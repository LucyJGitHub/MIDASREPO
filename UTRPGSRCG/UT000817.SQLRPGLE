     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2024')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('CTR004 Initialization Program')                        *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  UT000817 - CTR004 Initialization Program                     *
      *                                                               *
      *  Function: The purpose of the pgm is to initialise GLRFAT to  *
      *            'S' (String)                                       *
      *                                                               *
      *  (c) Finastra International Limited 2024                      *
      *                                                               *
      *  Last Amend No. CTR004  *CREATE    Date 06Mar24               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CTR004 - UDF reference fields length                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *

      /free

       // Process GPPDWJPP. Add Attribute 'S' if blanks.

       EXEC SQL
         Update GPPDWJPP set GLRFAT = 'S'
           where GLRFAT = ' ';

       If SQLCode <> 0 and
         SQLCode <> 100;
         ExSR *PSSR;
       EndIf;

       Eval *INLR = *ON;
       Return;

      /end-free

      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BegSR

     C                   Dump
      /free
        Eval *INU7 = *ON;
        Eval *INU8 = *ON;
        Eval *INLR = *ON;
        Return;
      /end-free
     C                   EndSR
