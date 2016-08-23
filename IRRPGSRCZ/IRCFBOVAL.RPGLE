     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Fees/buy-outs validation controller (XC)')    *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCFBOVAL - Validate Fees/Buy-Outs/Processing Method/Next    *
      *              Principal Change Date Details (Cross Currency)   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. 245692             Date 11Dec13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 240134             Date 09Sep06               *
      *                 CSD027             Date 09Dec05               *
      *                 233467             Date 06Jun05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 222727             Date 05Nov03               *
      *                 CAP043             Date 02May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP041  *CREATE    Date 07Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  240134 - Pass CAP041 to IRVNPCD01.                           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  233467 - Pass Deal number to IRVNPCD01 for Principal Change  *
      *           schedule verification of 'Next Principal Change     *
      *           date'                                               *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,IRCFBOV001
 
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
 
      ** Transaction Details in screen format
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
 
      ** Transaction Details OK indicators
     D OKFEBO        E DS                  EXTNAME(IREFEBOPD)
 
      ** Valid Transaction Details layout
     D NwFBFilFmt    E DS                  EXTNAME(IRVCIRSPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
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
 
     D PSide           S              5A
     D POTI            S              1A
     D PWUCDP          S              1P 0
     D PWTCDP          S              1P 0
     D PWPSCY          S              3A
     D PWRSCY          S              3A
     D PWPNLOC         S              3A
     D PWRNLOC         S              3A
 
     D vDLNO           S              6A                                                      233467
                                                                                              233467
     D/COPY QWINDSRC,IRCIRSGDTA
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,IRCFBOV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      /COPY WNCPYSRC,IRCFBOV003
 
      *
      ** Validate Up-Front Fee Value Date
      *
      /COPY WNCPYSRC,IRCFBOV004
     C                   EXSR      SrVUpFFVD
      /COPY WNCPYSRC,IRCFBOV005
      *
 
 
      *
      ** Validate Up-Front Fee Amount
      *
      /COPY WNCPYSRC,IRCFBOV006
     C                   EXSR      SrVUpFFee
      /COPY WNCPYSRC,IRCFBOV007
      *
 
 
      *
      ** Validate Up-Front Fee Pay/Receive
      *
      /COPY WNCPYSRC,IRCFBOV008
     C                   EXSR      SrVUpFFPR
      /COPY WNCPYSRC,IRCFBOV009
      *
 
 
      *
      ** Validate Buy-Out Value Date
      *
      /COPY WNCPYSRC,IRCFBOV010
     C                   EXSR      SrVBuyOVD
      /COPY WNCPYSRC,IRCFBOV011
      *
 
 
      *
      ** Validate Buy-Out Amount
      *
      /COPY WNCPYSRC,IRCFBOV012
     C                   EXSR      SrVBuyOAm
      /COPY WNCPYSRC,IRCFBOV013
      *
 
 
      *
      ** Validate Buy-Out Amount Pay/Receive
      *
      /COPY WNCPYSRC,IRCFBOV014
     C                   EXSR      SrVBuyOPR
      /COPY WNCPYSRC,IRCFBOV015
      *
 
 
      *
      ** Validate Next Principal Change Date (Our)
      *
     C                   EVAL      POTI = 'O'
      /COPY WNCPYSRC,IRCFBOV016
     C                   EXSR      SrVNxtPCD
      /COPY WNCPYSRC,IRCFBOV017
      *
 
 
      *
      ** Validate Interest Processing Method (Our)
      *
     C                   EVAL      PSide = 'Our'
      /COPY WNCPYSRC,IRCFBOV018
     C                   EXSR      SrVIntPrM
      /COPY WNCPYSRC,IRCFBOV019
      *
 
 
      *
      ** Validate Next Principal Change Date (Their)
      *
     C                   EVAL      POTI = 'T'
      /COPY WNCPYSRC,IRCFBOV020
     C                   EXSR      SrVNxtPCD
      /COPY WNCPYSRC,IRCFBOV021
      *
 
 
      *
      ** Validate Interest Processing Method (Their)
      *
     C                   EVAL      PSide = 'Their'
      /COPY WNCPYSRC,IRCFBOV022
     C                   EXSR      SrVIntPrM
      /COPY WNCPYSRC,IRCFBOV023
      *
 
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRCFBOV024
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SrVIntPrM
      *****************************************************************
     C     SrVIntPrM     BEGSR
 
     ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Our Interest Processing Method
      *
     C                   CALLB     'IRVINPM01'
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** Side to be validated (Our/Their)
     C                   PARM                    PSide
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** FRA/IRS Amortisation of Caps, Collars, Floors & Individual
      ** Compounding Swaps
     C                   PARM                    CIR006
      *
      ** Overnight Index Swaps
     C                   PARM                    CIR007
      *
      ** OUTPUTS
      ** =======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal info passed from other programs
     C                   PARM                    Data
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SrVNxtPCD
      *****************************************************************
     C     SrVNxtPCD     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Next Principal Change Date
      *
     C                   CALLB     'IRVNPCD01'
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** OTHERS
      ** ======
      *
      ** Validate 'O'ur/'T'heir/'B'oth indicator
     C                   PARM                    POTI
      ** Deal Number                                                                          233467
     C                   PARM                    vDLNO                                        233467
      *                                                                                       233467
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** FRA/IRS Amortisation of Caps, Collars, Floors & Individual
      ** Compounding Swaps
     C                   PARM                    CIR006
     C**********         PARM                    CAP043                                CAP043 240134
     C                   PARM                    CAP041                                       240134
      *
      ** OUTPUTS
      ** =======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal info passed from calling programs
     C                   PARM                    Data
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SrVUpFFVD
      *****************************************************************
     C     SrVUpFFVD     BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Field3
      *
     C                   CALLB     'IRVUPVD01'
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** Settlement currency
      ** Receivers currency
     C                   PARM                    PWPSCY
     C                   PARM                    PWRSCY
      *
      ** Nostro Locations
     C                   PARM                    PWPNLOC
     C                   PARM                    PWRNLOC
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** SDLCCY - Location code
     C                   PARM                    BJLCCY
      *
      ** SDSLCD - System location code
     C                   PARM                    BJSLCD
      *
      ** OUTPUTS
      ** =======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal info passed from other programs
     C                   PARM                    Data
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SrVUpFFee
      *****************************************************************
     C     SrVUpFFee     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Up-Front Fee Amount
      *
     C                   CALLB     'IRVUPFE01'
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** OTHERS
      ** ======
      *
      ** Decimal Places based on Up-Front Pay/Receive (Our)
      ** Decimal Places based on Up-Front Pay/Receive (Their)
     C                   PARM                    PWUCDP
     C                   PARM                    PWTCDP
      *
      ** OUTPUTS
      ** =======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal info passed from calling programs
     C                   PARM                    Data
     C                   PARM                    BNDCSP                                       245692
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SrVUpFFPR
      *****************************************************************
     C     SrVUpFFPR     BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Field1
      *
     C                   CALLB     'IRVUPPR01'
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** OUTPUTS
      ** =======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal info passed from other programs
     C                   PARM                    Data
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SrVBuyOVD
      *****************************************************************
     C     SrVBuyOVD     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Buy-Ouy Value Date
      *
     C                   CALLB     'IRVBOVD01'
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Midas rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** OUTPUTS
      ** =======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal info passed from calling programs
     C                   PARM                    Data
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SrVBuyOAm
      *****************************************************************
     C     SrVBuyOAm     BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Field3
      *
     C                   CALLB     'IRVBOAM01'
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** Decimal Places based on Up-Front Pay/Receive (Our)
     C                   PARM                    PWUCDP
      *
      ** Decimal Places based on Up-Front Pay/Receive (Their)
     C                   PARM                    PWTCDP
      *
      ** OUTPUTS
      ** =======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal info passed from other programs
     C                   PARM                    Data
     C                   PARM                    BNDCSP                                       245692
      *
      ** Update error info with that returned from the validation module
      *
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** SrVBuyOPR
      *****************************************************************
     C     SrVBuyOPR     BEGSR
 
      ** Reset variables updated by validation
 
     C                   EXSR      RESETERRS
      *
      ** Validate Buy-Out Pay/Receive
      *
     C                   CALLB     'IRVBOPR01'
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** OUTPUTS
      ** =======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal info passed from calling programs
     C                   PARM                    Data
      *
      ** Update error info with that returned from the validation module
      *
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
      *
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
      *
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
      *
      ** INPUTS
      ** ======
      *
      * Response mode
     C                   PARM                    RespMode          1
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *                                                                                       233467
      ** Deal Number                                                                          233467
     C                   PARM                    vDLNO                                        233467
      *
      ** OTHERS
      ** ======
      *
      ** Decimal Places based on Up-Front Pay/Receive (Our)
      ** Decimal Places based on Up-Front Pay/Receive (Their)
     C                   PARM                    PWUCDP
     C                   PARM                    PWTCDP
      *
      ** Settlement currency
      ** Receivers currency
     C                   PARM                    PWPSCY
     C                   PARM                    PWRSCY
      *
      ** Nostro Locations
     C                   PARM                    PWPNLOC
     C                   PARM                    PWRNLOC
      *
      ** OUTPUTS
      ** =======
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
 
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
      *
      ** Deal info passed from calling programs
     C                   PARM                    Data
     C                   PARM                    BNDCSP            1                          245692
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBKEY  = POPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
      *
      ** Check if switchable feature CIR006 is switched on.
      ** Private Banking Securities Trading Enhancement
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR006'      PSARD             6
      *
      ** Database Error
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY  = 'CIR006'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  = 2
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANK
     C                   MOVE      'Y'           CIR006            1
     C                   ELSE
     C                   MOVE      'N'           CIR006
     C                   ENDIF
      *
      ** Check if switchable feature CIR007 is switched on.
      ** Overnight Index swaps
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR007'      PSARD
      *
     C                   IF        PRTCD = *BLANK
     C                   MOVE      'Y'           CIR007            1
     C                   ELSE
     C                   MOVE      'N'           CIR007
     C                   ENDIF
      *****************************************************************                CAP043 240134
      ***Check*if*switchable*feature*CAP043*is*switched*on*************                CAP043 240134
      *****************************************************************                CAP043 240134
     C**********         CALL      'AOSARDR0'                                          CAP043 240134
     C**********         PARM      *BLANKS       PRTCD                                 CAP043 240134
     C**********         PARM      '*VERIFY'     POPTN                                 CAP043 240134
     C**********         PARM      'CAP043'      PSARD                                 CAP043 240134
      *****************************************************************                CAP043 240134
     C**********         IF        PRTCD = *BLANK                                      CAP043 240134
     C**********         MOVE      'Y'           CAP043            1                   CAP043 240134
     C**********         ELSE                                                          CAP043 240134
     C**********         MOVE      'N'           CAP043                                CAP043 240134
     C**********         ENDIF                                                         CAP043 240134
      *                                                                                       240134
      ** Check if switchable feature CAP041 is switched on                                    240134
      *                                                                                       240134
     C                   CALL      'AOSARDR0'                                                 240134
     C                   PARM      *BLANKS       PRTCD                                        240134
     C                   PARM      '*VERIFY'     POPTN                                        240134
     C                   PARM      'CAP041'      PSARD                                        240134
      *                                                                                       240134
     C                   IF        PRTCD = *BLANK                                             240134
     C                   MOVE      'Y'           CAP041            1                          240134
     C                   ELSE                                                                 240134
     C                   MOVE      'N'           CAP041                                       240134
     C                   ENDIF                                                                240134
 
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRCFBOV025
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
 
     C                   EVAL      DBPGM = 'IRCFBOVAL'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
      *
      ** Terminate the program
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
(c) Misys International Banking Systems Ltd. 2002
