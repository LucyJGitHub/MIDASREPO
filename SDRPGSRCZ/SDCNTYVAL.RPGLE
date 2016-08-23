     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Country Details Validation')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCNTYVAL - Country Details Validation                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. MD030956           Date 09Oct14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD030956 - Additional changes to BFM-TI enhancement          *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SDCTRYV001
 
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
     D TrnDets       E DS                  EXTNAME(SDCNTYPD)
 
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(SDECNTYPD)
 
      ** Valid Transaction Details layout
     D ValidCnty     E DS                  EXTNAME(SDVCNTYPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
     D ExtData       E DS                  EXTNAME(SDCTEXPD)
      *SDExtra Data - File (D/B) format
 
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
      /COPY WNCPYSRC,SDCNTYV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,SDCNTYV003
 
      *
      ** Validate Country Code
      /COPY WNCPYSRC,SDCNTYV004
     C                   EXSR      VCNCDSR
      /COPY WNCPYSRC,SDCNTYV005
      *
      ** Validate Country Name
      /COPY WNCPYSRC,SDCNTYV006
     C                   EXSR      VCNNMSR
      /COPY WNCPYSRC,SDCNTYV007
      *
      ** Validate ISO Country Code
      /COPY WNCPYSRC,SDCNTYV008
     C                   IF        CGP001 = 'N'
     C                   EXSR      VISOCSR
     C                   ENDIF
      /COPY WNCPYSRC,SDCNTYV009
      *
      ** Validate Region Code
      /COPY WNCPYSRC,SDCNTYV010
     C                   EXSR      VRGCDSR
      /COPY WNCPYSRC,SDCNTYV011
      *
      ** Validate Associated Currency if PB module on
      /COPY WNCPYSRC,SDCNTYV012
     C                   IF        BGN4ST = 'Y'
     C                             OR CTI006 = 'Y'                                          MD030956
     C                   EXSR      VCTAYSR
      /COPY WNCPYSRC,SDCNTYV013
      *
      ** Validate ZIP Code if PB module on
      /COPY WNCPYSRC,SDCNTYV014
     C                   EXSR      VCTZPSR
     C                   ENDIF
      /COPY WNCPYSRC,SDCNTYV015
      *
      ** Validate Weighting code if PB module or CGL014 on
      /COPY WNCPYSRC,SDCNTYV016
     C                   IF        BGN4ST = 'Y'
     C                             OR CGL014 = 'Y'
     C                   EXSR      VCTWCSR
     C                   ENDIF
      /COPY WNCPYSRC,SDCNTYV017
      *
      ** Validate BBAN total length if CFT004 is switched on
      /COPY WNCPYSRC,SDCNTYV018
     C                   IF        CFT004 = 'Y'
     C                   EXSR      VBBANSR
      /COPY WNCPYSRC,SDCNTYV019
      *
      ** Validate BBAN bank length if CFT004 is switched on
      /COPY WNCPYSRC,SDCNTYV020
     C                   EXSR      VBBRLSR
     C                   ENDIF
      /COPY WNCPYSRC,SDCNTYV021
      ** Validate ETXY End of Tax Year if CGL032 is switched on
      /COPY WNCPYSRC,SDCNTYV022
     C                   IF        CGL032 = 'Y'
     C                   EXSR      VETXYSR
      /COPY WNCPYSRC,SDCNTYV023
 
      ** Validate RPFQ Reporting Frequency if CGL032 is switched on
      /COPY WNCPYSRC,SDCNTYV024
     C                   EXSR      VRPFQSR
      /COPY WNCPYSRC,SDCNTYV025
     C                   ENDIF
 
      ** Validate TXCY Currency of Tax if CGL032 is switched on
      /COPY WNCPYSRC,SDCNTYV026
     C                   IF        CGL031 = 'Y'
     C                   EXSR      VTXCYSR
      /COPY WNCPYSRC,SDCNTYV027
     C                   ENDIF
 
      ** Validate JAMG Joint Account Management if CGL032 is switched on
      /COPY WNCPYSRC,SDCNTYV028
     C                   IF        CGL032 = 'Y'
     C                   EXSR      VJAMGSR
      /COPY WNCPYSRC,SDCNTYV029
     C                   ENDIF
 
      ** Validate CTTX Currency of Tax if CGL032 is switched on
      /COPY WNCPYSRC,SDCNTYV030
     C                   IF        CGL031 = 'Y'
     C                   EXSR      VCTTXSR
      /COPY WNCPYSRC,SDCNTYV031
     C                   ENDIF
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SDCNTYV032
 
      *****************************************************************
     C/EJECT
      ****************************************************************
      ** VCNCDSR - Validate country code
      *****************************************************************
     C     VCNCDSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Country Code
     C                   CALLB     'SDVCNCD'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Country Code
     C                   PARM                    DDCNCD
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Country Code       - OK
     C                   PARM                    DDCNCDOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      ****************************************************************
      ** VCNNMSR - Validate Country Name
      ****************************************************************
     C     VCNNMSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Country Name
     C                   CALLB     'SDVCNNM'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Country Code
     C                   PARM                    DDCNNM
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Country Name       - OK
     C                   PARM                    DDCNNMOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      ****************************************************************
      ** VISOCSR - Validate ISO country code
      *****************************************************************
     C     VISOCSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate ISO country code
     C                   CALLB     'SDVISOC'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** ISO country code
     C                   PARM                    DDISOC
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** ISO country code       - OK
     C                   PARM                    DDISOCOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      ****************************************************************
      ** VRGCDSR - Validate Region Code
      *****************************************************************
     C     VRGCDSR       BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Region code
     C                   CALLB     'SDVRGCD'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Region code
     C                   PARM                    DDRGCD
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Region code - OK
     C                   PARM                    DDRGCDOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      ****************************************************************
      ** VCTAYSR - Associated Currency
      *****************************************************************
     C     VCTAYSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Associated Currency
     C                   CALLB     'SDVCTAY'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Associated Currency
     C                   PARM                    DDCTAY
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Associated currency - OK
     C                   PARM                    DDCTAYOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      ****************************************************************
      ** VCTZPSR - ZIP Code
      ****************************************************************
     C     VCTZPSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate ZIP Code
     C                   CALLB     'SDVCTZP'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** ZIP Code
     C                   PARM                    DDCTZP
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** ZIP Code - OK
     C                   PARM                    DDCTZPOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      ****************************************************************
      ** VCTWCSR - Weighting code
      ****************************************************************
     C     VCTWCSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Weighting code
     C                   CALLB     'SDVCTWC'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** Weighting code
     C                   PARM                    DDCTWC
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Weighting code - OK
     C                   PARM                    DDCTWCOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      ****************************************************************
      ** VBBANSR - BBAN Total Length
      ****************************************************************
     C     VBBANSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate BBAN Total Length
     C                   CALLB     'SDVBBAN'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** BBAN total length
     C                   PARM                    DDBBAN
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** BBAN total length - OK
     C                   PARM                    DDBBANOK
     C                   PARM                    W#BBAN            2 0
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      ****************************************************************
      ** VBBRLSR - BBAN Bank Length
      ****************************************************************
     C     VBBRLSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate BBAN Bank Length
     C                   CALLB     'SDVBBRL'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** BBRL bank length
     C                   PARM                    DDBBRL
     C                   PARM                    W#BBAN
 
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** BBRL bank length - OK
     C                   PARM                    DDBBRLOK
 
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      ****************************************************************
      ** VETXYSR - ETXY End of Tax Year
      ****************************************************************
     C     VETXYSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate ETXY End of Tax Year
     C                   CALLB     'SDVETXY'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** ETXY End of Tax Year
     C                   PARM                    DDETXY
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** ETXY End of Tax Year - OK
     C                   PARM                    DDETXYOK
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      ****************************************************************
      ** VRPFQSR - RPFQ Reporting Frequency
      ****************************************************************
     C     VRPFQSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate RPFQ Reporting Frequency
     C                   CALLB     'SDVRPFQ'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** RPFQ Reporting Frequency
     C                   PARM                    DDRPFQ
      ** End of Tax Year
     C                   PARM                    DDETXY
      ** End of Tax Year OK
     C                   PARM                    DDETXYOK
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** RPFQ Reporting Frequency - OK
     C                   PARM                    DDRPFQOK
 
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      ****************************************************************
      **   VTXCYSR - TXCY Currency of Tax
      ****************************************************************
     C     VTXCYSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate TXCY Currency of Tax
     C                   CALLB     'SDVTXCY'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** TXCY Currency of Tax
     C                   PARM                    DDTXCY
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** TXCY Currency of Tax - OK
     C                   PARM                    DDTXCYOK
 
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      ****************************************************************
      **   VJAMGSR - JAMG Joint Account Management
      ****************************************************************
     C     VJAMGSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate JAMG Joint Account Management
     C                   CALLB     'SDVJAMG'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** JAMG Joint Account Management
     C                   PARM                    DDJAMG
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** JAMG Joint Account Management - OK
     C                   PARM                    DDJAMGOK
 
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      ****************************************************************
      **   VCTTXSR - CTTX Country of Tax(Y/N)
      ****************************************************************
     C     VCTTXSR       BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate CTTX Country of Tax(Y/N)
     C                   CALLB     'SDVCTTX'
      * Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
      ** CTTX Country of Tax(Y/N)
     C                   PARM                    DDCTTX
      ** Country Code
     C                   PARM                    DDCNCD
      *
      * Outputs
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** CTTX Country of Tax(Y/N) - OK
     C                   PARM                    DDCTTXOK
 
      *
      * Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      ******************************************************************
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
 
      ** Country Details
     C                   PARM                    TrnDets
     C                   PARM                    ExtData
      * Outputs
 
      ** Country Details OK inds
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
 
      * Valid Country details layout (DS) from/to caller
     C                   PARM                    ValidCNTY
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
     C                   EVAL      DBASE  =  900
     C                   EVAL      DBKEY  = @OPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
      *
      ** Check if switchable feature CFT004 is switched on.
      ** - International Bank Account Numbers Enhancement
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT004'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database Error
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = 'CFT004'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  =  902
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANK
     C                   MOVE      'Y'           CFT004            1
     C                   ELSE
     C                   MOVE      'N'           CFT004
     C                   ENDIF
 
      ** Check if switchable feature CGP001 is switched on.
      ** - Global Processing
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGP001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Database Error
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = 'CGP001'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  =  903
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANK
     C                   MOVE      'Y'           CGP001            1
     C                   ELSE
     C                   MOVE      'N'           CGP001
     C                   ENDIF
 
      ** Check if switchable feature CGL014 is switched on.
      ** - Collateral processing
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL014'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database Error
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = 'CGL014'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  =  904
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANK
     C                   MOVE      'Y'           CGL014            1
     C                   ELSE
     C                   MOVE      'N'           CGL014
     C                   ENDIF
 
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
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '905'         DBASE
     C                   EXSR      *PSSR
     C                   END
 
      ** Check if switchable feature CGL032 is switched on.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL032'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database Error
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = 'CGL032'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 906
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANK
     C                   MOVE      'Y'           CGL032            1
     C                   ELSE
     C                   MOVE      'N'           CGL032
     C                   ENDIF
      *
      ** Check if switchable feature CGL031 is switched on.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL031'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database Error
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = 'CGL031'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 907
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @RTCD = *BLANK
     C                   MOVE      'Y'           CGL031            1
     C                   ELSE
     C                   MOVE      'N'           CGL031
     C                   ENDIF
      *                                                                                     MD030956
      ** Check if switchable feature CTI006 is switched on.                                 MD030956
      *                                                                                     MD030956
     C                   CALLB     'AOSARDR0'                                               MD030956
     C                   PARM      *BLANKS       @RTCD                                      MD030956
     C                   PARM      '*VERIFY'     @OPTN                                      MD030956
     C                   PARM      'CTI006'      @SARD             6                        MD030956
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD030956
      *                                                                                     MD030956
      ** Database Error                                                                     MD030956
     C                   IF        @RTCD <> *BLANKS AND                                     MD030956
     C                             @RTCD <> '*NRF   '                                       MD030956
     C                   EVAL      DBKEY  = 'CTI006'                                        MD030956
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD030956
     C                   EVAL      DBASE  = 908                                             MD030956
     C                   EXSR      *PSSR                                                    MD030956
     C                   ENDIF                                                              MD030956
                                                                                            MD030956
     C                   IF        @RTCD = *BLANK                                           MD030956
     C                   MOVE      'Y'           CTI006            1                        MD030956
     C                   ELSE                                                               MD030956
     C                   MOVE      'N'           CTI006                                     MD030956
     C                   ENDIF                                                              MD030956
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SDCNTYV033
 
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
