     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Create logical files')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000018 - Create logical files                              *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
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
     D PPfx            S              2
     D POwner          S             10
     D PAutl           S             10
     D PReturn         S              1
      *
     D File            S             10
     D SrcFile         S             10
     D ObjectLib       S             10
     D Status          S              1
     D Command         S            100
     D CommandLen      S             15  5 INZ(100)
      *
     D/COPY GPCPYSRCG,PSDS
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLayer
     C                   PARM                    PBrgSrcLib
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
     C                   EVAL      ObjectLib = PPfx + %SUBST(SrcFile:9:2) +
     C                                         'LIB'
     C                   ENDIF
      *
      * Build CRTOBJ string.
     C                   EVAL      Command = 'CRTOBJ OBJ(' + ObjectLib
     C                   EVAL      Command = %TRIMR(Command) + '/' + File
     C                   EVAL      Command = %TRIMR(Command) + ') SRCFILE(' +
     C                             PBrgSrcLib
     C                   EVAL      Command = %TRIMR(Command) + '/' + SrcFile
     C                   EVAL      Command = %TRIMR(Command) + ') OWNER(' +
     C                             POwner
     C                   EVAL      Command = %TRIMR(Command) + ') AUTL(' +
     C                             PAutl
     C                   EVAL      Command = %TRIMR(Command) + ')'
      *
     C                   CALL(e)   'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      * Check for SYS* errors which means there has been a failure.
     C                   IF        PSExcpType = *blank
     C                   EVAL      Status = 'C'
     C                   ELSE
     C                   EVAL      Status = 'F'
     C                   EVAL      PSExcpType = *blank
     C                   EVAL      PSExcpNo = *blank
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
