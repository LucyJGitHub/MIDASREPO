     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas DL APR Calculation Take On')                     *
      *****************************************************************
      *                                                               *
      *   Midas - Dealing Module                                      *
      *                                                               *
      *  DL6010 - Utility program that calls APR Calculation pgm      *
      *           for all MM deals on DEALSDC                         *
      *                                                               *
      *  (C) Copyright Finastra International Limited 2016            *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050  *Create    Date 16Jun19               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percetage Rate (APR)                     *
      *                                                               *
      *****************************************************************
      *  Subroutine Index                                             *
      *                                                               *
      *  SRPROC - Processing.                                         *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D DEALDC        E DS                  EXTNAME(DEALSDC)
      *
      *****************************************************************
      *                                                               *
      *                       Main Processing                         *
      *                                                               *
      * CALLS      SRPROC   - Processing
      *                                                               *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    PDLNO             6
      *
      ** Define the LDA for error handling
     C     *DTAARA       DEFINE                  LDA
      *
     C                   EXSR      SRPROC
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
      ** If a deal is specified, calculate TAE for that record.
     C     PDLNO         Ifne      '*ALL'
      *
     C                   Move      PDLNO         DLKEY             6 0
      *
      ** Access deal and check that is not a Matured deal.
      *
     C/exec SQL
     C+ select *
     C+ into :DEALDC
     C+ from DEALSDC
     C+ where DLNO =:DLKEY
     C/end-exec

     C     SQLCOD        Ifeq      *Zeros
     C     RECI          andeq     'D'
      *
     C                   Call      'DLC6004'
     C                   Parm      *BLANK        ERRC              7
     C                   Parm                    PDLNO
      *
     C                   Endif
      *
      ** Otherwise, do for all records in DEALSDC.
     C                   Else
      *
     C/exec SQL
     C+ declare AllDl cursor for
     C+ Select * from DEALSDC
     C+ where RECI = 'D'
     C/end-exec

     C/exec SQL
     C+ open AllDl
     C/end-exec

      ** Handle SQL Error (if not %EOF)
     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf
      *
     C/exec SQL
     C+ fetch next
     C+ from AllDl
     C+ into :DEALDC
     C/end-exec

     C                   Dow       SQLCod <> 100

     C     RECI          Ifeq      'D'
     C                   Move      DLNO          PDLNO
     C                   Call      'DLC6004'
     C                   Parm      *BLANK        ERRC
     C                   Parm                    PDLNO
     C                   Endif
      *
     C/exec SQL
     C+ fetch next
     C+ from AllDl
     C+ into :DEALDC
     C/end-exec
     C                   Enddo

     C/exec SQL
     C+ close AllDl
     C/end-exec

     C                   Endif
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR: Program exception error routine. Called automatically  *
      *        if a program error occurs, or directly by the program  *
      *        code using EXSR. This subroutine DUMPs the program     *
      *        just once.                                             *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
      *
     C     DBASE         IFEQ      0
     C     *LOCK         IN        LDA
     C                   OUT       LDA
     C                   ENDIF
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
