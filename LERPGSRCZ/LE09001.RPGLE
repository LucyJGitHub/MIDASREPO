     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas LE Matured Loans - header and trailer')          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE09001   - Midas LE Matured Loans - header and trailer      *
      *                                                               *
      *  Function:  Ensures there are header and trailer records in   *
      *             History files                                     *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE137 *CREATE     Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE137 - LE Monthly History processing                       *
      *                                                               *
      *****************************************************************
      *
     FMNHSTHH   IF A E           K DISK    INFSR(*PSSR)
     FMNHSTT2   IF A E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     99 - Indicator for read of MNHSTT2/MNHSTHH                *
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
     C                   READ      MNHSTHHF                               99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'H'           RECI
     C                   WRITE     MNHSTHHF
     C                   ENDIF
      *
     C                   READ      MNHSTT2F                               99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'T'           RECI
     C                   Z-ADD     2             NORE
     C                   Z-ADD     0             VLRF
     C                   Z-ADD     0             VLRL
     C                   WRITE     MNHSTT2F
     C                   ENDIF
      *
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
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@ - Object copyright
(c) Finastra International Limited 2012
