     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Sec Diary Events Validation Controller 1')    *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDE1VL - Security Diary Events Validation Controller 1    *
      *                                                               *
      *  Function: This module validates Security Diary Events screen *
      *            1 fields for input into the Midas database.        *
      *                                                               *
      *  Component of: SESEDESIN                                      *
      *                SESEDECTL                                      *
      *                SESEDERPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 18Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 CSE072             Date 05Apr05               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSE072 - INT-CC3 - Brazilian C-Bonds                         *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         Use for LOOKUP command                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrSDDV - Amount per Unit validation process                  *
      *  SrSDPD - Payment date validation process                     *
      *  SrSDXD - Extension Date validation process                   *
      *  SrCAMT - Call Amount validation process                      *
      *  SrCPRI - Call/Put Percentage validation process              *
      *  SrSDCP - Current Factor validation process                   *
      *  SrSRPT - Repayment Amount validation process                 *
      *  SrSDNC - Next Coupon Rate validation process                 *
      *  SrSCRS - Credit Risk Spread validation process               *                       CAS006
      *  SrSLQP - Liquidity Premium validation process                *                       CAS006
      *  SrNetTrRt - Calculation/Validation of Net Treasury Rate      *                       CAS006
      *  SrPAYC - Payment Currency validation process                 *
      *  SrCUTR - Cut Coupon Rate validation process                  *
      *  SrSDMD - Multiply/Divide Indicator validation process        *
      *  SrCLAT - Call/Put Amount validation process                  *
      *  SrRAMT - Redemption Price validation process                 *
      *  SrRCIC - Include in Risk/Anal. Cash Flow validation process  *
      *  SrRCCY - Redemption Currency validation process              *
      *  SrXRAT - Exchange Rate validation process                    *
      *  SrRCMD - Multiply/Divide Indicator validation process        *
      *  SrSDCV - Conversion Security validation process              *
      *  SrCONC - Conversion Currency validation process              *
      *  SrCONR - Conversion Exchange Rate validation process         *
      *  SrCONP - Conversion Price validation process                 *
      *  SrNAR1 - Narrative 1 validation process                      *
      *  SrNAR2 - Narrative 2 validation process                      *
      *  SrNAR4 - Narrative 4 validation process                      *
      *  SRSDAL - Validate Average Life Date                          *                       CSE065
      *  SRResetErrs - Routine to reset Error Information that is     *
      *                received from each validation module           *
      *  SRUpdatErrs - Routine to update Error Information with that  *
      *                received back from each validation module      *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *                                                                                       CSE065
      ** Midas SE Security Diary Events by Average Life Date                                  CSE065
     FSEDEVAL   IF   E           K DISK    INFSR(*PSSR) PREFIX(F1)                            CSE065
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SESED1V001
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
      ** SE Diary Events Screen details from incoming transaction -
      ** - screen format
     D NwDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
      *
      ** SE Diary Events for file update - file format
     D NwDEFilFmt    E DS                  EXTNAME(SEVSEDEPD)
      *
      ** Security diary events retrieved from file - file format
      ** This DS will be passed to the calling module.
     D CrDEFilFmt    E DS                  EXTNAME(SEDEVD)
      *
      ** SE Diary Events screen error indicators
     D SEESEDE       E DS                  EXTNAME(SEESEDEPD)
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(D1)
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
     D CSE010          S              1A
     D S01509          S              1A
     D S01510          S              1A
     D CAS006          S              1A                                                      CAS006
     D CSE072          S              1A                                                      CSE072
     D CSE065          S              1A                                                      CSE065
     D CGL031          S              1A                                                      CGL031
      *
      ** Standing Data
     D BJDFIN          S              1A
     D RMFL            S              1A
     D BJRDNB          S              5P 0                                                    CSE065
      *
      ** Work parameters
     D PEvtDno         S              5P 0
     D PPROT           S              1A
     D PFieldName      S             10A                                                      CAS006
     D PSpdRate        S             17A                                                      CAS006
     D PValSpdRate     S             15P 8                                                    CAS006
                                                                                              CAS006
      ** Work variables                                                                       CAS006
     D WIx             S              3P 0                                                    CAS006
     D WUSpdRt         S                   LIKE(PValSpdRate)                                  CAS006
     D KSDAL           S              5P 0                                                    CSE065
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SESED1V002
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
                                                                                              CAS006
      ** +--------------------------------------+                                             CAS006
      ** ¦ Prototype Declarations               ¦                                             CAS006
      ** ¦ ======================               ¦                                             CAS006
      ** +--------------------------------------+                                             CAS006
                                                                                              CAS006
      ** Spread Rate Overflow Monitor                                                         CAS006
     D SPSpdRtOvf      PR             1A                                                      CAS006
     D  PSpdRt                       15P 8 VALUE                                              CAS006
                                                                                              CAS006
      ** Spread Rate Significant Decimal Positions Calculator                                 CAS006
     D SPGetSpdRtDP    PR             2P 0                                                    CAS006
     D  PSpdRt                       16A   VALUE                                              CAS006
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** M A I N  P R O C E S S I N G
      *
      /COPY WNCPYSRC,SESED1V003
      *
      ** Validate fields according to event type.
      *
      /COPY WNCPYSRC,SESED1V004
 
     C                   SELECT
 
      /COPY WNCPYSRC,SESED1V005
      *
      ** Dividends Declared
      ** ==================
      *
     C                   WHEN      DDSDET = 'DV'
 
      /COPY WNCPYSRC,SESED1V006
      *
      ** Amount per unit validation.
      *
      /COPY WNCPYSRC,SESED1V007
 
     C                   EXSR      SrSDDV
 
      /COPY WNCPYSRC,SESED1V008
      *
      ** Narrative 1 validation.
      *
      /COPY WNCPYSRC,SESED1V009
 
     C                   EXSR      SrNAR1
 
      /COPY WNCPYSRC,SESED1V010
      *
      ** Payment date validation.
      *
      /COPY WNCPYSRC,SESED1V011
 
     C                   EXSR      SrSDPD
 
     C                   IF        S01510 = 'Y'
 
      /COPY WNCPYSRC,SESED1V012
      *
      ** Extension date validation.
      *
      /COPY WNCPYSRC,SESED1V013
 
     C                   EXSR      SrSDXD
 
     C                   ELSE
 
      /COPY WNCPYSRC,SESED1V014
 
     C                   EVAL      S2SDXD = *ZEROS
     C                   ENDIF
 
      /COPY WNCPYSRC,SESED1V015
                                                                                              CGL031
      ** European Tax validation                                                              CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   EXSR      SrSETX                                                     CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Partly Paid
      ** ===========
      *
     C                   WHEN      DDSDET = 'PP'
 
      /COPY WNCPYSRC,SESED1V016
 
     C                   IF        PPROT = '4'
 
      /COPY WNCPYSRC,SESED1V017
      *
      ** For shares, perform call amount validation.
      *
      /COPY WNCPYSRC,SESED1V018
 
     C                   EXSR      SrCAMT
     C                   ELSE
 
      /COPY WNCPYSRC,SESED1V019
      *
      ** For non-shares, perform call percentage validation.
      *
      /COPY WNCPYSRC,SESED1V020
 
     C                   EXSR      SrCPRI
     C                   ENDIF
 
      /COPY WNCPYSRC,SESED1V021
      *
      ** Narrative 1 validation.
      *
      /COPY WNCPYSRC,SESED1V022
 
     C                   EXSR      SrNAR1
 
      /COPY WNCPYSRC,SESED1V023
      *
      ** Mortgage Payment
      ** ================
      *
     C                   WHEN      DDSDET = 'MP'
 
      /COPY WNCPYSRC,SESED1V024
      *
      ** Current factor validation.
      *
      /COPY WNCPYSRC,SESED1V025
 
     C                   EXSR      SrSDCP
 
      /COPY WNCPYSRC,SESED1V026
      *
      ** Payment date validation.
      *
      /COPY WNCPYSRC,SESED1V027
 
     C                   EXSR      SrSDPD
 
      /COPY WNCPYSRC,SESED1V028
      *
      ** Repayment amount validation.
      *
      /COPY WNCPYSRC,SESED1V029
 
     C                   EXSR      SrSRPT
 
      /COPY WNCPYSRC,SESED1V030
      *
      ** Narrative 2 validation.
      *
      /COPY WNCPYSRC,SESED1V031
 
     C                   EXSR      SrNAR2
 
      /COPY WNCPYSRC,SESED1V032
      *
      ** Interest Rate Change
      ** ====================
      *
     C                   WHEN      DDSDET = 'IR'
 
      /COPY WNCPYSRC,SESED1V033
      *
      ** Next coupon rate validation.
      *
      /COPY WNCPYSRC,SESED1V034
 
     C                   EXSR      SrSDNC
 
      /COPY WNCPYSRC,SESED1V035
      *
      ** Narrative 1 update.
      *
      /COPY WNCPYSRC,SESED1V036
 
     C                   MOVE      DDNAR1        S2SDNV
                                                                                              CAS006
      ** If CAS006 is installed.                                                              CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
                                                                                              CAS006
      ** Credit Risk Spread validation                                                        CAS006
                                                                                              CAS006
     C                   EXSR      SRSCRS                                                     CAS006
                                                                                              CAS006
      ** Liquidity Premium validation                                                         CAS006
                                                                                              CAS006
     C                   EXSR      SRSLQP                                                     CAS006
                                                                                              CAS006
      ** Calculate Net Treasury Rate                                                          CAS006
                                                                                              CAS006
     C                   EXSR      SRNetTrRt                                                  CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
 
      /COPY WNCPYSRC,SESED1V037
      *
      ** Exhange Rates
      ** =============
      *
     C                   WHEN      DDSDET = 'XR'
 
      /COPY WNCPYSRC,SESED1V038
      *
      ** Payment currency validation.
      *
      /COPY WNCPYSRC,SESED1V039
 
     C                   EXSR      SrPAYC
 
      /COPY WNCPYSRC,SESED1V040
      *
      ** Cut coupon rate validation.
      *
      /COPY WNCPYSRC,SESED1V041
 
     C                   EXSR      SrCUTR
 
      /COPY WNCPYSRC,SESED1V042
      *
      ** Multiply/divide indicator validation.
      *
      /COPY WNCPYSRC,SESED1V043
 
     C                   EXSR      SrSDMD
 
      /COPY WNCPYSRC,SESED1V044
      *
      ** Narrative 3 update.
      *
      /COPY WNCPYSRC,SESED1V045
 
     C                   MOVE      DDNAR3        S2SDNV
 
      /COPY WNCPYSRC,SESED1V046
      *
      ** Redemption Calls
      ** ================
      *
     C                   WHEN      DDSDET = 'RC'
 
      /COPY WNCPYSRC,SESED1V047
      *
      ** Call amount validation.
      *
      /COPY WNCPYSRC,SESED1V048
 
     C                   EXSR      SrCLAT
 
      /COPY WNCPYSRC,SESED1V049
      *
      ** Call percentage validation.
      *
      /COPY WNCPYSRC,SESED1V050
 
     C                   EXSR      SrCPRI
 
      /COPY WNCPYSRC,SESED1V051
      *
      ** Redemption price validation.
      *
      /COPY WNCPYSRC,SESED1V052
 
     C                   EXSR      SrRAMT
 
      /COPY WNCPYSRC,SESED1V053
      *
      ** Narrative 2 update.
      *
      /COPY WNCPYSRC,SESED1V054
 
     C                   MOVE      DDNAR2        S2SDNV
 
      /COPY WNCPYSRC,SESED1V055
      *
      ** Strategic risk management is on, perform risk/analysis
      ** cash flow validation.
      *
      /COPY WNCPYSRC,SESED1V056
 
     C                   IF        RMFL = 'Y'
     C                   EXSR      SrRCIC
     C                   ENDIF
 
     C                   IF        S01509 = 'Y'
 
      /COPY WNCPYSRC,SESED1V057
      *
      ** Redemption currency validation.
      *
      /COPY WNCPYSRC,SESED1V058
 
     C                   EXSR      SrRCCY
 
      /COPY WNCPYSRC,SESED1V059
      *
      ** Exchange rate validation.
      *
      /COPY WNCPYSRC,SESED1V060
 
     C                   EXSR      SrXRAT
 
      /COPY WNCPYSRC,SESED1V061
      *
      ** Multiply/divide indicator validation.
      *
      /COPY WNCPYSRC,SESED1V062
 
     C                   EXSR      SrRCMD
 
     C                   ENDIF
 
      /COPY WNCPYSRC,SESED1V063
      *
      ** Redemption Puts
      ** ===============
      *
     C                   WHEN      DDSDET = 'RP'
 
      /COPY WNCPYSRC,SESED1V064
      *
      ** Put amount validation.
      *
      /COPY WNCPYSRC,SESED1V065
 
     C                   EXSR      SrCLAT
 
      /COPY WNCPYSRC,SESED1V066
      *
      ** Put percentage validation.
      *
      /COPY WNCPYSRC,SESED1V067
 
     C                   EXSR      SrCPRI
 
      /COPY WNCPYSRC,SESED1V068
      *
      ** Redemption price validation.
      *
      /COPY WNCPYSRC,SESED1V069
 
     C                   EXSR      SrRAMT
 
      /COPY WNCPYSRC,SESED1V070
      *
      ** Narrative 2 update.
      *
      /COPY WNCPYSRC,SESED1V071
 
     C                   MOVE      DDNAR2        S2SDNV
 
      /COPY WNCPYSRC,SESED1V072
      *
      ** Conversions
      ** ===========
      *
     C                   WHEN      DDSDET = 'CV'
 
      /COPY WNCPYSRC,SESED1V073
      *
      ** Conversion security validation.
      *
      /COPY WNCPYSRC,SESED1V074
 
     C                   EXSR      SrSDCV
 
      /COPY WNCPYSRC,SESED1V075
      *
      ** Conversion currency validation.
      *
      /COPY WNCPYSRC,SESED1V076
 
     C                   EXSR      SrCONC
 
      /COPY WNCPYSRC,SESED1V077
      *
      ** Conversion exchange rate validation.
      *
      /COPY WNCPYSRC,SESED1V078
 
     C                   EXSR      SrCONR
 
      /COPY WNCPYSRC,SESED1V079
      *
      ** Conversion price validation.
      *
      /COPY WNCPYSRC,SESED1V080
 
     C                   EXSR      SrCONP
 
      /COPY WNCPYSRC,SESED1V081
      *
      ** Narrative 3 update.
      *
      /COPY WNCPYSRC,SESED1V082
 
     C                   MOVE      DDNAR3        S2SDNV
 
      /COPY WNCPYSRC,SESED1V083
      *
      ** Bonus Issues, Rights Issues, Capital Reorganisation and
      ** =======================================================
      ** Other Changes.
      ** ==============
      *
     C                   WHEN      DDSDET = 'BI' OR
     C                             DDSDET = 'RI' OR
     C                             DDSDET = 'CR' OR
     C                             DDSDET = 'OC'
 
      /COPY WNCPYSRC,SESED1V084
      *
      ** Narrative 4 validation.
      *
      /COPY WNCPYSRC,SESED1V085
 
     C                   EXSR      SrNAR4
 
      /COPY WNCPYSRC,SESED1V086
                                                                                              CSE065
      ** Average Life Date                                                                    CSE065
                                                                                              CSE065
     C                   WHEN      CSE065 = 'Y'  AND                                          CSE065
     C                             DDSDET = 'AL'                                              CSE065
                                                                                              CSE065
      ** Average Life Date validation                                                         CSE065
                                                                                              CSE065
     C                   EXSR      SRSDAL                                                     CSE065
                                                                                              CSE065
      ** Narative 1 validation                                                                CSE065
                                                                                              CSE065
     C                   EXSR      SrNAR1                                                     CSE065
 
     C                   ENDSL
 
      /COPY WNCPYSRC,SESED1V087
      *
      ** Set include in risk/analysis indicator to 'N' if risk mgmt is on
      ** and not redemption call (event type RC).
      *
      /COPY WNCPYSRC,SESED1V088
 
     C                   IF        RMFL = 'Y' AND DDSDET <> 'RC'
     C                   EVAL      S2RCIC = 'N'
     C                   ENDIF
 
      /COPY WNCPYSRC,SESED1V089
 
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,SESED1V090
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSDDV - Amount per Unit validation process                  *
      *                                                               *
      *****************************************************************
 
     C     SrSDDV        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDSDDV'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrSDPD - Payment date validation process                     *
      *                                                               *
      *****************************************************************
 
     C     SrSDPD        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDSDPD'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Event date (Day number)
     C                   PARM                    PEvtDno
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
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
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrSDXD - Extension Date validation process                   *
      *                                                               *
      *****************************************************************
 
     C     SrSDXD        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDSDXD'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** Event date (Day number)
     C                   PARM                    PEvtDno
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrCAMT - Call Amount validation process                      *
      *                                                               *
      *****************************************************************
 
     C     SRCAMT        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDCAMT'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** SE Diary Events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrCPRI - Call/Put Percentage validation process              *
      *                                                               *
      *****************************************************************
 
     C     SrCPRI        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDCPRI'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** SE Diary Events retrieve from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
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
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrSDCP - Current Factor validation process                   *
      *                                                               *
      *****************************************************************
 
     C     SrSDCP        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDSDCP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Event date (Day number)
     C                   PARM                    PEvtDno
      *                                                                                       CSE072
      ** SWITCHABLE FEATURE                                                                   CSE072
      ** ==================                                                                   CSE072
      *                                                                                       CSE072
      ** SE Transaction Enhancement                                                           CSE072
     C                   PARM                    CSE072                                       CSE072
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrSRPT - Repayment Amount validation process                 *
      *                                                               *
      *****************************************************************
 
     C     SrSRPT        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDSRPT'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Event date (Day number)
     C                   PARM                    PEvtDno
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrSDNC - Next Coupon Rate validation process                 *
      *                                                               *
      *****************************************************************
 
     C     SrSDNC        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDSDNC'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SrSCRS - Credit Risk Spread validation process               *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SrSCRS        BEGSR                                                                CAS006
                                                                                              CAS006
     C                   EVAL      PSpdRate = *BLANKS                                         CAS006
     C                   MOVE      DDSCRS        PSpdRate                                     CAS006
                                                                                              CAS006
      ** Reset variables updated by each module                                               CAS006
                                                                                              CAS006
     C                   EXSR      SRResetErrs                                                CAS006
                                                                                              CAS006
      ** Call validation module                                                               CAS006
                                                                                              CAS006
     C                   CALLB     'SEVPCSPDRT'                                               CAS006
      *                             ==========                                                CAS006
      ** INPUT                                                                                CAS006
      ** =====                                                                                CAS006
                                                                                              CAS006
      ** Return code                                                                          CAS006
     C                   PARM      *BLANKS       RetCodeOut                                   CAS006
                                                                                              CAS006
      ** Field Name                                                                           CAS006
     C                   PARM      'DDSCRS    '  PFieldName                                   CAS006
                                                                                              CAS006
      ** Credit Risk Spread                                                                   CAS006
     C                   PARM                    PSpdRate                                     CAS006
                                                                                              CAS006
      ** OUTPUT                                                                               CAS006
      ** ======                                                                               CAS006
                                                                                              CAS006
      ** Error fields/message IDs/message data (arrays) from/to caller                        CAS006
     C                   PARM                    FldNamXAr                                    CAS006
     C                   PARM                    MsgIDXAr                                     CAS006
     C                   PARM                    MsgDtaXAr                                    CAS006
                                                                                              CAS006
      ** Credit Risk Spread                                                                   CAS006
     C                   PARM                    PValSpdRate                                  CAS006
                                                                                              CAS006
      ** Credit Risk Spread Indicator                                                         CAS006
     C                   PARM                    OKSCRS                                       CAS006
                                                                                              CAS006
      ** Update error info with that returned from the validation module                      CAS006
                                                                                              CAS006
     C                   IF        RetCodeOut <> *BLANKS                                      CAS006
     C                   EXSR      SRUpdatErrs                                                CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
      ** Check for storage overflow.                                                          CAS006
                                                                                              CAS006
     C                   EVAL      WUSpdRt = %ABS(PValSpdRate)                                CAS006
                                                                                              CAS006
     C                   IF        SPSpdRtOvf(WUSpdRt) = 'Y'                                  CAS006
     C                   EVAL      PValSpdRate = *ZERO                                        CAS006
     C                   EVAL      OKSCRS  = 'N'                                              CAS006
     C                   EXSR      SRUpdatErrs                                                CAS006
     C                   ELSE                                                                 CAS006
     C                   EVALR     DDSCRS = %TRIM(DDSCRS)                                     CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   EVAL      S2SCRS = PValSpdRate                                       CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SrSLQP - Liquidity Premium validation process                *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SrSLQP        BEGSR                                                                CAS006
                                                                                              CAS006
     C                   EVAL      PSpdRate = *BLANKS                                         CAS006
     C                   MOVE      DDSLQP        PSpdRate                                     CAS006
                                                                                              CAS006
      ** Reset variables updated by each module                                               CAS006
                                                                                              CAS006
     C                   EXSR      SRResetErrs                                                CAS006
                                                                                              CAS006
      ** Call validation module                                                               CAS006
                                                                                              CAS006
     C                   CALLB     'SEVPCSPDRT'                                               CAS006
      *                             ==========                                                CAS006
      ** INPUT                                                                                CAS006
      ** =====                                                                                CAS006
                                                                                              CAS006
      ** Return code                                                                          CAS006
     C                   PARM      *BLANKS       RetCodeOut                                   CAS006
                                                                                              CAS006
      ** Field Name                                                                           CAS006
     C                   PARM      'DDSLQP    '  PFieldName                                   CAS006
                                                                                              CAS006
      ** Liquidity Premium                                                                    CAS006
     C                   PARM                    PSpdRate                                     CAS006
                                                                                              CAS006
      ** OUTPUT                                                                               CAS006
      ** ======                                                                               CAS006
                                                                                              CAS006
      ** Error fields/message IDs/message data (arrays) from/to caller                        CAS006
     C                   PARM                    FldNamXAr                                    CAS006
     C                   PARM                    MsgIDXAr                                     CAS006
     C                   PARM                    MsgDtaXAr                                    CAS006
                                                                                              CAS006
      ** Liquidity Premium                                                                    CAS006
     C                   PARM                    PValSpdRate                                  CAS006
                                                                                              CAS006
      ** Liquidity Premium Indicator                                                          CAS006
     C                   PARM                    OKSLQP                                       CAS006
                                                                                              CAS006
      ** Update error info with that returned from the validation module                      CAS006
                                                                                              CAS006
     C                   IF        RetCodeOut <> *BLANKS                                      CAS006
     C                   EXSR      SRUpdatErrs                                                CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
      ** Check for storage overflow.                                                          CAS006
                                                                                              CAS006
     C                   EVAL      WUSpdRt = %ABS(PValSpdRate)                                CAS006
                                                                                              CAS006
     C                   IF        SPSpdRtOvf(WUSpdRt) = 'Y'                                  CAS006
     C                   EVAL      PValSpdRate = *ZERO                                        CAS006
     C                   EVAL      OKSLQP  = 'N'                                              CAS006
     C                   EXSR      SRUpdatErrs                                                CAS006
     C                   ELSE                                                                 CAS006
     C                   EVALR     DDSLQP = %TRIM(DDSLQP)                                     CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   EVAL      S2SLQP = PValSpdRate                                       CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SrNetTrRt - Calculation/Validation of Net Treasury Rate      *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SrNetTrRt     BEGSR                                                                CAS006
                                                                                              CAS006
     C                   IF        OKSCRS = 'Y' AND                                           CAS006
     C                             OKSLQP = 'Y' AND                                           CAS006
     C                             OKSDNC = 'Y'                                               CAS006
                                                                                              CAS006
     C                   EVAL      S2SDNN = S2SDNC + S2SCRS + S2SLQP                          CAS006
                                                                                              CAS006
     C                   IF        S2SDNN <= 0                                                CAS006
     C                   EVAL      OKSCRS = 'N'                                               CAS006
     C                   EVAL      OKSLQP = 'N'                                               CAS006
     C                   EVAL      OKSDNC = 'N'                                               CAS006
     C                   EVAL      IDx = IDx + 1                                              CAS006
     C                   EVAL      FldNameArr(IDx)= 'DDSCRS'                                  CAS006
     C                   EVAL      MsgIdArr(IDx) = 'SEA0522'                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPAYC - Payment Currency validation process                 *
      *                                                               *
      *****************************************************************
 
     C     SrPAYC        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDPAYC'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
      *
      ** Redisplay screen flag
     C                   PARM                    PReDsp
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
      *  SrCUTR - Cut Coupon Rate validation process                  *
      *                                                               *
      *****************************************************************
 
     C     SrCUTR        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDCUTR'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrSDMD - Multiply/Divide Indicator validation process        *
      *                                                               *
      *****************************************************************
 
     C     SrSDMD        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDSDMD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrCLAT - Call/Put Amount validation process                  *
      *                                                               *
      *****************************************************************
 
     C     SrCLAT        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDCLAT'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrRAMT - Redemption Price validation process                 *
      *                                                               *
      *****************************************************************
 
     C     SrRAMT        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDRAMT'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrRCIC - Include in Risk/Anal. Cash Flow validation process  *
      *                                                               *
      *****************************************************************
 
     C     SrRCIC        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDRCIC'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrRCCY - Redemption Currency validation process              *
      *                                                               *
      *****************************************************************
 
     C     SrRCCY        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDRCCY'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
      *
      ** Redisplay screen flag
     C                   PARM                    PReDsp
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
      *  SrXRAT - Exchange Rate validation process                    *
      *                                                               *
      *****************************************************************
 
     C     SrXRAT        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDXRAT'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrRCMD - Multiply/Divide Indicator validation process        *
      *                                                               *
      *****************************************************************
 
     C     SrRCMD        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDRCMD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrSDCV - Conversion Security validation process              *
      *                                                               *
      *****************************************************************
 
     C     SrSDCV        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDSDCV'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** SWITCHABLE FEATURE
      ** ==================
      *
      ** SE Transaction Enhancement
     C                   PARM                    CSE010
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
      *
      ** Redisplay screen flag
     C                   PARM                    PReDsp
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
      *  SrCONC - Conversion Currency validation process              *
      *                                                               *
      *****************************************************************
 
     C     SrCONC        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDCONC'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
      *
      ** Redisplay screen flag
     C                   PARM                    PReDsp
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
      *  SrCONR - Conversion Exchange Rate validation process         *
      *                                                               *
      *****************************************************************
 
     C     SrCONR        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDCONR'
      *                             ========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  SrCONP - Conversion Price validation process                 *
      *                                                               *
      *****************************************************************
 
     C     SrCONP        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDCONP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrNAR1 - Narrative 1 validation process                      *
      *                                                               *
      *****************************************************************
 
     C     SrNAR1        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDNAR1'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrNAR2 - Narrative 2 validation process                      *
      *                                                               *
      *****************************************************************
 
     C     SrNAR2        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDNAR2'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      *  SrNAR4 - Narrative 4 validation process                      *
      *                                                               *
      *****************************************************************
 
     C     SrNAR4        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   EXSR      SRResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVDNAR4'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   IF        RetCodeOut <> *BLANKS
     C                   EXSR      SRUpdatErrs
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************                       CSE065
      /EJECT                                                                                  CSE065
      *****************************************************************                       CSE065
      *                                                               *                       CSE065
      *  SRSDAL - Average Life Date validation                        *                       CSE065
      *                                                               *                       CSE065
      *****************************************************************                       CSE065
                                                                                              CSE065
     C     SRSDAL        BEGSR                                                                CSE065
                                                                                              CSE065
                                                                                              CSE065
      ** Reset variables updated by each module                                               CSE065
                                                                                              CSE065
     C                   EXSR      SRResetErrs                                                CSE065
                                                                                              CSE065
      ** Validate Average Life Date if blank                                                  CSE065
                                                                                              CSE065
     C                   IF        DDSDAL = *BLANKS                                           CSE065
     C                   EVAL      OKSDAL = 'N'                                               CSE065
     C                   EVAL      IDx = IDx + 1                                              CSE065
     C                   EVAL      FldNameArr(IDx)= 'DDSDAL'                                  CSE065
     C                   EVAL      MsgIdArr(IDx) = 'SEA0562'                                  CSE065
     C                   ELSE                                                                 CSE065
                                                                                              CSE065
      ** Call validation module                                                               CSE065
                                                                                              CSE065
     C                   CALLB     'SEVDSDAL'                                                 CSE065
                                                                                              CSE065
      ** INPUT                                                                                CSE065
      ** =====                                                                                CSE065
      ** Return code                                                                          CSE065
                                                                                              CSE065
     C                   PARM                    RetCodeOut                                   CSE065
                                                                                              CSE065
      ** Average Life Date                                                                    CSE065
                                                                                              CSE065
     C                   PARM                    DDSDAL                                       CSE065
                                                                                              CSE065
      ** Externally described DS for security details                                         CSE065
                                                                                              CSE065
     C                   PARM                    PSectyd                                      CSE065
                                                                                              CSE065
      ** STANDING DATA                                                                        CSE065
      ** =============                                                                        CSE065
      ** SDBANK - Date Format Indicator                                                       CSE065
                                                                                              CSE065
     C                   PARM                    BJDFIN                                       CSE065
                                                                                              CSE065
      ** OUTPUT                                                                               CSE065
      ** ======                                                                               CSE065
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSE065
                                                                                              CSE065
     C                   PARM                    FldNamXAr                                    CSE065
     C                   PARM                    MsgIDXAr                                     CSE065
     C                   PARM                    MsgDtaXAr                                    CSE065
                                                                                              CSE065
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CSE065
                                                                                              CSE065
     C                   PARM                    WFldNmXAr                                    CSE065
     C                   PARM                    WMsgIDxAr                                    CSE065
     C                   PARM                    WMsgDtXAr                                    CSE065
                                                                                              CSE065
      ** Average Life OK Flag                                                                 CSE065
                                                                                              CSE065
     C                   PARM                    OKSDAL                                       CSE065
                                                                                              CSE065
     C                   PARM                    S2SDAL                                       CSE065
                                                                                              CSE065
      ** Average Life must be greater than rundate                                            CSE065
                                                                                              CSE065
     C                   IF        OKSDAL = 'Y'  OR                                           CSE065
     C                             OKSDAL = 'W'                                               CSE065
     C                   IF        S2SDAL <= BJRDNB                                           CSE065
     C                   EVAL      OKSDAL = 'N'                                               CSE065
     C                   EVAL      IDx = IDx + 1                                              CSE065
     C                   EVAL      FldNameArr(IDx)= 'DDSDAL'                                  CSE065
     C                   EVAL      MsgIdArr(IDx) = 'SEA0561'                                  CSE065
                                                                                              CSE065
      ** Average Life Date should be unique for Security                                      CSE065
                                                                                              CSE065
     C                   ELSE                                                                 CSE065
                                                                                              CSE065
     C                   EVAL      KSDAL = S2SDAL                                             CSE065
     C     KSEDEV        CHAIN     SEDEVAL                                                    CSE065
     C                   IF        %FOUND(SEDEVAL)                                            CSE065
     C                   EVAL      OKSDAL = 'N'                                               CSE065
     C                   EVAL      IDx = IDx + 1                                              CSE065
     C                   EVAL      FldNameArr(IDx)= 'DDSDAL'                                  CSE065
     C                   EVAL      MsgIdArr(IDx) = 'SEA0566'                                  CSE065
     C                   ENDIF                                                                CSE065
     C                   ENDIF                                                                CSE065
     C                   ENDIF                                                                CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
      ** Update error info with that returned from the validation module                      CSE065
                                                                                              CSE065
     C                   IF        RetCodeOut <> *BLANKS  OR                                  CSE065
     C                             OKSDAL = 'N'                                               CSE065
     C                   EXSR      SRUpdatErrs                                                CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
     C                   ENDSR                                                                CSE065
      *****************************************************************
      /EJECT                                                                                  CGL031
      *****************************************************************                       CGL031
      *                                                               *                       CGL031
      *  SrSETX - European Taxation validation process                *                       CGL031
      *                                                               *                       CGL031
      *****************************************************************                       CGL031
                                                                                              CGL031
     C     SrSETX        BEGSR                                                                CGL031
                                                                                              CGL031
      ** Call validation module                                                               CGL031
                                                                                              CGL031
     C                   CALLB     'SEVDSETAX'                                                CGL031
      *                             =========                                                 CGL031
      ** INPUT                                                                                CGL031
      ** =====                                                                                CGL031
                                                                                              CGL031
      ** Return code                                                                          CGL031
                                                                                              CGL031
     C                   PARM                    RetCodeOut                                   CGL031
                                                                                              CGL031
      ** SE Diary Events screen details from incoming                                         CGL031
      ** transaction - screen format                                                          CGL031
                                                                                              CGL031
     C                   PARM                    NwDE1ScnFmt                                  CGL031
                                                                                              CGL031
      ** OUTPUT                                                                               CGL031
      ** ======                                                                               CGL031
                                                                                              CGL031
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL031
                                                                                              CGL031
     C                   PARM                    FldNamXAr                                    CGL031
     C                   PARM                    MsgIDXAr                                     CGL031
     C                   PARM                    MsgDtaXAr                                    CGL031
                                                                                              CGL031
      ** SE Diary Events screen error indicators                                              CGL031
                                                                                              CGL031
     C                   PARM                    SEESEDE                                      CGL031
                                                                                              CGL031
      ** SE Diary Events for file update - file format                                        CGL031
                                                                                              CGL031
     C                   PARM                    NwDEFilFmt                                   CGL031
                                                                                              CGL031
      ** Update error info with that returned from the validation module                      CGL031
                                                                                              CGL031
     C                   IF        RetCodeOut <> *BLANKS                                      CGL031
     C                   EXSR      SRUpdatErrs                                                CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDSR                                                                CGL031
      *****************************************************************                       CGL031
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
     C     *BLANK        LOOKUP    FldNameArr(Ix)                         99
     C                   IF        *IN99 = *On
     C                   MOVEA     FldNamXar     FldNameArr(Ix)
     C                   MOVEA     MsgIDXAr      MsgIdArr(Ix)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(Ix)
     C                   ENDIF
      *
      ** Set Error Index.
      *
     C                   EVAL      Ix = 1
     C     *BLANK        LOOKUP    FldNameArr(Ix)                         99
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
     C     *BLANK        LOOKUP    WFldNamArr(Ix)                         99
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
      ** Return Code
     C                   PARM                    RetCodeIn
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
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** Security Diary Events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Event date (Day number)
     C                   PARM                    PEvtDno
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
                                                                                              CSE065
      ** SDBANK - Run day number                                                              CSE065
     C                   PARM                    BJRDNB                                       CSE065
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** SE Transactions Enhancement
     C                   PARM                    CSE010
      *
      ** Value CCY to be CCY of Issuer Payment
     C                   PARM                    S01509
      *
      ** Dividend Payments Base on EX-Date
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE072
      ** Brazilian C Bond                                                                     CSE072
     C                   PARM                    CSE072                                       CSE072
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
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
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
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
                                                                                              CSE065
      ** Key list for security events by type, desc. date.                                    CSE065
     C     KSEDEV        KLIST                                                                CSE065
     C                   KFLD                    DDSDSN                                       CSE065
     C                   KFLD                    DDSDET                                       CSE065
     C                   KFLD                    KSDAL                                        CSE065
      *
      /COPY WNCPYSRC,SESED1V091
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
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
      ** +--------------------------------------+                                             CAS006
      ** ¦ Subprocedure Definitions             ¦                                             CAS006
      ** ¦ ========================             ¦                                             CAS006
      ** +--------------------------------------+                                             CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SPSpdRtOvf - Checks if the value of a 15P 8 Spread Rate can  *                       CAS006
      *               be successfully assigned to a 11P 7 storage.    *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
     P SPSpdRtOvf      B                                                                      CAS006
     D SPSpdRtOvf      PI             1A                                                      CAS006
     D  PSpdRt                       15P 8 VALUE                                              CAS006
                                                                                              CAS006
      ** Working Variables                                                                    CAS006
     D WRetCde         S              1A   INZ('N')                                           CAS006
     D WPSpdRt         S             11P 7                                                    CAS006
     D WASpdRt         S             16A                                                      CAS006
                                                                                              CAS006
      ** Catch any exception that the following assignment may raise.                         CAS006
                                                                                              CAS006
     C                   MONITOR                                                              CAS006
     C                   EVAL      WPSpdRt = PSpdRt                                           CAS006
     C                   ON-ERROR  *ALL                                                       CAS006
     C                   EVAL      WRetCde = 'Y'                                              CAS006
     C                   ENDMON                                                               CAS006
                                                                                              CAS006
      ** Check the number of significant decimal positions.                                   CAS006
                                                                                              CAS006
     C                   IF        WRetCde <> 'Y'                                             CAS006
     C                   MOVEL     PSpdRt        WASpdRt                                      CAS006
     C                   EVAL      WASpdRt = %REPLACE('.' : WASpdRt :                         CAS006
     C                             8 : 0)                                                     CAS006
     C                   IF        SPGetSpdRtDP(WASpdRt) > 7                                  CAS006
     C                   EVAL      WRetCde = 'Y'                                              CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Return an error message if an overflow occurs.                                       CAS006
                                                                                              CAS006
     C                   IF        WRetCde = 'Y'                                              CAS006
     C                   EVAL      WIx = 1                                                    CAS006
     C                   EVAL      FldNamXAr(WIx) = 'PCSPDRT'                                 CAS006
     C                   EVAL      MsgIdXAr(WIx) = 'SEA0145'                                  CAS006
     C                   EVAL      MsgDtaXAr(WIx) = PSpdRate                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   RETURN    WRetCde                                                    CAS006
                                                                                              CAS006
     P                 E                                                                      CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SPGetSpdRtDP - Gets the number of (significant) decimal      *                       CAS006
      *                 positions in a given Spread Rate.             *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
     P SPGetSpdRtDP    B                                                                      CAS006
     D SPGetSpdRtDP    PI             2P 0                                                    CAS006
     D  PSpdRt                       16A   VALUE                                              CAS006
                                                                                              CAS006
      ** Working Variables                                                                    CAS006
     D WSpdRt          S             16A                                                      CAS006
     D WSpdRtDP        S              2P 0                                                    CAS006
     D WStart          S              2P 0                                                    CAS006
     D WLength         S              2P 0                                                    CAS006
                                                                                              CAS006
     C                   IF        PSpdRt <> *BLANKS                                          CAS006
                                                                                              CAS006
      ** Search for a decimal point.                                                          CAS006
                                                                                              CAS006
     C                   EVAL      WStart = %SCAN('.' : PSpdRt)                               CAS006
                                                                                              CAS006
      ** Calculate the number of decimal positions if possible.                               CAS006
                                                                                              CAS006
     C                   IF        WStart > *ZERO                                             CAS006
     C                   EVAL      WLength = %CHECKR('0 ' : PSpdRt)                           CAS006
     C                   IF        WLength >= WStart                                          CAS006
     C                   EVAL      WSpdRtDP = WLength - WStart                                CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   RETURN    WSpdRtDP                                                   CAS006
                                                                                              CAS006
     P                 E                                                                      CAS006
                                                                                              CAS006
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
