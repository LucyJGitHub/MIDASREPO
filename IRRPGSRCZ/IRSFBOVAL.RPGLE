     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Fees/Buy-Outs Validation controller')         *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRSFBOVAL - Fees/Buy-Outs Validation Controller              *
      *                                                               *
      *  Function: This module validates the IRS fees/buy-outs        *
      *            details for input to Midas Database.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. 245692             Date 11Dec13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 240134             Date 09Sep06               *
      *                 233467             Date 27May05               *
      *                 222373             Date 30Oct03               *
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
      *  233467 - Pass Deal number to IRVNPCD01 for Principal Change  *
      *           schedule verification of 'Next Principal Change     *
      *           date'                                               *
      *  222373 - Correct parameters on program calls                 *
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
      /COPY WNCPYSRC,IRSFBOV001
 
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
      *
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ZMUSER          DS            17
     D  USRBCH                11     13
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
 
     D/COPY QWINDSRC,IRSIRSGDTA
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,IRSFBOV002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,IRSFBOV003
 
      *
      ** Validate Up-Front Fee Value Date
      *
      /COPY WNCPYSRC,IRSFBOV004
     C                   EXSR      SrVUpFFVD
      /COPY WNCPYSRC,IRSFBOV005
      *
 
      *
      ** Validate Up-Front Fee Amount
      *
      /COPY WNCPYSRC,IRSFBOV006
     C                   EXSR      SrVUpFFee
      /COPY WNCPYSRC,IRSFBOV007
      *
 
      *
      ** Validate Up-Front Fee Pay/Receive
      *
      /COPY WNCPYSRC,IRSFBOV008
     C                   EXSR      SrVUpFFPR
      /COPY WNCPYSRC,IRSFBOV009
      *
 
      *
      ** Validate Buy-Out Value Date
      *
      /COPY WNCPYSRC,IRSFBOV010
     C                   EXSR      SrVBuyOVD
      /COPY WNCPYSRC,IRSFBOV011
      *
 
      *
      ** Validate Buy-Out Amount
      *
      /COPY WNCPYSRC,IRSFBOV012
     C                   EXSR      SrVBuyOAm
      /COPY WNCPYSRC,IRSFBOV013
      *
 
      *
      ** Validate Buy-Out Amount Pay/Receive
      *
      /COPY WNCPYSRC,IRSFBOV014
     C                   EXSR      SrVBuyOPR
      /COPY WNCPYSRC,IRSFBOV015
      *
 
      *
      ** Validate Next Principal Change Date (Our)
      *
     C                   EVAL      POTI = 'O'
      /COPY WNCPYSRC,IRSFBOV016
     C                   EXSR      SrVNxtPCD
      /COPY WNCPYSRC,IRSFBOV017
      *
 
      *
      ** Validate Interest Processing Method (Our)
      *
     C                   EVAL      PSide = 'Our'
      /COPY WNCPYSRC,IRSFBOV018
     C                   EXSR      SrVIntPrM
      /COPY WNCPYSRC,IRSFBOV019
      *
 
      *
      ** Validate Interest Processing Method (Their)
      *
     C                   EVAL      PSide = 'Their'
      /COPY WNCPYSRC,IRSFBOV020
     C                   EXSR      SrVIntPrM
      /COPY WNCPYSRC,IRSFBOV021
      *
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,IRSFBOV022
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrVIntPrM - Validate Interest Processing Method              *
      *                                                               *
      *****************************************************************
     C     SrVIntPrM     BEGSR
      *
      ** Reset variables updated by validation
      *
     C                   EXSR      SRResetErrs
      *
      ** Validate Interest Processing Method
      *
     C                   CALLB     'IRVINPM01'
      *                             =========
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
      ** Warning fields/message IDs/message data (arrays) from/to caller                      222373
     C                   PARM                    WFldNmXAr                                    222373
     C                   PARM                    WMsgIDXAr                                    222373
     C                   PARM                    WMsgDtXAr                                    222373
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal info passed from other programs
     C                   PARM                    Data
      *
      ** Update error info with that returned from the validation module
 
     C                   EXSR      SRUpdatErrs
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrVNxtPCD - Validate Next Principal Change Date              *
      *                                                               *
      *****************************************************************
     C     SrVNxtPCD     BEGSR
      *
      ** Reset variables updated by validation
      *
     C                   EXSR      SRResetErrs
      *
      ** Validate Next Principal Change Date
      *
     C                   CALLB     'IRVNPCD01'
      *                             =========
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
      ** Validate Our/Their indicator
     C                   PARM                    POTI
      *
      ** Deal number                                                                          233467
     C                   PARM                    vDLNO                                        233467
      *                                                                                       233467
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
      *
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
     C                   EXSR      SRUpdatErrs
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrVUpFFVD - Validate Up-Front Fee Value Date                 *
      *                                                               *
      *****************************************************************
     C     SrVUpFFVD     BEGSR
      *
      ** Reset variables updated by validation
      *
     C                   EXSR      SRResetErrs
      *
      ** Validate Up-Front Fee Value Date
      *
     C                   CALLB     'IRVUPVD01'
      *                             =========
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
 
     C                   EXSR      SRUpdatErrs
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrVUpFFee - Validate Up-Front Fee Amount                     *
      *                                                               *
      *****************************************************************
     C     SrVUpFFee     BEGSR
      *
      ** Reset variables updated by validation
      *
     C                   EXSR      SRResetErrs
      *
      ** Validate Up-Front Fee Amount
      *
     C                   CALLB     'IRVUPFE01'
      *                             =========
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
      *
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
     C                   EXSR      SRUpdatErrs
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrVUpFFPR - Validate Up-front Fee Pay/Receive                *
      *                                                               *
      *****************************************************************
     C     SrVUpFFPR     BEGSR
      *
      ** Reset variables updated by validation
      *
     C                   EXSR      SRResetErrs
      *
      ** Validate Up-front Fee Pay/Receive
      *
     C                   CALLB     'IRVUPPR01'
      *                             =========
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
 
     C                   EXSR      SRUpdatErrs
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrVBuyOVD - Validate Buy-Out Value Date                      *
      *                                                               *
      *****************************************************************
     C     SrVBuyOVD     BEGSR
      *
      ** Reset variables updated by validation
      *
     C                   EXSR      SRResetErrs
      *
      ** Validate Buy-Ouy Value Date
      *
     C                   CALLB     'IRVBOVD01'
      *                             =========
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
      *
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
     C                   EXSR      SRUpdatErrs
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrVBuyOAm - Validate Buy-Out Amount                          *
      *                                                               *
      *****************************************************************
     C     SrVBuyOAm     BEGSR
      *
      ** Reset variables updated by validation
      *
     C                   EXSR      SRResetErrs
      *
      ** Validate Buy-Out Amount
      *
     C                   CALLB     'IRVBOAM01'
      *                             =========
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
 
     C                   EXSR      SRUpdatErrs
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrVBuyOPR - Validate Buy-Out Pay/Receive                     *
      *                                                               *
      *****************************************************************
     C     SrVBuyOPR     BEGSR
      *
      ** Reset variables updated by validation
      *
     C                   EXSR      SRResetErrs
      *
      ** Validate Buy-Out Pay/Receive
      *
     C                   CALLB     'IRVBOPR01'
      *                             =========
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
      ** Deal info passed from calling programs
     C                   PARM                    Data
      *
      ** Update error info with that returned from the validation module
      *
 
     C                   EXSR      SRUpdatErrs
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErrs - Routine to reset Error Information that is     *
      *                received from each validation module           *
      *                                                               *
      *****************************************************************
     C     SRResetErrs   BEGSR
 
     C                   EVAL      RetCodeOut = *Blanks
      *
      ** Reset error & warning fields/message IDs/message data (arrays)
      *
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
      *  SRUpdatErrs - Routine to update Error Information with that  *
      *                received back from each validation module      *
      *                                                               *
      *****************************************************************
     C     SRUpdatErrs   BEGSR
      *
      ** Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          01
     C                   IF        *IN01
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
      *
      ** Set Error Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          01
     C     I             SUB       1             Idx
      *
      ** Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          01
     C                   IF        *IN01
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
      *
      ** Set Warning Index
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          01
     C     I             SUB       1             WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,IRSFBOV023
 
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
     C                   EVAL      DBPGM = 'IRSFBOVAL'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
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
(c) Misys International Banking Systems Ltd. 2002
