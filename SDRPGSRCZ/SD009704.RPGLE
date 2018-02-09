     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2017')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CER073 Initialization pgm')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009704 - Midas SD CER073 initialization                    *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
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

     FSDCUSTPD  IF   E             DISK    INFSR(*PSSR)

     FSDANACQD  O    E             DISK

      ** =======
      ** D-specs
      ** =======

     D SDANAC        E DS                  EXTNAME(SDANACQD)

      *****************************************************************
      /EJECT
      *****************************************************************

     C                   CLEAR                   SDANAC

     C     1             SETLL     SDCUSTPD
     C                   READ      SDCUSTPD

     C                   DOW       NOT %EOF(SDCUSTPD)
     C                   EVAL      ACCUSN = BBCUST
     C                   EVAL      ACBRCD = BBBRCD

     C                   WRITE     SDANACD0
     C                   READ      SDCUSTPD
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
