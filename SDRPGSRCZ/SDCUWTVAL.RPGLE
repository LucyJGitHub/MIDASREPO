     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Withholding Tax Details Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUWTVAL - Customer Withholding Tax Details Validation      *
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
      /COPY WNCPYSRC,SDCUWTV001
 
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
     D TrnDets       E DS                  EXTNAME(SDCUWTPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDECUWTPD)
 
      ** Valid Transaction Details layout
     D ValidCUWT     E DS                  EXTNAME(SDVCUWTPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
      **
     D CRTT_Arr        S              2A   DIM(30)
      ** Country of Tax treaty - array
 
     D INTS_Arr        S              3A   DIM(30)
      ** Intermediary Status - array
 
     D DCRC_Arr        S              1A   DIM(30)
      ** Documentation received - array
 
     D DCEX_Arr        S              6A   DIM(30)
      ** Documentation Expiry Date - array
 
     D EXCD_Arr        S              2A   DIM(30)
      ** Exemption code - array
 
     D BCWA_Arr        S              1A   DIM(30)
      ** Backup WHT applicable Y/N - array
 
     D RPCD_Arr        S              2A   DIM(30)
      ** Recipient code - array
 
     D TXBS_Arr        S              2A   DIM(30)
      ** Tax Basket - array
 
     D RFSI_Arr        S              1A   DIM(30)
      ** Report foreign src income Y/N - array
 
     D DBTT_Arr        S              1A   DIM(30)
      ** Double tax treaty Y/N - array
 
     D TIN_Arr         S             20A   DIM(30)
      ** Tax Identification Number - array
 
     D VCRTTSET        S              2A   DIM(30)
      ** Country of Tax treaty Set - array
 
     D DCEX_AN         S              5P 0 DIM(30)
      ** Documentation Expiry Date - array (Numeric)
 
     D CRTTOK_A        S              1A   DIM(30)
      ** Country of Tax treaty OK - array
 
     D INTSOK_A        S              1A   DIM(30)
      ** Intermediary Status OK - array
 
     D DCRCOK_A        S              1A   DIM(30)
      ** Documentation received OK - array
 
     D DCEXOK_A        S              1A   DIM(30)
      ** Documentation Expiry Date OK - array
 
     D EXCDOK_A        S              1A   DIM(30)
      ** Exemption code OK - array
 
     D BCWAOK_A        S              1A   DIM(30)
      ** Backup WHT applicable Y/N OK - array
 
     D RPCDOK_A        S              1A   DIM(30)
      ** Recipient code OK - array
 
     D TXBSOK_A        S              1A   DIM(30)
      ** Tax Basket OK - array
 
     D RFSIOK_A        S              1A   DIM(30)
      ** Report foreign src income Y/N OK - array
 
     D DBTTOK_A        S              1A   DIM(30)
      ** Double tax treaty Y/N OK - array
 
     D TINOK_A         S              1A   DIM(30)
      ** Tax Identification Number OK - array
 
      **
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
 
      ** Counter Variable for the arrays
     D Ctr             S              3P 0
 
      ** Index Variable for the arrays
     D Index           S              3P 0
 
      ** String to check incoming data
     D ChkString       S             38A
 
     D I               S              3P 0
     D RespMode        S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D S01496          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUWTV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initializing all Field and Field OK arrays
 
     C                   EXSR      INZALLARR
 
      ** Populate all the field arrays
 
     C                   EXSR      POPFLDARR
 
      /COPY WNCPYSRC,SDCUWTV003
 
      ** Validation of the fields
 
     C                   EVAL      Ctr = 1
     C                   EVAL      Index = 0
     C                   EVAL      ChkString =  CRTT_Arr(Ctr)
     C                                        + INTS_Arr(Ctr)
     C                                        + DCRC_Arr(Ctr)
     C                                        + DCEX_Arr(Ctr)
     C                                        + EXCD_Arr(Ctr)
     C                                        + BCWA_Arr(Ctr)
     C                                        + RPCD_Arr(Ctr)
     C                                        + TXBS_Arr(Ctr)
     C                                        + RFSI_Arr(Ctr)
     C                                        + DBTT_Arr(Ctr)
     C                                        + TIN_Arr(Ctr)
 
     C                   DOW       ChkString <>*BLANKS AND
     C                             Ctr <= 30
 
      ** Validate Country of tax treaty
 
      /COPY WNCPYSRC,SDCUWTV004
     C                   EXSR      VCRTTSR
      /COPY WNCPYSRC,SDCUWTV005
 
      ** Validate Intermediary Status
 
      /COPY WNCPYSRC,SDCUWTV006
     C                   EXSR      VINTSSR
      /COPY WNCPYSRC,SDCUWTV007
 
      ** Validate Documentation Received
 
      /COPY WNCPYSRC,SDCUWTV008
     C                   EXSR      VDCRCSR
      /COPY WNCPYSRC,SDCUWTV009
 
      ** Validate Documentation Expiry Date
 
      /COPY WNCPYSRC,SDCUWTV010
     C                   EXSR      VDCEXSR
      /COPY WNCPYSRC,SDCUWTV011
 
      ** Validate Exemption Code
 
      /COPY WNCPYSRC,SDCUWTV012
     C                   EXSR      VEXCDSR
      /COPY WNCPYSRC,SDCUWTV013
 
      ** Validate Back WHT Applicable
 
      /COPY WNCPYSRC,SDCUWTV014
     C                   EXSR      VBCWASR
      /COPY WNCPYSRC,SDCUWTV015
 
      ** Validate Recipient Code
 
      /COPY WNCPYSRC,SDCUWTV016
     C                   EXSR      VRPCDSR
      /COPY WNCPYSRC,SDCUWTV017
 
      ** Validate Tax Basket
 
      /COPY WNCPYSRC,SDCUWTV018
     C                   EXSR      VTXBSSR
      /COPY WNCPYSRC,SDCUWTV019
 
      ** Validate Report Foreign Source Income
 
      /COPY WNCPYSRC,SDCUWTV020
     C                   EXSR      VRFSISR
      /COPY WNCPYSRC,SDCUWTV021
 
      ** Validate Double Tax Treaty
 
      /COPY WNCPYSRC,SDCUWTV022
     C                   EXSR      VDBTTSR
      /COPY WNCPYSRC,SDCUWTV023
 
     C                   EVAL      Ctr = Ctr + 1
     C                   EVAL      ChkString = CRTT_Arr(Ctr)
     C                                        + INTS_Arr(Ctr)
     C                                        + DCRC_Arr(Ctr)
     C                                        + DCEX_Arr(Ctr)
     C                                        + EXCD_Arr(Ctr)
     C                                        + BCWA_Arr(Ctr)
     C                                        + RPCD_Arr(Ctr)
     C                                        + TXBS_Arr(Ctr)
     C                                        + RFSI_Arr(Ctr)
     C                                        + DBTT_Arr(Ctr)
     C                                        + TIN_Arr(Ctr)
     C                   IF        Ctr > 30
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDDO
 
      ** Populate OK Fields
 
     C                   EXSR      POPFLDOKARR
 
      ** Populate valid file format DCEX field
 
     C                   EXSR      POPDCEX
 
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUWTV024
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VCRTTSR - Validate Country of Tax Treaty                     *
      *                                                               *
      *****************************************************************
      *
     C     VCRTTSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Intermediary Status
 
     C                   CALLB     'SDVCRTT'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Country of Tax Treaty
 
     C                   PARM                    CRTT_Arr(Ctr)
 
      ** Country of Tax Treaty set Array
 
     C                   PARM                    VCRTTSET
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Country of Tax Treaty - OK
 
     C                   PARM                    CRTTOK_A(Ctr)
 
      ** Next available position for VCRTTSET Array
 
     C                   PARM                    Index
 
      ** Counter
 
     C                   PARM                    Ctr
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VINTSSR - Validate Intermediary Status                       *
      *                                                               *
      *****************************************************************
 
     C     VINTSSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Intermediary Status
 
     C                   CALLB     'SDVINTS'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Intermediary Status
 
     C                   PARM                    INTS_Arr(Ctr)
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Intermediary Status - OK
 
     C                   PARM                    INTSOK_A(Ctr)
 
      ** Counter
 
     C                   PARM                    Ctr
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VDCRCSR - Validate Documentation Received                    *
      *                                                               *
      *****************************************************************
 
     C     VDCRCSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Documentation Received
 
     C                   CALLB     'SDVDCRC'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Documentation Received
 
     C                   PARM                    DCRC_Arr(Ctr)
 
      ** Country of Tax Treaty
 
     C                   PARM                    CRTT_Arr(Ctr)
 
      ** Intermediary Status
 
     C                   PARM                    INTS_Arr(Ctr)
 
      ** Customer Number
 
     C                   PARM                    DDCSNO
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Documentation Received - OK
 
     C                   PARM                    DCRCOK_A(Ctr)
 
      ** Counter
 
     C                   PARM                    Ctr
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VDCEXSR - Validate Documentation Expiry Date                 *
      *                                                               *
      *****************************************************************
 
     C     VDCEXSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Documentation Expiry Date
 
     C                   CALLB     'SDVDCEX'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Documentation Expiry Date
 
     C                   PARM                    DCEX_Arr(Ctr)
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Documentation Expiry Date - OK
 
     C                   PARM      *BLANKS       DCEXOK_A(Ctr)
 
      ** Return value for Expiry Date
 
     C                   PARM      *ZEROS        DCEX_AN(Ctr)
 
      ** Counter
 
     C                   PARM                    Ctr
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VEXCDSR - Validate Exemption Code                            *
      *                                                               *
      *****************************************************************
     C     VEXCDSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Exemption Code
 
     C                   CALLB     'SDVEXCD'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Exemption Code
 
     C                   PARM                    EXCD_Arr(Ctr)
 
      ** Document Received
 
     C                   PARM                    DCRC_Arr(Ctr)
 
      ** Country of Tax Treaty
 
     C                   PARM                    CRTT_Arr(Ctr)
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Exemption Code - OK
 
     C                   PARM                    EXCDOK_A(Ctr)
 
      ** Counter
 
     C                   PARM                    Ctr
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VBCWASR - Validate Backup WHT Applicable                     *
      *                                                               *
      *****************************************************************
 
     C     VBCWASR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Backup WHT Applicable
 
     C                   CALLB     'SDVBCWA'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Backup WHT Applicable
 
     C                   PARM                    BCWA_Arr(Ctr)
 
      ** Document Received
 
     C                   PARM                    DCRC_Arr(Ctr)
 
      ** Intermediary Status
 
     C                   PARM                    INTS_Arr(Ctr)
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Backup WHT Applicable - OK
 
     C                   PARM                    BCWAOK_A(Ctr)
 
      ** Counter
 
     C                   PARM                    Ctr
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VRPCDSR - Validate Recipient Code                            *
      *                                                               *
      *****************************************************************
      *
     C     VRPCDSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Recipient Code
 
     C                   CALLB     'SDVRPCD'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Recipient Code
 
     C                   PARM                    RPCD_Arr(Ctr)
 
      ** Country of Tax Treaty
 
     C                   PARM                    CRTT_Arr(Ctr)
 
      ** Customer Number
 
     C                   PARM                    DDCSNO
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Recipient Code - OK
 
     C                   PARM                    RPCDOK_A(Ctr)
 
      ** Counter
 
     C                   PARM                    Ctr
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VTXBSSR - Validate Tax Basket                                *
      *                                                               *
      *****************************************************************
     C     VTXBSSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Tax Basket
 
     C                   CALLB     'SDVTXBS'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Tax Basket
 
     C                   PARM                    TXBS_Arr(Ctr)
 
      ** Double Tax Treaty
 
     C                   PARM                    DBTT_Arr(Ctr)
 
      ** Document Received
 
     C                   PARM                    DCRC_Arr(Ctr)
 
      ** Country of Tax Treaty
 
     C                   PARM                    CRTT_Arr(Ctr)
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Tax Basket - OK
 
     C                   PARM                    TXBSOK_A(Ctr)
 
      ** Counter
 
     C                   PARM                    Ctr
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VRFSISR - Validate Foreign Source Income                     *
      *                                                               *
      *****************************************************************
 
     C     VRFSISR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Foreign Source Income
 
     C                   CALLB     'SDVRFSI'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Foreign Source Income
 
     C                   PARM                    RFSI_Arr(Ctr)
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Foreign Source Income - OK
 
     C                   PARM                    RFSIOK_A(Ctr)
 
      ** Counter
 
     C                   PARM                    Ctr
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VDBTTSR - Validate Double Tax Treaty                         *
      *                                                               *
      *****************************************************************
 
     C     VDBTTSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Double Tax Treaty
 
     C                   CALLB     'SDVDBTT'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Double Tax Treaty
 
     C                   PARM                    DBTT_Arr(Ctr)
 
      ** Documentation Received
 
     C                   PARM                    DCRC_Arr(Ctr)
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Double Tax Treaty - OK
 
     C                   PARM                    DBTTOK_A(Ctr)
 
      ** Counter
 
     C                   PARM                    Ctr
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INZALLARR - Subroutine for Initialising all Field            *
      *     and Field OK arrays                                       *
      *                                                               *
      *****************************************************************
     C     INZALLARR     BEGSR
 
     C                   CLEAR                   CRTT_Arr
     C                   CLEAR                   INTS_Arr
     C                   CLEAR                   DCRC_Arr
     C                   CLEAR                   DCEX_Arr
     C                   CLEAR                   EXCD_Arr
     C                   CLEAR                   BCWA_Arr
     C                   CLEAR                   RPCD_Arr
     C                   CLEAR                   TXBS_Arr
     C                   CLEAR                   RFSI_Arr
     C                   CLEAR                   DBTT_Arr
     C                   CLEAR                   TIN_Arr
     C                   CLEAR                   DCEX_AN
 
     C                   CLEAR                   VCRTTSET
 
     C                   MOVE      *ALL'Y'       CRTTOK_A
     C                   MOVE      *ALL'Y'       INTSOK_A
     C                   MOVE      *ALL'Y'       DCRCOK_A
     C                   MOVE      *ALL'Y'       DCEXOK_A
     C                   MOVE      *ALL'Y'       EXCDOK_A
     C                   MOVE      *ALL'Y'       BCWAOK_A
     C                   MOVE      *ALL'Y'       RPCDOK_A
     C                   MOVE      *ALL'Y'       TXBSOK_A
     C                   MOVE      *ALL'Y'       RFSIOK_A
     C                   MOVE      *ALL'Y'       DBTTOK_A
     C                   MOVE      *ALL'Y'       TINOK_A
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  POPFLDARR - Subroutine for populating all Field arrays       *
      *                                                               *
      *****************************************************************
      *
     C     POPFLDARR     BEGSR
 
     C                   EVAL      CRTT_Arr(1)  = DDCRTT1
     C                   EVAL      INTS_Arr(1)  = DDINTS1
     C                   EVAL      DCRC_Arr(1)  = DDDCRC1
     C                   EVAL      DCEX_Arr(1)  = DDDCEX1
     C                   EVAL      EXCD_Arr(1)  = DDEXCD1
     C                   EVAL      BCWA_Arr(1)  = DDBCWA1
     C                   EVAL      RPCD_Arr(1)  = DDRPCD1
     C                   EVAL      TXBS_Arr(1)  = DDTXBS1
     C                   EVAL      RFSI_Arr(1)  = DDRFSI1
     C                   EVAL      DBTT_Arr(1)  = DDDBTT1
     C                   EVAL      TIN_Arr(1)   = DDTIN1
 
     C                   EVAL      CRTT_Arr(2)  = DDCRTT2
     C                   EVAL      INTS_Arr(2)  = DDINTS2
     C                   EVAL      DCRC_Arr(2)  = DDDCRC2
     C                   EVAL      DCEX_Arr(2)  = DDDCEX2
     C                   EVAL      EXCD_Arr(2)  = DDEXCD2
     C                   EVAL      BCWA_Arr(2)  = DDBCWA2
     C                   EVAL      RPCD_Arr(2)  = DDRPCD2
     C                   EVAL      TXBS_Arr(2)  = DDTXBS2
     C                   EVAL      RFSI_Arr(2)  = DDRFSI2
     C                   EVAL      DBTT_Arr(2)  = DDDBTT2
     C                   EVAL      TIN_Arr(2)   = DDTIN2
 
     C                   EVAL      CRTT_Arr(3)  = DDCRTT3
     C                   EVAL      INTS_Arr(3)  = DDINTS3
     C                   EVAL      DCRC_Arr(3)  = DDDCRC3
     C                   EVAL      DCEX_Arr(3)  = DDDCEX3
     C                   EVAL      EXCD_Arr(3)  = DDEXCD3
     C                   EVAL      BCWA_Arr(3)  = DDBCWA3
     C                   EVAL      RPCD_Arr(3)  = DDRPCD3
     C                   EVAL      TXBS_Arr(3)  = DDTXBS3
     C                   EVAL      RFSI_Arr(3)  = DDRFSI3
     C                   EVAL      DBTT_Arr(3)  = DDDBTT3
     C                   EVAL      TIN_Arr(3)   = DDTIN3
 
     C                   EVAL      CRTT_Arr(4)  = DDCRTT4
     C                   EVAL      INTS_Arr(4)  = DDINTS4
     C                   EVAL      DCRC_Arr(4)  = DDDCRC4
     C                   EVAL      DCEX_Arr(4)  = DDDCEX4
     C                   EVAL      EXCD_Arr(4)  = DDEXCD4
     C                   EVAL      BCWA_Arr(4)  = DDBCWA4
     C                   EVAL      RPCD_Arr(4)  = DDRPCD4
     C                   EVAL      TXBS_Arr(4)  = DDTXBS4
     C                   EVAL      RFSI_Arr(4)  = DDRFSI4
     C                   EVAL      DBTT_Arr(4)  = DDDBTT4
     C                   EVAL      TIN_Arr(4)   = DDTIN4
 
     C                   EVAL      CRTT_Arr(5)  = DDCRTT5
     C                   EVAL      INTS_Arr(5)  = DDINTS5
     C                   EVAL      DCRC_Arr(5)  = DDDCRC5
     C                   EVAL      DCEX_Arr(5)  = DDDCEX5
     C                   EVAL      EXCD_Arr(5)  = DDEXCD5
     C                   EVAL      BCWA_Arr(5)  = DDBCWA5
     C                   EVAL      RPCD_Arr(5)  = DDRPCD5
     C                   EVAL      TXBS_Arr(5)  = DDTXBS5
     C                   EVAL      RFSI_Arr(5)  = DDRFSI5
     C                   EVAL      DBTT_Arr(5)  = DDDBTT5
     C                   EVAL      TIN_Arr(5)   = DDTIN5
 
     C                   EVAL      CRTT_Arr(6)  = DDCRTT6
     C                   EVAL      INTS_Arr(6)  = DDINTS6
     C                   EVAL      DCRC_Arr(6)  = DDDCRC6
     C                   EVAL      DCEX_Arr(6)  = DDDCEX6
     C                   EVAL      EXCD_Arr(6)  = DDEXCD6
     C                   EVAL      BCWA_Arr(6)  = DDBCWA6
     C                   EVAL      RPCD_Arr(6)  = DDRPCD6
     C                   EVAL      TXBS_Arr(6)  = DDTXBS6
     C                   EVAL      RFSI_Arr(6)  = DDRFSI6
     C                   EVAL      DBTT_Arr(6)  = DDDBTT6
     C                   EVAL      TIN_Arr(6)   = DDTIN6
 
     C                   EVAL      CRTT_Arr(7)  = DDCRTT7
     C                   EVAL      INTS_Arr(7)  = DDINTS7
     C                   EVAL      DCRC_Arr(7)  = DDDCRC7
     C                   EVAL      DCEX_Arr(7)  = DDDCEX7
     C                   EVAL      EXCD_Arr(7)  = DDEXCD7
     C                   EVAL      BCWA_Arr(7)  = DDBCWA7
     C                   EVAL      RPCD_Arr(7)  = DDRPCD7
     C                   EVAL      TXBS_Arr(7)  = DDTXBS7
     C                   EVAL      RFSI_Arr(7)  = DDRFSI7
     C                   EVAL      DBTT_Arr(7)  = DDDBTT7
     C                   EVAL      TIN_Arr(7)   = DDTIN7
 
     C                   EVAL      CRTT_Arr(8)  = DDCRTT8
     C                   EVAL      INTS_Arr(8)  = DDINTS8
     C                   EVAL      DCRC_Arr(8)  = DDDCRC8
     C                   EVAL      DCEX_Arr(8)  = DDDCEX8
     C                   EVAL      EXCD_Arr(8)  = DDEXCD8
     C                   EVAL      BCWA_Arr(8)  = DDBCWA8
     C                   EVAL      RPCD_Arr(8)  = DDRPCD8
     C                   EVAL      TXBS_Arr(8)  = DDTXBS8
     C                   EVAL      RFSI_Arr(8)  = DDRFSI8
     C                   EVAL      DBTT_Arr(8)  = DDDBTT8
     C                   EVAL      TIN_Arr(8)   = DDTIN8
 
     C                   EVAL      CRTT_Arr(9)  = DDCRTT9
     C                   EVAL      INTS_Arr(9)  = DDINTS9
     C                   EVAL      DCRC_Arr(9)  = DDDCRC9
     C                   EVAL      DCEX_Arr(9)  = DDDCEX9
     C                   EVAL      EXCD_Arr(9)  = DDEXCD9
     C                   EVAL      BCWA_Arr(9)  = DDBCWA9
     C                   EVAL      RPCD_Arr(9)  = DDRPCD9
     C                   EVAL      TXBS_Arr(9)  = DDTXBS9
     C                   EVAL      RFSI_Arr(9)  = DDRFSI9
     C                   EVAL      DBTT_Arr(9)  = DDDBTT9
     C                   EVAL      TIN_Arr(9)   = DDTIN9
 
     C                   EVAL      CRTT_Arr(10)  = DDCRTT10
     C                   EVAL      INTS_Arr(10)  = DDINTS10
     C                   EVAL      DCRC_Arr(10)  = DDDCRC10
     C                   EVAL      DCEX_Arr(10)  = DDDCEX10
     C                   EVAL      EXCD_Arr(10)  = DDEXCD10
     C                   EVAL      BCWA_Arr(10)  = DDBCWA10
     C                   EVAL      RPCD_Arr(10)  = DDRPCD10
     C                   EVAL      TXBS_Arr(10)  = DDTXBS10
     C                   EVAL      RFSI_Arr(10)  = DDRFSI10
     C                   EVAL      DBTT_Arr(10)  = DDDBTT10
     C                   EVAL      TIN_Arr(10)   = DDTIN10
 
     C                   EVAL      CRTT_Arr(11)  = DDCRTT11
     C                   EVAL      INTS_Arr(11)  = DDINTS11
     C                   EVAL      DCRC_Arr(11)  = DDDCRC11
     C                   EVAL      DCEX_Arr(11)  = DDDCEX11
     C                   EVAL      EXCD_Arr(11)  = DDEXCD11
     C                   EVAL      BCWA_Arr(11)  = DDBCWA11
     C                   EVAL      RPCD_Arr(11)  = DDRPCD11
     C                   EVAL      TXBS_Arr(11)  = DDTXBS11
     C                   EVAL      RFSI_Arr(11)  = DDRFSI11
     C                   EVAL      DBTT_Arr(11)  = DDDBTT11
     C                   EVAL      TIN_Arr(11)   = DDTIN11
 
     C                   EVAL      CRTT_Arr(12)  = DDCRTT12
     C                   EVAL      INTS_Arr(12)  = DDINTS12
     C                   EVAL      DCRC_Arr(12)  = DDDCRC12
     C                   EVAL      DCEX_Arr(12)  = DDDCEX12
     C                   EVAL      EXCD_Arr(12)  = DDEXCD12
     C                   EVAL      BCWA_Arr(12)  = DDBCWA12
     C                   EVAL      RPCD_Arr(12)  = DDRPCD12
     C                   EVAL      TXBS_Arr(12)  = DDTXBS12
     C                   EVAL      RFSI_Arr(12)  = DDRFSI12
     C                   EVAL      DBTT_Arr(12)  = DDDBTT12
     C                   EVAL      TIN_Arr(12)   = DDTIN12
 
     C                   EVAL      CRTT_Arr(13)  = DDCRTT13
     C                   EVAL      INTS_Arr(13)  = DDINTS13
     C                   EVAL      DCRC_Arr(13)  = DDDCRC13
     C                   EVAL      DCEX_Arr(13)  = DDDCEX13
     C                   EVAL      EXCD_Arr(13)  = DDEXCD13
     C                   EVAL      BCWA_Arr(13)  = DDBCWA13
     C                   EVAL      RPCD_Arr(13)  = DDRPCD13
     C                   EVAL      TXBS_Arr(13)  = DDTXBS13
     C                   EVAL      RFSI_Arr(13)  = DDRFSI13
     C                   EVAL      DBTT_Arr(13)  = DDDBTT13
     C                   EVAL      TIN_Arr(13)   = DDTIN13
 
     C                   EVAL      CRTT_Arr(14)  = DDCRTT14
     C                   EVAL      INTS_Arr(14)  = DDINTS14
     C                   EVAL      DCRC_Arr(14)  = DDDCRC14
     C                   EVAL      DCEX_Arr(14)  = DDDCEX14
     C                   EVAL      EXCD_Arr(14)  = DDEXCD14
     C                   EVAL      BCWA_Arr(14)  = DDBCWA14
     C                   EVAL      RPCD_Arr(14)  = DDRPCD14
     C                   EVAL      TXBS_Arr(14)  = DDTXBS14
     C                   EVAL      RFSI_Arr(14)  = DDRFSI14
     C                   EVAL      DBTT_Arr(14)  = DDDBTT14
     C                   EVAL      TIN_Arr(14)   = DDTIN14
 
     C                   EVAL      CRTT_Arr(15)  = DDCRTT15
     C                   EVAL      INTS_Arr(15)  = DDINTS15
     C                   EVAL      DCRC_Arr(15)  = DDDCRC15
     C                   EVAL      DCEX_Arr(15)  = DDDCEX15
     C                   EVAL      EXCD_Arr(15)  = DDEXCD15
     C                   EVAL      BCWA_Arr(15)  = DDBCWA15
     C                   EVAL      RPCD_Arr(15)  = DDRPCD15
     C                   EVAL      TXBS_Arr(15)  = DDTXBS15
     C                   EVAL      RFSI_Arr(15)  = DDRFSI15
     C                   EVAL      DBTT_Arr(15)  = DDDBTT15
     C                   EVAL      TIN_Arr(15)   = DDTIN15
 
     C                   EVAL      CRTT_Arr(16)  = DDCRTT16
     C                   EVAL      INTS_Arr(16)  = DDINTS16
     C                   EVAL      DCRC_Arr(16)  = DDDCRC16
     C                   EVAL      DCEX_Arr(16)  = DDDCEX16
     C                   EVAL      EXCD_Arr(16)  = DDEXCD16
     C                   EVAL      BCWA_Arr(16)  = DDBCWA16
     C                   EVAL      RPCD_Arr(16)  = DDRPCD16
     C                   EVAL      TXBS_Arr(16)  = DDTXBS16
     C                   EVAL      RFSI_Arr(16)  = DDRFSI16
     C                   EVAL      DBTT_Arr(16)  = DDDBTT16
     C                   EVAL      TIN_Arr(16)   = DDTIN16
 
     C                   EVAL      CRTT_Arr(17)  = DDCRTT17
     C                   EVAL      INTS_Arr(17)  = DDINTS17
     C                   EVAL      DCRC_Arr(17)  = DDDCRC17
     C                   EVAL      DCEX_Arr(17)  = DDDCEX17
     C                   EVAL      EXCD_Arr(17)  = DDEXCD17
     C                   EVAL      BCWA_Arr(17)  = DDBCWA17
     C                   EVAL      RPCD_Arr(17)  = DDRPCD17
     C                   EVAL      TXBS_Arr(17)  = DDTXBS17
     C                   EVAL      RFSI_Arr(17)  = DDRFSI17
     C                   EVAL      DBTT_Arr(17)  = DDDBTT17
     C                   EVAL      TIN_Arr(17)   = DDTIN17
 
     C                   EVAL      CRTT_Arr(18)  = DDCRTT18
     C                   EVAL      INTS_Arr(18)  = DDINTS18
     C                   EVAL      DCRC_Arr(18)  = DDDCRC18
     C                   EVAL      DCEX_Arr(18)  = DDDCEX18
     C                   EVAL      EXCD_Arr(18)  = DDEXCD18
     C                   EVAL      BCWA_Arr(18)  = DDBCWA18
     C                   EVAL      RPCD_Arr(18)  = DDRPCD18
     C                   EVAL      TXBS_Arr(18)  = DDTXBS18
     C                   EVAL      RFSI_Arr(18)  = DDRFSI18
     C                   EVAL      DBTT_Arr(18)  = DDDBTT18
     C                   EVAL      TIN_Arr(18)   = DDTIN18
 
     C                   EVAL      CRTT_Arr(19)  = DDCRTT19
     C                   EVAL      INTS_Arr(19)  = DDINTS19
     C                   EVAL      DCRC_Arr(19)  = DDDCRC19
     C                   EVAL      DCEX_Arr(19)  = DDDCEX19
     C                   EVAL      EXCD_Arr(19)  = DDEXCD19
     C                   EVAL      BCWA_Arr(19)  = DDBCWA19
     C                   EVAL      RPCD_Arr(19)  = DDRPCD19
     C                   EVAL      TXBS_Arr(19)  = DDTXBS19
     C                   EVAL      RFSI_Arr(19)  = DDRFSI19
     C                   EVAL      DBTT_Arr(19)  = DDDBTT19
     C                   EVAL      TIN_Arr(19)   = DDTIN19
 
     C                   EVAL      CRTT_Arr(20)  = DDCRTT20
     C                   EVAL      INTS_Arr(20)  = DDINTS20
     C                   EVAL      DCRC_Arr(20)  = DDDCRC20
     C                   EVAL      DCEX_Arr(20)  = DDDCEX20
     C                   EVAL      EXCD_Arr(20)  = DDEXCD20
     C                   EVAL      BCWA_Arr(20)  = DDBCWA20
     C                   EVAL      RPCD_Arr(20)  = DDRPCD20
     C                   EVAL      TXBS_Arr(20)  = DDTXBS20
     C                   EVAL      RFSI_Arr(20)  = DDRFSI20
     C                   EVAL      DBTT_Arr(20)  = DDDBTT20
     C                   EVAL      TIN_Arr(20)   = DDTIN20
 
     C                   EVAL      CRTT_Arr(21)  = DDCRTT21
     C                   EVAL      INTS_Arr(21)  = DDINTS21
     C                   EVAL      DCRC_Arr(21)  = DDDCRC21
     C                   EVAL      DCEX_Arr(21)  = DDDCEX21
     C                   EVAL      EXCD_Arr(21)  = DDEXCD21
     C                   EVAL      BCWA_Arr(21)  = DDBCWA21
     C                   EVAL      RPCD_Arr(21)  = DDRPCD21
     C                   EVAL      TXBS_Arr(21)  = DDTXBS21
     C                   EVAL      RFSI_Arr(21)  = DDRFSI21
     C                   EVAL      DBTT_Arr(21)  = DDDBTT21
     C                   EVAL      TIN_Arr(21)   = DDTIN21
 
     C                   EVAL      CRTT_Arr(22)  = DDCRTT22
     C                   EVAL      INTS_Arr(22)  = DDINTS22
     C                   EVAL      DCRC_Arr(22)  = DDDCRC22
     C                   EVAL      DCEX_Arr(22)  = DDDCEX22
     C                   EVAL      EXCD_Arr(22)  = DDEXCD22
     C                   EVAL      BCWA_Arr(22)  = DDBCWA22
     C                   EVAL      RPCD_Arr(22)  = DDRPCD22
     C                   EVAL      TXBS_Arr(22)  = DDTXBS22
     C                   EVAL      RFSI_Arr(22)  = DDRFSI22
     C                   EVAL      DBTT_Arr(22)  = DDDBTT22
     C                   EVAL      TIN_Arr(22)   = DDTIN22
 
     C                   EVAL      CRTT_Arr(23)  = DDCRTT23
     C                   EVAL      INTS_Arr(23)  = DDINTS23
     C                   EVAL      DCRC_Arr(23)  = DDDCRC23
     C                   EVAL      DCEX_Arr(23)  = DDDCEX23
     C                   EVAL      EXCD_Arr(23)  = DDEXCD23
     C                   EVAL      BCWA_Arr(23)  = DDBCWA23
     C                   EVAL      RPCD_Arr(23)  = DDRPCD23
     C                   EVAL      TXBS_Arr(23)  = DDTXBS23
     C                   EVAL      RFSI_Arr(23)  = DDRFSI23
     C                   EVAL      DBTT_Arr(23)  = DDDBTT23
     C                   EVAL      TIN_Arr(23)   = DDTIN23
 
     C                   EVAL      CRTT_Arr(24)  = DDCRTT24
     C                   EVAL      INTS_Arr(24)  = DDINTS24
     C                   EVAL      DCRC_Arr(24)  = DDDCRC24
     C                   EVAL      DCEX_Arr(24)  = DDDCEX24
     C                   EVAL      EXCD_Arr(24)  = DDEXCD24
     C                   EVAL      BCWA_Arr(24)  = DDBCWA24
     C                   EVAL      RPCD_Arr(24)  = DDRPCD24
     C                   EVAL      TXBS_Arr(24)  = DDTXBS24
     C                   EVAL      RFSI_Arr(24)  = DDRFSI24
     C                   EVAL      DBTT_Arr(24)  = DDDBTT24
     C                   EVAL      TIN_Arr(24)   = DDTIN24
 
     C                   EVAL      CRTT_Arr(25)  = DDCRTT25
     C                   EVAL      INTS_Arr(25)  = DDINTS25
     C                   EVAL      DCRC_Arr(25)  = DDDCRC25
     C                   EVAL      DCEX_Arr(25)  = DDDCEX25
     C                   EVAL      EXCD_Arr(25)  = DDEXCD25
     C                   EVAL      BCWA_Arr(25)  = DDBCWA25
     C                   EVAL      RPCD_Arr(25)  = DDRPCD25
     C                   EVAL      TXBS_Arr(25)  = DDTXBS25
     C                   EVAL      RFSI_Arr(25)  = DDRFSI25
     C                   EVAL      DBTT_Arr(25)  = DDDBTT25
     C                   EVAL      TIN_Arr(25)   = DDTIN25
 
     C                   EVAL      CRTT_Arr(26)  = DDCRTT26
     C                   EVAL      INTS_Arr(26)  = DDINTS26
     C                   EVAL      DCRC_Arr(26)  = DDDCRC26
     C                   EVAL      DCEX_Arr(26)  = DDDCEX26
     C                   EVAL      EXCD_Arr(26)  = DDEXCD26
     C                   EVAL      BCWA_Arr(26)  = DDBCWA26
     C                   EVAL      RPCD_Arr(26)  = DDRPCD26
     C                   EVAL      TXBS_Arr(26)  = DDTXBS26
     C                   EVAL      RFSI_Arr(26)  = DDRFSI26
     C                   EVAL      DBTT_Arr(26)  = DDDBTT26
     C                   EVAL      TIN_Arr(26)   = DDTIN26
 
     C                   EVAL      CRTT_Arr(27)  = DDCRTT27
     C                   EVAL      INTS_Arr(27)  = DDINTS27
     C                   EVAL      DCRC_Arr(27)  = DDDCRC27
     C                   EVAL      DCEX_Arr(27)  = DDDCEX27
     C                   EVAL      EXCD_Arr(27)  = DDEXCD27
     C                   EVAL      BCWA_Arr(27)  = DDBCWA27
     C                   EVAL      RPCD_Arr(27)  = DDRPCD27
     C                   EVAL      TXBS_Arr(27)  = DDTXBS27
     C                   EVAL      RFSI_Arr(27)  = DDRFSI27
     C                   EVAL      DBTT_Arr(27)  = DDDBTT27
     C                   EVAL      TIN_Arr(27)   = DDTIN27
 
     C                   EVAL      CRTT_Arr(28)  = DDCRTT28
     C                   EVAL      INTS_Arr(28)  = DDINTS28
     C                   EVAL      DCRC_Arr(28)  = DDDCRC28
     C                   EVAL      DCEX_Arr(28)  = DDDCEX28
     C                   EVAL      EXCD_Arr(28)  = DDEXCD28
     C                   EVAL      BCWA_Arr(28)  = DDBCWA28
     C                   EVAL      RPCD_Arr(28)  = DDRPCD28
     C                   EVAL      TXBS_Arr(28)  = DDTXBS28
     C                   EVAL      RFSI_Arr(28)  = DDRFSI28
     C                   EVAL      DBTT_Arr(28)  = DDDBTT28
     C                   EVAL      TIN_Arr(28)   = DDTIN28
 
     C                   EVAL      CRTT_Arr(29)  = DDCRTT29
     C                   EVAL      INTS_Arr(29)  = DDINTS29
     C                   EVAL      DCRC_Arr(29)  = DDDCRC29
     C                   EVAL      DCEX_Arr(29)  = DDDCEX29
     C                   EVAL      EXCD_Arr(29)  = DDEXCD29
     C                   EVAL      BCWA_Arr(29)  = DDBCWA29
     C                   EVAL      RPCD_Arr(29)  = DDRPCD29
     C                   EVAL      TXBS_Arr(29)  = DDTXBS29
     C                   EVAL      RFSI_Arr(29)  = DDRFSI29
     C                   EVAL      DBTT_Arr(29)  = DDDBTT29
     C                   EVAL      TIN_Arr(29)   = DDTIN29
 
     C                   EVAL      CRTT_Arr(30)  = DDCRTT30
     C                   EVAL      INTS_Arr(30)  = DDINTS30
     C                   EVAL      DCRC_Arr(30)  = DDDCRC30
     C                   EVAL      DCEX_Arr(30)  = DDDCEX30
     C                   EVAL      EXCD_Arr(30)  = DDEXCD30
     C                   EVAL      BCWA_Arr(30)  = DDBCWA30
     C                   EVAL      RPCD_Arr(30)  = DDRPCD30
     C                   EVAL      TXBS_Arr(30)  = DDTXBS30
     C                   EVAL      RFSI_Arr(30)  = DDRFSI30
     C                   EVAL      DBTT_Arr(30)  = DDDBTT30
     C                   EVAL      TIN_Arr(30)   = DDTIN30
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  POPFLDOKARR - Subroutine for populating all Field arrays     *
      *                                                               *
      *****************************************************************
      *
     C     POPFLDOKARR   BEGSR
 
     C                   EVAL      DDCRTT1OK = CRTTOK_A(1)
     C                   EVAL      DDINTS1OK = INTSOK_A(1)
     C                   EVAL      DDDCRC1OK = DCRCOK_A(1)
     C                   EVAL      DDDCEX1OK = DCEXOK_A(1)
     C                   EVAL      DDEXCD1OK = EXCDOK_A(1)
     C                   EVAL      DDBCWA1OK = BCWAOK_A(1)
     C                   EVAL      DDRPCD1OK = RPCDOK_A(1)
     C                   EVAL      DDTXBS1OK = TXBSOK_A(1)
     C                   EVAL      DDRFSI1OK = RFSIOK_A(1)
     C                   EVAL      DDDBTT1OK = DBTTOK_A(1)
     C                   EVAL      DDTIN1OK  = TINOK_A(1)
 
     C                   EVAL      DDCRTT2OK = CRTTOK_A(2)
     C                   EVAL      DDINTS2OK = INTSOK_A(2)
     C                   EVAL      DDDCRC2OK = DCRCOK_A(2)
     C                   EVAL      DDDCEX2OK = DCEXOK_A(2)
     C                   EVAL      DDEXCD2OK = EXCDOK_A(2)
     C                   EVAL      DDBCWA2OK = BCWAOK_A(2)
     C                   EVAL      DDRPCD2OK = RPCDOK_A(2)
     C                   EVAL      DDTXBS2OK = TXBSOK_A(2)
     C                   EVAL      DDRFSI2OK = RFSIOK_A(2)
     C                   EVAL      DDDBTT2OK = DBTTOK_A(2)
     C                   EVAL      DDTIN2OK  = TINOK_A(2)
 
     C                   EVAL      DDCRTT3OK = CRTTOK_A(3)
     C                   EVAL      DDINTS3OK = INTSOK_A(3)
     C                   EVAL      DDDCRC3OK = DCRCOK_A(3)
     C                   EVAL      DDDCEX3OK = DCEXOK_A(3)
     C                   EVAL      DDEXCD3OK = EXCDOK_A(3)
     C                   EVAL      DDBCWA3OK = BCWAOK_A(3)
     C                   EVAL      DDRPCD3OK = RPCDOK_A(3)
     C                   EVAL      DDTXBS3OK = TXBSOK_A(3)
     C                   EVAL      DDRFSI3OK = RFSIOK_A(3)
     C                   EVAL      DDDBTT3OK = DBTTOK_A(3)
     C                   EVAL      DDTIN3OK  = TINOK_A(3)
 
     C                   EVAL      DDCRTT4OK = CRTTOK_A(4)
     C                   EVAL      DDINTS4OK = INTSOK_A(4)
     C                   EVAL      DDDCRC4OK = DCRCOK_A(4)
     C                   EVAL      DDDCEX4OK = DCEXOK_A(4)
     C                   EVAL      DDEXCD4OK = EXCDOK_A(4)
     C                   EVAL      DDBCWA4OK = BCWAOK_A(4)
     C                   EVAL      DDRPCD4OK = RPCDOK_A(4)
     C                   EVAL      DDTXBS4OK = TXBSOK_A(4)
     C                   EVAL      DDRFSI4OK = RFSIOK_A(4)
     C                   EVAL      DDDBTT4OK = DBTTOK_A(4)
     C                   EVAL      DDTIN4OK  = TINOK_A(4)
 
     C                   EVAL      DDCRTT5OK = CRTTOK_A(5)
     C                   EVAL      DDINTS5OK = INTSOK_A(5)
     C                   EVAL      DDDCRC5OK = DCRCOK_A(5)
     C                   EVAL      DDDCEX5OK = DCEXOK_A(5)
     C                   EVAL      DDEXCD5OK = EXCDOK_A(5)
     C                   EVAL      DDBCWA5OK = BCWAOK_A(5)
     C                   EVAL      DDRPCD5OK = RPCDOK_A(5)
     C                   EVAL      DDTXBS5OK = TXBSOK_A(5)
     C                   EVAL      DDRFSI5OK = RFSIOK_A(5)
     C                   EVAL      DDDBTT5OK = DBTTOK_A(5)
     C                   EVAL      DDTIN5OK  = TINOK_A(5)
 
     C                   EVAL      DDCRTT6OK = CRTTOK_A(6)
     C                   EVAL      DDINTS6OK = INTSOK_A(6)
     C                   EVAL      DDDCRC6OK = DCRCOK_A(6)
     C                   EVAL      DDDCEX6OK = DCEXOK_A(6)
     C                   EVAL      DDEXCD6OK = EXCDOK_A(6)
     C                   EVAL      DDBCWA6OK = BCWAOK_A(6)
     C                   EVAL      DDRPCD6OK = RPCDOK_A(6)
     C                   EVAL      DDTXBS6OK = TXBSOK_A(6)
     C                   EVAL      DDRFSI6OK = RFSIOK_A(6)
     C                   EVAL      DDDBTT6OK = DBTTOK_A(6)
     C                   EVAL      DDTIN6OK  = TINOK_A(6)
 
     C                   EVAL      DDCRTT7OK = CRTTOK_A(7)
     C                   EVAL      DDINTS7OK = INTSOK_A(7)
     C                   EVAL      DDDCRC7OK = DCRCOK_A(7)
     C                   EVAL      DDDCEX7OK = DCEXOK_A(7)
     C                   EVAL      DDEXCD7OK = EXCDOK_A(7)
     C                   EVAL      DDBCWA7OK = BCWAOK_A(7)
     C                   EVAL      DDRPCD7OK = RPCDOK_A(7)
     C                   EVAL      DDTXBS7OK = TXBSOK_A(7)
     C                   EVAL      DDRFSI7OK = RFSIOK_A(7)
     C                   EVAL      DDDBTT7OK = DBTTOK_A(7)
     C                   EVAL      DDTIN7OK  = TINOK_A(7)
 
     C                   EVAL      DDCRTT8OK = CRTTOK_A(8)
     C                   EVAL      DDINTS8OK = INTSOK_A(8)
     C                   EVAL      DDDCRC8OK = DCRCOK_A(8)
     C                   EVAL      DDDCEX8OK = DCEXOK_A(8)
     C                   EVAL      DDEXCD8OK = EXCDOK_A(8)
     C                   EVAL      DDBCWA8OK = BCWAOK_A(8)
     C                   EVAL      DDRPCD8OK = RPCDOK_A(8)
     C                   EVAL      DDTXBS8OK = TXBSOK_A(8)
     C                   EVAL      DDRFSI8OK = RFSIOK_A(8)
     C                   EVAL      DDDBTT8OK = DBTTOK_A(8)
     C                   EVAL      DDTIN8OK  = TINOK_A(8)
 
     C                   EVAL      DDCRTT9OK = CRTTOK_A(9)
     C                   EVAL      DDINTS9OK = INTSOK_A(9)
     C                   EVAL      DDDCRC9OK = DCRCOK_A(9)
     C                   EVAL      DDDCEX9OK = DCEXOK_A(9)
     C                   EVAL      DDEXCD9OK = EXCDOK_A(9)
     C                   EVAL      DDBCWA9OK = BCWAOK_A(9)
     C                   EVAL      DDRPCD9OK = RPCDOK_A(9)
     C                   EVAL      DDTXBS9OK = TXBSOK_A(9)
     C                   EVAL      DDRFSI9OK = RFSIOK_A(9)
     C                   EVAL      DDDBTT9OK = DBTTOK_A(9)
     C                   EVAL      DDTIN9OK  = TINOK_A(9)
 
     C                   EVAL      DDCRTT10OK = CRTTOK_A(10)
     C                   EVAL      DDINTS10OK = INTSOK_A(10)
     C                   EVAL      DDDCRC10OK = DCRCOK_A(10)
     C                   EVAL      DDDCEX10OK = DCEXOK_A(10)
     C                   EVAL      DDEXCD10OK = EXCDOK_A(10)
     C                   EVAL      DDBCWA10OK = BCWAOK_A(10)
     C                   EVAL      DDRPCD10OK = RPCDOK_A(10)
     C                   EVAL      DDTXBS10OK = TXBSOK_A(10)
     C                   EVAL      DDRFSI10OK = RFSIOK_A(10)
     C                   EVAL      DDDBTT10OK = DBTTOK_A(10)
     C                   EVAL      DDTIN10OK  = TINOK_A(10)
 
     C                   EVAL      DDCRTT11OK = CRTTOK_A(11)
     C                   EVAL      DDINTS11OK = INTSOK_A(11)
     C                   EVAL      DDDCRC11OK = DCRCOK_A(11)
     C                   EVAL      DDDCEX11OK = DCEXOK_A(11)
     C                   EVAL      DDEXCD11OK = EXCDOK_A(11)
     C                   EVAL      DDBCWA11OK = BCWAOK_A(11)
     C                   EVAL      DDRPCD11OK = RPCDOK_A(11)
     C                   EVAL      DDTXBS11OK = TXBSOK_A(11)
     C                   EVAL      DDRFSI11OK = RFSIOK_A(11)
     C                   EVAL      DDDBTT11OK = DBTTOK_A(11)
     C                   EVAL      DDTIN11OK  = TINOK_A(11)
 
     C                   EVAL      DDCRTT12OK = CRTTOK_A(12)
     C                   EVAL      DDINTS12OK = INTSOK_A(12)
     C                   EVAL      DDDCRC12OK = DCRCOK_A(12)
     C                   EVAL      DDDCEX12OK = DCEXOK_A(12)
     C                   EVAL      DDEXCD12OK = EXCDOK_A(12)
     C                   EVAL      DDBCWA12OK = BCWAOK_A(12)
     C                   EVAL      DDRPCD12OK = RPCDOK_A(12)
     C                   EVAL      DDTXBS12OK = TXBSOK_A(12)
     C                   EVAL      DDRFSI12OK = RFSIOK_A(12)
     C                   EVAL      DDDBTT12OK = DBTTOK_A(12)
     C                   EVAL      DDTIN12OK  = TINOK_A(12)
 
     C                   EVAL      DDCRTT13OK = CRTTOK_A(13)
     C                   EVAL      DDINTS13OK = INTSOK_A(13)
     C                   EVAL      DDDCRC13OK = DCRCOK_A(13)
     C                   EVAL      DDDCEX13OK = DCEXOK_A(13)
     C                   EVAL      DDEXCD13OK = EXCDOK_A(13)
     C                   EVAL      DDBCWA13OK = BCWAOK_A(13)
     C                   EVAL      DDRPCD13OK = RPCDOK_A(13)
     C                   EVAL      DDTXBS13OK = TXBSOK_A(13)
     C                   EVAL      DDRFSI13OK = RFSIOK_A(13)
     C                   EVAL      DDDBTT13OK = DBTTOK_A(13)
     C                   EVAL      DDTIN13OK  = TINOK_A(13)
 
     C                   EVAL      DDCRTT14OK = CRTTOK_A(14)
     C                   EVAL      DDINTS14OK = INTSOK_A(14)
     C                   EVAL      DDDCRC14OK = DCRCOK_A(14)
     C                   EVAL      DDDCEX14OK = DCEXOK_A(14)
     C                   EVAL      DDEXCD14OK = EXCDOK_A(14)
     C                   EVAL      DDBCWA14OK = BCWAOK_A(14)
     C                   EVAL      DDRPCD14OK = RPCDOK_A(14)
     C                   EVAL      DDTXBS14OK = TXBSOK_A(14)
     C                   EVAL      DDRFSI14OK = RFSIOK_A(14)
     C                   EVAL      DDDBTT14OK = DBTTOK_A(14)
     C                   EVAL      DDTIN14OK  = TINOK_A(14)
 
     C                   EVAL      DDCRTT15OK = CRTTOK_A(15)
     C                   EVAL      DDINTS15OK = INTSOK_A(15)
     C                   EVAL      DDDCRC15OK = DCRCOK_A(15)
     C                   EVAL      DDDCEX15OK = DCEXOK_A(15)
     C                   EVAL      DDEXCD15OK = EXCDOK_A(15)
     C                   EVAL      DDBCWA15OK = BCWAOK_A(15)
     C                   EVAL      DDRPCD15OK = RPCDOK_A(15)
     C                   EVAL      DDTXBS15OK = TXBSOK_A(15)
     C                   EVAL      DDRFSI15OK = RFSIOK_A(15)
     C                   EVAL      DDDBTT15OK = DBTTOK_A(15)
     C                   EVAL      DDTIN15OK  = TINOK_A(15)
 
     C                   EVAL      DDCRTT16OK = CRTTOK_A(16)
     C                   EVAL      DDINTS16OK = INTSOK_A(16)
     C                   EVAL      DDDCRC16OK = DCRCOK_A(16)
     C                   EVAL      DDDCEX16OK = DCEXOK_A(16)
     C                   EVAL      DDEXCD16OK = EXCDOK_A(16)
     C                   EVAL      DDBCWA16OK = BCWAOK_A(16)
     C                   EVAL      DDRPCD16OK = RPCDOK_A(16)
     C                   EVAL      DDTXBS16OK = TXBSOK_A(16)
     C                   EVAL      DDRFSI16OK = RFSIOK_A(16)
     C                   EVAL      DDDBTT16OK = DBTTOK_A(16)
     C                   EVAL      DDTIN16OK  = TINOK_A(16)
 
     C                   EVAL      DDCRTT17OK = CRTTOK_A(17)
     C                   EVAL      DDINTS17OK = INTSOK_A(17)
     C                   EVAL      DDDCRC17OK = DCRCOK_A(17)
     C                   EVAL      DDDCEX17OK = DCEXOK_A(17)
     C                   EVAL      DDEXCD17OK = EXCDOK_A(17)
     C                   EVAL      DDBCWA17OK = BCWAOK_A(17)
     C                   EVAL      DDRPCD17OK = RPCDOK_A(17)
     C                   EVAL      DDTXBS17OK = TXBSOK_A(17)
     C                   EVAL      DDRFSI17OK = RFSIOK_A(17)
     C                   EVAL      DDDBTT17OK = DBTTOK_A(17)
     C                   EVAL      DDTIN17OK  = TINOK_A(17)
 
     C                   EVAL      DDCRTT18OK = CRTTOK_A(18)
     C                   EVAL      DDINTS18OK = INTSOK_A(18)
     C                   EVAL      DDDCRC18OK = DCRCOK_A(18)
     C                   EVAL      DDDCEX18OK = DCEXOK_A(18)
     C                   EVAL      DDEXCD18OK = EXCDOK_A(18)
     C                   EVAL      DDBCWA18OK = BCWAOK_A(18)
     C                   EVAL      DDRPCD18OK = RPCDOK_A(18)
     C                   EVAL      DDTXBS18OK = TXBSOK_A(18)
     C                   EVAL      DDRFSI18OK = RFSIOK_A(18)
     C                   EVAL      DDDBTT18OK = DBTTOK_A(18)
     C                   EVAL      DDTIN18OK  = TINOK_A(18)
 
     C                   EVAL      DDCRTT19OK = CRTTOK_A(19)
     C                   EVAL      DDINTS19OK = INTSOK_A(19)
     C                   EVAL      DDDCRC19OK = DCRCOK_A(19)
     C                   EVAL      DDDCEX19OK = DCEXOK_A(19)
     C                   EVAL      DDEXCD19OK = EXCDOK_A(19)
     C                   EVAL      DDBCWA19OK = BCWAOK_A(19)
     C                   EVAL      DDRPCD19OK = RPCDOK_A(19)
     C                   EVAL      DDTXBS19OK = TXBSOK_A(19)
     C                   EVAL      DDRFSI19OK = RFSIOK_A(19)
     C                   EVAL      DDDBTT19OK = DBTTOK_A(19)
     C                   EVAL      DDTIN19OK  = TINOK_A(19)
 
     C                   EVAL      DDCRTT20OK = CRTTOK_A(20)
     C                   EVAL      DDINTS20OK = INTSOK_A(20)
     C                   EVAL      DDDCRC20OK = DCRCOK_A(20)
     C                   EVAL      DDDCEX20OK = DCEXOK_A(20)
     C                   EVAL      DDEXCD20OK = EXCDOK_A(20)
     C                   EVAL      DDBCWA20OK = BCWAOK_A(20)
     C                   EVAL      DDRPCD20OK = RPCDOK_A(20)
     C                   EVAL      DDTXBS20OK = TXBSOK_A(20)
     C                   EVAL      DDRFSI20OK = RFSIOK_A(20)
     C                   EVAL      DDDBTT20OK = DBTTOK_A(20)
     C                   EVAL      DDTIN20OK  = TINOK_A(20)
 
     C                   EVAL      DDCRTT21OK = CRTTOK_A(21)
     C                   EVAL      DDINTS21OK = INTSOK_A(21)
     C                   EVAL      DDDCRC21OK = DCRCOK_A(21)
     C                   EVAL      DDDCEX21OK = DCEXOK_A(21)
     C                   EVAL      DDEXCD21OK = EXCDOK_A(21)
     C                   EVAL      DDBCWA21OK = BCWAOK_A(21)
     C                   EVAL      DDRPCD21OK = RPCDOK_A(21)
     C                   EVAL      DDTXBS21OK = TXBSOK_A(21)
     C                   EVAL      DDRFSI21OK = RFSIOK_A(21)
     C                   EVAL      DDDBTT21OK = DBTTOK_A(21)
     C                   EVAL      DDTIN21OK  = TINOK_A(21)
 
     C                   EVAL      DDCRTT22OK = CRTTOK_A(22)
     C                   EVAL      DDINTS22OK = INTSOK_A(22)
     C                   EVAL      DDDCRC22OK = DCRCOK_A(22)
     C                   EVAL      DDDCEX22OK = DCEXOK_A(22)
     C                   EVAL      DDEXCD22OK = EXCDOK_A(22)
     C                   EVAL      DDBCWA22OK = BCWAOK_A(22)
     C                   EVAL      DDRPCD22OK = RPCDOK_A(22)
     C                   EVAL      DDTXBS22OK = TXBSOK_A(22)
     C                   EVAL      DDRFSI22OK = RFSIOK_A(22)
     C                   EVAL      DDDBTT22OK = DBTTOK_A(22)
     C                   EVAL      DDTIN22OK  = TINOK_A(22)
 
     C                   EVAL      DDCRTT23OK = CRTTOK_A(23)
     C                   EVAL      DDINTS23OK = INTSOK_A(23)
     C                   EVAL      DDDCRC23OK = DCRCOK_A(23)
     C                   EVAL      DDDCEX23OK = DCEXOK_A(23)
     C                   EVAL      DDEXCD23OK = EXCDOK_A(23)
     C                   EVAL      DDBCWA23OK = BCWAOK_A(23)
     C                   EVAL      DDRPCD23OK = RPCDOK_A(23)
     C                   EVAL      DDTXBS23OK = TXBSOK_A(23)
     C                   EVAL      DDRFSI23OK = RFSIOK_A(23)
     C                   EVAL      DDDBTT23OK = DBTTOK_A(23)
     C                   EVAL      DDTIN23OK  = TINOK_A(23)
 
     C                   EVAL      DDCRTT24OK = CRTTOK_A(24)
     C                   EVAL      DDINTS24OK = INTSOK_A(24)
     C                   EVAL      DDDCRC24OK = DCRCOK_A(24)
     C                   EVAL      DDDCEX24OK = DCEXOK_A(24)
     C                   EVAL      DDEXCD24OK = EXCDOK_A(24)
     C                   EVAL      DDBCWA24OK = BCWAOK_A(24)
     C                   EVAL      DDRPCD24OK = RPCDOK_A(24)
     C                   EVAL      DDTXBS24OK = TXBSOK_A(24)
     C                   EVAL      DDRFSI24OK = RFSIOK_A(24)
     C                   EVAL      DDDBTT24OK = DBTTOK_A(24)
     C                   EVAL      DDTIN24OK  = TINOK_A(24)
 
     C                   EVAL      DDCRTT25OK = CRTTOK_A(25)
     C                   EVAL      DDINTS25OK = INTSOK_A(25)
     C                   EVAL      DDDCRC25OK = DCRCOK_A(25)
     C                   EVAL      DDDCEX25OK = DCEXOK_A(25)
     C                   EVAL      DDEXCD25OK = EXCDOK_A(25)
     C                   EVAL      DDBCWA25OK = BCWAOK_A(25)
     C                   EVAL      DDRPCD25OK = RPCDOK_A(25)
     C                   EVAL      DDTXBS25OK = TXBSOK_A(25)
     C                   EVAL      DDRFSI25OK = RFSIOK_A(25)
     C                   EVAL      DDDBTT25OK = DBTTOK_A(25)
     C                   EVAL      DDTIN25OK  = TINOK_A(25)
 
     C                   EVAL      DDCRTT26OK = CRTTOK_A(26)
     C                   EVAL      DDINTS26OK = INTSOK_A(26)
     C                   EVAL      DDDCRC26OK = DCRCOK_A(26)
     C                   EVAL      DDDCEX26OK = DCEXOK_A(26)
     C                   EVAL      DDEXCD26OK = EXCDOK_A(26)
     C                   EVAL      DDBCWA26OK = BCWAOK_A(26)
     C                   EVAL      DDRPCD26OK = RPCDOK_A(26)
     C                   EVAL      DDTXBS26OK = TXBSOK_A(26)
     C                   EVAL      DDRFSI26OK = RFSIOK_A(26)
     C                   EVAL      DDDBTT26OK = DBTTOK_A(26)
     C                   EVAL      DDTIN26OK  = TINOK_A(26)
 
     C                   EVAL      DDCRTT27OK = CRTTOK_A(27)
     C                   EVAL      DDINTS27OK = INTSOK_A(27)
     C                   EVAL      DDDCRC27OK = DCRCOK_A(27)
     C                   EVAL      DDDCEX27OK = DCEXOK_A(27)
     C                   EVAL      DDEXCD27OK = EXCDOK_A(27)
     C                   EVAL      DDBCWA27OK = BCWAOK_A(27)
     C                   EVAL      DDRPCD27OK = RPCDOK_A(27)
     C                   EVAL      DDTXBS27OK = TXBSOK_A(27)
     C                   EVAL      DDRFSI27OK = RFSIOK_A(27)
     C                   EVAL      DDDBTT27OK = DBTTOK_A(27)
     C                   EVAL      DDTIN27OK  = TINOK_A(27)
 
     C                   EVAL      DDCRTT28OK = CRTTOK_A(28)
     C                   EVAL      DDINTS28OK = INTSOK_A(28)
     C                   EVAL      DDDCRC28OK = DCRCOK_A(28)
     C                   EVAL      DDDCEX28OK = DCEXOK_A(28)
     C                   EVAL      DDEXCD28OK = EXCDOK_A(28)
     C                   EVAL      DDBCWA28OK = BCWAOK_A(28)
     C                   EVAL      DDRPCD28OK = RPCDOK_A(28)
     C                   EVAL      DDTXBS28OK = TXBSOK_A(28)
     C                   EVAL      DDRFSI28OK = RFSIOK_A(28)
     C                   EVAL      DDDBTT28OK = DBTTOK_A(28)
     C                   EVAL      DDTIN28OK  = TINOK_A(28)
 
     C                   EVAL      DDCRTT29OK = CRTTOK_A(29)
     C                   EVAL      DDINTS29OK = INTSOK_A(29)
     C                   EVAL      DDDCRC29OK = DCRCOK_A(29)
     C                   EVAL      DDDCEX29OK = DCEXOK_A(29)
     C                   EVAL      DDEXCD29OK = EXCDOK_A(29)
     C                   EVAL      DDBCWA29OK = BCWAOK_A(29)
     C                   EVAL      DDRPCD29OK = RPCDOK_A(29)
     C                   EVAL      DDTXBS29OK = TXBSOK_A(29)
     C                   EVAL      DDRFSI29OK = RFSIOK_A(29)
     C                   EVAL      DDDBTT29OK = DBTTOK_A(29)
     C                   EVAL      DDTIN29OK  = TINOK_A(29)
 
     C                   EVAL      DDCRTT30OK = CRTTOK_A(30)
     C                   EVAL      DDINTS30OK = INTSOK_A(30)
     C                   EVAL      DDDCRC30OK = DCRCOK_A(30)
     C                   EVAL      DDDCEX30OK = DCEXOK_A(30)
     C                   EVAL      DDEXCD30OK = EXCDOK_A(30)
     C                   EVAL      DDBCWA30OK = BCWAOK_A(30)
     C                   EVAL      DDRPCD30OK = RPCDOK_A(30)
     C                   EVAL      DDTXBS30OK = TXBSOK_A(30)
     C                   EVAL      DDRFSI30OK = RFSIOK_A(30)
     C                   EVAL      DDDBTT30OK = DBTTOK_A(30)
     C                   EVAL      DDTIN30OK  = TINOK_A(30)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  POPDCEX - Subroutine for populating Document Expiry date     *
      *              field of valid file format                       *
      *                                                               *
      *****************************************************************
     C     POPDCEX       BEGSR
 
     C                   EVAL      WTDCEX1  = DCEX_AN(1)
     C                   EVAL      WTDCEX2  = DCEX_AN(2)
     C                   EVAL      WTDCEX3  = DCEX_AN(3)
     C                   EVAL      WTDCEX4  = DCEX_AN(4)
     C                   EVAL      WTDCEX5  = DCEX_AN(5)
     C                   EVAL      WTDCEX6  = DCEX_AN(6)
     C                   EVAL      WTDCEX7  = DCEX_AN(7)
     C                   EVAL      WTDCEX8  = DCEX_AN(8)
     C                   EVAL      WTDCEX9  = DCEX_AN(9)
     C                   EVAL      WTDCEX10 = DCEX_AN(10)
     C                   EVAL      WTDCEX11 = DCEX_AN(11)
     C                   EVAL      WTDCEX12 = DCEX_AN(12)
     C                   EVAL      WTDCEX13 = DCEX_AN(13)
     C                   EVAL      WTDCEX14 = DCEX_AN(14)
     C                   EVAL      WTDCEX15 = DCEX_AN(15)
     C                   EVAL      WTDCEX16 = DCEX_AN(16)
     C                   EVAL      WTDCEX17 = DCEX_AN(17)
     C                   EVAL      WTDCEX18 = DCEX_AN(18)
     C                   EVAL      WTDCEX19 = DCEX_AN(19)
     C                   EVAL      WTDCEX20 = DCEX_AN(20)
     C                   EVAL      WTDCEX21 = DCEX_AN(21)
     C                   EVAL      WTDCEX22 = DCEX_AN(22)
     C                   EVAL      WTDCEX23 = DCEX_AN(23)
     C                   EVAL      WTDCEX24 = DCEX_AN(24)
     C                   EVAL      WTDCEX25 = DCEX_AN(25)
     C                   EVAL      WTDCEX26 = DCEX_AN(26)
     C                   EVAL      WTDCEX27 = DCEX_AN(27)
     C                   EVAL      WTDCEX28 = DCEX_AN(28)
     C                   EVAL      WTDCEX29 = DCEX_AN(29)
     C                   EVAL      WTDCEX30 = DCEX_AN(30)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RESETERRS - Reset error information that is received back    *
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
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Response mode
 
     C                   PARM                    RespMode
 
      ** Customer Withholding Tax Details
 
     C                   PARM                    TrnDets
 
      ** Outputs
      ** Customer Withholding Tax Details OK inds
 
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
 
      ** Valid Customer Withholding Tax details layout(DS)
      ** from/to caller
 
     C                   PARM                    ValidCUWT
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
 
      ** Check if switchable feature S01496 is switched on.
      ** Private Banking Securities Trading Enhancement
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01496'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY  = 'S01496'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  =  902
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        PRTCD = *BLANK
     C                   MOVE      'Y'           S01496
     C                   ELSE
     C                   MOVE      'N'           S01496
     C                   ENDIF
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUWTV025
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2007
