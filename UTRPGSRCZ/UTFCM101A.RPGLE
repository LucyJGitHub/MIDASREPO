000100200430     H DEBUG
000101200430     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2019')
000102200430      *****************************************************************
000103200430/*STD *  RPGBASEBND                                                   *
000104200430/*EXI *  TEXT('Midas UT Populate Contractual Rates and Ex File')      *
000105200430      *****************************************************************
000106200430      *                                                               *
000107200430      *  Midas - Standing Data                                        *
000108200430      *                                                               *
000109200430      *  UTFCM101A - Midas UT Populate Contractual Rates and Ex File  *
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
000134200430      * Midas LE Loan Details
000135200430     FCLOANCL   UF   E             DISK    INFSR(*PSSR)
000136200430     F                                     USROPN
000137200430      *
000138200430      * Midas XX Customer Loans A record extension File
000139200430     FXXCLOQX0  O    E             DISK    INFSR(*PSSR)
000140200430     F                                     USROPN
000141200430      *
000142200430     D @RUN            S              1
000143200430      *
000144200430     D DSFDY         E DS                  EXTNAME(DSFDY)
000145200430      ** First DS for access programs, short data structure
000146200430      *
000147200430     D DSSDY         E DS                  EXTNAME(DSSDY)
000148200430      ** First DS for access programs, long data structure
000149200430      *
000150200430     D LDA           E DS           256    EXTNAME(LDA)
000151200430      *
000152200430      ** Local data area for database error details
000153200430      ** *LOCK IN LDA immediately before and OUT LDA immediately
000154200430      ** after each database error handling.
000155200430      **
000156200430      **                                    134 141 DBFILE
000157200430      **       Defines:                     142 170 DBKEY
000158200430      **                                    171 180 DBPGM
000159200430      **                                    181 1830DBASE
000160200430
000161200430      ** Main Processing
000162200430     C                   Exsr      SRMain
000163200430      *
000164200430     C                   RETURN
000165200430      /SPACE 5
000166200430      ********************************************************************
000167200430      * SRMain - Main Processing
000168200430      ********************************************************************
000169200430     C     SRMain        BEGSR
000170200430
000171200430     C                   OPEN      CLOANCL
000172200430     C                   OPEN      XXCLOQX0
000173200430     C                   READ      CLOANCL
000174200430     C                   DOW       NOT %EOF(CLOANCL)
000175200430      *
000176200430     C                   Z-ADD     RTSP          CNSP
000177200430     C                   MOVE      SPIN          CNSG
000178200430     C                   UPDATE    CLOANCLF
000179200430      *
000180200430     C                   MOVE      LNRF          XQLNRF
000181200430     C                   Z-ADD     0             XQBRTF
000182200430     C                   MOVE      ' '           XQBRSG
000183200430     C                   Z-ADD     0             XQAIRF
000184200430     C                   MOVE      ' '           XQAISG
000185200430     C                   WRITE     XXCLOND0
000186200430      *
000187200430     C                   READ      CLOANCL
000188200430     C                   ENDDO
000189200430      *
000190200430     C                   CLOSE     CLOANCL
000191200430     C                   CLOSE     XXCLOQX0
000192200430     C                   ENDSR
000193200430
000194200430      *****************************************************************
000195200430      /SPACE 5
000196200430      *****************************************************************
000197200430      * *INZSR - Program Initialisation routine                       *
000198200430      *****************************************************************
000199200430     C     *INZSR        BEGSR
000200200430      *
000201200430     C     *DTAARA       DEFINE                  LDA
000202200430      *
000203200430     C                   ENDSR
000204200430      *****************************************************************
000205200430      /SPACE 5
000206200430      *****************************************************************
000207200430      *                                                               *
000208200430      * *PSSR  - Program exception error routine                      *
000209200430      *                                                               *
000210200430      *****************************************************************
000211200430     C     *PSSR         BEGSR
000212200430
000213200430     C                   IF        @RUN = *BLANK
000214200430     C                   EVAL      @RUN = 'Y'
000215200430     C                   DUMP
000216200430     C                   ENDIF
000217200430
000218200430     C                   EVAL      *INU7 = *ON
000219200430     C                   EVAL      *INU8 = *ON
000220200430     C                   EVAL      *INLR = *ON
000221200430     C                   RETURN
000222200430
000223200430     C                   ENDSR
000224200430      *****************************************************************
