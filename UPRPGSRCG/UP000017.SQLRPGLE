     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Upgrade physicals and tables')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000017 - Upgrade physicals and tables                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CUP041   *CREATE   Date 11Sep13               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP041 - New Bridge methodology to combine menu options      *
      *                                                               *
      *****************************************************************
      *
     D PLayer          S              7
     D PBrgSrcLib      S             10
     D PMoveLib        S             10
     D PPfx            S              2
     D POwner          S             10
     D PAutl           S             10
     D PReturn         S              1
      *
     D File            S             10
     D SrcFile         S             10
     D ObjectLib       S             10
     D CopyOpt         S             10
     D Status          S              1
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLayer
     C                   PARM                    PBrgSrcLib
     C                   PARM                    PMoveLib
     C                   PARM                    PPfx
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
     C+ , AUSRCF
     C+ , AUFMTO
     C+ from UPDLVCPD
     C+ where
     C+     AUDTYP = 'O'
     C+ and AUUSTS <> 'C'
     C+ and AUDTLB = :PLayer
     C+ and
     C+ (
     C+     AUMBTP = 'PF'
     C+ or  AUMBTP = 'SQLTBL'
     C+ )
     C+ order by
     C+ AUIPTY asc
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
     C+ , :SrcFile
     C+ , :CopyOpt
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
     C                   IF        %SUBST(SrcFile:9:2) = 'QT'
     C                   ITER
     C                   ENDIF
      *
     C                   IF        %SUBST(SrcFile:10:1) = 'T'
     C                   EVAL      ObjectLib = PPfx + %SUBST(SrcFile:9:2) +
     C                                         'ALIB'
     C                   ELSE
     C                   IF        %SUBST(SrcFile:10:1) = 'A'
     C                   EVAL      ObjectLib = PPfx + %SUBST(SrcFile:9:1) +
     C                                         'PLIB'
     C                   ELSE
     C                   EVAL      ObjectLib = PPfx + %SUBST(SrcFile:9:2) +
     C                                         'LIB'
     C                   ENDIF
     C                   ENDIF
     C                   CALL(e)   'UPC000034'
     C                   PARM                    File
     C                   PARM                    SrcFile
     C                   PARM                    PBrgSrcLib
     C                   PARM                    ObjectLib
     C                   PARM                    PMoveLib
     C                   PARM                    CopyOpt
     C                   PARM                    POwner
     C                   PARM                    PAutl
     C                   PARM                    PReturn
     C                   IF        PReturn = 'E'
     C                   EVAL      Status = 'F'
     C                   EVAL      PReturn  = *blank
     C                   ELSE
     C                   EVAL      Status = 'C'
     C                   ENDIF
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
     C+ , :SrcFile
     C+ , :CopyOpt
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
