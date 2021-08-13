000100000000     H DEBUG
000200000000     H COPYRIGHT('(c) Finastra International Limited 2021')
000300000000      *****************************************************************
000400000000/*STD *  RPGSQLBND                                                    *
000500000000/*EXI *  TEXT('Midas FN Update UDF T_GZTRADEX/UDFTRAD08')             *
000600000000      *****************************************************************
000700000000      *                                                               *
000800000000      *  Midas - System Control Module                                *
000900000000      *                                                               *
001000000000      *  A1008003  - Midas FN Update UDF T_GZTRADEX/UDFTRAD08         *
001100000000      *                                                               *
001200000000      *  Function:  This program updates  UDFTRAD08 from Trade        *
001300000000      *  Called By: A1008002                                          *
001500000000      *                                                               *
001600000000      *  (c) Finastra International Limited 2021                      *
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
006300000000     D SysValue        S            200                                                     AR989143
006400000000     D ZoneName        S             10
006500000000     D Traderef        S              6
006600000000     D FRNTref         S              6
006700000000     D UniqueID        S             10
006800000000     D RTNCALL         S              1
006900000000     D ReturnCode      S              7
007000000000     D Option          S              7
007100000000     D Parms           S             80
007200000000     D Quote           S              1
007300000000      *
007400000000     D LDA           E DS           256    EXTNAME(LDA)
007500000000      *
007600000000      ** Local data area for database error details
007700000000      ** *LOCK IN LDA immediately before and OUT LDA immediately
007800000000      ** after each database error handling.
007900000000      **
008000000000      **                                    134 141 DBFILE
008100000000      **       Defines:                     142 170 DBKEY
008200000000      **                                    171 180 DBPGM
008300000000      **                                    181 1830DBASE
008400000000      *
008500000000      ** Data Area giving Installation Control Details
008600000000
008700000000      ** The following /COPY line includes all the defined fields in the
008800000000      ** PSDS.  They have meaningful names, prefixed by 'PS'.
008900000000
009000000000     D/COPY ZACPYSRC,PSDS
009100000000      *
009200000000      ** Program Status Data Structure
009300000000      *
009400000000      ** +-----------------------------------------------------------------+
009500000000      ** D specs of the following types should be inserted after the
009600000000      ** relevant box.  *** Remove this text afterwards. ***
009700000000      ** +-----------------------------------------------------------------+
009800000000
009900000000      ** +--------------------------------------+
010000000000      ** ¦ Named constants                      ¦
010100000000      ** ¦ ===============                      ¦
010200000000      ** +--------------------------------------+
010300000000
010400000000      ** +--------------------------------------+
010500000000      ** ¦ Arrays and Data Structures           ¦
010600000000      ** ¦ ==========================           ¦
010700000000      ** +--------------------------------------+
010800000000
010900000000     DDSSDY          E DS
011000000000
011100000000
011200000000      ** +--------------------------------------+
011300000000      ** ¦ Declared variables                   ¦
011400000000      ** ¦ ==================                   ¦
011500000000      ** +--------------------------------------+
011600000000
011700000000     D @RUN            S              1
011800000000      *****************************************************************
011900000000      /EJECT
012000000000      *****************************************************************
012100000000      *
012200000000      ** +--- Start of Main processing -----------------------------------+
012300000000      ** ¦                                                                ¦
012400000000      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
012500000000      ** ¦ executed at program activation.                                ¦
012600000000      ** ¦                                                                ¦
012700000000      ** +----------------------------------------------------------------+
012800000000
012900000000      *********************************************************************
013000000000      * MAIN PROCEDURE                                                    *
013100000000      *********************************************************************
013200000000      *
013300000000      ** Read in Installation Data
013400000000      *
013500000000     C     *DTAARA       DEFINE                  LDA
013600000000
013700000000      *                                                                                     AR989143
013800000000      ** Retrieve zone name from System Value file                                          AR989143
013900000000      *                                                                                     AR989143
014000000000     C/EXEC SQL                                                                             AR989143
014100000000     C+ select GIVAL into :SysValue from SDSVALPD                                           AR989143
014200000000     C+ where GISVAL = 'ZoneSystemName'                                                     AR989143
014300000000     C/END-EXEC                                                                             AR989143
014400000000      *                                                                                     AR989143
014500000000     C                   IF        SysValue = *BLANKS                                       AR989143
014600000000     C     *LOCK         IN        LDA                                                      AR989143
014700000000     C                   EVAL      *INU7 = *ON                                              AR989143
014800000000     C                   EVAL      *INU8 = *ON                                              AR989143
014900000000     C                   EVAL      DBFILE =  'SDSVALPD'                                     AR989143
015000000000     C                   EVAL      DBKEY  =  'ZoneSystemName'                               AR989143
015100000000     C                   EVAL      DBPGM  =  PSProcPgm                                      AR989143
015200000000     C                   EVAL      DBASE  =  002                                            AR989143
015300000000     C                   EVAL      DBMOD  =  PSProcMod                                      AR989143
015400000000     C                   EVAL      DBPROC =  'Main'                                         AR989143
015500000000     C                   OUT       LDA                                                      AR989143
015600000000     C                   EXSR      *PSSR                                                    AR989143
015700000000     C                   ELSE                                                               AR989143
015800000000     C                   EVAL      ZoneName = %TRIM(SysValue)                               AR989143
015900000000     C                   ENDIF                                                              AR989143
016000000000      *                                                                                     AR989143
016900000000     C                   Eval      WSTRSQL = 'update T_GZTRADEX set ' +
017000000000     C                                        ' UDFTRAD08  = ' + '''' +
017100000000     C                                        %trim(FRNTref) + '''' +
017200000000     C                                        ' where DDTRDF = ' + '''' +
017300000000     C                                        %trim(Traderef) + '''' +
017400000000     C                                        ' and ZONE = ' +  '''' +
017500000000     C                                        %trim(ZoneName) + ''''
017600000000
017700000000      * Prepare SQL statement
017800000000
017900000000     C/EXEC SQL
018000000000     C+ PREPARE S1 FROM :WSTRSQL
018100000000     C/END-EXEC
018200000000
018300000000      * Execute SQL statement
018400000000
018500000000     C/EXEC SQL
018600000000     C+ EXECUTE S1
018700000000     C/END-EXEC
018800000000     C                   IF        SQLCOD = 100
018900000000     C                   MOVEL     'NRF'         ReturnCode
019000000000     C                   Endif
019100000000     C                   IF        SQLCOD <> 0  And SQLCOD <> 100
019300000000     C                   MOVEL     'A1008003'    DBPGM
019400000000     C                   MOVEL     'T_GZTRADEX'  DBFILE
019500000000     C                   MOVEL     '001'         DBASE
019600000000     C                   MOVEL     TRADEREF      DBKEY
019700000000     C                   MOVEL     'ERR'         ReturnCode
019800000000      *
020000000000     C                   ENDIF
020200000000     C                   COMMIT
020300000000     C                   EVAL      *INLR = *ON
020400000000     C                   RETURN
020500000000      *****************************************************************
020600000000      /EJECT
020700000000      *****************************************************************
020800000000      *                                                               *
020900000000      * *INZSR - Program Initialisation routine                       *
021000000000      *                                                               *
021100000000      * Called by: Implicitly on program activation                   *
021200000000      *                                                               *
021300000000      * Calls: None                                                   *
021400000000      *                                                               *
021500000000      *****************************************************************
021600000000
021700000000     C     *INZSR        BEGSR
021800000000
021900000000     C     *entry        PLIST
022000000000     C                   PARM                    Traderef
022100000000     C                   PARM                    FRNTRef
022200000000
022300000000     C                   ENDSR
022400000000      *
022500000000      /EJECT
022600000000      *****************************************************************
022700000000      *                                                               *
022800000000      * *PSSR  - Program exception error routine                      *
022900000000      *          Called automatically if a program error occurs,      *
023000000000      *          or directly by the program code using EXSR.          *
023100000000      *          This subroutine DUMPs the program just once.         *
023200000000      *                                                               *
023300000000      * Called by: (**calling routines**)                             *
023400000000      *                                                               *
023500000000      * Calls: None                                                   *
023600000000      *                                                               *
023700000000      *****************************************************************
023800000000      *
023900000000     C     *PSSR         BEGSR
024000000000      *
024100000000     C                   IF        @RUN = *BLANK
024200000000     C                   EVAL      @RUN = 'Y'
024300000000     C                   DUMP
024400000000      *
024500000000     C                   CALL      'DBERRCTL'
024600000000      *
024700000000     C                   ENDIF
024800000000      *
024900000000     C                   EVAL      *INU7 = *ON
025000000000     C                   EVAL      *INU8 = *ON
025100000000     C                   EVAL      *INLR = *ON
025200000000
025300000000     C                   RETURN
025400000000      *
025500000000     C                   ENDSR
025600000000      *
