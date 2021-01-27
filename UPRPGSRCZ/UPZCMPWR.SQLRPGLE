     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Zone Compare Write')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UPGCMPWR - This program update the work file for the         *
      *             ADBU compare monitor.                             *
      *                                                               *
      *  (c) Finastra International 2020                              *
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
     D UPZCMP        E DS                  EXTNAME(UPZCMPTD)
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
     C+ delete from UPZCMPTD
     C+ where UPPRFX = :PREFIX
     C/END-EXEC

     C                   TIME                    ##TME             6 0
     C                   eval      UPTMST = %CHAR(##TME)

     C/EXEC SQL
     C+ insert into UPZCMPTD
     C+ (
     C+   UPPRFX
     C+  ,UPTMST
     C+  ,UPTMED
     C+  ,UPDMSB
     C+  ,UPDMED
     C+  ,UPDMNF
     C+  ,UPDMNR
     C+  ,UPDPSB
     C+  ,UPDPED
     C+  ,UPDPNF
     C+  ,UPDPNR
     C+  ,UPDTSB
     C+  ,UPDTED
     C+  ,UPDTNF
     C+  ,UPDTNR
     C+  ,UPDVSB
     C+  ,UPDVED
     C+  ,UPDVNF
     C+  ,UPDVNR
     C+  ,UPUSER
     C+  ,UPDMJN
     C+  ,UPDPJN
     C+  ,UPDTJN
     C+  ,UPDVJN
     C+  ,UPDMSS
     C+  ,UPDPSS
     C+  ,UPDTSS
     C+  ,UPDVSS
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
     C                   eval      SQLDynStmt = 'update UPZCMPTD set ' +
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
     C+ select count(*) into :RcdCount from UPZCMPTD
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
     C+ update UPZCMPTD set UPTMED = :UPTMED
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
     C                   PARM      'UPZADBCDTQ'  DtqNam           10
     C                   PARM      '*LIBL'       DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'REFRESH'     DtqDta           10
     C                   Endif
     C                   Endif

     C                   Seton                                        LR
     C                   Return

      *****************************************************************
