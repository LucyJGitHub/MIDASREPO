     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Debit interest/overdraft dtls validation')    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD2VL -  Debit Interest/Overdraft Details Validation     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD053611           Date 19Aug19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD047680           Date 08Sep17               *
      *                 MD046635           Date 10Aug17               *
      *                 MD020938           Date 19Jun13               *
      *                 CGL165             Date 17Feb15               *
      *                 MD029023           Date 21Nov14               *
      *                 CRE090             Date 14Feb14               *
      *                 MD024398           Date 11May14               *
      *                 MD000091           Date 07May13               *
      *                 AR947093A          Date 04May12               *
      *                 AR947093           Date 26Apr12               *
      *                 AR944106           Date 30Mar12               *
      *                 AR847249           Date 28Jan12               *
      *                 AR854615           Date 19Jan12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24157           Date 04Jun09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8550            Date 05Oct05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 14Feb99               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 180721             Date 03May00               *
      *                 CUT009             Date 19Feb01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 12Nov99               *
      *                 CPB001             Date 23Aug99               *
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053611 - Add validation when changing the interest         *
      *             calculation type.                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  MD047680 - Prevent validation of authority to the account    *
      *             branch if branch value is blank                   *
      *  MD046635 - User permissions are not verified on account      *
      *             input via AMAD API. Change the validation so that *
      *             the user inserting an account is always validated *
      *             to have authority to the branch of the account.   *
      *  MD020938 - Create new system values to check the branch/user *
      *             authority.                                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD029023 - Need to pass debit rate spread for validation of  *
      *             Additional O/D Rate                               *
      *  CRE090 - Delay Capitalisation of Interest                    *
      *  MD024398 - API Performance Optimisation                      *
      *  MD000091 - Event Codes Substitution                          *
      *  AR947093A - Base Rate amendment resulted to 0 interest rate  *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR944106 - Incorrect spread as calculated by the system      *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  AR854615 - Contractual spread indicator is always +          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding                              *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
      *             when field is set to Y (Recompile)                *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8550 - Reposition capture of ZMUSER data area             *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  208221 - Default Margin from Rate/Spread changes             *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CDE002 - CCRM Revenue Analysis - Recompile only              *
      *  180721 - Default "Next Statement Date" when opening          *
      *           Account coming from interface                       *
      *         - Retail Account Number must be calculated            *
      *  CUT009 - Manual addition of core hooks.                      *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers(Recompile Only)  *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     F/COPY WNCPYSRC,GLAMA2VF01

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

      ** Array of Fields with warnings.                                                       CER055
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     CER055
                                                                                              CER055
      ** Array of warning message IDs                                                         CER055
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        CER055
                                                                                              CER055
      ** Array of warning message data.                                                       CER055
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                      CER055
                                                                                              CER055
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDDRIBOK                      1A
     D  DDDRISOK                      1A
     D  DDDSIGOK                      1A
     D  DDDICTOK                      1A
     D  DDDCSTOK                      1A
     D  DDDRCDOK                      1A
     D  DDDRICOK                      1A
     D  DDNDIDOK                      1A
     D  DDDRIFOK                      1A
     D  DDDNCDOK                      1A
     D  DDDRBROK                      1A
     D  DDDACPOK                      1A
     D  DDODLNOK                      1A
     D  DDODSCOK                      1A
     D  DDITRDOK                      1A
     D  DDOLVDOK                      1A
     D  DDODEDOK                      1A
     D  DDAODROK                      1A
     D  DDAODRXOK                     1A
     D  DDORTCOK                      1A
     D  DDDCSPOK                      1A                                                      CRE073
     D  DDDCSGOK                      1A                                                      CRE073
     D  DDDRMTOK                      1A                                                      CRE073
     D  DDDRFDOK                      1A                                                      CRE073

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
                                                                                180721
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                    180721
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS                                 180721

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS

     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D SDRETLACCD    E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR RETAIL DETAILS

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
                                                                                180721
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    180721
      ** EXTERNAL DS FOR CUSTOMER DETAILS                                       180721

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
                                                                                180721
     DDSLDY          E DS                  EXTNAME(DSLDY)                       180721
      ** THIRD DS FOR ACCESS PROGRAMS, VERY LONG DATA STRUCTURE                 180721

     D ValidAccn     E DS                  EXTNAME(GLVAMADPD)
      * Valid Account layout -> ACCNTAB

     D ValidExBX     E DS                  EXTNAME(GLVAMBXPD)
     D GLBXACOD      E                     EXTFLD(QQACOD)                                     CGL029
      * Valid Extn. Account layout -> ACCNTBXC

     D ValidExRI     E DS                  EXTNAME(GLVAMRIPD)
     D GLRIACOD      E                     EXTFLD(QQACOD)                                     CGL029
      * Valid Extn. Account layout -> REIACD
                                                                                              208221
     D TranIn4       E DS                  EXTNAME(GLAMCOPD)                                  208221
      * Incoming Transaction (screen 4)                                                       208221

     D TranIn2       E DS                  EXTNAME(GLAMDIPD)
      * Incoming Transaction (screen 2)

     D TranIn1       E DS                  EXTNAME(GLAMADPD)
      * Incoming Transaction (screen 1)

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D ZMUSER          DS            17
      * ZMUSER data layout
     D  DBRN                  11     13

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                            MD000091
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
     D WIx             S              3P 0                                                    CER055
     D Indx            S              3P 0                                                    CRE073

      ** Fields defined for Enhancement CSC011                                                CSC011
     D CSC011          S              1A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
                                                                                              CSC011
      ** CER055 Overdraft Processing Flag                                                     CER055
     D CER055          S              1A                                                      CER055
                                                                                              CER055
     D CRE073          S              1A   INZ('N')                                           CRE073
     D TMCNSP          S             11P 7                                                    CRE073
     D NEWSRT          S             11P 7                                                    CRE073
     D WSPREAD         S             11P 7                                                    CRE073
     D NEWFRT          S             11P 7                                                  AR847249
     D PModule         S              6A                                                      CRE073
     D PCurset         S              2P 0                                                    CRE073
     D CRE090          S              1A   INZ('N')                                           CRE090
      ** Constant paramater for AOSVALR0                                                    MD020938
     D BRCUSR          C                   CONST('CheckBrchUserAuthori')                    MD020938
     D CurSysVal       DS           200                                                     MD020938
     D CurVal                  1      1                                                     MD020938
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
                                                                                             BUG8550
      **  GET ZMUSER to access default branch.                                               BUG8550
                                                                                             BUG8550
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C                   IN        ZMUSER                                                    BUG8550
     C                   UNLOCK    ZMUSER                                                    BUG8550

     C                   Z-Add     0             WWDBRT           11 7
     C                   Z-ADD     0             WWBRTT           11 7                      AR944106
     C                   Move      DDDRCD        WWDRCD            6
      *
     C                   Move      *Off          WIN44             1
     C     RINOALT       IfGT      0
     C                   Move      *On           WIN44
     C                   Endif
      *
      ** Access Currency details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCCY         @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY

      * Call Validation Modules in Sequence

      ** Validate Base Rate Type
      /COPY WNCPYSRC,GLAMAD2V01                                                               CUT009
     C                   EXSR      VBRATE
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
                                                                                              CRE073
     C                   EVAL      PModule = 'AMADDr'                                         CRE073
                                                                                              CRE073
      ** Validate Contractual Spread/Sign                                                     CRE073
                                                                                              CRE073
     C                   EXSR      SRSPSG                                                     CRE073
                                                                                              CRE073
      ** Validate Rounding Method                                                             CRE073
                                                                                              CRE073
     C                   IF        DDDCSPOK <> 'N'                                            CRE073
     C                   EXSR      SRRNDM                                                     CRE073
                                                                                              CRE073
      ** Validate Rounding Fraction/Decimal                                                   CRE073
                                                                                              CRE073
     C                   EXSR      SRRNDF                                                     CRE073
                                                                                              CRE073
      ** If all interest rate rounding related fields are valid                               CRE073
      ** compute for the new spread rate                                                      CRE073
                                                                                              CRE073
     C                   IF        DDDCSPOK <> 'N' AND                                        CRE073
     C                             DDDCSGOK <> 'N' AND                                        CRE073
     C                             DDDRMTOK <> 'N' AND                                        CRE073
     C                             DDDRFDOK <> 'N'                                            CRE073
     C                   EXSR      SRSPRT                                                     CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      /COPY WNCPYSRC,GLAMAD2V02                                                               CUT009
      ** Validate Rate/Spread & Sign
      /COPY WNCPYSRC,GLAMAD2V03                                                               CUT009
     C                   ELSE                                                                 CRE073
     C                   EXSR      VSRATE
     C                   ENDIF                                                                CRE073
      *                                                                                       CRE073
      /COPY WNCPYSRC,GLAMAD2V04                                                               CUT009
      ** Validate Interest Calc. Type/Subtype
      /COPY WNCPYSRC,GLAMAD2V05                                                               CUT009
     C                   EXSR      VICALC
      /COPY WNCPYSRC,GLAMAD2V06                                                               CUT009
      ** Validate This Change Value Date
      /COPY WNCPYSRC,GLAMAD2V07                                                               CUT009
     C**********         IF        CRE015 = 'N' OR                                AR947093 AR947093A
     C**********                   X5ATTY <>'P'                                   AR947093 AR947093A
     C                   EXSR      VCVDAT
     C**********         ENDIF                                                    AR947093 AR947093A
      /COPY WNCPYSRC,GLAMAD2V08                                                               CUT009
      ** Validate Calculation Basis
      /COPY WNCPYSRC,GLAMAD2V09                                                               CUT009
     C                   EXSR      VICALB
      /COPY WNCPYSRC,GLAMAD2V10                                                               CUT009
      ** Validate Next Capitalisation Date, Frequency & Day no.
      /COPY WNCPYSRC,GLAMAD2V11                                                               CUT009
     C                   EXSR      VNXCAP
      /COPY WNCPYSRC,GLAMAD2V12                                                               CUT009
      ** Validate Alternate A/C Dr. Interest Branch and Account
      /COPY WNCPYSRC,GLAMAD2V13                                                               CUT009
     C                   EXSR      VBRACP
      /COPY WNCPYSRC,GLAMAD2V14                                                               CUT009
      ** Validate Overdraft
      /COPY WNCPYSRC,GLAMAD2V15                                                               CUT009
     C                   EXSR      VOVRDRFT
      /COPY WNCPYSRC,GLAMAD2V16                                                               CUT009
      *
      *
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*

     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   Else
     C                   Move      WWDRCD        DDDRCD
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBRATE - Validate Base Rate Type
      *****************************************************************
     C     VBRATE        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVDBBS'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDDRIB
     C                   Parm                    DDCCY
     C                   Parm                    DDDACO
     C                   Parm                    DDDICT
     C                   Parm                    DDDCST
     C                   Parm                    DDDRIS                         180721
      *
      ** ICD
     C                   Parm                    BJDFIN
      *                                                                         180721
      ** Supplemental Validation for PB Customer (Y/N)                          180721
     C                   Parm                    WValforPB                      180721
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   Parm                    WWVDRC            5 0
     C                   Parm                    WWDBRT
     C                   PARM                    WWBRTT                                     AR944106
      *
      ** Base Rate Type - OK
     C                   Parm                    DDDRIBOk

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  VSRATE - Validate Rate/Spread & Sign
      *****************************************************************
     C     VSRATE        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVDBRT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDDRIS
     C                   Parm                    DDDSIG
     C                   Parm                    DDDICT
     C                   Parm                    DDDCST
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   Parm      *ZERO         WNDRIS           11 7
      *
      ** Rate/Spread - OK
      ** Rate/Spread Sign - OK
     C                   Parm                    DDDRISOk
     C                   Parm                    DDDSIGOk

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VICALC - Validate Interest Calc. Type/Subtype
      *****************************************************************
     C     VICALC        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVDBIT02'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDDICT
     C                   Parm                    DDDCST
     C                   Parm                    DDDRIB
     C                   Parm                    DDDRIS
     C                   Parm                    DDDSIG
     C                   Parm                    DDCCY
     C                   Parm                    DDCUSN                                     MD053611
     C                   Parm                    DDACOD                                     MD053611
     C                   Parm                    DDBRCA                                     MD053611
     C                   Parm                    DDACSQ                                     MD053611
      *
     C                   Parm                    WWVDRC
     C                   Parm                    WWDBRT
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      * Warning fields/message IDs/message data (arrays) from/to caller                     MD053611
     C                   PARM                    WFldNmXAr                                  MD053611
     C                   PARM                    WMsgIDXAr                                  MD053611
     C                   PARM                    WMsgDtXAr                                  MD053611
      *
      ** Interest Calc. Type - Ok
      ** Interest Calc. Subtype - Ok
     C                   Parm                    DDDICTOk
     C                   Parm                    DDDCSTOk
      *

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  VCVDAT - Validate This Change Value Date
      *****************************************************************
     C     VCVDAT        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
                                                                                180721
     C     WValforPB     Ifeq      'Y'                                          180721
     C     DDDRCD        Andeq     *Blanks                                      180721
     C     DDACTN        Andeq     'I'                                          180721
     C     WWID          Andeq     'TO'                                         180721
3676  *                                                                         180721
3677  **   Convert Day Number to Date                                           180721
3678 C                   Callb     'ZDATE2'                                     180721
     C**********         parm      BJRDNB        ZDAYNO                                180721 CSC011
     C                   PARM      WRunDay       ZDAYNO                                       CSC011
     C                   parm                    BJDFIN                         180721
     C                   parm                    ZNDATE            6 0          180721
     C                   parm                    ZADATE            7            180721
                                                                                180721
     C                   movel     ZNDATE        DDDRCD                         180721
     C                   Endif                                                  180721
      *
     C                   CALLB     'GLVDBDT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDDRCD
     C                   Parm                    DDACTN
     C                   Parm                    DDDRIB
     C                   Parm                    WNDRIS
     C                   Parm                    DDDICT
     C                   Parm                    DDDCST
     C                   Parm                    DDDACO
      *
     C                   Parm                    WWVDRC
      *
     C                   Parm                    AMDRIB
     C                   Parm                    AMDRIS
     C                   Parm                    AMOLDR
     C                   Parm                    RIDICT
     C                   Parm                    RIDCST
      *
      ** ICD
     C**********         Parm                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   Parm                    BJDFIN
     C                   Parm                    WWBKVD
      * Front Office ID                                                         180721
     C**********         PARM                    APFOTranID                            180721 CGL029
     C                   PARM                    APFOTran40                                   CGL029
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   Parm      *ZERO         WNDRCD            5 0
      *
      ** This Change Value Date - Ok
     C                   Parm                    DDDRCDOk

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VICALB - Validate Calculation Basis
      *****************************************************************
     C     VICALB        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVDBCC'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDDRIC
     C                   Parm                    DDDRIB
     C                   Parm                    DDDRIS
     C                   Parm                    DDDSIG
     C                   Parm                    DDDICT
     C                   Parm                    DDDCST
      *
      ** Standing Data
     C                   PARM                    A6DICB
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Calculation Basis - OK
     C                   Parm                    DDDRICOk

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VNXCAP - Validate Next Capital. Date, Frequency & Day no
      *****************************************************************
     C     VNXCAP        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
                                                                                180721
     C     WValforPB     Ifeq      'Y'                                          180721
     C     DDNDID        Andeq     *Blanks                                      180721
                                                                                180721
     C     DDDRIF        Ifeq      'D'                                          180721
     C                   Movel     DDDNCD        ZMDAY                          180721
     C                   Else                                                   180721
     C                   Z-add     *zeros        ZMDAY                          180721
     C                   Endif                                                  180721
                                                                                180721
     C                   CallB     'ZFREQB'                                     180721
     C                   Parm      *blanks       RetCodeIn                      180721
     C                   Parm      DDDRIF        ZFREQ             1            180721
     C**********         Parm      BJRDNB        ZDAYNO            5 0                 180721 CSC011
     C                   PARM      WRunDay       ZDAYNO            5 0                        CSC011
     C                   Parm      DDCcy         ZCCY              3            180721
     C                   Parm      *BLANKS       ZLOC              3                        AR702741
     C                   Parm                    ZMDAY             2 0          180721
     C                   Parm                    BJDFIN                         180721
     C                   Parm      SDGELR        SDGELR                         180721
                                                                                180721
     C     RetCodeIn     Ifeq      *blanks                                      180721
     C     ZdayNo        Andne     *zeros                                       180721
3676  *                                                                         180721
3677  **   Convert Day Number to Date                                           180721
3678 C                   Callb     'ZDATE2'                                     180721
     C                   parm                    ZDAYNO                         180721
     C                   parm                    BJDFIN                         180721
     C                   parm                    ZNDATE            6 0          180721
     C                   parm                    ZADATE            7            180721
                                                                                180721
     C                   movel     ZNDATE        DDNDID                         180721
     C                   Endif                                                  180721
                                                                                180721
     C                   Move      *blanks       RetCodeIn                      180721
     C                   Endif                                                  180721
      *
     C                   CALLB     'GLVDBFQ'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDNDID
     C                   Parm                    DDDRIF
     C                   Parm                    DDDNCD
     C                   Parm                    DDDRIB
     C                   Parm                    DDDRIS
     C                   Parm                    DDDSIG
     C                   Parm                    DDDICT
     C                   Parm                    DDDCST
     C                   Parm                    DDDACO
      *
      ** ICD
     C**********         Parm                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   Parm                    BJDFIN
     C                   Parm                    BMLDAI
     C                   PARM                    CRE090                                       CRE090
     C/COPY WNCPYSRC,GLAMA2VC01
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   Parm      *ZERO         WNNDID            5 0
     C                   Parm      *ZERO         WNDRDY            2 0
      *
      ** Next Capitalisation Date - Ok
      ** Next Capitalisation Freq - Ok
      ** Next Capitalisation Day  - Ok
     C                   Parm                    DDNDIDOk
     C                   Parm                    DDDRIFOk
     C                   Parm                    DDDNCDOk
     C/COPY WNCPYSRC,GLAMA2VC02

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBRACP - Validate Alternate A/C Dr. Interest Branch
      *****************************************************************
     C     VBRACP        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVDBAL'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDDRBR
     C                   Parm                    DDDACP
     C                   Parm                    DDDRIB
     C                   Parm                    DDDSIG
     C                   Parm                    DDACNO
     C                   Parm                    DDBRCA
     C                   Parm                    DDACTN
     C                   Parm                    DDCUSN
     C                   Parm                    DDCCY
     C                   Parm                    DDACOD
     C                   Parm                    DDACSQ
      *
     C                   Parm                    WIN44
      *
      ** ICD
     C                   Parm                    DBRN
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Alternate Account Branch - Ok
      ** Alternate Account - Ok
      ** Rate Spread Sign - Ok
     C                   Parm                    DDDRBROk
     C                   Parm                    DDDACPOk
     C                   Parm                    DDDSIGOk

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
                                                                                            MD046635
     C                   IF        DDDRBROk = 'Y' AND                                       MD046635
     C                             DDDACPOk = 'Y' AND                                       MD046635
     C                             DDDSIGOk = 'Y' AND                                       MD046635
     C**********                   CurVal   = 'Y'                                  MD046635 MD047680
     C                             CurVal   = 'Y' AND                                       MD047680
     C                             DDDRBR <> *BLANKS                                        MD047680
                                                                                            MD046635
     C                   EXSR      RESETERRS                                                MD046635
                                                                                            MD046635
     C                   MOVE      DDACTN        ZACTN                                      MD046635
     C                   CALL      'ZVACTBU'                                                MD046635
     C                   PARM                    ZACTN             1                        MD046635
     C                   PARM      DDDRBR        ZBR               3                        MD046635
     C                   PARM                    ERR               1 0                      MD046635
      *                                                                                     MD046635
      **   If action invalid for user                                                       MD046635
      *                                                                                     MD046635
     C     ERR           IFEQ      1                                                        MD046635
     C                   Z-ADD     1             I                                          MD046635
     C                   MOVEL     'DDDRBR'      FldNamXAr(I)                               MD046635
     C                   MOVEL     'RE71070'     MsgIDXAr(I)                                MD046635
     C                   ENDIF                                                              MD046635
      *                                                                                     MD046635
     C     ERR           IFEQ      2                                                        MD046635
     C                   Z-ADD     1             I                                          MD046635
     C     DDACTN        IFEQ      'I'                                                      MD046635
     C                   MOVEL     'DDDRBR'      FldNamXAr(I)                               MD046635
     C                   MOVEL     'RE7102B'     MsgIDXAr(I)                                MD046635
     C                   ENDIF                                                              MD046635
     C     DDACTN        IFEQ      'A'                                                      MD046635
     C                   MOVEL     'DDDRBR'      FldNamXAr(I)                               MD046635
     C                   MOVEL     'RE7103B'     MsgIDXAr(I)                                MD046635
     C                   ENDIF                                                              MD046635
     C     DDACTN        IFEQ      'D'                                                      MD046635
     C                   MOVEL     'DDDRBR'      FldNamXAr(I)                               MD046635
     C                   MOVEL     'RE7104B'     MsgIDXAr(I)                                MD046635
     C                   ENDIF                                                              MD046635
     C                   ENDIF                                                              MD046635
      *                                                                                     MD046635
     C     ERR           IFEQ      1                                                        MD046635
     C     ERR           OREQ      2                                                        MD046635
     C                   MOVE      'N'           DDDRBROk                                   MD046635
     C                   ENDIF                                                              MD046635
     C                   ENDIF                                                              MD046635
      *                                                                                     MD046635
     C                   EXSR      UPDATERRS                                                MD046635
      *                                                                                     MD020938
     C*****DDDRBR        IFEQ      *Blanks                                         MD020938 MD046635
     C*****BRIND         ANDEQ     'Y'                                             MD020938 MD046635
     C**********         MOVE      *BLANKS       BRIND                             MD020938 MD046635
     C**********         Move      ZBR           DDDRBR                            MD020938 MD046635
     C**********         ENDIF                                                     MD020938 MD046635
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  VOVRDRFT - Validate Overdraft Details
      *****************************************************************
     C     VOVRDRFT      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVODDE'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDODLN
     C                   Parm                    DDODSC
     C                   Parm                    DDITRD
     C                   Parm                    DDOLVD
     C                   Parm                    DDODED
     C                   Parm                    DDAODR
     C                   Parm                    DDAODRX
     C                   Parm                    DDORTC
     C                   Parm                    DDDICT
     C                   Parm                    DDDCST
     C                   Parm                    DDDACO
     C                   Parm                    DDACTN
     C                   Parm                    DDDRIB
     C                   Parm                    DDDRIS
     C                   Parm                    DDDSIG                                     MD029023
     C                   Parm                    WNDRCD
      *
     C                   Parm                    AMOLDR
     C                   Parm                    AMDRIB
     C                   Parm                    AMDRIS
     C                   Parm                    AMODED
     C                   Parm                    AMODLN
     C                   Parm                    BXOLVD
     C                   Parm                    BXORTC
     C                   Parm                    BXPOLC
     C                   Parm                    BXAODR
      *
      ** ICD
     C                   Parm                    CRE001
     C                   Parm                    CER055                                       CER055
     C                   Parm                    BJDFIN
     C**********         Parm                    BJRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   Parm                    WWBKVD
     C                   Parm                    WWFWVD
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr                                    CER055
     C                   PARM                    WMsgIDXAr                                    CER055
     C                   PARM                    WMsgDtXAr                                    CER055
      *
     C                   PARM      *ZERO         WNAODR           11 7
     C                   Parm      *ZERO         WNODLN           11 0
     C                   Parm                    AMDLIM
      *
      ** Overdraft Line - OK
      ** Overdraft Secured - OK
      ** Rev. Date (Line or Rate) - OK
      ** OD Line Charge Value Date - OK
      ** OD Line Expiry Date - OK
      ** Additional Overdraft Rate - OK
      ** Additional OD Rate Sign - OK
      ** Chg. Val. Date, OD Rate - OK
     C                   Parm                    DDODLNOK
     C                   Parm                    DDODSCOK
     C                   Parm                    DDITRDOK
     C                   Parm                    DDOLVDOK
     C                   Parm                    DDODEDOK
     C                   Parm                    DDAODROK
     C                   Parm                    DDAODRXOK
     C                   Parm                    DDORTCOK

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRSPSG - Validate Contractual Spread/Sign                    *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
     C     SRSPSG        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   EXSR      RESETERRS                                                  CRE073
                                                                                              CRE073
     C                   CALL      'ZAVCSPSG'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM      *BLANKS       DDBASR           12                          CRE073
     C                   PARM      *BLANKS       DDBRTT            2                          CRE073
     C                   PARM      *BLANKS       DDFXRT           12                          CRE073
     C                   PARM                    DDDCSP                                       CRE073
     C                   PARM                    DDDCSG                                       CRE073
     C                   PARM      *ZEROS        TMCNSP                                       CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      *ZEROS        PCurset                                      CRE073
     C                   PARM                    FldNamXAr                                    CRE073
     C                   PARM                    MsgIDXAr                                     CRE073
     C                   PARM                    MsgDtaXAr                                    CRE073
     C                   PARM      *ZEROS        Indx                                         CRE073
     C                   PARM                    DDDCSPOK                                     CRE073
     C                   PARM                    DDDCSGOK                                     CRE073
                                                                                              CRE073
     C                   EXSR      UPDATERRS                                                  CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRRNDM - Validate Rounding Method                            *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
     C     SRRNDM        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   EXSR      RESETERRS                                                  CRE073
                                                                                              CRE073
     C                   CALL      'ZAVRNDMT'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    DDDRMT                                       CRE073
     C                   PARM                    DDDCSP                                       CRE073
     C                   PARM                    DDDRFD                                       CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM                    PCurset                                      CRE073
     C                   PARM                    FldNamXAr                                    CRE073
     C                   PARM                    MsgIDXAr                                     CRE073
     C                   PARM                    MsgDtaXAr                                    CRE073
     C                   PARM      *ZEROS        Indx                                         CRE073
     C                   PARM                    DDDRMTOK                                     CRE073
                                                                                              CRE073
     C                   EXSR      UPDATERRS                                                  CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRRNDF - Validate Fraction/Decimal                           *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
     C     SRRNDF        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   EXSR      RESETERRS                                                  CRE073
                                                                                              CRE073
     C                   CALL      'ZAVRNDFD'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    DDDRFD                                       CRE073
     C                   PARM                    DDDCSP                                       CRE073
     C                   PARM                    DDDRMT                                       CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      *ZEROS        PCurset                                      CRE073
     C                   PARM                    FldNamXAr                                    CRE073
     C                   PARM                    MsgIDXAr                                     CRE073
     C                   PARM                    MsgDtaXAr                                    CRE073
     C                   PARM      *ZEROS        Indx                                         CRE073
     C                   PARM                    DDDRFDOK                                     CRE073
                                                                                              CRE073
     C                   EXSR      UPDATERRS                                                  CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *                                                               *                       CRE073
      *  SRSPRT - Compute for the new spread rate based on the        *                       CRE073
      *           rounding rules                                      *                       CRE073
      *                                                               *                       CRE073
      *****************************************************************                       CRE073
     C     SRSPRT        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   IF        CRE015  = 'Y'  AND                                       AR947093
     C                             X5ATTY = 'P'                                             AR947093
     C**********         MOVE      AMDRIS        NEWSRT                           AR947093 AR947093A
     C**********         MOVE      AMDRIS        WNDRIS                           AR947093 AR947093A
     C                   CallB     'ZALIGN'                                                AR947093A
     C                   Parm                    ZAlignOk          1                       AR947093A
     C                   Parm      DDDRIS        ZField           16                       AR947093A
     C                   Parm      7             ZADec                                     AR947093A
     C                   Parm      4             ZADig             2 0                     AR947093A
     C                   IF        ZAlignOk = 'Y'                                          AR947093A
     C                   Move      ZField        NEWSRT                                    AR947093A
     C                   IF        DDDSIG  = '-'                                           AR947093A
     C                   MULT      -1            NEWSRT                                    AR947093A
     C                   ENDIF                                                             AR947093A
     C                   Z-ADD     NEWSRT        WNDRIS                                    AR947093A
     C                   ENDIF                                                             AR947093A
     C                                                                                     AR947093A
     C                   ELSE                                                               AR947093
     C                   CALL      'ZACALCSPRT'                                               CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C**********         PARM                    WWDBRT                              CRE073 AR944106
     C                   PARM                    WWBRTT                                     AR944106
     C                   PARM                    TMCNSP                                       CRE073
     C                   PARM                    DDDCSG                                       CRE073
     C                   PARM                    DDDRMT                                       CRE073
     C                   PARM                    DDDRFD                                       CRE073
     C                   PARM      *ZEROS        NEWSRT                                       CRE073
     C                   PARM      *ZEROS        NEWFRT                                     AR847249
                                                                                              CRE073
     C                   IF        PRTCD <> *BLANKS                                           CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C**********         IF        NEWFRT <= *ZEROS AND                            AR847249 AR947093
     C**********                   DDDRMT <> *BLANKS                               AR847249 AR947093
     C**********         EVAL      DDDRMTOK = 'N'                                  AR847249 AR947093
     C**********         EVAL      FldNamXAr(1) = 'DDDRMT'                         AR847249 AR947093
     C**********         EVAL      MsgIDXAr(1)  = 'USS0015'                        AR847249 AR947093
      **********                                                                   AR847249 AR947093
     C**********         EVAL      MsgDtaXAr(1) = %EDITC(NEWFRT:'J')               AR847249 AR947093
     C**********         EXSR      UPDATERRS                                       AR847249 AR947093
     C**********         ELSE                                                      AR847249 AR947093
     C                   IF        NEWSRT = *ZERO                                             CRE073
     C                   EVAL      DDDRIS = *BLANKS                                           CRE073
     C                   EVAL      DDDSIG = *BLANKS                                           CRE073
     C                   ELSE                                                                 CRE073
     C                   Z-ADD     *ZEROS        WSPREAD                                      CRE073
     C                   IF        NEWSRT < *ZERO                                             CRE073
                                                                                            AR847249
     C                   EVAL      DDDRISOK = 'W'                                           AR847249
     C                   EVAL      WFldNmXAr(1) = 'DDDRIS'                                  AR847249
     C                   EVAL      WMsgIDXAr(1) = 'USS0016'                                 AR847249
     C**********         EVAL      WMsgDtXAr(1) = %EDITC(NEWSRT:'J')               AR847249 MD000091
     C                   EVAL      MsgDtaTmp = %EDITC(NEWSRT:'J')                           MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtXAr(1) = LenStr +%TRIM(MsgDtaTmp)                  MD000091
     C                   EXSR      UPDATERRS                                                AR847249
     C**********         MOVE      '-'           DDDSIG                              CRE073 AR854615
     C**********         MOVE      '+'           DDDSIG                            AR854615 AR847249
     C                   IF        DDDCSG = '+'                                             AR847249
     C                   MOVE      '-'           DDDSIG                                     AR847249
     C                   ELSEIF    DDDCSG = '-'                                             AR847249
     C                   MOVE      '+'           DDDSIG                                     AR847249
     C                   ENDIF                                                              AR847249
     C                   EVAL      WSPREAD = %ABS(NEWSRT)                                     CRE073
     C                   ELSE                                                                 CRE073
     C**********         MOVE      '+'           DDDSIG                              CRE073 AR854615
     C                   MOVE      DDDCSG        DDDSIG                                     AR854615
     C                   Z-ADD     NEWSRT        WSPREAD                                      CRE073
     C                   ENDIF                                                                CRE073
     C                   MOVE      *BLANKS       ZFIELD                                       CRE073
     C                   MOVE(P)   WSPREAD       ZFIELD                                       CRE073
     C                   Z-ADD     7             ZADEC                                        CRE073
     C                   CALLB     'ZEDIT'                                                    CRE073
     C                   PARM                    ZFIELD           16                          CRE073
     C                   PARM                    ZADEC             1 0                        CRE073
     C                   MOVE      ZFIELD        DDDRIS                                       CRE073
     C                   ENDIF                                                                CRE073
     C                   IF        DDDCSG = '-'                                             AR854615
     C**********                   AND NEWSRT > 0                                 AR854615 AR947093A
      ** Convert to positive for Negative spread rate                                       AR854615
     C**********                   OR  NEWSRT < 0                                 AR854615 AR947093A
     C                   MULT      -1            NEWSRT                                     AR854615
     C                   ENDIF                                                              AR854615
     C                   Z-ADD     NEWSRT        WNDRIS                                       CRE073
     C                   ENDIF                                                              AR847249
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************
     C/EJECT
      /COPY WNCPYSRC,GLAMAD2V17                                                               CUT009
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR
      *
     C     DDACTN        IFEQ      'I'
     C                   Move      DDCUSN        RICNUM
     C                   Move      DDCCY         RICCY
     C                   Move      DDACOD        RIACOD
     C                   Move      DDACSQ        RIACSQ
     C                   Move      DDBRCA        RIBRCA
     C                   ENDIF
     C                   MOVE      DDDRIB        AMDRIB
      *                                                                                       CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   Z-ADD     TMCNSP        AMDCSP                                       CRE073
     C                   MOVEL     DDDCSG        AMDCSG                                       CRE073
     C                   MOVEL     DDDRMT        AMDRMT                                       CRE073
     C                   MOVEL     DDDRFD        AMDRFD                                       CRE073
     C                   Z-ADD     NEWSRT        AMDRIS                                       CRE073
      *                                                                                       CRE073
     C                   ELSE                                                                 CRE073
     C                   Z-ADD     WNDRIS        AMDRIS
     C                   ENDIF                                                                CRE073
     C                   Z-ADD     WNDRCD        AMDRCD
     C                   Move      DDDICT        RIDICT
     C                   Move      DDDCST        RIDCST
     C                   Move      DDDRIC        AMDRIC
     C                   Z-ADD     WNNDID        AMNDID
     C                   MOVE      DDDRIF        AMDRIF
     C                   Z-ADD     WNDRDY        AMDRDY
     C                   Move      DDDRBR        RIDRBR
     C                   Move      DDDACP        RIDACP
     C                   Move      DDODSC        AMODSC
     C                   Z-ADD     WNAODR        BXAODR
     C     CER055        IFEQ      'Y'                                                        CER055
     C     WNODLN        ANDNE     AMODLN                                                     CER055
     C                   Z-ADD     AMODLN        BXPOLA                                       CER055
     C                   ENDIF                                                                CER055
     C                   Z-Add     WNODLN        AMODLN
      *
     C                   CallB     'ZDATE1'
     C                   Parm      DDITRD        DateIn            6
     C                   Parm      *Zero         DaynoOut          5 0
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag         1
     C                   Z-Add     DaynoOut      BXITRD
      *
     C                   CallB     'ZDATE1'
     C                   Parm      DDOLVD        DateIn
     C                   Parm      *Zero         DaynoOut
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag
      *                                                                                       CER055
     C                   Z-Add     DaynoOut      WWOLVD            5 0                        CER055
     C     CER055        IFEQ      'Y'                                                        CER055
     C     WWOLVD        ANDNE     BXOLVD                                                     CER055
     C                   Z-ADD     BXOLVD        BXPOLC                                       CER055
     C                   ENDIF                                                                CER055
     C                   Z-Add     DaynoOut      BXOLVD
      *
     C                   CallB     'ZDATE1'
     C                   Parm      DDODED        DateIn
     C                   Parm      *Zero         DaynoOut
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag
      *                                                                                       CER055
     C                   Z-Add     DaynoOut      WWODED            5 0                        CER055
     C     CER055        IFEQ      'Y'                                                        CER055
     C     WWODED        ANDNE     AMODED                                                     CER055
     C                   Z-ADD     AMODED        BXPOLE                                       CER055
     C                   ENDIF                                                                CER055
     C                   Z-Add     DaynoOut      AMODED
      *
     C                   CallB     'ZDATE1'
     C                   Parm      DDORTC        DateIn
     C                   Parm      *Zero         DaynoOut
     C                   Parm                    BJDFIN
     C                   Parm                    ErrorFlag
     C                   Z-Add     DaynoOut      BXORTC
     C*                                                                                       208221
     C** Check if Revenue Analysis (CDE002) is present                                        208221
     C*                                                                                       208221
     C     CDE002        IFEQ      'Y'                                                        208221
     C*                                                                                       208221
     C** Only default on Insert. Note if the rate/spread is zero,                             208221
     C** the margin will default to zero                                                      208221
     C*                                                                                       208221
     C     DDACTN        IFEQ      'I'                                                        208221
     C     DDDRIB        IFNE      *BLANKS                                                    208221
     C                   MOVE      *ZEROS        ZFLD15                                       CRE073
     C                   Z-ADD     WNDRIS        BXDRMG                                       208221
     C                   MOVEL     'Y'           BXOVRD                                       208221
     C                   MOVEL     'Y'           DDOVRD                                       208221
     C                   MOVE      BXDRMG        ZFLD15                                       208221
     C                   EVAL      ZDECS= 7                                                   208221
     C                   CALLB     'ZSEDIT'                                                   208221
     C                   PARM                    ZFLD15           15 0                        208221
     C                   PARM                    ZDECS             1 0                        208221
     C                   PARM      *BLANKS       ZECODE            1                          208221
     C                   PARM                    ZOUT21           21                          208221
     C                   EVAL      DDDRMG= %SUBST(ZOUT21:10:12)                               208221
     C                   ELSE                                                                 208221
     C                   MOVEL     *BLANKS       BXDRMG                                       208221
     C                   MOVEL     *BLANKS       BXOVRD                                       208221
     C                   MOVEL     *BLANKS       DDDRMG                                       208221
     C                   MOVEL     *BLANKS       DDOVRD                                       208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
     C*                                                                                       208221

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Transaction information (DS) from source system
     C                   PARM                    TranIn1
     C                   PARM                    TranIn2
     C                   PARM                    TranIn4                                      208221
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
      * Warning fields/message IDs/message data (arrays) from/to caller                       CER055
     C                   PARM                    WFldNamArr                                   CER055
     C                   PARM                    WMsgIDArr                                    CER055
     C                   PARM                    WMsgDtaArr                                   CER055
      * Array index (3P0) from/to caller                                                      CER055
     C                   PARM                    WIx                                          CER055
      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidAccn
     C                   PARM                    ValidExBX
     C                   PARM                    ValidExRI
      * Revenue Analysis                                                        208221
     C                   PARM                    CDE002            1            208221
     C                   PARM                    CRE015            1                        AR947093
     C                   PARM                    X5ATTY            1                        AR947093
      *
      **  GET ZMUSER to access default branch.
      *
     C******DTAARA       DEFINE                  ZMUSER                                      BUG8550
     C**********         IN        ZMUSER                                                    BUG8550
     C**********         UNLOCK    ZMUSER                                                    BUG8550
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLAMAD2VL'   DBPGM
     C                   OUT       LDA
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *                                                                         180721
      ** Access General Ledger details via access program                       180721
      *  (database error handling done in access program)                       180721
     C**********         CALLB     'AOGELRR0'                                   180721        CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD                          180721
     C                   PARM      '*FIRST '     @OPTN                          180721
     C*****SDGELR        PARM      SDGELR        DSFDY                          180721        CGL029
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
      ** Access SAR file to determine if CEU013 is present.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRE001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'CRE001'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   ENDIF
     C                   MOVEL     'N'           CRE001            1
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRE001
     C                   ENDIF
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
      ** CSC011 is a redundant feature. No need to check                                    MD024398
                                                                                            MD024398
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
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
                                                                                              CER055
      ** Check if CER055 is installed                                                         CER055
                                                                                              CER055
     C                   CALLB     'AOSARDR0'                                                 CER055
     C                   PARM      *BLANKS       PRtCd                                        CER055
     C                   PARM      '*VERIFY'     POptn                                        CER055
     C                   PARM      'CER055'      PSard                                        CER055
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER055
                                                                                              CER055
     C                   IF        PRtCd = *Blanks                                            CER055
     C                   EVAL      CER055 = 'Y'                                               CER055
     C                   ELSE                                                                 CER055
     C                   EVAL      CER055 = 'N'                                               CER055
     C                   IF        PRtCd <> '*NRF'                                            CER055
     C     *LOCK         IN        LDA                                                        CER055
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER055
     C                   EVAL      DBKEY = 'CER055'                                           CER055
     C                   EVAL      DBASE = 3                                                  CER055
     C                   OUT       LDA                                                        CER055
     C                   EXSR      *PSSR                                                      CER055
     C                   ENDIF                                                                CER055
     C                   ENDIF                                                                CER055
      *
      **  Get the Back Value Limit Date
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND S1SUPP = LIBR                             CSC011
     C     WRunDay       SUB       BJBVPD        WWBKVD            5 0                        CSC011
     C     WRunDay       ADD       BMNDFV        WWFWVD            5 0                        CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C     BJRDNB        SUB       BJBVPD        WWBKVD            5 0
      *
      **  Get the Forward Value Limit Date
     C     BJRDNB        ADD       BMNDFV        WWFWVD            5 0
     C                   ENDIF                                                                CSC011
                                                                                              CRE073
      ** Check if CRE073 is installed                                                         CRE073
                                                                                              CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRtCd                                        CRE073
     C                   PARM      '*VERIFY'     POptn                                        CRE073
     C                   PARM      'CRE073'      PSard                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
                                                                                              CRE073
     C                   IF        PRtCd = *BLANKS                                            CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      CRE073 = 'N'                                               CRE073
     C                   IF        PRtCd <> '*NRF'                                            CRE073
     C     *LOCK         IN        LDA                                                        CRE073
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE073
     C                   EVAL      DBKEY = 'CRE073'                                           CRE073
     C                   EVAL      DBASE = 4                                                  CRE073
     C                   OUT       LDA                                                        CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
                                                                                              CRE090
      ** Check if CRE090 is installed                                                         CRE090
                                                                                              CRE090
     C                   CALLB     'AOSARDR0'                                                 CRE090
     C                   PARM      *BLANKS       PRtCd                                        CRE090
     C                   PARM      '*VERIFY'     POptn                                        CRE090
     C                   PARM      'CRE090'      PSard                                        CRE090
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE090
                                                                                              CRE090
     C                   IF        PRtCd = *BLANKS                                            CRE090
     C                   EVAL      CRE090 = 'Y'                                               CRE090
     C                   ELSE                                                                 CRE090
     C                   EVAL      CRE090 = 'N'                                               CRE090
     C                   IF        PRtCd <> '*NRF'                                            CRE090
     C     *LOCK         IN        LDA                                                        CRE090
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE090
     C                   EVAL      DBKEY = 'CRE090'                                           CRE090
     C                   EVAL      DBASE = 5                                                  CRE090
     C                   OUT       LDA                                                        CRE090
     C                   EXSR      *PSSR                                                      CRE090
     C                   ENDIF                                                                CRE090
                                                                                              CRE090
     C                   ENDIF                                                                CRE090
                                                                                              CRE090
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
      *                                                                         180721
     C                   Movel     'N'           WValforPB         1            180721
     C                   Movel     *Blanks       WWID              2            180721
      *                                                                         180721
     C     BGN4ST        IFEQ      'Y'                                          180721
      *                                                                         180721
     C**********         Movel     APFOTranID    WWID                                  180721 CGL029
     C                   Movel     APFOTran40    WWID                                         CGL029
      *                                                                         180721
     C     AMATYP        IFEQ      'R'                                          180721
      *                                                                         180721
     C                   Movel     AMCNUM        @CNUM                          180721
     C                   CALL      'AOCUSTR1'                                   180721
     C                   PARM      '*DBERR '     @RTCD                          180721
     C                   PARM      '*KEY   '     @OPTN                          180721
     C                   PARM                    @CNUM            10            180721
     C                   PARM      *BLANKS       @CNST             7            180721
     C     SDCUST        PARM      SDCUST        DSLDY                          180721
      *                                                                         180721
     C     BBPRBA        IFEQ      'Y'                                          180721
     C                   Movel     'Y'           WValforPB                      180721
     C                   ENDIF                                                  180721
     C                   ENDIF                                                  180721
     C                   ENDIF                                                  180721
                                                                                            MD046635
     C                   CALLB     'AOSVALR0'                                               MD046635
     C                   PARM                    @RTCD             7                        MD046635
     C                   PARM      BRCUSR        @OP01            20                        MD046635
     C     CurSysVal     PARM                    @VL01           200                        MD046635
     C                   PARM                    @OP02            20                        MD046635
     C                   PARM                    @VL02           200                        MD046635
     C                   PARM                    @OP03            20                        MD046635
     C                   PARM                    @VL03           200                        MD046635
     C                   PARM                    @OP04            20                        MD046635
     C                   PARM                    @VL04           200                        MD046635
     C                   PARM                    @OP05            20                        MD046635
     C                   PARM                    @VL05           200                        MD046635
     C                   PARM                    @OP06            20                        MD046635
     C                   PARM                    @VL06           200                        MD046635
     C                   PARM                    @OP07            20                        MD046635
     C                   PARM                    @VL07           200                        MD046635
     C                   PARM                    @OP08            20                        MD046635
     C                   PARM                    @VL08           200                        MD046635
     C                   PARM                    @OP09            20                        MD046635
     C                   PARM                    @VL09           200                        MD046635
     C                   PARM                    @OP10            20                        MD046635
     C                   PARM                    @VL10           200                        MD046635
                                                                                            MD046635
     C/COPY WNCPYSRC,GLAMA2VC03

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
     C                   MOVEL     *BLANK        WFldNmXAr                                    CER055
     C                   MOVEL     *BLANK        WMsgIDXAr                                    CER055
     C                   MOVEL     *BLANK        WMsgDtXAr                                    CER055

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
      *                                                                                       CER055
      * Update warning fields/message IDs/message data (arrays)                               CER055
      *                                                                                       CER055
     C                   Z-ADD     1             I                                            CER055
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99                  CER055
     C     *IN99         IFEQ      '1'                                                        CER055
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)                                CER055
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)                                 CER055
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)                                CER055
     C                   END                                                                  CER055
      *                                                                                       CER055
      * Set Warning Index                                                                     CER055
     C                   Z-ADD     1             I                                            CER055
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99                  CER055
     C     I             SUB       1             WIx                                          CER055
      *                                                                                       CER055
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
(c) Finastra International Limited 2001
