     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas RE Write header and trailer records')            *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE3666T1 - Midas RE Write header and trailer records         *
      *                                                               *
      *  Function:  Write a header and trailer record once only       *
      *             for the task split of RE3666.                     *
      *                                                               *
      *  Called By: RE3666T1                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CRE093   *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE093 - Tactical COB changes REC3666                        *
      *                                                               *
      *****************************************************************
      *
     FGEIERHH   IF A E           K DISK    INFSR(*PSSR)
     FGEIERZZ   IF A E           K DISK    INFSR(*PSSR)
     FGEIER2HH  IF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTHHF:APOSTH2F)
     FGEIER2ZZ  IF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTZZF:APOSTZ2F)
     FRTZZ      IF A E           K DISK    INFSR(*PSSR)
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
      *
     C     *ENTRY        PLIST
     C                   PARM                    MODE              3
      *
     C                   MOVEA     CPY@          BIS@             80
      *
     C     MODE          IFEQ      'TWO'
     C                   READ      GEIER2HH                               99
     C                   ELSE
     C                   READ      GEIERHH                                99
     C                   ENDIF
      *
     C     *IN99         IFEQ      *ON
     C                   MOVE      'H'           RECI
     C     MODE          IFEQ      'TWO'
     C                   WRITE     APOSTH2F
     C                   ELSE
     C                   WRITE     APOSTHHF
     C                   ENDIF
     C                   ENDIF
      *
     C     MODE          IFEQ      'TWO'
     C                   READ      GEIER2ZZ                               99
     C                   ELSE
     C                   READ      GEIERZZ                                99
     C                   ENDIF
     C     *IN99         IFEQ      *ON
     C                   MOVE      'T'           RECI
     C                   Z-ADD     2             NORE1
     C                   Z-ADD     0             HRWN
     C                   Z-ADD     0             HRDC
     C     MODE          IFEQ      'TWO'
     C                   WRITE     APOSTZ2F
     C                   ELSE
     C                   WRITE     APOSTZZF
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      RTZZ                                   99
     C     *IN99         IFEQ      *ON
     C                   MOVE      'T'           RECI
     C                   Z-ADD     2             NORE
     C                   WRITE     RTZZF
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
(c) Misys International Banking Systems Ltd. 2012
