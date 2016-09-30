     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV transaction details validation')         *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEDPMVVAL - Transaction Details Validation Module            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD037824           Date 09Mar16               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CSW210             Date 04May10               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244007             Date 01Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027A            Date 05May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10469           Date 15Mar06               *
      *                 BUG10520           Date 09Feb06               *
      *                 CAP087             Date 05Sep05               *
      *                 CSE075             Date 17Nov05               *
      *                 237063             Date 20Nov05               *
      *                 BUG8550            Date 07Oct05               *
      *                 CGL035             Date 01Mar05               *
      *                 235546             Date 27Jul05               *
      *                 234916             Date 13Jul05               *
      *                 234691             Date 05Jul05               *
      *                 234577             Date 28Jun05               *
      *                 234552             Date 26Jun05               *
      *                 234440             Date 24Jun05               *
      *                 236705             Date 18Jun05               *
      *                 236703             Date 15Jun05               *
      *                 236702             Date 13Jun05               *
      *                 233698             Date 25May05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG3122            Date 17Jul04               *
      *                 BUG2392            Date 15Jun03               *
      *                 CGL029             Date 01Sep03               *
      *                 222321             Date 13Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 222727             Date 05Nov03               *
      *                 212599             Date 21Mar03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 208940             Date 30Aug02               *
      *                 207006             Date 18Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 183296             Date 30Mar01               *
      *                 187544             Date 11Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      *                 176680             Date 14Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      *                 CAP039             Date 29Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSE015             Date 06Dec99               *
      *                 CSE017             Date 20Oct99               *
      *                 CSE012             Date 16Aug99               *
      *                 CPB001             DATE 18Aug99               *
      *                 167262             Date 08Sep99               *
      *                 CGL011             Date 20Sep99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CSE010             Date 21Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP004             Date 09Sep98               *
      *                 CAP003  *CREATE    Date 07May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD037824 - Mismatch in value date between repo deal and depot*
      *             movement. Remove checking of DDDRID to always do  *
      *             validation of Associated Deal Number field.       *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  244007 - Add repo indicator from repurchased agreement input.*
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10469 - Fees functionality missing from Bond Lending /    *
      *             Bond Borrowing input.                             *
      *  BUG10520 - Validate SE Shortname first.                      *
      *  CAP087 - Depot Movement - Java Wrapper in Midasplus.         *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CGL035 - EUSD Upgrade to Midasplus                           *
      *  235546 - EU Tax backvaluations                               *
      *  234916 - Incorrect set up of Cum/Ex indicator                *
      *  234691 - Fixes EU Taxes - block deletions of depot movements *
      *  234577 - Blocking problems                                   *
      *  234552 - Corrections to 234440                               *
      *  234440 - Any input, amendment or reversal of backvalued      *
      *           transactions are blocked if they are prior to a     *
      *           previous, unreversed transaction for a security     *
      *           that is taxable and a customer who is liable for tax*
      *  236705 - original purchase date should default to average    *
      *           purchase date                                       *
      *  236703 - original purchase date should not be greater than   *
      *           trade date of the walk in                           *
      *  236702 - Need to default the original purchased interest if  *
      *           the original purchase date has changed and the      *
      *           original purchased interest has not.                *
      *  233698 - Change Control for CGL031                           *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSD025 - Customer De-Activation                              *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  BUG2392- Enable defaulting of market center                  *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  222321 - Replacing SEVTRDT with SEVTTRDDT.                   *
      *         - Incorrect field name used in error array because   *
      *           of the change in validation Module.                 *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  212599 - Swift Market Centre not appearing in ISO15022 msg.  *
      *  208940 - Add Parameters when calling SEVTCUST.               *
      *  207006 - Add Counterparty & Market Centre to SSI             *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSE022 - Depository Definition Enhancement (Recompile)       *
      *  183296 - '?' processing in Beneficial Customer dosen't work  *
      *           correctly.                                          *
      *  187544 - Depot Mvts - WI & WO: Review display of some        *
      *           PM/PB fields                                        *
      *  CSE023 - Treaty Withholding Tax                              *
      *  176680 - Error in Switchable feature processing              *
      *           - features are always set on.                       *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CAP039 - Security customer details API. Fields added to      *
      *           SDSECSPD (recompile)                                *
      *  CSE015 - Forward Valued Depot Movements                      *
      *  CSE017 - Cum/Ex Indicator on Depot Movements                 *
      *  CSE012 - SE Depot Movement Narratives (Recompiled).          *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *         - 'Private Banking' Module                            *
      *  167262 - Blanking out charge details on depot moves does not *
      *           reset data                                          *
      *  CGL011 - Collateral Processing for Midas                     *
      *  CSE010 - SE Transactions Enhancements.                       *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SEDPMVV035
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the SE standard declares
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
 
      ***The*fields*below*are*not*related*to*a*Walk-In*or************************************ CAP087
      ***Walk-Out*transaction*and*are*appropriately*set*to*Blanks.*************************** CAP087
      *                                                                                       CAP087
      *                                                                                       CAP087
     D***IVldEntry       DS                                                                   CAP087
     D*DDDPAD******************1      6A                                                      CAP087
     D*DDRPIN******************7      7A                                                      CAP087
     D*DDSWRF******************8     10A                                                      CAP087
     D*DDSIOI*****************11     11A                                                      CAP087
 
      ** This include member declares the arrays for overall error
      ** message handling in Midas APIs
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** The maximum size of the appended error arrays
      ** Array of Fields in error.
      ** Array of error message IDs
      ** Array of error message data.
      ** Array of Fields with warnings.
      ** Array of warning message IDs
      ** Array of warning message data.
 
     D/COPY ZACPYSRC,ERR_XARRYS                                                               222321
     D*XArrayMax*******C                   CONST(20)                                          222321
     D*FldNamXAr*******S             10A   DIM(XArrayMax)                                     222321
     D*MsgIDXAr********S                   DIM(XArrayMax) LIKE(#MsgId)                        222321
     D*MsgDtaXAr*******S                   DIM(XArrayMax) LIKE(#MsgData)                      222321
     D*WFldNmXAr*******S             10A   DIM(XArrayMax)                                     222321
     D*WMsgIDXAr*******S                   DIM(XArrayMax) LIKE(#MsgId)                        222321
     D*WMsgDtXAr*******S                   DIM(XArrayMax) LIKE(#MsgData)                      222321
 
      ** The following /COPY includes the customer details data structure                     207006
     D/COPY SECPYSRC,SE_CUSTDT                                                                207006
 
      ** Transaction Details
      ** Transaction Details Ok indicator
      ** Valid Transaction Details File Format
 
     D SETransDtl    E DS                  EXTNAME(SEDMWIPD)
     D DDDEPOT       E                     EXTFLD(DDDPID)
     D DDDATE        E                     EXTFLD(DDDPMD)
     D ChargeDtls            136    171
 
     D SEErFldF      E DS                  EXTNAME(SEEDMWIPD)
     D DDDepotOk     E                     EXTFLD(DDDPIDOK)
     D DDDateOk      E                     EXTFLD(DDDPMDOK)
 
     D SEValidF      E DS                  EXTNAME(DPTMVD)
 
 
      ** Branch Details
      ** External DS for Bank Details
      ** Securities Trading Data
      ** General ledger details
      ** External DS for Midas modules details
      ** Portfolio Management Details
      ** Currency Details
      ** Portfolio Customer Details
      ** Portfolio Definition Details
      ** Security ICD Details
      ** Security Details
      ** Investment Type Details
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
     D PORTDET       E DS                  EXTNAME(PMPORTPD)
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
     D   OldAcctCd   E                     EXTFLD(QQACCD)                                     CGL029
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  234552
     D CUST_DFAC     E                     EXTFLD(QQDFAC)                                     CGL035
                                                                                              CGL035
     D SECTY         E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(SEC_)
 
     D INVTPDts      E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
 
      ** DS for Access programs, short DS
      ** DS for Access Programs, long DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              234552
      ** DS for Access Programs, (very Long DS)                                               234552
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     234552
                                                                                              234552
    2** Input parameters on call to AOPLCSR1                                                  234552
                                                                                              234552
     D I@PARM          DS           256                                                       234552
     D  I#PORS                 1      1                                                       234552
     D  I#R997                 2      5                                                       234552
     D  I#CUST                 6     15                                                       234552
     D  I#BRCA                16     18                                                       234552
     D  I#BOOK                19     20                                                       234552
     D  I#PTFR                21     24                                                       234552
     D  I#CPGM                25     34                                                       234552
      *                                                                                       234552
      ** Output parameters on call to AOPLCSR1                                                234552
      *                                                                                       234552
     D O@PARM          DS           256                                                       234552
     D  O#BOOK                 1      2                                                       234552
     D  O#PTFR                 3      6                                                       234552
     D  O#BICN                 7     12                                                       234552
     D  O#CRNM                13     22                                                       234552
     D  O#ACOF                23     24                                                       234552
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SDSTAT data area                                                                     CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** External DS for SAR Details                                                          CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D  SCA_LCD      E                     EXTFLD(LCD)                                        CSC011
                                                                                              CSC011
      ** Data structure for MULTIBRANCH Indicator using rundat.
     D RUNDAT          DS
     D  RunDate                8     10P 0
     D  MBIN                  13     13
 
      ** Data Area of Menu User
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
      ** Nominal Currency Details
 
     D NomCcyDts       DS
     D  NomCcySPRT             1     13  8
     D  NomCcyDec             14     14P 0
     D  NomCcyMDIN            15     15
     D  NomCcyNQDP            16     16  0
     D  NomCcySWCY            17     19
     D  NomCcyCDFN            20     21
     D  NomCcyECDN            22     23
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(SEDMEXPD)                    CAP004
      * SE Depot Movements Extra Data - File (D/B) format                       CAP004
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                CPB001
      ** Purchased Interest save field                                          CPB001
     D DDPINTSAVE      S             13P 0                                      CPB001
 
      ** Charge Currency no. of Decimal Places
     D ChrCurDP        S              1S 0
 
      ** Index for arrays of error message ids etc
      ** Index for arrays of of warning message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Index for arrays
     D I               S              3P 0
 
     D CSC011          S              1A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
     D Dpmv_Date       S                   LIKE(BJRDNB)                                       234440
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                              CAP087
      ** Work fields for comparing old and new values (amend process)                         CAP087
     D*OldDPID**       S              6S 0                                            CAP087 CSD027A
     D OldDPID         S              6A                                                     CSD027A
     D OldDPMD         S              5P 0                                                    CAP087
     D*OldDPOD**       S              6S 0                                            CAP087 CSD027A
     D OldDPOD         S              6A                                                     CSD027A
     D OldDPDO         S              5P 0                                                    CAP087
     D OldDPBA         S              3A                                                      CAP087
     D OldDPBK         S              2A                                                      CAP087
     D OldDPNA         S             11P 0                                                    CAP087
     D OldMKTP         S             15P 8                                                    CAP087
                                                                                              CSC011
      ** Work field to save original values before call to SRFXRATE (for repos)               CAP087
     D @PNPTCY         S              1A                                                      CAP087
     D @BGN4ST         S              1A                                                      CAP087
     D @BGPFMG         S              1A                                                      CAP087
     D @DDPTFROk       S              3A                                                      CAP087
     D @WWPLCS         S              1A                                                      CAP087
                                                                                              CAP087
      ** Associated Deal Currency code (output from SEVDPMVAD)                                CAP087
     D DealCcy         S              3A                                                      CAP087
                                                                                              CAP087
      ** CGL031                                                                               CGL031
     D CGL031          S              1A                                                      CGL031
     D WRKFSPI         S             15  9                                                    CGL031
     D*WCust****       S              6S 0                                            234440 CSD027A
     D WCust           S              6A                                                     CSD027A
                                                                                              CGL031
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SEDPMVV036
 
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
      /COPY WNCPYSRC,SEDPMVV001
      *
      ** Initialization
      *
                                                                                             BUG8550
      ** In the DataArea ZMUSER                                                              BUG8550
      *                                                                                      BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
      *                                                                                      BUG8550
     C                   EXSR      SRInit
      *
      /COPY WNCPYSRC,SEDPMVV002
      *
      ** '?' in Beneficial Customer.                                                          183296
      *                                                                                       183296
     C                   MOVEL     DDDPBN        @STP              1                          183296
     C     @STP          IFEQ      '?'                                                        183296
     C                   MOVEL     DDDPBN        @AENB                                        183296
     C                   CALLB     'AOSECSR0'                                                 183296
     C                   PARM      *BLANKS       @RTCD             7                          183296
     C                   PARM      '*KEY   '     @OPTN             7                          183296
     C                   PARM                    @AENB             6                          183296
     C     SDSECS        PARM      SDSECS        DSSDY                                        183296
     C*                                                                                       183296
     C                   MOVE      *BLANKS       DDDPBN                                       183296
     C     @RTCD         IFEQ      *BLANKS                                                    183296
     C                   MOVEL     BFCUST        DDDPBN                                       183296
     C                   END                                                                  183296
     C                   END                                                                  183296
      *                                                                                       207006
      ** '?' in Counterparty                                                                  207006
      *                                                                                       207006
     C                   MOVEL     DDCPTY        @STP              1                          207006
     C     @STP          IFEQ      '?'                                                        207006
     C                   MOVEL     DDCPTY        @AENB                                        207006
     C                   CALLB     'AOSECSR0'                                                 207006
     C                   PARM      *BLANKS       @RTCD             7                          207006
     C                   PARM      '*KEY   '     @OPTN             7                          207006
     C                   PARM                    @AENB             6                          207006
     C     SDSECS        PARM      SDSECS        DSSDY                                        207006
     C*                                                                                       207006
     C                   MOVE      *BLANKS       DDCPTY                                       207006
     C     @RTCD         IFEQ      *BLANKS                                                    207006
     C                   MOVEL     BFCUST        DDCPTY                                       207006
     C                   END                                                                  207006
     C                   END                                                                  207006
      ** Validation
      *
     C                   EXSR      SRDetVal
      *
      ** Return
      *
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SEDPMVV037
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRDetVal - Transaction Details Validation Routine             *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SRInDepot     SRBBranch      SRNominal    SRAveYield   *
      *        SRInDate      SROrBranch     SRPrice      SRFXRate     *
      *        SROutDate     SRBookCde      SRPortRef    SRProfCtr    *
      *        SROutDepot    SRCustomer     SRCustMDIn   SRChrgSet    *
      *********SRCumEx       SRTradeDte                               *                CSE015 207006
      *        SRCumEx       SRTradeDte     SRMktCnt     SRCtrpty     *                       207006
      *                                                               *
      *****************************************************************
 
     C     SRDetVal      BEGSR
      *****************************************************************              234691 BUG10520
      ***Block*back*value*depot*movement*******************************              234691 BUG10520
      *****************************************************************              234691 BUG10520
     C**********         IF        CGL031 = 'Y' AND DDACTN = 'D'                     234691 BUG10520
     C**********         EXSR      SRTaxDate                                         234691 BUG10520
     C**********         GOTO      EDetVal                                           234691 BUG10520
     C**********         ENDIF                                                       234691 BUG10520
      *
      ** Security Validation
     C                   EXSR      SRSecurity
      *
      ** Do not proceed if Security is in error
      *
     C                   IF        DDDPSSOk = 'Y'
                                                                                            BUG10520
      ** Block back value depot movement                                                    BUG10520
                                                                                            BUG10520
     C                   IF        CGL031 = 'Y' AND DDACTN = 'D'                            BUG10520
     C                   EXSR      SRTaxDate                                                BUG10520
     C                   GOTO      EDetVal                                                  BUG10520
     C                   ENDIF                                                              BUG10520
 
     C     DPMVType      IFEQ      'WI'
      *
      ** In Depot
      /COPY WNCPYSRC,SEDPMVV003
     C                   EXSR      SRInDepot
      /COPY WNCPYSRC,SEDPMVV004
      *
      ** In Date
      /COPY WNCPYSRC,SEDPMVV005
     C                   EXSR      SRInDate
      /COPY WNCPYSRC,SEDPMVV006
     C                   END
 
     C     DPMVType      IFEQ      'WO'
      *
      ** Out Depot
      /COPY WNCPYSRC,SEDPMVV007
     C                   EXSR      SROutDepot
      /COPY WNCPYSRC,SEDPMVV008
      *
      ** Out Date
      /COPY WNCPYSRC,SEDPMVV009
     C                   EXSR      SROutDate
      /COPY WNCPYSRC,SEDPMVV010
     C                   END
                                                                                              CAP087
      ** Validate Repos and Depot Transfers                                                   CAP087
                                                                                              CAP087
     C     DPMVType      IFEQ      'BB'                                                       CAP087
     C     DPMVType      OREQ      'RR'                                                       CAP087
     C     DPMVType      OREQ      'PL'                                                       CAP087
     C     DPMVType      OREQ      'BL'                                                       CAP087
     C     DPMVType      OREQ      'RP'                                                       CAP087
     C     DPMVType      OREQ      'PD'                                                       CAP087
     C     DPMVType      OREQ      'DT'                                                       CAP087
                                                                                              CAP087
      ** If amend, save original values for later validation                                  CAP087
     C     DDACTN        IFEQ      'A'                                                        CAP087
     C                   EVAL      OldDPID = DPID                                             CAP087
     C                   EVAL      OldDPMD = DPMD                                             CAP087
     C                   EVAL      OldDPOD = DPOD                                             CAP087
     C                   EVAL      OldDPDO = DPDO                                             CAP087
     C                   EVAL      OldDPBA = DPBA                                             CAP087
     C                   EVAL      OldDPBK = DPBK                                             CAP087
     C                   EVAL      OldDPNA = DPNA                                             CAP087
     C                   EVAL      OldMKTP = MKTP                                             CAP087
     C                   END                                                                  CAP087
      ** In Depot                                                                             CAP087
     C                   EXSR      SRInDepot                                                  CAP087
      ** In Date                                                                              CAP087
     C                   EXSR      SRInDate                                                   CAP087
      ** Out Depot                                                                            CAP087
     C                   EXSR      SROutDep2                                                  CAP087
      ** Out Date                                                                             CAP087
     C                   EXSR      SROutDat2                                                  CAP087
                                                                                              CAP087
     C                   ENDIF                                                                CAP087
      *                                                                                       CSE015
      ** Trade Date                                                                           CSE015
      *                                                                                       CSE015
     C     CSE015        IFEQ      'Y'                                                        CSE015
     C                   EXSR      SRTradeDte                                                 CSE015
     C                   ENDIF                                                                CSE015
      *
      ** Booking Branch
      /COPY WNCPYSRC,SEDPMVV011
     C                   EXSR      SRBBranch
      /COPY WNCPYSRC,SEDPMVV012
      *
      ** Originating Branch
      /COPY WNCPYSRC,SEDPMVV013
     C                   EXSR      SROrBranch
      /COPY WNCPYSRC,SEDPMVV014
      *
      ** Book Code
      /COPY WNCPYSRC,SEDPMVV015
     C                   EXSR      SRBookCde
      /COPY WNCPYSRC,SEDPMVV016
      *
      *****************************************************************                CGL031 233698
      ***Original*Purchased*date***************************************                CGL031 233698
      *****************************************************************                CGL031 233698
     C**********         IF        CGL031 = 'Y'                                        CGL031 233698
     C**********         EXSR      SROrigPDate                                         CGL031 233698
     C**********         ENDIF                                                         CGL031 233698
      ** Beneficiary Customer
      /COPY WNCPYSRC,SEDPMVV017
     C                   EXSR      SRCustomer
      /COPY WNCPYSRC,SEDPMVV018
      *****************************************************************                233698 236705
      ***Original*Purchased*date***************************************                233698 236705
      *****************************************************************                233698 236705
     C**********         IF        CGL031 = 'Y'                                        233698 236705
     C**********                   AND DDDPSSOk = 'Y' AND DDDPBAOk = 'Y'               233698 236705
     C**********                   AND DDDPBNOk = 'Y                   '               233698 236705
     C**********         EXSR      SROrigPDate                                         233698 236705
     C**********         ENDIF                                                         233698 236705
      *
      ** Nominal Amount
      /COPY WNCPYSRC,SEDPMVV019
     C                   EXSR      SRNominal
      /COPY WNCPYSRC,SEDPMVV020
      ***Original*Purchased*date**************************************                 236705 234440
      **************                                                                   236705 234440
     C**************     IF        CGL031 = 'Y'                                        236705 234440
     C**************               AND DDDPSSOk = 'Y' AND DDDPBAOk = 'Y'               236705 234440
     C**************               AND DDDPBNOk = 'Y                   '               236705 234440
     C**************     EXSR      SROrigPDate                                         236705 234440
     C**************     ENDIF                                                         236705 234440
      *
      ** Narrative (No Validation Required)
     C                   MOVE      DDDPNR        DPNR
      *
      ** Market Price
      /COPY WNCPYSRC,SEDPMVV021
     C                   EXSR      SRPrice
      /COPY WNCPYSRC,SEDPMVV022
                                                                                              CGL031
      ***Fiscal*Price**                                                                CGL031 234440
      *****************                                                                CGL031 234440
     C*****************  IF        CGL031 = 'Y'                                        CGL031 234440
     C*****************            AND DDDPSSOk = 'Y' AND DDDPBAOk = 'Y'               233698 234440
     C*****************            AND DDDPBNOk = 'Y'                                  233698 234440
     C*****************  EXSR      SRFPrice                                            CGL031 234440
     C*****************  ENDIF                                                         CGL031 234440
      *
      ** Portfolio Reference
      /COPY WNCPYSRC,SEDPMVV023
     C                   EXSR      SRPortRef
      /COPY WNCPYSRC,SEDPMVV024
                                                                                              CGL031
      ** Original Purchased date                                                              234440
                                                                                              234440
     C                   IF        CGL031 = 'Y'                                               234440
     C                             AND DDDPSSOk = 'Y' AND DDDPBAOk = 'Y'                      234440
     C                             AND DDDPBNOk = 'Y'                                         234440
     C                             AND DDPTFROK = 'Y'                                         234440
     C                   EXSR      SROrigPDate                                                234440
     C                   ENDIF                                                                234440
                                                                                              234440
      ** Cum/Ex and Print Advice Indicator                                                    234916
      ** Do not validate for Repos                                                            CAP087
      *                                                                                       234916
                                                                                              234916
     C     CSE017        IFEQ      'Y'                                                        234916
     C     DPMVType      IFEQ      'DT'                                                       CAP087
     C     DPMVType      OREQ      'WI'                                                       CAP087
     C     DPMVType      OREQ      'WO'                                                       CAP087
     C                   EXSR      SRCumEx                                                    234916
     C                   END                                                                  234916
     C                   END                                                                  CAP087
                                                                                              234916
      ** Original Purchased Interest                                                          CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                             AND DDDPSSOk = 'Y' AND DDDPBAOk = 'Y'                      233698
     C                             AND DDDPBNOk = 'Y'                                         233698
     C                   EVAL      DDACIN = DDDPIN                                            234916
     C                   EXSR      SROrigPInt                                                 CGL031
     C***************    EXSR      SRTaxDate                                           234440 234552
     C                   ENDIF                                                                CGL031
      *
      ** Fiscal Price                                                                         234440
                                                                                              234440
     C                   IF        CGL031 = 'Y'                                               234440
     C                             AND DDDPSSOk = 'Y' AND DDDPBAOk = 'Y'                      234440
     C                             AND DDDPBNOk = 'Y'                                         234440
     C                   EXSR      SRFPrice                                                   234440
     C                   ENDIF                                                                234440
      *                                                                                       234440
      ** Customer Delivery/Withdrawal Indicator
      /COPY WNCPYSRC,SEDPMVV025
     C                   EXSR      SRCustMDIn
      /COPY WNCPYSRC,SEDPMVV026
      *
      ** Average Yield
      /COPY WNCPYSRC,SEDPMVV027
     C                   EXSR      SRAveYield
      /COPY WNCPYSRC,SEDPMVV028
      *
      ** For Repos, carry out processing of Exchange Rate later on as it                      CAP087
      ** require the Deal Currency, otherwise do validation here.                             CAP087
     C     DPMVType      IFNE      'RR'                                                       CAP087
     C     DPMVType      ANDNE     'RP'                                                       CAP087
     C     DPMVType      ANDNE     'PL'                                                       CAP087
     C     DPMVType      ANDNE     'PD'                                                       CAP087
      ** Processed FX Rate and M/D indicator
      /COPY WNCPYSRC,SEDPMVV029
     C                   EXSR      SRFXRate
      /COPY WNCPYSRC,SEDPMVV030
     C                   ENDIF                                                                CAP087
      *
      ** Profit Centre
      /COPY WNCPYSRC,SEDPMVV031
     C                   EXSR      SRProfCtr
      /COPY WNCPYSRC,SEDPMVV032
      *                                                                                       CSE017
      ***Cum/Ex*and*Print*Advice*Indicator***************                              CSE017 234916
      ****************                                                                 CSE017 234916
     C*****CSE017*****   IFEQ      'Y'                                                 CSE017 234916
     C****************   EXSR      SRCumEx                                             CSE017 234916
     C****************   END                                                           CSE017 234916
      *
      ** Charge and Settlement Details
 
      /COPY WNCPYSRC,SEDPMVV033
     C                   IF        ChargeDtls <> *BLANKS
     C                   EXSR      SRChrgSet
     C                   ELSE                                                   167262
     C                   MOVE      *BLANK        DCHC                           167262
     C                   MOVE      *BLANK        DCCE                           167262
     C                   Z-ADD     *ZERO         DCHA                           167262
     C                   Z-ADD     *ZERO         DCSE                           167262
     C                   MOVE      *BLANK        DCAT                           167262
     C                   MOVE      *BLANK        DCAB                           167262
     C                   END
                                                                                187544
      ** Movement Subtype                                                       187544
     C                   EXSR      SRMvtSbt                                     187544
      /COPY WNCPYSRC,SEDPMVV034
     C                   MOVE      'N'           PBFieldInd                     CPB001
     C     PROT          IFEQ      '1'                                          CPB001
     C     PROT          OREQ      '3'                                          CPB001
     C     PROT          OREQ      '5'                                          CPB001
     C     PROT          OREQ      '6'                                          CPB001
     C     PROT          OREQ      '8'                                          CPB001
     C     PROT          OREQ      '9'                                          CPB001
      *                                                                         CPB001
     C     SEC_STBS      IFEQ      'Y'                                          CPB001
     C     SEC_STBS      OREQ      'P'                                          CPB001
     C                   MOVE      'Y'           PBFieldInd                     CPB001
      *                                                                         CPB001
      ** Purchased Interest                                                     CPB001
     C                   EXSR      SRPurIntr                                    CPB001
      *                                                                         CPB001
      ** Accrued Indicator                                                      CPB001
     C                   EXSR      SRAccrInd                                    CPB001
      *                                                                         CPB001
      ** Movement Subtype ***********                                     CPB001187544
     C**************     EXSR      SRMvtSbt                               CPB001187544
     C                   ELSE                                                   CPB001
     C                   MOVE      *BLANKS       DDPINT                         CPB001
     C                   MOVE      *BLANKS       DDACIN                         CPB001
     C**************     MOVE      *BLANKS       DDMSTP                   CPB001187544
     C                   ENDIF                                                  CPB001
     C                   ELSE                                                   CPB001
     C                   MOVE      *BLANKS       DDPINT                         CPB001
     C                   MOVE      *BLANKS       DDACIN                         CPB001
     C**************     MOVE      *BLANKS       DDMSTP                   CPB001187544
     C                   ENDIF                                                  CPB001
 
      ** Counterparty and Market Centre                                                       207006
                                                                                              207006
     C     CSE029        IFEQ      'Y'                                                        207006
     C                   EXSR      SRCtrpty                                                   207006
     C                   EXSR      SRMktCnt                                                   207006
     C                   ENDIF                                                                207006
                                                                                              CAP087
      ** Validate Repo/Pledge Indicator, Deal Associated Deal Number,                         CAP087
      ** Switch Reference and Switch IN/OUT indicator only if Dealing MM                      CAP087
      ** module is switched on and type is Repo, Pledge or Bond.                              CAP087
                                                                                              CAP087
     C     BGDLMM        IFEQ      'Y'                                                        CAP087
                                                                                              CAP087
     C     DPMVType      IFEQ      'RR'                                                       CAP087
     C     DPMVType      OREQ      'RP'                                                       CAP087
     C     DPMVType      OREQ      'PL'                                                       CAP087
     C     DPMVType      OREQ      'PD'                                                       CAP087
     C     DPMVType      OREQ      'BB'                                                       CAP087
     C     DPMVType      OREQ      'BL'                                                       CAP087
      ** Repo/Pledge Indicator                                                                CAP087
     C                   EXSR      SRRPInd                                                    CAP087
      ** Associated Deal Number                                                               CAP087
     C                   MOVE      DDDPAD        DPAD                                         244007
     C**********         IF        DDDRID <> '  '                                    244007 MD037824
     C                   EXSR      SRDAsoD                                                    CAP087
     C**********         ENDIF                                                       244007 MD037824
      ** Switch Reference                                                                     CAP087
     C                   EXSR      SRSwRef                                                    CAP087
      ** Switch IN/OUT indicator                                                              CAP087
     C                   EXSR      SRSwIOInd                                                  CAP087
                                                                                              CAP087
      ** Exchange Rate - ONLY if Associated Deal validation is OK                             CAP087
      ** to ensure Deal Ccy was successfully retrieved.                                       CAP087
     C     DDDPADOk      IFNE      'N'                                                        CAP087
     C     DealCcy       ANDNE     *BLANKS                                                    CAP087
      **                                                                                      CAP087
      ** Setup the fields necessary to process exchange rate for Repos                        CAP087
      ** 1) Move the Deal Ccy (output from Assoc Deal validation) into                        CAP087
      **    Portfolio Ccy input parm                                                          CAP087
      ** 2) Set up other input parameters to force processing (i.e.                           CAP087
      **    Port Mgmt module ind, Private Banking Ind etc.)                                   CAP087
      *                                                                                       CAP087
      ** Save original values                                                                 CAP087
     C                   MOVE      PNPTCY        @PNPTCY                                      CAP087
     C                   MOVE      BGN4ST        @BGN4ST                                      CAP087
     C                   MOVE      BGPFMG        @BGPFMG                                      CAP087
     C                   MOVE      DDPTFROk      @DDPTFROk                                    CAP087
     C                   MOVE      WWPLCS        @WWPLCS                                      CAP087
                                                                                              CAP087
     C                   MOVE      DealCcy       PNPTCY                                       CAP087
     C                   MOVE      'Y'           BGN4ST                                       CAP087
     C                   MOVE      'Y'           BGPFMG                                       CAP087
     C                   MOVE      'Y'           DDPTFROk                                     CAP087
     C                   MOVE      'Y'           WWPLCS                                       CAP087
                                                                                              CAP087
     C                   EXSR      SRFXRate                                                   CAP087
                                                                                              CAP087
      ** Restore original values                                                              CAP087
     C                   MOVE      @PNPTCY       PNPTCY                                       CAP087
     C                   MOVE      @BGN4ST       BGN4ST                                       CAP087
     C                   MOVE      @BGPFMG       BGPFMG                                       CAP087
     C                   MOVE      @DDPTFROk     DDPTFROk                                     CAP087
     C                   MOVE      @WWPLCS       WWPLCS                                       CAP087
     C                   ENDIF                                                                CAP087
                                                                                              CAP087
     C                   ENDIF                                                                CAP087
                                                                                              CAP087
     C                   ENDIF                                                                CAP087
                                                                                              CAP087
      ** Validate combination of Repo / Depot Transfer data                                   CAP087
     C                   EXSR      SRRepoDta                                                  CAP087
                                                                                              207006
      ** Block back value depot movement                                                      234552
                                                                                              234552
     C                   IF        CGL031 = 'Y'                                               234552
     C                             AND DDDPSSOk = 'Y' AND DDDPBAOk = 'Y'                      234552
     C                             AND DDDPBNOk = 'Y'                                         234552
     C                   EXSR      SRTaxDate                                                  234552
     C                   ENDIF                                                                234552
                                                                                              234552
     C                   END
 
     C***************    ENDSR                                                                234691
     C     EDetVal       ENDSR                                                                234691
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRSecurity- Validation routine for Security Shortname         *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SRSecurity    BEGSR
 
     C                   EXSR      SRReset
      *
      ** Save Security Details
      *
 
     C                   MOVE      DPSS          OldDPSS          10
     C                   MOVE      SEC_SESN      OldSESN          10                          236702
 
     C                   CALLB     'SEVDSECSN'
      ** Return Code
     C                   PARM                    RetCodeIn
     C                   PARM      'Y'           Default           1
     C                   PARM      'Y'           Validate          1
     C                   PARM                    DDDPSS           10
      ** ICD
     C                   PARM                    CSE003            1
     C                   PARM                    S01511            1
     C**********         PARM                    BJRDNB            5 0                        CSC011
     C                   PARM                    WRunday                                      CSC011
      *                                                                                       CSE010
      ** SE Transactions Enhancements                                                         CSE010
      *                                                                                       CSE010
     C                   PARM                    CSE010                                       CSE010
      *                                                                                       CSE010
      ** Action Code                                                                          CSE010
      *                                                                                       CSE010
     C                   PARM                    DDACTN                                       CSE010
      *
      * OUTPUTS
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDDPSSOk          1
      *
     C                   PARM                    DPSS             10
      *
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTPDts
      *
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *                                                                         CSE023
     C                   EVAL      WCRTT = SEC_CRTT                             CSE023
      *
      ** Amend Validation
      *
     C                   IF        DDACTN = 'A'
     C                             AND OldDPSS <> DDDPSS
     C                             AND DDDPSSOk = 'Y'
      *
      ** Security shortname cannot be amended.
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDPSS'
     C                   EVAL      MsgIdArr(Idx) = 'MMA0604'
     C                   MOVE      'N'           DDDPSSOK
     C                   END
      *                                                                                       236702
      ** If security changes, need to redefault the EU tax fields                             236702
      *                                                                                       236702
     C                   IF        DDACTN = 'I' AND OldSESN <> *BLANKS                        236702
     C                             AND OldSESN <> DDDPSS                                      236702
     C                             AND DDDPSSOk = 'Y'                                         236702
     C                   EVAL      DDOPDT = *BLANKS                                           236702
     C                   EVAL      DDOPIN = *BLANKS                                           236702
     C                   EVAL      DDFSPR = *BLANKS                                           236702
     C                   END                                                                  236702
 
 
     C                   EXSR      SRUpdate
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRInDepot - Validation routine for In Depot                   *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SRInDepot     BEGSR
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDINDP'
     C                   PARM                    RetCodeIn
     C     DDDepot       PARM                    DDDPID
     C                   PARM                    DDDPAD
     C                   PARM                    DPMVtype
     C                   PARM                    SDSECS
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDDepotOk
     C                   PARM                    DPID
 
     C                   MOVE      BFCLAS        BFCLASInDp        1
     C                   MOVE      *BLANKS       DDDPID
     C                   MOVEL     DDDepot       DDDPID
 
     C                   EXSR      SRUpdate
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRInDate - Validation routine for In Date                     *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SRInDate      BEGSR
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDDATEIN'
     C                   PARM                    RetCodeIn
     C     DDDate        PARM                    DDDPMD
     C                   PARM                    DDDPID
     C                   PARM                    DDDPOD
     C                   PARM                    SEC_MATY
     C                   PARM                    SEC_NMCY
     C                   PARM                    BFCLASInDp
     C                   PARM                    BJDFIN
     C                   PARM                    RunDate
     C                   PARM                    BVEUCY
     C                   PARM                    BVCCCY
     C                   PARM                    BVBVP
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDDateOk
     C                   PARM                    DPMD
 
     C                   MOVE      *BLANKS       DDDPMD
     C                   MOVEL     DDDate        DDDPMD
 
     C                   EXSR      SRUpdate
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SROutDepot - Validation routine for Out Depot                 *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SROutDepot    BEGSR
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDOUTDP'
     C                   PARM                    RetCodeIn
     C     DDDepot       PARM                    DDDPOD
     C                   PARM                    DDDPAD
     C                   PARM                    SDSECS
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDDepotOk
     C                   PARM                    DPOD
 
     C                   MOVE      BFCLAS        BFClasOtDp        1
     C                   MOVE      *BLANKS       DDDPOD
     C                   MOVEL     DDDepot       DDDPOD
 
     C                   EXSR      SRUpdate
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SROutDate - Validation routine for Out Date                   *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SROutDate     BEGSR
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDDATEOT'
     C                   PARM                    RetCodeIn
     C     DDDate        PARM                    DDDPDO
     C                   PARM                    DDDPMD
     C                   PARM                    DDDepot
     C                   PARM                    DDDPID
     C                   PARM                    SEC_MATY
     C                   PARM                    SEC_NMCY
     C                   PARM                    BFCLASOtDp
     C                   PARM                    BJDFIN
     C                   PARM                    RunDate
     C                   PARM                    BVEUCY
     C                   PARM                    BVCCCY
     C                   PARM                    BVBVP
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDDateOk
     C                   PARM                    DPDO
 
     C                   MOVE      *BLANKS       DDDPDO
     C                   MOVEL     DDDate        DDDPDO
 
     C                   EXSR      SRUpdate
 
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  CAP087
      *****************************************************************                       CAP087
      *                                                               *                       CAP087
      * SROutDep2 - Validation routine for Out Depot for Repos        *                       CAP087
      *             and Depot Transfers.                              *                       CAP087
      *                                                               *                       CAP087
      * Called by: SRDetVal                                           *                       CAP087
      *                                                               *                       CAP087
      * Calls: SRReset                                                *                       CAP087
      *        SRUpdate                                               *                       CAP087
      *                                                               *                       CAP087
      *****************************************************************                       CAP087
                                                                                              CAP087
     C     SROutDep2     BEGSR                                                                CAP087
                                                                                              CAP087
     C                   EXSR      SRReset                                                    CAP087
                                                                                              CAP087
     C                   CALLB     'SEVDOUTDP'                                                CAP087
     C                   PARM                    RetCodeIn                                    CAP087
     C                   PARM                    DDDPOD                                       CAP087
     C                   PARM                    DDDPAD                                       CAP087
     C                   PARM                    SDSECS                                       CAP087
     C                   PARM                    FldNamXAr                                    CAP087
     C                   PARM                    MsgIDXAr                                     CAP087
     C                   PARM                    MsgDtaXAr                                    CAP087
     C                   PARM                    DDDPODOk                                     CAP087
     C                   PARM                    DPOD                                         CAP087
                                                                                              CAP087
     C                   MOVE      BFCLAS        BFClasOtDp        1                          CAP087
                                                                                              CAP087
     C                   EXSR      SRUpdate                                                   CAP087
                                                                                              CAP087
     C                   ENDSR                                                                CAP087
      *****************************************************************                       CAP087
     C/EJECT                                                                                  CAP087
      *****************************************************************                       CAP087
      *                                                               *                       CAP087
      * SROutDat2 - Validation routine for Out Date for Repos         *                       CAP087
      *             and Depot Transfers                               *                       CAP087
      *                                                               *                       CAP087
      * Called by: SRDetVal                                           *                       CAP087
      *                                                               *                       CAP087
      * Calls: SRReset                                                *                       CAP087
      *        SRUpdate                                               *                       CAP087
      *                                                               *                       CAP087
      *****************************************************************                       CAP087
                                                                                              CAP087
     C     SROutDat2     BEGSR                                                                CAP087
                                                                                              CAP087
     C                   EXSR      SRReset                                                    CAP087
                                                                                              CAP087
     C                   CALLB     'SEVDDATEOT'                                               CAP087
     C                   PARM                    RetCodeIn                                    CAP087
     C                   PARM                    DDDPDO                                       CAP087
     C                   PARM                    DDDPMD                                       CAP087
     C                   PARM                    DDDPOD                                       CAP087
     C                   PARM                    DDDPID                                       CAP087
     C                   PARM                    SEC_MATY                                     CAP087
     C                   PARM                    SEC_NMCY                                     CAP087
     C                   PARM                    BFCLASOtDp                                   CAP087
     C                   PARM                    BJDFIN                                       CAP087
     C                   PARM                    RunDate                                      CAP087
     C                   PARM                    BVEUCY                                       CAP087
     C                   PARM                    BVCCCY                                       CAP087
     C                   PARM                    BVBVP                                        CAP087
     C                   PARM                    FldNamXAr                                    CAP087
     C                   PARM                    MsgIDXAr                                     CAP087
     C                   PARM                    MsgDtaXAr                                    CAP087
     C                   PARM                    WFldNmXAr                                    CAP087
     C                   PARM                    WMsgIDXAr                                    CAP087
     C                   PARM                    WMsgDtXAr                                    CAP087
     C                   PARM                    DDDPDOOk                                     CAP087
     C                   PARM                    DPDO                                         CAP087
                                                                                              CAP087
     C                   EXSR      SRUpdate                                                   CAP087
                                                                                              CAP087
     C                   ENDSR                                                                CAP087
      *****************************************************************                       CAP087
     C/EJECT                                                                                  CSE015
      *****************************************************************                       CSE015
      *                                                               *                       CSE015
      * SRTradeDte - Validation Routine for Trade Date                *                       CSE015
      *                                                               *                       CSE015
      * Called by: SRDetVal                                           *                       CSE015
      *                                                               *                       CSE015
      * Calls: SRReset                                                *                       CSE015
      *        SRUpdate                                               *                       CSE015
      *                                                               *                       CSE015
      *****************************************************************                       CSE015
      *                                                                                       CSE015
     C     SRTradeDte    BEGSR                                                                CSE015
      *                                                                                       CSE015
     C                   EXSR      SRReset                                                    CSE015
     C                   EVAL      Default = 'Y'                                              222321
     C                   EVAL      Validate = 'Y'                                             222321
     C                   MOVE      *BLANKS       DDTDDT                                       222321
     C                   EVAL      DDTDDT = DDDMTD                                            222321
     C                   EVAL      TDVD = DPMD                                                222321
     C                   IF        TDVD = 0                                                   222321
     C                   EVAL      TDVD = DPDO                                                222321
     C                   ENDIF                                                                222321
      *                                                                                       CSE015
     C**********         CALLB     'SEVTRDT'                                           CSE015 222321
     C                   CALLB     'SEVTTRDDT'                                         CSE015 222321
      *                                                                                       CSE015
      ** Return Code                                                                          CSE015
      ** Trade Date screen field                                                              CSE015
      ** Depot movement date                                                                  CSE015
      ** ICD : Midas Run Date, Date format, Local currency,                                   CSE015
      **       System location, Back-value period.                                            CSE015
      *                                                                                       CSE015
     C                   PARM                    RetCodeIn                                    CSE015
      *                                                                                       222321
      ** Default & Validate (Y or N)                                                          222321
     C                   PARM                    Default           1                          222321
     C                   PARM                    Validate          1                          222321
     C**********         PARM                    DDDMTD                                CSE015 222321
     C**********         PARM                    DDDate                                CSE015 222321
      ** Trade Screen fields                                                                  222321
     C                   PARM                    DDTDDT            7                          222321
      *                                                                                       222321
      ** Trade value date                                                                     222321
     C                   PARM                    TDVD              5 0                        222321
     C**********         PARM                    BJRDNB                                CSE015 CSC011
     C                   PARM                    WRunday                                      CSC011
     C                   PARM                    BJDFIN                                       CSE015
     C                   PARM                    BJLCCY                                       CSE015
     C                   PARM                    BJSLCD                                       CSE015
     C                   PARM                    BVBVP                                        CSE015
      *                                                                                       CSE015
      ** Warning Messages                                                                     CSE015
      *                                                                                       CSE015
     C                   PARM                    FldNamXAr                                    CSE015
     C                   PARM                    MsgIDXAr                                     CSE015
     C                   PARM                    MsgDtaXAr                                    CSE015
     C                   PARM                    WFldNmXAr                                    CSE015
     C                   PARM                    WMsgIDXAr                                    CSE015
     C                   PARM                    WMsgDtXAr                                    CSE015
      *                                                                                       CSE015
      ** Trade Date - OK Flag                                                                 CSE015
      ** Trade Date                                                                           CSE015
     C                   PARM                    DDDMTDOK                                     CSE015
     C                   PARM                    DMTD                                         CSE015
                                                                                              222321
      ** If there are errors or warning in trade date,                                        222321
      ** then need to change the field name fro DDTDDT tp DDDMTD.                             222321
                                                                                              222321
     C                   IF        FldNamXAr(1) <> *BLANKS                                    222321
     C                   Z-ADD     1             I                                            222321
     C     'DDTDDT    '  LOOKUP    FldNamXAr(I)                           99                  222321
     C     *IN99         IFEQ      '1'                                                        222321
     C                   EVAL      FldNamXAr(I) = 'DDDMTD    '                                222321
     C                   END                                                                  222321
     C                   ENDIF                                                                222321
                                                                                              222321
     C                   IF        WFldNmXAr(1) <> *BLANKS                                    222321
     C                   Z-ADD     1             I                                            222321
     C     'DDTDDT    '  LOOKUP    WFldNmXAr(I)                           99                  222321
     C     *IN99         IFEQ      '1'                                                        222321
     C                   EVAL      WFldNmXAr(I) = 'DDDMTD    '                                222321
     C                   END                                                                  222321
     C                   ENDIF                                                                222321
                                                                                              222321
     C                   EVAL      DDDMTD = DDTDDT                                            222321
      *                                                                                       CSE015
     C                   EXSR      SRUpdate                                                   CSE015
      *                                                                                       CSE015
     C                   ENDSR                                                                CSE015
      *                                                                                       CSE015
      *****************************************************************                       CSE015
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRBBranch - Validation routine for Booking Branch             *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SRBBranch     BEGSR
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDBKGBRH'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDDPBA
     C                   PARM                    MBIN
     C                   PARM                    USRBCH
     C                   PARM                    RespMode
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    SDBRCH
     C                   PARM                    DDDPBAOk
     C                   PARM                    DPBA
 
     C                   EXSR      SRUpdate
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SROrBranch - Validation routine for Original Branch           *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SROrBranch    BEGSR
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDORBRCH'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDORBR
     C                   PARM                    DPBA
     C                   PARM                    MBIN
     C                   PARM                    BKOBRU
     C                   PARM                    BKOBUV
     C                   PARM                    RespMode
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDORBROk
     C                   PARM                    ORBR
 
     C                   EXSR      SRUpdate
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRBookCde - Validation routine for Book Code                  *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SRBookCde     BEGSR
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDBOOK'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDDPBK
     C                   PARM                    DDDPID
     C                   PARM                    DDDPOD
     C                   PARM                    DDDPMD
     C                   PARM                    DDDPDO
     C                   PARM                    DDDPBN
     C                   PARM                    DPID
     C                   PARM                    DPMD
     C                   PARM                    DPOD
     C                   PARM                    DPDO
     C                   PARM                    S01401
     C                   PARM                    BVDPBC
     C                   PARM                    BVDMBC
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDDPBKOk
     C                   PARM                    DPBK
 
     C                   EXSR      SRUpdate
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRCustomer - Validation routine for Customer                  *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SRCustomer    BEGSR
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDBFCUST'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDDPBN
     C                   PARM                    DDDPMD
     C                   PARM                    DDDPDO
     C                   PARM                    DDDPID
     C                   PARM                    DDDPOD
     C                   PARM                    DDDPAD
     C                   PARM                    S01401
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr                      CSE023
     C                   PARM                    WMsgIDXAr                      CSE023
     C                   PARM                    WMsgDtXAr                      CSE023
     C                   PARM                    SDSECS
     C                   PARM                    PC101             6
     C                   PARM                    PC102             6
     C                   PARM                    DDDPBNOk
     C                   PARM                    DPBN
     C                   PARM                    CSE023                         CSE023
     C                   PARM                    WCRTT             2            CSE023
     C                   PARM                    DDACTN                                       CSD025
      * Branch code                                                                           CAP087
     C                   PARM                    DDDPBA                                       CAP087
     C                   PARM                    DPMVType                                     CAP087
 
     C                   MOVE      BFCLAS        BFCLASCust        1
 
     C                   EXSR      SRUpdate
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRNominal- Validation routine for Nominal Amount              *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SRNominal     BEGSR
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDNMLAMT'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDDPNA
     C                   PARM                    DDDPID
     C                   PARM                    DDDPOD
     C                   PARM                    DDPTFR
     C                   PARM                    DPSS
     C                   PARM                    DPBA
     C                   PARM                    DPBN
     C                   PARM                    BFCLASCust
     C                   PARM                    RunDate
     C                   PARM                    S01496
     C                   PARM                    FCR997
     C                   PARM                    CSE007
     C                   PARM                    CEU017
     C                   PARM                    BGN4ST                         CPB001
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDDPNAOk
     C                   PARM                    DPNA
     C                   PARM                    CGL011                                       CGL011
 
     C                   EXSR      SRUpdate
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRPrice - Validation routine for Market Price                 *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SRPrice       BEGSR
 
     C                   Z-ADD     0             WRKPI            15 9
     C                   MOVE      'C'           SCUMEX            1
     C                   Z-ADD     DPNA          ZNOML            15 0
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDPRICE'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDMKTP
     C                   PARM                    DPMD
     C                   PARM                    DPDO
     C                   PARM                    DPID
     C                   PARM                    DPOD
     C                   PARM                    SECTY
     C                   PARM                    PROT
     C                   PARM                    BJDFIN
     C                   PARM                    S01496
     C                   PARM                    WRKPI
     C                   PARM                    SCUMEX
     C                   PARM                    ZNOML
     C                   PARM                    NomCcyDec
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDMKTPOk
     C                   PARM                    MKTP
 
     C                   EXSR      SRUpdate
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRPortRef - Validation routine for Portfolio Reference        *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SRPortRef     BEGSR
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDPRTREF'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDDPID
     C                   PARM                    DDDPOD
     C                   PARM                    DDPTFR
     C                   PARM                    DPBN
     C                   PARM                    DPBA
     C                   PARM                    DPSS
     C                   PARM                    DPNA
     C                   PARM                    DPDO
     C                   PARM                    BFCLASCust
     C                   PARM                    FCR997
     C                   PARM                    S01496
     C                   PARM                    BGPFMG
     C                   PARM                    BGN4ST                         CPB001
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    SDPLCS
     C                   PARM                    PORTDET
     C                   PARM                    WWPLCS            1
     C                   PARM                    WWPBCS            1            CPB001
     C                   PARM                    DDPTFROk
     C                   PARM                    DDDPNAOk
     C                   PARM                    PTFR
 
     C                   EXSR      SRUpdate
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRCustMDIn - Validation routine for Customer M/D Indicator.   *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SRCustMDIn    BEGSR
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDCDWIND'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDCWDI
     C                   PARM                    BGPFMG
     C                   PARM                    BFCLASCust
     C                   PARM                    WWPLCS
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDCWDIOk
     C                   PARM                    CWDI
 
     C                   EXSR      SRUpdate
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRAveYield - Validation routine for Average Yield             *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SRAveYield    BEGSR
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDAVEYLD'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDCYLD
     C                   PARM                    DDPTFR
     C                   PARM                    SEC_NMCY
     C                   PARM                    SEC_SITP
     C                   PARM                    DPMVType
     C                   PARM                    DDPTFROk
     C                   PARM                    BGPFMG
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDCYLDOk
     C                   PARM                    CYLD
 
     C                   EXSR      SRUpdate
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRFXRate  - Processing routine for FX Rate and M/D Ind.       *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SRFXRate      BEGSR
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDRATEMD'
     C                   PARM                    DDPTFR
     C                   PARM                    DDPTFROk
     C                   PARM                    DDDPDO
     C                   PARM                    DDDPID
     C                   PARM                    DDDPOD
     C                   PARM                    DPMD
     C                   PARM                    DPDO
     C                   PARM                    PNPTCY
     C                   PARM                    WWPLCS
     C                   PARM                    QBCSBY
     C                   PARM                    SEC_NMCY
     C                   PARM                    BGN4ST                         CPB001
     C                   PARM                    BGPFMG
     C                   PARM                    Rundate
     C                   PARM                    FCR997
     C                   PARM                    DDSPXR
     C                   PARM                    DDSPMD
     C                   PARM                    SPXR
     C                   PARM                    SPMD
 
     C                   EXSR      SRUpdate
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRProfCtr - Validation routine for Profit Centre              *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SRProfCtr     BEGSR
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDPFTCNT'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDDPPC
     C                   PARM                    DPBA
     C                   PARM                    DPBK
     C                   PARM                    DPBN
     C                   PARM                    DPSS
     C                   PARM                    DPMVType
     C                   PARM                    BKPRCU
     C                   PARM                    BGN0ST
     C                   PARM                    BKPCDU
     C                   PARM                    BVSEPC
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDDPPCOk
     C                   PARM                    DPPC
     C                   EXSR      SRUpdate
 
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  CSE017
      *****************************************************************                       CSE017
      *                                                               *                       CSE017
      * SRCumEx   - Cum-Ex and Print Advice Indicator Validation      *                       CSE017
      *                                                               *                       CSE017
      * Called by: SRDetVal                                           *                       CSE017
      *                                                               *                       CSE017
      * Calls: SRReset                                                *                       CSE017
      *                                                               *                       CSE017
      *****************************************************************                       CSE017
     C     SRCumEx       BEGSR                                                                CSE017
      *                                                                                       CSE017
     C     DPMVType      IFEQ      'WI'                                                       CSE017
     C     DPMVType      OREQ      'DT'                                                       CAP087
     C                   Z-Add     DPMD          Date                                         CSE017
     C                   ELSE                                                                 CSE017
     C                   Z-Add     DPDO          Date                                         CSE017
     C                   ENDIF                                                                CSE017
      *                                                                                       CSE017
     C                   EXSR      SRReset                                                    CSE017
      *                                                                                       CSE017
     C                   CALLB     'SEVPIIN'                                                  CSE017
      *                                                                                       CSE017
      ** Return Code                                                                          CSE017
      ** Print Advice Indicator                                                               CSE017
      ** Cum-Ex Indicator                                                                     CSE017
      ** Security Details                                                                     CSE017
      ** Processing Type                                                                      CSE017
      ** Depot Movement Type                                                                  CSE017
      ** In/Out Date                                                                          CSE017
      ** Date Format                                                                          CSE017
      *                                                                                       CSE017
     C                   PARM                    RetCodeIn                                    CSE017
     C     DPAP          PARM                    DDDPAP                                       CSE017
     C     DPIN          PARM                    DDDPIN                                       CSE017
     C                   PARM                    Secty                                        CSE017
     C                   PARM                    PROT                                         CSE017
     C                   PARM                    DPMVType                                     CSE017
     C                   PARM                    Date              5 0                        CSE017
     C                   PARM                    BJDFIN                                       CSE017
      *                                                                                       CSE017
      ** Warning Messages                                                                     CSE017
      *                                                                                       CSE017
     C                   PARM                    FldNAmXAr                                    CSE017
     C                   PARM                    MsgIDXAr                                     CSE017
     C                   PARM                    MsgDtaXAr                                    CSE017
      *                                                                                       CSE017
      ** Cum/Ex Indicator - Ok Flag                                                           CSE017
      ** Print Advice Indicator - Ok Flag                                                     CSE017
      *                                                                                       CSE017
     C                   PARM                    DDDPINOk                                     CSE017
     C                   PARM                    DDDPAPOk                                     CSE017
      *                                                                                       CSE017
     C                   EXSR      SRUpdate                                                   CSE017
      *                                                                                       CSE017
     C                   ENDSR                                                                CSE017
      *****************************************************************                       CSE017
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRChrSget - Transaction Detail Validation Routine  for        *
      *             Charges and Settelment details.                   *
      *                                                               *
      * Called by: SRDetVal                                           *
      *                                                               *
      * Calls: SRReset                                                *
      *        SRUpdate                                               *
      *                                                               *
      *****************************************************************
 
     C     SRChrgSet     BEGSR
 
     C     BVACOP        IFEQ      'Y'
     C     S01445        ANDEQ     'Y'
      *                                                                                     BUG10469
      * Validate charges for Bond Borrowing and Bond Lending                                BUG10469
     C     DPMVType      OREQ      'BB'                                                     BUG10469
     C     DPMVType      OREQ      'BL'                                                     BUG10469
 
     C                   EXSR      SRReset
 
      ** Charge Currency
      ** ---------------
 
     C                   CALLB     'SEVDCHGCUR'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDDCHC
     C                   PARM                    DDDCCE
     C                   PARM                    DDDCHA
     C                   PARM                    DDDCSE
     C                   PARM                    DDDCAT
     C                   PARM                    DDDCAB
     C                   PARM                    DPMVType
     C                   PARM                    BVACOP
     C                   PARM                    S01445
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    SDCURR
     C                   PARM                    DCCE
     C                   PARM                    DDDCCEOk
 
     C                   Z-ADD     A6NBDP        ChrCurDP
 
     C                   EXSR      SRUpdate
 
      ** Charge Code
      ** -----------
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDCHGCDE'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDDCHC
     C                   PARM                    DDDCCE
     C                   PARM                    DDDCHA
     C                   PARM                    DDDCSE
     C                   PARM                    DDDCAT
     C                   PARM                    DDDCAB
     C                   PARM                    DPMVType
     C                   PARM                    DDDCCEOK
     C                   PARM                    BVACOP
     C                   PARM                    S01445
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDDCHCOk
     C                   PARM                    DCHC
 
     C                   EXSR      SRUpdate
 
      ** Charge Amount
      ** -------------
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDCHGAMT'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDDCHC
     C                   PARM                    DDDCCE
     C                   PARM                    DDDCHA
     C                   PARM                    DDDCSE
     C                   PARM                    DDDCAT
     C                   PARM                    DDDCAB
     C                   PARM                    DPMVType
     C                   PARM                    DDDCCEOK
     C                   PARM                    BVACOP
     C                   PARM                    S01445
     C                   PARM                    ChrCurDP
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDDCHAOk
     C                   PARM                    DCHA
 
     C                   EXSR      SRUpdate
 
      ** Charg Settlement Method
      ** -----------------------
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDSETMTH'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDDCHC
     C                   PARM                    DDDCCE
     C                   PARM                    DDDCHA
     C                   PARM                    DDDCSE
     C                   PARM                    DDDCAT
     C                   PARM                    DDDCAB
     C                   PARM                    DPMVType
     C                   PARM                    BVACOP
     C                   PARM                    S01445
     C                   PARM                    BGRTBN
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDDCSEOk
     C                   PARM                    DCSE
 
     C                   EXSR      SRUpdate
 
 
      ** Charge Settlement Account
      ** -------------------------
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDSETACC'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDDCHC
     C                   PARM                    DDDCCE
     C                   PARM                    DDDCHA
     C                   PARM                    DDDCSE
     C                   PARM                    DDDCAT
     C                   PARM                    DDDCAB
     C                   PARM                    DPMVType
     C                   PARM                    DPBA
     C                   PARM                    DPBN
     C                   PARM                    DPMD
     C                   PARM                    DPDO
     C                   PARM                    DDDCSEOk
     C                   PARM                    DDDCABOk
     C                   PARM                    BVACOP
     C                   PARM                    S01445
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    RBranch
     C                   PARM                    DDDCATOk
     C                   PARM                    DCAT
 
     C                   EXSR      SRUpdate
 
      ** Charge Settlement Branch
      ** ------------------------
 
     C                   EXSR      SRReset
 
     C                   CALLB     'SEVDSETBRH'
     C                   PARM                    RetCodeIn
     C                   PARM                    DDDCHC
     C                   PARM                    DDDCCE
     C                   PARM                    DDDCHA
     C                   PARM                    DDDCSE
     C                   PARM                    DDDCAT
     C                   PARM                    DDDCAB
     C                   PARM                    DPMVType
     C                   PARM                    DPBA
     C                   PARM                    RBranch           3
     C                   PARM                    BVACOP
     C                   PARM                    S01445
     C                   PARM                    MBIN
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    DDDCABOk
     C                   PARM                    DCAB
 
     C                   EXSR      SRUpdate
     C                   END
 
 
     C                   ENDSR
 
      *****************************************************************         CPB001
     C/EJECT                                                                    CPB001
      *****************************************************************         CPB001
      *                                                               *         CPB001
      * SRPurIntr - Validation routine for Purchased Interest         *         CPB001
      *                                                               *         CPB001
      * Called by: SRDetVal                                           *         CPB001
      *                                                               *         CPB001
      * Calls: SRReset                                                *         CPB001
      *        SRUpdate                                               *         CPB001
      *                                                               *         CPB001
      *****************************************************************         CPB001
                                                                                CPB001
     C     SRPurIntr     BEGSR                                                  CPB001
                                                                                CPB001
     C                   EXSR      SRReset                                      CPB001
                                                                                CPB001
     C                   CALLB     'SEVPUIT'                                    CPB001
     C                   PARM                    RetCodeIn                      CPB001
     C                   PARM                    DDPINT                         CPB001
     C                   PARM                    DDACIN                         CPB001
     C                   PARM                    DPSS                           CPB001
     C                   PARM                    DPNA                           CPB001
     C                   PARM                    DPDO                           CPB001
     C                   PARM                    DPMD                           CPB001
     C                   PARM                    DPVD                           CPB001
     C                   PARM                    DPMVType                       CPB001
     C                   PARM                    BJDFIN                         CPB001
     C                   PARM                    SECTY                          CPB001
     C                   PARM                    NomCcyDec                      CPB001
     C                   PARM                    PROT                           CPB001
     C                   PARM                    DDPINTSAVE                     CPB001
     C                   PARM                    DDDPNAOk                       CPB001
     C                   PARM                    BGN4ST                         CPB001
     c                   PARM                    Default                        CPB001
     c                   PARM                    Validate                       CPB001
     C                   PARM                    FldNamXAr                      CPB001
     C                   PARM                    MsgIDXAr                       CPB001
     C                   PARM                    MsgDtaXAr                      CPB001
     C                   PARM                    WFldNmXAr                      CPB001
     C                   PARM                    WMsgIDXAr                      CPB001
     C                   PARM                    WMsgDtXAr                      CPB001
     C                   PARM                    DDPINTOk                       CPB001
     C                   PARM                    PINT                           CPB001
                                                                                CPB001
     C                   EXSR      SRUpdate                                     CPB001
                                                                                CPB001
     C                   ENDSR                                                  CPB001
      *****************************************************************         CPB001
     C/EJECT                                                                    CPB001
      *****************************************************************         CPB001
      *                                                               *         CPB001
      * SRAccrInd - Validation routine for Accrued Indicator          *         CPB001
      *                                                               *         CPB001
      * Called by: SRDetVal                                           *         CPB001
      *                                                               *         CPB001
      * Calls: SRReset                                                *         CPB001
      *        SRUpdate                                               *         CPB001
      *                                                               *         CPB001
      *****************************************************************         CPB001
                                                                                CPB001
     C     SRAccrInd     BEGSR                                                  CPB001
                                                                                CPB001
     C                   EXSR      SRReset                                      CPB001
                                                                                CPB001
     C                   CALLB     'SEVDOIN'                                    CPB001
     C                   PARM                    RetCodeIn                      CPB001
     c                   PARM                    Default                        CPB001
     c                   PARM                    Validate                       CPB001
     C                   PARM                    DDACIN                         CPB001
     C                   PARM                    DPVD                           CPB001
     C                   PARM                    SECTY                          CPB001
     C                   PARM                    PROT                           CPB001
     C                   PARM                    BJDFIN                         CPB001
     C                   PARM                    FldNamXAr                      CPB001
     C                   PARM                    MsgIDXAr                       CPB001
     C                   PARM                    MsgDtaXAr                      CPB001
     C                   PARM                    DDACINOk                       CPB001
     C                   PARM                    ACIN                           CPB001
                                                                                CPB001
     C                   EXSR      SRUpdate                                     CPB001
                                                                                CPB001
     C                   ENDSR                                                  CPB001
      *****************************************************************         CPB001
     C/EJECT                                                                    CPB001
      *****************************************************************         CPB001
      *                                                               *         CPB001
      * SRMvtSbt - Validation routine for Movement Subtype            *         CPB001
      *                                                               *         CPB001
      * Called by: SRDetVal                                           *         CPB001
      *                                                               *         CPB001
      * Calls: SRReset                                                *         CPB001
      *        SRUpdate                                               *         CPB001
      *                                                               *         CPB001
      *****************************************************************         CPB001
                                                                                CPB001
     C     SRMvtSbt      BEGSR                                                  CPB001
                                                                                CPB001
     C                   EXSR      SRReset                                      CPB001
                                                                                CPB001
     C                   CALLB     'SEVMVST'                                    CPB001
     C                   PARM                    RetCodeIn                      CPB001
     C                   PARM                    DDMSTP                         CPB001
     C                   PARM                    FldNamXAr                      CPB001
     C                   PARM                    MsgIDXAr                       CPB001
     C                   PARM                    MsgDtaXAr                      CPB001
     C                   PARM                    DDMSTPOk                       CPB001
     C                   PARM                    MSTP                           CPB001
                                                                                CPB001
     C                   EXSR      SRUpdate                                     CPB001
                                                                                CPB001
     C                   ENDSR                                                  CPB001
      *****************************************************************
     C/EJECT                                                                                  CGL031
      *****************************************************************                       CGL031
      *                                                               *                       CGL031
      * SROrigPdate - Validation routine for Original Purchase Date.  *                       CGL031
      *                                                               *                       CGL031
      *****************************************************************                       CGL031
                                                                                              CGL031
     C     SROrigPdate   BEGSR                                                                CGL031
                                                                                              CGL031
     C                   EXSR      SRReset                                                    CGL031
                                                                                              CGL031
                                                                                              234440
     C     DPMVType      IFEQ      'WI'                                                       234440
     C                   EVAL      Dpmv_Date = DPMD                                           234440
     C                   ELSE                                                                 234440
     C                   EVAL      DPmv_Date = DPDO                                           234440
     C                   END                                                                  234440
                                                                                              234440
     C                   CALLB     'SEVOPDT'                                                  CGL031
     C                   PARM                    RetCodeIn                                    CGL031
     C                   PARM                    DDOPDT                                       CGL031
     C                   PARM                    DPMVType                                     CGL031
     C                   PARM                    DDDPSS                                       CGL031
     C                   PARM                    DDDPBN                                       CGL031
     C                   PARM                    DDDPBA                                       233698
     C                   PARM                    BJRDNB                                       CGL031
     C                   PARM                    BJDFIN                                       CGL031
     C                   PARM                    DMTD                                         236703
     C*************      PARM                    DPMD                                  236705 234440
     C                   PARM                    Dpmv_Date                                    234440
     C                   PARM                    DPNA                                         236705
     C                   PARM                    PTFR                                         234440
     C                   PARM                    FldNamXAr                                    CGL031
     C                   PARM                    MsgIDXAr                                     CGL031
     C                   PARM                    MsgDtaXAr                                    CGL031
     C                   PARM                    DDOPDTOk                                     CGL031
     C                   PARM                    OPDT                                         CGL031
                                                                                              CGL031
     C                   EXSR      SRUpdate                                                   CGL031
                                                                                              CGL031
     C                   ENDSR                                                                CGL031
      *****************************************************************                       CGL031
     C/EJECT                                                                                  CGL031
      *****************************************************************                       CGL031
      *                                                               *                       CGL031
      * SRFPrice - Validation routine for Fiscal Price                *                       CGL031
      *                                                               *                       CGL031
      *****************************************************************                       CGL031
                                                                                              CGL031
     C     SRFPrice      BEGSR                                                                CGL031
                                                                                              CGL031
     C                   Z-ADD     0             WRKFSPI                                      CGL031
     C                   MOVE      'C'           SCUMEX                                       CGL031
     C                   Z-ADD     DPNA          ZNOML                                        CGL031
                                                                                              CGL031
     C                   EXSR      SRReset                                                    CGL031
                                                                                              CGL031
     C                   CALLB     'SEVSEFSPR3'                                               CGL031
     C                   PARM                    RetCodeIn                                    CGL031
     C                   PARM                    DDFSPR                                       CGL031
     C                   PARM                    SECTY                                        CGL031
     C                   PARM                    OPDT                                         CGL031
     C                   PARM                    BJDFIN                                       CGL031
     C                   PARM                    WRKFSPI                                      CGL031
     C                   PARM                    SCUMEX                                       CGL031
     C                   PARM                    ZNOML                                        CGL031
     C                   PARM                    NomCcyDec                                    CGL031
     C                   PARM                    DPMVType                                     CGL031
     C                   PARM                    DDDPBN                                       CGL031
     C                   PARM                    DDDPBA                                       233698
     C                   PARM                    DDOPDT                                       236702
     C                   PARM                    PTFR                                         234440
     C                   PARM                    FldNamXAr                                    CGL031
     C                   PARM                    MsgIDXAr                                     CGL031
     C                   PARM                    MsgDtaXAr                                    CGL031
     C                   PARM                    DDFSPROk                                     CGL031
     C                   PARM                    FSPR                                         CGL031
     C                   PARM                    FSPP                                         CGL031
                                                                                              CGL031
     C                   EXSR      SRUpdate                                                   CGL031
                                                                                              CGL031
     C                   ENDSR                                                                CGL031
      *****************************************************************                       CGL031
     C/EJECT                                                                                  CGL031
      *****************************************************************                       CGL031
      *                                                               *                       CGL031
      * SROrigPlnt - Validation routine for Original Purchase Interest*                       CGL031
      *                                                               *                       CGL031
      *****************************************************************                       CGL031
                                                                                              CGL031
     C     SROrigPInt    BEGSR                                                                CGL031
                                                                                              CGL031
     C                   EXSR      SRReset                                                    CGL031
                                                                                              CGL031
     C                   CALLB     'SEVOPUINT'                                                CGL031
     C                   PARM                    RetCodeIn                                    CGL031
     C                   PARM                    DDOPIN                                       CGL031
     C                   PARM                    DPMVType                                     CGL031
     C                   PARM                    DDDPBN                                       CGL031
     C                   PARM                    DDACIN                                       CGL031
     C                   PARM                    DDOPDT                                       236702
     C                   PARM                    DPSS                                         CGL031
     C                   PARM                    DPNA                                         CGL031
     C                   PARM                    OPDT                                         CGL031
     C                   PARM                    DPBA                                         CGL031
     C                   PARM                    BJDFIN                                       CGL031
     C                   PARM                    SECTY                                        CGL031
     C                   PARM                    NomCcyDec                                    CGL031
     c                   PARM                    Default                                      CGL031
     c                   PARM                    Validate                                     CGL031
     C                   PARM                    PTFR                                         234440
     C                   PARM                    FldNamXAr                                    CGL031
     C                   PARM                    MsgIDXAr                                     CGL031
     C                   PARM                    MsgDtaXAr                                    CGL031
     C                   PARM                    DDOPINOk                                     CGL031
     C                   PARM                    OPIN                                         CGL031
     C                   PARM                    ACIN                                         CGL031
                                                                                              CGL031
     C                   EXSR      SRUpdate                                                   CGL031
                                                                                              CGL031
     C                   ENDSR                                                                CGL031
      *****************************************************************                       CGL031
      /EJECT                                                                                  234440
      *****************************************************************                       234440
      *                                                               *                       234440
      * SRTaxDate  - Validate Date for Taxable Transaction            *                       234440
      *                                                               *                       234440
      *****************************************************************                       234440
                                                                                              234440
     C     SRTaxDate     BEGSR                                                                234440
                                                                                              234440
     C                   EXSR      SRReset                                                    234440
                                                                                              234552
     C                   MOVEL     DPBN          CustNum                                      234552
     C     BGPFMG        IFEQ      'Y'                                                        234552
     C     FCPORS        ANDNE     'B'                                                        234552
     C                   MOVEL     FCPORS        I#PORS                                       234552
     C                   MOVEL     FCR997        I#R997                                       234552
     C                   MOVEL     DPBN          I#CUST                                       234552
     C                   MOVEL     *BLANKS       I#BRCA                                       234552
     C                   MOVEL     *BLANKS       I#BOOK                                       234552
     C                   MOVEL     *BLANKS       I#PTFR                                       234552
     C                   MOVEL     *BLANKS       I#CPGM                                       234552
      *                                                                                       234552
     C                   CALL      'AOPLCSR1'                                                 234552
     C                   PARM      *BLANKS       PRTCD                                        234552
     C                   PARM      '*KEY   '     POPTN                                        234552
     C                   PARM                    I@PARM                                       234552
     C                   PARM      *BLANKS       O@PARM                                       234552
     C     SDPLCS        PARM      SDPLCS        DSFDY                                        234552
     C     PRtcd         IFNE      'PMA0008'                                                  234552
     C     PRtcd         ANDNE     'PMA0009'                                                  234552
     C                   MOVEL     'Y'           CustPM                                       234552
     C                   END                                                                  234552
     C                   END                                                                  234552
     C     BGN4ST        IFEQ      'Y'                                                        234552
     C                   MOVEL     DPBN          @KEY1                                        234552
     C                   CALLB     'AOCUSTR1'                                                 234552
     C                   PARM      *BLANKS       @RTCD                                        234552
     C                   PARM      '*KEY   '     @OPTN                                        234552
     C                   PARM                    @KEY1            10                          234552
     C                   PARM                    @KYST             7                          234552
     C     SDCUST        PARM      SDCUST        DSLDY                                        234552
                                                                                              234552
     C     @RTCD         IFEQ      *BLANKS                                                    234552
     C     BBPRBA        ANDEQ     'Y'                                                        234552
     C                   MOVEL     'Y'           CustPB                                       234552
     C                   ENDIF                                                                234552
     C                   ENDIF                                                                234552
                                                                                              234552
     C     DPMVType      IFEQ      'WI'                                                       234440
     C                   Z-ADD     DPMD          WDate                                        234440
     C                   MOVEL     'DDDPMD'      WField                                       234440
     C                   ELSE                                                                 234440
     C                   Z-ADD     DPDO          WDate                                        234440
     C                   MOVEL     'DDDPDO'      WField                                       234440
     C                   ENDIF                                                                234440
                                                                                              234440
     C***************    CALL      'SEVTAXDATE'                                        234440 234552
     C**********         CALLB     'SEVTAXDATE'                                        234552 237063
     C                   CALL      'SEVTAXDATE'                                               237063
     C                   PARM                    RetCodeIn                                    234440
     C***************    PARM      'Y'           WDefault          1                          234552
     C***************    PARM      *BLANKS       WDefault          1                   234552 235546
     C                   PARM      'Y'           WDefault          1                          235546
     C                   PARM      DDACTN        WAction           1                          234440
     C                   PARM      DPBA          WBrca             3                          234440
     C                   PARM      DPBN          WCust                                        234440
     C                   PARM      DPSS          WSesn            10                          234440
     C                   PARM      PTFR          WPtfr             4                          234440
     C***************    PARM      DPMK          WMrk              1                   234440 234552
     C***************    PARM      *BLANKS       WMrk              1                   234552 234577
     C                   PARM      SEC_MKTI      WMrk              1                          234577
     C                   PARM      'D'           WType             1                          234440
     C                   PARM      DPRN          WTRef             6                          234440
     C                   PARM                    WDate             5 0                        234440
     C                   PARM                    WField           10                          234440
     C                   PARM                    SECTY                                        234440
     C                   PARM                    CustDts                                      234552
     C                   PARM                    FldNamXAr                                    234440
     C                   PARM                    MsgIDXAr                                     234440
     C                   PARM                    MsgDtaXAr                                    234440
     C                   PARM                    WFldNmXAr                                    234440
     C                   PARM                    WMsgIDXAr                                    234440
     C                   PARM                    WMsgDtXAr                                    234440
     C                   PARM                    FieldOK           1                          234440
                                                                                              234440
     C     FieldOK       IFEQ      'N'                                                        234440
     C                   MOVEL     FieldOK       DDDATEOk                                     234440
     C                   ENDIF                                                                234440
                                                                                              234440
     C                   EXSR      SRUpdate                                                   234440
                                                                                              234440
     C                   ENDSR                                                                234440
      *****************************************************************                       234440
      /EJECT
      *****************************************************************                       207006
      *                                                               *                       207006
      * SRMktCnt - Validation routine for Market Centre               *                       207006
      *                                                               *                       207006
      * Called by: SRDetVal                                           *                       207006
      *                                                               *                       207006
      * Calls: SRReset                                                *                       207006
      *        SRUpdate                                               *                       207006
      *                                                               *                       207006
      *****************************************************************                       207006
                                                                                              207006
     C     SRMktCnt      BEGSR                                                                207006
                                                                                              207006
     C                   EXSR      SRReset                                                    207006
                                                                                              207006
     C                   CALLB     'SEVTMKTCEN'                                               207006
      * INPUTS                                                                                207006
     C                   PARM                    RetCodeIn                                    207006
     C*****************  PARM      'N'           Default           1                  207006 BUG2392
     C                   PARM      'Y'           Default           1                         BUG2392
     C                   PARM      'Y'           Validate          1                          207006
      ** Trade Screen fields                                                                  207006
     C                   PARM                    DDMRKT                                       207006
      ** Investment Type Market Centre                                                        207006
     C                   PARM                    DMKT              2                          207006
      * OUTPUTS                                                                               207006
     C                   PARM                    FldNamXAr                                    207006
     C                   PARM                    MsgIDXAr                                     207006
     C                   PARM                    MsgDtaXAr                                    207006
     C                   PARM                    DDMrktOK                                     207006
      ** Market Centre                                                                        207006
     C*****************  PARM                    TMKC              2                   207006 212599
     C                   PARM                    MRKT                                         212599
                                                                                              207006
     C                   EXSR      SRUpdate                                                   207006
                                                                                              207006
     C                   ENDSR                                                                207006
      *****************************************************************                       207006
      /EJECT                                                                                  207006
      *****************************************************************                       207006
      *                                                               *                       207006
      * SRCtrpty - Validation routine for Counterparty                *                       207006
      *                                                               *                       207006
      * Called by: SRDetVal                                           *                       207006
      *                                                               *                       207006
      * Calls: SRReset                                                *                       207006
      *        SRUpdate                                               *                       207006
      *                                                               *                       207006
      *****************************************************************                       207006
                                                                                              207006
     C     SRCtrpty      BEGSR                                                                207006
                                                                                              207006
     C                   EXSR      SRReset                                                    207006
                                                                                              207006
     C                   CALLB     'SEVTCUST'                                                 207006
      * INPUTS                                                                                207006
     C                   PARM                    RetCodeIn                                    207006
     C                   PARM      'N'           Default           1                          207006
     C                   PARM      'Y'           Validate          1                          207006
     C                   PARM                    DDCPTY                                       207006
     C                   PARM                    DDACTN            1                          207006
     C                   PARM                    DDTINC            1                          207006
                                                                                              208940
      ** First Buy-sell back indicator                                                        208940
                                                                                              208940
     C                   PARM                    PFBYSL            1                          208940
                                                                                              208940
      ** First Buy-sell counterparty                                                          208940
                                                                                              208940
     C**********         PARM                    PFTCNR            6 0                 208940 CSD027
     C                   PARM                    PFTCNR            6                          CSD027
     C                   PARM                    BGPFMG            1                          207006
     C                   PARM                    FCPORS            1                          207006
     C                   PARM                    FCR997            4                          207006
     C                   PARM                    BGN4ST            1                          207006
      * OUTPUTS                                                                               207006
     C                   PARM                    FldNamXAr                                    207006
     C                   PARM                    MsgIDXAr                                     207006
     C                   PARM                    MsgDtaXAr                                    207006
     C                   PARM                    DDCPTYOk                                     207006
     C                   PARM                    CPTY                                         207006
     C                   PARM                    CustDts                                      207006
     C                   PARM                    DDORDE            6                          207006
                                                                                              207006
     C                   EXSR      SRUpdate                                                   207006
                                                                                              207006
     C                   ENDSR                                                                207006
      *****************************************************************                       207006
      /EJECT                                                                                  CAP087
      *****************************************************************                       CAP087
      *                                                               *                       CAP087
      * SRRPInd - Validate Repo/Pledge Indicator                      *                       CAP087
      *                                                               *                       CAP087
      * Called by: SRDetVal                                           *                       CAP087
      *                                                               *                       CAP087
      * Calls:  None                                                  *                       CAP087
      *                                                               *                       CAP087
      *****************************************************************                       CAP087
                                                                                              CAP087
     C     SRRPInd       BEGSR                                                                CAP087
                                                                                              CAP087
     C                   EXSR      SRReset                                                    CAP087
                                                                                              CAP087
     C                   CALLB     'SEVDRPPLIN'                                               CAP087
      * Input                                                                                 CAP087
     C                   PARM                    RetCodeIn                                    CAP087
     C                   PARM                    DDRPIN                                       CAP087
     C                   PARM                    DDDPMD                                       CAP087
     C                   PARM                    DDDPDO                                       CAP087
     C                   PARM                    DDDPID                                       CAP087
     C                   PARM                    DDDPOD                                       CAP087
     C                   PARM                    BGDLMM                                       CAP087
      * Output                                                                                CAP087
     C                   PARM                    FldNamXAr                                    CAP087
     C                   PARM                    MsgIDXAr                                     CAP087
     C                   PARM                    MsgDtaXAr                                    CAP087
     C                   PARM                    DDRPINOK                                     CAP087
     C                   PARM                    RPIN                                         CAP087
                                                                                              CAP087
      * Update error message array                                                            CAP087
     C                   EXSR      SRUpdate                                                   CAP087
                                                                                              CAP087
     C                   ENDSR                                                                CAP087
                                                                                              CAP087
      *****************************************************************                       CAP087
      /EJECT                                                                                  CAP087
      *****************************************************************                       CAP087
      *                                                               *                       CAP087
      * SRDAsoD - Validate Associated Deal Number                     *                       CAP087
      *                                                               *                       CAP087
      * Called by: SRDetVal                                           *                       CAP087
      *                                                               *                       CAP087
      * Calls:  None                                                  *                       CAP087
      *                                                               *                       CAP087
      *****************************************************************                       CAP087
                                                                                              CAP087
     C     SRDAsoD       BEGSR                                                                CAP087
                                                                                              CAP087
     C                   EXSR      SRReset                                                    CAP087
                                                                                              CAP087
     C                   CALLB     'SEVDPMVAD'                                                CAP087
      * Input                                                                                 CAP087
     C                   PARM                    RetCodeIn                                    CAP087
     C                   PARM                    DDDPAD                                       CAP087
     C                   PARM                    DDSWRF                                       CAP087
     C                   PARM                    DDRPIN                                       CAP087
     C                   PARM                    DDDPRN                                       CAP087
     C                   PARM                    DPDO                                         CAP087
     C                   PARM                    DPMD                                         CAP087
     C                   PARM                    DPBA                                         CAP087
     C                   PARM                    DPBN                                         CAP087
      * Dealing module indicator                                                              CAP087
     C                   PARM                    BGDLMM                                       CAP087
      * Security Nominal Currency                                                             CAP087
     C                   PARM                    SEC_NMCY                                     CAP087
      * Security Investment Type                                                              CAP087
     C                   PARM                    SEC_SITP                                     CAP087
      * Security Maturity Date                                                                CAP087
     C                   PARM                    SEC_MATY                                     CAP087
      * Output                                                                                CAP087
      * Error message array                                                                   CAP087
     C                   PARM                    FldNamXAr                                    CAP087
     C                   PARM                    MsgIDXAr                                     CAP087
     C                   PARM                    MsgDtaXAr                                    CAP087
      * Warning message array                                                                 CAP087
     C                   PARM                    WFldNmXAr                                    CAP087
     C                   PARM                    WMsgIDXAr                                    CAP087
     C                   PARM                    WMsgDtXAr                                    CAP087
      * Associated Deal Number OK flag                                                        CAP087
      * Associated Deal Number                                                                CAP087
      * Associated Deal Currency Code                                                         CAP087
     C                   PARM                    DDDPADOK                                     CAP087
     C                   PARM                    DPAD                                         CAP087
     C                   PARM                    DealCcy                                      CAP087
                                                                                              CAP087
      * Update error message array                                                            CAP087
     C                   EXSR      SRUpdate                                                   CAP087
                                                                                              CAP087
     C                   ENDSR                                                                CAP087
                                                                                              CAP087
      *****************************************************************                       CAP087
      /EJECT                                                                                  CAP087
      *****************************************************************                       CAP087
      *                                                               *                       CAP087
      * SRSwRef - Validate Switch Reference                           *                       CAP087
      *                                                               *                       CAP087
      * Called by: SRDetVal                                           *                       CAP087
      *                                                               *                       CAP087
      * Calls:  None                                                  *                       CAP087
      *                                                               *                       CAP087
      *****************************************************************                       CAP087
                                                                                              CAP087
     C     SRSwRef       BEGSR                                                                CAP087
                                                                                              CAP087
     C                   EXSR      SRReset                                                    CAP087
                                                                                              CAP087
     C                   CALLB     'SEVDSWREF'                                                CAP087
      * Input                                                                                 CAP087
     C                   PARM                    RetCodeIn                                    CAP087
     C                   PARM                    DDSWRF                                       CAP087
     C                   PARM                    DDRPIN                                       CAP087
     C                   PARM                    BGDLMM                                       CAP087
      * Output                                                                                CAP087
     C                   PARM                    FldNamXAr                                    CAP087
     C                   PARM                    MsgIDXAr                                     CAP087
     C                   PARM                    MsgDtaXAr                                    CAP087
     C                   PARM                    DDSWRFOK                                     CAP087
     C                   PARM                    SWRF                                         CAP087
                                                                                              CAP087
      * Update error message array                                                            CAP087
     C                   EXSR      SRUpdate                                                   CAP087
                                                                                              CAP087
     C                   ENDSR                                                                CAP087
                                                                                              CAP087
      *****************************************************************                       CAP087
      /EJECT                                                                                  CAP087
      *****************************************************************                       CAP087
      *                                                               *                       CAP087
      * SRSwIOInd - Validate Switch IN/OUT Indicator                  *                       CAP087
      *                                                               *                       CAP087
      * Called by: SRDetVal                                           *                       CAP087
      *                                                               *                       CAP087
      * Calls:  None                                                  *                       CAP087
      *                                                               *                       CAP087
      *****************************************************************                       CAP087
                                                                                              CAP087
     C     SRSwIOInd     BEGSR                                                                CAP087
                                                                                              CAP087
     C                   EXSR      SRReset                                                    CAP087
                                                                                              CAP087
     C                   CALLB     'SEVDSWIOIN'                                               CAP087
      * Input                                                                                 CAP087
     C                   PARM                    RetCodeIn                                    CAP087
     C                   PARM                    DDSWRF                                       CAP087
     C                   PARM                    DDSIOI                                       CAP087
     C                   PARM                    BGDLMM                                       CAP087
      * Output                                                                                CAP087
     C                   PARM                    FldNamXAr                                    CAP087
     C                   PARM                    MsgIDXAr                                     CAP087
     C                   PARM                    MsgDtaXAr                                    CAP087
     C                   PARM                    DDSIOIOK                                     CAP087
     C                   PARM                    SIOI                                         CAP087
                                                                                              CAP087
      * Update error message array                                                            CAP087
     C                   EXSR      SRUpdate                                                   CAP087
                                                                                              CAP087
     C                   ENDSR                                                                CAP087
                                                                                              CAP087
      *****************************************************************                       CAP087
      /EJECT                                                                                  CAP087
      *****************************************************************                       CAP087
      *                                                               *                       CAP087
      * SRRepoDta - Validate combination of Repo / Depot Transfer     *                       CAP087
      *             primary data.                                     *                       CAP087
      *                                                               *                       CAP087
      * Called by: SRDetVal                                           *                       CAP087
      *                                                               *                       CAP087
      * Calls:  None                                                  *                       CAP087
      *                                                               *                       CAP087
      *****************************************************************                       CAP087
                                                                                              CAP087
     C     SRRepoDta     BEGSR                                                                CAP087
                                                                                              CAP087
     C     DPMVType      IFEQ      'BB'                                                       CAP087
     C     DPMVType      OREQ      'RR'                                                       CAP087
     C     DPMVType      OREQ      'PL'                                                       CAP087
     C     DPMVType      OREQ      'BL'                                                       CAP087
     C     DPMVType      OREQ      'RP'                                                       CAP087
     C     DPMVType      OREQ      'PD'                                                       CAP087
     C     DPMVType      OREQ      'DT'                                                       CAP087
                                                                                              CAP087
     C                   EXSR      SRReset                                                    CAP087
                                                                                              CAP087
     C                   CALLB     'SEVDPMVTP'                                                CAP087
      * Input                                                                                 CAP087
     C                   PARM                    RetCodeIn                                    CAP087
     C                   PARM                    DDACTN                                       CAP087
     C                   PARM                    DPMVType                                     CAP087
     C                   PARM                    DDDPID                                       CAP087
     C                   PARM                    DDDPMD                                       CAP087
     C                   PARM                    DDDPOD                                       CAP087
     C                   PARM                    DDDPDO                                       CAP087
     C                   PARM                    DDDPBA                                       CAP087
     C                   PARM                    DPID                                         CAP087
     C                   PARM                    DPMD                                         CAP087
     C                   PARM                    DPOD                                         CAP087
     C                   PARM                    DPDO                                         CAP087
     C                   PARM                    DPBA                                         CAP087
     C                   PARM                    DPBK                                         CAP087
     C                   PARM                    DPNA                                         CAP087
     C                   PARM                    MKTP                                         CAP087
     C                   PARM                    OldDPID                                      CAP087
     C                   PARM                    OldDPMD                                      CAP087
     C                   PARM                    OldDPOD                                      CAP087
     C                   PARM                    OldDPDO                                      CAP087
     C                   PARM                    OldDPBA                                      CAP087
     C                   PARM                    OldDPBK                                      CAP087
     C                   PARM                    OldDPNA                                      CAP087
     C                   PARM                    OldMKTP                                      CAP087
     C                   PARM                    DDDPAD                                       CAP087
     C                   PARM                    DDRPIN                                       CAP087
     C                   PARM                    BGDLMM                                       CAP087
     C                   PARM                    ORED                                         CAP087
     C                   PARM                    WRunday                                      CAP087
      * Output                                                                                CAP087
     C                   PARM                    FldNamXAr                                    CAP087
     C                   PARM                    MsgIDXAr                                     CAP087
     C                   PARM                    MsgDtaXAr                                    CAP087
                                                                                              CAP087
      * Update error message array                                                            CAP087
     C                   EXSR      SRUpdate                                                   CAP087
                                                                                              CAP087
     C                   END                                                                  CAP087
                                                                                              CAP087
     C                   ENDSR                                                                CAP087
                                                                                              CAP087
      *****************************************************************                       CAP087
      /EJECT                                                                                  207006
      *****************************************************************
      *                                                               *
      * SRRESET- Reset Error information that is received Back        *
      *          from Each Validation Module                          *
      *                                                               *
      * Called by: SRInDepot, SROutDate, SRInDepot, SRInDate          *
      *            SRBBranch, SRORBranch, SRNominal, SRPrice          *
      *            SRPortRef, SRCustMDIn, SRFXRate, SRProfCtr         *
      *            SRChrSet,                                          *
      *            SRPurIntr, SRAccrInd, SRMvtSbt                     *         CPB001
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRReset       BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate  - Update error information with that received back  *
      *             from each validation module.                      *
      *                                                               *
      * Called by: SRInDepot, SROutDate, SRInDepot, SRInDate          *
      *            SRBBranch, SRORBranch, SRNominal, SRPrice          *
      *            SRPortRef, SRCustMDIn, SRFXRate, SRProfCtr         *
      *            SRChrSet,                                          *
      *            SRPutIntr, SRAccrInd, SRMvtSbt                     *         CPB001
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SrUpdate      BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      * Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit- Initializtion Routine                                 *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:  None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
      *
      ***Set-up*unnecessary data                                                              CAP087
      *******************                                                                     CAP087
     C*******************MOVE      *BLANKS       IVldEntry                                    CAP087
      *******************                                                                     CAP087
      ** Remove blanking out of IVldEntry above as this is only applicable for WI or WO.      CAP087
      ** Instead, blank out individual fields only if DPMVType is Walk-In or Walk-Out as      CAP087
      ** these fields will now be required for Repos and Depot Transfers.                     CAP087
                                                                                              CAP087
     C     DPMVtype      IFEQ      'WI'                                                       CAP087
     C     DPMVtype      OREQ      'WO'                                                       CAP087
     C                   MOVE      *BLANKS       DDDPAD                                       CAP087
     C                   MOVE      *BLANKS       DDSWRF                                       CAP087
     C                   MOVE      *BLANKS       DDSIOI                                       CAP087
     C                   MOVE      *BLANKS       DDRPIN                                       CAP087
     C                   END                                                                  CAP087
      ** Set-up proper date and depot info for Walk-In/Walk-Out transaction
      *
     C     DPMVtype      IFEQ      'WI'
     C                   MOVE      DDDEPOT       DDDPID           10
     C                   MOVE      DDDATE        DDDPMD            6
     C                   MOVE      *BLANKS       DDDPOD           10
     C                   MOVE      *BLANKS       DDDPDO            6
     C**********         Z-ADD     0             DPOD                                         CSD027
     C                   EVAL      DPOD = *BLANKS                                             CSD027
     C                   Z-ADD     0             DPDO
     C                   MOVE      'WI'          DPMV
     C                   END
     C
     C     DPMVtype      IFEQ      'WO'
     C                   MOVE      DDDEPOT       DDDPOD
     C                   MOVE      DDDATE        DDDPDO
     C                   MOVE      *BLANKS       DDDPID
     C                   MOVE      *BLANKS       DDDPMD
     C**********         MOVE      0             DPID                                         CSD027
     C                   EVAL      DPID = *BLANKS                                             CSD027
     C                   Z-ADD     0             DPMD
     C                   MOVE      'WO'          DPMV
     C                   END
 
      ** As In Depot (DDDPID) has been renamed to DDDEPOT and In Date (DDDPMD) to             CAP087
      ** DDDATE, set up the fields accordingly for Repo and Depot Transfers as DDDPID         CAP087
      ** and DDDPMD are currently effectively NULL.  Also set Movement Type (DPMV)            CAP087
      ** based on passed DPMVType.                                                            CAP087
      ** NOTE : Out Depot (DDDPOD) and Out Date (DDDPDO) should be used as received from      CAP087
      **        incoming parameters (these are not renamed).                                  CAP087
                                                                                              CAP087
     C     DPMVtype      IFEQ      'BB'                                                       CAP087
     C     DPMVtype      OREQ      'BL'                                                       CAP087
     C     DPMVtype      OREQ      'RR'                                                       CAP087
     C     DPMVtype      OREQ      'RP'                                                       CAP087
     C     DPMVtype      OREQ      'PL'                                                       CAP087
     C     DPMVtype      OREQ      'PD'                                                       CAP087
     C     DPMVtype      OREQ      'DT'                                                       CAP087
     C                   MOVE      DDDEPOT       DDDPID                                       CAP087
     C                   MOVE      DDDATE        DDDPMD                                       CAP087
     C                   MOVE      DPMVType      DPMV                                         CAP087
     C                   END                                                                  CAP087
                                                                                              CAP087
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      * Called by: *InzSR                                             *
      *                                                               *
      * Calls:  *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
      *
      **  Terminte the program
      *
     C                   EXSR      *PSSR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *InzSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Received Parameters
      ** -------------------
 
      ** Depot Movement Screen Input Details
     C                   PARM                    SETransDtl
     C                   PARM                    ExtData                        CAP004
 
      ** Security Details
      ** Depot Movement Type (2A)
      ** Response Mode (1A)
     C                   PARM                    SECTY
     C                   PARM                    DPMVType          2
     C                   PARM                    DDDRID            1                          244007
     C                   PARM                    RespMode          1
 
      ** Returned Parameters
      ** -------------------
 
      ** Screen Output
      ** FX Rate
      ** M/D Indicator
      ** Portfolio Customer Indicator
      ** Private Banking Customer Indicator                                     CPB001
      ** Private Banking Field to process Indicator                             CPB001
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    WWPLCS            1
     C                   PARM                    WWPBCS            1            CPB001
     C                   PARM                    PBFieldInd        1            CPB001
 
      ** Valid Transaction fields Details
      ** Trade Primary Details OK inds
     C                   PARM                    SEValidF
     C                   PARM                    SEErFldF
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      * Array index (3P0) from/to caller
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
     C                   PARM                    WIdx
                                                                                              CGL031
      ** Switchable Feature CGL031                                                            CGL031
     C                   PARM                    CGL031                                       CGL031
 
     C                   MOVEL     'SEDPMVVAL'   DBPGM
 
      ** ICD Info Retrieval Processing
      ** -----------------------------
 
      *
      ** Read data area - RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** In the DataArea ZMUSER
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
      *
      ** Get Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 900*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** Securities Trading
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** Get General Ledger ICD
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** Check if switchable feature S01401 is switched on.
      *
     C                   MOVE      'N'           S01401            1
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01401'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01401'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '903'         DBASE                          * DBERR 903*
     C                   EXSR      SRERR                                        ************
     C                   ELSE
     C     @RTCD         IFEQ      *BLANKS                                      176680
     C                   MOVE      'Y'           S01401
     C                   END                                                    176680
     C                   END
      *
      ** Check if switchable feature S01496 is switched on.
      *
     C                   MOVE      'N'           S01496            1
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01496'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01496'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '904'         DBASE                          * DBERR 904*
     C                   EXSR      SRERR                                        ************
     C                   ELSE
     C     @RTCD         IFEQ      *BLANKS                                      176680
     C                   MOVE      'Y'           S01496
     C                   END                                                    176680
     C                   END
      *
      ** Check if switchable feature CSE007 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE007'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSE007'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '910'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSE007
     C                   ELSE
     C                   MOVE      'N'           CSE007            1
     C                   END
      *
      ** Check if switchable feature CEU017 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU017'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU017'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '911'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU017
     C                   ELSE
     C                   MOVE      'N'           CEU017            1
     C                   END
      *                                                                         CSE023
      ** Check if switchable feature CSE023 is switched on.                     CSE023
      *                                                                         CSE023
     C                   CALL      'AOSARDR0'                                   CSE023
     C                   PARM      *BLANKS       @RTCD                          CSE023
     C                   PARM      '*VERIFY'     @OPTN                          CSE023
     C                   PARM      'CSE023'      @SARD                          CSE023
      *                                                                         CSE023
      ** Database error                                                         CSE023
      *                                                                         CSE023
     C     @RTCD         IFNE      *BLANKS                                      CSE023
     C     @RTCD         ANDNE     '*NRF   '                                    CSE023
     C                   MOVEL     'CSE023'      DBKEY                          CSE023
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE023
     C                   MOVEL     '915'         DBASE                          CSE023
     C                   EXSR      SRERR                                        CSE023
     C                   ENDIF                                                  CSE023
      *                                                                         CSE023
     C     @RTCD         IFEQ      *BLANK                                       CSE023
     C                   MOVE      'Y'           CSE023                         CSE023
     C                   ELSE                                                   CSE023
     C                   MOVE      'N'           CSE023            1            CSE023
     C                   ENDIF                                                  CSE023
      *
      ** Get Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '905'         DBASE                          * DBERR 905*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** Access Portfolio Management Details
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST'      @OPTN             7
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE                         ************
     C                   MOVEL     '906'         DBASE                          * DBERR 906*
     C                   EXSR      SRERR                                        ************
     C                   END
 
     C                   END
      *
      ** Check if switchable feature S01445 is switched on.
      *
     C                   MOVE      'N'           S01445            1
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01445'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01445'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '907'         DBASE                          * DBERR 907*
     C                   EXSR      SRERR                                        ************
     C                   ELSE
     C     @RTCD         IFEQ      *BLANKS                                      176680
     C                   MOVE      'Y'           S01445
     C                   END                                                    176680
     C                   END
      *
      **  Access SAR details file to see if ? allowed for security
      *
     C                   MOVE      'N'           CSE003            1
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE003'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSE003'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '908'         DBASE                          * DBERR 908*
     C                   EXSR      *PSSR                                        ************
     C                   ELSE
     C     @RTCD         IFEQ      *BLANKS                                      176680
     C                   MOVE      'Y'           CSE003
     C                   END                                                    176680
     C                   END
      *
      ** Check if switchable feature S01511 is switched on.
      *
     C                   MOVE      'N'           S01511            1
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01511'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01511'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '909'         DBASE                          * DBERR 909*
     C                   EXSR      *PSSR                                        ************
     C                   ELSE
     C     @RTCD         IFEQ      *BLANKS                                      176680
     C                   MOVE      'Y'           S01511
     C                   END                                                    176680
     C                   END
      *                                                                                       CSE017
      ** Check if switchable feature CSE017 is switched on.                                   CSE017
      *                                                                                       CSE017
     C                   MOVE      'N'           CSE017            1                          CSE017
     C                   CALLB     'AOSARDR0'                                                 CSE017
     C                   PARM      *BLANKS       @RTCD                                        CSE017
     C                   PARM      '*VERIFY'     @OPTN                                        CSE017
     C                   PARM      'CSE017'      @SARD                                        CSE017
      *                                                                                       CSE017
      ** Database error                                                                       CSE017
      *                                                                                       CSE017
     C     @RTCD         IFNE      *BLANKS                                                    CSE017
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE017
     C                   MOVEL     'CSE017'      DBKEY                                        CSE017
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE017
     C                   MOVEL     '913'         DBASE                                        CSE017
     C                   EXSR      *PSSR                                                      CSE017
     C                   ELSE                                                                 CSE017
     C     @RTCD         IFEQ      *BLANKS                                                    CSE017
     C                   MOVE      'Y'           CSE017                                       CSE017
     C                   END                                                                  CSE017
     C                   END                                                                  CSE017
      *                                                                                       CSE015
      ** Check if switchable feature CSE015 is installed.                                     CSE015
      *                                                                                       CSE015
     C                   MOVE      'N'           CSE015            1                          CSE015
     C                   CALLB     'AOSARDR0'                                                 CSE015
     C                   PARM      *BLANKS       @RTCD                                        CSE015
     C                   PARM      '*VERIFY'     @OPTN                                        CSE015
     C                   PARM      'CSE015'      @SARD                                        CSE015
      *                                                                                       CSE015
      ** Database error                                                                       CSE015
      *                                                                                       CSE015
     C     @RTCD         IFNE      *BLANKS                                                    CSE015
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE015
     C                   MOVEL     'CSE015'      DBKEY                                        CSE015
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE015
     C                   MOVEL     '914'         DBASE                                        CSE015
     C                   EXSR      *PSSR                                                      CSE015
      *                                                                                       CSE015
     C                   ELSE                                                                 CSE015
     C     @RTCD         IFEQ      *BLANKS                                                    CSE015
     C                   MOVE      'Y'           CSE015                                       CSE015
     C                   ENDIF                                                                CSE015
     C                   ENDIF                                                                CSE015
      *                                                                                       CSE010
      ** Check if switchable feature CSE010 is switched on.                                   CSE010
      *                                                                                       CSE010
     C                   CALL      'AOSARDR0'                                                 CSE010
     C                   PARM      *BLANKS       @RTCD                                        CSE010
     C                   PARM      '*VERIFY'     @OPTN                                        CSE010
     C                   PARM      'CSE010'      @SARD                                        CSE010
      *                                                                                       CSE010
      ** Database Error                                                                       CSE010
      *                                                                                       CSE010
     C     @RTCD         IFNE      *BLANKS                                                    CSE010
     C     @RTCD         ANDNE     '*NRF   '                                                  CSE010
     C                   MOVEL     'CSE010'      DBKEY                                        CSE010
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CSE010
     C                   MOVEL     '912'         DBASE                                        CSE010
     C                   EXSR      SRERR                                                      CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CSE010
     C     @RTCD         IFEQ      *BLANK                                                     CSE010
     C                   MOVE      'Y'           CSE010                                       CSE010
     C                   ELSE                                                                 CSE010
     C                   MOVE      'N'           CSE010            1                          CSE010
     C                   ENDIF                                                                CSE010
      *                                                                                       CGL011
      ** Access Switchable Features file to check if CGL011                                   CGL011
      ** is installed.                                                                        CGL011
      *                                                                                       CGL011
     C                   Move      'N'           CGL011            1                          CGL011
      *                                                                                       CGL011
     C                   CallB     'AOSARDR0'                                                 CGL011
     C                   Parm      *BLANKS       @RTCD                                        CGL011
     C                   Parm      '*VERIFY'     @OPTN                                        CGL011
     C                   Parm      'CGL011'      @SARD                                        CGL011
      *                                                                                       CGL011
     C     @RTCD         IfNe      *BLANKS                                                    CGL011
     C     @RTCD         AndNe     '*NRF   '                                                  CGL011
     C                   MoveL     '913'         DBASE                                        CGL011
     C                   MoveL     'SCSARDPD'    DBFILE                                       CGL011
     C                   MoveL     'CGL011'      DBKEY                                        CGL011
     C                   Exsr      *PSSR                                                      CGL011
     C                   EndIf                                                                CGL011
      *                                                                                       CGL011
     C     @RTCD         IfEq      *BLANKS                                                    CGL011
     C                   Move      'Y'           CGL011                                       CGL011
     C                   EndIf                                                                CGL011
 
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        LIBR = S1SUPP                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C                   EVAL      DBKEY  = 'CSC011'                                          CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE  = 916                                               CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       207006
      ** Access Switchable Features file to check if CSE029                                   207006
      ** is installed.                                                                        207006
      *                                                                                       207006
     C                   Move      'N'           CSE029            1                          207006
     C                   CallB     'AOSARDR0'                                                 207006
     C                   Parm      *BLANKS       @RTCD                                        207006
     C                   Parm      '*VERIFY'     @OPTN                                        207006
     C                   Parm      'CSE029'      @SARD                                        207006
      *                                                                                       207006
     C     @RTCD         IfNe      *BLANKS                                                    207006
     C     @RTCD         AndNe     '*NRF   '                                                  207006
     C                   MoveL     '916'         DBASE                                        207006
     C                   MoveL     'SCSARDPD'    DBFILE                                       207006
     C                   MoveL     'CSE029'      DBKEY                                        207006
     C                   Exsr      *PSSR                                                      207006
     C                   EndIf                                                                207006
      *                                                                                       207006
     C     @RTCD         IfEq      *BLANKS                                                    207006
     C                   Move      'Y'           CSE029                                       207006
     C                   EndIf                                                                207006
                                                                                              CSC011
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SEDPMVV038
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
