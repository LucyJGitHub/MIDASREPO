     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Effective Date')                     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVEFDT - Validate Effective Date                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CRE075  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE075 - Effective Date for Retail Accounts                  *
      *                                                               *
      *****************************************************************
      *****************************************************************
     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)
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
 
      ** External data structure for branch codes file
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D ErrorFlag       S              1A
     D WWEfDt          S              5P 0
 
     D PDateIn2        S              5P 0
     D PCurrency       S              3A
     D PLocation       S              3A
     D PHolInd         S              1A
     D KCNUM           S                   LIKE(DDCUSN)
     D KCCY            S                   LIKE(DDCCY)
     D KACOD           S             10S 0
     D KACSQ           S              2S 0
     D KBRCA           S                   LIKE(DDBRCA)
 
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
 
     C                   EVAL      RetCodeIn = *BLANK
     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   EVAL      Idx       = 0
     C                   EVAL      WIdx      = 0
 
     C                   EXSR      SrEfDt
 
      ** If an error was found, set the return code appropriately.
 
     C                   IF        DDEfdtOK = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrEfDt-  Validate Effective Date for Retail Accounts         *
      *****************************************************************
     C     SrEfDt        BEGSR
 
      ** Proceed if Retail Account
 
     C                   IF        WWRETL = 'Y' AND DDACTN <> 'D'
 
      ** Effective Date field must be either a valid date or blank.
      ** If left blank, Effective Date field will default to the
      ** 'Date Account Opened'.
 
     C                   IF        DDEFDT = *BLANKS
     C                   EVAL      DDEFDT = DDDACO
     C                   EVAL      WWEfDt = WWDaco
 
     C                   ELSE
 
     C                   CALLB     'ZDATE1'
     C                   PARM      DDEFDT        DateIn
     C                   PARM      *Zero         DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
      ** Effective Date is not a valid date.
 
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      DDEFDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDEfDt    '
     C                   EVAL      MsgIdXAr(Idx) = 'RE77114'
     C                   ELSE
 
      ** Effective Date is a valid date.
 
     C                   EVAL      WWEfdt = DaynoOut
 
     C                   IF        DDACTN = 'A'
      ** Once Effective Date has been reached it cannot be amended.
 
     C     CHKACC        KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KCCY
     C                   KFLD                    KACOD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
 
     C                   MOVEL     DDCUSN        KCNUM
     C                   MOVEL     DDCCY         KCCY
     C                   MOVEL     DDACOD        KACOD
     C                   MOVEL     DDACSQ        KACSQ
     C                   MOVEL     DDBRCA        KBRCA
 
     C     CHKACC        CHAIN     ACCNTABF
 
     C                   IF        %FOUND(ACCNTL0)
     C                   IF        WWEfdt <> ACEFDT  AND
     C                             ACEFDT <= BJRDNB
 
     C                   EVAL      DDEFDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDEfDt    '
     C                   EVAL      MsgIdXAr(Idx) = 'RE77116'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Effective Date must not be earlier than Date Account Opened.
 
     C                   IF        DDEFDTOK = 'Y'
     C                   IF        WWEfdt < WWDaco
     C                   EVAL      DDEFDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDEfDt    '
     C                   EVAL      MsgIdXAr(Idx) = 'RE77115'
     C                   ENDIF
     C                   ENDIF
 
      ** Check if entered ED is holiday in account currency
 
     C                   IF        DDEFDTOK = 'Y'
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    DDBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   CALLB     'ZCHKH'
     C                   PARM      WWEfdt        PDateIn2
     C                   PARM      DDCCY         PCurrency
     C                   PARM      A8LCCD        PLocation
     C                   PARM      *BLANK        PHolInd
 
      ** Issue warning message if Effective Date is a holiday.
      ** 'Warning: Effective Date is a holiday in Local ccy or Account ccy.
 
     C                   IF        PHolInd = 'H'
     C                   EVAL      DDEFDTOK = 'W'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WFldNmXAr(WIdx) = 'DDEfDt    '
     C                   EVAL      WMsgIDXAr(WIdx) = 'RE77119'
 
     C                   ELSE
 
      ** Check if entered ED is holiday in local currency
 
     C                   CALLB     'ZCHKH'
     C                   PARM      WWEfdt        PDateIn2
     C                   PARM      BJLCCY        PCurrency
     C                   PARM      BJSLCD        PLocation
     C                   PARM      *BLANK        PHolInd
 
      ** Issue warning message if Effective Date is a holiday.
      ** 'Warning: Effective Date is a holiday in Local ccy or Account ccy.
 
     C                   IF        PHolInd = 'H'
     C                   EVAL      DDEFDTOK = 'W'
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WFldNmXAr(WIdx) = 'DDEfDt    '
     C                   EVAL      WMsgIDXAr(WIdx) = 'RE77119'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
      ** Field(s) requiring validation
 
     C                   PARM                    DDACTN            1
     C                   PARM                    DDDACO            6
     C                   PARM                    DDEFDT            6
     C                   PARM                    DDCCY             3
     C                   PARM                    DDBRCA            3
     C                   PARM                    WWRETL            1
     C                   Parm                    WWDAcO            5 0
 
      ** ICD
 
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    BJBVPD            3 0
     C                   PARM                    BJLCCY            3
     C                   PARM                    BJSLCD            3
 
      ** Account Key
 
     C                   PARM                    DDCUSN            6
     C                   PARM                    DDACOD           10
     C                   PARM                    DDACSQ            2
 
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
 
      ** Effective Date work field
 
     C                   PARM                    WWEfDt
 
      ** Effective Date - Ok
 
     C                   PARM                    DDEFDTOK          1
 
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
**  CPY@
(c) Misys International Banking Systems Ltd. 2011
