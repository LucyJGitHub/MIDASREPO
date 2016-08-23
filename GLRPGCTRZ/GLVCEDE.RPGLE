     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Period End Date')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVCEDE - Validate Period End Date                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CRE015  *CREATE    Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Entry Parameters
 
     D DDCEDEOK        S              1A
     D DDCEDE          S              6A
     D DDEVNT          S              1A
     D DDVDAT          S              6A
     D MAINT           S              7A
     D BJRDNB          S              5  0
     D TRMDAT          S              6A
     D DDCEDN          S              5  0
     D CURSET          S              2  0
     D DDTPRD          S              1A
     D DDMDATOK        S              1A
     D DDMDAT          S              6A
 
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
 
      ** ZFRQB2 Parameters
 
     D ZFREQ           S              1A
     D ZMDAY           S              2A
     D ZCCY            S              3A
     D ZLOC            S              3A
     D ZDIREC          S              1A
     D ZRTRN           S              7A
 
      ** ZDATE2 Parameters
 
     D ZDAYNO          S              5  0
     D BJDFIN          S              1A
     D ZDATE           S              6  0
     D ZADATE          S              7A
 
      ** ZDATE1 Parameters
 
     D ZERR            S              7A
     D ZDATFM          S              1A
 
      ** Work fields
 
     D DDCEDT          S              6A
     D UNTILT          S              7A
     D ZVALUE          S              5  0
     D #SDATE          S              6A
     D #SDAYN          S              5  0
     D #NMTH           S              2  0
     D #SDAYM          S              2  0
     D EMM             S              2  0
     D #EDATE          S              6A
     D #EDAYN          S              5  0
     D #TERML          S              5  0
     D ZZERR@          S              7A
     D UUWRK2          S              2A
     D EDD             S              2  0
     D UMTH            S              2  0
     D UWRK4           S              4A
     D EYY             S              2  0
     D UMYR            S              2  0
     D UMY             S              2  0
     D ULYR            S              2  0
     D ULY             S              1  0
     D UWRK2           S              2  0
     D ZWRK4           S              4  0
     D W3A             S              3A
     D WYMDA           S              8A
     D WWMMA           S              2A
     D WWDDA           S              2A
     D WWYYA           S              2A
     D SMDATN          S              5  0
 
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
     C                   MOVE      *BLANK        UNTILT
     C                   EVAL      DDCEDEOK = 'Y'
 
      ** End Date must not be blank
 
     C                   IF        DDCEDE = '000000' OR
     C                             DDCEDE = *BLANKS
 
     C                   EVAL      UNTILT = 'ERROR'
     C                   EVAL      DDCEDEOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCEDE' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0325'
     C                   ENDIF
 
      ** End date must be date=31 DEC 2044 for the termination period
 
     C                   IF        MAINT <> '*DFT'
 
     C                   IF        DDEVNT = 'Z' AND
     C                             DDCEDE <> TRMDAT
     C                   EVAL      UNTILT = 'ERROR'
 
     C                   EVAL      DDCEDEOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCEDE' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0326'
     C                   ENDIF
     C                   ENDIF
 
      ** End date value must be numeric and greater than 0
 
 02  C                   IF        UNTILT <> 'ERROR' AND
 02  C                             MAINT <> '*DFT'
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDCEDE        ZFIELD
     C                   Z-ADD     6             ZADIG
     C                   Z-ADD     0             ZADEC
 
     C                   EXSR      NEDIT
 
     C                   IF        ZRTN <> *BLANKS OR
     C                             ZAFLD = *ZEROS
     C                   EVAL      UNTILT = 'ERROR'
     C                   EVAL      DDCEDEOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCEDE' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0327'
     C                   ENDIF
     C                   ENDIF
 
      ** Determine Validation Type
      ** End date value must be on or before 31 DEC 2044 when a date
 
     C                   IF        UNTILT <> 'ERROR' AND
     C                             MAINT <> '*DFT'
     C                   MOVE      ZAFLD         DDCEDE
     C                   MOVE      ZAFLD1        DDCEDT
     C     3             SUBST     DDCEDE        W3A
 
     C                   IF        W3A = '000'
     C                   EVAL      UNTILT = 'REPEAT'
     C                   ELSE
     C                   EVAL      UNTILT = 'DATE'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        UNTILT = 'DATE'
 
 03  C     2             SUBST     DDCEDE:5      WWYYA
 
B04  C                   IF        BJDFIN = 'D'
 04  C     2             SUBST     DDCEDE:1      WWDDA
 04  C                   ELSE
 04  C     2             SUBST     DDCEDE:3      WWDDA
E04  C                   ENDIF
 
B04  C                   IF        BJDFIN = 'D'
 04  C     2             SUBST     DDCEDE:3      WWMMA
 04  C                   ELSE
 04  C     2             SUBST     DDCEDE:1      WWMMA
E04  C                   ENDIF
 
B04  C                   IF        WWYYA >= '72'
 04  C                   MOVEL     '19'          WYMDA
 04  C                   ELSE
 04  C                   MOVEL     '20'          WYMDA
E04  C                   ENDIF
 
 03  C     WYMDA         CAT       WWYYA:0       WYMDA
 03  C     WYMDA         CAT       WWMMA:0       WYMDA
 03  C     WYMDA         CAT       WWDDA:0       WYMDA
 
B04  C                   IF        WYMDA > '20441231'
     C                   EVAL      UNTILT = 'ERROR'
     C                   EVAL      DDCEDEOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCEDE' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0328'
E04  C                   ENDIF
E04  C                   ENDIF
 
      ** End of period must be greater than start of period and run date
 
B03  C                   IF        UNTILT = 'DATE  '
 
 03  C                   MOVE      DDVDAT        ZDATE
 03  C                   CALL      'ZDATE1'
 03  C                   PARM                    ZERR
 03  C                   PARM                    ZDATE
 03  C                   PARM      BJDFIN        ZDATFM
 03  C                   PARM      0             ZDAYNO
     C                   Z-ADD     ZDAYNO        ZVALUE
 
 03  C                   MOVE      DDCEDE        ZDATE
 03  C                   CALL      'ZDATE1'
 03  C                   PARM                    ZERR
 03  C                   PARM                    ZDATE
 03  C                   PARM      BJDFIN        ZDATFM
 03  C                   PARM      0             ZDAYNO
 
B04  C                   IF        ZERR <> *BLANKS OR
 04  C                             ZDAYNO < BJRDNB OR
 04  C                             ZDAYNO < ZVALUE OR
 04  C                             DDEVNT >= 'A' AND
 04  C                             DDEVNT < 'Z' AND
 04  C                             ZDAYNO >= 26664 OR
 04  C                             DDEVNT = 'Z' AND
 04  C                             ZDAYNO <> 26664
 04  C                   EVAL      UNTILT = 'ERROR'
     C                   EVAL      DDCEDEOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCEDE' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0329'
E04  C                   ENDIF
 
 03  C                   EVAL      DDCEDN = ZDAYNO
E03  C                   ENDIF
 
      ** number <= 999
 
B03  C                   IF        UNTILT = 'REPEAT'
 03  C                   MOVE      DDCEDE        DDCEDN
 03  C                   MOVE      DDCEDT        DDCEDE
 
      ** Until value must be a date for a Notice a/c
 
     C                   IF        DDTPRD = 'N' AND
     C                             Idx = 0
 04  C                   EVAL      UNTILT = 'ERROR'
     C                   EVAL      DDCEDEOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCEDE' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0372'
E04  C                   ENDIF
E03  C                   ENDIF
 
     C                   IF        CURSET = 1
 
     C                   IF        MAINT = '*EXIST' OR
     C                             MAINT = '*NEW'
 
     C                   MOVEL     DDMDAT        ZDATE
 02  C                   CALL      'ZDATE1'
 02  C                   PARM                    ZERR
 02  C                   PARM                    ZDATE
 02  C                   PARM      BJDFIN        ZDATFM
 02  C                   PARM      0             ZDAYNO
     C                   Z-ADD     ZDAYNO        SMDATN
 
      ** Next Date must be on or before 31 DEC 2044 for an a/c
 
     C                   IF        DDMDAT <> *BLANKS AND
     C                             SMDATN > 26664
     C
     C                   EVAL      DDMDATOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDMDAT    '
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0370'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDMDAT <> *BLANKS AND
     C                             DDMDAT <> TRMDAT AND
     C                             DDTPRD = 'T' AND
     C                             DDEVNT <> 'Z' AND
     C                             DDCEDN > 999 AND
     C                             SMDATN > DDCEDN
     C
     C                   EVAL      DDMDATOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDMDAT    '
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0406'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Return Error
 
     C                   IF        DDCEDEOK = 'N'
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
 
     C                   PARM                    DDCEDE
     C                   PARM                    DDEVNT
     C                   PARM                    DDVDAT
     C                   PARM                    MAINT
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    TRMDAT
     C                   PARM                    CURSET
     C                   PARM                    DDTPRD
     C                   PARM                    DDMDAT
 
      ** OUTPUTS
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtaXAr
 
     C                   PARM                    DDCEDEOK
     C                   PARM                    DDCEDN
     C                   PARM                    DDMDATOK
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
