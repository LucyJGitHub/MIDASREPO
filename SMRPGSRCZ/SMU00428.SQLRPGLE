     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - Deliverable Data Split sanity update')      *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SMU00428 - Migration Program for BA3100                      *
      *             EML100_Target2Nostro to Target2Nostro             *
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

     C                   EVAL      SQLDynStmt = 'update '      +
     C                             %trimr(KMSCHEMA) + '/SDSVLXTD x '  +
     C                             ' set (x.GIVAL) = (select c.GIVAL ' +
     C                             ' from SDSVLXTD c ' +
     C                             ' where c.GISVAL = ' +
     C                             ' ''EML100_Target2Nostro'') ' +
     C                             ' where x.GISVAL = ''Target2Nostro'' '

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

     C/EXEC SQL
     C+ delete from SDSVLBTD WHERE GISVAL = 'EML100_Target2Nostro'
     C/END-EXEC

     C                   IF        SQLCode <> 0
     C                             AND SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   ENDIF

     C/EXEC SQL
     C+ delete from SDSVLXTD WHERE GISVAL = 'EML100_Target2Nostro'
     C/END-EXEC


     C                   IF        SQLCode <> 0
     C                             AND SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   ENDIF

     C/EXEC SQL
     C+ delete from SDSVRBTD WHERE GJSVAL = 'EML100_Target2Nostro'
     C/END-EXEC


     C                   IF        SQLCode <> 0
     C                             AND SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   ENDIF

     C/EXEC SQL
     C+ delete from SDSVRXTD WHERE GJSVAL = 'EML100_Target2Nostro'
     C/END-EXEC


     C                   IF        SQLCode <> 0
     C                             AND SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   ENDIF

     C                   SETON                                        LR
      /EJECT
      *****************************************************************
