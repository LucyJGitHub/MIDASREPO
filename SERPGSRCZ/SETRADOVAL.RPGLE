     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade exch rates/settlements/comm validn')    *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SETRADOVAL - Trade Exchange Rates, Settlement Details,       *
      *               and Charge/Commission Details                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 233881             Date 27Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3145            Date 15Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE039             Date 04Apr03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 16Nov99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP004             Date 09Sep98               *
      *                 CSE013             Date 29Jul98               *
      *                 CAP003 *CREATE     Date 25Mar98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  233881 - EU Tax amount should be subtracted from the         *
      *           Countervalue.                                       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3145 - Charges and Commission are being missed out of the *
      *            calculation of countervalue.                       *
      *  CGL014 - Collaterals Processing                              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE039 - Auto-settlement of trades                           *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
      *           Recompiled due to database changes                  *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *         - 'Private Banking' Module                            *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  CSE013 - Short Position Warning                              *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SETRDOV008
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      **
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Trade Primary Details in screen format
     D TrPrim        E DS                  EXTNAME(SETRPRPD)
     D TR1_CLTY      E                     EXTFLD(DDCLTY)
 
      ** Trade Secondary Details in screen format
     D TrSeco        E DS                  EXTNAME(SETRSEPD)
 
      ** Trade Exchange Rates in screen format
     D TrExch        E DS                  EXTNAME(SETREXPD)
 
      ** Trade Settlement Instructions in screen format
     D TrSett        E DS                  EXTNAME(SETRSTPD)
 
      ** Trade Charge & Commissions in screen format
     D TrChCm        E DS                  EXTNAME(SETRCCPD)
 
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D SEC_RECI      E                     EXTFLD(RECI)
     D SEC_ZZ005     E                     EXTFLD(ZZ005)
     D SEC_LCD       E                     EXTFLD(LCD)
     D SEC_CHTP      E                     EXTFLD(CHTP)
     D SEC_TNLU      E                     EXTFLD(TNLU)
     D SEC_REPI      E                     EXTFLD(REPI)                         CPB001
     D SEC_FRNT      E                     EXTFLD(FRNT)                                       CAP137
     D SEC_REPA      E                     EXTFLD(REPA)                                       CAP137
     D SEC_TMST      E                     EXTFLD(TMST)                                       CAP137
 
      ** Investment Type Details
     D INVTP         E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)                                       CAS006
 
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
 
      ** Trade Exchange Rates OK indicators
     D OKTrExch      E DS                  EXTNAME(SEETREXPD)
 
      ** Trade Settlement Instructions OK indicators
     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)
 
      ** Trade Charge & Commissions OK indicators
     D OKTrChCm      E DS                  EXTNAME(SEETRCCPD)
 
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** General ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Trading ICD
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
 
     D QQACC1        E                     EXTFLD(QQACCD)                                     CGL029
      ** External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External DS for RETAIL details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D QQACC2        E                     EXTFLD(QQACCD)                                     CGL029
 
      ** Securities Trading ICD
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ** Profit Centre Accounting ICD
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
 
      ** EXTERNAL DS FOR Portfolio Management DETAILS
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
 
      ** EXTERNAL DS FOR SAR DETAILS
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SDSTAT data area                                                                     CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
      ** Data structure for MULTIBRANCH Indicator using rundat.
     D RUNDAT          DS
     D  @MBIN                 13     13
 
 
     D ValidTrad     E DS                  EXTNAME(SEVTRADPD)
      * Valid Trade layout
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(SETDEXPD)                    CAP004
      * SE Trades Extra Data - File (D/B) format                                CAP004
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
     D CSC011          S              1A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                      CGL014 BUG3145
     D*CGL014**********S              1A                                              CGL014 BUG3145
                                                                                              CSC011
      ** CGL031 flag                                                                          CGL031
     D CGL031          S              1A                                                      CGL031
                                                                                              CGL031
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SETRDOV009
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SETRDOV001
 
      * Call Validation Modules in Sequence
 
      *
      ** Validate Trade Exchange Rates
      *
      /COPY WNCPYSRC,SETRDOV002
     C                   EXSR      VTEXCH
      /COPY WNCPYSRC,SETRDOV003
      *
      ** Validate Trade Settlement Instructions
      *
      /COPY WNCPYSRC,SETRDOV004
     C                   EXSR      VTSETI
      /COPY WNCPYSRC,SETRDOV005
      *
      ** Validate Trade Charge and Commissions
      *
      /COPY WNCPYSRC,SETRDOV006
     C                   EXSR      VTCHCM
      /COPY WNCPYSRC,SETRDOV007
      *****************************************************************                CGL031 233881
      ***Generate*EU*Tax*Field*****************************************                CGL031 233881
      *****************************************************************                CGL031 233881
     C*****CGL031        IFEQ      'Y'                                                 CGL031 233881
     C**********         EXSR      SRValEUTax                                          CGL031 233881
     C**********         ENDIF                                                         CGL031 233881
 
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SETRDOV010
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTEXCH - Validate Trade Exchange Rates
      *****************************************************************
     C     VTEXCH        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Exchange Rates
      *
     C                   CALLB     'SETEXCHVAL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Trade Exchange Rates
     C                   PARM                    TrExch
 
      ** Nominal Currency
      ** Trade Type
      ** Settlement Currency
     C                   PARM                    NMCY              3
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETC            3
 
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
 
      ** Trade countervalue (in nominal currency)
     C                   PARM                    TCTR             15 0
 
      ** ICD
     C                   PARM                    BJCYCD            3
     C                   PARM                    BGN0ST            1
     C                   PARM                    FTTMRT
 
      * OUTPUTS
 
      ** Exchange Rate Multiply/Divide indicator
      ** Exchange Rate
      ** Base Currency Rate
      ** FX Margin Points
      ** FX Margin Rate
      ** FX Margin Amount
     C                   PARM                    TMDI              1
     C                   PARM                    TDER             13 8
     C                   PARM                    TBCR             13 8
     C                   PARM                    FXMP              7 2
     C                   PARM                    FXMR             13 8
     C                   PARM                    MAMT             13 0
 
      ** FX Margin Amount
     C                   PARM                    DDMAMT           18
 
      ** Trade Exchange Rates OK inds
     C                   PARM                    OKTrExch
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTSETI - Validate Trade Settlement Instructions
      *****************************************************************
     C     VTSETI        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Settlement Instructions
      *
     C                   CALLB     'SETSETIVAL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Trade Settlement Instructions
     C                   PARM                    TrSett
 
      ** OTHER SCREEN FIELDS
      ** Security
      ** Incomplete Ind
      ** Trade Type
      ** Book
      ** Trade Sub Type
      ** Market Indicator
      ** Booking branch
      ** Settlement Currency
      ** Market Centre                                                                        CSE039
      ** Portfolio Reference                                                                  CSE039
     C                   PARM                    DDSESN           10
     C                   PARM                    DDINCS            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDBPBK            2
     C                   PARM                    DDTSUB            2
     C                   PARM                    DDTDMI            1
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDSETC            3
     C                   PARM                    DDMRKT                                       CSE039
     C                   PARM                    DDPTFR                                       CSE039
 
      ** TRADE FIELDS
      ** Counterparty
      ** Value Date
      ** Nominal
      ***Countervalue***************                                                  CGL014 BUG3145
     C                   PARM                    TCNR
     C                   PARM                    TDVD              5 0
     C                   PARM                    NOML                           CSE013
     C**********         PARM                    TCTR                                 CGL014 BUG3145
 
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
 
      ** Security Info (from SECTYD)
      ** Nominal Currency
      ** Depot 1 Security Reference
      ** Depot 2 Security Reference
      ** Depot 3 Security Reference
 
     C                   PARM                    NMCY              3
     C                   PARM                    DASR             12
     C                   PARM                    DCSR             12
     C                   PARM                    DDSR             12
 
      ** Investment Type Info (from INVTPD)
      ** Settlement depots 1,2,3
      ** Investment Type                                                                      CSE039
     C                   PARM                    SDC1
     C                   PARM                    SDC2
     C                   PARM                    SDC3
     C                   PARM                    INVT                                         CSE039
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
 
      ** ICD
      ** Multi-branching Ind
      ** Local currency
      ** System branch
      ** System location
      ** Originating branches used
      ** Originating branches v. user validation
      ** Profit centres used
      ** Profit centre defaulting
      ** Profit Centre Accounting installed
      ** Euro Currency Code
      ** Retail installed
      ** US dollar currency code
      ** Retail current a/c code
      ** Cedel currency code
      ** Euroclear currency code
      ** Trade & Book Positions Reconciliable
      ** Trade/Value Date Valuation
      ** CSE013 - Short position warning
      ** S01496 - Private Banking SE enhancements
      ** CEU005 - EMU SE Settlement Currency Conversion
 
     C                   PARM                    @MBIN             1
     C                   PARM                    BJLCCY            3
     C                   PARM                    BJSBRC            3
     C                   PARM                    BJSLCD            3
     C                   PARM                    BKOBRU            1
     C                   PARM                    BKOBUV            1
     C                   PARM                    BKPRCU            1
     C                   PARM                    BKPCDU            1
     C                   PARM                    BKEURO            3
     C                   PARM                    BGN0ST            1
     C                   PARM                    BGRTBN            1
     C                   PARM                    BLUSCY            3
     C**********         PARM                    BMACCD            4                          CGL029
     C                   PARM                    BMACCD                                       CGL029
     C                   PARM                    BVCCCY            3
     C                   PARM                    BVEUCY            3
     C                   PARM                    BVTBRC            1
     C                   PARM                    BVTVDV            1            CSE013
     C                   PARM                    CSE013            1            CSE013
     C                   PARM                    S01496            1
     C                   PARM                    CEU005            1
     C**********         PARM                    CGL014                               CGL014 BUG3145
      *
      * OUTPUTS
      *
      ** Trade details
      ** Originating branch
      ** Settlement Method
      ** Pay From
      ** Pay From Branch
      ** Pay To
      ** Pay To Branch
      ** For Account of (Pay to)
      ** Account Sequence Number
      ** Clearance Type
      ** Deliver to
      ** For Account of (Deliver to)
      ** Deliver From
      ** For Account of-Deliver From
      ** Special Instructions
      ** In Currency in Field 72
      ** Profit Centre
      ** Priority Code
      ** Pay Code
      ** Auto-settle Indicator
     C                   PARM                    ORBR              3
     C                   PARM                    SMTH
     C**********         PARM                    PYFM             12                          CGL029
     C                   PARM                    PYFM                                         CGL029
     C                   PARM                    PYFA              3
     C**********         PARM                    PAYT             12                          CGL029
     C                   PARM                    PAYT                                         CGL029
     C                   PARM                    PYTA              3
     C                   PARM                    TDFA              8
     C                   PARM                    ASNM
     C                   PARM                    CLTY              1
     C                   PARM                    DELT
     C                   PARM                    DTFA              8
     C                   PARM                    DELF
     C                   PARM                    DFFA              8
     C                   PARM                    TDSI             35
     C                   PARM                    ICCY              3
     C                   PARM                    PRFC              4
     C                   PARM                    PRYC              1
     C                   PARM                    PCOD              1
     C                   PARM                    AUTS              1
      *
      ** Trade Settlement Instructions OK
     C                   PARM                    OKTrSett
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTCHCM - Validate Trade Charge and Commissions
      *****************************************************************
     C     VTCHCM        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Charge and Commissions
      *
     C                   CALLB     'SETCHCMVAL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
      *
      ** Trade details
      ** Trade Type
      ** Settlement Currency
      ** Trade date
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETC            3
     C                   PARM                    TDDT              5 0
      *
      ** Trade Charges & Commissions
     C                   PARM                    TrChCm
      *
      ** Nominal Currency Details
     C                   PARM                    NMCY              3
     C                   PARM                    NomCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      ** Portfolio Details
     C                   PARM                    PortDts
      *
      ** ICD
      ** Run date
      ** PM installed
      ** Autocharge Option
      ** Bank Portfolios installed
      ** 9997 Portfolios
      ** Private Banking Module                                                 CPB001
     C**********         PARM                    BJRDNB            5 0                        CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BGPFMG            1
     C                   PARM                    BVACOP            1
     C                   PARM                    FCPORS            1
     C                   PARM                    FCR997            4
     C                   PARM                    BGN4ST            1            CPB001
 
      * OUTPUTS
 
      * Broker commission
      * Customer commission
      * Charges 1 - 7
      * Tax
      * Broker commission rebate
      * Customer commission rebate
      * Tax on rebate
      * Portfolio ref
      * Portfolio exchange rate & M/D ind
     C                   PARM                    TBCC              2
     C                   PARM                    TBCA             13 0
     C                   PARM                    TCCC              2
     C                   PARM                    TCCA             13 0
     C                   PARM                    TCC1              2                           S0117
     C                   PARM                    TCA1             13 0                         S0117
     C                   PARM                    TCC2              2                           S0117
     C                   PARM                    TCA2             13 0                         S0117
     C                   PARM                    TCC3              2                           S0117
     C                   PARM                    TCA3             13 0                         S0117
     C                   PARM                    TCC4              2                           S0117
     C                   PARM                    TCA4             13 0                         S0117
     C                   PARM                    TCC5              2                           S0117
     C                   PARM                    TCA5             13 0                         S0117
     C                   PARM                    TCC6              2                           S0117
     C                   PARM                    TCA6             13 0                         S0117
     C                   PARM                    TCC7              2                           S0117
     C                   PARM                    TCA7             13 0                         S0117
     C                   PARM                    TAXA             13 0                         S0117
     C                   PARM                    BCMR             13 0                         S0117
     C                   PARM                    CCMR             13 0                         S0117
     C                   PARM                    TXRB             13 0                         S0117
     C                   PARM                    PTFR              4
     C                   PARM                    SPXR             13 8
     C                   PARM                    SPMD              1
      *
      ** Portfolio exchange rate & M/D ind screen format
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
      *
      ** Trade Charges & Commissions OK inds
     C                   PARM                    OKTrChCm
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CGL031
      ***SRValEUTax*-*Generate*EU*Tax*field****************************                CGL031 233881
      *****************************************************************                       CGL031
     C*****SRValEUTax    BEGSR                                                         CGL031 233881
      *                                                                                       CGL031
      ***Validate*EU*Tax*Field*****************************************                CGL031 233881
      *                                                                                       CGL031
     C**********         CALLB     'SEVTRADTAX'                                        CGL031 233881
                                                                                              CGL031
      **INPUTS*********************************************************                CGL031 233881
                                                                                              CGL031
      **Response*mode**************************************************                CGL031 233881
     C**********         PARM                    RespMode          1                   CGL031 233881
      **Valid*Trade*Details********************************************                CGL031 233881
     C**********         PARM                    ValidTrad                             CGL031 233881
      ***Security*Details**********************************************                CGL031 233881
     C**********         PARM                    SECTY                                 CGL031 233881
      ***Process*Flag**************************************************                CGL031 233881
     C**********         PARM      'E'           ProcFlag          1                   CGL031 233881
      *                                                                                       CGL031
                                                                                              CGL031
      **OUTPUTS********************************************************                CGL031 233881
                                                                                              CGL031
     C***EU*Tax*Screen*Format******************************************                CGL031 233881
      ***EU*Tax*in*Nominal*Currency*File*Format************************                CGL031 233881
      ***EU*Tax*in*Settlement*Currency*File*Format*********************                CGL031 233881
     C**********         PARM                    DDEUTX                                CGL031 233881
     C**********         PARM                    EUTX                                  CGL031 233881
     C**********         PARM                    EUTS                                  CGL031 233881
                                                                                              CGL031
      *                                                                                       CGL031
     C**********         ENDSR                                                         CGL031 233881
      /EJECT                                                                                  CGL031
                                                                                              CGL031
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
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Exchange Rates
      ** Trade Settlement Instructions
      ** Trade Charge & Commissions
     C                   PARM                    TrPrim
     C                   PARM                    TrSeco
     C                   PARM                    TrExch
     C                   PARM                    TrSett
     C                   PARM                    TrChCm
     C                   PARM                    ExtData                        CAP004
 
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
 
      ** Portfolio Details
     C                   PARM                    PortDts
 
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
      * CGL031 Switchable Feature                                                             CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * OUTPUTS
      *
      ** FX Margin Amount
      ** Portfolio exchange rate & M/D ind screen format
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
 
      ** Trade Exchange Rates OK inds
      ** Trade Settlement Instructions OK
      ** Trade Charge & Commissions OK inds
     C                   PARM                    OKTrExch
     C                   PARM                    OKTrSett
     C                   PARM                    OKTrChCm
 
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
 
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
 
      *
      ** Read data area - RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Get Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** Get General Ledger ICD
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** Get Trading details
      *
     C                   CALL      'AOTRADR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDTRADPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** GET MODULE DETAILS
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** Get retail details
      *
     C     BGRTBN        IFEQ      'Y'
     C     BGIOAC        OREQ      'Y'
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDRETLPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      ** Securities Trading
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
      ** Get Profit Centre Accounting details
      *
     C     BGN0ST        IFEQ      'Y'
     C                   CALL      'AOPCACR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPCAC        PARM      SDPCAC        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDPCACPD'    DBFILE
     C                   MOVEL     '906'         DBASE
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      ** ACCESS PORTFOLIO MANAGEMNT DETAILS
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   MOVEL     '907'         DBASE
     C                   EXSR      SRERR
     C                   END
     C                   END
      *
      ** Access SAR details file to determine if S01496
      ** (Private Banking SE enhancements) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01496'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01496'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '908'         DBASE
     C                   EXSR      SRERR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01496            1
     C                   ELSE
     C                   MOVEL     'N'           S01496
     C                   END
      *
      ** Access SAR details file to determine if CSE013                         CSE013
      ** (Short Position Warning) is on.                                        CSE013
      *                                                                         CSE013
     C                   CALLB     'AOSARDR0'                                   CSE013
     C                   PARM      *BLANKS       @RTCD                          CSE013
     C                   PARM      '*VERIFY'     @OPTN                          CSE013
     C                   PARM      'CSE013'      @SARD                          CSE013
     C     SCSARD        PARM      SCSARD        DSFDY                          CSE013
      *                                                                         CSE013
      * Database Error                                                          CSE013
      *                                                                         CSE013
     C     @RTCD         IFNE      *BLANKS                                      CSE013
     C     @RTCD         ANDNE     '*NRF   '                                    CSE013
     C                   MOVEL     'CSE013'      DBKEY                          CSE013
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE013
     C                   MOVEL     '909'         DBASE                          CSE013
     C                   EXSR      SRERR                                        ************
     C                   END                                                    CSE013
      *                                                                         CSE013
     C     @RTCD         IFEQ      *BLANK                                       CSE013
     C                   MOVEL     'Y'           CSE013            1            CSE013
     C                   ELSE                                                   CSE013
     C                   MOVEL     'N'           CSE013                         CSE013
     C                   END                                                    CSE013
      *
      ** Access SAR details file to determine if CEU005
      ** (EMU SE Settlement Currency Conversion) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU005'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '910'         DBASE
     C                   EXSR      SRERR                                        ************
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU005            1
     C                   ELSE
     C                   MOVEL     'N'           CEU005
     C                   END
 
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        LIBR = S1SUPP                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 911                                                CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ***Check*if*enhancement*CGL014*(Collaterals*Processing)*is*on****               CGL014 BUG3145
                                                                                      CGL014 BUG3145
     C**********         CALLB     'AOSARDR0'                                         CGL014 BUG3145
     C**********         PARM      *BLANKS       PRTCD                                CGL014 BUG3145
     C**********         PARM      '*VERIFY'     POPTN                                CGL014 BUG3145
     C**********         PARM      'CGL014'      PSARD                                CGL014 BUG3145
     C*****SCSARD        PARM      SCSARD        DSFDY                                CGL014 BUG3145
                                                                                      CGL014 BUG3145
     C**********         IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '          CGL014 BUG3145
     C**********         EVAL      DBFILE = 'SCSARDPD'                                CGL014 BUG3145
     C**********         EVAL      DBKEY  = 'CGL014'                                  CGL014 BUG3145
     C**********         EVAL      DBASE  = 912                                       CGL014 BUG3145
     C**********         EXSR      *PSSR                                              CGL014 BUG3145
     C**********         ENDIF                                                        CGL014 BUG3145
                                                                                      CGL014 BUG3145
     C**********         IF        PRTCD = *BLANKS                                    CGL014 BUG3145
     C**********         EVAL      CGL014 = 'Y'                                       CGL014 BUG3145
     C**********         ELSE                                                         CGL014 BUG3145
     C**********         EVAL      CGL014 = 'N'                                       CGL014 BUG3145
     C**********         ENDIF                                                        CGL014 BUG3145
                                                                                      CGL014 BUG3145
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SETRDOV011
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     'SETRADOVAL'  DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminte the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
