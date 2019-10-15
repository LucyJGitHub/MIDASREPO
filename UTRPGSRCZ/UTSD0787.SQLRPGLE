000100191014     H DEBUG
000200191014     H COPYRIGHT('(c) Finastra International Limited 2016')
000300191014      *****************************************************************
000400191014/*STD *  RPGSQLBND                                                    *
000500191014/*EXI *  TEXT('Midas SD MD-53116 Utility program for T_GZCUSTEX')     *
000600191014      *****************************************************************
000700191014      *                                                               *
000800191014      *  Midas - Standing Data Module                                 *
000900191014      *                                                               *
001000191014      *  UTSD0784 - Midas SD MD-53116 Utility program for T_GZCUSTEX  *
001100191014      *                                                               *
001200191014      *  (c) Finastra International Limited 2016                      *
001300191014      *                                                               *
001400191014      *  Last Amend No. MD053116  *CREATE  Date 08Oct19               *
001500191014      *                                                               *
001600191014      *---------------------------------------------------------------*
001700191014      *                                                               *
001800191014      *  MD053116 - Customer Deactivated but not displayed as         *
001900191014      *             inactive.                                         *
002000191014      *                                                               *
002100191014      *****************************************************************
002200191014
002300191014     FSDCUSTLL  IF   E           K DISK    INFSR(*PSSR)
002400191014
002500191014     FUTSD0787P1O    E             PRINTER OFLIND(*IN25)
002600191014
002700191014      ** =======
002800191014      ** D-specs
002900191014      ** =======
003000191014
003100191014     D/COPY ZACPYSRC,STD_D_SPEC
003200191014
003300191014      ** External DS for Midas Modules Details
003400191014     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
003500191014
003600191014      ** Short Data Structure for Access Objects
003700191014     D DSFDY         E DS                  EXTNAME(DSFDY)
003800191014
003900191014      ** Long Data Structure for Access Objects
004000191014     D DSSDY         E DS                  EXTNAME(DSSDY)
004100191014
004200191014      ** Data Structure for Customer Master File
004300191014     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
004400191014
004500191014      ** Data Structure for Bank Details File
004600191014     D SDBANK        E DS                  EXTNAME(SDBANKPD)
004700191014
004800191014      ** +--------------------------------------+
004900191014      ** ¦ Declared variables                   ¦
005000191014      ** ¦ ==================                   ¦
005100191014      ** +--------------------------------------+
005200191014
005300191014
005400191014     D PRTCD           S              7
005500191014     D POPTN           S              7
005600191014     D PKEY1           S             10
005700191014     D PKYST           S              7
005800191014     D PMODE           S              7
005900191014     D WSTAT           S              1A
006000191014
006100191014      *****************************************************************
006200191014      /EJECT
006300191014      *****************************************************************
006400191014
006500191014     C                   EVAL      *IN10 = *OFF
006600191014     C                   IF        PMODE = 'A'
006700191014     C                             OR PMODE = 'a'
006800191014     C                   EVAL      *IN10 = *ON
006900191014     C                   ENDIF
007000191014
007100191014     C                   EXSR      SRCUSTSTAT
007200191014
007300191014     C                   EVAL      *INLR = *ON
007400191014     C                   RETURN
007500191014
007600191014      *****************************************************************
007700191014      /EJECT
007800191014      *****************************************************************
007900191014      *  SRCUSTSTAT - Patch Customer Status Routine            *
008000191014      *****************************************************************
008100191014
008200191014     C     SRCUSTSTAT    BEGSR
008300191014
008400191014     C     *LOVAL        SETLL     SDCUSTLL
008500191014     C                   READ      SDCUSTLL
008600191014
008700191014     C                   WRITE     UTSD0787H
008800191014     C                   WRITE     UTSD0787H2
008900191014
009000191014     C                   EVAL      WCTR  = 0
009100191014     C                   DOW       NOT %EOF(SDCUSTLL)
009200191014
009300191014     C                   EVAL      *IN11 = *OFF
009400191014     C                   IF        *IN25 = *ON
009500191014     C                   WRITE     UTSD0787H
009600191014     C                   WRITE     UTSD0787H2
009700191014     C                   EVAL      *IN25 = *OFF
009800191014     C                   ENDIF
009900191014
010000191014     C                   EVAL      WCUST = BBCUST
010100191014     C                   EVAL      WDEAC = BBDEAC
010200191014
010300191014     C/EXEC SQL
010400191014     C+ SELECT DDSTAT INTO :WSTAT FROM T_GZCUSTEX
010500191014     C+ WHERE DDCUSN = :WCUST
010600191014     C/END-EXEC
010700191014
010800191014     C                   IF        WSTAT = 'A'
010900191014     C                   EVAL      *IN11 = *ON
011000191014     C                   EVAL      WCTR +=1
011100191014     C                   ENDIF
011200191014
011300191014     C                   IF        *IN10 = *OFF
011400191014     C                             AND *IN11 = *ON
011500191014     C/EXEC SQL
011600191014     C+  UPDATE T_GZCUSTEX
011700191014     C+  SET DDSTAT = 'I'
011800191014     C+  WHERE DDCUSN = :WCUST
011900191014     C/END-EXEC
012000191014     C                   EVAL      WSTAT = 'I'
012100191014     C                   ENDIF
012200191014
012300191014     C                   WRITE     UTSD0787D
012400191014     C                   READ      SDCUSTLL
012500191014     C                   ENDDO
012600191014
012700191014     C                   IF        *IN25 = *ON
012800191014     C                   WRITE     UTSD0787H
012900191014     C                   WRITE     UTSD0787H2
013000191014     C                   EVAL      *IN25 = *OFF
013100191014     C                   ENDIF
013200191014     C                   WRITE     UTSD0787T
013300191014
013400191014     C                   IF        *IN25 = *ON
013500191014     C                   WRITE     UTSD0787H
013600191014     C                   WRITE     UTSD0787H2
013700191014     C                   EVAL      *IN25 = *OFF
013800191014     C                   ENDIF
013900191014     C                   WRITE     UTSD0787E
014000191014
014100191014     C                   ENDSR
014200191014
014300191014      *****************************************************************
014400191014      /EJECT
014500191014      *****************************************************************
014600191014      *  *INZSR - Program Initialisation routine                      *
014700191014      *****************************************************************
014800191014
014900191014     C     *INZSR        BEGSR
015000191014
015100191014     C     *ENTRY        PLIST
015200191014     C                   PARM                    PMODE
015300191014      *
015400191014      ** Get Module details
015500191014      *
015600191014     C                   CALL      'AOMMODR0'
015700191014     C                   PARM      *BLANKS       PRTCD
015800191014     C                   PARM      '*FIRST'      POPTN
015900191014     C     SDMMOD        PARM      SDMMOD        DSFDY
016000191014      *
016100191014      * Database error
016200191014      *
016300191014     C     PRTCD         IFNE      *BLANK
016400191014     C                   EVAL      DBKEY = POPTN
016500191014     C                   EVAL      DBFILE = 'SDMMODPD'
016600191014     C                   EVAL      DBASE = 001
016700191014     C                   EXSR      *PSSR
016800191014     C                   ENDIF
016900191014
017000191014      *
017100191014      ** Read Bank details via Access program
017200191014      *
017300191014     C                   CALL      'AOBANKR0'
017400191014     C                   PARM      '*MSG   '     PRTCD
017500191014     C                   PARM      '*KEY   '     POPTN
017600191014     C     SDBANK        PARM                    SDBANK
017700191014      *
017800191014      ** If record not found, exit via DBERR subroutine
017900191014      *
018000191014     C                   IF        PRTCD <> *Blanks
018100191014     C     *LOCK         IN        LDA
018200191014     C                   EVAL      DBPGM = 'UTSD0787'
018300191014     C                   EVAL      DBFILE = 'SDBANKPD'
018400191014     C                   EVAL      DBASE = 002
018500191014     C                   EVAL      DBKEY = POPTN
018600191014     C                   EXSR      *PSSR
018700191014     C                   ENDIF
018800191014      *
018900191014     C                   ENDSR
019000191014
019100191014      *****************************************************************
019200191014      /EJECT
019300191014      *****************************************************************
019400191014      *                                                               *
019500191014      * *PSSR  - Program exception error routine                      *
019600191014      *          Called automatically if a program error occurs,      *
019700191014      *          or directly by the program code using EXSR.          *
019800191014      *          This subroutine DUMPs the program just once.         *
019900191014      *                                                               *
020000191014      *****************************************************************
020100191014
020200191014     C     *PSSR         BEGSR
020300191014
020400191014     C                   DUMP
020500191014
020600191014     C                   EVAL      *INU7 = *ON
020700191014     C                   EVAL      *INU8 = *ON
020800191014     C                   EVAL      *INLR = *ON
020900191014
021000191014     C                   RETURN
021100191014
021200191014     C                   ENDSR
021300191014
021400191014      *****************************************************************
021500191014      /EJECT
021600191014      *****************************************************************
