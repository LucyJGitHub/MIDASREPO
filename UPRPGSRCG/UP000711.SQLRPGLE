     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP WIP configuration take on for zone')          *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000711 - This program update Extension file and Bespoke    *
      *             file based on old file during migration.          *
      *             This is for WIP configuration only.               *
      *                                                               *
      *  (c) Finastra International 2020                              *
      *                                                               *
      *  Last Amend No. MD056103   *CREATE   Date 17Jun20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056103 - Deliverable Data Split migration                  *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D X_ZONE          S             10A
     D SCHEMAT         S             10A
     D SCHEMAM         S             10A
     D SCHEMAV         S             10A
     D INDEX           S             10A
     D TABLEB          S             10A
     D TABLEX          S             10A
     D KColumn         S             10A
     D KOrdinal        S              9  0
     D KeyArr          S             10A   DIM(12)
     D WIdx            S              3P 0
     D KeyFld          S            200A
     D WHERE           S            600A
     D WHEREK          S            600A
     D PINSERT         S            600A
     D PSELECT         S            600A
     D PINSERTX        S            600A
     D PSELECTX        S            600A
     D PINSERTB        S            600A
     D PSELECTB        S            600A
     D SQLDynStmt      S           5000A
     D Outfile         S             10A
     D O_File          S             10A
     D O_Lib           S             10A
     D OFMbr           S             10A
     D OFMbrOpt        S              8A
     D First           S              1A
     D TotRow          S             13  0
     D X_Field         S             10
     D FldData       E DS                  EXTNAME(UPFFDSTPD)

      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    ZSBSID            2
     C                   PARM                    GSBSID            2
     C                   PARM                    MIGRATE           1
     C                   PARM                    OLDLIB           10
     C                   PARM                    ERROR            10

      * Set variables
     C                   exsr      SR_SetVar

      * 1. Create default WIP config for the zone
     C                   exsr      SR_Default

      * 2. If migration is needed, check for bespoke API
     C                   If        MIGRATE = 'Y'
     C                   exsr      SR_AddBTD

      * 3. If migration is needed, apply T_WIPCF values to GPWIPXTD
     C                   exsr      SR_AppWIPCF
     C                   Endif

     C                   Seton                                        LR
     C                   Return
      /EJECT
      *****************************************************************

      * SR_SetVar - Set Variables

      *****************************************************************
     C     SR_SetVar     BEGSR

      * Retrieve zone for the current prefix
     C/EXEC SQL
     C+ SELECT ZOZONE
     C+ into :X_ZONE
     C+ from GPZONEPD
     C+ where ZOMSYS = :ZSBSID
     C/END-EXEC
     C                   IF        SQLCODE = 100
     C                   eval      ERROR = '*Error'
     C                   Dump
     C                   Return
     C                   ENDIF

     C                   eval      SCHEMAT = GSBSID + 'GTALIB'
     C                   eval      SCHEMAM = GSBSID + 'GMLIB'

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************

      * SR_Default - Create in GPWIPBTD and GPWIPXTD default config for
      *              the zone

      *****************************************************************
     C     SR_Default    BEGSR

     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = 'insert into ' + %trim(SCHEMAM)+
     C                             '/GPWIPBTD OVERRIDING USER VALUE ' +
     C                             'SELECT WC_ID, ' +
     C                             'WC_API, WC_CAT, WC_BONSTP, WC_BOASTP, ' +
     C                             'WC_BOAC, WC_BOACNE, ' +
     C                             'WC_BOACAM, WC_BOACAU, WC_BOACCL,' +
     C                             'WC_BOACDE, WC_BOACRE, ' +
     C                             'WC_BOACCH, WC_AUTOA, WC_AUTLVL, ' +
     C                             '''' + %trimr(X_ZONE) + '''' +
     C                             ' as WC_ZONE, ' +
     C                             'WC_SYSTEM, WC_BOFLD1, WC_BOFLD2, ' +
     C                             'WC_BOFLD3, WC_BOFLD4, ' +
     C                             'WC_BOFLD5, ''B'' FROM ' + %trimr(SCHEMAT) +
     C                             '/GPWIPCTD A where A.WC_ZONE ' +
     C                             ' = ''*REFZONE'' and not exists '+
     C                             ' (select * from ' + %trimr(SCHEMAM) +
     C                             '/GPWIPBTD B where A.WC_API ' +
     C                             ' = B.WC_API and B.WC_ZONE = ' + '''' +
     C                             %trimr(X_ZONE) + '''' + ')'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec
     C                   IF        SQLCODE <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   Dump
     C                   Return
     C                   ENDIF

      * Add corresponding GPWIPXTD records with zone (bespoke)

     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = 'insert into ' + %trim(SCHEMAM)+
     C                             '/GPWIPXTD (SELECT WC_ID, '+
     C                             'WC_API, WC_BONSTP, WC_BOASTP, ' +
     C                             'WC_AUTLVL, WC_ZONE, ''B'' from ' +
     C                              %trimr(SCHEMAM) +
     C                             '/GPWIPBTD A where not exists (select *' +
     C                             ' from GPWIPXTD B where A.WC_API = ' +
     C                             ' B.WC_API and B.WC_ZONE = ' + '''' +
     C                             %trimr(X_ZONE) + '''' + '))'

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
     C                   Return
     C                   Endif

     C                   ENDSR

      /EJECT
      *****************************************************************
      *****************************************************************

      * SR_AddBTD - Add records in GPWIPBTD and GPWIPXTD for bspoke API's

      *****************************************************************
     C     SR_AddBTD     BEGSR

     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = 'insert into ' + %trim(SCHEMAM)+
     C                             '/GPWIPBTD OVERRIDING USER VALUE ' +
     C                             'SELECT WC_ID, ' +
     C                             'WC_API, WC_CAT, WC_BONSTP, WC_BOASTP, ' +
     C                             'WC_BOAC, WC_BOACNE, ' +
     C                             'WC_BOACAM, WC_BOACAU, WC_BOACCL,' +
     C                             'WC_BOACDE, WC_BOACRE, ' +
     C                             'WC_BOACCH, WC_AUTOA, WC_AUTLVL, ' +
     C                             'WC_ZONE, ' +
     C                             'WC_SYSTEM, WC_BOFLD1, WC_BOFLD2, ' +
     C                             'WC_BOFLD3, WC_BOFLD4, ' +
     C                             'WC_BOFLD5, ''B'' FROM ' + %trimr(OLDLIB) +
     C                             '/T_WIPCF A where not exists ' +
     C                             ' (select * from ' + %trimr(SCHEMAM) +
     C                             '/GPWIPBTD B where A.WC_API ' +
     C                             ' = B.WC_API and B.WC_ZONE = ' + '''' +
     C                             %trimr(X_ZONE) + '''' + ') and a.WC_ZONE ' +
     C                             ' = ' + '''' + %trimr(X_ZONE) + ''''

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec
     C                   IF        SQLCODE <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   Dump
     C                   Return
     C                   ENDIF

      * Add corresponding GPWIPXTD records with zone (bespoke)

     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = 'insert into ' + %trim(SCHEMAM)+
     C                             '/GPWIPXTD (SELECT WC_ID, '+
     C                             'WC_API, WC_BONSTP, WC_BOASTP, ' +
     C                             'WC_AUTLVL, WC_ZONE, ''B'' from ' +
     C                              %trimr(SCHEMAM) +
     C                             '/GPWIPBTD A where not exists (select *' +
     C                             ' from GPWIPXTD B where A.WC_API = ' +
     C                             ' B.WC_API and B.WC_ZONE = ' + '''' +
     C                             %trimr(X_ZONE) + '''' + '))'

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
     C                   Return
     C                   Endif

     C                   ENDSR

      /EJECT
      *****************************************************************
      *****************************************************************

      * SR_AppWIPCF - Apply T_WIPCF setup to GPWIPXTD for the zone

      *****************************************************************
     C     SR_AppWIPCF   BEGSR

     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = 'update ' + %trim(SCHEMAM)+
     C                             '/GPWIPXTD B set (B.WC_BONSTP, ' +
     C                             'B.WC_BOASTP, B.WC_AUTLVL ) = (select ' +
     C                             'A.WC_BONSTP, ' +
     C                             'A.WC_BOASTP, A.WC_AUTLVL '+
     C                             ' FROM ' + %trimr(OLDLIB) +
     C                             '/T_WIPCF A where A.WC_API = B.WC_API and ' +
     C                             'A.WC_ZONE =' + '''' + %trimr(X_ZONE) +
     C                             '''' + ' ) where exists ' +
     C                             ' (select * from ' + %trimr(OLDLIB) +
     C                             '/T_WIPCF A where A.WC_API ' +
     C                             ' = B.WC_API and A.WC_ZONE =' +
     C                             '''' + %trimr(X_ZONE) + '''' + ')'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec
     C                   IF        SQLCODE <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   Dump
     C                   Return
     C                   ENDIF

     C                   ENDSR

      /EJECT
      *****************************************************************
