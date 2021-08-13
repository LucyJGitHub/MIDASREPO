000100000000     H DEBUG
000200000000     H COPYRIGHT('(c) Finastra International Limited 2021')
000300000000      *****************************************************************
000400000000/*STD *  RPGSQLBND                                                    *
000500000000/*EXI *  TEXT('Midas FN Retrieve UDF values from T_GZTRADEX')         *
000600000000      *****************************************************************
000700000000      *                                                               *
000800000000      *  Midas - System Control Module                                *
000900000000      *                                                               *
001000000000      *  A1008006  - Midas FN Retrieve UDF values from T_GZTRADEX     *
001100000000      *                                                               *
001200000000      *  Function:  This program retrieve UDF values for Trade        *
001300000000      *                  a) UDFTRAD07 Conso Branch 1 indicator        *
001400000000      *                  b) UDFTRAD09 Conso Branch 1 Book code        *
001500000000      *                  c) UDFTRAD12 Conso Branch 2 indicator        *
001600000000      *                  d) UDFTRAD14 Conso Branch 2 Book code        *
001700000000      *                  e) UDFTRAD15 Conso Branch 3 indicator        *
001800000000      *                  e) UDFTRAD17 Conso Branch 3 Book code        *
001900000000      *  Called By: A1008002                                          *
001901000000      *                                                               *
002100000000      *  (c) Finastra International Limited 2021                      *
002200000000      *                                                               *
002300000000      *  Last Amend No. BA1008   *CREATE   Date 03Jun21               *
002500000000      *                                                               *
002600000000      *---------------------------------------------------------------*
002601000000      *                                                               *
002602000000      *  BA1008 - Replication of Trades to consolidated Branches      *
002800000000      *                                                               *
002900000000      *****************************************************************
003000000000      *                                                               *
003100000000      *  Use of indicators.                                           *
003200000000      *                                                               *
003300000000      *    XX         Function of Indicator                           *
003400000000      *    98         Date Format                                     *
003500000000      *    99         Found Action Code Record                        *
003600000000      *                                                               *
003700000000      *****************************************************************
003800000000      *                                                               *
003900000000      *  S U B R O U T I N E  I N D E X                               *
004000000000      *                                                               *
004100000000      * *PSSR - Error processing                                      *
004200000000      * *INZSR - Initialise                                           *
004300000000      *                                                               *
004400000000      *    The *INZSR subroutine will only get called automatically   *
004500000000      *    on entry to the module the first time it is run            *
004600000000      *    (unless you end the program with LR on).  Similarly        *
004700000000      *    D-spec initialisation only happens the first time.  Use    *
004800000000      *    RESET for subsequent passes.                               *
004900000000      *                                                               *
005000000000      *****************************************************************
005100000000      ** +--------------------------------------+
005200000000      ** ¦ F-specs                              ¦
005300000000      ** ¦ =======                              ¦
005400000000      ** +--------------------------------------+
005500000000
005600000000      *****************************************************************
005700000000      /EJECT
005800000000      *****************************************************************
005900000000      ** +--------------------------------------+
006000000000      ** ¦ D-specs                              ¦
006100000000      ** ¦ =======                              ¦
006200000000      ** +--------------------------------------+
006300000000      ** Dynamic SQL statement work field
006400000000     D WSTRSQL         S           1000A   INZ(*BLANKS)
006500000000      *
006600000000     D SysValue        S            200                                                     AR989143
006700000000     D ZoneName        S             10
006800000000     D Traderef        S              6
006900000000     D Tradekey        S              6S 0
007000000000     D UniqueID        S             10
007100000000     D Wcons           S             10
007200000000     D RtnCons         S              1
007300000000     D RtnBook         S              2
007400000000     D ReturnCodex     S              7
007500000000     D Option          S              7
007600000000     D Parms           S             80
007700000000     D Quote           S              1
007800000000      *
007900000000     D Wcons2          S             10
008000000000     D RtnCons2        S              1
008100000000     D RtnBook2        S              2
008200000000     D Wcons3          S             10
008300000000     D RtnCons3        S              1
008400000000     D RtnBook3        S              2
008500000000      *
008600000000     D LDA           E DS           256    EXTNAME(LDA)
008700000000      *
008800000000      ** Local data area for database error details
008900000000      ** *LOCK IN LDA immediately before and OUT LDA immediately
009000000000      ** after each database error handling.
009100000000      **
009200000000      **                                    134 141 DBFILE
009300000000      **       Defines:                     142 170 DBKEY
009400000000      **                                    171 180 DBPGM
009500000000      **                                    181 1830DBASE
009600000000      *
009700000000      ** Data Area giving Installation Control Details
009800000000
009900000000      ** The following /COPY line includes all the defined fields in the
010000000000      ** PSDS.  They have meaningful names, prefixed by 'PS'.
010100000000
010200000000     D/COPY ZACPYSRC,PSDS
010300000000      *
010400000000      ** Program Status Data Structure
010500000000      *
010600000000      ** +-----------------------------------------------------------------+
010700000000      ** D specs of the following types should be inserted after the
010800000000      ** relevant box.  *** Remove this text afterwards. ***
010900000000      ** +-----------------------------------------------------------------+
011000000000
011100000000      ** +--------------------------------------+
011200000000      ** ¦ Named constants                      ¦
011300000000      ** ¦ ===============                      ¦
011400000000      ** +--------------------------------------+
011500000000
011600000000      ** +--------------------------------------+
011700000000      ** ¦ Arrays and Data Structures           ¦
011800000000      ** ¦ ==========================           ¦
011900000000      ** +--------------------------------------+
012000000000
012100000000     DDSSDY          E DS
012200000000
012300000000
012400000000      ** +--------------------------------------+
012500000000      ** ¦ Declared variables                   ¦
012600000000      ** ¦ ==================                   ¦
012700000000      ** +--------------------------------------+
012800000000
012900000000     D @RUN            S              1
013000000000      *****************************************************************
013100000000      /EJECT
013200000000      *****************************************************************
013300000000      *
013400000000      ** +--- Start of Main processing -----------------------------------+
013500000000      ** ¦                                                                ¦
013600000000      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
013700000000      ** ¦ executed at program activation.                                ¦
013800000000      ** ¦                                                                ¦
013900000000      ** +----------------------------------------------------------------+
014000000000
014100000000      *********************************************************************
014200000000      * MAIN PROCEDURE                                                    *
014300000000      *********************************************************************
014400000000      *
014500000000      ** Read in Installation Data
014600000000      *
014700000000     C     *DTAARA       DEFINE                  LDA
014800000000
014900000000     C                   MOVEL     TradeRef      Tradekey
015000000000
015100000000      *                                                                                     AR989143
015200000000      ** Retrieve zone name from System Value file                                          AR989143
015300000000      *                                                                                     AR989143
015400000000     C/EXEC SQL                                                                             AR989143
015500000000     C+ select GIVAL into :SysValue from SDSVALPD                                           AR989143
015600000000     C+ where GISVAL = 'ZoneSystemName'                                                     AR989143
015700000000     C/END-EXEC                                                                             AR989143
015800000000      *                                                                                     AR989143
015900000000     C                   IF        SysValue = *BLANKS                                       AR989143
016000000000     C     *LOCK         IN        LDA                                                      AR989143
016100000000     C                   EVAL      *INU7 = *ON                                              AR989143
016200000000     C                   EVAL      *INU8 = *ON                                              AR989143
016300000000     C                   EVAL      DBFILE =  'SDSVALPD'                                     AR989143
016400000000     C                   EVAL      DBKEY  =  'ZoneSystemName'                               AR989143
016500000000     C                   EVAL      DBPGM  =  PSProcPgm                                      AR989143
016600000000     C                   EVAL      DBASE  =  002                                            AR989143
016700000000     C                   EVAL      DBMOD  =  PSProcMod                                      AR989143
016800000000     C                   EVAL      DBPROC =  'Main'                                         AR989143
016900000000     C                   OUT       LDA                                                      AR989143
017000000000     C                   EXSR      *PSSR                                                    AR989143
017100000000     C                   ELSE                                                               AR989143
017200000000     C                   EVAL      ZoneName = %TRIM(SysValue)                               AR989143
017300000000     C                   ENDIF                                                              AR989143
017400000000      *                                                                                     AR989143
019000000000     C                   Eval      WSTRSQL = 'select UDFTRAD07, UDFTRAD09, ' +
019100000000     C                                       'UDFTRAD12, UDFTRAD14, ' +
019200000000     C                                       'UDFTRAD15, UDFTRAD17, ' +
019300000000     C                                        ' from T_GZTRADEX  ' +
019400000000     C                                        ' where DDTRDF = ' + '''' +
019500000000     C                                        %trim(TradeKey) + '''' +
019600000000     C                                        ' and ZONE = ' +  '''' +
019700000000     C                                        %trim(ZoneName) + ''''
019800000000
019900000000      * Prepare SQL statement
020000000000
020100000000     C/EXEC SQL
020200000000     C+ PREPARE S1 FROM :WSTRSQL
020300000000     C/END-EXEC
020400000000
020500000000     C/EXEC SQL
020600000000     C+ DECLARE C1 CURSOR FOR S1
020700000000     C/END-EXEC
020800000000
020900000000     C/EXEC SQL
021000000000     C+ OPEN C1
021100000000     C/END-EXEC
021200000000
021300000000     C/EXEC SQL
021400000000     C+ FETCH C1 into :Wcons, :RtnBook, :Wcons2, :RtnBook2, :Wcons3,
021500000000     C+ :RtnBook3
021600000000     C/END-EXEC
021700000000
021800000000     C                   Eval      ReturnCodex = *Blanks
021900000000     C                   IF        SQLCOD = 100
022000000000     C                   MOVEL     'NRF'         ReturnCodex
022100000000     C                   Endif
022200000000     C                   If        SQLCOD = -802
022300000000     C                   Dump
022400000000     C                   Endif
022500000000     C                   IF        SQLCOD <> 0  And SQLCOD <> 100  and
022600000000     C                             SQLCOD <> -802
022700000000     C                   MOVEL     'RPGETRAD07'  DBPGM
022800000000     C                   MOVEL     'T_GZTRADEX'  DBFILE
022900000000     C                   MOVEL     '001'         DBASE
023000000000     C                   MOVEL     TRADEREF      DBKEY
023100000000     C                   MOVEL     'ERR'         ReturnCodex
023200000000     C                   DUMP
023300000000      *
023400000000     C*                  EXSR      *PSSR
023500000000     C                   ENDIF
023600000000     C                   Movel     Wcons         RtnCons
023700000000     C                   Movel     Wcons2        RtnCons2
023800000000     C                   Movel     Wcons3        RtnCons3
023900000000     C                   EVAL      *INLR = *ON
024000000000     C                   RETURN
024100000000      *****************************************************************
024200000000      /EJECT
024300000000      *****************************************************************
024400000000      *                                                               *
024500000000      * *INZSR - Program Initialisation routine                       *
024600000000      *                                                               *
024700000000      * Called by: Implicitly on program activation                   *
024800000000      *                                                               *
024900000000      * Calls: None                                                   *
025000000000      *                                                               *
025100000000      *****************************************************************
025200000000
025300000000     C     *INZSR        BEGSR
025400000000
025500000000     C     *entry        PLIST
025600000000     C                   PARM                    Traderef
025700000000     C                   PARM                    RtnCons
025800000000     C                   PARM                    RtnBook
025900000000     C                   PARM                    RtnCons2
026000000000     C                   PARM                    RtnBook2
026100000000     C                   PARM                    RtnCons3
026200000000     C                   PARM                    RtnBook3
026300000000     C                   PARM                    ReturnCodex
026400000000
026500000000     C                   ENDSR
026600000000      *
026700000000      /EJECT
026800000000      *****************************************************************
026900000000      *                                                               *
027000000000      * *PSSR  - Program exception error routine                      *
027100000000      *          Called automatically if a program error occurs,      *
027200000000      *          or directly by the program code using EXSR.          *
027300000000      *          This subroutine DUMPs the program just once.         *
027400000000      *                                                               *
027500000000      * Called by: (**calling routines**)                             *
027600000000      *                                                               *
027700000000      * Calls: None                                                   *
027800000000      *                                                               *
027900000000      *****************************************************************
028000000000      *
028100000000     C     *PSSR         BEGSR
028200000000      *
028300000000     C                   IF        @RUN = *BLANK
028400000000     C                   EVAL      @RUN = 'Y'
028500000000     C                   DUMP
028600000000      *
028700000000     C                   CALL      'DBERRCTL'
028800000000      *
028900000000     C                   ENDIF
029000000000      *
029100000000     C                   EVAL      *INU7 = *ON
029200000000     C                   EVAL      *INU8 = *ON
029300000000     C                   EVAL      *INLR = *ON
029400000000     C                   RETURN
029500000000      *
029600000000     C                   ENDSR
029700000000      *
