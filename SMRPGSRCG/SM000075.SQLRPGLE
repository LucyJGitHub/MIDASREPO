     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Check if UDF tables are delivered')           *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000075 - Check if UDF tables are delivered                 *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD034724 *CREATE   Date 03Jun15               *
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
      *
     D Table           S             10A
     D Type            S             10A
     D Status          S              6A
     D Command         S            100A
     D CommandLen      S             15  5 INZ(100)
     D RtnFlag         S              1A
     D RtnData         S            180A
      *
     C     *ENTRY        PLIST
     C                   PARM                    POldLib
     C                   PARM                    PNewLib
      *
      ** Update status for migration.
     C                   EVAL      Status = 'ACTIVE'
     C                   EXSR      UpdateSts
      *
     C/exec SQL
     C+ declare UDF cursor for
     C+ select
     C+   UDFDD
     C+ from T_UDFDEF
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
      ** First check if the table exists in the 'to' system.
     C                   CALL      'UTRTVOBJD'
     C                   PARM                    Table
     C                   PARM                    PNewLib
     C                   PARM      '*FILE'       Type
     C                   PARM                    RtnFlag
     C                   PARM                    RtnData
     C                   IF                      RtnFlag <> *blank
     C                   EVAL      RtnFlag = *blank
     C/exec SQL
     C+ delete from T_UDFDEF
     C+ where current of UDF
     C/end-exec
     C
     C                   ELSE
      *
      ** Call program to check field differences and apply them.
     C                   CALL      'UP000026'
     C                   PARM                    POldLib
     C                   PARM                    PNewlib
     C                   PARM                    Table
     C                   PARM                    RtnFlag
     C                   IF                      RtnFlag <> *blank
     C                   EVAL      Status = 'FAILED'
     C                   ENDIF
      *
     C                   ENDIF
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
      ** Once the UDF has had the new fields added then update the data.
     C                   EXSR      CopyFile
      *
      ** Update status for migration.
     C                   EVAL      Status = 'PASSED'
     C                   EXSR      UpdateSts
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    CopyFile - Copy data from original files.                  *
      *                                                               *
      *****************************************************************
      *
     C     CopyFile      BEGSR
      *
     C/exec SQL
     C+ declare MIG cursor for
     C+ select
     C+   NCOBJ
     C+ from SMGNMGPD
     C+ where
     C+     NCETBL = 'Y'
     C/end-exec
      *
     C/exec SQL
     C+ open MIG
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from MIG
     C+ into :Table
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
     C                   EVAL      Command = 'CPYF FROMFILE('
     C                             + %TRIMR(POldLib) + '/' + %TRIMR(Table) +
     C                             ') TOFILE(' + %TRIMR(PNewLib) + '/' +
     C                             %TRIMR(Table) + ') MBROPT(*REPLACE) +
     C                             FMTOPT(*MAP *DROP)'
     C                   CALL(e)   'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      *
     C/exec SQL
     C+ fetch next
     C+ from MIG
     C+ into :Table
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close MIG
     C/end-exec
      *
     C     CopyFileE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *    UpdateSts - Update status on migration driving file.       *
      *                                                               *
      *****************************************************************
      *
     C     UpdateSts     BEGSR
      *
     C/exec SQL
     C+ update SMCPYDPD
     C+ set
     C+   ODDDAT = :Status
     C+ where
     C+     ODOBNM = 'SM000075'
     C+ and ODOBTP = '*PGM'
     C/end-exec
      *
     C     UpdateStsE    ENDSR
      *
      *****************************************************************
