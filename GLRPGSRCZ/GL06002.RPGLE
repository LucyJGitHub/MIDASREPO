     H DEBUG(*YES)
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account posting - trailer records')           *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL06002   - GL Balances Task Split Copy Data                 *
      *                                                               *
      *  Function:  Write a header and trailer record once only       *
      *             for the task split of GL0600.                     *
      *                                                               *
      *  Called By: GLC0600T1                                         *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL142             Date 06Aug12               *
      *                 CGL120  *CREATE    Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL142 - Tactical COB changes GL                             *
      *  CGL120 - GL COB Components Task Split                        *
      *                                                               *
      *****************************************************************
      *
     FSTMTHH    IF A E           K DISK    INFSR(*PSSR)
     F**********                           EXTIND(*INU1)                                      CGL142
     FSTMTZX    IF A E           K DISK    INFSR(*PSSR)
     F**********                           EXTIND(*INU1)                                      CGL142
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
     C                   READ      STMTHHF
     C                   IF        %EOF(STMTHH) = '1'
     C                   EVAL      RECI = 'H'
     C                   WRITE     STMTHHF
     C                   ENDIF
     C                   READ      STMTZXF
     C                   IF        %EOF(STMTZX) = '1'
     C                   EVAL      RECI = 'T'
     C                   EVAL      NORE1 = 2
     C                   WRITE     STMTZXF
     C                   ENDIF
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
