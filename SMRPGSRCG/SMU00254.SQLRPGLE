     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
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
 
       Exec SQL
        label on column GPMENUPD
        ( MIACOB text is 'Phase ''G'' Restricted?');
 
       Exec SQL
        label on column GPMENUPD
        ( MIACOB is 'Phs ''G'' Rstrct?');
 
       Exec SQL
        label on column GZSFMENUPD
        ( MIACOB text is 'Phase ''G'' Restricted?');
 
       EXEC SQL
        label on column GZSFMENUPD
        ( MIACOB is 'Phs ''G'' Rstrct?');
 
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
