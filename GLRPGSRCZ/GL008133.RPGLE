     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax Update A/cs for closure today')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL008133 - Stamp Tax - Reset accounts being closed           *
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
     FACCNT     UF   E           K DISK
     F                                     IGNORE(ACCNTAAF:ACCNTACF)
     FGLCLOSL0  IF   E           K DISK
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
     C     Kaccnt        Klist
     C                   Kfld                    T3CNUM
     C                   Kfld                    T3CCY
     C                   Kfld                    T3ACOD
     C                   Kfld                    T3ACSQ
     C                   Kfld                    T3BRCA
      *
      * Read accounts until end of file
      *
     C     *LOVAL        SETLL     GLCLOSL0
     C                   READ      GLCLOSL0                               90
      *
     C     *IN90         DOWEQ     *OFF
      *
      * Select a/c being closed today
      *
     C     T3RECI        IFEQ      'D'
     C     T3ACST        ANDEQ     'C'
      *
     C     KACCNT        CHAIN     ACCNT                              80
     C     *IN80         IFEQ      *OFF
     C                   MOVE      'C'           ACST
     C                   MOVE      T3DACC        DACC
     C                   UPDATE    ACCNTABF
     C                   ENDIF
      *
     C                   ENDIF
      * Read next record
     C                   READ      GLCLOSL0                               90
     C                   ENDDO
      *
     C                   MOVEL     *ON           *INLR
     C                   RETURN
      *****************************************************************
**  CPY@
(C) Copyright Misys International Banking Systems Ltd., 2010
