     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Check if file has moved between releases')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM0259 - Check if file has been moved between releases       *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CUP016 *CREATE     Date 01Apr03               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD046248 - Finastra Rebranding                               *
      *  CUP016 - Add implementation software to core.                *
      *                                                               *
      *****************************************************************
      *
      * File containing list of non-referenced fields
     FSMMTOTPD  IF   E             DISK
      *
     D Recursive       S              1
      *
     C     *ENTRY        PLIST
     C                   PARM                    FileName         10
     C                   PARM                    Type             10
     C                   PARM                    Found             1
      *
     C                   MOVE      'N'           Found
      *
      * Read first record;
     C     1             SETLL     SMMTOTD0
     C                   READ      SMMTOTD0                               99
     C     *IN99         IFEQ      *ON
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   DOU       *IN99 = *ON
      *
     C     MLNAME        IFEQ      FileName
     C     MLTYPE        ANDEQ     Type
     C                   MOVE      'Y'           Found
     C                   SETON                                        99
     C                   ENDIF
      *
     C                   READ      SMMTOTD0                               99
      *
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = 'N'
     C                   EVAL      Recursive = 'Y'
     C                   SETON                                        U7U8
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
