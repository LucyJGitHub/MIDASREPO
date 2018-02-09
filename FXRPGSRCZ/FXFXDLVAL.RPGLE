     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deal validation')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange Dealing Module                      *
      *                                                               *
      *  FXFXDLVAL - FX Deal Validation                               *
      *                                                               *
      *  Function: This Program Validates FX Deals for Input into     *
      *            the Midas database.                                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 MD039203           Date 14Jun16               *
      *                 CDL094             Date 01Sep14               *
      *                 AR720772           Date 19Aug14               *
      *                 CDL091             Date 12Dec12               *
      *                 CSW212             Date 03May12               *
      *                 207288             Date 10Jun03               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25240B          Date 13Aug09               *
      *                 BUG23668           Date 01Apr09               *
      *                 BUG23050A          Date 20Mar09               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248269             Date 25Jun07               *
      *                 246386             Date 20Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245101             Date 31Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242477             Date 27Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 07Jul06               *
      *                 CGL058             Date 30Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10704           Date 13Mar06               *
      *                 BUG9717            Date 29Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL029A            Date 09May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6251            Date 17Mar05               *
      *                 CAS008             Date 16Jun04               *
      *                 BUG5517            Date 19Jan05               *
      *                 BUG6124            Date 03Mar05               *
      *                 CDL035             Date 28Feb05               *
      *                 BUG5578            Date 21Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CDL029             Date 23Nov04               *
      *                 CFX114             Date 15Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      *                 CDL011             Date 07Jul02               *
      *                 214936             Date 27Feb03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 213799             Date 09Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 196952             Date 06May02               *
      *                 202132             Date 03Apr02               *
      *                 183759             Date 11Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 CAS001             Date 23Nov01               *
      *                 195763             Date 07Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 184685             Date 19Jan01               *
      *                 CPB002             Date 08Aug00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 11Nov99               *
      *                 CPB001             Date 01Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 07Sep98               *
      *                 141077             Date 21Aug98               *
      *                 CAP002  *CREATE    Date 06OCT97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date                                    *
      *  MD039203 - When creating an FX Deal, the value of Forward    *
      *             points and sign were not save upon completion of  *
      *             the transaction                                   *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *            (Recompile)                                        *
      *  AR720772 - Reverse fix BUG5578 to accept OT deal exchange    *
      *             rate not equal to related OP deal.                *
      *             (Child: AR720773)                                 *
      *  CDL091 - FX Auto Calculation (GIB016)                        *
      *         - Added hook :                                        *
      *             CDL091_012                                        *
      *             CDL091_013                                        *
      *             CDL091_014                                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  207288 - Check spot indicator for deal type/subtype          *
      *           combination and issue warning message when needed.  *
      *           Applied for AR999664 (Child: AR999668)              *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25240B - Reciprocal Rate Indicator Function (Recompile).  *
      *  BUG23668 - Defaulting of Reciprocal rate indicator when spot *
      *             rate is close to 1.                               *
      *  BUG23050A -Reciprocal rate indicator not defaulting.         *
      *             Defaulting of Reciprocal Rate indicator(FGE002).  *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248269 - Use original spot rate in validating the exchange   *
      *           rate of an Option takedown deal.                    *
      *  246386 - Reset Their/Sell Yield Curve OK flag before call    *
      *           to ZAVYLDC01.                                       *
      *  245101 - Applied fix 231410.                                 *
      *  231410 - Divide by zero error when trying to amend an FX     *
      *           deal.  Execute SR/C_MGAM during insert mode.        *
      *  242477 - Applied fix 200709.  Incorrect deals update due to  *
      *           authorisation of 2nd leg of swap before authorising *
      *           the 1st leg.  Prevent authorisation of the 2nd leg  *
      *           if 1st leg is not yet authorised.                   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  CGL058 - Default Branch Code                                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10704 - If entered transaction customer is not valid      *
      *             or does not exist in file, validation of          *
      *             customer VS branch must not be carried out.       *
      *  BUG9717- Defaulting of class should be done when CDL038      *
      *           feature is currently ON.                            *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL029A- Adding new field                                    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6251- Added parameter 'deal type' for use in defaulting   *
      *           of NBUY and NSEL indicators.                        *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  BUG5517- Authorisation Error on FXDL.  Retrieve contents of  *
      *           DTAARA/ZMUSER moved out of INZSR                    *
      *  BUG6124 - Branch code error when CDL029 is set on.           *
      *  CDL035 - Validate Trade input date against CLS Cust Eff Date *
      *  BUG5578- Default and validate exchange rate for OT deals.    *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CDL029 - Midas SD Authorised Booking Branches for Customers  *
      *  CFX114 - Core changes for GBO014                             *
      *         - Perform Override when Exchange Rate Tolerance is    *
      *           exceeded.                                           *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FXFXDLVC02,FXFXDLV031,FXFXDLV027,*
      *                              FXFXDLV030,FXFXDLV032            *
      *           Core hooks added:FXFXDLVX01                         *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *  CDL011 - Expansion of Customer Number on Dealing Transactions*
      *  214936 - Exchange rate versus amount validation is being     *
      *           done during amendment even if the fields involved   *
      *           are not amendable.  This validation should be       *
      *           perform only during insertion.                      *
      *  213799 - Customer Selection screen issued twice with '?'     *
      *  196952 - Ensure rate has 5 digits before decimal separator   *
      *           and 8 digits after. Use DDRAT1 instead of DDRATE.   *
      *  202132 - Error while selecting customer number using '?' in  *
      *           the customer field.  User have to select a customer *
      *           twice before it gets accepted.                      *
      *  183759 - Allow insert/authorise FX deal even if Base Curr    *
      *           Equivalent exceeds to 20% tolerance range since     *
      *           error msg FXX0421 is only a warning message.        *
      *  CSC011   24x7 Midas Availability                             *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  195763 - Recompiled due to changes in FXVEXCHVAM.            *
      *  184685 - Recompiled due to changes in FXVCUSTBK.             *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CAP051 - Automatic Authorisation (FX Part)                   *
      *  CPB001 - 'Private Banking' Module                            *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  141077 - Holiday validation of value date & option to date   *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FFXCDAFLL  IF   E             DISK    INFSR(*PSSR)

     FSDABBCL0  IF   E           K DISK    INFSR(*PSSR)                                       CDL029
      ** Midas SD Authorised Booking Branches for Customers)                                  CDL029
                                                                                              CDL029
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FXFXDLV030

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

     D @SF             S             10  0 DIM(10) CTDATA PERRCD(1)


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

     D RelDealDts      DS
      ** Related Deal Details (when deal is option takedown or swap.
      ** Thus related deal will be other leg of swap or option).
     D  RelDBRC                1      3
     D  RelCCY1                4      6
     D  RelCCY2                7      9
     D  RelDAM1               10     24  0
     D  RelDAM2               25     39  0
     D**RelDCNO*              40     45  0                                                    CSD027
     D  RelDCNO               40     45                                                       CSD027
     D  RelDCSN               46     55
     D  RelDDYY               56     59  0                                      deal date - year
     D  RelDDMM               60     61  0                                      deal date - mnth
     D  RelDDDD               62     63  0                                      deal date - day
     D  RelVDYY               64     67  0                                      val date - year
     D  RelVDMM               68     69  0                                      val date - mnth
     D  RelVDDD               70     71  0                                      val date - day
     D  RelDOEY               72     75  0                                      opt date - year
     D  RelDOEM               76     77  0                                      opt date - mnth
     D  RelDOED               78     79  0                                      opt date - day
     D  RelMGPT               80     86  2                                      opt date - day
     D  RelMGBS               87     87                                         opt date - day
     D  RelDXRT               88    100  8                                      opt date - day
     D  RelOSRT              101    113  8                                                    248269




     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS

     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D SDDEALACCD    E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR DEALING DETAILS

     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D SDTRADACCD    E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR Trading Data

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS

     D SDTRMA        E DS                  EXTNAME(SDTRMAPD)                    S01319
      ** EXTERNAL DS FOR Treasury Management DETAILS

     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** EXTERNAL DS FOR Portfolio Management DETAILS

     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  SDRETLACCD   E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR RETAIL DETAILS

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CPB002
      ** EXTERNAL DS FOR CUSTOMER DETAILS                                       CPB002
                                                                                CPB002
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D DSLDY         E DS                  EXTNAME(DSLDY)                       CPB002
      * THIRD DS FOR ACCESS PROGRAMS, VERY LONG DATA STRUCTURE                  CPB002

     D ValidDeal     E DS                  EXTNAME(FXVFXDLPD)
      * Valid Deals layout
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CDL099
     D InCDL099      E DS                  EXTNAME(FXDLEXPD)                                  CDL099
      * FX Deal Extra Data Layout Definition (input)                                          CDL099
                                                                                              CDL099
     D ZMUSER          DS            17
     D  ZUSER                  1     10                                                       CDL010
     D  BRC                   11     13
     D  DEPT                  14     16

     D TranIn        E DS                  EXTNAME(FXFXDLPD)
      * Incoming Transaction
                                                                                CAP051
     D InfData       E DS                  EXTNAME(FXFXIFPD)                    CAP051
     D                                     PREFIX(IF_)                          CAP051
      * FX (FXDL) Extra Data - File (D/B) format                                CAP051
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(FXFXEXPD)                    CAP004
      * FX Extra Data - File (D/B) format                                       CAP004
     D/COPY WNCPYSRC,FXH00128
                                                                                CPB002
      **  Front Office (2 First characters determine System Front Office)       CPB002
     D FrontOffice     DS            20                                         CPB002
     D  W_System               1      2                                         CPB002

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** DEFINE FIELDS FOR ZDATE9
     D @DAYN           S              5P 0
     D @YMD            S              8S 0
     D @RETN           S              1A


      **   First scaling exponent
     D     @@SXP1      S              1S 0
      **   Second scaling exponent
     D     @@SXP2      S                   LIKE(@@SXP1)
      **   Base currency scaling exponent
     D     @@BCSP      S                   LIKE(@@SXP1)


      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

      ** Index for arrays of of error message ids for CDL029                                  CDL029
     D P               S              3P 0                                                    CDL029
                                                                                              CDL029
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDActnOK                      1A
     D  DDDlnoOK                      1A
     D  DDDltpOK                      1A
     D  DDDlstOK                      1A
     D  DDFedfOK                      1A
     D  DDDldtOK                      1A
     D  DDBrsnOK                      1A
     D  DDBrkrOK                      1A
     D  DDBkrgOK                      1A
     D  DDSdnoOK                      1A
     D  DDCustOK                      1A
     D  DDVdatOK                      1A
     D  DDOdatOK                      1A
     D  DDBokcOK                      1A
     D  DDLnknOK                      1A
     D  DDPtfrOK                      1A
     D  DDBccyOK                      1A
     D  DDBamtOK                      1A
     D  DDNbuyOK                      1A
     D  DDRateOK                      1A
     D  DDFpntOK                      1A
     D  DDSignOK                      1A
     D  DDMginOK                      1A
     D  DDMbsiOK                      1A
     D  DDSccyOK                      1A
     D  DDSamtOK                      1A
     D  DDPrfcOK                      1A
     D  DDNselOK                      1A
     D  DDBceOK                       1A
     D  DDOrbrOK                      1A
     D  DDDbsrOK                      1A
     D  DDBbfpOK                      1A
     D  DDBbfsOK                      1A
     D  DDSbfpOK                      1A
     D  DDSbfsOK                      1A
     D  DDMtchOK                      1A
     D  DDCLSSOK                      1A                                        CDL008
     D  DDOylcOK                      1A                                                      CAS001
     D  DDTylcOK                      1A                                                      CAS001
     D  DDClasOK                      1A                                                      CDL038
     D  DDReinOK                      1A                                                      CER043
     D/COPY WNCPYSRC,FXH00060


      ** Receive / Pay Settlement Currency, Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D RecNostro       S             18A                                                      CDL038
     D*RecNostro*******S             12A                                                      CDL038
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D PayNostro       S             18A                                                      CDL038
     D*PayNostro*******S             12A                                                      CDL038


      ** A code to indicate the calling function to the lower level modules
     D FXDL            S              4A   INZ('FXDL')

      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
                                                                                              CAS001
      ** Define fields used in CAS001                                                         CAS001
     D CAS001          S              1A                                                      CAS001
     D PYCFN           S              6A                                                      CAS001
     D PERTP           S              1A                                                      CAS001
     D PFwRv           S              1A                                                      CAS005
     D PFwYC           S              5A                                                      CAS005
     D PFCRv           S              1A                                                      CAS008

      ** Fields defined for Enhancement CSC011                                                CSC011
     D CSC011          S              1A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
                                                                                              CSC011
      ** Fields defined for Enhancement CDL010                                                CDL010
     D CDL010          S              1A                                                      CDL010
                                                                                              CDL010
      ** Fields defined for Enhancement CDL029                                                CDL029
     D CDL029          S              1A                                                      CDL029
                                                                                              CDL029
     D CDL038          S              1A                                                     BUG9717
     D CDL049          S              1A                                                      CDL049
      *                                                                                       CGL058
      ** CGL058 - Default Branch Code                                                         CGL058
      *                                                                                       CGL058
     D CGL058          S              1A   INZ('N')                                           CGL058
     D/COPY WNCPYSRC,FXH00018
     D CER043          S              1A                                                      CER043
     D CDL099          S              1A                                                      CDL099
     D
     D/COPY OFCPYSRCZ,CDL091_012                                                              CDL091
     D @YYYYMMDD       DS                                                                     CDL099
     D @YYYY                          4S 0                                                    CDL099
     D @MM                            2S 0                                                    CDL099
     D @DD                            2S 0                                                    CDL099
      *                                                                                       CDL099
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FXFXDLV031

      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      /COPY WNCPYSRC,FXFXDLV001
      *                                                                                      BUG5517
      **  Get default branch and user from ZMUSER                                            BUG5517
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG5517
     C                   IN        ZMUSER                                                    BUG5517
     C                   UNLOCK    ZMUSER                                                    BUG5517

      * Call Validation Modules in Sequence

      *
      ** Validate Swap/Option Deal Number
      *
      /COPY WNCPYSRC,FXFXDLV002

     C                   EXSR      VSODLNO
      *
      /COPY WNCPYSRC,FXFXDLV003

      ***Validate*Deal*Type/Sub*Type*&*Fed*Funds*Ind                            CDL038
      **********************************************                            CDL038
      /COPY WNCPYSRC,FXFXDLV004
                                                                                CPB002
      * Defautl Deal Type/Sub type if necessary                                 CPB002
      *                                                                         CPB002
     C*****'?'**         SCAN      DDCUST                                 01           202132 213799
     C**********         IF        *IN01 <> *On                                        202132 213799
      *****************************************************************                202132 213799
     C                   Eval      P_Cust = *Blanks                             CPB002
     C                   Callb     'AOCUSTR1'                                   CPB002
     C                   Parm      *Blanks       @RTCD                          CPB002
     C                   Parm      '*KEY   '     @OPTN                          CPB002
     C                   Parm      DDCUST        @CUST            10            CPB002
     C                   Parm                    @KEY7             7            CPB002
     C     SDCUST        Parm      SDCUST        DSLDY                          CPB002
                                                                                              213799
     C                   SELECT                                                               213799
     C     @RTCD         WHENEQ    *BLANKS                                                    213799
     C                   MOVEL(P)  BBCUST        DDCUST                                       213799
     C     @RTCD         WHENEQ    '*NOSEL '                                                  213799
     C                   MOVEL     *BLANKS       DDCUST                                       213799
     C                   ENDSL                                                                213799
      *                                                                         CPB002
     C     BBPRBA        Ifeq      'Y'                                          CPB002
     C     @RTCD         Andeq     *Blanks                                      CPB002
     C                   Movel     BBCUST        P_Cust                         CPB002
     C                   Call      'PBDFST'                                     CPB002
     C                   Parm                    P_Cust            6            CPB002
     C                   Parm      DDDLTP        P_DType           2            CPB002
     C                   Parm      DDDLST        P_DSType          2            CPB002
     C                   Parm      DDACTN        P_Action          1            CPB002
                                                                                CPB002
      * Defautl Deal Type                                                       CPB002
     C     P_DType       Ifne      *Blanks                                      CPB002
     C                   Eval      DDDLTP = P_DType                             CPB002
     C                   Endif                                                  CPB002
                                                                                CPB002
      * Defautl Deal Sub Type                                                   CPB002
     C     P_DSType      Ifne      *Blanks                                      CPB002
     C                   Eval      DDDLST = P_DSType                            CPB002
     C                   Endif                                                  CPB002
     C                   Endif                                                  CPB002

     C**********         ENDIF                                                         202132 213799
      **********                                                                       202132 213799
                                                                                CDL038
      ** Default Sub Type and Class                                             CDL038
      *                                                                         CDL038
     C                   IF        CDL038 = 'Y'                                              BUG9717
     C                   EXSR      DSUBTCLAS                                    CDL038
     C                   ENDIF                                                               BUG9717
                                                                                CDL038
      ** Validate Deal Type/Sub Type & Fed Funds Ind                            CDL038
      *                                                                         CDL038
     C                   EXSR      VDEALTPS
      *
      /COPY WNCPYSRC,FXFXDLV005

      ** Validate Booking and Originating Branch
      *
      /COPY WNCPYSRC,FXFXDLV006

     C                   IF        CGL058 <> 'Y'                                              CGL058
      *                                                                                       CGL058
     C                   EXSR      VBRANCHS
      *                                                                                       CGL058
     C                   ENDIF                                                                CGL058
      *
      /COPY WNCPYSRC,FXFXDLV007

      ** Validate Deal Date, Value Date, Option To Date
      *
      /COPY WNCPYSRC,FXFXDLV008

     C                   EXSR      VDATES
      *
      /COPY WNCPYSRC,FXFXDLV009

      ** Validate Broker Code & Brokerage
      *
      /COPY WNCPYSRC,FXFXDLV010

     C                   EXSR      VBROKRGE
      *
      /COPY WNCPYSRC,FXFXDLV011

      ** Validate Customer, Book, Portfolio & Profit Centre
      *
      /COPY WNCPYSRC,FXFXDLV012

     C                   EXSR      VCUSTBK
      *
      /COPY WNCPYSRC,FXFXDLV013
      *                                                                                       CGL058
     C                   IF        CGL058 = 'Y'                                               CGL058
     C                   EXSR      VBBBRCD                                                    CGL058
     C                   EXSR      VBRANCHS                                                   CGL058
     C                   ENDIF                                                                CGL058

      ** Validate Linked Reference Number
      *
      /COPY WNCPYSRC,FXFXDLV014

     C                   EXSR      VLNKN
      *
      /COPY WNCPYSRC,FXFXDLV015
      *                                                                                       CER043
      ** Validate Reciprocal Rate Indicator                                                   CER043
      *                                                                                       CER043
     C                   IF        CER043 = 'Y'                                               CER043
     C                   EXSR      SRVREIN                                                    CER043
     C                   ENDIF                                                                CER043

      ** Validate Buy and Sell Currencies and Amounts
      *
      /COPY WNCPYSRC,FXFXDLV016

     C                   EXSR      VBSAMTS
      *
      /COPY WNCPYSRC,FXFXDLV017

      ** Validate Exchange Rate, Fwd Points & Sign
      *
      /COPY WNCPYSRC,FXFXDLV018

     C                   EXSR      VEXCHRAT
      *
      /COPY WNCPYSRC,FXFXDLV019

      ** Validate Margin & Other Forward Points
      ** only if S01453 is installed
      *
      /COPY WNCPYSRC,FXFXDLV020

     C     S01453        IFEQ      'Y'
     C                   EXSR      VMARGIN
     C                   END
      *
      /COPY WNCPYSRC,FXFXDLV021

      ** Validate Exchange Rate versus Amounts
      *
      /COPY WNCPYSRC,FXFXDLV022

     C     DDRateOK      IFNE      'N'
     C     DDFpntOK      ANDNE     'N'
     C     DDSignOK      ANDNE     'N'
     C     DDMginOK      ANDNE     'N'
     C     DDMbsiOK      ANDNE     'N'
     C     DDBccyOK      ANDNE     'N'
     C     DDBAmtOK      ANDNE     'N'
     C     DDSccyOK      ANDNE     'N'
     C     DDSAmtOK      ANDNE     'N'
     C     DDACTN        ANDEQ     'I'                                                        214936
     C                   EXSR      DETRAT@FP
     C/COPY WNCPYSRC,FXH00021
     C                   EXSR      VEXCHVAM
     C                   END
      *
      /COPY WNCPYSRC,FXFXDLV023

      ** Validate Base Currency Equivalent
      *
      /COPY WNCPYSRC,FXFXDLV024

     C                   EXSR      VBSECYAE
      *
      /COPY WNCPYSRC,FXFXDLV025

      ** Validate FX Netting fields
      ** only if CDL002 is installed and Customer and Value Date valid
      *
      /COPY WNCPYSRC,FXFXDLV026

     C     CDL002        IFEQ      'Y'
     C     DDCustOK      ANDNE     'N'
     C     DDVdatOK      ANDNE     'N'
     C                   EXSR      VFXNETS
     C                   END
      *                                                                         CDL008
      ** Validate continous link settlement only if CDL008 is installed.        CDL008
     C                   IF        CDL008 = 'Y'                                 CDL008
     C                   EXSR      VFXCLSS                                      CDL008
     C                   ENDIF                                                  CDL008
                                                                                              CAS001
      ***Validate*Yield*Curves*if*CAS001*is*on*and*Deal*Type/Subtype                   CAS001 CDL038
      ** Validate Yield Curves if CAS001 is on and Deal Type/Subtype/Class                    CDL038
      ** have no error                                                                        CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y' AND                                           CAS001
     C                             DDDltpOK = 'Y' AND                                         CAS001
     C                             DDDlstOK = 'Y' AND                                         CDL038
     C                             DDClasOK = 'Y'                                             CDL038
     C*****************************DDDlstOK = 'Y'                                      CAS001 CDL038
     C/COPY WNCPYSRC,FXH00240
     C                   EXSR      SRVOYLC                                                    CAS001
     C                   EXSR      SRVTYLC                                                    CAS001
     C                   ENDIF                                                                CAS001
      *                                                                                       CDL049
      * Validate Reference Rate field                                                         CDL049
     C                   IF        CDL049 = 'Y'                                               CDL049
     C                   EXSR      VRRAT                                                      CDL049
     C                   ENDIF                                                                CDL049
      *                                                                                       CDL099
     C                   IF        CDL099 ='Y'                                                CDL099
      *                                                                                       CDL099
     C                   EXSR      RESETERRS                                                  CDL099
      *                                                                                       CDL099
      ** Call New Split Value Date Validation Module                                          CDL099
     C                   CALLB     'FXVSPVDT'                                                 CDL099
     C                   Parm                    RetCodeOut                                   CDL099
     C                   Parm                    DDSDAT                                       CDL099
     C                   Parm                    DDVDAT                                       CDL099
     C                   Parm                    DDSCCY                                       CDL099
     C                   Parm                    BJDFIN                                       CDL099
     C                   Parm                    FldNamXAr                                    CDL099
     C                   Parm                    MsgIDXAr                                     CDL099
     C                   Parm                    MsgDtaXAr                                    CDL099
     C                   Parm                    WFldNmXAr                                    CDL099
     C                   Parm                    WMsgIDXAr                                    CDL099
     C                   Parm                    WMsgDtXAr                                    CDL099
     C                   Parm                    OK#SVDT           1                          CDL099
     C                   Parm                    SVSVDT            6                          CDL099
      *                                                                                       CDL099
      ** Update Valid File Parameters if Sell Value Date is valid                             CDL099
     C                   IF        OK#SVDT <> 'N'                                             CDL099
      *                                                                                       CDL099
     C                   EVAL      DDSDAT = SVSVDT                                            CDL099
      *                                                                                       CDL099
      ** Convert to Midas Number                                                              CDL099
     C                   CALLB     'ZAVDATE'                                                  CDL099
     C                   PARM      *BLANK        RetCodeOut                                   CDL099
     C                   PARM      DDSDAT        @@DATE            6                          CDL099
     C                   PARM                    BJDFIN                                       CDL099
     C                   PARM                    ValuDtDN          5 0                        CDL099
      *                                                                                       CDL099
      ** Convert to YYYYMMDD format                                                           CDL099
     C                   CALLB     'ZDATE9'                                                   CDL099
     C                   PARM      ValuDtDN      @DAYN                                        CDL099
     C                   PARM                    @YMD                                         CDL099
     C                   PARM                    @RETN                                        CDL099
      *                                                                                       CDL099
     C                   EVAL      @YYYYMMDD = %CHAR(@YMD)                                    CDL099
     C                   EVAL      F3VS2Y = @YYYY                                             CDL099
     C                   EVAL      F3VS2M = @MM                                               CDL099
     C                   EVAL      F3VS2D = @DD                                               CDL099
      *                                                                                       CDL099
     C                   EVAL      F3S2DN = ValuDtDN                                          CDL099
     C                   EVAL      F3S1DN = 0                                                 CDL099
     C                   ENDIF                                                                CDL099
      *                                                                                       CDL099
     C                   EXSR      UPDATERRS                                                  CDL099
      *                                                                                       CDL099
     C                   ENDIF                                                                CDL099

      /COPY WNCPYSRC,FXFXDLV027

      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*

      /COPY WNCPYSRC,FXFXDLV028

     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
      *
      /COPY WNCPYSRC,FXFXDLV029

      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FXFXDLV032

      *****************************************************************                       CGL058
      ** VBBBRCD  - Validate branch                                                           CGL058
      *****************************************************************                       CGL058
     C     VBBBRCD       BEGSR                                                                CGL058
      *                                                                                       CGL058
      ** Validate Booking and Originating Branch                                              CGL058
      *                                                                                       CGL058
     C                   CALLB     'FXVBBBRCD'                                                CGL058
      *                                                                                       CGL058
      ** Inputs                                                                               CGL058
      *                                                                                       CGL058
      ** Return Code                                                                          CGL058
      *                                                                                       CGL058
     C                   PARM                    DDACTN            1            Action        CGL058
     C                   PARM                    BJSBRC            3            Single        CGL058
     C                   PARM                    DDCUST           10            Counter       CGL058
     C                   PARM                    DDBRSN            3            Booking       CGL058
     C                   PARM                    DDORBR            3            Origin.       CGL058
                                                                                              CGL058
     C                   ENDSR                                                                CGL058
      *****************************************************************
      ** VSODLNO - Validate Swap/Option Deal Number
      *****************************************************************
     C     VSODLNO       BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Swap/Option Deal Number
      *
     C                   CALLB     'FXVSODLNO'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
     C                   PARM                    DDACTN            1            action code
     C                   PARM                    DDDLNO            6            action code
     C                   PARM                    DDDLTP            2            action code
     C                   PARM                    DDBRKR            4            action code
     C                   PARM                    DDSDNO            6            SW/OP deal no
      *
      * ICD
     C**********         PARM                    BJRDNB            5 0                        CSC011
     C                   PARM                    WRunDay                                      CSC011
      *
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Swap/option deal no - OK
     C                   PARM                    DDSdnoOK          1              SW/OP deal no
      *
      ** Related deal details
     C                   PARM                    RelDealDts                       SW/OP deal no
     C                   PARM                    DDDTYP                                       242477

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VDEALTPS - Validate Deal Type/Sub Type & Fed Funds Ind
      *****************************************************************
     C     VDEALTPS      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Deal Type/Sub Type & Fed Funds Ind
      *
     C                   CALLB     'FXVDEALTPS'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
     C                   PARM                    DDDLTP            2            deal type
     C                   PARM                    DDDLST            2            deal sub type
     C                   PARM                    DDCLAS            4            class         CDL038
     C                   PARM                    DDFEDF            1            fed funds ind
     C                   PARM                    DDBCCY            3            buy ccy
     C                   PARM                    DDSCCY            3            sell ccy
      *
      * ICD
     C                   PARM                    BLUSCY            3
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Deal Type - OK
      ** Deal Sub-Type - OK
      ** Class         - OK                                                                   CDL038
      ** Federal Funds - OK
     C                   PARM                    DDDltpOK          1            deal type
     C                   PARM                    DDDlstOK          1            deal sub type
     C                   PARM                    DDClasOK          1            class         CDL038
     C                   PARM                    DDFedfOK          1            fed funds ind

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBRANCHS - Validate Booking and Originating Branch
      *****************************************************************
     C     VBRANCHS      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      *  Validate Booking and Originating Branch                                             `
      *
     C                   CALLB     'FXVBRANCHS'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
     C                   PARM                    DDACTN            1            action code
     C                   PARM                    DDDLTP            2            deal type
     C                   PARM                    DDBRSN            3            booking branch
     C                   PARM                    DDORBR            3            origin. branch
      *
      ** Swap/Opt Deal no OK
     C                   PARM                    ddSDNOok          1              SW/OP deal no.
      *
      ** Related deal details
     C                   PARM                    RelDealDts                     SW/OP branch
      *
      ** ICD
     C                   PARM                    BJSBRC            3
     C                   PARM                    BKOBRU            1
     C                   PARM                    BKOBUV            1
      *
      ** Response mode (from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    RespMode          1
      *
      ** Default branch code from ZMUSER
     C                   PARM                    BRC               3
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Action code - OK
      ** Booking branch - OK
      ** Originating branch - OK
     C                   PARM                    DDActnOK          1              action code
     C                   PARM                    DDBrsnOK          1              booking branch
     C                   PARM                    DDOrbrOK          1              origin. branch
      *
      ** Deal Booking Branch & Originating Branch
     C                   PARM                    F3DBRC            3            booking branch
     C                   PARM                    F3ORBR            3            origin. branch

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C**********         IF        CDL029 ='Y'                                        CDL029 BUG6124
      **********                                                                      CDL029 BUG6124
     C*****KBRANCHAUTH   CHAIN     SDABBCL0                           91              CDL029 BUG6124
     C**********         IF        *IN91 = '1'                                        CDL029 BUG6124
     C**********         MOVE      'N'           DDBrsnOK                             CDL029 BUG6124
     C*****Idx**         ADD       1             P                                    CDL029 BUG6124
     C**********         MOVEL     'DDBRSN'      FldNameArr(P)                        CDL029 BUG6124
     C**********         MOVEL     'DDBRSN'      FldNamXAr(P)                         CDL029 BUG6124
     C**********         MOVEL     'FXM7001'     MsgIdArr(P)                          CDL029 BUG6124
     C**********         MOVEL     'FXM7001'     MsgIDXAr(P)                          CDL029 BUG6124
     C**********         END                                                          CDL029 BUG6124
      **********                                                                      CDL029 BUG6124
     C**********         END                                                          CDL029 BUG6124
      *                                                                                       CDL029
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VDATES - Validate Deal Date, Value Date, Option To Date
      *****************************************************************
     C     VDATES        BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Deal Date, Value Date, Option To Date
      *
     C/COPY WNCPYSRC,FXH00063
     C                   CALLB     'FXVDATES'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
     C                   PARM                    DDACTN            1            action code
     C                   PARM                    DDDLTP            2            deal type
     C                   PARM                    DDDLST            2                          207288
     C                   PARM                    DDBRSN            3            booking branch
     C                   PARM                    DDDLDT            6            deal date
     C                   PARM                    DDVDAT            6            value date
     C                   PARM                    DDODAT            6            option to date
     C                   PARM                    DDBRKR            4            broker
     C                   PARM                    DDSDNO            6            SW/OP deal no.
     C                   PARM                    DDBCCY            3            141077
     C                   PARM                    DDSCCY            3            141077
      *
      ** Deal settlement instruction fields
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth                     rec settle meth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth                     pay settle meth
     C                   PARM                    PayNostro
      *
      ** Booking branch OK
      ** Swap/Opt Deal no OK
     C                   PARM                    DDBrsnOK          1            booking branch
     C                   PARM                    DDSdnoOK          1            SW/OP deal no.
     C                   PARM                    DDDltpOK          1                          207288
     C                   PARM                    DDDlstOK          1                          207288
      *
      ** Related deal details
     C                   PARM                    RelDealDts                     SW/OP branch
      *
      * Booking branch loc
     C                   PARM                    BkBrnLoc          3            book. branch loc
      *
      * ICD
      *
     C**********         PARM                    BJRDNB            5 0                        CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJDFIN            1
     C                   PARM                    BJSBRC            3
     C                   PARM                    BJLCCY            3
     C                   PARM                    BJSLCD            3
     C                   PARM                    BJHOCY            3
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr                      141077
     C                   PARM                    WMsgIDXAr                      141077
     C                   PARM                    WMsgDtXAr                      141077
      *
      ** Date date - OK
      ** Value date - OK
      ** Option to date - OK
     C                   PARM                    DDDldtOK          1            deal date
     C                   PARM                    DDVdatOK          1            value date
     C                   PARM                    DDOdatOK          1            option to date
      *
      ** Deal deal date, value date, option to date
      *
     C                   PARM                    F3DDDN            5 0          deal date
     C                   PARM                    F3VDDN            5 0          deal date
     C                   PARM                    F3OTDN            5 0          deal date

     C/COPY WNCPYSRC,FXH00064
      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
     C/COPY WNCPYSRC,FXH00129
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBROKRGE - Validate Broker Code & Brokerage
      *****************************************************************
     C     VBROKRGE      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Broker Code & Brokerage
      *
     C                   CALLB     'FXVBROKRGE'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
     C                   PARM                    DDDLTP            2            deal type
     C                   PARM                    DDBRKR            4            broker
     C                   PARM                    DDBKRG           16            brokerage
      *
      * ICD
     C                   PARM                    BNDCSP            1            new dl status
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Broker - OK
      ** Brokerage - OK
     C                   PARM                    DDBrkrOK          1            broker
     C                   PARM                    DDBkrgOK          1            brokerage
      *
      ** Deal Broker, Brokerage and Broker ccy
      *
     C                   PARM                    F3BROK            4            broker
     C                   PARM                    F3BRKG           15 0          brokerage
     C                   PARM                    F3BKCY            3            broker ccy

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCUSTBK - Validate Customer, Book, Portfolio & Profit Centre
      *****************************************************************
     C     VCUSTBK       BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Customer, Book, Portfolio & Profit Centre
      *
     C                   CALLB     'FXVCUSTBK'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
     C                   PARM                    DDACTN            1            action code
     C                   PARM                    DDDLTP            2            deal type
     C                   PARM                    DDDLST            2            deal sub type
     C                   PARM                    DDBRSN            3            booking branch
      *
     C                   PARM                    DDCUST           10            customer
     C                   PARM                    DDBOKC            2            book
     C                   PARM                    DDPTFR            4            portfolio
     C                   PARM                    DDPRFC            4            profit centre
     C                   PARM                    DDNBUY            1            profit centre
     C                   PARM                    DDNSEL            1            profit centre
     C/COPY WNCPYSRC,FXH00130
      *
      ** Related deal details
     C                   PARM                    RelDealDts                     SW/OP branch
      *
      ** Swap/Opt Deal no OK
      ** Booking branch OK
     C                   PARM                    DDBrsnOK          1            booking branch
     C                   PARM                    DDSdnoOK          1            SW/OP deal no.
      *
      * ICD
     C                   PARM                    BNBCOP            1            new dl status
     C                   PARM                    BNBKCD            2            new dl status
     C                   PARM                    BGPFMG            1
     C                   PARM                    BGUDRS            1
     C                   PARM                    BKPRCU            1
     C                   PARM                    BKPCDU            1
     C                   PARM                    FCR997            4
     C                   PARM                    FCPORS            1
     C                   PARM                    BGN0ST            1
     C                   PARM                    CDL002            1
     C                   PARM                    BGN4ST            1            CPB001
      * Dept from ZMUSER
     C                   PARM                    DEPT              3
      * customer format
      * N = customer number, else customer shortname
     C                   PARM                    CustFormat        1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Customer - OK
      ** Book - OK
      ** Portfolio - OK
      ** Profit Centre - OK
      ** Deal Type - OK
      ** Net Buy Ind - OK
      ** Net Sell Ind - OK
     C                   PARM                    DDCustOK          1            customer
     C                   PARM                    DDBokcOK          1            book
     C                   PARM                    DDPtfrOK          1            portfolio
     C                   PARM                    DDPrfcOK          1            profit centre
     C                   PARM                    DDDltpOK          1            profit centre
     C                   PARM                    DDNbuyOK          1            profit centre
     C                   PARM                    DDNselOK          1            profit centre
      *
      ** Deal Customer number/shortname, book, portfolio, profit centre
      *
     C                   PARM                    F3DCNO                         customer no
     C                   PARM                    F3DCSN           10            customer shtname
     C                   PARM                    F3BOKC            2            book
     C                   PARM                    F3PTFR            4            portfolio
     C                   PARM                    F3PRFC            4            profit centre

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   IF        CDL029 ='Y'                                               BUG6124
     C                             AND DDCustOK = 'Y'                                       BUG10704
      *                                                                                      BUG6124
     C                   MOVEL     *BLANKS       W0BRCD                                      CDL029A
     C                   MOVEL     BBCUST        W0CUST                                      CDL029A
      *                                                                                      CDL029A
     C     KBRANCHAUTH   CHAIN     SDABBCL0                           91                     CDL029A
      *                                                                                      CDL029A
     C                   IF        *IN91 = '1'                                               CDL029A
      *                                                                                      CDL029A
     C                   MOVEL     BBBRCD        W0BRCD                                      CDL029A
     C                   MOVEL     *BLANKS       W0CUST                                      CDL029A
      *                                                                                      CDL029A
     C     KBRANCHAUTH   CHAIN     SDABBCL0                           91                     BUG6124
      *                                                                                      CDL029A
     C                   ENDIF                                                               CDL029A
      *                                                                                      CDL029A
     C                   IF        *IN91 = '1'                                               BUG6124
     C                   MOVE      'N'           DDBrsnOK                                    BUG6124
     C     Idx           ADD       1             P                                           BUG6124
     C                   MOVEL     'DDBRSN'      FldNameArr(P)                               BUG6124
     C                   MOVEL     'DDBRSN'      FldNamXAr(P)                                BUG6124
     C                   MOVEL     'FXM7001'     MsgIdArr(P)                                 BUG6124
     C                   MOVEL     'FXM7001'     MsgIDXAr(P)                                 BUG6124
     C                   END                                                                 BUG6124
      *                                                                                      BUG6124
     C                   END                                                                 BUG6124
      *                                                                                      BUG6124
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VLNKN - Validate Linked Reference Number
      *****************************************************************
     C     VLNKN         BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Linked Reference Number
      *
     C                   CALLB     'FXVLNKN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
     C                   PARM                    DDLNKN
      *
      * ICD
     C                   PARM                    BNDCSP            1            new dl status
      *
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Linked reference no - OK
     C                   PARM                    DDLNKNOK
      *
      ** Deal Linked Reference No.
     C                   PARM                    F3LNKN

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBSAMTS - Validate Buy and Sell Currencies and Amounts
      *****************************************************************
     C     VBSAMTS       BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Buy and Sell Currencies and Amounts
      *
     C                   CALLB     'FXVBSAMTS'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
     C                   PARM                    DDACTN            1            action code
     C                   PARM                    DDDLTP            2            deal type
     C                   PARM                    DDBRKR            4            broker
      *
     C                   PARM                    DDBCCY            3            buy ccy
     C                   PARM                    DDSCCY            3            sell ccy
     C                   PARM                    DDBAMT           14            buy amount
     C                   PARM                    DDSAMT           14            sell amount
      *
      ** Related deal details
     C                   PARM                    RelDealDts                     SW/OP branch
      *
      ** Swap/Opt Deal no OK
     C                   PARM                    DDSdnoOK          1            SW/OP deal no
      *
      * ICD
     C                   PARM                    BJCYCD                         new dl status
     C                   PARM                    BNCYDL                         new dl status
     C                   PARM                    BGTRMG                         new dl status
     C                   PARM                    BNDCSP                         new dl status
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Ccy 1 details
     C                   PARM                    @SPOT1           13 8          spot rate
     C                   PARM                    @CDP1             1 0          no of dec places
     C                   PARM                    @RDCY1            1            round down
     C                   PARM                    @@NDP1            1 0          norm quot decs
     C                   PARM                    @@SXP1                         scaling exponent
     C                   PARM                    @@MDF1            1            mult/div ind
     C                   PARM                    @@MDX1            1            mult/div ind,exch
     C                   PARM                    @@LSP1           13 8          low spot rate
     C                   PARM                    @@HSP1           13 8          high spot rate
     C                   PARM                    @@SPD1            8 0          FX spot date
     C                   PARM                    @NEXRT1                                      CER043
      *
      * Ccy 2 details
     C                   PARM                    @SPOT2           13 8          spot rate
     C                   PARM                    @CDP2             1 0          no of dec places
     C                   PARM                    @RDCY2            1            round down
     C                   PARM                    @@NDP2            1 0          norm quot decs
     C                   PARM                    @@SXP2                         scaling exponent
     C                   PARM                    @@MDF2            1            mult/div ind
     C                   PARM                    @@MDX2            1            mult/div ind,exch
     C                   PARM                    @@LSP2           13 8          low spot rate
     C                   PARM                    @@HSP2           13 8          high spot rate
     C                   PARM                    @@SPD2            8 0          FX spot date
     C                   PARM                    @NEXRT2                                      CER043
      *
      ** Buy ccy - OK
      ** Sell ccy - OK
      ** Buy amt - OK
      ** Sell amt - OK
     C                   PARM                    DDBccyOK          1            Buy ccy error
     C                   PARM                    DDSccyOK          1            Sell ccy error
     C                   PARM                    DDBamtOK          1            Buy amt error
     C                   PARM                    DDSamtOK          1            Sell amt error
     C                   PARM                    DDRateOK          1                          CER043
      *
      ** Deal Buy ccy, sell ccy, buy amt, sell amt
      *
     C                   PARM                    F3CCY1            3            buy ccy
     C                   PARM                    F3CCY2            3            sell ccy
     C                   PARM                    F3DAM1           15 0          buy amount
     C                   PARM                    F3DAM2           15 0          sell amount

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/COPY WNCPYSRC,FXH00022
     C/EJECT
      *****************************************************************
      ** VEXCHRAT - Validate Exchange Rate, Fwd Points & Sign
      *****************************************************************
     C     VEXCHRAT      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Exchange Rate, Fwd Points & Sign
      *
     C                   CALLB     'FXVEXCHRAT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
     C                   PARM                    DDBCCY            3            buy ccy
     C                   PARM                    DDSCCY            3            sell ccy
     C**********         PARM                    DDDLTP            2   deal type    BUG5578 AR720772
     C                   PARM                    DDDLTP            2                        MD039203
      *
     C**********         PARM                    DDRATE           13            exch rate     196952
     C                   PARM                    DDRAT1           14            exch rate     196952
     C                   PARM                    DDREIN                                       CER043
     C                   PARM                    @SPOT1           13 8                        CER043
     C                   PARM                    @@MDF1            1                          CER043
     C                   PARM                    @NEXRT1           5 2                        CER043
     C                   PARM                    @SPOT2           13 8                        CER043
     C                   PARM                    @@MDF2            1                          CER043
     C                   PARM                    @NEXRT2           5 2                        CER043
     C**********         PARM                    RelDXRT          13 8 OT deal rate BUG5578 AR720772
     C                   PARM                    RelOSRT          13 8                        248269
     C                   PARM                    S01453            1                          248269
     C                   PARM                    DDFPNT            8            fwd pts
     C                   PARM                    DDSIGN            1            fwd pts sgn
      *
      * Scaling Exponent 1 & 2
     C                   PARM                    @@SXP1                         scaling exponent
     C                   PARM                    @@SXP2                         scaling exponent
      *
      ** Buy ccy Ok
      ** Sell ccy OK
     C                   PARM                    DDBccyOK          1            Buy ccy error
     C                   PARM                    DDSccyOK          1            Sell ccy error
      *
      * ICD
     C                   PARM                    BNCYDL            3
     C                   PARM                    BNDCSP            1            new dl status
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr                                    CER043
     C                   PARM                    WMsgIDXAr                                    CER043
     C                   PARM                    WMsgDtXAr                                    CER043
      *
      ** Exchange Rate - OK
      ** Forward Points - OK
      ** Forward Points Sign - OK
     C                   PARM                    DDRateOK          1            err-exch rate
     C                   PARM                    DDFpntOK          1            err-fwd pts
     C                   PARM                    DDSignOK          1            err-fwd pts sgn
      *
      ** Input rate
      ** forward points
     C                   PARM      *ZEROS        W@INRT           13 8          rate (unscaled)
     C                   PARM                    F3FWPP            7 2          fwd pts

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VMARGIN - Validate Margin & Other Forward Points
      *****************************************************************
     C     VMARGIN       BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Margin & Other Forward Points
      *
     C                   CALLB     'FXVMARGIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
     C                   PARM                    DDACTN            1            Action Code
     C                   PARM                    DDDLTP            2            Deal Type
     C                   PARM                    DDBCCY            3            Buy CCy
     C                   PARM                    DDSCCY            3            Sell Ccy
      *
     C                   PARM                    DDMGIN            8            Margin Pts
     C                   PARM                    DDMBSI            1            Margin B/S
     C                   PARM                    DDDBSR           13            Dealt Base Rate
     C                   PARM                    DDBBFP            8            Buy Fwd Pts
     C                   PARM                    DDBBFS            1            Buy Fwd Pts sign
     C                   PARM                    DDSBFP            8            Sell Fwd Pts
     C                   PARM                    DDSBFS            1            Sell Fwd Pts sign
      *
      ** Related deal details
     C                   PARM                    RelDealDts                     SW/OP branch
      *
      ** Buy & Sell Ccy OK
     C                   PARM                    DDBccyOK          1            Buy CCy
     C                   PARM                    DDSccyOK          1            Sell Ccy
      *
      * ICD
     C                   PARM                    BNCYDL            3
     C                   PARM                    BNDCSP            1
      *
      * OUTPUTS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Margin - OK
      ** Margin Buy/sell ind - OK
      ** Deal Base Spot rate - OK
      ** Buy DL Base Fwd points - OK
      ** Buy DL Base Fwd points sign - OK
      ** Sell DL Base Fwd points - OK
      ** Sell DL Base Fwd points sign - OK
      *
     C                   PARM                    DDMginOK          1            Margin Pts
     C                   PARM                    DDMbsiOK          1            Margin B/S
     C                   PARM                    DDDbsrOK          1            Dealt Base Rate
     C                   PARM                    DDBbfpOK          1            Buy Fwd Pts
     C                   PARM                    DDBbfsOK          1            Buy Fwd Pts sign
     C                   PARM                    DDSbfpOK          1            Sell Fwd Pts
     C                   PARM                    DDSbfsOK          1            Sell Fwd Pts sign
      *
      ** Margin
      ** Margin Buy/sell ind
      ** Deal Base Spot rate
      ** Buy DL Base Fwd points
      ** Sell DL Base Fwd points
      *
     C                   PARM                    F3MGPT            7 2          Margin Pts
     C                   PARM                    F3MGBS            1            Margin B/S
     C                   PARM                    F3BDBS           13 8          Dealt Base Rate
     C                   PARM                    F3BDBF            7 2          Buy Fwd Pts
     C                   PARM                    F3SDBF            7 2          Sell Fwd Pts

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DETRAT@FP - Determine Rate + Forward Points                   *
      *****************************************************************
     C     DETRAT@FP     BEGSR
      *
      **  Unscale the input rate
      *
     C     @@SXP1        IFNE      0
     C     @@SXP1        ADD       1             @@SFAC            1 0
     C                   MOVE      'M'           @@DMD1
     C                   ELSE
     C     @@SXP2        ADD       1             @@SFAC
     C                   MOVE      'D'           @@DMD1
     C                   END
      *
     C     W@INRT        DIV(H)    @SF(@@SFAC)   F3OSRT
      *
      ** Add input rate and forward points together
      *
     C                   CALLB     'ZA0780'
      *
      * INPUTS
      *
     C                   PARM                    DDBCCY            3            buy ccy
     C                   PARM                    DDSCCY            3            sell ccy
      *
      * ICD
     C                   PARM                    BNCYDL            3            sell ccy
      *
     C                   PARM      F3OSRT        @@IRAT           13 8          exchange rate
     C                   PARM                    @@DMD1            1            1st ccy ml/dv ind
     C                   PARM      F3FWPP        @@FPNT            7 2          forward points
      *
     C                   PARM      'N'           @@SCAL            1            scale rate?
      *
     C                   PARM                    @@NDP1            1 0          norm quot decs
     C                   PARM                    @@SXP1                         scaling exponent
      *
     C                   PARM                    @@NDP2            1 0          norm quot decs
     C                   PARM                    @@SXP2                         scaling exponent
      *
      * OUTPUTS
      *
     C                   PARM      *ZEROS        @@GSRT           13 8          gross scaled rate
     C                   PARM      *ZEROS        @@GURT           13 8          gross unscld rate
      *
      ** Take scaled gross rate
      *
     C                   Z-ADD     @@GSRT        @@INRT
      *
     C**********         IF        CER043 = 'Y'                                   BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
      ***Get*scaled gross rate for reciprocal exchange rate                       BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
     C*****1****         DIV(H)    F3OSRT        @@EXRTR          13 8            BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
      ***Add*input rate and forward points together                               BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
     C**********         CALLB     'ZA0780'                                       BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
      **INPUTS**                                                                  BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
     C**********         PARM                    DDBCCY                           BUG23050A BUG23668
     C**********         PARM                    DDSCCY                           BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
      **ICD*****                                                                  BUG23050A BUG23668
     C**********         PARM                    BNCYDL                           BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
     C**********         PARM                    @@EXRTR                          BUG23050A BUG23668
     C**********         PARM                    @@DMD1                           BUG23050A BUG23668
     C**********         PARM      F3FWPP        @@FPNT                           BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
     C**********         PARM      'N'           @@SCAL                           BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
     C**********         PARM                    @@NDP1                           BUG23050A BUG23668
     C**********         PARM                    @@SXP1                           BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
     C**********         PARM                    @@NDP2                           BUG23050A BUG23668
     C**********         PARM                    @@SXP2                           BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
      **OUTPUTS*                                                                  BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
     C**********         PARM      *ZEROS        @@GSRTR          13 8            BUG23050A BUG23668
     C**********         PARM      *ZEROS        @@GURTR          13 8            BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
      ***Take*scaled gross rate  for reciprocal exchange rate                     BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
     C**********         Z-ADD     @@GSRTR       @@INRTR                          BUG23050A BUG23668
     C**********         ENDIF                                                    BUG23050A BUG23668
      **********                                                                  BUG23050A BUG23668
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VEXCHVAM - Validate Exchange Rate versus Amounts
      *****************************************************************
     C     VEXCHVAM      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Exchange Rate versus Amounts
      *
     C                   CALLB     'FXVEXCHVAM'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
     C                   PARM                    DDACTN            1            action code   CER043
     C                   PARM                    DDDLTP            2            deal type     CER043
     C                   PARM                    DDBAMT           14            buy amount    CER043
     C                   PARM                    DDSAMT           14            sell amount   CER043
     C                   PARM                    DDBCCY            3            buy ccy
     C                   PARM                    DDSCCY            3            sell ccy
      *                                                                                       CER043
      ** Related deal details                                                                 CER043
     C                   PARM                    RelDealDts                     SW/OP branch  CER043
      *
     C                   PARM                    W@INRT           13 8          scaled exch rate
     C                   PARM                    @@INRT           13 8          rate + fwd pts
     C**********         PARM                    @@INRTR          13 8            BUG23050A BUG23668
     C                   PARM      F3FWPP        @@FPNT            7 2          forward points
     C                   PARM      F3MGPT        @@MGPT            7 2          margin points
      *
     C                   PARM                    F3DAM1           15 0          amount
      *
     C                   PARM                    @SPOT1           13 8          spot rate
     C                   PARM                    @CDP1             1 0          no of dec places
     C                   PARM                    @RDCY1            1            round down
     C                   PARM                    @@NDP1            1 0          norm quot decs
     C                   PARM                    @@SXP1                         scaling exponent
     C                   PARM                    @@MDF1            1            mult/div ind
     C                   PARM                    @NEXRT1           5 2                     BUG23050A
      *
     C                   PARM                    F3DAM2           15 0          amount
      *
     C                   PARM                    @SPOT2           13 8          spot rate
     C                   PARM                    @CDP2             1 0          no of dec places
     C                   PARM                    @RDCY2            1            round down
     C                   PARM                    @@NDP2            1 0          norm quot decs
     C                   PARM                    @@SXP2                         scaling exponent
     C                   PARM                    @@MDF2            1            mult/div ind
     C                   PARM                    @NEXRT2           5 2                     BUG23050A
      *                                                                                       CER043
      ** Reciprocal rate indicator, exchange rate                                             CER043
      *                                                                                       CER043
     C                   PARM                    DDREIN                                       CER043
      *
      ** ICD
     C                   PARM                    BJCYCD
     C                   PARM                    BNCYDL
     C                   PARM                    BNEXRT
     C                   PARM                    BNDCSP
     C                   PARM                    S01391
     C                   PARM                    S01453
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Buy Amount - OK
      ** Sell Amount - OK
      ** Rate - OK
     C                   PARM                    DDBamtOK          1
     C                   PARM                    DDSamtOK          1
     C                   PARM                    DDRateOK          1
      *
      ** Multiply/Div Ind, Exchange Rate
      ** Descaled Exchange Rate, Rate+Mgn+Fwd Pts, Rate+Fwd Pts
      *
     C                   PARM                    F3DMD1            1            mult/div ind
     C                   PARM                    F3DXRT           13 8          exch rate
     C                   PARM      *ZEROS        @SRATE           13 8          Descaled exch rt
     C                   PARM      *ZEROS        @RRATE           13 8          Rate+mgn+fwd pts
     C                   PARM      *ZEROS        @XRATE           13 8          Rate+fwd pts
     C**********         PARM                    F3OSRT                           BUG23050A BUG23668
     C/COPY OFCPYSRCZ,CDL091_013                                                              CDL091
     C/COPY WNCPYSRC,FXFXDLVC03

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBSECYAE - Validate Base Currency Equivalent
      *****************************************************************
     C     VBSECYAE      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate Base Currency Equivalent
      *
     C                   CALLB     'FXVBSECYAE'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
     C                   PARM                    DDBCE            14            base ccy equiv
      *
     C                   PARM                    DDACTN            1            action code
     C                   PARM                    DDBCCY            3            buy ccy
     C                   PARM                    DDSCCY            3            sell ccy
     C                   PARM                    DDBAMT           14            buy amount
     C                   PARM                    DDSAMT           14            sell amount
      *
      ** OK indicators
     C                   PARM                    DDBccyOK          1            Buy ccy error
     C                   PARM                    DDSccyOK          1            Sell ccy error
     C                   PARM                    DDBAmtOK          1            Buy amt error
     C                   PARM                    DDSAmtOK          1            Sell amt error
      *
      ** Buy/sell amts
     C                   PARM                    F3DAM1           15 0          buy amount
     C                   PARM                    F3DAM2           15 0          sell amount
      *
      * Ccy 1 details
     C                   PARM                    @SPOT1           13 8          spot rate
     C                   PARM                    @CDP1             1 0          no of dec places
     C                   PARM                    @@MDF1            1            mult/div ind
      *
      * Ccy 2 details
     C                   PARM                    @SPOT2           13 8          spot rate
     C                   PARM                    @CDP2             1 0          no of dec places
     C                   PARM                    @@MDF2            1            mult/div ind
      *
      * ICD
     C                   PARM                    BJCYCD            3
     C                   PARM                    BNDCSP            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr                                    183759
     C                   PARM                    WMsgIDXAr                                    183759
     C                   PARM                    WMsgDtXAr                                    183759
      *
      ** Base ccy equivalent - OK
     C                   PARM                    DDBceOK           1            base ccy equiv
      *
      ** Deal Base ccy equivalent
     C                   PARM                    F3BCAE           15 0          base ccy equiv

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VFXNETS - Validate FX Netting fields
      *****************************************************************
     C     VFXNETS       BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
      ** Validate FX Netting fields
      *
     C                   CALLB     'FXVFXNETS'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Deal Screen fields
     C                   PARM                    DDACTN
     C                   PARM                    DDVDAT
     C                   PARM                    DDCUST
     C                   PARM                    DDBCCY
     C                   PARM                    DDNBUY
     C                   PARM                    DDSCCY
     C                   PARM                    DDNSEL
     C                   PARM                    DDMTCH
     C                   PARM                    DDNBRF
     C                   PARM                    DDNSRF
     C                   PARM                    DDDLTP                                      BUG6251
      *
      ** Value Date
     C                   PARM                    F3VDDN                         customer no
     C/COPY WNCPYSRC,FXH00131
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Net Buy Ind - OK
      ** Net Sell Ind - OK
      ** Match indicator - OK
     C                   PARM                    DDNbuyOK          1            base ccy equiv
     C                   PARM                    DDNselOK          1            base ccy equiv
     C                   PARM                    DDMtchOK          1            base ccy equiv
      *
      ** Buy/Sell Indicators and Matched Deal Indicator
      ** and Net Buy/Sell References
     C                   PARM                    F3NBUY                         customer no
     C                   PARM                    F3NSEL                         customer shtname
     C                   PARM                    F3MTCH                         book
     C                   PARM                    F3NBRF
     C                   PARM                    F3NSRF

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CDL008
      *****************************************************************         CDL008
      *                                                               *         CDL008
      *  VFXCLSS - Validate CLS settlement                            *         CDL008
      *                                                               *         CDL008
      *****************************************************************         CDL008
     C     VFXCLSS       BEGSR                                                  CDL008
      *                                                                         CDL008
      ** Reset variables updated by each module                                 CDL008
     C                   EXSR      RESETERRS                                    CDL008
                                                                                CDL008
     C                   CALLB     'FXVCLSSETL'                                 CDL008
      *                                                                         CDL008
      ** INPUTS                                                                 CDL008
      ** ======                                                                 CDL008
      *                                                                         CDL008
      ** Return Code                                                            CDL008
     C                   PARM                    RetCodeOut                     CDL008
     C                   PARM                    DDCLSS                         CDL008
     C                   PARM                    DDBRSN                         CDL008
     C                   PARM                    DDCUST                         CDL008
     C                   PARM                    DDBCCY                         CDL008
     C                   PARM                    DDSCCY                         CDL008
     C                   PARM                    F3VDDN                         CDL008
     C                   PARM                    DDNBUY                         CDL008
     C                   PARM                    DDNSEL                         CDL008
     C                   PARM                    F3DDDN                                       CDL035
      *                                                                         CDL008
      ** STANDING DATA                                                          CDL008
      ** =============                                                          CDL008
     C**********         PARM                    BJRDNB                                CDL008 CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJLCCY                         CDL008
     C                   PARM                    BJSLCD                         CDL008
      *                                                                         CDL008
      ** OUTPUTS                                                                CDL008
      ** =======                                                                CDL008
      *                                                                         CDL008
      ** Error fields/message IDs/message data (arrays) from/to caller          CDL008
     C                   PARM                    FldNamXAr                      CDL008
     C                   PARM                    MsgIDXAr                       CDL008
     C                   PARM                    MsgDtaXAr                      CDL008
      *                                                                         CDL008
      ** Warning fields/message IDs/message data (arrays) from/to caller        CDL008
     C                   PARM                    WFldNmXAr                      CDL008
     C                   PARM                    WMsgIDxAr                      CDL008
     C                   PARM                    WMsgDtXAr                      CDL008
                                                                                CDL008
     C                   PARM                    F3CLSS                         CDL008
                                                                                CDL008
     C                   PARM                    DDCLSSOK                       CDL008
      *                                                                         CDL008
      ** Update error info with that returned from the validation module        CDL008
     C                   EXSR      UPDATERRS                                    CDL008
                                                                                CDL008
     C                   ENDSR                                                  CDL008
                                                                                              CAS001
      *****************************************************************                       CAS001
      /EJECT                                                                                  CAS001
      *****************************************************************                       CAS001
      *                                                               *                       CAS001
      *  SRVOYLC - Validate Buy/Our Yield Curve                       *                       CAS001
      *                                                               *                       CAS001
      *  Called by: Main                                              *                       CAS001
      *                                                               *                       CAS001
      *  Calls: RESETERRS UPDATERRS                                   *                       CAS001
      *                                                               *                       CAS001
      *****************************************************************                       CAS001
                                                                                              CAS001
     C     SRVOYLC       BEGSR                                                                CAS001
                                                                                              CAS001
      ** Reset variables updated by each module                                               CAS001
                                                                                              CAS001
     C                   EXSR      RESETERRS                                                  CAS001
                                                                                              CAS001
      ** Validate Buy/Our Yield Curve                                                         CAS001
                                                                                              CAS001
     C                   CALLB     'ZAVYLDC01'                                                CAS001
                                                                                              CAS001
      ** INPUTS                                                                               CAS001
      ** ------                                                                               CAS001
                                                                                              CAS001
      ** Return Code                                                                          CAS001

     C                   PARM                    RetCodeOut                                   CAS001

      ** Deal Screen fields                                                                   CAS001

     C                   PARM                    DDDLTP                                       CAS001
     C                   PARM                    DDDLST                                       CAS001
     C                   PARM                    DDCLAS                                       CDL038
     C                   PARM                    DDOYLC                                       CAS001

      ** Field name                                                                           CAS001

     C                   PARM      'DDOYLC'      PYCFN                                        CAS001
                                                                                              CAS005
      ** Forward/Revaluation Flag                                                             CAS005
                                                                                              CAS005
     C                   PARM      *BLANKS       PFwRv                                        CAS005
                                                                                              CAS005
      ** Forward Yield Curve, to be checked if validating Reval Yield Curve                   CAS005
                                                                                              CAS005
     C                   PARM      *BLANKS       PFwYC                                        CAS005
                                                                                              CAS008
      ** Forward Commitment/Revaluation Flag                                                  CAS008
                                                                                              CAS008
     C                   PARM      *BLANKS       PFCRv                                        CAS008
                                                                                              CAS001
      ** OUTPUTS                                                                              CAS001
      ** -------                                                                              CAS001
                                                                                              CAS001
      ** Buy/Our Yield Curve - OK                                                             CAS001

     C                   PARM                    DDOylcOK                                     CAS001

      ** Error Type                                                                           CAS001

     C                   PARM      *BLANKS       PERTP                                        CAS001

      ** Buy/Our Yield Curve                                                                  CAS001

     C                   PARM                    F3OYLC                                       CAS001
                                                                                              CAS001
     C                   IF        RetCodeOut <> *Blanks                                      CAS001
     C                   Z-ADD     1             Idx                                          CAS001
     C                   EVAL      FldNamXAr(Idx) = 'DDOYLC'                                  CAS001
     C                   IF        PERTP = '1'                                                CAS001
     C                   EVAL      MsgIDXAr(Idx) = 'FXM5055'                                  CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      MsgIDXAr(Idx) = 'FXM5057'                                  CAS001
     C                   ENDIF                                                                CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
      ** Update error info with that returned from the validation module                      CAS001
                                                                                              CAS001
     C                   EXSR      UPDATERRS                                                  CAS001
                                                                                              CAS001
     C                   ENDSR                                                                CAS001
                                                                                              CAS001
      *****************************************************************                       CAS001
      /EJECT                                                                                  CAS001
      *****************************************************************                       CAS001
      *                                                               *                       CAS001
      *  SRVTYLC - Validate Sell/Their Yield Curve                    *                       CAS001
      *                                                               *                       CAS001
      *  Called by: Main                                              *                       CAS001
      *                                                               *                       CAS001
      *  Calls: RESETERRS UPDATERRS                                   *                       CAS001
      *                                                               *                       CAS001
      *****************************************************************                       CAS001
                                                                                              CAS001
     C     SRVTYLC       BEGSR                                                                CAS001
                                                                                              CAS001
      ** Reset variables updated by each module                                               CAS001
                                                                                              CAS001
     C                   EXSR      RESETERRS                                                  CAS001
                                                                                              246386
      ** Reset Sell/Their Yield Curve OK flag                                                 246386
     C                   EVAl      DDTylcOK = *Blanks                                         246386
                                                                                              CAS001
      ** Validate Their/Sell Yield Curve                                                      CAS001
                                                                                              CAS001
     C                   CALLB     'ZAVYLDC01'                                                CAS001
                                                                                              CAS001
      ** INPUTS                                                                               CAS001
      ** ------                                                                               CAS001
                                                                                              CAS001
      ** Return Code                                                                          CAS001
                                                                                              CAS001
     C                   PARM                    RetCodeOut                                   CAS001
                                                                                              CAS001
      ** Deal Screen fields                                                                   CAS001
                                                                                              CAS001
     C                   PARM                    DDDLTP                                       CAS001
     C                   PARM                    DDDLST                                       CAS001
     C                   PARM                    DDCLAS                                       CDL038
     C                   PARM                    DDTYLC                                       CAS001
                                                                                              CAS001
      ** Field name                                                                           CAS001
                                                                                              CAS001
     C                   PARM      'DDTYLC'      PYCFN                                        CAS001
                                                                                              CAS005
      ** Forward/Revaluation Flag                                                             CAS005
                                                                                              CAS005
     C                   PARM      *BLANKS       PFwRv                                        CAS005
                                                                                              CAS005
      ** Forward Yield Curve, to be checked if validating Reval Yield Curve                   CAS005
                                                                                              CAS005
     C                   PARM      *BLANKS       PFwYC                                        CAS005
                                                                                              CAS008
      ** Forward Commitment/Revaluation Flag                                                  CAS008
                                                                                              CAS008
     C                   PARM      *BLANKS       PFCRv                                        CAS008
                                                                                              CAS001
      ** OUTPUTS                                                                              CAS001
      ** -------                                                                              CAS001
                                                                                              CAS001
      ** Their/Sell Yield Curve - OK                                                          CAS001
                                                                                              CAS001
     C                   PARM                    DDTylcOK                                     CAS001
                                                                                              CAS001
      ** Error Type                                                                           CAS001
                                                                                              CAS001
     C                   PARM      *BLANKS       PERTP                                        CAS001
                                                                                              CAS001
      ** Their/Sell Yield Curve                                                               CAS001
                                                                                              CAS001
     C                   PARM                    F3TYLC                                       CAS001
                                                                                              CAS001
     C                   IF        RetCodeOut <> *Blanks                                      CAS001
     C                   Z-ADD     1             Idx                                          CAS001
     C                   EVAL      FldNamXAr(Idx) = 'DDTYLC'                                  CAS001
     C                   IF        PERTP = '1'                                                CAS001
     C                   EVAL      MsgIDXAr(Idx) = 'FXM5056'                                  CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      MsgIDXAr(Idx) = 'FXM5058'                                  CAS001
     C                   ENDIF                                                                CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
      ** Update error info with that returned from the validation module                      CAS001
                                                                                              CAS001
     C                   EXSR      UPDATERRS                                                  CAS001
                                                                                              CAS001
     C                   ENDSR                                                                CAS001
     C/COPY WNCPYSRC,FXH00061
      *                                                                         CDL008
      *****************************************************************         CDL008
      /EJECT                                                                                  CDL049
      *****************************************************************                       CDL049
      *                                                               *                       CDL049
      *  VRRAT     - Validate Reference Rate field                    *                       CDL049
      *                                                               *                       CDL049
      *  Called By: Main Processing                                   *                       CDL049
      *                                                               *                       CDL049
      *  Calls:                                                       *                       CDL049
      *  RESETERRS - Resets variables updated by each modules         *                       CDL049
      *  MMVFXRRAT - Reference Rate field Validation Module           *                       CDL049
      *  UPDATERRS - Update error information with that received back *                       CDL049
      *              from each validation module.                     *                       CDL049
      *                                                               *                       CDL049
      *****************************************************************                       CDL049
                                                                                              CDL049
     C     VRRAT         BEGSR                                                                CDL049
                                                                                              CDL049
      ** Reset variables updated by other modules                                             CDL049
                                                                                              CDL049
     C                   EXSR      RESETERRS                                                  CDL049
      *                                                                                       CDL049
      ** Validate Reference Rate field                                                        CDL049
      *                                                                                       CDL049
     C                   CALLB     'FXVDLRRAT'                                                CDL049
     C                   PARM                    RETCODEOUT                                   CDL049
     C                   PARM                    TRANIN                                       CDL049
     C                   PARM                    FLDNAMXAR                                    CDL049
     C                   PARM                    MSGIDXAR                                     CDL049
     C                   PARM                    MSGDTAXAR                                    CDL049
     C                   PARM                    WFLDNMXAR                                    CDL049
     C                   PARM                    WMSGIDXAR                                    CDL049
     C                   PARM                    WMSGDTXAR                                    CDL049
     C                   PARM                    F3DXRT                                       CDL049
     C                   PARM                    F3RRAT                                       CDL049
      *                                                                                       CDL049
     C                   EXSR      UPDATERRS                                                  CDL049
                                                                                              CDL049
     C                   ENDSR                                                                CDL049
      *****************************************************************                       CDL049
      /EJECT                                                                                  CDL038
      *****************************************************************                       CDL038
      * Default Sub Type and Class                                                            CDL038
      *****************************************************************                       CDL038
     C     DSUBTCLAS     BEGSR                                                                CDL038
      *                                                                                       CDL038
     C                   CALL      'DL002000'                                                 CDL038
      * Inputs                                                                                CDL038
     C                   PARM                    DDACTN                                       CDL038
     C                   PARM                    DDDLTP                                       CDL038
     C                   PARM                    DDCUST                                       CDL038
     C                   PARM                    DDVDAT                                       CDL038
     C                   PARM                    DDODAT                                       CDL038
     C                   PARM                    DDBOKC                                       CDL038
     C                   PARM                    DDPRFC                                       CDL038
     C                   PARM                    DDBCCY                                       CDL038
     C                   PARM                    DDSCCY                                       CDL038
     C                   PARM      *BLANK        @RelatedDeal      6                          CDL038
      * Inputs/Outputs                                                                        CDL038
     C                   PARM                    DDDLST                                       CDL038
     C                   PARM                    DDCLAS                                       CDL038
      *                                                                                       CDL038
     C                   ENDSR                                                                CDL038
      *****************************************************************                       CDL038
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR

      * Other F3xxxx fields are set up during the individual date
      *  validation, such as the ones where the input & database formats
      *  are different, e.g. dates, amounts.
      * This SR sets up the fields with the same (or compatible) attributes

     C                   MOVE      DDSDNO        F3DADN
     C                   MOVE      DDBRSN        F3MBCA
     C                   MOVE      DDDLTP        F3TYPE
     C                   MOVE      DDDLST        F3STYP
     C                   MOVE      DDFEDF        F3FEDF
     C                   MOVE      DDCLAS        F3CLAS                                       CDL038
     C                   MOVE      DDREIN        F3REIN                                       CER043
      *
      ** Calculate Base Currency Equivalent - Dealing
      ** if Treasury Management is present
      *
     C     BGTRMG        IFEQ      'Y'
     C                   EXSR      CALBED
     C                   END
      *
      ** Set up other fields
      ** only if S01453 is installed
      *
     C     S01453        IFEQ      'Y'
     C                   EXSR      SETUP_OTH
     C                   END
      *
      ** Set up The user field from ZMUSER which is the front office                          CDL010
      ** user if sent . Only if CDL010 is installed                                           CDL010
      *                                                                                       CDL010
     C     CDL010        IFEQ      'Y'                                                        CDL010
     C                   MOVE      ZUSER         F3USER                                       CDL010
     C                   END                                                                  CDL010
      *                                                                                       CDL010
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CALBED - Calculate Base Currency Equivalent - Dealing
      *****************************************************************
     C     CALBED        BEGSR
      *
      ** Pass value date to ZACALBED
      ** (Unless option deal and options on value date flag is 'N')
      *
     C     DDDLTP        IFEQ      'OP'                                         B**3
     C     EROVDI        ANDEQ     'N'                                          B**3           S0131
     C                   Z-ADD     F3OTDN        @DAYN
     C                   ELSE                                                   X**3
     C                   Z-ADD     F3VDDN        @DAYN
     C                   END                                                    E**3
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
      *
     C                   CALLB     'ZACALBED'
      *
      * INPUTS
      *
      * Buy  & Sell currencies
     C                   PARM                    DDBCCY                         buy ccy
     C                   PARM                    DDSCCY                         sell ccy
      *
      * Date effective, exchange rate, forward points
      *
     C                   PARM      @YMD          @@VDT             8 0          value date
     C                   PARM      @SRATE        @@DXR            13 8          exch rate
     C                   PARM      F3FWPP        @@DFP             7 2          forward pts
      *
      * Buy amount and Sell amount
      *
     C                   PARM      F3DAM1        @@DAM1           15 0          amount
     C                   PARM      F3DAM2        @@DAM2           15 0          amount
      *
      * buy: spot rate, ccy dec places, round down, norm quot decs
      *      scaling exponent, mult/div ind, mult/div ind-exch,
      *      low spot rate, high spot rate, FX spot date
      *
     C                   PARM                    @SPOT1           13 8          spot rate
     C                   PARM                    @CDP1             1 0          no of dec places
     C                   PARM                    @RDCY1            1            round down
     C                   PARM                    @@NDP1            1 0          norm quot decs
     C                   PARM                    @@SXP1                         scaling exponent
     C                   PARM                    @@MDF1            1            mult/div ind
     C                   PARM                    @@MDX1            1            mult/div ind,exch
     C                   PARM                    @@LSP1           13 8          low spot rate
     C                   PARM                    @@HSP1           13 8          high spot rate
     C                   PARM                    @@SPD1            8 0          FX spot date
      *
      * sell: spot rate, ccy dec places, round down, norm quot decs
      *       scaling exponent, mult/div ind, mult/div ind-exch,
      *       low spot rate, high spot rate, FX spot date
      *
     C                   PARM                    @SPOT2           13 8          spot rate
     C                   PARM                    @CDP2             1 0          no of dec places
     C                   PARM                    @RDCY2            1            round down
     C                   PARM                    @@NDP2            1 0          norm quot decs
     C                   PARM                    @@SXP2                         scaling exponent
     C                   PARM                    @@MDF2            1            mult/div ind
     C                   PARM                    @@MDX2            1            mult/div ind,exch
     C                   PARM                    @@LSP2           13 8          low spot rate
     C                   PARM                    @@HSP2           13 8          high spot rate
     C                   PARM                    @@SPD2            8 0          FX spot date
      *
      * ICD
     C                   PARM                    BNCYDL            3            mult/div ind
      *
      * OUTPUTS
      *
      * Base ccy dealing and dealt spot base
      *
     C                   PARM      *ZERO         @@DBCE           15 0          base ccy dealing
     C                   PARM      *ZERO         @@DSBC           15 0          dealt spot base
      *
      ** Update file fields
      *
     C                   Z-ADD     @@DBCE        F3BCDE                         **2
     C                   Z-ADD     @@DSBC        F3DSBE                         **2
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETUP_OTH - Set Up Other Fields
      *****************************************************************
     C     SETUP_OTH     BEGSR
      *
      * BUY AND SELL CURRENCY AMOUNTS
      * (make sell amount positive)
      *
     C                   Z-ADD     F3DAM1        @@BCYA           13 0
     C                   Z-SUB     F3DAM2        @@SCYA           13 0
      *
      ** Margin amount & currency
      *
     C     F3MGPT        IFNE      *ZEROS
     C     DDACTN        ANDEQ     'I'                                                        231410
     C                   EXSR      C_MGAM
     C                   END
      *
      ** Buy and Sell Forward points amounts
      *
     C                   EXSR      C_BSFPA
      *
      ** CALCULATE BUY DL BASE FORWARD RATE FROM FORWARD POINTS
      *
     C                   Z-ADD     *ZEROS        @@BRAT           13 8
     C     F3BDBF        IFNE      *ZEROS
     C                   EXSR      C_BDBR
     C                   END
      *
      ** CALCULATE SELL DL BASE FORWARD RATE FROM FORWARD POINTS
      *
     C                   Z-ADD     *ZEROS        @@SRAT           13 8
     C     F3SDBF        IFNE      *ZEROS
     C                   EXSR      C_SDBR
     C                   END
      *
      ** Other Currency DL Base Spot Rate
      *
     C     F3BDBS        IFNE      *ZEROS
     C*
     C                   Z-ADD     F3BDBS        F3SDBS
      *
      ** Other Spot rate should not include DL Base points in calcs.
      *
      ** Other Spot rate must allow for Multiply/divide rates &
      ** whether buy/sell is fixed. Margin excluded from calcs.
      *
     C     F3DMD1        IFEQ      'D'
     C     F3MGBS        ANDEQ     'B'
     C     F3DMD1        OREQ      'M'
     C     F3MGBS        ANDEQ     'S'
     C     1             MULT      F3OSRT        @@SDBS           13 8
     C                   ELSE
     C     1             DIV(H)    F3OSRT        @@SDBS
     C                   END
     C*
     C     F3MGBS        IFEQ      'B'
     C*
     C     @@MDF1        IFEQ      'M'
     C                   MULT      @@SDBS        F3SDBS
     C                   ELSE
     C                   DIV       @@SDBS        F3SDBS
     C                   END
     C*
     C                   ELSE
     C*
     C     @@MDF2        IFEQ      'M'
     C                   MULT      @@SDBS        F3SDBS
     C                   ELSE
     C                   DIV       @@SDBS        F3SDBS
     C                   END
     C*
     C                   END
      *
      ** Other Spot rate should not include DL Base points in calcs.
      *
     C                   Z-ADD     F3SDBS        @@SDBS
     C                   END
      *
      ** Other Currency DL Base Spot Rate Equivalent
      *
     C     F3BDBS        IFNE      *ZEROS
     C*
     C     F3MGBS        IFEQ      'S'
     C*
     C     @@MDF1        IFEQ      'M'
     C     @@BCYA        MULT      @@SDBS        @@SDBE           13 0
     C                   ELSE
     C     @@BCYA        DIV       @@SDBS        @@SDBE
     C                   END
     C*
     C                   ELSE
     C*
     C     @@MDF2        IFEQ      'M'
     C     @@SCYA        MULT      @@SDBS        @@SDBE
     C                   ELSE
     C     @@SCYA        DIV       @@SDBS        @@SDBE
     C                   END
     C*
     C                   END
     C*
     C                   Z-ADD     @@SDBE        F3SDBE
     C*
     C                   END
      *
      ** Buy DL Base Forward Amount
      ** Buy points amount is Buy ccy amount adjusted by DL pts rate
      *
     C     F3BDBF        IFNE      *ZEROS
     C     @@MDF1        IFEQ      'M'
     C     @@BCYA        MULT      @@BRAT        F3BDFA
     C                   ELSE
     C     @@BCYA        DIV       @@BRAT        F3BDFA
     C                   END
     C                   END
      *
      ** Sell DL Base Forward Amount
      ** Sell points amount is Sell ccy amount adjusted by DL pts rate
      *
     C     F3SDBF        IFNE      *ZEROS
     C     @@MDF2        IFEQ      'M'
     C     @@SCYA        MULT      @@SRAT        F3SDFA
     C                   ELSE
     C     @@SCYA        DIV       @@SRAT        F3SDFA
     C                   END
     C                   END

     C                   ENDSR
     C*******************************************************************
      /EJECT
     C*******************************************************************
     C* C_MGAM - CALCULATE MARGIN AMOUNT & CURRENCY
     C*******************************************************************
     C     C_MGAM        BEGSR
      *
      ** Convert Margin Points into Margin Rate
      ** (@RRATE = RATE+MGN+FWD PTS)
      ** (@XRATE = RATE+FWD PTS)
      *
     C     @RRATE        SUB       @XRATE        @@MRAT           13 8
     C     @@MRAT        IFLT      0
     C                   Z-SUB     @@MRAT        @@MRAT
     C                   END
      *
      ** Set up factoring to adjust for decimal places
      *
     C     F3MGBS        IFEQ      'B'
     C     @CDP2         SUB       @CDP1         @DIFDP            1 0
     C                   ELSE
     C     @CDP1         SUB       @CDP2         @DIFDP
     C                   END
     C*
     C                   Z-ADD     1             @FACT             7 3
     C     @DIFDP        DOWGT     0
     C                   MULT      10            @FACT
     C                   SUB       1             @DIFDP
     C                   END
     C*
     C     @DIFDP        DOWLT     0
     C                   DIV       10            @FACT
     C                   ADD       1             @DIFDP
     C                   END
     C*
     C     @CDP1         ADD       1             CD                2 0
     C     @@BCYA        DIV       @SF(CD)       BCYAMT           15 0
     C     @CDP2         ADD       1             CD
     C     @@SCYA        DIV       @SF(CD)       SCYAMT           15 0
      *
      * DETERMINE MARGIN SIGN
      * BASED ON INPUT RATE AND ADJUSTED BUY AND SELL AMOUNTS
      *
     C     @@INRT        IFGT      1
     C     BCYAMT        IFLT      SCYAMT
     C                   MOVE      '-'           @MGSGN            1
     C                   ELSE
     C                   MOVE      '+'           @MGSGN
     C                   END
     C                   ELSE
     C     BCYAMT        IFLT      SCYAMT
     C                   MOVE      '+'           @MGSGN
     C                   ELSE
     C                   MOVE      '-'           @MGSGN
     C                   END
     C                   END
      *
      * CALCULATE MARGIN AMOUNT AND CURRENCY IF MARGI IN BUY CURRENCY
      *
     C     F3MGBS        IFEQ      'B'
     C*
     C     @MGSGN        IFEQ      '-'
     C     @@BCYA        MULT      @@MRAT        F3MGAM
     C                   MULT      @FACT         F3MGAM
     C                   ELSE
     C     @@SCYA        MULT      @@MRAT        @MGAM            13 0
     C     @MGAM         DIV(H)    @XRATE        F3MGAM
     C                   END
     C*
     C                   MOVE      DDSCCY        F3MGCY
     C*
     C                   ELSE
      *
      * CALCULATE MARGIN AMOUNT AND CURRENCY IF MARGIN IN SELL CURRENCY
      *
     C     @MGSGN        IFEQ      '+'
     C     @@SCYA        MULT      @@MRAT        F3MGAM
     C                   MULT      @FACT         F3MGAM
     C                   ELSE
     C     @@BCYA        MULT      @@MRAT        @MGAM
     C     @MGAM         DIV(H)    @XRATE        F3MGAM
     C                   END
     C*
     C                   MOVE      DDBCCY        F3MGCY
     C*
     C                   END
     C*
     C                   ENDSR
     C*******************************************************************
      /EJECT
     C*******************************************************************
     C* C_BSFPA - CALCULATE BUY AND SELL FORWARD POINTS AMOUNTS
     C*******************************************************************
     C     C_BSFPA       BEGSR
      *
      * FORWARD POINTS = GROSS UNSCALED RATE - UNSCALED INPUT RATE
      *
     C     @@GURT        SUB       F3OSRT        @@FWDP           13 8
     C*
     C** Buy forward points amount
     C*
     C     @@MDF1        IFEQ      'M'
     C     @@BCYA        MULT      @@FWDP        F3BFPA
     C                   ELSE
     C     @@FWDP        IFNE      0
     C     @@BCYA        DIV       @@FWDP        F3BFPA
     C                   ELSE
     C                   Z-ADD     0             F3BFPA
     C                   END
     C                   END
     C*
     C** Sell forward points amount
     C*
     C     @@MDF2        IFEQ      'M'
     C     @@SCYA        MULT      @@FWDP        F3SFPA
     C                   ELSE
     C     @@FWDP        IFNE      0
     C     @@SCYA        DIV       @@FWDP        F3SFPA
     C                   ELSE
     C                   Z-ADD     0             F3SFPA
     C                   END
     C                   END
     C*
     C                   ENDSR
     C*******************************************************************
      /EJECT
     C*******************************************************************
     C* C_BDBR -  CALCULATE BUY DL BASE FORWARD RATE FROM FORWARD POINTS
     C*******************************************************************
     C     C_BDBR        BEGSR
      *
      ** Calculate new rate
      *
     C                   CALLB     'ZA0780'
      *
      * INPUTS
      *
     C                   PARM                    DDBCCY            3            buy ccy
     C                   PARM                    @@BCCY            3            sell ccy
      *
      * ICD
     C                   PARM                    BNCYDL            3            sell ccy
      *
     C                   PARM      1             @@IRAT           13 8          exchange rate
     C                   PARM                    @@DMD1            1            1st ccy ml/dv ind
     C                   PARM      F3BDBF        @@FPNT            7 2          forward points
      *
     C                   PARM      'N'           @@SCAL            1            scale rate?
      *
     C                   PARM                    @@NDP1            1 0          norm quot decs
     C                   PARM                    @@SXP1                         scaling exponent
      *
     C                   PARM                    @@BCDP            1 0          norm quot decs
     C                   PARM                    @@BCSP                         scaling exponent
      *
      * OUTPUTS
      *
     C                   PARM      *ZEROS        @@GSRT           13 8          gross scaled rate
     C                   PARM      *ZEROS        @@GURT           13 8          gross unscld rate
      *
      ** Store Buy DL Base Forward Rate
      *
     C     @@GURT        SUB       @@IRAT        @@BRAT
     C*
     C                   ENDSR
     C*******************************************************************
      /EJECT
     C*******************************************************************
     C* C_SDBR -  CALCULATE SELL DL BASE FORWARD RATE FROM FORWARD POINTS
     C*******************************************************************
     C     C_SDBR        BEGSR
      *
      ** Calculate new rate
      *
     C                   CALLB     'ZA0780'
      *
      * INPUTS
      *
     C                   PARM                    @@BCCY            3            buy ccy
     C                   PARM                    DDSCCY            3            sell ccy
      *
      * ICD
     C                   PARM                    BNCYDL            3            sell ccy
      *
     C                   PARM      1             @@IRAT           13 8          exchange rate
     C                   PARM                    @@DMD1            1            1st ccy ml/dv ind
     C                   PARM      F3SDBF        @@FPNT            7 2          forward points
      *
     C                   PARM      'N'           @@SCAL            1            scale rate?
      *
     C                   PARM                    @@BCDP            1 0          norm quot decs
     C                   PARM                    @@BCSP                         scaling exponent
      *
     C                   PARM                    @@NDP2            1 0          norm quot decs
     C                   PARM                    @@SXP2                         scaling exponent
      *
      * OUTPUTS
      *
     C                   PARM      *ZEROS        @@GSRT           13 8          gross scaled rate
     C                   PARM      *ZEROS        @@GURT           13 8          gross unscld rate
      *
      ** Store Buy DL Base Forward Rate
      *
     C     @@GURT        SUB       @@IRAT        @@SRAT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *                                                                                       CER043
      *****************************************************************                       CER043
      *                                                               *                       CER043
      ** SRVREIN - Validate Reciprocal Rate Indicator                 *                       CER043
      *                                                               *                       CER043
      *  Called by: Main Processing                                   *                       CER043
      *                                                               *                       CER043
      *  Calls: Reseterrs, Updaterrs                                  *                       CER043
      *                                                               *                       CER043
      *****************************************************************                       CER043
      *                                                                                       CER043
     C     SRVREIN       BEGSR                                                                CER043
      *                                                                                       CER043
      ** Reset variables updated by each module                                               CER043
      *                                                                                       CER043
     C                   EXSR      RESETERRS                                                  CER043
                                                                                              CER043
     C                   CALLB     'FXVREIN'                                                  CER043
     C                   PARM                    RetCodeOut                                   CER043
     C                   PARM                    DDREIN                                       CER043
     C                   PARM                    FldNamXAr                                    CER043
     C                   PARM                    MsgIDXAr                                     CER043
     C                   PARM                    MsgDtaXAr                                    CER043
     C                   PARM                    WFldNmXAr                                    CER043
     C                   PARM                    WMsgIDXAr                                    CER043
     C                   PARM                    WMsgDtXAr                                    CER043
     C                   PARM                    DDReinOK                                     CER043
      *                                                                                       CER043
      ** Update error info with that returned from validation module                          CER043
      *                                                                                       CER043
     C                   EXSR      UPDATERRS                                                  CER043
                                                                                              CER043
     C                   ENDSR                                                                CER043
      *****************************************************************                       CER043
     C/COPY WNCPYSRC,FXH00065
      /EJECT                                                                                  CER043
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    InfData                        CAP051
      * Receive Settlement Ccy, Method & Nostro and  Pay Settlement Ccy,
      * Method & Nostro, from default or valid deal
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    FrontOffice                    CPB002
     C                   PARM                    ExtData                        CAP004
      *
     C/COPY WNCPYSRC,FXFXDLVC01
      * NET BUY/SELL REFERENCE
     C                   PARM                    DDNBRF           19
     C                   PARM                    DDNSRF           19
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
      * Valid Deals layout (DS) from/to caller
     C                   PARM                    ValidDeal
     C                   PARM                    DDDTYP            1                          242477
     C                   PARM                    InCDL099                                     CDL099
     C/COPY WNCPYSRC,FXFXDLVC02
                                                                                              CDL029
     C     KBRANCHAUTH   KLIST                                                                CDL029
     C******             KFLD                    BBBRCD                                CDL029CDL029A
     C                   KFLD                    W0BRCD            3                         CDL029A
     C                   KFLD                    W0CUST            6                         CDL029A
     C                   KFLD                    DDBRSN                                       CDL029
      ************                                                                           BUG5517
      ****GET*ZMUSER to access default branch.                                               BUG5517
      ************                                                                           BUG5517
     C******DTAARA       DEFINE                  ZMUSER                                      BUG5517
     C************       IN        ZMUSER                                                    BUG5517
     C************       UNLOCK    ZMUSER                                                    BUG5517
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'FXFXDLVAL'   DBPGM
     C                   OUT       LDA
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Access Dealing details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      ** Access Trading data via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access Treasury Management details via access program
      *  (database error handling done in access program)
      *
     C     BGTRMG        IFEQ      'Y'
     C                   CALLB     'AOTRMAR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRMA        PARM      SDTRMA        DSFDY
     C                   ENDIF
      *
      ** Access Portfolio Management details via access program
      *  (database error handling done in access program)
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
      *
      ** Access Retail details via access program
      *  (database error handling done in access program)
     C     BGRTBN        IFEQ      'Y'
     C     BGIOAC        OREQ      'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
     C                   ENDIF
      **
      ** Access Currencies file via access program
      ** for Base Currency for Dealing details
      **
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BNCYDL        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   MOVE      A6CYCD        @@BCCY            3
     C                   Z-ADD     A6NBDP        @@BCDP            1 0
     C                   Z-ADD     A6SCEX        @@BCSP
      *
      * Get FX complete deal amendable fields details
      *
     C     1             SETLL     FXCDAFLL
     C     *IN99         DOUEQ     '1'
     C     FDDLTF        OREQ      *BLANKS
     C                   READ      FXCDAFLL                               99
     C                   END
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'FXCDAFLL'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     *BLANK        DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
      *
      ** Access SAR details file to determine if S01391
      ** (Japanese Sub Module) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01391'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     'S01391'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01391            1
     C                   ELSE
     C                   MOVEL     'N'           S01391
     C                   END
      *
      ** Access SAR details file to determine if S01453
      ** (Margin and FX Points in Base Currency) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01453'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     'S01453'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01453            1
     C                   ELSE
     C                   MOVEL     'N'           S01453
     C                   END
      *
      ** Access SAR details file to determine if CDL005 is on.
      ** (Customer format in input functions is shortname)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     'CDL005'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'S'           CustFormat
     C                   ELSE
     C                   MOVEL     'N'           CustFormat
     C                   END
      *                                                                         CDL011
      ** Access SAR details to determine if CDL011 is on.                       CDL011
      ** (Expansion of Customer Number on Dealing Transactions)                 CDL011
      *                                                                         CDL011
     C                   CALLB     'AOSARDR0'                                   CDL011
     C                   PARM      *BLANKS       @RTCD                          CDL011
     C                   PARM      '*VERIFY'     @OPTN                          CDL011
     C                   PARM      'CDL011'      @SARD                          CDL011
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL011
     C     @RTCD         IFNE      *BLANKS                                      CDL011
     C     @RTCD         ANDNE     '*NRF   '                                    CDL011
     C     *LOCK         IN        LDA                                          CDL011
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL011
     C                   MOVEL     '009'         DBASE                          CDL011
     C                   MOVEL     'CDL011'      DBKEY                          CDL011
     C                   OUT       LDA                                          CDL011
     C                   SETON                                        U7U8LR    CDL011
     C                   EXSR      #TERM                                        CDL011
     C                   END                                                    CDL011
     C     @RTCD         IFEQ      *BLANK                                       CDL011
     C                   MOVEL     'S'           CustFormat                     CDL011
     C                   END                                                    CDL011
      *
      ** Access SAR details file to determine if CDL002 is on.
      ** (FX Netting)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '005'         DBASE
     C                   MOVEL     'CDL002'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDL002            1
     C                   ELSE
     C                   MOVEL     'N'           CDL002
     C                   END
      *                                                                         CDL008
      ** Access SAR details file to determine if CDL008 is on.                  CDL008
      ** (Continuous Linked Settlement)                                         CDL008
      *                                                                         CDL008
     C                   CALLB     'AOSARDR0'                                   CDL008
     C                   PARM      *BLANKS       @RTCD                          CDL008
     C                   PARM      '*VERIFY'     @OPTN                          CDL008
     C                   PARM      'CDL008'      @SARD                          CDL008
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL008
     C     @RTCD         IFNE      *BLANKS                                      CDL008
     C     @RTCD         ANDNE     '*NRF   '                                    CDL008
     C     *LOCK         IN        LDA                                          CDL008
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL008
     C                   MOVEL     '006'         DBASE                          CDL008
     C                   MOVEL     'CDL008'      DBKEY                          CDL008
     C                   OUT       LDA                                          CDL008
     C                   SETON                                        U7U8LR    CDL008
     C                   EXSR      #TERM                                        CDL008
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
     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
     C                             PRTCD <> '*NRF   '                                         CAS001
     C     *LOCK         IN        LDA                                                        CAS001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
     C                   EVAL      DBASE = 007                                                CAS001
     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
     C                   OUT       LDA                                                        CAS001
     C                   EVAL      *INU7 = *ON                                                CAS001
     C                   EVAL      *INU8 = *ON                                                CAS001
     C                   EVAL      *INLR = *ON                                                CAS001
     C                   EXSR      #TERM                                                      CAS001
     C                   ENDIF                                                                CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   ENDIF                                                                CAS001
     C/COPY WNCPYSRC,FXH00241
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
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
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        LIBR = S1SUPP                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        (PRtCd <> '*NRF') and                                      CSC011
     C                             (PRtCd <> *Blanks)                                         CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 7                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
     C/COPY WNCPYSRC,FXH00062
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
     C                   EVAL      DBASE = 008                                                CDL010
     C                   EVAL      DBKEY = 'CDL010'                                           CDL010
     C                   OUT       LDA                                                        CDL010
     C                   EVAL      *INU7 = *ON                                                CDL010
     C                   EVAL      *INU8 = *ON                                                CDL010
     C                   EVAL      *INLR = *ON                                                CDL010
     C                   EXSR      #TERM                                                      CDL010
     C                   ENDIF                                                                CDL010
     C                   IF        PRTCD = *BLANKS                                            CDL010
     C                   EVAL      CDL010 = 'Y'                                               CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      CDL010 = 'N'                                               CDL010
     C                   ENDIF                                                                CDL010
     C*                                                                                       CDL029
     C                   CALLB     'AOSARDR0'                                                 CDL029
     C                   PARM      *BLANKS       PRTCD                                        CDL029
     C                   PARM      '*VERIFY'     POPTN                                        CDL029
     C                   PARM      'CDL029'      PSARD                                        CDL029
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL029
     C                   IF        PRTCD <> *BLANKS AND                                       CDL029
     C                             PRTCD <> '*NRF   '                                         CDL029
     C     *LOCK         IN        LDA                                                        CDL029
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL029
     C                   EVAL      DBASE = 028                                                CDL029
     C                   EVAL      DBKEY = 'CDL029'                                           CDL029
     C                   OUT       LDA                                                        CDL029
     C                   EVAL      *INU7 = *ON                                                CDL029
     C                   EVAL      *INU8 = *ON                                                CDL029
     C                   EVAL      *INLR = *ON                                                CDL029
     C                   EXSR      #TERM                                                      CDL029
     C                   ENDIF                                                                CDL029
     C                   IF        PRTCD = *BLANKS                                            CDL029
     C                   EVAL      CDL029 = 'Y'                                               CDL029
     C                   ELSE                                                                 CDL029
     C                   EVAL      CDL029 = 'N'                                               CDL029
     C                   ENDIF                                                                CDL029
                                                                                              CDL029
      ** Access SAR details file to determine if CDL038 is switched on                       BUG9717
                                                                                             BUG9717
     C                   CALLB     'AOSARDR0'                                                BUG9717
     C                   PARM      *BLANKS       PRTCD                                       BUG9717
     C                   PARM      '*VERIFY'     POPTN                                       BUG9717
     C                   PARM      'CDL038'      PSARD                                       BUG9717
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9717
                                                                                             BUG9717
     C                   IF        PRTCD <> *BLANKS AND                                      BUG9717
     C                             PRTCD <> '*NRF   '                                        BUG9717
     C     *LOCK         IN        LDA                                                       BUG9717
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG9717
     C                   EVAL      DBASE = 908                                               BUG9717
     C                   EVAL      DBKEY = 'CDL038'                                          BUG9717
     C                   OUT       LDA                                                       BUG9717
     C                   EXSR      *PSSR                                                     BUG9717
     C                   ENDIF                                                               BUG9717
                                                                                             BUG9717
     C                   IF        PRTCD = *BLANKS                                           BUG9717
     C                   EVAL      CDL038 = 'Y'                                              BUG9717
     C                   ELSE                                                                BUG9717
     C                   EVAL      CDL038 = 'N'                                              BUG9717
     C                   ENDIF                                                               BUG9717
                                                                                             BUG9717
     C                   CALLB     'AOSARDR0'                                                 CGL058
     C                   PARM      *BLANKS       @RTCD                                        CGL058
     C                   PARM      '*VERIFY'     @OPTN                                        CGL058
     C                   PARM      'CGL058'      @SARD                                        CGL058
     C                   IF        @RTCD = *BLANKS                                            CGL058
     C                   MOVE      'Y'           CGL058                                       CGL058
     C                   ENDIF                                                                CGL058
      ** Access SAR details file to determine if CDL049 is switched on                       CDL049
                                                                                             CDL049
     C                   CALLB     'AOSARDR0'                                                CDL049
     C                   PARM      *BLANKS       PRTCD                                       CDL049
     C                   PARM      '*VERIFY'     POPTN                                       CDL049
     C                   PARM      'CDL049'      PSARD                                       CDL049
     C     SCSARD        PARM      SCSARD        DSFDY                                       CDL049
      *                                                                                      CDL049
     C                   IF        PRTCD = *BLANKS                                           CDL049
     C                   EVAL      CDL049 = 'Y'                                              CDL049
     C                   ELSE                                                                CDL049
     C                   EVAL      CDL049 = 'N'                                              CDL049
     C                   ENDIF                                                               CDL049
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
     C                   EVAL      DBASE = 909                                                CER043
     C                   EVAL      DBKEY = 'CER043'                                           CER043
     C                   OUT       LDA                                                        CER043
     C                   EXSR      *PSSR                                                      CER043
     C                   ENDIF                                                                CER043
                                                                                              CER043
     C                   IF        PRTCD = *BLANKS                                            CER043
     C                   EVAL      CER043 = 'Y'                                               CER043
     C                   ENDIF                                                                CER043
      *                                                                                       CER043
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
     C                   EVAL      DBASE = 910                                                CDL099
     C                   EVAL      DBKEY = 'CDL099'                                           CDL099
     C                   OUT       LDA                                                        CDL099
     C                   EXSR      *PSSR                                                      CDL099
     C                   ENDIF                                                                CDL099
                                                                                              CDL099
     C                   IF        PRTCD = *BLANKS                                            CDL099
     C                   EVAL      CDL099 = 'Y'                                               CDL099
     C                   ENDIF                                                                CDL099
     C/COPY OFCPYSRCZ,CDL091_014                                                              CDL091
      *
     C/COPY WNCPYSRC,FXH00019
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'

      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FXFXDLV033

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
(c) Finastra International Limited 2001
** Scaling factors array - @SF
0000000001
0000000010
0000000100
0000001000
0000010000
0000100000
0001000000
0010000000
0100000000
1000000000
     X/COPY WNCPYSRC,FXFXDLVX01
