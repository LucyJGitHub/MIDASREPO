     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Handle redundant and renamed files')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000005 - Handle redundant, renamed or moved files          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CUP040 *CREATE      Date 09Aug13              *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP040 - Enhancment to delete redundant, renamed or moved    *
      *           files.                                              *
      *                                                               *
      *****************************************************************
      *
     D PLayer          S              7
     D PMoveLib        S             10
     D PReturn         S              1
      *
     D Member          S             10
     D MemberType      S             10
     D ObjectType      S              7
     D Status          S              1
     D Command         S             60
     D CommandLen      S             15  5 INZ(60)
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLayer
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
     C+ , AUMBTP
     C+ from UPDLVCPD
     C+ where
     C+     substr(AUMBTP,1,1) = 'X'
     C+ and AUDTYP = 'O'
     C+ and AUDTLB = :PLayer
     C+ order by AUIPTY desc
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
     C+   :Member
     C+ , :MemberType
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
     C                   SELECT
     C                   WHEN      %SUBST(MemberType:3:8) = 'LF'
     C                             or %SUBST(MemberType:3:8) = 'PF'
     C                             or %SUBST(MemberType:3:8) = 'SQLVIEW'
     C                             or %SUBST(MemberType:3:8) = 'SQLTABLE'
     C                   EVAL      ObjectType = '*FILE  '
      *
     C                   WHEN      %SUBST(MemberType:3:8) = 'TBL'
     C                   EVAL      ObjectType = '*TBL   '
      *
     C                   WHEN      %SUBST(MemberType:3:8) = 'DTAARA'
     C                   EVAL      ObjectType = '*DTAARA'
      *
     C                   WHEN      %SUBST(MemberType:3:8) = 'DTAQ'
     C                   EVAL      ObjectType = '*DTAQ  '
      *
     C                   WHEN      %SUBST(MemberType:3:8) = 'VLDL'
     C                   EVAL      ObjectType = '*VLDL  '
      *
     C                   OTHER
     C                   GOTO      NextRecord
      *
     C                   ENDSL
      *
      ** Call CL program for easier object handling.
     C                   CALL      'UPC000040'
     C                   PARM                    PMoveLib
     C                   PARM                    Member
     C                   PARM                    ObjectType
     C                   PARM                    MemberType
     C                   PARM                    Status
      *
     C/exec SQL
     C+ update UPDLVCPD
     C+ set AUUSTS = :Status
     C+ where current of DLVC
     C/end-exec
      *
     C     NextRecord    TAG
      *
     C/exec SQL
     C+ fetch next
     C+ from DLVC
     C+ into
     C+   :Member
     C+ , :MemberType
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
