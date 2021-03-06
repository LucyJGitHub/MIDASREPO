000100210222     H DEBUG
000102210226     H DFTACTGRP(*NO) BNDDIR('HTTPAPI') BNDDIR('YAJL')
000103210224     H COPYRIGHT('(c) Finastra International Limited 2021')
000104210222      *****************************************************************
000105210301/*STD *  RPGSQLBND                                                    *
000106210224/*EXI *  TEXT('Midas SD API - Invoke ARR Calculator')                 *
000107210222      *****************************************************************
000108210222      *                                                               *
000109210224      *  Midas - Midas Standing Data API - Invoke ARR Calculator      *
000110210222      *                                                               *
000111210224      *  ZAGETCALRT Midas API - Invoke ARR Calculator                 *
000112210222      *                                                               *
000113210224      *  (c) Finastra International Limited 2021                      *
000114210222      *                                                               *
000115210224      *  Prev Amend No. CSD103 *CREATE     Date 12Feb21               *
000116210222      *                                                               *
000117210222      *****************************************************************
000118210222      *                                                               *
000122210222      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
000123210222      *                                                               *
000124210222      *****************************************************************
000125210222
000126210222      **---------------------------------------------------------------
000127210222      ** The following /COPY line includes all the defined fields in
000128210222      ** the Program Status Data Structures.  They have meaningful
000129210222      ** names, prefixed by 'PS'.
000130210304
000131210306     D/INCLUDE LIBHTTP123/QRPGLESRC,YAJL_H
000132210306     D/INCLUDE LIBHTTP123/QRPGLESRC,HTTPAPI_H1
000133210304
000134210222     D/COPY ZACPYSRC,PSDS
000135210222     D/COPY ZACPYSRC,STD_D_SPEC
000136210306     D/COPY ZSRSRC,ZINTDYZ1LE
000137210306     D/COPY ZSRSRC,ZHOLILE
000138210306     D/COPY ZSRSRC,ZHOLELE
000140210222
000141210222      ** +--------------------------------------+
000142210222      ** ¦ Program Prototypes                   ¦
000143210222      ** ¦ ==================                   ¦
000144210222      ** +--------------------------------------+
000145210304
000146210226     D ACCESS_SVAL     PR                  EXTPGM('AOSVALR0')
000147210226     D pRetCode                       7A
000148210226     D pOP01                         20A
000149210226     D pVL01                        200A
000151210226     D pOP02                         20A
000152210226     D pVL02                        200A
000153210226     D pOP03                         20A
000154210226     D pVL03                        200A
000155210226     D pOP04                         20A
000156210226     D pVL04                        200A
000157210226     D pOP05                         20A
000158210226     D pVL05                        200A
000159210226     D pOP06                         20A
000160210226     D pVL06                        200A
000161210226     D pOP07                         20A
000162210226     D pVL07                        200A
000163210226     D pOP08                         20A
000164210226     D pVL08                        200A
000165210226     D pOP09                         20A
000166210226     D pVL09                        200A
000167210226     D pOP10                         20A
000168210226     D pVL10                        200A
000169210301
000170210301     D  ACCESS_SDBANK  pr                  extpgm('AOBANKR0')
000171210301     D    pReturnCode                 7A
000172210301     D    pOption                     7A
000173210301     D    pDSFDY                    200A
000174210304
000175210301     D  CONVERT_DATE   pr                  extpgm('ZDATE1')
000176210301     D    ErrorFlag                   7a
000177210301     D    DateIN                      6p 0
000178210301     D    DateInd                     1a
000179210301     D    DateOUT                     5p 0
000180210301
000181210222      *  +----------------+
000182210222      ** |Parameter lists |
000183210222      ** +----------------+
000184210222
000185210222     D Main            pr                  extpgm('ZAGETCALRT')
000186210301      **-----------------------------------------------------**
000187210301     D  moduleID                      2a
000188210301      ** Module ID
000189210301      **--** LE - Lending
000190210301      **--** DL - Dealing
000191210301      **--** FR - FRA/IRS
000192210301     D  transactREF                   6a
000193210301      ** Transaction Reference
000194210226     D  calcMethod                    4a
000195210301      ** Calculation Method
000196210301      **--** NCCR - Daily Compounding in Arrears (Non-Cumulative Compounded Rate)
000197210301      **--** CCR  - Average Compounded In Arrears (Cumulative Compounded Rate)
000198210301      **--** SARR - Simple Average
000199210301      **--** SAVG - Simple Average
000200210301      **--** MANU - Manual
000201210224     D  intPrdStartDt                10a
000202210224      ** Interest Period Start Date
000203210224     D  intPrdEndDt                  10a
000204210224      ** Interest Period End Date
000205210224     D  riskFreeRate                  4a
000206210224      ** Risk Free Rate
000207210226     D  riskFreeRatFl                20a
000208210224      ** Risk Free Rate Floor
000209210226     D  lookBackDays                  2a
000210210224      ** Lookback Days
000211210301     D  obserPrdShift                 5a
000212210224      ** Observation Period Shift
000213210301      ** True/False
000214210226     D  RateRndDecPts                 3a
000215210224      ** Rate Rounding Decimal Points
000216210303     D  dayCntConvent                 7a
000217210224      ** Day Count Convention
000218210226     D  lockOutDays                   2a
000219210224      ** Lockout Days
000220210301     D  showDailyDeta                 5a
000221210224      ** Show Dailty Details
000222210301      ** True/False
000223210224     D  callTillDate                 10a
000224210224      ** Calculate Till Date
000225210305     D  benchMarkAdj                 13p 7
000226210305      ** Benchmark Adjustment
000227210222
000228210222     D Main            pi
000229210301      **-----------------------------------------------------**
000230210301     D  moduleID                      2a
000231210301      ** Module ID
000232210301      **--** LE - Lending
000233210301      **--** DL - Dealing
000234210301      **--** FR - FRA/IRS
000235210301     D  transactREF                   6a
000236210301      ** Transaction Reference
000237210226     D  calcMethod                    4a
000238210226      ** Calculation Method
000239210301      **--** NCCR - Daily Compounding in Arrears (Non-Cumulative Compounded Rate)
000240210301      **--** CCR  - Average Compounded In Arrears (Cumulative Compounded Rate)
000241210301      **--** SARR - Simple Average
000242210301      **--** SAVG - Simple Average
000243210301      **--** MANU - Manual
000244210226     D  intPrdStartDt                10a
000245210226      ** Interest Period Start Date
000246210226     D  intPrdEndDt                  10a
000247210226      ** Interest Period End Date
000248210226     D  riskFreeRate                  4a
000249210226      ** Risk Free Rate
000250210226     D  riskFreeRatFl                20a
000251210226      ** Risk Free Rate Floor
000252210226     D  lookBackDays                  2a
000253210226      ** Lookback Days
000254210301     D  obserPrdShift                 5a
000255210226      ** Observation Period Shift
000256210301      ** True/False
000257210226     D  RateRndDecPts                 3a
000258210226      ** Rate Rounding Decimal Points
000259210303     D  dayCntConvent                 7a
000260210226      ** Day Count Convention
000261210226     D  lockOutDays                   2a
000262210226      ** Lockout Days
000263210301     D  showDailyDeta                 5a
000264210226      ** Show Dailty Details
000265210301      ** True/False
000266210226     D  callTillDate                 10a
000267210226      ** Calculate Till Date
000268210305     D  benchMarkAdj                 13p 7
000269210305      ** Benchmark Adjustment
000270210224
000271210222      ** +--------------------------------------+
000272210222      ** ¦ Manually included D-specs            ¦
000273210222      ** ¦ =========================            ¦
000274210222      ** +--------------------------------------+
000275210303
000276210301      ** Extract File
000277210301     D LELIBEDS      e ds                  extname(LELIBEPD)
000278210301     D ExtractFLDS     ds                  likeds(LELIBEDS)
000279210303
000280210303      ** Audit Log
000281210303     D SDARRLDS      e ds                  extname(SDARRLOGTD)
000282210303     D AuditLogDS      ds                  likeds(SDARRLDS)
000283210303
000284210303      ** ARR Daily Rates History File
000285210303     D ARRDLYDS      e ds                  extname(SDHSDRTD)
000286210303     D DailyHistDS     ds                  likeds(ARRDLYDS)
000287210303
000288210304      ** Core DS
000289210222     D dssdy         e ds                  extname(DSSDY)
000290210222     D dsfdy         e ds                  extname(DSFDY)
000291210222
000292210222      ** +--------------------------------------+
000293210222      ** ¦ Constants declaration                ¦
000294210222      ** ¦ =====================                ¦
000295210222      ** +--------------------------------------+
000296210304
000297210304     D AMP             c                   const('&')
000301210304     D INSERT          c                   const(0)
000302210304     D LELIBEPD        c                   const(1)
000305210301     D NO_ERROR        c                   const(0)
000306210301     D NO_RECORD       c                   const(100)
000309210301     D QUO             c                   const('''')
000310210304     D QUE             c                   const('?')
000312210304     D SDHSDRTD        c                   const(0)
000315210303     D UPDATE          c                   const(1)
000316210226
000317210222      ** +--------------------------------------+
000318210222      ** ¦ Variable declaration                 ¦
000319210222      ** ¦ ====================                 ¦
000320210222      ** +--------------------------------------+
000321210226      ** AOSVALR0 Parameters
000322210226     D pRetCode        S              7A
000323210226     D pOP01           S             20A
000324210226     D pVL01           S            200A
000325210226     D pOP02           S             20A
000326210226     D pVL02           S            200A
000327210226     D pOP03           S             20A
000328210226     D pVL03           S            200A
000329210226     D pOP04           S             20A
000330210226     D pVL04           S            200A
000331210226     D pOP05           S             20A
000332210226     D pVL05           S            200A
000333210226     D pOP06           S             20A
000334210226     D pVL06           S            200A
000335210226     D pOP07           S             20A
000336210226     D pVL07           S            200A
000337210226     D pOP08           S             20A
000338210226     D pVL08           S            200A
000339210226     D pOP09           S             20A
000340210226     D pVL09           S            200A
000341210226     D pOP10           S             20A
000342210226     D pVL10           S            200A
000343210304
000344210304      ** Work variables
000345210224     D err             s             10i 0
000347210222     D msg             s             52a
000350210304     D jsonData        s         999999a   varying
000351210305     D LogData         s          10000a   varying
000352210304     D RestAPIParm     s          65535a   varying inz(*blanks)
000353210226     D CalcMetURL      s            500a   varying inz(*blanks)
000354210301     D wSqlStr         S           2000A   INZ(*BLANKS)
000355210301     D pReturnCode     s              7a
000356210301     D pOption         s              7a
000359210301     D ErrorFlag       s              7a
000360210301     D DateIN          s              6p 0
000361210301     D DateInd         s              1a
000362210301     D DateOUT         s              5p 0
000363210303     D transactDate    s              5p 0
000364210303     D fileToCheck     s              1s 0
000365210304     D i               s             10i 0
000366210304     D lastElem        s             10i 0
000368210304     D errMsg          s            500a   varying inz('')
000369210304     D action          s              1s 0
000370210305     D errorMessage    s            100a
000371210305     D includeRecord   s              1a   inz('N')
000372210226
000373210226      *---------------*
000374210226      ** JSON Details *
000375210226      *---------------*
000376210226
000377210226     D summary_t       ds                  qualified
000378210226     D                                     template
000379210226     D   intPrdDate                  10a
000380210226      ** Interest Period Date
000381210303      ** NCCR, CCR, SAVG, SARR
000382210301     D   intPDMidas                   5p 0
000383210301      ** Interest Period Date in Midas Format
000384210303     D   intPrdYMD                    6a
000385210303      ** Interest Period Date YYMMDD
000386210226     D   intPrdDays                   2s 0
000387210226      ** Interest Period Days
000388210303      ** NCCR, CCR, SAVG, SARR
000389210226     D   obsPrdDate                  10a
000390210226      ** Observation Period Date
000391210303      ** NCCR
000392210303     D   intOPMidas                   5p 0
000393210303      ** Observation Period Date in Midas Format
000394210303     D   intObsYMD                    6a
000395210303      ** Observation Period Date YYMMDD
000396210226     D   obsPrdDays                   2s 0
000397210226      ** Observation Period Days
000398210303      ** NCCR
000399210305     D   pubRskFrRt                  30p 9
000400210226      ** Published Risk Free Rate
000401210303      ** NCCR, CCR, SAVG, SARR
000402210226     D   rateApplied                 30p 9
000403210226      ** Rate Applied
000404210303      ** NCCR, CCR, SAVG, SARR
000405210226     D   rskFrRtFlAp                  5a
000406210226      ** Risk Free Rate Floor Applied
000407210303      ** NCCR, CCR, SAVG, SARR
000408210304     D   compFactor                  10a
000409210226      ** Compounding Factor
000410210303      ** NCCR
000411210301     D   dlyCompRate                 10a
000412210226      ** Daily Compunded Rate
000413210303      ** NCCR
000414210303     D   aveCompRate                 10a
000415210303      ** Average Compunded Rate
000416210303      ** CCR
000417210303     D   simpleAve                   10a
000418210303      ** Simple Average
000419210303      ** SAVG
000420210226
000421210226     D request_t       ds                  qualified
000422210226     D                                     template
000423210226     D   intPrdStart                 10a
000424210226      ** Interest Period Start
000425210226     D   intPrdEnd                   10a
000426210226      ** Interest Period End
000427210226     D   rskFreeRate                  4a
000428210226      ** Risk Free Rate
000429210226     D   rskFreeRtFl                 15s 6
000430210226      ** Risk Free Rate Floor
000431210226     D   obsPrdShift                  8s 0
000432210226      ** Observation Period Shift
000433210226     D   ratRndDecPts                 8s 0
000434210226      ** Rate Rounding Decimal Points
000435210226     D   showDailyDet                 8s 0
000436210226      ** Show Daily Details
000437210226
000438210226     D result          ds                  qualified
000439210226     D   success                      1n
000440210226      ** Success
000441210226     D   errmsg                     500a   varying
000442210226      ** Error Message
000443210226     D   statusCode                   4a   varying
000444210226      ** Status Code
000445210226     D   message                     10a   varying
000446210226      ** Message
000447210226     D   comment                    500a   varying
000448210226      ** Comment
000449210226     D   lastUpdFrSrc               200a   varying
000450210226      ** Last Updated From Source
000451210226     D   legalDisc                  200a   varying
000452210226      ** Legal Disclaimer
000453210226     D   reqParms                          likeds(request_t)
000454210226      ** Request Parameters
000455210226     D   list                              likeds(summary_t) dim(999)
000456210226      ** Daily Rate Summary
000457210301
000458210301     D SDBANK        e ds                  extname(SDBANKPD)
000459210301     D                 DS
000460210301     D ISODate                 1     10
000461210301     D WkYear                  3      4  0
000462210301     D WkMonth                 6      7  0
000463210301     D WkDay                   9     10  0
000464210303
000465210303     D                 DS
000466210303     D YYMMDD                  1      6
000467210303     D WkY                     1      2
000468210303     D WkM                     3      4
000469210303     D WkD                     5      6
000470210301
000471210301     D                 DS
000472210301     D DateIN_D                1      6  0
000473210301     D DD1D                    1      2  0
000474210301     D DD1M                    3      4  0
000475210301     D DD1Y                    5      6  0
000476210301     D                 DS
000477210301     D DateIN_M                1      6  0
000478210301     D DD2M                    1      2  0
000479210301     D DD2D                    3      4  0
000480210301     D DD2Y                    5      6  0
000481210226
000482210226     D docNode         s                   like(yajl_val)
000483210226     D list            s                   like(yajl_val)
000484210226     D node            s                   like(yajl_val)
000485210226     D val             s                   like(yajl_val)
000487210305     D cStr            S             10a   Varying
000489210226
000490210222      ** +--------------------------------------+
000491210222      ** ¦ Array declaration                    ¦
000492210222      ** ¦ ==================                   ¦
000493210222      ** +--------------------------------------+
000494210222
000495210222      /free
000496210222
000497210222       // ** +--- Start of Main processing -----------------------------------+
000498210222       // ** ¦                                                                ¦
000499210222       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
000500210222       // ** ¦ executed at program activation.                                ¦
000501210222       // ** ¦                                                                ¦
000502210222       // ** +----------------------------------------------------------------+
000503210304
000504210224                   exsr processTransaction;
000505210222
000506210222                   *Inlr = *On;
000507210222                   return;
000508210222
000509210222       //*************************************************************
000510210222       /EJECT
000511210222       //*************************************************************
000512210222       //                                                            *
000513210224       // processTransaction - Process a Loan Transaction            *
000514210224       // ==================                                         *
000515210222       //                                                            *
000516210222       // Called by: Main Processing                                 *
000517210222       //                                                            *
000518210222       // Calls: None                                                *
000519210222       //                                                            *
000520210222       //*************************************************************
000521210222
000522210224       begsr processTransaction;
000523210305
000524210306                   //** This will build the URL parameter for the Rest API Call
000525210305
000526210304                   exsr buildParameter;
000527210224
000528210306                   //** This will call the http_string function from LIBHTTP123
000529210305                   //** to consume the Rest API
000530210305
000531210304                   exsr consumeRESTAPI;
000532210305
000536210305                   if msg = *blanks;
000537210305
000538210305                      //** This will parse the JSON data returned from ARR Calculator
000539210306                      //** and store it to an array of Data Structure
000540210305
000541210305                      exsr parseJSONData;
000542210305
000543210305                      //** This will handle the output of the array DS to the
000544210305                      //** history and extract files
000545210306
000546210305                      exsr outputFiles;
000547210305
000548210305                   endif;
000549210224
000550210305                   //** log details to audit file
000551210305                   exsr writeToAuditLog;
000552210224
000553210222       endsr;
000554210222
000555210224       //*************************************************************
000556210224       /EJECT
000557210224       //*************************************************************
000558210224       //                                                            *
000559210224       // buildParameter - Build REST API Parameter                  *
000560210224       // ==============                                             *
000561210224       //                                                            *
000562210224       // Called by: processTransaction                              *
000563210224       //                                                            *
000564210224       // Calls: None                                                *
000565210224       //                                                            *
000566210224       //*************************************************************
000567210224
000568210224       begsr buildParameter;
000569210304
000570210305                   RestAPIParm = %trim(CalcMetURL) +
000571210305                                 QUE + 'interestPeriodStartDate=' +
000572210305                                       %trim(intPrdStartDt) +
000573210304                                 AMP + 'interestPeriodEndDate=' +
000574210305                                    %trim(intPrdEndDt) +
000575210305                                 AMP + 'riskFreeRate=' +
000576210305                                    %trim(riskFreeRate) +
000577210305                                 AMP + 'lookBackDays=' +
000578210305                                    %trim(lookBackDays)  +
000579210226                                 AMP + 'rateRoundingDecimalPoints=' +
000580210305                                    %trim(RateRndDecPts) +
000581210226                                 AMP + 'observationPeriodShift=' +
000582210305                                    %trim(obserPrdShift) +
000583210305                                 AMP + 'lockoutDays=' +
000584210305                                    %trim(lockOutDays) +
000585210304                                 AMP + 'showDailyDetails=' +
000586210305                                    %trim(showDailyDeta) +
000587210304                                 AMP + 'calculateTillDate=' +
000588210305                                    %trim(callTillDate) +
000589210304                                 AMP + 'riskFreeRateFloor=' +
000590210305                                    %trim(riskFreeRatFl);
000591210305
000592210224       endsr;
000593210224
000594210224       //*************************************************************
000595210224       /EJECT
000596210224       //*************************************************************
000597210224       //                                                            *
000598210224       // consumeRESTAPI - Consume REST API                          *
000599210224       // ==============                                             *
000600210224       //                                                            *
000601210224       // Called by: processTransaction                              *
000602210224       //                                                            *
000603210306       // Calls: LIBHTTP123 http_string                              *
000604210224       //                                                            *
000605210224       //*************************************************************
000606210224
000607210224       begsr consumeRestAPI;
000608210224
000609210304              monitor;
000610210304                 clear jsonData;
000611210305                 jsonData = http_string( 'GET' : %trim(RestAPIParm));
000612210304                 msg = *blanks;
000613210304                 err = 0;
000614210304              on-error;
000615210305                 msg = http_error(err);
000616210305                 errorMessage = msg;
000617210305                 exsr errorHandler;
000618210304              endmon;
000619210224
000620210224       endsr;
000621210224
000622210224       //*************************************************************
000623210224       /EJECT
000624210224       //*************************************************************
000625210224       //                                                            *
000626210224       // parseJSONData - Parse JSON Data                            *
000627210224       // =============                                              *
000628210224       //                                                            *
000629210224       // Called by: processTransaction                              *
000630210224       //                                                            *
000631210224       // Calls: None                                                *
000632210224       //                                                            *
000633210224       //*************************************************************
000634210224
000635210224       begsr parseJSONData;
000636210304
000637210306                   // Load JSON data variable into a tree like structure
000638210306
000639210304                   docNode = yajl_buf_load_tree( %addr(jsonData:*data)
000640210304                             : %len(jsonData)
000641210304                             : ErrMsg );
000642210304
000643210304                   if errMsg <> '';
000644210305                      errorMessage = errMsg;
000646210305                      exsr errorHandler;
000647210304                   endif;
000648210304
000649210304                   node = YAJL_object_find(docNode: 'comment');
000650210304                   result.comment = YAJL_get_string(node);
000651210226
000652210304                   node = YAJL_object_find(docNode: 'errmsg');
000653210304                   result.errmsg = YAJL_get_string(node);
000654210226
000655210304                   list = YAJL_object_find(docNode: 'dailyRateSummary');
000656210306
000657210305                   clear result.list;
000658210306
000659210304                   i = 0;
000660210304                   dow YAJL_ARRAY_LOOP( list: i: node );
000661210226
000662210226                       lastElem = i;
000663210226
000664210303                       // All calculation methods
000665210226                       val = YAJL_object_find(node: 'interestPeriodDate');
000666210226                       result.list(i).intPrdDate = yajl_get_string(val);
000667210301
000668210301                       ISODate =  result.list(i).intPrdDate;
000669210303
000670210303                       WKY = %editc(wkYear:'X');
000671210303                       WKM = %editc(wkMonth:'X');
000672210303                       WKD = %editc(wkDay:'X');
000673210303
000674210303                       result.list(i).intPrdYMD  = YYMMDD;
000675210301
000676210301                       if BJDFIN = 'D';
000677210301                          DD1D = wkDay;
000678210301                          DD1M = wkMonth;
000679210301                          DD1Y = wkYear;
000680210301                          DateIn = DateIn_D;
000681210301                       else;
000682210301                          DD2D = wkDay;
000683210301                          DD2M = wkMonth;
000684210301                          DD2Y = wkYear;
000685210301                          DateIn = DateIn_M;
000686210301                       endif;
000687210301                       pOption = '*FIRST';
000688210301                       pReturnCode = *Blanks;
000689210301                       callp CONVERT_DATE(
000690210301                                  ErrorFlag
000691210301                                : DateIN
000692210301                                : BJDFIN
000693210301                                : DateOUT
000694210301                               );
000695210301
000696210301                       if ErrorFlag   <> *blanks;
000697210304                           Dbase    = 002;
000698210301                           DbFile   = *Blanks;
000699210301                           DbKey    = *BLANKS;
000700210301                           DbPgm    = 'ZAGETCALRT';
000701210301                           Exsr *Pssr;
000702210301                       endif;
000703210301
000704210301                       result.list(i).intPDMidas = DateOUT;
000705210226
000706210303                       // All calculation methods
000707210226                       val = YAJL_object_find(node: 'interestPeriodDays');
000708210305                       cStr      =  yajl_get_string(val);
000709210305                       result.list(i).intPrdDays =  %dec(%trim(cStr):2:0);
000710210226
000711210303                       if calcMethod = 'NCCR';
000712210303                           val =
000713210303                             YAJL_object_find(node: 'observationPeriodDate');
000714210303                           result.list(i).obsPrdDate =
000715210303                             yajl_get_string(val);
000716210303
000717210303                            ISODate =  result.list(i).obsPrdDate;
000718210303
000719210303                            WKY = %editc(wkYear:'X');
000720210303                            WKM = %editc(wkMonth:'X');
000721210303                            WKD = %editc(wkDay:'X');
000722210303
000723210303                            result.list(i).intObsYMD  = YYMMDD;
000724210303
000725210303                            if BJDFIN = 'D';
000726210303                                 DD1D = wkDay;
000727210303                                 DD1M = wkMonth;
000728210303                                 DD1Y = wkYear;
000729210303                                 DateIn = DateIn_D;
000730210303                            else;
000731210303                                 DD2D = wkDay;
000732210303                                 DD2M = wkMonth;
000733210303                                 DD2Y = wkYear;
000734210303                                 DateIn = DateIn_M;
000735210303                             endif;
000736210303
000737210303                             pOption = '*FIRST';
000738210303                             pReturnCode = *Blanks;
000739210303                             callp CONVERT_DATE(
000740210303                                  ErrorFlag
000741210303                                : DateIN
000742210303                                : BJDFIN
000743210303                                : DateOUT
000744210303                               );
000745210303
000746210303                             if ErrorFlag   <> *blanks;
000747210304                                  Dbase    = 003;
000748210303                                  DbFile   = *Blanks;
000749210303                                  DbKey    = *BLANKS;
000750210303                                  DbPgm    = 'ZAGETCALRT';
000751210303                                 Exsr *Pssr;
000752210303                             endif;
000753210303
000754210303                             result.list(i).intOPMidas = DateOUT;
000755210303
000756210304                             val =
000757210304                                YAJL_object_find(node: 'observationPeriodDays');
000758210305                                cStr      =  yajl_get_string(val);
000759210305                                result.list(i).obsPrdDays =
000760210305                                  %dec(%trim(cStr):2:0);
000761210303                       endif;
000762210303
000763210303                       // All calculation methods
000764210303                       val = YAJL_object_find(node: 'publishedRiskFreeRate');
000765210305
000766210305                       cStr  =  yajl_get_string(val);
000767210305                       result.list(i).pubRskFrRt =  %dec(%trim(cStr):30:9  );
000768210303
000769210303                       // All calculation methods
000770210303                       val = YAJL_object_find(node: 'rateApplied');
000771210305                       cStr  =  yajl_get_string(val);
000772210305                       result.list(i).rateApplied =  %dec(%trim(cStr):30:9  );
000773210226
000774210303                       // All calculation methods
000775210226                       val = YAJL_object_find(node: 'riskFreeRateFloorApplied');
000776210226                       if YAJL_is_true(node);
000777210226                           result.list(i).rskFrRtFlAp=  'True';
000778210226                       else;
000779210226                           result.list(i).rskFrRtFlAp=  'False';
000780210226                       endif;
000781210226
000782210303                        if calcMethod = 'NCCR';
000783210303                             val = YAJL_object_find(node: 'compoundingFactor');
000784210303                             result.list(i).compFactor=  yajl_get_string(val);
000785210226
000786210303                             val =
000787210303                               YAJL_object_find(node: 'dailyCompoundedRate');
000788210303                             result.list(i).dlyCompRate =
000789210303                               yajl_get_string(val);
000790210303                        endif;
000791210303
000792210303                        if calcMethod = 'CCR';
000793210303                             val =
000794210303                               YAJL_object_find(node: 'averageCompoundedRate');
000795210303                             result.list(i).aveCompRate =  yajl_get_string(val);
000796210303
000797210303                        endif;
000798210303
000799210303                        if calcMethod = 'SAVG';
000800210303                             val =
000801210303                               YAJL_object_find(node: 'simpleAverageRate');
000802210303                             result.list(i).simpleAve =  yajl_get_string(val);
000803210303
000804210303                        endif;
000805210303
000806210304                   enddo;
000807210226
000808210304                   // free up memory used by YAJL
000809210304                   yajl_tree_free(docNode);
000810210224
000811210224       endsr;
000812210224
000813210224       //*************************************************************
000814210224       /EJECT
000815210224       //*************************************************************
000816210224       //                                                            *
000817210301       // outputFile - Output Files                                  *
000818210301       // ==========                                                 *
000819210224       //                                                            *
000820210224       // Called by: processTransaction                              *
000821210224       //                                                            *
000822210224       // Calls: None                                                *
000823210224       //                                                            *
000824210224       //*************************************************************
000825210224
000826210301       begsr outputFiles;
000827210305
000828210226                   i = 1;
000829210306
000830210226                   dow i <= lastElem;
000831210306
000832210306                       // Output information to SDARRLOGTD
000833210303                       exsr writeToARRDailyHistory;
000834210306
000835210306                       //Output information to LELIBEPD
000836210301                       exsr writeToExtractFile;
000837210306
000838210301                       i = i + 1;
000839210306
000840210226                   enddo;
000841210224
000842210224       endsr;
000843210303       //*************************************************************
000844210303       /EJECT
000845210303       //*************************************************************
000846210303       //                                                            *
000847210303       // writeToARRDailyHistory - Write to ARR Daily Rates History  *
000848210303       // ======================                                     *
000849210303       //                                                            *
000850210303       // Called by: Output File                                     *
000851210303       //                                                            *
000852210303       // Calls: None                                                *
000853210303       //                                                            *
000854210303       //*************************************************************
000855210303
000856210303       begsr writeToARRDailyHistory;
000857210303
000858210305                   includeRecord = 'N';
000859210305
000860210305                   if (calcMethod = 'NCCR' or calcMethod  = 'SARR')
000861210305                   and  result.list(i).intPDMidas > transactDate;
000862210305                        includeRecord = 'Y';
000863210306
000864210305                   elseif  (calcMethod = 'CCR' or calcMethod  = 'SAVG');
000865210305                        includeRecord = 'Y';
000866210306
000867210305                   endif;
000868210305
000869210305                   fileToCheck = SDHSDRTD;
000870210305                   if includeRecord = 'Y';
000871210305                      exsr checkExist;
000872210305                      if action = INSERT;
000873210305                          exsr insertHistoryFile;
000874210305                      elseif action = UPDATE;
000875210305                          exsr updateHistoryFile;
000876210305                      endif;
000877210305                   endif;
000878210303
000879210303       endsr;
000880210303       //*************************************************************
000881210303       /EJECT
000882210303       //*************************************************************
000883210303       //                                                            *
000884210306       // checkExist - Check if a record exist on a given file       *
000885210303       // ==========                                                 *
000886210303       //                                                            *
000887210303       // Called by: Output File                                     *
000888210303       //                                                            *
000889210303       // Calls: None                                                *
000890210303       //                                                            *
000891210303       //*************************************************************
000892210303
000893210303       begsr checkExist;
000894210303
000896210303                   if fileToCheck = SDHSDRTD;
000897210303                        wSQLStr = 'select * from SDHSDRTD ' +
000898210303                                  'where CMODID = '  + QUO + moduleID + QUO +
000899210303                                  ' and CTRNID = ' + QUO + transactREF + QUO +
000900210303                                  ' and CMINPD = ' +
000901210303                                    %char(result.list(i).intPDMidas);
000902210303                   elseif fileToCheck = LELIBEPD;
000903210303                        wSQLStr = 'select * from LELIBEPD ' +
000904210303                                  'where LDLNRF = ' + QUO + transactREF + QUO +
000905210303                                  ' and LDVDAT = ' +
000906210303                                    %char(result.list(i).intPDMidas);
000907210303                   endif;
000908210303
000909210303                   exec sql prepare P1 from :wSQLStr;
000910210303                   exec sql open P1;
000911210303
000912210303                   if fileToCheck = SDHSDRTD;
000913210303                        exec sql fetch next From P1 into :DailyHistDS;
000914210303                   elseif fileToCheck = LELIBEPD;
000915210303                        exec sql fetch next From P1 into :ExtractFLDS;
000916210303                   endif;
000917210303
000918210303                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
000919210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
000920210305                      exsr errorHandler;
000921210303                   endif;
000922210303
000923210303                   if sqlCod = NO_RECORD;
000924210303                      action = INSERT;
000925210303                   else;
000926210303                      action = UPDATE;
000927210303                   endif;
000928210303                   exec sql close P1;
000929210303
000930210303       endsr;
000931210303       //*************************************************************
000932210303       /EJECT
000933210303       //*************************************************************
000934210303       //                                                            *
000935210303       // insertHistoryFile                                          *
000936210303       // =================                                          *
000937210303       //                                                            *
000938210303       // Called by: writeToARRDailyHistory                           *
000939210303       //                                                            *
000940210303       // Calls: None                                                *
000941210303       //                                                            *
000942210303       //*************************************************************
000943210303
000944210303       begsr insertHistoryFile;
000945210303
000946210303                   clear DailyHistDS;
000947210303                   DailyHistDS.CMODID = moduleID;
000948210303                   DailyHistDS.CTRNID = transactREF;
000949210304                   DailyHistDS.CCALCM = calcMethod;
000950210303                   DailyHistDS.CMINPD = result.list(i).intPDMidas;
000951210303                   DailyHistDS.CINPDT = result.list(i).intPrdYMD;
000952210303                   DailyHistDS.CINPDY = result.list(i).intPrdDays;
000953210303                   DailyHistDS.CMOBPD = result.list(i).intOPMidas;
000954210303                   DailyHistDS.COBPDT = result.list(i).intObsYMD;
000955210303                   DailyHistDS.CPBRFR = result.list(i).pubRskFrRt;
000956210305                   DailyHistDS.COBPDY = result.list(i).obsPrdDays;
000957210303                   DailyHistDS.CRTEAP = result.list(i).rateApplied;
000958210305                   if result.list(i).rskFrRtFlAp = 'true';
000959210305                     DailyHistDS.CRFRAP = 'Y';
000960210305                   else;
000961210305                     DailyHistDS.CRFRAP = 'N';
000962210305                   endif;
000963210303                   DailyHistDS.CTIMST = %timestamp();
000964210304
000965210303                   select;
000966210303                        when calcMethod = 'NCCR';
000967210304                             DailyHistDS.CDCMRT =
000968210303                               %Dec(Result.List(i).dlyCompRate:30:9);
000969210304                             DailyHistDS.CCMFAC =
000970210304                               %Dec(Result.List(i).compFactor:30:9);
000971210303                        when calcMethod = 'CCR';
000972210303                             DailyHistDS.CAVCRT =
000973210303                               %Dec(Result.List(i).aveCompRate:30:9);
000974210304                        when calcMethod = 'SAVG';
000975210304                             DailyHistDS.CSMPAV =
000976210304                               %Dec(Result.List(i).simpleAve:30:9);
000977210303                   endsl;
000978210303
000979210303                   exec sql insert into SDHSDRTD
000980210303                   values (:DailyHistDS);
000981210303
000982210304                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
000983210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
000984210305                      exsr errorHandler;
000985210303                   endif;
000986210303
000987210303       endsr;
000988210303       //*************************************************************
000989210303       /EJECT
000990210303       //*************************************************************
000991210303       //                                                            *
000992210303       // insertExtractFile                                          *
000993210303       // =================                                          *
000994210303       //                                                            *
000995210303       // Called by: writeToHistoryFile                               *
000996210303       //                                                            *
000997210303       // Calls: None                                                *
000998210303       //                                                            *
000999210303       //*************************************************************
001000210303
001001210303       begsr insertExtractFile;
001002210303
001003210303                   clear ExtractFLDS;
001004210303                   ExtractFLDS.LDLNRF = transactREF;
001005210303                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
001006210303
001007210303                   select;
001008210303                        when calcMethod = 'NCCR';
001009210303                             ExtractFLDS.LDCART =
001010210303                               %Dec(Result.List(i).dlyCompRate:30:9);
001011210303                        when calcMethod = 'CCR';
001012210303                             ExtractFLDS.LDCART =
001013210303                               %Dec(Result.List(i).aveCompRate:30:9);
001014210304                        when calcMethod = 'SAVG';
001015210304                             ExtractFLDS.LDCART =
001016210304                               %Dec(Result.List(i).simpleAve:30:9);
001017210303                   endsl;
001018210303
001019210303                   exec sql insert into LELIBEPD
001020210303                   values (:ExtractFLDS);
001021210303
001022210304                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001023210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001024210305                      exsr errorHandler;
001025210303                   endif;
001026210303
001027210303       endsr;
001075210303       //*************************************************************
001076210303       /EJECT
001077210303       //*************************************************************
001078210303       //                                                            *
001079210303       // updateExtractFile                                          *
001080210303       // =================                                          *
001081210303       //                                                            *
001082210303       // Called by: writeToExtractFile                               *
001083210303       //                                                            *
001084210303       // Calls: None                                                *
001085210303       //                                                            *
001086210303       //*************************************************************
001087210303
001088210303       begsr updateExtractFile;
001089210304
001090210303                   clear ExtractFLDS;
001091210303                   ExtractFLDS.LDLNRF = transactREF;
001092210303                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
001093210303
001094210303                   select;
001095210303                        when calcMethod = 'NCCR';
001096210303                             ExtractFLDS.LDCART =
001097210303                               %Dec(Result.List(i).dlyCompRate:30:9);
001098210303                        when calcMethod = 'CCR';
001099210303                             ExtractFLDS.LDCART =
001100210303                               %Dec(Result.List(i).aveCompRate:30:9);
001101210303                   endsl;
001102210303
001103210303                   wSqlStr = 'update LELIBEPD A '  +
001104210303                              'SET A.LDCART = ' + %Char(ExtractFLDS.LDCART) +
001105210303                              ' where A.LDLNRF = ' + QUO + ExtractFLDS.LDLNRF
001106210303                                 + QUO +
001107210303                              ' and   A.LDVDAT = ' +  %Char(ExtractFLDS.LDVDAT);
001108210303
001109210303                   exec sql
001110210303                   execute immediate :wSqlStr;
001111210303
001112210303                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001113210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001114210305                      exsr errorHandler;
001120210303                   endif;
001121210303
001123210303       endsr;
001124210303
001125210301       //*************************************************************
001126210301       /EJECT
001127210301       //*************************************************************
001128210301       //                                                            *
001129210301       // writeToExtractFile - Write to Extract File                 *
001130210301       // ==================                                         *
001131210301       //                                                            *
001132210301       // Called by: Output File                                     *
001133210301       //                                                            *
001134210301       // Calls: None                                                *
001135210301       //                                                            *
001136210301       //*************************************************************
001137210301
001138210301
001139210301       begsr writeToExtractFile;
001140210304
001141210303                   fileToCheck = LELIBEPD;
001142210303                   exsr checkExist;
001143210304
001144210303                   if action = INSERT;
001145210303                        exsr insertExtractFile;
001146210306
001147210303                   elseif action = UPDATE;
001148210303                        exsr updateExtractFile;
001149210306
001150210303                   endif;
001151210301
001152210304
001153210301       endsr;
001154210303       //*************************************************************
001155210303       /EJECT
001156210303       //*************************************************************
001157210303       //                                                            *
001158210303       // writeToAuditLog - Write to Audit Log                       *
001159210303       // ===============                                            *
001160210303       //                                                            *
001161210303       // Called by: Output File                                     *
001162210303       //                                                            *
001163210303       // Calls: None                                                *
001164210303       //                                                            *
001165210303       //*************************************************************
001166210303
001167210303
001168210303       begsr writeToAuditLog;
001169210303
001172210305                   AuditLogds.SJTMST = %timestamp();
001174210305                   logData = %Trim(jsonData);
001184210305                   exec sql insert into SDARRLOGTD
001185210305                   values (
001186210305                            : AuditLogds.SJMODI,
001187210305                            : AuditLogds.SJTREF,
001188210305                            : AuditLogds.SJSTAT,
001189210305                            : AuditLogds.SJTMST,
001190210305                            : logData
001191210305                          );
001192210305
001193210305                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001196210305                        dBase    = 006;
001197210305                        dBfile   = 'SDARRLOGTD';
001198210305                        dBKey    = *BLANKS;
001199210305                        dBPgm    = 'ZAGETCALRT';
001200210305                        exsr *pssr;
001201210305                   endif;
001231210303
001232210303       endsr;
001233210224
001234210222       //*************************************************************
001235210222       /EJECT
001236210222       //*************************************************************
001237210222       //                                                            *
001238210222       // inzsr - Program Initialisation routine                     *
001239210222       //                                                            *
001240210222       // Called by: Main processing                                 *
001241210222       //                                                            *
001242210222       //  Calls: None                                               *
001243210222       //                                                            *
001244210222       //*************************************************************
001245210222
001246210222       begsr *inzsr;
001247210305
001248210305                   //Initialise audit log DS
001249210305                   clear AuditLogDS;
001250210306
001251210305                   AuditLogds.SJMODI = moduleID;
001252210305                   AuditLogds.SJTREF = transactREF;
001253210305                   AuditLogds.SJSTAT = 'C';
001254210304
001255210301                   pOption = '*FIRST';
001256210301                   pReturnCode = *Blanks;
001257210301                   callp ACCESS_SDBANK(
001258210301                                  pReturnCode
001259210301                                : pOption
001260210301                                : dsfdy
001261210301                               );
001262210301                   SDBANK = dsfdy;
001263210301
001264210301                   if pReturnCode <> *blanks;
001265210304                      Dbase    = 010;
001266210301                      DbFile   = 'SDBANKPD';
001267210301                      DbKey    = *BLANKS;
001268210301                      DbPgm    = 'ZAGETCALRT';
001269210301                      Exsr *Pssr;
001270210301                   endif;
001271210301
001272210305                   pOP01 = 'ARRAdapterURL';
001273210226
001274210305                   select;
001275210305                      when calcMethod = 'NCCR';
001276210305                           pOP02 = 'NCCR_PARM';
001277210305                      when calcMethod = 'CCR';
001278210305                           pOP02 = 'CCR_PARM';
001279210305                      when calcMethod = 'SARR';
001280210305                           pOP02 = 'SARR_PARM';
001281210305                      when calcMethod = 'SAVG';
001282210305                           pOP02 = 'SAVG_PARM';
001283210305                   endsl;
001284210226
001285210305
001286210305                   CallP ACCESS_SVAL(
001287210305                                       pRetCode
001288210305                                     : pOP01
001289210305                                     : pVL01
001290210305                                     : pOP02
001291210305                                     : pVL02
001292210305                                     : pOP03
001293210305                                     : pVL03
001294210305                                     : pOP04
001295210305                                     : pVL04
001296210305                                     : pOP05
001297210305                                     : pVL05
001298210305                                     : pOP06
001299210305                                     : pVL06
001300210305                                     : pOP07
001301210305                                     : pVL07
001302210305                                     : pOP08
001303210305                                     : pVL08
001304210305                                     : pOP09
001305210305                                     : pVL09
001306210305                                     : pOP10
001307210305                                     : pVL10
001308210305                                       );
001309210226
001310210305                   If pRetCode <> *Blanks;
001311210305                      DbFile = 'SDSVALPD';
001312210305                      Dbase  = 1;
001313210305                      DbKey  = pOP01;
001314210305                      DbPgm  = 'ZAGETCALRT';
001315210305                      Exsr *Pssr;
001316210305                   Endif;
001317210226
001318210305                   If pVL01 <> *Blanks;
001319210305                         CalcMetURL     = %trim(pVL01) + %trim(pVL02);
001320210305                   Else;
001321210305                      DbFile = 'SDSVALPD';
001322210305                      Dbase  = 3;
001323210305                      DbKey  = pOP01;
001324210305                      DbPgm  = 'ZAGETCALRT';
001325210305                      Exsr *Pssr;
001326210305                   Endif;
001327210303
001328210304                   // Get the highest date in the Daily History file
001329210304                   wSQLStr = 'select * from SDHSDRTD ' +
001330210305                             ' where CMODID = ' + QUO + moduleID + QUO +
001331210305                             ' and CTRNID = ' +  QUO + transactREF + QUO +
001332210303                             'order by CMINPD DESC';
001333210303
001334210303                   exec sql prepare P1 from :wSQLStr;
001335210303                   exec sql declare P1 cursor for P1;
001336210303                   exec sql open P1;
001337210303                   exec sql fetch next From P1 into :DailyHistDS;
001339210303
001340210303                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001341210303                      dBkey = *Blanks;
001342210303                      dBfile = 'SDHSDRTD';
001343210304                      dBase = 011;
001344210303                      dBpgm  = 'ZAGETCALRT';
001345210303                      exsr *pssr;
001346210303                   endif;
001347210303
001348210303                   if sqlCod = NO_RECORD;
001349210303                      transactDate = 0;
001350210303                   else;
001351210303                      transactDate = DailyHistDS.CMINPD;
001352210303                   endif;
001353210303
001354210303                   exec sql close P1;
001355210222       endsr;
001356210222
001357210222       //*************************************************************
001358210222       /EJECT
001359210222       //*************************************************************
001360210222       //                                                            *
001361210222       //   *pssr  - Program Error Processing Subroutine.            *
001362210222       //                                                            *
001363210222       //   Called By: Main Processing, various subroutines          *
001364210222       //                                                            *
001365210222       //*************************************************************
001366210222
001367210222       begsr *pssr;
001368210222                   *inu7 = *on;
001369210222                   *inu8 = *on;
001370210222                   *Inlr = *on;
001371210222                   dump;
001372210222                   return;
001373210222       endsr;
001374210305       //*************************************************************
001375210305       /EJECT
001376210305       //*************************************************************
001377210305       //                                                            *
001378210305       //   errorHandler - Generic Error Handler                     *
001379210305       //                                                            *
001380210305       //   Called By: Various subroutines                           *
001381210305       //                                                            *
001382210305       //*************************************************************
001383210305
001384210305       begsr errorHandler;
001385210306
001386210305                 AuditLogds.SJSTAT = 'F';
001387210305                 jsonData = errorMessage;
001388210306
001389210305       endsr;
001822210305       //*************************************************************
001823210305       /EJECT
001824210305       //*************************************************************
001825210305       //                                                            *
001826210305       // updateHistoryFile                                          *
001827210305       // =================                                          *
001828210305       //                                                            *
001829210305       // Called by: writeToARRDailyHistory                           *
001830210305       //                                                            *
001831210305       // Calls: None                                                *
001832210305       //                                                            *
001833210305       //*************************************************************
001834210305
001835210305       begsr updateHistoryFile;
001836210305
001837210305                   clear DailyHistDS;
001838210305                   DailyHistDS.CMODID = moduleID;
001839210305                   DailyHistDS.CTRNID = transactREF;
001840210305                   DailyHistDS.CMINPD = result.list(i).intPDMidas;
001841210305                   DailyHistDS.CINPDT = result.list(i).intPrdYMD;
001842210305                   DailyHistDS.CINPDY = result.list(i).intPrdDays;
001843210305                   DailyHistDS.CMOBPD = result.list(i).intOPMidas;
001844210305                   DailyHistDS.COBPDT = result.list(i).intObsYMD;
001845210305                   DailyHistDS.CPBRFR = result.list(i).pubRskFrRt;
001846210305                   DailyHistDS.CRTEAP = result.list(i).rateApplied;
001847210305                   DailyHistDS.CRFRAP = result.list(i).rskFrRtFlAp;
001848210305
001849210305                   select;
001850210305                        when calcMethod = 'NCCR';
001851210305                             DailyHistDS.CAVCRT =
001852210305                               %Dec(Result.List(i).dlyCompRate:30:9);
001853210305                        when calcMethod = 'CCR';
001854210305                             DailyHistDS.CAVCRT =
001855210305                               %Dec(Result.List(i).aveCompRate:30:9);
001856210305                   endsl;
001857210305
001858210305                  exec sql  update SDHSDRTD
001859210305                  set CMINPD = DailyHistDS.CMINPD
001860210305                  where CMODID = moduleID
001861210305                  and   CTRNID = transactREF;
001862210305
001863210306                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001864210305                        dBase    = 007;
001865210305                        dBfile   = 'SDHSDRTD';
001866210305                        dBKey    = *BLANKS;
001867210305                        dBPgm    = 'ZAGETCALRT';
001868210305                        exsr *pssr;
001869210305                   endif;
001870210305       endsr;
001917210305
002102210305
002103210305       //*************************************************************
002104210222
002105210222      /end-free
002106210222
002107210222     C/COPY ZSRSRC,ZACCHLE
002108210222     C/COPY ZSRSRC,ZBKDT_ILE
002109210222     C/COPY ZSRSRC,ZFWDT_ILE
002110210222
