     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Initialise CLE172 Fields in CLOANCL')         *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  LE001111 - Initialise CLE172 Fields in CLOANCL               *
      *                                                               *
      *  Function:  This program will run during Post Database        *
      *             Upgrade. It will select all existing base rates   *
      *             from CLOANCL. Then, it will set the               *
      *             Backward-Looking rate fields into their default   *
      *             values if they do not initially contain values    *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CLE172    *CREATE  Date 01Oct20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE172 - LIBOR Deregulation - Lending                        *
      *                                                               *
      *****************************************************************

     FLECLIPL2  UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANCKF)
      ** Midas LE Customer Loans File

      *****************************************************************
      /EJECT
      *****************************************************************

     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *

     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure

     D LoanDetails     DS
     D  LNRF                   1      6

     D @RUN            S              1A

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Key Fields for Loans File Access
     C     LELOANKEY     KLIST
     C                   KFLD                    LNRF

      ** Select all existing base rates

     C/EXEC SQL
     C+ declare LoanCursor insensitive scroll cursor for
     C+ select LNRF
     C+ from CLOANCL
     C/END-EXEC
      *
     C/EXEC SQL
     C+ open LoanCursor
     C/END-EXEC
      *
     C/EXEC SQL
     C+ fetch next from LoanCursor into :LoanDetails
     C/END-EXEC

     C                   DOW       SQLCOD <> 100

     C                   IF        SQLCODE <> 0 and
     C                             SQLCODE <> 100
     C                   EVAL      DBFILE = 'CLOANCL'
     C                   EVAL      DBKEY  = 'SQL ERROR'
     C                   EVAL      DBPGM  = 'LE001111'
     C                   EVAL      DBASE  = SQLCODE
     C                   EXSR      *PSSR
     C                   ENDIF

     C     LELOANKEY     CHAIN     LECLIPL2
     C                   IF        %FOUND(LECLIPL2)
     C     BLRT          IFNE      'Y'
     C                   EVAL      BLRT   = 'N'
     C                   UPDATE    CLOANCLF
     C                   ENDIF
     C                   ELSE
     C                   EVAL      DBFILE = 'LECLIPL2'
     C                   EVAL      DBKEY  = 'LOAN NOT FOUND'
     C                   EVAL      DBPGM  = 'LE001111'
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF

     C/EXEC SQL
     C+ fetch next from LoanCursor into :LoanDetails
     C/END-EXEC

     C                   ENDDO

     C/EXEC SQL
     C+ close LoanCursor
     C/END-EXEC

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
