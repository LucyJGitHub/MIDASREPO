     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate Plato screen for non-ccy OTC')       *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVPLTOIN - Validate Plato Screen                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP166  *CREATE    Date 15Oct01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP166 - API for Non-Currency OTC                            *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
 
      ** Incoming transaction structure
     D TranIn        E DS                  EXTNAME(FFOTCOPD)
 
      ** The OK flags for the transaction
     D OKFlagsDS     E DS                  EXTNAME(FFEOTCOPD)
 
      ** Valid transaction layout
     D ValidTran     E DS                  EXTNAME(FFVTRANPD)
     D                                     PREFIX(V)
 
      ** Instrument types
     D InstTypes     E DS                  EXTNAME(INTYPD) PREFIX(IT)
 
      ** Data structure for term to maturity date
     D WMITMDS         DS             4
     D  WTerm                  1      3A
     D  WSign                  4      4A
     D  WVar1                  1      1A
     D  WVar2                  2      2A
     D  WVar3                  3      3A
     D  WVar4                  4      4A
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Parameters for ZALIGN and ZEDIT
     D PZAlignOk       S              1A
     D PZField         S             16A
     D PZADEC          S              1P 0
     D PZADIG          S              2P 0
 
      ** Parameters for ZDATE1
     D PDateAIn        S              6A
     D PDaynoOut       S              5P 0
     D PBJDFIN         S              1A
     D ErrorFlag       S              1A
 
     D PBKEURO         S              3A
 
      ** Generic OK flag
     D GenOKFlag       S              1A   INZ('Y')
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   EVAL      RetCodeIn = *BLANKS
 
     C                   EVAL      FldNameArr = *BLANKS
     C                   EVAL      MsgIDArr = *BLANKS
     C                   EVAL      MsgDtaArr = *BLANKS
     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0
 
      ** Validate plato screen
 
     C                   EXSR      SRValidate
 
      ** Return
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SRValidate - Validate Plato Screen                            *
      *****************************************************************
     C     SRValidate    BEGSR
 
     C                   IF        NISPT = '4'
 
      ** Validate Underlying Instrument details
      ** ======================================
 
      ** Validate Instrument type
      ** ------------------------
 
     C                   IF        NMIIT <> 'B' and NMIIT <> 'D' and
     C                             NMIIT <> 'L'
     C                   EVAL      OKMIIT = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NMIIT     '
     C                   EVAL      MsgIdArr(Idx) = 'MMA1230'
     C                   ELSE
     C                   EVAL      ITPLMIIT = NMIIT
     C                   ENDIF
 
      ** If instrument type is Bond, then only maturity date is allowed
 
     C                   IF        NMIIT = 'B'
 
     C                   IF        NMITM <> *BLANKS
     C                   EVAL      OKMITM = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NMITM     '
     C                   EVAL      MsgIdArr(Idx) = 'MMA1211'
     C                   ENDIF
 
      ** Validate maturity date
      ** ----------------------
 
     C                   EXSR      SRValMD
 
     C                   ELSE
 
      ** Maturity date should be blank
 
     C                   IF        NMITD <> *BLANKS
     C                   EVAL      OKMITD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NMITD     '
     C                   EVAL      MsgIdArr(Idx) = 'MMA1212'
     C                   ENDIF
 
      ** Validate underlying term to maturity
      ** ------------------------------------
 
     C                   EXSR      SRValTrmMat
 
     C                   ENDIF
 
      ** Underlying coupon and related underlying coupon frequency only
      ** valid for underlying instrument type = 'B' & 'D'
 
      ** Validate underlying coupon
      ** --------------------------
     C                   Z-ADD     7             PZADEC
     C                   Z-ADD     4             PZADIG
     C                   EVAL      PZField = *BLANKS
     C                   MOVE      NMICP         PZField
     C                   EXSR      SRZAlign
 
     C                   IF        PZAlignOk = 'N'
     C                   EVAL      OKMICP = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NMICP     '
     C                   EVAL      MsgIdArr(Idx) = 'MMA1213'
     C                   ELSE
     C                   MOVE      PZField       ITPLMICP
     C                   EXSR      SRZEdit
     C                   MOVE      PZField       NMICP
     C                   ENDIF
 
      ** Validate coupon frequency
      ** -------------------------
 
     C                   IF        NMICF = 'M' or NMICF = 'Q' or
     C                             NMICF = 'X' or NMICF = 'Y' or
     C                             NMICF = ' '
     C                   EVAL      ITPLMICF = NMICF
     C                   ELSE
     C                   EVAL      OKMICF = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NMICF     '
     C                   EVAL      MsgIdArr(Idx) = 'MMA1231'
     C                   ENDIF
 
      ** Entry on underlying coupon and related underlying coupon frequency
      ** is not allowed if underlying instrument type = 'L' ('Bill')
 
     C                   IF        NMIIT = 'L'
 
     C                   IF        ITPLMICP <> 0
     C                   EVAL      OKMICP = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NMICP     '
     C                   EVAL      MsgIdArr(Idx) = 'MMA1232'
     C                   EVAL      ITPLMICP = 0
     C                   ENDIF
 
     C                   IF        NMICF <> *BLANK
     C                   EVAL      OKMICF = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NMICF     '
     C                   EVAL      MsgIdArr(Idx) = 'MMA1233'
     C                   EVAL      ITPLMICF = NMICF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Endif for NISPT = '4'
 
     C                   ENDIF
 
      ** Validate spot price
      ** -------------------
 
     C                   EXSR      SRVSpotPr
 
      ** Validate price convention indicator
      ** -----------------------------------
 
     C                   IF        NISPT = '4' and NMIPC <> 'P' and
     C                             NMIPC <> 'F'
     C                   EVAL      OKMIPC = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NMIPC     '
     C                   EVAL      MsgIdArr(Idx) = 'MMA1234'
     C                   ELSE
     C                   EVAL      ITPLMIPC = NMIPC
     C                   ENDIF
 
      ** Validate volatility type
      ** ------------------------
 
     C                   SELECT
     C                   WHEN      NISPT = '6' and NMIVT <> 'P'
     C                   EVAL      OKMIVT = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NMIVT     '
     C                   EVAL      MsgIdArr(Idx) = 'MMA1235'
 
     C                   WHEN      NMIVT <> 'P' and NMIVT <> 'Y'
     C                   EVAL      OKMIVT = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NMIVT     '
     C                   EVAL      MsgIdArr(Idx) = 'MMA1236'
 
     C                   OTHER
     C                   EVAL      ITPLMIVT = NMIVT
 
     C                   ENDSL
 
      ** Validate pricing method
      ** -----------------------
 
     C                   IF        NMIPM <> 'B' and NMIPM <> 'S'
     C                   EVAL      OKMIPM = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NMIPM     '
     C                   EVAL      MsgIdArr(Idx) = 'MMA1237'
     C                   ELSE
     C                   EVAL      ITPLMIPM = NMIPM
     C                   ENDIF
 
      ** Default pricing group code, reporting group or credit rating
      ** if any of these fields are blank
 
     C                   IF        NMIPG = *BLANKS
     C                   EVAL      NMIPG = NISCY + 'Midas'
     C                   ENDIF
 
     C                   IF        NMIRG = *BLANKS
     C                   EVAL      NMIRG = 'Midas'
     C                   ENDIF
 
     C                   IF        NMICR = *BLANKS
     C                   EVAL      NMICR = 'AAA'
     C                   ENDIF
 
     C                   EVAL      ITPLMIPG = NMIPG
     C                   EVAL      ITPLMIRG = NMIRG
     C                   EVAL      ITPLMICR = NMICR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValMD  - Validate Maturity Date                            *
      *                                                               *
      *****************************************************************
 
     C     SRValMD       BEGSR
 
     C                   EVAL      PDateAIn = NMITD
     C                   EXSR      SRZDate1
 
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      OKMITD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NMITD     '
     C                   EVAL      MsgIdArr(Idx) = 'MMM0128'
     C                   ELSE
     C                   EVAL      ITPLMIMD = PDaynoOut
 
     C                   ENDIF
 
      ** Maturity date must not be after the instrument's final transaction
      ** date (only if final transaction date  - expiry date - not in error)
 
     C                   IF        ITPLMIMD > ITFTDT AND OKMITD = 'Y'
     C                   EVAL      OKMITD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NMITD     '
     C                   EVAL      MsgIdArr(Idx) = 'MMA1238'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValTrmMat - Validate Term to Maturity                      *
      *                                                               *
      *****************************************************************
 
     C     SRValTrmMat   BEGSR
 
     C                   EVAL      WMITMDS  = NMITM
 
      ** Right align the input field if it is non blank.
 
     C                   IF        NMITM <> *BLANKS
 
     C                   DOW       WVar4 = *BLANKS
     C                   EVAL      WVar4 = WVar3
     C                   EVAL      WVar3 = WVar2
     C                   EVAL      WVar2 = WVar1
     C                   EVAL      WVar1 = *BLANKS
     C                   ENDDO
 
     C                   Z-ADD     0             PZADEC
     C                   Z-ADD     3             PZADIG
     C                   EVAL      PZField = *BLANKS
     C                   MOVE      WTerm         PZField
     C                   EXSR      SRZAlign
 
     C                   IF        PZAlignOk = 'N'
     C                   EVAL      OKMITM = 'N'
     C                   ELSE
     C                   MOVE      PZField       WTerm
 
      ** WTerm cannot be zero.
 
     C                   IF        WTerm = '000'
     C                   EVAL      OKMITM = 'N'
     C                   ELSE
 
      ** WSign must be 'D' or 'M' or 'Y' only
 
     C                   IF        WSign <> 'D' and WSign <> 'M' and
     C                             WSign <> 'Y'
     C                   EVAL      OKMITM = 'N'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        OKMITM = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'NMITM     '
     C                   EVAL      MsgIdArr(Idx) = 'MMA1239'
     C                   ELSE
     C                   EVAL      ITPLMITM = NMITM
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVSpotPr - Validate spot price                              *
      *                                                               *
      *****************************************************************
 
     C     SRVSpotPr     BEGSR
 
     C                   EXSR      ResetErrs
 
     C                   CALLB     'FFVOTCSPT'
 
      ** Parameters returned to caller
      ** -----------------------------
 
      ** Return code (10A, returned to caller)
 
     C                   PARM                    ReturnCode
 
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Numeric (file) version of spot price (15,8P)
 
     C                   PARM                    VPLSPTP
 
      ** Parameters received from caller
      ** -------------------------------
 
      ** Spot price (16A, from transaction)
 
     C                   PARM                    NMSPT
 
      ** The INTYPD format (DS, several fields required)
      ** Strike price (15,8)
      ** Counter amount (13,0S, from transaction)
      ** Delivery amount (13,0S, from transaction)
      ** Delivery Currency (3A, from transaction)
      ** Counter  Currency (3A, from transaction)
      ** Euro Currency Code (3A, from SDGELRPD)
      ** Transaction Value Date (5,0 in Midas date Format)
 
     C                   PARM                    InstTypes
     C                   PARM                    VSTRP
     C                   PARM                    ITCCAM
     C                   PARM                    ITCTAM
     C                   PARM                    NDCCY
     C                   PARM                    ITCTCY
     C                   PARM                    PBKEURO
     C                   PARM                    VVALD
 
      ** Do the return code and error details handling
 
     C                   EXSR      HandleRet
     C                   EVAL      OKMSPT = GenOKFlag
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAlign - Validate numeric fields                           *
      *                                                               *
      *****************************************************************
 
     C     SRZAlign      BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZAlignOk
     C                   PARM                    PZField
     C                   PARM                    PZADEC
     C                   PARM                    PZADIG
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZEdit  - Format numeric fields for output                  *
      *                                                               *
      *****************************************************************
 
     C     SRZEdit       BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZField
     C                   PARM                    PZADEC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate1 - Validate and convert date to day number           *
      *                                                               *
      *****************************************************************
 
     C     SRZDate1      BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PDateAIn
     C                   PARM      *ZERO         PDaynoOut
     C                   PARM                    PBJDFIN
     C                   PARM      *BLANK        ErrorFlag
 
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
      ** Field names with errors array (<ArrayMax> x 10A)
      ** Error message ID array (<ArrayMax> x 7A)
      ** Error message data array (<ArrayMax> x 45A)
 
     C                   PARM                    Idx
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      ** Warning array index (3,0P)
      ** Field names with warnings array (<ArrayMax> x 10A)
      ** Warning message ID array (<ArrayMax> x 7A)
      ** Warning message data array (<ArrayMax> x 45A)
 
     C                   PARM                    WIdx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
      ** Inputs to called procedure
      ** --------------------------
 
      ** Field name array (<ErrArrMax> x 10A)
      ** Error message ID array (<ErrArrMax> x 7A)
      ** Error message data array (<ErrArrMax> x 45A)
 
     C                   PARM                    FldNamXArr
     C                   PARM                    MsgIDXArr
     C                   PARM                    MsgDtaXArr
 
      ** Field name array (<WArrMax> x 10A)
      ** Warning message ID array (<WArrMax> x 7A)
      ** Warning message data array (<WArrMax> x 45A)
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
 
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
      /COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
 
      ** Input parameters
      ** ----------------
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Transaction information (data structure, from source system)
 
     C                   PARM                    TranIn
 
      ** Euro Currency code (from SDGELRPD)
      ** Date Format indicator (from SDBANKPD)
 
     C                   PARM                    PBKEURO
     C                   PARM                    PBJDFIN
 
      ** Ouput parameters
      ** ----------------
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Error array index (3,0P, from/to caller)
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Warning array index (3P0) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
      ** Field OK flags (data structure, from/to caller)
 
     C                   PARM                    OKFlagsDS
 
      ** Valid transaction layout (data structure, from/to caller)
      ** Instrument details (DS based on INTYPD)
 
     C                   PARM                    ValidTran
     C                   PARM                    InstTypes
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
