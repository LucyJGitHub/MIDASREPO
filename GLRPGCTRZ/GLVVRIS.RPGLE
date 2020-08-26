     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Interest Base Rate, Spread, Sign')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVVRIS - Validate Interest Base Rate Type, Rate Spread,     *
      *            Rate Sign                                          *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015  *CREATE    Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding                              *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
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
 
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D FldNamXAr       S             10A   DIM(XArrayMax)
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
     D WFldNmXAr       S             10A   DIM(XArrayMax)
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)
 
     D P@FMT         E DS                  EXTNAME(DSSDY)
     D SDBSHS        E DS                  EXTNAME(SDBSHSPD)
     D BRFMT         E DS                  EXTNAME(SDBSRTPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Entry Parameters
 
     D DDDRIBOK        S              1A
     D DDDRISOK        S              1A
     D DDSIGDOK        S              1A
     D DDCRIBOK        S              1A
     D DDCRISOK        S              1A
     D DDSIGCOK        S              1A
     D DDDRIB          S              2A
     D DDDRIS          S             12A
     D DDSIGD          S              1A
     D DDCRIB          S              2A
     D DDCRIS          S             12A
     D DDSIGC          S              1A
     D S2DRIB          S              2A
     D S2CRIB          S              2A
     D CURSET          S              2  0
     D DDVDAT          S              6A
     D DDDNIR          S              1A
     D DDCNIR          S              1A
     D DDTPRD          S              1A
     D MAINT           S              7A
     D WMODE           S              7A
     D SCCY            S              3A
     D DDDRISN         S             11  7
     D DDCRISN         S             11  7
     D DDDCST          S              5A
     D DDCCST          S              5A
     D DDDICT          S              2A
     D DDCICT          S              2A
 
      ** AOBSRTR0 Parameters
     D P@RTCD          S              7A
     D P@OPTN          S              7A
     D P@CYCD          S              3A
     D P@BSRC          S              2A
 
      ** AOBSHSR0 Parameters
     D P@CCY           S              3A
     D*P@BSRT***       S              2  0                                                    CSD103
     D P@BSRT          S              2A                                                      CSD103
     D P@DATE          S              5  0
 
      ** ZSEDIT Parameters
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1A
     D ZOUT21          S             21A
     D ZAFLD1          S             16
 
      ** ZALIGN Parameters
 
     D ZRTN            S              7A
     D ZFIELD          S             16A
     D ZADEC           S              1  0
     D ZADIG           S              2  0
     D ZAFLD           S             16A
 
      ** ZDATE1 Parameters
 
     D ZERR            S              7A
     D ZDATE           S              6  0
     D ZDATFM          S              1A
     D ZDAYNO          S              5  0
 
      ** Work fields
 
     D W#VDAT          S              5  0
     D W16A1           S             16A
     D W16A2           S             16A
     D WCCY            S              3
     D W#DRBrt         S             11  7                                                    CRE073
     D W#CRBrt         S             11  7                                                    CRE073
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
     C                   EVAL      DDDRIBOK = 'Y'
     C                   EVAL      DDDRISOK = 'Y'
     C                   EVAL      DDSIGDOK = 'Y'
     C                   EVAL      DDCRIBOK = 'Y'
     C                   EVAL      DDCRISOK = 'Y'
     C                   EVAL      DDSIGCOK = 'Y'
 
      ** Place default sign
 
     C                   IF        DDDRIS <> *BLANKS AND
     C                             DDSIGD = *BLANKS
     C                   MOVEL     '+'           DDSIGD
     C                   ENDIF
 
     C                   IF        DDCRIS <> *BLANKS AND
     C                             DDSIGC = *BLANKS
     C                   MOVEL     '+'           DDSIGC
     C                   ENDIF
 
      ** DR Base rate
      ** Debit Base Rate must exist in Standing Data
 
     C                   IF        DDDRIB <> *BLANKS
 
     C                   IF        SCCY = *BLANKS
     C                   MOVEL     'SKK'         WCCY
     C                   ELSE
     C                   MOVEL     SCCY          WCCY
     C                   ENDIF
 
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM      WCCY          P@CYCD
     C                   PARM      DDDRIB        P@BSRC
     C     BRFMT         PARM                    P@FMT
 
     C                   IF        DDDRIB = '? ' OR
     C                             DDDRIB = ' ?'
     C                   EVAL      DDDRIBOK = 'N'
 
     C                   IF        SCCY = P@CYCD
     C                   MOVE      P@BSRC        DDDRIB
     C                   ELSE
     C                   MOVEL     'Curr'        P@RTCD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      DDDRIBOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDRB' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0330'
     C                   ELSE                                                                 CRE073
     C                   Z-Add     BACBSR        W#DRBrt                                      CRE073
     C                   ENDIF
 
      ** Additional rate checking if called independently from account
      **  maintenance or periodic fixing.
      ** For daily fixing, base rate change cannot be made if term
      ** start is earlier than base rate value date
 
     C                   IF        DDTPRD = 'T' AND
     C                             CURSET = 1 AND
     C                             MAINT <> '*DFT' AND
     C                             DDDRIB <> S2DRIB
 
     C                   Z-ADD     0             W#VDAT
     C                   IF        DDVDAT <> *BLANKS
     C                   MOVE      DDVDAT        ZDATE
 
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM                    ZDAYNO
 
     C                   MOVE      ZDAYNO        W#VDAT
     C                   ENDIF
 
     C                   IF        WMODE = '*INDEP' AND
     C                             DDDNIR = 'D' AND
     C                             W#VDAT < BAVDRC
     C                   EVAL      DDDRIBOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDRB' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0435'
     C                   ENDIF
 
      ** For periodic fixing, base rate change cannot be made if term
      ** start is earlier than earliest historic base rate date
 
     C                   IF        DDDNIR = 'P' AND
     C                             W#VDAT < BAVDRC
     C                   MOVE      DDDRIB        P@BSRT
 
     C                   CALL      'AOBSHSR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM      SCCY          P@CCY
     C                   PARM                    P@BSRT
     C                   PARM      W#VDAT        P@DATE
     C     SDBSHS        PARM                    P@FMT
 
     C                   IF        P@RTCD <> *BLANKS OR
     C                             W#VDAT < G0HIDT
     C                   EVAL      DDDRIBOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDRB' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0436'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** DR Rate/Spread
      ** Debit Rate/Spread must be numeric
 
     C                   IF        DDDRIS <> *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDDRIS        ZFIELD
     C                   Z-ADD     4             ZADIG
     C                   Z-ADD     7             ZADEC
     C                   EXSR      NEDIT
 
     C                   IF        ZRTN <> *BLANKS
     C                   EVAL      DDDRISOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDRS' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0331'
 
     C                   ELSE
     C                   MOVE      ZAFLD1        DDDRIS
     C                   MOVE      ZAFLD         DDDRISN
     C                   ENDIF
 
     C                   ENDIF
 
      ** DR Sign
      ** Debit Rate Sign must be (+) or (-)
 
     C                   IF        DDDRIS <> *BLANKS
 
     C                   IF        DDSIGD <> '+' AND
     C                             DDSIGD <> '-'
     C                   EVAL      DDSIGDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDSG' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0332'
     C                   ELSE
     C                   IF        DDSIGD = '-'
     C                   EVAL      DDDRISN = DDDRISN * -1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Debit Rate/Spread and Sign must both be blank or both be non-blank
 
     C                   IF        DDDRIS = *BLANKS AND
     C                             DDSIGD <> *BLANKS
     C                   EVAL      DDSIGDOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDSG' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0333'
     C                   ENDIF
     C
 
      **  CR Base rate
      **  Credit Base Rate must exist in Standing Data
 
     C                   IF        DDCRIB <> *BLANKS
 
     C                   IF        SCCY = *BLANKS
     C                   MOVEL     'SKK'         WCCY
     C                   ELSE
     C                   MOVEL     SCCY          WCCY
     C                   ENDIF
 
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM      WCCY          P@CYCD
     C                   PARM      DDCRIB        P@BSRC
     C     BRFMT         PARM                    P@FMT
 
     C                   IF        DDCRIB = '? ' OR
     C                             DDCRIB = ' ?'
     C                   EVAL      DDCRIBOK = 'N'
 
     C                   IF        SCCY = P@CYCD
     C                   MOVE      P@BSRC        DDCRIB
     C                   ELSE
     C                   MOVEL     'Curr'        P@RTCD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        P@RTCD <> *BLANKS
     C                   EVAL      DDCRIBOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPCRB' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0347'
     C                   ELSE                                                                 CRE073
     C                   Z-Add     BACBSR        W#CRBrt                                      CRE073
     C                   ENDIF
 
      ** Additional rate checking if called independently from account
      **  maintenance or periodic fixing
      ** For daily fixing, base rate change cannot be made if term
      **  start is earlier than base rate value date
 
     C                   IF        DDTPRD = 'T' AND
     C                             CURSET = 1 AND
     C                             MAINT <> '*DFT' AND
     C                             DDCRIB <> S2CRIB
 
     C                   Z-ADD     0             W#VDAT
 
     C                   IF        DDVDAT <> *BLANKS
     C                   MOVE      DDVDAT        ZDATE
 
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM                    ZDAYNO
 
     C                   MOVE      ZDAYNO        W#VDAT
     C                   ENDIF
 
     C                   IF        WMODE = '*INDEP' AND
     C                             DDCNIR = 'D' AND
     C                             W#VDAT < BAVDRC
     C                   EVAL      DDCRIBOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPCRB' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0435'
     C                   ENDIF
 
      ** For periodic fixing, base rate change cannot be made if term
      ** start is earlier than earliest historic base rate date
 
     C                   IF        DDCNIR = 'P' AND
     C                             W#VDAT < BAVDRC
     C                   MOVE      DDCRIB        P@BSRT
 
     C                   CALL      'AOBSHSR0'
     C                   PARM      *BLANKS       P@RTCD
     C                   PARM      '*KEY'        P@OPTN
     C                   PARM      SCCY          P@CCY
     C                   PARM                    P@BSRT
     C                   PARM      W#VDAT        P@DATE
     C     SDBSHS        PARM                    P@FMT
 
     C                   IF        P@RTCD <> *BLANKS OR
     C                             W#VDAT < G0HIDT
     C                   EVAL      DDCRIBOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPCRB' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0436'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** CR Rate/Spread
      ** Credit Rate/Spread must be numeric
 
     C                   IF        DDCRIS <> *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDCRIS        ZFIELD
     C                   Z-ADD     4             ZADIG
     C                   Z-ADD     7             ZADEC
 
     C                   EXSR      NEDIT
 
     C                   IF        ZRTN <> *BLANKS
     C                   EVAL      DDCRISOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPCRS' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0348'
 
     C                   ELSE
     C                   MOVE      ZAFLD1        DDCRIS
     C                   MOVE      ZAFLD         DDCRISN
     C                   ENDIF
 
     C                   ENDIF
 
      ** CR Sign
      ** Credit Rate Sign must be (+) or (-)
 
     C                   IF        DDCRIS <> *BLANKS
 
     C                   IF        DDSIGC <> '+' AND
     C                             DDSIGC <> '-'
     C                   EVAL      DDSIGCOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPCSG' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0349'
     C                   ELSE
     C                   IF        DDSIGC = '-'
     C                   EVAL      DDCRISN = DDCRISN * -1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Credit Rate/Spread and Sign must both be blank or both be non-blank
 
     C                   IF        DDCRIS = *BLANKS AND
     C                             DDSIGC <> *BLANKS
     C                   EVAL      DDSIGCOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPCSG' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0350'
     C                   ENDIF
 
      ** One of DR simple interest or complex interest details must be blank
 
     C                   EVAL      W16A1 = DDDRIB + DDDRIS + DDSIGD
     C                   EVAL      W16A2 = DDDICT + DDDCST
 
     C                   IF        W16A1 <> *BLANKS AND W16A2 <> *BLANKS
     C                   EVAL      DDDRIBOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDRB' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0373'
     C                   ENDIF
 
      ** One of CR simple interest or complex interest details must be blank
 
     C                   EVAL      W16A1 = DDCRIB + DDCRIS + DDSIGC
     C                   EVAL      W16A2 = DDCICT + DDCCST
 
     C                   IF        W16A1 <> *BLANKS AND W16A2 <> *BLANKS
     C                   EVAL      DDCRIBOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPCRB' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0374'
     C                   ENDIF
 
      ** Return Error
 
     C                   IF        DDDRIBOK = 'N' OR
     C                             DDDRISOK = 'N' OR
     C                             DDSIGDOK = 'N' OR
     C                             DDCRIBOK = 'N' OR
     C                             DDCRISOK = 'N' OR
     C                             DDSIGCOK = 'N'
     C                   EVAL      RetCodeIn = '*ERROR'
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * NEDIT - Standard Routine to Check and Format                  *
      *                                                               *
      *****************************************************************
     C     NEDIT         BEGSR
 
     C                   MOVE      ZFIELD        ZAFLD1
     C                   MOVE      *BLANKS       ZAFLD
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C                   PARM                    ZAFLD
 
     C                   IF        ZRTN = *BLANKS
     C                   MOVE      ZAFLD         ZFLD15
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM      ZADEC         ZDECS
     C                   PARM      '3'           ZECODE
     C                   PARM                    ZOUT21
     C     16            SUBST     ZOUT21:5      ZAFLD1
     C                   END
 
     C                   ENDSR
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
 
     C                   PARM                    DDDRIB
     C                   PARM                    DDDRIS
     C                   PARM                    DDSIGD
     C                   PARM                    DDCRIB
     C                   PARM                    DDCRIS
     C                   PARM                    DDSIGC
     C                   PARM                    S2DRIB
     C                   PARM                    S2CRIB
     C                   PARM                    CURSET
     C                   PARM                    DDVDAT
     C                   PARM                    DDDNIR
     C                   PARM                    DDCNIR
     C                   PARM                    DDTPRD
     C                   PARM                    MAINT
     C                   PARM                    WMODE
     C                   PARM                    SCCY
     C                   PARM                    DDDICT
     C                   PARM                    DDDCST
     C                   PARM                    DDCICT
     C                   PARM                    DDCCST
 
      ** OUTPUTS
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtaXAr
 
     C                   PARM                    DDDRIBOK
     C                   PARM                    DDDRISOK
     C                   PARM                    DDSIGDOK
     C                   PARM                    DDCRIBOK
     C                   PARM                    DDCRISOK
     C                   PARM                    DDSIGCOK
     C                   PARM                    DDDRISN
     C                   PARM                    DDCRISN
     C                   PARM                    W#DRBrt                                      CRE073
     C                   PARM                    W#CRBrt                                      CRE073
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
