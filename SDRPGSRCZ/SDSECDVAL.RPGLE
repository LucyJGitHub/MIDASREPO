     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Securities clients details validation')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSECDVAL - Security Customers Details Validation            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD021141           Date 05Jul13               *
      *  Prev Amend No. AR1081265          Date 24Jan13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG21078           Date 17Sep08               *
      *                 243070             Date 10Jul06               *
      *                 BUG12946           Date 20Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG7883            Date 16Aug05               *
      *                 CSE070             Date 15Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 CSE039             Date 05Feb03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP039             Date 24Sep99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021141 - Staturory Returns Code field missing during       *
      *             Amend or Enquire                                  *
      *  AR1081265 - Second Screen in Securities Trading Customer     *
      *              Details Maintenance is missing                   *
      *  BUG21078 - Apply fix BUG14245                                *
      *  BUG14245 - Frequency Statement Validation should be done     *
      *             when clicking complete/confirm (Recompile)        *
      *  243070 - Recompile over changed PF/SDVSECDPD                 *
      *  BUG12946 - Pass the customer number to SDVCCLAS module       *
      *             for additional checking when changing portfolio   *
      *             customer to non-portfolio classification          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7883- Validation of CSE070 fields should be dependent on  *
      *           the feature being switched on as the fields can     *
      *           only be input with the feature switched on          *
      *           (duplicate of BUG7945)                              *
      *  CSE070 - Repo Coupon Claims Report                           *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CSE039 - Automatic Settlement of Trades                      *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSE022 - Depository Definition Enhancement                   *
      *  CAP039 - Conversion of SD inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Midas SD Local Industry Codes
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDSECV001
 
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
 
      ** Security Details in screen format
     D SecDets       E DS                  EXTNAME(SDSECDPD)
 
      ** Security Details OK indicators
     D OKSecDets     E DS                  EXTNAME(SDESECDPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Securities ICD Details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
      ** External DS for SAR Details                                                          CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
 
     D ValidSecd     E DS                  EXTNAME(SDVSECDPD)
     D  VLACCD       E                     EXTFLD(QQACCD)                                     CGL029
      * Valid Securities Clients Details layout
 
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD data area                                                                         CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
 
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
 
     D WkDDNDR1        S             20A                                                      CSE022
     D WkDDNDR2        S             20A                                                      CSE022
                                                                                              CSE022
      ** Fields defined for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D WRunDay         S                   LIKE(BJRDNB)                                       CSC011
                                                                                              CSC011
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDSECV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SDSECV003
 
      *
      ** Validate Classification
      *
      /COPY WNCPYSRC,SDSECV004
     C                   EXSR      VCCLAS
      /COPY WNCPYSRC,SDSECV005
      *
 
 
      *
      ** Validate Portfolio Currency
      *
      /COPY WNCPYSRC,SDSECV006
     C                   EXSR      VCPCYC
      /COPY WNCPYSRC,SDSECV007
      *
 
 
      *
      ** Validate Settlement Currency
      *
      /COPY WNCPYSRC,SDSECV008
     C                   EXSR      VCCYCD
      /COPY WNCPYSRC,SDSECV009
      *
 
 
      *
      ** Validate Account Code
      *
      /COPY WNCPYSRC,SDSECV010
     C                   EXSR      VCACCD
      /COPY WNCPYSRC,SDSECV011
      *
 
 
      *
      ** Validate Account Sequence
      *
      /COPY WNCPYSRC,SDSECV012
     C                   EXSR      VCACSN
      /COPY WNCPYSRC,SDSECV013
      *
 
 
      *
      ** Validate Next Statment Date
      *
      /COPY WNCPYSRC,SDSECV014
     C                   EXSR      VCSNSD
      /COPY WNCPYSRC,SDSECV015
      *
 
 
      *
      ** Validate Statement Frequency
      *
      /COPY WNCPYSRC,SDSECV016
     C                   EXSR      VCSTFQ
      /COPY WNCPYSRC,SDSECV017
      *
 
 
      *
      ** Validate Statement Base Date
      *
      /COPY WNCPYSRC,SDSECV018
     C                   EXSR      VCSBDM
      /COPY WNCPYSRC,SDSECV019
      *
 
 
      *
      ** Validate Alternative Name and Address
      *
      /COPY WNCPYSRC,SDSECV020
     C                   EXSR      VCADCD
      /COPY WNCPYSRC,SDSECV021
      *
 
 
      *
      ** Validate Cedel Fungibility Indicator
      *
      /COPY WNCPYSRC,SDSECV022
     C                   EXSR      VCCFIN
      /COPY WNCPYSRC,SDSECV023
      *
 
 
      *
      ** Validate Pledge Agreement
      *
      /COPY WNCPYSRC,SDSECV024
     C                   EXSR      VCPLAG
      /COPY WNCPYSRC,SDSECV025
      *
 
 
      *
      ** Validate Tax Code
      *
      /COPY WNCPYSRC,SDSECV026
     C                   EXSR      VCTXCD
      /COPY WNCPYSRC,SDSECV027
      *
 
 
      *
      ** Validate Auto-Settle Indicator
      *
      /COPY WNCPYSRC,SDSECV028
     C                   EXSR      VCASIN
      /COPY WNCPYSRC,SDSECV029
      *
 
 
      *
      ** Validate Safe Custody Fees
      *
      /COPY WNCPYSRC,SDSECV030
     C                   EXSR      VCSBJF
      /COPY WNCPYSRC,SDSECV031
      *
 
 
      *
      ** Validate Trade Charges Group
      *
      /COPY WNCPYSRC,SDSECV032
     C                   EXSR      VCTDCG
      /COPY WNCPYSRC,SDSECV033
      *
 
 
      *
      ** Validate Custody Fees Group Code
      *
      /COPY WNCPYSRC,SDSECV034
     C                   EXSR      VCCFGC
      /COPY WNCPYSRC,SDSECV035
      *
 
 
      *
      ** Validate Position Settlement Charge Group
      *
      /COPY WNCPYSRC,SDSECV036
     C                   EXSR      VCPSCG
      /COPY WNCPYSRC,SDSECV037
      *
 
 
      *
      ** Validate Depot References and Participants
      *
      /COPY WNCPYSRC,SDSECV038
     C                   EXSR      VCDRFN
      /COPY WNCPYSRC,SDSECV039
      *                                                                                       CSE070
      ** Validate Repo Claims Required                                                        CSE070
      *                                                                                       CSE070
     C                   If        CSE070 = 'Y'                                              BUG7883
     C                   EXSR      VRREQ                                                      CSE070
     C                   EndIf                                                               BUG7883
      *                                                                                     MD021141
      ** Retain the original value of field Statutory Returns Code                          MD021141
      ** without validation.                                                                MD021141
      *                                                                                     MD021141
     C                   EVAL      SESRCD = DDSRCD                                          MD021141
      *
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDSECV040
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCCLAS
      *****************************************************************
     C     VCCLAS        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Classification
      *
     C                   CALLB     'SDVCCLAS'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Classification
     C     SECLAS        PARM                    DDCLAS
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Classification - OK
     C                   PARM                    DDCLASOK
     C                   PARM                    DDCUSN                                     BUG12946
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCPCYC
      *****************************************************************
     C     VCPCYC        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Portfolio Currency
      *
     C                   CALLB     'SDVCPCYC'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Classification
     C                   PARM                    DDCLAS
      *
      ** Midas Bank Details Currency Code
     C                   PARM                    WKCYCD
      *
      ** Portfolio Currency
     C     SEPCYC        PARM                    DDPCYC
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Portfolio Currency - OK
     C                   PARM                    DDPCYCOK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCCYCD
      *****************************************************************
     C     VCCYCD        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Settlement Currency
      *
     C                   CALLB     'SDVCCYCD'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Classification
     C                   PARM                    DDCLAS
      *
      ** Settlement Currency
     C     SECYCD        PARM                    DDCYCD
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Settlement Currency - OK
     C                   PARM                    DDCYCDOK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCACCD
      *****************************************************************
     C     VCACCD        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Account Code
      *
     C                   CALLB     'SDVCACCD'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Classification
     C                   PARM                    DDCLAS
      *
      ** Account Code
     C     SEACCD        PARM                    DDACCD
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Account Code - OK
     C                   PARM                    DDACCDOK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCACSN
      *****************************************************************
     C     VCACSN        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Account Sequence
      *
     C                   CALLB     'SDVCACSN'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Account Code
     C                   PARM                    DDACCD
      *
      ** Account Sequence - alpha
     C                   PARM                    DDACSN
      *
      *
      * OUTPUTS
      *
      ** Account Sequence - numeric
     C                   PARM                    SEACSN
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Account Sequence - OK
     C                   PARM                    DDACSNOK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCSTFQ
      *****************************************************************
     C     VCSTFQ        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Statement Frequency
      *
     C                   CALLB     'SDVCSTFQ'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Classification
     C                   PARM                    DDCLAS
      *
      ** Statement Frequency
     C     SESTFQ        PARM                    DDSTFQ
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Classification - OK
     C                   PARM                    DDCLASOK
      *
      ** Statement Frequency - OK
     C                   PARM                    DDSTFQOK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCSNSD
      *****************************************************************
     C     VCSNSD        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Next Statment Date
      *
     C                   CALLB     'SDVCSNSD'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Next Statement Date - alpha
     C                   PARM                    DDSNSD
      *
      ** Classification
     C                   PARM                    DDCLAS
      *
      ** Statement Frequency
     C                   PARM                    DDSTFQ
      *
      ** Date Format Indicator
     C                   PARM                    WKDFIN
      *
      ** Run Day Number
     C**********         PARM                    WKRDNB                                       CSC011
     C                   PARM                    WRunDay                                      CSC011
      *
      *
      * OUTPUTS
      *
      *
      ** Next Statement Date - day number
     C                   PARM                    SESNSD
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Next Statement Date - OK
     C                   PARM                    DDSNSDOK
      *
      ** Statement Frequency - OK
     C                   PARM                    DDSTFQOK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCSBDM
      *****************************************************************
     C     VCSBDM        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Statement Base Date
      *
     C                   CALLB     'SDVCSBDM'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Classification
     C                   PARM                    DDCLAS
      *
      ** Statement Base Date - alpha
     C                   PARM                    DDSBDM
      *
      ** Statement Frequency
     C                   PARM                    DDSTFQ
      *
      *
      * OUTPUTS
      *
      ** Statement Base Date - numeric
     C                   PARM                    SESBDM
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Classification - OK
     C                   PARM                    DDCLASOK
      *
      ** Statement Base Date - OK
     C                   PARM                    DDSBDMOK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCADCD
      *****************************************************************
     C     VCADCD        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Alternative Name and Address
      *
     C                   CALLB     'SDVCADCD'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Customer Number
     C                   PARM                    DDCUSN
      *
      ** Alternative Name and Address
     C     SEADCD        PARM                    DDADCD
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Alternative Name and Address - OK
     C                   PARM                    DDADCDOK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCCFIN
      *****************************************************************
     C     VCCFIN        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Cedel Fungibility Indicator
      *
     C                   CALLB     'SDVCCFIN'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Classification
     C                   PARM                    DDCLAS
      *
      ** Depot Participant 2
     C                   PARM                    DDPNP2
      *
      ** Cedel Fungibility Indicator
     C     SECFIN        PARM                    DDCFIN
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Cedel Fungibility Indicator - OK
     C                   PARM                    DDCFINOK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCPLAG
      *****************************************************************
     C     VCPLAG        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Pledge Agreement
      *
     C                   CALLB     'SDVCPLAG'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Pledge Agreement
     C     SEPLAG        PARM                    DDPLAG
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Pledge Agreement - OK
     C                   PARM                    DDPLAGOK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCTXCD
      *****************************************************************
     C     VCTXCD        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Tax Code
      *
     C                   CALLB     'SDVCTXCD'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Tax Code
     C     SETXCD        PARM                    DDTXCD
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Tax Code - OK
     C                   PARM                    DDTXCDOK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCASIN
      *****************************************************************
     C     VCASIN        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Auto-Settle Indicator
      *
     C                   CALLB     'SDVCASIN'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Auto-Settle Indicator
     C     SEASIN        PARM                    DDASIN
      *                                                                                       CSE039
      ** Automatic Settlement of Trades                                                       CSE039
     C                   PARM                    CSE039                                       CSE039
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Auto-Settle Indicator - OK
     C                   PARM                    DDASINOK
      *
     C                   IF        CSE039 ='Y' AND (SECLAS ='S' OR SECLAS ='D')            AR1081265
     C                   IF        DDSARQ =*BLANK                                          AR1081265
     C                   EVAL      DDSARQ = 'N'                                            AR1081265
     C                   ENDIF                                                             AR1081265
      *                                                                                    AR1081265
     C                   EVAL      SESARQ = DDSARQ                                         AR1081265
     C                   ENDIF                                                             AR1081265
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCSBJF
      *****************************************************************
     C     VCSBJF        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Safe Custody Fees
      *
     C                   CALLB     'SDVCSBJF'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Safe Custody Fees Flag
     C                   PARM                    BVCUIN
      *
      ** Classification
     C                   PARM                    DDCLAS
      *
      ** Subject to Custody Fees
     C     SESBJF        PARM                    DDSBJF
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Subject to Custody Fees - OK
     C                   PARM                    DDSBJFOK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCTDCG
      *****************************************************************
     C     VCTDCG        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Trade Charges Group
      *
     C                   CALLB     'SDVCTDCG'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Private Banking Securities Trading Enhancement
     C                   PARM                    S01496
      *
      ** Classification
     C                   PARM                    DDCLAS
      *
      ** Trade Charges Group
     C     SETDCG        PARM                    DDTDCG
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Trade Charges Group - OK
     C                   PARM                    DDTDCGOK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCCFGC
      *****************************************************************
     C     VCCFGC        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Custody Fees Group Code
      *
     C                   CALLB     'SDVCCFGC'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Safe Custody Fees Flag
     C                   PARM                    BVCUIN
      *
      ** Subject to Custody Fees
     C                   PARM                    DDSBJF
      *
      ** Custody Fees Group Code
     C     SECFGC        PARM                    DDCFGC
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Custody Fees Group Code - OK
     C                   PARM                    DDCFGCOK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCPSCG
      *****************************************************************
     C     VCPSCG        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Position Settlement Charge Group
      *
     C                   CALLB     'SDVCPSCG'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Private Banking Securities Trading Enhancement
     C                   PARM                    S01496
      *
      ** Classification
     C                   PARM                    DDCLAS
      *
      ** Position Settlement Charge Group
     C     SEPSCG        PARM                    DDPSCG
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Position Settlement Charge Group - OK
     C                   PARM                    DDPSCGOK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCDRFN
      *****************************************************************
     C     VCDRFN        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Depot References and Participants
      *
     C                   EVAL      WkDDNDR1 = DDNDR1                                          CSE022
     C                   EVAL      WkDDNDR2 = DDNDR2                                          CSE022
                                                                                              CSE022
     C                   CALLB     'SDVCDRFN'
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Customer Number
     C                   PARM                    DDCUSN
      *
      ** Classification
     C                   PARM                    DDCLAS
      *
      ** Depot 1
     C                   PARM                    BVDR1
      *
      ** Depot 2
     C                   PARM                    BVDR2
      *
      ** Depot Reference 1
     C*****SEDRF1        PARM                    DDDRF1                                       CSE022
     C     SENDR1        PARM                    DDNDR1                                       CSE022
      *
      ** Depot Reference 2
     C*****SEDRF2        PARM                    DDDRF2                                       CSE022
     C     SENDR2        PARM                    DDNDR2                                       CSE022
      *
      ** Depot Reference 3
     C*****SEDRF3        PARM                    DDDRF3                                       CSE022
     C     SENDR3        PARM                    DDNDR3                                       CSE022
      *
      ** Depot Reference 4
     C*****SEDRF4        PARM                    DDDRF4                                       CSE022
     C     SENDR4        PARM                    DDNDR4                                       CSE022
      *
      ** Depot Reference 5
     C*****SEDRF5        PARM                    DDDRF5                                       CSE022
     C     SENDR5        PARM                    DDNDR5                                       CSE022
      *
      ** Depot Reference 6
     C*****SEDRF6        PARM                    DDDRF6                                       CSE022
     C     SENDR6        PARM                    DDNDR6                                       CSE022
      *
      ** Depot Reference 7
     C*****SEDRF7        PARM                    DDDRF7                                       CSE022
     C     SENDR7        PARM                    DDNDR7                                       CSE022
      *
      ** Depot Reference 8
     C*****SEDRF8        PARM                    DDDRF8                                       CSE022
     C     SENDR8        PARM                    DDNDR8                                       CSE022
      *
      ** Depot Reference 9
     C*****SEDRF9        PARM                    DDDRF9                                       CSE022
     C     SENDR9        PARM                    DDNDR9                                       CSE022
      *
      ** Depot Reference 10
     C*****SEDRF0        PARM                    DDDRF0                                       CSE022
     C     SENDR0        PARM                    DDNDR0                                       CSE022
      *
      ** Depot Participant 1
     C     SEPNP1        PARM                    DDPNP1
      *
      ** Depot Participant 2
     C     SEPNP2        PARM                    DDPNP2
      *
      ** Depot Participant 3
     C     SEPNP3        PARM                    DDPNP3
      *
      ** Depot Participant 4
     C     SEPNP4        PARM                    DDPNP4
      *
      ** Depot Participant 5
     C     SEPNP5        PARM                    DDPNP5
      *
      ** Depot Participant 6
     C     SEPNP6        PARM                    DDPNP6
      *
      ** Depot Participant 7
     C     SEPNP7        PARM                    DDPNP7
      *
      ** Depot Participant 8
     C     SEPNP8        PARM                    DDPNP8
      *
      ** Depot Participant 9
     C     SEPNP9        PARM                    DDPNP9
      *
      ** Depot Participant 10
     C     SEPNP0        PARM                    DDPNP0
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Depot Reference 1 - OK
     C**********         PARM                    DDDRF1OK                                     CSE022
     C                   PARM                    DDNDR1OK                                     CSE022
      ** Depot Reference 2 - OK
     C**********         PARM                    DDDRF2OK                                     CSE022
     C                   PARM                    DDNDR2OK                                     CSE022
      ** Depot Reference 3 - OK
     C**********         PARM                    DDDRF3OK                                     CSE022
     C                   PARM                    DDNDR3OK                                     CSE022
      ** Depot Reference 4 - OK
     C**********         PARM                    DDDRF4OK                                     CSE022
     C                   PARM                    DDNDR4OK                                     CSE022
      ** Depot Reference 5 - OK
     C**********         PARM                    DDDRF5OK                                     CSE022
     C                   PARM                    DDNDR5OK                                     CSE022
      ** Depot Reference 6 - OK
     C**********         PARM                    DDDRF6OK                                     CSE022
     C                   PARM                    DDNDR6OK                                     CSE022
      ** Depot Reference 7 - OK
     C**********         PARM                    DDDRF7OK                                     CSE022
     C                   PARM                    DDNDR7OK                                     CSE022
      ** Depot Reference 8 - OK
     C**********         PARM                    DDDRF8OK                                     CSE022
     C                   PARM                    DDNDR8OK                                     CSE022
      ** Depot Reference 9 - OK
     C**********         PARM                    DDDRF9OK                                     CSE022
     C                   PARM                    DDNDR9OK                                     CSE022
      ** Depot Reference 10 - OK
     C**********         PARM                    DDDRF0OK                                     CSE022
     C                   PARM                    DDNDR0OK                                     CSE022
      ** Depot Participant 1 - OK
     C                   PARM                    DDPNP1OK
      ** Depot Participant 2 - OK
     C                   PARM                    DDPNP2OK
      ** Depot Participant 3 - OK
     C                   PARM                    DDPNP3OK
      ** Depot Participant 4 - OK
     C                   PARM                    DDPNP4OK
      ** Depot Participant 5 - OK
     C                   PARM                    DDPNP5OK
      ** Depot Participant 6 - OK
     C                   PARM                    DDPNP6OK
      ** Depot Participant 7 - OK
     C                   PARM                    DDPNP7OK
      ** Depot Participant 8 - OK
     C                   PARM                    DDPNP8OK
      ** Depot Participant 9 - OK
     C                   PARM                    DDPNP9OK
      ** Depot Participant 10 - OK
     C                   PARM                    DDPNP0OK
      *
      *
      *
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   EVAL      DDNDR1 = WkDDNDR1                                          CSE022
     C                   EVAL      DDNDR2 = WkDDNDR2                                          CSE022
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VRREQ                                                                                CSE070
      *****************************************************************                       CSE070
     C     VRREQ         BEGSR                                                                CSE070
                                                                                              CSE070
      * Reset variables updated by validation                                                 CSE070
                                                                                              CSE070
     C                   EXSR      RESETERRS                                                  CSE070
      *                                                                                       CSE070
      ** Validate Repo Claims Required                                                        CSE070
      *                                                                                       CSE070
     C                   CALLB     'SDVRREQ'                                                  CSE070
      * INPUTS                                                                                CSE070
      *                                                                                       CSE070
      ** Return Code                                                                          CSE070
     C                   PARM                    RetCodeIn                                    CSE070
      *                                                                                       CSE070
      ** Other parms                                                                          CSE070
      *                                                                                       CSE070
      ** Repo Claims Required                                                                 CSE070
     C     SERREQ        PARM                    DDRREQ                                       CSE070
      *                                                                                       CSE070
      ** Classification                                                                       CSE070
     C                   PARM                    DDCLAS                                       CSE070
      *                                                                                       CSE070
      *                                                                                       CSE070
      * OUTPUTS                                                                               CSE070
      *                                                                                       CSE070
      *                                                                                       CSE070
      * Error fields/message IDs/message data (arrays) from/to caller                         CSE070
     C                   PARM                    FldNamXAr                                    CSE070
     C                   PARM                    MsgIDXAr                                     CSE070
     C                   PARM                    MsgDtaXAr                                    CSE070
      *                                                                                       CSE070
      ** Repo Claims Req - OK                                                                 CSE070
     C                   PARM                    DDRREQOK                                     CSE070
      *                                                                                       CSE070
      ** Classification - OK                                                                  CSE070
     C                   PARM                    DDCLASOK                                     CSE070
      *                                                                                       CSE070
      *                                                                                       CSE070
      *                                                                                       CSE070
      * Update error info with that returned from the validation module                       CSE070
                                                                                              CSE070
     C                   EXSR      UPDATERRS                                                  CSE070
      *                                                                                       CSE070
     C                   ENDSR                                                                CSE070
      *****************************************************************                       CSE070
     C/EJECT                                                                                  CSE070
      *****************************************************************                       CSE070
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
 
      ** Security Details
     C                   PARM                    SecDets
                                                                                              CSE039
      ** Automatic Settlement of Trades                                                       CSE039
     C                   PARM                    CSE039            1                          CSE039
 
      * OUTPUTS
 
      ** Security Details OK inds
     C                   PARM                    OKSecDets
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Valid Securities Clients details layout (DS) from/to caller
     C                   PARM                    ValidSecd
 
      *
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   END
      *
      ** ACCESS SECURITIES ICD DETAILS
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDSTRD        PARM      SDSTRD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Check if switchable feature S01496 is switched on.
      ** Private Banking Securities Trading Enhancement
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01496'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01496'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      SRERR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01496            1
     C                   ELSE
     C                   MOVE      'N'           S01496
     C                   END
      *
      *
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   EVAL      WRunDay = BJRDNB                                           CSC011
                                                                                              CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   IF        LIBR = S1SUPP                                              CSC011
     C                   EVAL      WRunDay = S1DATE                                           CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        (PRtCd <> '*NRF') and                                      CSC011
     C                             (PRtCd <> *Blanks)                                         CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 903                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                      BUG7883
      ** Check if switchable feature CSE070 is switched on.                                  BUG7883
      *                                                                                      BUG7883
     C                   CALL      'AOSARDR0'                                                BUG7883
     C                   PARM      *BLANKS       @RTCD                                       BUG7883
     C                   PARM      '*VERIFY'     @OPTN                                       BUG7883
     C                   PARM      'CSE070'      @SARD             6                         BUG7883
      *                                                                                      BUG7883
      ** DATABASE ERROR                                                                      BUG7883
      *                                                                                      BUG7883
     C     @RTCD         IFNE      *BLANKS                                                   BUG7883
     C     @RTCD         ANDNE     '*NRF   '                                                 BUG7883
     C                   MOVEL     'CSE070'      DBKEY                                       BUG7883
     C                   MOVEL     'SCSARDPD'    DBFILE                                      BUG7883
     C                   MOVEL     '904'         DBASE                                       BUG7883
     C                   EXSR      SRERR                                                     BUG7883
     C                   END                                                                 BUG7883
     C     @RTCD         IFEQ      *BLANK                                                    BUG7883
     C                   MOVE      'Y'           CSE070            1                         BUG7883
     C                   ELSE                                                                BUG7883
     C                   MOVE      'N'           CSE070                                      BUG7883
     C                   END                                                                 BUG7883
      *                                                                                    AR1081265
      ** Check if switchable feature CSE039 is switched on.                                AR1081265
      *                                                                                    AR1081265
     C                   CALL      'AOSARDR0'                                              AR1081265
     C                   PARM      *BLANKS       @RTCD                                     AR1081265
     C                   PARM      '*VERIFY'     @OPTN                                     AR1081265
     C                   PARM      'CSE039'      @SARD             6                       AR1081265
      *                                                                                    AR1081265
      ** DATABASE ERROR                                                                    AR1081265
      *                                                                                    AR1081265
     C     @RTCD         IFNE      *BLANKS                                                 AR1081265
     C     @RTCD         ANDNE     '*NRF   '                                               AR1081265
     C                   MOVEL     'CSE039'      DBKEY                                     AR1081265
     C                   MOVEL     'SCSARDPD'    DBFILE                                    AR1081265
     C                   MOVEL     '905'         DBASE                                     AR1081265
     C                   EXSR      SRERR                                                   AR1081265
     C                   END                                                               AR1081265
     C     @RTCD         IFEQ      *BLANK                                                  AR1081265
     C                   MOVE      'Y'           CSE039            1                       AR1081265
     C                   ELSE                                                              AR1081265
     C                   MOVE      'N'           CSE039                                    AR1081265
     C                   END                                                               AR1081265
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDSECV041
 
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
     C                   MOVEL     'SDSECDVAL'   DBPGM
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
(c) Misys International Banking Systems Ltd. 2001
