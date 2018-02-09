     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas RE Trailers Update')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE3666T4 - Midas RE Trailers update for RE3666               *
      *                                                               *
      *  Function:  Update RTZZ and GEIERZZ files                     *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE093  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE093 - Tactical COB changes REC3666                        *
      *                                                               *
      *****************************************************************
      *
     FRTZZ      UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     PREFIX(T2_)
     FREACRLZZ  IF   E             DISK    INFSR(*PSSR)
     FGEIERZZ   UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     PREFIX(ZX_)
     FREGEIEZZ  IF   E             DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     99 - Indicator for read                                   *
      *                                                               *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * Main
      *****************************************************************
     C                   MOVEA     CPY@          BIS@             80
 
     C                   Z-ADD     0             TOTVLRF2         18 0
     C                   Z-ADD     0             TOTVLRF          18 0
     C                   Z-ADD     0             TOTNORE           5 0
 
      ** Process REGEIEZZ and update GEIERZZ
 
     C                   READ      REGEIEZZ                               99
 
     C     *IN99         DOWEQ     *OFF
 
     C     NORE1         ADD       TOTNORE       TOTNORE
     C                   EVAL      TOTVLRF  = TOTVLRF + (HRWN * 1000) + HRDC
 
     C                   READ      REGEIEZZ                               99
     C                   ENDDO
 
     C     1             CHAIN     GEIERZZ                            99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'GEIERZZ'     DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ELSE
     C     TOTNORE       ADD       ZX_NORE1      ZX_NORE1
 
     C                   EVAL      TOTVLRF2 = (ZX_HRWN * 1000) + ZX_HRDC
     C     TOTVLRF       ADD       TOTVLRF2      TOTVLRF2
 
     C                   EVAL      ZX_HRWN = (TOTVLRF2 / 1000)
     C                   EVAL      ZX_HRDC = TOTVLRF2 - (ZX_HRWN * 1000)
 
     C                   UPDATE    APOSTZZF
 
     C                   ENDIF
 
      ** Process REACRLZZ and update RTZZ
 
     C                   Z-ADD     0             TOTNORE           5 0
 
     C                   READ      REACRLZZ                               99
 
     C     *IN99         DOWEQ     *OFF
     C                   ADD       NORE          TOTNORE
     C                   READ      REACRLZZ                               99
     C                   ENDDO
 
     C     1             CHAIN     RTZZ                               99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'RTZZ   '     DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ELSE
     C                   ADD       TOTNORE       T2_NORE
     C                   UPDATE    RTZZF
     C                   ENDIF
 
     C                   COMMIT
 
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      * Calls: None                                                   *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@ - Object copyright
(c) Finastra International Limited 2012
