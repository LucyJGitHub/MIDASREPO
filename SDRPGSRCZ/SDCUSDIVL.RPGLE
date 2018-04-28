     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Portfolio Management Details Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDIVL - Customer Portfolio Management Details Validation *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUPMV001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **------------------------------------------------------------------
 
      **------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **------------------------------------------------------------------
 
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
 
      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(SDCUPMPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDECUPMPD)
 
      ** Valid Transaction Details layout
     D ValidCupm     E DS                  EXTNAME(SDVCUPMPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work fields for bank data
     D WKDFIN          S                   LIKE(BJDFIN)
     D WKRDNB          S                   LIKE(BJRDNB)
     D WKCYCD          S                   LIKE(BJCYCD)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Variables
     D I               S              3P 0
     D RespMode        S              1
     D DDCUSN          S              6
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUPMV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SDCUPMV003
 
      ** Validate Date of Birth(Portfolio)
 
      /COPY WNCPYSRC,SDCUPMV004
     C                   EXSR      VBDATSR
      /COPY WNCPYSRC,SDCUPMV005
 
      ** Validate Customer Base Currency
 
      /COPY WNCPYSRC,SDCUPMV006
     C                   EXSR      VCSBYSR
      /COPY WNCPYSRC,SDCUPMV007
 
      ** Validate Valuation Frequency
 
      /COPY WNCPYSRC,SDCUPMV008
     C                   EXSR      VVLFQSR
      /COPY WNCPYSRC,SDCUPMV009
 
      ** Validate Day in Month
 
      /COPY WNCPYSRC,SDCUPMV010
     C                   EXSR      VVLDMSR
      /COPY WNCPYSRC,SDCUPMV011
 
      ** Validate Next Valuation Date
 
      /COPY WNCPYSRC,SDCUPMV012
     C                   EXSR      VVLNDSR
      /COPY WNCPYSRC,SDCUPMV013
 
      ** Validate Holdings/Valuation Group
 
      /COPY WNCPYSRC,SDCUPMV014
     C                   EXSR      VS1VRSR
      /COPY WNCPYSRC,SDCUPMV015
 
      ** Validate Sector Break Down Required
 
      /COPY WNCPYSRC,SDCUPMV016
     C                   EXSR      VS2VRSR
      /COPY WNCPYSRC,SDCUPMV017
 
      ** Validate Past Year Performance Required
 
      /COPY WNCPYSRC,SDCUPMV018
     C                   EXSR      VS3VRSR
      /COPY WNCPYSRC,SDCUPMV019
 
      ** Validate Tax Year Performance Required
 
      /COPY WNCPYSRC,SDCUPMV020
     C                   EXSR      VS4VRSR
      /COPY WNCPYSRC,SDCUPMV021
 
      ** Validate Additional Performance Required
 
      /COPY WNCPYSRC,SDCUPMV022
     C                   EXSR      VS5VRSR
      /COPY WNCPYSRC,SDCUPMV023
 
      ** Validate Daily Cashflows Required
 
      /COPY WNCPYSRC,SDCUPMV024
     C                   EXSR      VS6VRSR
      /COPY WNCPYSRC,SDCUPMV025
 
      ** Validate Monthly Cashflows Required
 
      /COPY WNCPYSRC,SDCUPMV026
     C                   EXSR      VS7VRSR
      /COPY WNCPYSRC,SDCUPMV027
 
      ** Validate Yearly cashflows Required
 
      /COPY WNCPYSRC,SDCUPMV028
     C                   EXSR      VS8VRSR
      /COPY WNCPYSRC,SDCUPMV029
 
      ** Validate Pool Portfolio Customer Indicator
 
      /COPY WNCPYSRC,SDCUPMV030
     C                   EXSR      VPPCSSR
      /COPY WNCPYSRC,SDCUPMV031
 
      ** Validate Default Portfolio
 
      /COPY WNCPYSRC,SDCUPMV032
     C                   EXSR      VDFPOSR
      /COPY WNCPYSRC,SDCUPMV033
 
      ** Validate Instrument Summary
 
      /COPY WNCPYSRC,SDCUPMV034
     C                   EXSR      VINSUSR
      /COPY WNCPYSRC,SDCUPMV035
 
      ** Validate Currency Summary
 
      /COPY WNCPYSRC,SDCUPMV036
     C                   EXSR      VCYSUSR
      /COPY WNCPYSRC,SDCUPMV037
 
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUPMV038
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VBDATSR - Validate Date of Birth (Portfolio)                 *
      *                                                               *
      *****************************************************************
     C     VBDATSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Date of Birth (Portfolio)
 
     C                   CALLB     'SDVBDAT'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Date of Birth (Portfolio)
 
     C                   PARM                    DDBDAT
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Date of Birth (Portfolio) - OK
 
     C                   PARM                    DDBDATOK
 
      ** Return value of Date of Birth
 
     C                   PARM                    PMBDAT
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VCSBYSR - Validate Customer Base Currency                    *
      *                                                               *
      *****************************************************************
 
     C     VCSBYSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Customer Base Currency
 
     C                   CALLB     'SDVCSBY'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Customer Base Currency
 
     C                   PARM                    DDCSBY
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Customer Base Currency  - OK
 
     C                   PARM                    DDCSBYOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VVLFQSR - Validate Valuation Frequency                       *
      *                                                               *
      *****************************************************************
      *
     C     VVLFQSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Valuation Frequency
 
     C                   CALLB     'SDVVLFQ'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Valuation Frequency
 
     C                   PARM                    DDVLFQ
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Valuation Frequency - OK
 
     C                   PARM                    DDVLFQOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VVLDMSR - Validate Valuation Day in Month                    *
      *                                                               *
      *****************************************************************
 
     C     VVLDMSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Valuation Day in Month
 
     C                   CALLB     'SDVVLDM'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Valuation Day in Month
 
     C                   PARM                    DDVLDM
 
      ** Valuation Frequency
 
     C                   PARM                    DDVLFQ
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Valuation Day in Month - OK
 
     C                   PARM                    DDVLDMOK
 
      ** Return value of Valuation day in Month
 
     C                   PARM                    PMVLDM
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VVLNDSR - Validate Next Valuation Date                       *
      *                                                               *
      *****************************************************************
      *
     C     VVLNDSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Next Valuation Date
 
     C                   CALLB     'SDVVLND'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Next Valuation Date
 
     C                   PARM                    DDVLND
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Next Valuation Date - OK
 
     C                   PARM                    DDVLNDOK
 
      ** Return value for Next Valuation Date
 
     C                   PARM                    PMVLND
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VS1VRSR - Validate Holdings/Valuation Group                  *
      *                                                               *
      *****************************************************************
      *
     C     VS1VRSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Holdings/Valuation Group
 
     C                   CALLB     'SDVS1VR'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Holdings/Valuation Group
 
     C                   PARM                    DDS1VR
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Holdings/Valuation Group - OK
 
     C                   PARM                    DDS1VROK
 
      ** Update error info with that returned from the validation
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VS2VRSR - Validate Sector Breakdown Required                 *
      *                                                               *
      *****************************************************************
 
     C     VS2VRSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Sector Breakdown Required
 
     C                   CALLB     'SDVS2VR'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Sector Breakdown Required
 
     C                   PARM                    DDS2VR
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Sector Breakdown Required - OK
 
     C                   PARM                    DDS2VROK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VS3VRSR - Validate Past Year Performance Required            *
      *                                                               *
      *****************************************************************
 
     C     VS3VRSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Past Year Performance Required
 
     C                   CALLB     'SDVS3VR'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Past Year Performance Required
 
     C                   PARM                    DDS3VR
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Past Year Performance Required - OK
 
     C                   PARM                    DDS3VROK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VS4VRSR - Validate Tax Year Performance Required             *
      *                                                               *
      *****************************************************************
 
     C     VS4VRSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Tax Year Performance Required
 
     C                   CALLB     'SDVS4VR'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Tax Year Performance Required
 
     C                   PARM                    DDS4VR
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Tax Year Performance Required - OK
 
     C                   PARM                    DDS4VROK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VS5VRSR - Validate Additional Performance Required           *
      *                                                               *
      *****************************************************************
     C     VS5VRSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Additional Performance Required
 
     C                   CALLB     'SDVS5VR'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Additional Performance Required
 
     C                   PARM                    DDS5VR
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Additional Performance Required - OK
 
     C                   PARM                    DDS5VROK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VS6VRSR - Validate Daily Cashflows Required                  *
      *                                                               *
      *****************************************************************
      *
     C     VS6VRSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Daily Cashflows Required
 
     C                   CALLB     'SDVS6VR'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Daily Cashflows Required
 
     C                   PARM                    DDS6VR
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Daily Cashflows Required - OK
 
     C                   PARM                    DDS6VROK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VS7VRSR - Validate Monthly Cashflows Required                *
      *                                                               *
      *****************************************************************
 
     C     VS7VRSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Monthly Cashflows Required
 
     C                   CALLB     'SDVS7VR'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Monthly Cashflows Required
 
     C                   PARM                    DDS7VR
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Monthly Cashflows Required - OK
 
     C                   PARM                    DDS7VROK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VS8VRSR - Validate Yearly Cashflows Required                 *
      *                                                               *
      *****************************************************************
 
     C     VS8VRSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Yearly Cashflows Required
 
     C                   CALLB     'SDVS8VR'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Yearly Cashflows Required
 
     C                   PARM                    DDS8VR
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Yearly Cashflows Required - OK
 
     C                   PARM                    DDS8VROK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VPPCSSR - Validate Pool Portfolio Customer Indicator         *
      *                                                               *
      *****************************************************************
 
     C     VPPCSSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Pool Portfolio Customer Indicator
 
     C                   CALLB     'SDVPPCS'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Pool Portfolio Customer Indicator
 
     C                   PARM                    DDPPCS
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Pool Portfolio Customer Indicator - OK
 
     C                   PARM                    DDPPCSOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VDFPOSR - Validate Default portfolio                         *
      *                                                               *
      *****************************************************************
 
     C     VDFPOSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Default portfolio
 
     C                   CALLB     'SDVDFPO'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Default portfolio
 
     C                   PARM                    DDDFPO
 
      ** Customer Number
 
     C                   PARM                    DDCUSN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Default portfolio - OK
 
     C                   PARM                    DDDFPOOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VINSUSR - Validate Instrument Summary                        *
      *                                                               *
      *****************************************************************
 
     C     VINSUSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Instrument Summary
 
     C                   CALLB     'SDVINSU'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Instrument Summary
 
     C                   PARM                    DDINSU
 
      ** Valuation Frequency
 
     C                   PARM                    DDVLFQ
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Instrument Summary - OK
 
     C                   PARM                    DDINSUOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VCYSUSR - Validate Currency Summary                          *
      *                                                               *
      *****************************************************************
 
     C     VCYSUSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Currency Summary
 
     C                   CALLB     'SDVCYSU'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Currency Summary
 
     C                   PARM                    DDCYSU
 
      ** Valuation Frequency
 
     C                   PARM                    DDVLFQ
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Currency Summary - OK
 
     C                   PARM                    DDCYSUOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
 
      ** Reset error & warning fields/message IDs/message data (arrays)
 
     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   EVAL      WFldNmXAr = *BLANK
     C                   EVAL      WMsgIDXAr = *BLANK
     C                   EVAL      WMsgDtXAr = *BLANK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
 
      ** Update error fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
 
      ** Set Error Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
 
      ** Update warning fields/message IDs/message data (arrays)
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
 
      ** Set Warning Index
 
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      ** Inputs
      ** Response mode
 
     C                   PARM                    RespMode
 
      ** Transaction Details
 
     C                   PARM                    TrnDets
 
      ** Customer Number
 
     C                   PARM                    DDCUSN
 
      ** Outputs
      ** Transaction Details OK inds
 
     C                   PARM                    OKTrnDets
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    Idx
 
      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WIdx
 
      ** Valid Transaction details layout (DS) from/to caller
 
     C                   PARM                    ValidCupm
      *
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      * Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUPMV039
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      **------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2007
