     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Nostro Codes - Validation Module')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDNOSRVAL - Nostro Codes Details Validation                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. CDL094             Date 30May14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDNOSRV001
 
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
     D TrnDets       E DS                  EXTNAME(SDNOSRPD)
      ** Intermediary bank fields                                                             CDL094
     D   P#Intermeds         133    270                                                       CDL094
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDENOSRPD)
      **  Validation flags for Intermidary banks fields                                       CDL094
     D   P#OKFLAGS            20     25                                                       CDL094
 
      ** Valid Transaction Details layout
     D ValidNosr     E DS                  EXTNAME(SDVNOSRPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
     D ExtData       E DS                  EXTNAME(SDNVEXPD)
      *  SD Extra Data - File (D/B) format
 
      ** Intermidary banks fields                                                             CDL094
                                                                                              CDL094
     D CDL094          S               N                                                      CDL094
                                                                                              CDL094
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
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDNOSRV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SDNOSRV003
 
      *
      ** Validate Account Number
      /COPY WNCPYSRC,SDNOSRV004
     C                   EXSR      VACNTSR
      /COPY WNCPYSRC,SDNOSRV005
      *
      ** Validate Nostro Shortname
      /COPY WNCPYSRC,SDNOSRV006
     C                   EXSR      VNOSNSR
      /COPY WNCPYSRC,SDNOSRV007
      *
      ** Validate Prime Nostro Indicator
      /COPY WNCPYSRC,SDNOSRV008
     C                   EXSR      VPNOISR
      /COPY WNCPYSRC,SDNOSRV009
      *
      *
      *
      ** Validate Only If CDL008(Continous Linked Settlement feature) is
      ** switched on.
      *
     C                   IF        CDL008 = 'Y'
      *
      ** Validate CLS Dummy Nostro Indicator if CDL008 is switched on
      /COPY WNCPYSRC,SDNOSRV010
     C                   EXSR      VCLSDSR
      /COPY WNCPYSRC,SDNOSRV011
      *
      ** Validate Only If CLS Dummy NOstro Indicator = 'Y'
      *
     C                   IF        DDCLSD = 'Y'
      *
      ** Validate CLS Pay/Receive Nostro Code if CDL008 is switched on
      /COPY WNCPYSRC,SDNOSRV012
     C                   EXSR      VLPRSR
      /COPY WNCPYSRC,SDNOSRV013
      *
      ** Validate Multiple Pay-in Generated by Time if CDL008 is switched on
      /COPY WNCPYSRC,SDNOSRV014
     C                   EXSR      VMPGTSR
      /COPY WNCPYSRC,SDNOSRV015
      *
      ** Validate Payment Lead Time if CDL008 is switched on
      /COPY WNCPYSRC,SDNOSRV016
     C                   EXSR      VPMLTSR
      /COPY WNCPYSRC,SDNOSRV017
      *
      ** Validate CLS Settlement Member if CDL008 is switched on
      /COPY WNCPYSRC,SDNOSRV018
     C                   EXSR      VCLSMSR
      /COPY WNCPYSRC,SDNOSRV019
      *
      ** Validate CLS Settlement Members Correspondent if CDL008
      ** is switched on
      /COPY WNCPYSRC,SDNOSRV020
     C                   EXSR      VCLSCSR
      /COPY WNCPYSRC,SDNOSRV021
      *
      ** Validate Alternative CLS Funding SWIFT ID if CDL008 is switched on
      /COPY WNCPYSRC,SDNOSRV022
     C                   EXSR      VASIDSR
      /COPY WNCPYSRC,SDNOSRV023
      *
     C                   ENDIF                                                  *End DDCLSD
      *
     C                   ENDIF                                                  *End CDL008
      *
 
      ** Validate Intermediary Banks fields if CDL094 is ON                                   CDL094
     C                   If        CDL094                                                     CDL094
     C                   EXSR      VINTRMD                                                    CDL094
     C                   EndIf                                                                CDL094
                                                                                              CDL094
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDNOSRV024
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VACNTSR - Validate Account Number
      *****************************************************************
     C     VACNTSR       BEGSR
 
     C                   EXSR      RESETERRS
      *
      ** Validate Account Number
     C                   CALLB     'SDVACNT'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other Parms
      *
      ** Branch Code
     C                   PARM                    DDBRCD
      ** Customer Number
     C                   PARM                    DDCUST
      ** Currency Code
     C                   PARM                    DDCYCD
      ** Account Code
     C                   PARM                    DDACCD
      ** Account Sequence Number
     C                   PARM                    DDACSN
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Branch Code           - OK
     C                   PARM                    DDBRCDOK
      ** Customer Number       - OK
     C                   PARM                    DDCUSTOK
      ** Currency Code         - OK
     C                   PARM                    DDCYCDOK
      ** Account Code          - OK
     C                   PARM                    DDACCDOK
      ** Account Sequence Number - OK
     C                   PARM                    DDACSNOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VNOSNSR - Validate Nostro Shortname
      *****************************************************************
     C     VNOSNSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate NOstro Shortname
     C                   CALLB     'SDVNOSN'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      **  Other parms
      *
      ** Nostro Shortname
     C                   PARM                    DDNOSN
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Nostro Shortname - OK
     C                   PARM                    DDNOSNOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPNOISR - Validate Prime Nostro Indicator
      *****************************************************************
     C     VPNOISR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Prime Nostro Indicator
     C                   CALLB     'SDVPNOI'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Prime Nostro Indicator
     C                   PARM                    DDPNOI
     C                   PARM                    NVPNOI
     C                   PARM                    DDCYCD
     C                   PARM                    DDNOSN
     C                   PARM                    DDNONB
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Prime Nostro Indicator - OK
     C                   PARM                    DDPNOIOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      ****************************************************************
      ** VCLSDSR - CLS Dummy Nostro Indicator
      *****************************************************************
     C     VCLSDSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate CLS Dummy Nostro Indicator
     C                   CALLB     'SDVCLSD'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** CLS Dummy Nostro Indicator
     C                   PARM                    DDCLSD
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** CLS Dummy Nostro Indicator - OK
     C                   PARM                    DDCLSDOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VLPRSR - CLS Pay/Receive Nostro Indicator
      *****************************************************************
     C     VLPRSR        BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate CLS Pay/Receive Nostro Indicator
     C                   CALLB     'SDVLPR'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** CLS Pay/Receive Nostro Indicator
     C                   PARM                    DDLPR
      ** Nostro Currency Code
     C                   PARM                    DDCYCD
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** CLS Pay/Receive Nostro Indicator - OK
     C                   PARM                    DDLPROK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      ******************************************************************
     C/EJECT
      *****************************************************************
      ** VMPGTSR - Multiple Pay-in Generated by time
      *****************************************************************
     C     VMPGTSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Multiple Pay-in Generated by time
     C                   CALLB     'SDVMPGT'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Multiple Pay-in Generated by time
     C                   PARM                    DDMPGT
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Multiple Pay-in Generated by time - OK
     C                   PARM                    DDMPGTOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      ******************************************************************
     C/EJECT
      ******************************************************************
      ** VPMLTSR - Payment Lead Time
      ******************************************************************
     C     VPMLTSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Payment Lead Time
     C                   CALLB     'SDVPMLT'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      *
      ** Payment Lead Time
     C                   PARM                    DDPMLT
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Payment Lead Time - OK
     C                   PARM                    DDPMLTOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      ******************************************************************
     C/EJECT
      *****************************************************************
      ** VCLSMSR - CLS Settlement Member
      *****************************************************************
     C     VCLSMSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate CLS Settlement Member
     C                   CALLB     'SDVCLSM'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** CLS Settlement Member
     C                   PARM                    DDCLSM
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** CLS Settlement Member - OK
     C                   PARM                    DDCLSMOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      ******************************************************************
     C/EJECT
      *****************************************************************
      ** VCLSCSR - CLS Settlement Members Correspondent
      *****************************************************************
     C     VCLSCSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate CLS Settlement Members Correspondent
     C                   CALLB     'SDVCLSC'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** CLS Settlement Members Correspondent
     C                   PARM                    DDCLSC
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** CLS Settlement Members Correspondent - OK
     C                   PARM                    DDCLSCOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      ******************************************************************
     C/EJECT
      ******************************************************************
      ** VASIDSR - Alternative CLS Funding SWIFT ID
      *****************************************************************
     C     VASIDSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Alternative CLS Funding SWIFT ID
     C                   CALLB     'SDVASID'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Alternative CLS Funding SWIFT ID
     C                   PARM                    DDASID
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Alternative CLS Funding SWIFT ID - OK
     C                   PARM                    DDASIDOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT                                                                                  CDL094
      *****************************************************************                       CDL094
      ** VINTRMD - Validate Intermediary Banks Fields                                         CDL094
      *****************************************************************                       CDL094
     C     VINTRMD       BEGSR                                                                CDL094
                                                                                              CDL094
     C                   EXSR      RESETERRS                                                  CDL094
      *                                                                                       CDL094
      ** Validate Intermediary Banks fields if CDL094 is ON                                   CDL094
     C                   CALLB     'SDVRCIN'                                                  CDL094
     C                   PARM                    RetCodeIn                                    CDL094
      ** Input                                                                                CDL094
     C                   PARM                    P#Intermeds                                  CDL094
      ** Outputs                                                                              CDL094
     C                   PARM      *BLANKS       P#OKFLAGS                                    CDL094
     C                   PARM                    FldNamXAr                                    CDL094
     C                   PARM                    MsgIDXAr                                     CDL094
     C                   PARM                    MsgDtaXAr                                    CDL094
                                                                                              CDL094
      ** Update error info with that returned                                                 CDL094
      ** from the validation module                                                           CDL094
                                                                                              CDL094
     C                   EXSR      UPDATERRS                                                  CDL094
      *                                                                                       CDL094
     C                   ENDSR                                                                CDL094
     C/EJECT
      ******************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
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
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
      *
      * Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      * Update warning fields/message IDs/message data (arrays)
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
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
 
      * Inputs
 
      * Response mode
     C                   PARM                    RespMode          1
 
      ** Nostro Code Details
     C                   PARM                    TrnDets
     C                   PARM                    ExtData
      ** Outputs
 
      ** Nostro Code Details OK inds
     C                   PARM                    OKTrnDets
 
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
 
      ** Valid Nostro Code details layout (DS) from/to caller
     C                   PARM                    ValidNOSR
      *
      ** ACCESS BANK DETAILS
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
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
      *
      ** Check if switchable feature CDL008 is switched on.
      ** - Continous Linked Settlement Enhancement
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL008'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database Error
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = 'CDL008'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 901
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        @RTCD = *BLANK
     C                   MOVE      'Y'           CDL008            1
     C                   ELSE
     C                   MOVE      'N'           CDL008
     C                   ENDIF
      *                                                                                       CDL094
      ** Check if switchable feature CDL094 is switched on.                                   CDL094
     C                   CALL      'AOSARDR0'                                                 CDL094
     C                   PARM      *BLANKS       @RTCD                                        CDL094
     C                   PARM      '*VERIFY'     @OPTN                                        CDL094
     C                   PARM      'CDL094'      @SARD                                        CDL094
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL094
      *                                                                                       CDL094
      ** Database Error                                                                       CDL094
     C                   IF        @RTCD <> *BLANKS AND                                       CDL094
     C                             @RTCD <> '*NRF   '                                         CDL094
     C                   EVAL      DBKEY  = 'CDL094'                                          CDL094
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL094
     C                   EVAL      DBASE  = 902                                               CDL094
     C                   EXSR      *PSSR                                                      CDL094
     C                   ENDIF                                                                CDL094
                                                                                              CDL094
     C                   IF        @RTCD = *BLANK                                             CDL094
     C                   EVAL      CDL094 = *ON                                               CDL094
     C                   ELSE                                                                 CDL094
     C                   EVAL      CDL094 = *OFF                                              CDL094
     C                   ENDIF                                                                CDL094
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDNOSRV025
 
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
(c) Misys International Banking Systems Ltd. 2006
