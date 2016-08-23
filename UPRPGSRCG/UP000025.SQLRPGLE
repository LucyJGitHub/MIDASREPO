     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Check if UDF tables are delivered')           *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000025 - Check if UDF tables are delivered                 *
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
     D PPfx            S              2A
     D PRtnFlag        S              1A
      *
     D NewLib          S             10A
     D Table           S             10A
     D SaveF           S              1    INZ('N')
     D RcdCount        S              2  0
     D Command         S            100A
     D CommandLen      S             15  5 INZ(100)
      *
     C     *ENTRY        PLIST
     C                   PARM                    POldLib
     C                   PARM                    PPfx
     C                   PARM                    PRtnFlag
      *
     C                   EVAL      NewLib = PPfx + 'GMLIB'
      *
     C/exec SQL
     C+ declare UDF cursor for
     C+ select
     C+   AUMBNM
     C+ from UPDLVCPD a
     C+ where exists
     C+ (
     C+ select b.NCOBJ
     C+ from SMGNMGPD b
     C+ where
     C+     a.AUMBNM = b.NCOBJ
     C+ and b.NCETBL = 'Y'
     C+ )
     C/end-exec
      *
     C/exec SQL
     C+ open UDF
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from UDF
     C+ into :Table
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      ** First check if the table has additional customer fields; if no then
      **  check the next record.
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from T_UDFDEF
     C+ where
     C+     UDFDD = :Table
     C/end-exec
      *
     C                   IF        RcdCount > 0
      ** For the first record found take a copy of T_UDFDEF to the save
      **  library.
     C                   IF        SaveF = 'N'
     C                   EXSR      SaveFile
     C                   EVAL      SaveF = 'Y'
     C                   ENDIF
      *
      ** Call program to check field differences and apply them.
     C                   CALL      'UP000026'
     C                   PARM                    POldLib
     C                   PARM                    Newlib
     C                   PARM                    Table
     C                   PARM                    PRtnFlag
      *
     C                   ENDIF
      *
      ** Copy the records for the UDF table every time.
     C                   EXSR      CopyFile
      *
     C/exec SQL
     C+ fetch next
     C+ from UDF
     C+ into :Table
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close UDF
     C/end-exec
      *
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    CopyFile - Copy data from original file.                   *
      *                                                               *
      *****************************************************************
      *
     C     CopyFile      BEGSR
      *
     C                   EVAL      Command = 'CPYF FROMFILE('
     C                             + %TRIMR(POldLib) + '/' + %TRIMR(Table) +
     C                             ') TOFILE(' + %TRIMR(NewLib) + '/' +
     C                             %TRIMR(Table) + ') MBROPT(*REPLACE) +
     C                             FMTOPT(*MAP *DROP)'
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      *
     C     CopyFileE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    SaveFile - Save original version of T_UDFDEF.              *
      *                                                               *
      *****************************************************************
      *
     C     SaveFile      BEGSR
      *
     C                   EVAL      Command = 'CPYF FROMFILE(T_UDFDEF) TOFILE(' +
     C                             %TRIMR(POldLib) + '/T_UDFDEF) +
     C                             MBROPT(*REPLACE) CRTFILE(*YES)'
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      *
     C     SaveFileE     ENDSR
      *
      *****************************************************************
