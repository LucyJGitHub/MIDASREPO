     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Rollover Instructions Input')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LE3166 - Rollover rate fixing validation for confirmation    *
      *                                                               *
      *  Function:  This program will check if there is               *
      *             a Rollover fix advice required.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. AR925993  *CREATE  Date 13Jul16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR925993 - Rollover rate fixing does not produce confirmation*
      *             advice. Before submitting job LEC3165 program     *
      *             will check if there is need to produce rollover   *
      *             fix rate advice. (Child: AR925994)                *
      *           - Applied for MD039397.                             *
      *                                                               *
      *****************************************************************

     FCLOANCL   IF   E           K DISK    INFSR(*PSSR)

     D @RUN            S              1
     D CTR             S              1  0

      ** +----------------------------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ Start of Main processing.                                      ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C     *ENTRY        PLIST

      ** Output Parameters

     C                   PARM                    CTR
      *
     C                   EVAL      CTR = 0

     C                   READ      CLOANCL                                99
     C     *IN99         DOWEQ     '0'
     C     CTR           ANDEQ     0
     C                   IF        RFAR = 'Y'
     C                   EVAL      CTR = CTR + 1
     C                   ENDIF

     C                   READ      CLOANCL                                99
     C                   ENDDO

     C                   EVAL      *INLR = *ON

      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
