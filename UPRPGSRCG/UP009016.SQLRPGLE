     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Populate extension file')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP009016 - Populate extension file                           *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. CUP040  *CREATE    Date 28Feb13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP040 - New deliverable data methodology.                   *
      *                                                               *
      *****************************************************************
      *
     D FieldData       DS
     D   Field                 1     10
     D   Key                  11     11
      *
     D FieldDataArr    DS                  DIM(999)
     D                                     LIKEDS(FieldData)
      *
     D PMainFile       S             10
     D ExtFile         S             10
     D UnionFile       S             10
     D KeyCount        S              3  0 INZ(1)
     D FieldCount      S              3  0 INZ(0)
     D LoopCount       S              3  0 INZ(0)
     D SQLString       S           5000
     D Value           S             12
     D Recursive       S              1
     D x               S              3  0 INZ(1)
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMainFile
      *
      * Build file names from the main Core file.
     C                   EVAL      ExtFile = %SUBST(PMainFile:1:5) + 'XTD'
     C                   EVAL      UnionFile = %SUBST(PMainFile:1:5) + 'UW0'
      *
     C                   EXSR      BuildArray
     C                   EXSR      WriteRecs
     C                   EXSR      DeleteRecs
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * BuildArray - Fill array with data about extension file fields *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls: FetchRec                                               *
      *                                                               *
      *****************************************************************
      *
     C     BuildArray    BEGSR
      *
     C/exec SQL
     C+ declare ActionFile cursor for
     C+ select
     C+   AFFDNM
     C+ , AFKEYF
     C+ from UPAFFDPD
     C+ where
     C+     AFFILE = :PMainFile
     C+ and
     C+ (
     C+     AFKEYF = 'Y'
     C+ or  AFKEYF = 'X'
     C+ )
     C+ order by
     C+   AFKEYF desc
     C/end-exec
      *
     C/exec SQL
     C+ open ActionFile
     C/end-exec
      *
     C                   EXSR      FetchRec
      *
     C                   DOW       SQLCODE = 0
      * Populate array.
     C                   EVAL      FieldDataArr(x) = FieldData
     C                   EVAL      x = x + 1
      *
     C                   EXSR      FetchRec
      *
     C                   ENDDO
      * Store the number of fields.
     C                   EVAL      FieldCount = x - 1
      *
     C/exec SQL
     C+ close ActionFile
     C/end-exec
      *
     C     BuildArrayE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * FetchRec - Fetch next record.                                 *
      *                                                               *
      * Called by: BuildArray                                         *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     FetchRec      BEGSR
      *
     C/exec SQL
     C+ fetch next
     C+ from ActionFile
     C+ into
     C+   :Field
     C+ , :Key
     C/end-exec
      *
     C     FetchRecE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * WriteRecs - Write records to extension file if they don't     *
      *             already exist.                                    *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls: InsertFields                                           *
      *                                                               *
      *****************************************************************
      *
     C     WriteRecs     BEGSR
      *
      * Start to build insert string; the syntax will follow this -
      *  insert into <table> <values> where <key> exists in main file but not
      *   in extension file.
     C                   CLEAR                   SQLString
      * Fields to be inserted.
     C                   EVAL      SQLString = 'insert into ' +
     C                             ExtFile + '('
     C                   EVAL      x = 1
     C                   EXSR      InsertFields
     C                   EVAL      SQLString = %TRIMR(SQLString) + ')'
      * Values to be inserted.
     C                   EVAL      SQLString = %TRIMR(SQLString) + ' select '
     C                   EVAL      x = 1
     C                   EXSR      InsertValues
      * Key selection.
     C                   EVAL      SQLString = %TRIMR(SQLString) +
     C                             ' from ' +
     C                             %TRIMR(UnionFile) +
     C                             ' u where not exists (select * from ' +
     C                             %TRIMR(ExtFile) +
     C                             ' x where'
     C                   EVAL      x = 1
     C                   EXSR      KeySelection
     C                   EVAL      SQLString = %TRIMR(SQLString) + ')'
      * Perform insertion of records.
     C/exec SQL
     C+ execute immediate :SQLString
     C/end-exec
      *
     C     WriteRecsE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * DeleteRecs - Delete records from extension file if they don't *
      *              have a record on the main file.                  *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     DeleteRecs    BEGSR
      *
      * Start to build insert string; the syntax will follow this -
      *  delete from <table> <values> where <key> exists in extension file
      *   but not in main file.
     C                   CLEAR                   SQLString
     C                   EVAL      SQLString = 'delete from ' +
     C                             %TRIMR(ExtFile) +
     C                             ' x where not exists (select * from ' +
     C                             %TRIMR(UnionFile) +
     C                             ' u where'
      * Key selection.
     C                   EVAL      x = 1
     C                   EVAL      KeyCount = 1
     C                   EXSR      KeySelection
     C                   EVAL      SQLString = %TRIMR(SQLString) + ')'
      * Perform deletion of records.
     C/exec SQL
     C+ execute immediate :SQLString
     C/end-exec
      *
     C     DeleteRecsE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * InsertFields - Build string of fields.                        *
      *                                                               *
      * Called by: WriteRecs                                          *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     InsertFields  BEGSR
      *
      * Loop through array to enter fields to be populated.
     C                   DO        FieldCount
     C                   EVAL      FieldData = FieldDataArr(x)
     C                   IF        x <> 1
     C                   EVAL      SQLString = %TRIMR(SQLString) + ',' + Field
     C                   ELSE
     C                   EVAL      SQLString = %TRIMR(SQLString) + Field
     C                   ENDIF
     C                   EVAL      x = x + 1
     C                   ENDDO
      *
     C     InsertFieldsE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * InsertValues - Build string of values.                        *
      *                                                               *
      * Called by: WriteRecs                                          *
      *                                                               *
      * Calls: *none                                                  *
      *                                                               *
      *****************************************************************
      *
     C     InsertValues  BEGSR
      *
      * Loop through array to enter fields to be populated.
     C                   DO        FieldCount
     C                   EVAL      Field = FieldDataArr(x)
      * Take the value from the union view field.
     C                   EVAL      Value = 'u.' + Field
     C                   IF        x <> 1
     C                   EVAL      SQLString = %TRIMR(SQLString) + ',' + Value
     C                   ELSE
     C                   EVAL      SQLString = %TRIMR(SQLString) + ' ' + Value
     C                   ENDIF
     C                   EVAL      x = x + 1
     C                   ENDDO
      *
     C     InsertValuesE ENDSR
      *
      *****************************************************************
      *                                                               *
      * KeySelection - Join between main and extension files to       *
      *                determine records that need to be added.       *
      *                                                               *
      * Called by: WriteRecs                                          *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     KeySelection  BEGSR
      *
      * Loop through array to enter fields to be populated.
     C                   DO        FieldCount
     C                   EVAL      FieldData = FieldDataArr(x)
      * Only process key fields.
     C                   IF        Key = 'Y'
     C                   IF        KeyCount <> 1
     C                   EVAL      SQLString = %TRIMR(SQLString) + ' and ' +
     C                             'u.' + %TRIMR(Field) +
     C                             ' = x.' + Field
     C                   ELSE
     C                   EVAL      SQLString = %TRIMR(SQLString) +
     C                             ' u.' + %TRIMR(Field) +
     C                             ' = x.' + Field
     C                   EVAL      KeyCount = KeyCount + 1
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      x = x + 1
     C                   ENDDO
      *
     C     KeySelectionE ENDSR
      *
      /EJECT
      ********************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     Recursive     IFEQ      *BLANKS
     C                   MOVE      'Y'           Recursive
     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
      *
     C     PSSRE         ENDSR
      *****************************************************************
