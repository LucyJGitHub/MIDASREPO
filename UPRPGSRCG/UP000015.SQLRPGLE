     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Save non-core logical files')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000015 - Save non-core logical files, views                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CUP041   *CREATE   Date 10Sep13               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP041 - New Bridge methodology to combine menu options      *
      *                                                               *
      *****************************************************************
      *
     D PBrgBrgLib      S             10
     D PReturn         S              1
      *
     D Mode            S             10
     D File            S             10
     D Library         S             10
     D SaveFile        S             10
     D ReportFlag      S              1
     D ErrorMsg        S            100
     D Action          S              7
     D Program         S             10
     D Command         S             60
     D CommandLen      S             15  5 INZ(60)
     D CHGSPLFA        C                   'CHGSPLFA FILE(UP008010P1) +
     D                                     SPLNBR(*LAST) USRDTA(UP000015)'
      *
     D                 DS
     D SequenceN               1      8  0
     D SequenceA               1      8
      *
     C     *ENTRY        PLIST
     C                   PARM                    PBrgBrgLib
     C                   PARM                    PReturn
      *
      * Clear message file.
     C/exec SQL
     C+ delete from UPERRMQT
     C/end-exec
      *
      * Identify highest save file value for starting point.
     C/exec SQL
     C+ select max(DSSAVF)
     C+ into :SaveFile
     C+ from UPDBRSTD
     C/end-exec
      *
     C                   IF        SaveFile = ' '
     C                   EVAL      SequenceN = 1
     C                   ELSE
     C                   EVAL      SequenceA = %SUBST(SaveFile:3:8)
     C                   EVAL      SequenceN = SequenceN + 1
     C                   ENDIF
      *
     C/exec SQL
     C+ whenever SQLERROR goto ERROR
     C/end-exec
      *
     C/exec SQL
     C+ declare DBRS cursor for
     C+ select
     C+   DSFILE
     C+ , DSLIB
     C+ from UPDBRSTD
     C+ where
     C+     DSSAVF = ' '
     C/end-exec
      *
     C/exec SQL
     C+ open DBRS
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from DBRS
     C+ into
     C+   :File
     C+ , :Library
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      * Call program to handle creation of save file, save and deletion.
     C                   EVAL      SaveFile = 'QQ' + SequenceA
     C                   CALL(e)   'UPC000033'
     C                   PARM      '*SAV'        Mode
     C                   PARM                    File
     C                   PARM                    Library
     C                   PARM                    PBrgBrgLib
     C                   PARM                    SaveFile
     C                   PARM                    PReturn
      * If there was no error then update file with save file name.
     C                   IF        PReturn = *blank
     C                   EVAL      ReportFlag = 'Y'
     C/exec SQL
     C+ update UPDBRSTD
     C+ set DSSAVF = :SaveFile
     C+ where current of DBRS
     C/end-exec
     C                   EVAL      SequenceN = SequenceN + 1
      * Write record for reporting purposes.
     C                   EVAL      ErrorMsg  = File + Library + SaveFile
     C                   CALL      'UP008010'
     C                   PARM      '*WRITE'      Action
     C                   PARM      'UP000015'    Program
     C                   PARM                    ErrorMsg
     C                   ENDIF
      *
      * If the file was not found then delete record from file.
     C                   IF        PReturn = 'N'
     C/exec SQL
     C+ delete from UPDBRSTD
     C+ where current of DBRS
     C/end-exec
     C                   EVAL      PReturn = *blank
     C                   ENDIF
      *
      * If there was a general error then end program.
     C                   IF        PReturn = 'E'
     C                   GOTO      ERROR
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from DBRS
     C+ into
     C+   :File
     C+ , :Library
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close DBRS
     C/end-exec
      *
      * If any files were saved then report.
     C                   IF        ReportFlag = 'Y'
     C                   CALL      'UP008010'
     C                   PARM      '*REPORT'     Action
     C                   PARM      'UP000015'    Program
     C                   PARM                    ErrorMsg
      *
     C                   EVAL      Command = CHGSPLFA
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   ENDIF
      *
     C     ERROR         TAG
     C                   IF        SQLCODE < 0
     C                   EVAL      PReturn = 'E'
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
