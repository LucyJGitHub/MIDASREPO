     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE APR Update program for Base Rate')            *
      *****************************************************************
      *                                                               *
      *   Midas - Customer Lending Module                             *
      *                                                               *
      *  LE6008 - Midas LE APR Update program for Base Rate Changes   *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050  *Create    Date 16Jun19               *
      *                 xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CER050 - Annualized Percentage Rate                          *
      *                                                               *
      *****************************************************************
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  83 - No record found on LEACT5L5                             *
      *  U7 - Standard Midas usage                                    *
      *  U8 - Standard Midas usage                                    *
      *                                                               *
      *****************************************************************
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      * External DS for Midas LE Action File Detail
     D ACTN5         E DS                  EXTNAME(ACTN5DK)
      *
      * Array containing Copyright statement
     D ARRCPY          S             80    DIM(1) CTDATA PERRCD(1)
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            M A I N   P R O C E S S I N G                      *
      *                                                               *
      *****************************************************************
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CER050'      PSARD             6
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
      * Set up copyright parameter
     C                   MOVEA     ARRCPY        WCPY             80
      *
      * Initialise Error code
     C                   MOVE      *BLANKS       PERRC             7
      *
      ** Set file pointer to first record of MCLONCL
      *
     C/exec SQL
     C+ declare LIST1 cursor for
     C+ select * from ACTN5DK
     C+ where AMTP = 'BR'
     C+    or AMTP = 'RO'
     C+ order by LNRF
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
     C+ into: ACTN5
     C/end-exec
      *
     C                   Dow       SQLCode <> 100
     C                             and PERRC = *Blanks
      *
     C                   MOVE      LNRF          PILNNO            6
     C                   CALL      'LEC6002'
     C                   PARM                    PERRC
     C                   PARM                    PILNNO
      *
     C/exec SQL
     C+ fetch next
     C+ from LIST1
     C+ into: ACTN5
     C/end-exec
     C                   ENDDO
      *
     C/exec SQL
     C+ close LIST1
     C/end-exec
      *
      * If error was found set ON indicators U7 & U8
     C     PERRC         IFNE      *BLANK
     C                   SETON                                        U7U8
     C                   ENDIF
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - HANDLE ABNORMAL ERROR CONDITIONS                      *
      * Calls:                                                        *
      * Called by: Main Processing                                    *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR **
      *
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   END
      *
     C                   SETON                                        U7
     C                   SETON                                        U8
     C                   DUMP
      *
     C                   ENDSR                                                  ** *PSSR **
      *****************************************************************
** ARRCPY
(c) Finastra International Limited 2016
