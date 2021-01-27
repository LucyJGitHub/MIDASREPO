     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Global Compare Write')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UPGCMPWR - This program update the work file for the         *
      *             ADBU compare monitor.                             *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD050666 *CREATE     Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050666 - Adaptive Database Upgrade                         *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D RcdCount        S              5  0

     D ERROR           S             10A
     D RETURN          S             10A
     D UPDTBL          S             10A
     D UPDFLD          S             10A
     D UPDVAL          S            100A
     D UPDACT          S             10A
     D SQLDynStmt      S           5000A
     D UPGCMP        E DS                  EXTNAME(UPGCMPTD)
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    UPDACT
     C                   PARM                    PREFIX            2
     C                   PARM                    UPDFLD
     C                   PARM                    UPDVAL
     C                   PARM                    ERROR
     C                   PARM                    RETURN

     C                   eval      ERROR = *blanks
     C                   eval      RETURN = *blanks

      * At first, write record in UPGCMPTD
     C                   If        UPDACT = '*WRITE'

      * Delete first
     C/EXEC SQL
     C+ delete from UPGCMPTD
     C+ where UPPRFX = :PREFIX
     C/END-EXEC
     C                   If        SQLCode <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   eval      ERROR = '*Error'
     C                   goto      EndTag
     C                   Endif

      * Also delete all records for that prefix in driver file
     C/EXEC SQL
     C+ delete from UPGDRVTD
     C+ where DRPRFX = :PREFIX
     C/END-EXEC
     C                   If        SQLCode <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   eval      ERROR = '*Error'
     C                   goto      EndTag
     C                   Endif

     C                   TIME                    ##TME             6 0
     C                   eval      UPTMST = %CHAR(##TME)

     C/EXEC SQL
     C+ insert into UPGCMPTD
     C+ (
     C+   UPPRFX
     C+  ,UPTMST
     C+  ,UPTMED
     C+  ,UPGMSB
     C+  ,UPGMED
     C+  ,UPGMNF
     C+  ,UPGMNR
     C+  ,UPGPSB
     C+  ,UPGPED
     C+  ,UPGPNF
     C+  ,UPGPNR
     C+  ,UPGTSB
     C+  ,UPGTED
     C+  ,UPGTNF
     C+  ,UPGTNR
     C+  ,UPGVSB
     C+  ,UPGVED
     C+  ,UPGVNF
     C+  ,UPGVNR
     C+  ,UPUSER
     C+  ,UPGMJN
     C+  ,UPGPJN
     C+  ,UPGTJN
     C+  ,UPGVJN
     C+  ,UPGMSS
     C+  ,UPGPSS
     C+  ,UPGTSS
     C+  ,UPGVSS
     C+  ,UPCMSS
     C+  ,UPRPSS
     C+  ,UPRPJN
     C+ )
     C+ Values
     C+ (
     C+   :PREFIX
     C+  ,:UPTMST
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,0
     C+  ,0
     C+  ,' '
     C+  ,' '
     C+  ,0
     C+  ,0
     C+  ,' '
     C+  ,' '
     C+  ,0
     C+  ,0
     C+  ,' '
     C+  ,' '
     C+  ,0
     C+  ,0
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+ )
     C/END-EXEC

     C                   ENDIF

      * Update whatever field is passed as parameter
     C                   If        UPDACT = '*UPDATE'
     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = 'update UPGCMPTD set ' +
     C                             UPDFLD + ' = ' + '''' + %TRIM(UPDVAL) +
     C                             '''' + 'where UPPRFX = ' +
     C                             '''' + PREFIX + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   Endif

     C                   If        UPDACT = '*CHECK'

      * At the end, update 'Time Ended' field
     C/EXEC SQL
     C+ select count(*) into :RcdCount from UPGCMPTD
     C+ where UPPRFX = :PREFIX
     C/END-EXEC
     C                   If        SQLCode <> SQLOK
     C                             and SQLCODE <> SQLEOF
     C                   eval      ERROR = '*Error'
     C                   Else
      * set RETURN
     C                   If        RcdCount > 0
     C                   eval      RETURN = 'Found     '
     C                   Else
     C                   eval      RETURN = 'Not_found '
     C                   Endif
     C                   Endif

     C                   Endif

     C                   If        UPDACT = '*END'
     C                   TIME                    ##TME             6 0
     C                   eval      UPTMED = %CHAR(##TME)

      * At the end, update 'Time Ended' field
     C/EXEC SQL
     C+ update UPGCMPTD set UPTMED = :UPTMED
     C+ where UPPRFX = :PREFIX
     C/END-EXEC
     C                   Endif

     C                   If        SQLCode <> SQLOK
     C                   eval      ERROR = '*Error'
     C                   Else
      * send DTAQ message to refresh monitor screen if not *WRITE
     C                   If        UPDACT <> '*WRITE'
     C                             and UPDACT <> '*CHECK'
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'UPGADBCDTQ'  DtqNam           10
     C                   PARM      '*LIBL'       DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'REFRESH'     DtqDta           10
     C                   Endif
     C                   Endif

     C     EndTag        Tag
     C                   Seton                                        LR
     C                   Return

      *****************************************************************
