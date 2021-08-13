000100210505     H DEBUG
000200210607     H COPYRIGHT('(c) Finastra International Limited 2021')
000300210505      *****************************************************************
000400210505/*STD *  RPGSQLBND                                                    *
000500210505/*EXI *  TEXT('Midas FN Update UDF T_GZTRADEX/UDFTRAD16')             *
000600210505      *****************************************************************
000700210505      *                                                               *
000800210505      *  Midas - System Control Module                                *
000900210505      *                                                               *
001000210505      *  A1008005  - Midas FN Update UDF T_GZTRADEX/UDFTRAD16         *
001100210505      *                                                               *
001200210505      *  Function:  This program updates  UDFTRAD08 from Trade        *
001300210505      *  Called By: A1008002                                          *
001500210505      *                                                               *
001600210607      *  (c) Finastra International Limited 2021                      *
001700210505      *                                                               *
001800210607      *  Last Amend No. BA1008   *CREATE   Date 03Jun21               *
001900210505      *                                                               *
002000210505      *---------------------------------------------------------------*
002100210505      *                                                               *
002101210607      *  BA1008 - Replication of Trades to consolidated Branches      *
002400210505      *                                                               *
002500210505      *****************************************************************
002600210505      *                                                               *
002700210505      *  Use of indicators.                                           *
002800210505      *                                                               *
002900210505      *    XX         Function of Indicator                           *
003000210505      *    98         Date Format                                     *
003100210505      *    99         Found Action Code Record                        *
003200210505      *                                                               *
003300210505      *****************************************************************
003400210505      *                                                               *
003500210505      *  S U B R O U T I N E  I N D E X                               *
003600210505      *                                                               *
003700210505      * *PSSR - Error processing                                      *
003800210505      * *INZSR - Initialise                                           *
003900210505      *                                                               *
004000210505      *    The *INZSR subroutine will only get called automatically   *
004100210505      *    on entry to the module the first time it is run            *
004200210505      *    (unless you end the program with LR on).  Similarly        *
004300210505      *    D-spec initialisation only happens the first time.  Use    *
004400210505      *    RESET for subsequent passes.                               *
004500210505      *                                                               *
004600210505      *****************************************************************
004700210505      ** +--------------------------------------+
004800210505      ** ¦ F-specs                              ¦
004900210505      ** ¦ =======                              ¦
005000210505      ** +--------------------------------------+
005100210505
005200210505      *****************************************************************
005300210505      /EJECT
005400210505      *****************************************************************
005500210505      ** +--------------------------------------+
005600210505      ** ¦ D-specs                              ¦
005700210505      ** ¦ =======                              ¦
005800210505      ** +--------------------------------------+
005900210505      ** Dynamic SQL statement work field
006000210505     D WSTRSQL         S           1000A   INZ(*BLANKS)
006100210505      *
006200210505     D SysValue        S            200                                                     AR989143
006300210505     D ZoneName        S             10
006400210505     D Traderef        S              6
006500210505     D FRNTref         S              6
006600210505     D UniqueID        S             10
006700210505     D RTNCALL         S              1
006800210505     D ReturnCode      S              7
006900210505     D Option          S              7
007000210505     D Parms           S             80
007100210505     D Quote           S              1
007200210505      *
007300210505     D LDA           E DS           256    EXTNAME(LDA)
007400210505      *
007500210505      ** Local data area for database error details
007600210505      ** *LOCK IN LDA immediately before and OUT LDA immediately
007700210505      ** after each database error handling.
007800210505      **
007900210505      **                                    134 141 DBFILE
008000210505      **       Defines:                     142 170 DBKEY
008100210505      **                                    171 180 DBPGM
008200210505      **                                    181 1830DBASE
008300210505      *
008400210505      ** Data Area giving Installation Control Details
008500210505
008600210505      ** The following /COPY line includes all the defined fields in the
008700210505      ** PSDS.  They have meaningful names, prefixed by 'PS'.
008800210505
008900210505     D/COPY ZACPYSRC,PSDS
009000210505      *
009100210505      ** Program Status Data Structure
009200210505      *
009300210505      ** +-----------------------------------------------------------------+
009400210505      ** D specs of the following types should be inserted after the
009500210505      ** relevant box.  *** Remove this text afterwards. ***
009600210505      ** +-----------------------------------------------------------------+
009700210505
009800210505      ** +--------------------------------------+
009900210505      ** ¦ Named constants                      ¦
010000210505      ** ¦ ===============                      ¦
010100210505      ** +--------------------------------------+
010200210505
010300210505      ** +--------------------------------------+
010400210505      ** ¦ Arrays and Data Structures           ¦
010500210505      ** ¦ ==========================           ¦
010600210505      ** +--------------------------------------+
010700210505
010800210505     DDSSDY          E DS
010900210505
011000210505
011100210505      ** +--------------------------------------+
011200210505      ** ¦ Declared variables                   ¦
011300210505      ** ¦ ==================                   ¦
011400210505      ** +--------------------------------------+
011500210505
011600210505     D @RUN            S              1
011700210505      *****************************************************************
011800210505      /EJECT
011900210505      *****************************************************************
012000210505      *
012100210505      ** +--- Start of Main processing -----------------------------------+
012200210505      ** ¦                                                                ¦
012300210505      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
012400210505      ** ¦ executed at program activation.                                ¦
012500210505      ** ¦                                                                ¦
012600210505      ** +----------------------------------------------------------------+
012700210505
012800210505      *********************************************************************
012900210505      * MAIN PROCEDURE                                                    *
013000210505      *********************************************************************
013100210505      *
013200210505      ** Read in Installation Data
013300210505      *
013400210505     C     *DTAARA       DEFINE                  LDA
013500210505
013600210505      *                                                                                     AR989143
013700210505      ** Retrieve zone name from System Value file                                          AR989143
013800210505      *                                                                                     AR989143
013900210505     C/EXEC SQL                                                                             AR989143
014000210505     C+ select GIVAL into :SysValue from SDSVALPD                                           AR989143
014100210505     C+ where GISVAL = 'ZoneSystemName'                                                     AR989143
014200210505     C/END-EXEC                                                                             AR989143
014300210505      *                                                                                     AR989143
014400210505     C                   IF        SysValue = *BLANKS                                       AR989143
014500210505     C     *LOCK         IN        LDA                                                      AR989143
014600210505     C                   EVAL      *INU7 = *ON                                              AR989143
014700210505     C                   EVAL      *INU8 = *ON                                              AR989143
014800210505     C                   EVAL      DBFILE =  'SDSVALPD'                                     AR989143
014900210505     C                   EVAL      DBKEY  =  'ZoneSystemName'                               AR989143
015000210505     C                   EVAL      DBPGM  =  PSProcPgm                                      AR989143
015100210505     C                   EVAL      DBASE  =  002                                            AR989143
015200210505     C                   EVAL      DBMOD  =  PSProcMod                                      AR989143
015300210505     C                   EVAL      DBPROC =  'Main'                                         AR989143
015400210505     C                   OUT       LDA                                                      AR989143
015500210505     C                   EXSR      *PSSR                                                    AR989143
015600210505     C                   ELSE                                                               AR989143
015700210505     C                   EVAL      ZoneName = %TRIM(SysValue)                               AR989143
015800210505     C                   ENDIF                                                              AR989143
015900210505      *                                                                                     AR989143
016800210607     C                   Eval      WSTRSQL = 'update T_GZTRADEX set ' +
016900210607     C                                        ' UDFTRAD16  = ' + '''' +
017000210607     C                                        %trim(FRNTref) + '''' +
017100210607     C                                        ' where DDTRDF = ' + '''' +
017200210607     C                                        %trim(Traderef) + '''' +
017300210607     C                                        ' and ZONE = ' +  '''' +
017400210607     C                                        %trim(ZoneName) + ''''
017500210607
017600210607      * Prepare SQL statement
017700210607
017800210607     C/EXEC SQL
017900210607     C+ PREPARE S1 FROM :WSTRSQL
018000210607     C/END-EXEC
018100210607
018200210607      * Execute SQL statement
018300210607
018400210607     C/EXEC SQL
018500210607     C+ EXECUTE S1
018600210607     C/END-EXEC
018700210505     C                   IF        SQLCOD = 100
018800210505     C                   MOVEL     'NRF'         ReturnCode
018900210505     C                   Endif
019000210505     C                   IF        SQLCOD <> 0  And SQLCOD <> 100
019200210607     C                   MOVEL     'A1008005'    DBPGM
019300210505     C                   MOVEL     'T_GZTRADEX'  DBFILE
019400210505     C                   MOVEL     '001'         DBASE
019500210505     C                   MOVEL     TRADEREF      DBKEY
019600210505     C                   MOVEL     'ERR'         ReturnCode
019700210505      *
019900210505     C                   ENDIF
020100210505     C                   COMMIT
020200210505     C                   EVAL      *INLR = *ON
020300210505     C                   RETURN
020400210505      *****************************************************************
020500210505      /EJECT
020600210505      *****************************************************************
020700210505      *                                                               *
020800210505      * *INZSR - Program Initialisation routine                       *
020900210505      *                                                               *
021000210505      * Called by: Implicitly on program activation                   *
021100210505      *                                                               *
021200210505      * Calls: None                                                   *
021300210505      *                                                               *
021400210505      *****************************************************************
021500210505
021600210505     C     *INZSR        BEGSR
021700210505
021800210505     C     *entry        PLIST
021900210505     C                   PARM                    Traderef
022000210505     C                   PARM                    FRNTRef
022100210505
022200210505     C                   ENDSR
022300210505      *
022400210505      /EJECT
022500210505      *****************************************************************
022600210505      *                                                               *
022700210505      * *PSSR  - Program exception error routine                      *
022800210505      *          Called automatically if a program error occurs,      *
022900210505      *          or directly by the program code using EXSR.          *
023000210505      *          This subroutine DUMPs the program just once.         *
023100210505      *                                                               *
023200210505      * Called by: (**calling routines**)                             *
023300210505      *                                                               *
023400210505      * Calls: None                                                   *
023500210505      *                                                               *
023600210505      *****************************************************************
023700210505      *
023800210505     C     *PSSR         BEGSR
023900210505      *
024000210505     C                   IF        @RUN = *BLANK
024100210505     C                   EVAL      @RUN = 'Y'
024200210505     C                   DUMP
024300210505      *
024400210505     C                   CALL      'DBERRCTL'
024500210505      *
024600210505     C                   ENDIF
024700210505      *
024800210505     C                   EVAL      *INU7 = *ON
024900210505     C                   EVAL      *INU8 = *ON
025000210505     C                   EVAL      *INLR = *ON
025100210505
025200210505     C                   RETURN
025300210505      *
025400210505     C                   ENDSR
025500210505      *
