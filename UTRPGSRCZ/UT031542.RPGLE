     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Utility to change description of SF')         *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT031542 - Midas UT Utility to change description of SF      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. MD031542 *CREATE   Date 14Jan15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD031542 - Utility to update switchable feature description  *
      *             in file SCSARDPD and SCSAREPD if exist from file  *
      *             SCSARSPD                                          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas SC All core switchable feature details
     FSCSARSPD  IF   E             DISK

      ** Midas SC Enabled/disabled switchable features file
     FSCSAREL1  UF   E           K DISK
     F

     C*****************************************************************
     C/EJECT
     C*****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      /free
                 // Read all records in SCSARSPD
                 Read SCSARSPD;

                 DoW not %EOF;

                     // Check SCSARDPD
                        Chain (AXSARN) @SARDL1;
                        If %Found (SCSAREL1) and
                           AXSARD <> ABSARD;
                           ABSARD = AXSARD;
                           Update @SARDL1;
                        Else;
                           Chain (AXSARN) SCSARED1;
                           If %Found (SCSAREL1) and
                              AXSARD <> ABSARD;
                              ABSARD = AXSARD;
                              Update SCSARED1;
                           Endif;
                        Endif;

                     Read SCSARSPD;
                 EndDo;

                 *INLR = *ON;
                 Return;

      /end-free
