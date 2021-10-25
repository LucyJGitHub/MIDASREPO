     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Zone Update Write')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UPZUPDWR - This program update the work file for the         *
      *             ADBU Update Monitor.                              *
      *                                                               *
      *  (c) Finastra International 2020                              *
      *                                                               *
      *  Last Amend No. CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D RcdCount        S              5  0
     D RcdCount2       S              5  0
     D job_n           S             40
     D JOB             S             40
     D XLib1           S              3

     D V_LIB           S             10A
     D ERROR           S             10A
     D RETURN          S             10A
     D UPDTBL          S             10A
     D UPDFLD          S             10A
     D UPDVAL          S            100A
     D UPDACT          S             10A
     D SQLDynStmt      S           5000A
     D UPZUPD        E DS                  EXTNAME(UPZUPDTD)
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

      * At first, write record in UPZUPDTD
     C                   If        UPDACT = '*WRITE'

      * Make sure no server job is active
     C/exec SQL
     C+ select * into :UPZUPD
     C+ from UPZUPDTD where UPPRFX = :PREFIX
     C/end-exec
     C                   If        SQLCode = 0
     C                   eval      job_n = %trimr(UPSVJN) + '/' +
     C                             %trimr(UPUSER) + '/UPZADBUSVR'
      * check in TABLE if job is active
      * Note that => is not allowed in V7R1M0
     C*exec SQL
     C* select JOB_NAME into :JOB
     C* FROM TABLE(QSYS2.ACTIVE_JOB_INFO
     C* (JOB_NAME_FILTER => 'UPZADBUSVR')) A
     C* where JOB_NAME = :job_n
     C*end-exec
     C/exec SQL
     C+ select JOB_NAME into :JOB
     C+ FROM TABLE(QSYS2.ACTIVE_JOB_INFO ()) A
     C+ where JOB_NAME = :job_n
     C/end-exec
     C                   If        SQLCode = 0
     C                   eval      ERROR = '*ACTIVE'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF

      * check database integrity: there should be no file in one system having
      * dependency/dependent in the other system
     C                   eval      XLib1 = Prefix +'%'
     C/exec SQL
     C+ SELECT count(*) into :RcdCount
     C+ FROM qadbfdep WHERE DBFLIB like :XLib1
     C+ and DBFLDP not like :XLib1
     C/end-exec

     C/exec SQL
     C+ SELECT count(*) into :RcdCount2
     C+ FROM qadbfdep WHERE DBFLIB not like :XLib1
     C+ and DBFLDP like :XLib1
     C/end-exec

     C                   If        RcdCount > 0  or RcdCount2 > 0
     C                   eval      ERROR = '*DBIntegri'
     C                   RETURN
     C                   endif

      * Delete first record for monitor
     C/EXEC SQL
     C+ delete from UPZUPDTD
     C+ where UPPRFX = :PREFIX
     C/END-EXEC

      * Reset status in driver file
     C/EXEC SQL
     C+ update UPZDRVTD set DRSCRP = ' ', DRUPDD = ' '
     C+ where DRPRFX = :PREFIX
     C/END-EXEC

      * Remove previous error message
     C/EXEC SQL
     C+ delete from UPADBETD
     C+ where ERPRFX = :PREFIX
     C/END-EXEC

     C                   clear                   UPZUPD

     C                   TIME                    ##TME             6 0
     C                   eval      UPTMST = %CHAR(##TME)

      * Determine number of files to upgrade for each library
     C/exec SQL
     C+ declare GroupBy cursor for
     C+ select DRLIB, count(*)
     C+ from UPZDRVTD
     C+ where DRPRFX = :PREFIX
     C+ group by DRLIB
     C/end-exec
      *
     C/exec SQL
     C+ open GroupBy
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from GroupBy
     C+ into :V_LIB, :RcdCount
     C/end-exec

     C                   DOW       SQLCODE = 0

     C                   Select
      * DM
     C                   When      %SUBST(V_LIB:3:2) = 'DM'
     C                   eval      UPDMNF = RcdCount
      * DP
     C                   When      %SUBST(V_LIB:3:2) = 'DP'
     C                   eval      UPDPNF = RcdCount
      * DT
     C                   When      %SUBST(V_LIB:3:2) = 'DT'
     C                   eval      UPDTNF = RcdCount
      * DV
     C                   When      %SUBST(V_LIB:3:2) = 'DV'
     C                   eval      UPDVNF = RcdCount

     C                   Endsl
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from GroupBy
     C+ into :V_LIB, :RcdCount
     C/end-exec

     C                   END

     C/exec SQL
     C+ close GroupBy
     C/end-exec


     C/EXEC SQL
     C+ insert into UPZUPDTD
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
     C+  ,UPUPSS
     C+  ,UPRPSS
     C+  ,UPSVJN
     C+  ,UPSCRS
     C+  ,UPBKUS
     C+  ,UPPFUS
     C+  ,UPLFUS
     C+  ,UPRCLS
     C+  ,UPDRYS
     C+  ,UPDVNI
     C+  ,UPBUNI
     C+  ,UPPHAS
     C+ )
     C+ Values
     C+ (
     C+   :PREFIX
     C+  ,:UPTMST
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,:UPDMNF
     C+  ,0
     C+  ,' '
     C+  ,' '
     C+  ,:UPDPNF
     C+  ,0
     C+  ,' '
     C+  ,' '
     C+  ,:UPDTNF
     C+  ,0
     C+  ,' '
     C+  ,' '
     C+  ,:UPDVNF
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
     C+  ,'I'
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,' '
     C+  ,0
     C+  ,0
     C+  ,' '
     C+ )
     C/END-EXEC

     C                   ENDIF

      * Update whatever field is passed as parameter
     C                   If        UPDACT = '*UPDATE'
     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = 'update UPZUPDTD set ' +
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
     C+ select count(*) into :RcdCount from UPZUPDTD
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
     C+ update UPZUPDTD set UPTMED = :UPTMED
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
     C                   PARM      'UPZADBUDTQ'  DtqNam           10
     C                   PARM      '*LIBL'       DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'REFRESH'     DtqDta           10
     C                   Endif
     C                   Endif

     C                   Seton                                        LR
     C                   Return

      *****************************************************************
