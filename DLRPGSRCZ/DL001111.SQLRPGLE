000100210605     H DEBUG
000101210605     H COPYRIGHT('(c) Finastra International Limited 2021')
000102210605      *****************************************************************
000103210605/*STD *  RPGSQLBND                                                    *
000104210607/*EXI *  TEXT('Midas DL Initialise BckwrdLookng Rate Fld in Deals')   *
000105210605      *****************************************************************
000106210605      *                                                               *
000107210605      *  Midas - Implementation Module                                *
000108210605      *                                                               *
000109210605      *  DL001111 - Initialise Backward-Looking Rate Field in         *
000110210607      *              Deals File (CDL102 Take-On Program)              *
000111210605      *                                                               *
000112210605      *  Function:  This program will run during Post Database        *
000113210605      *             Upgrade. It will select all existing base rates   *
000114210605      *             from Deals File. Then, it will set the            *
000115210605      *             Backward-Looking rate fields into their default   *
000116210605      *             values if they do not initially contain values    *
000117210605      *                                                               *
000118210605      *  (c) Finastra International Limited 2021                      *
000119210605      *                                                               *
000120210605      *  Last Amend No. CDL102    *CREATE  Date 01Jun21               *
000121210605      *                                                               *
000122210605      *---------------------------------------------------------------*
000123210605      *                                                               *
000124210605      *  CDL102 - LIBOR Deregulation - Dealing                        *
000125210605      *                                                               *
000126210605      *****************************************************************
000127210605
000128210605      *****************************************************************
000129210605      /EJECT
000130210605      *****************************************************************
000131210605
000132210605     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
000133210605      ** Local data area for database error details
000134210605      ** *LOCK IN LDA immediately before and OUT LDA immediately
000135210605      ** after each database error handling.
000136210605      **                                    134 141 DBFILE
000137210605      **       Defines:                     142 170 DBKEY
000138210605      **                                    171 180 DBPGM
000139210605      **                                    181 1830DBASE
000140210605      *
000141210605
000142210605     D/COPY ZACPYSRC,PSDS
000143210605      ** Program Status Data Structure
000144210605
000145210605      ** Program Variable
000146210605     D @RUN            S              1A
000147210605
000148210605      *****************************************************************
000149210605      /EJECT
000150210605      *****************************************************************
000151210607
000152210607      ** ---------------------------------------------- **
000153210607      ** Default the Backward-Looking Rate field to 'N' **
000154210607      ** ---------------------------------------------- **
000155210605
000156210607      ** MMDELDPP **
000157210605     C/EXEC SQL
000158210605     C+ update MMDELDPP
000159210605     C+ set BLRT = 'N', RTKN = 'N', OPSH = 'N'
000160210605     C+ where BLRT <> 'Y'
000161210605     C+ with nc
000162210605     C/END-EXEC
000163210605
000164210605      ** Handle SQL Error
000165210605
000166210605     C                   IF        SQLCOD < 0
000167210605     C     *LOCK         IN        LDA
000168210605     C                   EVAL      DBASE = 1
000169210605     C                   EVAL      DBFILE = 'SQL STM'
000170210605     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
000171210605     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
000172210605     C                   OUT       LDA
000173210605     C                   EXSR      *PSSR
000174210605     C                   ENDIF
000175210607
000176210607      ** DEALSDC **
000177210605     C/EXEC SQL
000178210605     C+ update DEALSDC
000179210605     C+ set BLRT = 'N', RTKN = 'N', OPSH = 'N'
000180210605     C+ where BLRT <> 'Y'
000181210605     C+ with nc
000182210605     C/END-EXEC
000183210605
000184210605      ** Handle SQL Error
000185210605
000186210605     C                   IF        SQLCOD < 0
000187210605     C     *LOCK         IN        LDA
000188210605     C                   EVAL      DBASE = 2
000189210605     C                   EVAL      DBFILE = 'SQL STM'
000190210605     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
000191210605     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
000192210605     C                   OUT       LDA
000193210605     C                   EXSR      *PSSR
000194210605     C                   ENDIF
000195210605
000196210607      ** MMDEAMPP **
000197210605     C/EXEC SQL
000198210605     C+ update MMDEAMPP
000199210605     C+ set BLRT = 'N', OPSH = 'N'
000200210605     C+ where BLRT <> 'Y'
000201210605     C+ with nc
000202210605     C/END-EXEC
000203210605
000204210605      ** Handle SQL Error
000205210605
000206210605     C                   IF        SQLCOD < 0
000207210605     C     *LOCK         IN        LDA
000208210605     C                   EVAL      DBASE = 3
000209210605     C                   EVAL      DBFILE = 'SQL STM'
000210210605     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
000211210605     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
000212210605     C                   OUT       LDA
000213210605     C                   EXSR      *PSSR
000214210605     C                   ENDIF
000215210605
000216210607      ** DEAMSDI **
000217210605     C/EXEC SQL
000218210605     C+ update DEAMSDI
000219210605     C+ set BLRT = 'N', OPSH = 'N'
000220210605     C+ where BLRT <> 'Y'
000221210605     C+ with nc
000222210605     C/END-EXEC
000223210605
000224210605      ** Handle SQL Error
000225210605
000226210605     C                   IF        SQLCOD < 0
000227210605     C     *LOCK         IN        LDA
000228210605     C                   EVAL      DBASE = 4
000229210605     C                   EVAL      DBFILE = 'SQL STM'
000230210605     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
000231210605     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
000232210605     C                   OUT       LDA
000233210605     C                   EXSR      *PSSR
000234210605     C                   ENDIF
000235210605
000252210605     C                   EVAL      *INLR = *ON
000253210605     C                   RETURN
000254210605
000255210605      *****************************************************************
000256210605      /EJECT
000257210605      *****************************************************************
000258210605      *                                                               *
000259210605      * *PSSR  - Program exception error routine                      *
000260210605      *          Called automatically if a program error occurs,      *
000261210605      *          or directly by the program code using EXSR.          *
000262210605      *          This subroutine DUMPs the program just once.         *
000263210605      *                                                               *
000264210605      * Called by: (**calling routines**)                             *
000265210605      *                                                               *
000266210605      * Calls: None                                                   *
000267210605      *                                                               *
000268210605      *****************************************************************
000269210605     C     *PSSR         BEGSR
000270210605
000271210605     C                   IF        @RUN = *BLANK
000272210605     C                   EVAL      @RUN = 'Y'
000273210605     C                   DUMP
000274210605     C                   ENDIF
000275210605
000276210605     C                   EVAL      *INU7 = *ON
000277210605     C                   EVAL      *INU8 = *ON
000278210605     C                   EVAL      *INLR = *ON
000279210605     C                   RETURN
000280210605
000281210605     C                   ENDSR
000282210605      *****************************************************************
