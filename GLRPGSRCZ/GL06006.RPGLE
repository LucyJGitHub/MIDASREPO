     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Header and trailer record for REOUTLPA/PT')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL06006 - Header and Trailer record for REOUTLPA/PT          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CGL142  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL142 - Tactical COB changes GL                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     90 - Indicator for dummy read of REOUTLPA/PT files        *
      *                                                               *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
      *
     FREOUTLPA  IF A E           K DISK    INFSR(*PSSR)
     F                                     EXTIND(*INU4)
     FREOUTLPT  IF A E           K DISK    INFSR(*PSSR)
     F                                     EXTIND(*INU4)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Program Status Data Structure
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
      ** Main Processing
 
     C                   READ      REOUTLPA                               99
     C                   IF        *IN99 = *ON
     C                   MOVE      'H'           GRECI
     C                   WRITE     REOUTLA0
     C                   ENDIF
     C                   READ      REOUTLPT                               99
     C                   IF        *IN99 = *ON
     C                   MOVE      'T'           GRECI
     C                   Z-ADD     2             GNREC
     C                   Z-ADD     0             GHWNP
     C                   Z-ADD     0             GHDCP
     C                   Z-ADD     0             GHWNT
     C                   Z-ADD     0             GHDCT
     C                   WRITE     REOUTLT0
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
