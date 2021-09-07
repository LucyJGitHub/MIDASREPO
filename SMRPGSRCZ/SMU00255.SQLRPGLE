     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
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
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD056561           Date 31Aug20               *
      *  Prev Amend No. AR1067493 *CREATE  Date 12Dec12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056561 - Deliverable Data Split for SFMENUPD and GPMTXTPD  *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1067493 - COBOP Upgrade programs amendment                 *
      *                                                               *
      *****************************************************************
      *
     D Recursive       S              1
      /free
       EXEC SQL
        label on column SFMNUCTD
        ( MIACOB text is 'Phase ''G'' Restricted?');

      *EXEC*SQL                                                                             MD056561
      **label*on*column*SFMENUPD                                                            MD056561
      **(*MIACOB*is*'Phs*''G''*Rstrct?');                                                   MD056561

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
