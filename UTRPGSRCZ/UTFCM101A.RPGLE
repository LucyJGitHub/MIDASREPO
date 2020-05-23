     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Populate Contractual Rates and Ex File')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data                                        *
      *                                                               *
      *  UTFCM101A - Midas UT Populate Contractual Rates and Ex File  *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. FCM101  *CREATE    Date 13Mar19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  FCM101 - Floor Rates                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N  O F  I N D I C A T O R S                    *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      * SRFLR  - Floor Rates Update                                   *
      *                                                               *
      *****************************************************************
 
      * Midas LE Loan Details
     FCLOANCL   UF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      * Midas XX Customer Loans A record extension File
     FXXCLOQX0  O    E             DISK    INFSR(*PSSR)
     F                                     USROPN
      *
     D @RUN            S              1
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** First DS for access programs, long data structure
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** Main Processing
     C                   Exsr      SRMain
      *
     C                   RETURN
      /SPACE 5
      ********************************************************************
      * SRMain - Main Processing
      ********************************************************************
     C     SRMain        BEGSR
 
     C                   OPEN      CLOANCL
     C                   OPEN      XXCLOQX0
     C                   READ      CLOANCL
     C                   DOW       NOT %EOF(CLOANCL)
      *
     C                   Z-ADD     RTSP          CNSP
     C                   MOVE      SPIN          CNSG
     C                   UPDATE    CLOANCLF
      *
     C                   MOVE      LNRF          XQLNRF
     C                   Z-ADD     0             XQBRTF
     C                   MOVE      ' '           XQBRSG
     C                   Z-ADD     0             XQAIRF
     C                   MOVE      ' '           XQAISG
     C                   WRITE     XXCLOND0
      *
     C                   READ      CLOANCL
     C                   ENDDO
      *
     C                   CLOSE     CLOANCL
     C                   CLOSE     XXCLOQX0
     C                   ENDSR
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************