     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Additional Details Validation')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDAVL - Customer Additional Details Validation           *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD050052           Date 16Mar18               *
      *  Prev Amend No. CGL157             Date 17Aug15               *
      *                 MD040876           Date 13Sep16               *
      *                 MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 MD021510           Date 09Aug13               *
      *                 CLE134             Date 01Aug12               *
      *                 AR739736           Date 01Apr11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG15872           Date 12Feb08               *
      *                 BUG15314           Date 23Nov07               *
      *                 CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050052 - Serious Midas Error is encountered during CUSD    *
      *  CGL157 - CRS Reporting                                       *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  MD021510 -  Account Owner/Family and Company Name/First Name *
      *              are being populated from Repair Queue even no    *
      *              value is passed Edit                             *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  AR739736 - USR4761: Joint Account Type cannot be "I"         *
      *             Customer is a Bank (Child:AR739761)               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG15872 - Parameter mismatch. Applied fix BUG14992/BUG15314.*
      *  BUG15314 - A "serious Midas error" occurred upon clicking    *
      *             Confirm authorise in CUSD                         *
      *  BUG14992 - Some of CSW207 fields not completely upgraded     *
      *  CSD079 - Enhanced Customer Maintenance API                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUADV001
 
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
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(SDCUADPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDECUADPD)
 
      ** Valid Transaction Details layout
     D ValidCuad     E DS                  EXTNAME(SDVCUADPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Midas SD Midas modules Data Structure                                              BUG14992
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                BUG14992
                                                                                            BUG14992
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
      *
     D DDCOLC          S              2    INZ(*BLANKS)
     D PTaxStat        S              1    INZ(*BLANKS)
     D WDateOut        S              8    INZ(*BLANKS)
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Work fields
     D I               S              3P 0
     D W               S              2S 0                                                    CGL157
     D RespMode        S              1A
     D DDCUSN          S              6A
     D DDBNBI          S              1A                                                    AR739736
     D CGL032          S              1A
     D CLE134          S              1A                                                      CLE134
     D CSW207          S              1A                                                    BUG14992
     D DDOKCTR1        S              1A                                                      CGL157
     D DDOKCTR2        S              1A                                                      CGL157
     D DDOKCTR3        S              1A                                                      CGL157
     D DDOKCTR4        S              1A                                                      CGL157
     D DDOKCTR5        S              1A                                                      CGL157
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUADV002
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,SDCUADV003
 
      ** Validate Tax Details Crosscheck
 
      /COPY WNCPYSRC,SDCUADV004
     C                   IF        CGL032  = 'Y'
     C                             OR CSW207 = 'Y'                                          BUG14992
     C                   EXSR      VTXCC01SR
     C                   ENDIF
      /COPY WNCPYSRC,SDCUADV005
 
      ** Validate Joint Account Type
 
      /COPY WNCPYSRC,SDCUADV006
     C                   IF        CGL032  = 'Y'
     C                             OR CSW207 = 'Y'                                          BUG14992
     C                   EXSR      VJACT01SR
     C                   ENDIF
      /COPY WNCPYSRC,SDCUADV007
 
      ** Validate Identification Type
 
      /COPY WNCPYSRC,SDCUADV008
     C                   IF        CGL032  = 'Y'
     C                             OR CSW207 = 'Y'                                          BUG14992
     C                   EXSR      VIDTP01SR
     C                   ENDIF
      /COPY WNCPYSRC,SDCUADV009
 
      ** Validate Issuing Country
 
      /COPY WNCPYSRC,SDCUADV010
     C                   IF        CGL032  = 'Y'
     C                             OR CSW207 = 'Y'                                          BUG14992
     C                   EXSR      VICTR01SR
     C                   ENDIF
      /COPY WNCPYSRC,SDCUADV011
 
      ** Validate Issuing Date
 
      /COPY WNCPYSRC,SDCUADV012
     C                   IF        CGL032  = 'Y'
     C                             OR CSW207 = 'Y'                                          BUG14992
     C                   EXSR      VIDAT01SR
     C                   ENDIF
      /COPY WNCPYSRC,SDCUADV013
 
      ** Validate Date of Birth
 
      /COPY WNCPYSRC,SDCUADV014
     C                   EXSR      VBRTHSR
      /COPY WNCPYSRC,SDCUADV015
 
      ** Validate Provisional opening
 
      /COPY WNCPYSRC,SDCUADV016
     C                   EXSR      VPRVOSR
      /COPY WNCPYSRC,SDCUADV017
 
      ** Validate Date of Last Visit
 
      /COPY WNCPYSRC,SDCUADV018
     C                   EXSR      VDOLVSR
      /COPY WNCPYSRC,SDCUADV019
 
      ** Validate Place of Birth
 
      /COPY WNCPYSRC,SDCUADV020
     C                   IF        CGL032  = 'Y'
     C                             OR CSW207 = 'Y'                                          BUG14992
     C                   EXSR      VCBTH01SR
     C                   ENDIF
      /COPY WNCPYSRC,SDCUADV021
 
      ** Validate Family Name
 
      /COPY WNCPYSRC,SDCUADV022
     C                   EXSR      VFAMI01SR
      /COPY WNCPYSRC,SDCUADV023
 
      ** Validate First Name
 
      /COPY WNCPYSRC,SDCUADV024
     C                   EXSR      VFIRS01SR
      /COPY WNCPYSRC,SDCUADV025
 
      ** Validate Street of Residence 1
 
      /COPY WNCPYSRC,SDCUADV026
     C                   EXSR      VSTR101SR
      /COPY WNCPYSRC,SDCUADV027
 
      ** Validate Street of Residence 2
 
      /COPY WNCPYSRC,SDCUADV028
     C                   EXSR      VSTR201SR
      /COPY WNCPYSRC,SDCUADV029
 
      ** Validate City
 
      /COPY WNCPYSRC,SDCUADV030
     C                   IF        CGL032  = 'Y'
     C                             OR CSW207 = 'Y'                                          BUG14992
     C                   EXSR      VCITY01SR
     C                   ENDIF
      /COPY WNCPYSRC,SDCUADV031
 
      ** Validate Zip Code
 
      /COPY WNCPYSRC,SDCUADV032
     C                   IF        CGL032  = 'Y'
     C                             OR CSW207 = 'Y'                                          BUG14992
     C                   EXSR      VZIPC01SR
     C                   ENDIF
                                                                                              CLE134
      ** Validate Basel II Past Due Customer                                                  CLE134
                                                                                              CLE134
     C                   IF        CLE134  = 'Y'                                              CLE134
     C                   EXSR      SRVPDCU                                                    CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      /COPY WNCPYSRC,SDCUADV033
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                             BUG14992
     C                   EXSR      SRVCISCD                                                 BUG14992
     C                   ENDIF                                                              BUG14992
                                                                                              CGL157
     C                   EXSR      SrMail                                                     CGL157
     C                   EXSR      SrPhone                                                    CGL157
 
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
 
      /COPY WNCPYSRC,SDCUADV034
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VTXCC01SR - Validate Tax Details Crosscheck                  *
      *                                                               *
      *****************************************************************
 
     C     VTXCC01SR     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Tax Details Crosscheck
 
     C                   CALLB     'SDVTXCC01'
 
      ** INPUTS
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Customer Number
 
     C                   PARM                    DDCUSN
 
      ** Tax Identification Number
 
     C                   PARM                    DDTINO
 
      ** Birth information (date, country and town)
 
     C                   PARM                    DDDBTH
     C                   PARM                    DDBTHC
     C                   PARM                    DDBTHT
 
     C                   PARM                    DDCOLC
     C                   PARM                    DDJATP
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Tax Identification Number - OK
      ** Date of Birth - OK
      ** Country of Birth - OK
      ** Town of Birth - OK
      ** Tax Status
 
     C                   PARM                    DDTINOOK
     C                   PARM                    DDDBTHOK
     C                   PARM                    DDBTHCOK
     C                   PARM                    DDBTHTOK
     C                   PARM                    PTaxStat
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VJACT01SR - Validate Joint Account Type                      *
      *                                                               *
      *****************************************************************
 
     C     VJACT01SR     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Joint Account Type
 
     C                   CALLB     'SDVJACT01'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Customer Number
 
     C                   PARM                    DDCUSN
 
      ** Joint Account Type
 
     C                   PARM                    DDJATP
                                                                                            AR739736
      ** Bank/non-bank Indicator                                                            AR739736
                                                                                            AR739736
     C                   PARM                    DDBNBI                                     AR739736
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Joint Account Type - OK
 
     C                   PARM                    DDJATPOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VIDTP01SR - Validate Identification Type                     *
      *                                                               *
      *****************************************************************
 
     C     VIDTP01SR     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Identification Type
 
     C                   CALLB     'SDVIDTP01'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Tax Identification Number
 
     C                   PARM                    DDTINO
 
      ** Identification Type
 
     C                   PARM                    DDIDTP
                                                                                            MD050052
      ** Identity number                                                                    MD050052
     C                   PARM                    DDIDNO                                     MD050052
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Identification Type - OK
 
     C                   PARM                    DDIDTPOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VICTR01SR - Validate Issuing Country                         *
      *                                                               *
      *****************************************************************
 
     C     VICTR01SR     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Issuing Country
 
     C                   CALLB     'SDVICTR01'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Tax Identification Number
 
     C                   PARM                    DDTINO
 
      ** Issuing Country
 
     C                   PARM                    DDISCT
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Issuing Country - OK
 
     C                   PARM                    DDISCTOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      ****************************************************************
      *                                                              *
      *  VIDAT01SR - Validate Issuing Date                           *
      *                                                              *
      ****************************************************************
 
     C     VIDAT01SR     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Issuing Date
 
     C                   CALLB     'SDVIDAT01'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Tax Identification Number
 
     C                   PARM                    DDTINO
 
      ** Issuing Date
 
     C                   PARM                    DDISDT
 
      ** OUTPUTS
      ** Issuing Date in Midas Day Number
 
     C                   PARM                    WDateOut
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Issuing Date - OK
 
     C                   PARM                    DDISDTOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  VBRTHSR - Validate Date of Birth                             *
      *                                                               *
      *****************************************************************
 
     C     VBRTHSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Date of Birth
 
     C                   CALLB     'SDVBRTH'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Date of Birth
 
     C                   PARM                    DDBRTH
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Date of Birth  - OK
 
     C                   PARM                    DDBRTHOK
 
      ** O/P valid calculated fields
      ** Date of Birth
 
     C                   PARM                    ADBRTH
 
      ** Date of Birth DAF1
 
     C                   PARM                    ADBRT1
 
      ** Date of Birth DAF2
 
     C                   PARM                    ADBRT2
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  VPRVOSR - Validate Provisional Opening                       *
      *                                                               *
      *****************************************************************
 
     C     VPRVOSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Provisional Opening
 
     C                   CALLB     'SDVPRVO'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Provisional Opening
 
     C                   PARM                    DDPRVO
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Provisional Opening   - OK
 
     C                   PARM                    DDPRVOOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  VDOLVSR - Validate Date of last Visit                        *
      *                                                               *
      *****************************************************************
 
     C     VDOLVSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Date of Last Visit
 
     C                   CALLB     'SDVDOLV'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Date of Last Visit
 
     C                   PARM                    DDDOLV
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Date of Last Visit - OK
 
     C                   PARM                    DDDOLVOK
 
      ** Date of Last Visit
 
     C                   PARM                    ADDOLV
 
      ** Update error info with that returned from the validation
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  VCBTH01SR - Validate Place of Birth                          *
      *                                                               *
      *****************************************************************
 
     C     VCBTH01SR     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Place of Birth
 
     C                   CALLB     'SDVCBTH01'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Place of Birth
 
     C                   PARM                    DDBTHC
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Place of Birth - Country - OK
 
     C                   PARM                    DDBTHCOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  VFAMI01SR - Validate Family Name                             *
      *                                                               *
      *****************************************************************
 
     C     VFAMI01SR     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Family Name
 
     C                   CALLB     'SDVFAMI01'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Customer Number
 
     C                   PARM                    DDCUSN
 
      ** Family Name
 
     C                   PARM                    DDCNA1
 
      ** Tax Status
 
     C                   PARM                    PTaxStat
 
      ** Joint A/c Type
 
     C                   PARM                    DDJATP
                                                                                            MD021510
      ** Action Code                                                                        MD021510
                                                                                            MD021510
     C                   PARM                    DDACTN                                     MD021510
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C**********         PARM                    MsgIDXAr                                   BUG15314
     C                   PARM                    MsgDtaXAr
 
      ** Cust. Name and Address 1 - OK
 
     C                   PARM                    DDCNA1OK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  VFIRS01SR - Validate First Name                              *
      *                                                               *
      *****************************************************************
 
     C     VFIRS01SR     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate First Name
 
     C                   CALLB     'SDVFIRS01'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Customer Number                                                                    BUG15314
                                                                                            BUG15314
     C                   PARM                    DDCUSN                                     BUG15314
      ** Family Name
 
     C                   PARM                    DDCNA2
 
      ** Tax Status
 
     C                   PARM                    PTaxStat
 
      ** Joint A/c Type
 
     C                   PARM                    DDJATP
                                                                                            MD021510
      ** Action Code                                                                        MD021510
                                                                                            MD021510
     C                   PARM                    DDACTN                                     MD021510
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Cust. Name and Address 2 - OK
 
     C                   PARM                    DDCNA2OK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  VSTR101SR - Validate Street of Residence 1                   *
      *                                                               *
      *****************************************************************
 
     C     VSTR101SR     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Street of Residence 1
 
     C                   CALLB     'SDVSTR101'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Customer Number
 
     C                   PARM                    DDCUSN
 
      ** Cust. Name and Address 3
 
     C                   PARM                    DDCNA3
 
      ** Tax Status
 
     C                   PARM                    PTaxStat
 
      ** Joint A/c Type
 
     C                   PARM                    DDJATP
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Cust. Name and Address 3 - OK
 
     C                   PARM                    DDCNA3OK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  VSTR201SR - Validate Street of Residence 2                   *
      *                                                               *
      *****************************************************************
 
     C     VSTR201SR     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Street of Residence 2
 
     C                   CALLB     'SDVSTR201'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Customer Number
 
     C                   PARM                    DDCUSN
 
      ** Cust. Name and Address 4
 
     C                   PARM                    DDCNA4
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Cust. Name and Address 4 - OK
 
     C                   PARM                    DDCNA4OK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  VCITY01SR - Validate City                                    *
      *                                                               *
      *****************************************************************
 
     C     VCITY01SR     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate City
 
     C                   CALLB     'SDVCITY01'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Customer Number
 
     C                   PARM                    DDCUSN
 
      ** City
 
     C                   PARM                    DDCITY
 
      ** Tax Status
 
     C                   PARM                    PTaxStat
 
      ** Joint A/c Type
 
     C                   PARM                    DDJATP
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** City - OK
 
     C                   PARM                    DDCITYOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  VZIPC01SR - Validate Zip Code                                *
      *                                                               *
      *****************************************************************
 
     C     VZIPC01SR     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Zip Code
 
     C                   CALLB     'SDVZIPC01'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Zip Code
 
     C                   PARM                    DDZIPC
 
      ** Tax Status
 
     C                   PARM                    PTaxStat
 
      ** Joint A/c Type
 
     C                   PARM                    DDJATP
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Tax Identification Number - OK
 
     C                   PARM                    DDZIPCOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
     C                   ENDSR
 
      *****************************************************************                     BUG14992
      /EJECT                                                                                BUG14992
      *****************************************************************                     BUG14992
      * SRVCISCD - Validate Issuer Code                               *                     BUG14992
      *****************************************************************                     BUG14992
     C     SRVCISCD      BEGSR                                                              BUG14992
                                                                                            BUG14992
      ** Reset variables updated by validation                                              BUG14992
                                                                                            BUG14992
     C                   EXSR      RESETERRS                                                BUG14992
                                                                                            BUG14992
      ** Validate Issuer Code                                                               BUG14992
                                                                                            BUG14992
     C                   CALLB     'SDVISCP01'                                              BUG14992
                                                                                            BUG14992
      ** Inputs                                                                             BUG14992
      ** Return Code                                                                        BUG14992
     C                   PARM                    RetCodeIn                                  BUG14992
                                                                                            BUG14992
      ** Other parms                                                                        BUG14992
      ** Identification Type                                                                BUG14992
     C                   PARM                    DDIDTP                                     BUG14992
      ** Issuer Code                                                                        BUG14992
     C     ADISCD        PARM                    DDISCD                                     BUG14992
                                                                                            BUG14992
      ** Outputs                                                                            BUG14992
      ** Error fields/message IDs/message data (arrays) from/to caller                      BUG14992
     C                   PARM                    FldNamXAr                                  BUG14992
     C                   PARM                    MsgIDXAr                                   BUG14992
     C                   PARM                    MsgDtaXAr                                  BUG14992
                                                                                            BUG14992
      ** Issuer Code - OK                                                                   BUG14992
     C                   PARM                    DDISCDOK                                   BUG14992
                                                                                            BUG14992
      ** Update error info with that returned from the validation module                    BUG14992
                                                                                            BUG14992
     C                   EXSR      UPDATERRS                                                BUG14992
                                                                                            BUG14992
     C                   ENDSR                                                              BUG14992
                                                                                              CGL157
      *****************************************************************                       CGL157
     C/EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      ** SrMail - Validate Mailing Country                            *                       CGL157
      *****************************************************************                       CGL157
     C     SrMail        BEGSR                                                                CGL157
                                                                                              CGL157
      ** Reset variables updated by each module                                               CGL157
                                                                                              CGL157
     C                   EXSR      RESETERRS                                                  CGL157
                                                                                              CGL157
     C                   CALLB     'SDVCTRYD'                                                 CGL157
                                                                                              CGL157
      ** Inputs                                                                               CGL157
      ** Return Code                                                                          CGL157
     C                   PARM                    RetCodeIn                                    CGL157
                                                                                              CGL157
      ** Other parms                                                                          CGL157
      ** Mailing Countries                                                                    CGL157
     C     ADCTR1        PARM                    DDCTR1                                       CGL157
     C     ADCTR2        PARM                    DDCTR2                                       CGL157
     C     ADCTR3        PARM                    DDCTR3                                       CGL157
     C     ADCTR4        PARM                    DDCTR4                                       CGL157
     C     ADCTR5        PARM                    DDCTR5                                       CGL157
                                                                                              CGL157
      ** Outputs                                                                              CGL157
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL157
     C                   PARM                    FldNamXAr                                    CGL157
     C                   PARM                    MsgIDXAr                                     CGL157
     C                   PARM                    MsgDtaXAr                                    CGL157
                                                                                              CGL157
      ** Mailing Country Codes - OK                                                           CGL157
     C                   PARM                    DDOKCTR1                                     CGL157
     C                   PARM                    DDOKCTR2                                     CGL157
     C                   PARM                    DDOKCTR3                                     CGL157
     C                   PARM                    DDOKCTR4                                     CGL157
     C                   PARM                    DDOKCTR5                                     CGL157
                                                                                              CGL157
      * Update error info with that returned from the validation module                       CGL157
                                                                                              CGL157
     C                   EXSR      UPDATERRS                                                  CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
      *****************************************************************                       CGL157
     C/EJECT                                                                                  CGL157
      *****************************************************************                       CGL157
      ** SrPhone - Validate Phone Country                             *                       CGL157
      *****************************************************************                       CGL157
     C     SrPhone       BEGSR                                                                CGL157
                                                                                              CGL157
      ** Reset variables updated by each module                                               CGL157
                                                                                              CGL157
     C                   EXSR      RESETERRS                                                  CGL157
                                                                                              CGL157
     C                   CALLB     'SDVCTRYD'                                                 CGL157
                                                                                              CGL157
      ** Inputs                                                                               CGL157
      ** Return Code                                                                          CGL157
     C                   PARM                    RetCodeIn                                    CGL157
                                                                                              CGL157
      ** Other parms                                                                          CGL157
      ** Phone Countries                                                                      CGL157
     C     ADPHN1        PARM                    DDPHN1                                       CGL157
     C     ADPHN2        PARM                    DDPHN2                                       CGL157
     C     ADPHN3        PARM                    DDPHN3                                       CGL157
     C     ADPHN4        PARM                    DDPHN4                                       CGL157
     C     ADPHN5        PARM                    DDPHN5                                       CGL157
                                                                                              CGL157
      ** Outputs                                                                              CGL157
      ** Error fields/message IDs/message data (arrays) from/to caller                        CGL157
     C                   PARM                    FldNamXAr                                    CGL157
     C                   PARM                    MsgIDXAr                                     CGL157
     C                   PARM                    MsgDtaXAr                                    CGL157
                                                                                              CGL157
      ** Phone Country Codes - OK                                                             CGL157
     C                   PARM                    DDOKCTR1                                     CGL157
     C                   PARM                    DDOKCTR2                                     CGL157
     C                   PARM                    DDOKCTR3                                     CGL157
     C                   PARM                    DDOKCTR4                                     CGL157
     C                   PARM                    DDOKCTR5                                     CGL157
                                                                                              CGL157
     C                   EVAL      W = 1                                                      CGL157
                                                                                              CGL157
     C                   DOW       FldNamXAr(W) <> *Blanks                                    CGL157
     C                   IF        FldNamXAr(W) = 'DDCTR1'                                    CGL157
     C                   EVAL      FldNamXAr(W) = 'DDPHN1'                                    CGL157
     C                   ENDIF                                                                CGL157
     C                   IF        FldNamXAr(W) = 'DDCTR2'                                    CGL157
     C                   EVAL      FldNamXAr(W) = 'DDPHN2'                                    CGL157
     C                   ENDIF                                                                CGL157
     C                   IF        FldNamXAr(W) = 'DDCTR3'                                    CGL157
     C                   EVAL      FldNamXAr(W) = 'DDPHN3'                                    CGL157
     C                   ENDIF                                                                CGL157
     C                   IF        FldNamXAr(W) = 'DDCTR4'                                    CGL157
     C                   EVAL      FldNamXAr(W) = 'DDPHN4'                                    CGL157
     C                   ENDIF                                                                CGL157
     C                   IF        FldNamXAr(W) = 'DDCTR5'                                    CGL157
     C                   EVAL      FldNamXAr(W) = 'DDPHN5'                                    CGL157
     C                   ENDIF                                                                CGL157
     C                   EVAL      W = W + 1                                                  CGL157
     C                   ENDDO                                                                CGL157
                                                                                              CGL157
      * Update error info with that returned from the validation module                       CGL157
                                                                                              CGL157
     C                   EXSR      UPDATERRS                                                  CGL157
                                                                                              CGL157
     C                   ENDSR                                                                CGL157
      *****************************************************************
     C/EJECT
      *****************************************************************                       CLE134
      ** Validate Basel II Past Due Customer                                                  CLE134
      *****************************************************************                       CLE134
     C     SRVPDCU       BEGSR                                                                CLE134
                                                                                              CLE134
      ** Reset variables updated by each module                                               CLE134
                                                                                              CLE134
     C                   EXSR      RESETERRS                                                  CLE134
                                                                                              CLE134
      ** Validate Basel II Past Due Customer                                                  CLE134
                                                                                              CLE134
     C                   CALLB     'SDVPDCU'                                                  CLE134
                                                                                              CLE134
      ** INPUTS                                                                               CLE134
                                                                                              CLE134
      ** Return Code                                                                          CLE134
                                                                                              CLE134
     C                   PARM                    RetCodeOut                                   CLE134
                                                                                              CLE134
      ** Basel II Past Due Customer (1A)                                                      CLE134
                                                                                              CLE134
     C     ADPDCU        PARM                    DDPDCU                                       CLE134
                                                                                              CLE134
      ** OUTPUTS                                                                              CLE134
                                                                                              CLE134
      ** Error fields/message IDs/message data (arrays) from/to caller                        CLE134
                                                                                              CLE134
     C                   PARM                    FldNamXAr                                    CLE134
     C                   PARM                    MsgIDXAr                                     CLE134
     C                   PARM                    MsgDtaXAr                                    CLE134
                                                                                              CLE134
      ** Basel II Past Due Customer - OK                                                      CLE134
                                                                                              CLE134
     C                   PARM                    DDPDCUOK                                     CLE134
                                                                                              CLE134
      * Update error info with that returned from the validation module                       CLE134
                                                                                              CLE134
     C                   EXSR      UPDATERRS                                                  CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
      *****************************************************************                       CLE134
     C/EJECT                                                                                  CLE134
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module                                *
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
      *    from each validation module                                *
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
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Response mode
 
     C                   PARM                    RespMode
 
      ** Additional Details
 
     C                   PARM                    TrnDets
 
      ** Customer Number
 
     C                   PARM                    DDCUSN
                                                                                            AR739736
      ** Customer Number                                                                    AR739736
                                                                                            AR739736
     C                   PARM                    DDBNBI                                     AR739736
 
      ** Outputs
      ** Additional Details OK inds
 
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
 
      ** Valid Additional Details layout (DS) from/to caller
 
     C                   PARM                    ValidCUAD
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EVAL      DBKEY  = @OPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
                                                                                            BUG14992
      ** Check if Private Banking is switched on:                                           BUG14992
                                                                                            BUG14992
     C                   CALL      'AOMMODR0'                                               BUG14992
     C                   PARM      '*DBERR'      @RTCD                                      BUG14992
     C                   PARM      '*FIRST '     @OPTN                                      BUG14992
     C     SDMMOD        PARM      SDMMOD        DSFDY                                      BUG14992
                                                                                            BUG14992
     C                   IF        @RTCD <> *BLANKS                                         BUG14992
     C     *LOCK         IN        LDA                                                      BUG14992
     C                   EVAL      DBFILE = 'SDMMODPD'                                      BUG14992
     C                   EVAL      DBASE = 902                                              BUG14992
     C                   EVAL      DBKEY  = @OPTN                                           BUG14992
     C                   OUT       LDA                                                      BUG14992
     C                   EXSR      *PSSR                                                    BUG14992
     C                   ENDIF                                                              BUG14992
 
      ** Check if switchable feature CGL032 is switched on
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL032'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database Error
 
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = 'CGL032'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 902
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        @RTCD = *BLANK
     C                   MOVE      'Y'           CGL032
     C                   ELSE
     C                   MOVE      'N'           CGL032
     C                   ENDIF
                                                                                              CLE134
      ** Check if switchable feature CLE134 is switched on                                    CLE134
                                                                                              CLE134
     C                   CALL      'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*VERIFY'     @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD                                        CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
                                                                                              CLE134
      ** Database Error                                                                       CLE134
                                                                                              CLE134
     C                   IF        @RTCD <> *BLANKS AND                                       CLE134
     C                             @RTCD <> '*NRF   '                                         CLE134
     C                   EVAL      DBKEY  = 'CLE134'                                          CLE134
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE134
     C                   EVAL      DBASE  = 905                                               CLE134
     C                   EXSR      *PSSR                                                      CLE134
     C                   ENDIF                                                                CLE134
     C                   IF        @RTCD = *BLANK                                             CLE134
     C                   MOVE      'Y'           CLE134                                       CLE134
     C                   ELSE                                                                 CLE134
     C                   MOVE      'N'           CLE134                                       CLE134
     C                   ENDIF                                                                CLE134
 
      ** Check if SWIFT 2007 is installed                                                   BUG14992
                                                                                            BUG14992
     C                   CALL      'SWIF2007'                                               BUG14992
     C                   PARM      *BLANKS       @RTCD                                      BUG14992
                                                                                            BUG14992
     C                   IF        @RTCD = 'CSW2007'                                        BUG14992
     C                   EVAL      CSW207 = 'Y'                                             BUG14992
     C                   ELSE                                                               BUG14992
     C                   EVAL      CSW207 = 'N'                                             BUG14992
     C                   ENDIF                                                              BUG14992
                                                                                            BUG14992
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUADV035
 
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
