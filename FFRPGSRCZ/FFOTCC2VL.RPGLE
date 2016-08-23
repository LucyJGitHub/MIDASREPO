     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Currency OTC validation')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFOTCC2VL - Validation controller for currency over-the-     *
      *              counter options.                                 *
      *                                                               *
      *  Function:  This module controls the transaction validation   *
      *             for currency OTC options.                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR798207A          Date 16Aug11               *
      *  Prev Amend No. AR798207           Date 13Jul11               *
      *                 CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 TDA037             Date 25Mar04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166             Date 15Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007  *CREATE    Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR798207A - Required fields in New Instrument Details Tab    *
      *  AR798207 - Required fields in New Instrument Details Tab     *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  TDA037 - Added parameters in calling FFVCNRK01.              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP166 - API for Non-Currency OTC                            *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,FFOTC2V001
 
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
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ Map variable names to indicators to allow use of names instead ¦
      ** ¦ of numbers; base the following data structure on a pointer to  ¦
      ** ¦ the indicator array.                                           ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                ¦
     D  LookupSucc            98     98
      ** ¦                                                                ¦
     D  NoRecFound            99     99
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     D TranIn        E DS                  EXTNAME(FFOTCCPD)
      ** Incoming transaction structure
 
      ** Incoming OTCO transaction structure                                                  CAP166
     D FFOTCO        E DS                  EXTNAME(FFOTCOPD)                                  CAP166
                                                                                              CAP166
     D ValidTran     E DS                  EXTNAME(FFVTRANPD)
      ** Valid transaction layout
 
     D OKFlagsDS     E DS                  EXTNAME(FFEOTCCPD)
      ** The OK flags for the transaction
 
      ** OK flags for OTCO transaction                                                        CAP166
     D FFEOTCO       E DS                  EXTNAME(FFEOTCOPD)                                 CAP166
     D                                     PREFIX(A)                                          CAP166
                                                                                              CAP166
     D InstTypes     E DS                  EXTNAME(INTYPD) PREFIX(IT)
      ** Instrument types
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** General Ledger ICD
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Midas modules flags
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  #ACCD1       E                     EXTFLD(QQACCD)                                     CGL029
      ** Futures and Options ICD
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Generic OK flag
     D GenOKFlag       S              1A   INZ('Y')
 
     ** Error array index
     D Idx             S              3P 0
 
     D NewInst         S              1A
                                                                                              CAP166
     D TransType       S              4A                                                      CAP166
                                                                                              CAP166
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      /COPY WNCPYSRC,FFOTC2V002
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset the fields specific to the VAL function
      ** ---------------------------------------------
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   EVAL      Idx = 0
 
      ** Load OTCO field to OTCC field                                                        CAP166
                                                                                              CAP166
     C                   IF        TransType = 'OTCO'                                         CAP166
     C                   EVAL      SCOVE = NCOVE                                              CAP166
     C                   EVAL      SHETR = NHETR                                              CAP166
     C                   EVAL      SBLUP = NBLUP                                              CAP166
     C                   EVAL      SUNSE = NUNSE                                              CAP166
     C                   EVAL      STECO = NTECO                                              CAP166
     C                   EVAL      STNAT = NTNAT                                              CAP166
     C                   EVAL      SCRIK = NCRIK                                              CAP166
     C                   EVAL      SCCYR = NCCYR                                              CAP166
     C                   EVAL      STWEI = NTWEI                                              CAP166
     C                   EVAL      SISTT = NISTT                                              CAP166
     C                   EVAL      SISPT = NISPT                                              TDA037
     C                   EVAL      SDCCY = NDCCY                                              TDA037
     C                   ENDIF                                                                CAP166
                                                                                              CAP166
      ** Call Validation Modules in Sequence
      ** -----------------------------------
 
      ** Validate PB fields
 
      /COPY WNCPYSRC,FFOTC2V003
      **--------------------*
      ** Covered Validation *
      **--------------------*
 
     C                   EXSR      SrCover
      /COPY WNCPYSRC,FFOTC2V004
 
      /COPY WNCPYSRC,FFOTC2V005
      **--------------------------*
      ** Hedged/Traded Validation *
      **--------------------------*
 
     C                   EXSR      SrHgTrd
      /COPY WNCPYSRC,FFOTC2V006
 
      /COPY WNCPYSRC,FFOTC2V007
      **---------------------------*
      ** Block Underlying Position *
      **---------------------------*
 
     C                   EXSR      SrBlkPs
      /COPY WNCPYSRC,FFOTC2V008
 
      /COPY WNCPYSRC,FFOTC2V009
      **---------------------*
      ** Underlying Security *
      **---------------------*
 
     C                   EXSR      SrUnSec
      /COPY WNCPYSRC,FFOTC2V010
 
      /COPY WNCPYSRC,FFOTC2V011
      **-----------------*
      ** Economic Sector *
      **-----------------*
 
     C                   EXSR      SrEcSct
      /COPY WNCPYSRC,FFOTC2V012
 
      /COPY WNCPYSRC,FFOTC2V013
      **-------------*
      ** Nature Code *
      **-------------*
 
     C                   EXSR      SrNtrCd
      /COPY WNCPYSRC,FFOTC2V014
 
      /COPY WNCPYSRC,FFOTC2V015
      **-----------------*
      ** Country of Risk *
      **-----------------*
 
     C                   EXSR      SrCtyRk
      /COPY WNCPYSRC,FFOTC2V016
 
      /COPY WNCPYSRC,FFOTC2V017
      **------------------*
      ** Currency of Risk *
      **------------------*
 
     C                   EXSR      SrCcyRk
      /COPY WNCPYSRC,FFOTC2V018
 
      /COPY WNCPYSRC,FFOTC2V019
      **----------------*
      ** Weighting Code *
      **----------------*
 
     C                   EXSR      SrWgtCd
      /COPY WNCPYSRC,FFOTC2V020
 
     C                   IF        Idx = 0
     C                   EXSR      SrValid
     C                   ENDIF
 
      ** Load OTCC field back to OTCO field                                                   CAP166
                                                                                              CAP166
     C                   IF        TransType = 'OTCO'                                         CAP166
     C                   EVAL      NCOVE = SCOVE                                              CAP166
     C                   EVAL      NHETR = SHETR                                              CAP166
     C                   EVAL      NBLUP = SBLUP                                              CAP166
     C                   EVAL      NUNSE = SUNSE                                              CAP166
     C                   EVAL      NTECO = STECO                                              CAP166
     C                   EVAL      NTNAT = STNAT                                              CAP166
     C                   EVAL      NCRIK = SCRIK                                              CAP166
     C                   EVAL      NCCYR = SCCYR                                              CAP166
     C                   EVAL      NTWEI = STWEI                                              CAP166
     C                   EVAL      NISPT = SISPT                                              TDA037
     C                   EVAL      NDCCY = SDCCY                                              TDA037
                                                                                              CAP166
     C                   EVAL      AOKCOVE = OKCOVE                                           CAP166
     C                   EVAL      AOKHETR = OKHETR                                           CAP166
     C                   EVAL      AOKBLUP = OKBLUP                                           CAP166
     C                   EVAL      AOKUNSE = OKUNSE                                           CAP166
     C                   EVAL      AOKTECO = OKTECO                                           CAP166
     C                   EVAL      AOKTNAT = OKTNAT                                           CAP166
     C                   EVAL      AOKCRIK = OKCRIK                                           CAP166
     C                   EVAL      AOKCCYR = OKCCYR                                           CAP166
     C                   EVAL      AOKTWEI = OKTWEI                                           CAP166
     C                   ENDIF                                                                CAP166
     C                                                                                        CAP166
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCover - Covered Validation                                  *
      *                                                               *
      *****************************************************************
 
     C     SrCover       BEGSR
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVCXPN01'
     C                   PARM                    ReturnCode
     C                   PARM                    SCOVE
     C                   PARM                    MsgIDXArr
     C                   PARM                    FldNamXArr
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKCOVE = GenOKFlag
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrHgTrd - Hedged/Traded Validation                            *
      *                                                               *
      *****************************************************************
 
     C     SrHgTrd       BEGSR
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVHGTR01'
     C                   PARM                    ReturnCode
     C                   PARM                    SHETR
     C                   PARM                    SCOVE
     C                   PARM                    MsgIDXArr
     C                   PARM                    FldNamXArr
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKHETR = GenOKFlag
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrBlkPs - Block Underlying Position                           *
      *                                                               *
      *****************************************************************
 
     C     SrBlkPs       BEGSR
 
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVBOUL01'
     C                   PARM                    ReturnCode
     C                   PARM                    SBLUP
     C                   PARM                    MsgIDXArr
     C                   PARM                    FldNamXArr
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKBLUP = GenOKFlag
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrUnSec - Underlying Security Validation                      *
      *                                                               *
      *****************************************************************
 
     C     SrUnSec       BEGSR
 
     C                   IF        NewInst = 'Y'
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVULSE01'
     C                   PARM                    ReturnCode
     C                   PARM                    SUNSE
     C                   PARM                    BGSECS
     C                   PARM                    MsgIDXArr
     C                   PARM                    FldNamXArr
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKUNSE = GenOKFlag
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrEcSct - Economic Sector Validation                          *
      *                                                               *
      *****************************************************************
 
     C     SrEcSct       BEGSR
 
     C**********         IF        NewInst = 'Y'                                            AR798207
     C**********         IF        (NewInst = 'Y' AND BGSECS = 'N')               AR798207 AR798207A
     C**********                   Or (NewInst = 'Y' AND BGSECS = 'Y' AND         AR798207 AR798207A
     C**********                       SUNSE <> *Blanks)                          AR798207 AR798207A
     C                   IF        NewInst = 'Y'                                           AR798207A
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVECSC01'
     C                   PARM                    ReturnCode
     C                   PARM                    STECO
     C                   PARM                    SUNSE
     C                   PARM                    BGSECS
     C                   PARM                    MsgIDXArr
     C                   PARM                    FldNamXArr
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKTECO = GenOKFlag
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrNtrCd - Nature Code Validation                              *
      *                                                               *
      *****************************************************************
 
     C     SrNtrCd       BEGSR
 
     C**********         IF        NewInst = 'Y'                                            AR798207
     C**********         IF        (NewInst = 'Y' AND BGSECS = 'N')               AR798207 AR798207A
     C**********                   Or (NewInst = 'Y' AND BGSECS = 'Y' AND         AR798207 AR798207A
     C**********                       SUNSE <> *Blanks)                          AR798207 AR798207A
     C                   IF        NewInst = 'Y'                                           AR798207A
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVNACD01'
     C                   PARM                    ReturnCode
     C                   PARM                    STNAT
     C                   PARM                    SUNSE
     C                   PARM                    BGSECS
     C                   PARM                    MsgIDXArr
     C                   PARM                    FldNamXArr
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKTNAT = GenOKFlag
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCtyRk - Country of Risk Validation                          *
      *                                                               *
      *****************************************************************
 
     C     SrCtyRk       BEGSR
 
     C**********         IF        NewInst = 'Y'                                            AR798207
     C**********         IF        (NewInst = 'Y' AND BGSECS = 'N')               AR798207 AR798207A
     C**********                   Or (NewInst = 'Y' AND BGSECS = 'Y' AND         AR798207 AR798207A
     C**********                       SUNSE <> *Blanks)                          AR798207 AR798207A
     C                   IF        NewInst = 'Y'                                           AR798207A
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVCYRK01'
     C                   PARM                    ReturnCode
     C                   PARM                    SCRIK
     C                   PARM                    SUNSE
     C                   PARM                    BGSECS
     C                   PARM                    MsgIDXArr
     C                   PARM                    FldNamXArr
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKCRIK = GenOKFlag
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrCcyRk - Currency of Risk Validation                         *
      *                                                               *
      *****************************************************************
 
     C     SrCcyRk       BEGSR
 
     C                   IF        NewInst = 'Y'
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVCNRK01'
     C                   PARM                    ReturnCode
     C                   PARM                    SCCYR
     C                   PARM                    SCRIK
     C                   PARM                    SISTT
     C                   PARM                    SISPT                                        TDA037
     C                   PARM                    SDCCY                                        TDA037
     C                   PARM                    MsgIDXArr
     C                   PARM                    FldNamXArr
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKCCYR = GenOKFlag
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrWgtCd - Weighting Code Validation                           *
      *                                                               *
      *****************************************************************
 
     C     SrWgtCd       BEGSR
 
     C**********         IF        NewInst = 'Y'                                            AR798207
     C**********         IF        (NewInst = 'Y' AND BGSECS = 'N')               AR798207 AR798207A
     C**********                   Or (NewInst = 'Y' AND BGSECS = 'Y' AND         AR798207 AR798207A
     C**********                       SUNSE <> *Blanks)                          AR798207 AR798207A
     C                   IF        NewInst = 'Y'                                           AR798207A
      ** Reset variables updated by each module before each call
     C                   EXSR      ResetErrs
 
      ** Weighting Code
     C                   CALLB     'FFVWGCD01'
     C                   PARM                    ReturnCode
     C                   PARM                    STWEI
     C                   PARM                    SUNSE
     C                   PARM                    BGSECS
     C                   PARM                    MsgIDXArr
     C                   PARM                    FldNamXArr
 
      ** Do the return code and error details handling
     C                   EXSR      HandleRet
     C                   EVAL      OKTWEI = GenOKFlag
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * AppendArrs - Append one field's error and warning details to  *
      *              the general error and warning arrays.            *
      *                                                               *
      *****************************************************************
 
     C     AppendArrs    BEGSR
 
     C                   CALLB     'APAPNDARRS'
      ** Outputs from called procedure
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Error array index (3,0P)
     C                   PARM                    Idx
      ** Field names with errors array (<ArrayMax> x 10A)
     C                   PARM                    FldNameArr
      ** Error message ID array (<ArrayMax> x 7A)
     C                   PARM                    MsgIDArr
      ** Error message data array (<ArrayMax> x 45A)
     C                   PARM                    MsgDtaArr
      ** Warning array index (3,0P)
     C                   PARM                    WIdx
      ** Field names with warnings array (<ArrayMax> x 10A)
     C                   PARM                    WFldNamArr
      ** Warning message ID array (<ArrayMax> x 7A)
     C                   PARM                    WMsgIDArr
      ** Warning message data array (<ArrayMax> x 45A)
     C                   PARM                    WMsgDtaArr
 
      ** Inputs to called procedure
      ** --------------------------
      ** Field name array (<ErrArrMax> x 10A)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A)
     C                   PARM                    MsgDtaXArr
      ** Field name array (<WArrMax> x 10A)
     C                   PARM                    FldNamWArr
      ** Warning message ID array (<WArrMax> x 7A)
     C                   PARM                    MsgIDWArr
      ** Warning message data array (<WArrMax> x 45A)
     C                   PARM                    MsgDtaWArr
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * HandleRet - Handle the return code and error details for      *
      *             each called procedure                             *
      *                                                               *
      *****************************************************************
 
     C     HandleRet     BEGSR
 
      ** Use the return code's value to set the field's OK flag
     C                   RESET                   GenOKFlag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    GenOKFlag
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      ** If the OK flag is blank, set it to 'Y'; this shouldn't normally
      ** happen, but is a fallback.
     C                   IF        GenOKFlag = ' '
     C                   EVAL      GenOKFlag = 'Y'
     C                   ENDIF
 
      ** If errors or warnings found, append error and warning details
      ** from this module to the overall error and warning arrays.
     C                   IF        ReturnCode <> *blanks
     C                   EXSR      AppendArrs
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ResetErrs - Reset or clear all error-related fields           *
      *                                                               *
      *****************************************************************
 
     C     ResetErrs     BEGSR
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx; and to warning message handling: WarnFound,
      ** FldNamWArr, MsgIDWArr, MsgDtaWArr, WIdx.
      ** It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrValid - All validated fields are placed in the valid file   *
      *                                                               *
      *****************************************************************
 
     C     SrValid       BEGSR
 
     C                   MOVEL     SCOVE         COVE
     C                   MOVEL     SHETR         HETR
     C                   MOVEL     SBLUP         BLUP
     C                   MOVEL     SUNSE         ITUNSE
     C                   MOVEL     STECO         ITTECO
     C                   MOVEL     STNAT         ITTNAT
     C                   MOVEL     SCRIK         ITCRIK
     C                   MOVEL     SCCYR         ITCCYR
     C                   MOVEL     STWEI         ITTWEI
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** Outputs
      ** -------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Field OK flags (data structure, from/to caller)
     C                   PARM                    OKFlagsDS
     C                   PARM                    FFEOTCO                                      CAP166
      ** Error array index (3,0P, from/to caller)
     C                   PARM                    Idx
      ** Field names in error array (<ArrayMax> x 10A, returned to caller)
     C                   PARM                    FldNameArr
      ** Error message ID array (<ArrayMax> x 7A, returned to caller)
     C                   PARM                    MsgIDArr
      ** Error message data array (<ArrayMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaArr
      ** Warning array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** Field names w/warnings array (<ArrayMax> x 10A, returned to caller)
     C                   PARM                    WFldNamArr
      ** Warning message ID array (<ArrayMax> x 7A, returned to caller)
     C                   PARM                    WMsgIDArr
      ** Warning message data array (<ArrayMax> x 45A, returned to caller)
     C                   PARM                    WMsgDtaArr
      ** Valid transaction layout (data structure, from/to caller)
     C                   PARM                    ValidTran
      ** Instrument details (DS based on INTYPD)
     C                   PARM                    InstTypes
 
      ** Inputs
      ** ------
      ** Transaction information (data structure, from source system)
     C                   PARM                    TranIn
     C                   PARM                    FFOTCO                                       CAP166
     C                   PARM                    NewInst
      ** Bank details (data structure based on SDBANKPD)
     C                   PARM                    SDBANK
      ** Module flags (data structure based on SDMMODPD)
     C                   PARM                    SDMMOD
      ** General Ledger ICD (data structure based on SDGELRPD
     C                   PARM                    SDGELR
      ** Futures and Options ICD (data structure based on SDFODAPD)
     C                   PARM                    SDFODA
      ** Transaction Type                                                                     CAP166
     C                   PARM                    TransType                                    CAP166
                                                                                              CAP166
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
