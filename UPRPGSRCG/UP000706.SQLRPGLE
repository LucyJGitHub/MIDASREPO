     H DEBUG
     H COPYRIGHT('(c) Finastra International 2021')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - Syncrhonize validation list files')         *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000706 - This program synchronize Extension and Bespoke    *
      *             files for validation list                         *
      *                                                               *
      *  (c) Finastra International 2021                              *
      *                                                               *
      *  Last Amend No. MD058672   *CREATE   Date 25Aug21             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058672 - Issue with Validation List files due to CCSID     *
      *             Applied for MD059822                              *
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
     C                   PARM                    OLDFILE          10


      * Delete all core records from 'extension' file
     C                   eval      SQLDynStmt = 'insert into ' +
     C                             'UPVLBZTD (select A.XXCND,A.CNDTYP, ' +
     C                             'A.EXTVAL,A.INTVAL,A.CNDTXT,A.USRMOD, ' +
     C                             'A.VALMAP, ' + '''' + 'B' + '''' +
     C                             ' from UPVLOZTD A where not exists' +
     C                             ' (select * from UPVLCZTD B where ' +
     C                             ' A.XXCND =B.XXCND and A.CNDTYP = B.CNDTYP' +
     C                             ' and A.EXTVAL = B.EXTVAL and A.INTVAL = ' +
     C                             'B.INTVAL))'

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

      * Add extension records for the added bespoke records
     C/exec SQL
     C+ insert into UPVLXZTD
     C+ (select A.XXCND,A.CNDTYP,
     C+ A.EXTVAL,A.INTVAL,'B'
     C+ FROM UPVLBZTD A where
     C+ not exists (select * from UPVLXZTD B
     C+ where A.XXCND =B.XXCND and A.CNDTYP = B.CNDTYP and
     C+ A.EXTVAL = B.EXTVAL and A.INTVAL = B.INTVAL))
     C/end-exec

     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   Dump
     C                   Endif



     C                   Seton                                        LR
     C                   Return

