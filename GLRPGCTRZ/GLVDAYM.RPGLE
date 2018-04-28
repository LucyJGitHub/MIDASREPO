     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Day of the Month')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVDAYM - Validate Rollover Day of the Month                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BUG27605           Date 04May10               *
      *  Prev Amend No. BUG27468           Date 23Apr10               *
      *                 BUG27484           Date 21Apr10               *
      *                 CRE015  *CREATE    Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG27605 - Error for max number of months                    *
      *  BUG27468 - Serious midas error when using no. of months      *
      *  BUG27484 - Error validation for period and penalty details   *
      *             is not working when AMAD is entered via SOAP      *
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
     DUFMD             S              2    DIM(12) CTDATA PERRCD(12)
 
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
 
     D DDDAYMOK        S              1A
     D DDDAYM          S              2A
     D DDFREQ          S              1A
     D DDNMPD          S              2A
     D MAINT           S              7A
     D BJLCCY          S              3A
     D SMDATN          S              5  0
     D CURSET          S              2  0
     D DDMDAT          S              6                                                     BUG27484
     D DDTPRD          S              1                                                     BUG27484
     D DDEVNT          S              1                                                     BUG27484
     D DDNDPD          S              3                                                     BUG27484
     D DDVDAT          S              6                                                     BUG27484
     D BJRDNB          S              5  0                                                  BUG27484
     D DDMDATOK        S              1                                                     BUG27484
     D DDVDATOK        S              1                                                     BUG27484
 
      ** ZSEDIT Parameters
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1A
     D ZOUT21          S             21A
     D ZAFLD1          S             16A
 
      ** ZALIGN Parameters
 
     D ZRTN            S              7A
     D ZFIELD          S             16A
     D ZADEC           S              1  0
     D ZADIG           S              2  0
     D ZAFLD           S             16A
 
      ** ZFRQB5 Parameters
 
     D ZFREQ           S              1
     D ZMDAY           S              2  0
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
 
     D SVDATF          S              5  0
     D #SDATE          S              6A
     D #SDAYN          S              5  0
     D #NMTH           S              2  0
     D #SDAYM          S              2  0
     D EDD             S              2  0
     D EMM             S              2  0
     D EYY             S              2  0
     D #EDATE          S              6A
     D #EDAYN          S              5  0
     D #TERML          S              5  0
     D ZZERR@          S              7A
     D UUWRK2          S              2A
     D*UMTH*****       S              2  0                                                  BUG27605
     D UMTH            S              3  0                                                  BUG27605
     D UWRK4           S              4A
     D UMYR            S              2  0
     D UMY             S              2  0
     D ULYR            S              2  0
     D ULY             S              1  0
     D UWRK2           S              2  0
     D ZWRK4           S              4  0
 
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
     C                   EVAL      DDDAYMOK = 'Y'
 
      ** Day Number is required for Roll Frequency
 
     C                   IF        (DDFREQ = *BlANKS AND
     C                             DDDAYM <> *BLANKS AND
     C                             DDNMPD = *BLANKS) OR
     C                             (DDFREQ = 'D' AND
     C                             DDDAYM <> *BLANKS) OR
     C                             DDFREQ <> *BLANKS AND
     C                             DDFREQ <> 'D' AND
     C                             DDDAYM = *BLANKS
 
     C                   EVAL      DDDAYMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDAYM' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0403'
     C                   ENDIF
 
      ** Day Number must range from 01 to 31, or be special value 99 for dft a/c
 
     C                   IF        DDDAYM <> *BlANKS AND
     C                             Idx = 0
     C                   MOVE      *BLANKs       ZFIELD
     C                   MOVE      DDDAYM        ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
 
     C                   EXSR      NEDIT
 
     C                   IF        ZRTN <> *BLANKS OR
     C                             DDDAYM = '00' OR
     C                             (DDDAYM >= '32' AND
     C                             DDDAYM <> '99') OR
     C                             (DDDAYM = '99' AND
     C                             MAINT <> '*DFT')
 
     C                   EVAL      DDDAYMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDAYM' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0404'
     C                   ENDIF
 
     C                   MOVE      ZAFLD         DDDAYM
     C                   ENDIF
 
      ** Day Number and Roll Frequency must synchronise with Next Date
 
B03  C                   IF        CURSET = 1
 03  C                   Z-ADD     0             SVDATF
 
B04  C                   IF        DDDAYM <> *BLANKS AND
 04  C                             MAINT <> '*DFT' AND
 04  C                             IDX = 0
 
     C                   IF        DDFREQ <> *BLANKS
     C                   MOVE      DDDAYM        ZMDAY
 
 04  C                   CALL      'ZFRQB5'
 04  C                   PARM      DDFREQ        ZFREQ
 04  C                   PARM      SMDATN        ZDAYNO
 04  C                   PARM                    ZMDAY
 04  C                   PARM      BJLCCY        ZCCY
 04  C                   PARM      *BLANKS       ZLOC
 04  C                   PARM      'B'           ZDIREC
 04  C                   PARM      *BLANKS       ZRTRN
 
     C                   EVAL      SVDATF = ZDAYNO + 1
     C                   MOVE      DDDAYM        ZMDAY
 
 04  C                   CALL      'ZFRQB5'
 04  C                   PARM      DDFREQ        ZFREQ
 04  C                   PARM                    ZDAYNO
 04  C                   PARM                    ZMDAY
 04  C                   PARM      BJLCCY        ZCCY
 04  C                   PARM      *BLANKS       ZLOC
 04  C                   PARM      'F'           ZDIREC
 04  C                   PARM      *BLANKS       ZRTRN
 
     C                   ENDIF
 
     C                   IF        DDNMPD <> *BLANKS
     C                   MOVE      *BLANKS       #SDATE
     C                   Z-ADD     SMDATN        #SDAYN
     C                   MOVE      DDNMPD        #NMTH
     C                   Z-SUB     #NMTH         #NMTH
     C                   MOVE      DDDAYM        #SDAYM
 
     C                   EXSR      NOMTHS
 
     C                   MOVE      *BLANKS       #SDATE
     C                   Z-ADD     #EDAYN        #SDAYN
     C                   MOVE      DDNMPD        #NMTH
     C                   MOVE      DDDAYM        #SDAYM
 
     C                   EXSR      NOMTHS
 
     C                   Z-ADD     #EDAYN        ZDAYNO
     C                   ENDIF
 
B05  C                   IF        ZDAYNO <> SMDATN
     C                   EVAL      DDDAYMOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDDAYM' + %CHAR(CURSET)
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0405'
E05  C                   ENDIF
 
 04  C                   MOVE      ZAFLD         DDDAYM
E04  C                   ENDIF
                                                                                            BUG27484
      ** Next Date with Period Days or Roll Frequency must include run date                 BUG27484
                                                                                            BUG27484
     C     Idx           IFEQ      0                                                        BUG27484
     C     DDMDATOK      ANDEQ     'Y'                                                      BUG27484
     C     DDVDATOK      ANDEQ     'Y'                                                      BUG27484
                                                                                            BUG27484
     C     DDMDAT        IFNE      *BLANKS                                                  BUG27484
     C     DDTPRD        ANDEQ     'T'                                                      BUG27484
     C     DDEVNT        IFEQ      'Z'                                                      BUG27484
     C                   Z-ADD     *ALL'9'       W9DATE                                     BUG27484
     C     SMDATN        IFEQ      26664                                                    BUG27484
     C                   Z-ADD     0             W9DATE                                     BUG27484
     C                   ENDIF                                                              BUG27484
     C                   ELSE                                                               BUG27484
     C     DDFREQ        IFEQ      *BLANKS                                                  BUG27484
     C     DDNMPD        IFEQ      *BLANKS                                                  BUG27484
     C                   MOVE      DDNDPD        SWBVAL            5 0                      BUG27484
     C                   ELSE                                                               BUG27484
     C                   Z-ADD     0             #SDAYN                                     BUG27484
     C                   MOVE      DDVDAT        #SDATE                                     BUG27484
     C                   MOVE      DDNMPD        #NMTH                                      BUG27484
     C                   Z-ADD     0             #SDAYM                                     BUG27484
     C     DDDAYM        IFNE      *BLANKS                                                  BUG27484
     C                   MOVE      DDDAYM        #SDAYM                                     BUG27484
     C                   ENDIF                                                              BUG27484
     C                   EXSR      NOMTHS                                                   BUG27484
     C                   Z-ADD     #TERML        SWBVAL                                     BUG27484
     C                   ENDIF                                                              BUG27484
     C                   ELSE                                                               BUG27484
     C     SMDATN        SUB       SVDATF        SWBVAL                                     BUG27484
     C                   ADD       1             SWBVAL                                     BUG27484
     C                   ENDIF                                                              BUG27484
     C     SMDATN        SUB       SWBVAL        W9DATE            5 0                      BUG27484
     C                   ADD       1             W9DATE                                     BUG27484
     C                   ENDIF                                                              BUG27484
     C     W9DATE        IFGT      BJRDNB                                                   BUG27484
     C                   EVAL      DDMDATOK = 'N'                                           BUG27484
     C                   EVAL      Idx = Idx + 1                                            BUG27484
     C                   EVAL      FldNamXAr(Idx) = 'DDMDAT'                                BUG27484
     C                   EVAL      MsgIdXAr(Idx) = 'TNN0371'                                BUG27484
     C                   ENDIF                                                              BUG27484
     C                   ENDIF                                                              BUG27484
     C                   ENDIF                                                              BUG27484
E03  C                   ENDIF
 
      ** Return Error
 
     C                   IF        DDDAYMOK = 'N'
     C                             OR DDMDATOK = 'N'                                        BUG27484
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
     C                   MOVE      *BLANKs       ZAFLD
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
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * NOMTHS -  Calculate term length in days and end date given    *
      *           start date and number of months.                    *
      *                                                               *
      *****************************************************************
     C     NOMTHS        BEGSR
 
     C                   Z-ADD     0             EDD
     C                   Z-ADD     0             EMM
     C                   Z-ADD     0             EYY
     C                   MOVE      *BLANKS       #EDATE
     C                   Z-ADD     0             #EDAYN
     C                   Z-ADD     0             #TERML
     C                   MOVE      *BLANK        ZZERR@
 
      ** Convert day number to date (DDMMYY)
 
     C                   IF        #SDATE = *BLANKS
 02  C                   CALL      'ZDATE2'
 02  C                   PARM      #SDAYN        ZDAYNO
 02  C                   PARM      'D'           BJDFIN
 02  C                   PARM                    ZDATE
 02  C                   PARM                    ZADATE
     C                   MOVE      ZDATE         #SDATE
     C                   ENDIF
 
      ** Convert date to day number
 
     C                   IF        #SDAYN = 0
     C                   MOVE      #SDATE        ZDATE
 02  C                   CALL      'ZDATE1'
 02  C                   PARM                    ZERR
 02  C                   PARM                    ZDATE
 02  C                   PARM      'D'           ZDATFM
 02  C                   PARM                    ZDAYNO
     C                   Z-ADD     ZDAYNO        #SDAYN
     C                   ENDIF
 
      **   Set end day number to be same as start day number
      **   or equal to day number
 
     C                   IF        #SDAYM = 0
     C                   MOVEL     #SDATE        UUWRK2
     C                   MOVE      UUWRK2        EDD
     C                   ELSE
     C                   Z-ADD     #SDAYM        EDD
     C                   ENDIF
 
      ** Calculate date NMTH no of months ahead
 
     C                   Z-ADD     0             UMTH
     C                   MOVEL     #SDATE        UWRK4
     C                   MOVE      UWRK4         UMTH
     C                   EVAL      UMTH = UMTH + #NMTH
 
      ** Convert into months and years
 
     C                   Z-ADD     UMTH          EMM
     C                   MOVE      #SDATE        EYY
     C                   IF        UMTH >= 12 OR
     C                             UMTH <= -12
     C     UMTH          DIV       12            UMYR
     C                   MVR                     UMY
     C                   Z-ADD     UMY           EMM
     C**********         EVAL      EYY = EYY + UMYR                                         BUG27468
     C     EYY           ADD       UMYR          EYY                                        BUG27468
     C                   ENDIF
 
      **  If negative values of month and year, make valid values
 
     C                   IF        EMM < 1
     C                   EVAL      EMM = EMM + 12
     C                   EVAL      EYY = EYY - 1
     C                   ENDIF
 
     C                   IF        EYY < 0
     C                   EVAL      EYY = EYY + 100
     C                   ENDIF
 
      ** Check for Leap year.
 
     C     EYY           DIV       4             ULYR
     C                   MVR                     ULY
 
      ** Check day number is within end of month
 
     C                   MOVE      UFMD(EMM)     UWRK2
     C                   IF        EMM = 2 AND
     C                             ULY = 0
     C                   Z-ADD     29            UWRK2
     C                   ENDIF
 
     C                   IF        EDD > UWRK2
     C                   Z-ADD     UWRK2         EDD
     C                   ENDIF
 
      ** Reformat date, DDMMYY, and convert to day number.
 
     C                   MOVEL     EDD           ZWRK4
     C                   MOVE      EMM           ZWRK4
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      EYY           ZDATE
     C                   MOVE      ZDATE         #EDATE
 
     C                   CALL      'ZDATE1'
     C                   PARM                    ZERR
     C                   PARM                    ZDATE
     C                   PARM      'D'           ZDATFM
     C                   PARM      0             ZDAYNO
     C                   Z-ADD     ZDAYNO        #EDAYN
 
      ** Determine length of term
 
     C                   EVAL      #TERML = #EDAYN - #SDAYN
     C                   EVAL      #TERML = #TERML + 1
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
 
     C                   PARM                    RetCodeIn
 
      ** Other parms
 
     C                   PARM                    DDDAYM
     C                   PARM                    DDFREQ
     C                   PARM                    DDNMPD
     C                   PARM                    MAINT
     C                   PARM                    BJLCCY
     C                   PARM                    SMDATN
     C                   PARM                    CURSET
     C                   PARM                    DDMDAT                                     BUG27484
     C                   PARM                    DDTPRD                                     BUG27484
     C                   PARM                    DDEVNT                                     BUG27484
     C                   PARM                    DDNDPD                                     BUG27484
     C                   PARM                    DDVDAT                                     BUG27484
     C                   PARM                    BJRDNB                                     BUG27484
 
      ** OUTPUTS
 
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtaXAr
     C                   PARM                    DDDAYMOK
     C                   PARM                    DDMDATOK                                   BUG27484
     C                   PARM                    DDVDATOK                                   BUG27484
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**CTDATA UFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
