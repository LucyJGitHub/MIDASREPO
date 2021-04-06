000100210405     H DEBUG
000101210405     H DFTACTGRP(*NO) BNDDIR('HTTPAPI') BNDDIR('YAJL')
000102210405     H COPYRIGHT('(c) Finastra International Limited 2020')
000103210405      *****************************************************************
000104210405/*STD *  RPGSQLBND                                                    *
000105210405/*EXI *  TEXT('Midas SD API - Invoke ARR Calculator')                 *
000106210405      *****************************************************************
000107210405      *                                                               *
000108210405      *  Midas - Midas Standing Data API - Invoke ARR Calculator      *
000109210405      *                                                               *
000110210405      *  ZAGETCALRT Midas API - Invoke ARR Calculator                 *
000111210405      *                                                               *
000112210405      *  (c) Finastra International Limited 2020                      *
000113210405      *                                                               *
000114210405      *  Last Amend No. CSD103  *CREATE    Date 10Aug20               *
000115210405      *                                                               *
000116210405      *****************************************************************
000117210405      *                                                               *
000118210405      *  CSD103 - LIBOR Deregulation - Common Laye Standing Data      *
000119210405      *                                                               *
000120210405      *****************************************************************
000121210405
000122210405      **---------------------------------------------------------------
000123210405      ** The following /COPY line includes all the defined fields in
000124210405      ** the Program Status Data Structures.  They have meaningful
000125210405      ** names, prefixed by 'PS'.
000126210405
000127210405      *
000128210405      ** Scott Clements library for JSON Parse and HTTP calls
000129210405     D/INCLUDE LIBHTTP123/QRPGLESRC,YAJL_H
000130210405     D/INCLUDE LIBHTTP123/QRPGLESRC,HTTPAPI_H
000131210405
000132210405     D/COPY ZACPYSRC,PSDS
000133210405     D/COPY ZACPYSRC,STD_D_SPEC
000134210405     D/COPY ZSRSRC,ZINTDYZ1LE
000135210405     D/COPY ZSRSRC,ZHOLILE
000136210405     D/COPY ZSRSRC,ZHOLELE
000137210405
000138210405      ** +--------------------------------------+
000139210405      ** ¦ Program Prototypes                   ¦
000140210405      ** ¦ ==================                   ¦
000141210405      ** +--------------------------------------+
000142210405
000143210405     D ACCESS_SVAL     PR                  EXTPGM('AOSVALR0')
000144210405     D pRetCode                       7A
000145210405     D pOP01                         20A
000146210405     D pVL01                        200A
000147210405     D pOP02                         20A
000148210405     D pVL02                        200A
000149210405     D pOP03                         20A
000150210405     D pVL03                        200A
000151210405     D pOP04                         20A
000152210405     D pVL04                        200A
000153210405     D pOP05                         20A
000154210405     D pVL05                        200A
000155210405     D pOP06                         20A
000156210405     D pVL06                        200A
000157210405     D pOP07                         20A
000158210405     D pVL07                        200A
000159210405     D pOP08                         20A
000160210405     D pVL08                        200A
000161210405     D pOP09                         20A
000162210405     D pVL09                        200A
000163210405     D pOP10                         20A
000164210405     D pVL10                        200A
000165210405
000166210405     D  ACCESS_SDBANK  pr                  extpgm('AOBANKR0')
000167210405     D    pReturnCode                 7A
000168210405     D    pOption                     7A
000169210405     D    pDSFDY                    200A
000170210405
000171210405     D  CONVERT_DATE   pr                  extpgm('ZDATE1')
000172210405     D    ErrorFlag                   7a
000173210405     D    DateIN                      6p 0
000174210405     D    DateInd                     1a
000175210405     D    DateOUT                     5p 0
000176210405
000177210405      *  +----------------+
000178210405      ** |Parameter lists |
000179210405      ** +----------------+
000180210405
000181210405     D Main            pr                  extpgm('ZAGETCALRT')
000182210405      **-----------------------------------------------------**
000183210405     D  moduleID                      2a
000184210405      ** Module ID
000185210405      **--** LE - Lending
000186210405      **--** DL - Dealing
000187210405      **--** FR - FRA/IRS
000188210405     D  transactREF                   6a
000189210405      ** Transaction Reference
000190210405     D  calcMethod                    4a
000191210405      ** Calculation Method
000192210405      **--** NCCR - Daily Compounding in Arrears (Non-Cumulative Compounded Rate)
000193210405      **--** CCR  - Average Compounded In Arrears (Cumulative Compounded Rate)
000194210405      **--** SARR - Simple ARR
000195210405      **--** SAVG - Simple Average
000196210405     D  intPrdStartDt                10a
000197210405      ** Interest Period Start Date
000198210405     D  intPrdStrMDAY                 5a
000199210405      ** Interest Period Start Date in Midas Day
000200210405     D  intPrdEndDt                  10a
000201210405      ** Interest Period End Date
000202210405     D  intPrdEndMDAY                 5a
000203210405      ** Interest Period End Date in Midas Day
000204210405     D  riskFreeRate                  5a
000205210405      ** Risk Free Rate
000206210405     D  riskFreeRatFl                20a
000207210405      ** Risk Free Rate Floor
000208210405     D  lookBackDays                  2a
000209210405      ** Lookback Days
000210210405     D  obserPrdShift                 5a
000211210405      ** Observation Period Shift
000212210405      ** True/False
000213210405     D  RateRndDecPts                 3a
000214210405      ** Rate Rounding Decimal Points
000215210405     D  dayCntConvent                 7a
000216210405      ** Day Count Convention
000217210405     D  lockOutDays                   2a
000218210405      ** Lockout Days
000219210405     D  showDailyDeta                 5a
000220210405      ** Show Dailty Details
000221210405      ** True/False
000222210405     D  callTillDate                 10a
000223210405      ** Calculate Till Date
000224210405     D  benchMarkAdj                 20a
000225210405      ** Benchmark Adjustment
000226210405     D  ratesKnownInd                 1a
000227210405      ** Rates Known Indicator
000228210405     D  returnCD                     20a
000229210405      ** Return Code
000230210405
000231210405     D Main            pi
000232210405      **-----------------------------------------------------**
000233210405     D  moduleID                      2a
000234210405      ** Module ID
000235210405      **--** LE - Lending
000236210405      **--** DL - Dealing
000237210405      **--** FR - FRA/IRS
000238210405     D  transactREF                   6a
000239210405      ** Transaction Reference
000240210405     D  calcMethod                    4a
000241210405      ** Calculation Method
000242210405      **--** NCCR - Daily Compounding in Arrears (Non-Cumulative Compounded Rate)
000243210405      **--** CCR  - Average Compounded In Arrears (Cumulative Compounded Rate)
000244210405      **--** SARR - Simple ARR
000245210405      **--** SAVG - Simple Average
000246210405     D  intPrdStartDt                10a
000247210405      ** Interest Period Start Date
000248210405     D  intPrdStrMDAY                 5a
000249210405      ** Interest Period Start Date in Midas Day
000250210405     D  intPrdEndDt                  10a
000251210405      ** Interest Period End Date
000252210405     D  intPrdEndMDAY                 5a
000253210405      ** Interest Period End Date in Midas Day
000254210405     D  riskFreeRate                  5a
000255210405      ** Risk Free Rate
000256210405     D  riskFreeRatFl                20a
000257210405      ** Risk Free Rate Floor
000258210405     D  lookBackDays                  2a
000259210405      ** Lookback Days
000260210405     D  obserPrdShift                 5a
000261210405      ** Observation Period Shift
000262210405      ** True/False
000263210405     D  RateRndDecPts                 3a
000264210405      ** Rate Rounding Decimal Points
000265210405     D  dayCntConvent                 7a
000266210405      ** Day Count Convention
000267210405     D  lockOutDays                   2a
000268210405      ** Lockout Days
000269210405     D  showDailyDeta                 5a
000270210405      ** Show Dailty Details
000271210405      ** True/False
000272210405     D  callTillDate                 10a
000273210405      ** Calculate Till Date
000274210405     D  benchMarkAdj                 20a
000275210405      ** Benchmark Adjustment
000276210405     D  ratesKnownInd                 1a
000277210405      ** Rates Known Indicator
000278210405     D  returnCD                     20a
000279210405      ** Return Code
000280210405
000281210405      ** +--------------------------------------+
000282210405      ** ¦ Manually included D-specs            ¦
000283210405      ** ¦ =========================            ¦
000284210405      ** +--------------------------------------+
000285210405      ** +--------------------------------------+
000286210405
000287210405      ** Extract file for LE0370 consumption and BR event creation
000288210405     D LELIBEDS      e ds                  extname(LELIBEPD)
000289210405     D ExtractFLDS     ds                  likeds(LELIBEDS)
000290210405
000291210405      ** Audit Log
000292210405     D SDARRLDS      e ds                  extname(SDARRLOGTD)
000293210405     D AuditLogDS      ds                  likeds(SDARRLDS)
000294210405
000295210405      ** ARR Daily Rates History File
000296210405     D ARRDLYDS      e ds                  extname(SDHSDRTD)
000297210405     D DailyHistDS     ds                  likeds(ARRDLYDS)
000298210405
000299210405      ** Core data structures
000300210405     D dssdy         e ds                  extname(DSSDY)
000301210405     D dsfdy         e ds                  extname(DSFDY)
000302210405
000303210405      ** +--------------------------------------+
000304210405      ** ¦ Constants declaration                ¦
000305210405      ** ¦ =====================                ¦
000306210405      ** +--------------------------------------+
000307210405
000308210405     D AMP             c                   const('&')
000309210405     D HTTP_HEAD       c                   const('http://')
000310210405     D INSERT          c                   const(0)
000311210405     D LELIBEPD        c                   const(1)
000312210405     D NO_ERROR        c                   const(0)
000313210405     D NO_RECORD       c                   const(100)
000314210405     D QUE             c                   const('?')
000315210405     D QUO             c                   const('''')
000316210405     D SDHSDRTD        c                   const(0)
000317210405     D UPDATE          c                   const(1)
000318210405
000319210405      ** +--------------------------------------+
000320210405      ** ¦ Variable declaration                 ¦
000321210405      ** ¦ ====================                 ¦
000322210405      ** +--------------------------------------+
000323210405      ** AOSVALR0 Parameters
000324210405     D pRetCode        S              7A
000325210405     D pOP01           S             20A
000326210405     D pVL01           S            200A
000327210405     D pOP02           S             20A
000328210405     D pVL02           S            200A
000329210405     D pOP03           S             20A
000330210405     D pVL03           S            200A
000331210405     D pOP04           S             20A
000332210405     D pVL04           S            200A
000333210405     D pOP05           S             20A
000334210405     D pVL05           S            200A
000335210405     D pOP06           S             20A
000336210405     D pVL06           S            200A
000337210405     D pOP07           S             20A
000338210405     D pVL07           S            200A
000339210405     D pOP08           S             20A
000340210405     D pVL08           S            200A
000341210405     D pOP09           S             20A
000342210405     D pVL09           S            200A
000343210405     D pOP10           S             20A
000344210405     D pVL10           S            200A
000345210405
000346210405      ** Work variables
000347210405     D i               s             10i 0
000348210405     D err             s             10i 0
000349210405     D msg             s             52a
000350210405     D jsonData        s         999999a   varying
000351210405     D RestAPIParm     s          65535a   varying inz(*blanks)
000352210405     D CalcMetURL      s            500a   varying inz(*blanks)
000353210405     D wSqlStr         S           2000A   INZ(*BLANKS)
000354210405     D pReturnCode     s              7a
000355210405     D pOption         s              7a
000356210405     D ErrorFlag       s              7a
000357210405     D DateIN          s              6p 0
000358210405     D DateOUT         s              5p 0
000359210405     D transactDate    s              5p 0
000360210405     D fileToCheck     s              1s 0
000361210405     D lastElem        s             10i 0
000362210405     D errMsg          s            500a   varying inz('')
000363210405     D action          s              1s 0
000364210405     D errorMessage    s            100a
000365210405     D includeRecord   s              1a   inz('N')
000366210405     D compAveRate     s             30p 9 inz(0)
000367210405     D logData         s          25000a   varying
000368210405     D isError         s               n   inz(false)
000369210405     D isException     s               n   inz(false)
000370210405     D writeLogs       S              1a
000371210405
000372210405      *---------------*
000373210405      ** JSON Details *
000374210405      *---------------*
000375210405
000376210405     D summary_t       ds                  qualified
000377210405     D                                     template
000378210405     D   intPrdDate                  10a
000379210405      ** Interest Period Date
000380210405      ** NCCR, CCR, SAVG, SARR
000381210405     D   intPDMidas                   5p 0
000382210405      ** Interest Period Date in Midas Format
000383210405     D   intPrdDays                   5s 0
000384210405      ** Interest Period Days
000385210405      ** NCCR, CCR, SAVG, SARR
000386210405     D   obsPrdDate                  10a
000387210405      ** Observation Period Date
000388210405      ** NCCR
000389210405     D   intOPMidas                   5p 0
000390210405      ** Observation Period Date in Midas Format
000391210405     D   obsPrdDays                   5s 0
000392210405      ** Observation Period Days
000393210405      ** NCCR
000394210405     D   pubRskFrRt                  30p 9
000395210405      ** Published Risk Free Rate
000396210405      ** NCCR, CCR, SAVG, SARR
000397210405     D   rateApplied                 30p 9
000398210405      ** Rate Applied
000399210405      ** NCCR, CCR, SAVG, SARR
000400210405     D   rskFrRtFlAp                  5a
000401210405      ** Risk Free Rate Floor Applied
000402210405      ** NCCR, CCR, SAVG, SARR
000403210405     D   compFactor                  10a
000404210405      ** Compounding Factor
000405210405      ** NCCR
000406210405     D   dlyCompRate                 10a
000407210405      ** Daily Compunded Rate
000408210405      ** NCCR
000409210405     D   aveCompRate                 10a
000410210405      ** Average Compunded Rate
000411210405      ** CCR
000412210405     D   simpleAve                   10a
000413210405      ** Simple Average
000414210405      ** SAVG
000415210405
000416210405     D request_t       ds                  qualified
000417210405     D                                     template
000418210405     D   intPrdStart                 10a
000419210405      ** Interest Period Start
000420210405     D   intPrdEnd                   10a
000421210405      ** Interest Period End
000422210405     D   rskFreeRate                  4a
000423210405      ** Risk Free Rate
000424210405     D   rskFreeRtFl                 15s 6
000425210405      ** Risk Free Rate Floor
000426210405     D   obsPrdShift                  8s 0
000427210405      ** Observation Period Shift
000428210405     D   ratRndDecPts                 8s 0
000429210405      ** Rate Rounding Decimal Points
000430210405     D   showDailyDet                 8s 0
000431210405      ** Show Daily Details
000432210405
000433210405     D result          ds                  qualified
000434210405     D   success                      1n
000435210405      ** Success
000436210405     D   errmsg                     500a   varying
000437210405      ** Error Message
000438210405     D   statusCode                   4a   varying
000439210405      ** Status Code
000440210405     D   message                     10a   varying
000441210405      ** Message
000442210405     D   comment                    500a   varying
000443210405      ** Comment
000444210405     D   lastUpdFrSrc               200a   varying
000445210405      ** Last Updated From Source
000446210405     D   legalDisc                  200a   varying
000447210405      ** Legal Disclaimer
000448210405     D   reqParms                          likeds(request_t)
000449210405      ** Request Parameters
000450210405     D   list                              likeds(summary_t) dim(999)
000451210405      ** Daily Rate Summary
000452210405     D   errors                            likeds(exception_t)
000453210405      ** Exception Parameters
000454210405
000455210405     D exception_t     ds                  qualified
000456210405     D                                     template
000457210405     D   title                       50a
000458210405      ** Title
000459210405     D   exceptionMsg               100a
000460210405      ** Exception Message
000461210405     D   status                       4a
000462210405      ** Status
000463210405
000464210405     D SDBANK        e ds                  extname(SDBANKPD)
000465210405     D                 DS
000466210405     D ISODate                 1     10
000467210405     D WkYear                  3      4  0
000468210405     D WkMonth                 6      7  0
000469210405     D WkDay                   9     10  0
000470210405
000471210405     D                 DS
000472210405     D YYMMDD                  1      6
000473210405     D WkY                     1      2
000474210405     D WkM                     3      4
000475210405     D WkD                     5      6
000476210405
000477210405     D                 DS
000478210405     D DateIN_D                1      6  0
000479210405     D DD1D                    1      2  0
000480210405     D DD1M                    3      4  0
000481210405     D DD1Y                    5      6  0
000482210405     D                 DS
000483210405     D DateIN_M                1      6  0
000484210405     D DD2M                    1      2  0
000485210405     D DD2D                    3      4  0
000486210405     D DD2Y                    5      6  0
000487210405
000488210405     D reqParms        s                   like(yajl_val)
000489210405     D errors          s                   like(yajl_val)
000490210405     D docNode         s                   like(yajl_val)
000491210405     D list            s                   like(yajl_val)
000492210405     D node            s                   like(yajl_val)
000493210405     D val             s                   like(yajl_val)
000494210405     D cStr            S             10a   Varying
000495210405
000496210405      ** +--------------------------------------+
000497210405      ** ¦ Array declaration                    ¦
000498210405      ** ¦ ==================                   ¦
000499210405      ** +--------------------------------------+
000500210405
000501210405     D arrCalLoc       s            100a   dim(4) ctdata perrcd(1)
000502210405
000503210405      /free
000504210405
000505210405       // ** +--- Start of Main processing -----------------------------------+
000506210405       // ** ¦                                                                ¦
000507210405       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
000508210405       // ** ¦ executed at program activation.                                ¦
000509210405       // ** ¦                                                                ¦
000510210405       // ** +----------------------------------------------------------------+
000511210405
000512210405                   exsr processTransaction;
000513210405
000514210405                   *Inlr = *On;
000515210405                   return;
000516210405
000517210405       //*************************************************************
000518210405       /EJECT
000519210405       //*************************************************************
000520210405       //                                                            *
000521210405       // inzsr - Program Initialisation routine                     *
000522210405       //                                                            *
000523210405       // Called by: Main processing                                 *
000524210405       //                                                            *
000525210405       //  Calls: None                                               *
000526210405       //                                                            *
000527210405       //*************************************************************
000528210405
000529210405       begsr *inzsr;
000530210405
000531210405                   //Initialise audit log DS
000532210405                   clear AuditLogDS;
000533210405                   isError = false;
000534210405
000535210405                   AuditLogDS.SJMODI = moduleID;
000536210405                   AuditLogDS.SJTREF = transactREF;
000537210405                   AuditLogDS.SJSTAT = 'C';
000538210405                   AuditLogDS.SJMDAY = 0;
000539210405
000540210405                   pOption = '*FIRST';
000541210405                   pReturnCode = *Blanks;
000542210405
000543210405                   callp ACCESS_SDBANK(
000544210405                                  pReturnCode
000545210405                                : pOption
000546210405                                : dsfdy
000547210405                               );
000548210405                   SDBANK = dsfdy;
000549210405
000550210405                   if pReturnCode <> *blanks;
000551210405                      AuditLogDS.SJTMST = %timestamp();
000552210405                      AuditLogDS.SJEXMS = 'Error in access SDBANKPD';
000553210405                      AuditLogDS.SJCODE = '001';
000554210405                      isError = True;
000555210405                      exsr errorHandler;
000556210405                   endif;
000557210405
000558210405                   AuditLogDS.SJMDAY = BJRDNB;
000559210405                   pOP01 = 'ARRAdapterURL';
000560210405                   pOP02 = 'ARRCalculatorTrace';
000561210405
000562210405                   CallP ACCESS_SVAL(
000563210405                                       pRetCode
000564210405                                     : pOP01
000565210405                                     : pVL01
000566210405                                     : pOP02
000567210405                                     : pVL02
000568210405                                     : pOP03
000569210405                                     : pVL03
000570210405                                     : pOP04
000571210405                                     : pVL04
000572210405                                     : pOP05
000573210405                                     : pVL05
000574210405                                     : pOP06
000575210405                                     : pVL06
000576210405                                     : pOP07
000577210405                                     : pVL07
000578210405                                     : pOP08
000579210405                                     : pVL08
000580210405                                     : pOP09
000581210405                                     : pVL09
000582210405                                     : pOP10
000583210405                                     : pVL10
000584210405                                       );
000585210405
000586210405                   If pRetCode <> *Blanks;
000587210405                        AuditLogDS.SJTMST = %timestamp();
000588210405                        AuditLogDS.SJEXMS = 'Error in access SDSVALPD ' +
000589210405                          %trim(Pvl01);
000590210405                        AuditLogDS.SJCODE = '002';
000591210405                        isError = True;
000592210405                        exsr errorHandler;
000593210405                   Endif;
000594210405
000595210405                   If pVL01 <> *Blanks;
000596210405                         CalcMetURL     = HTTP_HEAD  + %trim(pVL01);
000597210405                   Else;
000598210405                        AuditLogDS.SJTMST = %timestamp();
000599210405                        AuditLogDS.SJEXMS = 'Error in access SDSVALPD ' +
000600210405                          %trim(calcMetURL);
000601210405                        AuditLogDS.SJCODE = '003';
000602210405                        isError = True;
000603210405                        exsr errorHandler;
000604210405                   Endif;
000605210405
000606210405                   writeLogs = pVL02;
000607210405
000608210405                   select;
000609210405
000610210405                       when calcMethod = 'NCCR';
000611210405                            calcMetURL =  %trim(calcMetURL) +
000612210405                              %trim(arrCalLoc(1));
000613210405
000614210405                       when calcMethod = 'CCR';
000615210405                            calcMetURL =  %trim(calcMetURL) +
000616210405                              %trim(arrCalLoc(2));
000617210405
000618210405                       when calcMethod = 'SARR';
000619210405                            calcMetURL =  %trim(calcMetURL) +
000620210405                              %trim(arrCalLoc(3));
000621210405
000622210405                       when calcMethod = 'SAVG';
000623210405                            calcMetURL =  %trim(calcMetURL) +
000624210405                              %trim(arrCalLoc(4));
000625210405
000626210405                   endsl;
000627210405
000628210405                   // Get the highest date in the Daily History file
000629210405                   wSQLStr = 'select * from SDHSDRTD ' +
000630210405                             ' where CMODID = ' + QUO + moduleID + QUO +
000631210405                             ' and CTRNID = ' +  QUO + transactREF + QUO +
000632210405                             ' order by CINPDT DESC';
000633210405
000634210405                   exec sql prepare P1 from :wSQLStr;
000635210405                   exec sql declare P1 cursor for P1;
000636210405                   exec sql open P1;
000637210405                   exec sql fetch next From P1 into :DailyHistDS;
000638210405
000639210405                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
000640210405                        AuditLogDS.SJTMST = %timestamp();
000641210405                        AuditLogDS.SJEXMS = 'Error in access SDHSDRTD ' +
000642210405                          %trim(wSQLSTR);
000643210405                        AuditLogDS.SJCODE = '004';
000644210405                        isError = True;
000645210405                        exsr errorHandler;
000646210405                   endif;
000647210405
000648210405                   if sqlCod = NO_RECORD;
000649210405                      transactDate = 0;
000650210405                   else;
000651210405                      transactDate = DailyHistDS.CINPDT;
000652210405                   endif;
000653210405
000654210405                   exec sql close P1;
000655210405
000656210405                   // Initialize Current Interest Period Flag to N
000657210405                   exec sql  update SDHSDRTD set CINFLG = 'N'
000658210405                    where CMODID = :moduleID
000659210405                    and   CTRNID = :transactREF;
000660210405
000661210405                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
000662210405                     AuditLogDS.SJTMST = %timestamp();
000663210405                     AuditLogDS.SJEXMS = 'Error in access SDHSDRTD '
000664210405                                       + 'SQL ERROR ' + %char(sqlCod);
000665210405                     AuditLogDS.SJCODE = '005';
000666210405                     isError = true;
000667210405                     exsr errorHandler;
000668210405                   endif;
000669210405
000670210405       endsr;
000671210405
000672210405       //*************************************************************
000673210405       /EJECT
000674210405       //*************************************************************
000675210405       //                                                            *
000676210405       // processTransaction - Process a Loan Transaction            *
000677210405       // ==================                                         *
000678210405       //                                                            *
000679210405       // Called by: Main Processing                                 *
000680210405       //                                                            *
000681210405       // Calls: None                                                *
000682210405       //                                                            *
000683210405       //*************************************************************
000684210405
000685210405       begsr processTransaction;
000686210405
000687210405                   //** This will build the URL parameter for the Rest API Call
000688210405
000689210405                   exsr buildParameter;
000690210405
000691210405                   //** This will call the http_string function from LIBHTTP123
000692210405                   //** to consume the Rest API
000693210405
000694210405                   exsr consumeRESTAPI;
000695210405
000696210405                   if not(isError);
000697210405
000698210405                      //** This will parse the JSON data returned from ARR Calculator
000699210405                      //** and store it to an array of Data Structure
000700210405
000701210405                      exsr parseJSONData;
000702210405
000703210405                      //** This will handle the output of the array DS to the
000704210405                      //** history and extract files
000705210405
000706210405                      exsr outputFiles;
000707210405
000708210405                      //** log details to audit file
000709210405
000710210405                      exsr writeToAuditLog;
000711210405
000712210405                   endif;
000713210405
000714210405       endsr;
000715210405
000716210405       //*************************************************************
000717210405       /EJECT
000718210405       //*************************************************************
000719210405       //                                                            *
000720210405       // buildParameter - Build REST API Parameter                  *
000721210405       // ==============                                             *
000722210405       //                                                            *
000723210405       // Called by: processTransaction                              *
000724210405       //                                                            *
000725210405       // Calls: None                                                *
000726210405       //                                                            *
000727210405       //*************************************************************
000728210405
000729210405       begsr buildParameter;
000730210405
000731210405                   RestAPIParm =    %trim(CalcMetURL) +
000732210405                                 QUE + 'interestPeriodStartDate=' +
000733210405                                    %trim(intPrdStartDt) +
000734210405                                 AMP + 'interestPeriodEndDate=' +
000735210405                                    %trim(intPrdEndDt) +
000736210405                                 AMP + 'riskFreeRate=' +
000737210405                                    %trim(riskFreeRate) +
000738210405                                 AMP + 'lookBackDays=' +
000739210405                                    %trim(lookBackDays)  +
000740210405                                 AMP + 'rateRoundingDecimalPoints=' +
000741210405                                    %trim(RateRndDecPts) +
000742210405                                 AMP + 'observationPeriodShift=' +
000743210405                                    %trim(obserPrdShift) +
000744210405                                 AMP + 'lockoutDays=' +
000745210405                                    %trim(lockOutDays) +
000746210405                                 AMP + 'showDailyDetails=' +
000747210405                                    %trim(showDailyDeta) +
000748210405                                 AMP + 'calculateTillDate=' +
000749210405                                    %trim(callTillDate) +
000750210405                                 AMP + 'riskFreeRateFloor=' +
000751210405                                    %trim(riskFreeRatFl);
000752210405
000753210405       endsr;
000754210405
000755210405       //*************************************************************
000756210405       /EJECT
000757210405       //*************************************************************
000758210405       //                                                            *
000759210405       // consumeRESTAPI - Consume REST API                          *
000760210405       // ==============                                             *
000761210405       //                                                            *
000762210405       // Called by: processTransaction                              *
000763210405       //                                                            *
000764210405       // Calls: LIBHTTP123 http_string                              *
000765210405       //                                                            *
000766210405       //*************************************************************
000767210405
000768210405       begsr consumeRestAPI;
000769210405
000770210405              monitor;
000771210405
000772210405                 clear jsonData;
000773210405                 jsonData = http_string( 'GET' : %trim(RestAPIParm));
000774210405                 msg = *blanks;
000775210405                 err = 0;
000776210405
000777210405              on-error;
000778210405
000779210405                 msg = http_error(err);
000780210405                 errorMessage = %trim(msg);
000781210405                 returnCD = 'CONNECTION_ERROR';
000782210405                 isError = True;
000783210405                 AuditLogDS.SJTMST = %timestamp();
000784210405                 AuditLogDS.SJEXMS = %trim(msg);
000785210405                 AuditLogDS.SJCODE = '999';
000786210405                 exsr errorHandler;
000787210405
000788210405              endmon;
000789210405
000790210405       endsr;
000791210405
000792210405       //*************************************************************
000793210405       /EJECT
000794210405       //*************************************************************
000795210405       //                                                            *
000796210405       // parseJSONData - Parse JSON Data                            *
000797210405       // =============                                              *
000798210405       //                                                            *
000799210405       // Called by: processTransaction                              *
000800210405       //                                                            *
000801210405       // Calls: None                                                *
000802210405       //                                                            *
000803210405       //*************************************************************
000804210405
000805210405       begsr parseJSONData;
000806210405
000807210405                   // Load JSON data variable into a tree like structure
000808210405
000809210405                   docNode = yajl_buf_load_tree( %addr(jsonData:*data)
000810210405                             : %len(jsonData)
000811210405                             : ErrMsg );
000812210405
000813210405                   if errMsg <> '';
000814210405                      errorMessage = errMsg;
000815210405                      isError = true;
000816210405                      exsr errorHandler;
000817210405                   endif;
000818210405
000819210405                   node = YAJL_object_find(docNode: 'comment');
000820210405                   result.comment = YAJL_get_string(node);
000821210405
000822210405                   node = YAJL_object_find(docNode: 'errmsg');
000823210405                   result.errmsg  = yajl_get_string(val);
000824210405
000825210405                   // Exception messages
000826210405                   node = YAJL_object_find(docNode: 'exception');
000827210405                   if node <> *null;
000828210405
000829210405                       isException = true;
000830210405                       val = YAJL_object_find(node: 'title');
000831210405                       result.errors.title = yajl_get_string(val);
000832210405
000833210405                       val = YAJL_object_find(node: 'exceptionMessage');
000834210405                       result.errors.exceptionMsg = yajl_get_string(val);
000835210405
000836210405                       val = YAJL_object_find(node: 'status');
000837210405                       result.errors.status = yajl_get_string(val);
000838210405
000839210405                       // free up memory used by YAJL
000840210405                       yajl_tree_free(docNode);
000841210405
000842210405                       exsr errorHandler;
000843210405
000844210405                   endif;
000845210405
000846210405
000847210405                   list = YAJL_object_find(docNode: 'dailyRateSummary');
000848210405
000849210405                   clear result.list;
000850210405
000851210405                   i = 0;
000852210405                   dow YAJL_ARRAY_LOOP( list: i: node );
000853210405
000854210405                       lastElem = i;
000855210405
000856210405                       // All calculation methods
000857210405                       val = YAJL_object_find(node: 'interestPeriodDate');
000858210405                       result.list(i).intPrdDate = yajl_get_string(val);
000859210405
000860210405                       ISODate =  result.list(i).intPrdDate;
000861210405
000862210405                       monitor;
000863210405
000864210405                           WKY = %editc(wkYear:'X');
000865210405                           WKM = %editc(wkMonth:'X');
000866210405                           WKD = %editc(wkDay:'X');
000867210405
000868210405                           if BJDFIN = 'D';
000869210405                              DD1D = wkDay;
000870210405                              DD1M = wkMonth;
000871210405                              DD1Y = wkYear;
000872210405                              DateIn = DateIn_D;
000873210405                           else;
000874210405                              DD2D = wkDay;
000875210405                              DD2M = wkMonth;
000876210405                              DD2Y = wkYear;
000877210405                              DateIn = DateIn_M;
000878210405                           endif;
000879210405
000880210405                           pOption = '*FIRST';
000881210405                           pReturnCode = *Blanks;
000882210405                           callp CONVERT_DATE(
000883210405                                      ErrorFlag
000884210405                                    : DateIN
000885210405                                    : BJDFIN
000886210405                                    : DateOUT
000887210405                                   );
000888210405
000889210405                           if ErrorFlag   <> *blanks;
000890210405                                AuditLogDS.SJTMST = %timestamp();
000891210405                                AuditLogDS.SJEXMS = 'Error in date conversion';
000892210405                                AuditLogDS.SJCODE = '006';
000893210405                                isError = True;
000894210405                                exsr errorHandler;
000895210405                           endif;
000896210405
000897210405                           result.list(i).intPDMidas = DateOUT;
000898210405
000899210405                       on-error;
000900210405                       endmon;
000901210405
000902210405                       // All calculation methods
000903210405                       val = YAJL_object_find(node: 'interestPeriodDays');
000904210405                       cStr =  yajl_get_string(val);
000905210405                       result.list(i).intPrdDays =  %dec(%trim(cStr):5:0);
000906210405
000907210405                       val =
000908210405                          YAJL_object_find(node: 'observationPeriodDate');
000909210405                       result.list(i).obsPrdDate =
000910210405                          yajl_get_string(val);
000911210405
000912210405                       ISODate =  result.list(i).obsPrdDate;
000913210405
000914210405                       monitor;
000915210405                            WKY = %editc(wkYear:'X');
000916210405                            WKM = %editc(wkMonth:'X');
000917210405                            WKD = %editc(wkDay:'X');
000918210405
000919210405                            if BJDFIN = 'D';
000920210405                                 DD1D = wkDay;
000921210405                                 DD1M = wkMonth;
000922210405                                 DD1Y = wkYear;
000923210405                                 DateIn = DateIn_D;
000924210405                            else;
000925210405                                 DD2D = wkDay;
000926210405                                 DD2M = wkMonth;
000927210405                                 DD2Y = wkYear;
000928210405                                 DateIn = DateIn_M;
000929210405                             endif;
000930210405
000931210405                             pOption = '*FIRST';
000932210405                             pReturnCode = *Blanks;
000933210405                             callp CONVERT_DATE(
000934210405                                  ErrorFlag
000935210405                                : DateIN
000936210405                                : BJDFIN
000937210405                                : DateOUT
000938210405                               );
000939210405
000940210405                             if ErrorFlag   <> *blanks;
000941210405                                AuditLogDS.SJTMST = %timestamp();
000942210405                                AuditLogDS.SJEXMS = 'Error in date conversion';
000943210405                                AuditLogDS.SJCODE = '007';
000944210405                                isError = True;
000945210405                                exsr errorHandler;
000946210405                             endif;
000947210405
000948210405                             result.list(i).intOPMidas = DateOUT;
000949210405
000950210405                       on-error;
000951210405                       endmon;
000952210405
000953210405                       val =
000954210405                           YAJL_object_find(node: 'observationPeriodDays');
000955210405
000956210405                       monitor;
000957210405                           cStr =  yajl_get_string(val);
000958210405                           result.list(i).obsPrdDays = %dec(%trim(cStr):5:0);
000959210405                       on-error;
000960210405                       endmon;
000961210405
000962210405                       // All calculation methods
000963210405                       val = YAJL_object_find(node: 'publishedRiskFreeRate');
000964210405
000965210405                       cStr  =  yajl_get_string(val);
000966210405                       result.list(i).pubRskFrRt =  %dec(%trim(cStr):30:9  );
000967210405
000968210405                       // All calculation methods
000969210405                       val = YAJL_object_find(node: 'rateApplied');
000970210405                       cStr  =  yajl_get_string(val);
000971210405
000972210405                       monitor;
000973210405                          result.list(i).rateApplied =  %dec(%trim(cStr):30:9);
000974210405                       on-error;
000975210405                       endmon;
000976210405
000977210405                       // All calculation methods
000978210405                       val = YAJL_object_find(node: 'riskFreeRateFloorApplied');
000979210405                       if YAJL_is_true(node);
000980210405                           result.list(i).rskFrRtFlAp=  'True';
000981210405                       else;
000982210405                           result.list(i).rskFrRtFlAp=  'False';
000983210405                       endif;
000984210405
000985210405                       if calcMethod = 'NCCR';
000986210405                            val = YAJL_object_find(node: 'compoundingFactor');
000987210405                            result.list(i).compFactor=  yajl_get_string(val);
000988210405
000989210405                            val =
000990210405                              YAJL_object_find(node: 'dailyCompoundedRate');
000991210405                            result.list(i).dlyCompRate =
000992210405                              yajl_get_string(val);
000993210405                       endif;
000994210405
000995210405                       if calcMethod = 'CCR';
000996210405                            val =
000997210405                              YAJL_object_find(node: 'averageCompoundedRate');
000998210405                            result.list(i).aveCompRate =  yajl_get_string(val);
000999210405
001000210405                       endif;
001001210405
001002210405                       if calcMethod = 'SAVG';
001003210405                            val =
001004210405                              YAJL_object_find(node: 'simpleAverageRate');
001005210405                            result.list(i).simpleAve =  yajl_get_string(val);
001006210405
001007210405                       endif;
001008210405
001009210405                   enddo;
001010210405
001011210405                   // free up memory used by YAJL
001012210405                   yajl_tree_free(docNode);
001013210405
001014210405       endsr;
001015210405
001016210405       //*************************************************************
001017210405       /EJECT
001018210405       //*************************************************************
001019210405       //                                                            *
001020210405       // outputFile - Output Files                                  *
001021210405       // ==========                                                 *
001022210405       //                                                            *
001023210405       // Called by: processTransaction                              *
001024210405       //                                                            *
001025210405       // Calls: None                                                *
001026210405       //                                                            *
001027210405       //*************************************************************
001028210405
001029210405       begsr outputFiles;
001030210405
001031210405                   i = 1;
001032210405
001033210405                   dow i <= lastElem;
001034210405
001035210405                       // Output information to SDARRLOGTD
001036210405                       exsr writeToARRDailyHistory;
001037210405
001038210405                       //Output information to LELIBEPD
001039210405                       exsr writeToExtractFile;
001040210405
001041210405                       i = i + 1;
001042210405
001043210405                   enddo;
001044210405
001045210405       endsr;
001046210405
001047210405       //*************************************************************
001048210405       /EJECT
001049210405       //*************************************************************
001050210405       //                                                            *
001051210405       // writeToARRDailyHistory - Write to ARR Daily Rates History  *
001052210405       // ======================                                     *
001053210405       //                                                            *
001054210405       // Called by: Output File                                     *
001055210405       //                                                            *
001056210405       // Calls: None                                                *
001057210405       //                                                            *
001058210405       //*************************************************************
001059210405
001060210405       begsr writeToARRDailyHistory;
001061210405
001062210405                   includeRecord = 'N';
001063210405
001064210405                   if (calcMethod = 'NCCR' or calcMethod  = 'SARR')
001065210405                   and  result.list(i).intPDMidas > transactDate;
001066210405                        includeRecord = 'Y';
001067210405
001068210405                   elseif  (calcMethod = 'CCR' or calcMethod  = 'SAVG');
001069210405                        includeRecord = 'Y';
001070210405
001071210405                   endif;
001072210405
001073210405                   fileToCheck = SDHSDRTD;
001074210405                   if includeRecord = 'Y';
001075210405                      exsr checkExist;
001076210405                      if action = INSERT;
001077210405                          exsr insertHistoryFile;
001078210405                      elseif action = UPDATE;
001079210405                          exsr updateHistoryFile;
001080210405                      endif;
001081210405                   endif;
001082210405
001083210405       endsr;
001084210405       //*************************************************************
001085210405       /EJECT
001086210405       //*************************************************************
001087210405       //                                                            *
001088210405       // checkExist - Check if a record exist on a given file       *
001089210405       // ==========                                                 *
001090210405       //                                                            *
001091210405       // Called by: Output File                                     *
001092210405       //                                                            *
001093210405       // Calls: None                                                *
001094210405       //                                                            *
001095210405       //*************************************************************
001096210405
001097210405       begsr checkExist;
001098210405
001099210405                   if fileToCheck = SDHSDRTD;
001100210405                        wSQLStr = 'select * from SDHSDRTD ' +
001101210405                                  'where CMODID = '  + QUO + moduleID + QUO +
001102210405                                  ' and CTRNID = ' + QUO + transactREF + QUO +
001103210405                                  ' and CINPDT = ' +
001104210405                                    %char(result.list(i).intPDMidas);
001105210405                   elseif fileToCheck = LELIBEPD;
001106210405                        wSQLStr = 'select * from LELIBEPD ' +
001107210405                                  'where LDLNRF = ' + QUO + transactREF + QUO +
001108210405                                  ' and LDVDAT = ' +
001109210405                                    %char(result.list(i).intPDMidas);
001110210405                   endif;
001111210405
001112210405                   exec sql prepare P1 from :wSQLStr;
001113210405                   exec sql open P1;
001114210405
001115210405                   if fileToCheck = SDHSDRTD;
001116210405                        exec sql fetch next From P1 into :DailyHistDS;
001117210405                   elseif fileToCheck = LELIBEPD;
001118210405                        exec sql fetch next From P1 into :ExtractFLDS;
001119210405                   endif;
001120210405
001121210405                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001122210405                       AuditLogDS.SJTMST = %timestamp();
001123210405                       AuditLogDS.SJEXMS = 'Error in access '
001124210405                                         + ' SQL ERROR ' + %char(sqlCod);
001125210405                       AuditLogDS.SJCODE = '008';
001126210405                       isError = true;
001127210405                       exsr errorHandler;
001128210405                   endif;
001129210405
001130210405                   if sqlCod = NO_RECORD;
001131210405                      action = INSERT;
001132210405                   else;
001133210405                      action = UPDATE;
001134210405                   endif;
001135210405                   exec sql close P1;
001136210405
001137210405       endsr;
001138210405       //*************************************************************
001139210405       /EJECT
001140210405       //*************************************************************
001141210405       //                                                            *
001142210405       // insertHistoryFile                                          *
001143210405       // =================                                          *
001144210405       //                                                            *
001145210405       // Called by: writeToARRDailyHistory                          *
001146210405       //                                                            *
001147210405       // Calls: None                                                *
001148210405       //                                                            *
001149210405       //*************************************************************
001150210405
001151210405       begsr insertHistoryFile;
001152210405
001153210405                   clear DailyHistDS;
001154210405                   DailyHistDS.CMODID = moduleID;
001155210405                   DailyHistDS.CTRNID = transactREF;
001156210405                   DailyHistDS.CCALCM = calcMethod;
001157210405                   DailyHistDS.CINPSD = %dec(intPrdStrMDAY:5:0);
001158210405                   DailyHistDS.CINPED = %dec(intPrdEndMDAY:5:0);
001159210405                   DailyHistDS.CINFLG = 'Y';
001160210405                   DailyHistDS.CINPDT = result.list(i).intPDMidas;
001161210405                   DailyHistDS.CINPDY = result.list(i).intPrdDays;
001162210405                   DailyHistDS.COBPDT = result.list(i).intOPMidas;
001163210405                   DailyHistDS.COBPDY = result.list(i).obsPrdDays;
001164210405                   DailyHistDS.CPBRFR = result.list(i).pubRskFrRt;
001165210405                   DailyHistDS.CRTEAP = result.list(i).rateApplied;
001166210405                   if result.list(i).rskFrRtFlAp = 'true';
001167210405                      DailyHistDS.CRFRAP = 'Y';
001168210405                   else;
001169210405                      DailyHistDS.CRFRAP = 'N';
001170210405                   endif;
001171210405                   DailyHistDS.CTIMST = %timestamp();
001172210405
001173210405                   select;
001174210405                        when calcMethod = 'NCCR';
001175210405                             DailyHistDS.CDCMRT =
001176210405                               %Dec(Result.List(i).dlyCompRate:30:9);
001177210405                             DailyHistDS.CCMFAC =
001178210405                               %Dec(Result.List(i).compFactor:30:9);
001179210405                        when calcMethod = 'CCR';
001180210405                             DailyHistDS.CAVCRT =
001181210405                               %Dec(Result.List(i).aveCompRate:30:9);
001182210405                        when calcMethod = 'SAVG';
001183210405                             DailyHistDS.CSMPAV =
001184210405                               %Dec(Result.List(i).simpleAve:30:9);
001185210405                   endsl;
001186210405
001187210405                   exec sql insert into SDHSDRTD
001188210405                   values (:DailyHistDS);
001189210405
001190210405                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001191210405                       AuditLogDS.SJTMST = %timestamp();
001192210405                       AuditLogDS.SJEXMS = 'Error in access SDHSDRTD '
001193210405                                         + 'SQL ERROR ' + %char(sqlCod);
001194210405                       AuditLogDS.SJCODE = '009';
001195210405                       isError = true;
001196210405                       exsr errorHandler;
001197210405                   endif;
001198210405
001199210405       endsr;
001200210405
001201210405       //*************************************************************
001202210405       /EJECT
001203210405       //*************************************************************
001204210405       //                                                            *
001205210405       // insertExtractFile                                          *
001206210405       // =================                                          *
001207210405       //                                                            *
001208210405       // Called by: writeToHistoryFile                               *
001209210405       //                                                            *
001210210405       // Calls: None                                                *
001211210405       //                                                            *
001212210405       //*************************************************************
001213210405
001214210405       begsr insertExtractFile;
001215210405
001216210405                   clear ExtractFLDS;
001217210405                   clear compAveRate;
001218210405                   ExtractFLDS.LDLNRF = transactREF;
001219210405                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
001220210405
001221210405                   select;
001222210405                        when calcMethod = 'NCCR';
001223210405                             compAveRate =
001224210405                               %Dec(Result.List(i).dlyCompRate:30:9);
001225210405                        when calcMethod = 'CCR';
001226210405                             compAveRate =
001227210405                               %Dec(Result.List(i).aveCompRate:30:9);
001228210405                        when calcMethod = 'SARR';
001229210405                             compAveRate =
001230210405                               %Dec(Result.List(i).rateApplied:30:9);
001231210405                        when calcMethod = 'SAVG';
001232210405                             compAveRate =
001233210405                               %Dec(Result.List(i).simpleAve:30:9);
001234210405                   endsl;
001235210405
001236210405                   compAveRate += %dech(benchMarkAdj:13:9);
001237210405                   ExtractFLDS.LDCART =
001238210405                     %dech(compAveRate  :13 :9);
001239210405
001240210405                   exec sql insert into LELIBEPD
001241210405                   values (:ExtractFLDS);
001242210405
001243210405                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001244210405                      AuditLogDS.SJTMST = %timestamp();
001245210405                      AuditLogDS.SJEXMS = 'Error in access LELIBEPD '
001246210405                                       + 'SQL ERROR ' + %char(sqlCod);
001247210405                      AuditLogDS.SJCODE = '010';
001248210405                      isError = true;
001249210405                      exsr errorHandler;
001250210405                   endif;
001251210405
001252210405       endsr;
001253210405       //*************************************************************
001254210405       /EJECT
001255210405       //*************************************************************
001256210405       //                                                            *
001257210405       // updateExtractFile                                          *
001258210405       // =================                                          *
001259210405       //                                                            *
001260210405       // Called by: writeToExtractFile                               *
001261210405       //                                                            *
001262210405       // Calls: None                                                *
001263210405       //                                                            *
001264210405       //*************************************************************
001265210405
001266210405       begsr updateExtractFile;
001267210405
001268210405                   clear ExtractFLDS;
001269210405                   clear compAveRate;
001270210405                   ExtractFLDS.LDLNRF = transactREF;
001271210405                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
001272210405
001273210405                   select;
001274210405                        when calcMethod = 'NCCR';
001275210405                             compAveRate =
001276210405                               %Dec(Result.List(i).dlyCompRate:30:9);
001277210405                        when calcMethod = 'CCR';
001278210405                             compAveRate =
001279210405                               %Dec(Result.List(i).aveCompRate:30:9);
001280210405                        when calcMethod = 'SARR';
001281210405                             compAveRate =
001282210405                               %Dec(Result.List(i).rateApplied:30:9);
001283210405                        when calcMethod = 'SAVG';
001284210405                             compAveRate =
001285210405                               %Dec(Result.List(i).simpleAve:30:9);
001286210405                   endsl;
001287210405
001288210405                   compAveRate += %dech(benchMarkAdj:13:9);
001289210405                   ExtractFLDS.LDCART =
001290210405                     %dech(compAveRate  :13 :9);
001291210405
001292210405                   wSqlStr = 'update LELIBEPD A '  +
001293210405                              'SET A.LDCART = ' + %Char(ExtractFLDS.LDCART) +
001294210405                              ' where A.LDLNRF = ' + QUO + ExtractFLDS.LDLNRF
001295210405                                 + QUO +
001296210405                              ' and   A.LDVDAT = ' +  %Char(ExtractFLDS.LDVDAT);
001297210405
001298210405                   exec sql
001299210405                   execute immediate :wSqlStr;
001300210405
001301210405                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001302210405                      AuditLogDS.SJTMST = %timestamp();
001303210405                      AuditLogDS.SJEXMS = 'Error in access LELIBEPD '
001304210405                                       + 'SQL ERROR ' + %char(sqlCod);
001305210405                      AuditLogDS.SJCODE = '011';
001306210405                      isError = true;
001307210405                      exsr errorHandler;
001308210405                   endif;
001309210405
001310210405       endsr;
001311210405
001312210405       //*************************************************************
001313210405       /EJECT
001314210405       //*************************************************************
001315210405       //                                                            *
001316210405       // writeToExtractFile - Write to Extract File                 *
001317210405       // ==================                                         *
001318210405       //                                                            *
001319210405       // Called by: Output File                                     *
001320210405       //                                                            *
001321210405       // Calls: None                                                *
001322210405       //                                                            *
001323210405       //*************************************************************
001324210405
001325210405       begsr writeToExtractFile;
001326210405
001327210405                   fileToCheck = LELIBEPD;
001328210405                   exsr checkExist;
001329210405
001330210405                   if action = INSERT;
001331210405                        exsr insertExtractFile;
001332210405
001333210405                   elseif action = UPDATE;
001334210405                        exsr updateExtractFile;
001335210405
001336210405                   endif;
001337210405
001338210405       endsr;
001339210405
001340210405       //*************************************************************
001341210405       /EJECT
001342210405       //*************************************************************
001343210405       //                                                            *
001344210405       // writeToAuditLog - Write to Audit Log                       *
001345210405       // ===============                                            *
001346210405       //                                                            *
001347210405       // Called by: Output File                                     *
001348210405       //                                                            *
001349210405       // Calls: None                                                *
001350210405       //                                                            *
001351210405       //*************************************************************
001352210405
001353210405       begsr writeToAuditLog;
001354210405
001355210405                   if isException;
001356210405                       AuditLogDS.SJTMST = %timestamp();
001357210405                       AuditLogDS.SJEXMS = result.errors.exceptionMsg;
001358210405                       AuditLogDS.SJCODE = result.errors.status;
001359210405                       AuditLogDS.SJSTAT = 'F';
001360210405                       if AuditLogDS.SJCODE = '400';
001361210405                          logData = RestAPIParm;
001362210405                          returnCD = 'EXCEPTION_ERROR';
001363210405                       endif;
001364210405                   else;
001365210405                       if not(isError);
001366210405                          AuditLogDS.SJTMST = %timestamp();
001367210405                          AuditLogDS.SJEXMS = 'ARR Calculator completed' +
001368210405                             ' successfully';
001369210405                          AuditLogDS.SJCODE = '000';
001370210405                          returnCD = 'SUCCESS';
001371210405                          AuditLogDS.SJSTAT = 'C';
001372210405                          logData = %Trim(jsonData);
001373210405                       else;
001374210405                          logData = %Trim(errorMessage);
001375210405                          AuditLogDS.SJSTAT = 'F';
001376210405                       endif;
001377210405                   endif;
001378210405
001379210405                   // Write to audit log file if status is completed and
001380210405                   // system value ARRCalculatorTrace is Y
001381210405                   // OR status is failed and this is the last program call
001382210405                   // for the same transaction reference (i.e. RatesKnown = N)
001383210405                   if (AuditLogDS.SJSTAT = 'C' and writeLogs = 'Y') or
001384210405                      (AuditLogDS.SJSTAT = 'F' and RatesKnownInd = 'N');
001385210405                       exec sql insert into SDARRLOGTD
001386210405                       values (
001387210405                            : AuditLogDS.SJMODI,
001388210405                            : AuditLogDS.SJTREF,
001389210405                            : AuditLogDS.SJSTAT,
001390210405                            : AuditLogDS.SJMDAY,
001391210405                            : AuditLogDS.SJTMST,
001392210405                            : AuditLogDS.SJCODE,
001393210405                            : AuditLogDS.SJEXMS,
001394210405                            : logData
001395210405                       );
001396210405                       if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001397210405                          AuditLogDS.SJTMST = %timestamp();
001398210405                          AuditLogDS.SJEXMS = 'Error in access SDARRLOGTD';
001399210405                          AuditLogDS.SJCODE = '012';
001400210405                          isError = True;
001401210405                          exsr errorHandler;
001402210405                       endif;
001403210405                   endif;
001404210405
001405210405       endsr;
001406210405
001407210405       //*************************************************************
001408210405       /EJECT
001409210405       //*************************************************************
001410210405       //                                                            *
001411210405       // updateHistoryFile                                          *
001412210405       // =================                                          *
001413210405       //                                                            *
001414210405       // Called by: writeToARRDailyHistory                          *
001415210405       //                                                            *
001416210405       // Calls: None                                                *
001417210405       //                                                            *
001418210405       //*************************************************************
001419210405
001420210405       begsr updateHistoryFile;
001421210405
001422210405                   clear DailyHistDS;
001423210405                   DailyHistDS.CMODID = moduleID;
001424210405                   DailyHistDS.CTRNID = transactREF;
001425210405                   DailyHistDS.CCALCM = calcMethod;
001426210405                   DailyHistDS.CINPSD = %dec(intPrdStrMDAY:5:0);
001427210405                   DailyHistDS.CINPED = %dec(intPrdEndMDAY:5:0);
001428210405                   DailyHistDS.CINFLG = 'Y';
001429210405                   DailyHistDS.CINPDT = result.list(i).intPDMidas;
001430210405                   DailyHistDS.CINPDY = result.list(i).intPrdDays;
001431210405                   DailyHistDS.COBPDT = result.list(i).intOPMidas;
001432210405                   DailyHistDS.COBPDY = result.list(i).obsPrdDays;
001433210405                   DailyHistDS.CPBRFR = result.list(i).pubRskFrRt;
001434210405                   DailyHistDS.CRTEAP = result.list(i).rateApplied;
001435210405                   if result.list(i).rskFrRtFlAp = 'true';
001436210405                      DailyHistDS.CRFRAP = 'Y';
001437210405                   else;
001438210405                      DailyHistDS.CRFRAP = 'N';
001439210405                   endif;
001440210405                   DailyHistDS.CTIMST = %timestamp();
001441210405
001442210405                   select;
001443210405                        when calcMethod = 'NCCR';
001444210405                             DailyHistDS.CDCMRT =
001445210405                               %Dec(Result.List(i).dlyCompRate:30:9);
001446210405                             DailyHistDS.CCMFAC =
001447210405                               %Dec(Result.List(i).compFactor:30:9);
001448210405                        when calcMethod = 'CCR';
001449210405                             DailyHistDS.CAVCRT =
001450210405                               %Dec(Result.List(i).aveCompRate:30:9);
001451210405                        when calcMethod = 'SAVG';
001452210405                             DailyHistDS.CSMPAV =
001453210405                               %Dec(Result.List(i).simpleAve:30:9);
001454210405                   endsl;
001455210405
001456210405                   wSqlStr = 'update SDHSDRTD A SET '  +
001457210405                              'A.CCALCM = ' + QUO + %trim(DailyHistDS.CCALCM) +
001458210405                               QUO + ' , ' +
001459210405                              'A.CINPSD = ' + %char(DailyHistDS.CINPSD) +
001460210405                               ' , ' +
001461210405                              'A.CINPED = ' + %char(DailyHistDS.CINPED) +
001462210405                               QUO + ' , ' +
001463210405                              'A.CINFLG = ' + QUO + %trim(DailyHistDS.CINFLG) +
001464210405                               QUO + ' , ' +
001465210405                              'A.CINPDT = ' + %char(DailyHistDS.CINPDT) +
001466210405                              ' , ' +
001467210405                              'A.CINPDY = ' + %char(DailyHistDS.CINPDY) +
001468210405                              ' , ' +
001469210405                              'A.COBPDT = ' + %char(DailyHistDS.COBPDT) +
001470210405                              ' , ' +
001471210405                              'A.COBPDY = ' + %char(DailyHistDS.COBPDY) +
001472210405                              ' , ' +
001473210405                              'A.CPBRFR = ' + %char(DailyHistDS.CPBRFR) +
001474210405                              ' , ' +
001475210405                              'A.CRTEAP = ' + %char(DailyHistDS.CRTEAP) +
001476210405                              ' , ' +
001477210405                              'A.CRFRAP = ' + QUO + %trim(DailyHistDS.CRFRAP) +
001478210405                              QUO + ' , ' +
001479210405                              'A.CAVCRT = ' + %char(DailyHistDS.CAVCRT) +
001480210405                              ' , ' +
001481210405                              'A.CCMFAC = ' + %char(DailyHistDS.CCMFAC) +
001482210405                              ' , ' +
001483210405                              'A.CDCMRT = ' + %char(DailyHistDS.CDCMRT) +
001484210405                              ' , ' +
001485210405                              'A.CSMPAV = ' + %char(DailyHistDS.CSMPAV) +
001486210405                              ' , ' +
001487210405                              'A.CTIMST = ' + QUO + %char(DailyHistDS.CTIMST) +
001488210405                              QUO +
001489210405                              ' where A.CMODID = ' +
001490210405                                QUO + %trim(moduleID) + QUO +
001491210405                              ' and   A.CTRNID = ' +
001492210405                                QUO + %trim(transactREF) + QUO;
001493210405
001494210405                   exec sql
001495210405                   execute immediate :wSqlStr;
001496210405
001497210405                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001498210405                      AuditLogDS.SJTMST = %timestamp();
001499210405                      AuditLogDS.SJEXMS = 'Error in access SDHSDRTD '
001500210405                                       + 'SQL ERROR ' + %char(sqlCod);
001501210405                      AuditLogDS.SJCODE = '013';
001502210405                      isError = true;
001503210405                      exsr errorHandler;
001504210405                   endif;
001505210405
001506210405       endsr;
001507210405
001508210405       //*************************************************************
001509210405       /EJECT
001510210405       //*************************************************************
001511210405       //                                                            *
001512210405       //   errorHandler  - Program Error Processing Subroutine.     *
001513210405       //                                                            *
001514210405       //   Called By: Main Processing, various subroutines          *
001515210405       //                                                            *
001516210405       //*************************************************************
001517210405
001518210405       begsr *pssr;
001519210405                   *inu7 = *on;
001520210405                   *inu8 = *on;
001521210405                   *Inlr = *on;
001522210405                   dump;
001523210405                   return;
001524210405       endsr;
001525210405
001526210405       //*************************************************************
001527210405       /EJECT
001528210405       //*************************************************************
001529210405       //                                                            *
001530210405       //   errorHandler                                             *
001531210405       //                                                            *
001532210405       //   Called By: Main Processing, various subroutines          *
001533210405       //                                                            *
001534210405       //*************************************************************
001535210405
001536210405       begsr errorHandler;
001537210405
001538210405                   exsr writeToAuditLog;
001539210405                   *Inlr = *on;
001540210405                   return;
001541210405       endsr;
001542210405
001543210405       //*************************************************************
001544210405
001545210405      /end-free
001546210405
001547210405     C/COPY ZSRSRC,ZACCHLE
001548210405     C/COPY ZSRSRC,ZBKDT_ILE
001549210405     C/COPY ZSRSRC,ZFWDT_ILE
001550210405** CPY@   **      OBJECT COPYRIGHT
001551210405(c) Finastra International Limited 2020
001552210405** arrCalLoc
001553210405/corporate/lending/alternative-reference-rates/v1/daily-compounding/rates
001554210405/corporate/lending/alternative-reference-rates/v1/compounded-in-arrears/average-rate
001555210405/corporate/lending/alternative-reference-rates/v1/simple-arr/rates
001556210405/corporate/lending/alternative-reference-rates/v1/simple-average/rates
