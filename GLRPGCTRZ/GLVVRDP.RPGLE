     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Interest Cap Day and Month')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVVRDP - Validate Interest Capitalisation Day and Month     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CRE015  *CREATE    Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
     D DDDRDD          S              2A
     D DDDRMM          S              2A
     D DDCRDD          S              2A
     D DDCRMM          S              2A
     D WWDRDD          S              2S 0
     D WWDRMM          S              2S 0
     D WWCRDD          S              2S 0
     D WWCRMM          S              2S 0
     D DDDRDDOK        S              1A
     D DDCRDDOK        S              1A
     D DDDRMMOK        S              1A
     D DDCRMMOK        S              1A
     D ZAlignOk        S              1A
     D ZField          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
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
     C                   MOVE      'Y'           DDDRDDOK
     C                   MOVE      'Y'           DDCRDDOK
     C                   MOVE      'Y'           DDDRMMOK
     C                   MOVE      'Y'           DDCRMMOK
      *
      ** Validation
      *
     C                   IF        DDDRDD <> *BLANKS
     C
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      DDDRDD        ZField
     C                   EXSR      SRZAlign
     C
     C                   IF        ZAlignOk = 'N'
      *
     C                   EVAL      DDDRDDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDRDY' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0444'
     C                   ELSE
     C                   MOVE      ZField        DDDRDD
     C                   ENDIF
      *
     C                   IF        DDDRDDOK = 'Y'
      *
     C                   Z-ADD     0             WWDRDD
     C                   MOVE      DDDRDD        WWDRDD
     C                   IF        WWDRDD = 0  OR
     C                             WWDRDD >= 32
      *
     C                   EVAL      DDDRDDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDRDY' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0446'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        DDDRMM <> *BLANKS
     C
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      DDDRMM        ZField
     C                   EXSR      SRZAlign
     C
     C                   IF        ZAlignOk = 'N'
      *
     C                   EVAL      DDDRMMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDRMO' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0445'
     C                   ELSE
     C                   MOVE      ZField        DDDRMM
     C                   ENDIF
      *
     C                   IF        DDDRMMOK = 'Y'
      *
     C                   Z-ADD     0             WWDRMM
     C                   MOVE      DDDRMM        WWDRMM
     C                   IF        WWDRMM = 0  OR
     C                             WWDRMM >= 13
      *
     C                   EVAL      DDDRMMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDRMO' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0447'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        DDCRDD <> *BLANKS
     C
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      DDCRDD        ZField
     C                   EXSR      SRZAlign
     C
     C                   IF        ZAlignOk = 'N'
      *
     C                   EVAL      DDCRDDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCRDY' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0448'
     C                   ELSE
     C                   MOVE      ZField        DDCRDD
     C                   ENDIF
      *
     C                   IF        DDCRDDOK = 'Y'
      *
     C                   Z-ADD     0             WWCRDD
     C                   MOVE      DDCRDD        WWCRDD
     C                   IF        WWCRDD = 0  OR
     C                             WWCRDD >= 32
      *
     C                   EVAL      DDCRDDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCRDY' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0450'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        DDCRMM <> *BLANKS
     C
     C                   MOVE      *BLANKS       ZField
     C                   MOVE      DDCRMM        ZField
     C                   EXSR      SRZAlign
     C
     C                   IF        ZAlignOk = 'N'
      *
     C                   EVAL      DDCRMMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCRMO' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0449'
     C                   ELSE
     C                   MOVE      ZField        DDCRMM
     C                   ENDIF
      *
     C                   IF        DDCRMMOK = 'Y'
      *
     C                   Z-ADD     0             WWCRMM
     C                   MOVE      DDCRMM        WWCRMM
     C                   IF        WWCRMM = 0  OR
     C                             WWCRMM >= 13
      *
     C                   EVAL      DDCRMMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCRMO' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0451'
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        DDDRDDOK = 'N' OR
     C                             DDCRDDOK = 'N' OR
     C                             DDDRMMOK = 'N' OR
     C                             DDCRMMOK = 'N'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZAlign - Validate numeric fields                           *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: ZALIGN                                                *
      *                                                               *
      *****************************************************************
      *
     C     SRZAlign      BEGSR
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      *Blanks       ZAlignOk
     C                   PARM                    ZField
     C                   PARM      0             ZADEC
     C                   PARM      2             ZADIG
      *
     C                   ENDSR
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
     C                   PARM                    DDDRDD
     C                   PARM                    DDDRMM
     C                   PARM                    DDCRDD
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
     C                   PARM                    DDDRDDOK
     C                   PARM                    DDDRMMOK
     C                   PARM                    DDCRDDOK
     C                   PARM                    DDCRMMOK
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
