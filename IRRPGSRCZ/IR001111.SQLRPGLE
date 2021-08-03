000100210803     H DEBUG
000101210803     H COPYRIGHT('(c) Finastra International Limited 2021')
000102210803      *****************************************************************
000103210803/*STD *  RPGSQLBND                                                    *
000104210803/*EXI *  TEXT('Midas IR Initialise BckwrdLookng Rate Fld in Deals')   *
000105210803      *****************************************************************
000106210803      *                                                               *
000107210803      *  Midas - Implementation Module                                *
000108210803      *                                                               *
000109210803      *  IR001111 - Initialise Backward-Looking Rate Field in         *
000110210803      *              Deals File (CIR020 Take-On Program)              *
000111210803      *                                                               *
000112210803      *  Function:  This program will run during Post Database        *
000113210803      *             Upgrade. It will select all existing base rates   *
000114210803      *             from Deals File. Then, it will set the            *
000115210803      *             Backward-Looking rate fields into their default   *
000116210803      *             values if they do not initially contain values    *
000117210803      *                                                               *
000118210803      *  (c) Finastra International Limited 2021                      *
000119210803      *                                                               *
000120210803      *  Last Amend No. CIR020    *CREATE  Date 02Aug21               *
000121210803      *                                                               *
000122210803      *---------------------------------------------------------------*
000123210803      *                                                               *
000124210803      *  CIR020 - LIBOR Deregulation - IRS                            *
000125210803      *                                                               *
000126210803      *****************************************************************
000127210803
000128210803      *****************************************************************
000129210803      /EJECT
000130210803      *****************************************************************
000131210803
000132210803     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
000133210803      ** Local data area for database error details
000134210803      ** *LOCK IN LDA immediately before and OUT LDA immediately
000135210803      ** after each database error handling.
000136210803      **                                    134 141 DBFILE
000137210803      **       Defines:                     142 170 DBKEY
000138210803      **                                    171 180 DBPGM
000139210803      **                                    181 1830DBASE
000140210803      *
000141210803
000142210803     D/COPY ZACPYSRC,PSDS
000143210803      ** Program Status Data Structure
000144210803
000145210803      ** Program Variable
000146210803     D @RUN            S              1A
000147210803
000148210803      *****************************************************************
000149210803      /EJECT
000150210803      *****************************************************************
000151210803
000152210803      ** ---------------------------------------------- **
000153210803      ** Default the Backward-Looking Rate field to 'N' **
000154210803      ** ---------------------------------------------- **
000155210803
000156210803      ** GZDEALSDG **
000157210803     C/EXEC SQL
000158210803     C+ update GZDEALSDG
000159210803     C+ set UBLRT = 'N', URTKN = 'N', UOPSH = 'N', TBLRT = 'N', TRTKN = 'N'
000160210803     C+     , TOPSH = 'N'
000161210803     C+ where UBLRT <> 'Y' OR  TBLRT <> 'Y'
000162210803     C+ with nc
000163210803     C/END-EXEC
000164210803
000165210803      ** Handle SQL Error
000166210803
000167210803     C                   IF        SQLCOD < 0
000168210803     C     *LOCK         IN        LDA
000169210803     C                   EVAL      DBASE = 1
000170210803     C                   EVAL      DBFILE = 'SQL STM'
000171210803     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
000172210803     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
000173210803     C                   OUT       LDA
000174210803     C                   EXSR      *PSSR
000175210803     C                   ENDIF
000176210803
000177210803      ** DEALSDG **
000178210803     C/EXEC SQL
000179210803     C+ update DEALSDG
000180210803     C+ set UBLRT = 'N', URTKN = 'N', UOPSH = 'N', TBLRT = 'N', TRTKN = 'N'
000181210803     C+     , TOPSH = 'N'
000182210803     C+ where UBLRT <> 'Y' OR  TBLRT <> 'Y'
000183210803     C+ with nc
000184210803     C/END-EXEC
000185210803
000186210803      ** Handle SQL Error
000187210803
000188210803     C                   IF        SQLCOD < 0
000189210803     C     *LOCK         IN        LDA
000190210803     C                   EVAL      DBASE = 2
000191210803     C                   EVAL      DBFILE = 'SQL STM'
000192210803     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
000193210803     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
000194210803     C                   OUT       LDA
000195210803     C                   EXSR      *PSSR
000196210803     C                   ENDIF
000197210803
000198210803      ** GZDLGHISPD **
000199210803     C/EXEC SQL
000200210803     C+ update GZDLGHISPD
000201210803     C+ set UBLRT = 'N', URTKN = 'N', UOPSH = 'N', TBLRT = 'N', TRTKN = 'N'
000202210803     C+     , TOPSH = 'N'
000203210803     C+ where UBLRT <> 'Y' OR  TBLRT <> 'Y'
000204210803     C+ with nc
000205210803     C/END-EXEC
000206210803
000207210803      ** Handle SQL Error
000208210803
000209210803     C                   IF        SQLCOD < 0
000210210803     C     *LOCK         IN        LDA
000211210803     C                   EVAL      DBASE = 3
000212210803     C                   EVAL      DBFILE = 'SQL STM'
000213210803     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
000214210803     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
000215210803     C                   OUT       LDA
000216210803     C                   EXSR      *PSSR
000217210803     C                   ENDIF
000218210803
000219210803      ** DLGHISPD **
000220210803     C/EXEC SQL
000221210803     C+ update DLGHISPD
000222210803     C+ set UBLRT = 'N', URTKN = 'N', UOPSH = 'N', TBLRT = 'N', TRTKN = 'N'
000223210803     C+     , TOPSH = 'N'
000224210803     C+ where UBLRT <> 'Y' OR  TBLRT <> 'Y'
000225210803     C+ with nc
000226210803     C/END-EXEC
000227210803
000228210803      ** Handle SQL Error
000229210803
000230210803     C                   IF        SQLCOD < 0
000231210803     C     *LOCK         IN        LDA
000232210803     C                   EVAL      DBASE = 4
000233210803     C                   EVAL      DBFILE = 'SQL STM'
000234210803     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
000235210803     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
000236210803     C                   OUT       LDA
000237210803     C                   EXSR      *PSSR
000238210803     C                   ENDIF
000239210803
000240210803     C                   EVAL      *INLR = *ON
000241210803     C                   RETURN
000242210803
000243210803      *****************************************************************
000244210803      /EJECT
000245210803      *****************************************************************
000246210803      *                                                               *
000247210803      * *PSSR  - Program exception error routine                      *
000248210803      *          Called automatically if a program error occurs,      *
000249210803      *          or directly by the program code using EXSR.          *
000250210803      *          This subroutine DUMPs the program just once.         *
000251210803      *                                                               *
000252210803      * Called by: (**calling routines**)                             *
000253210803      *                                                               *
000254210803      * Calls: None                                                   *
000255210803      *                                                               *
000256210803      *****************************************************************
000257210803     C     *PSSR         BEGSR
000258210803
000259210803     C                   IF        @RUN = *BLANK
000260210803     C                   EVAL      @RUN = 'Y'
000261210803     C                   DUMP
000262210803     C                   ENDIF
000263210803
000264210803     C                   EVAL      *INU7 = *ON
000265210803     C                   EVAL      *INU8 = *ON
000266210803     C                   EVAL      *INLR = *ON
000267210803     C                   RETURN
000268210803
000269210803     C                   ENDSR
000270210803      *****************************************************************
