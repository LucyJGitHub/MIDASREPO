     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deal post settlement validation')             *
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange Dealing Module                      *
      *                                                               *
      *  FXFXDLVLP - FX Deal Post Settlement Validation               *
      *                                                               *
      *  Function: This Program Processes Post Settlement Detail      *
      *            FXDL date validation                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CSW212             Date 03May12               *
      *                 207288             Date 10Jun03               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23473           Date 20Mar09               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248269             Date 25Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BG12166            Date 04Oct06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5517            Date 19Jan05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3992  Re-open   Date 11Nov04               *
      *                 BUG4787            Date 09Nov04               *
      *                 BUG3992  *CREATE   Date 01Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *            (Recompile)                                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  207288 - Check spot indicator for deal type/subtype          *
      *           combination and issue warning message when needed.  *
      *           Applied for AR999664 (Child: AR999668)              *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23473 - Duplicate error shown in FXDL when Option to Date *
      *             for Option Deal is missing.                       *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248269 - Use original spot rate in validating the exchange   *
      *           rate of an Option takedown deal.                    *
      *  BG12166- Parameter mismatch                                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5517- Authorisation Error on FXDL.  Retrieve contents of  *
      *           DTAARA/ZMUSER moved out of INZSR                    *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3992- Re-open - Suppress duplicate error messages.        *
      *           Some may already have been sent bu MMLDNIVAL.       *
      *  BUG4787 -No call to FXVSODLNO meaning impossible to insert a *
      *           swap deal as related deal details are blank.        *
      *  BUG3992- New program based on FXFXDLVAL to perform post      *
      *           settlement detail validation. Revalidate dates.     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FFXCDAFLL  IF   E             DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,FXFXDVP001
 
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
     D SDDEALACCD    E                     EXTFLD(QQACCD)
      ** EXTERNAL DS FOR DEALING DETAILS
 
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D SDTRADACCD    E                     EXTFLD(QQACCD)
      ** EXTERNAL DS FOR Trading Data
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDTRMA        E DS                  EXTNAME(SDTRMAPD)
      ** EXTERNAL DS FOR Treasury Management DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** EXTERNAL DS FOR Portfolio Management DETAILS
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  SDRETLACCD   E                     EXTFLD(QQACCD)
      ** EXTERNAL DS FOR RETAIL DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      * THIRD DS FOR ACCESS PROGRAMS, VERY LONG DATA STRUCTURE
 
     D ValidDeal     E DS                  EXTNAME(FXVFXDLPD)
      * Valid Deals layout
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status data area
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D ZMUSER          DS            17
     D  ZUSER                  1     10
     D  BRC                   11     13
     D  DEPT                  14     16
 
     D TranIn        E DS                  EXTNAME(FXFXDLPD)
      * Incoming Transaction
 
     D InfData       E DS                  EXTNAME(FXFXIFPD)
     D                                     PREFIX(IF_)
      * FX (FXDL) Extra Data - File (D/B) format
 
     D ExtData       E DS                  EXTNAME(FXFXEXPD)
      * FX Extra Data - File (D/B) format
 
      **  Front Office (2 First characters determine System Front Office)
     D FrontOffice     DS            20
     D  W_System               1      2
 
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
     D  DDCLSSOK                      1A
     D  DDOylcOK                      1A
     D  DDTylcOK                      1A
     D  DDClasOK                      1A                                                      CDL038
 
 
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
 
      ** Define fields used in CAS001
     D CAS001          S              1A
     D PYCFN           S              6A
     D PERTP           S              1A
     D PFwRv           S              1A
     D PFwYC           S              5A
 
      ** Fields defined for Enhancement CSC011
     D CSC011          S              1A
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D WRunDay         S                   LIKE(BJRDNB)
 
      ** Fields defined for Enhancement CDL010
     D CDL010          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FXFXDVP002
 
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *                                                                                      BUG5517
      **  Get default branch and user from ZMUSER                                            BUG5517
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG5517
     C                   IN        ZMUSER                                                    BUG5517
     C                   UNLOCK    ZMUSER                                                    BUG5517
 
      * Call Validation Modules in Sequence
      *                                                                                      BUG4787
      ** Validate Swap/Option Deal Number                                                    BUG4787
      *                                                                                      BUG4787
     C                   EXSR      VSODLNO                                                   BUG4787
 
      ** Validate Deal Date, Value Date, Option To Date
      *
      /COPY WNCPYSRC,FXFXDVP003
 
     C                   EXSR      VDATES
      *
      /COPY WNCPYSRC,FXFXDVP004
 
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
      /COPY WNCPYSRC,FXFXDVP005
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
      *
      /COPY WNCPYSRC,FXFXDVP006
 
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FXFXDVP007
      *****************************************************************                      BUG4787
      ** VSODLNO - Validate Swap/Option Deal Number                                          BUG4787
      *****************************************************************                      BUG4787
     C     VSODLNO       BEGSR                                                               BUG4787
                                                                                             BUG4787
      * Reset variables updated by each module                                               BUG4787
                                                                                             BUG4787
     C                   EXSR      RESETERRS                                                 BUG4787
      *                                                                                      BUG4787
      ** Validate Swap/Option Deal Number                                                    BUG4787
      *                                                                                      BUG4787
     C                   CALLB     'FXVSODLNO'                                               BUG4787
      *                                                                                      BUG4787
      * INPUTS                                                                               BUG4787
      *                                                                                      BUG4787
      ** Return Code                                                                         BUG4787
     C                   PARM                    RetCodeOut                                  BUG4787
      *                                                                                      BUG4787
      ** Deal Screen fields                                                                  BUG4787
     C                   PARM                    DDACTN            1            action code  BUG4787
     C                   PARM                    DDDLNO            6            action code  BUG4787
     C                   PARM                    DDDLTP            2            action code  BUG4787
     C                   PARM                    DDBRKR            4            action code  BUG4787
     C                   PARM                    DDSDNO            6            SW/OP deal noBUG4787
      *                                                                                      BUG4787
      * ICD                                                                                  BUG4787
     C                   PARM                    WRunDay                                     BUG4787
      *                                                                                      BUG4787
      * OUTPUTS                                                                              BUG4787
      * Error fields/message IDs/message data (arrays) from/to caller                        BUG4787
     C                   PARM                    FldNamXAr                                   BUG4787
     C                   PARM                    MsgIDXAr                                    BUG4787
     C                   PARM                    MsgDtaXAr                                   BUG4787
      *                                                                                      BUG4787
      ** Swap/option deal no - OK                                                            BUG4787
     C                   PARM                    DDSdnoOK          1              SW/OP deal BUG4787
      *                                                                                      BUG4787
      ** Related deal details                                                                BUG4787
     C                   PARM                    RelDealDts                       SW/OP deal BUG4787
     C                   PARM                    F3DTYP                                      BG12166
                                                                                             BUG4787
      * Update error info with that returned from the validation module                      BUG4787
                                                                                             BUG4787
     C                   EXSR      UPDATERRS                                                 BUG4787
      *                                                                                      BUG4787
     C                   ENDSR                                                               BUG4787
      *****************************************************************
      ** VDATES - Validate Deal Date, Value Date, Option To Date
      *****************************************************************
     C     VDATES        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Deal Date, Value Date, Option To Date
      *
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
     C                   PARM                    WRunDay
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
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
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
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
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
      *
      ** Set up The user field from ZMUSER which is the front office
      ** user if sent . Only if CDL010 is installed
      *
     C     CDL010        IFEQ      'Y'
     C                   MOVE      ZUSER         F3USER
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/COPY WNCPYSRC,FXH00066
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    InfData
      * Receive Settlement Ccy, Method & Nostro and  Pay Settlement Ccy,
      * Method & Nostro, from default or valid deal
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    FrontOffice
     C                   PARM                    ExtData
      *
     C/COPY WNCPYSRC,FXFXDVP008
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
     C/COPY WNCPYSRC,FXFXDVP009
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
     C                   CALLB     'AOGELRR1'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ** Access Dealing details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AODEALR1'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDDEAL        PARM      SDDEAL        DSSDY
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
     C                   MOVEL     'S'           CustFormat        1
     C                   ELSE
     C                   MOVEL     'N'           CustFormat
     C                   END
      *
      ** Access SAR details to determine if CDL011 is on.
      ** (Expansion of Customer Number on Dealing Transactions)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '009'         DBASE
     C                   MOVEL     'CDL011'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'S'           CustFormat
     C                   END
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
      *
      ** Access SAR details file to determine if CDL008 is on.
      ** (Continuous Linked Settlement)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '006'         DBASE
     C                   MOVEL     'CDL008'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   ENDIF
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CDL008            1
     C                   ELSE
     C                   MOVEL     'N'           CDL008
     C                   ENDIF
 
      ** Access SAR details file to determine if CAS001 is on.
      ** (Net Present Value Accounting)
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAS001'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 007
     C                   EVAL      DBKEY = 'CAS001'
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      #TERM
     C                   ENDIF
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CAS001 = 'Y'
     C                   ELSE
     C                   EVAL      CAS001 = 'N'
     C                   ENDIF
     C/COPY WNCPYSRC,FXH00242
 
      ** Check if CSC011 is installed
 
     C                   EVAL      WRunDay = BJRDNB
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtCd = *Blanks
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   IF        LIBR = S1SUPP
     C                   EVAL      WRunDay = S1DATE
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   IF        (PRtCd <> '*NRF') and
     C                             (PRtCd <> *Blanks)
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 7
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Access SAR details file to determine if CDL010 is on.
      ** (Dealing Transaction Authorisation)
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CDL010'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 008
     C                   EVAL      DBKEY = 'CDL010'
     C                   OUT       LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      #TERM
     C                   ENDIF
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CDL010 = 'Y'
     C                   ELSE
     C                   EVAL      CDL010 = 'N'
     C                   ENDIF
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FXFXDVP010
 
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
      ** Check array to avoid duplication of Msg IDs.                                       BUG23473
     C                   Z-ADD     1             K                 3 0                      BUG23473
     C     MsgIDXAr(K)   LOOKUP    MsgIDArr                               99                BUG23473
     C     *IN99         IFEQ      '0'                                                      BUG23473
     C                   EVAL      FldNameArr(I) = FldNamXAr(K)                             BUG23473
     C                   EVAL      MsgIdArr(I)  = MsgIDXAr(K)                               BUG23473
     C**********         MOVEA     FldNamXAr     FlDNameArr(I)                              BUG23473
     C**********         MOVEA     MsgIDXAr      MsgIdArr(I)                                BUG23473
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF                                                              BUG23473
     C                   ADD       1             I                                          BUG23473
     C                   ADD       1             K                                          BUG23473
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
      *                                                                                      BUG3992
      * Only move in warning errors which are not already in the array.                      BUG3992
      *                                                                                      BUG3992
     C                   Z-ADD     1             J                 3 0                       BUG3992
     C     WMsgIDXAr(J)  DOUEQ     *BLANK                                                    BUG3992
     C     WMsgIDXAr(J)  LOOKUP    WMsgIDArr                              99                 BUG3992
     C     *IN99         IFEQ      '0'                                                       BUG3992
     C                   EVAL      WFldNamArr(I) = WFldNmXAr(J)                              BUG3992
     C                   EVAL      WMsgIDArr(I) = WMsgIDXAr(J)                               BUG3992
     C                   ENDIF                                                               BUG3992
     C                   ADD       1             I                                           BUG3992
     C                   ADD       1             J                                           BUG3992
     C                   ENDDO                                                               BUG3992
     C**********         MOVEA     WFldNmXAr     WFldNamArr(I)                               BUG3992
     C**********         MOVEA     WMsgIDXAr     WMsgIDArr(I)                                BUG3992
     C**********         MOVEA     WMsgDtXAr     WMsgDtaArr(I)                               BUG3992
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
(c) Misys International Banking Systems Ltd. 2004
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
     X/COPY WNCPYSRC,FXFXDVP011
