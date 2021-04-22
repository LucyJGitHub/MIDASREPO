     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas DL APR Update Pgm for DL Base Rate Changes')     *
      *****************************************************************
      *                                                               *
      *   Midas - Dealing Module                                      *
      *                                                               *
      *  DL6011 - Update program that calculates APR rates for        *
      *           deals with Base Rate changes.                       *
      *                                                               *
      *  (C) Copyright Finastra International Limited 2016            *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050  *Create    Date 16Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  CER050 - Annualised Percentage Rate (APR)                    *
      *                                                               *
      *****************************************************************
      *  Indicators Index                                             *
      *                                                               *
      *  83 - ON if CHAIN to DAMBRDI failed                           *
      *  U7 - Standard Midas usage                                    *
      *  U8 - Standard Midas usage                                    *
      *                                                               *
      *****************************************************************
      *
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
     D DAMBR         E DS                  EXTNAME(DAMBRDI)
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  LCDSAR       E                     EXTFLD(LCD)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                       Main Processing                         *
      *                                                               *
      *****************************************************************
      *
      ** Define the LDA for error handling
     C     *DTAARA       DEFINE                  LDA
      *
     C/exec SQL
     C+ select *
     C+ into :SCSARD
     C+ from SCSARDPD
     C+ where SARN = 'CER050'
     C/end-exec

     C     SQLCOD        Ifne      *Zeros
     C                   Seton                                        LR
     C                   Return
     C                   Endif
      *
      ** Initialise error code.
     C                   MOVE      *BLANK        PERRC             7
      *
      ** Read through Base Rate Change File.
      *
     C/exec SQL
     C+ declare BasRat cursor for
     C+ Select * from DAMBRDI
     C/end-exec

     C/exec SQL
     C+ open BasRat
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

     C/exec SQL
     C+ fetch next
     C+ from BasRat
     C+ into :DAMBR
     C/end-exec

     C                   Dow       SQLCod <> 100
      *                            and PERRC = *Blanks
      *
     C                   Move      DLNO          PDlno             6
      *
     C                   CALL      'DLC6004'
     C                   Parm                    PErrc
     C                   Parm                    PDlno
      *
      ** Read next record in file.

     C/exec SQL
     C+ fetch next
     C+ from BasRat
     C+ into :DAMBR
     C/end-exec
     C                   ENDDO

     C/exec SQL
     C+ close BasRat
     C/end-exec
      *
      ** Set ON indicators U7 & U8 if error occurred.
     C     PERRC         Ifne      *Blank
     C                   SetOn                                        U7U8
     C                   Endif
      *
     C                   Seton                                        LR
     C                   Return
      *
      *****************************************************************
      *                                                               *
      *  SUBROUTINE : *PSSR  -  Error handling subroutine             *
      *                                                               *
      *  CALLED BY  : This routine is called if there are any program *
      *               or file errors.                                 *
      *                                                               *
      *  CALLS      : none                                            *
      *                                                               *
      *  FIELDS USED: @RUN                                            *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          Ifeq      *BLANK
     C                   Move      'Y'           @RUN              1
     C                   Dump
     C                   Endif
      *
     C                   Move      *On           *Inu7
     C                   Move      *On           *Inu8
     C                   Move      *On           *Inlr
     C                   Return
      *
     C                   ENDSR
      *
     C*****************************************************************
