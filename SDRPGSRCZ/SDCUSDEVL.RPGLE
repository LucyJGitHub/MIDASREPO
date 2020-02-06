     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Customer FX Netting details Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSDEVL - Customer FX Netting details Validation           *
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
      /COPY WNCPYSRC,SDCUFXV001
 
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
     D TrnDets       E DS                  EXTNAME(SDCUFXPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDECUFXPD)
 
      ** Valid Transaction Details layout
     D ValidCusd     E DS                  EXTNAME(SDVCUSDPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
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
     D DDCUSN          S              6
     D I               S              3P 0
     D RespMode        S              1
     D PRTCD           S              7
     D POPTN           S              7
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SDCUFXV002
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SDCUFXV003
 
      ** Validate Net Settlement field
 
      /COPY WNCPYSRC,SDCUFXV004
     C                   EXSR      VNETSR
      /COPY WNCPYSRC,SDCUFXV005
 
      ** Validate Netting Group Field
 
      /COPY WNCPYSRC,SDCUFXV006
     C                   EXSR      VNTGPSR
      /COPY WNCPYSRC,SDCUFXV007
 
      ** Validate Net by CCY Pairs Field
 
      /COPY WNCPYSRC,SDCUFXV008
     C                   EXSR      VNTCPSR
      /COPY WNCPYSRC,SDCUFXV009
 
      ** Validate Net Notice Days Field
 
      /COPY WNCPYSRC,SDCUFXV010
     C                   EXSR      VNTNDSR
      /COPY WNCPYSRC,SDCUFXV011
 
      ** Validate Net Manual Matching
 
      /COPY WNCPYSRC,SDCUFXV012
     C                   EXSR      VNTMMSR
      /COPY WNCPYSRC,SDCUFXV013
      *
 
     C                   RETURN
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCUFXV014
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VNETSR - Validate Net Settlement field                       *
      *                                                               *
      *****************************************************************
      *
     C     VNETSR        BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Net Settlement
 
     C                   CALLB     'SDVNET'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Net Settlement
 
     C                   PARM                    DDNET
 
      ** Customer Number
 
     C                   PARM                    DDCUSN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Net Settlement - OK
 
     C                   PARM                    DDNETOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VNTGPSR - Validate Netting Group                             *
      *                                                               *
      *****************************************************************
 
     C     VNTGPSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Netting Group
 
     C                   CALLB     'SDVNTGP'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Netting Group
 
     C                   PARM                    DDNTGP
 
      ** Net Settlement
 
     C                   PARM                    DDNET
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Netting Group OK
 
     C                   PARM                    DDNTGPOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VNTCPSR - Validate Net by CCY Pairs                          *
      *                                                               *
      *****************************************************************
 
     C     VNTCPSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Net by CCY Pairs
 
     C                   CALLB     'SDVNTCP'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other Parms
      ** Net by CCY pairs
 
     C                   PARM                    DDNTCP
 
      ** Netting Group
 
     C                   PARM                    DDNTGP
 
      ** Net Settlement
 
     C                   PARM                    DDNET
 
      ** Customer Number
 
     C                   PARM                    DDCUSN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Net by CCY Pairs - OK
 
     C                   PARM                    DDNTCPOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VNTNDSR - Validate Net Notice Days                           *
      *                                                               *
      *****************************************************************
 
     C     VNTNDSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Net Notice Days
 
     C                   CALLB     'SDVNTND'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Net Notice Days
 
     C                   PARM                    DDNTND
 
      ** Net Settlement
 
     C                   PARM                    DDNET
 
      ** Netting Group
 
     C                   PARM                    DDNTGP
 
      ** Customer Number
 
     C                   PARM                    DDCUSN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Net Notice Days - OK
 
     C                   PARM                    DDNTNDOK
 
      ** Net Notice Days
 
     C                   PARM                    CUNTND
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  VNTMMSR - Validate Net Manual Matching                       *
      *                                                               *
      *****************************************************************
 
     C     VNTMMSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Net Manual Matching
 
     C                   CALLB     'SDVNTMM'
 
      ** Inputs
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Net Manual Matching
 
     C                   PARM                    DDNTMM
 
      ** Netting Group
 
     C                   PARM                    DDNTGP
 
      ** Net Settlement
 
     C                   PARM                    DDNET
 
      ** Customer Number
 
     C                   PARM                    DDCUSN
 
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Net Manual Matching - OK
 
     C                   PARM                    DDNTMMOK
 
      ** Update error info with that returned from the validation
      ** module
 
     C                   EXSR      UPDATERRS
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
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
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
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
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      ** Inputs
      ** Response mode
 
     C                   PARM                    RespMode
 
      ** FX Netting Details
 
     C                   PARM                    TrnDets
 
      ** Customer Number
 
     C                   PARM                    DDCUSN
 
      ** Outputs
      ** FX Netting Details OK inds
 
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
 
      ** Valid FX Netting Details layout (DS) from/to caller
 
     C                   PARM                    ValidCusd
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  =  900
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
 
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCUFXV015
 
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
