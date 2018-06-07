     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Futures & Options Details Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDHVL - Customer Futures and Options Details Validation  *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD040876           Date 13Sep16               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUFOV001
 
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
     D TrnDets       E DS                  EXTNAME(SDCUFOPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDECUFOPD)
 
      ** Valid Transaction Details layout
     D ValidCufo     E DS                  EXTNAME(SDVCufoPD)
     D Validfox1     E DS                  EXTNAME(SDVFOX1PD)
 
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
     D DDCUST          S              6
     D I               S              3P 0
     D RespMode        S              1
     D ULX004          S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUFOV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SDCUFOV003
 
      ** Validate Statement Frequency
 
      /COPY WNCPYSRC,SDCUFOV004
     C                   EXSR      VSTFQSR
      /COPY WNCPYSRC,SDCUFOV005
 
      ** Validate Day in Month for Statement
 
      /COPY WNCPYSRC,SDCUFOV006
     C                   EXSR      VDMFSSR
      /COPY WNCPYSRC,SDCUFOV007
 
      ** Validate Next Statement Date
 
      /COPY WNCPYSRC,SDCUFOV008
     C                   EXSR      VNSDTSR
      /COPY WNCPYSRC,SDCUFOV009
 
      ** Validate Broker Indicator
 
      /COPY WNCPYSRC,SDCUFOV010
     C                   EXSR      VBKINSR
      /COPY WNCPYSRC,SDCUFOV011
 
      ** Validate settlement Type
 
      /COPY WNCPYSRC,SDCUFOV012
     C                   EXSR      VSTTYSR
      /COPY WNCPYSRC,SDCUFOV013
 
      ** Validate Correspondence Address
 
      /COPY WNCPYSRC,SDCUFOV014
     C                   EXSR      VCOADSR
      /COPY WNCPYSRC,SDCUFOV015
 
      ** Validate Telex Confirmation Ind.
 
      /COPY WNCPYSRC,SDCUFOV016
     C                   EXSR      VTXCISR
      /COPY WNCPYSRC,SDCUFOV017
 
      ** Validate Contract limit
 
      /COPY WNCPYSRC,SDCUFOV018
     C                   EXSR      VCTLMSR
      /COPY WNCPYSRC,SDCUFOV019
 
      ** Validate Revaluation Frequency
 
      /COPY WNCPYSRC,SDCUFOV020
     C                   EXSR      VRVFQSR
      /COPY WNCPYSRC,SDCUFOV021
 
      ** Validate Revaluation Base Day
 
      /COPY WNCPYSRC,SDCUFOV022
     C                   EXSR      VRVBDSR
      /COPY WNCPYSRC,SDCUFOV023
 
      ** Validate Next Revaluation Date
 
      /COPY WNCPYSRC,SDCUFOV024
     C                   EXSR      VNRDTSR
      /COPY WNCPYSRC,SDCUFOV025
 
      ** Validate Positions Combined Indicator
 
      /COPY WNCPYSRC,SDCUFOV026
     C                   EXSR      VPCINSR
      /COPY WNCPYSRC,SDCUFOV027
 
      ** Validate Automatic Closure Indicator
 
      /COPY WNCPYSRC,SDCUFOV028
     C                   EXSR      VACINSR
      /COPY WNCPYSRC,SDCUFOV029
 
      ** Validate Collateral currency
 
      /COPY WNCPYSRC,SDCUFOV030
     C                   EXSR      VCYCDSR
      /COPY WNCPYSRC,SDCUFOV031
 
      ** Validate Collateral Amount
 
      /COPY WNCPYSRC,SDCUFOV032
     C                   EXSR      VCOAMSR
      /COPY WNCPYSRC,SDCUFOV033
 
      ** Validate Settlement Branch
 
      /COPY WNCPYSRC,SDCUFOV034
     C                   EXSR      VSEBRSR
      /COPY WNCPYSRC,SDCUFOV035
 
      ** Validate Netting Agreement
 
      /COPY WNCPYSRC,SDCUFOV036
     C                   IF        ULX004 = 'Y'
     C                   EXSR      VNETASR
     C                   ENDIF
      /COPY WNCPYSRC,SDCUFOV037
 
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUFOV038
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VSTFQSR - Validate Statement Frequency                       *
      *                                                               *
      *****************************************************************
     C     VSTFQSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Statement Frequency
 
     C                   CALLB     'SDVSTFQ'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Statement Frequency
 
     C                   PARM                    DDSTFQ
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Statement Frequency - OK
 
     C                   PARM                    DDSTFQOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VDMFSSR - Validate Day in Month for Statement                *
      *                                                               *
      *****************************************************************
      *
     C     VDMFSSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Day in Month for Statement
 
     C                   CALLB     'SDVDMFS'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Day in Month for Statement
 
     C                   PARM                    DDDMFS
 
      ** Statement Frequency
 
     C                   PARM                    DDSTFQ
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Day in Month for Statement - OK
 
     C                   PARM                    DDDMFSOK
 
      ** Return value, Validate Day in Month for Statement
 
     C                   PARM                    FODMFS
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VNSDTSR - Validate Next Statement Date                       *
      *                                                               *
      *****************************************************************
      *
     C     VNSDTSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Next Statement Date
 
     C                   CALLB     'SDVNSDT'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Next Statement Date
 
     C                   PARM                    DDNSDT
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Next Statement Date - OK
 
     C                   PARM                    DDNSDTOK
 
      ** Returned value of Next Statement Date
 
     C                   PARM                    FONSDT
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VBKINSR - Validate Broker Indicator                          *
      *                                                               *
      *****************************************************************
 
     C     VBKINSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Broker Indicator
 
     C                   CALLB     'SDVBKIN'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Broker Indicator
 
     C                   PARM                    DDBKIN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Broker Indicator - OK
 
     C                   PARM                    DDBKINOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VSTTYSR - Validate Settlement Type                           *
      *                                                               *
      *****************************************************************
      *
     C     VSTTYSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Settlement Type
 
     C                   CALLB     'SDVSTTY'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Settlement type
 
     C                   PARM                    DDSTTY
 
      ** For Account of
 
     C                   PARM                    DDFACO
 
      ** CounterParty Nostro
 
     C                   PARM                    DDCPNO
 
      ** Settlement Account
 
     C                   PARM                    DDSMAC
 
      ** Currency Code
 
     C                   PARM                    DDCYCD
 
      ** Customer Number
 
     C                   PARM                    DDCUST
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Settlement Type - OK
 
     C                   PARM                    DDSTTYOK
 
      ** For Account of  - OK
 
     C                   PARM                    DDFACOOK
 
      ** Counterparty Nostro - OK
 
     C                   PARM                    DDCPNOOK
 
      ** Settlement Account - OK
 
     C                   PARM                    DDSMACOK
 
      ** Return value for CounterParty Nostro
 
     C                   PARM                    FOCPNO
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VCOADSR - Validate Correspondence Address                    *
      *                                                               *
      *****************************************************************
 
     C     VCOADSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Correspondence Address
 
     C                   CALLB     'SDVCOAD'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Correspondence Address
 
     C                   PARM                    DDCOAD
 
      ** Broker Indicator
 
     C                   PARM                    DDBKIN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Correspondence Address - OK
 
     C                   PARM                    DDCOADOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VTXCISR - Validate Telex Confirmation Ind.                   *
      *                                                               *
      *****************************************************************
      *
     C     VTXCISR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Telex Confirmation Ind.
 
     C                   CALLB     'SDVTXCI'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Telex Confirmation Ind.
 
     C                   PARM                    DDTXCI
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Telex Confirmation Ind.- OK
 
     C                   PARM                    DDTXCIOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VCTLMSR - Validate Contract limit                            *
      *                                                               *
      *****************************************************************
      *
     C     VCTLMSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Contract limit
 
     C                   CALLB     'SDVCTLM'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Contract limit
 
     C                   PARM                    DDCTLM
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Contract limit - OK
 
     C                   PARM                    DDCTLMOK
 
      ** Return value for Contract Limit,
 
     C                   PARM                    FOCTLM
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VRVFQSR -Validate Revaluation Frequency                      *
      *                                                               *
      *****************************************************************
 
     C     VRVFQSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Revaluation Frequency
 
     C                   CALLB     'SDVRVFQ'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Revaluation Frequency
 
     C                   PARM                    DDRVFQ
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Revaluation Frequency - OK
 
     C                   PARM                    DDRVFQOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VRVBDSR - Validate Revaluation Base Day                      *
      *                                                               *
      *****************************************************************
 
     C     VRVBDSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Revaluation Base Day
 
     C                   CALLB     'SDVRVBD'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Revaluation Base Day
 
     C                   PARM                    DDRVBD
 
      ** Revaluation Frequency
 
     C                   PARM                    DDRVFQ
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Revaluation Base Day - OK
 
     C                   PARM                    DDRVBDOK
 
      ** Return value Revaluation Base Day,
 
     C                   PARM                    FORVBD
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VNRDTSR - Validate Next Revaluation Date                     *
      *                                                               *
      *****************************************************************
      *
     C     VNRDTSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Next Revaluation Date
 
     C                   CALLB     'SDVNRDT'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Next Revaluation Date
 
     C                   PARM                    DDNRDT
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Next Revaluation Date - OK
 
     C                   PARM                    DDNRDTOK
 
      ** Return Value Next Revaluation date
 
     C                   PARM                    FONRDT
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VPCINSR - Validate Positions Combined Indicator              *
      *                                                               *
      *****************************************************************
      *
     C     VPCINSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Positions Combined Indicator
 
     C                   CALLB     'SDVPCIN'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Positions Combined Indicator
 
     C                   PARM                    DDPCIN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Positions Combined Indicator - OK
 
     C                   PARM                    DDPCINOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VACINSR - Validate Automatic Closure Indicator               *
      *                                                               *
      *****************************************************************
     C     VACINSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Automatic Closure Indicator
 
     C                   CALLB     'SDVCACIN'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Automatic Closure Indicator
 
     C                   PARM                    DDACIN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Automatic Closure Indicator - OK
 
     C                   PARM                    DDACINOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VCYCDSR - Validate Collateral Currency                       *
      *                                                               *
      *****************************************************************
      *
     C     VCYCDSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Collateral Currency
 
     C                   CALLB     'SDVCYCD'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Collateral Currency
 
     C                   PARM                    DDCYCD
 
      ** Collateral Description,
 
     C                   PARM                    DDCODE
 
      ** Collateral Amount
 
     C                   PARM                    DDCOAM
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Collateral Currency - OK
 
     C                   PARM                    DDCYCDOK
 
      ** Collateral Description - OK
 
     C                   PARM                    DDCODEOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VCOAMSR - Validate Collateral Amount                         *
      *                                                               *
      *****************************************************************
     C     VCOAMSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Collateral Amount
 
     C                   CALLB     'SDVCOAM'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Collateral Amount
 
     C                   PARM                    DDCOAM
 
      ** Collateral Currency
 
     C                   PARM                    DDCYCD
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Collateral Amount - OK
 
     C                   PARM                    DDCOAMOK
 
      ** Return Collateral Amount
 
     C                   PARM                    FOCOAM
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VSEBRSR - Validate Settlement Branch                         *
      *                                                               *
      *****************************************************************
     C     VSEBRSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Settlement Branch
 
     C                   CALLB     'SDVSEBR'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Settlement Branch
 
     C                   PARM                    DDSEBR
 
      ** Settlement Type
 
     C                   PARM                    DDSTTY
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Settlement Branch - OK
 
     C                   PARM                    DDSEBROK
 
      ** Return value of Settlement Branch
 
     C                   PARM                    FOSEBR
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VNETASR - Validate Netting Agreement                         *
      *                                                               *
      *****************************************************************
     c     VNETASR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Netting Agreement
 
     C                   CALLB     'SDVNETA'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Netting Agreement
 
     C                   PARM                    DDNETA
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Netting Agreement - OK
 
     C                   PARM                    DDNETAOK
 
      ** Return value of Netting Agreement
 
     C                   PARM                    LXNETA
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      *****************************************************************
     C     RESETERRS     BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
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
      *  INZSR - Program Initialisation routine                       *
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
 
     C                   PARM                    ULX004
 
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
 
     C                   PARM                    ValidCUFO
 
     C                   PARM                    ValidFOX1
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUFOV039
 
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
(c) Finastra International Limited 2007
