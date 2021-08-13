000100000000     H DEBUG
000200000000     H COPYRIGHT('(c) Finastra International Limited 2021')
000300000000      *****************************************************************
000400000000/*STD *  RPGSQLBND                                                    *
000500000000/*EXI *  TEXT('Midas FN Update UDF T_GZTRADEX/UDFTRAD13')             *
000600000000      *****************************************************************
000700000000      *                                                               *
000800000000      *  Midas - System Control Module                                *
000900000000      *                                                               *
001000000000      *  A1008004  - Midas FN Update UDF T_GZTRADEX/UDFTRAD13         *
001100000000      *                                                               *
001200000000      *  Function:  This program updates  UDFTRAD08 from Trade        *
001300000000      *  Called By: A1008002                                          *
001500000000      *                                                               *
001600000000      *  (c) Finastra International Limited 2021                      *
001700000000      *                                                               *
001800000000      *  Last Amend No. BA1008   *CREATE   Date 03Jun21               *
001900000000      *                                                               *
002000000000      *---------------------------------------------------------------*
002100000000      *                                                               *
002101000000      *  BA1008 - Replication of Trades to consolidated Branches      *
002400000000      *                                                               *
002500000000      *****************************************************************
002600000000      *                                                               *
002700000000      *  Use of indicators.                                           *
002800000000      *                                                               *
002900000000      *    XX         Function of Indicator                           *
003000000000      *    98         Date Format                                     *
003100000000      *    99         Found Action Code Record                        *
003200000000      *                                                               *
003300000000      *****************************************************************
003400000000      *                                                               *
003500000000      *  S U B R O U T I N E  I N D E X                               *
003600000000      *                                                               *
003700000000      * *PSSR - Error processing                                      *
003800000000      * *INZSR - Initialise                                           *
003900000000      *                                                               *
004000000000      *    The *INZSR subroutine will only get called automatically   *
004100000000      *    on entry to the module the first time it is run            *
004200000000      *    (unless you end the program with LR on).  Similarly        *
004300000000      *    D-spec initialisation only happens the first time.  Use    *
004400000000      *    RESET for subsequent passes.                               *
004500000000      *                                                               *
004600000000      *****************************************************************
004700000000      ** +--------------------------------------+
004800000000      ** ¦ F-specs                              ¦
004900000000      ** ¦ =======                              ¦
005000000000      ** +--------------------------------------+
005100000000
005200000000      *****************************************************************
005300000000      /EJECT
005400000000      *****************************************************************
005500000000      ** +--------------------------------------+
005600000000      ** ¦ D-specs                              ¦
005700000000      ** ¦ =======                              ¦
005800000000      ** +--------------------------------------+
005900000000      ** Dynamic SQL statement work field
006000000000     D WSTRSQL         S           1000A   INZ(*BLANKS)
006100000000      *
006200000000     D SysValue        S            200                                                     AR989143
006300000000     D ZoneName        S             10
006400000000     D Traderef        S              6
006500000000     D FRNTref         S              6
006600000000     D UniqueID        S             10
006700000000     D RTNCALL         S              1
006800000000     D ReturnCode      S              7
006900000000     D Option          S              7
007000000000     D Parms           S             80
007100000000     D Quote           S              1
007200000000      *
007300000000     D LDA           E DS           256    EXTNAME(LDA)
007400000000      *
007500000000      ** Local data area for database error details
007600000000      ** *LOCK IN LDA immediately before and OUT LDA immediately
007700000000      ** after each database error handling.
007800000000      **
007900000000      **                                    134 141 DBFILE
008000000000      **       Defines:                     142 170 DBKEY
008100000000      **                                    171 180 DBPGM
008200000000      **                                    181 1830DBASE
008300000000      *
008400000000      ** Data Area giving Installation Control Details
008500000000
008600000000      ** The following /COPY line includes all the defined fields in the
008700000000      ** PSDS.  They have meaningful names, prefixed by 'PS'.
008800000000
008900000000     D/COPY ZACPYSRC,PSDS
009000000000      *
009100000000      ** Program Status Data Structure
009200000000      *
009300000000      ** +-----------------------------------------------------------------+
009400000000      ** D specs of the following types should be inserted after the
009500000000      ** relevant box.  *** Remove this text afterwards. ***
009600000000      ** +-----------------------------------------------------------------+
009700000000
009800000000      ** +--------------------------------------+
009900000000      ** ¦ Named constants                      ¦
010000000000      ** ¦ ===============                      ¦
010100000000      ** +--------------------------------------+
010200000000
010300000000      ** +--------------------------------------+
010400000000      ** ¦ Arrays and Data Structures           ¦
010500000000      ** ¦ ==========================           ¦
010600000000      ** +--------------------------------------+
010700000000
010800000000     DDSSDY          E DS
010900000000
011000000000
011100000000      ** +--------------------------------------+
011200000000      ** ¦ Declared variables                   ¦
011300000000      ** ¦ ==================                   ¦
011400000000      ** +--------------------------------------+
011500000000
011600000000     D @RUN            S              1
011700000000      *****************************************************************
011800000000      /EJECT
011900000000      *****************************************************************
012000000000      *
012100000000      ** +--- Start of Main processing -----------------------------------+
012200000000      ** ¦                                                                ¦
012300000000      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
012400000000      ** ¦ executed at program activation.                                ¦
012500000000      ** ¦                                                                ¦
012600000000      ** +----------------------------------------------------------------+
012700000000
012800000000      *********************************************************************
012900000000      * MAIN PROCEDURE                                                    *
013000000000      *********************************************************************
013100000000      *
013200000000      ** Read in Installation Data
013300000000      *
013400000000     C     *DTAARA       DEFINE                  LDA
013500000000
013600000000      *                                                                                     AR989143
013700000000      ** Retrieve zone name from System Value file                                          AR989143
013800000000      *                                                                                     AR989143
013900000000     C/EXEC SQL                                                                             AR989143
014000000000     C+ select GIVAL into :SysValue from SDSVALPD                                           AR989143
014100000000     C+ where GISVAL = 'ZoneSystemName'                                                     AR989143
014200000000     C/END-EXEC                                                                             AR989143
014300000000      *                                                                                     AR989143
014400000000     C                   IF        SysValue = *BLANKS                                       AR989143
014500000000     C     *LOCK         IN        LDA                                                      AR989143
014600000000     C                   EVAL      *INU7 = *ON                                              AR989143
014700000000     C                   EVAL      *INU8 = *ON                                              AR989143
014800000000     C                   EVAL      DBFILE =  'SDSVALPD'                                     AR989143
014900000000     C                   EVAL      DBKEY  =  'ZoneSystemName'                               AR989143
015000000000     C                   EVAL      DBPGM  =  PSProcPgm                                      AR989143
015100000000     C                   EVAL      DBASE  =  002                                            AR989143
015200000000     C                   EVAL      DBMOD  =  PSProcMod                                      AR989143
015300000000     C                   EVAL      DBPROC =  'Main'                                         AR989143
015400000000     C                   OUT       LDA                                                      AR989143
015500000000     C                   EXSR      *PSSR                                                    AR989143
015600000000     C                   ELSE                                                               AR989143
015700000000     C                   EVAL      ZoneName = %TRIM(SysValue)                               AR989143
015800000000     C                   ENDIF                                                              AR989143
015900000000      *                                                                                     AR989143
016800000000     C                   Eval      WSTRSQL = 'update T_GZTRADEX set ' +
016900000000     C                                        ' UDFTRAD13  = ' + '''' +
017000000000     C                                        %trim(FRNTref) + '''' +
017100000000     C                                        ' where DDTRDF = ' + '''' +
017200000000     C                                        %trim(Traderef) + '''' +
017300000000     C                                        ' and ZONE = ' +  '''' +
017400000000     C                                        %trim(ZoneName) + ''''
017500000000
017600000000      * Prepare SQL statement
017700000000
017800000000     C/EXEC SQL
017900000000     C+ PREPARE S1 FROM :WSTRSQL
018000000000     C/END-EXEC
018100000000
018200000000      * Execute SQL statement
018300000000
018400000000     C/EXEC SQL
018500000000     C+ EXECUTE S1
018600000000     C/END-EXEC
018700000000     C                   IF        SQLCOD = 100
018800000000     C                   MOVEL     'NRF'         ReturnCode
018900000000     C                   Endif
019000000000     C                   IF        SQLCOD <> 0  And SQLCOD <> 100
019200000000     C                   MOVEL     'A1008004'    DBPGM
019300000000     C                   MOVEL     'T_GZTRADEX'  DBFILE
019400000000     C                   MOVEL     '001'         DBASE
019500000000     C                   MOVEL     TRADEREF      DBKEY
019600000000     C                   MOVEL     'ERR'         ReturnCode
019700000000      *
019900000000     C                   ENDIF
020100000000     C                   COMMIT
020200000000     C                   EVAL      *INLR = *ON
020300000000     C                   RETURN
020400000000      *****************************************************************
020500000000      /EJECT
020600000000      *****************************************************************
020700000000      *                                                               *
020800000000      * *INZSR - Program Initialisation routine                       *
020900000000      *                                                               *
021000000000      * Called by: Implicitly on program activation                   *
021100000000      *                                                               *
021200000000      * Calls: None                                                   *
021300000000      *                                                               *
021400000000      *****************************************************************
021500000000
021600000000     C     *INZSR        BEGSR
021700000000
021800000000     C     *entry        PLIST
021900000000     C                   PARM                    Traderef
022000000000     C                   PARM                    FRNTRef
022100000000
022200000000     C                   ENDSR
022300000000      *
022400000000      /EJECT
022500000000      *****************************************************************
022600000000      *                                                               *
022700000000      * *PSSR  - Program exception error routine                      *
022800000000      *          Called automatically if a program error occurs,      *
022900000000      *          or directly by the program code using EXSR.          *
023000000000      *          This subroutine DUMPs the program just once.         *
023100000000      *                                                               *
023200000000      * Called by: (**calling routines**)                             *
023300000000      *                                                               *
023400000000      * Calls: None                                                   *
023500000000      *                                                               *
023600000000      *****************************************************************
023700000000      *
023800000000     C     *PSSR         BEGSR
023900000000      *
024000000000     C                   IF        @RUN = *BLANK
024100000000     C                   EVAL      @RUN = 'Y'
024200000000     C                   DUMP
024300000000      *
024400000000     C                   CALL      'DBERRCTL'
024500000000      *
024600000000     C                   ENDIF
024700000000      *
024800000000     C                   EVAL      *INU7 = *ON
024900000000     C                   EVAL      *INU8 = *ON
025000000000     C                   EVAL      *INLR = *ON
025100000000
025200000000     C                   RETURN
025300000000      *
025400000000     C                   ENDSR
025500000000      *
