     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GL Load Statement Requests with Priority')       *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL43T0 - Midas GL Load Statement Requests with Priority      *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. CGL188   *Create   Date 19Feb18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL188 - COB Optimisation of GL0420                          *
      *                                                               *
      *****************************************************************
     FSTMTS     IF   E           K DISK    IGNORE(STMTHHF)
      *                                    IGNORE(STMTZXF)
      *
     FGLSTBAL0  IF   E           K DISK    PREFIX(BA)
     FGLSTPRPD  O    E             DISK    RENAME(STMTAHF:GLSTPRP0)
      *******************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
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
      *******************************************************************
      *
     C     KEY01         KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Define LDA
     C     *DTAARA       DEFINE                  LDA
      *
      *
     C                   Read      STMTS                                  80
     C     *IN80         Doweq     *Off
      *
     C     KEY01         Chain     GLSTBAL0                           81
     C     *IN81         Ifeq      *Off
     C                   move      'A'           RPTY
     C                   else
     C                   move      'Z'           RPTY
     C                   Endif
      *
     C                   write     GLSTPRP0
      *
     C                   read      STMTS                                  80
     C                   Enddo
      *
     C                   move      *ON           *INLR
     C                   Return
      *
      *******************************************************************
** CPY@ - Object copyright
(c) Finastra International Limited 2018
