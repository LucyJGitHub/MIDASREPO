     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Restore non-core logical files')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000016 - Restore non-core logical files, views             *
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
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    PBrgBrgLib
     C                   PARM                    PReturn
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
     C+ , DSSAVF
     C+ from UPDBRSTD
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
     C+ , :SaveFile
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      * Call program to handle restore of files.
     C                   CALL(e)   'UPC000033'
     C                   PARM      '*RST'        Mode
     C                   PARM                    File
     C                   PARM                    Library
     C                   PARM                    PBrgBrgLib
     C                   PARM                    SaveFile
     C                   PARM                    PReturn
      * If there was a general error then end program.
     C                   IF        PReturn = 'E'
     C                   GOTO      ERROR
     C                   ENDIF
     C/exec SQL
     C+ delete from UPDBRSTD
     C+ where current of DBRS
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from DBRS
     C+ into
     C+   :File
     C+ , :Library
     C+ , :SaveFile
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close DBRS
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
