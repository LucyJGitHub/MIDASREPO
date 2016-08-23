     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM MIACOB field text chg for zone')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00255 - Update MIACOB field text on menu items files      *
      *                                                               *
      *  Function:  This applies label text change on all necessary   *
      *             zone menu items files with MIACOB field as it is  *
      *             reused as Phase G restriction flag.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR1067493 *CREATE  Date 12Dec12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1067493 - COBOP Upgrade programs amendment                 *
      *                                                               *
      *****************************************************************
      *
     D Recursive       S              1
      /free
       EXEC SQL
        label on column SFMENUPD
        ( MIACOB text is 'Phase ''G'' Restricted?');
 
       EXEC SQL
        label on column SFMENUPD
        ( MIACOB is 'Phs ''G'' Rstrct?');
 
                 Return;
      /EJECT
       //-------------------------------------------------------------*
       // *PSSR  - Program exception error routine                    *
       //          Called automatically if a program error occurs,    *
       //          or directly by the program code using EXSR.        *
       //          This subroutine DUMPs the program just once.       *
       //-------------------------------------------------------------*
          BegSr *PSSR;
             If Recursive = *BLANKS;
                Dump;
                Return;
             EndIf;
          EndSr;
      /end-free
      *****************************************************************
