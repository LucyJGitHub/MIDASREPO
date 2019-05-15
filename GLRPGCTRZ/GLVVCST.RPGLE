     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Interest Sub Type')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVVCST - Validate Interest Sub Type                         *
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
     FREINT     IF   E           K DISK    USROPN
     FREINHSL0  IF   E           K DISK
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
     D ZERR            S              7A
     D ZDATE           S              6S 0
     D ZDATFM          S              1A
     D ZDAYNO          S              5S 0
     D WWVDAT          S              5S 0
     D HKEY            S             12A
     D WCCY            S              3A
     D DDDCST          S              5A
     D DDCCST          S              5A
     D DDDICT          S              2A
     D DDCICT          S              2A
     D DDDNIR          S              1A
     D DDCNIR          S              1A
     D DDVDAT          S              6A
     D WSCCY           S              3A
     D CURSET          S              2P 0
      *
     D DDDCSTOK        S              1A
     D DDCCSTOK        S              1A
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
     C                   MOVE      'Y'           DDDCSTOK
     C                   MOVE      'Y'           DDCCSTOK
      *
      ** Validation
      *
     C                   IF        DDDCST <> *BLANK  OR
     C                             DDDICT <> *BLANK
      *
     C                   EVAL      WWVDAT = 0
     C                   IF        DDVDAT <> *BLANKS
     C                   MOVE      DDVDAT        ZDATE
 02  C                   CALL      'ZDATE1'
 02  C                   PARM                    ZERR
 02  C                   PARM                    ZDATE
 02  C                   PARM                    ZDATFM
 02  C                   PARM                    ZDAYNO
 02  C                   MOVE      ZDAYNO        WWVDAT
E02  C                   ENDIF
      *
     C                   OPEN      REINT
     C                   MOVE      *BLANK        HKEY
     C     ' '           CAT       DDDICT        HKEY
     C                   CAT       DDDCST:0      HKEY
     C     WSCCY         IFEQ      *BLANKS
     C                   MOVEL     'SKK'         WCCY
 03  C     HKEY          CAT       WCCY:0        HKEY
     C                   ELSE
 03  C     HKEY          CAT       WSCCY:0       HKEY
     C                   ENDIF
 03  C                   MOVE      'D'           HKEY
 03  C     HKEY          CHAIN     REINT                              85
 03  C                   CLOSE     REINT
      *
B04  C     *IN85         IFEQ      '1'
     C     VDTC          ORGT      WWVDAT
     C     DDDNIR        ANDNE     'D'
      *
     C     H2KEY         SETGT     REINHSL0                           85
     C     HKEY          READPE    REINHSL0                               85
     C     *IN85         IFEQ      '1'
     C     DDDCST        OREQ      *BLANKS
     C     DDDNIR        ANDNE     'D'
      *
     C                   EVAL      DDDCSTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDST' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0335'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DDCCST <> *BLANK  OR
     C                             DDCICT <> *BLANK
      *
     C                   EVAL      WWVDAT = 0
     C                   IF        DDVDAT <> *BLANKS
     C                   MOVE      DDVDAT        ZDATE
 02  C                   CALL      'ZDATE1'
 02  C                   PARM                    ZERR
 02  C                   PARM                    ZDATE
 02  C                   PARM                    ZDATFM
 02  C                   PARM                    ZDAYNO
 02  C                   MOVE      ZDAYNO        WWVDAT
E02  C                   ENDIF
      *
     C                   OPEN      REINT
     C                   MOVE      *BLANK        HKEY
     C     ' '           CAT       DDCICT        HKEY
     C                   CAT       DDCCST:0      HKEY
     C     WSCCY         IFEQ      *BLANKS
     C                   MOVEL     'SKK'         WCCY
 03  C     HKEY          CAT       WCCY:0        HKEY
     C                   ELSE
 03  C     HKEY          CAT       WSCCY:0       HKEY
     C                   ENDIF
 03  C                   MOVE      'D'           HKEY
 03  C     HKEY          CHAIN     REINT                              85
 03  C                   CLOSE     REINT
      *
B04  C     *IN85         IFEQ      '1'
     C     VDTC          ORGT      WWVDAT
     C     DDCNIR        ANDNE     'D'
      *
     C     H2KEY         SETGT     REINHSL0                           85
     C     HKEY          READPE    REINHSL0                               85
     C     *IN85         IFEQ      '1'
     C     DDCICT        OREQ      *BLANKS
      *
     C                   EVAL      DDCCSTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPCST' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0352'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        DDDCSTOK = 'N' OR
     C                             DDCCSTOK = 'N'
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
     C                   PARM                    DDDCST
     C                   PARM                    DDCCST
     C                   PARM                    DDDICT
     C                   PARM                    DDCICT
     C                   PARM                    DDDNIR
     C                   PARM                    DDCNIR
     C                   PARM                    DDVDAT
     C                   PARM                    WSCCY
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
     C                   PARM                    DDDCSTOK
     C                   PARM                    DDCCSTOK
      *
      ** Key for REINHSL0
      *
     C     H2KEY         KLIST
     C                   KFLD                    HKEY
     C                   KFLD                    WWVDAT
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
