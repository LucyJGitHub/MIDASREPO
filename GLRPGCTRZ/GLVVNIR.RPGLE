     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Interest Fixing Indicator')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVVNIR - Validate Interest Fixing Indicator                 *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CRE015  *CREATE    Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *                                                               *
      *****************************************************************
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D XArrayMax       C                   CONST(20)
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D FldNamXAr       S             10A   DIM(XArrayMax)
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
     D WFldNmXAr       S             10A   DIM(XArrayMax)
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D CURSET          S              2P 0
     D DDDNIR          S              1A
     D DDCNIR          S              1A
     D DDTPRD          S              1A
     D DDDNIROK        S              1A
     D DDCNIROK        S              1A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
     C                   MOVE      'Y'           DDDNIROK
     C                   MOVE      'Y'           DDCNIROK
      *
      ** Set default values
      *
     C                   IF        DDDNIR = *BLANKS
     C                   EVAL      DDDNIR = 'D'
     C                   ENDIF
     C                   IF        DDCNIR = *BLANKS
     C                   EVAL      DDCNIR = 'D'
     C                   ENDIF
      *
      ** Validation
      *
     C                   IF        DDDNIR <> 'P'  AND
     C                             DDDNIR <> 'D'
      *
     C                   EVAL      DDDNIROK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDNIR' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0337'
     C                   ENDIF
      *
     C                   IF        DDDNIR = 'P' AND
     C                             DDTPRD = 'N'
     C                   EVAL      DDDNIROK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDNIR' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0429'
     C                   ENDIF
      *
     C                   IF        DDCNIR <> 'P'  AND
     C                             DDCNIR <> 'D'
      *
     C                   EVAL      DDCNIROK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCNIR' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0354'
     C                   ENDIF
      *
     C                   IF        DDCNIR = 'P' AND
     C                             DDTPRD = 'N'
     C                   EVAL      DDCNIROK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCNIR' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0429'
     C                   ENDIF
      *
     C                   IF        DDDNIROK = 'N' OR
     C                             DDCNIROK = 'N'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
     C                   PARM                    DDDNIR
     C                   PARM                    DDCNIR
     C                   PARM                    DDTPRD
     C                   PARM                    CURSET
      *
      ** OUTPUTS
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtaXAr
     C                   PARM                    DDDNIROK
     C                   PARM                    DDCNIROK
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
