     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments validat54n control 3')      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTOPAY3VL  - FT Outgoing Payments Validation Module (scrn 3) *
      *                                                               *
      *  Function: This Program Validates FT Outgoing Payments for    *
      *            input to the Midas database.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CSD089             Date 07Oct10               *
      *                 BUG26775           Date 23Nov09               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260477             Date 21May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 250600             Date 07Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 BUG7029            Date 09Jun05               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 16Oct03               *
      *                 CAP084             Date 18Jul03               *
      *                 219131             Date 26May03               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 15Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 03Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CPB001             Date 23Aug99               *
      *                 CAP031  *CREATE    Date 22Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  BUG26775 - Validation error in Outgoing Validation Flag      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  260477 - Validation error /INT/ in Bank to Bank: apply 251758*
      *  251758 - Additional parameter for FTVXVXV module             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing.                                  *
      *         - Recompile due to change in FTVOPY2PD.               *
      *  CAP084 - MidasPlus Changes                                   *
      *  219131 - Passed parm does not match entry parm for FTVXVXV   *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  CFT009 - Funds Transfer Fees and Charges - recompile         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - BIC Database Plus Integration                       *
      *  CFT004 - Recompile, IBAN - International Bank Account Number *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
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
     D/COPY WNCPYSRC,FTH00563
 
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
 
 
      * Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      * Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)
 
      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of warning message data.
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D TranInSecA    E DS                  EXTNAME(FTOPY2PD)
     D TranInSecB    E DS                  EXTNAME(FTOPY3PD)
     D TranInThir    E DS                  EXTNAME(FTOPY4PD)
                                                                                CFT014
      ** Payment Extension Details layout                                       CFT014
     D TranInPrmB    E DS                  EXTNAME(FTOPY1APD)                   CFT014
     D TranInThiB    E DS                  EXTNAME(FTOPY5PD)                    CFT014
 
     D ExtData       E DS                  EXTNAME(FTOPEXPD)
      * FT (OPAY) Extra Data - File (D/B) format
 
      * Valid Payments layout
     D ValidPmnt     E DS                  EXTNAME(FTVOPAYPD)
     D QQCDROX       E                     EXTFLD(QQCDRO)                                     CGL029
                                                                                CFT014
      ** Valid Outgoing Payments Extension File                                 CFT014
     D ValidPmtX     E DS                  EXTNAME(FTVOPY2PD)                   CFT014
                                                                                              219131
      ** Dummy DS so that parameter passed to FTVXVXV will not contain garbage                219131
     D OKFlagsDS1    E DS                  EXTNAME(FTEOPY2PD) PREFIX(DMY:3)                   219131
 
      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY3PD)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      * External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      * Switchable Features File
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
     D ZMUSER          DS            17                                                       CAP084
     D  WUSRID                 1     10                                                       CAP084
                                                                                              CAP084
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D TCNTRL          DS           256
     D  WPDTI                  1      1
     D  WGLUI                  4      4
     D  WVATF                  6      6
 
      **Data*structure*to*retrieve*VAT*rate****************************         CFT014
     D***VATDS***         DS                                                    CFT014
     D*WVATR*****             10     12P 4                                      CFT014
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
 
      * A code to indicate the calling function to the lower level modules
     D OPAY            S              4A   INZ('OPAY')
 
      * Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
     D I               S              3  0
                                                                                CFT014
      ** Program message queue                                                  CFT014
     D WPrgQ           S             10A                                        CFT014
                                                                                              CSW201
      ** SWIFT 2001 switchable feature                                                        CSW201
     D Csw201          S              1A                                                      CSW201
 
     D/COPY WNCPYSRC,FTH00564
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Initial Processing
     C                   EXSR      INIT
 
      * Call Validation Modules in Sequence
 
      ** Details of Payment                                                     CFT014
                                                                                CFT014
     C                   ExSr      SrDetPay                                     CFT014
                                                                                CFT014
      ** Bank to Bank Information                                               CFT014
                                                                                CFT014
     C/COPY WNCPYSRC,FTH00316
     C                   ExSr      SrBnkToBnk                                   CFT014
      ***Validate*Intermediary*Bank************************************         CFT014
     C/COPY WNCPYSRC,FTH00317
     C***********        Exsr      VINTBNK                                      CFT014
 
      * Validate Central Bank Reference
     C                   Exsr      VCBKREF
                                                                                CFT014
      ** Transfer Commission Tariff                                             CFT014
                                                                                CFT014
     C                   ExSr      SrTrfCmT                                     CFT014
 
      ***Validate*Details*of*Charges***********************************         CFT014
     C***********        Exsr      VDETCHG                                      CFT014
 
      ***Validate*Transfer*Commission*Charges**************************         CFT014
     C***********        Exsr      VTRFCOM                                      CFT014
 
      ***Validate*Telex*Charges****************************************         CFT014
     C***********        Exsr      VTLXCHG                                      CFT014
 
      ***Validate*Cheque*Charges***************************************
     C***********        Exsr      VCHQCHG
 
      ***Validate*Costs*Abroad*****************************************         CFT014
     C***********        Exsr      VCSTABR                                      CFT014
 
      ***Validate*Swift*Priority*Charges*******************************         CFT014
     C***********        Exsr      VSWPCHG                                      CFT014
 
     C***Validate*Miscellaneous*ChargesCHG*****************************         CFT014
     C***********        Exsr      VMSCCHG                                      CFT014
 
      ***Validate*F/Xchange*Commission*Charges*************************         CFT014
     C***********        If        @01494 = 'Y'                                 CFT014
     C***********        Exsr      VCOMCHG                                      CFT014
     C***********        End                                                    CFT014
 
      ***Validate*VAT*Flags*and*Calculate*charges**********************         CFT014
     C***********        If        @VATP = 'Y'                                  CFT014
     C***********        Exsr      VVATFLG                                      CFT014
     C***********        End                                                    CFT014
 
      ***Validate*Total*Charges*<=*Pay*Amount**************************         CFT014
     C***********        Exsr      VTOTCHG                                      CFT014
 
      *  Validate CHAPS Payment Code
     C                   Exsr      VCHAPS
                                                                                CFT014
      ** Instruction Code                                                       CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   ExSr      SrInsCde                                     CFT014
                                                                                CFT014
      ** Regulatory Reporting                                                   CFT014
                                                                                CFT014
     C                   ExSr      SrRgtRep                                     CFT014
     C                   EndIf                                                  CFT014
 
      ***If*Analytical*Accounting*on*in*system*validate*margin*fields**         CFT014
     C*****BGN0ST        IFEQ      'Y'                                          CFT014
     C***********        EXSR      VMGNINFO                                     CFT014
     C***********        ENDIF                                                  CFT014
                                                                                CFT014
      ** Cross validations                                                      CFT014
                                                                                CFT014
     C                   If        Idx = *Zero                                  CFT014
     C                   ExSr      SrXVal                                       CFT014
     C                   EndIf                                                  CFT014
 
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
 
      * RETURN
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************         CFT014
      /Title Sr/SrDetPay                                                        CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SrDetPay: Validate Details of Payment                      *         CFT014
      *                                                               *         CFT014
      * Called By: Main Routine                                       *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      *  RESETERRS  - Resets variables updated by each modules        *         CFT014
      *  FTVDEPY    - Details of Payment Validation Module            *         CFT014
      *  UPDATERRS  - Updates error information                       *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrDetPay      BegSr                                                  CFT014
                                                                                CFT014
      ** Reset variables updated by other modules                               CFT014
                                                                                CFT014
     C                   ExSr      ResetErrs                                    CFT014
                                                                                CFT014
     C/COPY WNCPYSRC,FTOPA3VC01
      ** Validate Details of Payment entry                                      CFT014
                                                                                CFT014
     C                   CallB     'FTVDEPY'                                    CFT014
     C                   Parm                    ReTCodeOut                     CFT014
     C                   Parm                    TranInPrim                     CFT014
     C                   Parm                    TranInPrmB                                 BUG26775
     C                   Parm                    TranInSecB                                 BUG26775
     C                   Parm                    TranInThir                     CFT014
     C                   Parm                    FldNamXAr                      CFT014
     C                   Parm                    MsgIDXAr                       CFT014
     C                   Parm                    MsgDtaXAr                      CFT014
     C                   Parm                    WFldNmXAr                                    CSD089
     C                   Parm                    WMsgIDXAr                                    CSD089
     C                   Parm                    WMsgDtXAr                                    CSD089
     C                   Parm                    OKFlagsDS                      CFT014
     C                   Parm                    Val@Fields                     CFT014
     C/COPY WNCPYSRC,FTH00374
                                                                                CFT014
      ** Update error info with that retured from the validation module         CFT014
                                                                                CFT014
     C                   ExSr      UpdatErrs                                    CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SrBnkToBnk                                                      CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SrBnkToBnk  - Bank to Bank Information Validation            *         CFT014
      *                                                               *         CFT014
      *  Called By: Main Processing                                   *         CFT014
      *                                                               *         CFT014
      *  Calls:                                                       *         CFT014
      *  RESETERRS  - Resets variables updated by each modules        *         CFT014
      *  FTVTOBK    - Bank to Bank Information Validation Module      *         CFT014
      *  UPDATERRS  - Updates error information                       *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrBnkToBnk    BegSr                                                  CFT014
                                                                                CFT014
      ** Reset variables updated by other modules                               CFT014
                                                                                CFT014
     C                   ExSr      ResetErrs                                    CFT014
                                                                                CFT014
      ** Validate Bank to Bank Information entry                                CFT014
                                                                                CFT014
     C                   CallB     'FTVTOBK'                                    CFT014
     C                   Parm                    ReTCodeOut                     CFT014
     C                   Parm                    TranInPrim                     CFT014
     C                   Parm                    TranInThir                     CFT014
     C                   Parm                    FldNamXAr                      CFT014
     C                   Parm                    MsgIDXAr                       CFT014
     C                   Parm                    MsgDtaXAr                      CFT014
     C                   Parm                    WFldNmXAr                      CFT014
     C                   Parm                    WMsgIDXAr                      CFT014
     C                   Parm                    WMsgDtXAr                      CFT014
     C                   Parm                    OKFlagsDS                      CFT014
     C                   Parm                    Val@Fields                     CFT014
     C                   PARM                    Csw201                                       CSW201
                                                                                CFT014
      ** Update error info with that retured from the validation module         CFT014
                                                                                CFT014
     C                   ExSr      UpdatErrs                                    CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      *****************************************************************         CFT014
      ***VINTBNK**-*Validate*Intermediary*Bank*************************         CFT014
      *****************************************************************         CFT014
     C*****VINTBNK       BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      ***Validate******************************************************         CFT014
     C***********        CALLB     'FTVIYBK'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInPrim                     CFT014
     C***********        Parm                    TranInThir                     CFT014
      ***********                                                               CFT014
      **OUTPUTS********************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C***********        Parm                    FldNamXAr                      CFT014
     C***********        Parm                    MsgIDXAr                       CFT014
     C***********        Parm                    MsgDtaXAr                      CFT014
      ***********                                                               CFT014
     C***********        Parm                    WFldNmXAr                      CFT014
     C***********        Parm                    WMsgIDXAr                      CFT014
     C***********        Parm                    WMsgDtXAr                      CFT014
      ***********                                                               CFT014
      ***OK*Flags******************************************************         CFT014
     C***********        Parm                    OKFlagsDS                      CFT014
      ***********                                                               CFT014
      ***Validation*Work*Fields****************************************         CFT014
     C***********        Parm                    Val@Fields                     CFT014
      ***********                                                               CFT014
      ***********                                                               CFT014
      **Update*error*info*with*that*returned*from*the*validation*module         CFT014
     C***********        Exsr      UPDATERRS                                    CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
      *****************************************************************         CFT014
     C*/EJECTT***                                                               CFT014
      *****************************************************************
      ** VCBKREF  - Validate Central Bank Reference
      *****************************************************************
     C     VCBKREF       BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C                   CALLB     'FTVBARF'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut
 
      *  Screen fields
     C                   Parm                    TranInThir
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************         CFT014
      /Title Sr/SrTrfCmT                                                        CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SrTrfCmT    - Transfer Commission Tariff Validation          *         CFT014
      *                                                               *         CFT014
      *  Called By: Main Processing                                   *         CFT014
      *                                                               *         CFT014
      *  Calls:                                                       *         CFT014
      *  RESETERRS  - Resets variables updated by each modules        *         CFT014
      *  FTVTFTA    - Transfer Commission Tariff Validation Module    *         CFT014
      *  UPDATERRS  - Updates error information                       *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrTrfCmT      BegSr                                                  CFT014
                                                                                CFT014
      ** Reset variables updated by other modules                               CFT014
                                                                                CFT014
     C                   ExSr      ResetErrs                                    CFT014
                                                                                CFT014
      ** Validate Transfer Commission Code entry                                CFT014
                                                                                CFT014
     C                   CallB     'FTVTFTA'                                    CFT014
     C                   Parm                    ReTCodeOut                     CFT014
     C                   Parm                    TranInPrim                     CFT014
     C                   Parm                    TranInThir                     CFT014
     C                   Parm                    FldNamXAr                      CFT014
     C                   Parm                    MsgIDXAr                       CFT014
     C                   Parm                    MsgDtaXAr                      CFT014
     C                   Parm                    OKFlagsDS                      CFT014
     C                   Parm                    Val@Fields                     CFT014
                                                                                CFT014
      ** Update error info with that retured from the validation module         CFT014
                                                                                CFT014
     C                   ExSr      UpdatErrs                                    CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      *****************************************************************         CFT014
      ***VDETCHG**-*Validate*Details*of*Charges************************         CFT014
      *****************************************************************         CFT014
     C*****VDETCHG       BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      ***Validate******************************************************         CFT014
     C***********        CALLB     'FTVDECH'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInThir                     CFT014
      ***********                                                               CFT014
      **OUTPUTS********************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C***********        Parm                    FldNamXAr                      CFT014
     C***********        Parm                    MsgIDXAr                       CFT014
     C***********        Parm                    MsgDtaXAr                      CFT014
      ***********                                                               CFT014
      ***OK*Flags******************************************************         CFT014
     C***********        Parm                    OKFlagsDS                      CFT014
      ***********                                                               CFT014
      ***Validation Work Fields                                                 CFT014
     C***********        Parm                    Val@Fields                     CFT014
      ***********                                                               CFT014
      ***********                                                               CFT014
      **Update*error*info*with*that*returned*from*the*validation*module         CFT014
     C***********        Exsr      UPDATERRS                                    CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
      *****************************************************************         CFT014
     C*/EJECTT***                                                               CFT014
      *****************************************************************         CFT014
      ***VTRFCOM**-*Validate*Transfer*Commission*Charge****************         CFT014
      *****************************************************************         CFT014
     C*****VTRFCOM       BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      ***Validate******************************************************         CFT014
     C***********        CALLB     'FTVTFCH'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInThir                     CFT014
      ***********                                                               CFT014
      **OUTPUTS********************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C***********        Parm                    FldNamXAr                      CFT014
     C***********        Parm                    MsgIDXAr                       CFT014
     C***********        Parm                    MsgDtaXAr                      CFT014
      ***********                                                               CFT014
      ***OK*Flags******************************************************         CFT014
     C***********        Parm                    OKFlagsDS                      CFT014
      ***********                                                               CFT014
      ***Validation*Work*Fields****************************************         CFT014
     C***********        Parm                    Val@Fields                     CFT014
      ***********                                                               CFT014
      **Update*error*info*with*that*returned*from*the*validation*module         CFT014
     C***********        Exsr      UPDATERRS                                    CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
      *****************************************************************         CFT014
     C*/EJECTT***                                                               CFT014
      *****************************************************************         CFT014
      *****************************************************************         CFT014
      ***VTLXCHG**-*Validate*Telex*Charges*****************************         CFT014
      *****************************************************************         CFT014
     C*****VTLXCHG       BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      ***Validate******************************************************         CFT014
     C***********        CALLB     'FTVTLCH'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInPrim                     CFT014
     C***********        Parm                    TranInThir                     CFT014
      ***********                                                               CFT014
      **OUTPUTS**                                                               CFT014
      ***Error*fields/message IDs/message data (arrays) from/to caller          CFT014
     C***********        Parm                    FldNamXAr                      CFT014
     C***********        Parm                    MsgIDXAr                       CFT014
     C***********        Parm                    MsgDtaXAr                      CFT014
      ***********                                                               CFT014
      ***OK*Flags******************************************************         CFT014
     C***********        Parm                    OKFlagsDS                      CFT014
      ***********                                                               CFT014
      ***Validation*Work*Fields****************************************         CFT014
     C***********        Parm                    Val@Fields                     CFT014
      ***********                                                               CFT014
      **Update*error*info*with*that*returned*from*the*validation*module         CFT014
     C***********        Exsr      UPDATERRS                                    CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
      *****************************************************************         CFT014
     C*/EJECTT***                                                               CFT014
      *****************************************************************         CFT014
      ***VCHQCHG*-*Validate*Cheque*Charges*****************************         CFT014
      *****************************************************************         CFT014
     C*****VCHQCHG       BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      ***Validate******************************************************         CFT014
     C***********        CALLB     'FTVCQCH'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInThir                     CFT014
      ***********                                                               CFT014
      **OUTPUTS********************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C***********        Parm                    FldNamXAr                      CFT014
     C***********        Parm                    MsgIDXAr                       CFT014
     C***********        Parm                    MsgDtaXAr                      CFT014
      ***********                                                               CFT014
      ***OK*Flags******************************************************         CFT014
     C***********        Parm                    OKFlagsDS                      CFT014
      ***********                                                               CFT014
      ***Validation*Work*Fields****************************************         CFT014
     C***********        Parm                    Val@Fields                     CFT014
      ***********                                                               CFT014
      ***********                                                               CFT014
      **Update*error*info*with*that*returned*from*the*validation*module         CFT014
     C***********        Exsr      UPDATERRS                                    CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
      *****************************************************************         CFT014
     C*/EJECTT***                                                               CFT014
      *****************************************************************         CFT014
      ***VCSTABR**-*Validate*Costs*Abroad******************************         CFT014
      *****************************************************************         CFT014
     C*****VCSTABR       BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      **Validate*******************************************************         CFT014
     C***********        CALLB     'FTVCTAB'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInThir                     CFT014
      ***********                                                               CFT014
      **OUTPUTS********************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C***********        Parm                    FldNamXAr                      CFT014
     C***********        Parm                    MsgIDXAr                       CFT014
     C***********        Parm                    MsgDtaXAr                      CFT014
      ***********                                                               CFT014
      ***OK*Flags                                                               CFT014
     C***********        Parm                    OKFlagsDS                      CFT014
      ***********                                                               CFT014
      ***Validation*Work*Fields****************************************         CFT014
     C***********        Parm                    Val@Fields                     CFT014
      ***********                                                               CFT014
      ***********                                                               CFT014
      **Update*error*info*with*that*returned*from*the*validation*module         CFT014
     C***********        Exsr      UPDATERRS                                    CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
      *****************************************************************         CFT014
     C*/EJECTT***                                                               CFT014
      *****************************************************************         CFT014
      ***VSWPCHG*-*Validate*SWIFT*Priority*Charges*********************         CFT014
      *****************************************************************         CFT014
     C*****VSWPCHG       BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      **Validate*******************************************************         CFT014
     C***********        CALLB     'FTVSFCH'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInPrim                     CFT014
     C***********        Parm                    TranInThir                     CFT014
      ***********                                                               CFT014
      **OUTPUTS********************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C***********        Parm                    FldNamXAr                      CFT014
     C***********        Parm                    MsgIDXAr                       CFT014
     C***********        Parm                    MsgDtaXAr                      CFT014
      ***********                                                               CFT014
      ***OK*Flags******************************************************         CFT014
     C***********        Parm                    OKFlagsDS                      CFT014
      ***********                                                               CFT014
      ***Validation*Work*Fields****************************************         CFT014
     C***********        Parm                    Val@Fields                     CFT014
      ***********                                                               CFT014
      **Update*error*info*with*that*returned*from*the*validation*module         CFT014
     C***********        Exsr      UPDATERRS                                    CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
      *****************************************************************         CFT014
      */EJECTT***                                                               CFT014
      *****************************************************************         CFT014
      ***VMSCCHG*-*Validate*Miscellaneous*Charges**********************         CFT014
      *****************************************************************         CFT014
     C*****VMSCCHG       BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      **Validate*******************************************************         CFT014
     C***********        CALLB     'FTVMCCH'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInThir                     CFT014
      ***********                                                               CFT014
      **OUTPUTS********************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C***********        Parm                    FldNamXAr                      CFT014
     C***********        Parm                    MsgIDXAr                       CFT014
     C***********        Parm                    MsgDtaXAr                      CFT014
      ***********                                                               CFT014
      ***OK*Flags                                                               CFT014
     C***********        Parm                    OKFlagsDS                      CFT014
      ***********                                                               CFT014
      ***Validation*Work*Fields****************************************         CFT014
     C***********        Parm                    Val@Fields                     CFT014
      ***********                                                               CFT014
      **Update*error*info*with*that*returned*from*the*validation*module         CFT014
     C***********        Exsr      UPDATERRS                                    CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
      *****************************************************************         CFT014
      */EJECTT***                                                               CFT014
      *****************************************************************         CFT014
      ***VCOMCHG*-*Validate*Commission*Charges*************************         CFT014
      *****************************************************************         CFT014
     C*****VCOMCHG       BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      **Validate*******************************************************         CFT014
     C***********        CALLB     'FTVCMCH'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInPrim                     CFT014
     C***********        Parm                    TranInThir                     CFT014
      ***********                                                               CFT014
      **OUTPUTS********************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C***********        Parm                    FldNamXAr                      CFT014
     C***********        Parm                    MsgIDXAr                       CFT014
     C***********        Parm                    MsgDtaXAr                      CFT014
      ***********                                                               CFT014
      ***OK*Flags******************************************************         CFT014
     C***********        Parm                    OKFlagsDS                      CFT014
      ***********                                                               CFT014
      ***Validation*Work*Fields****************************************         CFT014
     C***********        Parm                    Val@Fields                     CFT014
      ***********                                                               CFT014
      ***********                                                               CFT014
      **Update*error*info*with*that*returned*from*the*validation*module         CFT014
     C***********        Exsr      UPDATERRS                                    CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
      *****************************************************************         CFT014
      */EJECTT***                                                               CFT014
      *****************************************************************         CFT014
      ***VVATFLG*-*Validate*VAT*Flags*and*Calculate*Charges************         CFT014
      *****************************************************************
     C*****VVATFLG       BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      **Validate*******************************************************         CFT014
     C***********        CALLB     'FTVVTIN'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInThir                     CFT014
      ***********                                                               CFT014
      **OUTPUTS********************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C***********        Parm                    FldNamXAr                      CFT014
     C***********        Parm                    MsgIDXAr                       CFT014
     C***********        Parm                    MsgDtaXAr                      CFT014
      ***********                                                               CFT014
      ***OK*Flags******************************************************         CFT014
     C***********        Parm                    OKFlagsDS                      CFT014
      ***********                                                               CFT014
      ***Validation*Work*Fields****************************************         CFT014
     C***********        Parm                    Val@Fields                     CFT014
      ***********                                                               CFT014
      **Update*error info with that returned from the validation module         CFT014
     C***********        Exsr      UPDATERRS                                    CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
      *****************************************************************         CFT014
      */EJECTT***                                                               CFT014
      *****************************************************************         CFT014
      ***VTOTCHG*-*Validate*Total*Charges*<=*Pay*Amount****************         CFT014
      *****************************************************************         CFT014
     C*****VTOTCHG       BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      **Validate*******************************************************         CFT014
     C***********        CALLB     'FTVCHPY'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInPrim                     CFT014
     C***********        Parm                    TranInThir                     CFT014
      ***********                                                               CFT014
      **OUTPUTS********************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C***********        Parm                    FldNamXAr                      CFT014
     C***********        Parm                    MsgIDXAr                       CFT014
     C***********        Parm                    MsgDtaXAr                      CFT014
      ***********                                                               CFT014
      ***OK*Flags                                                               CFT014
     C***********        Parm                    OKFlagsDS                      CFT014
      ***********                                                               CFT014
      ***Validation*Work*Fields****************************************         CFT014
     C***********        Parm                    Val@Fields                     CFT014
      ***********                                                               CFT014
      ***********                                                               CFT014
      **Update*error*info*with*that*returned*from*the*validation*module         CFT014
     C***********        Exsr      UPDATERRS                                    CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
      *****************************************************************         CFT014
      */EJECTT***                                                               CFT014
      *****************************************************************
      ** VCHAPS  - Validate CHAPS Payment Code
      *****************************************************************
     C     VCHAPS        BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      * Validate
     C                   CALLB     'FTVSECD'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut
 
      *  Screen fields
     C                   Parm                    TranInThir
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
     C/COPY WNCPYSRC,FTH00515
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************         CFT014
      /Title Sr/SrInsCde                                                        CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SrInsCde    - Instruction Code Validation                    *         CFT014
      *                                                               *         CFT014
      *  Called By: Main Processing                                   *         CFT014
      *                                                               *         CFT014
      *  Calls:                                                       *         CFT014
      *  RESETERRS  - Resets variables updated by each modules        *         CFT014
      *  FTVINCD    - Instruction Code Validation Module              *         CFT014
      *  UPDATERRS  - Updates error information                       *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrInsCde      BegSr                                                  CFT014
                                                                                CFT014
      ** Reset variables updated by other modules                               CFT014
                                                                                CFT014
     C                   ExSr      ResetErrs                                    CFT014
                                                                                CFT014
      ** Validate Instruction Code entry                                        CFT014
                                                                                CFT014
     C                   CallB     'FTVINCD'                                    CFT014
     C                   Parm                    ReTCodeOut                     CFT014
     C                   Parm                    TranInSecA                     CFT014
     C                   Parm                    TranInSecB                     CFT014
     C                   Parm                    TranInThir                     CFT014
     C                   Parm                    TranInThiB                     CFT014
     C                   Parm                    FldNamXAr                      CFT014
     C                   Parm                    MsgIDXAr                       CFT014
     C                   Parm                    MsgDtaXAr                      CFT014
     C                   Parm                    WFldNmXAr                                    CSD089
     C                   Parm                    WMsgIDXAr                                    CSD089
     C                   Parm                    WMsgDtXAr                                    CSD089
     C                   Parm                    OKFlagsDS                      CFT014
     C                   Parm                    Val@Fields                     CFT014
     C                   PARM                    Csw201                                       CSW201
                                                                                CFT014
      ** Update error info with that retured from the validation module         CFT014
                                                                                CFT014
     C                   ExSr      UpdatErrs                                    CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SrRgtRep                                                        CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SrRgtRep    - Regulatory Reporting Validation                *         CFT014
      *                                                               *         CFT014
      *  Called By: Main Processing                                   *         CFT014
      *                                                               *         CFT014
      *  Calls:                                                       *         CFT014
      *  RESETERRS  - Resets variables updated by each modules        *         CFT014
      *  FTVRRPT    - Regulatory Reporting Validation Module          *         CFT014
      *  UPDATERRS  - Updates error information                       *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrRgtRep      BegSr                                                  CFT014
                                                                                CFT014
      ** Reset variables updated by other modules                               CFT014
                                                                                CFT014
     C                   ExSr      ResetErrs                                    CFT014
                                                                                CFT014
      ** Validate Regulatory Reporting entry                                    CFT014
                                                                                CFT014
     C                   CallB     'FTVRRPT'                                    CFT014
     C                   Parm                    ReTCodeOut                     CFT014
     C                   Parm                    TranInThiB                     CFT014
     C                   Parm                    FldNamXAr                      CFT014
     C                   Parm                    MsgIDXAr                       CFT014
     C                   Parm                    MsgDtaXAr                      CFT014
     C                   Parm                    WFldNmXAr                                    CSD089
     C                   Parm                    WMsgIDXAr                                    CSD089
     C                   Parm                    WMsgDtXAr                                    CSD089
     C                   Parm                    OKFlagsDS                      CFT014
     C                   Parm                    Val@Fields                     CFT014
                                                                                CFT014
      ** Update error info with that retured from the validation module         CFT014
                                                                                CFT014
     C                   ExSr      UpdatErrs                                    CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SrXVal                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SrXVal      - Bank Cross Validation                          *         CFT014
      *                                                               *         CFT014
      *  Called By: Main Processing                                   *         CFT014
      *                                                               *         CFT014
      *  Calls:                                                       *         CFT014
      *  RESETERRS  - Resets variables updated by each modules        *         CFT014
      *  FTVXVXV    - Cross Validation Module                         *         CFT014
      *  UPDATERRS  - Updates error information                       *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrXVal        BegSr                                                  CFT014
                                                                                CFT014
      ** Reset variables updated by other modules                               CFT014
                                                                                CFT014
     C                   ExSr      ResetErrs                                    CFT014
                                                                                CFT014
      ** Validate                                                               CFT014
                                                                                CFT014
     C                   CallB     'FTVXVXV'                                    CFT014
     C                   Parm                    ReTCodeOut                     CFT014
     C                   Parm                    TranInPrim                     CFT014
     C                   Parm                    TranInPrmB                                 BUG26775
     C                   Parm                    TranInSecA                                   251758
     C                   Parm                    TranInSecB                     CFT014
     C                   Parm                    TranInThir                     CFT014
     C                   Parm      'FTOPAY3VL'   WPrgQ                          CFT014
     C                   Parm                    FldNamXAr                      CFT014
     C                   Parm                    MsgIDXAr                       CFT014
     C                   Parm                    MsgDtaXAr                      CFT014
     C                   Parm                    OKFlagsDS1                                   219131
     C                   Parm                    OKFlagsDS                      CFT014
     C                   Parm                    Val@Fields                     CFT014
                                                                                CFT014
      ** Update error info with that retured from the validation module         CFT014
                                                                                CFT014
     C                   ExSr      UpdatErrs                                    CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      *****************************************************************         CFT014
      ***VMGNINFO*-*Validate*FX*Margin*Information*********************         CFT014
      *****************************************************************         CFT014
     C*****VMGNINFO      BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      **Validate*******************************************************         CFT014
     C***********        CALLB     'FTVMGMG'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInPrim                     CFT014
     C***********        Parm                    TranInThir                     CFT014
      ***********                                                               CFT014
      **OUTPUTS********************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C***********        Parm                    FldNamXAr                      CFT014
     C***********        Parm                    MsgIDXAr                       CFT014
     C***********        Parm                    MsgDtaXAr                      CFT014
      ***********                                                               CFT014
     C***********        Parm                    WFldNmXAr                      CFT014
     C***********        Parm                    WMsgIDXAr                      CFT014
     C***********        Parm                    WMsgDtXAr                      CFT014
      ***********                                                               CFT014
      ***OK*Flags******************************************************         CFT014
     C***********        Parm                    OKFlagsDS                      CFT014
      ***********                                                               CFT014
      ***Validation*Work*Fields****************************************         CFT014
     C***********        Parm                    Val@Fields                     CFT014
      ***********                                                               CFT014
      **Update*error*info*with*that*returned*from*the*validation*module         CFT014
     C***********        Exsr      UPDATERRS                                    CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
      *****************************************************************         CFT014
      */EJECT****                                                               CFT014
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
      **  Details of Payment                                                    CFT014
                                                                                CFT014
     C                   Eval      OTDTP1 = SDTP1                               CFT014
     C                   Eval      OTDTP2 = SDTP2                               CFT014
     C                   Eval      OTDTP3 = SDTP3                               CFT014
     C                   Eval      OTDTP4 = SDTP4                               CFT014
                                                                                CFT014
      ** Sender to Receiver information                                         CFT014
                                                                                CFT014
     C                   Eval      OTBBI1 = SBBI1                               CFT014
     C                   Eval      OTBBI2 = SBBI2                               CFT014
     C                   Eval      OTBBI3 = SBBI3                               CFT014
     C                   Eval      OTBBI4 = SBBI4                               CFT014
     C                   Eval      OTBBI5 = SBBI5                               CFT014
     C                   Eval      OTBBI6 = SBBI6                               CFT014
                                                                                CFT014
      **Intermediary*Bank**********************************************         CFT014
     C***********        Eval      OTINBT = @INBT                               CFT014
     C***********        Eval      OTINB1 = SINB1                               CFT014
     C***********        Eval      OTINB2 = SINB2                               CFT014
     C***********        Eval      OTINB3 = SINB3                               CFT014
     C***********        Eval      OTINB4 = SINB4                               CFT014
     C***********        Eval      OTINB5 = SINB5                               CFT014
 
      *  Central Bank Reference
     C                   Eval      OTDNBC = @DNBC
                                                                                CFT014
      ** Transfer Commission Tariff                                             CFT014
                                                                                CFT014
     C                   Eval      OTTRCT = STRCT                               CFT014
 
      ***Details*of*Charges********************************************         CFT014
     C***********        Eval      OTDTCH = SDTCH                               CFT014
 
      *  Chaps code
     C                   Eval      OTCHAP = @CHAP
 
      *  Related Reference
     C                   Eval      OTRLPR = SRLPR
 
      ** Instruction Code                                                       CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   Eval      O2ICD1 = SICD1                               CFT014
     C                   Eval      O2ICD2 = SICD2                               CFT014
     C                   Eval      O2ICD3 = SICD3                               CFT014
     C                   Eval      O2ICD4 = SICD4                               CFT014
     C                   Eval      O2ICD5 = SICD5                               CFT014
                                                                                CFT014
      ** Regulatory Reporting                                                   CFT014
                                                                                CFT014
     C                   Eval      O2RRP1 = SRRP1                               CFT014
     C                   Eval      O2RRP2 = SRRP2                               CFT014
     C                   Eval      O2RRP3 = SRRP3                               CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ***Charges*******************************************************         CFT014
     C***********        Eval      OTDUMA1 = @TRCD                              CFT014
     C***********        Eval      OTTRCM = @TRCM                               CFT014
 
     C***********        Eval      OTDUMA2 = @TXCD                              CFT014
     C***********        Eval      OTTXCH = @TXCH                               CFT014
 
     C***********        Eval      OTDUMA3 = @CQCD                              CFT014
     C***********        Eval      OTCQCH = @CQCH                               CFT014
 
     C***********        Eval      OTDUMA4 = @CSTD                              CFT014
     C***********        Eval      OTCSTA = @CSTA                               CFT014
 
     C***********        Eval      OTDUMA5 = @SPCD                              CFT014
     C***********        Eval      OTSPCH = @SPCH                               CFT014
 
     C***********        Eval      OTDUMA6 = @MSCD                              CFT014
     C***********        Eval      OTMSCH = @MSCH                               CFT014
 
     C***********        If        @01494 = 'Y'                                 CFT014
     C***********        Eval      OTOPDUM7 = @CHCD                             CFT014
     C***********        Eval      OTOPCHCM = @CHCM                             CFT014
     C***********        End                                                    CFT014
 
      **If*switchable*feature*S01499*is*switched*ON,*set*up*V.A.T.*details      CFT014
     C***********        If        @01499 = 'Y'                                 CFT014
     C***********        Eval      OTOPDUM8 = @VATD                             CFT014
     C***********        Eval      OTOPVATT = @VATT                             CFT014
     C***********        Eval      OTOPVAT1 = SVAT1                             CFT014
     C***********        Eval      OTOPVAT2 = SVAT2                             CFT014
     C***********        Eval      OTOPVAT3 = SVAT3                             CFT014
     C***********        Eval      OTOPVAT4 = SVAT4                             CFT014
     C***********        Eval      OTOPVAT5 = SVAT5                             CFT014
     C***********        Eval      OTOPVAT6 = SVAT6                             CFT014
     C***********        Eval      OTOPVAT7 = SVAT7                             CFT014
 
      **Store*V.A.T.*rate*if*used**************************************         CFT014
     C***********        If        @VATD <> 0 or                                CFT014
     C***********                  @VATT <> 0                                   CFT014
     C***********        Eval      OTOPVATR = @VATR                             CFT014
     C***********        End                                                    CFT014
 
     C***********        End                                                    CFT014
 
      **If*Analytical*Accounting*installed,*set*up*margin*info*fields.*         CFT014
     C***********        If        BGN0ST = 'Y'                                 CFT014
     C***********        Eval      OTFXMP = @FXMP                               CFT014
     C***********        Eval      OTFXMD = @FXMD                               CFT014
     C***********        Eval      OTMSIG = SMSIG                               CFT014
     C***********        Eval      OTMAMT = @MAMT                               CFT014
     C***********        If        SMBSI  = 'S'                                 CFT014
     C***********        Eval      OTMBSI = 'B'                                 CFT014
     C***********        End                                                    CFT014
     C***********        If        SMBSI  = 'P'                                 CFT014
     C***********        Eval      OTMBSI = 'S'                                 CFT014
     C***********        End                                                    CFT014
     C***********        End                                                    CFT014
 
      * If insert set up audit information
     C                   If        SACTION = 'I'
     C                   Time                    OTLCHT
     C                   Eval      OTLCD = BJRDNB
     C                   Eval      OTCHTP = 'I'
     C                   Eval      @USRID = WUSRID                                            CAP084
     C                   Eval      OTINUSR2 = @USRID
     C                   End
     C
      * If amend set up audit information
     C                   If        SACTION = 'A'
     C                   Time                    OTLCHT
     C                   If        OTLCD <> BJRDNB
     C                   Eval      OTCHTP = 'A'
     C                   End
     C                   Eval      OTAUP1 = *Blanks
     C                   Eval      OTLCD = BJRDNB
     C                   Eval      @USRID = WUSRID                                            CAP084
     C                   Eval      OTINUSR2 = @USRID
     C                   End
 
      * If delete set up audit information
     C                   If        SACTION = 'D'
     C                   Eval      OTRECI = 'C'
     C                   Time                    OTLCHT
     C                   Eval      OTLCD = BJRDNB
     C                   Eval      OTCHTP = 'D'
     C                   End
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETUP_OTH - Set Up Other Fields
      *****************************************************************
     C     SETUP_OTH     BEGSR
      *
 
     C                   ENDSR
     C*******************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
 
      * Transaction information (DS) from source system
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSecA
     C                   PARM                    TranInSecB
     C                   PARM                    TranInThir
     C                   PARM                    TranInPrmB                     CFT014
     C                   PARM                    TranInThiB                     CFT014
 
      * Custom Extra Data file data
     C                   PARM                    ExtData
 
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
     C                   PARM                    ValidPmnt
     C                   PARM                    ValidPmtX                      CFT014
 
      *  Validation Work Fields from/to caller
     C                   Parm                    Val@Fields
 
      *  Move program name into *LDA field.
     C     *LOCK         In        LDA
     C                   Movel     'FTPYOTVAL'   DBPGM
     C                   Out       LDA
 
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
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
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ***Set*up*the*name*of the MSGF from which the message handler will        CFT007
      ****get*the*messages                                                      CFT007
     C*******************EVAL      #MsgFile = 'DRSMM'                           CFT007
      ** Set up the name of the primary and secondary message files from        CFT007
      ** which the message handler will get the messages                        CFT007
     C                   EVAL      #MsgFile     = 'FTUSRMSG'                    CFT007
     C                   EVAL      MsgFArray(1) = 'DRSMM'                       CFT007
 
      *                                                                                       CSW201
      ** Check if enhancement CSW201 is on                                                    CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                           99                    CSW201
     C                   PARM      *BLANKS       @Rtcd                                        CSW201
      *                                                                                       CSW201
     C                   IF        *IN99                                                      CSW201
     C                   EVAL      DBPGM = 'SWIF2001'                                         CSW201
     C                   EXSR      *PSSR                                                      CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        @Rtcd = 'CSW2001'                                          CSW201
     C                   EVAL      Csw201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      Csw201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
     C/COPY WNCPYSRC,FTH00375
      **********                                                                      CAP084 BUG7029
      ***Retrieve*ZMUSER*details.                                                     CAP084 BUG7029
      **********                                                                      CAP084 BUG7029
     C******DTAARA       DEFINE                  ZMUSER                               CAP084 BUG7029
     C**********         IN        ZMUSER                                             CAP084 BUG7029
      *                                                                                       CSW201
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INIT - Initial Processing                                    *
      *****************************************************************
 
     C     INIT          BEGSR
 
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
      *                                                                                      BUG7029
      * Access FT Control data
     C                   CALL      'FT0005'                             9090
     C                   Parm      *BLANKS       @RTCD
     C     TCNTRL        Parm      TCNTRL        DSFDY
      *
     C                   If        *IN90 = *ON or
     C                             @RTCD = '*ERROR*'
     C                   Move      'FTOPAY3VL'   DBPGM
     C                   Move      'FT0005'      DBFILE
     C                   Eval      DBASE = 20
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        WGLUI = 'I'
     C                   Eval      @FTOV = 'Y'
     C                   Else
     C                   Eval      @FTOV = *Blanks
     C                   End
     C                   Eval      @PDTI =WPDTI
     C                   Eval      @VATF =WVATF
 
      ** Access SAR details file to determine if CEU006 is on.
     C                   CALLB     'AOSARDR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CEU006'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Move      'FTOPAY3VL'   DBPGM
     C                   Move      'AOSARDR0'    DBFILE
     C                   Eval      DBASE = 2
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Eval      @CEU006 = 'Y'
     C                   Else
     C                   Eval      @CEU006 = 'N'
     C                   End
      *
      **Read*V.A.T.*details*if*S01499*switched*ON***************************    CFT014
     C***********        If        @01499 = 'Y'                                 CFT014
     C***********        CALL      'AOVATR0'                            9090    CFT014
     C***********        Parm      '*MSG   '     @RTCD                          CFT014
     C***********        Parm      '*FIRST '     @OPTN                          CFT014
     C***********        Parm                    VATDS                          CFT014
      ***********                                                               CFT014
     C***********        If        *IN90 = *ON or                               CFT014
     C***********                  @RTCD = '*ERROR*'                            CFT014
     C***********        Move      'FTOPAY3VL'   DBPGM                          CFT014
     C***********        Move      'AOVATR0'     DBFILE                         CFT014
     C***********        Eval      DBASE = 2                                    CFT014
     C***********        Movel     '*CALL'       DBKEY                          CFT014
     C***********        Exsr      *PSSR                                        CFT014
      ***********                                                               CFT014
     C***********        Else                                                   CFT014
     C***********        Eval      OTOPVATR = WVATR                             CFT014
     C***********        Eval      @VATR = WVATR                                CFT014
     C***********        Eval      @VATP = 'Y'                                  CFT014
     C***********        End                                                    CFT014
     C***********        End                                                    CFT014
     C/COPY WNCPYSRC,FTH00516
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   Eval      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      WFldNmXAr = *BlankS
     C                   Eval      WMsgIDXAr = *BlankS
     C                   Eval      WMsgDtXAr = *BlankS
 
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
     C                   Eval      I = 1
     C     *Blank        Lookup    FldNameArr(I)                          99
     C                   If        *IN99 = *On
     C                   Movea     FldNamXar     FldNameArr(I)
     C                   Movea     MsgIDXAr      MsgIdArr(I)
     C                   Movea     MsgDtaXAr     MsgDtaArr(I)
     C                   End
      *
      * Set Error Index
     C                   Eval      I = 1
     C     *Blank        Lookup    FldNameArr(I)                          99
     C                   Eval      Idx = I - 1
      *
      * Update warning fields/message IDs/message data (arrays)
      *
     C                   Eval      I = 1
     C     *Blank        Lookup    WFldNamArr(I)                          99
     C                   If        *IN99 = *On
     C                   Movea     WFldNmXAr     WFldNamArr(I)
     C                   Movea     WMsgIDXAr     WMsgIDArr(I)
     C                   Movea     WMsgDtXAr     WMsgDtaArr(I)
     C                   End
      *
      * Set Warning Index
     C                   Eval      I = 1
     C     *Blank        Lookup    WFldNamArr(I)                          99
     C                   Eval      WIdx = I - 1
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
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
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
