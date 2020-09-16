     H DEBUG
     H COPYRIGHT('(c) Finastra International 2019')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - Deliverable Data Split Take on')            *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000703 - This program update Extension file based on       *
      *             old file.                                         *
      *                                                               *
      *  (c) Finastra International 2019                              *
      *                                                               *
<<<<<<< HEAD
      *  Last Amend No. MD056696             Date 09Sep20             *
      *  Prev Amend No. MD055681             Date 31Jul20             *
      *                 MD054955             Date 16Dec19             *
      *                 MD054605   *CREATE   Date 17Oct19             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056696 - SCSARDPD, SCSAREPD and REAPWDPD should not be     *
      *             added as Bespoke record in SCTRGBTD.              *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D EXTINDEX        S             10A
     D BINDEX          S             10A
     D KXINDEX         S             10A
     D KXSCHEMA        S             10A
     D KMSCHEMA        S             10A
     D KColumn         S             10A
     D KOrdinal        S              9  0
     D KeyArr          S             10A   DIM(12)
     D WIdx            S              3P 0
     D KeyFld          S            200A
     D*WHERE****       S            300A                                                    MD054955
     D WHERE           S            600A                                                    MD054955
     D*PINSERT**       S            300A                                                    MD054955
     D PINSERT         S            600A                                                    MD054955
     D*PSELECT**       S            300A                                                    MD054955
     D PSELECT         S            600A                                                    MD054955
     D SQLDynStmt      S           5000A
     D Outfile         S             10A
     D OFMbr           S             10A
     D OFMbrOpt        S              8A
     D First           S              1A
     D TotRow          S             13  0
     D FldData       E DS                  EXTNAME(UPFFDSTPD)
     D LibMov          S             10A                                                    MD055681
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
     C                   PARM                    OLDFILE          10

      * Retrieve key fields
     C                   exsr      SR_RtvKeys

     C                   Select                                                             MD055681
                                                                                            MD055681
     C                   when      XINDEX = 'SCSRSCTD'                                      MD055681
      * Update BTD new fields and XTD file                                                  MD055681
     C                   exsr      SR_SCSARZPD                                              MD055681
                                                                                            MD055681
     C                   when      XINDEX = 'SCSRDCTD'                                      MD055681
      * Update BTD new fields, remove BTD and update XTD file                               MD055681
     C                   exsr      SR_SCSARDPD                                              MD055681
                                                                                            MD055681
     C                   when      XINDEX = 'GPSRDCTD'                                      MD055681
      * Update BTD new fields, remove BTD and update XTD file                               MD055681
     C                   exsr      SR_GPSARDPD                                              MD055681
                                                                                            MD055681
     C                   Other                                                              MD055681
      * Update Extension file with content of 'old file'
     C                   exsr      SR_UpdExt

      * Add Bespoke record if not found in core file
     C                   exsr      SR_AddBsp

     C                   ENDSL                                                              MD055681
                                                                                            MD055681
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

      ** build WHERE clause
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
     C                   ENDSR

      *****************************************************************

      * SR_UpdExt - Upd records in Extension file if found in old file

      *****************************************************************
     C     SR_UpdExt     BEGSR

     C                   eval      First = 'Y'
     C                   eval      KMSCHEMA = %SUBST(XSCHEMA:1:3) + 'MLIB'
     C                   eval      EXTINDEX = %SUBST(XINDEX:1:5) + 'XTD'

      ** Call program to produce file field description outfile of extension file
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

      ** Ignore if field is part of key fields
     C     WHFLDI        SCAN      KeyFld                                 99
     C                   IF        *IN99  = '0'
     C                             and %SUBST(WHFLDI:3:4) <> 'MODE'
     C                   IF        First = 'Y'
      ** Get until the fieldadd to the end of the table.
     C                   eval      PINSERT = %trimr(PINSERT) + 'B.' + WHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + 'A.' + WHFLDI
     C                   eval      First = 'N'
     C                   ELSE
     C                   eval      PINSERT = %trimr(PINSERT) + ',B.' + WHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + ',A.' + WHFLDI
     C                   ENDIF
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


      ** Update XTD file only if there is at least one filed to update                      MD054955
     C                   If        PINSERT <> *blanks                                       MD054955
     C                   eval      SQLDynStmt = 'update ' + EXTINDEX +
     C                             ' B set (' + %trimr(PINSERT) +
     C                             ') = (select ' + %trimr(PSELECT) +
     C                             ' from ' + OLDFILE + ' A ' + %trimr(WHERE) +
     C                             ') where  exists (select * from ' +
     C                             OLDFILE +  ' A ' + %trimr(WHERE) + ')'

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
     C                   Endif                                                              MD054955
                                                                                            MD054955
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
     C                   PARM                    EXTINDEX
     C                   PARM                    KMSCHEMA
     C                   PARM                    OutFile
     C                   PARM      '*FIRST'      OFMbr
     C                   PARM      '*REPLACE'    OFMbrOpt
     C
      *
     C     BldOutFileE   ENDSR
      *
      *****************************************************************

      * SR_AddBsp - Add records in Bespoke file if not found in Core file

      *****************************************************************
     C     SR_AddBsp     BEGSR


     C                   eval      First = 'Y'
     C                   eval      PINSERT = *BLANKS
     C                   eval      PSELECT = *BLANKS
     C                   eval      KMSCHEMA = %SUBST(XSCHEMA:1:3) + 'MLIB'
     C                   eval      EXTINDEX = %SUBST(XINDEX:1:5) + 'BTD'
      ** Call program to produce file field description outfile of  file.
     C                   EVAL      OutFile = 'UDFOLD'
     C                   EXSR      BldOutFile

     C/exec SQL
     C+ declare GetFieldsB cursor for
     C+ select *
     C+ from UDFOLD
     C/end-exec
      *
     C/exec SQL
     C+ open GetFieldsB
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFieldsB
     C+ into :FldData
     C/end-exec
      *
     C                   DOW       SQLCODE = 0

     C                   IF        %SUBST(WHFLDI:3:4) <> 'MODE'
     C                   IF        First = 'Y'
      ** Get until the fieldadd to the end of the table.
     C                   eval      PINSERT = %trimr(PINSERT) + WHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + 'A.' + WHFLDI
     C                   eval      First = 'N'
     C                   ELSE
     C                   IF        WHFLDI = 'AXPROT'                                        MD055681
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + WHFLDI                 MD055681
     C                   eval      PSELECT = %trimr(PSELECT) + ', ' + '''Y'''               MD055681
     C                   else                                                               MD055681
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + WHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + ',A.' + WHFLDI
     C                   ENDIF                                                              MD055681
     C                   ENDIF
     C                   else
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + WHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + ', ' + '''B'''
     C                   Endif
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFieldsB
     C+ into :FldData
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close GetFieldsB
     C/end-exec

     C                   eval      SQLDynStmt = 'insert into ' + EXTINDEX +
     C                             ' (select ' +
     C                             %trimr(PSELECT) + ' from ' + OLDFILE +
     C                             ' A where not exists (select * from ' +
     C                             XINDEX +  ' B ' + %trimr(WHERE) + '))'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C/EXEC SQL
     C+ get diagnostics :TotRow  = ROW_COUNT
     C/END-EXEC

     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   Endif

      ** If records were added in Bespoke, records must be added in Extension file too
     C                   If        TotRow > 0
     C                   exsr      SR_AddExt
     C                   ENDIF
     C

     C                   If        XINDEX = 'SCTRGCTD'                                      MD056696
     C/EXEC SQL                                                                             MD056696
     C+ delete from SCTRGBTD where TRFILE = 'SCSARDPD' or TRFILE                            MD056696
     C+ = 'SCSAREPD' or TRFILE = 'REAPWDPD'                                                 MD056696
     C/END-EXEC                                                                             MD056696
     C/EXEC SQL                                                                             MD056696
     C+ delete from SCTRGXTD where TRFILE = 'SCSARDPD' or TRFILE                            MD056696
     C+ = 'SCSAREPD' or TRFILE = 'REAPWDPD'                                                 MD056696
     C/END-EXEC                                                                             MD056696
     C                   Endif                                                              MD056696
                                                                                            MD056696
=======
      *  Last Amend No. MD055681             Date 31Jul20             *
      *  Prev Amend No. MD054955             Date 16Dec19             *
      *                 MD054605   *CREATE   Date 17Oct19             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D EXTINDEX        S             10A
     D BINDEX          S             10A
     D KXINDEX         S             10A
     D KXSCHEMA        S             10A
     D KMSCHEMA        S             10A
     D KColumn         S             10A
     D KOrdinal        S              9  0
     D KeyArr          S             10A   DIM(12)
     D WIdx            S              3P 0
     D KeyFld          S            200A
     D*WHERE****       S            300A                                                    MD054955
     D WHERE           S            600A                                                    MD054955
     D*PINSERT**       S            300A                                                    MD054955
     D PINSERT         S            600A                                                    MD054955
     D*PSELECT**       S            300A                                                    MD054955
     D PSELECT         S            600A                                                    MD054955
     D SQLDynStmt      S           5000A
     D Outfile         S             10A
     D OFMbr           S             10A
     D OFMbrOpt        S              8A
     D First           S              1A
     D TotRow          S             13  0
     D FldData       E DS                  EXTNAME(UPFFDSTPD)
     D LibMov          S             10A                                                    MD055681
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
     C                   PARM                    OLDFILE          10

      * Retrieve key fields
     C                   exsr      SR_RtvKeys

     C                   Select                                                             MD055681
                                                                                            MD055681
     C                   when      XINDEX = 'SCSRSCTD'                                      MD055681
      * Update BTD new fields and XTD file                                                  MD055681
     C                   exsr      SR_SCSARZPD                                              MD055681
                                                                                            MD055681
     C                   when      XINDEX = 'SCSRDCTD'                                      MD055681
      * Update BTD new fields, remove BTD and update XTD file                               MD055681
     C                   exsr      SR_SCSARDPD                                              MD055681
                                                                                            MD055681
     C                   when      XINDEX = 'GPSRDCTD'                                      MD055681
      * Update BTD new fields, remove BTD and update XTD file                               MD055681
     C                   exsr      SR_GPSARDPD                                              MD055681
                                                                                            MD055681
     C                   Other                                                              MD055681
      * Update Extension file with content of 'old file'
     C                   exsr      SR_UpdExt

      * Add Bespoke record if not found in core file
     C                   exsr      SR_AddBsp

     C                   ENDSL                                                              MD055681
                                                                                            MD055681
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

      ** build WHERE clause
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
     C                   ENDSR

      *****************************************************************

      * SR_UpdExt - Upd records in Extension file if found in old file

      *****************************************************************
     C     SR_UpdExt     BEGSR

     C                   eval      First = 'Y'
     C                   eval      KMSCHEMA = %SUBST(XSCHEMA:1:3) + 'MLIB'
     C                   eval      EXTINDEX = %SUBST(XINDEX:1:5) + 'XTD'

      ** Call program to produce file field description outfile of extension file
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

      ** Ignore if field is part of key fields
     C     WHFLDI        SCAN      KeyFld                                 99
     C                   IF        *IN99  = '0'
     C                             and %SUBST(WHFLDI:3:4) <> 'MODE'
     C                   IF        First = 'Y'
      ** Get until the fieldadd to the end of the table.
     C                   eval      PINSERT = %trimr(PINSERT) + 'B.' + WHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + 'A.' + WHFLDI
     C                   eval      First = 'N'
     C                   ELSE
     C                   eval      PINSERT = %trimr(PINSERT) + ',B.' + WHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + ',A.' + WHFLDI
     C                   ENDIF
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


      ** Update XTD file only if there is at least one filed to update                      MD054955
     C                   If        PINSERT <> *blanks                                       MD054955
     C                   eval      SQLDynStmt = 'update ' + EXTINDEX +
     C                             ' B set (' + %trimr(PINSERT) +
     C                             ') = (select ' + %trimr(PSELECT) +
     C                             ' from ' + OLDFILE + ' A ' + %trimr(WHERE) +
     C                             ') where  exists (select * from ' +
     C                             OLDFILE +  ' A ' + %trimr(WHERE) + ')'

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
     C                   Endif                                                              MD054955
                                                                                            MD054955
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
     C                   PARM                    EXTINDEX
     C                   PARM                    KMSCHEMA
     C                   PARM                    OutFile
     C                   PARM      '*FIRST'      OFMbr
     C                   PARM      '*REPLACE'    OFMbrOpt
     C
      *
     C     BldOutFileE   ENDSR
      *
      *****************************************************************

      * SR_AddBsp - Add records in Bespoke file if not found in Core file

      *****************************************************************
     C     SR_AddBsp     BEGSR


     C                   eval      First = 'Y'
     C                   eval      PINSERT = *BLANKS
     C                   eval      PSELECT = *BLANKS
     C                   eval      KMSCHEMA = %SUBST(XSCHEMA:1:3) + 'MLIB'
     C                   eval      EXTINDEX = %SUBST(XINDEX:1:5) + 'BTD'
      ** Call program to produce file field description outfile of  file.
     C                   EVAL      OutFile = 'UDFOLD'
     C                   EXSR      BldOutFile

     C/exec SQL
     C+ declare GetFieldsB cursor for
     C+ select *
     C+ from UDFOLD
     C/end-exec
      *
     C/exec SQL
     C+ open GetFieldsB
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFieldsB
     C+ into :FldData
     C/end-exec
      *
     C                   DOW       SQLCODE = 0

     C                   IF        %SUBST(WHFLDI:3:4) <> 'MODE'
     C                   IF        First = 'Y'
      ** Get until the fieldadd to the end of the table.
     C                   eval      PINSERT = %trimr(PINSERT) + WHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + 'A.' + WHFLDI
     C                   eval      First = 'N'
     C                   ELSE
     C                   IF        WHFLDI = 'AXPROT'                                        MD055681
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + WHFLDI                 MD055681
     C                   eval      PSELECT = %trimr(PSELECT) + ', ' + '''Y'''               MD055681
     C                   else                                                               MD055681
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + WHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + ',A.' + WHFLDI
     C                   ENDIF                                                              MD055681
     C                   ENDIF
     C                   else
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + WHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + ', ' + '''B'''
     C                   Endif
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFieldsB
     C+ into :FldData
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close GetFieldsB
     C/end-exec

     C                   eval      SQLDynStmt = 'insert into ' + EXTINDEX +
     C                             ' (select ' +
     C                             %trimr(PSELECT) + ' from ' + OLDFILE +
     C                             ' A where not exists (select * from ' +
     C                             XINDEX +  ' B ' + %trimr(WHERE) + '))'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C/EXEC SQL
     C+ get diagnostics :TotRow  = ROW_COUNT
     C/END-EXEC

     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   Endif

      ** If records were added in Bespoke, records must be added in Extension file too
     C                   If        TotRow > 0
     C                   exsr      SR_AddExt
     C                   ENDIF
     C

>>>>>>> branch 'feature/MDSC-33215' of http://blrvslalm0006:7990/scm/md/midasrpg.git
     C                   ENDSR

      /EJECT
      *****************************************************************

      * SR_AddExt - Add records in Extension file if found in Bespoke file
      *             but not in extension file

      *****************************************************************
     C     SR_AddExt     BEGSR


     C                   eval      First = 'Y'
     C                   eval      PINSERT = *BLANKS
     C                   eval      PSELECT = *BLANKS
     C
     C                   eval      KMSCHEMA = %SUBST(XSCHEMA:1:3) + 'MLIB'
     C                   eval      EXTINDEX = %SUBST(XINDEX:1:5) + 'XTD'
     C                   eval      BINDEX = %SUBST(XINDEX:1:5) + 'BTD'
      ** Call program to produce file field description outfile of  file.
     C                   EVAL      OutFile = 'UDFOLD'
     C                   EXSR      BldOutFile

     C/exec SQL
     C+ declare GetFieldsX cursor for
     C+ select *
     C+ from UDFOLD
     C/end-exec
      *
     C/exec SQL
     C+ open GetFieldsX
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFieldsX
     C+ into :FldData
     C/end-exec
      *
     C                   DOW       SQLCODE = 0

     C                   IF        %SUBST(WHFLDI:3:4) <> 'MODE'
     C                   IF        First = 'Y'
      ** Get until the fieldadd to the end of the table.
     C                   eval      PINSERT = %trimr(PINSERT) + WHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + 'A.' + WHFLDI
     C                   eval      First = 'N'
     C                   ELSE
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + WHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + ',A.' + WHFLDI
     C                   ENDIF
     C                   else
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + WHFLDI
     C                   eval      PSELECT = %trimr(PSELECT) + ', ' + '''B'''
     C                   Endif
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFieldsX
     C+ into :FldData
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close GetFieldsX
     C/end-exec


     C                   eval      SQLDynStmt = 'insert into ' + EXTINDEX +
     C                             ' (select ' +
     C                             %trimr(PSELECT) + ' from ' +
     C                             BINDEX  +
     C                             ' A where not exists (select * from ' +
     C                             EXTINDEX +  ' B ' + %trimr(WHERE) + '))'

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
     C                   ENDSR

      /EJECT
      *****************************************************************
      /EJECT                                                                                MD055681
      *****************************************************************                     MD055681
                                                                                            MD055681
      * SR_SCSARZPD - Update new fields introduced in BTD and add                           MD055681
      *               corresponding records in XTD                                          MD055681
                                                                                            MD055681
      *****************************************************************                     MD055681
     C     SR_SCSARZPD   BEGSR                                                              MD055681
                                                                                            MD055681
      * update AXPROT and AXMODE fields                                                     MD055681
     C/EXEC SQL                                                                             MD055681
     C+ update SCSRSBTD set                                                                 MD055681
     C+   AXPROT = 'Y'                                                                      MD055681
     C+ , AXMODE = 'B'                                                                      MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C                   If        SQLCode <> 0                                             MD055681
     C                             and SQLCode <> 100                                       MD055681
     C                   eval      ERROR = '*Error'                                         MD055681
     C                   Endif                                                              MD055681
                                                                                            MD055681
      * delete BTD records if found in CTD (in case bespoke feature went to core)           MD055681
     C/EXEC SQL                                                                             MD055681
     C+ delete SCSRSBTD b where exists                                                      MD055681
     C+   (select * from SCSRSCTD c where c.AXSARN = b.AXSARN)                              MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C                   If        SQLCode <> 0                                             MD055681
     C                             and SQLCode <> 100                                       MD055681
     C                   eval      ERROR = '*Error'                                         MD055681
     C                   Endif                                                              MD055681
                                                                                            MD055681
                                                                                            MD055681
      * insert XTD records for the BTD records added by CPYF in UPC000700                   MD055681
     C                   eval      First = 'Y'                                              MD055681
     C                   eval      PINSERT = *BLANKS                                        MD055681
     C                   eval      PSELECT = *BLANKS                                        MD055681
     C                                                                                      MD055681
     C                   eval      KMSCHEMA = %SUBST(XSCHEMA:1:3) + 'MLIB'                  MD055681
     C                   eval      EXTINDEX = %SUBST(XINDEX:1:5) + 'XTD'                    MD055681
     C                   eval      BINDEX = %SUBST(XINDEX:1:5) + 'BTD'                      MD055681
      ** Call program to produce file field description outfile of  file.                   MD055681
     C                   EVAL      OutFile = 'UDFOLD'                                       MD055681
     C                   EXSR      BldOutFile                                               MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ declare GetFieldsZ cursor for                                                       MD055681
     C+ select *                                                                            MD055681
     C+ from UDFOLD                                                                         MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ open GetFieldsZ                                                                     MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ fetch next                                                                          MD055681
     C+ from GetFieldsZ                                                                     MD055681
     C+ into :FldData                                                                       MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C                   DOW       SQLCODE = 0                                              MD055681
                                                                                            MD055681
     C                   IF        %SUBST(WHFLDI:3:4) <> 'MODE'                             MD055681
     C                   IF        First = 'Y'                                              MD055681
      ** Get until the fieldadd to the end of the table.                                    MD055681
     C                   eval      PINSERT = %trimr(PINSERT) + WHFLDI                       MD055681
     C                   eval      PSELECT = %trimr(PSELECT) + 'A.' + WHFLDI                MD055681
     C                   eval      First = 'N'                                              MD055681
     C                   ELSE                                                               MD055681
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + WHFLDI                 MD055681
     C                   eval      PSELECT = %trimr(PSELECT) + ',A.' + WHFLDI               MD055681
     C                   ENDIF                                                              MD055681
     C                   else                                                               MD055681
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + WHFLDI                 MD055681
     C                   eval      PSELECT = %trimr(PSELECT) + ', ' + '''B'''               MD055681
     C                   Endif                                                              MD055681
      *                                                                                     MD055681
     C/exec SQL                                                                             MD055681
     C+ fetch next                                                                          MD055681
     C+ from GetFieldsZ                                                                     MD055681
     C+ into :FldData                                                                       MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C                   ENDDO                                                              MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ close GetFieldsZ                                                                    MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
                                                                                            MD055681
     C                   eval      SQLDynStmt = 'insert into ' + EXTINDEX +                 MD055681
     C                             ' (select ' +                                            MD055681
     C                             %trimr(PSELECT) + ' from ' +                             MD055681
     C                             BINDEX  +                                                MD055681
     C                             ' A where not exists (select * from ' +                  MD055681
     C                             EXTINDEX +  ' B ' + %trimr(WHERE) + '))'                 MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ prepare DynSQLStmnt                                                                 MD055681
     C+ from :SQLDynStmt                                                                    MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ execute DynSQLStmnt                                                                 MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C                   If        SQLCode <> 0                                             MD055681
     C                             and SQLCode <> 100                                       MD055681
     C                   eval      ERROR = '*Error'                                         MD055681
     C                   Endif                                                              MD055681
     C                   ENDSR                                                              MD055681
                                                                                            MD055681
      /EJECT                                                                                MD055681
      *****************************************************************                     MD055681
                                                                                            MD055681
      * SR_SCSARDPD - Update new fields introduced in BTD and add                           MD055681
      *               corresponding records in XTD                                          MD055681
      *               also remove BTD records already in CTD                                MD055681
                                                                                            MD055681
      *****************************************************************                     MD055681
     C     SR_SCSARDPD   BEGSR                                                              MD055681
                                                                                            MD055681
      * set variable to '#.zzDMLIB                                                          MD055681
     C                   eval      LibMov = '#.' +                                          MD055681
     C                              %SUBST(XSCHEMA:1:3) + 'MLIB'                            MD055681
                                                                                            MD055681
      * first remove BTD records if found in CTD (CTD only contains features not to         MD055681
      * be switched off)                                                                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ delete SCSRDBTD b                                                                   MD055681
     C+   where exists (select * from SCSRDCTD c where c.SARN = b.SARN)                     MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C                   If        SQLCode <> 0                                             MD055681
     C                             and SQLCode <> 100                                       MD055681
     C                   eval      ERROR = '*Error'                                         MD055681
     C                   Endif                                                              MD055681
                                                                                            MD055681
      * update BTD records set field MODE to 'B' for all and ENABLD to 'E' for all first    MD055681
      * [for the disabled ones (from SCSAREPD), XTD records will be updated later]          MD055681
     C/EXEC SQL                                                                             MD055681
     C+ update SCSRDBTD set MODE = 'B', ENABLD = 'E'                                        MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C                   If        SQLCode <> 0                                             MD055681
     C                             and SQLCode <> 100                                       MD055681
     C                   eval      ERROR = '*Error'                                         MD055681
     C                   Endif                                                              MD055681
                                                                                            MD055681
                                                                                            MD055681
      * insert XTD records for the BTD records added                                        MD055681
     C                   eval      First = 'Y'                                              MD055681
     C                   eval      PINSERT = *BLANKS                                        MD055681
     C                   eval      PSELECT = *BLANKS                                        MD055681
     C                                                                                      MD055681
     C                   eval      KMSCHEMA = %SUBST(XSCHEMA:1:3) + 'MLIB'                  MD055681
     C                   eval      EXTINDEX = %SUBST(XINDEX:1:5) + 'XTD'                    MD055681
     C                   eval      BINDEX = %SUBST(XINDEX:1:5) + 'BTD'                      MD055681
      ** Call program to produce file field description outfile of  file.                   MD055681
     C                   EVAL      OutFile = 'UDFOLD'                                       MD055681
     C                   EXSR      BldOutFile                                               MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ declare GetFieldsC cursor for                                                       MD055681
     C+ select *                                                                            MD055681
     C+ from UDFOLD                                                                         MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ open GetFieldsC                                                                     MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ fetch next                                                                          MD055681
     C+ from GetFieldsC                                                                     MD055681
     C+ into :FldData                                                                       MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C                   DOW       SQLCODE = 0                                              MD055681
                                                                                            MD055681
     C                   IF        %SUBST(WHFLDI:3:4) <> 'MODE'                             MD055681
     C                   IF        First = 'Y'                                              MD055681
      ** Get until the fieldadd to the end of the table.                                    MD055681
     C                   eval      PINSERT = %trimr(PINSERT) + WHFLDI                       MD055681
     C                   eval      PSELECT = %trimr(PSELECT) + 'A.' + WHFLDI                MD055681
     C                   eval      First = 'N'                                              MD055681
     C                   ELSE                                                               MD055681
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + WHFLDI                 MD055681
     C                   eval      PSELECT = %trimr(PSELECT) + ',A.' + WHFLDI               MD055681
     C                   ENDIF                                                              MD055681
     C                   else                                                               MD055681
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + WHFLDI                 MD055681
     C                   eval      PSELECT = %trimr(PSELECT) + ', ' + '''B'''               MD055681
     C                   Endif                                                              MD055681
      *                                                                                     MD055681
     C/exec SQL                                                                             MD055681
     C+ fetch next                                                                          MD055681
     C+ from GetFieldsC                                                                     MD055681
     C+ into :FldData                                                                       MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C                   ENDDO                                                              MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ close GetFieldsC                                                                    MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
                                                                                            MD055681
     C                   eval      SQLDynStmt = 'insert into ' + EXTINDEX +                 MD055681
     C                             ' (select ' +                                            MD055681
     C                             %trimr(PSELECT) + ' from ' +                             MD055681
     C                             BINDEX  +                                                MD055681
     C                             ' A where not exists (select * from ' +                  MD055681
     C                             EXTINDEX +  ' B ' + %trimr(WHERE) + '))'                 MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ prepare DynSQLStmnt                                                                 MD055681
     C+ from :SQLDynStmt                                                                    MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ execute DynSQLStmnt                                                                 MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C                   If        SQLCode <> 0                                             MD055681
     C                             and SQLCode <> 100                                       MD055681
     C                   eval      ERROR = '*Error'                                         MD055681
     C                   Endif                                                              MD055681
                                                                                            MD055681
      * finally update XTD record ENABLD field for the ones disabled                        MD055681
     C                   eval      SQLDynStmt = 'update ' + EXTINDEX +                      MD055681
     C                             ' x set ENABLD = ' + '''' + 'D' + '''' +                 MD055681
     C                             ' where exists (select * from ' +                        MD055681
     C****                         %trimr(LibMov) + '/SCSAREPD e where e.SARN' +            MD055681
     C                             'SCSAREPD e where e.SARN' +                              MD055681
     C                             ' = x.SARN)'                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ prepare DynSQLStmnt                                                                 MD055681
     C+ from :SQLDynStmt                                                                    MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ execute DynSQLStmnt                                                                 MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C                   If        SQLCode <> 0                                             MD055681
     C                             and SQLCode <> 100                                       MD055681
     C                   eval      ERROR = '*Error'                                         MD055681
     C                   Endif                                                              MD055681
                                                                                            MD055681
     C                   ENDSR                                                              MD055681
                                                                                            MD055681
      /EJECT                                                                                MD055681
      *****************************************************************                     MD055681
                                                                                            MD055681
      * SR_GPSARDPD - Update new fields introduced in BTD and add                           MD055681
      *               corresponding records in XTD                                          MD055681
      *               also remove BTD records already in CTD                                MD055681
                                                                                            MD055681
      *****************************************************************                     MD055681
     C     SR_GPSARDPD   BEGSR                                                              MD055681
                                                                                            MD055681
                                                                                            MD055681
      * first remove BTD records if found in CTD (CTD only contains features not to         MD055681
      * be switched off)                                                                    MD055681
     C/EXEC SQL                                                                             MD055681
     C+ delete GPSRDBTD b                                                                   MD055681
     C+   where exists (select * from GPSRDCTD c where c.SARN = b.SARN)                     MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C                   If        SQLCode <> 0                                             MD055681
     C                             and SQLCode <> 100                                       MD055681
     C                   eval      ERROR = '*Error'                                         MD055681
     C                   Endif                                                              MD055681
                                                                                            MD055681
      * update BTD records set field MODE to 'B' for all and ENABLD to 'E' for all first    MD055681
      * [for the disabled ones (from SCSAREPD), XTD records will be updated later]          MD055681
     C/EXEC SQL                                                                             MD055681
     C+ update GPSRDBTD set MODE = 'B', ENABLD = 'E'                                        MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C                   If        SQLCode <> 0                                             MD055681
     C                             and SQLCode <> 100                                       MD055681
     C                   eval      ERROR = '*Error'                                         MD055681
     C                   Endif                                                              MD055681
                                                                                            MD055681
                                                                                            MD055681
      * insert XTD records for the BTD records added                                        MD055681
     C                   eval      First = 'Y'                                              MD055681
     C                   eval      PINSERT = *BLANKS                                        MD055681
     C                   eval      PSELECT = *BLANKS                                        MD055681
     C                                                                                      MD055681
     C                   eval      KMSCHEMA = %SUBST(XSCHEMA:1:3) + 'MLIB'                  MD055681
     C                   eval      EXTINDEX = %SUBST(XINDEX:1:5) + 'XTD'                    MD055681
     C                   eval      BINDEX = %SUBST(XINDEX:1:5) + 'BTD'                      MD055681
      ** Call program to produce file field description outfile of  file.                   MD055681
     C                   EVAL      OutFile = 'UDFOLD'                                       MD055681
     C                   EXSR      BldOutFile                                               MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ declare GetFieldsG cursor for                                                       MD055681
     C+ select *                                                                            MD055681
     C+ from UDFOLD                                                                         MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ open GetFieldsG                                                                     MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ fetch next                                                                          MD055681
     C+ from GetFieldsG                                                                     MD055681
     C+ into :FldData                                                                       MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C                   DOW       SQLCODE = 0                                              MD055681
                                                                                            MD055681
     C                   IF        %SUBST(WHFLDI:3:4) <> 'MODE'                             MD055681
     C                   IF        First = 'Y'                                              MD055681
      ** Get until the fieldadd to the end of the table.                                    MD055681
     C                   eval      PINSERT = %trimr(PINSERT) + WHFLDI                       MD055681
     C                   eval      PSELECT = %trimr(PSELECT) + 'A.' + WHFLDI                MD055681
     C                   eval      First = 'N'                                              MD055681
     C                   ELSE                                                               MD055681
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + WHFLDI                 MD055681
     C                   eval      PSELECT = %trimr(PSELECT) + ',A.' + WHFLDI               MD055681
     C                   ENDIF                                                              MD055681
     C                   else                                                               MD055681
     C                   eval      PINSERT = %trimr(PINSERT) + ',' + WHFLDI                 MD055681
     C                   eval      PSELECT = %trimr(PSELECT) + ', ' + '''B'''               MD055681
     C                   Endif                                                              MD055681
      *                                                                                     MD055681
     C/exec SQL                                                                             MD055681
     C+ fetch next                                                                          MD055681
     C+ from GetFieldsG                                                                     MD055681
     C+ into :FldData                                                                       MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C                   ENDDO                                                              MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ close GetFieldsG                                                                    MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
                                                                                            MD055681
     C                   eval      SQLDynStmt = 'insert into ' + EXTINDEX +                 MD055681
     C                             ' (select ' +                                            MD055681
     C                             %trimr(PSELECT) + ' from ' +                             MD055681
     C                             BINDEX  +                                                MD055681
     C                             ' A where not exists (select * from ' +                  MD055681
     C                             EXTINDEX +  ' B ' + %trimr(WHERE) + '))'                 MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ prepare DynSQLStmnt                                                                 MD055681
     C+ from :SQLDynStmt                                                                    MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ execute DynSQLStmnt                                                                 MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C                   If        SQLCode <> 0                                             MD055681
     C                             and SQLCode <> 100                                       MD055681
     C                   eval      ERROR = '*Error'                                         MD055681
     C                   Endif                                                              MD055681
                                                                                            MD055681
      * finally update XTD record ENABLD field for the ones disabled                        MD055681
     C                   eval      SQLDynStmt = 'update ' + EXTINDEX +                      MD055681
     C                             ' x set ENABLD = ' + '''' + 'D' + '''' +                 MD055681
     C                             ' where exists (select * from ' +                        MD055681
     C****                         %trimr(LibMov) + '/GPSAREPD e where e.SARN' +            MD055681
     C                             'GPSAREPD e where e.SARN' +                              MD055681
     C                             ' = x.SARN)'                                             MD055681
                                                                                            MD055681
     C/EXEC SQL                                                                             MD055681
     C+ prepare DynSQLStmnt                                                                 MD055681
     C+ from :SQLDynStmt                                                                    MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ execute DynSQLStmnt                                                                 MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C                   If        SQLCode <> 0                                             MD055681
     C                             and SQLCode <> 100                                       MD055681
     C                   eval      ERROR = '*Error'                                         MD055681
     C                   Endif                                                              MD055681
                                                                                            MD055681
     C                   ENDSR                                                              MD055681
                                                                                            MD055681
      /EJECT                                                                                MD055681
      *****************************************************************                     MD055681
