     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Merge message files')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000022 - Merge message files                               *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CUP041   *CREATE   Date 05Aug14               *
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
     D PBrgDtaLib      S             10
     D POwner          S             10
     D PAutl           S             10
     D PReturn         S              1
      *
     D File            S             10
     D Status          S              1
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLayer
     C                   PARM                    PMovLib
     C                   PARM                    PBrgDtaLib
     C                   PARM                    POwner
     C                   PARM                    PAutl
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
     C+ and AUMBTP = 'MSGF'
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
     C                   CALL      'UPC000044'
     C                   PARM                    PMovLib
     C                   PARM                    PBrgDtaLib
     C                   PARM                    File
     C                   PARM                    POwner
     C                   PARM                    PAutl
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
