     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE APR Calculation Take On')                     *
      *****************************************************************
      *                                                               *
      *   Midas - Customer Lending Module                             *
      *                                                               *
      *  LE6007 - Midas LE APR Calculation Take On                    *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CER050  *Create    Date 16Jun19               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate                          *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRPROC - Processing                                          *
      *                                                               *
      *****************************************************************
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      * Array containing Copyright statement
     D ARRCPY          S             80    DIM(1) CTDATA PERRCD(1)
      *
      * External DS for Midas LE Customer loans
     D CLOAN1        E DS                  EXTNAME(CLOANCL)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            M A I N   P R O C E S S I N G                      *
      *                                                               *
      * Calls: SRPROC - Processing                                    *
      *                                                               *
      *****************************************************************
      *
      * Entry parameter
     C     *ENTRY        PLIST
     C                   PARM                    PILNNO            6
      *
      * Set up copyright parameter
     C                   MOVEA     ARRCPY        WCPY             80
      *
     C                   EXSR      SRPROC
      *
      * End program
     C                   SETON                                        LR
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRPROC - Processing                                           *
      * Calls:                                                        *
      * Called by: Main Processing                                    *
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
      * If a loan is specified, calculate APR for that record
     C     PILNNO        IFNE      '*ALL'
      *
      ** Set file pointer to first record of CLOANCL
      *
     C/exec SQL
     C+ declare LIST1 cursor for
     C+ select * from CLOANCL
     C+ where LNRF = :PILNNO
     C+ and RECI = 'D'
     C+ order by LNRF, RCDT
     C/end-exec
      *
     C/exec SQL
     C+ open LIST1
     C/end-exec
      *
      ** Handle SQL Error (If not %EOF)
     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   Eval      DBASE = 1
     C                   Eval      DBFILE = 'SQL STM'
     C                   Eval      DBKEY  = 'SQLSTT : ' + SQLSTT
     C                                    + '; SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from LIST1
     C+ into: CLOAN1
     C/end-exec
      *
     C                   IF        SQLCode <> 100
      *
     C                   CALL      'LEC6002'
     C                   PARM      *BLANK        PERRC             7
     C                   PARM                    PILNNO
     C                   ENDIF
      *
      * Otherwise, do for all records in DEALSDC
     C                   ELSE
      *
      ** Set file pointer to first record of MCLONCL
      *
     C/exec SQL
     C+ declare LIST2 cursor for
     C+ select * from CLOANCL
     C+ where RECI = 'D'
     C+ order by LNRF, RCDT
     C/end-exec
      *
     C/exec SQL
     C+ open LIST2
     C/end-exec
      *
      ** Handle SQL Error (If not %EOF)
     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   Eval      DBASE = 2
     C                   Eval      DBFILE = 'SQL STM'
     C                   Eval      DBKEY  = 'SQLSTT : ' + SQLSTT
     C                                    + '; SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from LIST2
     C+ into: CLOAN1
     C/end-exec
      *
     C                   Dow       SQLCode <> 100
      *
     C                   MOVE      LNRF          PILNNO
     C                   CALL      'LEC6002'
     C                   PARM      *BLANK        PERRC
     C                   PARM                    PILNNO
      *
     C/exec SQL
     C+ fetch next
     C+ from LIST2
     C+ into: CLOAN1
     C/end-exec
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - HANDLE ABNORMAL ERROR CONDITIONS                      *
      * Calls:                                                        *
      * Called by: SRPROC Processing                                  *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR **
      *
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   ENDSR                                                  ** *PSSR **
      *****************************************************************
** ARRCPY
(c) Finastra International Limited 2016
