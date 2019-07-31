     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas LE History processing - trailers update')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE09002   - Midas LE History processing - trailers update    *
      *                                                               *
      *  Function:  Update LEHISTPD and LEHIDTPD files                *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE137  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE137 - LE Monthly History processing                       *
      *                                                               *
      *****************************************************************
      *
     FMNHSTT2   UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     PREFIX(T2_)
     FLEHISTPD  IF   E           K DISK    INFSR(*PSSR)
     FHISTSZX   UF   E             DISK    INFSR(*PSSR) COMMIT
     F                                     PREFIX(ZX_)
     FLEHIDTPD  IF   E           K DISK    INFSR(*PSSR)
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
      *
     C                   z-add     0             TOTVLRF2         18 0
     C                   z-add     0             TOTVLRF          18 0
     C                   z-add     0             TOTNORE           5 0
      *
      ** Process LEHISTPD and update MNHSTT2
      *
     C                   READ      LEHISTPD                               99
      *
     C     *IN99         DOWEQ     *OFF
      *
     C     NORE          ADD       TOTNORE       TOTNORE
     C                   EVAL      TOTVLRF  = TOTVLRF + (VLRF * 1000) + VLRL
      *
     C                   READ      LEHISTPD                               99
     C                   ENDDO
      *
     C     1             CHAIN     MNHSTT2                            99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'MNHSTT2'     DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ELSE
     C     TOTNORE       ADD       T2_NORE       T2_NORE
      *
     C                   EVAL      TOTVLRF2 = (T2_VLRF * 1000) + T2_VLRL
     C     TOTVLRF       ADD       TOTVLRF2      TOTVLRF2
      *
     C                   EVAL      T2_VLRF = (TOTVLRF2 / 1000)
     C                   EVAL      T2_VLRL = TOTVLRF2 - (T2_VLRF * 1000)
      *
     C                   UPDATE    MNHSTT2F
      *
     C                   ENDIF
      *
      ** Process LEHIDTPD and update HISTSZX
      *
     C                   z-add     0             TOTNORE           5 0
      *
     C                   READ      LEHIDTPD                               99
      *
     C     *IN99         DOWEQ     *OFF
     C                   ADD       NOREDL        TOTNORE
     C                   READ      LEHIDTPD                               99
     C                   ENDDO
      *
     C     1             CHAIN     HISTSZX                            99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'HISTSZX'     DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ELSE
     C     ZX_NORE       SUB       TOTNORE       ZX_NORE
     C     ZX_NORE       Iflt      0
     C     100000        ADD       ZX_NORE       ZX_NORE
     C                   Endif
      *
     C                   UPDATE    HISTSZXF
      *
     C                   ENDIF
      *
     C                   COMMIT
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
