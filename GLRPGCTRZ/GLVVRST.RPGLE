     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Penalty Restriction')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVVRST - Validate Penalty Restriction                       *
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
     D DDDRST          S              1A
     D DDCRST          S              1A
     D DDEVNT          S              1A
     D DDRTTD          S              5A
     D DDRTTC          S              5A
     D DDDRSTOK        S              1A
     D DDCRSTOK        S              1A
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
     C                   MOVE      'Y'           DDDRSTOK
     C                   MOVE      'Y'           DDCRSTOK
      *
      ** Validation
      *
     C                   IF        DDDRST <> *BLANK AND
     C                             DDEVNT = 'Z'
      *
     C                   EVAL      DDDRSTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDRST' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0345'
     C                   ENDIF
      *
     C                   IF        DDEVNT <> 'Z'
     C                   IF        DDDRST <> 'N' AND
     C                             DDDRST <> 'I' AND
     C                             DDRTTD <> *BLANKS OR
     C                             DDDRST <> *BLANKS AND
     C                             DDRTTD = *BLANKS
      *
     C                   EVAL      DDDRSTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDRST' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0346'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DDCRST <> *BLANK AND
     C                             DDEVNT = 'Z'
      *
     C                   EVAL      DDCRSTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCRST' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0362'
     C                   ENDIF
      *
     C                   IF        DDEVNT <> 'Z'
     C                   IF        DDCRST <> 'N' AND
     C                             DDCRST <> 'I' AND
     C                             DDRTTC <> *BLANKS OR
     C                             DDCRST <> *BLANKS AND
     C                             DDRTTC = *BLANKS
      *
     C                   EVAL      DDCRSTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCRST' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0363'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DDDRSTOK = 'N' OR
     C                             DDCRSTOK = 'N'
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
     C                   PARM                    DDDRST
     C                   PARM                    DDCRST
     C                   PARM                    DDEVNT
     C                   PARM                    DDRTTD
     C                   PARM                    DDRTTC
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
     C                   PARM                    DDDRSTOK
     C                   PARM                    DDCRSTOK
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
