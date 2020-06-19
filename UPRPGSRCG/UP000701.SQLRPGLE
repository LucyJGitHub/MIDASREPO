     H DEBUG
     H COPYRIGHT('(c) Finastra International 2019')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - Deliverable Data Split Synchronisation')    *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000701 - This program synchronize Extension and Bespoke    *
      *             files with new data from Deliverable Data Split   *
      *             file.                                             *
      *                                                               *
      *  (c) Finastra International 2019                              *
      *                                                               *
      *  Last Amend No. MD056020             Date 18Jun20             *
      *  Prev Amend No. MD054955             Date 16Dec19             *
      *                 MD055832             Date 14May20             *
      *                 MD055829             Date 12May20             *
      *                 MD055469             Date 13Mar20             *
      *                 MD054605             Date 17Oct19             *
      *                 MD054209   *CREATE   Date 07Sep19             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056020 - Dumps generated in PRCA because of SQL error      *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD055832 - Avoid deletion of bespoke records in extension    *
      *             table                                             *
      *  MD055829 - GPWIPBTD field WC_BOACAU should not be updated as *
      *             it is linked to LE ICD configuration.             *
      *  MD055469 - Global APIs have WC_ZONE set to blank.            *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD054209 - Deliverable Data Split for T_WIPCF                *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D EXTINDEX        S             10A
     D KXINDEX         S             10A
     D KXSCHEMA        S             10A
     D KMSCHEMA        S             10A                                                    MD054605
     D BINDEX          S             10A                                                    MD055832
     D BSCHEMA         S             10A                                                    MD055832
     D KColumn         S             10A
     D KOrdinal        S              9  0
     D KeyArr          S             10A   DIM(12)
     D WIdx            S              3P 0
     D KeyFld          S            200A
     D*WHERE****       S            300A                                                    MD054955
     D WHERE           S            600A                                                    MD054955
     D*WHEREX***       S            300A                                           MD055832 MD054955
     D WHEREX          S            600A                                                    MD054955
     D*PINSERT**       S            300A                                                    MD054955
     D PINSERT         S            600A                                                    MD054955
     D*PSELECT**       S            300A                                                    MD054955
     D PSELECT         S            600A                                                    MD054955
     D SQLDynStmt      S           5000A
     D Outfile         S             10A
     D OFMbr           S             10A
     D OFMbrOpt        S              8A
     D First           S              1A
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

      * Retrieve key fields
     C                   exsr      SR_RtvKeys

      * Delete from extension file if not found in core file
      * and not found in bespoke file                                                       MD055832
     C                   exsr      SR_DltExt

      * Add missing record in extension file if found in core file but not in the extension
     C                   exsr      SR_AddExt

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

      * SR_DltExt - Delete records in Extension file if not found in Core file

      *****************************************************************
     C     SR_DltExt     BEGSR

     C                   If        XINDEX <> 'GPWIPCTD'

     C                   eval      EXTINDEX = %SUBST(XINDEX:1:5) + 'XTD'
     C                   eval      BINDEX = %SUBST(XINDEX:1:5) + 'BTD'                      MD055832
     C                   eval      WIdx = 1
     C                   eval      WHERE = *BLANKS
     C                   eval      WHEREX = *BLANKS                                         MD055832
     C                   eval      WHERE = ' WHERE A.' + %trimr(KeyArr(WIdx)) +
     C                             ' = B.' + %trimr(KeyArr(WIdx))
     C                   eval      WHEREX= ' WHERE A.' + %trimr(KeyArr(WIdx)) +             MD055832
     C                             ' = X.' + %trimr(KeyArr(WIdx))                           MD055832
     C                   eval      WIdx = WIdx + 1
     C                   eval      BSCHEMA = %subst(XSCHEMA:1:3) + 'MLIB'                   MD055832

     C     KeyArr(WIdx)  DOWNE     *BLANKS
     C     WIdx          ANDLT     13
     C                   eval      WHERE = %trimr(WHERE) + ' and A.' +
     C                             %trimr(KeyArr(WIdx)) +
     C                             ' = B.' + %trimr(KeyArr(WIdx))
     C**********         eval      WHEREX = %trimr(WHERE) + ' and A.' +            MD055832 MD056020
     C                   eval      WHEREX = %trimr(WHEREX) + ' and A.' +                    MD056020
     C                             %trimr(KeyArr(WIdx)) +                                   MD055832
     C                             ' = X.' + %trimr(KeyArr(WIdx))                           MD055832
     C                   eval      WIdx = WIdx + 1
     C                   ENDDO

     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = 'delete from ' + EXTINDEX +
     C                             ' A where not exists (select * from ' +
     C                             %trimr(XSCHEMA) + '/' + XINDEX +
     C**********                   ' B ' +  %trimr(WHERE) + ')'                             MD055832
     C                             ' B ' +  %trimr(WHERE) + ') and ' +                      MD055832
     C                             '  not exists (select * from ' +                         MD055832
     C                             %trimr(BSCHEMA) + '/' + BINDEX +                         MD055832
     C                             ' X ' +  %trimr(WHEREX) + ')'                            MD055832

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
     C                   Endif

     C                   ELSE

      * delete GPWIPXTD records not found in Core

     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = 'delete from GPWIPXTD' +
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
     C                   Endif

      * Additional process for GPWIPBTD as the Bespoke records are the zonal WIP config

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
     C                   Endif

     C                   ENDIF
     C                   ENDSR

      *****************************************************************

      * SR_AddExt - Add records in Extension file if found in Core file
      *             but not in extension file

      *****************************************************************
     C     SR_AddExt     BEGSR

     C                   If        XINDEX <> 'GPWIPCTD'

     C                   eval      First = 'Y'                                              MD054605
     C                   eval      KMSCHEMA = %SUBST(XSCHEMA:1:3) + 'MLIB'                  MD054605
      ** Call program to produce file field description outfile of  file.
     C                   EVAL      OutFile = 'UDFOLD'
     C                   EXSR      BldOutFile

     C/exec SQL
     C+ declare GetFields cursor for
     C+ select *
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
     C+ into :FldData
     C/end-exec
      *
     C                   DOW       SQLCODE = 0

     C                   IF        First = 'Y'
      ** Get until the fieldadd to the end of the table.
     C                   eval      PINSERT = %trimr(PINSERT) + WHFLDI
     C**********         eval      PSELECT = %trimr(PSELECT) + WHFLDI                       MD054605
     C                   eval      PSELECT = %trimr(PSELECT) + 'A.' + WHFLDI                MD054605
     C                   eval      First = 'N'
     C                   ELSE
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + WHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + ',A.' + WHFLDI
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFields
     C+ into :FldData
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close GetFields
     C/end-exec

     C                   eval      PINSERT = %trimr(PINSERT) + ')'

     C**********         eval      SQLDynStmt = 'insert into ' + KXINDEX +                  MD054605
     C                   eval      SQLDynStmt = 'insert into ' + EXTINDEX +                 MD054605
     C**********                   %trimr(PINSERT) + ' select ' +                           MD054605
     C                             ' (select ' +                                            MD054605
     C                             %trimr(PSELECT) + ' from ' +
     C                             %trimr(XSCHEMA) + '/' + XINDEX  +
     C                             ' A where not exists (select * from ' +
     C**********                   XINDEX +  ' B ' + %trimr(WHERE) + ')'                    MD054605
     C                             EXTINDEX +  ' B ' + %trimr(WHERE) + '))'                 MD054605

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
     C                   Endif
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
     C                   Endif

      * Add GPWIPXTD records with blank zone for global API                                 MD055469
                                                                                            MD055469
     C/exec SQL                                                                             MD055469
     C+ insert into GPWIPXTD                                                                MD055469
     C+ (SELECT WC_ID,                                                                      MD055469
     C+ WC_API, WC_BONSTP, WC_BOASTP,                                                       MD055469
     C+ WC_AUTLVL, WC_ZONE, 'C'                                                             MD055469
     C+ FROM GPWIPCTD A where A.WC_ZONE = '          '                                      MD055469
     C+ and not exists (select * from GPWIPXTD B                                            MD055469
     C+ where A.WC_API = B.WC_API and B.WC_ZONE = '          '))                            MD055469
     C/end-exec                                                                             MD055469
     C                   If        SQLCode <> 0                                             MD055469
     C                             and SQLCode <> 100                                       MD055469
     C                   eval      ERROR = '*Error'                                         MD055469
     C                   Endif                                                              MD055469
                                                                                            MD055469
      * Add GPWIPBTD records with zone (bespoke) in case new API

     C/exec SQL
     C+ insert into GPWIPBTD
     C+ OVERRIDING USER VALUE
     C+ (SELECT WC_ID,
     C+ WC_API, WC_CAT, WC_BONSTP, WC_BOASTP, WC_BOAC, WC_BOACNE,
     C+ WC_BOACAM, WC_BOACAU, WC_BOACCL, WC_BOACDE, WC_BOACRE,
     C+ WC_BOACCH, WC_AUTOA, WC_AUTLVL, ZOZONE as WC_ZONE,
     C+ WC_SYSTEM, WC_BOFLD1, WC_BOFLD2, WC_BOFLD3, WC_BOFLD4,
     C+ WC_BOFLD5, 'B' FROM GPWIPCTD A, GPZONEPD
     C+ where A.WC_ZONE = '*REFZONE' and not exists
     C+ (select * from GPWIPBTD B where A.WC_API = B.WC_API))
     C/end-exec

     C                   IF        SQLCODE <> 0
     C                             and SQLCode <> 100
     C                   EVAL      ERROR = '*Error'
     C                   ENDIF

      * Add GPWIPXTD records with zone (bespoke) in case new API

     C/exec SQL
     C+ insert into GPWIPXTD
     C+ (SELECT WC_ID,
     C+ WC_API, WC_BONSTP, WC_BOASTP,
     C+ WC_AUTLVL, WC_ZONE, 'B'
     C+ FROM GPWIPBTD A where
     C+ not exists (select * from GPWIPXTD B
     C+ where A.WC_API = B.WC_API and B.WC_ZONE <> '*REFZONE'))
     C/end-exec
     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   Endif

      * update GPWIPBTD records (bespoke) in case of change in core fields

     C/exec SQL
     C+ update GPWIPBTD b
     C+ set
     C+ (b.WC_CAT, b.WC_BOAC, b.WC_BOACNE,
     C**b.WC_BOACAM,*b.WC_BOACAU,*b.WC_BOACCL,*b.WC_BOACDE,*b.WC_BOACRE,                    MD055829
     C+ b.WC_BOACAM, b.WC_BOACCL, b.WC_BOACDE, b.WC_BOACRE,                                 MD055829
     C+ b.WC_BOACCH, b.WC_AUTOA,
     C+ b.WC_SYSTEM, b.WC_BOFLD1, b.WC_BOFLD2, b.WC_BOFLD3, b.WC_BOFLD4,
     C+ b.WC_BOFLD5) =
     C+ (select c.WC_CAT, c.WC_BOAC, c.WC_BOACNE,
     C**c.WC_BOACAM,*c.WC_BOACAU,*c.WC_BOACCL,*c.WC_BOACDE,*c.WC_BOACRE,                    MD055829
     C+ c.WC_BOACAM, c.WC_BOACCL, c.WC_BOACDE, c.WC_BOACRE,                                 MD055829
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
     C                   ENDIF

     C                   ENDIF
     C                   ENDSR

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
     C**********         PARM                    KXINDEX                                    MD054605
     C                   PARM                    EXTINDEX                                   MD054605
     C**********         PARM                    KXSCHEMA                                   MD054605
     C                   PARM                    KMSCHEMA                                   MD054605
     C                   PARM                    OutFile
     C                   PARM      '*FIRST'      OFMbr
     C                   PARM      '*REPLACE'    OFMbrOpt
     C
      *
     C     BldOutFileE   ENDSR
      *
