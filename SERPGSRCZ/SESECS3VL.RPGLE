     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities input validation controller 3')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS3VL - Securities Input Validation Controller 3         *
      *                                                               *
      *  Function: This module validates Securities screen 3          *
      *            fields for input into the Midas database.          *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR996842           Date 11Feb13               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSE075             Date 06Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10800           Date 12Mar06               *
      *                 232543             Date 29Mar05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG4734            Date 23Nov04               *
      *                 CGL014             Date 20Oct03               *
      *                 225455             Date 05Mar04               *
      *                 223846             Date 16Dec03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 12Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR996842 - Creation of new security details: Private Banking *
      *             Instrument type defaulting improvement            *
      *             (Child:AR996843)                                  *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSE075 - CSE075 Change Control. Display Coupon Delay period  *
      *           for all interest-bearing securities.                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10800 - Set Average Life Date of Perpetual Bond to 99999  *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG4734- Fields which are not allow to be amended being      *
      *           changed by default subroutine, and generated error  *
      *           in validation.                                      *
      *  CGL014 - Collaterals Processing                              *
      *  225455 - Fix will ensure that if the "New Issue?" indicator  *
      *           is equal to "Y", the system will default the issue  *
      *           date to initial date if blank, else, the issue date *
      *           will be validated against the initial date.         *
      *  223846 - Withholding Tax fields not being validated          *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD006 - Market Data Feed (recompile)                        *
      *  CSE023 - Treaty Withholding Tax                              *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SESEC3V001
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     D NwSE2ScnFmt   E DS                  EXTNAME(SESEC2PD)
      *
      ** Securities Screen 3 Details from incoming transaction
      ** - screen format
     D NwSE3ScnFmt   E DS                  EXTNAME(SESEC3PD)
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
      *
      ** Securities extra data
     D PExtData      E DS                  EXTNAME(SESEEXPD)
      *
      ** Securities Screen 3 error indicators
     D SEESEC3       E DS                  EXTNAME(SEESEC3PD)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *                                                                                       CSE065
      ** Externally described DS for SAR details                                              CSE065
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSE065
     D  SLCD         E                     EXTFLD(LCD)                                        CSE065
      *                                                                                       CSE065
      ** DS for Access Objects - second data structure                                        CSE065
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CSE065
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D Idx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      ** Index for update of error arrays
     D Ix              S              3  0
      *
      ** Response Mode
     D PRespMode       S              1A
      *
      ** Mode of Processing
     D PMode           S              6A
      *                                                                         CSE023
      ** Processing type                                                        CSE023
     D PPROT           S              1A                                        CSE023
      *
      ** Redsiplay screen flag
     D PReDsp          S              1A
      *
      ** Number of decimal places of Fee currency
     D PFNBDP          S              1P 0
      *                                                                                     AR996842
      ** Instrument type                                                                    AR996842
     D PINNR           S              3A                                                    AR996842
      *
      ** Standing Data
     D BGN4ST          S              1A
     D BJDFIN          S              1A
     D BGRKMG          S              1A
     D CSE023          S              1A                                        CSE023
     D CGL031          S              1A                                                      CGL031
      *
      ** New Issue
     D DDNISS          S              1A
      *
      ** Action code
     D DDACTN          S              1A
      *                                                                                       CSE065
      ** Switchable features                                                                  CSE065
     D CSE065          S              1A                                                      CSE065
     D CSE075          S              1A                                                      CSE075
      *                                                                                       CSE065
      ** Parameters for AOSARDR0                                                              CSE065
     D PRtCd           S              7A                                                      CSE065
     D POptn           S              7A                                                      CSE065
     D PSard           S              6A                                                      CSE065
                                                                                              CSE065
      ** Parameter to ZDATE11                                                                 CSE065
                                                                                              CSE065
     D P@DAT1          S              8                                                       CSE065
     D P@DAY#          S              5  0                                                    CSE065
     D PERRFLG         S              1                                                       CSE065
                                                                                              CSE065
      ** Work variable                                                                        CSE065
                                                                                              CSE065
     D WDateIso        S               d   datfmt(*iso)                                       CSE065
     D WDateIso#       S              8  0                                                    CSE065
     D WkALDT          S              5  0                                                    CSE065
     D WkITLD          S              5  0                                                    CSE065
     D WkMATY          S              5  0                                                    CSE065
     D W#ITLD          S              6  0                                                    CSE065
     D W#MATY          S              6  0                                                    CSE065
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
                                                                                              232543
      ** Subject to European Tax                                                              232543
     D DDSETX          S              1A                                                      232543
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SESEC3V002
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      /COPY WNCPYSRC,SESEC3V003
     C                   IF        DDNISS <> 'Y' AND
     C                             DDACTN = 'I'
     C                   EVAL      DDISA2 = DDISA1
     C                   EVAL      DDFECY = *BLANKS
     C                   IF        CGL031 <> 'Y'                                              232543
     C                   EVAL      DDISSD = *BLANKS
     C                   EVAL      DDISSP = *BLANKS
     C                   ENDIF                                                                232543
     C                   EVAL      DDLMGR = *BLANKS
     C                   EVAL      DDTOTU = *BLANKS
     C                   EVAL      DDALRQ = *BLANKS
     C                   EVAL      DDALRC = *BLANKS
     C                   EVAL      DDMGFD = *BLANKS
     C                   EVAL      DDMGRC = *BLANKS
     C                   EVAL      DDUNFD = *BLANKS
     C                   EVAL      DDUNFR = *BLANKS
     C                   EVAL      ISSD = *ZEROS                                              225455
     C                   EVAL      ISSP = *ZEROS                                              225455
     C**********         EVAL      LMGR = *ZEROS                                       225455 CSD027
     C                   EVAL      LMGR = *BLANKS                                             CSD027
     C                   EVAL      ISSA = *ZEROS                                              225455
     C                   EVAL      TOTU = *ZEROS                                              225455
     C                   EVAL      ALRQ = *ZEROS                                              225455
     C                   EVAL      ALRC = *ZEROS                                              225455
     C                   EVAL      MGFD = *ZEROS                                              225455
     C                   EVAL      UNFD = *ZEROS                                              225455
     C                   EVAL      UNFR = *ZEROS                                              225455
     C                   EVAL      FECY = *ZEROS                                              225455
     C                   EVAL      MGRC = *ZEROS                                              225455
     C                   IF        CSE075 = 'Y'                                               CSE075
     C                   EVAL      CPDY   = *ZEROS                                            CSE075
     C                   EVAL      RPRT   = *ZEROS                                            CSE075
     C                   EVAL      WACP   = *ZEROS                                            CSE075
     C                   EVAL      WAMY   = *ZEROS                                            CSE075
     C                   ENDIF                                                                CSE075
     C                   ENDIF
      *                                                                                       225455
      ** If the Initial Date was amended, Issue Date should be changed                        225455
      ** accordingly                                                                          225455
      *                                                                                       225455
     C                   IF        ITLD<>  S1ITLD AND                                         225455
     C                             ISSD > S1ITLD AND                                          225455
     C                             DDNISS = 'Y' AND                                           225455
     C                             DDACTN <> 'E'OR                                            225455
     C                             DDISSD = *BLANKS                                           225455
     C                             AND DDNISS = 'Y'                                          BUG4734
     C                   EVAL      ISSD = S1ITLD                                              225455
     C                   EVAL      DDISSD=DDITLD                                              225455
     C                   ENDIF                                                                225455
      *
      ** Issue date validation.
      *
      /COPY WNCPYSRC,SESEC3V004
 
     C                   EXSR      SRIssDte
 
      /COPY WNCPYSRC,SESEC3V005
      *
      ** Issue price validation.
      *
      /COPY WNCPYSRC,SESEC3V006
 
     C                   EXSR      SRIssPrc
 
      /COPY WNCPYSRC,SESEC3V007
      *
      ** Lead manager validation.
      *
      /COPY WNCPYSRC,SESEC3V008
 
     C                   EXSR      SRLdMgr
 
      /COPY WNCPYSRC,SESEC3V009
      *
      ** Issue amount validation.
      *
      /COPY WNCPYSRC,SESEC3V010
      *
      ** For Insert, default issue amount 2 to issue amount 1 if
      ** Early repayment is 'Y', and Risk Management is on.
      *
     C                   IF        DDACTN = 'I' AND
     C                             BGRKMG = 'Y' AND
     C                             S1ERPY = 'Y'
     C                   EVAL      DDISA2 = DDISA1
     C                   ENDIF
 
     C                   EXSR      SRIssAmt
 
      /COPY WNCPYSRC,SESEC3V011
      *
      ** Total underwritten validation.
      *
      /COPY WNCPYSRC,SESEC3V012
 
     C                   EXSR      SRTtlUdw
 
      /COPY WNCPYSRC,SESEC3V013
      *
      ** Allocation requested/received validation.
      *
      /COPY WNCPYSRC,SESEC3V014
 
     C                   EXSR      SRAllReqRcv
 
      /COPY WNCPYSRC,SESEC3V015
      *
      ** Fees detail validation.
      *
      /COPY WNCPYSRC,SESEC3V016
 
     C                   IF        DDFECY <> *BLANK                                          BUG4734
     C                             OR DDNISS = 'Y'                                           BUG4734
     C                   EXSR      SRFeeCcy
     C                   ENDIF                                                               BUG4734
 
      /COPY WNCPYSRC,SESEC3V017
      *                                                                                       CSE065
      ** Average Life Date validation                                                         CSE065
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'  AND                                          CSE065
     C                             PProT <> '2'  AND                                          CSE065
     C                             PProT <> '4'  AND                                          CSE065
     C                             PProT <> '7'                                               CSE065
     C                   EXSR      SRAveLife                                                  CSE065
     C                   ENDIF                                                                CSE065
 
      *
      ** Management fees due and received validation.
      *
      /COPY WNCPYSRC,SESEC3V018
 
     C                   EXSR      SRMgmtFee
 
      /COPY WNCPYSRC,SESEC3V019
      *
      ** Underwriting fees due and received validation.
      *
      /COPY WNCPYSRC,SESEC3V020
 
     C                   EXSR      SRUndwFee
 
 
      /COPY WNCPYSRC,SESEC3V021
      *
      ** Private banking if active.
      *
     C                   IF        BGN4ST = 'Y'
     C                             OR  CGL014 = 'Y'                                           CGL014
     C                   IF        BGN4ST = 'Y'                                               CGL014
 
      /COPY WNCPYSRC,SESEC3V022
      *
      ** Principal paying agent validation.
      *
      /COPY WNCPYSRC,SESEC3V023
 
     C                   EXSR      SRPPayAgnt
 
      /COPY WNCPYSRC,SESEC3V024
      *
      ** Guarantor validation.
      *
      /COPY WNCPYSRC,SESEC3V025
 
     C                   EXSR      SRGuarntr
 
      /COPY WNCPYSRC,SESEC3V026
      **************************************                                                  CGL014
      ***Weighting*code*validation.*********                                                  CGL014
      **************************************                                                  CGL014
      /COPY WNCPYSRC,SESEC3V027
 
     C**********         EXSR      SRWeiCode                                                  CGL014
 
      /COPY WNCPYSRC,SESEC3V028
      *
      ** Nature of account validation.
      *
      /COPY WNCPYSRC,SESEC3V029
 
     C                   EXSR      SRNatuAc
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
 
      /COPY WNCPYSRC,SESEC3V030
                                                                                              CGL014
     C                   IF        BGN4ST = 'Y'  OR  CGL014 = 'Y'                             CGL014
      *
      ** PB Instrument Type.
      *
      /COPY WNCPYSRC,SESEC3V031
 
     C                   EXSR      SRPBInTp
                                                                                              CGL014
      ** Weighting code validation.                                                           CGL014
                                                                                              CGL014
     C                   EXSR      SRWeiCode                                                  CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
 
      /COPY WNCPYSRC,SESEC3V032
 
     C                   ELSE
     C                   EVAL      DDPPAG = *BLANKS
     C                   EVAL      DDGUAR = *BLANKS
     C                   EVAL      DDWEIC = *BLANKS
     C                   EVAL      DDNATU = *BLANKS
     C                   EVAL      DDPBIT = *BLANKS
     C                   ENDIF
                                                                                              CGL014
     C                   IF        BGN4ST = 'N'  AND  CGL014 = 'Y'                            CGL014
     C                   EVAL      DDPPAG = *BLANKS                                           CGL014
     C                   EVAL      DDGUAR = *BLANKS                                           CGL014
     C                   EVAL      DDNATU = *BLANKS                                           CGL014
     C                   ENDIF                                                                CGL014
 
      /COPY WNCPYSRC,SESEC3V033
      *                                                                         CSE023
      ** US Withholding Tax Treaty is active and processing is called           CSE023
      ** from the '*CTL' then validate as follows.                              CSE023
      ** Otherwise, validation processing is done by windows program.           CSE023
      *                                                                         CSE023
     C************       IF        CSE023 = 'Y' AND PMode = '*FRONT'                   CSE023 223846
     C                   IF        CSE023 = 'Y' AND PMode <> '*SIN'                    CSE023 223846
                                                                                CSE023
     C                   EXSR      SRCSE023                                     CSE023
                                                                                CSE023
     C                   ENDIF                                                  CSE023
 
      *                                                                                       CSE075
      ** Validate coupon delay period, Validate Repayment Rate,                               CSE075
      ** Weighted Average coupon and Weighted Average Maturity                                CSE075
      *                                                                                       CSE075
     C                   IF        CSE075 = 'Y' AND PPROT = '8'                               CSE075
     C**********         EXSR      SRCPDelay                                           CSE075 CSE075
     C                   EXSR      SRReprate                                                  CSE075
     C                   EXSR      SRWaveCP                                                   CSE075
     C                   EXSR      SRWaveMat                                                  CSE075
     C                   ENDIF                                                                CSE075
                                                                                              CSE075
      ** Validate coupon delay period separately                                              CSE075
                                                                                              CSE075
     C                   IF        CSE075 = 'Y'                                               CSE075
     C                   IF        (S1STBS = 'P' AND PPROT <> '2' AND                         CSE075
     C                             PPROT <> '4' AND PPROT <> '7') OR                          CSE075
     C                             (S1STBS = 'Y' AND PPROT <> '2' AND                         CSE075
     C                             PPROT <> '4' AND PPROT <> '7' AND                          CSE075
     C                             PPROT <> '9')                                              CSE075
     C                   EXSR      SRCPDelay                                                  CSE075
     C                   ENDIF                                                                CSE075
     C                   ENDIF                                                                CSE075
      *                                                                                       CSE075
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,SESEC3V034
 
      *****************************************************************
      *                                                               *
      *  SRIssDte - Issue Date Validation                             *
      *                                                               *
      *****************************************************************
 
     C     SRIssDte      BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SEVSISSDT'
      *                             =========
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *                                                                                       232543
      ** Subject to EU Tax                                                                    232543
     C                   PARM                    DDSETX                                       232543
      *
      ** Securities Screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Date Format Indicator
     C                   PARM                    BJDFIN
                                                                                              CGL031
      ** SWITCHABLE FEATURE                                                                   CGL031
      ** ==================                                                                   CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
                                                                                              CGL031
      ** Processing type, from PF/INVTPD                                                      CGL031
     C                   PARM                    PPROT                                        CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIssPrc - Issue Price Validation                            *
      *                                                               *
      *****************************************************************
 
     C     SRIssPrc      BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SEVSISSPR'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *                                                                                       232543
      ** Subject to EU Tax                                                                    232543
     C                   PARM                    DDSETX                                       232543
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
                                                                                              CGL031
      ** Processing type, from PF/INVTPD                                                      CGL031
     C                   PARM                    PPROT                                        CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLdMgr - Lead Manager Validation                            *
      *                                                               *
      *****************************************************************
 
     C     SRLdMgr       BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SEVSLDMGR'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (Screen input function)
      ** Mode = '*RPR  ' (Repair function)
     C                   PARM                    PMode
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIssAmt - Issue Amount Validation                           *
      *                                                               *
      *****************************************************************
 
     C     SRIssAmt      BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SEVSISAM2'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTtlUdw - Total Underwritten Validation                     *
      *                                                               *
      *****************************************************************
 
     C     SRTtlUdw      BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SEVSTLUND'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAllReqRcv - Allocation Requested/Received Validation       *
      *                                                               *
      *****************************************************************
 
     C     SRAllReqRcv   BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SEVSARQRC'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFeeCcy - Fee Currency Validation                           *
      *                                                               *
      *****************************************************************
 
     C     SRFeeCcy      BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SEVSFCCY'
      *                             ========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (Screen input function)
      ** Mode = '*RPR  ' (Repair function)
     C                   PARM                    PMode
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Number of decimal places of Fee currency
     C                   PARM                    PFNBDP
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************                       CSE065
      /EJECT                                                                                  CSE065
      *****************************************************************                       CSE065
      *                                                               *                       CSE065
      *  SRAveLife - Average Life Date Validation                     *                       CSE065
      *                                                               *                       CSE065
      *****************************************************************                       CSE065
                                                                                              CSE065
     C     SRAveLife     BEGSR                                                                CSE065
      *                                                                                       CSE065
      ** Reset fields                                                                         CSE065
      *                                                                                       CSE065
     C                   EXSR      SRResetErrs                                                CSE065
                                                                                              CSE065
      ** Maturity Date                                                                        CSE065
                                                                                              CSE065
     C                   Z-ADD     *ZEROS        W#MATY                                       CSE065
     C                   IF        S1STBS = 'D' OR S1STBS = 'Y' AND                           CSE065
     C                             PPROT = '9'                                                CSE065
     C                   MOVE      DDMATY1       W#MATY                                       CSE065
     C                   ENDIF                                                                CSE065
     C                   IF        (S1STBS = 'P' AND PPROT <> '2' AND                         CSE065
     C                             PPROT <> '4' AND PPROT <> '7') OR                          CSE065
     C                             (S1STBS = 'Y' AND PPROT <> '2' AND                         CSE065
     C                             PPROT <> '4' AND PPROT <> '7' AND                          CSE065
     C                             PPROT <> '9')                                              CSE065
     C                   MOVE      DDMATY2       W#MATY                                       CSE065
     C                   ENDIF                                                                CSE065
     C                   IF        W#MATY  <> 0                                               CSE065
     C                             AND W#MATY <> 999999                                     BUG10800
                                                                                              CSE065
      ** Convert Maturity Date from DDMMYY or MMDDYY to DDMMYYYY or MMDDYYYY                  CSE065
                                                                                              CSE065
     C                   IF        BJDFIN = 'D'                                               CSE065
     C     *dmy          MOVE      W#MATY        WDateIso                                     CSE065
     C                   ELSE                                                                 CSE065
     C     *mdy          MOVE      W#MATY        WDateIso                                     CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
      ** Add 100 years                                                                        CSE065
                                                                                              CSE065
     C                   IF        DDLTMI = 'Y'                                               CSE065
     C                   ADDDUR    100:*Y        WDateIso                                     CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
                                                                                              CSE065
     C                   IF        BJDFIN = 'D'                                               CSE065
     c     *eur          Move      WDateIso      WDateIso#                                    CSE065
     c                   Else                                                                 CSE065
     c     *usa          Move      WDateIso      WDateIso#                                    CSE065
     c                   EndIf                                                                CSE065
                                                                                              CSE065
     C                   MOVE      WDateIso#     P@DAT1                                       CSE065
                                                                                              CSE065
      ** Convert Maturity Date to Midas Day Number format                                     CSE065
                                                                                              CSE065
     C                   CALL      'ZDATE11'                                                  CSE065
     C                   PARM                    P@DAT1                                       CSE065
     C                   PARM      0             P@DAY#                                       CSE065
     C                   PARM                    BJDFIN                                       CSE065
     C                   PARM                    PERRFLG                                      CSE065
                                                                                              CSE065
      ** Store Maturity Date to Work variable                                                 CSE065
                                                                                              CSE065
     C                   EVAL      WkMATY = MATY                                              CSE065
     C                   EVAL      MATY = P@DAY#                                              CSE065
                                                                                              CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
      ** Initial date                                                                         CSE065
                                                                                              CSE065
     C                   MOVE      DDITLD        W#ITLD                                       CSE065
     C                   IF        W#ITLD  > 0                                                CSE065
                                                                                              CSE065
      ** Convert Initial Date from MMDDYY or DDMMYY to MMDDYYYY or                            CSE065
      ** DDMMYYYY format                                                                      CSE065
                                                                                              CSE065
     C                   IF        BJDFIN = 'D'                                               CSE065
     C     *dmy          MOVE      W#ITLD        WDateIso                                     CSE065
     c     *eur          Move      WDateIso      WDateIso#                                    CSE065
     C                   ELSE                                                                 CSE065
     C     *mdy          MOVE      W#ITLD        WDateIso                                     CSE065
     c     *usa          Move      WDateIso      WDateIso#                                    CSE065
     C                   ENDIF                                                                CSE065
     C                   MOVE      WDateIso#     P@DAT1                                       CSE065
                                                                                              CSE065
      ** Convert Initial Date into Midas Day Number format                                    CSE065
                                                                                              CSE065
     C                   CALL      'ZDATE11'                                                  CSE065
     C                   PARM                    P@DAT1                                       CSE065
     C                   PARM      0             P@DAY#                                       CSE065
     C                   PARM                    BJDFIN                                       CSE065
     C                   PARM                    PERRFLG                                      CSE065
                                                                                              CSE065
      ** Store Initial Date to a work variable                                                CSE065
                                                                                              CSE065
     C                   EVAL      WkITLD = ITLD                                              CSE065
     C                   EVAL      ITLD = P@DAY#                                              CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
      ** Store Average Life Date (from file SECTYD) to a work variable                        CSE065
                                                                                              CSE065
     C                   EVAL      WkALDT = ALDT                                              CSE065
     C                   EVAL      ALDT = *ZERO                                               CSE065
                                                                                            BUG10800
     C                   IF        W#MATY <> 999999                                         BUG10800
                                                                                              CSE065
      ** Call validation module                                                               CSE065
                                                                                              CSE065
     C                   CALLB     'SEVDSDAL'                                                 CSE065
      *                             ========                                                  CSE065
      ** INPUT                                                                                CSE065
      ** =====                                                                                CSE065
      *                                                                                       CSE065
      ** Return code                                                                          CSE065
     C                   PARM                    RetCodeOut                                   CSE065
                                                                                              CSE065
      ** SE Diary Events screen details from incoming                                         CSE065
      ** transaction - screen format                                                          CSE065
     C                   PARM                    DDALDT                                       CSE065
      *                                                                                       CSE065
      ** Securities retrieved from file - file format                                         CSE065
     C                   PARM                    CrSEFilFmt                                   CSE065
      *                                                                                       CSE065
      ** STANDING DATA                                                                        CSE065
      ** =============                                                                        CSE065
      *                                                                                       CSE065
      ** SDBANK - Date format indicator                                                       CSE065
     C                   PARM                    BJDFIN                                       CSE065
      *                                                                                       CSE065
      ** OUTPUT                                                                               CSE065
      ** ======                                                                               CSE065
      *                                                                                       CSE065
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE065
     C                   PARM                    FldNamXAr                                    CSE065
     C                   PARM                    MsgIDXAr                                     CSE065
     C                   PARM                    MsgDtaXAr                                    CSE065
      *                                                                                       CSE065
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSE065
     C                   PARM                    WFldNmXAr                                    CSE065
     C                   PARM                    WMsgIDxAr                                    CSE065
     C                   PARM                    WMsgDtXAr                                    CSE065
      *                                                                                       CSE065
      ** Average Life OK Flag                                                                 CSE065
     C                   PARM                    OKALDT                                       CSE065
      *                                                                                       CSE065
      ** Securities for file update - file format                                             CSE065
     C                   PARM                    S1ALDT                                       CSE065
                                                                                            BUG10800
     C                   ELSE                                                               BUG10800
      *                                                                                     BUG10800
     C                   EVAL      S1ALDT = 99999                                           BUG10800
      *                                                                                     BUG10800
     C                   ENDIF                                                              BUG10800
                                                                                              CSE065
      ** Restore Maturity Date from work variable                                             CSE065
                                                                                              CSE065
     C                   EVAL      MATY = WkMATY                                              CSE065
                                                                                              CSE065
      ** Restore Initial Date from work variable                                              CSE065
                                                                                              CSE065
     C                   EVAL      ITLD = WkITLD                                              CSE065
                                                                                              CSE065
      ** Restore Average Life Date from work variable                                         CSE065
                                                                                              CSE065
     C                   EVAL      WkALDT = ALDT                                              CSE065
                                                                                              CSE065
      ** Update error information.                                                            CSE065
                                                                                              CSE065
     C                   IF        RetCodeOut <> *Blanks                                      CSE065
     C                   EXSR      SRUpdatErrs                                                CSE065
     C                   ENDIF                                                                CSE065
      *                                                                                       CSE065
     C                   ENDSR                                                                CSE065
                                                                                              CSE065
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMgmtFee - Management Fees Due/Received Validation          *
      *                                                               *
      *****************************************************************
 
     C     SRMgmtFee     BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SEVSMFEES'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Number of decimal places of Fee currency
     C                   PARM                    PFNBDP
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUndwFee - Underwriting Fees Due/Received Validation        *
      *                                                               *
      *****************************************************************
 
     C     SRUndwFee     BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SEVSUFEES'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Number of decimal places of Fee currency
     C                   PARM                    PFNBDP
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPPayAgnt - Principal Paying Agent Validation               *
      *                                                               *
      *****************************************************************
 
     C     SRPPayAgnt    BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SEVSPPYAG'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (Screen input function)
      ** Mode = '*RPR  ' (Repair function)
     C                   PARM                    PMode
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGuarntr - Guarantor Validation                             *
      *                                                               *
      *****************************************************************
 
     C     SRGuarntr     BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SEVSGRNTR'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (Screen input function)
      ** Mode = '*RPR  ' (Repair function)
     C                   PARM                    PMode
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error information.
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWeiCode - Weighting Code Validation                        *
      *                                                               *
      *****************************************************************
 
     C     SRWeiCode     BEGSR
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module.
      *
     C                   CALLB     'SEVSWEICD'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (Screen input function)
      ** Mode = '*RPR  ' (Repair function)
     C                   PARM                    PMode
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
                                                                                              CGL014
     C                   PARM                    CGL014                                       CGL014
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNatuAc - Nature of Account Validation                      *
      *                                                               *
      *****************************************************************
 
     C     SRNatuAc      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call Validation module
      *
     C                   CALLB     'SEVSNATAC'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (Screen input function)
      ** Mode = '*RPR  ' (Repair function)
     C                   PARM                    PMode
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPBInTp - PB Instrument Type Validation                     *
      *                                                               *
      *****************************************************************
 
     C     SRPBInTp      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call Validation module
      *
     C                   CALLB     'SEVSPBITP'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (Screen input function)
      ** Mode = '*RPR  ' (Repair function)
     C                   PARM                    PMode
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *                                                                                     AR996842
      ** Instrument type                                                                    AR996842
     C                   PARM                    PINNR                                      AR996842
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *Blanks
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************         CSE023
      *                                                               *         CSE023
      *  SRCSE023 - US Withholding tax fields validation (for CTL)    *         CSE023
      *                                                               *         CSE023
      *****************************************************************         CSE023
                                                                                CSE023
     C     SRCSE023      BEGSR                                                  CSE023
      *                                                                         CSE023
      ** Reset variables updated by each module                                 CSE023
      *                                                                         CSE023
     C                   EXSR      SRResetErrs                                  CSE023
      *                                                                         CSE023
      ** Call Validation module                                                 CSE023
      *                                                                         CSE023
     C                   CALLB     'SEVCSE023'                                  CSE023
      *                             =========                                   CSE023
      *                                                                         CSE023
      ** INPUT                                                                  CSE023
      ** =====                                                                  CSE023
      *                                                                         CSE023
      ** Return Code                                                            CSE023
     C                   PARM                    RetCodeOut                     CSE023
      *                                                                         CSE023
      ** Securities Screen 3 details from incoming transaction                  CSE023
      ** - screen format                                                        CSE023
     C                   PARM                    NwSE3ScnFmt                    CSE023
      *                                                                         CSE023
      ** Processing type, from PF/INVTPD                                        CSE023
     C                   PARM                    PPROT                          CSE023
      *                                                                         CSE023
      ** OUTPUT                                                                 CSE023
      ** ======                                                                 CSE023
      *                                                                         CSE023
      ** Error fields/message IDs/message data (arrays) from/to caller          CSE023
     C                   PARM                    FldNamXAr                      CSE023
     C                   PARM                    MsgIDXAr                       CSE023
     C                   PARM                    MsgDtaXAr                      CSE023
      *                                                                         CSE023
      ** Securities for file update - file format                               CSE023
     C                   PARM                    NwSEFilFmt                     CSE023
      *                                                                         CSE023
      ** Update error info with that returned from the validation module        CSE023
      *                                                                         CSE023
     C                   IF        RetCodeOut <> *Blanks                        CSE023
     C                   EXSR      SRUpdatErrs                                  CSE023
     C                   ENDIF                                                  CSE023
                                                                                CSE023
     C                   ENDSR                                                  CSE023
                                                                                CSE023
      *****************************************************************         CSE023
      /EJECT                                                                    CSE023
      *****************************************************************                       CSE075
      *                                                               *                       CSE075
      *  SRCPDelay - Coupon Delay Period Validation                   *                       CSE075
      *                                                               *                       CSE075
      *****************************************************************                       CSE075
                                                                                              CSE075
     C     SRCPDelay     BEGSR                                                                CSE075
      *                                                                                       CSE075
      ** Reset variables updated by each module                                               CSE075
      *                                                                                       CSE075
     C                   EXSR      SRResetErrs                                                CSE075
      *                                                                                       CSE075
      ** Call Validation Module                                                               CSE075
      *                                                                                       CSE075
     C                   CALLB     'SEVSCPDLY'                                                CSE075
     C                   PARM      *BLANKS       RetCodeOut                                   CSE075
     C                   PARM                    NwSE3ScnFmt                                  CSE075
     C                   PARM                    FldNamXar                                    CSE075
     C                   PARM                    MsgIDXAr                                     CSE075
     C                   PARM                    MsgDtaXAr                                    CSE075
     C                   PARM                    SEESEC3                                      CSE075
     C                   PARM                    NwSEFilFmt                                   CSE075
      *                                                                                       CSE075
      ** Update error information                                                             CSE075
      *                                                                                       CSE075
     C                   IF        RetCodeOut <> *BLANKS                                      CSE075
     C                   EXSR      SRUpdatErrs                                                CSE075
     C                   ENDIF                                                                CSE075
      *                                                                                       CSE075
     C                   ENDSR                                                                CSE075
      *****************************************************************                       CSE075
      /EJECT                                                                                  CSE075
      *****************************************************************                       CSE075
      *                                                               *                       CSE075
      *  SRRepRate - Repayment Rate Validation                        *                       CSE075
      *                                                               *                       CSE075
      *****************************************************************                       CSE075
                                                                                              CSE075
     C     SRRepRate     BEGSR                                                                CSE075
      *                                                                                       CSE075
      ** Reset variables updated by each module                                               CSE075
      *                                                                                       CSE075
     C                   EXSR      SRResetErrs                                                CSE075
      *                                                                                       CSE075
      ** Call Validation Module                                                               CSE075
      *                                                                                       CSE075
     C                   CALLB     'SEVSRPRAT'                                                CSE075
     C                   PARM      *BLANKS       RetCodeOut                                   CSE075
     C                   PARM                    NwSE3ScnFmt                                  CSE075
     C                   PARM                    FldNamXar                                    CSE075
     C                   PARM                    MsgIDXAr                                     CSE075
     C                   PARM                    MsgDtaXAr                                    CSE075
     C                   PARM                    SEESEC3                                      CSE075
     C                   PARM                    NwSEFilFmt                                   CSE075
      *                                                                                       CSE075
      ** Update error information                                                             CSE075
      *                                                                                       CSE075
     C                   IF        RetCodeOut <> *BLANKS                                      CSE075
     C                   EXSR      SRUpdatErrs                                                CSE075
     C                   ENDIF                                                                CSE075
      *                                                                                       CSE075
     C                   ENDSR                                                                CSE075
      *****************************************************************                       CSE075
      /EJECT                                                                                  CSE075
      *****************************************************************                       CSE075
      *                                                               *                       CSE075
      *  SRWAveCP - Weighted Average Coupon Validation                *                       CSE075
      *                                                               *                       CSE075
      *****************************************************************                       CSE075
                                                                                              CSE075
     C     SRWAveCp      BEGSR                                                                CSE075
      *                                                                                       CSE075
      ** Reset variables updated by each module                                               CSE075
      *                                                                                       CSE075
     C                   EXSR      SRResetErrs                                                CSE075
      *                                                                                       CSE075
      ** Call Validation Module                                                               CSE075
      *                                                                                       CSE075
     C                   CALLB     'SEVSWAVCP'                                                CSE075
     C                   PARM      *BLANKS       RetCodeOut                                   CSE075
     C                   PARM                    NwSE3ScnFmt                                  CSE075
     C                   PARM                    FldNamXar                                    CSE075
     C                   PARM                    MsgIDXAr                                     CSE075
     C                   PARM                    MsgDtaXAr                                    CSE075
     C                   PARM                    SEESEC3                                      CSE075
     C                   PARM                    NwSEFilFmt                                   CSE075
      *                                                                                       CSE075
      ** Update error information                                                             CSE075
      *                                                                                       CSE075
     C                   IF        RetCodeOut <> *BLANKS                                      CSE075
     C                   EXSR      SRUpdatErrs                                                CSE075
     C                   ENDIF                                                                CSE075
      *                                                                                       CSE075
     C                   ENDSR                                                                CSE075
      *****************************************************************                       CSE075
      /EJECT                                                                                  CSE075
      *****************************************************************                       CSE075
      *                                                               *                       CSE075
      *  SRWAveMAT - Weighted Average Maturity Validation             *                       CSE075
      *                                                               *                       CSE075
      *****************************************************************                       CSE075
                                                                                              CSE075
     C     SRWAveMat     BEGSR                                                                CSE075
      *                                                                                       CSE075
      ** Reset variables updated by each module                                               CSE075
      *                                                                                       CSE075
     C                   EXSR      SRResetErrs                                                CSE075
      *                                                                                       CSE075
      ** Call Validation Module                                                               CSE075
      *                                                                                       CSE075
     C                   CALLB     'SEVSWAVMY'                                                CSE075
     C                   PARM      *BLANKS       RetCodeOut                                   CSE075
     C                   PARM                    NwSE3ScnFmt                                  CSE075
     C                   PARM                    FldNamXar                                    CSE075
     C                   PARM                    MsgIDXAr                                     CSE075
     C                   PARM                    MsgDtaXAr                                    CSE075
     C                   PARM                    SEESEC3                                      CSE075
     C                   PARM                    NwSEFilFmt                                   CSE075
      *                                                                                       CSE075
      ** Update error information                                                             CSE075
      *                                                                                       CSE075
     C                   IF        RetCodeOut <> *BLANKS                                      CSE075
     C                   EXSR      SRUpdatErrs                                                CSE075
     C                   ENDIF                                                                CSE075
      *                                                                                       CSE075
     C                   ENDSR                                                                CSE075
      *****************************************************************
      *                                                               *
      *  SRResetErrs - Reset error information that is received back  *
      *                from each validation module.                   *
      *                                                               *
      *****************************************************************
 
     C     SRResetErrs   BEGSR
 
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ** Reset error and warning fields/message IDs/message
      ** data (arrays).
      *
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
 
     C                   EVAL      WFldNmXAr = *BLANKS
     C                   EVAL      WMsgIDXAr = *BLANKS
     C                   EVAL      WMsgDtXAr = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdatErrs - Routine to update Error Information with that  *
      *                received back from each validation module      *
      *                                                               *
      *****************************************************************
 
     C     SRUpdatErrs   BEGSR
      *
      ** Update error fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FldNameArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     FldNamXar     FldNameArr(Ix)
     C                   MOVEA     MsgIDXAr      MsgIdArr(Ix)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set error index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FLDNAMEARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             IDX
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       FLDNAMEARR(Ix)
     C                   MOVE      *BLANKS       MSGIDARR(Ix)
     C                   MOVE      *BLANKS       MSGDTAARR(Ix)
     C                   Eval      IDX = ArrayMax - 1
     C                   ENDIF
      *
      ** Update warning fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFldNamArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     WFldNmXAr     WFldNamArr(Ix)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(Ix)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set warning index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFLDNAMARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             WIDX
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       WFLDNAMARR(Ix)
     C                   MOVE      *BLANKS       WMSGIDARR(Ix)
     C                   MOVE      *BLANKS       WMSGDTAARR(Ix)
     C                   Eval      WIDX = ArrayMax - 1
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PRespMode
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE2ScnFmt
      *
      ** Securities Screen 3 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE3ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *                                                                         CSE023
      ** Processing type, from PF/INVTPD                                        CSE023
     C                   PARM                    PPROT                          CSE023
      *
      ** New Issue
     C                   PARM                    DDNISS
      *
      ** Action code
     C                   PARM                    DDACTN
      *                                                                                       232543
      ** Subject to European Tax                                                              232543
     C                   PARM                    DDSETX                                       232543
      *                                                                                     AR996842
      ** Instrument type                                                                    AR996842
     C                   PARM                    PINNR                                      AR996842
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** SDMMOD - Private Banking Flag
     C                   PARM                    BGN4ST
      *
      ** SDMMOD - Interest risk management
     C                   PARM                    BGRKMG
      *                                                                         CSE023
      ** CSE023 - US Withholding Tax Treaty.                                    CSE023
     C                   PARM                    CSE023                         CSE023
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
                                                                                              CGL014
     C                   PARM                    CGL014                                       CGL014
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Securities Screen 3 error indicators
     C                   PARM                    SEESEC3
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
                                                                                              CSE065
      ** Check if CSE065 is installed                                                         CSE065
     C                   EVAL      CSE065 = 'N'                                               CSE065
     C                   CALLB     'AOSARDR0'                                                 CSE065
     C                   PARM      *Blanks       PRTCD                                        CSE065
     C                   PARM      '*VERIFY'     POPTN                                        CSE065
     C                   PARM      'CSE065'      PSARD                                        CSE065
     C     SCSARD        PARM      SCSARD        DSSDY                                        CSE065
                                                                                              CSE065
     C                   IF        PRTCD = *Blanks                                            CSE065
     C                   EVAL      CSE065 = 'Y'                                               CSE065
     C                   ELSE                                                                 CSE065
     C                   IF        PRTCD <> '*NRF   '                                         CSE065
     C     *LOCK         IN        LDA                                                        CSE065
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSE065
     C                   EVAL      DBKEY  = 'CSE065'                                          CSE065
     C                   EVAL      DBASE  = 1                                                 CSE065
     C                   OUT       LDA                                                        CSE065
     C                   EXSR      *PSSR                                                      CSE065
     C                   ENDIF                                                                CSE065
     C                   ENDIF                                                                CSE065
      *                                                                                       CSE075
      ** Check if CSE075 is installed                                                         CSE075
      *                                                                                       CSE075
     C                   EVAL      CSE075 = 'N'                                               CSE075
     C                   CALLB     'AOSARDR0'                                                 CSE075
     C                   PARM      *Blanks       PRTCD                                        CSE075
     C                   PARM      '*VERIFY'     POPTN                                        CSE075
     C                   PARM      'CSE075'      PSARD                                        CSE065
     C     SCSARD        PARM      SCSARD        DSSDY                                        CSE075
                                                                                              CSE075
     C                   IF        PRTCD = *Blanks                                            CSE075
     C                   EVAL      CSE075 = 'Y'                                               CSE075
     C                   ELSE                                                                 CSE075
     C                   IF        PRTCD <> '*NRF   '                                         CSE075
     C     *LOCK         IN        LDA                                                        CSE075
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSE075
     C                   EVAL      DBKEY  = 'CSE075'                                          CSE075
     C                   EVAL      DBASE  = 2                                                 CSE075
     C                   OUT       LDA                                                        CSE075
     C                   EXSR      *PSSR                                                      CSE075
     C                   ENDIF                                                                CSE075
     C                   ENDIF                                                                CSE075
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,SESEC3V035
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
