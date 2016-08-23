     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities validation controller 1')          *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS1VL - Securities Input Validation Controller 1         *
      *                                                               *
      *  Function: This module validates Securities screen 1 fields   *
      *            for input into the Midas database.                 *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE073             Date 10Dec06               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3644            Date 12Jul04               *
      *                 CGL014             Date 20Oct03               *
      *                 222373             Date 22Oct03               *
      *                 CSE037             Date 29Apr02               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP060             Date 12Feb01               *
      *                 CSD006             Date 12Feb01               *
      *                 183604             Date 16Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL032 - Automatic Exchange of Information                   *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  222373 - Parameter Mismatch                                  *
      *  CSE037 - Countervalue rounding - recompile only for INVTP    *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAP060 - Midas APIs Sec Prices                               *
      *  CSD006 - Market Data Feed                                    *
      *  183604 - Industry Code and Market Center must be mandatory   *
      *           when new PB Module is switched ON. Rating Code      *
      *           must be validated against new table PBRATIPD when   *
      *           new PB Module is switched ON.                       *
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
      /COPY WNCPYSRC,SESEC1V001
      *
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
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
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
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     D CrSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
     D                                     PREFIX(O)
      *
      ** Securities for file update - file format
     D NwSEFilFmt    E DS                  EXTNAME(SEVSECSPD)
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
      *
      ** Securities screen 1 error indicators
     D SEESEC1       E DS                  EXTNAME(SEESEC1PD)
      *
      ** Securities screen 2 error indicators
     D SEESEC2       E DS                  EXTNAME(SEESEC2PD)
      *
      ** Externally described DS for investment types
     D PInvtp        E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(P)
      *
      ** Externally described DS for country codes
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      ** Update error index
     D Ix              S              3P 0
      *
      ** Response Mode, received as a parameter from the common header
     D PResponse       S              1A
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     D PMode           S              6A
      *
      ** Redisplay screen
     D PReDsp          S              1A
      *
      ** Switchable features
     D CEU017          S              1A
     D CEU018          S              1A
     D CSE007          S              1A
     D CSE011          S              1A
     D S01401          S              1A
     D S01511          S              1A
     D CSD006          S              1A                                                      CSD006
     D CAP060          S              1A                                                      CAP060
     D CGL032          S              1A                                                      CGL032
      *
      ** Standing data
     D BGN4ST          S              1A
      *
      ** Work parameters
     D PRate1          S             13P 8
     D PMDI1           S              1A
     D PNMDP           S              1P 0
     D PVLDP           S              1P 0
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SESEC1V002
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
      ** M A I N  P R O C E S S I N G
      *
      /COPY WNCPYSRC,SESEC1V003
      *
      ** Security report name validation
      *
      /COPY WNCPYSRC,SESEC1V004
 
     C                   EXSR      SRRptNm
 
      /COPY WNCPYSRC,SESEC1V005
      *                                                                                       CAP060
      ** Security Price ID validation                                                         CAP060
      *                                                                                       CAP060
     C                   IF        CAP060 = 'Y'                                               CAP060
      /COPY WNCPYSRC,SESEC1V054                                                               CAP060
     C                   EXSR      SRSpId                                                     CAP060
      /COPY WNCPYSRC,SESEC1V055                                                               CAP060
     C                   ENDIF                                                                CAP060
      *                                                                                       CSD006
      ** Data Source Override validation                                                      CSD006
      *                                                                                       CSD006
     C                   IF        CSD006 = 'Y'                                               CSD006
      /COPY WNCPYSRC,SESEC1V056                                                               CSD006
     C                   EXSR      SRVSPdso                                                   CSD006
      /COPY WNCPYSRC,SESEC1V057                                                               CSD006
     C                   ENDIF                                                                CSD006
      *
      ** Incomplete indicator validation
      *
      /COPY WNCPYSRC,SESEC1V006
 
     C                   EXSR      SRIncIn
 
      /COPY WNCPYSRC,SESEC1V007
      *
      ** Issuer validation
      *
      /COPY WNCPYSRC,SESEC1V008
 
     C                   EXSR      SRIssr
 
      /COPY WNCPYSRC,SESEC1V009
      *
      ** New issue validation
      *
      /COPY WNCPYSRC,SESEC1V010
 
     C                   EXSR      SRNewIss
 
      /COPY WNCPYSRC,SESEC1V011
      *
      ** Nominal currency validation
      *
      /COPY WNCPYSRC,SESEC1V012
 
     C                   EXSR      SRNomCcy
 
      /COPY WNCPYSRC,SESEC1V013
      *
      ** Investment type validation
      *
      /COPY WNCPYSRC,SESEC1V014
 
     C                   EXSR      SRInvTyp
 
      /COPY WNCPYSRC,SESEC1V015
      *
      ** Partly paid indicator validation
      *
      /COPY WNCPYSRC,SESEC1V016
 
     C                   EXSR      SRPartPd
 
      /COPY WNCPYSRC,SESEC1V017
                                                                                              CGL032
      ** Taxation on Savings Income                                                           CGL032
                                                                                              CGL032
     C                   IF        CGL032 = 'Y'                                               CGL032
     C                   EXSR      SRVsetx                                                    CGL032
     C                   ENDIF                                                                CGL032
      *
      ** Trade basis override validation
      *
      /COPY WNCPYSRC,SESEC1V018
 
     C                   EXSR      SRTrBsOv
      *                                                                         183604
      ** Rating Code validation                                                 183604
      *                                                                         183604
                                                                                183604
     C                   IF        BGN4ST = 'Y'                                 183604
     C                   EXSR      SRRtgCod                                     183604
     C                   ENDIF                                                  183604
 
      /COPY WNCPYSRC,SESEC1V019
      *
      ** Market indicator validation
      *
      /COPY WNCPYSRC,SESEC1V020
 
     C                   EXSR      SRMktInd
 
      /COPY WNCPYSRC,SESEC1V021
      *
      ** Trade denomination validation
      *
      /COPY WNCPYSRC,SESEC1V022
 
     C                   EXSR      SRTrdDnm
 
      /COPY WNCPYSRC,SESEC1V023
      *
      ** Early repayment validation
      *
      /COPY WNCPYSRC,SESEC1V024
 
     C                   EXSR      SRErRpy
 
      /COPY WNCPYSRC,SESEC1V025
      *
      ** Value date default validation
      *
      /COPY WNCPYSRC,SESEC1V026
 
     C                   EXSR      SRVDtDft
 
      /COPY WNCPYSRC,SESEC1V027
      *
      ** Extension date default validation
      *
      /COPY WNCPYSRC,SESEC1V028
 
     C                   EXSR      SREDtDft
 
      /COPY WNCPYSRC,SESEC1V029
      *
      ** Value currency validation
      *
      /COPY WNCPYSRC,SESEC1V030
 
     C                   EXSR      SRValCcy
 
      /COPY WNCPYSRC,SESEC1V031
      *
      ** Multi currency indicator validation
      *
      /COPY WNCPYSRC,SESEC1V032
 
     C                   EXSR      SRMulCcy
 
      /COPY WNCPYSRC,SESEC1V033
      *
      ** Industry code validation
      *
      /COPY WNCPYSRC,SESEC1V034
 
     C                   EXSR      SRIndCd
 
      /COPY WNCPYSRC,SESEC1V035
      *
      ** Country of risk validation
      *
      /COPY WNCPYSRC,SESEC1V036
 
     C                   EXSR      SRCntRsk
 
      /COPY WNCPYSRC,SESEC1V037
      *
      ** ISIN/common code validation. Validate only if MT5xx feature
      ** or Private banking module is present.
      *
      /COPY WNCPYSRC,SESEC1V038
 
     C                   IF        S01401 = 'Y' OR BGN4ST = 'Y'
     C                   EXSR      SRISIN
     C                   ELSE
     C                   EVAL      DDISIN = *BLANKS
     C                   ENDIF
 
      /COPY WNCPYSRC,SESEC1V039
      *
      ** Swift security type code validation. Validate only if MT5xx
      ** feature is installed.
      *
      /COPY WNCPYSRC,SESEC1V040
 
     C                   IF        S01401 = 'Y'
     C                   EXSR      SRSwTyp
     C                   ELSE
     C                   IF        BGN4ST = 'Y'
     C                   EVAL      S1SWTP = DDSWTP
     C                   ELSE
     C                   EVAL      DDSWTP = *BLANKS
     C                   ENDIF
     C                   ENDIF
 
      /COPY WNCPYSRC,SESEC1V041
      *
      ** Nominal decimal places validation
      *
      /COPY WNCPYSRC,SESEC1V042
 
     C                   EXSR      SRNomDp
 
      /COPY WNCPYSRC,SESEC1V043
      *
      ** Additional validation if feature CSE011 is installed
      *
      /COPY WNCPYSRC,SESEC1V044
 
     C                   IF        CSE011 = 'Y'
 
      /COPY WNCPYSRC,SESEC1V045
      *
      ** Sedol/extel validation
      *
      /COPY WNCPYSRC,SESEC1V046
 
     C                   EXSR      SRSedol
 
      /COPY WNCPYSRC,SESEC1V047
      *
      ** Telekurs validation
      *
      /COPY WNCPYSRC,SESEC1V048
 
     C                   EXSR      SRTlKurs
 
      /COPY WNCPYSRC,SESEC1V049
      *
      ** Cusip validation
      *
      /COPY WNCPYSRC,SESEC1V050
 
     C                   EXSR      SRCusip
     C                   ELSE
     C                   EVAL      S1SREF = DDSREF
     C                   EVAL      S1T2RF = DDT2RF
     C                   EVAL      S1CSPN = DDCSPN
 
     C                   ENDIF
 
      /COPY WNCPYSRC,SESEC1V051
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,SESEC1V052
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRptNm - Security Report Name validation process            *
      *                                                               *
      *****************************************************************
 
     C     SRRptNm       BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSRPNM'
      *                             ========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************                       CAP060
      *                                                               *                       CAP060
      *  SRSpId  - Security Price Id validation process               *                       CAP060
      *                                                               *                       CAP060
      *****************************************************************                       CAP060
                                                                                              CAP060
     C     SRSpId        BEGSR                                                                CAP060
      *                                                                                       CAP060
      ** Reset variables updated by each module                                               CAP060
      *                                                                                       CAP060
     C                   EXSR      SRResetErrs                                                CAP060
      *                                                                                       CAP060
      ** Call validation module                                                               CAP060
      *                                                                                       CAP060
     C                   CALLB     'SEVSPID01'                                                CAP060
      *                             =========                                                 CAP060
      ** INPUTS                                                                               CAP060
      ** ======                                                                               CAP060
      *                                                                                       CAP060
      ** Return code                                                                          CAP060
     C                   PARM                    RetCodeOut                                   CAP060
      *                                                                                       CAP060
      ** Action Code                                                                          CAP060
     C                   PARM                    DDACTN            1                          CAP060
      ** Security Shortname                                                                   CAP060
     C                   PARM                    DDSESN           10                          CAP060
      ** Security Price Id                                                                    CAP060
     C                   PARM                    DDSPID           20                          CAP060
      *                                                                                       CAP060
      ** OUTPUT                                                                               CAP060
      ** ======                                                                               CAP060
      *                                                                                       CAP060
      ** Error fields/message IDs/message data (arrays) from/to caller                        CAP060
     C                   PARM                    FldNamXAr                                    CAP060
     C                   PARM                    MsgIDXAr                                     CAP060
     C                   PARM                    MsgDtaXAr                                    CAP060
      *                                                                                       CAP060
      ** Securities Price Id in file format                                                   CAP060
     C                   PARM                    S1SPID                                       CAP060
      ** Securities screen 1 error indicator                                                  CAP060
     C                   PARM                    OKSPID                                       CAP060
      *                                                                                       CAP060
      ** Update error info with that returned from the validation module                      CAP060
      *                                                                                       CAP060
     C                   IF        RetCodeOut <> *BLANKS                                      CAP060
     C                   EXSR      SRUpdatErrs                                                CAP060
     C                   ENDIF                                                                CAP060
                                                                                              CAP060
     C                   ENDSR                                                                CAP060
                                                                                              CAP060
      *****************************************************************                       CSD006
      /EJECT                                                                                  CSD006
      *****************************************************************                       CSD006
      *                                                               *                       CSD006
      *  SRVSPdso- Security Price Data Source Override validation     *                       CSD006
      *                                                               *                       CSD006
      *****************************************************************                       CSD006
                                                                                              CSD006
     C     SRVSPdso      BEGSR                                                                CSD006
      *                                                                                       CSD006
      ** Reset variables updated by each module                                               CSD006
      *                                                                                       CSD006
     C                   EXSR      SRResetErrs                                                CSD006
      *                                                                                       CSD006
      ** Call validation module                                                               CSD006
      *                                                                                       CSD006
     C                   CALLB     'SEVSPDS01'                                                CSD006
      *                             =========                                                 CSD006
      ** INPUTS                                                                               CSD006
      ** ======                                                                               CSD006
      *                                                                                       CSD006
      ** Return code                                                                          CSD006
     C                   PARM                    RetCodeOut                                   CSD006
      *                                                                                       CSD006
      ** Security Price Data Source Override, screen format                                   CSD006
      **                                                                                      CSD006
     C                   PARM                    DDSPDS                                       CSD006
      *                                                                                       CSD006
      ** OUTPUT                                                                               CSD006
      ** ======                                                                               CSD006
      *                                                                                       CSD006
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSD006
     C                   PARM                    FldNamXAr                                    CSD006
     C                   PARM                    MsgIDXAr                                     CSD006
     C                   PARM                    MsgDtaXAr                                    CSD006
      *                                                                                       CSD006
      ** Sec Price data source override in file format                                        CSD006
     C                   PARM                    S1SPDS                                       CSD006
      *                                                                                       CSD006
      ** Securities screen 1 error indicator                                                  CSD006
     C                   PARM                    OKSPDS                                       CSD006
      ** Redisplay screen                                                                     CSD006
     C                   PARM                    PReDsp                                       CSD006
      *                                                                                       CSD006
      ** Update error info with that returned from the validation module                      CSD006
      *                                                                                       CSD006
     C                   IF        RetCodeOut <> *BLANKS                                      CSD006
     C                   EXSR      SRUpdatErrs                                                CSD006
     C                   ENDIF                                                                CSD006
                                                                                              CSD006
     C                   ENDSR                                                                CSD006
                                                                                              CSD006
      *****************************************************************                       CSD006
      /EJECT                                                                                  CSD006
      *****************************************************************
      *                                                               *
      *  SRIssr - Issuer validation process                           *
      *                                                               *
      *****************************************************************
 
     C     SRIssr        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSISSR'
      *                             ========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
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
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNewIss - New Issue validation process                      *
      *                                                               *
      *****************************************************************
 
     C     SRNewIss      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSNISS'
      *                             ========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIncIn - Incomplete Indicator validation process            *
      *                                                               *
      *****************************************************************
 
     C     SRIncIn       BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSINCI'
      *                             ========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNomCcy - Nominal Currency validation process               *
      *                                                               *
      *****************************************************************
 
     C     SRNomCcy      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSNMCCY'
      *                             =========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
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
      ** Securities Screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Spot rate for nominal currency
     C                   PARM                    PRate1
      *
      ** Multiply/divide indicator for nominal currency
     C                   PARM                    PMDI1
      *
      ** Nominal currency's number of decimal places
     C                   PARM                    PNMDP
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInvTyp- Investment Type validation process                 *
      *                                                               *
      *****************************************************************
 
     C     SRInvTyp      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSINVTP'
      *                             =========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
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
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Externally described DS for investment types
     C                   PARM                    PInvtp
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPartPd - Partly Paid Indicator validation process          *
      *                                                               *
      *****************************************************************
 
     C     SRPartPd      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSPPDI'
      *                             ========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTrBsOv - Trade Basis Override validation process           *
      *                                                               *
      *****************************************************************
 
     C     SRTrBsOv      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSTRDOV'
      *                             =========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************         183604
      *                                                               *         183604
      *  SRRtgCod - Rating Code validation process                    *         183604
      *                                                               *         183604
      *****************************************************************         183604
                                                                                183604
     C     SRRtgCod      BEGSR                                                  183604
      *                                                                         183604
      ** Reset variables updated by each module                                 183604
      *                                                                         183604
     C                   EXSR      SRResetErrs                                  183604
      *                                                                         183604
      ** Call validation module                                                 183604
      *                                                                         183604
     C                   CALLB     'SEVSRATNG'                                  183604
      *                             =========                                   183604
      ** INPUTS                                                                 183604
      ** ======                                                                 183604
      *                                                                         183604
      ** Return code                                                            183604
     C                   PARM                    RetCodeOut                     183604
      *                                                                         183604
      ** Mode = '*FRONT' (Front Office Transaction Interface)                   183604
      ** Mode = '      ' (Not Front Office Transaction Interface)               183604
      ** Mode = '*RPR  ' (Repair function)                                      183604
      ** Mode = '*SIN  ' (Screen Input function)                                183604
     C                   PARM                    PMode                          183604
      *                                                                         183604
      ** Securities screen 1 details from incoming transaction                  183604
      ** - screen format                                                        183604
     C                   PARM                    NwSE1ScnFmt                    183604
      *                                                                         183604
      ** Redisplay screen                                                       183604
     C                   PARM                    PReDsp                         183604
      *                                                                         183604
      ** OUTPUT                                                                 183604
      ** ======                                                                 183604
      *                                                                         183604
      ** Error fields/message IDs/message data (arrays) from/to caller          183604
     C                   PARM                    FldNamXAr                      183604
     C                   PARM                    MsgIDXAr                       183604
     C                   PARM                    MsgDtaXAr                      183604
      *                                                                         183604
      ** Securities screen 1 error indicators                                   183604
     C                   PARM                    SEESEC1                        183604
      *                                                                         183604
      ** Securities for file update - file format                               183604
     C                   PARM                    NwSEFilFmt                     183604
      *                                                                         183604
      ** Update error info with that returned from the validation module        183604
      *                                                                         183604
     C                   IF        RetCodeOut <> *BLANKS                        183604
     C                   EXSR      SRUpdatErrs                                  183604
     C                   ENDIF                                                  183604
                                                                                183604
     C                   ENDSR                                                  183604
                                                                                183604
      *****************************************************************         183604
      /EJECT                                                                    183604
      *****************************************************************
      *                                                               *
      *  SRMktInd - Market Indicator validation process               *
      *                                                               *
      *****************************************************************
 
     C     SRMktInd      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSMKTI'
      *                             ========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Default market indicator from, PF/INVTPD
     C                   PARM                    PDMAR
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Market migration
     C                   PARM                    S01511
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTrdDnm - Trade Denomination validation process             *
      *                                                               *
      *****************************************************************
 
     C     SRTrdDnm      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSTRDDN'
      *                             =========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Default trade denomination from PF/INVTPD
     C                   PARM                    PDTRD
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErRpy - Early Repayment Validation Process                 *
      *                                                               *
      *****************************************************************
 
     C     SRErRpy       BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSERPMT'
      *                             =========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDtDft - Value Date Default validation process             *
      *                                                               *
      *****************************************************************
 
     C     SRVDtDft      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSVDDFT'
      *                             =========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREDtDft - Extension Date Default validation process         *
      *                                                               *
      *****************************************************************
 
     C     SREDtDft      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSEDDFT'
      *                             =========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValCcy - Value Currency Validation Process                 *
      *                                                               *
      *****************************************************************
 
     C     SRValCcy      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSVLCCY'
      *                             =========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** Default value currency from, PF/INVTPD
     C                   PARM                    PDVCY
      *
      ** Spot rate for nominal currency
     C                   PARM                    PRate1
      *
      ** Multiply/divide indicator for nominal currency
     C                   PARM                    PMDI1
      *
      ** Nominal currency's no. of decimal places
     C                   PARM                    PNMDP
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Corporate actions
     C                   PARM                    CSE007
      *
      ** Securities redenomination
     C                   PARM                    CEU017
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Value currency's no. of decimal places
     C                   PARM                    PVLDP
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMulCcy - Multi-Currency validation process                 *
      *                                                               *
      *****************************************************************
 
     C     SRMulCcy      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSMLCCY'
      *                             =========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Default multi-currency indicator from, PF/INVTPD
     C                   PARM                    PDMCY
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      **********                                                                       183604 222373
      ***SDMMOD*- Private banking                                                      183604 222373
     C**********         PARM                    BGN4ST                                183604 222373
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIndCd - Industry Code Validation Process                   *
      *                                                               *
      *****************************************************************
 
     C     SRIndCd       BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSINDCD'
      *                             =========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
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
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *                                                                                       222373
      ** SDMMOD - Private banking                                                             222373
     C                   PARM                    BGN4ST                                       222373
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCntRsk - Country of Risk validation process                *
      *                                                               *
      *****************************************************************
 
     C     SRCntRsk      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSCRISK'
      *                             =========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
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
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRISIN - ISIN/COMMON Code validation process                 *
      *                                                               *
      *****************************************************************
 
     C     SRISIN        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSISNCD'
      *                             =========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** SWITCHABLE FEATURE
      ** ==================
      *
      ** Duplicate security code check
     C                   PARM                    CSE011
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSwTyp - SWIFT Security Type Code Validation Process        *
      *                                                               *
      *****************************************************************
 
     C     SRSwTyp       BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSWTYCD'
      *                             =========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNomDp - Nominal Decimal Places validation process          *
      *                                                               *
      *****************************************************************
 
     C     SRNomDp       BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSNMDP'
      *                             ========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Nominal currency's number of decimal places
     C                   PARM                    PNMDP
      *
      ** SWITCHABLE FEATURE
      ** ==================
      *
      ** Decimals on nominals
     C                   PARM                    CEU018
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSedol - SEDOL/EXTEL validation process                     *
      *                                                               *
      *****************************************************************
 
     C     SRSedol       BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSSEDOL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTlKurs - TELEKURS validation process                       *
      *                                                               *
      *****************************************************************
 
     C     SRTlKurs      BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSTKURS'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCusip - CUSIP validation process                           *
      *                                                               *
      *****************************************************************
 
     C     SRCusip       BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVSCUSIP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CGL032
      *****************************************************************                       CGL032
      *                                                               *                       CGL032
      *  SRVsetx - Routine to validate the European Tax Indicator.    *                       CGL032
      *            Call SEVSSETAX.                                    *                       CGL032
      *                                                               *                       CGL032
      *****************************************************************                       CGL032
     C     SRVsetx       BEGSR                                                                CGL032
      *                                                                                       CGL032
      ** Reset variables updated by each module                                               CGL032
      *                                                                                       CGL032
     C                   EXSR      SRResetErrs                                                CGL032
                                                                                              CGL032
      ** Call validation module                                                               CGL032
                                                                                              CGL032
     C                   CALLB     'SEVSSETAX'                                                CGL032
                                                                                              CGL032
      ** INPUT                                                                                CGL032
      ** =====                                                                                CGL032
      ** Return code                                                                          CGL032
                                                                                              CGL032
     C                   PARM                    RetCodeOut                                   CGL032
                                                                                              CGL032
      ** Securities screen 1 details from incoming transaction                                CGL032
      ** - screen format                                                                      CGL032
                                                                                              CGL032
     C                   PARM                    NwSE1ScnFmt                                  CGL032
                                                                                              CGL032
      ** Processing type from PF/INVTPD                                                       CGL032
                                                                                              CGL032
     C                   PARM                    PPROT                                        CGL032
                                                                                              CGL032
      ** OUTPUT                                                                               CGL032
      ** ======                                                                               CGL032
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL032
                                                                                              CGL032
     C                   PARM                    FldNamXAr                                    CGL032
     C                   PARM                    MsgIDXAr                                     CGL032
     C                   PARM                    MsgDtaXAr                                    CGL032
                                                                                              CGL032
      ** Securities for file update - file format                                             CGL032
                                                                                              CGL032
     C                   PARM                    NwSEFilFmt                                   CGL032
                                                                                              CGL032
      ** Securities screen 1 error indicator                                                  CGL032
                                                                                              CGL032
     C                   PARM                    SEESEC1                                      CGL032
                                                                                              CGL032
      ** Update error info with that returned from the validation module                      CGL032
                                                                                              CGL032
     C                   IF        RetCodeOut <> *BLANKS                                      CGL032
     C                   EXSR      SRUpdatErrs                                                CGL032
     C                   ENDIF                                                                CGL032
      *                                                                                       CGL032
     C                   ENDSR                                                                CGL032
      *****************************************************************                       CGL032
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErrs - Routine to reset Error Information that is     *
      *                received from each validation module           *
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
      *
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
     C     *Blank        LOOKUP    FldNameArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     FldNamXar     FldNameArr(Ix)
     C                   MOVEA     MsgIDXAr      MsgIdArr(Ix)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Error Index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FLDNAMEARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             IDx
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       FLDNAMEARR(Ix)
     C                   MOVE      *BLANKS       MSGIDARR(Ix)
     C                   MOVE      *BLANKS       MSGDTAARR(Ix)
     C                   EVAL      IDx = ArrayMax - 1
     C                   ENDIF
      *
      ** Update warning fields/message IDs/message data (arrays).
      *
     C                   EVAL      Ix = 1
     C     *Blank        LOOKUP    WFldNamArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     WFldNmXAr     WFldNamArr(Ix)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(Ix)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Warning Index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    WFLDNAMARR(Ix)                         99
     C     *IN99         IFEQ      '1'
     C     Ix            SUB       1             WIDx
     C                   ELSE
     C                   EVAL      Ix = ArrayMax
     C                   MOVE      *BLANKS       WFLDNAMARR(Ix)
     C                   MOVE      *BLANKS       WMSGIDARR(Ix)
     C                   MOVE      *BLANKS       WMSGDTAARR(Ix)
     C                   EVAL      WIDx = ArrayMax - 1
     C                   ENDIF
 
     C                   ENDSR
      *
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
     C                   PARM                    PResponse
      *
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Securities screen 1 details retrieved from file
      ** - screen format
     C                   PARM                    CrSE1ScnFmt
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Private banking
     C                   PARM                    BGN4ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Securities redenomination
     C                   PARM                    CEU017
      *
      ** Decimals on nominals
     C                   PARM                    CEU018
      *
      ** Corporate actions
     C                   PARM                    CSE007
      *
      ** Duplicate security code check
     C                   PARM                    CSE011
      *
      ** MT5xx message generation
     C                   PARM                    S01401
      *
      ** Market migration
     C                   PARM                    S01511
      *                                                                                       CSD006
      ** Market Data Feed                                                                     CSD006
     C                   PARM                    CSD006                                       CSD006
      *                                                                                       CAP060
      ** Midas APIs Sec Prices                                                                CAP060
     C                   PARM                    CAP060                                       CAP060
                                                                                              CGL032
      ** Taxation on Savings Income                                                           CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
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
      ** Securities screen 1 error indicators
     C                   PARM                    SEESEC1
      *
      ** Securities screen 2 error indicators
     C                   PARM                    SEESEC2
      *
      ** Securities for file update - file format
     C                   PARM                    NwSEFilFmt
      *
      ** Externally described DS for Investment types
     C                   PARM                    PInvtp
      *
      ** Nominal currency's no. of decimal places
     C                   PARM                    PNMDP
      *
      ** Value currency's no. of decimal places
     C                   PARM                    PVLDP
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,SESEC1V053
      *
     C                   ENDSR
      *
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
