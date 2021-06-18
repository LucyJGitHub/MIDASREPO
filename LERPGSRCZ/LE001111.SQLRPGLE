     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Initialise BckwrdLookng Rate Fld in Loans')   *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  LE001111 - Initialise Backward-Looking Rate Field in         *
      *              Loans File (CLE172 Take-On Program)               *
      *                                                               *
      *  Function:  This program will run during Post Database        *
      *             Upgrade. It will select all existing base rates   *
      *             from CLOANCL. Then, it will set the               *
      *             Backward-Looking rate fields into their default   *
      *             values if they do not initially contain values    *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD058321           Date 18Jun21               *
      *  Prev Amend No. CLE172    *CREATE  Date 01Oct20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058321 - Default Rates Known to 'N'                        *
      *  CLE172 - LIBOR Deregulation - Lending                        *
      *                                                               *
      *****************************************************************

      *****************************************************************
      /EJECT
      *****************************************************************

     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
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

      ** Program Variable
     D @RUN            S              1A

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Default the Backward-Looking Rate field to 'N'
      ** and Rates Know to 'N'                                                              MD058321

     C/EXEC SQL
     C+ update CLOANCL
     C**set*BLRT*=*'N',*OPSH*=*'N'*                                                         MD058321
     C+ set BLRT = 'N', OPSH = 'N', RTKN = 'N'                                              MD058321
     C+ where BLRT <> 'Y'
     C+ with nc
     C/END-EXEC

      ** Handle SQL Error

     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C/EXEC SQL
     C+ update HISTSHM
     C**set*BLRT*=*'N',*OPSH*=*'N'*                                                         MD058321
     C+ set BLRT = 'N', OPSH = 'N', RTKN = 'N'                                              MD058321
     C+ where BLRT <> 'Y'
     C+ with nc
     C/END-EXEC

      ** Handle SQL Error

     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C/EXEC SQL
     C+ update HISTSHN
     C**set*BLRT*=*'N',*OPSH*=*'N'*                                                         MD058321
     C+ set BLRT = 'N', OPSH = 'N', RTKN = 'N'                                              MD058321
     C+ where BLRT <> 'Y'
     C+ with nc
     C/END-EXEC

      ** Handle SQL Error

     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 3
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C/EXEC SQL
     C+ update HISTSHQ
     C**set*BLRT*=*'N',*OPSH*=*'N'*                                                         MD058321
     C+ set BLRT = 'N', OPSH = 'N', RTKN = 'N'                                              MD058321
     C+ where BLRT <> 'Y' and AMTP = 'RO'
     C+ with nc
     C/END-EXEC

      ** Handle SQL Error

     C                   IF        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 4
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

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

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
