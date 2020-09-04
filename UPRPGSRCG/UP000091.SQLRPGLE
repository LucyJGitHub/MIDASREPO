     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Update deliverables list')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000091 - Update Deliverables List                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CUP042 *CREATE     Date 22May15               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - Simplify update of driving file.                    *
      *                                                               *
      *****************************************************************
      *
     D Mode            S              4
      *
     D Member          S             10
     D Library         S             10
     D ObjectType      S             10
     D ReturnCode      S              1
     D ReturnData      S            180
     D ObjectText      S             50
      *
     C     *ENTRY        PLIST
     C                   PARM                    Mode
      *
      *
     C                   IF        Mode = '*TXT'
      ** Add text if blank.
     C                   EXSR      AddText
     C                   ENDIF
      *
     C                   IF        Mode = '*STS'
      ** Reset statuses to blank.
     C                   EXSR      UpdStatus
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *********************************************************************
      *                                                                   *
      *    AddText - Attempt to add text if blank.                        *
      *                                                                   *
      *********************************************************************
     C     AddText       BEGSR
      *
      ** Read through records where text is blank.
     C/exec SQL
     C+ declare AddTextC cursor for
     C+ select
     C+   AUMBNM
     C+ , AUPROJ
     C+ from UPDLVCPD
     C+ where
     C+     AUMBTX = ' '
     C/end-exec
      *
     C/exec SQL
     C+ open AddTextC
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from AddTextC
     C+ into
     C+   :Member
     C+ , :ObjectType
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      ** Retrieve object description to get text.
     C                   CALL      'UTRTVOBJD'
     C                   PARM                    Member
     C                   PARM      '*LIBL'       Library
     C                   PARM                    ObjectType
     C                   PARM                    ReturnCode
     C                   PARM                    ReturnData
     C                   IF        ReturnCode = *blank
     C                   EVAL      ObjectText = %SUBST(ReturnData:101:50)
     C/exec SQL
     C+ update UPDLVCPD
     C+ set
     C+   AUMBTX = :ObjectText
     C+ where current of AddTextC
     C/end-exec
     C                   ENDIF
      *
      *
     C/exec SQL
     C+ fetch next
     C+ from AddTextC
     C+ into
     C+   :Member
     C+ , :ObjectType
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close AddTextC
     C/end-exec
      *
     C     AddTextE      ENDSR
      *
      *********************************************************************
      *                                                                   *
      *    UpdStatus - Set statuses to blank.                             *
      *                                                                   *
      *********************************************************************
     C     UpdStatus     BEGSR
      *
     C/exec SQL
     C+ update UPDLVCPD set
     C+   AUUSTS = ' '
     C/end-exec
      *
     C     UpdStatusE    ENDSR
      *
