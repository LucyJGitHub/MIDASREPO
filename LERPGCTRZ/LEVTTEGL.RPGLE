     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Effective Global Rate')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVTTEGL - Validate Effective Global Rate                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 08Jan21               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian returns upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
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

     D DDTTEGL         S              9A
     D DDTLNIT         S              7A
     D DDTTEGLOK       S              1A
     D VPFTEGL         S              8S 3

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

     C                   MOVE      DDTTEGL       PZfld16A
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZRtnCde
     C                   PARM                    PZfld16A
     C                   PARM      3             PZDec1P0
     C                   PARM      5             PZDig2P0

     C                   IF        PZRtnCde = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTTEGL'
     C                   EVAL      MsgIdXAr(Idx)  = 'ITL3236'
     C                   EVAL      DDTTEGLOK      = 'N'
     C                   LEAVESR
     C                   ENDIF

     C                   MOVE      PZfld16A      WNum8P3

     C                   IF        WNum8P3 <> *ZERO AND
     C                             DDTLNIT  = *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTTEGL'
     C                   EVAL      MsgIdXAr(Idx)  = 'ITL3234'
     C                   EVAL      DDTTEGLOK      = 'N'
     C                   LEAVESR
     C                   ENDIF

     C                   IF        WNum8P3 = *ZERO
     C                   EVAL      DDTTEGL = *BLANKS
     C                   ELSE

     C                   CALLB     'ZEDIT'
     C                   PARM      PZFLD16A      PZField
     C                   PARM      3             PZADEC
     C                   MOVE      PZField       DDTTEGL

     C                   ENDIF

     C                   EVAL      VPFTEGL = WNUM8P3

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

     C                   PARM                    DDTTEGL
     C                   PARM                    DDTLNIT
     C                   PARM                    DDTTEGLOK

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Warning fields/message IDs/message data (arrays) from/to
      ** caller

     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr

     C                   PARM                    VPFTEGL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
