     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax Reset A/cs being closed today')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL008132 - Stamp Tax - Reset Accounts being closed           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd 2010             *
      *                                                               *
      *  Last Amend No. CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
     FACCNTL1   UF   E           K DISK
     FGLCLOSPD  O    E             DISK
      *
     F/EJECT
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
     D*
     D* Get Rundate - Rundate  *
     D*
      /EJECT
      *****************************************************************
      *
      * Read accounts until end of file
      *
     C     *LOVAL        SETLL     ACCNTABF
     C                   READ      ACCNTABF                               90
      *
     C     *IN90         DOWEQ     *OFF
      *
      * Select a/c being closed today
      *
     C     RECI          IFEQ      'D'
     C     ACST          ANDEQ     'C'
      *
     C                   MOVE      RECI          T3RECI
     C                   MOVE      ACST          T3ACST
     C                   MOVE      BRCA          T3BRCA
     C                   MOVE      CNUM          T3CNUM
     C                   MOVE      CCY           T3CCY
     C                   MOVE      ACOD          T3ACOD
     C                   MOVE      ACSQ          T3ACSQ
     C                   MOVE      DACC          T3DACC
     C                   WRITE     @GLCLP0
      *
     C                   MOVE      *BLANKS       ACST
     C                   Z-ADD     *ZEROS        DACC
     C                   UPDATE    ACCNTABF
     C                   ENDIF
      *
      * Read next record
     C                   READ      ACCNTABF                               90
     C                   ENDDO
      *
     C                   MOVEL     *ON           *INLR
     C                   RETURN
      *****************************************************************
**  CPY@
(C) Copyright Misys International Banking Systems Ltd., 2010
