     H DEBUG
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2021')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Cum Rate Max Uncovered Bal')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVTCMPC - Validate Cum rate Max Uncovered  Bal              *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2021                 *
      *                                                               *
      *  Last Amend No. LUC139   *Create   Date 08Jan21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian returns upgrade to FM2.1                *
      *                                                               *
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving
      ** the size of the arrays.
      /COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------

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

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D Idx             S              3P 0
     D WIdx            S              3P 0
      ** Index for arrays of error message ids etc

     D DDTCMPC         S              9A
     D DDTLNIT         S              7A
     D DDTCMPCOK       S              1A
     D VPFCMPC         S              8S 3

     D PZRtnCde        S              1A
     D PZfld16A        S             16A
     D PZDec1P0        S              1P 0
     D PZDig2P0        S              2P 0

     D PZField         S             16A
     D PZADEC          S              1P 0

     D WNum8P3         S              8P 3
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** Initialization

     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx

     C                   EVAL      PZFld16A = *BLANKS

      ** Validation

     C                   EXSR      SRMAIN

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Main Validation routine                             *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR

      ** Verify if Numeric

     C                   MOVE      DDTCMPC       PZfld16A
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZRtnCde
     C                   PARM                    PZfld16A
     C                   PARM      3             PZDec1P0
     C                   PARM      5             PZDig2P0

     C                   IF        PZRtnCde = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTCMPC'
     C                   EVAL      MsgIdXAr(Idx)  = 'ITL3239'
     C                   EVAL      DDTCMPCOK      = 'N'
     C                   LEAVESR
     C                   ENDIF

     C                   MOVE      PZfld16A      WNum8P3

     C                   IF        WNum8P3 <> *ZERO AND
     C                             DDTLNIT  = *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTCMPC'
     C                   EVAL      MsgIdXAr(Idx)  = 'ITL3237'
     C                   EVAL      DDTCMPCOK      = 'N'
     C                   LEAVESR
     C                   ENDIF

     C                   IF        WNum8P3 = *ZERO
     C                   EVAL      DDTCMPC = *BLANKS
     C                   ELSE

     C                   CALLB     'ZEDIT'
     C                   PARM      PZFLD16A      PZField
     C                   PARM      3             PZADEC
     C                   MOVE      PZField       DDTCMPC

     C                   ENDIF

     C                   EVAL      VPFCMPC = WNUM8P3

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Inputs

     C                   PARM                    DDTCMPC
     C                   PARM                    DDTLNIT
     C                   PARM                    DDTCMPCOK

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFCMPC

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Systems Ltd. 2021
