     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Permission Patch Retrieve Sys Details')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00201 - Midas SM Upgrade for Permission Patch Application *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD020108 *CREATE   Date 18Apr13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
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
       //Select*value(GIVAL,'')*into:*TargetPfx*from*GPSVALPD*****************************//MD054605
        Select value(GIVAL,'') into: TargetPfx from GPSVLJW0                              //MD054605
        where GISVAL = 'GlobalSystemPrefix';

                 Return;
      /end-free
