     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Resequence numbers for Action File')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade module                                       *
      *                                                               *
      *  UP009012 - Resequence numbers for Action Files               *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. A1084804 *CREATE   Date 01Feb13               *
      *  Prev Amend No. xxxxxxxx           Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  A1084804 - Add *MRG option.                                  *
      *                                                               *
      *****************************************************************
      *
     D SaveFile        S             10
     D ResetSeq        S              6  0
     D Recursive       S              1    INZ('N')
      *
     D AFCP          E DS                  EXTNAME(UPAFCPPD)
      *
      * Start reading through the Action File.
     C/exec SQL
     C+ declare AFCursor cursor for
     C+ select * from UPAFCPPD
     C+ order by
     C+   ATFILE
     C+ for update of
     C+   ATNUMB
     C/end-exec
      *
     C/exec SQL
     C+ open AFCursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from AFCursor
     C+ into: AFCP
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      * If a new file is found then find key fields position and length.
     C                   IF        ATFILE <> SaveFile
     C                   EVAL      ResetSeq = 1
     C                   EVAL      SaveFile = ATFILE
     C                   ELSE
     C                   EVAL      ResetSeq = ResetSeq + 1
     C                   ENDIF
      *
     C/exec SQL
     C+ update UPAFCPPD
     C+ set
     C+    ATNUMB = :ResetSeq
     C+ where
     C+    current of AFCursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from AFCursor
     C+ into: AFCP
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close AFCursor
     C/end-exec
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
