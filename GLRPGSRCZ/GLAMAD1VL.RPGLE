     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account master details validation')           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD1VL -  Account Master Details Validation               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. CER069             Date 03Jul14               *
      *                 MD024336A          Date 19Aug14               *
      *                 MD024398           Date 11May14               *
      *                 CGL123             Date 12Dec12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR869261           Date 13Dec11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 AR762349           Date 03Jun11               *
      *                 AR760540A          Date 25May11               *
      *                 AR761933           Date 26May11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 262025             Date 19Oct09               *
      *                 BUG23886           Date 26May09               *
      *                 BUG24157           Date 04Jun09               *
      *                 BUG22747           Date 12Feb09               *
      *                 BUG22745           Date 09Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27466           Date 21Apr10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG16622           Date 14Mar08               *
      *                 249054             Date 28May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 231128             Date 16Oct06               *
      *                 242488             Date 27Sep06               *
      *                 227198             Date 30Jun06               *
      *                 CDL013             Date 08Jun06               *
      *                 239720             Date 11May06               *
      *                 238639             Date 27Feb06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8550            Date 07Oct05               *
      *                 BUG7967            Date 29Jul05               *
      *                 BUG8625            Date 29Sep05               *
      *                 BUG8471            Date 14Sep05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG5340            Date 06Apr05               *
      *                 BUG4615            Date 26Oct04               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG3365            Date 24Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 225892  BUG1522    Date 19Mar04               *
      *                 CGL029             Date 27Mar04               *
      *                 CSD012             Date 15Oct02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 203214             Date 28May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 14Feb99               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 180721             Date 03May00               *
      *                 CUT009             Date 19Feb01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 19Oct99               *
      *                 CFT004             Date 05Nov99               *
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax                                *
      *  CER069 - German Tax Enhancement                              *
      *  MD024336A - Account name in error as blank if Account not    *
      *              found                                            *
      *  MD024398 - API Performance Optimisation                      *
      *  CGL123 - Issue a warning message during closure of account   *
      *           if there is a remaining balance at Profit Centre    *
      *           level.                                              *
      *           Added hooks: OFCPYSRCZ,CGL123_001                   *
      *                        OFCPYSRCZ,CGL123_002                   *
      *                        OFCPYSRCZ,CGL123_003                   *
      *         - Applied fix AR895874 :                              *
      *             CGL123 Warning was issued during account creation.*
      *             Warning message should only be issued during      *
      *             Account closure. Recompile due to changes in      *
      *             OFCPYSRCZ,CGL123_003. (Child: AR895875)           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR869261 - Account Name defaulted to old customer when       *
      *             it is manually inserted                           *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  AR762349 - Self-Report Customer validation issues            *
      *  AR760540A - Block/Refer debit and credit fields are not      *
      *              defaulted                                        *
      *  AR761933 - Unable to transamit AMAD transaction via SOAP API *
      *  CRE075 - Effective Date for Retail Accounts                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  262025 - Problem with IBAN number generation. Re-initialize  *
      *           DDIBAN field when Action Code is Insert.            *
      *  BUG23886 - Account insert - Taxable indicator defaults       *
      *           to Threshold                                        *
      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
      *             when field is set to Y                            *
      *  BUG22747 - 'Y' should not be an option if customer is        *
      *           non-taxable. Correct retrieval of European Tax      *
      *           status.                                             *
      *  BUG22745 - Error on defaulting and validation of Tax         *
      *             Indicator.                                        *
      *  CER048 - German Features - Taxes                             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  BUG27466 - Apply fix BUG25813                                *
      *  BUG25813 - Duplicate error for account code                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16622 - Warning message must shown if closing an account  *
      *             with balance not equal to zero                    *
      *  249054 - Applied core fix 248025                             *
      *  248025 - Subject to A/C charge (ATCHIN) should be 'N' if     *
      *           Fixed A/C Charge (FACH) is 'N' in RE ICD.           *
      *           Completed fix 242488.                               *
      *  231128 - Same fix as 242488.                                 *
      *  242488 - Interest Taxable should not be checked if taxes is  *
      *           off. Validate other ACCNTBXC fields in all cases.   *
      *           Apply fix 239720/238639/227198.                     *
      *  227198 - Unable to insert retail account. Keep getting       *
      *           message TAM4801 (Interest Taxable must be Y on N)   *
      *           eventhough the field is not displayed.              *
      *  CDL013 - Tiered Withholding Tax                              *
      *  239720 - Interest Taxable should not be checked if taxes is  *
      *           off. Validate other ACCNTBXC fields in all cases    *
      *           Applied 238639.                                     *
      *  238639 - Interest Taxable should not be checked if taxes is  *
      *           off. Validate other ACCNTBXC fields in all cases    *
      *           Applied 231128                                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  BUG7967 - Show warning message upon deletion of account      *
      *            with cheque book details still existing            *
      *  BUG8625 - Default DDITAX to N if BGNTST is OFF               *
      *  BUG8471- Cannot authorise deletion in SDA due to DB error    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  BUG5340 - Validate TI account details.                       *
      *  BUG4615 - Show warning message upon deletion of account      *
      *            with cheque book details still existing            *
      *  CSD025 - Customer De-Activation                              *
      *  BUG3365 - Add account sequence to GLVTIAC (SP6GL0001).       *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  225892 - Stop job looping when CCY is *Blank                 *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD012 - Standing Data Authorisation                         *
      *  208221 - Default Margin from Rate/Spread changes (Recompile) *
      *  203214 - Cannot Amend an account from TOF as block C/D       *
      *          is not correct in TOF.                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CDE002 - CCRM Revenue Analysis - Recompile only              *
      *  180721 - Default "Next Statement Date" when opening          *
      *           Account coming from interface                       *
      *         - Retail Account Number must be calculated            *
      *  CUT009 - Manual addition of core hooks.                      *
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
      *****************************************************************
      *                                                                                       CSD012
     FSDAULGL0  IF   E           K DISK    INFSR(*PSSR)                                       CSD012
      * RTV : Authorisation Log - by Key                                                      CSD012
 
     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)                                     BUG16622
     F                                     PREFIX(A1)                                       BUG16622
      ** Account details                                                                    BUG16622
      *                                                                                       CER048
     FSDACTXL1  IF   E           K DISK                                                       CER048
      *                                                                                       CER048
      ** Customer Details by Country of Tax                                                   CER048
      *                                                                                       CER048
     FSDCTTXL0  IF   E           K DISK                                                     BUG23886
      *                                                                                     BUG23886
      ** Midas SD Country of Tax Codes                                                      BUG23886
      *                                                                                     BUG23886
     FSDBRCHL0  IF   E           K DISK    INFSR(*PSSR)                                       262025
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDActnOK                      1A
     D  DDAccnOK                      1A
     D  DDRFrAOK                      1A
     D  DDBrcaOK                      1A
     D  DDCUSNOK                      1A
     D  DDCcyOK                       1A
     D  DDACodOK                      1A
     D  DDAcSqOK                      1A
     D  DDAcNoOK                      1A
     D  DDAnamOK                      1A
     D  DDDAcOOK                      1A
     D  DDNStDOK                      1A
     D  DDStFqOK                      1A
     D  DDENoCOK                      1A
     D  DDNSDNOK                      1A
     D  DDEUSBOK                      1A
     D  DDPtAdOK                      1A
     D  DDRefOK                       1A
     D  DDRADOK                       1A
     D  DDRACOK                       1A
     D  DDBADOK                       1A
     D  DDBACOK                       1A
     D  DDTIAcOK                      1A
     D  DDTIANOK                      1A
     D  DDTIASOK                      1A
     D  DDPrfCOK                      1A
     D  DDMFFqOK                      1A
     D  DDPtfROK                      1A
     D  DDITAXOK                      1A
     D  DDTXC1OK                      1A                                                      CGL165
     D  DDTXC2OK                      1A                                                      CGL165
     D  DDSTCIOK                      1A
     D  DDCHINOK                      1A
     D  DDCHAMOK                      1A
     D  DDIBANOK                      1A                                        CFT004
     D  DD24COK                       1A                                                    BUG24157
     D  DDEFDTOK                      1A                                                      CRE075
 
     D KCNUM           S                   LIKE(DDCUSN)                                     BUG16622
     D KCCY            S                   LIKE(DDCCY)                                      BUG16622
     D KACOD           S             10S 0                                                  BUG16622
     D KACSQ           S              2S 0                                                  BUG16622
     D KBRCA           S                   LIKE(DDBRCA)                                     BUG16622
 
      *                                                                                     BUG22747
      ** External data structures for Location Details                                      BUG22747
      *                                                                                     BUG22747
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                BUG22747
      *                                                                                     BUG22747
      ** External data structures for Branch Details                                        BUG22747
      *                                                                                     BUG22747
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                BUG22747
     D   AQQDFAC     E                     EXTFLD(QQDFAC)                                   BUG22747
      *                                                                                     BUG22747
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D RETABLE       E DS                  EXTNAME(TABTBRE)
      ** EXTERNAL DS FOR RETAIL TABLE FILE
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  RLACCD       E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR RETAIL DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
                                                                                              CDL013
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CDL013
      ** EXTERNAL DS FOR CUSTOMER DETAILS                                                     CDL013
                                                                                              CDL013
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** Portfolio Management ICD Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D ValidAccn     E DS                  EXTNAME(GLVAMADPD)
      * Valid Account layout -> ACCNTAB
 
     D ValidExBX     E DS                  EXTNAME(GLVAMBXPD)
     D  GBACCD       E                     EXTFLD(QQACOD)                                     CGL029
      * Valid Extn. Account layout -> ACCNTBXC
 
     D TranIn        E DS                  EXTNAME(GLAMADPD)
      * Incoming Transaction
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D ZMUSER          DS            17
      * ZMUSER data layout
     D  DBRN                  11     13
 
     D RUNDAT          DS            13
      * Rundate data area
     D  AGMBIN                13     13
 
     D*PKEY*****       DS            20                                                CSD012 CGL029
     D PKEY            DS            26                                                       CGL029
     D PBRCA                   1      3                                                       CSD012
     D PCUSN                   4      9                                                       CSD012
     D PCCY                   10     12                                                       CSD012
     D*PACOD****              13     16                                                CSD012 CGL029
     D*PACSQ****              17     18                                                CSD012 CGL029
     D PACOD                  13     22                                                       CGL029
     D PACSQ                  23     24                                                       CGL029
                                                                                              CSD012
     D/COPY OFCPYSRCZ,CGL123_001                                                              CGL123
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
      ** Fields defined for Enhancement CSC011                                                CSC011
     D CSC011          S              1A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CER048
                                                                                              CSC011
     D CER047          S              1A                                                    BUG24157
     D CER048          S              1A                                                      CER048
     D PAcHlF          S              1A                                                      CER048
     D PKey1           S             10A                                                      CER048
     D PKyst           S              7A                                                      CER048
      *                                                                                       CER048
     D KFCusn          S              6A                                                      CER048
     D KFCtax          S              2A                                                      CER048
      *                                                                                     BUG23886
     D KCtTx           S              2A                                                    BUG23886
     D KCtRe           S              2A                                                    BUG23886
     D WThrMtd         S              1A                                                    BUG23886
      *                                                                                       CER048
     D PBrch           S              3a                                                    BUG22747
     D PLocn           S              3A                                                    BUG22747
                                                                                              CRE075
     D CRE075          S              1A                                                      CRE075
     D CER069          S              1A                                                      CER069
     D CGL165          S              1A                                                      CGL165
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      **  Retrieve ZMUSER details                                                            BUG8550
                                                                                             BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550
      *                                                                                       CUT009
     C     CHKACC        KLIST                                                              BUG16622
     C                   KFLD                    KCNUM                                      BUG16622
     C                   KFLD                    KCCY                                       BUG16622
     C                   KFLD                    KACOD                                      BUG16622
     C                   KFLD                    KACSQ                                      BUG16622
     C                   KFLD                    KBRCA                                      BUG16622
      *                                                                                     BUG16622
      /COPY WNCPYSRC,GLAMAD1V01                                                               CUT009
      ** Call Validation Modules in Sequence
      *
      ** Validation for Primary Screen
     C     WFMT          IFEQ      'F0'
      ** Validate Action Code, Account Number & Review From Account
     C                   EXSR      VACCNTKY
     C                   ENDIF
      *
      /COPY WNCPYSRC,GLAMAD1V02                                                               CUT009
      ** Validation for Key Screen
     C     WFMT          IFEQ      'FK'
      ** Run all remaining validation if called from CTL pgm
     C     WFMT          OREQ      *BLANKS
      *                                                                                       CSD012
      ** If Authorisation check is on,                                                        CSD012
      ** check if unathorised record exists on Authorisation Log.                             CSD012
 B01 C     AUTHRQ        IFEQ      'Y'                                                        CSD012
     C     AUTHMD        ANDNE     'X'                                                        CSD012
     C     DDACTN        ANDNE     'E'                                                        CSD012
      *                                                                                       CSD012
     C                   MOVEL     DDBRCA        PBRCA                                        CSD012
     C                   MOVEL     DDCUSN        PCUSN                                        CSD012
     C                   MOVEL     DDCCY         PCCY                                         CSD012
     C                   MOVEL     DDACOD        PACOD                                        CSD012
     C                   MOVEL     DDACSQ        PACSQ                                        CSD012
      *                                                                                       CSD012
     C     PKEY          CHAIN     SDAULGL0                           90                      CSD012
      *                                                                                       CSD012
      ** If record exists then prevent amendment and return                                   CSD012
 B02 C     *IN90         IFEQ      *OFF                                                       CSD012
     C                   MOVEL     'N'           DDACCNOK                                     CSD012
     C                   MOVE      1             Idx                                          CSD012
     C                   MOVEL     DDCUSN        FldNamXAr(Idx)                               CSD012
     C                   MOVEL     'USR9265'     MsgIDXAr(Idx)                                CSD012
      *                                                                                       CSD012
      ** Update error info                                                                    CSD012
     C                   EXSR      UPDATERRS                                                  CSD012
      *                                                                                       CSD012
     C                   RETURN                                                               CSD012
 E02 C                   ENDIF                                                                CSD012
 E02 C                   ENDIF                                                                CSD012
      *                                                                                       CSD012
      ** Validate Branch
      /COPY WNCPYSRC,GLAMAD1V03                                                               CUT009
     C                   EXSR      VBranch
      /COPY WNCPYSRC,GLAMAD1V04                                                               CUT009
      ** Validate Customer Number
      /COPY WNCPYSRC,GLAMAD1V05                                                               CUT009
     C                   EXSR      VCustNo
      /COPY WNCPYSRC,GLAMAD1V06                                                               CUT009
      ** Validate Currency
      /COPY WNCPYSRC,GLAMAD1V07                                                               CUT009
     C                   EXSR      VCurrency
      /COPY WNCPYSRC,GLAMAD1V08                                                               CUT009
      ** Validate Account Code & Sequence
      /COPY WNCPYSRC,GLAMAD1V09                                                               CUT009
     C                   EXSR      VACSQ
      /COPY WNCPYSRC,GLAMAD1V10                                                               CUT009
      ** Validate GL & Retail Account Number
      /COPY WNCPYSRC,GLAMAD1V11                                                               CUT009
     C                   EXSR      VAccount
      /COPY WNCPYSRC,GLAMAD1V12                                                               CUT009
                                                                                            AR869261
      ** Default Account Name only if the field is blank and all fields                     AR869261
      ** from the initial screen has been validated                                         AR869261
                                                                                            AR869261
     C                   IF        DDBrcaOK = 'Y' AND                                       AR869261
     C                             DDCUSNOK = 'Y' AND                                       AR869261
     C                             DDCcyOK  = 'Y' AND                                       AR869261
     C                             DDACodOK = 'Y' AND                                       AR869261
     C                             DDAcSqOK = 'Y' AND                                       AR869261
     C                             DDAcNoOK = 'Y' AND                                       AR869261
     C                             DDANAM  =  *BLANKS                                       AR869261
     C                   CALL      'AOCUSTR0'                                               AR869261
     C                   PARM      '*DBERR '     @RTCD                                      AR869261
     C                   PARM      '*KEY   '     @OPTN                                      AR869261
     C                   PARM      DDCUSN        @CUSNN                                     AR869261
     C                   PARM      *BLANKS       @CSTAT                                     AR869261
     C     SDCUST        PARM      SDCUST        DSLDY                                      AR869261
                                                                                            AR869261
      ** Retrieve Account Name from Customer Report Name                                    AR869261
                                                                                            AR869261
     C                   EVAL      DDANAM = BBCRNM                                          AR869261
     C                   ENDIF                                                              AR869261
     C                   ENDIF
      *
      /COPY WNCPYSRC,GLAMAD1V13                                                               CUT009
      ** Validation for First Detail Screen
     C     WFMT          IFEQ      'F1'
      ** Run all remaining validation if called from CTL pgm
     C     WFMT          OREQ      *BLANKS
      *
      ** Validate Retail Account Name
      /COPY WNCPYSRC,GLAMAD1V14                                                               CUT009
                                                                                           MD024336A
      ** Validate only if Key fields are valid.                                            MD024336A
                                                                                           MD024336A
     C                   IF        DDBrcaOK = 'Y' AND                                      MD024336A
     C                             DDCUSNOK = 'Y' AND                                      MD024336A
     C                             DDCcyOK  = 'Y' AND                                      MD024336A
     C                             DDACodOK = 'Y' AND                                      MD024336A
     C                             DDAcSqOK = 'Y' AND                                      MD024336A
     C                             DDAcNoOK = 'Y'                                          MD024336A
     C                   EXSR      VAccntNm
     C                   ENDIF                                                             MD024336A
      /COPY WNCPYSRC,GLAMAD1V15                                                               CUT009
      ** Validate Date Account Opened
      /COPY WNCPYSRC,GLAMAD1V16                                                               CUT009
     C                   EXSR      VDatAcOp
                                                                                              CRE075
      ** Validate Effective Date for Retail Accounts                                          CRE075
                                                                                              CRE075
     C                   IF        CRE075 = 'Y'                                               CRE075
     C                   EXSR      VEffDate                                                   CRE075
     C                   ENDIF                                                                CRE075
                                                                                              CRE075
      /COPY WNCPYSRC,GLAMAD1V17                                                               CUT009
      *                                                                         180721
      ** Default Next Statement Date if necessary                               180721
     C     BGN4ST        Ifeq      'Y'                                          180721
     C     DDNSTD        Andeq     *blanks                                      180721
     C     DDCcyOK       Andeq     'Y'                                                        225892
     C                   EXSR      DNxtSDat                                     180721
     C                   Endif                                                  180721
      *                                                                         180721
      ** Validate Next Statement Date
      /COPY WNCPYSRC,GLAMAD1V18                                                               CUT009
     C                   EXSR      VNxtSDat
      /COPY WNCPYSRC,GLAMAD1V19                                                               CUT009
      ** Validate Frequency, No. of Copies, and Next Statement Day no.
      /COPY WNCPYSRC,GLAMAD1V20                                                               CUT009
     C                   EXSR      VFqNcNsd
      /COPY WNCPYSRC,GLAMAD1V21                                                               CUT009
      ** Validate Print Address Y/N, and Address Reference
      /COPY WNCPYSRC,GLAMAD1V22                                                               CUT009
     C                   EXSR      VPTADREF
      /COPY WNCPYSRC,GLAMAD1V23                                                               CUT009
      ** Validate Refer All and Block All
      /COPY WNCPYSRC,GLAMAD1V24                                                               CUT009
                                                                                              CRE075
      ** Process Defaulting of Refer and Block Debit/Credit if CRE075 is ON.                  CRE075
                                                                                              CRE075
     C                   IF        CRE075 = 'Y' AND WWRETL = 'Y'                              CRE075
                                                                                              CRE075
     C                   IF        DDEFDTOK <> 'N'                                            CRE075
     C                   EXSR      DRfrNBlk                                                   CRE075
     C                   ENDIF                                                                CRE075
                                                                                              CRE075
     C                   ELSE                                                                 CRE075
                                                                                              CRE075
     C     DDRAD         IFEQ      ' '                                                        203214
     C                   MOVE      'N'           DDRAD                                        203214
     C                   END                                                                  203214
     C     DDRAC         IFEQ      ' '                                                        203214
     C                   MOVE      'N'           DDRAC                                        203214
     C                   END                                                                  203214
     C     DDBAD         IFEQ      ' '                                                        203214
     C                   MOVE      'N'           DDBAD                                        203214
     C                   END                                                                  203214
     C     DDBAC         IFEQ      ' '                                                        203214
     C                   MOVE      'N'           DDBAC                                        203214
     C                   END                                                                  203214
                                                                                              CRE075
     C                   ENDIF                                                                CRE075
                                                                                              CRE075
     C                   EXSR      VRfrNBlk
      /COPY WNCPYSRC,GLAMAD1V25                                                               CUT009
      *                                                                                     AR761933
     C     BGN3ST        IFEQ      'Y'                                                      AR761933
     C     DDTIAC        ANDEQ     ' '                                                      AR761933
     C                   MOVE      'N'           DDTIAC                                     AR761933
     C                   ENDIF                                                              AR761933
      *                                                                                     AR761933
      ** Validate TI Account
      /COPY WNCPYSRC,GLAMAD1V26                                                               CUT009
     C                   EXSR      VTIAccnt
      /COPY WNCPYSRC,GLAMAD1V27                                                               CUT009
      ** Validate Statement Balance in Euros and Archiving Frequency
      /COPY WNCPYSRC,GLAMAD1V28                                                               CUT009
     C                   EXSR      VEUSBMFQ
      /COPY WNCPYSRC,GLAMAD1V29                                                               CUT009
      ** Validate Profit Centre and Portfolio Reference
      /COPY WNCPYSRC,GLAMAD1V30                                                               CUT009
     C     DDACODOK      IFEQ      'Y'                                                      BUG25813
     C                   EXSR      VPRFCPTF
     C                   ENDIF                                                              BUG25813
      /COPY WNCPYSRC,GLAMAD1V31                                                               CUT009
      ** Validate International Bank Account Number IBAN                        CFT004
      /COPY WNCPYSRC,GLAMAD1V32                                                               CUT009
     C     CFT004        IFEQ      'Y'                                          CFT004
      *                                                                                       262025
      ** Check the Generated Entry Method based on branch code used.                          262025
      *                                                                                       262025
     C     DDBRCA        CHAIN     SDBRCHL0                           90                      262025
     C     *IN90         IFEQ      *OFF                                                       262025
     C                   MOVEL     A8GENM        WGENM             1                          262025
     C                   ENDIF                                                                262025
      *                                                                                       262025
     C     *IN11         IFEQ      *OFF                                                       262025
     C     DDACTN        ANDEQ     'I'                                                        262025
     C     AMATYP        ANDEQ     'R'                                                        262025
     C     A8GENM        ANDNE     '1'                                                        262025
     C                   MOVEL     *BLANKS       DDIBAN                                       262025
     C                   ENDIF                                                                262025
      *                                                                                       262025
     C                   EXSR      ValIBAN                                      CFT004
     C                   ENDIF                                                  CFT004
      /COPY WNCPYSRC,GLAMAD1V33                                                               CUT009
      *                                                                                     BUG24157
      ** Validate KWG @24c reporting                                                        BUG24157
      *                                                                                     BUG24157
     C                   IF        CER047 = 'Y'                                             BUG24157
     C                   EXSR      SRVK24C                                                  BUG24157
     C                   ENDIF                                                              BUG24157
      *
     C     AMATYP        IFEQ      'R'                                                        239720
     C*****BGWDPR        IFEQ      'Y'                                                        239720
     C*****AMATYP        ANDEQ     'R'                                                        239720
      ***********                                                                             239720
     C*****BGSWRT        IFEQ      'Y'                                                        239720
     C*****BGNTST        OREQ      'Y'                                                        239720
     C*****FACH**        OREQ      'Y'                                                        239720
     C*****TSTMC*        OREQ      'Y'                                                        239720
      *
      ** Interest Taxable Flag
      /COPY WNCPYSRC,GLAMAD1V34                                                               CUT009
      ** Only validate if Taxable module switched ON                                          227198
     C     BGNTST        IFEQ      'Y'                                                        227198
     C                   EXSR      VITAXFLG
     C                   EXSR      VITAXCOD                                                   CGL165
     C                   ENDIF                                                                227198
      /COPY WNCPYSRC,GLAMAD1V35                                                               CUT009
      ** Statement Charge Flag
      /COPY WNCPYSRC,GLAMAD1V36                                                               CUT009
     C                   EXSR      VSTCIFLG
      /COPY WNCPYSRC,GLAMAD1V37                                                               CUT009
      ** Subject to Account Charge Flag
      /COPY WNCPYSRC,GLAMAD1V38                                                               CUT009
     C                   EXSR      VCHINFLG
      /COPY WNCPYSRC,GLAMAD1V39                                                               CUT009
      ** Account Charge Amount
      /COPY WNCPYSRC,GLAMAD1V40                                                               CUT009
     C                   EXSR      VCHAM
      /COPY WNCPYSRC,GLAMAD1V41                                                               CUT009
      *
     C**********         ENDIF                                                                239720
      *
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                     BUG16622
     C                   IF        DDACTN = 'D'                                             BUG16622
     C                   MOVEL     DDCUSN        KCNUM                                      BUG16622
     C                   MOVEL     DDCCY         KCCY                                       BUG16622
     C                   MOVEL     DDACOD        KACOD                                      BUG16622
     C                   MOVEL     DDACSQ        KACSQ                                      BUG16622
     C                   MOVEL     DDBRCA        KBRCA                                      BUG16622
     C     CHKACC        CHAIN     ACCNTABF                                                 BUG16622
     C                   IF        %FOUND(ACCNTL0)                                          BUG16622
     C                   IF        A1LDBL <> *ZEROS                                         BUG16622
     C                             OR A1CLBL <> *ZEROS                                      BUG16622
     C                   EXSR      RESETERRS                                                BUG16622
     C                   EVAL      WFldNmXAr(1) = '*ANY   '                                 BUG16622
     C                   EVAL      WMsgIDXAr(1) = 'RE77101'                                 BUG16622
     C                   EXSR      UPDATERRS                                                BUG16622
     C                   ENDIF                                                              BUG16622
     C                   ENDIF                                                              BUG16622
     C                   ENDIF                                                              BUG16622
      *
     C/COPY OFCPYSRCZ,CGL123_003                                                              CGL123
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
     C/COPY WNCPYSRC,GLAMA1VC03
      *****************************************************************
      ** VACCNTKY - Validate Action Code, A/c No. & Review from fld
      *****************************************************************
     C     VACCNTKY      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVACCD'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDACTN
     C                   Parm                    DDACCN
     C                   Parm                    DDRFRA
      *
     C                   Parm                    @IN34             1
      *
      ** ICD
     C                   Parm                    DBRN
     C                   Parm                    BJSBRC
     C                   Parm                    AGMBIN
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Full GL Account Number
     C**********         Parm      *BLANKS       WGLKEY           18                          CGL029
     C                   Parm      *BLANKS       WGLKEY           24                          CGL029
      *
      ** Action code - OK
      ** Account Number - OK
      ** Review From Account - OK
     C                   Parm                    DDACTNOK
     C                   Parm                    DDACCNOK
     C                   Parm                    DDRFRAOK
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBRANCH - Validate Branch
      *****************************************************************
     C     VBRANCH       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVBHCD01'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Response mode (1A), from source system common header
     C                   PARM                    RespMode
      *
      ** Account Screen fields
     C                   PARM                    DDBRCA                         booking branch
     C                   Parm                    DDACTN
      *
      ** ICD
     C                   Parm                    BJSBRC
     C                   Parm                    DBRN
     C                   Parm                    AGMBIN
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Branch Internal Customer
     C                   Parm                    A8BICN            6
      *
      ** Branch code - OK
     C                   Parm                    DDBrcaOK                         action code
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCUSTNO - Validate Customer Number
      *****************************************************************
     C     VCUSTNO       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Customer, Book, Portfolio & Profit Centre
      *
     C                   CALLB     'GLVCSNB'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   PARM                    DDCUSN                         action code
      *
      ** Action Code field                                                                    CSD025
     C                   PARM                    DDACTN                                       CSD025
      *                                                                                       CSD025
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Customer - OK
     C                   PARM                    DDCUSNOK                       customer
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCURRENCY - Validate Currency
      *****************************************************************
     C     VCURRENCY     BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVCYCY'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   PARM                    DDCCY                          booking branch
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Currency - OK
     C                   PARM                    DDCcyOK                          action code
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VACSQ    - Validate Account Code and Sequence
      *****************************************************************
     C     VACSQ         BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVACSQ'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDACod                         customer
     C                   Parm                    DDAcSq                         customer
     C                   Parm                    DDCUSN                         customer
      *
      ** ICD
     C                   Parm                    A8BICN
     C                   Parm                    AGMBIN
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   Parm                    AMATYP            1
     C                   Parm                    AMSTYP            1
     C                   Parm                    A5TOIN            1
     C                   Parm                    WWRETL            1
      *
      ** Account Code - Ok
      ** Account Seq  - Ok
     C                   Parm                    DDACodOk                       customer
     C                   Parm                    DDAcSqOk                       customer
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VACCOUNT - Validate GL & Retail Account Number
      *****************************************************************
     C     VACCOUNT      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVRLAC'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDActn
     C                   Parm                    DDBrca
     C                   Parm                    DDCUSN
     C                   Parm                    DDCcy
     C                   Parm                    DDACod
     C                   Parm                    DDAcSq
     C                   Parm                    DDAcNo
     C                   Parm                    DDANam
      *
      ** Output of Sr/VACSQ
     C                   Parm                    WWRetl
      *
      ** ICD
     C                   Parm                    BMRANR
     C                   Parm                    BMLDAI
     C                   Parm                    BGN1ST
     C**********         Parm                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
      *
      ** Access from SDACODPD from pgm/GLVACSQ
     C                   Parm                    A5TOIN
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Account Name - Ok
      ** Retail Account - Ok
      ** Customer - OK
      ** Currency - OK
      ** Account code - OK
      ** Account Seq - OK
     C                   Parm                    DDANamOK
     C                   Parm                    DDAcNoOK
     C                   Parm                    DDCUSNOK
     C                   Parm                    DDCcyOK
     C                   Parm                    DDACodOK
     C                   Parm                    DDAcSqOK
                                                                                             BUG4615
      * Warning message IDs/message data (arrays) from/to caller                             BUG4615
                                                                                             BUG4615
     C                   PARM                    WFldNmXAr                                   BUG4615
     C                   PARM                    WMsgIDXAr                                   BUG4615
     C                   PARM                    WMsgDtXAr                                   BUG4615
 
      * Update error info with that returned from the validation module
 
     C     RetCodeOut    IFNE      *BLANKS                                                    262025
     C                   MOVE      *ON           *IN11                                        262025
     C                   ELSE                                                                 262025
     C                   MOVE      *OFF          *IN11                                        262025
     C                   ENDIF                                                                262025
      *                                                                                       262025
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VACCNTNM - Validate Account Name
      *****************************************************************
     C     VACCNTNM      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVACNM'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDANAM
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Account Name - Ok
     C                   Parm                    DDANamOK
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VDATACOP - Validate Date Account Opend
      *****************************************************************
     C     VDATACOP      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVACDT'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDACTN
     C                   Parm                    DDDACO
      *
      ** ICD
     C**********         Parm                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   Parm                    BJDFIN
     C                   Parm                    BJBVPD
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Date Account Open work field
     C                   Parm      *ZERO         WWDAcO            5 0
      *
      ** Date Account Open - Ok
     C                   Parm                    DDDAcOOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                    180721
      *****************************************************************                       CRE075
      ** VEFFDATE - Validate Effective Date for Retail Accounts                               CRE075
      *****************************************************************                       CRE075
     C     VEFFDATE      BEGSR                                                                CRE075
                                                                                              CRE075
      ** Effective Date should only be validated if Date Account Opened                       CRE075
      ** is valid.                                                                            CRE075
                                                                                              CRE075
     C                   IF        DDDAcOOk = 'Y'                                             CRE075
                                                                                              CRE075
      ** Reset variables updated by each module                                               CRE075
                                                                                              CRE075
     C                   EXSR      RESETERRS                                                  CRE075
                                                                                              CRE075
     C                   CALLB     'GLVEFDT'                                                  CRE075
                                                                                              CRE075
      ** INPUTS                                                                               CRE075
                                                                                              CRE075
      ** Return Code                                                                          CRE075
                                                                                              CRE075
     C                   PARM                    RetCodeOut                                   CRE075
                                                                                              CRE075
      ** Account Screen fields                                                                CRE075
                                                                                              CRE075
     C                   PARM                    DDACTN                         Action code   CRE075
     C                   PARM                    DDDACO                         DateAccntOpen CRE075
     C                   PARM                    DDEFDT            6            Effective DateCRE075
     C                   PARM                    DDCCY                          CCY           CRE075
     C                   PARM                    DDBRCA                         Booking BranchCRE075
     C                   PARM                    WWRETL                         Retail Flag   CRE075
     C                   PARM                    WWDAcO                                       CRE075
                                                                                              CRE075
      ** ICD                                                                                  CRE075
                                                                                              CRE075
     C                   PARM                    WRunDay                                      CRE075
     C                   PARM                    BJDFIN                                       CRE075
     C                   PARM                    BJBVPD                                       CRE075
     C                   PARM                    BJLCCY                                       CRE075
     C                   PARM                    BJSLCD                                       CRE075
                                                                                              CRE075
      ** Account Key                                                                          CRE075
                                                                                              CRE075
     C                   PARM                    DDCUSN                                       CRE075
     C                   PARM                    DDACOD                                       CRE075
     C                   PARM                    DDACSQ                                       CRE075
                                                                                              CRE075
      ** OUTPUTS                                                                              CRE075
      ** Error fields/message IDs/message data (arrays) from/to caller                        CRE075
                                                                                              CRE075
     C                   PARM                    FldNamXAr                                    CRE075
     C                   PARM                    MsgIDXAr                                     CRE075
     C                   PARM                    MsgDtaXAr                                    CRE075
                                                                                              CRE075
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE075
                                                                                              CRE075
     C                   PARM                    WFldNmXAr                                    CRE075
     C                   PARM                    WMsgIDXAr                                    CRE075
     C                   PARM                    WMsgDtXAr                                    CRE075
                                                                                              CRE075
      ** Effective Date work field                                                            CRE075
                                                                                              CRE075
     C                   PARM      *ZERO         WWEfdt            5 0                        CRE075
                                                                                              CRE075
      ** Effective date - Ok                                                                  CRE075
                                                                                              CRE075
     C                   PARM                    DDEFDTOK                                     CRE075
                                                                                              CRE075
      ** Update error info with that returned from the validation module                      CRE075
                                                                                              CRE075
     C                   EXSR      UPDATERRS                                                  CRE075
                                                                                              CRE075
     C                   ENDIF                                                                CRE075
     C                   ENDSR                                                                CRE075
      *****************************************************************                       CRE075
     C/EJECT                                                                                  CRE075
      *****************************************************************                       CRE075
      ** DRFRNBLK - Default Refer and Block Debit/Crebit                                      CRE075
      *****************************************************************                       CRE075
     C     DRfrNBlk      BEGSR                                                                CRE075
                                                                                              CRE075
      ** If a New Retail account is opened and the Effective Date is                          CRE075
      ** greater than rundate, values are defaulted as follows:                               CRE075
                                                                                              CRE075
     C                   IF        (DDACTN = 'I' OR                                           CRE075
     C                              DDACTN = 'A') AND                                         CRE075
     C                             WWEfDt > BJRDNB                                            CRE075
      *                                                                                    AR760540A
     C     DDBAD         IFEQ      ' '                                                     AR760540A
     C                   MOVE      'Y'           DDBAD                                     AR760540A
     C                   END                                                               AR760540A
     C     DDBAC         IFEQ      ' '                                                     AR760540A
     C                   MOVE      'Y'           DDBAC                                     AR760540A
     C                   END                                                               AR760540A
     C     DDRAD         IFEQ      ' '                                                     AR760540A
     C                   MOVE      'N'           DDRAD                                     AR760540A
     C                   END                                                               AR760540A
     C     DDRAC         IFEQ      ' '                                                     AR760540A
     C                   MOVE      'N'           DDRAC                                     AR760540A
     C                   END                                                               AR760540A
                                                                                              CRE075
      ** If not equal to the default values issue warning message                             CRE075
                                                                                              CRE075
     C                   IF        DDRAD <> 'N' OR                                            CRE075
     C                             DDRAC <> 'N' OR                                            CRE075
     C                             DDBAD <> 'Y' OR                                            CRE075
     C                             DDBAC <> 'Y'                                               CRE075
                                                                                              CRE075
     C                   EVAL      WIdx = 1                                                   CRE075
     C                   EVAL      WFldNmXAr(WIdx) = '*ANY  '                                 CRE075
     C                   EVAL      WMsgIDXAr(WIdx) = 'RE71076'                                CRE075
     C                   EXSR      UPDATERRS                                                  CRE075
     C                   ENDIF                                                                CRE075
                                                                                              CRE075
     C                   ELSE                                                                 CRE075
                                                                                              CRE075
      ** If a New Retail account is opened with Effective Date less                           CRE075
      ** or equalto rundate, or if the Effective Date of an existing                          CRE075
      ** Retail Account is amended to be less than or equal to run-                           CRE075
      ** date, these field should be defaulted as follows:                                    CRE075
                                                                                              CRE075
     C                   IF        (DDACTN = 'I' OR                                           CRE075
     C                              DDACTN = 'A') AND                                         CRE075
     C                             WWEfDt <= BJRDNB                                           CRE075
      *                                                                                    AR760540A
     C     DDBAD         IFEQ      ' '                                                     AR760540A
     C                   MOVE      'N'           DDBAD                                     AR760540A
     C                   END                                                               AR760540A
     C     DDBAC         IFEQ      ' '                                                     AR760540A
     C                   MOVE      'N'           DDBAC                                     AR760540A
     C                   END                                                               AR760540A
     C     DDRAD         IFEQ      ' '                                                     AR760540A
     C                   MOVE      'N'           DDRAD                                     AR760540A
     C                   END                                                               AR760540A
     C     DDRAC         IFEQ      ' '                                                     AR760540A
     C                   MOVE      'N'           DDRAC                                     AR760540A
     C                   END                                                               AR760540A
                                                                                              CRE075
      ** If not equal to the default values issue warning message                             CRE075
                                                                                              CRE075
     C                   IF        DDRAD <> 'N' OR                                            CRE075
     C                             DDRAC <> 'N' OR                                            CRE075
     C                             DDBAD <> 'N' OR                                            CRE075
     C                             DDBAC <> 'N'                                               CRE075
     C                   EVAL      WIdx = 1                                                   CRE075
     C                   EVAL      WFldNmXAr(WIdx) = '*ANY  '                                 CRE075
     C                   EVAL      WMsgIDXAr(WIdx) = 'RE71077'                                CRE075
     C                   EXSR      UPDATERRS                                                  CRE075
     C                   ENDIF                                                                CRE075
                                                                                              CRE075
     C                   ENDIF                                                                CRE075
     C                   ENDIF                                                                CRE075
                                                                                              CRE075
     C                   ENDSR                                                                CRE075
      *****************************************************************                       CRE075
     C/EJECT                                                                                  CRE075
      *****************************************************************         180721
      ** DNXTSDAT - Default Next Statement Date                                 180721
      *****************************************************************         180721
     C     DNXTSDAT      BEGSR                                                  180721
                                                                                180721
      * Reset variables updated by each module                                  180721
                                                                                180721
     C                   EXSR      RESETERRS                                    180721
      *                                                                         180721
     C/COPY WNCPYSRC,GLH00799
     C                   CALLB     'GLDSMDT'                                    180721
      *                                                                         180721
      * INPUTS                                                                  180721
      *                                                                         180721
      ** Return Code                                                            180721
     C                   Parm                    RetCodeOut                     180721
      *                                                                         180721
      ** Account Screen fields                                                  180721
     C                   Parm                    DDCCY                          180721
     C                   Parm                    DDSTFQ                         180721
     C                   Parm                    DDNSDN                         180721
      *                                                                         180721
      ** ICD                                                                    180721
     C                   Parm                    SDBANK                         180721
     C                   Parm                    SDGELR                         180721
      *                                                                         180721
      * OUTPUTS                                                                 180721
      *                                                                         180721
      ** Next Statement Date                                                    180721
     C                   Parm                    DDNSTD                         180721
      *                                                                         180721
      * Error fields/message IDs/message data (arrays) from/to caller           180721
     C                   PARM                    FldNamXAr                      180721
     C                   PARM                    MsgIDXAr                       180721
     C                   PARM                    MsgDtaXAr                      180721
      *                                                                         180721
      ** Next Statement Date - Ok                                               180721
     C                   Parm                    DDNStDOk                       180721
                                                                                180721
     C/COPY WNCPYSRC,GLH00800
      * Update error info with that returned from the validation module         180721
                                                                                180721
     C                   EXSR      UPDATERRS                                    180721
      *                                                                         180721
     C                   ENDSR                                                  180721
      *****************************************************************         180721
     C/EJECT
      *****************************************************************
      ** VNXTSDAT - Validate Next Statement Date
      *****************************************************************
     C     VNXTSDAT      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVSMDT'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDNSTD
     C                   Parm                    DDSTFQ
      *
      ** Passed from GLVACDT
     C                   Parm                    WWDACO
      *
      ** ICD
     C**********         Parm                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   Parm                    BJDFIN
     C                   Parm                    BKAPDT
     C/COPY WNCPYSRC,GLH00718
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Next Statement Date work field
     C                   Parm      *ZERO         WWNSTD            5 0
      *
      ** Next Statement Date - Ok
     C                   Parm                    DDNStDOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VFQNCNSD - Validate Freq, No of Copies and Next Statement Day no.
      *****************************************************************
     C     VFQNCNSD      BEGSR
 
     C                   MoveL     *Blanks       WDAY              2
     C     BJDFIN        IfEq      'D'
     C                   MoveL     DDNSTD        WDAY
     C                   Else
     C                   Eval      WDAY = %Subst(DDNSTD:3)
     C                   EndIf
      *
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C/COPY WNCPYSRC,GLAMA1VC01
     C                   CALLB     'GLVSMFQ'
     C/COPY WNCPYSRC,GLAMA1VC02
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDStFq
     C                   Parm                    DDENoC
     C                   Parm                    DDNSDN
     C/COPY WNCPYSRC,GLH00719
      *
      ** Next Statement Date - Ok
     C                   Parm                    DDNStDOk
      *
      ** ICD
     C                   Parm                    TTURN
     C                   Parm                    CNDS
      *
      ** Day no in next statement date field
     C                   Parm                    WDAY
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Statement Frequency - Ok
      ** Number of Copies - Ok
      ** Next Statement Day No - Ok
     C                   Parm                    DDStFqOk
     C                   Parm                    DDENoCOk
     C                   Parm                    DDNSDNOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPTADREF - Validate Print Addrs Y/N, and Address Reference
      *****************************************************************
     C     VPTADREF      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVPIAD'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDREF
     C                   Parm                    DDPTAD
     C                   Parm                    DDCUSN
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Address Reference - Ok
      ** Print Address Ref - Ok
     C                   Parm                    DDRefOk
     C                   Parm                    DDPtAdOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VRFRNBLK - Validate Refer All and Block All
      *****************************************************************
     C     VRFRNBLK      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVMCMC'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDRAD
     C                   Parm                    DDRAC
     C                   Parm                    DDBAD
     C                   Parm                    DDBAC
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Refer All Debits - Ok
      ** Refer All Credits - Ok
      ** Block All Debits - Ok
      ** Block All Credits - Ok
     C                   Parm                    DDRADOk
     C                   Parm                    DDRACOk
     C                   Parm                    DDBADOk
     C                   Parm                    DDBACOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTIACCNT - Validate TI Account
      *****************************************************************
     C     VTIACCNT      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVTIAC'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDACTN
     C                   Parm                    DDTIAC
     C                   Parm                    DDTIAN
     C                   Parm                    DDTIAS
     C                   Parm                    DDACOD
     C                   Parm                    DDBRCA
     C                   Parm                    DDCUSN
     C                   Parm                    DDCCY
     C                   Parm                    DDACSQ                                      BUG3365
      *
     C                   Parm                    AMA5TIAC
      *
      ** ICD
     C                   Parm                    BGN3ST
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Indicator 76 & 89 for used in display file
     C                   Parm                    WIN76             1
     C                   Parm                    WIN89             1
      *
      ** TI Account - OK
      ** TI Account Number - OK
      ** TI Account Suffix - OK
     C                   Parm                    DDTIACOk
     C                   Parm                    DDTIANOk
     C                   Parm                    DDTIASOk
     C                   Parm                    Idx                                         BUG5340
     C                   Parm                    WIdx                                        BUG5340
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VEUSBMFQ - Validate Statement Bal in Euros and Archiving Freq
      *****************************************************************
     C     VEUSBMFQ      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVEUBL'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDEUSB
     C                   Parm                    DDMFFQ
     C                   Parm                    DDCCY
      *
      ** ICD
     C                   Parm                    CEU013
     C                   Parm                    BGMFIC
     C**********         Parm                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Statement Bal. in Euros - Ok
      ** Mrichofiche Frequency - Ok
     C                   Parm                    DDEUSBOk
     C                   Parm                    DDMFFQOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPRFCPTF - Validate Profit Centre & Portfolio Reference
      *****************************************************************
     C     VPRFCPTF      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVPFPO'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDACTN
     C                   Parm                    DDBRCA
     C                   Parm                    DDCUSN
     C                   Parm                    DDCCY
     C                   Parm                    DDACOD
     C                   Parm                    DDACSQ
     C                   Parm                    DDPRFC
     C                   Parm                    DDPTFR
      *
     C                   Parm                    AMPRFC
     C                   Parm                    AMPTFR
     C                   Parm                    AMATYP
      *
      ** ICD
     C                   Parm                    BKPRCU
     C                   Parm                    BKPRCA
     C                   Parm                    BKPCDU
     C                   Parm                    BGN0ST
     C                   Parm                    BGPFMG
     C                   Parm                    BGLMCR
     C**********         Parm                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   Parm                    FCPORS
     C                   Parm                    FCR997
     C                   Parm                    BGN4ST                                       CPB001
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Profit Centre - Ok
      ** Portfolio Reference - Ok
      ** Account Code - Ok
     C                   Parm                    DDPRFCOk
     C                   Parm                    DDPTFROk
     C                   Parm                    DDACODOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************         CFT004
     C/EJECT                                                                    CFT004
      *****************************************************************         CFT004
      ** ValIBAN - Validate International Bank Account number                   CFT004
      *****************************************************************         CFT004
     C     ValIBAN       BEGSR                                                  CFT004
                                                                                CFT004
      * Reset variables updated by each module                                  CFT004
                                                                                CFT004
     C                   EXSR      RESETERRS                                    CFT004
      *                                                                         CFT004
     C                   CALLB     'GLVIBAC'                                    CFT004
      *                                                                         CFT004
      * INPUTS                                                                  CFT004
      *                                                                         CFT004
      ** Return Code                                                            CFT004
     C                   Parm                    RetCodeOut                     CFT004
      *                                                                         CFT004
      ** International Bank Account Number (screen)                             CFT004
     C                   Parm                    DDIBAN                         CFT004
      ** International Bank Account Number (on file)                            CFT004
     C                   Parm                    AMIBAN                         CFT004
      ** International Bank Account Number Sequence                             CFT004
     C                   Parm                    AMIBSEQN                       CFT004
      ** Action Code                                                            CFT004
     C                   Parm                    DDACTN                         CFT004
      ** Branch Code                                                            CFT004
     C                   Parm                    DDBRCA                         CFT004
      ** Customer Number                                                        CFT004
     C                   Parm                    DDCUSN                         CFT004
      ** Currency                                                               CFT004
     C                   Parm                    DDCCY                          CFT004
      ** Account Code                                                           CFT004
     C                   Parm                    DDACOD                         CFT004
      ** Account Sequence                                                       CFT004
     C                   Parm                    DDACSQ                         CFT004
      ** Account Type                                                           CFT004
     C                   Parm                    AMATYP                         CFT004
      ** Account Number                                                         CFT004
     C                   Parm                    DDACNO                         CFT004
      *                                                                         CFT004
      * OUTPUTS                                                                 CFT004
      *                                                                         CFT004
      * Error fields/message IDs/message data (arrays) from/to caller           CFT004
     C                   PARM                    FldNamXAr                      CFT004
     C                   PARM                    MsgIDXAr                       CFT004
     C                   PARM                    MsgDtaXAr                      CFT004
      *                                                                         CFT004
      * Warning message IDs/message data (arrays) from/to caller                CFT004
     C                   PARM                    WFldNmXAr                      CFT004
     C                   PARM                    WMsgIDXAr                      CFT004
     C                   PARM                    WMsgDtXAr                      CFT004
      *                                                                         CFT004
      ** International Bank Account Number - OK                                 CFT004
     C                   Parm                    DDIBANOk                       CFT004
                                                                                CFT004
      * Update error info with that returned from the validation module         CFT004
                                                                                CFT004
     C                   EVAL      DDIBSQ = AMIBSEQN                            CFT004
     C                   EXSR      UPDATERRS                                    CFT004
      *                                                                         CFT004
     C                   ENDSR                                                  CFT004
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  VITaxFlg - Validate Interest Taxable Flag
      *****************************************************************
     C     VITAXFLG      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *                                                                                       CDL013
     C     CDL013        Ifeq      'Y'                                                        CDL013
     C*                                                                                       CDL013
     C                   CALL      'AOCUSTR0'                                                 CDL013
     C                   PARM      '*MSG    '    @RTCD             7                          CDL013
     C                   PARM      '*KEY    '    @OPTN             7                          CDL013
     C                   PARM      DDCUSN        @CUSNN           10                          CDL013
     C                   PARM                    @CSTAT            7                          CDL013
     C     SDCUST        PARM      SDCUST        DSFDY                                        CDL013
     C*                                                                                       CDL013
     C** Data-base error processing.                                                          CDL013
     C*                                                                                       CDL013
     C     @RTCD         IFNE      *BLANKS                                                    CDL013
     C     @CSTAT        OREQ      '*ERROR'                                                   CDL013
     C     *LOCK         IN        LDA                                                        CDL013
     C                   MOVEL     'SDCUSTPD'    DBFILE                                       CDL013
     C                   Z-ADD     6             DBASE                                        CDL013
     C                   MOVEL     DDCUSN        DBKEY                                        CDL013
     C                   OUT       LDA                                                        CDL013
     C                   EXSR      #TERM                                                      CDL013
     C                   ENDIF                                                                CDL013
     C                   ENDIF                                                                CDL013
     C*                                                                                       CDL013
      *                                                                         180721
      ** Default Interest Taxable if necessary                                  180721
     C     BGN4ST        Ifeq      'Y'                                          180721
     C     DDITAX        Andeq     *blanks                                      180721
     C     BGNTST        OrEq      'N'                                                       BUG8625
     C     DDITAX        AndEq     *blanks                                                   BUG8625
     C     CDL013        Ifeq      'Y'                                                        CDL013
     C                   EVAL      DDITAX = BBTAIN                                            CDL013
     C                   Else                                                                 CDL013
     C                   EVAL      DDITAX = 'N'                                 180721
     C                   Endif                                                                CDL013
     C                   Endif                                                  180721
      *
     C                   IF        CER048 = 'Y'                                               CER048
      *                                                                                       CER048
     C                   MOVEL     DDCUSN        PKey1                                        CER048
      *                                                                                       CER048
     C                   CALL      'AOCUSTR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*KEY'        POptn                                        CER048
     C                   PARM                    PKey1                                        CER048
     C                   PARM      *BLANKS       PKyst                                        CER048
     C     SDCUST        PARM      SDCUST        DSLDY                                        CER048
      *                                                                                       CER048
      ** Retrieve Country code                                                              BUG22747
      *                                                                                     BUG22747
     C                   EXSR      SRCNTRY                                                  BUG22747
     C                   MOVEL     DDCUSN        KFCusn                                       CER048
     C**********         MOVEL     BBCOLC        KFCtax                              CER048 BUG22747
     C                   MOVEL     DVCNCD        KFCtax                                     BUG22747
      *                                                                                     BUG23886
      ** Retrieve threshol method                                                           BUG23886
      *                                                                                     BUG23886
     C                   EVAL      WThrMtd = *blanks                                        BUG23886
     C                   EVAL      KCtTx = DVCNCD                                           BUG23886
     C                   EVAL      KCtRe = BBCOLC                                           BUG23886
     C     KCTxCd        CHAIN     SDCTTXL0                                                 BUG23886
     C                   IF        %FOUND(SDCTTXL0)                                         BUG23886
     C                   EVAL      WThrMtd = EWTHMD                                         BUG23886
     C                   ENDIF                                                              BUG23886
      *                                                                                       CER048
     C     *LOVAL        SETLL     SDACTXL1                                                   CER048
     C     KLActx        CHAIN     SDACTXL1                                                   CER048
      *                                                                                       CER048
     C                   IF        %FOUND(SDACTXL1)                                           CER048
      *                                                                                       CER048
     C                   IF        AXETXS = 'T'                                               CER048
     C                             and WThrMtd = 'Y'                                        BUG23886
     C                             or AXETXS = 'Y' and CER069 = 'Y'                           CER069
     C                             and WThrMtd = 'Y'                                          CER069
     C**********                   AND BBTAIN = 'Y'                                BUG22745 BUG22747
     C                   EVAL      PAcHlF = 'Y'                                               CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      PAcHlF = 'N'                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        DDITAX = *BLANKS                                           CER048
     C                   IF        CER069 = 'Y' AND AXETXS <> ' '                             CER069
     C                   EVAL      DDITAX = 'A'                                               CER069
     C                   ELSE                                                                 CER069
      *                                                                                       CER048
     C                   IF        AXETXS = 'T'                                               CER048
     C                             and WThrMtd = 'Y'                                        BUG23886
     C**********                   AND BBTAIN = 'Y'                                BUG22745 BUG22747
     C                   EVAL      DDITAX = 'T'                                               CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      DDITAX = 'N'                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER069
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C                   EVAL      PAcHlF = 'X'                                               CER048
      *                                                                                       CER048
     C                   IF        DDITAX = *BLANKS                                           CER048
     C                   EVAL      DDITAX = 'N'                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C/COPY WNCPYSRC,GLAMA1VC05
     C                   CALLB     'GLVITIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDITAX
      *                                                                                       CDL013
      ** Customer type                                                                        CDL013
     C                   Parm                    BBCSTY                                       CDL013
      *                                                                                       CDL013
      ** CDL013 switchable feature                                                            CDL013
     C                   Parm                    CDL013                                       CDL013
      ** German Features                                                                      CER048
     C                   PARM                    PAcHlF                                       CER048
     C                   PARM                    WThrMtd                                    AR762349
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr                                    CER048
     C                   PARM                    WMsgIdXAr                                    CER048
     C                   PARM                    WMsgDtXAr                                    CER048
      *
      ** Interest Taxable - OK
     C                   Parm                    DDITAXOk
     C/COPY WNCPYSRC,GLAMA1VC06
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  CGL165
      *****************************************************************                       CGL165
      *  VITaxCod - Validate Interest Taxable Codes                                           CGL165
      *****************************************************************                       CGL165
     C     VITAXCOD      BEGSR                                                                CGL165
                                                                                              CGL165
      * Reset variables updated by each module                                                CGL165
                                                                                              CGL165
     C                   EXSR      RESETERRS                                                  CGL165
      *                                                                                       CGL165
     C     CGL165        Ifeq      'Y'                                                        CGL165
      *                                                                                       CGL165
      * Default tax codes if blank and account is taxable                                     CGL165
     C                   IF        DDTXC1 = *BLANKS                                           CGL165
     C                             AND DDTXC2 = *BLANKS                                       CGL165
     C                             AND DDITAX = 'Y'                                           CGL165
      *                                                                                       CGL165
     C                   MOVEL(P)  DDCUSN        @CUSNN                                       CGL165
     C                   CALL      'AOCUSTR0'                                                 CGL165
     C                   PARM      '*MSG    '    @RTCD             7                          CGL165
     C                   PARM      '*KEY    '    @OPTN             7                          CGL165
     C                   PARM                    @CUSNN           10                          CGL165
     C                   PARM                    @CSTAT            7                          CGL165
     C     SDCUST        PARM      SDCUST        DSSDY                                        CGL165
      *                                                                                       CGL165
     C                   MOVEL(P)  DDBRCA        TXBRCA                                       CGL165
     C                   MOVEL(P)  DDCCY         TXCCY                                        CGL165
     C                   MOVEL(P)  DDACOD        TXACOD                                       CGL165
     C                   CALL      'AOWTDFR0'                                                 CGL165
     C                   PARM                    @RTCD1            1                          CGL165
     C                   PARM                    TXBRCA            3                          CGL165
     C                   PARM      *BLANK        TXBOOK            2                          CGL165
     C                   PARM                    TXCCY             3                          CGL165
     C                   PARM                    BBCOLC                                       CGL165
     C                   PARM                    BBCSTY                                       CGL165
     C                   PARM                    BBLINC                                       CGL165
     C                   PARM      'RE'          TXMODU            2                          CGL165
     C                   PARM                    TXACOD           10                          CGL165
     C                   PARM      *BLANKS       TXPSTP            2                          CGL165
     C                   PARM                    @WTRC1            2                          CGL165
     C                   PARM                    @WTRC2            2                          CGL165
      *                                                                                       CGL165
     C                   IF        @RTCD1 = '0'                                               CGL165
     C                   MOVE      @WTRC1        DDTXC1                                       CGL165
     C                   MOVE      @WTRC2        DDTXC2                                       CGL165
     C                   ENDIF                                                                CGL165
      *                                                                                       CGL165
     C                   ENDIF                                                                CGL165
      *                                                                                       CGL165
     C                   CALLB     'GLVITCD'                                                  CGL165
      *                                                                                       CGL165
      * INPUTS                                                                                CGL165
      *                                                                                       CGL165
      ** Return Code                                                                          CGL165
     C                   Parm                    RetCodeOut                                   CGL165
      *                                                                                       CGL165
      ** Account Screen fields                                                                CGL165
     C                   Parm                    DDITAX                                       CGL165
     C                   Parm                    DDTXC1                                       CGL165
     C                   Parm                    DDTXC2                                       CGL165
     C                   Parm                    DDCCY                                        CGL165
      *                                                                                       CGL165
      *                                                                                       CGL165
      * OUTPUTS                                                                               CGL165
      *                                                                                       CGL165
      * Error fields/message IDs/message data (arrays) from/to caller                         CGL165
     C                   PARM                    FldNamXAr                                    CGL165
     C                   PARM                    MsgIDXAr                                     CGL165
     C                   PARM                    MsgDtaXAr                                    CGL165
     C                   PARM                    WFldNmXAr                                    CGL165
     C                   PARM                    WMsgIdXAr                                    CGL165
     C                   PARM                    WMsgDtXAr                                    CGL165
      *                                                                                       CGL165
      ** Tax Codes - OK                                                                       CGL165
     C                   Parm                    DDTXC1Ok                                     CGL165
     C                   Parm                    DDTXC2Ok                                     CGL165
                                                                                              CGL165
     C                   EndIf                                                                CGL165
      * Update error info with that returned from the validation module                       CGL165
                                                                                              CGL165
     C                   EXSR      UPDATERRS                                                  CGL165
      *                                                                                       CGL165
     C                   ENDSR                                                                CGL165
     C/EJECT
      *****************************************************************
      *  VStCIFlg - Validate Statement Charge Flag
      *****************************************************************
     C     VSTCIFLG      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVSMIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDSTCI
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Statement Charge - OK
     C                   Parm                    DDSTCIOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  VChInFlg - Validate Subject to Account Charge Flag
      *****************************************************************
     C     VCHINFLG      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVACCH'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDCHIN
      *                                                                                       248025
      ** Fixed Account Charge                                                                 248025
      *                                                                                       248025
     C                   Parm                    FACH                                         248025
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Subject to account charge - Ok
     C                   Parm                    DDCHINOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  VCHAM    - Validate Account Charge Amount
      *****************************************************************
     C     VCHAM         BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVCHAM'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDCHAM
     C                   Parm                    DDCHIN
     C                   Parm                    DDCCY
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   Parm      *ZERO         WNCHAM            7 0
      *
      ** Account Charge Amount - Ok
     C                   Parm                    DDCHAMOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  CUT009
      /COPY WNCPYSRC,GLAMAD1V42                                                               CUT009
      *****************************************************************                       CUT009
     C/EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
      *
     C                   MOVE      DDCUSN        AMCNUM
     C                   MOVE      DDCCY         AMCCY
     C                   MOVE      DDACOD        AMACOD
     C                   MOVE      DDACSQ        AMACSQ
     C                   MOVE      DDBRCA        AMBRCA
     C                   MOVE      DDACNO        AMACNO
      *
     C     WFMT          IFEQ      'F1'
     C     WFMT          OREQ      *BLANKS
      *
     C                   MOVE      DDANAM        AMANAM
     C     DDACTN        IFEQ      'I'
     C                   Z-ADD     WWDACO        AMDACO
     C                   ENDIF
     C                   Z-ADD     WWNSTD        AMNSTD
     C                   MOVE      DDSTFQ        AMSTFQ
     C                   MOVE      DDENOC        AMENOC
     C                   MOVE      DDNSDN        AMSTDY
     C                   MOVE      DDEUSB        AMEUSB
 
     C     DDPTAD        IFEQ      'Y'
     C                   BITON     '2'           AMGLBT
     C                   ELSE
     C                   BITOFF    '2'           AMGLBT
     C                   ENDIF
 
     C     DDRAD         IFEQ      'Y'
     C                   BITON     '0'           AMRETB
     C                   ELSE
     C                   BITOFF    '0'           AMRETB
     C                   ENDIF
 
     C     DDRAC         IFEQ      'Y'
     C                   BITON     '1'           AMRETB
     C                   ELSE
     C                   BITOFF    '1'           AMRETB
     C                   ENDIF
 
     C     DDBAD         IFEQ      'Y'
     C                   BITON     '2'           AMRETB
     C                   ELSE
     C                   BITOFF    '2'           AMRETB
     C                   ENDIF
 
     C     DDBAC         IFEQ      'Y'
     C                   BITON     '3'           AMRETB
     C                   ELSE
     C                   BITOFF    '3'           AMRETB
     C                   ENDIF
 
     C                   MOVEL     DDREF         AMADREF1
     C                   MOVE      DDREF         AMADREF2
     C                   MOVE      DDTIAC        AMA5TIAC
     C                   MOVE      DDTIAN        AMA5TIAN
     C                   MOVE      DDTIAS        AMA5TIAS
     C                   MOVE      DDPRFC        AMPRFC
     C                   MOVE      DDMFFQ        AMMFFQ
     C                   MOVE      DDPTFR        AMPTFR
     C                   MOVE      DDITAX        BXITAX
     C                   IF        CGL165 = 'Y'                                               CGL165
     C                   MOVE      DDTXC1        BXTXC1                                       CGL165
     C                   MOVE      DDTXC2        BXTXC2                                       CGL165
     C                   ENDIF                                                                CGL165
     C                   MOVE      DDSTCI        BXSTCI
     C                   MOVE      DDCHIN        BXCHIN
     C                   Z-ADD     WNCHAM        BXCHAM
      *
     C                   ENDIF
      *
      ** Populate Extension File key fields
     C     DDACTN        IFEQ      'I'
     C*****BGWDPR        ANDEQ     'Y'                                                        239720
     C     AMATYP        ANDEQ     'R'
     C     DDACTN        OREQ      'D'                                                       BUG8471
     C*****BGWDPR        ANDEQ     'Y'                                                BUG8471 242488
     C     AMATYP        ANDEQ     'R'                                                       BUG8471
                                                                                             BUG8471
     C*****BGSWRT        IFEQ      'Y'                                                        239720
     C*****BGNTST        OREQ      'Y'                                                        239720
     C*****FACH**        OREQ      'Y'                                                        239720
     C*****TSTMC*        OREQ      'Y'                                                        239720
     C                   MOVE      DDCUSN        BXCNUM
     C                   MOVE      DDCCY         BXCCY
     C                   MOVE      DDACOD        BXACOD
     C                   MOVE      DDACSQ        BXACSQ
     C                   MOVE      DDBRCA        BXBRCA
     C**********         ENDIF                                                                239720
     C                   ENDIF
      *                                                                                     BUG24157
      ** KWG @24c reporting                                                                 BUG24157
      *                                                                                     BUG24157
     C                   IF        CER047 = 'Y'                                             BUG24157
     C                   EVAL      AMK24C = DD24C                                           BUG24157
     C                   ENDIF                                                              BUG24157
      *
                                                                                              CRE075
      ** Effective Date for Retail Accounts                                                   CRE075
                                                                                              CRE075
     C                   IF        CRE075 = 'Y'                                               CRE075
     C                   EVAL      AMEFDT = WWEfDt                                            CRE075
     C                   ENDIF                                                                CRE075
                                                                                              CRE075
     C                   ENDSR
      *****************************************************************                     BUG22747
      /EJECT                                                                                BUG22747
      *****************************************************************                     BUG22747
      * SRCNTRY- Retrieve correct country codee                       *                     BUG22747
      *****************************************************************                     BUG22747
                                                                                            BUG22747
     C     SRCNTRY       BEGSR                                                              BUG22747
                                                                                            BUG22747
     C                   CALL      'AOBRCHR1'                                               BUG22747
     C                   PARM      *BLANKS       PRtcd                                      BUG22747
     C                   PARM      '*KEY   '     POptn                                      BUG22747
     C                   PARM      BBBRCD        PBrch                                      BUG22747
     C     SDBRCH        PARM      SDBRCH        DSSDY                                      BUG22747
      *                                                                                     BUG22747
     C                   IF        PRtcd <> *BLANKS                                         BUG22747
     C     *LOCK         IN        LDA                                                      BUG22747
     C                   Z-ADD     004           DBASE                                      BUG22747
     C                   EVAL      DBFILE = 'SDBRCHPD'                                      BUG22747
     C                   EVAL      DBKEY = PBrch                                            BUG22747
     C                   EVAL      DBPGM = 'GLAMAD1VL'                                      BUG22747
     C                   EVAL      *INU7 = *ON                                              BUG22747
     C                   EVAL      *INU8 = *ON                                              BUG22747
     C                   OUT       LDA                                                      BUG22747
     C                   EXSR      *PSSR                                                    BUG22747
     C                   ENDIF                                                              BUG22747
                                                                                            BUG22747
     C                   CALL      'AOLOCNR0'                                               BUG22747
     C                   PARM      *BLANKS       PRtcd                                      BUG22747
     C                   PARM      '*KEY   '     POptn                                      BUG22747
     C                   PARM      A8LCCD        PLocn                                      BUG22747
     C     SDLOCN        PARM      SDLOCN        DSFDY                                      BUG22747
      *                                                                                     BUG22747
     C                   IF        PRtcd <> *BLANKS                                         BUG22747
     C     *LOCK         IN        LDA                                                      BUG22747
     C                   Z-ADD     005           DBASE                                      BUG22747
     C                   EVAL      DBFILE = 'SDLOCNPD'                                      BUG22747
     C                   EVAL      DBKEY = PLocn                                            BUG22747
     C                   EVAL      DBPGM = 'GLAMAD1VL'                                      BUG22747
     C                   EVAL      *INU7 = *ON                                              BUG22747
     C                   EVAL      *INU8 = *ON                                              BUG22747
     C                   OUT       LDA                                                      BUG22747
     C                   EXSR      *PSSR                                                    BUG22747
     C                   ENDIF                                                              BUG22747
                                                                                            BUG22747
     C                   ENDSR                                                              BUG22747
      *****************************************************************
      /EJECT
      *****************************************************************                     BUG24157
      ** SRVK24C - Validate KWG §24c reporting                                              BUG24157
      *****************************************************************                     BUG24157
     C     SRVK24C       BEGSR                                                              BUG24157
                                                                                            BUG24157
      * Reset variables updated by each module                                              BUG24157
                                                                                            BUG24157
     C                   EXSR      RESETERRS                                                BUG24157
      *                                                                                     BUG24157
     C                   CALLB     'GLVK24C'                                                BUG24157
      ** Return Code                                                                        BUG24157
     C                   PARM                    RetCodeOut                                 BUG24157
      ** KWG §24c reporting field                                                           BUG24157
     C                   PARM                    DD24C                                      BUG24157
      ** Customer Number                                                                    BUG24157
     C                   PARM                    DDCUSN                                     BUG24157
      * Error fields/message IDs/message data (arrays) from/to caller                       BUG24157
     C                   PARM                    FldNamXAr                                  BUG24157
     C                   PARM                    MsgIDXAr                                   BUG24157
     C                   PARM                    MsgDtaXAr                                  BUG24157
      * Warning fields/message IDs/message data (arrays) from/to caller                     BUG24157
     C                   PARM                    WFldNmXAr                                  BUG24157
     C                   PARM                    WMsgIDXAr                                  BUG24157
     C                   PARM                    WMsgDtXAr                                  BUG24157
      * KWG §24c reporting Y/N - Ok Flag                                                    BUG24157
     C                   PARM                    DD24COK                                    BUG24157
                                                                                            BUG24157
      * Update error info with that returned from the validation module                     BUG24157
                                                                                            BUG24157
     C                   EXSR      UPDATERRS                                                BUG24157
      *                                                                                     BUG24157
     C                   ENDSR                                                              BUG24157
      *****************************************************************                     BUG24157
     C/EJECT                                                                                BUG24157
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Screen Format
     C                   PARM                    WFMT              2
      * ICD
     C                   PARM                    RETABLE
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
      * Front Office ID                                                         180721
     C**********         PARM                    APFOTranID       20                   180721 CGL029
     C                   PARM                    APFOTran40       40                          CGL029
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
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
     C                   Parm                    WGLKEY
      * IBAN Sequence                                                           CFT004
     C                   Parm                    DDIBSQ            3            CFT004
      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidAccn
     C                   PARM                    ValidExBX
      * Base Rate Auth req                                                                    CSD012
     C                   PARM                    AUTHRQ            1                          CSD012
      * Authorisation Mode                                                                    CSD012
     C                   PARM                    AUTHMD            1                          CSD012
      *
      **  GET ZMUSER to access default branch.
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
      *
      **  GET RUNDAT to access multi-branching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLAMAD1VL'   DBPGM
     C                   OUT       LDA
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access Retail details via access program
      *  (database error handling done in access program)
     C     BGRTBN        IFEQ      'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
     C                   ENDIF
      *
      ** Access default Portfolio Reference via access program
      *  (database error handling done in access program)
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      'DBERR  '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
      *
      ** Access SAR file to determine if CEU013 is present.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU013'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'CEU013'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   ENDIF
     C                   MOVEL     'N'           CEU013            1
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU013
     C                   ENDIF
      *                                                                                       CDL013
      ** Access SAR file to determine if CDL013 is present.                                   CDL013
      *                                                                                       CDL013
     C                   CALLB     'AOSARDR0'                                                 CDL013
     C                   PARM      *BLANKS       @RTCD                                        CDL013
     C                   PARM      '*VERIFY'     @OPTN                                        CDL013
     C                   PARM      'CDL013'      @SARD                                        CDL013
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL013
     C     @RTCD         IFNE      *BLANKS                                                    CDL013
     C     @RTCD         ANDNE     '*NRF   '                                                  CDL013
     C     *LOCK         IN        LDA                                                        CDL013
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL013
     C                   Z-ADD     3             DBASE                                        CDL013
     C                   MOVEL     'CDL013'      DBKEY                                        CDL013
     C                   OUT       LDA                                                        CDL013
     C                   SETON                                        U7U8LR                  CDL013
     C                   EXSR      #TERM                                                      CDL013
     C                   ENDIF                                                                CDL013
     C                   MOVEL     'N'           CDL013            1                          CDL013
     C     @RTCD         IFEQ      *BLANK                                                     CDL013
     C                   MOVEL     'Y'           CDL013                                       CDL013
     C                   ENDIF                                                                CDL013
      *                                                                                       CDL013
      *                                                                                       CDL013
     C/COPY WNCPYSRC,GLH00720
      *
     C     CDTO          IFEQ      'Y'
     C     CHOV          OREQ      'Y'
     C     FXAC          OREQ      'Y'
     C     CNDS          OREQ      'Y'
     C     CDRI          OREQ      'Y'
     C     CMBL          OREQ      'Y'
     C     CINA          OREQ      'Y'
     C                   MOVE      *ON           @IN34
     C                   ENDIF
      *
      ** Access SAR file to determine if CFT004 is present.                     CFT004
      *                                                                         CFT004
     C                   CALLB     'AOSARDR0'                                   CFT004
     C                   PARM      *BLANKS       @RTCD                          CFT004
     C                   PARM      '*VERIFY'     @OPTN                          CFT004
     C                   PARM      'CFT004'      @SARD                          CFT004
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT004
     C     @RTCD         IFNE      *BLANKS                                      CFT004
     C     @RTCD         ANDNE     '*NRF   '                                    CFT004
     C     *LOCK         IN        LDA                                          CFT004
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT004
     C                   Z-ADD     1             DBASE                          CFT004
     C                   MOVEL     'CFT004'      DBKEY                          CFT004
     C                   OUT       LDA                                          CFT004
     C                   SETON                                        U7U8LR    CFT004
     C                   EXSR      #TERM                                        CFT004
     C                   ENDIF                                                  CFT004
     C                   MOVEL     'N'           CFT004            1            CFT004
     C     @RTCD         IFEQ      *BLANK                                       CFT004
     C                   MOVEL     'Y'           CFT004                         CFT004
     C                   ENDIF                                                  CFT004
     C/COPY WNCPYSRC,GLAMA1VC04
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
      ** CSC011 is a redundant feature. No need to check                                    MD024398
                                                                                            MD024398
     C**********         CALLB     'AOSARDR0'                                        CSC011 MD024398
     C**********         PARM      *BLANKS       PRtCd                               CSC011 MD024398
     C**********         PARM      '*VERIFY'     POptn                               CSC011 MD024398
     C**********         PARM      'CSC011'      PSard                               CSC011 MD024398
     C*****SCSARD        PARM      SCSARD        DSFDY                               CSC011 MD024398
      **********                                                                     CSC011 MD024398
     C**********         IF        PRtCd = *Blanks                                   CSC011 MD024398
     C**********         EVAL      CSC011 = 'Y'                                      CSC011 MD024398
     C**********         IN        SC24X7                                            CSC011 MD024398
     C**********         IN        SDSTAT                                            CSC011 MD024398
     C**********         IF        S1SUPP = LIBR                                     CSC011 MD024398
     C**********         EVAL      WRunDay = S1DATE                                  CSC011 MD024398
     C**********         ENDIF                                                       CSC011 MD024398
      **********                                                                     CSC011 MD024398
     C**********         ELSE                                                        CSC011 MD024398
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C**********         IF        PRtCd <> '*NRF'                                   CSC011 MD024398
     C******LOCK         IN        LDA                                               CSC011 MD024398
     C**********         EVAL      DBFILE = 'SCSARDPD'                               CSC011 MD024398
     C**********         EVAL      DBKEY = 'CSC011'                                  CSC011 MD024398
     C**********         EVAL      DBASE = 2                                         CSC011 MD024398
     C**********         OUT       LDA                                               CSC011 MD024398
     C**********         EXSR      *PSSR                                             CSC011 MD024398
     C**********         ENDIF                                                       CSC011 MD024398
      **********                                                                     CSC011 MD024398
     C**********         ENDIF                                                       CSC011 MD024398
                                                                                              CSC011
      *                                                                                     BUG24157
      ** Check if CER047 is installed.                                                      BUG24157
      *                                                                                     BUG24157
     C                   CALLB     'AOSARDR0'                                               BUG24157
     C                   PARM      *BLANKS       PRtCd                                      BUG24157
     C                   PARM      '*VERIFY'     POptn                                      BUG24157
     C                   PARM      'CER047'      PSard                                      BUG24157
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG24157
                                                                                            BUG24157
     C                   EVAL      CER047 = 'N'                                             BUG24157
     C                   IF        PRtCd = *BLANKS                                          BUG24157
     C                   EVAL      CER047 = 'Y'                                             BUG24157
     C                   ENDIF                                                              BUG24157
                                                                                            BUG24157
     C                   IF        PRtCd <> *BLANKS  AND  PRtCd <> '*NRF   '                BUG24157
     C     *LOCK         IN        LDA                                                      BUG24157
     C                   EVAL      DBFILE = 'SCSARDPD'                                      BUG24157
     C                   EVAL      DBKEY = 'CER047'                                         BUG24157
     C                   EVAL      DBASE = 6                                                BUG24157
     C                   OUT       LDA                                                      BUG24157
     C                   EXSR      *PSSR                                                    BUG24157
     C                   ENDIF                                                              BUG24157
      *                                                                                     BUG24157
      *                                                                                       CER048
      ** Check if CER048 is installed.                                                        CER048
      *                                                                                       CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   IF        BGNTST = 'Y'                                               CER048
      *                                                                                       CER048
     C                   CALLB     'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtCd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtCd <> *BLANKS AND                                       CER048
     C                             PRtCd <> '*NRF'                                            CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   EVAL      DBASE = 3                                                  CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtCd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Check if CRE075 is installed.                                                        CRE075
      *                                                                                       CRE075
     C                   CALLB     'AOSARDR0'                                                 CRE075
     C                   PARM      *BLANKS       PRtCd                                        CRE075
     C                   PARM      '*VERIFY'     POptn                                        CRE075
     C                   PARM      'CRE075'      PSard                                        CRE075
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE075
                                                                                              CRE075
     C                   EVAL      CRE075 = 'N'                                               CRE075
     C                   IF        PRtCd = *BLANKS                                            CRE075
     C                   EVAL      CRE075 = 'Y'                                               CRE075
     C                   ENDIF                                                                CRE075
                                                                                              CRE075
     C                   IF        PRtCd <> *BLANKS  AND  PRtCd <> '*NRF   '                  CRE075
     C     *LOCK         IN        LDA                                                        CRE075
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE075
     C                   EVAL      DBKEY = 'CRE075'                                           CRE075
     C                   EVAL      DBASE = 7                                                  CRE075
     C                   OUT       LDA                                                        CRE075
     C                   EXSR      *PSSR                                                      CRE075
     C                   ENDIF                                                                CRE075
                                                                                              CER069
      ** Check if CER069 is installed.                                                        CER069
                                                                                              CER069
     C                   CALLB     'AOSARDR0'                                                 CER069
     C                   PARM      *BLANKS       PRtCd                                        CER069
     C                   PARM      '*VERIFY'     POptn                                        CER069
     C                   PARM      'CER069'      PSard                                        CER069
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER069
                                                                                              CER069
     C                   EVAL      CER069 = 'N'                                               CER069
     C                   IF        PRtCd = *BLANKS                                            CER069
     C                   EVAL      CER069 = 'Y'                                               CER069
     C                   ENDIF                                                                CER069
                                                                                              CER069
     C                   IF        PRtCd <> *BLANKS  AND  PRtCd <> '*NRF   '                  CER069
     C     *LOCK         IN        LDA                                                        CER069
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER069
     C                   EVAL      DBKEY = 'CER069'                                           CER069
     C                   EVAL      DBASE = 8                                                  CER069
     C                   OUT       LDA                                                        CER069
     C                   EXSR      *PSSR                                                      CER069
     C                   ENDIF                                                                CER069
                                                                                              CER069
      ** Check if CGL165 is installed.                                                        CER069
                                                                                              CER069
     C                   CALLB     'AOSARDR0'                                                 CER069
     C                   PARM      *BLANKS       PRtCd                                        CER069
     C                   PARM      '*VERIFY'     POptn                                        CER069
     C                   PARM      'CGL165'      PSard                                        CER069
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER069
                                                                                              CER069
     C                   EVAL      CGL165 = 'N'                                               CER069
     C                   IF        PRtCd = *BLANKS                                            CER069
     C                   EVAL      CGL165 = 'Y'                                               CER069
     C                   ENDIF                                                                CER069
     C                   MOVE      *OFF          *IN11                                        262025
      *                                                                                       262025
     C     KLActx        KLIST                                                                CER048
     C                   KFLD                    KFCusn                                       CER048
     C                   KFLD                    KFCtax                                       CER048
      *                                                                                     BUG23886
     C     KCTxCd        KLIST                                                              BUG23886
     C                   KFLD                    KCtTx                                      BUG23886
     C                   KFLD                    KCtRe                                      BUG23886
      *                                                                                     BUG23886
     C/COPY OFCPYSRCZ,CGL123_002                                                              CGL123
      *                                                                         CFT004
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
     C/COPY WNCPYSRC,GLAMA1VC07
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
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
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
 
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
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
      * #TERM - Termination processing.
      *****************************************************************
     C     #TERM         BEGSR
      *
      **  Terminate program
      *
     C                   MOVE      '1'           *INLR
      *
     C     *INU7         IFEQ      '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
