     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT Retrieve member text from source')            *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000060 - Retrieve member text from source                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CUP042  *CREATE    Date 27May15               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CUP042 - Retrieve member text from source                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     D PMode           S              3
     D PText           S             50
      *
     D CodeLine        S            100
     D FoundPos        S              2  0
     D StartPos        S              2  0
     D Quote           S              1    INZ('''')
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMode
     C                   PARM                    PText
      *
     C                   EVAL      PText = *blanks
      *
     C                   IF        PMode = 'RPG'
      ** Select EXI lines from code.
     C/exec SQL
     C+ declare RPGC cursor for
     C+ select
     C+   SRCDTA
     C+ from INPSRC
     C+ where
     C+     substr(SRCDTA, 2, 4) = '*EXI'
     C+ or  substr(SRCDTA, 2, 4) = '*E*I'
     C/end-exec
      *
     C/exec SQL
     C+ open RPGC
     C/end-exec
      *
     C/exec SQL
     C+ fetch next from RPGC
     C+ into
     C+   :CodeLine
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      ** Search for text string.
     C                   EVAL      FoundPos = %SCAN('TEXT(':CodeLine)
     C                   IF        FoundPos <> 0
     C                   EVAL      StartPos = FoundPos + 6
     C                   EVAL      FoundPos = %SCAN(')':CodeLine:StartPos)
     C                   EVAL      PText = %SUBST(CodeLine:StartPos:
     C                             (FoundPos - StartPos - 1))
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next from RPGC
     C+ into
     C+   :CodeLine
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close RPGC
     C/end-exec
     C                   ENDIF
      *
     C                   IF        PMode = 'SQL'
      ** Select ' is ' lines from code.
     C/exec SQL
     C+ declare SQLC cursor for
     C+ select
     C+   SRCDTA
     C+ from INPSRC
     C+ where
     C+     substr(SRCDTA, 4, 4) = ' is '
     C/end-exec
      *
     C/exec SQL
     C+ open SQLC
     C/end-exec
      *
     C/exec SQL
     C+ fetch next from SQLC
     C+ into
     C+   :CodeLine
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      ** Search for text string.
     C                   EVAL      FoundPos = %SCAN(Quote:CodeLine)
     C                   IF        FoundPos <> 0
     C                   EVAL      StartPos = FoundPos + 1
     C                   EVAL      FoundPos = %SCAN(Quote:CodeLine:StartPos)
     C                   EVAL      PText = %SUBST(CodeLine:StartPos:
     C                             (FoundPos - StartPos))
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next from SQLC
     C+ into
     C+   :CodeLine
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close SQLC
     C/end-exec
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *
