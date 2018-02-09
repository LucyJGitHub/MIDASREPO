     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Interest Capitalisation Freq')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVVRIF - Validate Interest Capitalisation Frequency         *
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
     D DDDRIF          S              1A
     D DDCRIF          S              1A
     D DDDRDD          S              2A
     D DDCRDD          S              2A
     D DDDRMM          S              2A
     D DDCRMM          S              2A
     D DDDRIFOK        S              1A
     D DDCRIFOK        S              1A
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
     C                   MOVE      'Y'           DDDRIFOK
     C                   MOVE      'Y'           DDCRIFOK
      *
      ** Set default values
      *
     C                   IF        DDDRIF = *BLANKS
     C                   EVAL      DDDRIF = 'Z'
     C                   ENDIF
     C                   IF        DDCRIF = *BLANKS
     C                   EVAL      DDCRIF = 'Z'
     C                   ENDIF
      *
      ** Validation
      *
     C                   IF        DDDRIF <> 'Z' AND
     C                             DDDRIF <> 'M' AND
     C                             DDDRIF <> 'Q' AND
     C                             DDDRIF <> 'X' AND
     C                             DDDRIF <> 'Y'
      *
     C                   EVAL      DDDRIFOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDIF' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0339'
     C                   ENDIF
      *
     C                   IF        DDDRIF = 'Z' AND
     C                             DDDRDD <> *BLANKS OR
     C                             DDDRIF = 'Z' AND
     C                             DDDRMM <> *BLANKS
     C                   EVAL      DDDRIFOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDIF' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0408'
     C                   ENDIF
      *
     C                   IF        DDDRIF <> 'Z' AND
     C                             DDDRDD = *BLANKS OR
     C                             DDDRIF <> 'Z' AND
     C                             DDDRMM = *BLANKS
     C                   EVAL      DDDRIFOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDIF' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0409'
     C                   ENDIF
      *
     C                   IF        DDCRIF <> 'Z' AND
     C                             DDCRIF <> 'M' AND
     C                             DDCRIF <> 'Q' AND
     C                             DDCRIF <> 'X' AND
     C                             DDCRIF <> 'Y'
      *
     C                   EVAL      DDCRIFOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPCIF' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0356'
     C                   ENDIF
      *
     C                   IF        DDCRIF = 'Z' AND
     C                             DDCRDD <> *BLANKS OR
     C                             DDCRIF = 'Z' AND
     C                             DDCRMM <> *BLANKS
     C                   EVAL      DDCRIFOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPCIF' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0412'
     C                   ENDIF
      *
     C                   IF        DDCRIF <> 'Z' AND
     C                             DDCRDD = *BLANKS OR
     C                             DDCRIF <> 'Z' AND
     C                             DDCRMM = *BLANKS
     C                   EVAL      DDCRIFOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPCIF' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0413'
     C                   ENDIF
      *
     C                   IF        DDDRIFOK = 'N' OR
     C                             DDCRIFOK = 'N'
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
     C                   PARM                    DDDRIF
     C                   PARM                    DDCRIF
     C                   PARM                    DDDRDD
     C                   PARM                    DDCRDD
     C                   PARM                    DDDRMM
     C                   PARM                    DDCRMM
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
     C                   PARM                    DDDRIFOK
     C                   PARM                    DDCRIFOK
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
