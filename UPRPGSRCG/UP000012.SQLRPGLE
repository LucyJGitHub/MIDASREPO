     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Run Upgrade Programs')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000012 - Run Upgrade Programs                              *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. CUP041   *CREATE   Date 06Sep11               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP041 - New Bridge methodology to combine menu options      *
      *                                                               *
      *****************************************************************
      *
     D PLayer          S              7
     D PMode           S              7
     D PReturn         S              1
      *
     D Program         S             10
     D Parameters      S             50
     D Status          S              1
     D Command         S             80
     D CommandLen      S             15  5 INZ(80)
      *
     D/COPY GPCPYSRCG,PSDS
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLayer
     C                   PARM                    PMode
     C                   PARM                    PReturn
      *
     C/exec SQL
     C+ whenever SQLERROR goto ERROR
     C/end-exec
      *
     C                   EVAL      *INU8 = *OFF
      *
     C/exec SQL
     C+ declare DLVC cursor for
     C+ select
     C+   AUMBNM
     C+ , AUEXIN
     C+ from UPDLVCPD
     C+ where
     C+     AUMBTP = 'EXE'
     C+ and AUDTYP = 'O'
     C+ and AUUSTS <> 'C'
     C+ and AUDTLB = :PLayer
     C+ and AUFMTO = :PMode
     C+ order by
     C+     AUIPTY asc
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
     C+   :Program
     C+ , :Parameters
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      * Build the command string.
     C                   EVAL      Command = 'CALL PGM(' + Program
     C                   EVAL      Command = %TRIMR(Command) + ')'
     C                   IF        Parameters <> *blank
     C                   EVAL      Command = %TRIMR(Command) + ' PARM(' +
     C                             Parameters
     C                   EVAL      Command = %TRIMR(Command) + ')'
     C                   ENDIF
      *
     C                   CALL(e)   'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      * If the error switch is on then update status as failed.
     C                   IF        *INU8 = *ON or
     C                             PSExcpNo <> *blank
     C                   EVAL      Status = 'F'
     C                   EVAL      *INU8 = *OFF
     C                   EVAL      PSExcpNo = *blank
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
     C+   :Program
     C+ , :Parameters
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
