     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer Fiduciary Deposits Details Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDFVL - Customer Fiduciary Deposit Details Validation    *
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
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCUFDV001
 
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
     D TrnDets       E DS                  EXTNAME(SDCUFDPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDECUFDPD)
 
      ** Valid Transaction Details layout
     D ValidCusd     E DS                  EXTNAME(SDVCUSDPD)
 
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
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUFDV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SDCUFDV003
 
      ** Validate Commission Group
 
      /COPY WNCPYSRC,SDCUFDV004
     C                   EXSR      VCOMGSR
      /COPY WNCPYSRC,SDCUFDV005
 
      ** Validate Charge Group
 
      /COPY WNCPYSRC,SDCUFDV006
     C                   EXSR      VCHRGSR
      /COPY WNCPYSRC,SDCUFDV007
 
      ** Validate Agent
 
      /COPY WNCPYSRC,SDCUFDV008
     C                   EXSR      VAGNTSR
      /COPY WNCPYSRC,SDCUFDV009
 
      ** Validate Agent Percentage
 
      /COPY WNCPYSRC,SDCUFDV010
     C                   EXSR      VAGNPSR
      /COPY WNCPYSRC,SDCUFDV011
 
      ** Validate Trust Agreement Status
 
      /COPY WNCPYSRC,SDCUFDV012
     C                   EXSR      VTRASSR
      /COPY WNCPYSRC,SDCUFDV013
 
      ** Validate Restrictions/Narrative
 
      /COPY WNCPYSRC,SDCUFDV014
     C                   EXSR      VNARSR
      /COPY WNCPYSRC,SDCUFDV015
 
      ** Validate Default Account code
 
      /COPY WNCPYSRC,SDCUFDV016
     C                   EXSR      VDFACSR
      /COPY WNCPYSRC,SDCUFDV017
 
      ** Validate Default Account Sequence
 
      /COPY WNCPYSRC,SDCUFDV018
     C                   EXSR      VDFASSR
      /COPY WNCPYSRC,SDCUFDV019
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
 
      /COPY WNCPYSRC,SDCUFDV020
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VCOMGSR - Validate Commission Group                          *
      *                                                               *
      *****************************************************************
     C     VCOMGSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Commission Group
 
     C                   CALLB     'SDVCOMG'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Commission Group
 
     C                   PARM                    DDCOMG
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Commission Group - OK
 
     C                   PARM                    DDCOMGOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VCHRGSR - Validate Charge Group                              *
      *                                                               *
      *****************************************************************
      *
     C     VCHRGSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Charge Group
 
     C                   CALLB     'SDVCHRG'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Provisional Opening
 
     C                   PARM                    DDCHRG
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Charge Group  - OK
 
     C                   PARM                    DDCHRGOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VAGNTSR - Validate Agent                                     *
      *                                                               *
      *****************************************************************
 
     C     VAGNTSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Agent
 
     C                   CALLB     'SDVAGNT'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Agent
 
     C                   PARM                    DDAGNT
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Agent - OK
 
     C                   PARM                    DDAGNTOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VAGNPSR - Agent Percentage                                   *
      *                                                               *
      *****************************************************************
 
     C     VAGNPSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Agent Percentage
 
     C                   CALLB     'SDVAGNP'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Agent Percentage
 
     C                   PARM                    DDAGNP
 
      ** Agent
 
     C                   PARM                    DDAGNT
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Agent Percentage - OK
 
     C                   PARM                    DDAGNPOK
 
      ** Return value for Agent Percentage
 
     C                   PARM                    CUAGNP
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VTRASSR - Trust Agreement status                             *
      *                                                               *
      *****************************************************************
 
     C     VTRASSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Trust Agreement Status
 
     C                   CALLB     'SDVTRAS'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Trust Agreement Status
 
     C                   PARM                    DDTRAS
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Trust Agreement Status - OK
 
     C                   PARM                    DDTRASOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VNARSR - Restrictions/Narrative                              *
      *                                                               *
      *****************************************************************
 
     C     VNARSR        BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Restrictions/Narrative
 
     C                   CALLB     'SDVNAR'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Restrictions/Narrative 1/2/3/4
 
     C                   PARM                    DDNAR1
     C                   PARM                    DDNAR2
     C                   PARM                    DDNAR3
     C                   PARM                    DDNAR4
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Restrictions/Narrative 1/2/3/4 - OK
 
     C                   PARM                    DDNAR1OK
     C                   PARM                    DDNAR2OK
     C                   PARM                    DDNAR3OK
     C                   PARM                    DDNAR4OK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VDFACSR - Default Account Code                               *
      *                                                               *
      *****************************************************************
 
     C     VDFACSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Default Account Code
 
     C                   CALLB     'SDVDFAC'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Default Account Code
 
     C                   PARM                    DDDFAC
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Default Account Code - OK
 
     C                   PARM                    DDDFACOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  VDFASSR - Default Account Sequence                           *
      *                                                               *
      *****************************************************************
 
     C     VDFASSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Default Account Sequence
 
     C                   CALLB     'SDVDFAS'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Default Account Sequence
 
     C                   PARM                    DDDFAS
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Default Account Sequence - OK
 
     C                   PARM                    DDDFASOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
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
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Inputs
      ** Response mode
 
     C                   PARM                    RespMode
 
      ** Transaction Details
 
     C                   PARM                    TrnDets
 
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
 
     C                   PARM                    ValidCusd
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SKCUFDV021
 
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
