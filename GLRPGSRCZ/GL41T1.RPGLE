     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Daily report Merge-Trailer records')          *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL41T1 - Midas GL Daily Report Merge - Trailer               *
      *                                                               *
      *  Function:  Write a header and trailer record once only       *
      *             for the task split of GLC41.                      *
      *                                                               *
      *  Called By: GLC41T1                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CGL120  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL120 - GL COB Components Task Split                        *
      *                                                               *
      *****************************************************************
      *
     FEODPOHH   IF A E           K DISK    INFSR(*PSSR)
     FEODPOZZ   IF A E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     90 - Indicator for dummy read of GLACBAPD                 *
      *                                                               *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
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
      * Main Processing                                               *
      *****************************************************************
      *
      ** Update Header File
      *
     C                   READ      APOSTHHF                               99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'H'           RECI
     C                   WRITE     APOSTHHF
     C                   ENDIF
      *
      ** Update Trailer File
      *
     C                   READ      APOSTZZF                               99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'T'           RECI
     C                   Z-ADD     2             NORE1
     C                   WRITE     APOSTZZF
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
