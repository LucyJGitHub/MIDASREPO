     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*XBIA*  OVRDBF FILE(UDFOLD) TOFILE(UPFFDSTPD)                        *
/*XBIB*  OVRDBF FILE(UDFNEW) TOFILE(UPFFDSTPD)                        *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Update UDF tables (including T_UDFDEF)')      *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000026 - Update UDF tables (including T_UDFDEF)            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. MD034724   *CREATE   Date 03Jun15             *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034724 - New Bridge program to upgrade UDF tables.         *
      *                                                               *
      *****************************************************************
      *
     D POldLib         S             10A
     D PNewLib         S             10A
     D PTable          S             10A
     D PRtnFlag        S              1A
      *
     D Library         S             10A
     D Outfile         S             10A
     D Format          S             50A
     D OFMbr           S             10A
     D OFMbrOpt        S              8A
     D Type            S             10A
     D DataType        S             10A
     D DataLen         S             10A
     D KeyPos          S              6A
     D SQLStr          S            150A
     D Quote           S              1A   INZ('''')
      *
     D FldData       E DS                  EXTNAME(UPFFDSTPD)
      *
     C     *ENTRY        PLIST
     C                   PARM                    POldLib
     C                   PARM                    PNewLib
     C                   PARM                    PTable
     C                   PARM                    PRtnFlag
      *
      ** Call program to produce file field description outfile of old file.
     C                   EVAL      Library = POldLib
     C                   EVAL      OutFile = 'UDFOLD'
     C                   EXSR      BldOutFile
      ** Call program to produce file field description outfile of new file.
     C                   EVAL      Library = PNewLib
     C                   EVAL      OutFile = 'UDFNEW'
     C                   EXSR      BldOutFile
      *
      ** Identify bespoke fields and add them to the UDF table.
     C                   EXSR      FindBespFlds
      *
      ** Update T_UDFDEF; first identify the new key fields.
     C                   EXSR      FindCoreFlds
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
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
     C                   PARM                    PTable
     C                   PARM                    Library
     C                   PARM                    OutFile
     C                   PARM      '*FIRST'      OFMbr
     C                   PARM      '*REPLACE'    OFMbrOpt
     C
      *
     C     BldOutFileE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    FindBespFlds - Find bespoke fields on 'old' file.          *
      *                                                               *
      *****************************************************************
      *
     C     FindBespFlds  BEGSR
      *
     C/exec SQL
     C+ declare FldDiff cursor for
     C+ select *
     C+ from UDFOLD o
     C+ where not exists
     C+ (
     C+ select *
     C+ from UDFNEW n
     C+ where
     C+     o.WHFLDI = n.WHFLDI
     C+ )
     C+ order by
     C+   WHFOBO
     C/end-exec
      *
     C/exec SQL
     C+ open FldDiff
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from FldDiff
     C+ into :FldData
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      ** For each new field add to the end of the table.
     C                   EXSR      AddField
      *
     C/exec SQL
     C+ fetch next
     C+ from FldDiff
     C+ into :FldData
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close FldDiff
     C/end-exec
      *
     C     FindBespFldsE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    AddField - Add column to the end of the table.             *
      *                                                               *
      *****************************************************************
      *
     C     AddField      BEGSR
      *
     C                   SELECT
      *
     C                   WHEN      WHFLDT = 'A'
     C                   EVAL      DataType = 'char'
     C                   EVAL      DataLen = %TRIML(%EDITC(WHFLDB:'3'))
      *
     C                   WHEN      WHFLDT = 'S'
     C                   EVAL      DataType = 'numeric'
     C                   EVAL      DataLen = %TRIML(%EDITC(WHFLDD:'3'))
     C                   EVAL      DataLen = %TRIMR(DataLen) + ',' +
     C                             %TRIML(%EDITC(WHFLDP:'3'))
      *
     C                   WHEN      WHFLDT = 'P'
     C                   EVAL      DataType = 'decimal'
     C                   EVAL      DataLen = %TRIML(%EDITC(WHFLDD:'3'))
     C                   EVAL      DataLen = %TRIMR(DataLen) + ',' +
     C                             %TRIML(%EDITC(WHFLDP:'3'))
      *
     C                   ENDSL
      *
     C                   EVAL      SQLStr = *blanks
     C                   EVAL      SQLStr = 'alter table ' + %TRIMR(PNewLib) +
     C                             '/' + %TRIMR(PTable) + ' add column ' +
     C                             %TRIMR(WHFLDI) + ' ' +  %TRIMR(DataType) +
     C                             ' (' + %TRIMR(DataLen) + ')'
     C                   IF        WHNULL = 'N'
     C                   EVAL      SQLStr = %TRIMR(SQLStr) +
     C                             ' not null with default'
     C                   ENDIF
      *
     C/exec SQL
     C+ execute immediate :SQLStr
     C/end-exec
      *
      ** Add text for new field.
     C                   EVAL      SQLStr = *blanks
     C                   EVAL      SQLStr = 'label on column ' +
     C                             %TRIMR(PNewLib) + '/' + %TRIMR(PTable) +
     C                             ' (' + %TRIMR(WHFLDI) + ' text is ' +
     C                             Quote + WHFTXT + Quote + ')'
      *
     C/exec SQL
     C+ execute immediate :SQLStr
     C/end-exec
      *
      ** Add column headings for new field.
     C                   EVAL      SQLStr = *blanks
     C                   EVAL      SQLStr = 'label on column ' +
     C                             %TRIMR(PNewLib) + '/' + %TRIMR(PTable) +
     C                             ' (' + %TRIMR(WHFLDI) + ' is ' +
     C                             Quote + WHCHD1 + WHCHD2 + WHCHD3 + Quote +
     C                             ')'
      *
     C/exec SQL
     C+ execute immediate :SQLStr
     C/end-exec
      *
     C     AddFieldE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    FindCoreFlds - Find new key fields on 'new' file.          *
      *                                                               *
      *****************************************************************
      *
     C     FindCoreFlds  BEGSR
      *
     C/exec SQL
     C+ declare DiffFld cursor for
     C+ select *
     C+ from UDFNEW o
     C+ where not exists
     C+ (
     C+ select *
     C+ from UDFOLD n
     C+ where
     C+     o.WHFLDI = n.WHFLDI
     C+ )
     C+ order by
     C+   WHFOBO
     C/end-exec
      *
     C/exec SQL
     C+ open DiffFld
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from DiffFld
     C+ into :FldData
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      ** For each key update data on T_UDFDEF.
     C                   EXSR      AddKey
      *
     C/exec SQL
     C+ fetch next
     C+ from DiffFld
     C+ into :FldData
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close DiffFld
     C/end-exec
      *
     C     FindCoreFldsE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    AddKey - Add key information to T_UDFDEF.                  *
      *                                                               *
      *****************************************************************
      *
     C     AddKey        BEGSR
      *
     C                   SELECT
      *
     C                   WHEN      WHFLDT = 'A'
     C                   EVAL      DataType = 'String'
     C                   EVAL      Type = 'string'
     C                   EVAL      Format = '<length>' +
     C                             %TRIML(%EDITC(WHFLDB:'3'))
     C                   EVAL      Format = %TRIMR(Format) + '</length>'
     C
      *
     C                   WHEN      WHFLDT = 'S'
     C                   EVAL      DataType = 'Number'
     C                   EVAL      Type = 'number'
     C                   EVAL      Format = '<precision>' +
     C                             %TRIML(%EDITC(WHFLDD:'3'))
     C                   EVAL      Format = %TRIMR(Format) +
     C                             '</precision><scale>' +
     C                             %TRIML(%EDITC(WHFLDP:'3'))
     C                   EVAL      Format = %TRIMR(Format) + '</scale>'
      *
     C                   ENDSL
      *
     C                   CALL      'UP000024'
     C                   PARM                    PTable
     C                   PARM                    WHFLDI
     C                   PARM                    WHFTXT
     C                   PARM                    DataType
     C                   PARM                    Type
     C                   PARM                    Format
     C                   PARM      '*LAST'       KeyPos
     C                   PARM                    PRtnFlag
      *
     C     AddKeyE       ENDSR
      *
      *****************************************************************
