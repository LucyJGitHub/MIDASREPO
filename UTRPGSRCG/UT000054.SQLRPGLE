     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Compare file without key')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UT000054 - Compare file without key                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD021155 *CREATE   Date 13May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021155 - COB Restructure Phase 1 remnants                  *
      *           - Compare file without key                          *
      *                                                               *
      *****************************************************************
      *
     D PFile1          S             10
     D PLib1           S             10
     D PFile2          S             10
     D PLib2           S             10
      *
     D NewFile         S             10
     D LikeFile        S             10
     D LikeFileLib     S             10
     D TempFile        S             10
     D FromFile        S             10
     D FromLib         S             10
     D Field           S             10
     D FieldType       S              1
     D FieldLen        S              3  0
     D FieldSeq        S              4  0
     D FieldDig        S              4  0
     D RcdLen          S              5  0
     D RcdLenA         S              5
     D SQLString       S           5000
     D FieldList1      S           2000
     D FieldList2      S           2000
     D Recursive       S              1
     D x               S              3  0
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFile1
     C                   PARM                    PLib1
     C                   PARM                    PFile2
     C                   PARM                    PLib2
      *
     C                   EVAL      NewFile = 'UT0000541'
     C                   EVAL      LikeFile = PFile2
     C                   EVAL      LikeFileLib = PLib2
      *
      * Read through the file layout on UTFLDDPD to retrieve field names and
      *  drop any that have been deslected.
     C                   CLEAR                   FieldList1
     C                   CLEAR                   FieldList2
     C                   EXSR      GetFields
      *
      * Create file based on PFile2.
     C                   EXSR      CreateTable
      *
      * Create second file based on the first created file.
     C                   EVAL      NewFile = 'UT0000542'
     C                   EVAL      LikeFile = 'UT0000541'
     C                   EVAL      LikeFileLib = 'QTEMP'
     C                   EXSR      CrtLikeFile
      *
      * Insert data into first file.
     C                   EVAL      TempFile = 'UT0000541'
     C                   EVAL      FromFile = PFile1
     C                   EVAL      FromLib = PLib1
     C                   EXSR      InsertRecs
      *
      * Insert data into second file.
     C                   EVAL      TempFile = 'UT0000542'
     C                   EVAL      FromFile = PFile2
     C                   EVAL      FromLib = PLib2
     C                   EXSR      InsertRecs
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ExecuteSQL - Execute SQL statement                            *
      *                                                               *
      * Called by: *multi                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     ExecuteSQL    BEGSR
      *
     C/exec SQL
     C+ execute immediate :SQLString
     C/end-exec
      *
     C     ExecuteSQLE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * InsertRecs - Insert records into temporary file               *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     InsertRecs    BEGSR
      *
      * Start to build SQL script
     C                   CLEAR                   SQLString
     C                   EVAL      SQLString = 'insert into QTEMP/' +
     C                             TempFile + ' select ' + FieldList1
     C                   EVAL      SQLString = %TRIMR(SQLString) +
     C                             ',count(*) from ' + FromLib + '/' +
     C                             FromFile + ' group by '+ FieldList2
     C                   EXSR      ExecuteSQL
      *
     C     InsertRecsE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * CrtLikeFile - Create file based on another                    *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls: ExecuteSQL                                             *
      *                                                               *
      *****************************************************************
      *
     C     CrtLikeFile   BEGSR
      *
     C                   CLEAR                   SQLString
     C                   EVAL      SQLString = 'create table QTEMP/' +
     C                             NewFile + 'like ' + LikeFileLib + '/' +
     C                             LikeFile
     C                   EXSR      ExecuteSQL
      *
     C     CrtLikeFileE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * GetFields - Retrieve field names                              *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls: ExecuteSQL                                             *
      *                                                               *
      *****************************************************************
      *
     C     GetFields     BEGSR
      *
     C                   EVAL      x = 1
     C                   EVAL      RcdLen = 0
      *
     C/exec SQL
     C+ declare FLDDcursor cursor for
     C+ select
     C+   FDRPGN
     C+ , FDTYPE
     C+ , FDLENG
     C+ , FDDIGI
     C+ , FDSEQN
     C+ from UTFLDDPD
     C+ where
     C+     FDFILE = :LikeFile
     C/end-exec
      *
     C/exec SQL
     C+ open FLDDcursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from FLDDcursor
     C+ into
     C+   :Field
     C+ , :FieldType
     C+ , :FieldLen
     C+ , :FieldDig
     C+ , :FieldSeq
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      * Build list of fields ...
     C                   IF        FieldSeq <> 999
     C                   EXSR      BuildFldList
     C                   EVAL      x = x + 1
     C                   IF        FieldType = 'P'
     C                   EVAL      RcdLen = RcdLen + FieldDig
     C                   ELSE
     C                   EVAL      RcdLen = RcdLen + FieldLen
     C                   ENDIF
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from FLDDcursor
     C+ into
     C+   :Field
     C+ , :FieldType
     C+ , :FieldLen
     C+ , :FieldDig
     C+ , :FieldSeq
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close FLDDcursor
     C/end-exec
      *
     C     GetFieldsE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * CreateTable - Create table                                    *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls: ExecuteSQL                                             *
      *                                                               *
      *****************************************************************
      *
     C     CreateTable   BEGSR
      *
     C                   CLEAR                   SQLString
     C                   EVAL      RcdLenA = %CHAR(RcdLen)
     C                   EVAL      SQLString = 'create table QTEMP/UT0000541 +
     C                             (FIELD1 CHAR (' + RcdLenA + '), DUPCNT +
     C                             NUMERIC (5,0))'
     C                   EXSR      ExecuteSQL
      *
     C     CreateTableE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * BuildFldList - Build list of fields for SQL script            *
      *                                                               *
      * Called by: GetFields                                          *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     BuildFldList  BEGSR
      *
      * Add field to list with or without commas.
     C                   IF        x = 1
     C                   IF        FieldType = 'P'
     C                             or FieldType = 'S'
     C                   EVAL      FieldList1 = %TRIMR(FieldList1) +
     C                             'digits(' + Field + ')'
     C                   ELSE
     C                   EVAL      FieldList1 = %TRIMR(FieldList1) + Field
     C                   ENDIF
     C                   EVAL      FieldList2 = %TRIMR(FieldList2) + Field
     C                   ELSE
     C                   IF        FieldType = 'P'
     C                             or FieldType = 'S'
     C                   EVAL      FieldList1 = %TRIMR(FieldList1) +
     C                             ' concat digits(' + Field + ')'
     C                   ELSE
     C                   EVAL      FieldList1 = %TRIMR(FieldList1) +
     C                             ' concat ' + Field
     C                   ENDIF
     C                   EVAL      FieldList2 = %TRIMR(FieldList2) + ',' + Field
     C                   ENDIF
      *
     C     BuildFldListE ENDSR
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
