     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIA*  OVRDBF FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)               *         180721
/*XBIB*  OVRDBF FILE(REIACXX) TOFILE(REIAC) SHARE(*NO)                *         180721
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account maintenance screen input')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMADSIN - Account Maintenance - Screen Input               *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for account maintenance.                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 222427             Date 05Dec16               *
      *                 LLN022A            Date 03Jun15               *
      *                 CRE101             Date 27Aug14               *
      *                 CGL165             Date 17Feb15               *
      *                 MD021858           Date 17Aug13               *
      *                 AR947093           Date 26Apr12               *
      *                 AR847249           Date 28Jan12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER049             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 AR582286           Date 26Jul10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24157           Date 04Jun09               *
      *                 BUG22742           Date 07Feb09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE030             Date 10Jul06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 222549             Date 06Jun06               *
      *                 240205             Date 06Jun06               *
      *                 238839             Date 29Mar06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 LLN022             Date 24Jan05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 213342             Date 27Jun03               *
      *                 215721             Date 10Jun03               *
      *                 215207             Date 19Mar03               *
      *                 CSD012             Date 15Oct02               *
      *                 CGL018             Date 23Sep02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210628             Date 09Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 194431             Date 22May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 190343             Date 07Dec01               *
      *                 193883             Date 20Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 01Feb00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      *                 180721             Date 05May00               *
      *                 189774             Date 13Feb01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 176842             Date 01Jun00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 23Aug99               *
      *                 CFT004             Date 05Nov99               *
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  222427 - AMAN - 'Extra Daily Statement Commission' default   *
      *           value is 0.00.  Data structure which includes       *
      *           DDSTFQ should be included in the parameter list on  *
      *           call to module GLAMAD4DT.                           *
      *           Partially Applied for MD042713.                     *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  CRE101 - Interim Interest Statement on a Frequency           *
      *           Added hooks: CRE101_008, CRE101_025, CRE101_026,    *
      *                        CRE101_027, CRE101_028, CRE101_058,    *
      *                        CRE101_059                             *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD021858 - Reinstate Account Details enquiry option          *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  AR582286 - The system was not able to generate IBAN for      *
      *             the customer. Applied fix 206824.                 *
      *  206824 - IBAN field not displayed and updated correctly      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
      *             when field is set to Y (Recompile)                *
      *  BUG22742 - Rectify the invalid defaulting when customer is   *
      *             flagged as Taxable                                *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  CRE030 - Default RE Accounts by Currency                     *
      *  222549 - API version of Accounts master enquiry should be    *
      *           used in the linked enquiry from the Customer Account*
      *           Balances Enquiry. Introduced linked enquiry         *
      *           processing in the API version of GL accounts        *
      *           maintenance.                                        *
      *  240205 - 194431 should not default the account name nor      *
      *           the account status indicators.                      *
      *  238839 - Pass parameter DDIBAN to GLAMADRTV.                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  213342 - Default statement fee amount should be displayed if *
      *           statement charges (TSTMC) is 'Y' in RE ICD by CCY.  *
      *  215721 - Default values for commissions and charges are not  *
      *           displayed in amend mode.                            *
      *  215207 - Function key F6 for amend does not work when chosen *
      *           from an enquiry of an account.                      *
      *  CSD012 - Standing Data Authorisation                         *
      *  CGL018 - Risk Weighted Assets.                               *
      *  208221 - Default Margin from Rate/Spread changes             *
      *  210628 - IBAN code and Customer name should not be changed   *
      *           when getting the default. Enhancement for 194431.   *
      *  194431 - Use Account details of reference account if         *
      *           Default Retail Account is set up.                   *
      *  190343 - Recompile over changed GLAMADUPD.                   *
      *  193883 - Recompile over changed GLAMADUPD.                   *
      *  CDE002 - CCRM Revenue Analysis - Addition of Margin Int. Flds*
      *  CRE007 - Base Rate Tax 2001.                                 *
      *  180721 - Default "Next Statement Date" when opening          *
      *           Account coming from interface                       *
      *  189774 - Window processing for Customer Details API program  *
      *  176842 - Fix for defaulting values to 4th screen             *
      *  CPB001 - Meridian DBA Middleware Replication Customisation.  *
      *           Recompiled due to database changes.                 *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers                  *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Retail III Table file
     FTABTBRE   IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(R_)
                                                                                180721
      ** Default Retail Account                                                 180721
     FREDEF     IF   E           K DISK    INFSR(*PSSR)                         180721
     F                                     PREFIX(X_)                           180721
     F                                     IGNORE(REDEFAF)                      180721
     F                                     IGNORE(REDEFZF)                      180721
                                                                                180721
      ** Retail Interest and Charge File                                        180721
     FREIACXX   IF   E           K DISK    INFSR(*PSSR)                         180721
                                                                                180721
      ** Accounts by Branch                                                     180721
     FACCNTLXX  IF   E           K DISK    INFSR(*PSSR)                         180721
                                                                                180721
      ** Account Numbers                                                        180721
     FACNUM     IF   E           K DISK    RENAME(ACCNTABF:ACNUMTBF)            180721
     F                                     INFSR(*PSSR)                         180721
                                                                                CRE007
      ** BRT Customer Details                                                   CRE007
     FSDCBRTL1  IF   E           K DISK    INFSR(*PSSR)                         CRE007
 
     F/COPY WNCPYSRC,GLAMADSF01
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
     DEMSDS          E DS                  EXTNAME(EMDTA) DTAARA(EMSDS)                       222549
     D CUSTNO                141    146                                                       222549
     D*CUSTN****             141    146  0                                             222549 CSD031
     D CUSTN                 141    146                                                       CSD031
     D CURRCY                147    149                                                       222549
     D ACCODE                150    159                                                       222549
     D ACCDN                 150    159  0                                                    222549
     D ACCSEQ                160    161                                                       222549
     D ACSQN                 160    161  0                                                    222549
     D BRANCH                162    164                                                       222549
     D AREF15                141    161                                                       222549
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Breakdown of Account Number
     D                 DS
     D*ACKEY**                 1     18                                                       CGL029
     D ACKEY                   1     24                                                       CGL029
     D WWBRCA                  1      3
     D WWCNUM                  4      9
     D WWCCY                  10     12
     D*WWACOD*                13     16                                                       CGL029
     D*WWACSQ*                17     18                                                       CGL029
     D WWACOD                 13     22                                                       CGL029
     D WWACSQ                 23     24                                                       CGL029
     D RETNUM                  1     10
      *                                                                                       194431
     D WWKEY1          DS            12                                                       194431
     D WWICSP                  1      2                                                       194431
     D WWICTP                  3      7                                                       194431
     D WWICCY                  8     10                                                       194431
 
     D RUNDAT          DS            13
      ** Rundate data area
     D  AGMBIN                13     13
 
      * Current Account in File Format
     D CrAcFilFmt    E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(C_)
      * Current Account in File Format (Extension File)
     D CABXFilFmt    E DS                  EXTNAME(ACCNTBXC)
     D                                     PREFIX(CA_)
      * Current Account in File Format (Extension File)
     D CARIFilFmt    E DS                  EXTNAME(REIACD)
     D                                     PREFIX(CB_)
     D CARIFilFmt1             1    144                                                       CGL029
     D CARIFilFmtEx          146    218                                                       CGL029
      * Current Account in File Format (Extension File)
     D CACOFilFmt    E DS                  EXTNAME(RECOMD)
     D                                     PREFIX(CC_)
     D CACOFilFmt1             1    286                                                       CGL029
     D CACOFilFmtEx          287    296                                                       CGL029
      * Current Account in File Format (Extension File)
     D CAPWFilFmt    E DS                  EXTNAME(REAPWDPD)
     D                                     PREFIX(CD_)
     D CAPWFilFmt1             1     33                                                       CGL029
     D CAPWFilFmtEx           34     43                                                       CGL029
 
      * Term/Notice Periods and Penalties                                                   MD021858
     D ExPPFilFmt    E DS                  EXTNAME(REPENAPD)                                MD021858
     D                                     PREFIX(E_)                                       MD021858
     D P1PPFilFmt    E DS                  EXTNAME(GLVAMPPPD)                               MD021858
     D                                     PREFIX(E_)                                       MD021858
     D NewAcPena     E DS                  EXTNAME(GLAMPPPD)                                MD021858
     D                                     PREFIX(E_)                                       MD021858
     C/COPY OFCPYSRCZ,CRE101_025                                                            CRE101
      * (Current) Account in Screen Format - Primary Details
     D CurAcPrim     E DS                  EXTNAME(GLAMADPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Debit Details
     D CurAcDebt     E DS                  EXTNAME(GLAMDIPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Credit Details
     D CurAcCrdt     E DS                  EXTNAME(GLAMCIPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Commission Details
     D CurAcComm     E DS                  EXTNAME(GLAMCOPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Other Details
     D CurAcOthr     E DS                  EXTNAME(GLAMODPD)
     D                                     PREFIX(@)
 
      * New Account in File Format
     D NwAcFilFmt    E DS                  EXTNAME(GLVAMADPD)
      * New Account in File Format (Extension File)
     D NABXFilFmt    E DS                  EXTNAME(GLVAMBXPD)
     D                                     PREFIX(A_)
      * New Account in File Format (Extension File)
     D NARIFilFmt    E DS                  EXTNAME(GLVAMRIPD)
     D                                     PREFIX(B_)
     D NARIFilFmt1             1    144                                                       CGL029
     D NARIFilFmtEx          212    284                                                       CGL029
      * New Account in File Format (Extension File)
     D NACOFilFmt    E DS                  EXTNAME(GLVAMCOPD)
     D                                     PREFIX(C_)
     D NACOFilFmt1             1    286                                                       CGL029
     D NACOFilFmtEx          354    363                                                       CGL029
      * New Account in File Format (Extension File)
     D NAPWFilFmt    E DS                  EXTNAME(GLVAMPWPD)
     D                                     PREFIX(D_)
     D NAPWFilFmt1             1     33                                                       CGL029
     D NAPWFilFmtEx          101    110                                                       CGL029
 
     D P1RIFilFmt    E DS                  EXTNAME(GLVAMRIPD)                                 CGL029
     D                                     PREFIX(P1)                                         CGL029
     D P1RIFilFmt1             1    144                                                       CGL029
     D P1RIFilFmtEx          212    284                                                       CGL029
      * Account in File Format (Extension File)                                               CGL029
     D P1COFilFmt    E DS                  EXTNAME(GLVAMCOPD)                                 CGL029
     D                                     PREFIX(P2)                                         CGL029
     D P1COFilFmt1             1    286                                                       CGL029
     D P1COFilFmtEx          354    363                                                       CGL029
      * Account in File Format (Extension File)                                               CGL029
     D P1PWFilFmt    E DS                  EXTNAME(GLVAMPWPD)                                 CGL029
     D                                     PREFIX(P3)                                         CGL029
     D P1PWFilFmt1             1     33                                                       CGL029
     D P1PWFilFmtEx          101    110                                                       CGL029
      * New Account in Screen Format - First Details
     D NewAcPrim     E DS                  EXTNAME(GLAMADPD)
      * New Account in Screen Format - Debit Details
     D NewAcDebt     E DS                  EXTNAME(GLAMDIPD)
      * New Account in Screen Format - Credit Details
     D NewAcCrdt     E DS                  EXTNAME(GLAMCIPD)
      * New Account in Screen Format - Commission Details
     D NewAcComm     E DS                  EXTNAME(GLAMCOPD)
      * New Account in Screen Format - Other Details
     D NewAcOthr     E DS                  EXTNAME(GLAMODPD)
 
      * Previous Account in Screen Format - First Details
     D PrvAcPrim     E DS                  EXTNAME(GLAMADPD)
     D                                     PREFIX(@P)
      * Previous Account in Screen Format - Debit Details
     D PrvAcDebt     E DS                  EXTNAME(GLAMDIPD)
     D                                     PREFIX(@P)
      * Previous Account in Screen Format - Credit Details
     D PrvAcCrdt     E DS                  EXTNAME(GLAMCIPD)
     D                                     PREFIX(@P)
      * Previous Account in Screen Format - Commission Details
     D PrvAcComm     E DS                  EXTNAME(GLAMCOPD)
     D                                     PREFIX(@P)
      * Previous Account in Screen Format - Other Details
     D PrvAcOthr     E DS                  EXTNAME(GLAMODPD)
     D                                     PREFIX(@P)
 
      * Error indicators
     D OKAcPrim      E DS                  EXTNAME(GLEAMADPD)
     D OKAcDebt      E DS                  EXTNAME(GLEAMDIPD)
     D OKAcCrdt      E DS                  EXTNAME(GLEAMCIPD)
     D OKAcComm      E DS                  EXTNAME(GLEAMCOPD)
     D OKAcOthr      E DS                  EXTNAME(GLEAMODPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D RETABLE       E DS                  EXTNAME(TABTBRE)
     D                                     PREFIX(R_)
      ** EXTERNAL DS FOR RETAIL TABLE FILE
                                                                                180721
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)                    180721
      ** EXTERNAL DS FOR MIDAS BASE RATE CODE DETAILS                           180721
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     DDSLDY          E DS                  EXTNAME(DSLDY)                       180721
      ** THIRD DS FOR ACCESS PROGRAMS, VERY LONG DATA STRUCTURE                 180721
                                                                                              206824
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  206824
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     206824
      ** EXTERNAL DS FOR BRANCH DETAILS                                                       206824
                                                                                              206824
                                                                                              CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSD012
      **  Data Structure for AOSVALR0 string                                                  CSD012
     DSVAL1            DS           200                                                       CSD012
     DSVAL11                   1      1                                                       CSD012
                                                                                              CSD012
     D CSD012          S              1A                                                      CSD012
     D SVALKK          C                   CONST('AuthReqAccntMaint')                         CSD012
                                                                                              CSD012
      ** Override SDAULGL0                                                                    CSD012
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          CSD012
                                                                                              CSD012
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
                                                                                              CSC022
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
 
     D/COPY QWINDSRC,GLAMADDTA                                                                189774
     D/COPY WNCPYSRC,GLAMADSD01
                                                                                              189774
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
     D Ix              S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Initialise Indicators
     D @INKC           S              1    INZ(*OFF)
     D @INKE           S              1    INZ(*OFF)
     D @INKF           S              1    INZ(*OFF)
     D @INKG           S              1    INZ(*OFF)
     D @INKH           S              1    INZ(*OFF)
     D @INKI           S              1    INZ(*OFF)
     D @INKJ           S              1    INZ(*OFF)
     D @INKL           S              1    INZ(*OFF)
     D @INKP           S              1    INZ(*OFF)
     D @IN49           S              1    INZ(*OFF)
 
     D WGLKEY          S             24                                                       CGL029
     D ACCD            S             24                                                       CGL029
     D #DACCN          S             24                                                       CGL029
     D DDACREF         S             24                                                       CGL029
     D @ACRED          S             24                                                       CGL029
     D @ACSEL          S             24                                                       CGL029
     D DDLINK          S             24                                                       CGL029
     D WDACOD          S             10                                                       CGL029
     D WWACOK          S             10S 0                                                    CGL029
      *                                                                                     BUG22742
      ** Introduced by CER048                                                               BUG22742
      *                                                                                     BUG22742
     D CER048          S              1                                                     BUG22742
                                                                                              CGL029
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,GLAMADS001
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      * Issue rollback to clear any possible updates in window functions
      *
     C     @INKE         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      SRRDNBRW
     C                   ENDIF
      *
      ** DO WHILE screen: Primary Screen
      *
     C     @SCRN         DOWEQ     '0'
     C                   EXSR      SRPSDP
     C                   ENDDO
      *
      ** DO WHILE screen: Key Screen
      *
     C     @SCRN         DOWEQ     'K'
     C                   EXSR      SRPSDK
     C                   ENDDO
      *
      ** DO WHILE screen: 1st Detail Screen
      *
     C     @SCRN         DOWEQ     '1'
     C                   EXSR      SRPSD1
     C                   ENDDO
      *
      ** DO WHILE screen: 2nd Detail Screen
      *
     C     @SCRN         DOWEQ     '2'
     C                   EXSR      SRPSD2
     C                   ENDDO
      *
      ** DO WHILE screen: 3nd Detail Screen
      *
     C     @SCRN         DOWEQ     '3'
     C                   EXSR      SRPSD3
     C                   ENDDO
      *
      ** DO WHILE screen: 4th Detail Screen
      *
     C     @SCRN         DOWEQ     '4'
     C                   EXSR      SRPSD4
     C                   ENDDO
      *
      ** DO WHILE screen: 5th Detail Screen
      *
     C     @SCRN         DOWEQ     '5'
     C                   EXSR      SRPSD5
     C                   ENDDO
      *                                                                                       189774
      ** DO WHILE screen: Window processing                                                   189774
      *                                                                                       189774
     C     @SCRN         DOWEQ     'W'                                                        189774
     C                   EXSR      SRPSDW                                                     189774
     C                   ENDDO                                                                189774
      *
      ** Do File updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      SRUPDATE
     C                   ENDIF
      *
      ** Terminate program
      ** Rollback to clear any possible updates in window function                            189774
      *
     C     @SCRN         IFEQ      'T'
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK                                                                189774
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                189774
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
     C/COPY WNCPYSRC,GLAMADSC03
      *****************************************************************
      /EJECT                                                                                  CGL029
      *****************************************************************                       CGL029
      *                                                               *                       CGL029
      *  SRClear -  Initialises Packed-type Variables to Zero         *                       CGL029
      *                                                               *                       CGL029
      *****************************************************************                       CGL029
     C     SRClear       BEGSR                                                                CGL029
                                                                                              CGL029
     C                   EVAL      B_RINRCA = *ZEROS                                          CGL029
     C                   EVAL      B_RIRCA  = *ZEROS                                          CGL029
     C                   EVAL      B_RIMCLB = *ZEROS                                          CGL029
     C                   EVAL      B_RINOALT = *ZEROS                                         CGL029
     C                   EVAL      B_RITCHO = *ZEROS                                          CGL029
                                                                                              CGL029
     C                   EVAL      C_COFXDC = *ZEROS                                          CGL029
     C                   EVAL      C_COACCEA = *ZEROS                                         CGL029
     C                   EVAL      C_COACCC = *ZEROS                                          CGL029
     C                   EVAL      C_COGVDPE = *ZEROS                                         CGL029
     C                   EVAL      C_COGVDPC = *ZEROS                                         CGL029
     C                   EVAL      C_COACCRA = *ZEROS                                         CGL029
     C                   EVAL      C_COCACCC = *ZEROS                                         CGL029
     C                   EVAL      C_COCDIE = *ZEROS                                          CGL029
     C                   EVAL      C_COCDICA = *ZEROS                                         CGL029
     C                   EVAL      C_COCDRR = *ZEROS                                          CGL029
     C                   EVAL      C_COCCDIC = *ZEROS                                         CGL029
     C                   EVAL      C_COIACE = *ZEROS                                          CGL029
     C                   EVAL      C_COIACCC = *ZEROS                                         CGL029
     C                   EVAL      C_COCIACC = *ZEROS                                         CGL029
     C                   EVAL      C_COCMBE = *ZEROS                                          CGL029
     C                   EVAL      C_COCMBC = *ZEROS                                          CGL029
     C                   EVAL      C_COACCB = *ZEROS                                          CGL029
     C                   EVAL      C_COCCMBC = *ZEROS                                         CGL029
     C                   EVAL      C_COCHDBE = *ZEROS                                         CGL029
     C                   EVAL      C_COCHDBC = *ZEROS                                         CGL029
     C                   EVAL      C_COHDRB = *ZEROS                                          CGL029
     C                   EVAL      C_COCHDBR = *ZEROS                                         CGL029
     C                   EVAL      C_COCCHDBC = *ZEROS                                        CGL029
     C                   EVAL      C_COCCINST = *ZEROS                                        CGL029
     C                   EVAL      C_COVATAM = *ZEROS                                         CGL029
     C                   EVAL      C_CONOIS = *ZEROS                                          CGL029
     C                   EVAL      C_CONOCC = *ZEROS                                          CGL029
     C                   EVAL      C_COPESP = *ZEROS                                          CGL029
     C                   EVAL      C_CONOIP = *ZEROS                                          CGL029
                                                                                              CGL029
     C                   ENDSR                                                                CGL029
      *****************************************************************                       CGL029
      /EJECT
      *****************************************************************
      * SRPSDP - PROCESS SCREEN: Primary Screen
      *****************************************************************
     C     SRPSDP        BEGSR
      *                                                                                       222549
      ** Check if linked enquiry and initialise account key with linked enquiry details       222549
      *                                                                                       222549
     C     *LOCK         IN        EMSDS                                                      222549
     C                   MOVE      RQDTD         MODID             2                          222549
     C                   OUT       EMSDS                                                      222549
      *                                                                                       222549
     C     MODID         IFEQ      'GL'                                                       222549
     C                   MOVEL     'E'           DDACTN                                       222549
     C                   MOVEL     '1'           WWACTN                                       222549
     C                   MOVEL     BRANCH        ACKEY                                        222549
     C                   MOVE      AREF15        ACKEY                                        222549
     C                   MOVEL     BRANCH        DDACCN                                       222549
     C                   MOVE      AREF15        DDACCN                                       222549
     C                   MOVE      BRANCH        DDBRCA                                       222549
     C                   MOVE      CUSTNO        DDCUSN                                       222549
     C                   MOVE      CURRCY        DDCCY                                        222549
     C                   MOVE      ACCODE        DDACOD                                       222549
     C                   MOVE      ACCSEQ        DDACSQ                                       222549
     C                   MOVE      *BLANKS       DDACNO                                       222549
     C                   ENDIF                                                                222549
 
      * Update 'previous' screen
 
     C                   MOVEL     NewAcPrim     PrvAcPrim
      *
     C     WRITEONLY     IFEQ      'N'
      *
      ** WRITE/READ DISPLAY SCREEN - Primary Details
      *
     C                   CALLB     'GLAMADPDP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Account (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewAcPrim
      *
      * Fields in error
     C                   PARM                    OKAcPrim
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED KEY FIELDS
      * ENABLED DETAIL FIELDS
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      *OFF          @INKC
     C                   PARM      *OFF          @INKG
     C                   PARM      *OFF          @INKH
     C                   PARM      *OFF          @INKL
     C                   PARM      *OFF          @IN49
      * Write screen with no read indicator
     C                   PARM                    WriteOnly
      *
     C                   ENDIF
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKAcPrim
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *                                                                                       222549
      ** Linked enquiry command keys processing                                               222549
      *                                                                                       222549
     C     MODID         IFEQ      'GL'                                                       222549
     C                   EXSR      #CMDSR                                                     222549
     C                   ENDIF                                                                222549
      *
     C                   SELECT
      * F3 - End Program
     C     @INKC         WHENEQ    '1'
     C                   MOVE      'T'           @SCRN
      *
      * F7 - Roll Backwards
      * F8 - Roll Forwards
     C     @INKG         WHENEQ    '1'
     C     @INKH         OREQ      '1'
     C                   MOVE      DDACCN        DDACREF
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'D'
     C     DDACTN        OREQ      *BLANK
     C                   MOVE      'E'           DDACTN
     C                   ENDIF
     C                   EXSR      SRROLL
      *
      * F12 - Cancel on Primary Screen
     C     @INKL         WHENEQ    '1'
     C                   EXSR      SRINIT
      *
      * Validate input to Primary screen
     C                   OTHER
     C                   EXSR      SRVALDP
     C     @SCRN         IFEQ      'S'
     C                   MOVE      '0'           @SCRN
     C                   EXSR      SRBLDBRW
     C                   ENDIF
     C                   ENDSL
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVALDP - Validate input to primary screen
      *****************************************************************
     C     SRVALDP       BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      * clear Account in File Format, blank the following screens
      *
     C                   Z-ADD     *ZERO         Idx
     C                   CLEAR                   NwAcFilFmt
     C                   CLEAR                   NABXFilFmt
     C                   CLEAR                   NARIFilFmt
     C                   CLEAR                   NACOFilFmt
     C                   CLEAR                   NAPWFilFmt
     C                   EXSR      SRClear                                                    CGL029
     C                   MOVEL     *BLANK        NewAcDebt
     C                   MOVEL     *BLANK        NewAcCrdt
     C                   MOVEL     *BLANK        NewAcComm
     C                   MOVEL     *BLANK        NewAcOthr
      *
      * Validate Primary Account details
      *
     C                   CALLB     'GLAMAD1VL'
      *
      ** INPUTS
      *
      * Response mode
     C                   PARM                    RespMode
 
      * Screen Format
     C                   PARM      'F0'          WFMT              2
 
      ** ICD
     C                   PARM                    RETABLE
 
      ** Account Primary details
     C                   PARM                    NewAcPrim
                                                                                180721
      * Front Office Transaction ID                                             180721
     C                   PARM                    FOTRID                         180721
 
      ** Account Primary Details OK inds
     C                   PARM                    OKAcPrim
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Full GL Account Number
     C**********         PARM                    WGLKEY           18                          CGL029
     C                   PARM                    WGLKEY                                       CGL029
 
      * IBAN Sequence                                                           CFT004
     C                   PARM                    DDIBSQ            3            CFT004
 
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
     C                   PARM                    NABXFilFmt
                                                                                              CSD012
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ                                       CSD012
                                                                                              CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD                                       CSD012
      *
     C     IDX           IFEQ      0
      *
     C                   MOVE      DDACTN        WWACTN            1
     C                   SELECT
     C     DDACTN        WHENEQ    'I'
     C     DDACTN        OREQ      'D'
     C                   MOVEL     'K'           @SCRN
     C                   EXSR      SRRFRSH
     C     DDACTN        WHENEQ    'A'
     C     DDACTN        OREQ      'E'
     C                   MOVEL     '1'           @SCRN
     C     DDACTN        WHENEQ    '1'
     C     DDACTN        OREQ      '2'
     C     DDACTN        OREQ      '3'
     C     DDACTN        OREQ      '4'
     C     DDACTN        OREQ      '5'
     C                   MOVE      DDACTN        @SCRN
     C                   MOVE      'E'           DDACTN
     C     DDACTN        WHENEQ    *BLANK
     C                   MOVEL     'S'           @SCRN
     C                   ENDSL
      *
     C     DDACTN        IFNE      'I'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     *BLANKS
      *
      ** Retrieve Account details
     C                   MOVEL     WGLKEY        ACKEY
     C                   MOVE      WWBRCA        DDBRCA
     C                   MOVE      WWCNUM        DDCUSN
     C                   MOVE      WWCCY         DDCCY
     C                   MOVE      WWACOD        DDACOD
     C                   MOVE      WWACSQ        DDACSQ
     C                   MOVE      *BLANKS       DDACNO
     C                   EXSR      SRRTVACC
      *
      * If primary fields are NOT OK
      * Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDBRCAOK      OREQ      'N'
     C     DDCUSNOK      OREQ      'N'
     C     DDCCYOK       OREQ      'N'
     C     DDACODOK      OREQ      'N'
     C     DDACSQOK      OREQ      'N'
     C     DDACNOOK      OREQ      'N'
     C                   MOVE      'N'           DDACCNOK
     C                   MOVEL     '0'           @SCRN
     C                   GOTO      EndVALDP
     C                   ENDIF
      *
      ** Convert the Account to screen format
     C                   EXSR      SRCVTACC
     C                   MOVEL     CrAcFilFmt    NwAcFilFmt
     C                   MOVEL     CABXFilFmt    NABXFilFmt
     C**********         MOVEL     CARIFilFmt    NARIFilFmt                                   CGL029
     C                   MOVEL     CARIFilFmt1   NARIFilFmt1                                  CGL029
     C                   MOVEL     CARIFilFmtEx  NARIFilFmtEx                                 CGL029
     C**********         MOVEL     CACOFilFmt    NACOFilFmt                                   CGL029
     C                   MOVEL     CACOFilFmt1   NACOFilFmt1                                  CGL029
     C                   MOVEL     CACOFilFmtEx  NACOFilFmtEx                                 CGL029
     C**********         MOVEL     CAPWFilFmt    NAPWFilFmt                                   CGL029
     C                   MOVEL     CAPWFilFmt1   NAPWFilFmt1                                  CGL029
     C                   MOVEL     CAPWFilFmtEx  NAPWFilFmtEx                                 CGL029
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      'N'           WRITEONLY
     C                   EXSR      SFDS@P
      *
     C     EndValDP      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPSDK - PROCESS SCREEN: Key Screen
      *****************************************************************
     C     SRPSDK        BEGSR
 
      * Update 'previous' screen
 
     C                   MOVEL     NewAcPrim     PrvAcPrim
      *
     C     WRITEONLY     IFEQ      'N'
      *
      ** WRITE/READ DISPLAY SCREEN - Primary Details
      *
     C                   CALLB     'GLAMADKDP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Account (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewAcPrim
      *
      * Fields in error
     C                   PARM                    OKAcPrim
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED FUNCTION KEYS
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
     C                   PARM                    @EINKJ            1
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      *OFF          @INKC
     C                   PARM      *OFF          @INKE
     C                   PARM      *OFF          @INKJ
     C                   PARM      *OFF          @INKL
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
     C/COPY WNCPYSRC,GLAMADSC15
      *
     C                   ENDIF
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKAcPrim
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *                                                                                       222549
      ** Linked enquiry command keys processing                                               222549
      *                                                                                       222549
     C     MODID         IFEQ      'GL'                                                       222549
     C                   EXSR      #CMDSR                                                     222549
     C                   ENDIF                                                                222549
      *
     C                   SELECT
      *
      ** F3 - End Program
     C     @INKC         WHENEQ    '1'
     C                   MOVE      'T'           @SCRN
      *
      ** F5 - Refresh
     C     @INKE         WHENEQ    *ON
     C                   EXSR      SRRFRSH
      *
      ** F10 - Confirm Delete
     C     @INKJ         WHENEQ    *ON
     C                   MOVEL     'U'           @SCRN
      *
      ** F12 - Cancel
     C     @INKL         WHENEQ    *ON
     C                   EXSR      SRINIT
      *
      ** Validate input to Key screen
     C                   OTHER
     C                   EXSR      SRVALDK
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVALDK  - Validate input to key screen
      *****************************************************************
     C     SRVALDK       BEGSR
      *
      * Prior to validation, initialize error indicators as 'OK'
      * clear Account in File Format, blank the following screens
      *
     C                   Z-ADD     *ZERO         Idx
     C                   CLEAR                   NwAcFilFmt
     C                   CLEAR                   NABXFilFmt
     C                   CLEAR                   NARIFilFmt
     C                   CLEAR                   NACOFilFmt
     C                   CLEAR                   NAPWFilFmt
     C                   EXSR      SRClear                                                    CGL029
     C                   MOVEL     *BLANK        NewAcDebt
     C                   MOVEL     *BLANK        NewAcCrdt
     C                   MOVEL     *BLANK        NewAcComm
     C                   MOVEL     *BLANK        NewAcOthr
      *
      * Validate Primary Account details
      *
     C                   CALLB     'GLAMAD1VL'
      *
      ** INPUTS
      *
      * Response mode
     C                   PARM                    RespMode
 
      * Screen Format
     C                   PARM      'FK'          WFMT
 
      ** ICD
     C                   PARM                    RETABLE
 
      ** Account Primary details
     C                   PARM                    NewAcPrim
                                                                                180721
      * Front Office Transaction ID                                             180721
     C                   PARM                    FOTRID                         180721
 
      ** Account Primary Details OK inds
     C                   PARM                    OKAcPrim
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Full GL Account Number
     C                   PARM                    WGLKEY
      * IBAN Sequence                                                           CFT004
     C                   PARM                    DDIBSQ                         CFT004
 
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
     C                   PARM                    NABXFilFmt
                                                                                              CSD012
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ                                       CSD012
                                                                                              CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD                                       CSD012
      *
     C     IDX           IFEQ      0
      *
     C                   SELECT
      *
     C     DDACTN        WHENEQ    'D'
     C     @INKJ         ANDEQ     *OFF
     C                   MOVEL     'Y'           @EINKJ
     C                   EXSR      SRRTVACC
     C                   MOVEL     CrAcFilFmt    NwAcFilFmt
     C                   MOVEL     CABXFilFmt    NABXFilFmt
     C**********         MOVEL     CARIFilFmt    NARIFilFmt                                   CGL029
     C                   MOVEL     CARIFilFmt1   NARIFilFmt1                                  CGL029
     C                   MOVEL     CARIFilFmtEx  NARIFilFmtEx                                 CGL029
     C**********         MOVEL     CACOFilFmt    NACOFilFmt                                   CGL029
     C                   MOVEL     CACOFilFmt1   NACOFilFmt1                                  CGL029
     C                   MOVEL     CACOFilFmtEx  NACOFilFmtEx                                 CGL029
     C**********         MOVEL     CAPWFilFmt    NAPWFilFmt                                   CGL029
     C                   MOVEL     CAPWFilFmt1   NAPWFilFmt1                                  CGL029
     C                   MOVEL     CAPWFilFmtEx  NAPWFilFmtEx                                 CGL029
      *
     C     DDACTN        WHENEQ    'I'
     C                   EXSR      SRDEFT                                                     213342
     C                   MOVEL     NwAcFilFmt    CrAcFilFmt
     C                   MOVEL     NABXFilFmt    CABXFilFmt
     C**********         MOVEL     NARIFilFmt    CARIFilFmt                                   CGL029
     C                   MOVEL     NARIFilFmt1   CARIFilFmt1                                  CGL029
     C                   MOVEL     NARIFilFmtEx  CARIFilFmtEx                                 CGL029
     C**********         MOVEL     NACOFilFmt    CACOFilFmt                                   CGL029
     C                   MOVEL     NACOFilFmt1   CACOFilFmt1                                  CGL029
     C                   MOVEL     NACOFilFmtEx  CACOFilFmtEx                                 CGL029
     C**********         MOVEL     NAPWFilFmt    CAPWFilFmt                                   CGL029
     C                   MOVEL     NAPWFilFmt1   CAPWFilFmt1                                  CGL029
     C                   MOVEL     NAPWFilFmtEx  CAPWFilFmtEx                                 CGL029
     C                   EXSR      SRCVTACC
     C                   MOVEL     '1'           @SCRN
     C                   EXSR      SRDEFT
      *
     C                   ENDSL
      *
     C/COPY WNCPYSRC,GLAMADSC10
     C                   ENDIF
      *
     C                   MOVE      'N'           WRITEONLY
     C                   EXSR      SFDS@P
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@P - SET FIELD STATUS ON PRIMARY SCREEN
      *****************************************************************
     C     SFDS@P        BEGSR
      *
      * Enable/disable fields on primary screen
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPSD1 - PROCESS SCREEN: First Detail Screen
      *****************************************************************
     C     SRPSD1        BEGSR
 
      * Update 'previous' screen
 
     C                   MOVEL     NewAcPrim     PrvAcPrim
     C/COPY WNCPYSRC,GLAMADSC09
      *
      ** WRITE/READ DISPLAY SCREEN - First Details
      *
     C                   CALLB     'GLAMAD1DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Account (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewAcPrim
      *
      * Fields in error
     C                   PARM                    OKAcPrim
      *
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
     C                   PARM                    NARIFilFmt
      *
      ** Output Only fields
     C                   PARM                    DDDACC
     C                   PARM                    DDLINK
     C                   PARM                    DDFAMT
      *
      ** ICD
     C                   PARM                    R_CNDS
     C                   PARM                    R_FACH
     C                   PARM                    R_TSTMC
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
     C                   PARM                    @EIN25
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      *OFF          @INKC
     C                   PARM      *OFF          @INKE
     C                   PARM      *OFF          @INKF
     C                   PARM      *OFF          @INKG
     C                   PARM      *OFF          @INKH
     C                   PARM      *OFF          @INKI
     C                   PARM      *OFF          @INKL
     C                   PARM      *OFF          @INKP
     C                   PARM      *OFF          @IN49
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
     C/COPY WNCPYSRC,GLAMADSC07
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKAcPrim
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   MOVEL     *BLANK        WFLAG             1                          208221
      *                                                                                       222549
      ** Linked enquiry command keys processing                                               222549
      *                                                                                       222549
     C     MODID         IFEQ      'GL'                                                       222549
     C                   EXSR      #CMDSR                                                     222549
     C                   ENDIF                                                                222549
      *
     C                   SELECT
      * F3 - End Program
     C     @INKC         WHENEQ    *ON
     C                   MOVE      'T'           @SCRN
      *
      ** F5 - Refresh
     C     @INKE         WHENEQ    *ON
     C                   EXSR      SRRFRSH
      *
      ** F6 - Amend on Enquiry
     C     @INKF         WHENEQ    *ON
      *
      * If multibranching do validation on branch input
     C     BJSBRC        IFEQ      *BLANKS
     C                   MOVEL     'A'           @ZACTN
     C                   MOVEL     DDBRCA        @BRCA
     C                   EXSR      SRAUTH
     C     @ERR          IFNE      0
     C                   Add       1             Idx
     C                   Z-ADD     IDX           IX
     C                   Movel     *Blank        FldNameArr(Ix)
     C                   Movel     'RE7103B'     MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
      ** User must be authorised and action mode is enquiry
     C     *IN41         IFEQ      '1'
     C     DDACTN        ANDEQ     'E'
     C     Idx           ANDEQ     *ZERO
     C                   MOVE      'A'           DDACTN
     C                   EXSR      SFDS@P                                                     215207
     C                   ELSE
     C                   Add       1             Idx
     C                   Z-ADD     IDX           IX
     C                   Movel     *Blank        FldNameArr(Ix)
     C                   Movel     'RE71003'     MsgIDArr(Ix)
     C                   ENDIF
      *
      ** F7 - Roll Backwards
      ** F8 - Roll Forwards
     C     @INKG         WHENEQ    '1'
     C     @INKH         OREQ      '1'
     C                   MOVE      DDBRCA        WWBRCA
     C                   MOVE      DDCUSN        WWCNUM
     C                   MOVE      DDCCY         WWCCY
     C                   MOVE      DDACOD        WWACOD
     C                   MOVE      DDACSQ        WWACSQ
     C                   MOVE      ACKEY         DDACREF
     C     DDACTN        IFEQ      'I'
     C                   MOVE      'E'           DDACTN
     C                   ENDIF
     C                   EXSR      SRROLL
      *
      ** F9 - Init Screen
     C     @INKI         WHENEQ    *ON
     C                   EXSR      SRINIT
      *
      ** F12 - Cancel
     C     @INKL         WHENEQ    *ON
     C                   MOVE      '0'           @SCRN
     C                   MOVE      WWACTN        DDACTN
      *
      ** F15 - Select
     C     @INKP         WHENEQ    *ON
     C                   MOVE      DDBRCA        WWBRCA
     C                   MOVE      DDCUSN        WWCNUM
     C                   MOVE      DDCCY         WWCCY
     C                   MOVE      DDACOD        WWACOD
     C                   MOVE      DDACSQ        WWACSQ
     C                   MOVE      ACKEY         DDRFRA
     C                   EXSR      SRBLDBRW
      *
      ** Validate input to key screen when enter is pressed
     C     @IN49         WHENEQ    *OFF
     C                   EXSR      SRVALD1
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVALD1  - Validate input to first detail screen
      *****************************************************************
     C     SRVALD1       BEGSR
      *
      ** Call validation module only if not in enquiry mode
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ** Call AMD module
     C     DDACTN        IFEQ      'A'
 
     C                   CALLB     'GLAMADAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Incoming Account in Screen Format :
 Form * - Master Details
      * - Debit Details
      * - Credit Details
      * - Commision Details
      * - Other Details
     C                   PARM                    NewAcPrim
     C                   PARM                    NewAcDebt
     C                   PARM                    NewAcCrdt
     C                   PARM                    NewAcComm
     C                   PARM                    NewAcOthr
      *
      * (Current) Account in Screen Format :
 Form * - Master Details
      * - Debit Details
      * - Credit Details
      * - Commision Details
      * - Other Details
     C                   PARM                    CurAcPrim
     C                   PARM                    CurAcDebt
     C                   PARM                    CurAcCrdt
     C                   PARM                    CurAcComm
     C                   PARM                    CurAcOthr
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKAcPrim
     C                   PARM                    OKAcDebt
     C                   PARM                    OKAcCrdt
     C                   PARM                    OKAcComm
     C                   PARM                    OKAcOthr
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      0             Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
 
     C                   ENDIF
      *
     C                   CALLB     'GLAMAD1VL'
      *
      ** INPUTS
      *
      * Response mode
     C                   PARM                    RespMode
 
      * Screen Format
     C                   PARM      'F1'          WFMT
 
      ** ICD
     C                   PARM                    RETABLE
 
      ** Account Primary details
     C                   PARM                    NewAcPrim
                                                                                180721
      * Front Office Transaction ID                                             180721
     C                   PARM                    FOTRID                         180721
 
      ** Account Primary Details OK inds
     C                   PARM                    OKAcPrim
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Full GL Account Number
     C                   PARM                    WGLKEY
      * IBAN Sequence                                                           CFT004
     C                   PARM                    DDIBSQ                         CFT004
 
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
     C                   PARM                    NABXFilFmt
                                                                                              CSD012
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ                                       CSD012
                                                                                              CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD                                       CSD012
      *
     C                   ENDIF
      *
     C/COPY WNCPYSRC,GLAMADSC12
     C     IDX           IFEQ      0
     C     WIDX          ANDEQ     0
     C     DDACTN        OREQ      'E'
      *
      ** If Account is Retail, send following format
     C     AMATYP        IFEQ      'R'
      * General action requested, send next format
     C     WWACTN        IFEQ      'A'
     C     WWACTN        OREQ      'E'
     C     DDACTN        OREQ      'I'
     C                   MOVEL     '2'           @SCRN
     C                   ENDIF
      * Detail action requested, send correct format
     C     WWACTN        IFEQ      '1'
     C     WWACTN        OREQ      '2'
     C     WWACTN        OREQ      '3'
     C     WWACTN        OREQ      '4'
     C     WWACTN        OREQ      '5'
      * else if amend mode process screen and if no error process update
      * if error send fourth screen
     C     DDACTN        IFEQ      'A'
     C     DDSTFQ        IFEQ      'E'
     C/COPY WNCPYSRC,GLH00797
     C     DDNOCC        IFGT      DDENOC
     C                   MOVEL     '4'           @SCRN
     C                   ELSE
      *                                                                                       189774
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   MOVE      'W'           @SCRN                                        189774
     C                   ELSE                                                                 189774
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ENDIF
     C                   ELSE
     C     DDNOCC        IFNE      *BLANK
     C     DDCEXF        ORNE      *BLANK
     C                   MOVEL     '4'           @SCRN
     C                   ELSE
      *                                                                                       189774
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   MOVE      'W'           @SCRN                                        189774
     C                   ELSE                                                                 189774
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      ** Enquiry
     C     DDACTN        IFEQ      'E'
      *                                                                                       189774
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   MOVE      'W'           @SCRN                                        189774
     C                   ELSE                                                                 189774
      *                                                                                       189774
     C     BGN1ST        IFEQ      'Y'
     C                   CALL      'CGC0025'
     C                   PARM      *BLANKS       RTCD              7
     C                   PARM      'E'           ACTN              1
     C**********         PARM      ACKEY         ACCD             18                          CGL029
     C                   PARM      ACKEY         ACCD                                         CGL029
     C                   ENDIF
      *
      ** If Midas-Fontis Interface is switched on, call program to
      ** display Fontis account details.
      *
     C     CGL004        IFEQ      'Y'
     C                   CALL      'GLC2800'
     C                   PARM      *BLANK        RTCD
     C                   PARM      ACKEY         ACCD
     C                   PARM      'E'           ACTN
     C                   ENDIF
      ** If Midas-Risk Weighted Assets feature is switched on,                                CGL018
      ** call program to allow optional entry of RWA codes                                    CGL018
      *                                                                                       CGL018
     C     CGL018        IFEQ      'Y'                                                        CGL018
     C                   CALL      'GLC001240'                                                CGL018
     C                   PARM      *BLANK        RTCD                                         CGL018
     C                   PARM      ACKEY         ACCD                                         CGL018
     C                   PARM      'E'           ACTN                                         CGL018
     C                   ENDIF                                                                CGL018
      *
      ** IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ** ELSE, GO TO INITIAL SCREEN
     C                   EXSR      SRINIT
     C                   ENDIF
      *                                                                                       189774
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      ** Account is not retail - InserT mode, process write
     C     DDACTN        IFEQ      'I'
      *                                                                                       189774
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   MOVE      'W'           @SCRN                                        189774
     C                   ELSE                                                                 189774
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ENDIF
      ** Account is not retail - Amend mode, process update
     C     DDACTN        IFEQ      'A'
      *                                                                                       189774
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   MOVE      'W'           @SCRN                                        189774
     C                   ELSE                                                                 189774
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ENDIF
      ** Account is not retail - Enquiry mode, return to previous screen
     C     DDACTN        IFEQ      'E'
      *                                                                                       189774
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   MOVE      'W'           @SCRN                                        189774
     C                   ELSE                                                                 189774
     C     BGN1ST        IFEQ      'Y'
     C                   CALL      'CGC0025'
     C                   PARM      *BLANKS       RTCD
     C                   PARM      'E'           ACTN
     C                   PARM      ACKEY         ACCD
     C                   ENDIF
      *
      ** IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ** ELSE, GO TO INITIAL SCREEN
     C                   EXSR      SRINIT
     C                   ENDIF
      *
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C/COPY WNCPYSRC,GLAMADSC13
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPSD2 - PROCESS SCREEN: Second Detail Screen
      *****************************************************************
     C     SRPSD2        BEGSR
 
      * Update 'previous' screen
 
     C                   MOVEL     NewAcDebt     PrvAcDebt
      *
      ** WRITE/READ DISPLAY SCREEN - Second Details
      *
     C                   CALLB     'GLAMAD2DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Account (IN SCREEN FORMAT - First & Second)
     C                   PARM                    NewAcPrim
     C                   PARM                    NewAcDebt
      *
      * Fields in error
     C                   PARM                    OKAcDebt
      *
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
      *
      * Output Only fields
     C                   PARM                    DODRCD
     C                   PARM                    DOPOLC
     C                   PARM                    DOPOLE
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
     C                   PARM                    @EIN25
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      *OFF          @INKC
     C                   PARM      *OFF          @INKE
     C                   PARM      *OFF          @INKF
     C                   PARM      *OFF          @INKI
     C                   PARM      *OFF          @INKL
     C                   PARM      *OFF          @IN49
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKAcDebt
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *                                                                                       222549
      ** Linked enquiry command keys processing                                               222549
      *                                                                                       222549
     C     MODID         IFEQ      'GL'                                                       222549
     C                   EXSR      #CMDSR                                                     222549
     C                   ENDIF                                                                222549
      *
     C                   SELECT
      *
      ** F3 - End Program
     C     @INKC         WHENEQ    *ON
     C                   MOVE      'T'           @SCRN
      *
      ** F5 - Refresh
     C     @INKE         WHENEQ    *ON
     C                   EXSR      SRRFRSH
      *
      ** F6 - Amend on Enquiry
     C     @INKF         WHENEQ    *ON
      *
      * If multibranching do validation on branch input
     C     BJSBRC        IFEQ      *BLANKS
     C                   MOVEL     'A'           @ZACTN
     C                   MOVEL     DDBRCA        @BRCA
     C                   EXSR      SRAUTH
     C     @ERR          IFNE      0
     C                   Add       1             Idx
     C                   Z-ADD     IDX           IX
     C                   Movel     *Blank        FldNameArr(Ix)
     C                   Movel     'RE7103B'     MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
      ** User must be authorised and action mode is enquiry
     C     *IN41         IFEQ      '1'
     C     DDACTN        ANDEQ     'E'
     C     Idx           ANDEQ     *ZERO
     C                   MOVE      'A'           DDACTN
     C                   EXSR      SFDS@P                                                     215207
     C                   ELSE
     C                   Add       1             Idx
     C                   Z-ADD     IDX           IX
     C                   Movel     *Blank        FldNameArr(Ix)
     C                   Movel     'RE71003'     MsgIDArr(Ix)
     C                   ENDIF
      *
      ** F9 - Init Screen
     C     @INKI         WHENEQ    *ON
     C                   EXSR      SRINIT
      *
      ** F12 - Cancel
     C     @INKL         WHENEQ    *ON
     C     WWACTN        IFEQ      'A'
     C     WWACTN        OREQ      'E'
     C     DDACTN        OREQ      'I'
      ** Reset updated file fields for validation in detail 1
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'I'
     C                   MOVE      C_A5TIAC      AMA5TIAC
     C                   MOVE      C_PRFC        AMPRFC
     C                   MOVE      C_PTFR        AMPTFR
     C                   ENDIF
     C                   MOVE      '1'           @SCRN
     C                   ELSE
     C                   MOVE      '0'           @SCRN
     C                   MOVE      WWACTN        DDACTN
     C                   ENDIF
      *
      ** Validate input to key screen when enter or rollup is pressed
     C     @IN49         WHENEQ    *OFF
     C                   EXSR      SRVALD2
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVALD2  - Validate input to second detail screen
      *****************************************************************
     C     SRVALD2       BEGSR
      *
      ** Call validation module only if not in enquiry mode
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ** Call AMD module
     C     DDACTN        IFEQ      'A'
 
     C                   CALLB     'GLAMADAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Incoming Account in Screen Format :
 Form * - Master Details
      * - Debit Details
      * - Credit Details
      * - Commision Details
      * - Other Details
     C                   PARM                    NewAcPrim
     C                   PARM                    NewAcDebt
     C                   PARM                    NewAcCrdt
     C                   PARM                    NewAcComm
     C                   PARM                    NewAcOthr
      *
      * (Current) Account in Screen Format :
 Form * - Master Details
      * - Debit Details
      * - Credit Details
      * - Commision Details
      * - Other Details
     C                   PARM                    CurAcPrim
     C                   PARM                    CurAcDebt
     C                   PARM                    CurAcCrdt
     C                   PARM                    CurAcComm
     C                   PARM                    CurAcOthr
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKAcPrim
     C                   PARM                    OKAcDebt
     C                   PARM                    OKAcCrdt
     C                   PARM                    OKAcComm
     C                   PARM                    OKAcOthr
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      0             Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
 
     C                   ENDIF
      *
     C                   CALLB     'GLAMAD2VL'
      *
      ** INPUTS
      *
      ** Account Primary & Debit details
     C                   PARM                    NewAcPrim
     C                   PARM                    NewAcDebt
     C                   PARM                    NewAcComm                                    208221
                                                                                180721
      * Front Office Transaction ID                                             180721
     C                   PARM                    FOTRID                         180721
 
      ** Debit Details OK inds
     C                   PARM                    OKAcDebt
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller                       CER055
     C                   PARM                    WFldNamArr                                   CER055
     C                   PARM                    WMsgIDArr                                    CER055
     C                   PARM                    WMsgDtaArr                                   CER055
      * Array index (3P0) from/to caller                                                      CER055
     C                   PARM                    WIdx                                         CER055
 
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
     C                   PARM                    NABXFilFmt
     C                   PARM                    NARIFilFmt
      * Revenue Analysis                                                                      208221
     C                   PARM                    CDE002                                       208221
     C                   PARM                    CRE015            1                        AR947093
     C                   PARM                    X5ATTY            1                        AR947093
      *
     C                   ENDIF
      *
     C     IDX           IFEQ      0
     C     DDACTN        OREQ      'E'
     C/COPY WNCPYSRC,GLAMADSC17
      *
     C     DDACTN        IFEQ      'I'
     C     WWACTN        OREQ      'A'
     C     WWACTN        OREQ      'E'
     C                   MOVEL     '3'           @SCRN
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'A'
     C     WWACTN        ANDEQ     '2'
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'E'
     C     WWACTN        ANDNE     'E'
      *
     C     BGN1ST        IFEQ      'Y'
     C                   CALL      'CGC0025'
     C                   PARM      *BLANKS       RTCD
     C                   PARM      'E'           ACTN
     C                   PARM      ACKEY         ACCD
     C                   ENDIF
      *
      ** If Midas-Fontis Interface is switched on, call program to
      ** display Fontis account details.
      *
     C     AMATYP        IFEQ      'R'
     C     CGL004        ANDEQ     'Y'
     C                   CALL      'GLC2800'
     C                   PARM      *BLANK        RTCD
     C                   PARM      ACKEY         ACCD
     C                   PARM      'E'           ACTN
     C                   ENDIF
      *
      ** If Midas-Risk Weighted Assets feature is switched on,                                CGL018
      ** call program to allow optional entry of RWA codes                                    CGL018
      *                                                                                       CGL018
     C     CGL018        IFEQ      'Y'                                                        CGL018
     C                   CALL      'GLC001240'                                                CGL018
     C                   PARM      *BLANK        RTCD                                         CGL018
     C                   PARM      ACKEY         ACCD                                         CGL018
     C                   PARM      'E'           ACTN                                         CGL018
     C                   ENDIF                                                                CGL018
      *                                                                                       CGL018
      ** IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ** ELSE, GO TO INITIAL SCREEN
     C                   EXSR      SRINIT
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,GLAMADSC18
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPSD3 - PROCESS SCREEN: Third Detail Screen
      *****************************************************************
     C     SRPSD3        BEGSR
 
      * Update 'previous' screen
 
     C                   MOVEL     NewAcCrdt     PrvAcCrdt
      *
      ** WRITE/READ DISPLAY SCREEN - Third Details
      *
     C                   CALLB     'GLAMAD3DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Account (IN SCREEN FORMAT - First & Third)
     C                   PARM                    NewAcPrim
     C                   PARM                    NewAcCrdt
      *
      * Fields in error
     C                   PARM                    OKAcCrdt
      *
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
      *
      * Output Only field
     C                   PARM                    DOCRCD
      *
      ** ICD
     C                   PARM                    R_TCAL
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
     C                   PARM                    @EIN25
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      *OFF          @INKC
     C                   PARM      *OFF          @INKE
     C                   PARM      *OFF          @INKF
     C                   PARM      *OFF          @INKI
     C                   PARM      *OFF          @INKL
     C                   PARM      *OFF          @IN49
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKAcCrdt
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *                                                                                       222549
      ** Linked enquiry command keys processing                                               222549
      *                                                                                       222549
     C     MODID         IFEQ      'GL'                                                       222549
     C                   EXSR      #CMDSR                                                     222549
     C                   ENDIF                                                                222549
      *
     C                   SELECT
      *
      ** F3 - End Program
     C     @INKC         WHENEQ    *ON
     C                   MOVE      'T'           @SCRN
      *
      ** F5 - Refresh
     C     @INKE         WHENEQ    *ON
     C                   EXSR      SRRFRSH
      *
      ** F6 - Amend on Enquiry
     C     @INKF         WHENEQ    *ON
      *
      * If multibranching do validation on branch input
     C     BJSBRC        IFEQ      *BLANKS
     C                   MOVEL     'A'           @ZACTN
     C                   MOVEL     DDBRCA        @BRCA
     C                   EXSR      SRAUTH
     C     @ERR          IFNE      0
     C                   Add       1             Idx
     C                   Z-ADD     IDX           IX
     C                   Movel     *Blank        FldNameArr(Ix)
     C                   Movel     'RE7103B'     MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
      ** User must be authorised and action mode is enquiry
     C     *IN41         IFEQ      '1'
     C     DDACTN        ANDEQ     'E'
     C     Idx           ANDEQ     *ZERO
     C                   MOVE      'A'           DDACTN
     C                   EXSR      SFDS@P                                                     215207
     C                   ELSE
     C                   Add       1             Idx
     C                   Z-ADD     IDX           IX
     C                   Movel     *Blank        FldNameArr(Ix)
     C                   Movel     'RE71003'     MsgIDArr(Ix)
     C                   ENDIF
      *
      ** F9 - Init Screen
     C     @INKI         WHENEQ    *ON
     C                   EXSR      SRINIT
      *
      ** F12 - Cancel
     C     @INKL         WHENEQ    *ON
     C     WWACTN        IFEQ      'A'
     C     WWACTN        OREQ      'E'
     C     DDACTN        OREQ      'I'
      ** Reset updated file field for validation in detail 2
     C     DDACTN        IFEQ      'I'
     C                   Z-ADD     *ZERO         AMDRIB
     C                   Z-ADD     *ZERO         AMDRIS
     C                   Z-ADD     *ZERO         B_RIDICT
     C                   Z-ADD     *ZERO         B_RIDCST
     C                   Z-ADD     *ZERO         AMDRCD
     C                   Z-ADD     *ZERO         AMODED
     C                   Z-ADD     *ZERO         AMODLN
     C                   Z-ADD     *ZERO         A_BXOLVD
     C                   Z-ADD     *ZERO         A_BXORTC
     C                   Z-ADD     *ZERO         A_BXAODR
     C                   ENDIF
     C     DDACTN        IFEQ      'A'
     C                   Z-ADD     C_DRIB        AMDRIB
     C                   Z-ADD     C_DRIS        AMDRIS
     C                   Z-ADD     CB_DICT       B_RIDICT
     C                   Z-ADD     CB_DCST       B_RIDCST
     C                   Z-ADD     C_DRCD        AMDRCD
     C                   Z-ADD     C_ODED        AMODED
     C                   Z-ADD     C_ODLN        AMODLN
     C                   Z-ADD     CA_ATOLVD     A_BXOLVD
     C                   Z-ADD     CA_ATORTC     A_BXORTC
     C                   Z-ADD     CA_ATAODR     A_BXAODR
     C                   ENDIF
     C                   MOVE      '2'           @SCRN
     C                   ELSE
     C                   MOVE      '0'           @SCRN
     C                   MOVE      WWACTN        DDACTN
     C                   ENDIF
      *
      ** Validate input to key screen when enter is pressed
     C     @IN49         WHENEQ    *OFF
     C                   EXSR      SRVALD3
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVALD3  - Validate input to third detail screen
      *****************************************************************
     C     SRVALD3       BEGSR
      *
      ** Call validation module only if not in enquiry mode
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ** Call AMD module
     C     DDACTN        IFEQ      'A'
 
     C                   CALLB     'GLAMADAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Incoming Account in Screen Format :
 Form * - Master Details
      * - Debit Details
      * - Credit Details
      * - Commision Details
      * - Other Details
     C                   PARM                    NewAcPrim
     C                   PARM                    NewAcDebt
     C                   PARM                    NewAcCrdt
     C                   PARM                    NewAcComm
     C                   PARM                    NewAcOthr
      *
      * (Current) Account in Screen Format :
 Form * - Master Details
      * - Debit Details
      * - Credit Details
      * - Commision Details
      * - Other Details
     C                   PARM                    CurAcPrim
     C                   PARM                    CurAcDebt
     C                   PARM                    CurAcCrdt
     C                   PARM                    CurAcComm
     C                   PARM                    CurAcOthr
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKAcPrim
     C                   PARM                    OKAcDebt
     C                   PARM                    OKAcCrdt
     C                   PARM                    OKAcComm
     C                   PARM                    OKAcOthr
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      0             Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
 
     C                   ENDIF
      *
     C                   CALLB     'GLAMAD3VL'
      *
      ** INPUTS
      *
      ** Account Primary & Credit details
     C                   PARM                    NewAcPrim
     C                   PARM                    NewAcCrdt
     C                   PARM                    NewAcComm                                    208221
 
      ** ICD
     C                   PARM                    R_TCAL
                                                                                180721
      * Front Office Transaction ID                                             180721
     C                   PARM                    FOTRID                         180721
 
      ** Credit Details OK inds
     C                   PARM                    OKAcCrdt
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller                    AR847249
     C                   PARM                    WFldNamArr                                 AR847249
     C                   PARM                    WMsgIDArr                                  AR847249
     C                   PARM                    WMsgDtaArr                                 AR847249
      ** Array index (3P0) from/to caller                                                   AR847249
     C                   PARM                    WIdx                                       AR847249
 
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
     C                   PARM                    NARIFilFmt
     C                   PARM                    NABXFilFmt                                   208221
      * Revenue Analysis                                                                      208221
     C                   PARM                    CDE002                                       208221
     C                   PARM                    CRE015            1                        AR947093
     C                   PARM                    X5ATTY            1                        AR947093
      *
     C                   ENDIF
      *
     C     IDX           IFEQ      0
     C     DDACTN        OREQ      'E'
      *
     C     DDACTN        IFEQ      'I'
     C     WWACTN        OREQ      'A'
     C     WWACTN        OREQ      'E'
      ** Test if at least one commission present
     C     CommDisp      IFEQ      'Y'
     C                   MOVEL     '4'           @SCRN
     C                   ELSE
     C                   MOVEL     '5'           @SCRN
     C                   ENDIF
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'A'
     C     WWACTN        ANDEQ     '3'
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'E'
     C     WWACTN        ANDNE     'E'
      *
     C     BGN1ST        IFEQ      'Y'
     C                   CALL      'CGC0025'
     C                   PARM      *BLANKS       RTCD
     C                   PARM      'E'           ACTN
     C                   PARM      ACKEY         ACCD
     C                   ENDIF
      *
      ** If Midas-Fontis Interface is switched on, call program to
      ** display Fontis account details.
      *
     C     AMATYP        IFEQ      'R'
     C     CGL004        ANDEQ     'Y'
     C                   CALL      'GLC2800'
     C                   PARM      *BLANK        RTCD
     C                   PARM      ACKEY         ACCD
     C                   PARM      'E'           ACTN
     C                   ENDIF
      *                                                                                       CGL018
      ** If Midas-Risk Weighted Assets feature is switched on,                                CGL018
      ** call program to allow optional entry of RWA codes                                    CGL018
      *                                                                                       CGL018
     C     CGL018        IFEQ      'Y'                                                        CGL018
     C                   CALL      'GLC001240'                                                CGL018
     C                   PARM      *BLANK        RTCD                                         CGL018
     C                   PARM      ACKEY         ACCD                                         CGL018
     C                   PARM      'E'           ACTN                                         CGL018
     C                   ENDIF                                                                CGL018
      *
      ** IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ** ELSE, GO TO INITIAL SCREEN
     C                   EXSR      SRINIT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPSD4 - PROCESS SCREEN: Fourth Detail Screen
      *****************************************************************
     C     SRPSD4        BEGSR
 
      * IF INSERT                                                               176842
      * DO DEFAULTING FOR CHARGES & COMMISSIONS SCREEN                          176842
      * (Only do this once per transaction unless details on other screens      176842
      *  have changed)                                                          176842
      *
     C     DDACTN        IFEQ      'I'                                          176842
     C     NewAcPrim     IFNE      PrvAcPrim                                    176842
     C     NewAcDebt     ORNE      PrvAcDebt                                    176842
     C     NewAcCrdt     ORNE      PrvAcCrdt                                    176842
     C                   EXSR      DFT@O                                        176842
     C                   END                                                    176842
     C                   END                                                    176842
      *
      * IF AMEND OR ENQUIRE                                                     176842
      * Do charges and VAT calculations only if first time through              176842
      * for transaction.                                                        176842
     C     DDACTN        IFNE      'I'                                          176842
     C*****DDACCN        IFNE      #DACCN                                              176842 222427
     C                   EXSR      DFT@O                                        176842
     C**********         MOVEL     DDACCN        #DACCN           18                   176842 CGL029
     C**********         MOVEL     DDACCN        #DACCN                                CGL029 222427
     C**********         END                                                           176842 222427
     C                   END                                                    176842
 
      * Update 'previous' screen
 
     C                   MOVEL     NewAcComm     PrvAcComm
      *
      ** WRITE/READ DISPLAY SCREEN - Fourth Details
      *
     C                   CALLB     'GLAMAD4DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Account (IN SCREEN FORMAT - First & Fourth)
     C                   PARM                    NewAcPrim
     C                   PARM                    NewAcComm
      *
      * Fields in error
     C                   PARM                    OKAcComm
      *
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
      *
      * Output Only fields
     C                   PARM                    DDCEXA1
     C                   PARM                    DDCEXB1
     C                   PARM                    DDCEXC1
     C                   PARM                    DDCEXD1
     C                   PARM                    DDCEXE1
     C                   PARM                    DDCEXF1
     C                   PARM                    DDCEXG1
     C                   PARM                    DDDRMG1                        CDE002
     C                   PARM                    DDCRMG1                        CDE002
      *
      ** ICD
     C                   PARM                    RETABLE
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
     C                   PARM                    @EIN25
      *
      * CCRM Revenue Analysis                                                   CDE002
     C                   PARM                    CDE002                         CDE002
      *                                                                         CDE002
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      *OFF          @INKC
     C                   PARM      *OFF          @INKE
     C                   PARM      *OFF          @INKF
     C                   PARM      *OFF          @INKI
     C                   PARM      *OFF          @INKL
     C                   PARM      *OFF          @IN49
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKAcComm
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *                                                                                       222549
      ** Linked enquiry command keys processing                                               222549
      *                                                                                       222549
     C     MODID         IFEQ      'GL'                                                       222549
     C                   EXSR      #CMDSR                                                     222549
     C                   ENDIF                                                                222549
      *
     C                   SELECT
      *
      ** F3 - End Program
     C     @INKC         WHENEQ    *ON
     C                   MOVE      'T'           @SCRN
      *
      ** F5 - Refresh
     C     @INKE         WHENEQ    *ON
     C                   EXSR      SRRFRSH
      *
      ** F6 - Amend on Enquiry
     C     @INKF         WHENEQ    *ON
      *
      * If multibranching do validation on branch input
     C     BJSBRC        IFEQ      *BLANKS
     C                   MOVEL     'A'           @ZACTN
     C                   MOVEL     DDBRCA        @BRCA
     C                   EXSR      SRAUTH
     C     @ERR          IFNE      0
     C                   Add       1             Idx
     C                   Z-ADD     IDX           IX
     C                   Movel     *Blank        FldNameArr(Ix)
     C                   Movel     'RE7103B'     MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
      ** User must be authorised and action mode is enquiry
     C     *IN41         IFEQ      '1'
     C     DDACTN        ANDEQ     'E'
     C     Idx           ANDEQ     *ZERO
     C                   MOVE      'A'           DDACTN
     C                   EXSR      SFDS@P                                                     215207
     C                   ELSE
     C                   Add       1             Idx
     C                   Z-ADD     IDX           IX
     C                   Movel     *Blank        FldNameArr(Ix)
     C                   Movel     'RE71003'     MsgIDArr(Ix)
     C                   ENDIF
      *
      ** F9 - Init Screen
     C     @INKI         WHENEQ    *ON
     C                   EXSR      SRINIT
      *
      ** F12 - Cancel
     C     @INKL         WHENEQ    *ON
     C     WWACTN        IFEQ      'A'
     C     WWACTN        OREQ      'E'
     C     DDACTN        OREQ      'I'
      ** Reset updated file field for validation in detail 3
     C     DDACTN        IFEQ      'I'
     C                   Z-ADD     *ZERO         AMCRIB
     C                   Z-ADD     *ZERO         AMCRIS
     C                   Z-ADD     *ZERO         B_RICICT
     C                   Z-ADD     *ZERO         B_RICCST
     C                   Z-ADD     *ZERO         AMCRCD
     C                   ENDIF
     C     DDACTN        IFEQ      'A'
     C                   Z-ADD     C_CRIB        AMCRIB
     C                   Z-ADD     C_CRIS        AMCRIS
     C                   Z-ADD     CB_CICT       B_RICICT
     C                   Z-ADD     CB_CCST       B_RICCST
     C                   Z-ADD     C_CRCD        AMCRCD
     C                   ENDIF
     C                   MOVE      '3'           @SCRN
     C                   ELSE
     C                   MOVE      '0'           @SCRN
     C                   MOVE      WWACTN        DDACTN
     C                   ENDIF
      *
      ** Validate input to key screen when enter is pressed
     C     @IN49         WHENEQ    *OFF
     C                   EXSR      SRVALD4
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    176842
      *****************************************************************         176842
      * DFT@O   - DEFAULTING FOR COMMISSIONS & OVERRIDES SCREEN                 176842
      *****************************************************************         176842
     C     DFT@O         BEGSR                                                  176842
      *
     C                   CALL      'AOCUSTR1'                                                 215721
     C                   PARM      '*DBERR '     @RTCD                                        215721
     C                   PARM      '*KEY   '     @OPTN                                        215721
     C                   PARM      DDCUSN        @CNUM            10                          215721
     C                   PARM      *BLANKS       @CNST             7                          215721
     C     SDCUST        PARM      SDCUST        DSLDY                                        215721
      *                                                                                       215721
     C     BBCGRP        IFEQ      *BLANKS                                      176842
     C     @RTCD         ORNE      *BLANKS                                                    215721
     C                   MOVEL     '1'           BBCGRP                         176842
     C                   ENDIF                                                  176842
      *
      *                                                                         176842
     C                   CALLB     'GLAMAD4DT'                                  176842
      *                                                                         176842
      * INPUTS :                                                                176842
      * Response mode                                                           176842
     C                   PARM                    RetCodeIn                      176842
                                                                                176842
      * Customer Retail Group                                                   176842
     C                   PARM                    BBCGRP                         176842
      *                                                                         CDE002
      ** CCRM Revenue Analysis                                                  CDE002
     C                   PARM                    CDE002                         CDE002
                                                                                176842
      * Account details (DS) in file format                                     176842
     C                   PARM                    CrAcFilFmt                     176842
     C                   PARM                    NABXFilFmt                                   208221
     C                   PARM                    NewAcPrim                                    222427
 
      * OUTPUTS :                                                               176842
      * Screen 4 Output                                                         176842
     C                   PARM                    DDCEXA1          11            176842
     C                   PARM                    DDCEXB1          11            176842
     C                   PARM                    DDCEXC1          11            176842
     C                   PARM                    DDCEXD1           8            176842
     C                   PARM                    DDCEXE1           8            176842
     C                   PARM                    DDCEXF1           8            176842
     C                   PARM                    DDCEXG1           8            176842
     C                   PARM                    DDDRMG1                        CDE002
     C                   PARM                    DDCRMG1                        CDE002
 
     C                   ENDSR                                                  176842
      *****************************************************************         176842
      /EJECT
      *****************************************************************
      * SRVALD4  - Validate input to fourth detail screen
      *****************************************************************
     C     SRVALD4       BEGSR
      *
      ** Call validation module only if not in enquiry mode
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
     C                   CALLB     'GLAMAD4VL'
      *
      ** INPUTS
      *
      ** Account Primary & Commission details
     C                   PARM                    NewAcPrim
     C                   PARM                    NewAcComm
 
      ** ICD
     C                   PARM                    RETABLE
 
      ** CCRM Revenue Analysis                                                  CDE002
     C                   PARM                    CDE002                         CDE002
                                                                                CDE002
      ** Commission Details OK inds
     C                   PARM                    OKAcComm
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
                                                                                              208221
      * Warning fields/message IDs/message data (arrays) from/to caller                       208221
     C                   PARM                    WFldNamArr                                   208221
     C                   PARM                    WMsgIDArr                                    208221
     C                   PARM                    WMsgDtaArr                                   208221
      * Array index (3P0) from/to caller                                                      208221
     C                   PARM                    WIdx                                         208221
 
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NACOFilFmt
      *
      * Valid Account layout (Extension file) (DS) from/to caller               CDE002
     C                   PARM                    NABXFilFmt                     CDE002
      * Valid Account layout (DS) from/to caller                                              208221
     C                   PARM                    NwAcFilFmt                                   208221
      *                                                                         CDE002
     C                   ENDIF
      *
     C     IDX           IFEQ      0
     C     WIdx          ANDEQ     0                                                          208221
     C     IDX           OREQ      0                                                          208221
     C     WIdx          ANDNE     0                                                          208221
     C     WFLAG         ANDEQ     'Y'                                                        208221
     C     DDACTN        OREQ      'E'
      *
     C                   MOVEL     *BLANK        WFldNamArr                                   208221
     C                   MOVEL     *BLANK        WMsgIdArr                                    208221
     C                   MOVEL     *BLANK        WMsgDtaArr                                   208221
      *                                                                                       208221
     C     DDACTN        IFEQ      'I'
     C     WWACTN        OREQ      'A'
     C     WWACTN        OREQ      'E'
     C                   MOVEL     '5'           @SCRN
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'A'
     C     WWACTN        ANDNE     'A'
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'E'
     C     WWACTN        ANDNE     'E'
      *
     C     BGN1ST        IFEQ      'Y'
     C                   CALL      'CGC0025'
     C                   PARM      *BLANKS       RTCD
     C                   PARM      'E'           ACTN
     C                   PARM      ACKEY         ACCD
     C                   ENDIF
      *
      ** If Midas-Fontis Interface is switched on, call program to
      ** display Fontis account details.
      *
     C     AMATYP        IFEQ      'R'
     C     CGL004        ANDEQ     'Y'
     C                   CALL      'GLC2800'
     C                   PARM      *BLANK        RTCD
     C                   PARM      ACKEY         ACCD
     C                   PARM      'E'           ACTN
     C                   ENDIF
      *                                                                                       CGL018
      ** If Midas-Risk Weighted Assets feature is switched on,                                CGL018
      ** call program to allow optional entry of RWA codes                                    CGL018
      *                                                                                       CGL018
     C     CGL018        IFEQ      'Y'                                                        CGL018
     C                   CALL      'GLC001240'                                                CGL018
     C                   PARM      *BLANK        RTCD                                         CGL018
     C                   PARM      ACKEY         ACCD                                         CGL018
     C                   PARM      'E'           ACTN                                         CGL018
     C                   ENDIF                                                                CGL018
      *
      ** IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ** ELSE, GO TO INITIAL SCREEN
     C                   EXSR      SRINIT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C     WIdx          IFNE      0                                                          208221
     C                   MOVEL     'Y'           WFLAG             1                          208221
     C                   END                                                                  208221
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPSD5 - PROCESS SCREEN: Fifth Detail Screen
      *****************************************************************
     C     SRPSD5        BEGSR
                                                                                CRE007
      * If Base Rate Tax 2001 is installed and Account Holder Type              CRE007
      * is 'R' then default BRT Category field to 'R' in Insert Mode.           CRE007
      *                                                                         CRE007
     C     CRE007        IFEQ      'Y'                                          CRE007
     C     DDACTN        ANDEQ     'I'                                          CRE007
      *                                                                         CRE007
      * Check if Account Holder Type is 'R'                                     CRE007
     C**********         MOVE      DDCUSN        @CNUM6            6 0                 CRE007 CSD027
     C                   MOVE      DDCUSN        @CNUM6            6                          CSD027
     C     @CNUM6        CHAIN     SDCBRTL1                           80        CRE007
     C     *IN80         IFEQ      *OFF                                         CRE007
     C     XRECI         ANDEQ     'D'                                          CRE007
                                                                                CRE007
     C     ACHLRT        IFEQ      'R'                                          CRE007
     C                   MOVE      'R'           DDBRTCA                        CRE007
     C                   ENDIF                                                  CRE007
     C                   ENDIF                                                  CRE007
     C                   ENDIF                                                  CRE007
 
      * Update 'previous' screen
 
     C                   MOVEL     NewAcOthr     PrvAcOthr
      *
      ** WRITE/READ DISPLAY SCREEN - Fifth Details
      *
     C                   CALLB     'GLAMAD5DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Account (IN SCREEN FORMAT - First & Fifth)
     C                   PARM                    NewAcPrim
     C                   PARM                    NewAcOthr
      *
      * Fields in error
     C                   PARM                    OKAcOthr
      *
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
      *
      ** ICD
     C                   PARM                    R_PBKU
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
     C                   PARM                    @EIN25
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      *OFF          @INKC
     C                   PARM      *OFF          @INKE
     C                   PARM      *OFF          @INKF
     C                   PARM      *OFF          @INKI
     C                   PARM      *OFF          @INKL
     C                   PARM      *OFF          @IN49
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKAcOthr
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *                                                                                       222549
      ** Linked enquiry command keys processing                                               222549
      *                                                                                       222549
     C     MODID         IFEQ      'GL'                                                       222549
     C                   EXSR      #CMDSR                                                     222549
     C                   ENDIF                                                                222549
      *
     C                   SELECT
      *
      ** F3 - End Program
     C     @INKC         WHENEQ    *ON
     C                   MOVE      'T'           @SCRN
      *
      ** F5 - Refresh
     C     @INKE         WHENEQ    *ON
     C                   EXSR      SRRFRSH
      *
      ** F6 - Amend on Enquiry
     C     @INKF         WHENEQ    *ON
      *
      * If multibranching do validation on branch input
     C     BJSBRC        IFEQ      *BLANKS
     C                   MOVEL     'A'           @ZACTN
     C                   MOVEL     DDBRCA        @BRCA
     C                   EXSR      SRAUTH
     C     @ERR          IFNE      0
     C                   Add       1             Idx
     C                   Z-ADD     IDX           IX
     C                   Movel     *Blank        FldNameArr(Ix)
     C                   Movel     'RE7103B'     MsgIDArr(Ix)
     C                   ENDIF
     C                   ENDIF
      *
      ** User must be authorised and action mode is enquiry
     C     *IN41         IFEQ      '1'
     C     DDACTN        ANDEQ     'E'
     C     Idx           ANDEQ     *ZERO
     C                   MOVE      'A'           DDACTN
     C                   EXSR      SFDS@P                                                     215207
     C                   ELSE
     C                   Add       1             Idx
     C                   Z-ADD     IDX           IX
     C                   Movel     *Blank        FldNameArr(Ix)
     C                   Movel     'RE71003'     MsgIDArr(Ix)
     C                   ENDIF
      *
      ** F9 - Init Screen
     C     @INKI         WHENEQ    *ON
     C                   EXSR      SRINIT
      *
      ** F12 - Cancel
     C     @INKL         WHENEQ    *ON
     C     WWACTN        IFEQ      'A'
     C     WWACTN        OREQ      'E'
     C     DDACTN        OREQ      'I'
      ** At least one commission must be present
     C     CommDisp      IFEQ      'Y'
     C                   MOVE      '4'           @SCRN
     C                   ELSE
      ** Reset updated file field for validation in screen 3
     C     DDACTN        IFEQ      'I'
     C                   Z-ADD     *ZERO         AMCRIB
     C                   Z-ADD     *ZERO         AMCRIS
     C                   Z-ADD     *ZERO         B_RICICT
     C                   Z-ADD     *ZERO         B_RICCST
     C                   Z-ADD     *ZERO         AMCRCD
     C                   ENDIF
     C     DDACTN        IFEQ      'A'
     C                   Z-ADD     C_CRIB        AMCRIB
     C                   Z-ADD     C_CRIS        AMCRIS
     C                   Z-ADD     CB_CICT       B_RICICT
     C                   Z-ADD     CB_CCST       B_RICCST
     C                   Z-ADD     C_CRCD        AMCRCD
     C                   ENDIF
     C                   MOVEL     '3'           @SCRN
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '0'           @SCRN
     C                   MOVE      WWACTN        DDACTN
     C                   ENDIF
      *
      ** Validate input to key screen when enter is pressed
     C     @IN49         WHENEQ    *OFF
     C                   EXSR      SRVALD5
      *
     C                   ENDSL
      *
     C/COPY WNCPYSRC,GLAMADSC04
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRVALD5  - Validate input to fifth detail screen
      *****************************************************************
     C     SRVALD5       BEGSR
      *
      ** Call validation module only if not in enquiry mode
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
     C                   CALLB     'GLAMAD5VL'
      *
      ** INPUTS
      *
      ** Account Primary & Other details
     C                   PARM                    NewAcPrim
     C                   PARM                    NewAcOthr
     C/COPY OFCPYSRCZ,CRE101_028                                                              CRE101
 
      ** Other Details OK inds
     C                   PARM                    OKAcOthr
     C/COPY OFCPYSRCZ,CRE101_058                                                              CRE101
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller                       CER047
     C                   PARM                    WFldNamArr                                   CER047
     C                   PARM                    WMsgIDArr                                    CER047
     C                   PARM                    WMsgDtaArr                                   CER047
      * Array index (3P0) from/to caller                                                      CER047
     C                   PARM                    WIdx                                         CER047
                                                                                              CER047
      * Valid Account layout (DS) from/to caller
     C                   PARM                    NwAcFilFmt
     C                   PARM                    NARIFilFmt
     C                   PARM                    NAPWFilFmt
     C/COPY OFCPYSRCZ,CRE101_059                                                              CRE101
      *
     C                   ENDIF
      *
     C     IDX           IFEQ      0
     C     DDACTN        OREQ      'E'
      *
      ** Insert or Amend Mode, process insert/write
      **    but if windows processing is on, display window first                             189774
      *                                                                                       189774
     C/COPY WNCPYSRC,GLAMADSC02
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   MOVE      'W'           @SCRN                                        189774
     C                   ELSE                                                                 189774
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                189774
     C                   ENDIF
      *
      ** Enquiry Mode, return to previous screen
      **    but if windows processing is on, display window first                             189774
      *                                                                                       189774
     C     DDACTN        IFEQ      'E'
      *
     C     BGWDPR        IFEQ      'Y'                                                        189774
     C                   MOVE      'W'           @SCRN                                        189774
     C                   ELSE                                                                 189774
      *                                                                                       189774
     C     BGN1ST        IFEQ      'Y'
     C                   CALL      'CGC0025'
     C                   PARM      *BLANKS       RTCD
     C                   PARM      'E'           ACTN
     C                   PARM      ACKEY         ACCD
     C                   ENDIF
      *
      ** If Midas-Fontis Interface is switched on, call program to
      ** display Fontis account details.
      *
     C     AMATYP        IFEQ      'R'
     C     CGL004        ANDEQ     'Y'
     C                   CALL      'GLC2800'
     C                   PARM      *BLANK        RTCD
     C                   PARM      ACKEY         ACCD
     C                   PARM      'E'           ACTN
     C                   ENDIF
      *                                                                                       CGL018
      ** If Midas-Risk Weighted Assets feature is switched on,                                CGL018
      ** call program to allow optional entry of RWA codes                                    CGL018
      *                                                                                       CGL018
     C     CGL018        IFEQ      'Y'                                                        CGL018
     C                   CALL      'GLC001240'                                                CGL018
     C                   PARM      *BLANK        RTCD                                         CGL018
     C                   PARM      ACKEY         ACCD                                         CGL018
     C                   PARM      'E'           ACTN                                         CGL018
     C                   ENDIF                                                                CGL018
      *
      ** IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ** ELSE, GO TO INITIAL SCREEN
     C                   EXSR      SRINIT
     C                   ENDIF
      *
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ENDIF
      *
     C                   ENDIF
      *
     C/COPY WNCPYSRC,GLAMADSC22
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  189774
      *****************************************************************                       189774
      * SRPSDW - PROCESS SCREEN: Window processing                                            189774
      *****************************************************************                       189774
     C     SRPSDW        BEGSR                                                                189774
      *                                                                                       189774
      ** If account is retail, redisplay first detail screen                                  189774
      *                                                                                       189774
     C     AMATYP        IFEQ      'R'                                                        189774
     C                   CALLB     'GLAMAD1DP'                                                189774
      ** Input parameters                                                                     189774
     C                   PARM      *Blanks       RetCodeIn                                    189774
     C                   PARM                    NewAcPrim                                    189774
     C                   PARM                    OKAcPrim                                     189774
     C                   PARM                    NwAcFilFmt                                   189774
     C                   PARM                    NARIFilFmt                                   189774
     C                   PARM                    DDDACC                                       189774
     C                   PARM                    DDLINK                                       189774
     C                   PARM                    DDFAMT                                       189774
     C                   PARM                    R_CNDS                                       189774
     C                   PARM                    R_FACH                                       189774
     C                   PARM                    R_TSTMC                                      189774
     C                   PARM                    FldNameArr                                   189774
     C                   PARM                    MsgIdArr                                     189774
     C                   PARM                    MsgDtaArr                                    189774
     C                   PARM                    WFldNamArr                                   189774
     C                   PARM                    WMsgIdArr                                    189774
     C                   PARM                    WMsgDtaArr                                   189774
     C                   PARM                    @EKYFD                                       189774
     C                   PARM                    @EDTFD                                       189774
     C                   PARM                    @EIN25                                       189774
      ** Output parameters                                                                    189774
     C                   PARM                    @INKC                                        189774
     C                   PARM                    @INKE                                        189774
     C                   PARM                    @INKF                                        189774
     C                   PARM                    @INKG                                        189774
     C                   PARM                    @INKH                                        189774
     C                   PARM                    @INKI                                        189774
     C                   PARM                    @INKL                                        189774
     C                   PARM                    @INKP                                        189774
     C                   PARM                    @IN49                                        189774
     C                   PARM      'Y'           WriteOnly                                    189774
      *                                                                                       189774
      ** Else if account is not retail, redisplay fifth detail screen                         189774
      *                                                                                       189774
     C                   ELSE                                                                 189774
     C                   CALLB     'GLAMAD5DP'                                                189774
      ** Input parameters                                                                     189774
     C                   PARM      *Blank        RetCodeIn                                    189774
     C                   PARM                    NewAcPrim                                    189774
     C                   PARM                    NewAcOthr                                    189774
     C                   PARM                    OKAcOthr                                     189774
     C                   PARM                    NwAcFilFmt                                   189774
     C                   PARM                    R_PBKU                                       189774
     C                   PARM                    FldNameArr                                   189774
     C                   PARM                    MsgIdArr                                     189774
     C                   PARM                    MsgDtaArr                                    189774
     C                   PARM                    WFldNamArr                                   189774
     C                   PARM                    WMsgIdArr                                    189774
     C                   PARM                    WMsgDtaArr                                   189774
     C                   PARM                    @EIN25                                       189774
      ** Output parameters                                                                    189774
     C                   PARM                    @INKC                                        189774
     C                   PARM                    @INKE                                        189774
     C                   PARM                    @INKF                                        189774
     C                   PARM                    @INKI                                        189774
     C                   PARM                    @INKL                                        189774
     C                   PARM                    @IN49                                        189774
     C                   PARM      'Y'           WriteOnly                                    189774
     C                   ENDIF                                                                189774
                                                                                              189774
     C/COPY WNCPYSRC,GLAMADSMV1                                                               189774
      *                                                                                      LLN022A
      ** Move fields from main screen to Data structure                                      LLN022A
      ** to be passed to window                                                              LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN022 = 'Y'                                              LLN022A
     C                   MOVE      DDBRCA        BYBRCD                                      LLN022A
     C                   MOVE      DDCUSN        BYCNUM                                      LLN022A
     C                   MOVE      DDCCY         BYCCY                                       LLN022A
     C                   MOVE      DDACOD        BYACOD                                      LLN022A
     C                   MOVE      DDACSQ        BYACSQ                                      LLN022A
      *                                                                                      LLN022A
      ** Account Type                                                                        LLN022A
      *                                                                                      LLN022A
     C                   MOVE      AMATYP        BYATYP                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       189774
     C                   CALL      'WN0010'                                                   189774
     C                   PARM      'GLAMADSIN'   PWPgm            10                          189774
     C                   PARM                    PWKey             2                          189774
     C                   PARM      DDACTN        PWAction          1                          189774
     C                   PARM                    Data                                         189774
     C                   PARM      *Blanks       PWRtn             7                          189774
     C                   PARM                    PWSpare         256                          189774
     C/COPY WNCPYSRC,GLAMADSC01
      *                                                                                       189774
      ** If F3 pressed, end program                                                           189774
      *                                                                                       222549
      ** Linked enquiry command keys processing                                               222549
      *                                                                                       222549
     C     MODID         IFEQ      'GL'                                                       222549
     C                   EXSR      #CMDSR                                                     222549
     C                   ENDIF                                                                222549
      *                                                                                       189774
     C                   SELECT                                                               189774
     C                   WHEN      PWRtn = 'Y2U9999'                                          189774
     C                   EVAL      @SCRN = 'T'                                                189774
      *                                                                                       189774
      ** Else if F12 pressed, return to previous screen                                       189774
      *                                                                                       189774
     C                   WHEN      PWRtn = 'USR0790'                                          189774
     C                             AND AMATYP = 'R'                                           189774
     C                   EVAL      @SCRN = '5'                                                189774
      *                                                                                       189774
     C                   WHEN      PWRtn = 'USR0790'                                          189774
     C                             AND AMATYP <> 'R'                                          189774
     C                   EVAL      @SCRN = '1'                                                189774
      *                                                                                       189774
      ** Else if ENTER key was pressed,                                                       189774
      *                                                                                       189774
     C                   OTHER                                                                189774
      *                                                                                       189774
     C     DDACTN        IFEQ      'E'                                                        189774
      *                                                                                       189774
     C     BGN1ST        IFEQ      'Y'                                                        189774
     C                   CALL      'CGC0025'                                                  189774
     C                   PARM      *BLANKS       RTCD                                         189774
     C                   PARM      'E'           ACTN                                         189774
     C                   PARM      ACKEY         ACCD                                         189774
     C                   ENDIF                                                                189774
     C     AMATYP        IFEQ      'R'                                                        189774
     C     CGL004        ANDEQ     'Y'                                                        189774
     C                   CALL      'GLC2800'                                                  189774
     C                   PARM      *BLANK        RTCD                                         189774
     C                   PARM      ACKEY         ACCD                                         189774
     C                   PARM      'E'           ACTN                                         189774
     C                   ENDIF                                                                189774
     C     @RDNB         IFEQ      'Y'                                                        189774
     C                   MOVEL     'R'           @SCRN                                        189774
     C                   ELSE                                                                 189774
     C                   EXSR      SRINIT                                                     189774
     C                   ENDIF                                                                189774
      *                                                                                       CGL018
      ** If Midas-Risk Weighted Assets feature is switched on,                                CGL018
      ** call program to allow optional entry of RWA codes                                    CGL018
      *                                                                                       CGL018
     C     CGL018        IFEQ      'Y'                                                        CGL018
     C                   CALL      'GLC001240'                                                CGL018
     C                   PARM      *BLANK        RTCD                                         CGL018
     C                   PARM      ACKEY         ACCD                                         CGL018
     C                   PARM      'E'           ACTN                                         CGL018
     C                   ENDIF                                                                CGL018
      *                                                                                       189774
     C     @RDNB         IFEQ      'Y'                                                        189774
     C                   MOVEL     'R'           @SCRN                                        189774
     C                   ELSE                                                                 189774
     C                   EXSR      SRINIT                                                     189774
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ELSE                                                                 189774
     C     DDACTN        IFEQ      'I'                                                        189774
     C     DDACTN        OREQ      'A'                                                        189774
     C                   EVAL      @SCRN = 'U'                                                189774
     C                   ENDIF                                                                189774
     C                   ENDIF                                                                189774
      *                                                                                       189774
     C                   ENDSL                                                                189774
      *                                                                                       189774
     C/COPY WNCPYSRC,GLAMADSC06
     C                   ENDSR                                                                189774
      *****************************************************************                       189774
      /EJECT
      *****************************************************************
      * SRRFRSH - Refresh Screen
      *****************************************************************
     C     SRRFRSH       BEGSR
      *
     C                   SELECT
      *
     C     @SCRN         WHENEQ    'K'
     C                   MOVEL     *BLANK        DDBRCA
     C                   MOVEL     *BLANK        DDCUSN
     C                   MOVEL     *BLANK        DDCCY
     C                   MOVEL     *BLANK        DDACOD
     C                   MOVEL     *BLANK        DDACSQ
     C                   MOVEL     *BLANK        DDACNO
     C                   MOVEL     *BLANK        DDANAM
     C                   MOVEL     *BLANK        WWANAM           20                          210628
      *
     C     @SCRN         WHENEQ    '1'
     C                   SELECT
     C     DDACTN        WHENEQ    'A'
     C                   MOVEL     CurAcPrim     NewAcPrim
     C                   MOVE      'A'           DDACTN
     C     DDACTN        WHENEQ    'I'
     C                   EXSR      SRDEFT
     C                   ENDSL
      *
     C     @SCRN         WHENEQ    '2'
     C                   SELECT
     C     DDACTN        WHENEQ    'A'
     C                   MOVEL     CurAcDebt     NewAcDebt
     C     DDACTN        WHENEQ    'I'
     C                   CLEAR                   NewAcDebt
     C                   EXSR      SRDEFT                                                     194431
     C                   ENDSL
      *
     C     @SCRN         WHENEQ    '3'
     C                   SELECT
     C     DDACTN        WHENEQ    'A'
     C                   MOVEL     CurAcCrdt     NewAcCrdt
     C     DDACTN        WHENEQ    'I'
     C                   CLEAR                   NewAcCrdt
     C                   EXSR      SRDEFT                                                     194431
     C                   ENDSL
      *
     C     @SCRN         WHENEQ    '4'
     C                   SELECT
     C     DDACTN        WHENEQ    'A'
     C                   MOVEL     CurAcComm     NewAcComm
     C     DDACTN        WHENEQ    'I'
     C                   CLEAR                   NewAcComm
     C                   EXSR      SRDEFT                                                     194431
     C                   ENDSL
      *
     C     @SCRN         WHENEQ    '5'
     C                   SELECT
     C     DDACTN        WHENEQ    'A'
     C                   MOVEL     CurAcOthr     NewAcOthr
     C     DDACTN        WHENEQ    'I'
     C                   CLEAR                   NewAcOthr
     C                   EXSR      SRDEFT                                                     194431
     C                   ENDSL
      *
     C                   ENDSL
      *
     C/COPY WNCPYSRC,GLAMADSC11
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAUTH - Check action code and branch authority
      *****************************************************************
     C     SRAUTH        BEGSR
      *
      ** Multi-branch system, user must be authorised to action on branch.
      *
     C     AGMBIN        IFEQ      'Y'
     C                   CALL      'ZVACTBU'
     C                   PARM                    @ZACTN            1
     C                   PARM                    @BRCA             3
     C                   PARM                    @ERR              1 0
      *
     C                   ELSE
      *
      ** Single branch system, check user is authorised to action code
      *
     C                   CALL      'ZVACTU'
     C                   PARM                    @ZACTN
     C                   PARM                    @ERR
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      * SRDEFT - Process default values in INSERT MODE
      ********************************************************************
     C     SRDEFT        BEGSR
      *
      ** Initialise screen fields to default values:
     C                   MOVE      'Y'           DDPTAD
     C                   MOVE      'N'           DDRAD
     C                   MOVE      'N'           DDRAC
     C                   MOVE      'N'           DDBAD
     C                   MOVE      'N'           DDBAC
      *
      ** Dft the Statement Freq to the value held on the GL ICD (SdGelr)
     C                   MOVE      BKDSFC        DDSTFQ
     C                   MOVE      BKDSFC        AMSTFQ                                       213342
      *
      ** Access customer details
     C*****              CALL      'AOCUSTR0'                                   180721
     C                   CALL      'AOCUSTR1'                                   180721
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCUSN        @CNUM            10
     C                   PARM      *BLANKS       @CNST             7
     C*****SDCUST        PARM      SDCUST        DSSDY                          180721
     C     SDCUST        PARM      SDCUST        DSLDY                          180721
      *
      ** Dft Account Name to Client Name
     C                   MOVE      BBCRNM        DDANAM
     C                   MOVE      BBCRNM        WWANAM                                       210628
     C/COPY WNCPYSRC,GLAMADSC16
      *
      ** If Midas/Trade Innovation Interface is switched on then
      ** TI Account defaults to 'N' and other TI fields to blanks
     C     BGN3ST        IFEQ      'Y'
     C                   MOVE      'N'           DDTIAC
     C                   MOVE      *BLANKS       DDTIAN
     C                   MOVE      *BLANKS       DDTIAS
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       DDDACO
     C                   MOVE      *BLANKS       DDNSTD
     C                   MOVE      *BLANKS       DDENOC
     C                   MOVE      *BLANKS       DDNSDN
     C                   MOVE      *BLANKS       DDEUSB
     C                   MOVE      *BLANKS       DDREF
     C                   MOVE      *BLANKS       DDPRFC
     C                   MOVE      *BLANKS       DDMFFQ
     C                   MOVE      *BLANKS       DDPTFR
      *                                                                         CRE007
     C     CRE007        IFEQ      'N'                                          CRE007
     C                   MOVE      BBTAIN        DDITAX
     C                   ELSE                                                   CRE007
     C                   MOVE      'N'           DDITAX                         CRE007
     C                   ENDIF                                                  CRE007
      *                                                                                     BUG22742
     C                   IF        CER048 = 'Y'                                             BUG22742
     C                   EVAL      DDITAX = *BLANKS                                         BUG22742
     C                   ENDIF                                                              BUG22742
      *                                                                         CRE007
     C                   MOVE      R_TSTMC       DDSTCI
     C                   MOVE      *BLANKS       DDCHIN
     C                   MOVE      *BLANKS       DDCHAM
      *                                                                         180721
     C                   MOVE      DDACOD        WWACOK                                       194431
     C                   MOVE      'D'           WWRECI                                       194431
      *                                                                                       CRE030
     C                   IF        CRE030 = 'Y'                                               CRE030
     C                   MOVE      DDCCY         WWACCY                                       CRE030
     C     ACODK2        CHAIN     REDEFDF                            50                      CRE030
     C                   ELSE                                                                 CRE030
     C*****ACODK         CHAIN     REDEF                              50               194431 CRE030
     C     ACODK         CHAIN     REDEFDF                            50                      CRE030
     C                   ENDIF                                                                CRE030
      *                                                                                       194431
     C     *IN50         IFEQ      '0'                                                        194431
     C     X_RECI        ANDEQ     'D'                                                        194431
      *                                                                                       194431
     C                   MOVE      DDACTN        WDACTN            1                          194431
     C                   MOVE      DDCUSN        WDCUSN            6                          194431
     C                   MOVE      DDCCY         WDCCY             3                          194431
     C**********         MOVE      DDACOD        WDACOD            4                   194431 CGL029
     C                   MOVE      DDACOD        WDACOD                                       CGL029
     C                   MOVE      DDACSQ        WDACSQ            2                          194431
     C                   MOVE      DDBRCA        WDBRCA            3                          194431
     C                   MOVE      DDACNO        WDACNO           10                          194431
      *                                                                                       194431
     C                   MOVE      'R'           DDACTN                                       194431
      *                                                                                       194431
     C                   EXSR      SRRTVACC                                                   194431
      *                                                                                       194431
      ** Convert the Account to screen format                                                 194431
      *                                                                                       194431
     C                   MOVE      WDACTN        DDACTN                                       194431
     C                   EXSR      SRCVTACC                                                   194431
      *                                                                                       194431
      ** Return the display field values.                                                     194431
      *                                                                                       194431
     C                   MOVE      WDCUSN        DDCUSN                                       194431
     C                   MOVE      WDCCY         DDCCY                                        194431
     C                   MOVE      WDACOD        DDACOD                                       194431
     C                   MOVE      WDACSQ        DDACSQ                                       194431
     C                   MOVE      WDBRCA        DDBRCA                                       194431
     C                   MOVE      WDACNO        DDACNO                                       194431
     C                   MOVE      *BLANKS       DDDACO                                       194431
     C                   EVAL      %SUBST(DDACCN:1:3)=DDBRCA                                  240205
     C                   EVAL      %SUBST(DDACCN:4:6)=DDCUSN                                  240205
     C                   EVAL      %SUBST(DDACCN:10:3)=DDCCY                                  240205
     C                   EVAL      %SUBST(DDACCN:13:10)=DDACOD                                240205
     C                   EVAL      %SUBST(DDACCN:23:2)=DDACSQ                                 240205
     C                   MOVEL     NewAcPrim     CurAcPrim                                    240205
      *                                                                                       240205
      * Reset values which should not be defaulted from account                               240205
     C                   MOVE      BBCRNM        DDANAM                                       240205
     C                   MOVE      'N'           DDINAI                                       240205
     C                   MOVE      'N'           DDBRLI                                       240205
     C                   MOVE      'N'           DDBADI                                       240205
     C                   MOVE      *BLANKS       DDIBAN                                       210628
     C                   MOVE      WWANAM        DDANAM                                       210628
      *                                                                                       194431
      ** Copy the New account details to the current account details.                         194431
      *                                                                                       194431
     C                   MOVE      WDCUSN        C_CNUM                                       194431
     C                   MOVE      WDCCY         C_CCY                                        194431
     C                   MOVE      WDACOD        C_ACOD                                       194431
     C                   MOVE      WDACSQ        C_ACSQ                                       194431
     C                   MOVE      WDBRCA        C_BRCA                                       194431
     C                   MOVE      WDACNO        C_ACNO                                       194431
     C                   MOVE      *BLANKS       C_IBAN                                       210628
     C                   MOVE      WWANAM        C_ANAM                                       210628
     C                   MOVE      *BLANKS       C_IBSEQN                                     210628
     C                   ENDIF                                                                194431
      *                                                                                       194431
     C     BGN4ST        IFEQ      'Y'                                          180721
     C     BBPRBA        ANDEQ     'Y'                                          180721
      *                                                                         180721
     C     ACODK         KLIST                                                  180721
     C**********         KFLD                    WWACOK            4 0                 180721 CGL029
     C                   KFLD                    WWACOK                                       CGL029
     C                   KFLD                    WWRECI            1            180721
      *                                                                                       CRE030
     C     ACODK2        KLIST                                                                CRE030
     C                   KFLD                    WWACOK                                       CRE030
     C                   KFLD                    WWRECI                                       CRE030
     C                   KFLD                    WWACCY            3                          CRE030
      *                                                                         180721
     C     WWACKB        KLIST                                                  180721
     C                   KFLD                    WWBRCK            3            180721
     C**********         KFLD                    WWCUSK            6 0                 180721 CSD027
     C                   KFLD                    WWCUSK            6                          CSD027
     C                   KFLD                    WWCCYK            3            180721
     C**********         KFLD                    WWACOK            4 0                 180721 CGL029
     C                   KFLD                    WWACOK                                       CGL029
     C                   KFLD                    WWACSK            2 0          180721
      *                                                                         180721
     C     WWACK2        KLIST                                                  180721
     C                   KFLD                    WWCUSK                         180721
     C                   KFLD                    WWCCYK                         180721
     C                   KFLD                    WWACOK                         180721
     C                   KFLD                    WWACSK                         180721
     C                   KFLD                    WWBRCK                         180721
      *                                                                         180721
     C                   MOVE      DDACOD        WWACOK                         180721
     C                   MOVE      'D'           WWRECI                         180721
      *                                                                         180721
     C                   IF        CRE030 = 'Y'                                               CRE030
     C                   MOVE      DDCCY         WWACCY                                       CRE030
     C     ACODK2        CHAIN     REDEFDF                            99                      CRE030
     C                   ELSE                                                                 CRE030
     C*****ACODK         CHAIN     REDEF                              99               180721 CRE030
     C     ACODK         CHAIN     REDEFDF                            99                      CRE030
     C                   ENDIF                                                                CRE030
      *                                                                         180721
     C     *IN99         IFEQ      '0'                                          180721
     C     X_RECI        ANDEQ     'D'                                          180721
      *                                                                         180721
     C*****X_CNUM        IFEQ      *ZEROS                                              180721 CSD027
     C     X_CNUM        IFEQ      *BLANKS                                                    CSD027
      *                                                                         180721
     C     X_RETN        CHAIN     ACNUM                              99        180721
     C     *IN99         IFEQ      '0'                                          180721
     C                   MOVE      CNUM          WWCUSK                         180721
     C                   MOVE      CCY           WWCCYK                         180721
     C                   MOVE      ACOD          WWACOK                         180721
     C                   MOVE      ACSQ          WWACSK                         180721
     C                   MOVE      BRCA          WWBRCK                         180721
     C     WWACKB        CHAIN     ACCNTLXX                           99        180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C                   ELSE                                                   180721
     C                   MOVE      X_CNUM        WWCUSK                         180721
     C                   MOVE      X_RCCY        WWCCYK                         180721
     C                   MOVE      X_ACOD        WWACOK                         180721
     C                   MOVE      X_SEQR        WWACSK                         180721
     C                   MOVE      X_BRCA        WWBRCK                         180721
     C     WWACKB        CHAIN     ACCNTLXX                           99        180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C     *IN99         IFEQ      '0'                                          180721
      *                                                                                       CRE030
      ** Default Minimum Balance if CRE030 is enabled                                         CRE030
     C                   IF        CRE030 = 'Y'                                               CRE030
     C                   IF        MINB=*ZERO                                                 CRE030
     C                   EVAL      DDMINB=*BLANKS                                             CRE030
     C                   ELSE                                                                 CRE030
     C                   MOVE      *BLANKS       ZFIELD                                       CRE030
     C                   MOVE(P)   MINB          ZFIELD                                       CRE030
     C                   Z-ADD     *ZERO         ZADEC                                        CRE030
     C                   CALLB     'ZEDIT'                                                    CRE030
     C                   PARM                    ZFIELD                                       CRE030
     C                   PARM                    ZADEC                                        CRE030
     C                   MOVEL     ZFIELD        DDMINB                                       CRE030
     C                   ENDIF                                                                CRE030
     C                   ENDIF                                                                CRE030
      *                                                                         180721
     C     X_RCCY        IFEQ      DDCCY                                        180721
     C     DRIB          IFEQ      *ZEROS                                       180721
     C                   MOVEL     *BLANKS       DDDRIB                         180721
     C                   ELSE                                                   180721
     C                   MOVE      DRIB          DDDRIB                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
      ** If not the same Ccy - Check Base Type is valid for other Ccy           180721
     C                   ELSE                                                   180721
     C     DRIB          IFNE      *ZEROS                                       180721
     C                   MOVE      DRIB          WWRIB             2            180721
      *                                                                         180721
      ** Get Base Rate Codes                                                    180721
     C                   CALL      'AOBSRTR0'                                   180721
     C                   PARM      '*MSG   '     @RTCD                          180721
     C                   PARM      '*KEY   '     @OPTN                          180721
     C                   PARM                    DDCCY                          180721
     C                   PARM                    WWRIB                          180721
     C     SDBSRT        PARM      SDBSRT        DSFDY                          180721
      *                                                                         180721
     C     @RTCD         IFEQ      *BLANKS                                      180721
     C                   MOVE      DRIB          DDDRIB                         180721
     C                   ELSE                                                   180721
     C                   MOVE      *BLANKS       DDDRIB                         180721
     C                   ENDIF                                                  180721
     C                   ENDIF                                                  180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C     DRIS          IFEQ      *ZEROS                                       180721
     C                   MOVE      *BLANKS       DDDRIS                         180721
     C                   ELSE                                                   180721
     C     DRIS          IFLT      *ZEROS                                       180721
     C                   MOVE      '-'           DDDSIG                         180721
     C                   Z-SUB     DRIS          DRIS                           180721
     C                   ELSE                                                   180721
     C                   MOVE      ' '           DDDSIG                         180721
     C                   ENDIF                                                  180721
     C                   MOVE      *BLANKS       ZFIELD                         180721
     C                   MOVE(P)   DRIS          ZFIELD                         180721
     C                   Z-ADD     7             ZADEC                          180721
     C                   CALLB     'ZEDIT'                                      180721
     C                   PARM                    ZFIELD           16            180721
     C                   PARM                    ZADEC             1 0          180721
     C                   MOVEL     ZFIELD        DDDRIS                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C     X_RCCY        IFEQ      DDCCY                                        180721
     C     CRIB          IFEQ      *ZEROS                                       180721
     C                   MOVEL     *BLANKS       DDCRIB                         180721
     C                   ELSE                                                   180721
     C                   MOVE      CRIB          DDCRIB                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
      ** If not the same Ccy - Check Base Type is valid for other Ccy           180721
     C                   ELSE                                                   180721
     C     CRIB          IFNE      *ZEROS                                       180721
     C                   MOVE      CRIB          WWRIB                          180721
      *                                                                         180721
      ** Get Base Rate Codes                                                    180721
     C                   CALL      'AOBSRTR0'                                   180721
     C                   PARM      '*MSG   '     @RTCD                          180721
     C                   PARM      '*KEY   '     @OPTN                          180721
     C                   PARM                    DDCCY                          180721
     C                   PARM                    WWRIB                          180721
     C     SDBSRT        PARM      SDBSRT        DSFDY                          180721
      *                                                                         180721
     C     @RTCD         IFEQ      *BLANKS                                      180721
     C                   MOVE      CRIB          DDCRIB                         180721
     C                   ELSE                                                   180721
     C                   MOVE      *BLANKS       DDCRIB                         180721
     C                   ENDIF                                                  180721
     C                   ENDIF                                                  180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C     CRIS          IFEQ      *ZEROS                                       180721
     C                   MOVE      *BLANKS       DDCRIS                         180721
     C                   ELSE                                                   180721
     C     CRIS          IFLT      *ZEROS                                       180721
     C                   MOVE      '-'           DDCSIG                         180721
     C                   Z-SUB     CRIS          CRIS                           180721
     C                   ELSE                                                   180721
     C                   MOVE      ' '           DDCSIG                         180721
     C                   ENDIF                                                  180721
     C                   MOVE      *BLANKS       ZFIELD                         180721
     C                   MOVE(P)   CRIS          ZFIELD                         180721
     C                   Z-ADD     7             ZADEC                          180721
     C                   CALLB     'ZEDIT'                                      180721
     C                   PARM                    ZFIELD           16            180721
     C                   PARM                    ZADEC             1 0          180721
     C                   MOVEL     ZFIELD        DDCRIS                         180721
     C                   ENDIF                                                  180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C     DRIC          IFEQ      *ZEROS                                       180721
     C                   MOVE      *BLANKS       DDDRIC                         180721
     C                   ELSE                                                   180721
     C                   MOVE      DRIC          DDDRIC                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C     NDID          IFNE      *ZEROS                                       180721
     C                   CallB     'ZDATE2'                                     180721
     C                   Parm      NDID          ZDAYNO            5 0          180721
     C                   Parm                    BJDFIN                         180721
     C                   Parm      0             ZDATE             6 0          180721
     C                   Parm      *Blanks       ZADATE            7            180721
     C                   Move      ZDATE         DDNDID                         180721
     C                   ELSE                                                   180721
     C                   MOVEL     *BLANKS       DDNDID                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C                   MOVE      *BLANKS       DDDRCD                         180721
     C                   MOVE      *BLANKS       DDCRCD                         180721
      *                                                                         180721
     C                   MOVEL     DRIF          DDDRIF                         180721
     C                   MOVEL     CRIF          DDCRIF                         180721
      *                                                                         180721
     C     DDDRIF        IFEQ      'M'                                          180721
     C     DDDRIF        OREQ      'T'                                          180721
     C     DDDRIF        OREQ      'Q'                                          180721
     C     DDDRIF        OREQ      'X'                                          180721
     C     DDDRIF        OREQ      'Y'                                          180721
     C                   MOVE      DRDY          DDDNCD                         180721
     C                   ELSE                                                   180721
     C                   MOVE      *BLANKS       DDDNCD                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C     DDCRIF        IFEQ      'M'                                          180721
     C     DDCRIF        OREQ      'T'                                          180721
     C     DDCRIF        OREQ      'Q'                                          180721
     C     DDCRIF        OREQ      'X'                                          180721
     C     DDCRIF        OREQ      'Y'                                          180721
     C                   MOVE      CRDY          DDCNCD                         180721
     C                   ELSE                                                   180721
     C                   MOVE      *BLANKS       DDCNCD                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C     CRIC          IFEQ      *ZEROS                                       180721
     C                   MOVE      *BLANKS       DDCRIC                         180721
     C                   ELSE                                                   180721
     C                   MOVE      CRIC          DDCRIC                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C     NCID          IFNE      *ZEROS                                       180721
     C                   CallB     'ZDATE2'                                     180721
     C                   Parm      NCID          ZDAYNO            5 0          180721
     C                   Parm                    BJDFIN                         180721
     C                   Parm      0             ZDATE             6 0          180721
     C                   Parm      *Blanks       ZADATE            7            180721
     C                   Move      ZDATE         DDNCID                         180721
     C                   ELSE                                                   180721
     C                   MOVEL     *BLANKS       DDNCID                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C     WWACK2        CHAIN     REIACXX                            99        180721
      *                                                                         180721
     C     *IN99         IFEQ      '0'                                          180721
      *                                                                         180721
     C     X_RCCY        IFEQ      DDCCY                                        180721
      *                                                                         180721
     C                   MOVEL     *BLANKS       DDDICT                         180721
     C     DICT          IFNE      *ZEROS                                       180721
     C                   MOVE      DICT          DDDICT                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C                   MOVEL     *BLANKS       DDCICT                         180721
     C     CICT          IFNE      *ZEROS                                       180721
     C                   MOVE      CICT          DDCICT                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C     DCST          IFEQ      *ZEROS                                       180721
     C                   MOVEL     *BLANKS       DDDCST                         180721
     C                   ELSE                                                   180721
     C                   MOVE      DCST          DDDCST                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C     CCST          IFEQ      *ZEROS                                       180721
     C                   MOVEL     *BLANKS       DDCCST                         180721
     C                   ELSE                                                   180721
     C                   MOVE      CCST          DDCCST                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C                   ENDIF                                                  180721
      *                                                                         180721
     C                   ENDIF                                                  180721
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRROLL - Roll backwards & forwards through Accounts file
      *****************************************************************
     C     SRROLL        BEGSR
      *
      * READ NEXT OR PREVIOUS RECORD ON Account FILE
      * ACCORDING TO COMMAND KEY TAKEN (F7{=INKG} OR F8)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   ENDIF
      *
     C                   CALLB     'GLAMADRED'
      *
      * INPUT PARAMETERS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Account REF. POINTER
     C**********         PARM                    DDACREF          18                          CGL029
     C                   PARM                    DDACREF                                      CGL029
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      * Account REF. READ
     C**********         PARM      *BLANK        @ACRED           18                          CGL029
     C                   PARM      *BLANK        @ACRED                                       CGL029
     C                   PARM      *BLANK        @RERED           10
      *
      * If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EROLL
     C                   ENDIF
      *
      * If Account read
      *
     C     @ACRED        IFNE      *BLANK
      *
      * Retrieve Account details
      *
     C                   MOVEL     @ACRED        ACKEY
     C                   MOVEL     @ACRED        DDACCN
     C                   MOVE      @RERED        DDACNO
     C                   MOVE      WWBRCA        DDBRCA
     C                   MOVE      WWCNUM        DDCUSN
     C                   MOVE      WWCCY         DDCCY
     C                   MOVE      WWACOD        DDACOD
     C                   MOVE      WWACSQ        DDACSQ
     C                   EXSR      SRRTVACC
      *
      ** IF VALID, WRITE ONLY THE PRIMARY SCREEN AND VALIDATE THE SCREEN
     C     IDX           IFEQ      *ZERO
      *
      ** Convert Account
     C                   EXSR      SRCVTACC
     C                   MOVEL     CrAcFilFmt    NwAcFilFmt
     C                   MOVEL     CABXFilFmt    NABXFilFmt
     C**********         MOVEL     CARIFilFmt    NARIFilFmt                                   CGL029
     C                   MOVEL     CARIFilFmt1   NARIFilFmt1                                  CGL029
     C                   MOVEL     CARIFilFmtEx  NARIFilFmtEx                                 CGL029
     C**********         MOVEL     CACOFilFmt    NACOFilFmt                                   CGL029
     C                   MOVEL     CACOFilFmt1   NACOFilFmt1                                  CGL029
     C                   MOVEL     CACOFilFmtEx  NACOFilFmtEx                                 CGL029
     C**********         MOVEL     CAPWFilFmt    NAPWFilFmt                                   CGL029
     C                   MOVEL     CAPWFilFmt1   NAPWFilFmt1                                  CGL029
     C                   MOVEL     CAPWFilFmtEx  NAPWFilFmtEx                                 CGL029
     C                   MOVE      'Y'           WRITEONLY
     C                   ELSE
      ** NORMAL PRIMARY SCREEN PROCESS
     C                   MOVE      'N'           WRITEONLY
     C                   ENDIF
      *
     C                   MOVE      '0'           @SCRN
     C                   MOVE      *OFF          @INKG
     C                   MOVE      *OFF          @INKH
      *
     C                   ENDIF
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRBLDBRW - Build Browse Subfile
      *****************************************************************
     C     SRBLDBRW      BEGSR
      *
      * Reset Read next browse subfile record
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * Build Browse subfile
     C                   CALLB     'GLAMADBRW'
      *
      * INPUT PARAMETERS :
      * Return Code
      * Review from Account Number
      * Build subfile
      * Read subfile record
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDRFRA
     C                   PARM      'Y'           @BDSFL            1
     C                   PARM      *BLANK        @RDSFL            1
      *
      * OUTPUT PARAMETERS :
      * Error message
      * Option Selected
      * Account Ref. selected
      * Command Keys
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @OPSEL            1
     C**********         PARM      *BLANK        @ACSEL           18                          CGL029
     C                   PARM      *BLANK        @ACSEL                                       CGL029
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *                                                                                       222549
      ** Linked enquiry command keys processing                                               222549
      *                                                                                       222549
     C     MODID         IFEQ      'GL'                                                       222549
     C                   EXSR      #CMDSR                                                     222549
     C                   ENDIF                                                                222549
      *
      * If F3 taken in browse, End Program
     C     @INKC         IFEQ      '1'
     C                   MOVE      'T'           @SCRN
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * If F12 not taken in browse
      * Read next browse subfile record
      *
     C     @INKL         IFNE      '1'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C                   GOTO      EndBLDBRW
     C                   ENDIF
      *
     C     EndBLDBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRDNBRW - Read next Browse Subfile record
      *****************************************************************
     C     SRRDNBRW      BEGSR
      *
      * Read Next Subfile Record
      *
     C                   CALLB     'GLAMADBRW'
      *
      * INPUT PARAMETERS :
      * Return Code
      * Review from Account Number
      * Build subfile
      * Read subfile record
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDRFRA
     C                   PARM      *BLANK        @BDSFL
     C                   PARM      'Y'           @RDSFL
      *
      * OUTPUT PARAMETERS :
      * Error message
      * Option Selected
      * Account Ref. selected
      * Command Keys
     C                   PARM      *BLANK        @ERRMS
     C                   PARM      *BLANK        @OPSEL
     C                   PARM      *BLANK        @ACSEL
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      * If Account read from subfile
     C     @ACSEL        IFNE      *BLANK
      *
      * Retrieve Account details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     @ACSEL        ACKEY
     C                   MOVEL     @ACSEL        DDACCN
     C                   MOVE      WWBRCA        DDBRCA
     C                   MOVE      WWCNUM        DDCUSN
     C                   MOVE      WWCCY         DDCCY
     C                   MOVE      WWACOD        DDACOD
     C                   MOVE      WWACSQ        DDACSQ
     C                   MOVE      *BLANKS       DDACNO
     C                   EXSR      SRRTVACC
      *
      ** IF VALID, WRITE ONLY THE PRIMARY SCREEN AND VALIDATE THE SCREEN
     C     IDX           IFEQ      *ZERO
      *
      ** Convert Account
     C                   EXSR      SRCVTACC
     C                   MOVEL     CrAcFilFmt    NwAcFilFmt
     C                   MOVEL     CABXFilFmt    NABXFilFmt
     C**********         MOVEL     CARIFilFmt    NARIFilFmt                                   CGL029
     C                   MOVEL     CARIFilFmt1   NARIFilFmt1                                  CGL029
     C                   MOVEL     CARIFilFmtEx  NARIFilFmtEx                                 CGL029
     C**********         MOVEL     CACOFilFmt    NACOFilFmt                                   CGL029
     C                   MOVEL     CACOFilFmt1   NACOFilFmt1                                  CGL029
     C                   MOVEL     CACOFilFmtEx  NACOFilFmtEx                                 CGL029
     C**********         MOVEL     CAPWFilFmt    NAPWFilFmt                                   CGL029
     C                   MOVEL     CAPWFilFmt1   NAPWFilFmt1                                  CGL029
     C                   MOVEL     CAPWFilFmtEx  NAPWFilFmtEx                                 CGL029
     C                   MOVE      'Y'           WRITEONLY
     C                   ELSE
      ** NORMAL PRIMARY SCREEN PROCESS
     C                   MOVE      'N'           WRITEONLY
     C                   ENDIF
      *
     C     @OPSEL        IFEQ      'I'
     C     @OPSEL        OREQ      'D'
     C                   MOVE      'K'           @SCRN
     C                   MOVE      C_ANAM        DDANAM
     C                   IF        C_ACNO=*ZERO
     C                   MOVE      *BLANKS       DDACNO
     C                   ELSE
     C                   MOVE      C_ACNO        DDACNO
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '0'           @SCRN
     C                   ENDIF
     C                   EXSR      SFDS@P
      *
      * Else, go to initial screen
      *
     C                   ELSE
     C     DDRFRA        IFEQ      *BLANKS
     C                   EXSR      SRINIT
     C                   ELSE
     C                   MOVE      '0'           @SCRN
     C                   MOVE      'Y'           WRITEONLY
     C                   ENDIF
     C                   ENDIF
      *
     C     EndRDNBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@P - Send a message to primary screen
      *****************************************************************
     C     SNDM@P        BEGSR
      *
      * If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'FXM0292'
     C                   MOVE      'N'           DDACTNOK
     C                   END
      *
      ** Account reference on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'MMM0162'
     C                   MOVE      'N'           DDACCNOK
     C                   END
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C     EndSNDM@P     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRTVACC - Retrieve Account
      *****************************************************************
     C     SRRTVACC      BEGSR
      *
      * Retrieve Account
      *
     C                   CALLB     'GLAMADRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      '      '      @@MODE            6
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      * Action Code
     C                   PARM                    DDACTN
      * Front Office Transaction ID
     C**********         PARM                    FOTRID           20                          CGL029
     C                   PARM                    FOTRID           40                          CGL029
      * (Midas) Account Reference
     C                   PARM                    DDCUSN
     C                   PARM                    DDCCY
     C                   PARM                    DDACOD
     C                   PARM                    DDACSQ
     C                   PARM                    DDBRCA
     C                   PARM                    DDACNO
      * Commissions
     C                   PARM                    CommDisp
      * IBAN                                                                    CFT004
     C                   PARM                    CFT004                         CFT004
     C                   PARM                    DDIBAN                                       238839
     C                   PARM                    CRE015                                     MD021858
     C/COPY OFCPYSRCZ,CRE101_008                                                              CRE101
      *                                                                                       194431
      ** New Accounts Currency                                                                194431
      *                                                                                       194431
     C                   PARM                    WDCCY                                        194431
      * OUTPUTS :
      * (Current) Account in file format
     C                   PARM                    CrAcFilFmt
     C                   PARM                    CABXFilFmt
     C                   PARM                    CARIFilFmt
     C                   PARM                    CACOFilFmt
     C                   PARM                    CAPWFilFmt
     C                   PARM                    ExPPFilFmt                                 MD021858
     C/COPY OFCPYSRCZ,CRE101_026                                                              CRE101
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      * OK - Account Reference
     C                   PARM                    DDCUSNOK
     C                   PARM                    DDCCYOK
     C                   PARM                    DDACODOK
     C                   PARM                    DDACSQOK
     C                   PARM                    DDBRCAOK
     C                   PARM                    DDACNOOK
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ                                       CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD                                       CSD012
      *
     C     EndRTVACC     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCVTACC - Put a Account on the detial screens
      *****************************************************************
     C     SRCVTACC      BEGSR
      *                                                                                       CGL029
      ** Since Valid File and Actual File have some fields in different positions,            CGL029
      ** before calling Convert, this must be mapped correctly                                CGL029
      *                                                                                       CGL029
     C                   MOVEL     CARIFilFmt1   P1RIFilFmt1                                  CGL029
     C                   MOVEL     CARIFilFmtEx  P1RIFilFmtEx                                 CGL029
     C                   MOVEL     CACOFilFmt1   P1COFilFmt1                                  CGL029
     C                   MOVEL     CACOFilFmtEx  P1COFilFmtEx                                 CGL029
     C                   MOVEL     CAPWFilFmt1   P1PWFilFmt1                                  CGL029
     C                   MOVEL     CAPWFilFmtEx  P1PWFilFmtEx                                 CGL029
      *
      * Call program to fill screen fields with data from master files
      *
     C                   CALLB     'GLAMADCVT'
      *
      * INPUTS :
      * Return Code
      * Account in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrAcFilFmt
     C                   PARM                    CABXFilFmt
     C**********         PARM                    CARIFilFmt                                   CGL029
     C**********         PARM                    CACOFilFmt                                   CGL029
     C**********         PARM                    CAPWFilFmt                                   CGL029
     C                   PARM                    P1RIFilFmt                                   CGL029
     C                   PARM                    P1COFilFmt                                   CGL029
     C                   PARM                    P1PWFilFmt                                   CGL029
     C                   PARM                    P1PPFilFmt                                 MD021858
     C/COPY OFCPYSRCZ,CRE101_027                                                              CRE101
      *
      * Commissions
     C                   PARM                    CommDisp
      * CCRM Revenue Analysis                                                   CDE002
     C                   PARM                    CDE002            1            CDE002
      *                                                                         CDE002
      * Retail Details
     C                   PARM                    R_FACH
     C                   PARM                    R_TSTMC
      * OUTPUTS
      * Account - screen formats
     C                   PARM                    NewAcPrim
     C                   PARM                    NewAcDebt
     C                   PARM                    NewAcCrdt
     C                   PARM                    NewAcComm
     C                   PARM                    NewAcOthr
     C                   PARM                    NewAcPena                                  MD021858
     C/COPY OFCPYSRCZ,CRE101_028                                                              CRE101
      *
      * Screen 1 Output
     C                   PARM                    DDDACC            6
     C**********         PARM                    DDLINK           18                          CGL029
     C                   PARM                    DDLINK                                       CGL029
     C                   PARM                    DDFAMT            8
      *
      * Screen 2 Output
     C                   PARM                    DODRCD            6
     C                   PARM                    DOPOLC            6
     C                   PARM                    DOPOLE            6
      *
      * Screen 3 Output
     C                   PARM                    DOCRCD            6
      *
      * Screen 4 Output
     C                   PARM                    DDCEXA1          11
     C                   PARM                    DDCEXB1          11
     C                   PARM                    DDCEXC1          11
     C                   PARM                    DDCEXD1           8
     C                   PARM                    DDCEXE1           8
     C                   PARM                    DDCEXF1           8
     C                   PARM                    DDCEXG1           8
     C                   PARM                    DDDRMG1          12            CDE002
     C                   PARM                    DDCRMG1          12            CDE002
      *
      * Update 'Current' Account with Account in Screen Format
      *
     C                   MOVEL     NewAcPrim     CurAcPrim
     C                   MOVEL     NewAcDebt     CurAcDebt
     C                   MOVEL     NewAcCrdt     CurAcCrdt
     C                   MOVEL     NewAcComm     CurAcComm
     C                   MOVEL     NewAcOthr     CurAcOthr
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPDATE - Updates
      *****************************************************************
     C     SRUPDATE      BEGSR
      *
      * UPDATE VALID Account: CHANGE TYPE
      *
     C                   MOVEL     DDACTN        AMCHTP
      *                                                                                       206824
      ** Retrieve Branch details for IBAN generation method                                   206824
      *                                                                                       206824
     C                   CALL      'AOBRCHR1'                                                 206824
     C                   PARM      *BLANKS       @RTCD                                        206824
     C                   PARM      '*KEY   '     @OPTN                                        206824
     C                   PARM      DDBRCA        @BRCH             3                          206824
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        206824
      *                                                                                       206824
      * DATABASE ERROR                                                                        206824
      *                                                                                       206824
     C     @RTCD         IFNE      *BLANKS                                                    206824
     C                   MOVEL     'SDBRCHPD'    DBFILE                                       206824
     C                   MOVEL     '15'          DBASE                                        206824
     C                   MOVEL     @OPTN         DBKEY                                        206824
     C                   EXSR      *PSSR                                                      206824
     C                   ENDIF                                                                206824
      *                                                                                       206824
      ** Update the File with the unformatted IBAN number.                                    206824
     C     DDIBAN        IFNE      *BLANKS                                                    206824
     C                   CALLB     'AOIBANR3'                                                 206824
     C                   PARM      *BLANKS       @RTCD             7                          206824
     C                   PARM      DDIBAN        @IBAN            47                          206824
     C                   PARM                    @IWITH           47                          206824
     C                   PARM                    @INOBL           34                          206824
     C     @RTCD         IFEQ      *BLANKS                                                    206824
      *                                                                                       206824
     C     DDACTN        IFEQ      'I'                                                        206824
     C                   EVAL      AMIBAN = @INOBL                                            206824
     C                   ENDIF                                                                206824
      *                                                                                       206824
     C     DDACTN        IFEQ      'A'                                                        206824
     C     A8GENM        ANDEQ     '1'                                                        206824
     C                   EVAL      AMIBAN = @INOBL                                            206824
     C                   ENDIF                                                                206824
     C                                                                                        206824
     C                   ELSE                                                                 206824
     C                   EVAL      AMIBAN=*BLANKS                                             206824
     C                   ENDIF                                                                206824
     C                   ENDIF                                                                206824
     C**********         EVAL      AMIBAN = DDIBAN                                     CFT004 206824
     C                   EVAL      AMIBSEQN = DDIBSQ                            CFT004
      *
      * Account UPDATES
      *
     C                   CALLB     'GLAMADUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    RespMode
     C                   PARM                    NwAcFilFmt
     C                   PARM                    NABXFilFmt
     C                   PARM                    NARIFilFmt
     C                   PARM                    NACOFilFmt
     C                   PARM                    NAPWFilFmt
     C                   PARM                    CEU013
     C                   PARM                    CRT001
     C                   PARM                    CRT002
     C                   PARM                    CRE001
     C                   PARM                    CRT101
     C                   PARM                    CFT004                         CFT004
     C                   PARM                    CDE002                         CDE002
     C                   PARM                    R_FACH
     C                   PARM                    R_TSTMC
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
     C/COPY WNCPYSRC,GLAMADSC08
      *
      ** IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      ** UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*RECUPD'
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ENDIF                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
      *
     C/COPY WNCPYSRC,GLAMADSC05
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C/COPY WNCPYSRC,GLAMADSC14
      *
     C     BGN1ST        IFEQ      'Y'
     C                   CALL      'CGC0025'
     C                   PARM      *BLANKS       RTCD
     C                   PARM      'I'           ACTN
     C                   PARM      ACKEY         ACCD
     C                   ENDIF
      *
      ** If Midas-Fontis Interface is switched on, call program to
      ** display Fontis account details.
      *
     C     AMATYP        IFEQ      'R'
     C     CGL004        ANDEQ     'Y'
     C                   CALL      'GLC2800'
     C                   PARM      *BLANK        RTCD
     C                   PARM      ACKEY         ACCD
     C                   PARM      'I'           ACTN
     C                   ENDIF
     C/COPY WNCPYSRC,GLAMADSC19
     C                   ENDIF
      *
      ** If Midas-Risk Weighted Assets feature is switched on,                                CGL018
      ** call program to allow optional entry of RWA codes                                    CGL018
                                                                                              CGL018
     C     CGL018        IFEQ      'Y'                                                        CGL018
     C                   CALL      'GLC001240'                                                CGL018
     C                   PARM      *BLANK        RTCD                                         CGL018
     C                   PARM      @DDACCN       ACCD                                         CGL018
     C                   PARM      'I'           ACTN                                         CGL018
     C                   ENDIF                                                                CGL018
      *                                                                                       CGL018
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
      *
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C                   END
      *
      ** IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ** ELSE, GO TO INITIAL SCREEN
      *
     C                   EXSR      SRINIT
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINIT - Go To Initial Screen
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Blank the screens
      *
     C                   MOVEL     *BLANK        NewAcPrim
     C                   MOVEL     *BLANK        NewAcDebt
     C                   MOVEL     *BLANK        NewAcCrdt
     C                   MOVEL     *BLANK        NewAcComm
     C                   MOVEL     *BLANK        NewAcOthr
     C/COPY WNCPYSRC,GLAMADSC21
      *
      ** Primary Details Screen
      *
     C                   MOVE      '0'           @SCRN             1
     C                   MOVE      'N'           WRITEONLY
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     '0'           @INKJ
      *
      ** Enable Roll Function Keys
     C                   MOVEL     'Y'           @EIN25            1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
                                                                                              CSD012
      * Override SDAULGL0                                                                     CSD012
     C                   Z-ADD     50            CMDLEN           15 5                        CSD012
     C                   CALL      'QCMDEXC'                                                  CSD012
     C                   PARM                    CMD                                          CSD012
     C                   PARM                    CMDLEN                                       CSD012
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLAMADSIN '  DBPGM
     C                   OUT       LDA
      *
      **  GET RUNDAT to access multi-branching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Retail III Table file
     C     BGNXST        IFEQ      'Y'
     C     BGNYST        OREQ      'Y'
     C                   READ      TABTBRE                                80
     C     *IN80         IfEq      '1'
     C     R_RECI        OrNE      'D'
     C     *LOCK         IN        LDA
     C                   MOVEL     'TABTBRE '    DBFILE
     C                   Z-ADD     4             DBASE
     C                   MOVEL     *Blanks       DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Check commissions if present.
     C     R_CDTO        IFEQ      'Y'
     C     R_CHOV        OREQ      'Y'
     C     R_FXAC        OREQ      'Y'
     C     R_CNDS        OREQ      'Y'
     C     R_CDRI        OREQ      'Y'
     C     R_CMBL        OREQ      'Y'
     C     R_CINA        OREQ      'Y'
     C                   MOVE      'Y'           CommDisp          1
     C                   ELSE
     C                   MOVE      'N'           CommDisp
     C                   ENDIF
      *
      ** Access SAR details file to determine if CGL004 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'CGL004'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CGL004            1
     C                   ELSE
     C                   MOVEL     'N'           CGL004
     C                   END
      *
      ** Access SAR details file to determine if S01446 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU013'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     6             DBASE
     C                   MOVEL     'CEU013'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU013            1
     C                   ELSE
     C                   MOVEL     'N'           CEU013
     C                   END
      *
      ** Access SAR details file to determine if CRE001 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRE001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     7             DBASE
     C                   MOVEL     'CRE001'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRE001            1
     C                   ELSE
     C                   MOVEL     'N'           CRE001
     C                   END
      *
      ** Access SAR details file to determine if CRT001 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     8             DBASE
     C                   MOVEL     'CRT001'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT001            1
     C                   ELSE
     C                   MOVEL     'N'           CRT001
     C                   END
      *                                                                         CAP050
      ** Access SAR details file to determine if CRT002 is on.                  CAP050
      *                                                                         CAP050
     C                   CALLB     'AOSARDR0'                                   CAP050
     C                   PARM      *BLANKS       @RTCD                          CAP050
     C                   PARM      '*VERIFY'     @OPTN                          CAP050
     C                   PARM      'CRT002'      @SARD                          CAP050
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP050
      *                                                                         CAP050
      * Database Error                                                          CAP050
      *                                                                         CAP050
     C     @RTCD         IFNE      *BLANKS                                      CAP050
     C     @RTCD         ANDNE     '*NRF   '                                    CAP050
     C                   MOVEL     'SCSARDPD'    DBFILE                         CAP050
     C                   Z-ADD     9             DBASE                          CAP050
     C                   MOVEL     'CRT002'      DBKEY                          CAP050
     C                   EXSR      *PSSR                                        CAP050
     C                   END                                                    CAP050
      *                                                                         CAP050
     C     @RTCD         IFEQ      *BLANK                                       CAP050
     C                   MOVEL     'Y'           CRT002            1            CAP050
     C                   ELSE                                                   CAP050
     C                   MOVEL     'N'           CRT002                         CAP050
     C                   END                                                    CAP050
      *
      ** Access SAR details file to determine if CRT101 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT101'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     10            DBASE
     C                   MOVEL     'CRT101'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT101            1
     C                   ELSE
     C                   MOVEL     'N'           CRT101
     C                   END
      *                                                                         CFT004
      ** Access SAR details file to determine if CFT004 is on.                  CFT004
      *                                                                         CFT004
     C                   CALLB     'AOSARDR0'                                   CFT004
     C                   PARM      *BLANKS       @RTCD                          CFT004
     C                   PARM      '*VERIFY'     @OPTN                          CFT004
     C                   PARM      'CFT004'      @SARD                          CFT004
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT004
      *                                                                         CFT004
      * Database Error                                                          CFT004
      *                                                                         CFT004
     C     @RTCD         IFNE      *BLANKS                                      CFT004
     C     @RTCD         ANDNE     '*NRF   '                                    CFT004
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT004
     C                   Z-ADD     10            DBASE                          CFT004
     C                   MOVEL     'CFT004'      DBKEY                          CFT004
     C                   EXSR      *PSSR                                        CFT004
     C                   END                                                    CFT004
      *                                                                         CFT004
     C     @RTCD         IFEQ      *BLANK                                       CFT004
     C                   MOVEL     'Y'           CFT004            1            CFT004
     C                   ELSE                                                   CFT004
     C                   MOVEL     'N'           CFT004                         CFT004
     C                   END                                                    CFT004
      *                                                                         CDE002
      ** Access SAR details file to determine if CDE002 is on.                  CDE002
      *                                                                         CDE002
     C                   CALLB     'AOSARDR0'                                   CDE002
     C                   PARM      *BLANKS       @RTCD                          CDE002
     C                   PARM      '*VERIFY'     @OPTN                          CDE002
     C                   PARM      'CDE002'      @SARD                          CDE002
     C     SCSARD        PARM      SCSARD        DSFDY                          CDE002
      *                                                                         CDE002
      * Database Error                                                          CDE002
      *                                                                         CDE002
     C     @RTCD         IFNE      *BLANKS                                      CDE002
     C     @RTCD         ANDNE     '*NRF   '                                    CDE002
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDE002
     C                   Z-ADD     12            DBASE                          CDE002
     C                   MOVEL     'CDE002'      DBKEY                          CDE002
     C                   EXSR      *PSSR                                        CDE002
     C                   END                                                    CDE002
      *                                                                         CDE002
     C     @RTCD         IFEQ      *BLANK                                       CDE002
     C                   MOVEL     'Y'           CDE002            1            CDE002
     C                   ELSE                                                   CDE002
     C                   MOVEL     'N'           CDE002                         CDE002
     C                   END                                                    CDE002
      *                                                                         CRE007
      ** Access SAR details file to determine if CRE007 is on.                  CRE007
      *                                                                         CRE007
     C                   CALLB     'AOSARDR0'                                   CRE007
     C                   PARM      *BLANKS       @RTCD                          CRE007
     C                   PARM      '*VERIFY'     @OPTN                          CRE007
     C                   PARM      'CRE007'      @SARD                          CRE007
     C     SCSARD        PARM      SCSARD        DSFDY                          CRE007
      *                                                                         CRE007
      * Database Error                                                          CRE007
      *                                                                         CRE007
     C     @RTCD         IFNE      *BLANKS                                      CRE007
     C     @RTCD         ANDNE     '*NRF   '                                    CRE007
     C                   MOVEL     'SCSARDPD'    DBFILE                         CRE007
     C                   Z-ADD     11            DBASE                          CRE007
     C                   MOVEL     'CRE007'      DBKEY                          CRE007
     C                   EXSR      *PSSR                                        CRE007
     C                   END                                                    CRE007
      *                                                                         CRE007
     C     @RTCD         IFEQ      *BLANK                                       CRE007
     C                   MOVE      'Y'           CRE007            1            CRE007
     C                   ELSE                                                   CRE007
     C                   MOVE      'N'           CRE007                         CRE007
     C                   END                                                    CRE007
     C/COPY WNCPYSRC,GLAMADSC20
      *                                                                                       CGL018
      ** Access SAR details file to determine if CGL018 is on.                                CGL018
      *                                                                                       CGL018
     C                   CALLB     'AOSARDR0'                                                 CGL018
     C                   PARM      *BLANKS       @RTCD                                        CGL018
     C                   PARM      '*VERIFY'     @OPTN                                        CGL018
     C                   PARM      'CGL018'      @SARD                                        CGL018
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL018
      *                                                                                       CGL018
      * Database Error                                                                        CGL018
      *                                                                                       CGL018
     C     @RTCD         IFNE      *BLANKS                                                    CGL018
     C     @RTCD         ANDNE     '*NRF   '                                                  CGL018
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL018
     C                   Z-ADD     12            DBASE                                        CGL018
     C                   MOVEL     'CGL018'      DBKEY                                        CGL018
     C                   EXSR      *PSSR                                                      CGL018
     C                   END                                                                  CGL018
      *                                                                                       CGL018
     C     @RTCD         IFEQ      *BLANK                                                     CGL018
     C                   MOVE      'Y'           CGL018            1                          CGL018
     C                   ELSE                                                                 CGL018
     C                   MOVE      'N'           CGL018                                       CGL018
     C                   END                                                                  CGL018
      *                                                                                       CSD012
      ** Access SAR details file to determine if CSD012 is on.                                CSD012
      *                                                                                       CSD012
     C                   CALLB     'AOSARDR0'                                                 CSD012
     C                   PARM      *BLANKS       @RTCD                                        CSD012
     C                   PARM      '*VERIFY'     @OPTN                                        CSD012
     C                   PARM      'CSD012'      @SARD                                        CSD012
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD012
      *                                                                                       CSD012
     C     @RTCD         IFEQ      *BLANK                                                     CSD012
     C                   MOVE      'Y'           CSD012                                       CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           CSD012                                       CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
      ** If CSD012 is ON, Check if Account Authorisation is ON                                CSD012
 B1  C     CSD012        IFEQ      'Y'                                                        CSD012
      *                                                                                       CSD012
     C                   CALL      'AOSVALR0'                                                 CSD012
     C                   PARM                    @RTCD                                        CSD012
     C                   PARM      SVALKK        SVALK1           20                          CSD012
     C                   PARM                    SVAL1           200                          CSD012
     C                   PARM                    SVALK2           20                          CSD012
     C                   PARM                    SVAL2           200                          CSD012
     C                   PARM                    SVALK3           20                          CSD012
     C                   PARM                    SVAL3           200                          CSD012
     C                   PARM                    SVALK4           20                          CSD012
     C                   PARM                    SVAL4           200                          CSD012
     C                   PARM                    SVALK5           20                          CSD012
     C                   PARM                    SVAL5           200                          CSD012
     C                   PARM                    SVALK6           20                          CSD012
     C                   PARM                    SVAL6           200                          CSD012
     C                   PARM                    SVALK7           20                          CSD012
     C                   PARM                    SVAL7           200                          CSD012
     C                   PARM                    SVALK8           20                          CSD012
     C                   PARM                    SVAL8           200                          CSD012
     C                   PARM                    SVALK9           20                          CSD012
     C                   PARM                    SVAL9           200                          CSD012
     C                   PARM                    SVALK0           20                          CSD012
     C                   PARM                    SVAL10          200                          CSD012
      *                                                                                       CSD012
     C     @RTCD         IFNE      *BLANKS                                                    CSD012
                                                                                              CSD012
     C     SVAL10        IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK0        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL9         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK9        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL8         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK8        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL7         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK7        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL6         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK6        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL5         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK5        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL4         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK4        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL3         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK3        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL2         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK2        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
     C     SVAL1         IFEQ      '*NRF'                                                     CSD012
     C                   MOVE      SVALK1        DBKEY                                        CSD012
     C                   ENDIF                                                                CSD012
                                                                                              CSD012
     C     *LOCK         IN        LDA                                                        CSD012
     C                   Z-ADD     13            DBASE                                        CSD012
     C                   MOVE      'SDSVALPD'    DBFILE                                       CSD012
     C                   MOVE      'GLAMADSIN'   DBPGM                                        CSD012
     C                   OUT       LDA                                                        CSD012
     C                   EXSR      *PSSR                                                      CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** If Account Authorisation is On set to Authorise                                      CSD012
     C     SVAL11        IFEQ      'Y'                                                        CSD012
     C                   MOVE      'Y'           AUTHRQ            1                          CSD012
     C                   ELSE                                                                 CSD012
     C                   MOVE      'N'           AUTHRQ                                       CSD012
     C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
 E1  C                   ENDIF                                                                CSD012
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        @RTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   EVAL      WCMTSK = 'N'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
                                                                                              CSC022
     C                   IF        COMITNUM > 0                                               CSC022
                                                                                              CSC022
     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
                                                                                              CSC022
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
     C                   IF        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 14                                                 CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
      *                                                                                       CRE030
      ** Check if feature CRE030 is active                                                    CRE030
      *                                                                                       CRE030
     C                   CALL      'AOSARDR0'                                                 CRE030
     C                   PARM      '       '     @RTCD             7                          CRE030
     C                   PARM      '*VERIFY'     @OPTN             7                          CRE030
     C                   PARM      'CRE030'      @SARD             6                          CRE030
     C*                                                                                       CRE030
     C                   IF        @RTCD = *BLANKS                                            CRE030
     C                   MOVE      'Y'           CRE030            1                          CRE030
     C                   ELSE                                                                 CRE030
     C                   MOVE      'N'           CRE030                                       CRE030
     C                   ENDIF                                                                CRE030
      *                                                                                      LLN022A
      ** Access Switchable SAR details for the existence                                     LLN022A
      ** of LLN022 (Bank of England)                                                         LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANK        @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN022'      @SARD                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *BLANK                                            LLN022A
     C                   MOVE      'Y'           LLN022            1                         LLN022A
     C                   ELSE                                                                LLN022A
     C                   MOVE      'N'           LLN022            1                         LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                     BUG22742
      ** Access SAR details file to determine if CER048 is on.                              BUG22742
      *                                                                                     BUG22742
     C                   EVAL      CER048 = 'N'                                             BUG22742
      *                                                                                     BUG22742
     C                   CALL      'AOSARDR0'                                               BUG22742
     C                   PARM      *BLANKS       @RTCD                                      BUG22742
     C                   PARM      '*VERIFY'     @OPTN                                      BUG22742
     C                   PARM      'CER048'      @SARD                                      BUG22742
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG22742
      *                                                                                     BUG22742
     C                   IF        @RTCD <> *BLANKS AND                                     BUG22742
     C                             @RTCD <> '*NRF'                                          BUG22742
     C     *LOCK         IN        LDA                                                      BUG22742
     C                   EVAL      DBPGM = 'GLAMADVU'                                       BUG22742
     C                   EVAL      DBKEY = 'CER048'                                         BUG22742
     C                   EVAL      DBFILE ='SCSARDPD'                                       BUG22742
     C                   EVAL      DBASE  = 15                                              BUG22742
     C                   OUT       LDA                                                      BUG22742
     C                   EXSR      *PSSR                                                    BUG22742
     C                   ENDIF                                                              BUG22742
      *                                                                                     BUG22742
     C     @RTCD         IFEQ      *BLANK                                                   BUG22742
     C                   MOVEL     'Y'           CER048                                     BUG22742
     C                   ENDIF                                                              BUG22742
      *
      ** Prepare Amend Authorisation
      *
     C                   MOVE      *OFF          *IN41
     C                   MOVE      'A'           @ZACTN
     C     BJSBRC        IFNE      *BLANKS
     C                   EXSR      SRAUTH
     C     @ERR          IFEQ      0
     C                   MOVE      *ON           *IN41
     C                   ENDIF
     C                   ELSE
     C                   MOVE      *ON           *IN41
     C                   END
      *
      * GO TO INITIAL SCREEN
      *
     C                   EXSR      SRINIT
      *
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,GLAMADS002
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************                    222549
      *                                                                  *                    222549
      *    #CMDSR - PROCESS COMMAND KEYS                                 *                    222549
      *                                                                  *                    222549
      *    CALLS:     #RETSR - END OF PROGRAM PROCESSING                 *                    222549
      *                                                                  *                    222549
      *    THIS IS A STANDARD LINK ENQUIRY SUBROUTINE FOR PROCESSING     *                    222549
      *    THE COMMAND KEYS                                              *                    222549
      *                                                                  *                    222549
      ********************************************************************                    222549
      *                                                                                       222549
     C     #CMDSR        BEGSR                                                                222549
      *                                                                                       222549
      ** SET DATA AREA WORK FIELD RTNDWF TO BLANKS                                            222549
      *                                                                                       222549
     C                   MOVE      *BLANK        RTNDWF            1                          222549
      *                                                                                       222549
      ** IF F3 PRESSED, RETURN TO MENU                                                        222549
      *                                                                                       222549
     C     @INKC         IFEQ      '1'                                                        222549
     C                   MOVE      'Q'           RTNDWF                                       222549
     C                   EXSR      #RETSR                                                     222549
     C                   ENDIF                                                                222549
      *                                                                                       222549
      ** IF F9 PRESSED, RETURN TO INITIAL ENQUIRY                                             222549
      *                                                                                       222549
     C     @INKI         IFEQ      '1'                                                        222549
     C                   MOVE      'S'           RTNDWF                                       222549
     C                   EXSR      #RETSR                                                     222549
     C                   ENDIF                                                                222549
      *                                                                                       222549
      ** IF F12 PRESSED, RETURN TO PREVIOUS ENQUIRY                                           222549
      *                                                                                       222549
     C     @INKL         IFEQ      '1'                                                        222549
     C                   MOVE      'U'           RTNDWF                                       222549
     C                   EXSR      #RETSR                                                     222549
     C                   ENDIF                                                                222549
      *                                                                                       222549
     C                   ENDSR                                                                222549
      *                                                                                       222549
     C********************************************************************                    222549
      /EJECT                                                                                  222549
      ********************************************************************                    222549
      *                                                                  *                    222549
      *    #RETSR - END OF PROGRAM PROCESSING                            *                    222549
      *                                                                  *                    222549
      *    CALLED BY: #CMDSR - PROCESS COMMAND KEYS                      *                    222549
      *               *PSSR - ERROR PROCESSING                           *                    222549
      *    CALLS:                                                        *                    222549
      *                                                                  *                    222549
      ********************************************************************                    222549
      *                                                                                       222549
     C     #RETSR        BEGSR                                                                222549
      *                                                                                       222549
      ** SET ON LR                                                                            222549
      *                                                                                       222549
     C                   MOVE      '1'           *INLR                                        222549
      *                                                                                       222549
      ** ACCESS EM DATA AREA                                                                  222549
      *                                                                                       222549
     C     *LOCK         IN        EMSDS                                                      222549
     C                   MOVE      RTNDWF        RETND                                        222549
     C                   OUT       EMSDS                                                      222549
      *                                                                                       222549
     C                   RETURN                                                               222549
      *                                                                                       222549
     C                   ENDSR                                                                222549
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
     C/COPY WNCPYSRC,GLAMADSC23
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** CMD
OVRDBF FILE(SDAULGL0) TOFILE(SDAULGL0) SHARE(*NO)
