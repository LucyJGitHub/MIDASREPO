     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2019')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Populate Floor Rates')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data                                        *
      *                                                               *
      *  UTFCM101B - Midas UT Populate Floor Rates                    *
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
 
      * Midas UT Floor Rates Details
     FUTFLRPD   IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      * Midas XX Customer Loans A record extension File
     FXXCLOQY0  UF   E           K DISK    INFSR(*PSSR)
      *
     D @RUN            S              1
     D ZWDTIN          S              8S 0
     D DateOut         S              8S 0
     D @@DAYN          S              5P 0
     D TimeStamp       S               Z
     D WLREF           S              6
     D WBFLR           S             12
     D WBFLRS          S              1
     D WAFLR           S             12
     D WAFLRS          S              1
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
     C                   Exsr      SRFLR
      *
     C                   RETURN
      /SPACE 5
      ********************************************************************
      * SRFLR  - Floor Rates Update
      ********************************************************************
     C     SRFLR         BEGSR
 
     C                   READ      UTFLRD0
     C                   DOW       NOT %EOF(UTFLRPD)
      *
     C                   Z-ADD     0             x                 2 0
     C                   Z-ADD     0             y                 2 0
     C                   Z-ADD     1             n                 2 0
     C                   MOVE      *BLANKS       WBFLR
     C                   MOVE      *BLANKS       WBFLRS
     C                   MOVE      *BLANKS       WAFLR
     C                   MOVE      *BLANKS       WAFLRS
      *
      * Loan Reference
     C                   EVAL      x = %SCAN(',':Field1:n)
     C                   EVAL      x = x - 1
     C                   EVAL      WLREF = %SUBST(Field1:n:x)
      *
      * Base Rate Floor
     C                   EVAL      x = x + 2
     C                   EVAL      y = %SCAN(',':Field1:x)
      *
      * If y <> x then Base Rate Floor has been defined
     C                   IF        x <> y
     C                   EVAL      n = y - x
     C                   EVAL      WBFLR = %SUBST(Field1:x:n)
     C                   EVAL      y = y + 1
     C                   EVAL      WBFLRS = %SUBST(Field1:y:1)
      *
     C                   ELSE
      *
      * If y <> x then All-in Rate Floor has been defined
     C                   EVAL      x = x + 2
     C                   EVAL      y = %SCAN(',':Field1:x)
      *
     C                   EVAL      n = y - x
     C                   EVAL      WAFLR = %SUBST(Field1:x:n)
     C                   EVAL      y = y + 1
     C                   EVAL      WAFLRS = %SUBST(Field1:y:1)
     C                   ENDIF
      *
      * Format Loan Ref
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      WLREF         ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM                    ZAFLD            16
     C                   MOVE      ZAFLD         WQLNRF            6
      *
     C     WQLNRF        CHAIN     XXCLOQY0
     C                   IF        %FOUND(XXCLOQY0)
      *
      * Format Base Rate Floor
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      WBFLR         ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   Z-ADD     4             ZADIG
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM                    ZAFLD            16
     C                   MOVE      ZAFLD         XQBRTF
     C                   MOVE      WBFLRS        XQBRSG
      *
      * Format All-in Rate Floor
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      WAFLR         ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   Z-ADD     4             ZADIG
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM                    ZAFLD            16
     C                   MOVE      ZAFLD         XQAIRF
     C                   MOVE      WAFLRS        XQAISG
      *
     C                   UPDATE    XXCLOND0
     C                   ENDIF
      *
     C                   READ      UTFLRPD
     C                   ENDDO
      *
     C                   CLOSE     UTFLRPD
      *
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
     C                   OPEN      UTFLRPD
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