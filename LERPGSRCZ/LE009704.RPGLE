     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2017')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE CER073 CLIP Initialization pgm')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE009704 - Midas LE CER073 CLIP initialization               *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER073B            Date 25Sep17               *
      *                 CER073A            Date 05Sep17               *
      *                 CER073   *CREATE   Date 10Jul17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - Libor Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CER073B - CER073 Change Control 2 (Recompile)                *
      *  CER073A - CER073 Change Control 1 (Recompile)                *
      *  CER073 - AnaCredit Reporting                                 *
      *                                                               *
      *****************************************************************

     FCLOANCL   IF   E             DISK    INFSR(*PSSR)

     FLEANACQD  O    E             DISK

      ** =======
      ** D-specs
      ** =======

     D LEANAC        E DS                  EXTNAME(LEANACQD)

      *****************************************************************
      /EJECT
      *****************************************************************

     C                   CLEAR                   LEANAC

     C     1             SETLL     CLOANCL
     C                   READ      CLOANCL

     C                   DOW       NOT %EOF(CLOANCL)
     C                   EVAL      ACLNRF = LNRF
     C                   EVAL      ACBRCD = BRCA

     C                   WRITE     LEANACD0
     C                   READ      CLOANCL
     C                   ENDDO


     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
