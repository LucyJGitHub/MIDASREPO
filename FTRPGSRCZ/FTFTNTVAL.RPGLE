     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Nostro Transfer Validation')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTFTNTVAL - Nostro Transfer Details Validation               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CAP212  *CREATE    Date 15Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP212 - FT Nostro Transfer API                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
      ** Transfer Details in screen format
     D TrnDets       E DS                  EXTNAME(FTFTNTPD)
     D  InterBanks            63    309
     D  BanktoBankInf        310    449
 
      ** Transfer Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(FTEFTNTPD)
 
      ** Valid Transfer Details layout
     D ValidNoTr     E DS                  EXTNAME(FTVFTNTPD)
 
      ** Extra Data
     D ExtData       E DS                  EXTNAME(FTFTEXPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
     D I               S              3  0
     D RespMode        S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Validate Transfer Sub-Type
 
     C                   EXSR      VTransSubType
 
      ** Validate Booking Branch
 
     C                   EXSR      VBookBranch
 
      ** Validate Settlement Type
 
     C                   EXSR      VSettType
 
      ** Validate Swift Priority Code
 
     C                   EXSR      VSwftPrCode
 
      ** Validate Originating Branch
 
     C                   EXSR      VOrigBranch
 
      ** Validate Book Code
 
     C                   EXSR      VBookCode
 
      ** Validate Currency
 
     C                   EXSR      VCurrency
 
      ** Validate Value Date
 
     C                   EXSR      VValueDate
 
      ** Validate From Nostro
 
     C                   EXSR      VFromNostro
 
      ** Validate ToNostro
 
     C                   EXSR      VToNostro
 
      ** Validate Profit Centre if to nostro is valid
 
     C                   IF        NVDEST <> 0
     C                   EXSR      VProfitCtr
     C                   ENDIF
 
      ** Validate Transfer Amount
 
     C                   EXSR      VTransAmt
 
      ** Validate Intermediary if not blank
 
     C                   IF        InterBanks <> *BLANKS
     C                   EXSR      VInterBank
     C                   ENDIF
 
      ** Validate Bank to Bank Info if not blank
 
     C                   IF        BanktoBankInf <> *BLANKS
     C                   EXSR      VBankToBank
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTransSubType - Validate Transfer Sub-Type
      *****************************************************************
     C     VTransSubType BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Transfer Sub-Type
 
     C                   CALLB     'FTVTFST'
      *
      * Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBookBranch - Validate Booking Branch
      *****************************************************************
     C     VBookBranch   BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Booking Branch
 
     C                   CALLB     'FTVBBRC'
      *
      * Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VSettType - Validate Settlement Type
      *****************************************************************
     C     VSettType     BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Settlement Type
 
     C                   CALLB     'FTVSTMT'
      *
      * Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VSwftPrCode - Validate Swift Priority Code
      *****************************************************************
     C     VSwftPrCode   BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Swift Priority Code
 
     C                   CALLB     'FTVSWFT'
      *
      * Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VOrigBranch - Validate Originating Branch
      *****************************************************************
     C     VOrigBranch   BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Originating Branch
 
     C                   CALLB     'FTVOBRC'
      *
      * Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBookCode - Validate Book Code
      *****************************************************************
     C     VBookCode     BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Book Code
 
     C                   CALLB     'FTVBOKC'
      *
      * Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCurrency - Validate Currency
      *****************************************************************
     C     VCurrency     BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Currency
 
     C                   CALLB     'FTVCURR'
      *
      * Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VFromNostro - Validate From Nostro
      *****************************************************************
     C     VFromNostro   BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate From Nostro
 
     C                   CALLB     'FTVFNOS'
      *
      * Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VToNostro - Validate To Nostro
      *****************************************************************
     C     VToNostro     BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate To Nostro
 
     C                   CALLB     'FTVTNOS'
      *
      * Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VProfitCtr - Validate Profit Centre
      *****************************************************************
     C     VProfitCtr    BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Profit Centre
 
     C                   CALLB     'FTVPRFC'
      *
      * Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VTransAmt - Validate Transfer Amount
      *****************************************************************
     C     VTransAmt     BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Transfer Amount
 
     C                   CALLB     'FTVAMNT'
      *
      * Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VValueDate - Validate Value Date
      *****************************************************************
     C     VValueDate    BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Value Date
 
     C                   CALLB     'FTVVDAT'
      *
      * Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VInterBank - Validate Intermediary Bank
      *****************************************************************
     C     VInterBank    BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Intermediary Bank
 
     C                   CALLB     'FTVINTB'
      *
      * Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr
 
      * Update error info with that returned from the validation module
 
     C                   EXSR      UPDATERRS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBankToBank - Validate Bank to Bank Info
      *****************************************************************
     C     VBankToBank   BEGSR
 
      * Reset variables updated by validation
 
     C                   EXSR      RESETERRS
 
      ** Validate Bank to Bank Info
 
     C                   CALLB     'FTVBTBI'
      *
      * Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** OK Flags
     C                   PARM                    OKTrnDets
      *
      ** Validation Fields
     C                   PARM                    ValidNoTr
 
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
 
     C                   EVAL      ReturnCode = *Blanks
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
     C                   Z-ADD     1             I
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
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Inputs
 
      * Response mode
     C                   PARM                    RespMode
 
      ** Transaction Details
     C                   PARM                    TrnDets
 
      ** Extra Data
     C                   PARM                    ExtData
 
      * Outputs
 
      ** Transaction Details OK inds
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
 
      * Valid Transaction details layout (DS) from/to caller
     C                   PARM                    ValidNoTr
      *
      *
      **------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **------------------------------------------------------------------
 
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
