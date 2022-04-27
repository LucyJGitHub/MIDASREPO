     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - Syncrhonize global pwd list files')         *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000725 - This program synchronize Extension and Bespoke    *
      *             files for Global pwd                              *
      *                                                               *
      *  (c) Finastra International 2022                              *
      *                                                               *
      *  Last Amend No. MD059822   *CREATE   Date 22Apr22             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059822 - Issue with Global password files due to CCSID     *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D SQLDynStmt      S           5000A

       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    ERROR            10
     C                   PARM                    XINDEX           10
     C                   PARM                    XSCHEMA          10


      * Delete all core records from 'extension' file
     C                   eval      SQLDynStmt = 'delete from ' +
     C                             'UPGPXZTD where REMODE = ' +
     C                             '''' + 'C' + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   Dump
     C                   Endif

      * Add all core records in extension file

     C/exec SQL
     C+ insert into UPGPXZTD
     C+ (select A.PXSARN, 'C'
     C+ FROM UPGPCZTD A where
     C+ not exists (select * from UPGPXZTD B
     C+ where A.PXSARN = B.PXSARN))
     C/end-exec
     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   Dump
     C                   Endif

     C                   Seton                                        LR
     C                   Return

