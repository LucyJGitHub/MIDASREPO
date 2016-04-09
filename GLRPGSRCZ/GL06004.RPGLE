     H DEBUG(*YES)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account posting - trailer records')           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL06004   - GL Balances Task Split Copy Data                 *
      *                                                               *
      *  Function:  Write a header and trailer record once only       *
      *             for the task split of GL0600.                     *
      *                                                               *
      *  Called By: GLC0600T1                                         *
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
     FACCNTAA   UF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *  U7+U8 - Database error                                       *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
      ** Local data area for database error details
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Program Status Data Structure
      *
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * Main
      *****************************************************************
      *
     C                   READ      ACCNTAAF
     C                   EVAL      RECI = 'H'
     C                   EVAL      ORDI = 'Y'
     C                   EVAL      FLSZ = 0
     C                   UPDATE    ACCNTAAF
      *
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
