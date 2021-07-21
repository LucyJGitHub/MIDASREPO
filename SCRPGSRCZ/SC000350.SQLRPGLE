000100210712      *****************************************************************
000200210712     H DEBUG
000300210712     H COPYRIGHT('(c) Finastra International Limited 2019')
000400210712      *****************************************************************
000500210712/**** *  RPGBASEBND                                                   *                     MD055681
000600210712/*STD *  RPGSQLBND                                                    *                     MD055681
000700210712/*EXI *  TEXT('Midas SC Activation of Feature')                       *
000800210712      *****************************************************************
000900210712      *                                                               *
001000210712      *  Midas - System Control Module                                *
001100210712      *                                                               *
001200210712      *  SC000350 - Midas SC Activation of Feature                    *
001300210712      *                                                               *
001400210712      *  Function:  This program will activate the features           *
001500210712      *             automatically                                     *
001600210712      *                                                               *
001700210712      *  (c) Finastra International Limited 2019                      *
001800210712      *                                                               *
001900210712      *  Last Amend No. MD057885           Date 13Apr21               *
002000210712      *  Prev Amend No. MD056781           Date 20Sep20               *
002100210712      *                 MD055681           Date 31Jul20               *
002200210712      *                 MD055694           Date 09Mar20               *
002300210712      *                 CSW219 *CREATE     Date 04Mar19               *
002400210712      *                                                               *
002500210712      *---------------------------------------------------------------*
002600210712      *                                                               *
002700210712      *  MD057885 - Remove CSW220 changes                             *
002800210712      *  MD056781 - Deliverable Data Split for MESWACPD               *
002900210712      *  MD055681 - Deliverable Data Split for SAR                    *
003000210712      *  MD055694 - SWIFT Changes 2021                                *
003100210712      *  CSW219 - SWIFT Changes 2019                                  *
003200210712      *                                                               *
003300210712      *****************************************************************
003400210712      *                                                               *
003500210712      *  Subroutine index                                             *
003600210712      *                                                               *
003700210712      *  SrProcess - Process All Available Features                   *
003800210712      *  SrWrite   - Determine which Feature will be written          *
003900210712      *  SrWriteSard - Insert SCSARDPD Record                         *
004000210712      *  SrWritePass - Insert SCPASSPD Record                         *
004100210712      *  SrCache   - Call Caching of Features                         *
004200210712      *  *PSSR     - Error processing                                 *
004300210712      *  *INZSR    - Initialise                                       *
004400210712      *                                                               *
004500210712      *****************************************************************
004600210712
004700210712      ** +--------------------------------------+
004800210712      ** ¦ F-specs                              ¦
004900210712      ** ¦ =======                              ¦
005000210712      ** +--------------------------------------+
005100210712
005200210712      **
005300210712     F*SCSARDL0* UF A E           K DISK                                                    MD055681
005400210712     FSCPASSPD  UF A E           K DISK
005500210712     F*SCSARSL1* IF   E           K DISK                                                    MD055681
005600210712     F*MESWACL0* IF   E           K DISK                                                    MD056781
005700210712      *
005800210712      /EJECT
005900210712      *****************************************************************
006000210712
006100210712      ** +--------------------------------------+
006200210712      ** ¦ D-specs                              ¦
006300210712      ** ¦ =======                              ¦
006400210712      ** +--------------------------------------+
006500210712
006600210712     DPSDS            SDS
006700210712     D PSExcpType             40     42
006800210712      **  Exception number.
006900210712     D PSExcpNo               43     46
007000210712      ** Job name.
007100210712     D PSJobName             244    253
007200210712      ** User name.
007300210712     D PSUser                254    263
007400210712      *
007500210712
007600210712      ** +--------------------------------------+
007700210712      ** ¦ Named constants                      ¦
007800210712      ** ¦ ===============                      ¦
007900210712      ** +--------------------------------------+
008000210712      *
008100210712      *
008200210712      ** +--------------------------------------+
008300210712      ** ¦ Arrays and Data Structures           ¦
008400210712      ** ¦ ==========================           ¦
008500210712      ** +--------------------------------------+
008600210712      *
008700210712      ** Data Structure for Feature
008800210712     D FeatDS          DS
008900210712     D                                6    INZ('CSW219')
009000210712     D**********                      6    INZ('CSW220')                           MD055694 MD057885
009100210712     D                                6    INZ('CSW221')                                    MD055694
009200210712     D Feat                           6    DIM(N) OVERLAY(FeatDS)
009300210712      *
009400210712      ** Data Structure for Feature Password
009500210712     D PWordDS         DS
009600210712     D                               16    INZ('GALERA')
009700210712     D**********                     16    INZ('CARMONA')                          MD055694 MD057885
009800210712     D                               16    INZ('ABBEY ROAD')                                MD055694
009900210712     D PWord                         16    DIM(N) OVERLAY(PWordDS)
010000210712      *
010100210712     D CacheDT       E DS                  EXTNAME(CACHEDT) DTAARA(CACHEDT)
010200210712      *
010300210712     D SDBank        E DS                  EXTNAME(SDBankpd)
010400210712      *
010500210712      ** First DS for Access programs, short Data Structure
010600210712     D DSFDY         E DS                  EXTNAME(DSFDY)
010700210712      *
010800210712     D SCSARD        E DS                  EXTNAME(SCSRDJW0)                                MD055681
010900210712     D SCSARS        E DS                  EXTNAME(SCSRSJW0)                                MD055681
011000210712     D MESWAC        E DS                  EXTNAME(MESWAJW0)                                MD056781
011100210712      ** +--------------------------------------+
011200210712      ** ¦ Declared variables                   ¦
011300210712      ** ¦ ==================                   ¦
011400210712      ** +--------------------------------------+
011500210712
011600210712      ** Increment N, everytime a new Feature is added in DS
011700210712     D*N********       C                   1                                               MD055694
011800210712     D N               C                   3                                               MD055694
011900210712      *
012000210712     D I               S              4S 0
012100210712     D WriteFlag       S              1A
012200210712     D WRun            S              1A
012300210712     D Msg             S            100A
012400210712     D PRetCode        S              7A
012500210712     D POption         S              7A
012600210712     D XXFeat          S              6A                                                    MD055681
012700210712      *
012800210712      /EJECT
012900210712      *****************************************************************
013000210712      * MAIN - Processing
013100210712      *****************************************************************
013200210712      *
013300210712     C                   EXSR      SrProcess
013400210712     C                   EXSR      SrCache
013500210712     C                   EVAL      *INLR = *ON
013600210712     C                   RETURN
013700210712      *
013800210712      /EJECT
013900210712      *****************************************************************
014000210712      *                                                               *
014100210712      *  SrProcess - Process All Available Features                   *
014200210712      *                                                               *
014300210712      *****************************************************************
014400210712     C     SrProcess     BEGSR
014500210712      *
014600210712      ** Process all available features, if it exist in file
014700210712      ** skip processing and proceed to the next feature.
014800210712      *
014900210712     C                   FOR        I = 1 to N
015000210712     C*****Feat(I)       CHAIN(N)  SCSARDL0                                                 MD055681
015100210712     C                   EVAL      XXFeat = Feat(I)                                         MD055681
015200210712     C/EXEC SQL                                                                             MD055681
015300210712     C+ SELECT *                                                                            MD055681
015400210712     C+ into :SCSARD                                                                        MD055681
015500210712     C+ from SCSRDJW0                                                                       MD055681
015600210712     C+ where SARN = :XXFeat                                                                MD055681
015700210712     C/END-EXEC                                                                             MD055681
015800210712     C**********         IF        %FOUND(SCSARDL0)                                         MD055681
015900210712     C                   IF        SQLCODE = 0                                              MD055681
016000210712     C                   ITER
016100210712      *
016200210712     C                   ELSE
016300210712     C*****Feat(I)       CHAIN     MESWACL0                                                 MD056781
016400210712     C/EXEC SQL                                                                             MD056781
016500210712     C+ SELECT *                                                                            MD056781
016600210712     C+ into :MESWAC                                                                        MD056781
016700210712     C+ from MESWAJW0                                                                       MD056781
016800210712     C+ where SWFEAT = :XXFeat                                                              MD056781
016900210712     C/END-EXEC                                                                             MD056781
017000210712     C**********         IF        %FOUND(MESWACL0) AND                                     MD056781
017100210712     C                   IF        SQLCODE = 0 AND                                          MD056781
017200210712     C                             BJDNWD >= SWACDT
017300210712     C                   EXSR      SrWrite
017400210712     C                   ENDIF
017500210712      *
017600210712     C                   ENDIF
017700210712     C                   ENDFOR
017800210712      *
017900210712     C                   ENDSR
018000210712      *
018100210712      /EJECT
018200210712      *****************************************************************
018300210712      *                                                               *
018400210712      *  SrWrite - Determine which Feature will be written            *
018500210712      *                                                               *
018600210712      *****************************************************************
018700210712     C     SrWrite       BEGSR
018800210712      *
018900210712     C                   CLEAR                   WriteFlag
019000210712      *
019100210712     C*****Feat(I)       CHAIN(N)  SCSARDL0                                                 MD055681
019200210712     C                   EVAL      XXFeat = Feat(I)                                         MD055681
019300210712     C/EXEC SQL                                                                             MD055681
019400210712     C+ SELECT *                                                                            MD055681
019500210712     C+ into :SCSARD                                                                        MD055681
019600210712     C+ from SCSRDJW0                                                                       MD055681
019700210712     C+ where SARN = :XXFeat                                                                MD055681
019800210712     C/END-EXEC                                                                             MD055681
019900210712     C**********         IF        NOT%FOUND(SCSARDL0)                                      MD055681
020000210712     C                   IF        SQLCODE = 100                                            MD055681
020100210712     C                   EXSR      SrWriteSard
020200210712     C                   ELSE
020300210712     C**********         UNLOCK    SCSARDL0                                                 MD055681
020400210712     C                   ENDIF
020500210712      *
020600210712     C     Feat(I)       CHAIN     SCPASSPD
020700210712     C                   IF        NOT%FOUND(SCPASSPD)
020800210712     C                   EXSR      SrWritePass
020900210712     C                   ELSE
021000210712     C                   UNLOCK    SCPASSPD
021100210712     C                   ENDIF
021200210712      *
021300210712     C                   ENDSR
021400210712      *
021500210712      /EJECT
021600210712      *****************************************************************
021700210712      *                                                               *
021800210712      *  SrWriteSard - Insert SCSARDPD Record                         *
021900210712      *                                                               *
022000210712      *****************************************************************
022100210712     C     SrWriteSard   BEGSR
022200210712      *
022300210712     C**********         CLEAR                   @SARDL0                                    MD055681
022400210712     C                   MOVEL     *BLANKS       XXSARD           50                        MD055681
022500210712     C*****Feat(I)       CHAIN     SCSARSL1                                                 MD055681
022600210712     C                   eval      XXFeat = Feat(I)                                         MD055681
022700210712     C/EXEC SQL                                                                             MD055681
022800210712     C+ SELECT *                                                                            MD055681
022900210712     C+ into :SCSARS                                                                        MD055681
023000210712     C+ from SCSRSJW0                                                                       MD055681
023100210712     C+ where AXSARN = :XXFeat and AXMODE = 'C'                                             MD055681
023200210712     C/END-EXEC                                                                             MD055681
023300210712     C**********         IF        %FOUND(SCSARSL1)                                         MD055681
023400210712     C                   IF        SQLCODE = 0                                              MD055681
023500210712     C**********         EVAL      ABSARD = AXSARD                                          MD055681
023600210712     C                   EVAL      XXSARD = AXSARD                                          MD055681
023700210712     C                   ENDIF
023800210712     C**********         EVAL      ABSARN = Feat(I)                                         MD055681
023900210712     C                   EVAL      XXFeat = Feat(I)                                         MD055681
024000210712     C**********         EVAL      ABTYLC = 'I'                                             MD055681
024100210712     C                   EVAL      WriteFlag = 'Y'
024200210712     C**********         WRITE(E)  @SARDL0                                                  MD055681
024300210712     C/EXEC SQL                                                                             MD055681
024400210712     C+ insert into SCSRDBTD                                                                MD055681
024500210712     C+ (                                                                                   MD055681
024600210712     C+   SARN                                                                              MD055681
024700210712     C+ , SARD                                                                              MD055681
024800210712     C+ , LCD                                                                               MD055681
024900210712     C+ , TYLC                                                                              MD055681
025000210712     C+ , ZONE                                                                              MD055681
025100210712     C+ , ENABLD                                                                            MD055681
025200210712     C+ , MODE                                                                              MD055681
025300210712     C+ )                                                                                   MD055681
025400210712     C+ Values                                                                              MD055681
025500210712     C+ (                                                                                   MD055681
025600210712     C+   :XXFeat                                                                           MD055681
025700210712     C+ , :XXSARD                                                                           MD055681
025800210712     C+ , 0                                                                                 MD055681
025900210712     C+ , 'I'                                                                               MD055681
026000210712     C+ , ' '                                                                               MD055681
026100210712     C+ , 'E'                                                                               MD055681
026200210712     C+ , 'B'                                                                               MD055681
026300210712     C+ )                                                                                   MD055681
026400210712     C/END-EXEC                                                                             MD055681
026500210712     C/EXEC SQL                                                                             MD055681
026600210712     C+ insert into SCSRDXTD                                                                MD055681
026700210712     C+ (                                                                                   MD055681
026800210712     C+   SARN                                                                              MD055681
026900210712     C+ , LCD                                                                               MD055681
027000210712     C+ , TYLC                                                                              MD055681
027100210712     C+ , ZONE                                                                              MD055681
027200210712     C+ , ENABLD                                                                            MD055681
027300210712     C+ , MODE                                                                              MD055681
027400210712     C+ )                                                                                   MD055681
027500210712     C+ Values                                                                              MD055681
027600210712     C+ (                                                                                   MD055681
027700210712     C+   :XXFeat                                                                           MD055681
027800210712     C+ , 0                                                                                 MD055681
027900210712     C+ , 'I'                                                                               MD055681
028000210712     C+ , ' '                                                                               MD055681
028100210712     C+ , 'E'                                                                               MD055681
028200210712     C+ , 'B'                                                                               MD055681
028300210712     C+ )                                                                                   MD055681
028400210712     C/END-EXEC                                                                             MD055681
028500210712      *
028600210712     C**********         IF        %ERROR                                                   MD055681
028700210712     C                   IF        SQLCODE <> 0                                             MD055681
028800210712     C                   EVAL      Msg = 'Write to SCSARDL0 ended in error.'
028900210712     C                   EXSR      *PSSR
029000210712     C                   ENDIF
029100210712      *
029200210712     C                   ENDSR
029300210712      *
029400210712      /EJECT
029500210712      *****************************************************************
029600210712      *                                                               *
029700210712      *  SrWritePass - Insert SCPASSPD Record                         *
029800210712      *                                                               *
029900210712      *****************************************************************
030000210712     C     SrWritePass   BEGSR
030100210712      *
030200210712     C                   CLEAR                   SCPASSD0
030300210712     C                   EVAL      PASS = PWord(I)
030400210712     C                   EVAL      P@SARN = Feat(I)
030500210712     C                   EVAL      WriteFlag = 'Y'
030600210712     C                   WRITE(E)  SCPASSD0
030700210712      *
030800210712     C                   IF        %ERROR
030900210712     C                   EVAL      Msg = 'Write to SCPASSPD ended in error.'
031000210712     C                   EXSR      *PSSR
031100210712     C                   ENDIF
031200210712      *
031300210712     C                   ENDSR
031400210712      *
031500210712      /EJECT
031600210712      *****************************************************************
031700210712      *                                                               *
031800210712      *  SrCache - Call Caching of Features                           *
031900210712      *                                                               *
032000210712      *****************************************************************
032100210712     C     SrCache       BEGSR
032200210712      *
032300210712     C                   IF        WriteFlag = 'Y'
032400210712      *
032500210712      ** Call the caching of feature in SCSARHTD.
032600210712      *
032700210712     C                   CALL(E)   'SC000300'
032800210712      *
032900210712     C                   IF        %ERROR
033000210712     C                   EVAL      Msg = 'Call to SC000300 ended in error...'
033100210712     C                   EXSR      *PSSR
033200210712     C                   ENDIF
033300210712      *
033400210712      ** Set CACHEDT (data area) to Y, to enable Caching of URL
033500210712      ** in the next component.
033600210712      *
033700210712     C     *LOCK         IN(E)     CACHEDT
033800210712     C                   EVAL      SCACHE = 'Y'
033900210712     C                   OUT       CACHEDT
034000210712
034100210712     C                   IF        %ERROR
034200210712     C                   EVAL      Msg = 'Access to CACHEDT-Data Area ' +
034300210712     C                             'ended in error.'
034400210712     C                   EXSR      *PSSR
034500210712     C                   ENDIF
034600210712      *
034700210712     C                   ENDIF
034800210712      *
034900210712     C                   ENDSR
035000210712      *
035100210712      /EJECT
035200210712      *****************************************************************
035300210712      *                                                               *
035400210712      *  *INZSR - Initialise                                          *
035500210712      *                                                               *
035600210712      *****************************************************************
035700210712     C     *INZSR        BEGSR
035800210712      *
035900210712      ** Call Access Program for Bank Details - Title, Run Date and
036000210712      ** Run Day Number.
036100210712      *
036200210712     C                   CALL      'AOBANKR0'
036300210712     C                   PARM      '*MSG   '     PRetCode
036400210712     C                   PARM      '*FIRST '     POption
036500210712     C     SDBank        PARM      SDBank        DSFDY
036600210712      *
036700210712      ** Initialize Data Area to blanks.
036800210712      *
036900210712     C     *LOCK         IN(E)     CACHEDT
037000210712     C                   EVAL      SCACHE = *BLANKS
037100210712     C                   OUT       CACHEDT
037200210712     C                   ENDSR
037300210712      *
037400210712      /EJECT
037500210712      *****************************************************************
037600210712      *                                                               *
037700210712      *  *PSSR - Program exception error routine                      *
037800210712      *                                                               *
037900210712      *  Called By: Automatically If a program error occurs,          *
038000210712      *             or directly by the program code using EXSR.       *
038100210712      *             This subroutine DUMPs the program just once.      *
038200210712      *                                                               *
038300210712      *****************************************************************
038400210712     C     *PSSR         BEGSR
038500210712      *
038600210712     C                   IF        WRun = *BLANKS
038700210712      *
038800210712     C                   EVAL      WRun = 'Y'
038900210712     C                   DUMP
039000210712      *
039100210712     C                   ENDIF
039200210712      *
039300210712     C                   EVAL      *INU7 = *ON
039400210712     C                   EVAL      *INU8 = *ON
039500210712     C                   EVAL      *INLR = *ON
039600210712     C                   RETURN
039700210712      *
039800210712     C                   ENDSR
039900210712      *****************************************************************
