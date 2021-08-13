000100000000     H DEBUG
000200000000     H COPYRIGHT('(c) Finastra International Limited 2021')
000300000000      *****************************************************************
000400000000/*STD *  RPGSQLBND                                                    *
000500000000/*EXI *  TEXT('Midas FN Retrieve TDRF From Tradsd using FRNT')        *
000600000000      *****************************************************************
000700000000      *                                                               *
000800000000      *  Midas - System Control Module                                *
000900000000      *                                                               *
001000000000      *  A1008007  - Midas FN Retrieve TDRF From Tradsd using FRNT    *
001100000000      *                                                               *
001200000000      *  Function:  This program retrieve TDRF From TRADSD using FRNT *
001300000000      *  Called By: A1008002 and xx008006                             *
001500000000      *                                                               *
001600000000      *  (c) Finastra Internationl Limited 2021                       *
001700000000      *                                                               *
001800000000      *  Last Amend No. BA1008   *CREATE   Date 03Jun21               *
002000000000      *                                                               *
002100000000      *---------------------------------------------------------------*
002200000000      *                                                               *
002201000000      *  BA1008 - Replication of Trades to consolidated Branches      *
002500000000      *                                                               *
002600000000      *****************************************************************
002700000000      *                                                               *
002800000000      *  Use of indicators.                                           *
002900000000      *                                                               *
003000000000      *    XX         Function of Indicator                           *
003100000000      *    98         Date Format                                     *
003200000000      *    99         Found Action Code Record                        *
003300000000      *                                                               *
003400000000      *****************************************************************
003500000000      *                                                               *
003600000000      *  S U B R O U T I N E  I N D E X                               *
003700000000      *                                                               *
003800000000      * *PSSR - Error processing                                      *
003900000000      * *INZSR - Initialise                                           *
004000000000      *                                                               *
004100000000      *    The *INZSR subroutine will only get called automatically   *
004200000000      *    on entry to the module the first time it is run            *
004300000000      *    (unless you end the program with LR on).  Similarly        *
004400000000      *    D-spec initialisation only happens the first time.  Use    *
004500000000      *    RESET for subsequent passes.                               *
004600000000      *                                                               *
004700000000      *****************************************************************
004800000000      ** +--------------------------------------+
004900000000      ** ¦ F-specs                              ¦
005000000000      ** ¦ =======                              ¦
005100000000      ** +--------------------------------------+
005200000000
005300000000      *****************************************************************
005400000000      /EJECT
005500000000      *****************************************************************
005600000000      ** +--------------------------------------+
005700000000      ** ¦ D-specs                              ¦
005800000000      ** ¦ =======                              ¦
005900000000      ** +--------------------------------------+
006000000000      ** Dynamic SQL statement work field
006100000000     D WSTRSQL         S           1000A   INZ(*BLANKS)
006200000000      *
006300000000     D Traderef        S              6
006400000000     D FRNkey          S             20
006500000000     D Branch          S              3
006600000000     D ReturnCodex     S              7
006700000000      *
006800000000     D LDA           E DS           256    EXTNAME(LDA)
006900000000      *
007000000000      ** Local data area for database error details
007100000000      ** *LOCK IN LDA immediately before and OUT LDA immediately
007200000000      ** after each database error handling.
007300000000      **
007400000000      **                                    134 141 DBFILE
007500000000      **       Defines:                     142 170 DBKEY
007600000000      **                                    171 180 DBPGM
007700000000      **                                    181 1830DBASE
007800000000      *
007900000000      ** Data Area giving Installation Control Details
008000000000
008100000000      ** The following /COPY line includes all the defined fields in the
008200000000      ** PSDS.  They have meaningful names, prefixed by 'PS'.
008300000000
008400000000     D/COPY ZACPYSRC,PSDS
008500000000      *
008600000000      ** Program Status Data Structure
008700000000      *
008800000000      ** +-----------------------------------------------------------------+
008900000000      ** D specs of the following types should be inserted after the
009000000000      ** relevant box.  *** Remove this text afterwards. ***
009100000000      ** +-----------------------------------------------------------------+
009200000000
009300000000      ** +--------------------------------------+
009400000000      ** ¦ Named constants                      ¦
009500000000      ** ¦ ===============                      ¦
009600000000      ** +--------------------------------------+
009700000000
009800000000      ** +--------------------------------------+
009900000000      ** ¦ Arrays and Data Structures           ¦
010000000000      ** ¦ ==========================           ¦
010100000000      ** +--------------------------------------+
010200000000
010300000000     DDSSDY          E DS
010400000000
010500000000
010600000000      ** +--------------------------------------+
010700000000      ** ¦ Declared variables                   ¦
010800000000      ** ¦ ==================                   ¦
010900000000      ** +--------------------------------------+
011000000000
011100000000     D @RUN            S              1
011200000000      *****************************************************************
011300000000      /EJECT
011400000000      *****************************************************************
011500000000      *
011600000000      ** +--- Start of Main processing -----------------------------------+
011700000000      ** ¦                                                                ¦
011800000000      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
011900000000      ** ¦ executed at program activation.                                ¦
012000000000      ** ¦                                                                ¦
012100000000      ** +----------------------------------------------------------------+
012200000000
012300000000      *********************************************************************
012400000000      * MAIN PROCEDURE                                                    *
012500000000      *********************************************************************
012600000000      *
012700000000      ** Read in Installation Data
012800000000      *
012900000000     C     *DTAARA       DEFINE                  LDA
013000000000
013100000000      *
013200000000     C/EXEC SQL
013300000000     C+ select TDRF into :Traderef  from TRADSD
013400000000     C+ where
013500000000     C+   TDBA   = :Branch
013600000000     C+ and FRNT = :FRNkey                                                                  AR989143
013700000000     C/END-EXEC                                                                             AR989143
013800000000      *                                                                                     AR989143
013900000000     C                   Eval      ReturnCodex = *Blanks
014000000000     C                   IF        SQLCOD = 100
014100000000     C                   MOVEL     'NRF'         ReturnCodex
014200000000     C                   Endif
014300000000     C                   IF        SQLCOD <> 0  And SQLCOD <> 100  and
014400000000     C                             SQLCOD <> -802
014500000000     C                   MOVEL     'RPGETRADFO'  DBPGM
014600000000     C                   MOVEL     'TRADSD    '  DBFILE
014700000000     C                   MOVEL     '001'         DBASE
014800000000     C                   MOVEL     FRNkey        DBKEY
014900000000     C                   MOVEL     'ERR'         ReturnCodex
015000000000     C                   DUMP
015100000000      *
015300000000     C                   ENDIF
015400000000     C                   EVAL      *INLR = *ON
015600000000     C                   RETURN
015700000000      *****************************************************************
015800000000      /EJECT
015900000000      *****************************************************************
016000000000      *                                                               *
016100000000      * *INZSR - Program Initialisation routine                       *
016200000000      *                                                               *
016300000000      * Called by: Implicitly on program activation                   *
016400000000      *                                                               *
016500000000      * Calls: None                                                   *
016600000000      *                                                               *
016700000000      *****************************************************************
016800000000
016900000000     C     *INZSR        BEGSR
017000000000
017100000000     C     *entry        PLIST
017200000000     C                   PARM                    FRNkey
017300000000     C                   PARM                    Branch
017400000000     C                   PARM                    Traderef
017500000000     C                   PARM                    ReturnCodex
017600000000
017700000000     C                   ENDSR
017800000000      *
017900000000      /EJECT
018000000000      *****************************************************************
018100000000      *                                                               *
018200000000      * *PSSR  - Program exception error routine                      *
018300000000      *          Called automatically if a program error occurs,      *
018400000000      *          or directly by the program code using EXSR.          *
018500000000      *          This subroutine DUMPs the program just once.         *
018600000000      *                                                               *
018700000000      * Called by: (**calling routines**)                             *
018800000000      *                                                               *
018900000000      * Calls: None                                                   *
019000000000      *                                                               *
019100000000      *****************************************************************
019200000000      *
019300000000     C     *PSSR         BEGSR
019400000000      *
019500000000     C                   IF        @RUN = *BLANK
019600000000     C                   EVAL      @RUN = 'Y'
019700000000     C                   DUMP
019800000000      *
019900000000     C                   CALL      'DBERRCTL'
020000000000      *
020100000000     C                   ENDIF
020200000000      *
020300000000     C                   EVAL      *INU7 = *ON
020400000000     C                   EVAL      *INU8 = *ON
020500000000     C                   EVAL      *INLR = *ON
020600000000     C                   RETURN
020700000000      *
020800000000     C                   ENDSR
020900000000      *
