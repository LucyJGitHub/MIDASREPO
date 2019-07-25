     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Copy across extact files')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000023 - Copy across extact files                          *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. CUP042 *CREATE     Date 25May15               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - Simplification of deliverables list.                *
      *                                                               *
      *****************************************************************
      *
     D PLayer          S              7
     D PBrgDtaLib      S             10
     D PMoveLib        S             10
     D PReturn         S              1
      *
     D Status          S              1
     D ReturnCode      S              1
     D File            S             10
     D CopyOpt         S             10
     D MbrOpt          S              8
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLayer
     C                   PARM                    PBrgDtaLib
     C                   PARM                    PMoveLib
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
     C+ , AUCPYO
     C+ from UPDLVCPD
     C+ where
     C+     AUMBTP = 'DATA'
     C+ and AUDTYP = 'O'
     C+ and AUUSTS <> 'C'
     C+ and AUDTLB = :PLayer
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
     C+   :File
     C+ , :CopyOpt
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
     C                   EVAL      MbrOpt = %SUBST(CopyOpt:1:8)
     C                   EVAL      ReturnCode = *blank
      * Call the program to process the copy of the files.
     C                   CALL      'UPC000041'
     C                   PARM                    File
     C                   PARM                    MbrOpt
     C                   PARM                    PBrgDtaLib
     C                   PARM                    PMoveLib
     C                   PARM                    ReturnCode
      * Set the status depending on the return code.
     C                   IF        ReturnCode = 'E'
     C                   EVAL      Status = 'F'
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
