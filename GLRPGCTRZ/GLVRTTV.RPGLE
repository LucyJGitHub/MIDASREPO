     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Penalty Transaction Type')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVRTTV - Validate Penalty Transaction Type                  *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL154             Date 13Oct14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015  *CREATE    Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL154 - FATCA Reporting (Recompile)                         *
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
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D TTFMT         E DS                  EXTNAME(SDRETRPD)
     D FldNamXAr       S             10A   DIM(XArrayMax)
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
     D WFldNmXAr       S             10A   DIM(XArrayMax)
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)
     D WArr            S              1    DIM(5)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D CURSET          S              2P 0
     D P@RTCD          S              7A
     D P@OPTN          S              7A
     D P@RTTY          S              5A
     D DDRTTD          S              5A
     D DDRTTC          S              5A
     D DDEVNT          S              1A
     D DDRTTDOK        S              1A
     D DDRTTCOK        S              1A
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
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
     C                   MOVE      'Y'           DDRTTDOK
     C                   MOVE      'Y'           DDRTTCOK
      *
      ** Validation
      *
     C                   IF        DDRTTD <> *BLANK AND
     C                             DDEVNT = 'Z'
      *
     C                   EVAL      DDRTTDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRTTD' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0341'
     C                   ENDIF
      *
     C                   IF        DDRTTD <> *BLANK AND
     C                             DDEVNT <> 'Z'
      *
     C                   MOVEA     DDRTTD        WArr
     C     '?'           LOOKUP    WArr                                   10
     C                   IF        *IN10 = '1'
      *
     C                   EVAL      DDRTTDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRTTD' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0342'
     C                   ELSE
      *
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      DDRTTD        P@RTTY
     C     TTFMT         PARM                    DSSDY
      *
      *
     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      DDRTTDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRTTD' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0342'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DDRTTC <> *BLANK AND
     C                             DDEVNT = 'Z'
      *
     C                   EVAL      DDRTTCOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRTTC' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0358'
     C                   ENDIF
      *
     C                   IF        DDRTTC <> *BLANK AND
     C                             DDEVNT <> 'Z'
      *
     C                   MOVEA     DDRTTC        WArr
     C     '?'           LOOKUP    WArr                                   11
     C                   IF        *IN11 = '1'
      *
     C                   EVAL      DDRTTCOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRTTC' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0359'
     C                   ELSE
      *
     C                   CALL      'AORETRR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      DDRTTC        P@RTTY
     C     TTFMT         PARM                    DSSDY
      *
     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      DDRTTCOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRTTC' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0359'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DDRTTDOK = 'N' OR
     C                             DDRTTCOK = 'N'
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
     C                   PARM                    DDRTTDOK
     C                   PARM                    DDRTTCOK
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
