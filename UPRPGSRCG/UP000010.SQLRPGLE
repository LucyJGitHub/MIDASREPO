     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Update modes on new dlv. data file')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000010 - Update modes on deliverable data file             *
      *                                                               *
      *  ((c) Finastra International Limited 2013                     *
      *                                                               *
      *  Last Amend No. CUP040  *CREATE    Date 06Mar13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP040 - New deliverable data methodology.                   *
      *                                                               *
      *****************************************************************
      *
     D PMainFile       S             10
     D POldFileL       S             10
     D PNewFileL       S             10
     D PModeField      S             10
      *
     D DelField        S             10
     D OutFile         S             10    INZ('UP000010F')
     D OutFileMbr      S             10    INZ('*FIRST')
     D MbrOpt          S              8    INZ('*REPLACE')
     D Format          S             10    INZ(*blanks)
     D Field           S             10    INZ(*blanks)
     D CallMode        S              7    INZ('*FIRST')
     D Return          S              7
     D FieldData       S           2000
     D Command         S             50
     D CommandLen      S             15  5 INZ(50)
     D Key             S              1
     D SQLString       S           5000
     D Quote           S              1    INZ('''')
     D Recursive       S              1
     D x               S              3  0 INZ(1)
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMainFile
     C                   PARM                    POldFileL
     C                   PARM                    PNewFileL
     C                   PARM                    PModeField
      *
      * Retrieve mode field name.
     C                   CALL      'UTC000004'
     C                   PARM                    PMainFile
     C                   PARM                    PNewFileL
     C                   PARM                    OutFile
     C                   PARM                    OutFileMbr
     C                   PARM                    MbrOpt
     C                   EVAL      Command = 'OVRDBF FILE(UPFFDSTPD) +
     C                             TOFILE(UP000010F)'
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   CALL      'UTAOFFDS'
     C                   PARM                    PMainFile
     C                   PARM                    Format
     C                   PARM                    Field
     C                   PARM                    CallMode
     C                   PARM                    Return
     C                   PARM                    FieldData
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'DLTOVR FILE(UPFFDSTPD)'
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      *
     C                   EVAL      PModeField = %SUBST(FieldData:130:2) + 'MODE'
     C                   EVAL      DelField = %SUBST(FieldData:130:2) + 'DEL'
      *
      * First set all mode fields to blank in case of re-run.
     C                   EVAL      SQLString = 'update ' +
     C                             %TRIMR(POldFileL) +
     C                             '/' +
     C                             %TRIMR(PMainFile) +
     C                             ' set ' +
     C                             PModeField +
     C                             '=' +
     C                             Quote + ' ' + Quote
     C                   EXSR      ExecuteSQL
      *
      * Build initial part of SQL statement to populate mode fields.
     C                   CLEAR                   SQLString
     C                   EVAL      SQLString = 'update ' +
     C                             %TRIMR(POldFileL) +
     C                             '/' +
     C                             %TRIMR(PMainFile) +
     C                             ' o set ' +
     C                             PModeField +
     C                             '= ' +
     C                             Quote + 'C' + Quote +
     C                             ' where exists (select * from ' +
     C                             %TRIMR(PNewFileL) +
     C                             '/' +
     C                             %TRIMR(PMainFile) +
     C                             ' n where '
     C                   EXSR      GetKeyFields
     C                   EVAL      SQLString = %TRIMR(SQLString) + ')'
     C                   EXSR      ExecuteSQL
      *
      * Once the 'core' records have been updated then update the rest
      *  of the records.
     C                   CLEAR                   SQLString
     C                   EVAL      SQLString = 'update ' +
     C                             %TRIMR(POldFileL) +
     C                             '/' +
     C                             %TRIMR(PMainFile) +
     C                             ' set ' +
     C                             PModeField +
     C                             '=' +
     C                             Quote + 'B' + Quote +
     C                             ' where ' +
     C                             PModeField +
     C                             '=' +
     C                             Quote + ' ' + Quote
     C                   EXSR      ExecuteSQL
      *
      * Update all logically deleted fields to 'N'.  Note that this field
      *  may not exist on the file but the error will be ignored.
     C                   CLEAR                   SQLString
     C                   EVAL      SQLString = 'update ' +
     C                             %TRIMR(POldFileL) +
     C                             '/' +
     C                             %TRIMR(PMainFile) +
     C                             ' set ' +
     C                             DelField +
     C                             '=' +
     C                             Quote + 'N' + Quote
     C                   EXSR      ExecuteSQL
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * GetKeyFields - Retrieve key fields from UPAFFDPD              *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls: FetchRec                                               *
      *                                                               *
      *****************************************************************
      *
     C     GetKeyFields  BEGSR
      *
     C/exec SQL
     C+ declare AFFDcursor cursor for
     C+ select
     C+   AFFDNM
     C+ , AFKEYF
     C+ from UPAFFDPD
     C+ where
     C+   AFFILE = :PMainFile
     C/end-exec
      *
     C/exec SQL
     C+ open AFFDcursor
     C/end-exec
      *
     C                   EXSR      FetchRec
      *
     C                   DOW       SQLCODE = 0
      * Select only key fields that are not mode fields.
     C                   IF        Key = 'Y'
     C                             and Field <> PModeField
     C                   EXSR      BuildKey
     C                   EVAL      x = x + 1
     C                   ENDIF
      *
     C                   EXSR      FetchRec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close AFFDcursor
     C/end-exec
      *
     C     GetKeyFieldsE ENDSR
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
     C+ from AFFDcursor
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
      * BuildKey - Build key string for comparison                    *
      *                                                               *
      * Called by: *main                                              *
      *                                                               *
      * Calls: GetKeyFields                                           *
      *                                                               *
      *****************************************************************
      *
     C     BuildKey      BEGSR
      *
     C                   IF        x <> 1
     C                   EVAL      SQLString = %TRIMR(SQLString) + ' and ' +
     C                             'o.' + %TRIMR(Field) +
     C                             ' = n.' + Field
     C                   ELSE
     C                   EVAL      SQLString = %TRIMR(SQLString) +
     C                             ' o.' + %TRIMR(Field) +
     C                             ' = n.' + Field
     C                   ENDIF
      *
     C     BuildKeyE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ExecuteSQL - Execute SQL statement                            *
      *                                                               *
      * Called by: *main                                              *
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
