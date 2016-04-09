     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Yield Curves Details Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDYLCUVAL - Yield Curves Details Validation                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDYLCUV001
 
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
     D TrnDets       E DS                  EXTNAME(SDYLCUPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDEYLCUPD)
 
      ** Valid Transaction Details layout
     D ValidYlcu     E DS                  EXTNAME(SDVYLCUPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
     D ExtData       E DS                  EXTNAME(SDYCEXPD)
      ** SD Extra Data - File (D/B) format
     D CRE026          S              1A
 
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
      /COPY WNCPYSRC,SDYLCUV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SDYLCUV003
 
      *
      ** Validate Yield Curves Description
      /COPY WNCPYSRC,SDYLCUV004
     C                   EXSR      VYLDDSR
      /COPY WNCPYSRC,SDYLCUV005
      *
      ** Validate Yield Curves Type
      /COPY WNCPYSRC,SDYLCUV006
     C                   EXSR      VYLDTSR
      /COPY WNCPYSRC,SDYLCUV007
      *
      ** Validate Interpolation Method
      /COPY WNCPYSRC,SDYLCUV008
     C                   EXSR      VINTPSR
      /COPY WNCPYSRC,SDYLCUV009
      *
      ** Check if enhancement CRE026 is on
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRE026'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD <> *BLANKS  AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CRE026'
     C                   EVAL      DBASE  = 910
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CRE026 = 'Y'
     C                   ELSE
     C                   EVAL      CRE026 = 'N'
     C                   ENDIF
 
      ** Validate Yield Curve Mnemonic
     C                   IF        CRE026 = 'Y'
      /COPY WNCPYSRC,SDYLCUV010
     C                   EXSR      VYLDASR
      /COPY WNCPYSRC,SDYLCUV011
     C                   ENDIF
      *
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDYLCUV012
 
     ******************************************************************
     C/EJECT
      *****************************************************************
      ** VYLDDSR - Validate Yield Curves Description
      *****************************************************************
     C     VYLDDSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Yield Curves Description
     C                   CALLB     'SDVYLDD'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Yield Curves Description
     C                   PARM                    DDYLDD
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Yield Curves Description - OK
     C                   PARM                    DDYLDDOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VYLDTSR - Validate Yield Curve Type
      *****************************************************************
     C     VYLDTSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Yield Curve Type
     C                   CALLB     'SDVYLDT'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Yield Curve Type
     C                   PARM                    DDYLDT
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Yield Curve Type - OK
     C                   PARM                    DDYLDTOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VINTPSR - Validate Interpolation Method
      *****************************************************************
     C     VINTPSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Interpolation Method
     C                   CALLB     'SDVINTP'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Interpolation Method
     C                   PARM                    DDINTP
      ** Yield Curve Type
     C                   PARM                    DDYLDT
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Interpolation Method - OK
     C                   PARM                    DDINTPOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VYLDASR - Validate Yield Curve Mnemonic
      *****************************************************************
     C     VYLDASR       BEGSR
 
      * Reset variables updated by validation
     C                   EXSR      RESETERRS
      *
      ** Validate Yield Curve Mnemonic
     C                   CALLB     'SDVYLDA'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Yield Curve Mnemonic
     C                   PARM                    DDYLDA
      ** Interpolation Method
     C                   PARM                    DDINTP
      ** Yield Curve Code
     C                   PARM                    DDYLDC
 
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Yield Curve Mnemonic - OK
     C                   PARM                    DDYLDAOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
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
 
      ** Yield Curves Details
     C                   PARM                    TrnDets
     C                   PARM                    ExtData
      * Outputs
 
      ** Yield Curves Details OK inds
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
 
      * Valid Yield Curves details layout (DS) from/to caller
     C                   PARM                    ValidYLCU
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
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDYLCUV013
 
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
