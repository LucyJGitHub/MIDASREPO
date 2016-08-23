     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL A/C Posting Hist Purge Audit Report Print')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL4450T4 - Midas GL A/C Postings History Purge Audit         *
      *             Report Print                                      *
      *                                                               *
      *  Called By: REC4450T4                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CGL127AY *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL127AY - COB Restructure - GL COB Optimisation Phase 1     *
      *                                                               *
      *****************************************************************
      *
     FGLACHPZZ  IF   E             DISK
      ** Summary File for number of postings dropped
      *
     FGL4450AU  O    E             PRINTER
      ** Audit report
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *     01 - READ indicator for GLACHPZZ                          *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *
      ** Add up all the NOPP from GLACHPZZ
      *
     C                   READ      GLACHPZZ                               01
      *
     C     *IN01         DOWEQ     '0'
      *
     C                   ADD       NOPP          NDROP
      *
     C                   READ      GLACHPZZ                               01
      *
     C                   ENDDO
      *
      ** Print total number of psotings purged
      *
     C                   WRITE     HEADING
     C                   WRITE     DETAIL
     C                   WRITE     ENDRPT
      *
     C                   SETON                                        LR
      *
