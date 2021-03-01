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
000131210301     D/INCLUDE YAJL/QRPGLESRC,YAJL_H
000132210301     D/INCLUDE LIBHTTP/QRPGLESRC,HTTPAPI_H
000133210222     D/COPY ZACPYSRC,PSDS
000134210222     D/COPY ZACPYSRC,STD_D_SPEC
000135210222     D/COPY ZSRSRC,ZINTDYZ1LE
000136210222     D/COPY ZSRSRC,ZHOLILE
000137210222     D/COPY ZSRSRC,ZHOLELE
000138210222
000139210222
000140210222      ** +--------------------------------------+
000141210222      ** ¦ Program Prototypes                   ¦
000142210222      ** ¦ ==================                   ¦
000143210222      ** +--------------------------------------+
000144210226     D ACCESS_SVAL     PR                  EXTPGM('AOSVALR0')
000145210226     D pRetCode                       7A
000146210226     D pOP01                         20A
000147210226     D pVL01                        200A
000148210226     D pOP02                         20A
000149210226     D pVL02                        200A
000150210226     D pOP03                         20A
000151210226     D pVL03                        200A
000152210226     D pOP04                         20A
000153210226     D pVL04                        200A
000154210226     D pOP05                         20A
000155210226     D pVL05                        200A
000156210226     D pOP06                         20A
000157210226     D pVL06                        200A
000158210226     D pOP07                         20A
000159210226     D pVL07                        200A
000160210226     D pOP08                         20A
000161210226     D pVL08                        200A
000162210226     D pOP09                         20A
000163210226     D pVL09                        200A
000164210226     D pOP10                         20A
000165210226     D pVL10                        200A
000166210301
000167210301     D  ACCESS_SDBANK  pr                  extpgm('AOBANKR0')
000168210301     D    pReturnCode                 7A
000169210301     D    pOption                     7A
000171210301     D    pDSFDY                    200A
000172210301     D
000173210301     D  CONVERT_DATE   pr                  extpgm('ZDATE1')
000174210301     D    ErrorFlag                   7a
000175210301     D    DateIN                      6p 0
000177210301     D    DateInd                     1a
000178210301     D    DateOUT                     5p 0
000179210301
000180210222
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
000216210226     D  dayCntConvent                 1a
000217210224      ** Day Count Convention
000218210226     D  lockOutDays                   2a
000219210224      ** Lockout Days
000220210301     D  showDailyDeta                 5a
000221210224      ** Show Dailty Details
000222210301      ** True/False
000223210224     D  callTillDate                 10a
000224210224      ** Calculate Till Date
000225210222
000226210222     D Main            pi
000227210301      **-----------------------------------------------------**
000228210301     D  moduleID                      2a
000229210301      ** Module ID
000230210301      **--** LE - Lending
000231210301      **--** DL - Dealing
000232210301      **--** FR - FRA/IRS
000233210301     D  transactREF                   6a
000234210301      ** Transaction Reference
000235210226     D  calcMethod                    4a
000236210226      ** Calculation Method
000237210301      **--** NCCR - Daily Compounding in Arrears (Non-Cumulative Compounded Rate)
000238210301      **--** CCR  - Average Compounded In Arrears (Cumulative Compounded Rate)
000239210301      **--** SARR - Simple Average
000240210301      **--** SAVG - Simple Average
000241210301      **--** MANU - Manual
000242210226     D  intPrdStartDt                10a
000243210226      ** Interest Period Start Date
000244210226     D  intPrdEndDt                  10a
000245210226      ** Interest Period End Date
000246210226     D  riskFreeRate                  4a
000247210226      ** Risk Free Rate
000248210226     D  riskFreeRatFl                20a
000249210226      ** Risk Free Rate Floor
000250210226     D  lookBackDays                  2a
000251210226      ** Lookback Days
000252210301     D  obserPrdShift                 5a
000253210226      ** Observation Period Shift
000254210301      ** True/False
000255210226     D  RateRndDecPts                 3a
000256210226      ** Rate Rounding Decimal Points
000257210226     D  dayCntConvent                 1a
000258210226      ** Day Count Convention
000259210226     D  lockOutDays                   2a
000260210226      ** Lockout Days
000261210301     D  showDailyDeta                 5a
000262210226      ** Show Dailty Details
000263210301      ** True/False
000264210226     D  callTillDate                 10a
000265210226      ** Calculate Till Date
000266210224
000267210222      ** +--------------------------------------+
000268210222      ** ¦ Manually included D-specs            ¦
000269210222      ** ¦ =========================            ¦
000270210222      ** +--------------------------------------+
000271210301      ** Extract File
000272210301     D LELIBEDS      e ds                  extname(LELIBEPD)
000273210301     D ExtractFLDS     ds                  likeds(LELIBEDS)
000274210301      *
000275210222     D dssdy         e ds                  extname(DSSDY)
000276210222     D dsfdy         e ds                  extname(DSFDY)
000277210222
000278210222      ** +--------------------------------------+
000279210222      ** ¦ Constants declaration                ¦
000280210222      ** ¦ =====================                ¦
000281210222      ** +--------------------------------------+
000282210226     D QUE             c                   const('?')
000283210226     D AMP             c                   const('&')
000284210301     D EQUAL           c                   const(0)
000285210301     D HIGH            c                   const(1)
000286210301     D IGNORE_ERROR    c                   const(30)
000287210301     D LOW             c                   const(-1)
000288210301     D NOT_EXIST       c                   const(-204)
000289210301     D NO_ERROR        c                   const(0)
000290210301     D NO_RECORD       c                   const(100)
000291210301     D NOT_ALL_GRANT   c                   const(570)
000292210301     D NOT_FOUND       c                   const(-204)
000293210301     D QUO             c                   const('''')
000294210301     D START           c                   const(1)
000295210301     D TABLE_CREATED   c                   const(7905)
000296210301     D TABLE_IS_OPEN   c                   const(-501)
000297210226
000298210222      ** +--------------------------------------+
000299210222      ** ¦ Variable declaration                 ¦
000300210222      ** ¦ ====================                 ¦
000301210222      ** +--------------------------------------+
000302210226      ** AOSVALR0 Parameters
000303210226     D pRetCode        S              7A
000304210226     D pOP01           S             20A
000305210226     D pVL01           S            200A
000306210226     D pOP02           S             20A
000307210226     D pVL02           S            200A
000308210226     D pOP03           S             20A
000309210226     D pVL03           S            200A
000310210226     D pOP04           S             20A
000311210226     D pVL04           S            200A
000312210226     D pOP05           S             20A
000313210226     D pVL05           S            200A
000314210226     D pOP06           S             20A
000315210226     D pVL06           S            200A
000316210226     D pOP07           S             20A
000317210226     D pVL07           S            200A
000318210226     D pOP08           S             20A
000319210226     D pVL08           S            200A
000320210226     D pOP09           S             20A
000321210226     D pVL09           S            200A
000322210226     D pOP10           S             20A
000323210226     D pVL10           S            200A
000324210226      **
000325210224     D err             s             10i 0
000326210222     D rc              s             10i 0
000327210222     D msg             s             52a
000328210223     D URL             s            300a   varying inz(*blanks)
000329210222     D IFS             s            256a   varying
000330210224     D jsonData        s         100000a   varying
000331210226     D RestAPIParm     s            500a   varying inz(*blanks)
000332210226     D CalcMetURL      s            500a   varying inz(*blanks)
000333210301     D wSqlStr         S           2000A   INZ(*BLANKS)
000334210301     D pReturnCode     s              7a
000335210301     D pOption         s              7a
000336210301     D pSARD           s              6a
000337210301     D pDSSDY          s            200a
000338210301     D ErrorFlag       s              7a
000339210301     D DateIN          s              6p 0
000340210301     D DateInd         s              1a
000341210301     D DateOUT         s              5p 0
000342210226
000343210226      *---------------*
000344210226      ** JSON Details *
000345210226      *---------------*
000346210226
000347210226     D summary_t       ds                  qualified
000348210226     D                                     template
000349210226     D   intPrdDate                  10a
000350210226      ** Interest Period Date
000351210301     D   intPDMidas                   5p 0
000352210301      ** Interest Period Date in Midas Format
000353210226     D   intPrdDays                   2s 0
000354210226      ** Interest Period Days
000355210226     D   obsPrdDate                  10a
000356210226      ** Observation Period Date
000357210226     D   obsPrdDays                   2s 0
000358210226      ** Observation Period Days
000359210226     D   pubRskFrRt                   2s 0
000360210226      ** Published Risk Free Rate
000361210226     D   rateApplied                 30p 9
000362210226      ** Rate Applied
000363210226     D   rskFrRtFlAp                  5a
000364210226      ** Risk Free Rate Floor Applied
000365210226     D   compFactor                   5a
000366210226      ** Compounding Factor
000367210301     D   dlyCompRate                 10a
000368210226      ** Daily Compunded Rate
000369210226
000370210226     D request_t       ds                  qualified
000371210226     D                                     template
000372210226     D   intPrdStart                 10a
000373210226      ** Interest Period Start
000374210226     D   intPrdEnd                   10a
000375210226      ** Interest Period End
000376210226     D   rskFreeRate                  4a
000377210226      ** Risk Free Rate
000378210226     D   rskFreeRtFl                 15s 6
000379210226      ** Risk Free Rate Floor
000380210226     D   obsPrdShift                  8s 0
000381210226      ** Observation Period Shift
000382210226     D   ratRndDecPts                 8s 0
000383210226      ** Rate Rounding Decimal Points
000384210226     D   showDailyDet                 8s 0
000385210226      ** Show Daily Details
000386210226
000387210226     D result          ds                  qualified
000388210226     D   success                      1n
000389210226      ** Success
000390210226     D   errmsg                     500a   varying
000391210226      ** Error Message
000392210226     D   statusCode                   4a   varying
000393210226      ** Status Code
000394210226     D   message                     10a   varying
000395210226      ** Message
000396210226     D   comment                    500a   varying
000397210226      ** Comment
000398210226     D   lastUpdFrSrc               200a   varying
000399210226      ** Last Updated From Source
000400210226     D   legalDisc                  200a   varying
000401210226      ** Legal Disclaimer
000402210226     D   reqParms                          likeds(request_t)
000403210226      ** Request Parameters
000404210226     D   list                              likeds(summary_t) dim(999)
000405210226      ** Daily Rate Summary
000406210301
000407210301     D SDBANK        e ds                  extname(SDBANKPD)
000408210301     D                 DS
000409210301     D ISODate                 1     10
000410210301     D WkYear                  3      4  0
000411210301     D WkMonth                 6      7  0
000412210301     D WkDay                   9     10  0
000413210301
000414210301     D                 DS
000415210301     D DateIN_D                1      6  0
000416210301     D DD1D                    1      2  0
000417210301     D DD1M                    3      4  0
000418210301     D DD1Y                    5      6  0
000419210301     D                 DS
000420210301     D DateIN_M                1      6  0
000421210301     D DD2M                    1      2  0
000422210301     D DD2D                    3      4  0
000423210301     D DD2Y                    5      6  0
000424210226
000425210226     D docNode         s                   like(yajl_val)
000426210226     D list            s                   like(yajl_val)
000427210226     D node            s                   like(yajl_val)
000428210226     D val             s                   like(yajl_val)
000429210226
000430210226     D i               s             10i 0
000431210226     D lastElem        s             10i 0
000432210226     D dateUSA         s             10a
000433210226     D errMsg          s            500a   varying inz('')
000434210226
000435210222      ** +--------------------------------------+
000436210222      ** ¦ Array declaration                    ¦
000437210222      ** ¦ ==================                   ¦
000438210222      ** +--------------------------------------+
000439210222
000440210222      /free
000441210222
000442210222       // ** +--- Start of Main processing -----------------------------------+
000443210222       // ** ¦                                                                ¦
000444210222       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
000445210222       // ** ¦ executed at program activation.                                ¦
000446210222       // ** ¦                                                                ¦
000447210222       // ** +----------------------------------------------------------------+
000448210222
000449210224                   exsr processTransaction;
000450210222
000451210222                   *Inlr = *On;
000452210222                   return;
000453210222
000454210222       //*************************************************************
000455210222       /EJECT
000456210222       //*************************************************************
000457210222       //                                                            *
000458210224       // processTransaction - Process a Loan Transaction            *
000459210224       // ==================                                         *
000460210222       //                                                            *
000461210222       // Called by: Main Processing                                 *
000462210222       //                                                            *
000463210222       // Calls: None                                                *
000464210222       //                                                            *
000465210222       //*************************************************************
000466210222
000467210224       begsr processTransaction;
000468210224
000469210226       //**        exsr buildParameter;
000470210224
000471210226       //**        exsr consumeRESTAPI;
000472210224
000473210224                   exsr parseJSONData;
000474210224
000475210301                   exsr outputFiles;
000476210224
000477210222       endsr;
000512210222
000513210224       //*************************************************************
000514210224       /EJECT
000515210224       //*************************************************************
000516210224       //                                                            *
000517210224       // buildParameter - Build REST API Parameter                  *
000518210224       // ==============                                             *
000519210224       //                                                            *
000520210224       // Called by: processTransaction                              *
000521210224       //                                                            *
000522210224       // Calls: None                                                *
000523210224       //                                                            *
000524210224       //*************************************************************
000525210224
000526210224       begsr buildParameter;
000527210226
000528210226                   RestAPIParm = CalcMetURL + QUE +
000529210226                                 'interestPeriodStartDate=' + intPrdStartDt +
000530210226                                 AMP + 'interestPeriodEndDate=' + intPrdEndDt +
000531210226                                 AMP + 'riskFreeRate=' + riskFreeRate +
000532210226                                 AMP + 'lookBackDays=' + lookBackDays  +
000533210226                                 AMP + 'rateRoundingDecimalPoints=' +
000534210226                                       RateRndDecPts +
000535210226                                 AMP + 'observationPeriodShift=' +
000536210226                                       obserPrdShift +
000537210226                                 AMP + 'lockoutDays=' + lockOutDays +
000539210226                                 AMP + 'showDailyDetails=' + showDailyDeta +
000540210226                                 AMP + 'calculateTillDate=' +  callTillDate +
000541210226                                 AMP + 'riskFreeRateFloor=' + riskFreeRatFl;
000545210224       endsr;
000546210224
000547210224       //*************************************************************
000548210224       /EJECT
000549210224       //*************************************************************
000550210224       //                                                            *
000551210224       // consumeRESTAPI - Consume REST API                          *
000552210224       // ==============                                             *
000553210224       //                                                            *
000554210224       // Called by: processTransaction                              *
000555210224       //                                                            *
000556210224       // Calls: None                                                *
000557210224       //                                                            *
000558210224       //*************************************************************
000559210224
000560210224       begsr consumeRestAPI;
000565210224
000566210224                monitor;
000567210226                   jsonData = http_string( 'GET' : RestAPIParm);
000568210224                   msg = *blanks;
000569210224                   err = 0;
000570210224                on-error;
000571210224                   msg = http_error(err);
000572210224                endmon;
000573210224
000574210224       endsr;
000575210224
000576210224       //*************************************************************
000577210224       /EJECT
000578210224       //*************************************************************
000579210224       //                                                            *
000580210224       // parseJSONData - Parse JSON Data                            *
000581210224       // =============                                              *
000582210224       //                                                            *
000583210224       // Called by: processTransaction                              *
000584210224       //                                                            *
000585210224       // Calls: None                                                *
000586210224       //                                                            *
000587210224       //*************************************************************
000588210224
000589210224       begsr parseJSONData;
000590210226
000591210226                  docNode =
000592210226                  yajl_stmf_load_tree( '/temp/NCCR.json' : errMsg );
000593210226
000594210226                  if errMsg <> '';
000595210226                      DbFile = 'NCCR.JSON';
000596210226                      Dbase  = 4;
000597210226                      DbKey  = *BLANKS;
000598210226                      DbPgm  = 'ZAGETCALRT';
000599210226                      Exsr *Pssr;
000601210226                  endif;
000602210226
000603210226                  node = YAJL_object_find(docNode: 'comment');
000604210226                  result.comment = YAJL_get_string(node);
000605210226
000606210226                  node = YAJL_object_find(docNode: 'errmsg');
000607210226                  result.errmsg = YAJL_get_string(node);
000608210226
000609210226                  list = YAJL_object_find(docNode: 'dailyRateSummary');
000610210226
000611210226                  i = 0;
000612210226                  dow YAJL_ARRAY_LOOP( list: i: node );
000613210226
000614210226                       lastElem = i;
000615210226
000616210226                       val = YAJL_object_find(node: 'interestPeriodDate');
000617210226                       result.list(i).intPrdDate = yajl_get_string(val);
000618210301
000619210301                       ISODate =  result.list(i).intPrdDate;
000620210301
000621210301                       if BJDFIN = 'D';
000622210301                          DD1D = wkDay;
000623210301                          DD1M = wkMonth;
000624210301                          DD1Y = wkYear;
000625210301                          DateIn = DateIn_D;
000626210301                       else;
000627210301                          DD2D = wkDay;
000628210301                          DD2M = wkMonth;
000629210301                          DD2Y = wkYear;
000630210301                          DateIn = DateIn_M;
000631210301                       endif;
000632210301                       pOption = '*FIRST';
000633210301                       pReturnCode = *Blanks;
000634210301                       callp CONVERT_DATE(
000635210301                                  ErrorFlag
000636210301                                : DateIN
000637210301                                : BJDFIN
000638210301                                : DateOUT
000640210301                               );
000641210301
000642210301                       if ErrorFlag   <> *blanks;
000643210301                           Dbase    = 007;
000644210301                           DbFile   = *Blanks;
000645210301                           DbKey    = *BLANKS;
000646210301                           DbPgm    = 'ZAGETCALRT';
000647210301                           Exsr *Pssr;
000648210301                       endif;
000649210301
000650210301                       result.list(i).intPDMidas = DateOUT;
000651210226
000652210226                       val = YAJL_object_find(node: 'interestPeriodDays');
000653210226                       result.list(i).intPrdDays =  yajl_get_number(val);
000654210226
000655210226                       val = YAJL_object_find(node: 'observationPeriodDate');
000656210226                       result.list(i).obsPrdDate = yajl_get_string(val);
000657210226
000658210226                       val = YAJL_object_find(node: 'observationPeriodDays');
000659210226                       result.list(i).obsPrdDays =  yajl_get_number(val);
000660210226
000661210226                       val = YAJL_object_find(node: 'publishedRiskFreeRate');
000662210226                       result.list(i).pubRskFrRt =  yajl_get_number(val);
000663210226
000664210226                       val = YAJL_object_find(node: 'rateApplied');
000665210226                       result.list(i).rateApplied=  yajl_get_number(val);
000666210226
000667210226                       val = YAJL_object_find(node: 'riskFreeRateFloorApplied');
000668210226                       if YAJL_is_true(node);
000669210226                           result.list(i).rskFrRtFlAp=  'True';
000670210226                       else;
000671210226                           result.list(i).rskFrRtFlAp=  'False';
000672210226                       endif;
000673210226
000674210226                       val = YAJL_object_find(node: 'compoundingFactor');
000675210226                       result.list(i).compFactor=  yajl_get_string(val);
000676210226
000677210226                       val = YAJL_object_find(node: 'dailyCompoundedRate');
000678210301                       result.list(i).dlyCompRate=  yajl_get_string(val);
000679210226
000680210226                  enddo;
000681210226
000682210226                  yajl_tree_free(docNode);
000683210224
000684210224       endsr;
000685210224
000686210224       //*************************************************************
000687210224       /EJECT
000688210224       //*************************************************************
000689210224       //                                                            *
000690210301       // outputFile - Output Files                                  *
000691210301       // ==========                                                 *
000692210224       //                                                            *
000693210224       // Called by: processTransaction                              *
000694210224       //                                                            *
000695210224       // Calls: None                                                *
000696210224       //                                                            *
000697210224       //*************************************************************
000698210224
000699210301       begsr outputFiles;
000700210226
000701210226
000702210226                   i = 1;
000703210226                   dow i <= lastElem;
000704210301
000705210301                       exsr writeToExtractFile;
000706210301                       i = i + 1;
000707210226                   enddo;
000708210226
000709210224
000710210224       endsr;
000711210301
000712210301       //*************************************************************
000713210301       /EJECT
000714210301       //*************************************************************
000715210301       //                                                            *
000716210301       // writeToExtractFile - Write to Extract File                 *
000717210301       // ==================                                         *
000718210301       //                                                            *
000719210301       // Called by: Output File                                     *
000720210301       //                                                            *
000721210301       // Calls: None                                                *
000722210301       //                                                            *
000723210301       //*************************************************************
000724210301
000725210301
000726210301       begsr writeToExtractFile;
000727210301
000728210301                    wSQLStr = 'select * from LELIBEPD ' +
000729210301                             'where LDLNRF = ' + TransactREF +
000730210301                             ' and   LDVDAT = ' +
000731210301                               Result.List(i).intPDMidas;
000732210301
000733210301                   exec sql prepare P1 from :wSQLStr;
000734210301                   exec sql declare P1 cursor for P1;
000735210301                   exec sql open P1;
000736210301                   exec sql fetch next From P1 into :ExtractFLDS;
000737210301
000741210301
000742210301                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
000743210301                      dBkey = *Blanks;
000744210301                      dBfile = 'SDRPKYTD';
000745210301                      dBase = 003;
000746210301                      dBpgm  = 'LE000495';
000747210301                      exsr *pssr;
000748210301                   endif;
000749210301
000751210301                   ExtractFLDS.LDLNRF = TransactREF;
000752210301                   ExtractFLDS.LDVDAT = Result.List(i).intPDMidas;
000753210301                   ExtractFLDS.LDCART =
000754210301                   %Dec(Result.List(i).dlyCompRate:30:9);
000755210301
000756210301                   if sqlCod = NO_RECORD;
000757210301                        exec sql insert into LELIBEPD
000758210301                        values (:ExtractFLDS);
000759210301
000760210301                        if sqlCod <> NO_ERROR and sqlCod <> NO_ERROR;
000761210301                             dBase    = 013;
000762210301                             dBfile   = 'LELIBEPD';
000763210301                             dBKey    = *BLANKS;
000764210301                             dBPgm    = 'ZAGETCALRT';
000765210301                             exsr *pssr;
000766210301                        endif;
000767210301                   else;
000768210301                        exec sql update LELIBEPD
000769210301                        set LDCART = ExtractFLDS.LDCART
000770210301                        where LDLNRF = TransacREF
000771210301                        and   LDVDAT = BJRNDB;
000772210301
000773210301                        if sqlCod <> NO_ERROR and sqlCod <> NO_ERROR;
000774210301                             dBase    = 013;
000775210301                             dBfile   = 'LELIBEPD';
000776210301                             dBKey    = *BLANKS;
000777210301                             dBPgm    = 'ZAGETCALRT';
000778210301                             exsr *pssr;
000779210301                        endif;
000780210301
000781210301                   endif;
000782210301       endsr;
000783210224
000784210222       //*************************************************************
000785210222       /EJECT
000786210222       //*************************************************************
000787210222       //                                                            *
000788210222       // inzsr - Program Initialisation routine                     *
000789210222       //                                                            *
000790210222       // Called by: Main processing                                 *
000791210222       //                                                            *
000792210222       //  Calls: None                                               *
000793210222       //                                                            *
000794210222       //*************************************************************
000795210222
000796210222       begsr *inzsr;
000797210301                   pOption = '*FIRST';
000798210301                   pReturnCode = *Blanks;
000799210301                   callp ACCESS_SDBANK(
000800210301                                  pReturnCode
000801210301                                : pOption
000802210301                                : dsfdy
000803210301                               );
000804210301                   SDBANK = dsfdy;
000805210301
000806210301                   if pReturnCode <> *blanks;
000807210301                      Dbase    = 006;
000808210301                      DbFile   = 'SDBANKPD';
000809210301                      DbKey    = *BLANKS;
000810210301                      DbPgm    = 'ZAGETCALRT';
000811210301                      Exsr *Pssr;
000812210301                   endif;
000813210301
000814210226
000815210226       //          select;
000816210226       //               when calcMethod = 'NCCR';
000817210226       //                    pOP01 = 'NCCR_PARM';
000818210226       //               when calcMethod = 'CCR';
000819210226       //                    pOP01 = 'CCR_PARM';
000820210226       //               when calcMethod = 'SARR';
000821210226       //                    pOP01 = 'SARR_PARM';
000822210226       //               when calcMethod = 'SAVG';
000823210226       //                    pOP01 = 'SAVG_PARM';
000824210226       //          endsl;
000825210226
000826210226       //          CallP ACCESS_SVAL(
000827210226       //                              pRetCode
000828210226       //                            : pOP01
000829210226       //                            : pVL01
000830210226       //                            : pOP02
000831210226       //                            : pVL02
000832210226       //                            : pOP03
000833210226      //                             : pVL03
000834210226      //                             : pOP04
000835210226      //                             : pVL04
000836210226      //                             : pOP05
000837210226      //                             : pVL05
000838210226      //                             : pOP06
000839210226      //                             : pVL06
000840210226      //                             : pOP07
000841210226      //                             : pVL07
000842210226      //                             : pOP08
000843210226      //                             : pVL08
000844210226      //                             : pOP09
000845210226      //                             : pVL09
000846210226      //                             : pOP10
000847210226      //                             : pVL10
000848210226      //                               );
000849210226
000850210226      //           If pRetCode <> *Blanks;
000851210226      //              DbFile = 'SDSVALPD';
000852210226      //              Dbase  = 1;
000853210226      //              DbKey  = pOP01;
000854210226      //              DbPgm  = 'ZAGETCALRT';
000855210226      //              Exsr *Pssr;
000856210226      //           Endif;
000857210226
000858210226      //           If pVL01 <> *Blanks;
000859210226      //              Monitor;
000860210226      //                 CalcMetURL     = pVL01;
000861210226      //              On-Error;
000862210226      //                 DbFile = 'SDSVALPD';
000863210226      //                 Dbase  = 2;
000864210226      //                 DbKey  = pOP01;
000865210226      //                 DbPgm  = 'ZAGETCALRT';
000866210226      //                 Exsr *Pssr;
000867210226      //              EndMon;
000868210226      //           Else;
000869210226      //              DbFile = 'SDSVALPD';
000870210226      //              Dbase  = 3;
000871210226      //              DbKey  = pOP01;
000872210226      //              DbPgm  = 'ZAGETCALRT';
000873210226      //              Exsr *Pssr;
000874210226      //           Endif;
000875210222       endsr;
000876210222
000877210222       //*************************************************************
000878210222       /EJECT
000879210222       //*************************************************************
000880210222       //                                                            *
000881210222       //   *pssr  - Program Error Processing Subroutine.            *
000882210222       //                                                            *
000883210222       //   Called By: Main Processing, various subroutines          *
000884210222       //                                                            *
000885210222       //*************************************************************
000886210222
000887210222       begsr *pssr;
000888210222                   *inu7 = *on;
000889210222                   *inu8 = *on;
000890210222                   *Inlr = *on;
000891210222                   dump;
000892210222                   return;
000893210222       endsr;
000894210222
000895210222      /end-free
000896210222
000897210222     C/COPY ZSRSRC,ZACCHLE
000898210222     C/COPY ZSRSRC,ZBKDT_ILE
000899210222     C/COPY ZSRSRC,ZFWDT_ILE
000900210222
