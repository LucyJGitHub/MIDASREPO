     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Report errors on the Bridge driving file')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000011 - Report errors on the Bridge driving file          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CUP041   *CREATE   Date 03Sep11               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP041 - New Bridge methodology to combine menu options      *
      *                                                               *
      *****************************************************************
      *
     D PMode           S              4
     D PProgram        S             10
     D PFail           S              1
      *
     D Action          S              7    INZ('*REPORT')
     D ErrorMsg        S            100
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMode
     C                   PARM                    PProgram
     C                   PARM                    PFail
      *
     C                   IF        PMode = '*CHK'
     C/exec SQL
     C+ delete from UPERRMQT
     C/end-exec
      *
     C/exec SQL
     C+ insert into QTEMP/UPERRMQT
     C+ (
     C+ UPERRMQT
     C+ )
     C+ select
     C+        AUMBNM
     C+ concat AUMBTP
     C+ concat AUMBTX
     C+ from UPDLVCPD
     C+ where AUUSTS = 'F'
     C/end-exec
      *
     C                   IF        SQLCODE = 0
     C                   EVAL      PFail = 'Y'
     C                   CALL      'UP008010'
     C                   PARM                    Action
     C                   PARM                    PProgram
     C                   PARM      *blanks       ErrorMsg
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        PMode = '*RST'
      *
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+ AUUSTS = ' '
     C/end-exec
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
