     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Account balances extract')                    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL3320T1 - Midas GL Account balances extract                 *
      *                                                               *
      *  Function:  Write a header and trailer record once only       *
      *             for the task split of GL3320.                     *
      *                                                               *
      *  Called By: GLC3320T1                                         *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL120 *CREATE     Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL120 - GL COB Components Task Split                        *
      *                                                               *
      *****************************************************************
 
     FABEXHH    IF A E           K DISK    INFSR(*PSSR)
     FABEXZY    IF A E           K DISK    INFSR(*PSSR)
 
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
 
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
 
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * Main
      *****************************************************************
 
      ** Update Header File
 
     C                   READ      ABEXHHF                                99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'H'           RECI
     C                   WRITE     ABEXHHF
     C                   ENDIF
 
      ** Update Trailer File
 
     C                   READ      ABEXZYF                                99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'T'           RECI
     C                   Z-ADD     2             NORE
     C                   WRITE     ABEXZYF
     C                   ENDIF
 
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
