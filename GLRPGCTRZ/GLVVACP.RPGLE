     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Alternative Account')                *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVVACP - Validate Alternative Account                       *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015  *CREATE    Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *                                                               *
      *****************************************************************
      *
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
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
     D ACFMT         E DS                  EXTNAME(ACCNTAB)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D CURSET          S              2P 0
     D TESTRT          S              8A
     D W8BRCA          S              3A
     D W8CNUM          S              6A
     D W8CCY           S              3A
     D W8ACOD          S             10A
     D W8ACSQ          S              2A
     D P@RTCD          S              7A
     D P@OPTN          S              7A
     D P@RETL          S             10A
     D P@CNUM          S              6A
     D P@CUCD          S              3A
     D P@ACCD          S             10A
     D P@ACSQ          S              2A
     D P@BRCA          S              3A
     D DDDACP          S             24A
     D DDCACP          S             24A
     D DDDACPOK        S              1A
     D DDCACPOK        S              1A
     D WNDACP          S             10P 0
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
     C                   MOVE      'Y'           DDDACPOK
     C                   MOVE      'Y'           DDCACPOK
      *
      ** Validation
      *
     C                   IF        DDDACP <> *BLANK
      *
     C     8             SUBST     DDDACP:11     TESTRT
     C                   IF        TESTRT <> *BLANKS
     C     3             SUBST     DDDACP:1      W8BRCA
     C     6             SUBST     DDDACP:4      W8CNUM
     C     3             SUBST     DDDACP:10     W8CCY
     C     10            SUBST     DDDACP:13     W8ACOD
     C     2             SUBST     DDDACP:23     W8ACSQ
      *
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      *BLANKS       P@RETL
     C                   PARM      W8CNUM        P@CNUM
     C                   PARM      W8CCY         P@CUCD
     C                   PARM      W8ACOD        P@ACCD
     C                   PARM      W8ACSQ        P@ACSQ
     C                   PARM      W8BRCA        P@BRCA
     C     ACFMT         PARM      *BLANK        DSSDY
     C                   ELSE
     C                   MOVEL     DDDACP        WNDACP
     C     WNDACP        CHAIN     ACNUM                              97
     C                   ENDIF
      *
     C     *IN97         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   EVAL      DDDACPOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDAC' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0340'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DDCACP <> *BLANK
      *
     C     8             SUBST     DDCACP:11     TESTRT
     C                   IF        TESTRT <> *BLANKS
     C     3             SUBST     DDCACP:1      W8BRCA
     C     6             SUBST     DDCACP:4      W8CNUM
     C     3             SUBST     DDCACP:10     W8CCY
     C     10            SUBST     DDCACP:13     W8ACOD
     C     2             SUBST     DDCACP:23     W8ACSQ
      *
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY   '     P@OPTN
     C                   PARM      *BLANKS       P@RETL
     C                   PARM      W8CNUM        P@CNUM
     C                   PARM      W8CCY         P@CUCD
     C                   PARM      W8ACOD        P@ACCD
     C                   PARM      W8ACSQ        P@ACSQ
     C                   PARM      W8BRCA        P@BRCA
     C     ACFMT         PARM      *BLANK        DSSDY
     C                   ELSE
     C                   MOVEL     DDCACP        WNDACP
     C     WNDACP        CHAIN     ACNUM                              97
     C                   ENDIF
      *
     C     *IN97         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C                   EVAL      DDCACPOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPCAC' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0357'
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DDDACPOK = 'N' OR
     C                             DDCACPOK = 'N'
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
     C                   PARM                    DDDACP
     C                   PARM                    DDCACP
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
     C                   PARM                    DDDACPOK
     C                   PARM                    DDCACPOK
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
