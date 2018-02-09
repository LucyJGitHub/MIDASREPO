     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Penalty Time Basis')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVDYBV - Validate Penalty Time Basis                        *
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
     D DDDYBD          S              1A
     D DDDYBC          S              1A
     D DDRTTD          S              5A
     D DDRTTC          S              5A
     D DDEVNT          S              1A
     D DDDYBDOK        S              1A
     D DDDYBCOK        S              1A
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
     C                   MOVE      'Y'           DDDYBDOK
     C                   MOVE      'Y'           DDDYBCOK
      *
      ** Validation
      *
     C                   IF        DDRTTD = *BLANK AND
     C                             DDDYBD <> *BLANK OR
     C                             DDRTTD <> *BLANK AND
     C                             DDDYBD <> 'D' AND
     C                             DDDYBD <> 'S' AND
     C                             DDDYBD <> 'M'
      *
     C                   EVAL      DDDYBDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDYBD' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0343'
     C                   ENDIF
      *
     C                   IF        DDDYBD <> *BLANK AND
     C                             DDEVNT = 'Z'
      *
     C                   EVAL      DDDYBDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDYBD' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0344'
     C                   ENDIF
      *
     C                   IF        DDRTTC = *BLANK AND
     C                             DDDYBC <> *BLANK OR
     C                             DDRTTC <> *BLANK AND
     C                             DDDYBC <> 'D' AND
     C                             DDDYBC <> 'S' AND
     C                             DDDYBC <> 'M'
      *
     C                   EVAL      DDDYBCOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDYBC' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0360'
     C                   ENDIF
      *
     C                   IF        DDDYBC <> *BLANK AND
     C                             DDEVNT = 'Z'
      *
     C                   EVAL      DDDYBCOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDYBC' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0361'
     C                   ENDIF
      *
     C                   IF        DDDYBDOK = 'N' OR
     C                             DDDYBCOK = 'N'
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
     C                   PARM                    DDDYBD
     C                   PARM                    DDDYBC
     C                   PARM                    DDRTTD
     C                   PARM                    DDRTTC
     C                   PARM                    DDEVNT
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
     C                   PARM                    DDDYBDOK
     C                   PARM                    DDDYBCOK
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
