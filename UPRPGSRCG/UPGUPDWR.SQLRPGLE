     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Globa Update Write')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UPGUPDWR - This program update the work file for the         *
      *             ADBU update monitor (Global).                     *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD061706             Date 01Aug23             *
      *  Prev Amend No. CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061706 - Various changes for transition to aDBU            *
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
     D UPGUPD        E DS                  EXTNAME(UPGUPDTD)
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

      * At first, write record in UPGUPDTD
     C                   If        UPDACT = '*WRITE'

      * Make sure no server job is active
     C/exec SQL
     C+ select * into :UPGUPD
     C+ from UPGUPDTD where UPPRFX = :PREFIX
     C/end-exec
     C                   If        SQLCode = 0
     C                   eval      job_n = %trimr(UPSVJN) + '/' +
     C                             %trimr(UPUSER) + '/UPGADBUSVR'
      * check in TABLE if job is active
      * Note that => is not allowed in V7R1M0
     C*exec SQL
     C**select JOB_NAME into :JOB
     C* FROM TABLE(QSYS2.ACTIVE_JOB_INFO
     C* (JOB_NAME_FILTER => 'UPGADBUSVR')) A
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

      * relax for now...
     C**********         If        RcdCount > 0  or RcdCount2 > 0
     C**********         eval      ERROR = '*DBIntegri'
     C**********         RETURN
     C**********         endif

      * Delete first record for monitor
     C/EXEC SQL
     C+ delete from UPGUPDTD
     C+ where UPPRFX = :PREFIX
     C/END-EXEC

      * Reset status in driver file
     C/EXEC SQL
     C+ update UPGDRVTD set DRSCRP = ' ', DRUPDD = ' '
     C+ where DRPRFX = :PREFIX
     C/END-EXEC

      * Remove previous error message
     C/EXEC SQL
     C+ delete from UPADBETD
     C+ where ERPRFX = :PREFIX
     C/END-EXEC

     C                   clear                   UPGUPD

     C                   TIME                    ##TME             6 0
     C                   eval      UPTMST = %CHAR(##TME)

      * Determine number of files to upgrade for each library
     C/exec SQL
     C+ declare GroupBy cursor for
     C+ select DRLIB, count(*)
     C+ from UPGDRVTD
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
      * GM
     C                   When      %SUBST(V_LIB:3:2) = 'GM'
     C                   eval      UPGMNF = RcdCount
      * GP
     C                   When      %SUBST(V_LIB:3:2) = 'GP'
     C                   eval      UPGPNF = RcdCount
      * GT
     C                   When      %SUBST(V_LIB:3:2) = 'GT'
     C                   eval      UPGTNF = RcdCount
      * GV
     C                   When      %SUBST(V_LIB:3:2) = 'GV'
     C                   eval      UPGVNF = RcdCount

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
     C+ insert into UPGUPDTD
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
     C+  ,UPUPSS
     C+  ,UPRPSS
     C+  ,UPSVJN
     C+  ,UPSCRS
     C+  ,UPBKUS
     C+  ,UPPFUS
     C+  ,UPLFUS
     C+  ,UPRCLS
     C+  ,UPDRYS
     C+  ,UPGVNI
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
     C+  ,:UPGMNF
     C+  ,0
     C+  ,' '
     C+  ,' '
     C+  ,:UPGPNF
     C+  ,0
     C+  ,' '
     C+  ,' '
     C+  ,:UPGTNF
     C+  ,0
     C+  ,' '
     C+  ,' '
     C+  ,:UPGVNF
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
     C                   eval      SQLDynStmt = 'update UPGUPDTD set ' +
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
     C+ select count(*) into :RcdCount from UPGUPDTD
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
     C+ update UPGUPDTD set UPTMED = :UPTMED
     C+ where UPPRFX = :PREFIX
     C/END-EXEC
     C                   Endif

     C                   If        UPDACT = '*RTV'                                          MD061706
                                                                                            MD061706
     C                   eval      UPDVAL = *blanks                                         MD061706
                                                                                            MD061706
     C                   SELECT                                                             MD061706
     C                   WHEN      UPDFLD = 'UPUPSS'                                        MD061706
      * Retrieve the field passed as parameter                                              MD061706
     C/EXEC SQL                                                                             MD061706
     C+ select UPUPSS into :UPDVAL   from UPGUPDTD                                          MD061706
     C/END-EXEC                                                                             MD061706
     C                   ENDSL                                                              MD061706
     C                   If        SQLCode <> SQLOK                                         MD061706
     C                             and SQLCODE <> SQLEOF                                    MD061706
     C                   eval      ERROR = '*Error'                                         MD061706
     C                   Endif                                                              MD061706
                                                                                            MD061706
     C                   Endif                                                              MD061706
                                                                                            MD061706
     C                   If        SQLCode <> SQLOK
     C                   eval      ERROR = '*Error'
     C                   Else
      * send DTAQ message to refresh monitor screen if not *WRITE
     C                   If        UPDACT <> '*WRITE'
     C                             and UPDACT <> '*CHECK'
     C                             and UPDACT <> '*RTV'                                     MD061706
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'UPGADBUDTQ'  DtqNam           10
     C                   PARM      '*LIBL'       DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'REFRESH'     DtqDta           10
     C                   Endif
     C                   Endif

     C                   Seton                                        LR
     C                   Return

      *****************************************************************
