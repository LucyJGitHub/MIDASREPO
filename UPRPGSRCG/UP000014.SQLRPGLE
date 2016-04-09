     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Delete logicals, views, indices, etc.')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000014 - Delete logicals, views, indices, etc.             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CUP041   *CREATE   Date 09Sep13               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP041 - New Bridge methodology to combine menu options      *
      *                                                               *
      *****************************************************************
      *
     D PLayer          S              7
     D PMovLib         S             10
     D PReturn         S              1
      *
     D File            S             10
     D Status          S              1
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLayer
     C                   PARM                    PMovLib
     C                   PARM                    PReturn
      *
     C/exec SQL
     C+ whenever SQLERROR goto ERROR
     C/end-exec
      *
     C/exec SQL
     C+ declare DLVC cursor for
     C+ select
     C+   AUMBNM
     C+ from UPDLVCPD
     C+ where
     C+     AUDTYP = 'O'
     C+ and AUUSTS <> 'C'
     C+ and AUDTLB = :PLayer
     C+ and
     C+ (
     C+     AUMBTP = 'LF'
     C+ or  AUMBTP = 'SQLVIEW'
     C+ )
     C+ order by
     C+ AUIPTY desc
     C/end-exec
      *
     C/exec SQL
     C+ open DLVC
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from DLVC
     C+ into
     C+   :File
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
     C                   CALL      'UPC000042'
     C                   PARM                    PMovLib
     C                   PARM                    File
     C                   PARM                    PReturn
     C                   IF        PReturn = 'F'
     C                   EVAL      Status = 'F'
     C                   ELSE
     C                   EVAL      Status = 'C'
     C                   ENDIF
     C                   EVAL      PReturn = *blank
      *
     C/exec SQL
     C+ update UPDLVCPD
     C+ set AUUSTS = :Status
     C+ where current of DLVC
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from DLVC
     C+ into
     C+   :File
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close DLVC
     C/end-exec
      *
     C     ERROR         TAG
     C                   IF        SQLCODE < 0
     C                   EVAL      PReturn = 'E'
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
