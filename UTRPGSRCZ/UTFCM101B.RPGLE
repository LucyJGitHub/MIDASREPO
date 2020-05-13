000100200430     H DEBUG
000101200430     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2019')
000102200430      *****************************************************************
000103200430/*STD *  RPGBASEBND                                                   *
000104200430/*EXI *  TEXT('Midas UT Populate Floor Rates')                        *
000105200430      *****************************************************************
000106200430      *                                                               *
000107200430      *  Midas - Standing Data                                        *
000108200430      *                                                               *
000109200430      *  UTFCM101B - Midas UT Populate Floor Rates                    *
000110200430      *                                                               *
000111200430      *  (c) Finastra Systems Technology, Inc. 2019                   *
000112200430      *                                                               *
000113200430      *  Last Amend No. FCM101  *CREATE    Date 13Mar19               *
000114200430      *                                                               *
000115200430      *---------------------------------------------------------------*
000116200430      *                                                               *
000117200430      *  FCM101 - Floor Rates                                         *
000118200430      *                                                               *
000119200430      *****************************************************************
000120200430      *                                                               *
000121200430      *  F U N C T I O N  O F  I N D I C A T O R S                    *
000122200430      *                                                               *
000123200430      *                                                               *
000124200430      *****************************************************************
000125200430      *                                                               *
000126200430      *  S U B R O U T I N E  I N D E X                               *
000127200430      *                                                               *
000128200430      * *PSSR - Error processing                                      *
000129200430      * *INZSR - Initialise                                           *
000130200430      * SRFLR  - Floor Rates Update                                   *
000131200430      *                                                               *
000132200430      *****************************************************************
000133200430
000134200430      * Midas UT Floor Rates Details
000135200430     FUTFLRPD   IF   E             DISK    INFSR(*PSSR)
000136200430     F                                     USROPN
000137200430      *
000138200430      * Midas XX Customer Loans A record extension File
000139200430     FXXCLOQY0  UF   E           K DISK    INFSR(*PSSR)
000140200430      *
000141200430     D @RUN            S              1
000142200430     D ZWDTIN          S              8S 0
000143200430     D DateOut         S              8S 0
000144200430     D @@DAYN          S              5P 0
000145200430     D TimeStamp       S               Z
000146200430     D WLREF           S              6
000147200430     D WBFLR           S             12
000148200430     D WBFLRS          S              1
000149200430     D WAFLR           S             12
000150200430     D WAFLRS          S              1
000151200430      *
000152200430     D DSFDY         E DS                  EXTNAME(DSFDY)
000153200430      ** First DS for access programs, short data structure
000154200430      *
000155200430     D DSSDY         E DS                  EXTNAME(DSSDY)
000156200430      ** First DS for access programs, long data structure
000157200430      *
000158200430     D LDA           E DS           256    EXTNAME(LDA)
000159200430      *
000160200430      ** Local data area for database error details
000161200430      ** *LOCK IN LDA immediately before and OUT LDA immediately
000162200430      ** after each database error handling.
000163200430      **
000164200430      **                                    134 141 DBFILE
000165200430      **       Defines:                     142 170 DBKEY
000166200430      **                                    171 180 DBPGM
000167200430      **                                    181 1830DBASE
000168200430
000169200430      ** Main Processing
000170200430     C                   Exsr      SRFLR
000171200430      *
000172200430     C                   RETURN
000173200430      /SPACE 5
000174200430      ********************************************************************
000175200430      * SRFLR  - Floor Rates Update
000176200430      ********************************************************************
000177200430     C     SRFLR         BEGSR
000178200430
000179200430     C                   READ      UTFLRD0
000180200430     C                   DOW       NOT %EOF(UTFLRPD)
000181200430      *
000182200430     C                   Z-ADD     0             x                 2 0
000183200430     C                   Z-ADD     0             y                 2 0
000184200430     C                   Z-ADD     1             n                 2 0
000185200430     C                   MOVE      *BLANKS       WBFLR
000186200430     C                   MOVE      *BLANKS       WBFLRS
000187200430     C                   MOVE      *BLANKS       WAFLR
000188200430     C                   MOVE      *BLANKS       WAFLRS
000189200430      *
000190200430      * Loan Reference
000191200430     C                   EVAL      x = %SCAN(',':Field1:n)
000192200430     C                   EVAL      x = x - 1
000193200430     C                   EVAL      WLREF = %SUBST(Field1:n:x)
000194200430      *
000195200430      * Base Rate Floor
000196200430     C                   EVAL      x = x + 2
000197200430     C                   EVAL      y = %SCAN(',':Field1:x)
000198200430      *
000199200430      * If y <> x then Base Rate Floor has been defined
000200200430     C                   IF        x <> y
000201200430     C                   EVAL      n = y - x
000202200430     C                   EVAL      WBFLR = %SUBST(Field1:x:n)
000203200430     C                   EVAL      y = y + 1
000204200430     C                   EVAL      WBFLRS = %SUBST(Field1:y:1)
000205200430      *
000206200430     C                   ELSE
000207200430      *
000208200430      * If y <> x then All-in Rate Floor has been defined
000209200430     C                   EVAL      x = x + 2
000210200430     C                   EVAL      y = %SCAN(',':Field1:x)
000211200430      *
000212200430     C                   EVAL      n = y - x
000213200430     C                   EVAL      WAFLR = %SUBST(Field1:x:n)
000214200430     C                   EVAL      y = y + 1
000215200430     C                   EVAL      WAFLRS = %SUBST(Field1:y:1)
000216200430     C                   ENDIF
000217200430      *
000218200430      * Format Loan Ref
000219200430     C                   MOVE      *BLANKS       ZFIELD
000220200430     C                   MOVE      WLREF         ZFIELD
000221200430     C                   Z-ADD     0             ZADEC
000222200430     C                   Z-ADD     6             ZADIG
000223200430     C                   CALL      'ZALIGN'
000224200430     C                   PARM      *BLANKS       ZRTN              7
000225200430     C                   PARM                    ZFIELD           16
000226200430     C                   PARM                    ZADEC             1 0
000227200430     C                   PARM                    ZADIG             2 0
000228200430     C                   PARM                    ZAFLD            16
000229200430     C                   MOVE      ZAFLD         WQLNRF            6
000230200430      *
000231200430     C     WQLNRF        CHAIN     XXCLOQY0
000232200430     C                   IF        %FOUND(XXCLOQY0)
000233200430      *
000234200430      * Format Base Rate Floor
000235200430     C                   MOVE      *BLANKS       ZFIELD
000236200430     C                   MOVE      WBFLR         ZFIELD
000237200430     C                   Z-ADD     7             ZADEC
000238200430     C                   Z-ADD     4             ZADIG
000239200430     C                   CALL      'ZALIGN'
000240200430     C                   PARM      *BLANKS       ZRTN              7
000241200430     C                   PARM                    ZFIELD           16
000242200430     C                   PARM                    ZADEC             1 0
000243200430     C                   PARM                    ZADIG             2 0
000244200430     C                   PARM                    ZAFLD            16
000245200430     C                   MOVE      ZAFLD         XQBRTF
000246200430     C                   MOVE      WBFLRS        XQBRSG
000247200430      *
000248200430      * Format All-in Rate Floor
000249200430     C                   MOVE      *BLANKS       ZFIELD
000250200430     C                   MOVE      WAFLR         ZFIELD
000251200430     C                   Z-ADD     7             ZADEC
000252200430     C                   Z-ADD     4             ZADIG
000253200430     C                   CALL      'ZALIGN'
000254200430     C                   PARM      *BLANKS       ZRTN              7
000255200430     C                   PARM                    ZFIELD           16
000256200430     C                   PARM                    ZADEC             1 0
000257200430     C                   PARM                    ZADIG             2 0
000258200430     C                   PARM                    ZAFLD            16
000259200430     C                   MOVE      ZAFLD         XQAIRF
000260200430     C                   MOVE      WAFLRS        XQAISG
000261200430      *
000262200430     C                   UPDATE    XXCLOND0
000263200430     C                   ENDIF
000264200430      *
000265200430     C                   READ      UTFLRPD
000266200430     C                   ENDDO
000267200430      *
000268200430     C                   CLOSE     UTFLRPD
000269200430      *
000270200430     C                   ENDSR
000271200430
000272200430      *****************************************************************
000273200430      /SPACE 5
000274200430      *****************************************************************
000275200430      * *INZSR - Program Initialisation routine                       *
000276200430      *****************************************************************
000277200430     C     *INZSR        BEGSR
000278200430
000279200430      *
000280200430     C     *DTAARA       DEFINE                  LDA
000281200430      *
000282200430     C                   OPEN      UTFLRPD
000283200430      *
000284200430     C                   ENDSR
000285200430      *****************************************************************
000286200430      /SPACE 5
000287200430      *****************************************************************
000288200430      *                                                               *
000289200430      * *PSSR  - Program exception error routine                      *
000290200430      *                                                               *
000291200430      *****************************************************************
000292200430     C     *PSSR         BEGSR
000293200430
000294200430     C                   IF        @RUN = *BLANK
000295200430     C                   EVAL      @RUN = 'Y'
000296200430     C                   DUMP
000297200430     C                   ENDIF
000298200430
000299200430     C                   EVAL      *INU7 = *ON
000300200430     C                   EVAL      *INU8 = *ON
000301200430     C                   EVAL      *INLR = *ON
000302200430     C                   RETURN
000303200430
000304200430     C                   ENDSR
000305200430      *****************************************************************
