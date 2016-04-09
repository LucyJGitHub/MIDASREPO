     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Permission Patch Retrieve Sys Details')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00201 - Midas SM Upgrade for Permission Patch Application *
      *                                                               *
      *  Last Amend No. MD020108 *CREATE   Date 18Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD020108 - Permissions Patch                                 *
      *                                                               *
      *****************************************************************
      *
     DTargetPfx        S              2
      *
     C     *ENTRY        PLIST
     C                   PARM                    TargetPfx
      /free
       EXEC SQL
        Select value(GIVAL,'') into: TargetPfx from GPSVALPD
        where GISVAL = 'GlobalSystemPrefix';
 
                 Return;
      /end-free
