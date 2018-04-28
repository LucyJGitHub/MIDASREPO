     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Account other details validation')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD5VL -  Account Other Details Validation                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24157           Date 04Jun09               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG4067            Date 17Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4481            Date 06Oct04               *
      *                 BUG4067            Date 26Aug04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CUT009             Date 19Feb01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 12Nov99               *
      *                 CPB001             Date 23Aug99               *
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
      *             when field is set to Y                            *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  BUG4067 - PM Instrument code should be validated when the    *
      *            PM Module is switched on.                          *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4481 - Reverse fix for BUG4067 to avoid problem in        *
      *            Accounts Maintenance.                              *
      *  BUG4067 - Do not allow attachment of facility to an account  *
      *            with account code that has a blank PM Instrument   *
      *            code.                                              *
      *  CLE025 - Credit Lines                                        *
      *  CGL029 - Increase Account Code to 10 digits                  *
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
 
      ** BRT Customer Details
     FSDCBRTL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Customer Group Codes
     FTABLEV4   IF   E             DISK    INFSR(*PSSR)
 
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
 
      ** Client Group Code
     D GRP             S              1    DIM(8)
      ** Account Commission Indicators
     D AIN1            S              1    DIM(8)
      ** Max. Dr. Balance Commission Indicators
     D AIN2            S              1    DIM(8)
      ** Debit Interest Commission Indicators
     D AIN3            S              1    DIM(8)
      ** Inactive Commission Indicators
     D AIN4            S              1    DIM(8)
      ** Minimum Balance Indicators
     D AIN5            S              1    DIM(8)
      ** Daily Statement Commission Indicators
     D AIN6            S              1    DIM(8)
      ** Fixed Commission Indicators
     D AIN7            S              1    DIM(8)
 
      ** DATA STRUCTURE TO GET THE RIGHT CUSTOMER GROUP
     D                 DS
     D  ZZ010                  1     10
     D  CGRP                  10     10
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDMINBOK                      1A
     D  DDBRTCAOK                     1A
     D  DDFACTOK                      1A
     D  DDFCNOOK                      1A
     D  DDEFACOK                      1A
     D  DDINAIOK                      1A
     D  DDBRLIOK                      1A
     D  DDBADIOK                      1A
     D  DDPTRAOK                      1A
     D  DDPRCHOK                      1A
     D  DDPBKUOK                      1A
     D  DDFCCUOK                      1A                                                      CLE025
     D**DDK24COK                      1A                                             CER047 BUG24157
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D ValidAccn     E DS                  EXTNAME(GLVAMADPD)
      * Valid Account layout -> ACCNTAB
 
     D ValidExRI     E DS                  EXTNAME(GLVAMRIPD)
     D GLRIACOD      E                     EXTFLD(QQACOD)                                     CGL029
      * Valid Account layout -> REIACD
 
     D ValidExPW     E DS                  EXTNAME(GLVAMPWPD)
     D GLPWACOD      E                     EXTFLD(QQACOD)                                     CGL029
      * Valid Account layout -> REAPWDPD
 
     D TranIn5       E DS                  EXTNAME(GLAMODPD)
      * Incoming Transaction (screen 5)
 
     D TranIn1       E DS                  EXTNAME(GLAMADPD)
      * Incoming Transaction (screen 1)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
     D Idx1            S              3P 0
 
     D CLE025          S              1                                                       CLE025
     D PRTCD           S              7                                                       CLE025
     D POPTN           S              7                                                       CLE025
     D PSARD           S              6                                                       CLE025
     D PCUST           S             10                                                       CLE025
     D PKYST           S              7                                                       CLE025
                                                                                              CLE025
     D CER047          S              1A                                                      CER047
      ** Array of fields in warning                                                           CER047
     D WFldNamXAr      S             10A   DIM(XArrayMax)                                     CER047
                                                                                              CER047
      ** Array of warning message IDs                                                         CER047
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        CER047
                                                                                              CER047
      ** Array of warning message data.                                                       CER047
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)                      CER047
                                                                                              CER047
      ** Index for arrays of warning message ids etc                                          CER047
     D WIdx            S              3P 0                                                    CER047
                                                                                              CER047
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
 
     C                   EXSR      SRINIT
      *
      * Call Validation Modules in Sequence
 
      ** Validate Minimum Balance
      /COPY WNCPYSRC,GLAMAD5V01                                                               CUT009
     C                   EXSR      VMINBAL
      /COPY WNCPYSRC,GLAMAD5V02                                                               CUT009
      *
     C     S01383        IFEQ      'Y'
     C     *IN19         ANDEQ     *ON
      ** Validate BRT Category
      /COPY WNCPYSRC,GLAMAD5V03                                                               CUT009
     C                   EXSR      VBSTX
      /COPY WNCPYSRC,GLAMAD5V04                                                               CUT009
     C                   ENDIF
      *
      ** Validate Facility Type, Number and Encashment
      /COPY WNCPYSRC,GLAMAD5V05                                                               CUT009
     C                   EXSR      VFCLTY
      /COPY WNCPYSRC,GLAMAD5V06                                                               CUT009
      ** Validate Inactive Account Flag
      /COPY WNCPYSRC,GLAMAD5V07                                                               CUT009
     C                   EXSR      VINAIFLG
      /COPY WNCPYSRC,GLAMAD5V08                                                               CUT009
      ** Validate Bankrupt/Liquidated Flag
      /COPY WNCPYSRC,GLAMAD5V09                                                               CUT009
     C                   EXSR      VBPIN
      /COPY WNCPYSRC,GLAMAD5V10                                                               CUT009
      ** Validate Bad Debt Flag
      /COPY WNCPYSRC,GLAMAD5V11                                                               CUT009
     C                   EXSR      VBDDB
      /COPY WNCPYSRC,GLAMAD5V12                                                               CUT009
      ** Validate Print Trans Advice Flag
      /COPY WNCPYSRC,GLAMAD5V13                                                               CUT009
     C                   EXSR      VPTRAFLG
      /COPY WNCPYSRC,GLAMAD5V14                                                               CUT009
      ** Validate Print Rate Chg Advice Flag
      /COPY WNCPYSRC,GLAMAD5V15                                                               CUT009
     C                   EXSR      VPRCHFLG
      /COPY WNCPYSRC,GLAMAD5V16                                                               CUT009
      ** Validate Passbook Used on A/C Flag
      /COPY WNCPYSRC,GLAMAD5V17                                                               CUT009
     C                   EXSR      VPBKUFLG
      /COPY WNCPYSRC,GLAMAD5V18                                                               CUT009
      **********                                                                     CER047 BUG24157
      ***Validate KWG @24c reporting                                                 CER047 BUG24157
      **********                                                                     CER047 BUG24157
     C**********         IF        CER047 = 'Y'                                      CER047 BUG24157
     C**********         EXSR      SRVK24C                                           CER047 BUG24157
     C**********         ENDIF                                                       CER047 BUG24157
      *
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
      *****************************************************************
      ** VMINBAL - Validate Minimum Balance
      *****************************************************************
     C     VMINBAL       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVMMBL'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDMINB
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   Parm                    AMMINB
      *
      ** Minimum Balance - Ok
     C                   Parm                    DDMINBOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  VBSTX   - Validate Base Rate Tax Category
      *****************************************************************
     C     VBSTX         BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVBSTX'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDBRTCA
      *
      ** ICD
     C                   Parm                    ACHLRT
     C                   Parm                    H1BRTL
     C                   Parm                    H2BRTL
     C                   Parm                    H3BRTL
     C                   Parm                    H4BRTL
     C                   Parm                    H5BRTL
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** BRT Category - Ok
     C                   Parm                    DDBRTCAOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VFCLTY - Validate Facility Type, Number & Encashment
      *****************************************************************
     C     VFCLTY        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVFCTY'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDFACT
     C                   Parm                    DDFCNO
     C                   Parm                    DDEFAC
     C                   Parm                    DDCUSN
     C                   Parm                    DDFCCU                                       CLE025
     C**********         Parm                    DDACOD                              BUG4067 BUG4481
     C                   Parm                    DDACOD                                      BUG4067
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Facility Customer - Ok                                                               CLE025
      ** Facility Type - Ok
      ** Facility No. - Ok
      ** Encashment Facility - Ok
     C                   Parm                    DDFCCUOk                                     CLE025
     C                   Parm                    DDFACTOk
     C                   Parm                    DDFCNOOk
     C                   Parm                    DDEFACOk
      *
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  VINAIFLG - Validate Inactive Account Flag
      *****************************************************************
     C     VINAIFLG      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVIAIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDINAI
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Inactive Account Y/N - Ok
     C                   Parm                    DDINAIOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBPIN    - Validate Bankrupt/Liquidated Flag
      *****************************************************************
     C     VBPIN         BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVBPIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDBRLI
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Bankrupt/Liquidated Y/N - Ok
     C                   Parm                    DDBRLIOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBDDB    - Validate Bad Debt Flag
      *****************************************************************
     C     VBDDB         BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVBDDB'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDBADI
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Bad Debt Y/N - Ok
     C                   Parm                    DDBADIOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPTRAFLG - Validate Print Trans Advice Flag
      *****************************************************************
     C     VPTRAFLG      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVPRAI'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDPTRA
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Print Trans. Advice Y/N - Ok
     C                   Parm                    DDPTRAOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPRCHFLG - Validate Print Rate Chg Advice Flag
      *****************************************************************
     C     VPRCHFLG      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVPIIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDPRCH
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Print Rate Chg. Advice Y/N - Ok
     C                   Parm                    DDPRCHOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPBKUFLG - Validate Passbook Used on A/C Flag
      *****************************************************************
     C     VPBKUFLG      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVPKIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDPBKU
      *
      ** ICD
     C                   Parm                    CRT001
     C                   Parm                    CRT002
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Passbook Used on A/C Y/N - Ok
     C                   Parm                    DDPBKUOk
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      /COPY WNCPYSRC,GLAMAD5V19                                                               CUT009
      *****************************************************************
     C/EJECT
      *****************************************************************              CER047 BUG24157
      ***SRVK24C - Validate KWG §24c reporting                                       CER047 BUG24157
      *****************************************************************              CER047 BUG24157
     C*****SRVK24C       BEGSR                                                       CER047 BUG24157
      **********                                                                     CER047 BUG24157
      **Reset*variables updated by each module                                       CER047 BUG24157
      **********                                                                     CER047 BUG24157
     C**********         EXSR      RESETERRS                                         CER047 BUG24157
      **********                                                                     CER047 BUG24157
     C**********         CALLB     'GLVK24C'                                         CER047 BUG24157
      ***Return*Code                                                                 CER047 BUG24157
     C**********         PARM                    RetCodeOut                          CER047 BUG24157
      ***KWG*§24c reporting field                                                    CER047 BUG24157
     C**********         PARM                    DDK24C                              CER047 BUG24157
      ***Customer Number                                                             CER047 BUG24157
     C**********         PARM                    DDCUSN                              CER047 BUG24157
      **Error*fields/message IDs/message data (arrays) from/to caller                CER047 BUG24157
     C**********         PARM                    FldNamXAr                           CER047 BUG24157
     C**********         PARM                    MsgIDXAr                            CER047 BUG24157
     C**********         PARM                    MsgDtaXAr                           CER047 BUG24157
      **Warning*fields/message IDs/message data (arrays) from/to caller              CER047 BUG24157
     C**********         PARM                    WFldNamXAr                          CER047 BUG24157
     C**********         PARM                    WMsgIDXAr                           CER047 BUG24157
     C**********         PARM                    WMsgDtaXAr                          CER047 BUG24157
      **KWG*§24c reporting Y/N - Ok Flag                                             CER047 BUG24157
     C**********         PARM                    DDK24COK                            CER047 BUG24157
      **********                                                                     CER047 BUG24157
      **Update*error info with that returned from the validation module              CER047 BUG24157
      **********                                                                     CER047 BUG24157
     C**********         EXSR      UPDATERRS                                         CER047 BUG24157
      **********                                                                     CER047 BUG24157
     C**********         ENDSR                                                       CER047 BUG24157
      *****************************************************************              CER047 BUG24157
     C***/EJECT                                                                      CER047 BUG24157
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
     C                   MOVE      DDBRTCA       AMBRTCA
                                                                                              CLE025
      ** Facility Customer                                                                    CLE025
                                                                                              CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
                                                                                              CLE025
     C                   IF        DDFCCU = *BLANKS                                           CLE025
     C**********         EVAL      AMFCCU = *ZERO                                      CLE025 CSD027
     C                   EVAL      AMFCCU = *BLANKS                                           CSD027
                                                                                              CLE025
     C                   ELSE                                                                 CLE025
     C                   CALLB     'AOCUSTR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*KEY   '     POPTN                                        CLE025
     C                   PARM      DDFCCU        PCUST                                        CLE025
     C                   PARM      *BLANKS       PKYST                                        CLE025
     C     SDCUST        PARM      SDCUST        DSSDY                                        CLE025
                                                                                              CLE025
     C                   IF        PRTCD <> *BLANKS                                           CLE025
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        CLE025
     C                   EVAL      DBKEY = DDFCCU                                             CLE025
     C                   EVAL      DBASE = 5                                                  CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ELSE                                                                 CLE025
     C                   MOVE      BBCUST        AMFCCU                                       CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   ENDIF                                                                CLE025
     C                   ENDIF                                                                CLE025
      *
     C     DDFACT        IFEQ      *BLANKS
     C                   Z-Add     0             AMFACT
     C                   ELSE
     C                   MOVE      DDFACT        AMFACT
     C                   ENDIF
      *
     C     DDFCNO        IFEQ      *BLANKS
     C                   MOVE      *Zeros        AMFCNO
     C                   ELSE
     C                   MOVE      DDFCNO        AMFCNO
     C                   ENDIF
      *
     C     DDEFAC        IFEQ      *BLANKS
     C                   MOVE      *ZEROS        AMEFAC
     C                   ELSE
     C                   MOVE      DDEFAC        AMEFAC
     C                   ENDIF
      *
     C     DDINAI        IFEQ      'Y'
     C                   BITON     '4'           AMRETB
     C                   ELSE
     C                   BITOFF    '4'           AMRETB
     C                   ENDIF
      *
     C     DDBRLI        IFEQ      'Y'
     C                   BITON     '6'           AMRETB
     C                   ELSE
     C                   BITOFF    '6'           AMRETB
     C                   ENDIF
      *
     C     DDBADI        IFEQ      'Y'
     C                   BITON     '7'           AMRETB
     C                   ELSE
     C                   BITOFF    '7'           AMRETB
     C                   ENDIF
      *
     C                   MOVE      DDPTRA        RIPTRA
     C                   MOVE      DDPRCH        RIPRCH
      *
      **  If Retail Teller System (CRT001) SAR is installed
      **  or Retail Branch Access (CRT002) SAR is installed
      *
     C     CRT001        IFEQ      'Y'
     C     CRT002        OREQ      'Y'
     C                   MOVE      DDPBKU        RIPBKU
     C                   ENDIF
      *
      **  If Password on Retail Savings Account (CRT101) SAR is ON
      *
     C     CRT101        IFEQ      'Y'
     C     CRT001        ANDEQ     'Y'
     C     AMATYP        ANDEQ     'R'
     C     AMSTYP        ANDEQ     'S'
     C                   MOVE      DDPSWD        PWPSWD
     C     DDACTN        IFEQ      'I'
     C                   Move      DDCUSN        PWCNUM
     C                   Move      DDCCY         PWCCY
     C                   Move      DDACOD        PWACOD
     C                   Move      DDACSQ        PWACSQ
     C                   Move      DDBRCA        PWBRCA
     C                   ENDIF
     C                   ENDIF
      **********                                                                     CER047 BUG24157
      ***KWG*@24c reporting                                                          CER047 BUG24157
      **********                                                                     CER047 BUG24157
     C**********         IF        CER047 = 'Y'                                      CER047 BUG24157
     C**********         EVAL      AMK24C = DDK24C                                   CER047 BUG24157
     C**********         ENDIF                                                       CER047 BUG24157
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINIT - Process Initialisation                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Check if BRT SAR Installed.
     C                   MOVE      *OFF          *IN19
     C**********         MOVE      DDCUSN        WCNUM6            6 0                        CSD027
     C                   MOVE      DDCUSN        WCNUM6            6                          CSD027
     C     S01383        IFEQ      'Y'
     C     WCNUM6        CHAIN     SDCBRTL1                           89
     C     *IN89         IFEQ      *OFF
     C     XRECI         ANDEQ     'D'
     C                   MOVE      *ON           *IN19
     C                   ENDIF
     C                   ENDIF
      *
      ** ACCESS CUSTOMER GROUP IN SDCUSTPD
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCUSN        @CNUM            10
     C                   PARM      *Blanks       @CNST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Movel     *Blanks       FldNamXAr(1)
     C                   Movel     'RE71450'     MsgIDXAr(1)
     C                   ELSE
     C                   MOVE      BBCUST        DDCUSN
     C                   ENDIF
      *
     C     BBCGRP        IFEQ      *BLANK
     C                   MOVEL     '1'           BBCGRP
     C                   ENDIF
      *
      ** CHECK IF CUSTOMER GROUP IS OK
     C                   Z-ADD     1             IDX1
     C     BBCGRP        LOOKUP    GRP(Idx1)                              10
     C*
     C     *IN10         IFNE      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   Z-Add     6             DBASE
     C                   MOVEL     DDCUSN        DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   ENDIF
      *
     C                   Move      AIN1(Idx1)    WACMI             1
     C                   Move      AIN2(Idx1)    WMDBI             1
     C                   Move      AIN3(Idx1)    WDINI             1
     C                   Move      AIN4(Idx1)    WINAI             1
     C                   Move      AIN5(Idx1)    WMINI             1
     C                   Move      AIN6(Idx1)    WDYSI             1
     C                   Move      AIN7(Idx1)    WFIXI             1
      *
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
     C                   PARM                    TranIn5
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
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
     C                   PARM                    ValidAccn
     C                   PARM                    ValidExRI
     C                   PARM                    ValidExPW
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLAMAD5VL'   DBPGM
     C                   OUT       LDA
      *
      ** Access SAR file to determine if CRT001 is present.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     'CRT001'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   ENDIF
      *
     C                   MOVEL     'N'           CRT001            1
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT001
     C                   ENDIF
      *
      ** Access SAR file to determine if CRT002 is present.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     'CRT002'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   ENDIF
      *
     C                   MOVEL     'N'           CRT002            1
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT002
     C                   ENDIF
      *
      ** Access SAR file to determine if CRT101 is present.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT101'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     'CRT101'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   ENDIF
      *
     C                   MOVEL     'N'           CRT101            1
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT101
     C                   ENDIF
      *
      ** Access SAR file to determine if S01383 is present.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     4             DBASE
     C                   MOVEL     'S01383'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   ENDIF
      *
     C                   MOVEL     'N'           S01383            1
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383
     C                   ENDIF
                                                                                              CLE025
      ** Check if enhancement CLE025 (Multi-Option Facilities) is on                          CLE025
                                                                                              CLE025
     C                   CALLB     'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CLE025
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE025
     C                   EVAL      DBKEY = 'CLE025'                                           CLE025
     C                   EVAL      DBASE = 7                                                  CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
      *
      ** READ UP TO EIGHT GROUP RECORDS AND STORE RELEVANT DETAILS
      ** IN INTERNAL ARRAYS
      *
     C                   Z-ADD     0             IDX1
     C                   Move      *Off          *IN10
     C     1             SETLL     TABLEV4F
      *
     C     *IN10         DOUEQ     *On
     C                   READ      TABLEV4F                               10
     C     *IN10         IFEQ      *Off
     C                   ADD       1             Idx1
     C                   MOVE      CGRP          GRP(Idx1)
     C                   MOVE      ACMI          AIN1(Idx1)
     C                   MOVE      MDBI          AIN2(Idx1)
     C                   MOVE      DINI          AIN3(Idx1)
     C                   MOVE      INAI          AIN4(Idx1)
     C                   MOVE      MINI          AIN5(Idx1)
     C                   MOVE      DYSI          AIN6(Idx1)
     C                   MOVE      FIXI          AIN7(Idx1)
      *
      ** ONLY EIGHT CUSTOMER GROUP ARE POSSIBLE
      *
     C     Idx1          IFEQ      8
     C                   MOVE      '1'           *IN10
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
 
      *                                                                                       CER047
      ** Check if enhancement CER047 is on                                                    CER047
      *                                                                                       CER047
     C                   CALLB     'AOSARDR0'                                                 CER047
     C                   PARM      *BLANKS       PRTCD                                        CER047
     C                   PARM      '*VERIFY'     POPTN                                        CER047
     C                   PARM      'CER047'      PSARD                                        CER047
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER047
                                                                                              CER047
     C                   If        PRTCD = *BLANKS                                            CER047
     C                   Eval      CER047 = 'Y'                                               CER047
     C                   Else                                                                 CER047
     C                   Eval      CER047 = 'N'                                               CER047
     C                   EndIf                                                                CER047
                                                                                              CER047
     C                   If        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CER047
     C     *LOCK         IN        LDA                                                        CER047
     C                   Eval      DBFILE = 'SCSARDPD'                                        CER047
     C                   Eval      DBKEY = 'CER047'                                           CER047
     C                   Eval      DBASE = 8                                                  CER047
     C                   OUT       LDA                                                        CER047
     C                   EXSR      *PSSR                                                      CER047
     C                   EndIf                                                                CER047
      *                                                                                       CER047
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
     C                   MOVEL     *BLANK        WFldNamXAr                                   CER047
     C                   MOVEL     *BLANK        WMsgIDXAr                                    CER047
     C                   MOVEL     *BLANK        WMsgDtaXAr                                   CER047
 
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
      ** Update warning fields/message IDs/message data (arrays)                              CER047
      *                                                                                       CER047
     C                   Z-ADD     1             I                                            CER047
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99                  CER047
     C     *IN99         IFEQ      '1'                                                        CER047
     C                   MOVEA     WFldNamXAr    WFlDNamArr(I)                                CER047
     C                   MOVEA     WMsgIDXAr     WMsgIdArr(I)                                 CER047
     C                   MOVEA     WMsgDtaXAr    WMsgDtaArr(I)                                CER047
     C                   ENDIF                                                                CER047
      *                                                                                       CER047
      ** Set Warning Index                                                                    CER047
      *                                                                                       CER047
     C                   Z-ADD     1             I                                            CER047
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99                  CER047
     C     I             SUB       1             WIdx                                         CER047
      *                                                                                       CER047
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
