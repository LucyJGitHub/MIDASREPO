     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade secondary details validation')          *
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SETRADSVAL - Trade Secondary Details Validation              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249473             Date 30Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 235547             Date 11Aug05               *
      *                 236708             Date 13Jun05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE035             Date 22Apr02               *
      *                 CAS006             Date 21Jan03               *
      *                 CSE037             Date 29Apr02               *
      *                 CSE039             Date 04Apr03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209952             Date 15Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      *                 CSC011             Date 18Sep01               *
      *                 198112             Date 30Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP051             Date 16Nov99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAC005             Date 23Nov98               *
      *                 157785             Date 19Mar99               *
      *                 CAP004             Date 09Sep98               *
      *                 CAP050             Date 27Jul98               *
      *                 CAP003 *CREATE     Date 25Mar98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249473 - When blank, the Settlement currency from the Valid  *
      *           file is not updated with the default Settlement ccy *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  235547 - Defaulting incorrect first time into program        *
      *  236708 - If Original purchase date is before effective date  *
      *           use effective date for bonds                        *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE035 - NX/NNX Coupon Payment Processing.                   *
      *           default it with the market center of the security.  *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSE037 - Bond Pricing - 3 Decimal Places in Trades Input     *
      *  CSE039 - Auto-settlement of trades                           *
      *         - Recompiled due to change in SETRSEPD                *
      *  209952 - If market Center is blank for investment type       *
      *           default it with the market center of the security.  *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CSC011 - 24x7 Midas Availability                             *
      *  198112 - Recompiled over changed SEVTBPRFCN.                 *
      *  CSE028 - Standing Settlement Instructions Enhancement        *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs (SECTYD)                   *
      *  CAP051 - Automatic Authorisation (SE Trades Part)            *
      *           Recompiled due to database changes                  *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *         - 'Private Banking' Module                            *
      *           /COPY SE_CUSTDT Changed                             *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAC005 - Profit Centre Accounting - SE Enhancement           *
      *  157785 - Several fields not updated in trades input          *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extar Data                       *
      *  CAP050 - Midas/ToF Interface                                 *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SETRDSV037
 
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
      ** Trade Secondary Details in screen format
     D TrSeco        E DS                  EXTNAME(SETRSEPD)
 
 
      ** Trade Secondary Details OK indicators
     D OKTrSeco      E DS                  EXTNAME(SEETRSEPD)
 
 
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
     D SEC_NDEC      E                     EXTFLD(NDEC)                                       CSE037
 
      ** Investment Type Details
     D INVTP         E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)                                       CSE037
 
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** General ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Securities Trading ICD
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ** Portfolio ICD
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
 
      ** Profit Centre Accounting ICD
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
 
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
      ** External DS for SAR Details                                                          CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
     D  SCA_LCD      E                     EXTFLD(LCD)                                        CSC011
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
                                                                                              CSE028
     D CSE028          S              1A                                                      CSE028
 
     D CSC011          S              1A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                              CSC011
      ** CGL031 flag                                                                          CGL031
     D CGL031          S              1A                                                      CGL031
                                                                                              CGL031
     D C_TDVD          S                   LIKE(TDVD)                                         235547
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SETRDSV038
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SETRDSV001
 
      * Call Validation Modules in Sequence
 
      *
      ** Validate Trade Settlement Currency
      *
      /COPY WNCPYSRC,SETRDSV002
     C                   EXSR      VTSETLCY
      /COPY WNCPYSRC,SETRDSV003
      *
      ** Validate Trade Reallowance
      *
      /COPY WNCPYSRC,SETRDSV004
     C                   EXSR      VTREALLW
      /COPY WNCPYSRC,SETRDSV005
      *
      ** Validate Trade Market Centre
      *
      /COPY WNCPYSRC,SETRDSV006
     C                   EXSR      VTMKTCEN
      /COPY WNCPYSRC,SETRDSV007
      *
      ** Validate Trade Capacity
      *
      /COPY WNCPYSRC,SETRDSV008
     C                   EXSR      VTCAPACI
      /COPY WNCPYSRC,SETRDSV009
      *
      ** Validate Trade Trade Date
      *
      /COPY WNCPYSRC,SETRDSV010
     C                   EXSR      VTTRDDT
      /COPY WNCPYSRC,SETRDSV011
      *
      ** Validate Trade Ex Dividend Ind.
      *
      /COPY WNCPYSRC,SETRDSV012
     C     PROT          IFEQ      '4'
     C     PROT          OREQ      '7'
     C                   EXSR      VTEXDIV
     C                   END
      /COPY WNCPYSRC,SETRDSV013
      *
      ** Validate Trade Trade Sub-Type
      *
      /COPY WNCPYSRC,SETRDSV014
     C                   EXSR      VTTRDSB
      /COPY WNCPYSRC,SETRDSV015
      *
      ** Validate Trade Market Indicator
      *
      /COPY WNCPYSRC,SETRDSV016
     C                   EXSR      VTMARKIN
      /COPY WNCPYSRC,SETRDSV017
      *
      ** Validate Trade Book Profit Centre
      ** If Profit Centre Accounting installed
      ** and if market indicator is OK
      *
      /COPY WNCPYSRC,SETRDSV018
     C     BGN0ST        IFEQ      'Y'
     C     DDTdmiOK      ANDNE     'N'
     C                   EXSR      VTBPRFCN
     C                   END
      /COPY WNCPYSRC,SETRDSV019
      *
      ** Validate Trade Transaction Profit Centre
      ** If Profit Centre Accounting installed
      *
      /COPY WNCPYSRC,SETRDSV020
     C     BGN0ST        IFEQ      'Y'
     C                   EXSR      VTTPRFCN
     C                   END
      /COPY WNCPYSRC,SETRDSV021
      *
      ** Validate Trade ISMA/IPMA indicator
      *
      /COPY WNCPYSRC,SETRDSV022
     C                   EXSR      VTAIIP
      /COPY WNCPYSRC,SETRDSV023
      *                                                                         CAP050
      ** Validate Private Banking Order Number                                  CAP050
      *                                                                         CAP050
      /COPY WNCPYSRC,SETRDSV024
     C*****CAP050******* IFEQ      'Y'                                   CAP050 CPB001
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C                   EXSR      VPBORDE                                      CAP050
     C                   ENDIF                                                  CAP050
      /COPY WNCPYSRC,SETRDSV025
      *
      ** If interest bearing security
      *
     C     PROT          IFEQ      '1'
     C     PROT          OREQ      '3'
     C     PROT          OREQ      '5'
     C     PROT          OREQ      '6'
     C     PROT          OREQ      '8'
     C     PROT          OREQ      '9'
      *
     C     STBS          IFEQ      'Y'
     C     STBS          OREQ      'P'
      *
      ** Validate Trade Accrued Indicator
      *
      /COPY WNCPYSRC,SETRDSV026
     C                   EXSR      VTACCRIN
      /COPY WNCPYSRC,SETRDSV027
      *
      ** Validate Trade Days Adjustment/Sign
      *
      /COPY WNCPYSRC,SETRDSV028
     C                   EXSR      VTDAYSAD
      /COPY WNCPYSRC,SETRDSV029
      *
      ** Validate Actual/Difference Ind.
      *
      /COPY WNCPYSRC,SETRDSV030
     C                   EXSR      VTACDFIN
      /COPY WNCPYSRC,SETRDSV031
      *
      ** If Accrued Indicator / Days Adjustment
      ** Actual/Difference Indicator are not invalid
      *
      ** Validate Trade Interest Amount
      *
     C     ddACINok      IFNE      'N'
     C     ddDADJok      ANDNE     'N'
     C     ddACTDok      ANDNE     'N'
      /COPY WNCPYSRC,SETRDSV032
     C                   EXSR      VTINTAMT
      /COPY WNCPYSRC,SETRDSV033
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      /COPY WNCPYSRC,SETRDSV034
      *
      ** Validate Trade Price
      *
     C     ddACINok      IFNE      'N'
     C     ddDADJok      ANDNE     'N'
     C     ddACTDok      ANDNE     'N'
     C     ddITRAok      ANDNE     'N'
      /COPY WNCPYSRC,SETRDSV035
     C                   EXSR      VTPRICE
      /COPY WNCPYSRC,SETRDSV036
     C                   END
                                                                                              CGL031
      ** Validate Fiscal Price                                                                CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   EXSR      SRVFPrice                                                  CGL031
     C                   END                                                                  CGL031
                                                                                157785
      *  *-------------------------------------------------------*              157785
      *  * If no errors set up outstanding fields for valid file *              157785
      *  *-------------------------------------------------------*              157785
                                                                                157785
     C                   IF        Idx = 0                                      157785
     C                   EXSR      SetupValid                                   157785
     C                   ENDIF                                                  157785
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SETRDSV039
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Settlement Currency
      *****************************************************************
     C     VTSETLCY      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Settlement Currency
      *
     C                   CALLB     'SEVTSETLCY'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDSETC            3
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDBPBK                                       CSE028
      *
      ** Security Details
     C                   PARM                    SECTY
 
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Customer Classification
      ** Customer Currency Code
      ** Customer number
      *
     C                   PARM                    CustClass         1
     C                   PARM                    CustCurr          3
     C                   PARM                    TCNR
      *
      ** Euro currency code
      ** S01509 on
      ** CEU005 on
     C                   PARM                    BKEURO            3
     C                   PARM                    S01509            1
     C                   PARM                    CEU005            1
      *                                                                                       CSE028
      ** MT5xx SSI (Phase 2)                                                                  CSE028
     C                   PARM                    CSE028                                       CSE028
      *
      * OUTPUTS
      *
      ** Settlement Currency Details
     C                   PARM                    SetCcyDts
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Settlement Currency - OK
     C                   PARM                    DDSetcOK          1
      *
      ** Trade Settlement Currency
      *
     C                   PARM                    SETC              3
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Reallowance
      *****************************************************************
     C     VTREALLW      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Reallowance
      *
     C                   CALLB     'SEVTREALLW'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDRALL           11
      *
      ** Security Details
      *
     C                   PARM                    SECTY
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Reallowance - OK
     C                   PARM                    DDRALLOK          1
      *
      ** Trade Reallowance
      *
     C                   PARM                    RALL              9 5
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Market Centre
      *****************************************************************
     C     VTMKTCEN      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Market Centre
      *
     C                   CALLB     'SEVTMKTCEN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDMRKT            2
      *
      ** Investment Type Market Centre
     C                   PARM                    DMKT              2
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Market Centre - OK
     C                   PARM                    DDMrktOK          1
      *
      ** Market Centre
      *
     C                   PARM                    TMKC              2
                                                                                              209952
     C     TMKC          IFEQ      '  '                                                       209952
     C                   CALLB     'SEVTMKTCEN'                                               209952
      *                                                                                       209952
      ** INPUTS                                                                               209952
      *                                                                                       209952
      ** Return Code                                                                          209952
      *                                                                                       209952
     C                   PARM                    RetCodeOut                                   209952
      *                                                                                       209952
      ** Default & Validate (Y or N)                                                          209952
      *                                                                                       209952
     C                   PARM                    Default           1                          209952
     C                   PARM                    Validate          1                          209952
      *                                                                                       209952
      ** Trade Screen fields                                                                  209952
      *                                                                                       209952
     C                   PARM                    DDMRKT            2                          209952
      *                                                                                       209952
      ** Investment Type Market Centre                                                        209952
      *                                                                                       209952
     C                   PARM                    SMCC              2                          209952
      *                                                                                       209952
      ** OUTPUTS                                                                              209952
      *                                                                                       209952
      ** Error fields/message IDs/message data (arrays) from/to caller                        209952
      *                                                                                       209952
     C                   PARM                    FldNamXAr                                    209952
     C                   PARM                    MsgIDXAr                                     209952
     C                   PARM                    MsgDtaXAr                                    209952
      *                                                                                       209952
      ** Market Centre - OK                                                                   209952
      *                                                                                       209952
     C                   PARM                    DDMrktOK          1                          209952
      *                                                                                       209952
      ** Market Centre                                                                        209952
      *                                                                                       209952
     C                   PARM                    TMKC              2                          209952
     C                   END                                                                  209952
                                                                                              209952
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Capacity
      *****************************************************************
     C     VTCAPACI      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Capacity
      *
     C                   CALLB     'SEVTCAPACI'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDCPCY            1
     C                   PARM                    DDBLKR            6
     C                   PARM                    DDTDTP            2
      *
      ** Agency trade ID
      ** Bulk input option
     C                   PARM                    ATRD              1
     C                   PARM                    BVBIOP            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Capacity Ind. - OK
     C                   PARM                    DDCpcyOK          1
      *
      ** Capacity Ind.
      *
     C                   PARM                    TCAP
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Trade Date
      *****************************************************************
     C     VTTRDDT       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Trade Date
      *
     C                   CALLB     'SEVTTRDDT'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDTDDT            7
      *
      ** Trade value date
     C                   PARM                    TDVD              5 0
      *
      ** ICD
      ** run date, date format, local currency, system location, bv period
      *
     C**********         PARM                    BJRDNB            5 0                        CSC011
     C                   PARM                    WRunDay                                      CSC011
     C                   PARM                    BJDFIN            1
     C                   PARM                    BJLCCY            3
     C                   PARM                    BJSLCD            3
     C                   PARM                    BVBVP             3 0
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
      ** Trade Date - OK
     C                   PARM                    DDTDDTOK          1
      *
      ** Trade Date
      *
     C                   PARM                    TDDT              5 0
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Ex Div
      *****************************************************************
     C     VTEXDIV       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Ex Div
      *
     C                   CALLB     'SEVTEXDIV'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
 
      ** Screen fields
      ** -------------
      * Ex-Dividend Indicator (1A)
     C                   PARM                    DDEXDV
 
      ** Trade Details
      ** -------------
      * Value Date (5P 0)
      * Trade Date (5P 0)
     C                   PARM                    TDVD              5 0
     C                   PARM                    TDDT              5 0
 
      ** Security Details
      ** ----------------
     C                   PARM                    SECTY
 
      ** System Info
      ** -----------
      * S01510 indicator
      * Date Format (1A)
     C                   PARM                    S01510
     C                   PARM                    BJDFIN
 
      * OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Ex-Dividend Ok indicator (1A)
      ** Ex-Dividend indicator  (1A)
 
     C                   PARM                    DDEXDVOK
     C                   PARM                    EXDV
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Trade Sub-Type
      *****************************************************************
     C     VTTRDSB       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Trade Sub-Type
      *
     C                   CALLB     'SEVTTRDSB'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDTSUB            2
      *
      ** Customer classification
      ** Market Deal Sub Type
      ** Portfolio Deal Sub Type
      *
     C                   PARM                    CustClass         1
     C                   PARM                    BVDMKS            2
     C                   PARM                    BVDPFS            2
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Trade Sub Type - OK
     C                   PARM                    DDTsubOK          1
      *
      ** Trade Sub Type
      *
     C                   PARM                    TSUB              2
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Market Indicator
      *****************************************************************
     C     VTMARKIN      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Market Indicator
      *
     C                   CALLB     'SEVTMARKIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDTDMI            1
      *
      ** Security Market Indicator
     C                   PARM                    MKTI              1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Market Indicator - OK
     C                   PARM                    DDTDMIOK          1
      *
      ** Trade Market Indicator
      *
     C                   PARM                    TDMI              1
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Book Profit Centre
      *****************************************************************
     C     VTBPRFCN      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Book Profit Centre
      *
     C                   CALLB     'SEVTBPRFCN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
 
      ** Booking profit centre
     C                   PARM                    DDBPRC            4
 
      ** Security
      ** Trade Type
      ** Branch code
      ** Book code
      ** Market Indicator
      ** Trade Sub Type
     C                   PARM                    DDSESN           10
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDBPBK            2
     C                   PARM                    DDTDMI            1
     C                   PARM                    DDTSUB            2
      *
      ** Trade Customer
     C                   PARM                    TCNR
      *
      ** ICD
     C                   PARM                    BKPCDU            1
     C                   PARM                    CAC005                         CAC005
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
      ** Booking profit centre - OK
     C                   PARM                    DDBprcOK          1            broker
      *
      ** Trade Booking profit centre
      *
     C                   PARM                    BPRC              4            broker
      *                                                                         CAC005
      ** Trade Book                                                             CAC005
      *                                                                         CAC005
     C                   PARM                    TDBK              2            CAC005
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Transaction Profit Centre
      *****************************************************************
     C     VTTPRFCN      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Transaction Profit Centre
      *
     C                   CALLB     'SEVTTPRFCN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
 
      ** Transaction profit centre
     C                   PARM                    DDTPRC            4
 
      ** Security
      ** Trade Type
      ** Branch Code
      ** Book
      ** Book Profit Centre
      ** Trade Sub Type
 
     C                   PARM                    DDSESN           10
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDBPBK            2
     C                   PARM                    DDBPRC            4
     C                   PARM                    DDTSUB            2
 
      ** Customer (6S 0)
      ** Customer Classification   (1A)
 
     C                   PARM                    TCNR
     C                   PARM                    CustClass         1
      *
      ** ICD
     C                   PARM                    BKPCDU            1
 
      * OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Profit Ok Indicator
     C                   PARM                    DDTPRCok          1
      *
      ** Transaction Profit Centre
     C                   PARM                    TPRC              4
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade ISMA/IPMA indicator
      *****************************************************************
     C     VTAIIP        BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade ISMA/IPMA indicator
      *
     C                   CALLB     'SEVTAIIP'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDAIIP            1
      *
      ** Processing Type
      *
     C                   PARM                    PROT              1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** ISMA/IPMA Indicator - OK
     C                   PARM                    DDAiipOK          1
      *
      ** Trade ISMA/IPMA Indicator
      *
     C                   PARM                    AIIP              1
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                    CAP050
      *****************************************************************         CAP050
      ** Validate Private Banking Order Number                                  CAP050
      *****************************************************************         CAP050
     C     VPBORDE       BEGSR                                                  CAP050
                                                                                CAP050
      * Reset variables updated by each module                                  CAP050
                                                                                CAP050
     C                   EXSR      RESETERRS                                    CAP050
      *                                                                         CAP050
      ** Validate Private Banking Order Number                                  CAP050
      *                                                                         CAP050
     C                   CALLB     'SEVPBORDE'                                  CAP050
      *                                                                         CAP050
      * INPUTS                                                                  CAP050
      *                                                                         CAP050
      ** Return Code                                                            CAP050
     C                   PARM                    RetCodeOut                     CAP050
      *                                                                         CAP050
      ** Default & Validate (Y or N)                                            CAP050
     C                   PARM                    Default           1            CAP050
     C                   PARM                    Validate          1            CAP050
      *                                                                         CAP050
      ** Trade Screen fields                                                    CAP050
     C                   PARM                    DDORDE            6            CAP050
      *                                                                         CAP050
      * OUTPUTS                                                                 CAP050
      *                                                                         CAP050
      * Error fields/message IDs/message data (arrays) from/to caller           CAP050
     C                   PARM                    FldNamXAr                      CAP050
     C                   PARM                    MsgIDXAr                       CAP050
     C                   PARM                    MsgDtaXAr                      CAP050
      *                                                                         CAP050
      ** Order Number - OK                                                      CAP050
     C                   PARM                    DDOrdeOK          1            CAP050
      *                                                                         CAP050
      ** Order Number                                                           CAP050
      *                                                                         CAP050
     C****************** PARM                    ORDE              6 0   CAP050 CPB001
     C                   PARM                    ORDE                           CPB001
                                                                                CAP050
      * Update error info with that returned from the validation module         CAP050
                                                                                CAP050
     C                   EXSR      UPDATERRS                                    CAP050
      *                                                                         CAP050
     C                   ENDSR                                                  CAP050
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Accrued Indicator
      *****************************************************************
     C     VTACCRIN      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Accrued Indicator
      *
     C                   CALLB     'SEVTACCRIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDACIN            1
      *
      ** Trade Value Date
     C                   PARM                    TDVD              5 0
      *
      ** Security Details
      ** Processing Type
     C                   PARM                    SECTY
     C                   PARM                    PROT              1
      *
      ** Date format ind
     C                   PARM                    BJDFIN            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Accrued Indicator - OK
     C                   PARM                    DDAcinOK          1
      *
      ** Trade Accrued Indicator
      *
     C                   PARM                    ACIN              1
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Days Adjustment/Sign
      *****************************************************************
     C     VTDAYSAD      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Days Adjustment/Sign
      *
     C                   CALLB     'SEVTDAYSAD'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDDADJ            5
      *
      ** Security Days Adjustment (from SECTYD)
     C                   PARM                    IADJ              3 0
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Days Adjustment - OK
     C                   PARM                    DDDADJOK          1
      *
      ** Trade Days Adjustment
      *
     C                   PARM                    DADJ              3 0
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Actual/Difference Ind.
      *****************************************************************
     C     VTACDFIN      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Actual/Difference Ind.
      *
     C                   CALLB     'SEVTACDFIN'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDACTD            1
      *
      ** Trade Days Adjustment
     C                   PARM                    DADJ              3 0
      *
      ** Security Days Adjustment (from SECTYD)
     C                   PARM                    IADJ              3 0
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Act/Diff Indicator - OK
     C                   PARM                    DDActdOK          1
      *
      ** Trade Act/Diff Indicator
      *
     C                   PARM                    ADIN              1
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Interest Amount
      *****************************************************************
     C     VTINTAMT      BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Interest Amount
      *
     C                   CALLB     'SEVTINTAMT'
 
      * INPUTS
 
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Screen Fields
      ** -------------
 
      ** Accrued indicator  (1A)
      ** Days Adjustment  (5A)
      ** Actual/Difference Indicator (1A)
      ** Interest Amount (15A)
     C                   PARM                    DDACIN
     C                   PARM                    DDDADJ
     C                   PARM                    DDACTD
     C                   PARM                    DDITRA
 
      ** Trade Details
      ** -------------
      ** Nominal  (11P 0)
      ** Value Date (5P 0)
      ** Days Adjustment <actual> (3P 0)
      ** Coupon rate (for trade) (11P 7)
      ** Overide Indicator  (1A)
 
     C                   PARM                    NOML
     C                   PARM                    TDVD
     C                   PARM                    DADJ
     C                   PARM                    TDCR
     C                   PARM                    ZCPOVR            1
 
      ** Security Details
      ** ----------------
      ** Interest days adjustment
      ** Nominal currency decimal places   (1P 0)
      ** Processing type   (1A)
 
     C                   PARM                    SECTY
     C                   PARM                    DADJN             1
     C                   PARM                    NomCcyDec
     C                   PARM                    PROT
 
      *
      ** System details
      ** --------------
      ** Date format  (1A)
     C                   PARM                    BJDFIN
 
      * OUTPUTS
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** OK Indicators
      ** -------------
 
      ** Days Adjustment OK indicator  (1A)
      ** Actual/Difference Ind OK indicator  (1A)
      ** Interest Amount OK Indicator (1A)
 
     C                   PARM                    ddDADJok
     C                   PARM                    ddACTDok
     C                   PARM                    ddITRAok
 
      ** Interest Amount
      ** Interest Adjustment
      ** Expected Interest Amount
     C                   PARM                    ITRA
     C                   PARM                    TINA
     C                   PARM                    EXPT_ITRA        13 0
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Validate Trade Price
      *****************************************************************
     C     VTPRICE       BEGSR
 
      * Reset variables updated by each module
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Price
      *
     C                   CALLB     'SEVTPRICE'
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeOut
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
 
      ** Trade Screen fields
      ** -------------------
      ** Price  (17A)
      ** Accrued indicator (1A)
      ** Action code                                                                          CSE035
      ** Price/Discount/Yield                                                                 CSE035
      ** Countervalue                                                                         CSE035
     C                   PARM                    DDPRIC
     C                   PARM                    DDACIN
     C                   PARM                    DDACTN                                       CSE035
     C                   PARM                    DDTPDY                                       CSE035
     C                   PARM                    DDTCTR           21                          CSE035
 
      ** Trade Details
      ** -------------
      * Nominal (15P 0)
      * Price/discount/yield  (15P 8)
      * Value date (5P 0)
      * Interest Amount (13P 0)
     C                   PARM                    NOML
     C                   PARM                    TPDY
     C                   PARM                    TDVD
     C                   PARM                    ITRA
 
      ** Security Details  (& nominal ccy dec places)
      ** ----------------
     C                   PARM                    SECTY
     C                   PARM                    NomCcyDec
      **
      ** Investment Type Details
      ** -----------------------
      ** Processing Type
     C                   PARM                    PROT              1
 
      ** System Info
      ** -----------
 
      * Date Format (1A)
     C                   PARM                    BJDFIN
 
      * OUTPUTS
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Price Ok INdicator (1A)
      ** Price (15P 8)
     C                   PARM                    DDPricOk
     C                   PARM                    PRIC
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************         CAP050
      /EJECT                                                                                  CGL031
      *****************************************************************                       CGL031
      ** Validate Fiscal Price                                                                CGL031
      *****************************************************************                       CGL031
     C     SRVFPrice     BEGSR                                                                CGL031
                                                                                              CGL031
      ** Reset variables updated by each module                                               CGL031
                                                                                              CGL031
     C                   EXSR      RESETERRS                                                  CGL031
                                                                                              CGL031
      ** Validate Fiscal Price                                                                CGL031
                                                                                              CGL031
     C                   CALLB     'SEVSEFSPR2'                                               CGL031
                                                                                              CGL031
      ** INPUTS                                                                               CGL031
      ** Return Code                                                                          CGL031
     C                   PARM                    RetCodeOut                                   CGL031
                                                                                              CGL031
      ** Default & Validate (Y or N)                                                          CGL031
                                                                                              CGL031
     C                   PARM                    Default           1                          CGL031
     C                   PARM                    Validate          1                          CGL031
                                                                                              CGL031
      ** Fiscal Price  (16A)                                                                  CGL031
                                                                                              CGL031
     C                   PARM                    DDFSPR                                       CGL031
                                                                                              CGL031
      ** Trade Date (5P 0)                                                                    CGL031
                                                                                              CGL031
     C                   PARM                    TDVD                                         CGL031
                                                                                              CGL031
      ** Security Details                                                                     CGL031
                                                                                              CGL031
     C                   PARM                    SECTY                                        CGL031
                                                                                              CGL031
      ** Investment Type Details                                                              CGL031
                                                                                              CGL031
     C                   PARM                    INVTP                                        CGL031
                                                                                              CGL031
      ** Customer (Counterparty) Details                                                      CGL031
                                                                                              CGL031
     C                   PARM                    CustDts                                      CGL031
     C                   PARM                    BJDFIN                                       CGL031
     C                   PARM                    DDBRCD                                       236708
      ** Current File Trade Date                                                              235547
     C                   PARM                    C_TDVD                                       235547
                                                                                              CGL031
      ** OUTPUTS                                                                              CGL031
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL031
                                                                                              CGL031
     C                   PARM                    FldNamXAr                                    CGL031
     C                   PARM                    MsgIDXAr                                     CGL031
     C                   PARM                    MsgDtaXAr                                    CGL031
                                                                                              CGL031
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CGL031
                                                                                              CGL031
     C                   PARM                    WFldNmXAr                                    CGL031
     C                   PARM                    WMsgIDXAr                                    CGL031
     C                   PARM                    WMsgDtXAr                                    CGL031
                                                                                              CGL031
      ** Price Ok INdicator (1A)                                                              CGL031
      ** Price (15P 8)                                                                        CGL031
                                                                                              CGL031
     C                   PARM                    DDFsprOk                                     CGL031
     C                   PARM                    FSPR                                         CGL031
     C                   PARM                    FSPP                                         CGL031
                                                                                              CGL031
      ** Update error info with that returned from the validation module                      CGL031
                                                                                              CGL031
     C                   EXSR      UPDATERRS                                                  CGL031
                                                                                              CGL031
     C                   ENDSR                                                                CGL031
      *****************************************************************                       CGL031
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
      /EJECT                                                                    157785
      *****************************************************************         157785
      *                                                               *         157785
      * SETUPVALID - Set up additional fields that are needed on the  *         157785
      *    Valid file record.                                         *         157785
      *                                                               *         157785
      *****************************************************************         157785
                                                                                157785
     C     SETUPVALID    BEGSR                                                  157785
                                                                                157785
     C                   MOVEL     DDTDID        TDID                           157785
     C                   MOVEL     DDLKRF        LKRF                           157785
     C                   MOVEL     DDTDNR        TDNR                           157785
     C                   MOVEL     DDSETC        SETC                                         249473
                                                                                157785
     C                   ENDSR                                                  157785
      *****************************************************************         157785
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
     C                   PARM                    TrPrim
     C                   PARM                    TrSeco
     C                   PARM                    ExtData                        CAP004
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default
     C                   PARM                    Validate
 
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
 
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *                                                                                       CSE028
      ** MT5xx SSI (Phase 2)                                                                  CSE028
     C                   PARM                    CSE028                                       CSE028
                                                                                              CGL031
      ** CGL031 Switchable Feature                                                            CGL031
     C                   PARM                    CGL031                                       CGL031
      ** Current File Trade Date                                                              235547
     C                   PARM                    C_TDVD                                       235547
      *
      * OUTPUTS
      *
      ** Settlement Currency Details
     C                   PARM                    SetCcyDts
 
      ** Trade Secondary Details OK inds
     C                   PARM                    OKTrSeco
 
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
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SETRADSVAL'  DBPGM
     C                   OUT       LDA
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
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 900*
     C                   EXSR      SRERR                                        ************
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
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 907*
     C                   EXSR      SRERR                                        ************
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
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 902*
     C                   EXSR      SRERR                                        ************
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
     C                   MOVEL     'SDSTRDPD'    DBFILE                         ************
     C                   MOVEL     '903'         DBASE                          * DBERR 905*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** Portfolio Management
      *
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDPORTPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   EXSR      SRERR
     C                   END
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
     C                   MOVEL     'SDPCACPD'    DBFILE                         ************
     C                   MOVEL     '905'         DBASE                          * DBERR 903*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   END
      *
      ** Check if switchable feature S01509 is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01509'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01509'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '906'         DBASE                          * DBERR 904*
     C                   EXSR      SRERR                                        ************
     C                   END
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           S01509
     C                   ELSE
     C                   MOVE      'N'           S01509            1
     C                   END
      *
      ** Check if switchable feature S01510 is switched on.
      *
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01510'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01510'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '907'         DBASE                          * DBERR 904*
     C                   EXSR      SRERR                                        ************
     C                   END
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           S01510
     C                   ELSE
     C                   MOVE      'N'           S01510            1
     C                   END
      *
      ** Check if switchable feature CEU005 is switched on.
      *
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU005'      @SARD
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU005'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '908'         DBASE                          * DBERR 904*
     C                   EXSR      SRERR                                        ************
     C                   END
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU005
     C                   ELSE
     C                   MOVE      'N'           CEU005            1
     C                   END
      *                                                                         CAP050
      ** Check if switchable feature CAP050 is switched on.                     CAP050
      *                                                                         CAP050
     C                   CALL      'AOSARDR0'                                   CAP050
     C                   PARM      *BLANKS       @RTCD                          CAP050
     C                   PARM      '*VERIFY'     @OPTN                          CAP050
     C                   PARM      'CAP050'      @SARD                          CAP050
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CAP050'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '909'         DBASE                          * DBERR 904*
     C                   EXSR      SRERR                                        ************
     C                   END
     C     @RTCD         IFEQ      *BLANKS                                      CAP050
     C                   MOVEL     'Y'           CAP050            1            CAP050
     C                   ELSE                                                   CAP050
     C                   MOVEL     'N'           CAP050                         CAP050
     C                   ENDIF                                                  CAP050
      *                                                                         CAC005
      ** Check if switchable feature CAC005 is switched on.                     CAC005
      *                                                                         CAC005
     C                   CALL      'AOSARDR0'                                   CAC005
     C                   PARM      *BLANKS       @RTCD                          CAC005
     C                   PARM      '*VERIFY'     @OPTN                          CAC005
     C                   PARM      'CAC005'      @SARD                          CAC005
      *                                                                         CAC005
      ** DATABASE ERROR                                                         CAC005
      *                                                                         CAC005
     C     @RTCD         IFNE      *BLANKS                                      CAC005
     C     @RTCD         ANDNE     '*NRF   '                                    CAC005
     C                   MOVEL     'CAC005'      DBKEY                          CAC005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CAC005
     C                   MOVEL     '910'         DBASE                          CAC005
     C                   EXSR      SRERR                                        CAC005
     C                   END                                                    CAC005
     C     @RTCD         IFEQ      *BLANK                                       CAC005
     C                   MOVE      'Y'           CAC005                         CAC005
     C                   ELSE                                                   CAC005
     C                   MOVE      'N'           CAC005            1            CAC005
     C                   END                                                    CAC005
      *
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
     C                   EVAL      DBASE = 914                                                CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SETRDSV040
 
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
     C                   MOVEL     'SETRADSVAL'  DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
      *
      **  Terminate the program
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
