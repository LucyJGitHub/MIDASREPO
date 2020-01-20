     H DEBUG
     H COPYRIGHT('(c) Finastra International 2019')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Deliverable Data Split Migration')            *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000700 - This program migrates 'old' deliverable data      *
      *             files into new Deliverable Data Split structure   *
      *                                                               *
      *  (c) Finastra International 2019                              *
      *                                                               *
      *  Last Amend No. MD055093             Date 20Jan20             *
      *  Prev Amend No. MD054209   *CREATE   Date 07Sep19             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055093 - 'Old' file T_WIPCF has been cpoied to QTEMP       *
      *  MD054209 - Deliverable Data Split for T_WIPCF                *
      *                                                               *
      *****************************************************************

     D SQLDynStmt      S           5000A
     D GTALIB          S             10A

      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    ERROR            10
     C                   PARM                    FILE             10
     C                   PARM                    OLDLIB           10

     C                   EVAL      ERROR = *BLANK

     C                   IF        FILE = 'GPWIPCTD'
     C                   EXSR      GPWIP_Sr
     C                   ELSE
     C                   ENDIF

     C                   EVAL      *INLR = *ON
     C                   RETURN

      ***************************************************************************
     C     GPWIP_Sr      BEGSR

     C**********         EVAL      GTALIB = %SUBST(OLDLIB:1:2) + 'GTALIB'                   MD055093
     C                   EVAL      GTALIB = 'QTEMP'                                         MD055093
     C/exec SQL
     C+ ALTER TABLE GPWIPBTD ALTER COLUMN
     C+ WC_ID restart with 10500
     C/end-exec

      ** create bespoke records in GPWIPBTD based on existing T_WIPCF
      ** for existing zones
     C*exec SQL
     C* insert into GPWIPBTD
     C* OVERRIDING USER VALUE
     C* (SELECT WC_ID,
     C* WC_API, WC_CAT, WC_BONSTP, WC_BOASTP, WC_BOAC, WC_BOACNE,
     C* WC_BOACAM, WC_BOACAU, WC_BOACCL, WC_BOACDE, WC_BOACRE,
     C* WC_BOACCH, WC_AUTOA, WC_AUTLVL, WC_ZONE,
     C* WC_SYSTEM, WC_BOFLD1, WC_BOFLD2, WC_BOFLD3, WC_BOFLD4,
     C* WC_BOFLD5, 'B' FROM T_WIPCF
     C* where WC_ZONE <> '*REFZONE' and WC_ZONE <> ''
     C* and WC_ZONE IS NOT NULL and WC_ZONE <> 'GLOBAL')
     C*end-exec

     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = 'insert into GPWIPBTD OVERRID' +
     C                             'ING USER VALUE (SELECT WC_ID, ' +
     C                             'WC_API, WC_CAT, WC_BONSTP, WC_BOASTP, ' +
     C                             'WC_BOAC, WC_BOACNE, ' +
     C                             'WC_BOACAM, WC_BOACAU, WC_BOACCL,' +
     C                             'WC_BOACDE, WC_BOACRE, ' +
     C                             'WC_BOACCH, WC_AUTOA, WC_AUTLVL, WC_ZONE, ' +
     C                             'WC_SYSTEM, WC_BOFLD1, WC_BOFLD2, ' +
     C                             'WC_BOFLD3, WC_BOFLD4, ' +
     C                             'WC_BOFLD5, ''B'' FROM ' + %trimr(GTALIB) +
     C                             '/T_WIPCF where WC_ZONE <> ''*REFZONE'' and'+
     C                             ' WC_ZONE <> '''' and WC_ZONE IS NOT NULL ' +
     C                             'and WC_ZONE <> ''GLOBAL'')'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec
     C                   IF        SQLCODE <> 0
     C                   EVAL      ERROR = '*ERROR*'
     C                   ENDIF

      ** create extension records in GPWIPXTD
     C/exec SQL
     C+ insert into GPWIPXTD
     C+ (SELECT WC_ID,
     C+ WC_API, WC_BONSTP, WC_BOASTP,
     C+ WC_AUTLVL, WC_ZONE, 'B'
     C+ FROM GPWIPBTD)
     C/end-exec
      *
     C                   IF        SQLCODE <> 0
     C                   EVAL      ERROR = '*ERROR*'
     C                   ENDIF

     C                   ENDSR
