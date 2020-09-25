     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Deliverable Data Split Migration Take on')    *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000710 - This program update Extension file and Bespoke    *
      *             file based on old file during migration.          *
      *                                                               *
      *  (c) Finastra International 2020                              *
      *                                                               *
      *  Last Amend No. MD055681             Date 31Jul20             *
      *  Prev Amend No. MD056103   *CREATE   Date 17Jun20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD056103 - Deliverable Data Split migration                  *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D SCHEMAM         S             10A
     D SCHEMAV         S             10A
     D INDEX           S             10A
     D TABLEB          S             10A
     D TABLEX          S             10A
     D OLDFILE_S       S             10A                                                    MD055681
     D OSCHEMA_S       S             10A                                                    MD055681
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
     C                   PARM                    DDSFILE          10
     C                   PARM                    OLDFILE          10
     C                   PARM                    SCHEMAT          10
     C                   PARM                    OSCHEMA          10
     C                   PARM                    ERROR            10

      * Set variables
     C                   exsr      SR_SetVar

      * Retrieve key fields
     C                   exsr      SR_RtvKeys

      * 1. syncrhonize XTD file based on CTD
     C                   exsr      SR_Synch1

      * 2. add Bespoke record from the old file if not found in CTD
     C                   exsr      SR_AddBTD

      * 3. syncrhonize XTD file based on BTD
      ** If records were added in Bespoke, records must be added in Extension file too
     C                   If        TotRow > 0
     C                   exsr      SR_Synch2
     C                   ENDIF

      * Special process for GPSAREPD and SCSAREPD                                           MD055681
     C                   If        DDSFILE = 'SCSRDCTD' or DDSFILE = 'GPSRDCTD'             MD055681
     C                   exsr      SR_SAREPD                                                MD055681
     C                   If        TotRow > 0                                               MD055681
     C                   exsr      SR_Synch2                                                MD055681
     C                   ENDIF                                                              MD055681
     C                   ENDIF                                                              MD055681
                                                                                            MD055681
      * 4. Update Extension file with content of 'old file'
     C                   exsr      SR_UpdExt

     C                   Seton                                        LR
     C                   Return
      /EJECT
      *****************************************************************

      * SR_SetVar - Set Variables

      *****************************************************************
     C     SR_SetVar     BEGSR

     C                   eval      INDEX = %SUBST(DDSFILE:1:5) + 'JI0'
     C                   eval      TABLEB = %SUBST(DDSFILE:1:5) + 'BTD'
     C                   eval      TABLEX = %SUBST(DDSFILE:1:5) + 'XTD'
     C                   eval      SCHEMAV = %SUBST(SCHEMAT:1:3) + 'VLIB'
     C                   eval      SCHEMAM = %SUBST(SCHEMAT:1:3) + 'MLIB'

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************

      * SR_RtvKeys - Retrieve key fields from IJ0 index

      *****************************************************************
     C     SR_RtvKeys    BEGSR

      * Retrieve key fields
     C/EXEC SQL
     C+ declare KKCursor insensitive scroll cursor for
     C+ select SYSTEM_COLUMN_NAME, ORDINAL_POSITION from QSYS2/SYSKEYS
     C+ where INDEX_NAME = :INDEX and INDEX_SCHEMA = :SCHEMAV
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

      ** build WHEREK clause
     C                   eval      WIdx = 1
     C                   eval      WHEREK = *BLANKS
     C                   eval      WHEREK = ' WHERE A.' + %trimr(KeyArr(WIdx)) +
     C                             ' = B.' + %trimr(KeyArr(WIdx))
     C                   eval      WIdx = WIdx + 1

     C     KeyArr(WIdx)  DOWNE     *BLANKS
     C     WIdx          ANDLT     13
     C                   eval      WHEREK = %trimr(WHEREK) + ' and A.' +
     C                             %trimr(KeyArr(WIdx)) +
     C                             ' = B.' + %trimr(KeyArr(WIdx))
     C                   eval      WIdx = WIdx + 1
     C                   ENDDO
     C                   ENDSR

      /EJECT
      *****************************************************************
      *****************************************************************

      * SR_Synch1 - (a) Add records in XTD if found in CTD but not in XTD
      *             and
      *             (b) Delete records in XTD if not found in CTD

      *****************************************************************
     C     SR_Synch1     BEGSR

      * (a) Add records in XTD if found in CTD but not in XTD

     C                   eval      First = 'Y'
      ** Call program to produce file field description outfile of file.
     C                   EVAL      OutFile = 'UDFOLD'
     C                   EVAL      O_File = TABLEX
     C                   EVAL      O_Lib = SCHEMAM
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
     C+ into :X_Field
     C/end-exec
      *
     C                   eval      PSELECTX = *BLANKS

     C                   DOW       SQLCODE = 0

     C                   IF        First = 'Y'
     C                   eval      PSELECTX = %trimr(PSELECTX) + 'A.' + X_Field
     C                   eval      First = 'N'
     C                   ELSE
     C                   eval      PSELECTX = %trimr(PSELECTX) + ',A.' + X_Field
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFields
     C+ into :X_Field
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close GetFields
     C/end-exec

     C                   eval      SQLDynStmt = 'insert into ' +
     C                             %trimr(SCHEMAM) + '/' + TABLEX +
     C                             ' (select ' +
     C                             %trimr(PSELECTX) + ' from ' +
     C                             %trimr(SCHEMAT) + '/' + DDSFILE  +
     C                             ' A where not exists (select * from ' +
     C                             %trimr(SCHEMAM) + '/' + TABLEX +
     C                             ' B ' + %trimr(WHEREK) + '))'

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
     C                   Return
     C                   Endif


      * (b) Delete records in XTD if not found in CTD


     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = 'delete from ' +
     C                             %trimr(SCHEMAM) + '/' + TABLEX +
     C                             ' A where not exists (select * from ' +
     C                             %trimr(SCHEMAT) + '/' + DDSFILE +
     C                             ' B ' +  %trimr(WHEREK) + ')'

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
     C                   Return
     C                   Endif

     C                   ENDSR

      /EJECT
      *****************************************************************

      * SR_AddBTD - Add Bespoke records from old file

      *****************************************************************
     C     SR_AddBTD     BEGSR


      * for SCSARSPD migration, all core features are delivered in SCSRSCTD                 MD055681
      * what is non core is the old SCSARZPD, these are the ones to be added in BTD         MD055681
      * set OLDFILE to SCSARZPD                                                             MD055681
     C                   eval      OLDFILE_S = OLDFILE                                      MD055681
     C                   eval      OSCHEMA_S = OSCHEMA                                      MD055681
     C                   if        DDSFILE = 'SCSRSCTD'                                     MD055681
     C                   eval      OLDFILE = 'SCSARZPD'                                     MD055681
     C                   eval      OSCHEMA = %SUBST(OSCHEMA:1:2) + 'DMLIB'                  MD055681
     C                   endif                                                              MD055681
                                                                                            MD055681
     C                   eval      TotRow = 0
     C                   eval      First = 'Y'
     C                   eval      PINSERT = *BLANKS
     C                   eval      PSELECT = *BLANKS
      ** Call program to produce file field description outfile of  file.
     C                   EVAL      OutFile = 'UDFOLD'
     C                   EVAL      O_File = TABLEB
     C                   EVAL      O_Lib = SCHEMAM
     C                   EXSR      BldOutFile

     C/exec SQL
     C+ declare GetFieldsB cursor for
     C+ select WHFLDI
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
     C+ into :X_Field
     C/end-exec

     C                   eval      PINSERTB = *BLANKS
     C                   eval      PSELECTB = *BLANKS

     C                   DOW       SQLCODE = 0

     C                   IF        %SUBST(X_Field:3:4) <> 'MODE'
     C                             and %SUBST(X_Field:1:4) <> 'MODE'                        MD055681
     C                   IF        First = 'Y'
      ** Get until the fieldadd to the end of the table.
     C                   eval      PINSERTB = %trimr(PINSERTB) + X_Field
     C                   eval      PSELECTB = %trimr(PSELECTB) + 'A.' + X_Field
     C                   eval      First = 'N'
     C                   ELSE
     C                   IF        X_Field = 'AXPROT'                                       MD055681
     C                   eval      PINSERTB = %trimr(PINSERTB) + ',' + X_Field              MD055681
     C                   eval      PSELECTB = %trimr(PSELECTB) + ', ' + '''Y'''             MD055681
     C                   else                                                               MD055681
      * for ENABLD field                                                                    MD055681
     C                   IF        X_Field = 'ENABLD'                                       MD055681
     C                   eval      PINSERTB = %trimr(PINSERTB) + ',' + X_Field              MD055681
     C                   eval      PSELECTB = %trimr(PSELECTB) + ', ' + '''E'''             MD055681
     C                   else                                                               MD055681
     C                   eval      PINSERTB = %trimr(PINSERTB) + ',' + X_Field
     C                   eval      PSELECTB = %trimr(PSELECTB) + ',A.' + X_Field
     C                   ENDIF                                                              MD055681
     C                   ENDIF                                                              MD055681
     C                   ENDIF
     C                   else
     C                   eval      PINSERTB = %trimr(PINSERTB) + ',' + X_Field
     C                   eval      PSELECTB = %trimr(PSELECTB) + ', ' + '''B'''
     C                   Endif
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFieldsB
     C+ into :X_Field
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close GetFieldsB
     C/end-exec

     C                   eval      SQLDynStmt = *Blanks
     C                   eval      SQLDynStmt = 'insert into ' +
     C                             %trimr(SCHEMAM) + '/' + TABLEB +
     C                             ' (select ' +
     C                             %trimr(PSELECTB) + ' from ' +
     C                             %trimr(OSCHEMA) + '/' + OLDFILE +
     C                             ' A where not exists (select * from ' +
     C                             %trimr(SCHEMAT) + '/' + DDSFILE +
     C                             ' B ' + %trimr(WHEREK) + '))'

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
     C                   Return
     C                   Endif


     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************

      * SR_Synch2 - Syncrhonize XTD file based on BTD

      *****************************************************************
     C     SR_Synch2     BEGSR

     C                   eval      First = 'Y'


     C                   eval      SQLDynStmt = *Blanks
     C                   eval      SQLDynStmt = 'insert into ' +
     C                             %trimr(SCHEMAM) + '/' + TABLEX +
     C                             ' (select ' +
     C                             %trimr(PSELECTX) + ' from ' +
     C                             %trimr(SCHEMAM) + '/' + TABLEB  +
     C                             ' A where not exists (select * from ' +
     C                             %trimr(SCHEMAM) + '/' + TABLEX +
     C                             ' B ' + %trimr(WHEREK) + '))'

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
     C                   Return
     C                   Endif

     C                   ENDSR

      *****************************************************************
      *****************************************************************

      * SR_UpdExt - Upd records in Extension file if found in old file

      *****************************************************************
     C     SR_UpdExt     BEGSR

     C                   eval      First = 'Y'
     C                   eval      PINSERTX = *Blanks
     C                   eval      PSELECTX = *Blanks

      ** Call program to produce file field description outfile of extension file
     C                   EVAL      OutFile = 'UDFOLD'
     C                   EVAL      O_File = TABLEX
     C                   EVAL      O_Lib = SCHEMAM
     C                   EXSR      BldOutFile

     C/exec SQL
     C+ declare GetFieldsY cursor for
     C+ select WHFLDI
     C+ from UDFOLD
     C/end-exec
      *
     C/exec SQL
     C+ open GetFieldsY
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from GetFieldsY
     C+ into :X_Field
     C/end-exec
      *
     C                   DOW       SQLCODE = 0

      ** Ignore if field is part of key fields
     C     X_Field       SCAN      KeyFld                                 99
     C                   IF        *IN99  = '0'
     C                             and %SUBST(X_Field:3:4) <> 'MODE'
     C                             and %SUBST(X_Field:1:4) <> 'MODE'                        MD055681
     C                             and X_Field <> 'ENABLD'                                  MD055681
     C                   IF        First = 'Y'
     C                   eval      PINSERTX = %trimr(PINSERTX) + 'B.' + X_Field
     C                   eval      PSELECTX = %trimr(PSELECTX) + 'A.' + X_Field
     C                   eval      First = 'N'
     C                   ELSE
     C                   eval      PINSERTX = %trimr(PINSERTX) + ',B.' + X_Field
     C                   eval      PSELECTX = %trimr(PSELECTX) + ',A.' + X_Field
     C                   ENDIF
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from GetFieldsY
     C+ into :X_Field
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close GetFieldsY
     C/end-exec


      ** Update XTD file only if there is at least one field to update
     C                   If        PINSERTX <> *blanks
     C                   eval      SQLDynStmt = 'update ' +
     C                             %trimr(SCHEMAM) + '/' + TABLEX +
     C                             ' B set (' + %trimr(PINSERTX) +
     C                             ') = (select ' + %trimr(PSELECTX) +
     C                             ' from ' +  %trimr(OSCHEMA) + '/' +
     C                             OLDFILE + ' A ' + %trimr(WHEREK) +
     C                             ') where  exists (select * from ' +
     C                             %trimr(OSCHEMA) + '/' + OLDFILE +
     C                             ' A ' + %trimr(WHEREK) + ')'

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
     C                   Return
     C                   Endif
     C                   Endif

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *    Retrieve fields list                                       *
      *                                                               *
      *****************************************************************
      *
     C     BldOutFile    BEGSR
      *
     C                   CALL      'UTC000004'
     C                   PARM                    O_File
     C                   PARM                    O_Lib
     C                   PARM                    OutFile
     C                   PARM      '*FIRST'      OFMbr
     C                   PARM      '*REPLACE'    OFMbrOpt
     C
      *
     C     BldOutFileE   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                     MD055681
                                                                                            MD055681
      * SR_SAREPD - Special process to migrate disabled features                            MD055681
                                                                                            MD055681
      *****************************************************************                     MD055681
     C     SR_SAREPD     BEGSR                                                              MD055681
                                                                                            MD055681
                                                                                            MD055681
     C                   eval      OLDFILE_S = OLDFILE                                      MD055681
     C                   eval      OSCHEMA_S = OSCHEMA                                      MD055681
     C                   if        DDSFILE = 'SCSRDCTD'                                     MD055681
     C                   eval      OLDFILE = 'SCSAREPD'                                     MD055681
     C                   eval      OSCHEMA = %SUBST(OSCHEMA:1:2) + 'DMLIB'                  MD055681
     C                   endif                                                              MD055681
     C                   if        DDSFILE = 'GPSRDCTD'                                     MD055681
     C                   eval      OLDFILE = 'GPSAREPD'                                     MD055681
     C                   eval      OSCHEMA = %SUBST(OSCHEMA:1:2) + 'GMLIB'                  MD055681
     C                   endif                                                              MD055681
                                                                                            MD055681
     C                   eval      TotRow = 0                                               MD055681
     C                   eval      First = 'Y'                                              MD055681
     C                   eval      PINSERT = *BLANKS                                        MD055681
     C                   eval      PSELECT = *BLANKS                                        MD055681
      ** Call program to produce file field description outfile of  file.                   MD055681
     C                   EVAL      OutFile = 'UDFOLD'                                       MD055681
     C                   EVAL      O_File = TABLEB                                          MD055681
     C                   EVAL      O_Lib = SCHEMAM                                          MD055681
     C                   EXSR      BldOutFile                                               MD055681
                                                                                            MD055681
     C/exec SQL                                                                             MD055681
     C+ declare GetFieldsE cursor for                                                       MD055681
     C+ select WHFLDI                                                                       MD055681
     C+ from UDFOLD                                                                         MD055681
     C/end-exec                                                                             MD055681
      *                                                                                     MD055681
     C/exec SQL                                                                             MD055681
     C+ open GetFieldsE                                                                     MD055681
     C/end-exec                                                                             MD055681
      *                                                                                     MD055681
     C/exec SQL                                                                             MD055681
     C+ fetch next                                                                          MD055681
     C+ from GetFieldsE                                                                     MD055681
     C+ into :X_Field                                                                       MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C                   eval      PINSERTB = *BLANKS                                       MD055681
     C                   eval      PSELECTB = *BLANKS                                       MD055681
                                                                                            MD055681
     C                   DOW       SQLCODE = 0                                              MD055681
                                                                                            MD055681
     C                   IF        %SUBST(X_Field:3:4) <> 'MODE'                            MD055681
     C                             and %SUBST(X_Field:1:4) <> 'MODE'                        MD055681
     C                   IF        First = 'Y'                                              MD055681
      ** Get until the fieldadd to the end of the table.                                    MD055681
     C                   eval      PINSERTB = %trimr(PINSERTB) + X_Field                    MD055681
     C                   eval      PSELECTB = %trimr(PSELECTB) + 'A.' + X_Field             MD055681
     C                   eval      First = 'N'                                              MD055681
     C                   ELSE                                                               MD055681
     C                   IF        X_Field = 'AXPROT'                                       MD055681
     C                   eval      PINSERTB = %trimr(PINSERTB) + ',' + X_Field              MD055681
     C                   eval      PSELECTB = %trimr(PSELECTB) + ', ' + '''Y'''             MD055681
     C                   else                                                               MD055681
      * for ENABLD field, those will be disabled                                            MD055681
     C                   IF        X_Field = 'ENABLD'                                       MD055681
     C                   eval      PINSERTB = %trimr(PINSERTB) + ',' + X_Field              MD055681
     C                   eval      PSELECTB = %trimr(PSELECTB) + ', ' + '''D'''             MD055681
     C                   else                                                               MD055681
     C                   eval      PINSERTB = %trimr(PINSERTB) + ',' + X_Field              MD055681
     C                   eval      PSELECTB = %trimr(PSELECTB) + ',A.' + X_Field            MD055681
     C                   ENDIF                                                              MD055681
     C                   ENDIF                                                              MD055681
     C                   ENDIF                                                              MD055681
     C                   else                                                               MD055681
     C                   eval      PINSERTB = %trimr(PINSERTB) + ',' + X_Field              MD055681
     C                   eval      PSELECTB = %trimr(PSELECTB) + ', ' + '''B'''             MD055681
     C                   Endif                                                              MD055681
      *                                                                                     MD055681
     C/exec SQL                                                                             MD055681
     C+ fetch next                                                                          MD055681
     C+ from GetFieldsE                                                                     MD055681
     C+ into :X_Field                                                                       MD055681
     C/end-exec                                                                             MD055681
      *                                                                                     MD055681
     C                   ENDDO                                                              MD055681
      *                                                                                     MD055681
     C/exec SQL                                                                             MD055681
     C+ close GetFieldsE                                                                    MD055681
     C/end-exec                                                                             MD055681
                                                                                            MD055681
     C                   eval      SQLDynStmt = *Blanks                                     MD055681
     C                   eval      SQLDynStmt = 'insert into ' +                            MD055681
     C                             %trimr(SCHEMAM) + '/' + TABLEB +                         MD055681
     C                             ' (select ' +                                            MD055681
     C                             %trimr(PSELECTB) + ' from ' +                            MD055681
     C                             %trimr(OSCHEMA) + '/' + OLDFILE +                        MD055681
     C                             ' A where not exists (select * from ' +                  MD055681
     C                             %trimr(SCHEMAT) + '/' + DDSFILE +                        MD055681
     C                             ' B ' + %trimr(WHEREK) + '))'                            MD055681
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
     C/EXEC SQL                                                                             MD055681
     C+ get diagnostics :TotRow  = ROW_COUNT                                                MD055681
     C/END-EXEC                                                                             MD055681
                                                                                            MD055681
     C                   If        SQLCode <> 0                                             MD055681
     C                             and SQLCode <> 100                                       MD055681
     C                   eval      ERROR = '*Error'                                         MD055681
     C                   Return                                                             MD055681
     C                   Endif                                                              MD055681
                                                                                            MD055681
     C                   eval      OLDFILE = OLDFILE_S                                      MD055681
     C                   eval      OSCHEMA = OSCHEMA_S                                      MD055681
                                                                                            MD055681
     C                   ENDSR                                                              MD055681
                                                                                            MD055681
      *****************************************************************                     MD055681
