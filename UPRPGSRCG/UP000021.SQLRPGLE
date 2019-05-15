     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Upgrade data areas and data queues')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000021 - Upgrade data areas and data queues                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD034982           Date 14Jul15               *
      *  Prev Amend No. CUP041   *CREATE   Date 11Sep13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034982 - Handle SQL sequences (SQLDTAARA)                  *
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
     D Member          S             10
     D MemberType      S             10
     D ObjType         S              7
     D SrcFile         S             10
     D ObjectLib       S             10
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
     C+ , AUMBTP
     C+ , AUSRCF
     C+ from UPDLVCPD
     C+ where
     C+     AUDTYP = 'O'
     C+ and AUUSTS <> 'C'
     C+ and AUDTLB = :PLayer
     C+ and
     C+ (
     C+     AUMBTP = 'DTAARA'
     C+ or  AUMBTP = 'DTAQ'
     C+ or  AUMBTP = 'VLDL'
     C+ or  AUMBTP = 'SQLDTAARA'                                                            MD034982
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
     C+   :Member
     C+ , :MemberType
     C+ , :SrcFile
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
     C                   IF        %SUBST(SrcFile:9:2) = 'QT'
     C                   ITER
     C                   ENDIF
      *
     C                   IF        MemberType = 'SQLDTAARA'                                 MD034982
     C                   EVAL      MemberType = 'DTAARA'                                    MD034982
     C                   ENDIF                                                              MD034982
     C                   EVAL      ObjType = '*' + MemberType
     C                   IF        %SUBST(SrcFile:10:1) = 'T'
     C                   EVAL      ObjectLib = PPfx + %SUBST(SrcFile:9:2) +
     C                                         'ALIB'
     C                   ELSE
     C                   EVAL      ObjectLib = PPfx + %SUBST(SrcFile:9:2) +
     C                                         'LIB'
     C                   ENDIF
     C                   CALL(e)   'UPC000035'
     C                   PARM                    ObjType
     C                   PARM                    Member
     C                   PARM                    SrcFile
     C                   PARM                    PBrgSrcLib
     C                   PARM                    ObjectLib
     C                   PARM                    PMoveLib
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
     C+   :Member
     C+ , :MemberType
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
