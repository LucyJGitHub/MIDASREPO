     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Calculation Basis')                  *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVVRIC - Validate Calculation Basis                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. CRE015  *CREATE    Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
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
      *                                                                                       CER059
      * First DS for Access programs - short data structure                                   CER059
      *                                                                                       CER059
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER059
                                                                                              CER059
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER059
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D CURSET          S              2P 0
     D DDDRIC          S              1A
     D DDCRIC          S              1A
     D DDDRICOK        S              1A
     D DDCRICOK        S              1A
     D CER016          S              1A                                                      CER059
     D PRtcd           S              7A                                                      CER059
     D POptn           S              7A                                                      CER059
     D PSard           S              6A                                                      CER059
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
     C                   MOVE      'Y'           DDDRICOK
     C                   MOVE      'Y'           DDCRICOK
      *
      ** Set default values
      *
     C                   IF        DDDRIC = *BLANKS
     C                   EVAL      DDDRIC = '1'
     C                   ENDIF
     C                   IF        DDCRIC = *BLANKS
     C                   EVAL      DDCRIC = '1'
     C                   ENDIF
      *
      ** Validation
      *
     C                   IF        DDDRIC <> '1'   AND
     C                             DDDRIC <> '2'   AND
     C                             DDDRIC <> '3'   AND
     C                             DDDRIC <> '4'   AND
     C                             DDDRIC <> '5'   AND
     C                             DDDRIC <> '6'   AND
     C                             DDDRIC <> '7'
     C                   IF        CER016 <> 'Y'   OR                                         CER059
     C                             DDDRIC <> '0'                                              CER059
      *
     C                   EVAL      DDDRICOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDIC' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0336'
     C                   ENDIF                                                                CER059
     C                   ENDIF
      *
     C                   IF        DDCRIC <> '1'   AND
     C                             DDCRIC <> '2'   AND
     C                             DDCRIC <> '3'   AND
     C                             DDCRIC <> '4'   AND
     C                             DDCRIC <> '5'   AND
     C                             DDCRIC <> '6'   AND
     C                             DDCRIC <> '7'
     C                   IF        CER016 <> 'Y'   OR                                         CER059
     C                             DDCRIC <> '0'                                              CER059
      *
     C                   EVAL      DDCRICOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPCIC' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0353'
     C                   ENDIF                                                                CER059
     C                   ENDIF
      *
     C                   IF        DDDRICOK = 'N' OR
     C                             DDCRICOK = 'N'
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
     C                   PARM                    DDDRIC
     C                   PARM                    DDCRIC
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
     C                   PARM                    DDDRICOK
     C                   PARM                    DDCRICOK
      *
     C/COPY ZACPYSRC,DBFIELDS
      *                                                                                       CER059
     C                   CALLB     'AOSARDR0'                                                 CER059
     C                   PARM      *BLANKS       PRtcd                                        CER059
     C                   PARM      '*VERIFY'     POptn                                        CER059
     C                   PARM      'CER016'      PSard                                        CER059
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER059
     C     PRtcd         IFEQ      *BLANK                                                     CER059
     C                   MOVEL     'Y'           CER016                                       CER059
     C                   ELSE                                                                 CER059
     C                   MOVEL     'N'           CER016                                       CER059
     C                   END                                                                  CER059
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
