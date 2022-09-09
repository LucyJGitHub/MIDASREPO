     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas Generate BTD and XTD record of BA3100')          *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SMU00428 - Generate BTD and XTD record of BA3100             *
      *                                                               *
      *  (c) Finastra International 2022                              *
      *                                                               *
      *  Last Amend No. BA3100  *CREATE     Date 01Sep22              *
      *  Prev Amend No. nnnnnn              Date ddmmmyy              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BA3100 - MT103 and MT202 message details changes for         *
      *           Target 2 RTGS System                                *
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
     C                               'values(''BA3100'', ''MT103 and MT202 '+
     C                               'msg details changes Target2RTGS'', '+
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

     C                   EVAL      SQLDynStmt = 'insert into SCSRVBTD '+
     C                               '(GSSVAL, GSSARN, GSAVAL, GSLCT, GSMODE)'+
     C                               'values(''Target2Nostro'', ''BA3100'',' +
     C                               '''Y'', ''I'', ''B'')'

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

     C                   EVAL      SQLDynStmt = 'insert into SDSVLBTD '+
     C                               '(GISVAL, GIMMOD, GIMMSN, GIDESC, GIVAL, '+
     C                               'GIDFT, GIHELP, GIATTR, GIDLEN, '+
     C                               'GISUPP, GISWCH, GIALWB, GIJUST, GIEMSG, '+
     C                               'GILCT, GIZONE, GIMODE)'+
     C                               'values(''Target2Nostro'', ''ME'', '+
     C                               '''MSGMGMT'', '+
     C                               '''MT103 & MT202 Target2 Nostro'', '+
     C                               '''01'', ''01'', ''Nostro Codes'', '+
     C                               '''2A'', ''002'', '' '', '+
     C                               '''BA3100'', ''N'', '+
     C                               '''L'', ''USV0155'', '+
     C                               ''' '', '' '', ''B'')'

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

     C                   EVAL      SQLDynStmt = 'insert into SDSVRBTD '+
     C                               '(GJRECI, GJSVAL, GJSEQ, GJVDTA, '+
     C                               'GJDESC, GJMODE) '+
     C                               'values(''H'', ''Target2Nostro'', '+
     C                               '''001'', ''*RANGE'','+
     C                               '''MT103 & MT202 Target2 Nostro'', '+
     C                               '''B'')'

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

     C                   EVAL      SQLDynStmt = 'insert into SDSVRBTD '+
     C                               '(GJRECI, GJSVAL, GJSEQ, GJVDTA, '+
     C                               'GJDESC, GJMODE) '+
     C                               'values(''D'', ''Target2Nostro'', '+
     C                               '''001'', ''01'','+
     C                               '''MT103 & MT202 Target2 Nostro'', '+
     C                               '''B'')'

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

     C                   EVAL      SQLDynStmt = 'insert into SDSVRBTD '+
     C                               '(GJRECI, GJSVAL, GJSEQ, GJVDTA, '+
     C                               'GJDESC, GJMODE) '+
     C                               'values(''D'', ''Target2Nostro'', '+
     C                               '''001'', ''99'','+
     C                               '''MT103 & MT202 Target2 Nostro'', '+
     C                               '''B'')'

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
     C                               'values(''B', ''BA3100'', '+
     C                               '''DHJBKDPNCMHBSANG'', ''N'', ''B')'

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
     C                               (AXSARN, AXMODE) values(''BA3100'',''B'')'

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

     C                   EVAL      SQLDynStmt = 'insert into SCSRVXTD '+
     C                               '(GSSVAL, GSSARN, GSAVAL, GSMODE)'+
     C                               'values(''Target2Nostro'', ''BA3100'','+
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

     C                   EVAL      SQLDynStmt = 'insert into SDSVLXTD '+
     C                               '(GISVAL, GIVAL, GILCT, GIMODE)' +
     C                               'values(''Target2Nostro'', ''01'', '+
     C                               '''I'', ''B'')'

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

     C                   IF        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   DUMP
     C                   RETURN
     C                   ENDIF

     C                   EVAL      SQLDynStmt = 'insert into SDSVRXTD '+
     C                               '(GJRECI, GJSVAL, GJSEQ, GJVDTA) '+
     C                               'values(''H'', ''Target2Nostro'', '+
     C                               '''001'', ''*RANGE'')'

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

     C                   EVAL      SQLDynStmt = 'insert into SDSVRXTD '+
     C                               '(GJRECI, GJSVAL, GJSEQ, GJVDTA) '+
     C                               'values(''D'', ''Target2Nostro'', '+
     C                               '''001'', ''01'')'

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

     C                   EVAL      SQLDynStmt = 'insert into SDSVRXTD '+
     C                               '(GJRECI, GJSVAL, GJSEQ, GJVDTA) '+
     C                               'values(''D'', ''Target2Nostro'', '+
     C                               '''001'', ''99'')'

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
     C                               'values(''BA3100'', ''B'')'

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
