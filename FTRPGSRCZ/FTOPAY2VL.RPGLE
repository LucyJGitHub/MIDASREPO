     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments validation control 2')      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTOPAY2VL - FT Outgoing Payments Validation Module           *
      *                                                               *
      *  Function: This Program Validates FT Outgoing Payments for    *
      *            input to the Midas database.                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055656           Date 20Apr20               *
      *  Prev Amend No. MD021318           Date 26Jul13               *
      *                 MD046248           Date 27Oct17               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR787620           Date 10Jun11               *
      *                 CRE067             Date 05Oct10               *
      *                 BUG26775           Date 27Nov09               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260477             Date 21May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 250600             Date 07Oct07               *
      *                 BUG14042           Date 24May07               *
      *                 BUG13798           Date 02May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12541           Date 16Nov06               *
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 16Oct03               *
      *                 219131             Date 26May03               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
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
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055656 - OPAY messages sent via JMS API end in error       *
      *             (ERZ248) (Recompile)                              *
      *  MD021318 - OPAY allowed input of account with block debit    *
      *           - Fix is to condition CSD089 overridable error      *
      *             changes when input is from HATS screen            *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,FTH00014                                 *
      *             WNCPYSRC,FTH00015                                 *
      *             WNCPYSRC,FTH00016                                 *
      *             WNCPYSRC,FTH00017                                 *
      *             WNCPYSRC,FTH00018                                 *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  BUG26775 - Validation error in Outgoing Validation Flag      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  260477 - Validation error /INT/ in Bank to Bank: apply 251758*
      *  251758 - Additional parameter for FTVXVXV module             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  BUG14042 - CFT032 errors ; applied fix 13798                 *
      *  BUG13798 - CFT032 errors                                     *
      *  BUG12541- Resolve the problem encountered in Beneficiary Type*
      *            and Ordering Type. (Recompile due to changes made  *
      *            in RPGLE/FTVBEBE).                                 *
      *  CFT032 - Account Line in Field 50X in MT103                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing.                                  *
      *         - Recompile due to change in FTVOPY2PD                *
      *  219131 - Passed parm does not match entry parm for FTVXVXV   *
      *  CFT009 - Funds Transfer Fees and Charges (Recompiled)        *
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
 
     FFXCDAFLL  IF   E             DISK    INFSR(*PSSR)
 
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
     D TranInSecC    E DS                  EXTNAME(FTOPY1PD)                                  CFT032
     D                                     PREFIX(C_)                                         CFT032
     D TranInThiA    E DS                  EXTNAME(FTOPY4PD)                    CFT014
                                                                                CFT014
      ** Payment Extension Details layout                                       CFT014
     D TranInPrmB    E DS                  EXTNAME(FTOPY1APD)                   CFT014
                                                                                CFT014
      ** Valid Outgoing Payments Extension File                                 CFT014
     D ValidPmtX     E DS                  EXTNAME(FTVOPY2PD)                   CFT014
 
     D ExtData       E DS                  EXTNAME(FTOPEXPD)
      * FT (OPAY) Extra Data - File (D/B) format
 
      * Valid Payments layout
     D ValidPmnt     E DS                  EXTNAME(FTVOPAYPD)
 
      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY2PD)
 
      ** Dummy DS so that parameter passed to FTVXVXV will not contain garbage                219131
     D OKFlagsDS2    E DS                  EXTNAME(FTEOPY3PD) PREFIX(DMY:3)                   219131
                                                                                              219131
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
     D  QQCDR1       E                     EXTFLD(@CDRQQ)                                     CGL029
     D/COPY WNCPYSRC,FTH00014
 
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
     D PMode           S              6A                                                    MD021318
     D/COPY WNCPYSRC,FTH00284
                                                                                CFT014
      ** Program message queue                                                  CFT014
     D WPrgQ           S             10A                                        CFT014
     D/COPY WNCPYSRC,FTH00248
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
 
      * Call Validation Modules in Sequence
 
      ** Validate Bank Operation Code                                           CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   ExSr      SrBnkOpCde                                   CFT014
                                                                                CFT014
      ** Validate Transaction Type Code                                         CFT014
                                                                                CFT014
     C                   ExSr      SrTrnTpCde                                   CFT014
     C                   Endif                                                  CFT014
      ***Validate*Transfer*Commission*Tariff***************************         CFT014
     C***********        Exsr      VTRFCTF                                      CFT014
 
      **Validate*Charges*to*the*Debit*of*******************************         CFT014
     C***********        Exsr      VDBTCC                                       CFT014
 
      *  Validate Receiver's Correspondent
     C/COPY WNCPYSRC,FTH00015
     C                   Exsr      VRCVCOR
     C/COPY WNCPYSRC,FTH00016
                                                                                CFT014
      ** Validate Third Reimbursement Institutions                              CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   ExSr      SrTrdReIns                                   CFT014
     C                   EndIf                                                  CFT014
 
      *  Validate Account with Institution
     C                   Exsr      VACCBNK
                                                                                CFT014
      ** Validate Intermediary Bank                                             CFT014
                                                                                CFT014
     C                   ExSr      SrIntBnk                                     CFT014
 
      *  Validate Beneficiary
     C                   Exsr      VBENFCY
 
      ***Validate*Details*Of*Payment***********************************         CFT014
     C***********        Exsr      VDETPAY                                      CFT014
 
      ***Validate*Bank*To*Bank*Information*****************************         CFT014
     C***********        Exsr      VBKTOBK                                      CFT014
 
      *  Cross validations
     C                   If        Idx = 0
     C                   Exsr      VXVAL
     C                   End
     C/COPY WNCPYSRC,FTH00495
 
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
      ***VTRFCTF**-*Validate*Transfer*Commission*Tariff****************         CFT014
      *****************************************************************         CFT014
     C*****VTRFCTF       BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      ***Validate******************************************************         CFT014
     C***********        CALLB     'FTVTFTA'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInPrim                     CFT014
     C***********        Parm                    TranInSecA                     CFT014
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
     C*/EJECT****                                                               CFT014
      *****************************************************************         CFT014
      ***VDBTCC**-*Charges*to*the*Debit*of*****************************         CFT014
      *****************************************************************         CFT014
     C*****VDBTCC        BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      ***Validate******************************************************         CFT014
     C***********        CALLB     'FTVCSRF'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInPrim                     CFT014
     C***********        Parm                    TranInSecA                     CFT014
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
     C*/EJECT****                                                               CFT014
      *****************************************************************
      ** VRCVCOR  - Validate Receiver's Correspondent
      *****************************************************************
     C     VRCVCOR       BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      ** Validate
     C                   CALLB     'FTVRVCR'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut
 
      *  Screen fields
     C                   Parm                    TranInSecA
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      ** Screen Input Function                                                              MD021318
     C                   PARM                    PMode                                      MD021318
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
     C/COPY WNCPYSRC,FTH00017
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VACCBNK  - Validate Account with Bank
      *****************************************************************
     C     VACCBNK       BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
     C/COPY WNCPYSRC,FTH00249
 
      ** Validate
     C                   CALLB     'FTVACBA'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut
 
      *  Screen fields
     C                   Parm                    TranInPrim                     CFT014
     C                   Parm                    TranInSecA
     C                   Parm                    TranInSecB                     CFT014
     C                   Parm      'FTOPAY2VL'   WPrgQ                          CFT014
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      ** Screen Input Function                                                              MD021318
     C                   PARM                    PMode                                      MD021318
 
     C/COPY WNCPYSRC,FTH00250
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *****************************************************************
      ** VBENFCY  - Validate Beneficiary
      *****************************************************************
     C     VBENFCY       BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
     C/COPY WNCPYSRC,FTOPA2VC01
      ** Validate
     C                   CALLB     'FTVBEBE'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut
 
      *  Screen fields
     C                   Parm                    TranInSecA
     C                   Parm                    TranInSecB
     C**********         Parm                    TranInSecC                          CFT032 BUG14042
     C                   Parm                    TranInPrim                                 BUG14042
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtXAr
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      ** Screen Input Function                                                              MD021318
     C                   PARM                    PMode                                      MD021318
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************         CFT014
      ***VDETPAY*-*Validate*Details*of*Payment*************************         CFT014
      *****************************************************************         CFT014
     C*****VDETPAY       BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      ***Validate******************************************************         CFT014
     C***********        CALLB     'FTVDEPY'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInPrim                     CFT014
     C***********        Parm                    TranInSecB                     CFT014
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
     C*/EJECT****                                                               CFT014
      *****************************************************************         CFT014
      ***VBKTOBK**-*Validate*Bank*to*Bank******************************         CFT014
      *****************************************************************         CFT014
     C*****VBKTOBK       BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      **Validate*******************************************************         CFT014
     C***********        CALLB     'FTVTOBK'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInPrim                     CFT014
     C***********        Parm                    TranInSecB                     CFT014
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
     C*/EJECT****                                                               CFT014
      *****************************************************************
      ** VXVAL   - Validate Cross Validations
      *****************************************************************
     C     VXVAL         BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      * Validate
     C                   CALLB     'FTVXVXV'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut
 
      *  Screen fields
     C                   Parm                    TranInPrim
     C                   Parm                    TranInPrmB                                 BUG26775
     C***********        Parm                    TranInSecA                     CFT014
     C                   Parm                    TranInSecA                                   251758
     C                   Parm                    TranInSecB
     C                   Parm                    TranInThiA                     CFT014
     C                   Parm      'FTOPAY2VL'   WPrgQ                          CFT014
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
      *  OK Flags
     C                   Parm                    OKFlagsDS
     C                   Parm                    OKFlagsDS2                                   219131
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
 
     C                   ENDSR
      *****************************************************************         CFT014
      /Title Sr/SrBnkOpCde                                                      CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SrBnkOpCde  - Bank Operation Code Validation                 *         CFT014
      *                                                               *         CFT014
      *  Called By: Main Processing                                   *         CFT014
      *                                                               *         CFT014
      *  Calls:                                                       *         CFT014
      *  RESETERRS  - Resets variables updated by each modules        *         CFT014
      *  FTVBOCD    - Bank Operation Code Validation Module           *         CFT014
      *  UPDATERRS  - Updates error information                       *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrBnkOpCde    BegSr                                                  CFT014
                                                                                CFT014
      ** Reset variables updated by other modules                               CFT014
                                                                                CFT014
     C                   ExSr      ResetErrs                                    CFT014
                                                                                CFT014
      ** Validate Bank Operation Code entry                                     CFT014
                                                                                CFT014
     C                   CallB     'FTVBOCD'                                    CFT014
     C                   Parm                    ReTCodeOut                     CFT014
     C                   Parm                    TranInSecA                     CFT014
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
      /Title Sr/SrTrnTpCde                                                      CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SrTrnTpCde  - Transaction Type Code Validation               *         CFT014
      *                                                               *         CFT014
      *  Called By: Main Processing                                   *         CFT014
      *                                                               *         CFT014
      *  Calls:                                                       *         CFT014
      *  RESETERRS  - Resets variables updated by each modules        *         CFT014
      *  FTVTTCD    - Transaction Type Code Validation Module         *         CFT014
      *  UPDATERRS  - Updates error information                       *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrTrnTpCde    BegSr                                                  CFT014
                                                                                CFT014
      ** Reset variables updated by other modules                               CFT014
                                                                                CFT014
     C                   ExSr      ResetErrs                                    CFT014
                                                                                CFT014
      ** Validate Transaction Type Code entry                                   CFT014
                                                                                CFT014
     C                   CallB     'FTVTTCD'                                    CFT014
     C                   Parm                    ReTCodeOut                     CFT014
     C                   Parm                    TranInSecA                     CFT014
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
      /Title Sr/SrTrdReIns                                                      CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SrTrdReIns  - Third Reimbursement Institution Validation     *         CFT014
      *                                                               *         CFT014
      *  Called By: Main Processing                                   *         CFT014
      *                                                               *         CFT014
      *  Calls:                                                       *         CFT014
      *  RESETERRS  - Resets variables updated by each modules        *         CFT014
      *  FTVTRIB    - Third Reimbursement Institution Validation Mod. *         CFT014
      *  UPDATERRS  - Updates error information                       *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrTrdReIns    BegSr                                                  CFT014
                                                                                CFT014
      ** Reset variables updated by other modules                               CFT014
                                                                                CFT014
     C                   ExSr      ResetErrs                                    CFT014
                                                                                CFT014
      ** Validate Third Reimbursement Ins. entries                              CFT014
                                                                                CFT014
     C                   CallB     'FTVTRIB'                                    CFT014
     C                   Parm                    ReTCodeOut                     CFT014
     C                   Parm                    TranInPrim                     CFT014
     C                   Parm                    TranInSecA                     CFT014
     C                   Parm                    FldNamXAr                      CFT014
     C                   Parm                    MsgIDXAr                       CFT014
     C                   Parm                    MsgDtaXAr                      CFT014
     C                   Parm                    WFldNmXAr                      CFT014
     C                   Parm                    WMsgIDXAr                      CFT014
     C                   Parm                    WMsgDtXAr                      CFT014
     C                   Parm                    OKFlagsDS                      CFT014
     C                   Parm                    Val@Fields                     CFT014
     C                   PARM                    PMode                                      MD021318
                                                                                CFT014
      ** Update error info with that retured from the validation module         CFT014
                                                                                CFT014
     C                   ExSr      UpdatErrs                                    CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SrIntBnk                                                        CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SrIntBnk    - Intermediary Bank Validation                   *         CFT014
      *                                                               *         CFT014
      *  Called By: Main Processing                                   *         CFT014
      *                                                               *         CFT014
      *  Calls:                                                       *         CFT014
      *  RESETERRS  - Resets variables updated by each modules        *         CFT014
      *  FTVIYBK    - Intermediary Bank Validation Module             *         CFT014
      *  UPDATERRS  - Updates error information                       *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrIntBnk      BegSr                                                  CFT014
                                                                                CFT014
      ** Reset variables updated by other modules                               CFT014
                                                                                CFT014
     C                   ExSr      ResetErrs                                    CFT014
                                                                                CFT014
      ** Validate Intermediary Bank entries                                     CFT014
                                                                                CFT014
     C                   CallB     'FTVIYBK'                                    CFT014
     C                   Parm                    ReTCodeOut                     CFT014
     C                   Parm                    TranInPrim                     CFT014
     C                   Parm                    TranInSecA                     CFT014
     C                   Parm                    TranInSecB                     CFT014
     C                   Parm      'FTOPAY2VL'   WPrgQ                          CFT014
     C                   Parm                    FldNamXAr                      CFT014
     C                   Parm                    MsgIDXAr                       CFT014
     C                   Parm                    MsgDtaXAr                      CFT014
     C                   Parm                    WFldNmXAr                      CFT014
     C                   Parm                    WMsgIDXAr                      CFT014
     C                   Parm                    WMsgDtXAr                      CFT014
     C                   Parm                    OKFlagsDS                      CFT014
     C                   Parm                    Val@Fields                     CFT014
     C                   PARM                    PMode                                      MD021318
                                                                                CFT014
      ** Update error info with that returned from the validation module        CFT014
                                                                                CFT014
     C                   ExSr      UpdatErrs                                    CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
      * Level 2 Valid Indicator
     C                   Eval      OTLVL2 = 'Y'
 
      ** Bank Operation Code                                                    CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   Eval      O2BOCD = SBOCD                               CFT014
                                                                                CFT014
      ** Transaction Type Code                                                  CFT014
                                                                                CFT014
     C                   Eval      O2TTCD = STRTC                               CFT014
     C                   EndIf                                                  CFT014
      **Transfer*Commission*Tariff*************************************         CFT014
     C***********        Eval      OTTRCT = STRCT                               CFT014
 
      **Charges*to*Bebit*of*Branch*/*Type*/*Value**********************         CFT014
     C***********        Eval      OTCDBR = SCDBR                               CFT014
     C***********        Eval      OTCDRT = @CDRT                               CFT014
     C***********        Eval      OTCDRO = @CDRO                               CFT014
                                                                                CFT014
      ** Third Reimbursement Institutions                                       CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   Eval      O2TRIT = @TRIT                               CFT014
     C                   Eval      O2TRI1 = STRI1                               CFT014
     C                   Eval      O2TRI2 = STRI2                               CFT014
     C                   Eval      O2TRI3 = STRI3                               CFT014
     C                   Eval      O2TRI4 = STRI4                               CFT014
     C                   Eval      O2TRI5 = STRI5                               CFT014
     C                   EndIf                                                  CFT014
 
      * Receiver's Correspondent
     C                   Eval      OTRCRT = @RCRT
     C                   Eval      OTRCO1 = SRCO1
     C                   Eval      OTRCO2 = SRCO2
     C                   Eval      OTRCO3 = SRCO3
     C                   Eval      OTRCO4 = SRCO4
     C                   Eval      OTRCO5 = SRCO5
                                                                                CFT014
      ** Intermediary Bank                                                      CFT014
                                                                                CFT014
     C                   Eval      OTINBT = @INBT                               CFT014
     C                   Eval      OTINB1 = SINB1                               CFT014
     C                   Eval      OTINB2 = SINB2                               CFT014
     C                   Eval      OTINB3 = SINB3                               CFT014
     C                   Eval      OTINB4 = SINB4                               CFT014
     C                   Eval      OTINB5 = SINB5                               CFT014
     C
      * Account with Bank
     C                   Eval      OTACBT = @ACBT
     C                   Eval      OTACB1 = SACB1
     C                   Eval      OTACB2 = SACB2
     C                   Eval      OTACB3 = SACB3
     C                   Eval      OTACB4 = SACB4
     C                   Eval      OTACB5 = SACB5
     C
      * Beneficiary
     C                   Eval      OTBNCT = @BNCT
     C                   Eval      OTBNC1 = SBNC1
     C                   Eval      OTBNC2 = SBNC2
     C                   Eval      OTBNC3 = SBNC3
     C                   Eval      OTBNC4 = SBNC4
     C                   Eval      OTBNC5 = SBNC5
 
      ***Details*of*Payment********************************************                       CFT014
     C***********        Eval      OTDTP1 = SDTP1                                             CFT014
     C***********        Eval      OTDTP2 = SDTP2                                             CFT014
     C***********        Eval      OTDTP3 = SDTP3                                             CFT014
     C***********        Eval      OTDTP4 = SDTP4                                             CFT014
 
      ***Sender*to*Receiver*information********************************                       CFT014
     C***********        Eval      OTBBI1 = SBBI1                                             CFT014
     C***********        Eval      OTBBI2 = SBBI2                                             CFT014
     C***********        Eval      OTBBI3 = SBBI3                                             CFT014
     C***********        Eval      OTBBI4 = SBBI4                                             CFT014
     C***********        Eval      OTBBI5 = SBBI5                                             CFT014
     C***********        Eval      OTBBI6 = SBBI6                                             CFT014
 
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
     C                   PARM                    TranInPrmB                     CFT014
     C                   PARM                    TranInThiA                     CFT014
 
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
      ** Screen Input Function                                                              MD021318
     C                   PARM                    PMode                                      MD021318
 
      ***Set*up*the*name*of the MSGF from which the message handler will        CFT007
      ****get*the*messages                                                      CFT007
     C*******************EVAL      #MsgFile = 'DRSMM'                           CFT007
      ** Set up the name of the primary and secondary message files from        CFT007
      ** which the message handler will get the messages                        CFT007
     C                   EVAL      #MsgFile     = 'FTUSRMSG'                    CFT007
     C                   EVAL      MsgFArray(1) = 'DRSMM'                       CFT007
     C/COPY WNCPYSRC,FTH00018
 
      ** =================================================================
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