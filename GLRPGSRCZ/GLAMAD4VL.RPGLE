     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Commissions and override details validn')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD4VL -  Commissions and Override Details Validation     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL165             Date 23Feb15               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
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
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 02Feb00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CUT009             Date 19Feb01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 12Nov99               *
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050  - Annualised Percentage Rate (Recompile)             *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165  - Dual Withholding Tax  (Recompile)                  *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER049 - Stamp Tax (Recompile)                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
      *             when field is set to Y (Recompile)                *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  208221 - Default Margin from Rate/Spread changes             *
      *  CDE002 - CCRM Revenue Analysis - Addition of Margin Int. Flds*
      *  CUT009 - Manual addition of core hooks.                      *
      *  CFT004 - Straight Through Processing Phase 2                 *
      *         - International Bank Account Numbers(Recompile Only)  *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

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
                                                                                              208221
      ** Array of Fields with warnings.                                                       208221
     D WFldNmXAr       S             10A   DIM(XArrayMax)                                     208221
                                                                                              208221
      ** Array of warning message IDs                                                         208221
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)                        208221
                                                                                              208221
      ** Array of warning message data.                                                       208221
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)                      208221
                                                                                              208221

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
     D  DDCEXAOK                      1A
     D  DDCEXBOK                      1A
     D  DDCEXCOK                      1A
     D  DDCEXDOK                      1A
     D  DDCEXEOK                      1A
     D  DDCEXFOK                      1A
     D  DDCEXGOK                      1A
     D  DDNOCCOK                      1A
     D  DDOVRDOK                      1A                                        CDE002
     D  DDDRMGOK                      1A                                        CDE002
     D  DDOVRCOK                      1A                                        CDE002
     D  DDCRMGOK                      1A                                        CDE002

     D RETABLE       E DS                  EXTNAME(TABTBRE)
      ** EXTERNAL DS FOR RETAIL TABLE FILE

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** EXTERNAL DS FOR CUSTOMER DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D ValidExCO     E DS                  EXTNAME(GLVAMCOPD)
      * Valid Account Layout -> RECOMD

     D ValidAcEx     E DS                  EXTNAME(GLVAMBXPD)                   CDE002
     D GLBXACOD      E                     EXTFLD(QQACOD)                              CDE002 CGL029
      * Valid Account Layout (Extension File)                                   CDE002
                                                                                CDE002
     D ValidAccn     E DS                  EXTNAME(GLVAMADPD)                   208221
     D GLADACOD      E                     EXTFLD(QQACOD)                              CDE002 CGL029
      * Valid Account Layout (Extension File)                                   208221
                                                                                208221
     D TranIn4       E DS                  EXTNAME(GLAMCOPD)
      * Incoming Transaction (screen 4)

     D TranIn1       E DS                  EXTNAME(GLAMADPD)
      * Incoming Transaction (screen 1)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

     D Idx1            S              2P 0 INZ(0)
                                                                                              208221
     D WIdx            S              3P 0                                                    208221

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

      ** Validate Highest OD Commission
      /COPY WNCPYSRC,GLAMAD4V01                                                               CUT009
     C                   EXSR      VHIODCOM
      /COPY WNCPYSRC,GLAMAD4V02                                                               CUT009
      ** Validate Turnover Commission
      /COPY WNCPYSRC,GLAMAD4V03                                                               CUT009
     C                   EXSR      VTURNCOM
      /COPY WNCPYSRC,GLAMAD4V04                                                               CUT009
      ** Validate Debit Interest Commission
      /COPY WNCPYSRC,GLAMAD4V05                                                               CUT009
     C                   EXSR      VDINTCOM
      /COPY WNCPYSRC,GLAMAD4V06                                                               CUT009
      ** Validate Commission on Inactive Account
      /COPY WNCPYSRC,GLAMAD4V07                                                               CUT009
     C                   EXSR      VINACCOM
      /COPY WNCPYSRC,GLAMAD4V08                                                               CUT009
      ** Validate Minimum Credit Balance Commission
      /COPY WNCPYSRC,GLAMAD4V09                                                               CUT009
     C                   EXSR      VMINCCOM
      /COPY WNCPYSRC,GLAMAD4V10                                                               CUT009
      ** Validate Extra Daily Statement Commission
      ** and No. of Copies Chargeable
      /COPY WNCPYSRC,GLAMAD4V11                                                               CUT009
     C                   EXSR      VSTMTCOM
      /COPY WNCPYSRC,GLAMAD4V12                                                               CUT009
      ** Validate Fixed Commission
      /COPY WNCPYSRC,GLAMAD4V13                                                               CUT009
     C                   EXSR      VFIXDCOM
      ** Validate Debit and Credit Interest Margins                             CDE002
     C                   IF        CDE002 = 'Y'                                 CDE002
     C                   EXSR      VDMGOVR                                      CDE002
     C                   EXSR      VCMGOVR                                      CDE002
     C                   ENDIF                                                  CDE002
      /COPY WNCPYSRC,GLAMAD4V14                                                               CUT009
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
      ** VHIODCOM -Validate Highest OD Commission
      *****************************************************************
     C     VHIODCOM      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVCMCM02'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDCEXA
     C                   Parm                    WMDBI
      *
      ** ICD
     C                   Parm                    CHOV
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   Parm      *BLANKS       XXCEXA           10
      *
      ** Highest OD Commission - Ok
     C                   Parm                    DDCEXAOk

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  VTURNCOM - Validate Turnover Commission
      *****************************************************************
     C     VTURNCOM      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVTUCM'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDCEXB
     C                   Parm                    WACMI
      *
      ** ICD
     C                   Parm                    CDTO
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   Parm      *BLANKS       XXCEXB           10
      *
      ** Highest Turnover Commission - Ok
     C                   Parm                    DDCEXBOk

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VDINTCOM - Validate Debit Interest Commission
      *****************************************************************
     C     VDINTCOM      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVDBIT01'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDCEXC
     C                   Parm                    WDINI
      *
      ** ICD
     C                   Parm                    CDRI
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   Parm      *BLANKS       XXCEXC           10
      *
      ** Highest Turnover Commission - Ok
     C                   Parm                    DDCEXCOk
      *

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  VINACCOM - Validate Commission on Inactive Account
      *****************************************************************
     C     VINACCOM      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVIACM'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDCEXD
     C                   Parm                    WINAI
      *
      ** ICD
     C                   Parm                    CINA
     C                   Parm                    A6NBDP
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   Parm      *BLANKS       XXCEXD            7
      *
      ** Highest Turnover Commission - Ok
     C                   Parm                    DDCEXDOk

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VMINCCOM - Validate Minimum Credit Balance Commission
      *****************************************************************
     C     VMINCCOM      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVMMCR'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDCEXE
     C                   Parm                    WMINI
      *
      ** ICD
     C                   Parm                    CMBL
     C                   Parm                    A6NBDP
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   Parm      *BLANKS       XXCEXE            7
      *
      ** Highest Turnover Commission - Ok
     C                   Parm                    DDCEXEOk

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VSTMTCOM - Validate Extra Daily Statement Commission and
      **            No. of Copies Chargeable
      *****************************************************************
     C     VSTMTCOM      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVSMCM'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDCEXF
     C                   Parm                    DDNOCC
     C                   Parm                    WDYSI
     C                   Parm                    DDENOC
     C                   Parm                    DDSTFQ
      *
      ** ICD
     C                   Parm                    CNDS
     C                   Parm                    A6NBDP
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   Parm      *BLANKS       XXCEXF            7
     C                   Parm      *ZERO         XXNOCC            3 0
      *
      ** Extra Daily Statement Comm. - Ok
      ** No. of Copies Chargeable - Ok
     C                   Parm                    DDCEXFOk
     C                   Parm                    DDNOCCOk

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VFIXDCOM - Validate Fixed Commission
      *****************************************************************
     C     VFIXDCOM      BEGSR

      * Reset variables updated by each module

     C                   EXSR      RESETERRS
      *
     C                   CALLB     'GLVCMCM01'
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeOut
      *
      ** Account Screen fields
     C                   Parm                    DDCEXG
     C                   Parm                    WFIXI
      *
      ** ICD
     C                   Parm                    FXAC
     C                   Parm                    A6NBDP
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
     C                   Parm      *BLANKS       XXCEXG            7
      *
      ** Fixed Commission - Ok
     C                   Parm                    DDCEXGOk

      * Update error info with that returned from the validation module

     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************         CDE002
      ** VDMGOVR - Validate Debit Interest Margin and Margin Override           CDE002
      *****************************************************************         CDE002
     C     VDMGOVR       BEGSR                                                  CDE002
                                                                                CDE002
      * Reset variables updated by each module                                  CDE002
                                                                                CDE002
     C                   EXSR      RESETERRS                                    CDE002
      *                                                                         CDE002
     C                   CALLB     'GLVXRMG'                                    CDE002
      * INPUTS                                                                  CDE002
      ** Return Code                                                            CDE002
     C                   Parm                    RetCodeOut                     CDE002
      ** Debit Margin Override                                                  CDE002
     C     BXOVRD        Parm                    DDOVRD            1            CDE002
      ** Debit Margin Rate                                                      CDE002
     C                   Parm                    DDDRMG                         CDE002
      ** Debit Margin Override Field Name                                       CDE002
     C                   Parm      'DDOVRD'      DDOVRDFLD        10            CDE002
      ** Debit Margin Rate Field Name                                           CDE002
     C                   Parm      'DDDRMG'      DDDRMGFLD        10            CDE002
      ** Action Code                                                            208221
     C                   Parm                    DDACTN                         208221
      ** Currency                                                               208221
     C                   Parm                    DDCCY                          208221
      ** Debit Base Rate                                                        208221
     C                   Parm                    AMDRIB                         208221
      ** Debit Rate/Spread                                                      208221
     C                   Parm                    AMDRIS                         208221
      *                                                                         CDE002
      ** OUTPUTS                                                                CDE002
      * Error fields/message IDs/message data (arrays) from/to caller           CDE002
     C                   Parm                    FldNamXAr                      CDE002
     C                   Parm                    MsgIDXAr                       CDE002
     C                   Parm                    MsgDtaXAr                      CDE002
      *                                                                         208221
      * Warning message IDs/message data (arrays) from/to caller                208221
     C                   PARM                    WFldNmXAr                      208221
     C                   PARM                    WMsgIDXAr                      208221
     C                   PARM                    WMsgDtXAr                      208221
      ** Debit Margin Override - OK                                             CDE002
     C                   Parm                    DDOVRDOK          1            CDE002
      ** Debit Margin Rate - OK                                                 CDE002
     C                   Parm                    DDDRMGOK          1            CDE002
      ** Valid File field - Debit Margin Rate                                   CDE002
     C                   Parm      *ZEROS        BXDRMG                         CDE002
      ** Valid File field - Debit Margin Base Rate                              208221
     C                   Parm      *BLANKS       BXDMBR                         208221
                                                                                CDE002
      * Update error info with that returned from the validation module         CDE002
                                                                                CDE002
     C                   EXSR      UPDATERRS                                    CDE002
                                                                                CDE002
     C                   ENDSR                                                  CDE002
      *****************************************************************         CDE002
     C/EJECT                                                                    CDE002
      *****************************************************************         CDE002
      ** VCMGOVR - Validate Credit Interest Margin                              CDE002
      *****************************************************************         CDE002
     C     VCMGOVR       BEGSR                                                  CDE002
                                                                                CDE002
      * Reset variables updated by each module                                  CDE002
                                                                                CDE002
     C                   EXSR      RESETERRS                                    CDE002
      *                                                                         CDE002
     C                   CALLB     'GLVXRMG'                                    CDE002
      *                                                                         CDE002
      * INPUTS                                                                  CDE002
      ** Return Code                                                            CDE002
     C                   Parm                    RetCodeOut                     CDE002
      ** Credit Margin Override                                                 CDE002
     C     BXOVRC        Parm                    DDOVRC            1            CDE002
      ** Credit Margin Rate                                                     CDE002
     C                   Parm                    DDCRMG                         CDE002
      ** Credit Margin Override Field Name                                      CDE002
     C                   Parm      'DDOVRC'      DDOVRCFLD        10            CDE002
      ** Credit Margin Rate Field Name                                          CDE002
     C                   Parm      'DDCRMG'      DDCRMGFLD        10            CDE002
      ** Action Code                                                            208221
     C                   Parm                    DDACTN                         208221
      ** Currency                                                               208221
     C                   Parm                    DDCCY                          208221
      ** Credit Base Rate                                                       208221
     C                   Parm                    AMCRIB                         208221
      ** Credit Rate/Spread                                                     208221
     C                   Parm                    AMCRIS                         208221
      *                                                                         CDE002
      ** OUTPUTS                                                                CDE002
      * Error fields/message IDs/message data (arrays) from/to caller           CDE002
     C                   Parm                    FldNamXAr                      CDE002
     C                   Parm                    MsgIDXAr                       CDE002
     C                   Parm                    MsgDtaXAr                      CDE002
      *                                                                         208221
      * Warning message IDs/message data (arrays) from/to caller                208221
     C                   PARM                    WFldNmXAr                      208221
     C                   PARM                    WMsgIDXAr                      208221
     C                   PARM                    WMsgDtXAr                      208221
      ** Credit Margin Override - OK                                            CDE002
     C                   Parm                    DDOVRCOK          1            CDE002
      ** Credit Margin Rate - OK                                                CDE002
     C                   Parm                    DDCRMGOK          1            CDE002
      ** Valid File field - Credit Margin Rate                                  CDE002
     C                   Parm      *ZEROS        BXCRMG                         CDE002
      ** Valid File field - Debit Margin Base Rate                              208221
     C                   Parm      *BLANKS       BXCMBR                         208221
                                                                                CDE002
                                                                                CDE002
      * Update error info with that returned from the validation module         CDE002
                                                                                CDE002
     C                   EXSR      UPDATERRS                                    CDE002
                                                                                CDE002
     C                   ENDSR                                                  CDE002
      *****************************************************************         CDE002
     C/EJECT                                                                    CDE002
      /COPY WNCPYSRC,GLAMAD4V15                                                               CUT009
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
     C                   Move      DDCUSN        COCNUM
     C                   Move      DDCCY         COCCY
     C                   Move      DDACOD        COACOD
     C                   Move      DDACSQ        COACSQ
     C                   Move      DDBRCA        COBRCA
     C                   ENDIF
     C                   Move      XXCEXA        COCEXA
     C                   Move      XXCEXB        COCEXB
     C                   Move      XXCEXC        COCEXC
     C                   Move      XXCEXD        COCEXD
     C                   Move      XXCEXE        COCEXE
     C                   Move      XXCEXF        COCEXF
     C                   Move      XXCEXG        COCEXG
     C                   Z-Add     XXNOCC        CONOCC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINIT - Process Initialisation                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Access Currency details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCCY         @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
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
     C                   END
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
     C                   Z-Add     2             DBASE
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
     C                   PARM                    TranIn4
      * ICD
     C                   PARM                    RETABLE
      ** CCRM Revenue Analysis                                                  CDE002
     C                   PARM                    CDE002            1            CDE002
                                                                                CDE002
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller                       208221
     C                   PARM                    WFldNamArr                                   208221
     C                   PARM                    WMsgIDArr                                    208221
     C                   PARM                    WMsgDtaArr                                   208221
      * Array index (3P0) from/to caller                                                      208221
     C                   PARM                    WIdx                                         208221
      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidExCO
      * Valid Account layout (extension file) (DS) from/to caller               CDE002
     C                   PARM                    ValidAcEx                      CDE002
      * Valid Account layout (DS) from/to caller                                208221
     C                   PARM                    ValidAccn                      208221
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLAMAD4VL'   DBPGM
     C                   OUT       LDA
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
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
     C                   MOVEL     *BLANK        WFldNmXAr                                    208221
     C                   MOVEL     *BLANK        WMsgIDXAr                                    208221
     C                   MOVEL     *BLANK        WMsgDtXAr                                    208221

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
      *                                                                                       208221
      * Update warning fields/message IDs/message data (arrays)                               208221
      *                                                                                       208221
     C                   Z-ADD     1             I                                            208221
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99                  208221
     C     *IN99         IFEQ      '1'                                                        208221
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)                                208221
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)                                 208221
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)                                208221
     C                   END                                                                  208221
      *                                                                                       208221
      * Set Warning Index                                                                     208221
     C                   Z-ADD     1             I                                            208221
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99                  208221
     C     I             SUB       1             WIdx                                         208221
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
