     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - Deliverable Data Split sanity update')      *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000716 - This program synchronize Extension table (XTD)    *
      *             with Core table (CTD) and Bespoke table (BTD)     *
      *             It also removes BTD records that are in CTD.      *
      *                                                               *
      *  (c) Finastra International 2022                              *
      *                                                               *
      *  Last Amend No. MD059732 *CREATE   Date 18Aug22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059732 - DDS improvements, report conflict only            *
      *           - Applied for MD-60290.                             *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D CstB            C                   Const('B')

     D DSDelCnt        S              5  0
     D DSAdXCCnt       S              5  0
     D DSAdXBCnt       S              5  0
     D DSDelDup        S              5  0
     D DSDelDupX       S              5  0

     D EXTINDEX        S             10A
     D KXINDEX         S             10A
     D KXSCHEMA        S             10A
     D KMSCHEMA        S             10A
     D BINDEX          S             10A
     D XINDEXB         S             10A
     D BSCHEMA         S             10A
     D KColumn         S             10A
     D KOrdinal        S              9  0
     D KeyArr          S             10A   DIM(12)
     D WIdx            S              3P 0
     D KeyFld          S            200A
     D WHERE           S            600A
     D WHEREX          S            600A
     D PINSERT         S            600A
     D PSELECT         S            600A
     D SQLDynStmt      S           5000A
     D Outfile         S             10A
     D OFMbr           S             10A
     D OFMbrOpt        S              8A
     D First           S              1A
     D xxBSTP          S             20A
     D XHFLDI          S             10A
     D XMODE           S             10A
     D FldData       E DS                  EXTNAME(UPFFDSTPD)
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
     C                   PARM                    DSDelCnt
     C                   PARM                    DSAdXCCnt
     C                   PARM                    DSAdXBCnt
     C                   PARM                    DSDelDup

      * Retrieve key fields
     C                   exsr      SR_RtvKeys

     C                   If        XINDEX = 'GPWIPCTD'
     C                   eval      XINDEXB = %SUBST(XINDEX:1:5) + 'BTD'
     C                   eval      EXTINDEX = %SUBST(XINDEX:1:5) + 'XTD'
     C                   eval      BSCHEMA = %subst(XSCHEMA:1:3) + 'MLIB'
     C                   else

      * Get the'MODE' field name
     C                   eval      EXTINDEX = %SUBST(XINDEX:1:5) + 'XTD'
     C                   eval      BSCHEMA = %subst(XSCHEMA:1:3) + 'MLIB'
     C/EXEC SQL
     C+ select NAME into :XMODE from QSYS2/SYSCOLUMNS
     C+ where TBNAME = :EXTINDEX and DBNAME = :BSCHEMA and NAME like '%MODE'
     C/END-EXEC

      * Remove duplicate records: then ones in BTD also in CTD
     C                   exsr      SR_RmvDup

      * Delete from extension file if not found in core file
      * and not found in bespoke file
     C                   exsr      SR_DltExt

      * Add missing record in extension file if found in core file but not in the extension
     C                   exsr      SR_AddExtC

      * Add missing record in extension file if found in bespoke file but not in the extension
     C                   exsr      SR_AddExtB

      * Special process for CBCMPCTD
     C                   if        XINDEX = 'CBCMPCTD'
     C                   exsr      SR_CBCMP
     C                   endif

     C                   endif

     C                   Seton                                        LR
     C                   Return

      *****************************************************************

      * SR_RtvKeys - Retrieve key fields

      *****************************************************************
     C     SR_RtvKeys    BEGSR

     C                   eval      KXINDEX = %SUBST(XINDEX:1:5) + 'JI0'
     C                   eval      KXSCHEMA = %SUBST(XSCHEMA:1:3) + 'VLIB'
      * Retrieve key fields
     C/EXEC SQL
     C+ declare KKCursor insensitive scroll cursor for
     C+ select SYSTEM_COLUMN_NAME, ORDINAL_POSITION from QSYS2/SYSKEYS
     C+ where INDEX_NAME = :KXINDEX and INDEX_SCHEMA = :KXSCHEMA
     C+ order by ORDINAL_POSITION
     C/END-EXEC

     C/EXEC SQL
     C+ open KKCursor
     C/END-EXEC

     C     SQLCODE       IFEQ      SQLOK


     C                   DOU       SQLCODE <> SQLOK
     C                             and SQLCODE = SQLEOF

     C                   If        KOrdinal > 0
     C                   eval      KeyArr(KOrdinal) = KColumn
     C                   ENDIF
     C/EXEC SQL
     C+ fetch next from KKCursor into :KColumn, :KOrdinal
     C/END-EXEC

     C                   ENDDO

     C                   ENDIF

      *
      ** Close cursor fetch
      *
     C/EXEC SQL
     C+ close KKCursor
     C/END-EXEC

     C                   eval      KeyFld = *blanks
     C                   eval      KeyFld = KeyArr(1) + KeyArr(2) + KeyArr(3)
     C                             + KeyArr(4) + KeyArr(5) +KeyArr(6)
     C                             + KeyArr(7) + KeyArr(8) +KeyArr(9)
     C                             + KeyArr(10) + KeyArr(11) +KeyArr(12)

     C                   ENDSR

      *****************************************************************

      * SR_RmvDup - Delete records in BTD if existing in CTD

      *****************************************************************
     C     SR_RmvDup     BEGSR

     C                   If        XINDEX <> 'GPWIPCTD'

     C                   eval      WIdx = 1
     C                   eval      WHERE = *BLANKS
     C                   eval      WHERE = ' WHERE A.' + %trimr(KeyArr(WIdx)) +
     C                             ' = B.' + %trimr(KeyArr(WIdx))
     C                   eval      WIdx = WIdx + 1

     C     KeyArr(WIdx)  DOWNE     *BLANKS
     C     WIdx          ANDLT     13
     C                   eval      WHERE = %trimr(WHERE) + ' and A.' +
     C                             %trimr(KeyArr(WIdx)) +
     C                             ' = B.' + %trimr(KeyArr(WIdx))
     C                   eval      WIdx = WIdx + 1
     C                   ENDDO

     C                   eval      BINDEX = %SUBST(XINDEX:1:5) + 'BTD'
     C                   eval      BSCHEMA = %subst(XSCHEMA:1:3) + 'MLIB'
     C                   eval      SQLDynStmt = 'delete from ' +
     C                             %trimr(BSCHEMA) + '/' + BINDEX +
     C                             ' A where exists (select * from ' +
     C                             %trimr(XSCHEMA) + '/' + XINDEX +
     C                             ' B ' +  %trimr(WHERE) + ')'

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

     C/EXEC SQL
     C+           GET DIAGNOSTICS :DSDelDup = Row_Count
     C/END-EXEC

      * If records are deleted from BTD, corresponding XTD must be deleted too
     C                   If        DSDelDup > 0
     C                   eval      SQLDynStmt = 'delete from ' +
     C                             %trimr(BSCHEMA) + '/' + EXTINDEX +
     C                             ' A where not exists (select * from ' +
     C                             %trimr(BSCHEMA) + '/' + BINDEX +
     C                             ' B ' +  %trimr(WHERE) + ') and A.' +
     C                             %trim(XMODE) + ' = ' + '''' + CstB +
     C                             ''''

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

     C/EXEC SQL
     C+           GET DIAGNOSTICS :DSDelDupX = Row_Count
     C/END-EXEC
     C
     C                   ENDIF

     C                   ENDIF

     C                   ENDSR


      *****************************************************************

      * SR_DltExt - Delete records in Extension file if not found in Core file

      *****************************************************************
     C     SR_DltExt     BEGSR

     C                   If        XINDEX <> 'GPWIPCTD'

     C                   eval      EXTINDEX = %SUBST(XINDEX:1:5) + 'XTD'
     C                   eval      BINDEX = %SUBST(XINDEX:1:5) + 'BTD'
     C                   eval      WIdx = 1
     C                   eval      WHERE = *BLANKS
     C                   eval      WHEREX = *BLANKS
     C                   eval      WHERE = ' WHERE A.' + %trimr(KeyArr(WIdx)) +
     C                             ' = B.' + %trimr(KeyArr(WIdx))
     C                   eval      WHEREX= ' WHERE A.' + %trimr(KeyArr(WIdx)) +
     C                             ' = X.' + %trimr(KeyArr(WIdx))
     C                   eval      WIdx = WIdx + 1
     C                   eval      BSCHEMA = %subst(XSCHEMA:1:3) + 'MLIB'

     C     KeyArr(WIdx)  DOWNE     *BLANKS
     C     WIdx          ANDLT     13
     C                   eval      WHERE = %trimr(WHERE) + ' and A.' +
     C                             %trimr(KeyArr(WIdx)) +
     C                             ' = B.' + %trimr(KeyArr(WIdx))
     C                   eval      WHEREX = %trimr(WHEREX) + ' and A.' +
     C                             %trimr(KeyArr(WIdx)) +
     C                             ' = X.' + %trimr(KeyArr(WIdx))
     C                   eval      WIdx = WIdx + 1
     C                   ENDDO

     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = 'delete from ' +
     C                             %trimr(BSCHEMA) + '/' + EXTINDEX +
     C                             ' A where not exists (select * from ' +
     C                             %trimr(XSCHEMA) + '/' + XINDEX +
     C                             ' B ' +  %trimr(WHERE) + ') and ' +
     C                             '  not exists (select * from ' +
     C                             %trimr(BSCHEMA) + '/' + BINDEX +
     C                             ' X ' +  %trimr(WHEREX) + ')'

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

     C/EXEC SQL
     C+           GET DIAGNOSTICS :DSDelCnt = Row_Count
     C/END-EXEC
      * Add the XTD records removed while BTD duplicate were removed
     C                   eval      DSDelCnt = DSDelCnt + DSDelDupX
     C                   ELSE

      * delete GPWIPXTD records not found in Core
      * and not found in bespoke
     C                   eval      BINDEX = %SUBST(XINDEX:1:5) + 'BTD'
     C                   eval      BSCHEMA = %subst(XSCHEMA:1:3) + 'MLIB'

     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = 'delete from GPWIPXTD' +
     C                             ' A where not exists (select * from ' +
     C                             %trimr(XSCHEMA) + '/' + XINDEX +
     C                             ' B ' + ' where A.WC_API = B.WC_API)' +
     C                             ' and  not exists (select * from ' +
     C                             %trimr(BSCHEMA) + '/' + BINDEX +
     C                             ' F ' + ' where A.WC_API = F.WC_API)'

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

     C/EXEC SQL
     C+           GET DIAGNOSTICS :DSDelCnt = Row_Count
     C/END-EXEC

      * Additional process for GPWIPBTD as the Bespoke records are the zonal WIP config
      * consider now bespoke API in BTD
     C                   leaveSR

     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = 'delete from GPWIPBTD' +
     C                             ' A where not exists (select * from ' +
     C                             %trimr(XSCHEMA) + '/' + XINDEX +
     C                             ' B ' + ' where A.WC_API = B.WC_API)'

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

     C                   ENDIF
     C                   ENDSR

      *****************************************************************

      * SR_AddExt - Add records in Extension file if found in Core file
      *             but not in extension file

      *****************************************************************
     C     SR_AddExtC    BEGSR

     C                   If        XINDEX <> 'GPWIPCTD'

     C                   eval      First = 'Y'
     C                   eval      KMSCHEMA = %SUBST(XSCHEMA:1:3) + 'MLIB'
      ** Call program to produce file field description outfile of  file.
     C                   EVAL      OutFile = 'UDFOLD'
     C                   EXSR      BldOutFile

     C/exec SQL
     C+ declare GetFields cursor for
     C+ select WHFLDI
     C+ from UDFOLD
     C/end-exec
      *
     C/exec SQL
     C+ open GetFields
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFields
     C+ into :XHFLDI
     C/end-exec
      *
     C                   DOW       SQLCODE = 0

     C                   IF        First = 'Y'
      ** Get until the fieldadd to the end of the table.
     C                   eval      PINSERT = %trimr(PINSERT) + XHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + 'A.' + XHFLDI
     C                   eval      First = 'N'
     C                   ELSE
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + XHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + ',A.' + XHFLDI
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFields
     C+ into :XHFLDI
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close GetFields
     C/end-exec

     C                   eval      PINSERT = %trimr(PINSERT) + ')'

     C                   eval      SQLDynStmt = 'insert into ' +
     C                             %trimr(KMSCHEMA) + '/' + EXTINDEX  +
     C                             ' (select ' +
     C                             %trimr(PSELECT) + ' from ' +
     C                             %trimr(XSCHEMA) + '/' + XINDEX  +
     C                             ' A where not exists (select * from ' +
     C                             %trimr(KMSCHEMA) + '/' + EXTINDEX  +
     C                             ' B ' + %trimr(WHERE) + '))'

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

     C/EXEC SQL
     C+           GET DIAGNOSTICS :DSAdXCCnt = Row_Count
     C/END-EXEC

     C                   ELSE

      * Add GPWIPXTD records with *REFZONE (core) in case new API

     C/exec SQL
     C+ insert into GPWIPXTD
     C+ (SELECT WC_ID,
     C+ WC_API, WC_BONSTP, WC_BOASTP,
     C+ WC_AUTLVL, WC_ZONE, 'C'
     C+ FROM GPWIPCTD A where A.WC_ZONE = '*REFZONE'
     C+ and not exists (select * from GPWIPXTD B
     C+ where A.WC_API = B.WC_API and B.WC_ZONE = '*REFZONE'))
     C/end-exec
     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   Dump
     C                   Endif

      * Add GPWIPXTD records with blank zone for global API

     C/exec SQL
     C+ insert into GPWIPXTD
     C+ (SELECT WC_ID,
     C+ WC_API, WC_BONSTP, WC_BOASTP,
     C+ WC_AUTLVL, WC_ZONE, 'C'
     C+ FROM GPWIPCTD A where A.WC_ZONE = '          '
     C+ and not exists (select * from GPWIPXTD B
     C+ where A.WC_API = B.WC_API and B.WC_ZONE = '          '))
     C/end-exec
     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   Dump
     C                   Endif

      * Add GPWIPBTD records with zone (bespoke) in case new API

     C/exec SQL
     C+ insert into GPWIPBTD
     C+ OVERRIDING USER VALUE
     C+ (SELECT WC_ID,
     C+ WC_API, WC_CAT, WC_BONSTP, WC_BOASTP, WC_BOAC, WC_BOACNE,
     C+ WC_BOACAM, WC_BOACAU, WC_BOACCL, WC_BOACDE, WC_BOACRE,
     C+ WC_BOACCH, WC_AUTOA, WC_AUTLVL, ZOZONE as WC_ZONE,
     C+ WC_SYSTEM, WC_BOFLD1, WC_BOFLD2, WC_BOFLD3, WC_BOFLD4,
     C**WC_BOFLD5,*'B'*FROM*GPWIPCTD*A,*GPZONEPD
     C+ WC_BOFLD5, 'B' , WCAN, WCAC, WCAT, WCBSTP
     C+ FROM GPWIPCTD A, GPZONEPD
     C+ where A.WC_ZONE = '*REFZONE' and not exists
     C+ (select * from GPWIPBTD B where A.WC_API = B.WC_API))
     C/end-exec

     C                   IF        SQLCODE <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   Dump
     C                   ENDIF

      * Add GPWIPXTD records with zone (bespoke) in case new API

     C/exec SQL
     C+ insert into GPWIPXTD
     C+ (SELECT WC_ID,
     C+ WC_API, WC_BONSTP, WC_BOASTP,
     C+ WC_AUTLVL, WC_ZONE, 'B'
     C+ FROM GPWIPBTD A where
     C+ not exists (select * from GPWIPXTD B
     C**where*A.WC_API*=*B.WC_API*and*B.WC_ZONE*<>*'*REFZONE'))
     C+ where A.WC_API = B.WC_API and B.WC_ZONE <> '*REFZONE' and
     C+ WC_ZONE <> '        '))
     C/end-exec
     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   Dump
     C                   Endif

      * update GPWIPBTD records (bespoke) in case of change in core fields

     C/exec SQL
     C+ update GPWIPBTD b
     C+ set
     C+ (b.WC_CAT, b.WC_BOAC, b.WC_BOACNE,
     C+ b.WC_BOACAM, b.WC_BOACCL, b.WC_BOACDE, b.WC_BOACRE,
     C+ b.WC_BOACCH, b.WC_AUTOA,
     C+ b.WC_SYSTEM, b.WC_BOFLD1, b.WC_BOFLD2, b.WC_BOFLD3, b.WC_BOFLD4,
     C+ b.WC_BOFLD5) =
     C+ (select c.WC_CAT, c.WC_BOAC, c.WC_BOACNE,
     C+ c.WC_BOACAM, c.WC_BOACCL, c.WC_BOACDE, c.WC_BOACRE,
     C+ c.WC_BOACCH, c.WC_AUTOA,
     C+ c.WC_SYSTEM, c.WC_BOFLD1, c.WC_BOFLD2, c.WC_BOFLD3, c.WC_BOFLD4,
     C+ c.WC_BOFLD5 from GPWIPCTD c where c.WC_API = b.WC_API
     C+ and c.WC_ZONE = '*REFZONE')
     C+ where exists (select * from GPWIPCTD c where c.WC_API = b.WC_API
     C+ and c.WC_ZONE = '*REFZONE')
     C/end-exec

     C                   IF        SQLCODE <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   Dump
     C                   ENDIF

     C/exec SQL
     C+ update GPWIPBTD b
     C+ set (b.WC_BOACAU) =
     C+ (select c.WC_BOACAU
     C+ from GPWIPCTD c where c.WC_API = b.WC_API
     C+ and c.WC_ZONE = '*REFZONE'and c.WC_API = 'BITH')
     C+ where exists (select * from GPWIPCTD c where c.WC_API = b.WC_API
     C+ and c.WC_ZONE = '*REFZONE' and c.WC_API = 'BITH')
     C/end-exec

     C                   IF        SQLCODE <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   Dump
     C                   ENDIF

      * if CFT157 fields are left blank, then initialize them with values from CTD
     C/exec SQL
     C+ select WCBSTP into :xxBSTP from GPWIPBTD
     C+ where WC_API = 'OPAY'
     C+ fetch first 1 row only
     C/end-exec
     C                   If        xxBSTP = *blanks
     C/exec SQL
     C+ update GPWIPBTD b
     C+ set (b.WCAN, b.WCAC, b.WCAT, b.WCBSTP)  =
     C+ (select c.WCAN, c.WCAC, c.WCAT, c.WCBSTP
     C+ from GPWIPCTD c where c.WC_API = b.WC_API
     C+ and c.WC_ZONE = '*REFZONE')
     C+ where exists (select * from GPWIPCTD c where c.WC_API = b.WC_API
     C+ and c.WC_ZONE = '*REFZONE') and (b.WC_API = 'IPAY' or b.WC_API = 'OPAY')
     C/end-exec

     C                   IF        SQLCODE <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   Dump
     C                   ENDIF
     C
     C                   ENDIF

     C                   ENDIF
     C                   ENDSR

      /EJECT
      *****************************************************************

      * SR_AddExt - Add records in Extension file if found in Bespoke file
      *             but not in extension file

      *****************************************************************
     C     SR_AddExtB    BEGSR

     C                   eval      XINDEXB = %SUBST(XINDEX:1:5) + 'BTD'
     C                   If        XINDEX <> 'GPWIPCTD'


     C                   eval      SQLDynStmt = 'insert into ' +
     C                             %trimr(KMSCHEMA) + '/' + EXTINDEX  +
     C                             ' (select ' +
     C                             %trimr(PSELECT) + ' from ' +
     C                             %trimr(KMSCHEMA) + '/' + XINDEXB  +
     C                             ' A where not exists (select * from ' +
     C                             %trimr(KMSCHEMA) + '/' + EXTINDEX  +
     C                             ' B ' + %trimr(WHERE) + '))'

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

     C/EXEC SQL
     C+           GET DIAGNOSTICS :DSAdXBCnt = Row_Count
     C/END-EXEC

     C                   ELSE

      * Add GPWIPXTD records with *REFZONE (core) in case new API

     C/exec SQL
     C+ insert into GPWIPXTD
     C+ (SELECT WC_ID,
     C+ WC_API, WC_BONSTP, WC_BOASTP,
     C+ WC_AUTLVL, WC_ZONE, 'C'
     C+ FROM GPWIPCTD A where A.WC_ZONE = '*REFZONE'
     C+ and not exists (select * from GPWIPXTD B
     C+ where A.WC_API = B.WC_API and B.WC_ZONE = '*REFZONE'))
     C/end-exec
     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   Dump
     C                   Endif

      * Add GPWIPXTD records with blank zone for global API

     C/exec SQL
     C+ insert into GPWIPXTD
     C+ (SELECT WC_ID,
     C+ WC_API, WC_BONSTP, WC_BOASTP,
     C+ WC_AUTLVL, WC_ZONE, 'C'
     C+ FROM GPWIPCTD A where A.WC_ZONE = '          '
     C+ and not exists (select * from GPWIPXTD B
     C+ where A.WC_API = B.WC_API and B.WC_ZONE = '          '))
     C/end-exec
     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   Dump
     C                   Endif

      * Add GPWIPBTD records with zone (bespoke) in case new API

     C/exec SQL
     C+ insert into GPWIPBTD
     C+ OVERRIDING USER VALUE
     C+ (SELECT WC_ID,
     C+ WC_API, WC_CAT, WC_BONSTP, WC_BOASTP, WC_BOAC, WC_BOACNE,
     C+ WC_BOACAM, WC_BOACAU, WC_BOACCL, WC_BOACDE, WC_BOACRE,
     C+ WC_BOACCH, WC_AUTOA, WC_AUTLVL, ZOZONE as WC_ZONE,
     C+ WC_SYSTEM, WC_BOFLD1, WC_BOFLD2, WC_BOFLD3, WC_BOFLD4,
     C**WC_BOFLD5,*'B'*FROM*GPWIPCTD*A,*GPZONEPD
     C+ WC_BOFLD5, 'B' , WCAN, WCAC, WCAT, WCBSTP
     C+ FROM GPWIPCTD A, GPZONEPD
     C+ where A.WC_ZONE = '*REFZONE' and not exists
     C+ (select * from GPWIPBTD B where A.WC_API = B.WC_API))
     C/end-exec

     C                   IF        SQLCODE <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   Dump
     C                   ENDIF

      * Add GPWIPXTD records with zone (bespoke) in case new API

     C/exec SQL
     C+ insert into GPWIPXTD
     C+ (SELECT WC_ID,
     C+ WC_API, WC_BONSTP, WC_BOASTP,
     C+ WC_AUTLVL, WC_ZONE, 'B'
     C+ FROM GPWIPBTD A where
     C+ not exists (select * from GPWIPXTD B
     C**where*A.WC_API*=*B.WC_API*and*B.WC_ZONE*<>*'*REFZONE'))
     C+ where A.WC_API = B.WC_API and B.WC_ZONE <> '*REFZONE' and
     C+ WC_ZONE <> '        '))
     C/end-exec
     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   Dump
     C                   Endif

      * update GPWIPBTD records (bespoke) in case of change in core fields

     C/exec SQL
     C+ update GPWIPBTD b
     C+ set
     C+ (b.WC_CAT, b.WC_BOAC, b.WC_BOACNE,
     C+ b.WC_BOACAM, b.WC_BOACCL, b.WC_BOACDE, b.WC_BOACRE,
     C+ b.WC_BOACCH, b.WC_AUTOA,
     C+ b.WC_SYSTEM, b.WC_BOFLD1, b.WC_BOFLD2, b.WC_BOFLD3, b.WC_BOFLD4,
     C+ b.WC_BOFLD5) =
     C+ (select c.WC_CAT, c.WC_BOAC, c.WC_BOACNE,
     C+ c.WC_BOACAM, c.WC_BOACCL, c.WC_BOACDE, c.WC_BOACRE,
     C+ c.WC_BOACCH, c.WC_AUTOA,
     C+ c.WC_SYSTEM, c.WC_BOFLD1, c.WC_BOFLD2, c.WC_BOFLD3, c.WC_BOFLD4,
     C+ c.WC_BOFLD5 from GPWIPCTD c where c.WC_API = b.WC_API
     C+ and c.WC_ZONE = '*REFZONE')
     C+ where exists (select * from GPWIPCTD c where c.WC_API = b.WC_API
     C+ and c.WC_ZONE = '*REFZONE')
     C/end-exec

     C                   IF        SQLCODE <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   Dump
     C                   ENDIF

     C/exec SQL
     C+ update GPWIPBTD b
     C+ set (b.WC_BOACAU) =
     C+ (select c.WC_BOACAU
     C+ from GPWIPCTD c where c.WC_API = b.WC_API
     C+ and c.WC_ZONE = '*REFZONE'and c.WC_API = 'BITH')
     C+ where exists (select * from GPWIPCTD c where c.WC_API = b.WC_API
     C+ and c.WC_ZONE = '*REFZONE' and c.WC_API = 'BITH')
     C/end-exec

     C                   IF        SQLCODE <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   Dump
     C                   ENDIF

      * if CFT157 fields are left blank, then initialize them with values from CTD
     C/exec SQL
     C+ select WCBSTP into :xxBSTP from GPWIPBTD
     C+ where WC_API = 'OPAY'
     C+ fetch first 1 row only
     C/end-exec
     C                   If        xxBSTP = *blanks
     C/exec SQL
     C+ update GPWIPBTD b
     C+ set (b.WCAN, b.WCAC, b.WCAT, b.WCBSTP)  =
     C+ (select c.WCAN, c.WCAC, c.WCAT, c.WCBSTP
     C+ from GPWIPCTD c where c.WC_API = b.WC_API
     C+ and c.WC_ZONE = '*REFZONE')
     C+ where exists (select * from GPWIPCTD c where c.WC_API = b.WC_API
     C+ and c.WC_ZONE = '*REFZONE') and (b.WC_API = 'IPAY' or b.WC_API = 'OPAY')
     C/end-exec

     C                   IF        SQLCODE <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   Dump
     C                   ENDIF
     C
     C                   ENDIF

     C                   ENDIF
     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *    SR_CBCMP - Special process to update CBCMPXTD              *
      *                                                               *
      *****************************************************************

     C     SR_CBCMP      BEGSR

     C                   eval      KMSCHEMA = %SUBST(XSCHEMA:1:3) + 'MLIB'

     C                   eval      SQLDynStmt = 'update '      +
     C                             %trimr(KMSCHEMA) + '/CBCMPXTD x '  +
     C                             ' set (x.dhcprm ) = (select c.dhcprm ' +
     C                             ' from CBCMPCTD c ' +
     C                             ' where x.dhcott = c.dhcott and x.dhcseq ' +
     C                             ' = c.dhcseq and c.dhcpca <> ''Y'') ' +
     C                             ' where exists (select * from CBCMPCTD c' +
     C                             ' where x.dhcott = c.dhcott and x.dhcseq ' +
     C                             ' = c.dhcseq and c.dhcpca <> ''Y'')'

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
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    FindBespFlds - Find bespoke fields on 'old' file.          *
      *                                                               *
      *****************************************************************
      *
     C     BldOutFile    BEGSR
      *
     C                   CALL      'UTC000004'
     C                   PARM                    EXTINDEX
     C                   PARM                    KMSCHEMA
     C                   PARM                    OutFile
     C                   PARM      '*FIRST'      OFMbr
     C                   PARM      '*REPLACE'    OFMbrOpt
     C
      *
     C     BldOutFileE   ENDSR
      /EJECT
      *****************************************************************
