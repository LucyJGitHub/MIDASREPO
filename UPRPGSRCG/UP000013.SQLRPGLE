     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Prepare database upgrade')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000013 - Prepare database upgrade                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD034307           Date 05May15               *
      *  Prev Amend No. CUP041   *CREATE   Date 06Sep11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034307 - Allow for no database changes.                    *
      *  CUP041 - New Bridge methodology to combine menu options      *
      *                                                               *
      *****************************************************************
      *
     D PLayer          S              7
     D PBrgBrgLib      S             10
     D PPgmLib         S             10
     D PFileLib        S             10
     D PReturn         S              1
      *
     D Mode            S              4
     D File            S             10
     D MemberType      S             10
     D Status          S              1
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLayer
     C                   PARM                    PBrgBrgLib
     C                   PARM                    PPgmLib
     C                   PARM                    PFileLib
     C                   PARM                    PReturn
      *
     C/exec SQL
     C+ whenever SQLERROR goto ERROR
     C/end-exec
      *
      * Delete work files.
     C                   CALL(e)   'UPC000030'
     C                   PARM      '*DLT'        Mode
     C                   PARM      *blanks       File
     C                   PARM      *blanks       MemberType
     C                   PARM                    PBrgBrgLib
     C                   PARM                    PPgmLib
     C                   PARM                    PFileLib
     C                   PARM                    PReturn
      * If the error switch is on then update status as failed.
     C                   IF        PReturn = 'E'
     C                   GOTO      ERROR
     C                   ENDIF
      *
     C/exec SQL
     C+ declare DLVC cursor for
     C+ select
     C+   AUMBNM
     C+ , AUMBTP
     C+ from UPDLVCPD
     C+ where
     C+     AUDTYP = 'O'
     C+ and AUUSTS <> 'C'
     C+ and AUDTLB = :PLayer
     C+ and
     C+ (
     C+     AUMBTP = 'PF'
     C+ or  AUMBTP = 'LF'
     C+ or  AUMBTP = 'SQLTBL'
     C+ or  AUMBTP = 'SQLVIEW'
     C+ )
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
     C+ , :MemberType
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
     C                   CALL(e)   'UPC000030'
     C                   PARM      '*BLD'        Mode
     C                   PARM                    File
     C                   PARM                    MemberType
     C                   PARM                    PBrgBrgLib
     C                   PARM                    PPgmLib
     C                   PARM                    PFileLib
     C                   PARM                    PReturn
      * If the error switch is on then update status as failed.
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
     C+ , :MemberType
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close DLVC
     C/end-exec
      *
      * Copy records for multi-membered files.
     C                   CALL(e)   'UPC000030'
     C                   PARM      '*CPY'        Mode
     C                   PARM      *blanks       File
     C                   PARM      *blanks       MemberType
     C                   PARM                    PBrgBrgLib
     C                   PARM                    PPgmLib
     C                   PARM                    PFileLib
     C                   PARM                    PReturn
      * If the error switch is on then update status as failed.
     C                   IF        PReturn = 'E'
     C                   GOTO      ERROR
     C                   ENDIF
      *
      * Insert unique records for database relations.
     C/exec SQL
     C+ insert into UPDBRSTD
     C+ (
     C+   DSFILE
     C+ , DSLIB
     C+ , DSSAVF
     C+ )
     C+ select distinct
     C+   WHREFI
     C+ , WHRELI
     C+ , ' '
     C**from*TESTDBR*                                                                       MD034307
     C+ from UPC0030DB                                                                      MD034307
     C+ where
     C+     WHREFI <> ' '
     C+ order by
     C+   WHREFI
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
