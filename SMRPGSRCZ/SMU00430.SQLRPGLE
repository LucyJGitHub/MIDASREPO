     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas Generate BTD and XTD record of BA3101')          *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SMU00430 - Generate BTD and XTD record of BA3101             *
      *                                                               *
      *  (c) Finastra International 2022                              *
      *                                                               *
      *  Last Amend No. BA3101 *CREATE      Date 12Sep22              *
      *  Prev Amend No. nnnnnn              Date ddmmmyy              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BA3101 - Output account in field 50K on MT103 for FX/MM deal *
      *                                                               *
      *****************************************************************

     D KMSCHEMA        S             10A
     D XSCHEMA         S             10A
     D WHERE           S            600A
     D SQLDynStmt      S           5000A

       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    SYSID             2
     C                   PARM                    ERROR            10

     C                   EVAL      KMSCHEMA = %SUBST(SYSID:1:2) + 'DMLIB'

      ** Update BTD

     C                   EVAL      SQLDynStmt = 'insert into SCSRSBTD '+
     C                               '(AXSARN, AXSARD, AXPRIM, AXCEMI, '+
     C                               'AXRELL, AXIREL, AXCLVL, '+
     C                               'AXRSTS, AXDFLT, AXMNTB, '+
     C                               'AXPROT, AXMODE) '+
     C                               'values(''BA3101'', ''Output account '+
     C                               'in field 50K on MT103 for FX-MM'', '+
     C                               '''ME'', ''N'', ''BFV2R1'', ''00'', '+
     C                               '''GEN'', ''R'', ''OFF'', ''C'', '+
     C                               '''Y'', ''B'')'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   IF        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   DUMP
     C                   RETURN
     C                   ENDIF

     C                   EVAL      SQLDynStmt = 'insert into GPSECBTD '+
     C                               '(RECI, P@SARN, SEPASS, SEINTL, REMODE) '+
     C                               'values(''B'', ''BA3101'', '+
     C                               '''CJHPKDXODSMBBANG'', ''N'', ''B'')'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   IF        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   DUMP
     C                   RETURN
     C                   ENDIF

      ** Update XTD

     C                   EVAL      SQLDynStmt = 'insert into SCSRSXTD +
     C                               (AXSARN, AXMODE) values(''BA3101'',''B'')'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   IF        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   DUMP
     C                   RETURN
     C                   ENDIF

     C                   EVAL      SQLDynStmt = 'insert into GPSECXTD '+
     C                               '(P@SARN, REMODE) '+
     C                               'values(''BA3101'', ''B'')'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   IF        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   DUMP
     C                   RETURN
     C                   ENDIF

     C                   SETON                                        LR
      /EJECT
      *****************************************************************
