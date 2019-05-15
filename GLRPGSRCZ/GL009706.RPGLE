     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2017')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL CREG CER073 Initialization pgm')              *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL009706 - Midas GL CREG CER073 initialization               *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER073A            Date 05Sep17               *
      *                 CER073   *CREATE   Date 10Jul17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER073A - CER073 Change Control 1 (Recompile)                *
      *  CER073 - AnaCredit Reporting                                 *
      *                                                               *
      *****************************************************************

     FGLCOLLPD  IF   E             DISK    INFSR(*PSSR)

     FGLANACQD  O    E             DISK

      ** =======
      ** D-specs
      ** =======

     D GLANAC        E DS                  EXTNAME(GLANACQD)

      *****************************************************************
      /EJECT
      *****************************************************************

     C                   CLEAR                   GLANAC

     C     1             SETLL     GLCOLLPD
     C                   READ      GLCOLLPD

     C                   DOW       NOT %EOF(GLCOLLPD)
     C                   EVAL      ACCREF = CDCREF
     C                   EVAL      ACBRCD = CDBBRC

     C                   WRITE     GLANACD0
     C                   READ      GLCOLLPD
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
