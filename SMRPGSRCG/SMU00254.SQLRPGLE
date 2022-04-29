     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM MIACOB field text chg for global')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00254 - Update MIACOB field text on menu items files      *
      *                                                               *
      *  Function:  This applies label text change on all necessary   *
      *             global menu items files with MIACOB field as it is*
      *             reused as Phase G restriction flag.               *
      *             This ensures permission data for menu item        *
      *             0000000659 is removed from BF layer.              *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD059814           Date 28Apr22               *
      *  Prev Amend No. AR1067493 *CREATE  Date 12Dec12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059814 - Comment out label changes as already delivered    *
      *  AR1067493 - COBOP Upgrade programs amendment                 *
      *                                                               *
      *****************************************************************
      *
     D Recursive       S              1
      /free

      //xec SQL                                                                             MD059814
      //label on column GPMENUPD                                                            MD059814
      //( MIACOB text is 'Phase ''G'' Restricted?');                                        MD059814

      //xec SQL                                                                             MD059814
      //label on column GPMENUPD                                                            MD059814
      //( MIACOB is 'Phs ''G'' Rstrct?');                                                   MD059814

      //xec SQL                                                                             MD059814
      //label on column GZSFMENUPD                                                          MD059814
      //( MIACOB text is 'Phase ''G'' Restricted?');                                        MD059814

      //XEC SQL                                                                             MD059814
      //label on column GZSFMENUPD                                                          MD059814
      //( MIACOB is 'Phs ''G'' Rstrct?');                                                   MD059814

       // Removal of menu item 0000000659 permission data

       Exec SQL
        Delete from BFTB_RESOURCEPERM
        where BFRESOURCEID like '%0000000659%';


       Exec SQL
        Delete from BFTB_RESOURCE
        where BFARTEFACTID like '%0000000659%';

       Exec SQL
        Delete from BFTB_PERMISSION
        where BFPERMISSIONNAME like '%0000000659%';

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
