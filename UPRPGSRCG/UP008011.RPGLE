     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*XBI *  CRTPF FILE(QTEMP/UPERRMQT) RCDLEN(100)                       *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Write Warning messages and produce report')   *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP008011 - Write Warning messages and produce report         *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD056774 *CREATE   Date 16Sep20               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD056774 - ZINZ contains error in spool after run.           *
      *           - Applied for MD-56883.                             *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file indicator
      *       37      Overflow indicator
      *
     FUPERRMQT  IF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(UPERRMQT:ERRM)
     F                                     PREFIX(X)
     FUP008011P1O    E             PRINTER INFDS(SPOOL)
     F                                     INFSR(*PSSR)
     F                                     OFLIND(*IN37)
     F                                     USROPN
      *
      /EJECT
      *
      * File information data structure for P1 file; used for page end
      *   handling
     D SPOOL           DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
     D  OFLLN                188    189B 0
     D  PRTLN                367    368B 0
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      * Local data area for database error details
      * *LOCK IN LDA immediately before and OUT LDA immediately
      * after each database error handling.
      *
      *                                     134 141 DBFILE
      *        Defines:                     142 170 DBKEY
      *                                     171 180 DBPGM
      *                                     181 1830DBASE
      *
     D PSDS           SDS
      *
      * Program Status Data Structure.
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode              7
     C                   PARM                    GenPgmName       10
     C                   PARM                    Message         100
      *
      * *WRITE mode
     C     Mode          IFEQ      '*WRITE'
     C                   MOVEL     Message       XUPERRMQT
     C                   WRITE     ERRM
     C                   ENDIF
      *
      * *REPORT mode
     C     Mode          IFEQ      '*REPORT'
     C                   OPEN      UP008011P1
      *
     C                   EVAL      #GENPGM  = GenPgmName
     C                   WRITE     HEADPY
      *
     C     1             SETLL     ERRM
      *
     C                   READ      UPERRMQT                               20
      *
      * If there are no records at all write 'no records'.
     C     *IN20         IFEQ      *ON
     C                   WRITE     NORECS
     C                   GOTO      ENDPGM
      *
     C                   ENDIF
      *
     C     *IN20         DOWEQ     *OFF
      *
      * Write headers if overflow on.
     C     *IN37         IFEQ      *ON
     C                   WRITE     HEADPY
     C                   SETOFF                                       37
     C                   ENDIF
      *
     C                   MOVEL     XUPERRMQT     #ERRM
     C                   WRITE     DETAIL
      *
     C                   READ      UPERRMQT                               20
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   WRITE     TRAILPY
     C                   CLOSE     UP008011P1
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
