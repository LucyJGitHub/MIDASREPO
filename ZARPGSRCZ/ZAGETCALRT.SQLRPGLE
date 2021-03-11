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
000205210310     D  riskFreeRate                  5a
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
000225210310     D  benchMarkAdj                 20a
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
000248210310     D  riskFreeRate                  5a
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
000268210310     D  benchMarkAdj                 20a
000269210305      ** Benchmark Adjustment
000270210224
000271210222      ** +--------------------------------------+
000272210222      ** ¦ Manually included D-specs            ¦
000273210222      ** ¦ =========================            ¦
000274210222      ** +--------------------------------------+
000275210310      ** +--------------------------------------+
000276210303
000277210301      ** Extract File
000278210301     D LELIBEDS      e ds                  extname(LELIBEPD)
000279210301     D ExtractFLDS     ds                  likeds(LELIBEDS)
000280210303
000281210303      ** Audit Log
000282210303     D SDARRLDS      e ds                  extname(SDARRLOGTD)
000283210303     D AuditLogDS      ds                  likeds(SDARRLDS)
000284210303
000285210303      ** ARR Daily Rates History File
000286210303     D ARRDLYDS      e ds                  extname(SDHSDRTD)
000287210303     D DailyHistDS     ds                  likeds(ARRDLYDS)
000288210303
000289210304      ** Core DS
000290210222     D dssdy         e ds                  extname(DSSDY)
000291210222     D dsfdy         e ds                  extname(DSFDY)
000292210222
000293210222      ** +--------------------------------------+
000294210222      ** ¦ Constants declaration                ¦
000295210222      ** ¦ =====================                ¦
000296210222      ** +--------------------------------------+
000297210304
000298210304     D AMP             c                   const('&')
000301210304     D INSERT          c                   const(0)
000302210304     D LELIBEPD        c                   const(1)
000305210301     D NO_ERROR        c                   const(0)
000306210301     D NO_RECORD       c                   const(100)
000309210301     D QUO             c                   const('''')
000310210304     D QUE             c                   const('?')
000312210304     D SDHSDRTD        c                   const(0)
000315210303     D UPDATE          c                   const(1)
000316210310     D HTTP_HEAD       c                   const('http://')
000317210226
000318210222      ** +--------------------------------------+
000319210222      ** ¦ Variable declaration                 ¦
000320210222      ** ¦ ====================                 ¦
000321210222      ** +--------------------------------------+
000322210226      ** AOSVALR0 Parameters
000323210226     D pRetCode        S              7A
000324210226     D pOP01           S             20A
000325210226     D pVL01           S            200A
000326210226     D pOP02           S             20A
000327210226     D pVL02           S            200A
000328210226     D pOP03           S             20A
000329210226     D pVL03           S            200A
000330210226     D pOP04           S             20A
000331210226     D pVL04           S            200A
000332210226     D pOP05           S             20A
000333210226     D pVL05           S            200A
000334210226     D pOP06           S             20A
000335210226     D pVL06           S            200A
000336210226     D pOP07           S             20A
000337210226     D pVL07           S            200A
000338210226     D pOP08           S             20A
000339210226     D pVL08           S            200A
000340210226     D pOP09           S             20A
000341210226     D pVL09           S            200A
000342210226     D pOP10           S             20A
000343210226     D pVL10           S            200A
000344210304
000345210304      ** Work variables
000346210310     D i               s             10i 0
000347210224     D err             s             10i 0
000348210222     D msg             s             52a
000350210304     D jsonData        s         999999a   varying
000351210305     D LogData         s          10000a   varying
000352210304     D RestAPIParm     s          65535a   varying inz(*blanks)
000353210226     D CalcMetURL      s            500a   varying inz(*blanks)
000354210301     D wSqlStr         S           2000A   INZ(*BLANKS)
000355210301     D pReturnCode     s              7a
000356210301     D pOption         s              7a
000359210301     D ErrorFlag       s              7a
000360210301     D DateIN          s              6p 0
000362210301     D DateOUT         s              5p 0
000363210303     D transactDate    s              5p 0
000364210303     D fileToCheck     s              1s 0
000366210304     D lastElem        s             10i 0
000368210304     D errMsg          s            500a   varying inz('')
000369210304     D action          s              1s 0
000370210305     D errorMessage    s            100a
000371210305     D includeRecord   s              1a   inz('N')
000372210310     D compAveRate     s             30p 9 inz(0)
000373210226
000374210226      *---------------*
000375210226      ** JSON Details *
000376210226      *---------------*
000377210226
000378210226     D summary_t       ds                  qualified
000379210226     D                                     template
000380210226     D   intPrdDate                  10a
000381210226      ** Interest Period Date
000382210303      ** NCCR, CCR, SAVG, SARR
000383210301     D   intPDMidas                   5p 0
000384210301      ** Interest Period Date in Midas Format
000385210303     D   intPrdYMD                    6a
000386210303      ** Interest Period Date YYMMDD
000387210226     D   intPrdDays                   2s 0
000388210226      ** Interest Period Days
000389210303      ** NCCR, CCR, SAVG, SARR
000390210226     D   obsPrdDate                  10a
000391210226      ** Observation Period Date
000392210303      ** NCCR
000393210303     D   intOPMidas                   5p 0
000394210303      ** Observation Period Date in Midas Format
000395210303     D   intObsYMD                    6a
000396210303      ** Observation Period Date YYMMDD
000397210226     D   obsPrdDays                   2s 0
000398210226      ** Observation Period Days
000399210303      ** NCCR
000400210305     D   pubRskFrRt                  30p 9
000401210226      ** Published Risk Free Rate
000402210303      ** NCCR, CCR, SAVG, SARR
000403210226     D   rateApplied                 30p 9
000404210226      ** Rate Applied
000405210303      ** NCCR, CCR, SAVG, SARR
000406210226     D   rskFrRtFlAp                  5a
000407210226      ** Risk Free Rate Floor Applied
000408210303      ** NCCR, CCR, SAVG, SARR
000409210304     D   compFactor                  10a
000410210226      ** Compounding Factor
000411210303      ** NCCR
000412210301     D   dlyCompRate                 10a
000413210226      ** Daily Compunded Rate
000414210303      ** NCCR
000415210303     D   aveCompRate                 10a
000416210303      ** Average Compunded Rate
000417210303      ** CCR
000418210303     D   simpleAve                   10a
000419210303      ** Simple Average
000420210303      ** SAVG
000421210226
000422210226     D request_t       ds                  qualified
000423210226     D                                     template
000424210226     D   intPrdStart                 10a
000425210226      ** Interest Period Start
000426210226     D   intPrdEnd                   10a
000427210226      ** Interest Period End
000428210226     D   rskFreeRate                  4a
000429210226      ** Risk Free Rate
000430210226     D   rskFreeRtFl                 15s 6
000431210226      ** Risk Free Rate Floor
000432210226     D   obsPrdShift                  8s 0
000433210226      ** Observation Period Shift
000434210226     D   ratRndDecPts                 8s 0
000435210226      ** Rate Rounding Decimal Points
000436210226     D   showDailyDet                 8s 0
000437210226      ** Show Daily Details
000438210226
000439210226     D result          ds                  qualified
000440210226     D   success                      1n
000441210226      ** Success
000442210226     D   errmsg                     500a   varying
000443210226      ** Error Message
000444210226     D   statusCode                   4a   varying
000445210226      ** Status Code
000446210226     D   message                     10a   varying
000447210226      ** Message
000448210226     D   comment                    500a   varying
000449210226      ** Comment
000450210226     D   lastUpdFrSrc               200a   varying
000451210226      ** Last Updated From Source
000452210226     D   legalDisc                  200a   varying
000453210226      ** Legal Disclaimer
000454210226     D   reqParms                          likeds(request_t)
000455210226      ** Request Parameters
000456210226     D   list                              likeds(summary_t) dim(999)
000457210226      ** Daily Rate Summary
000458210301
000459210301     D SDBANK        e ds                  extname(SDBANKPD)
000460210301     D                 DS
000461210301     D ISODate                 1     10
000462210301     D WkYear                  3      4  0
000463210301     D WkMonth                 6      7  0
000464210301     D WkDay                   9     10  0
000465210303
000466210303     D                 DS
000467210303     D YYMMDD                  1      6
000468210303     D WkY                     1      2
000469210303     D WkM                     3      4
000470210303     D WkD                     5      6
000471210301
000472210301     D                 DS
000473210301     D DateIN_D                1      6  0
000474210301     D DD1D                    1      2  0
000475210301     D DD1M                    3      4  0
000476210301     D DD1Y                    5      6  0
000477210301     D                 DS
000478210301     D DateIN_M                1      6  0
000479210301     D DD2M                    1      2  0
000480210301     D DD2D                    3      4  0
000481210301     D DD2Y                    5      6  0
000482210226
000483210226     D docNode         s                   like(yajl_val)
000484210226     D list            s                   like(yajl_val)
000485210226     D node            s                   like(yajl_val)
000486210226     D val             s                   like(yajl_val)
000487210305     D cStr            S             10a   Varying
000489210226
000490210222      ** +--------------------------------------+
000491210222      ** ¦ Array declaration                    ¦
000492210222      ** ¦ ==================                   ¦
000493210222      ** +--------------------------------------+
000494210309
000495210309     D arrCalLoc       s            100a   dim(4) ctdata perrcd(1)
000496210222
000497210222      /free
000498210222
000499210222       // ** +--- Start of Main processing -----------------------------------+
000500210222       // ** ¦                                                                ¦
000501210222       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
000502210222       // ** ¦ executed at program activation.                                ¦
000503210222       // ** ¦                                                                ¦
000504210222       // ** +----------------------------------------------------------------+
000505210304
000506210224                   exsr processTransaction;
000507210222
000508210222                   *Inlr = *On;
000509210222                   return;
000510210310
000511210310       //*************************************************************
000512210310       /EJECT
000513210310       //*************************************************************
000514210310       //                                                            *
000515210310       // inzsr - Program Initialisation routine                     *
000516210310       //                                                            *
000517210310       // Called by: Main processing                                 *
000518210310       //                                                            *
000519210310       //  Calls: None                                               *
000520210310       //                                                            *
000521210310       //*************************************************************
000522210310
000523210310       begsr *inzsr;
000524210310
000525210310                   //Initialise audit log DS
000526210310                   clear AuditLogDS;
000527210310
000528210310                   AuditLogds.SJMODI = moduleID;
000529210310                   AuditLogds.SJTREF = transactREF;
000530210310                   AuditLogds.SJSTAT = 'C';
000531210310
000532210310                   pOption = '*FIRST';
000533210310                   pReturnCode = *Blanks;
000534210310
000535210310                   callp ACCESS_SDBANK(
000536210310                                  pReturnCode
000537210310                                : pOption
000538210310                                : dsfdy
000539210310                               );
000540210310                   SDBANK = dsfdy;
000541210310
000542210310                   if pReturnCode <> *blanks;
000543210310                      Dbase    = 001;
000544210310                      DbFile   = 'SDBANKPD';
000545210310                      DbKey    = *BLANKS;
000546210310                      DbPgm    = 'ZAGETCALRT';
000547210310                      Exsr *Pssr;
000548210310                   endif;
000549210310
000550210310                   pOP01 = 'ARRAdapterURL';
000551210310
000553210310                   CallP ACCESS_SVAL(
000554210310                                       pRetCode
000555210310                                     : pOP01
000556210310                                     : pVL01
000557210310                                     : pOP02
000558210310                                     : pVL02
000559210310                                     : pOP03
000560210310                                     : pVL03
000561210310                                     : pOP04
000562210310                                     : pVL04
000563210310                                     : pOP05
000564210310                                     : pVL05
000565210310                                     : pOP06
000566210310                                     : pVL06
000567210310                                     : pOP07
000568210310                                     : pVL07
000569210310                                     : pOP08
000570210310                                     : pVL08
000571210310                                     : pOP09
000572210310                                     : pVL09
000573210310                                     : pOP10
000574210310                                     : pVL10
000575210310                                       );
000576210310
000577210310                   If pRetCode <> *Blanks;
000578210310                      DbFile = 'SDSVALPD';
000579210310                      Dbase  = 002;
000580210310                      DbKey  = pOP01;
000581210310                      DbPgm  = 'ZAGETCALRT';
000582210310                      Exsr *Pssr;
000583210310                   Endif;
000584210310
000585210310                   If pVL01 <> *Blanks;
000586210310                         CalcMetURL     = HTTP_HEAD  + %trim(pVL01);
000587210310                   Else;
000588210310                      DbFile = 'SDSVALPD';
000589210310                      Dbase  = 003;
000590210310                      DbKey  = pOP01;
000591210310                      DbPgm  = 'ZAGETCALRT';
000592210310                      Exsr *Pssr;
000593210310                   Endif;
000594210310
000595210310                   select;
000596210310
000597210310                       when calcMethod = 'NCCR';
000598210310                            calcMetURL =  %trim(calcMetURL) +
000599210310                              %trim(arrCalLoc(1));
000600210310
000601210310                       when calcMethod = 'CCR';
000602210310                            calcMetURL =  %trim(calcMetURL) +
000603210310                              %trim(arrCalLoc(2));
000604210310
000605210310                       when calcMethod = 'SARR';
000606210310                            calcMetURL =  %trim(calcMetURL) +
000607210310                              %trim(arrCalLoc(3));
000608210310
000609210310                       when calcMethod = 'SAVG';
000610210310                            calcMetURL =  %trim(calcMetURL) +
000611210310                              %trim(arrCalLoc(4));
000612210310
000613210310                   endsl;
000614210310
000615210310                   // Get the highest date in the Daily History file
000616210310                   wSQLStr = 'select * from SDHSDRTD ' +
000617210310                             ' where CMODID = ' + QUO + moduleID + QUO +
000618210310                             ' and CTRNID = ' +  QUO + transactREF + QUO +
000619210310                             'order by CMINPD DESC';
000620210310
000621210310                   exec sql prepare P1 from :wSQLStr;
000622210310                   exec sql declare P1 cursor for P1;
000623210310                   exec sql open P1;
000624210310                   exec sql fetch next From P1 into :DailyHistDS;
000625210310
000626210310                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
000627210310                      dBkey = *Blanks;
000628210310                      dBfile = 'SDHSDRTD';
000629210310                      dBase = 004;
000630210310                      dBpgm  = 'ZAGETCALRT';
000631210310                      exsr *pssr;
000632210310                   endif;
000633210310
000634210310                   if sqlCod = NO_RECORD;
000635210310                      transactDate = 0;
000636210310                   else;
000637210310                      transactDate = DailyHistDS.CMINPD;
000638210310                   endif;
000639210310
000640210310                   exec sql close P1;
000641210310       endsr;
000642210222
000643210222       //*************************************************************
000644210222       /EJECT
000645210222       //*************************************************************
000646210222       //                                                            *
000647210224       // processTransaction - Process a Loan Transaction            *
000648210224       // ==================                                         *
000649210222       //                                                            *
000650210222       // Called by: Main Processing                                 *
000651210222       //                                                            *
000652210222       // Calls: None                                                *
000653210222       //                                                            *
000654210222       //*************************************************************
000655210222
000656210224       begsr processTransaction;
000657210305
000658210306                   //** This will build the URL parameter for the Rest API Call
000659210305
000660210304                   exsr buildParameter;
000661210224
000662210306                   //** This will call the http_string function from LIBHTTP123
000663210305                   //** to consume the Rest API
000664210305
000665210304                   exsr consumeRESTAPI;
000666210305
000667210305                   if msg = *blanks;
000668210305
000669210305                      //** This will parse the JSON data returned from ARR Calculator
000670210306                      //** and store it to an array of Data Structure
000671210305
000672210305                      exsr parseJSONData;
000673210305
000674210305                      //** This will handle the output of the array DS to the
000675210305                      //** history and extract files
000676210306
000677210305                      exsr outputFiles;
000678210305
000679210305                   endif;
000680210224
000681210305                   //** log details to audit file
000682210305                   exsr writeToAuditLog;
000683210224
000684210222       endsr;
000685210222
000686210224       //*************************************************************
000687210224       /EJECT
000688210224       //*************************************************************
000689210224       //                                                            *
000690210224       // buildParameter - Build REST API Parameter                  *
000691210224       // ==============                                             *
000692210224       //                                                            *
000693210224       // Called by: processTransaction                              *
000694210224       //                                                            *
000695210224       // Calls: None                                                *
000696210224       //                                                            *
000697210224       //*************************************************************
000698210224
000699210224       begsr buildParameter;
000700210304
000701210305                   RestAPIParm = %trim(CalcMetURL) +
000702210305                                 QUE + 'interestPeriodStartDate=' +
000703210305                                       %trim(intPrdStartDt) +
000704210304                                 AMP + 'interestPeriodEndDate=' +
000705210305                                    %trim(intPrdEndDt) +
000706210305                                 AMP + 'riskFreeRate=' +
000707210305                                    %trim(riskFreeRate) +
000708210305                                 AMP + 'lookBackDays=' +
000709210305                                    %trim(lookBackDays)  +
000710210226                                 AMP + 'rateRoundingDecimalPoints=' +
000711210305                                    %trim(RateRndDecPts) +
000712210226                                 AMP + 'observationPeriodShift=' +
000713210305                                    %trim(obserPrdShift) +
000714210305                                 AMP + 'lockoutDays=' +
000715210305                                    %trim(lockOutDays) +
000716210304                                 AMP + 'showDailyDetails=' +
000717210305                                    %trim(showDailyDeta) +
000718210304                                 AMP + 'calculateTillDate=' +
000719210305                                    %trim(callTillDate) +
000720210304                                 AMP + 'riskFreeRateFloor=' +
000721210305                                    %trim(riskFreeRatFl);
000722210305
000723210224       endsr;
000724210224
000725210224       //*************************************************************
000726210224       /EJECT
000727210224       //*************************************************************
000728210224       //                                                            *
000729210224       // consumeRESTAPI - Consume REST API                          *
000730210224       // ==============                                             *
000731210224       //                                                            *
000732210224       // Called by: processTransaction                              *
000733210224       //                                                            *
000734210306       // Calls: LIBHTTP123 http_string                              *
000735210224       //                                                            *
000736210224       //*************************************************************
000737210224
000738210224       begsr consumeRestAPI;
000739210224
000740210304              monitor;
000741210310
000742210304                 clear jsonData;
000743210305                 jsonData = http_string( 'GET' : %trim(RestAPIParm));
000744210304                 msg = *blanks;
000745210304                 err = 0;
000746210310
000747210304              on-error;
000748210310
000749210305                 msg = http_error(err);
000750210311                 errorMessage = %trim(msg) + ' ' + %trim(RestAPIParm);
000751210305                 exsr errorHandler;
000752210310
000753210304              endmon;
000754210224
000755210224       endsr;
000756210224
000757210224       //*************************************************************
000758210224       /EJECT
000759210224       //*************************************************************
000760210224       //                                                            *
000761210224       // parseJSONData - Parse JSON Data                            *
000762210224       // =============                                              *
000763210224       //                                                            *
000764210224       // Called by: processTransaction                              *
000765210224       //                                                            *
000766210224       // Calls: None                                                *
000767210224       //                                                            *
000768210224       //*************************************************************
000769210224
000770210224       begsr parseJSONData;
000771210304
000772210306                   // Load JSON data variable into a tree like structure
000773210306
000774210304                   docNode = yajl_buf_load_tree( %addr(jsonData:*data)
000775210304                             : %len(jsonData)
000776210304                             : ErrMsg );
000777210304
000778210304                   if errMsg <> '';
000779210305                      errorMessage = errMsg;
000780210305                      exsr errorHandler;
000781210304                   endif;
000782210304
000783210304                   node = YAJL_object_find(docNode: 'comment');
000784210304                   result.comment = YAJL_get_string(node);
000785210226
000786210304                   node = YAJL_object_find(docNode: 'errmsg');
000787210304                   result.errmsg = YAJL_get_string(node);
000788210226
000789210304                   list = YAJL_object_find(docNode: 'dailyRateSummary');
000790210306
000791210305                   clear result.list;
000792210306
000793210304                   i = 0;
000794210304                   dow YAJL_ARRAY_LOOP( list: i: node );
000795210226
000796210226                       lastElem = i;
000797210226
000798210303                       // All calculation methods
000799210226                       val = YAJL_object_find(node: 'interestPeriodDate');
000800210226                       result.list(i).intPrdDate = yajl_get_string(val);
000801210301
000802210301                       ISODate =  result.list(i).intPrdDate;
000803210303
000804210310                       monitor;
000805210310                           WKY = %editc(wkYear:'X');
000806210310                           WKM = %editc(wkMonth:'X');
000807210310                           WKD = %editc(wkDay:'X');
000808210303
000809210310                           result.list(i).intPrdYMD  = YYMMDD;
000810210301
000811210310                           if BJDFIN = 'D';
000812210310                              DD1D = wkDay;
000813210310                              DD1M = wkMonth;
000814210310                              DD1Y = wkYear;
000815210310                              DateIn = DateIn_D;
000816210310                           else;
000817210310                              DD2D = wkDay;
000818210310                              DD2M = wkMonth;
000819210310                              DD2Y = wkYear;
000820210310                              DateIn = DateIn_M;
000822210310                           endif;
000823210310
000824210310                           pOption = '*FIRST';
000825210310                           pReturnCode = *Blanks;
000826210310                           callp CONVERT_DATE(
000827210310                                      ErrorFlag
000828210310                                    : DateIN
000829210310                                    : BJDFIN
000830210310                                    : DateOUT
000831210310                                   );
000832210301
000833210310                           if ErrorFlag   <> *blanks;
000834210310                               Dbase    = 005;
000835210310                               DbFile   = *Blanks;
000836210310                               DbKey    = *BLANKS;
000837210310                               DbPgm    = 'ZAGETCALRT';
000838210310                               Exsr *Pssr;
000839210310                           endif;
000840210301
000841210310                           result.list(i).intPDMidas = DateOUT;
000842210310                       on-error;
000843210310                       endmon;
000844210310
000845210303                       // All calculation methods
000846210226                       val = YAJL_object_find(node: 'interestPeriodDays');
000847210305                       cStr      =  yajl_get_string(val);
000848210305                       result.list(i).intPrdDays =  %dec(%trim(cStr):2:0);
000849210226
000850210310                       val =
000851210310                          YAJL_object_find(node: 'observationPeriodDate');
000852210310                       result.list(i).obsPrdDate =
000853210310                          yajl_get_string(val);
000854210303
000855210310                       ISODate =  result.list(i).obsPrdDate;
000856210310
000857210310                       monitor;
000858210303                            WKY = %editc(wkYear:'X');
000859210303                            WKM = %editc(wkMonth:'X');
000860210303                            WKD = %editc(wkDay:'X');
000861210303
000862210303                            result.list(i).intObsYMD  = YYMMDD;
000863210303
000864210303                            if BJDFIN = 'D';
000865210303                                 DD1D = wkDay;
000866210303                                 DD1M = wkMonth;
000867210303                                 DD1Y = wkYear;
000868210303                                 DateIn = DateIn_D;
000869210303                            else;
000870210303                                 DD2D = wkDay;
000871210303                                 DD2M = wkMonth;
000872210303                                 DD2Y = wkYear;
000873210303                                 DateIn = DateIn_M;
000874210303                             endif;
000875210303
000876210303                             pOption = '*FIRST';
000877210303                             pReturnCode = *Blanks;
000878210303                             callp CONVERT_DATE(
000879210303                                  ErrorFlag
000880210303                                : DateIN
000881210303                                : BJDFIN
000882210303                                : DateOUT
000883210303                               );
000884210303
000885210303                             if ErrorFlag   <> *blanks;
000886210310                                  Dbase    = 006;
000887210303                                  DbFile   = *Blanks;
000888210303                                  DbKey    = *BLANKS;
000889210303                                  DbPgm    = 'ZAGETCALRT';
000890210303                                 Exsr *Pssr;
000891210303                             endif;
000892210303
000893210303                             result.list(i).intOPMidas = DateOUT;
000894210310                       on-error;
000895210310                       endmon;
000896210310
000897210310                       val =
000898210310                           YAJL_object_find(node: 'observationPeriodDays');
000899210310
000900210310                       monitor;
000901210310                           cStr      =  yajl_get_string(val);
000902210310                              result.list(i).obsPrdDays =
000903210310                              %dec(%trim(cStr):2:0);
000904210310                       on-error;
000905210310                       endmon;
000906210303
000907210303                       // All calculation methods
000908210303                       val = YAJL_object_find(node: 'publishedRiskFreeRate');
000909210305
000910210305                       cStr  =  yajl_get_string(val);
000911210305                       result.list(i).pubRskFrRt =  %dec(%trim(cStr):30:9  );
000912210303
000913210303                       // All calculation methods
000914210303                       val = YAJL_object_find(node: 'rateApplied');
000915210305                       cStr  =  yajl_get_string(val);
000916210305                       result.list(i).rateApplied =  %dec(%trim(cStr):30:9  );
000917210226
000918210303                       // All calculation methods
000919210226                       val = YAJL_object_find(node: 'riskFreeRateFloorApplied');
000920210226                       if YAJL_is_true(node);
000921210226                           result.list(i).rskFrRtFlAp=  'True';
000922210226                       else;
000923210226                           result.list(i).rskFrRtFlAp=  'False';
000924210226                       endif;
000925210226
000926210310                       if calcMethod = 'NCCR';
000927210310                            val = YAJL_object_find(node: 'compoundingFactor');
000928210310                            result.list(i).compFactor=  yajl_get_string(val);
000929210226
000930210310                            val =
000931210310                              YAJL_object_find(node: 'dailyCompoundedRate');
000932210310                            result.list(i).dlyCompRate =
000933210310                              yajl_get_string(val);
000934210310                       endif;
000935210303
000936210310                       if calcMethod = 'CCR';
000937210310                            val =
000938210310                              YAJL_object_find(node: 'averageCompoundedRate');
000939210310                            result.list(i).aveCompRate =  yajl_get_string(val);
000940210303
000941210310                       endif;
000942210303
000943210310                       if calcMethod = 'SAVG';
000944210310                            val =
000945210310                              YAJL_object_find(node: 'simpleAverageRate');
000946210310                            result.list(i).simpleAve =  yajl_get_string(val);
000947210303
000948210310                       endif;
000949210303
000950210304                   enddo;
000951210226
000952210304                   // free up memory used by YAJL
000953210304                   yajl_tree_free(docNode);
000954210224
000955210224       endsr;
000956210224
000957210224       //*************************************************************
000958210224       /EJECT
000959210224       //*************************************************************
000960210224       //                                                            *
000961210301       // outputFile - Output Files                                  *
000962210301       // ==========                                                 *
000963210224       //                                                            *
000964210224       // Called by: processTransaction                              *
000965210224       //                                                            *
000966210224       // Calls: None                                                *
000967210224       //                                                            *
000968210224       //*************************************************************
000969210224
000970210301       begsr outputFiles;
000971210305
000972210226                   i = 1;
000973210306
000974210226                   dow i <= lastElem;
000975210306
000976210306                       // Output information to SDARRLOGTD
000977210303                       exsr writeToARRDailyHistory;
000978210306
000979210306                       //Output information to LELIBEPD
000980210301                       exsr writeToExtractFile;
000981210306
000982210301                       i = i + 1;
000983210306
000984210226                   enddo;
000985210224
000986210224       endsr;
000987210303       //*************************************************************
000988210303       /EJECT
000989210303       //*************************************************************
000990210303       //                                                            *
000991210303       // writeToARRDailyHistory - Write to ARR Daily Rates History  *
000992210303       // ======================                                     *
000993210303       //                                                            *
000994210303       // Called by: Output File                                     *
000995210303       //                                                            *
000996210303       // Calls: None                                                *
000997210303       //                                                            *
000998210303       //*************************************************************
000999210303
001000210303       begsr writeToARRDailyHistory;
001001210303
001002210305                   includeRecord = 'N';
001003210305
001004210305                   if (calcMethod = 'NCCR' or calcMethod  = 'SARR')
001005210305                   and  result.list(i).intPDMidas > transactDate;
001006210305                        includeRecord = 'Y';
001007210306
001008210305                   elseif  (calcMethod = 'CCR' or calcMethod  = 'SAVG');
001009210305                        includeRecord = 'Y';
001010210306
001011210305                   endif;
001012210305
001013210305                   fileToCheck = SDHSDRTD;
001014210305                   if includeRecord = 'Y';
001015210305                      exsr checkExist;
001016210305                      if action = INSERT;
001017210305                          exsr insertHistoryFile;
001018210305                      elseif action = UPDATE;
001019210305                          exsr updateHistoryFile;
001020210305                      endif;
001021210305                   endif;
001022210303
001023210303       endsr;
001024210303       //*************************************************************
001025210303       /EJECT
001026210303       //*************************************************************
001027210303       //                                                            *
001028210306       // checkExist - Check if a record exist on a given file       *
001029210303       // ==========                                                 *
001030210303       //                                                            *
001031210303       // Called by: Output File                                     *
001032210303       //                                                            *
001033210303       // Calls: None                                                *
001034210303       //                                                            *
001035210303       //*************************************************************
001036210303
001037210303       begsr checkExist;
001038210303
001039210303                   if fileToCheck = SDHSDRTD;
001040210303                        wSQLStr = 'select * from SDHSDRTD ' +
001041210303                                  'where CMODID = '  + QUO + moduleID + QUO +
001042210303                                  ' and CTRNID = ' + QUO + transactREF + QUO +
001043210303                                  ' and CMINPD = ' +
001044210303                                    %char(result.list(i).intPDMidas);
001045210303                   elseif fileToCheck = LELIBEPD;
001046210303                        wSQLStr = 'select * from LELIBEPD ' +
001047210303                                  'where LDLNRF = ' + QUO + transactREF + QUO +
001048210303                                  ' and LDVDAT = ' +
001049210303                                    %char(result.list(i).intPDMidas);
001050210303                   endif;
001051210303
001052210303                   exec sql prepare P1 from :wSQLStr;
001053210303                   exec sql open P1;
001054210303
001055210303                   if fileToCheck = SDHSDRTD;
001056210303                        exec sql fetch next From P1 into :DailyHistDS;
001057210303                   elseif fileToCheck = LELIBEPD;
001058210303                        exec sql fetch next From P1 into :ExtractFLDS;
001059210303                   endif;
001060210303
001061210303                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001062210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001063210305                      exsr errorHandler;
001064210303                   endif;
001065210303
001066210303                   if sqlCod = NO_RECORD;
001067210303                      action = INSERT;
001068210303                   else;
001069210303                      action = UPDATE;
001070210303                   endif;
001071210303                   exec sql close P1;
001072210303
001073210303       endsr;
001074210303       //*************************************************************
001075210303       /EJECT
001076210303       //*************************************************************
001077210303       //                                                            *
001078210303       // insertHistoryFile                                          *
001079210303       // =================                                          *
001080210303       //                                                            *
001081210303       // Called by: writeToARRDailyHistory                           *
001082210303       //                                                            *
001083210303       // Calls: None                                                *
001084210303       //                                                            *
001085210303       //*************************************************************
001086210303
001087210303       begsr insertHistoryFile;
001088210303
001089210303                   clear DailyHistDS;
001090210303                   DailyHistDS.CMODID = moduleID;
001091210303                   DailyHistDS.CTRNID = transactREF;
001092210304                   DailyHistDS.CCALCM = calcMethod;
001093210303                   DailyHistDS.CMINPD = result.list(i).intPDMidas;
001094210303                   DailyHistDS.CINPDT = result.list(i).intPrdYMD;
001095210303                   DailyHistDS.CINPDY = result.list(i).intPrdDays;
001096210303                   DailyHistDS.CMOBPD = result.list(i).intOPMidas;
001097210303                   DailyHistDS.COBPDT = result.list(i).intObsYMD;
001098210303                   DailyHistDS.CPBRFR = result.list(i).pubRskFrRt;
001099210305                   DailyHistDS.COBPDY = result.list(i).obsPrdDays;
001100210303                   DailyHistDS.CRTEAP = result.list(i).rateApplied;
001101210305                   if result.list(i).rskFrRtFlAp = 'true';
001102210305                     DailyHistDS.CRFRAP = 'Y';
001103210305                   else;
001104210305                     DailyHistDS.CRFRAP = 'N';
001105210305                   endif;
001106210303                   DailyHistDS.CTIMST = %timestamp();
001107210304
001108210303                   select;
001109210303                        when calcMethod = 'NCCR';
001110210304                             DailyHistDS.CDCMRT =
001111210303                               %Dec(Result.List(i).dlyCompRate:30:9);
001112210304                             DailyHistDS.CCMFAC =
001113210304                               %Dec(Result.List(i).compFactor:30:9);
001114210303                        when calcMethod = 'CCR';
001115210303                             DailyHistDS.CAVCRT =
001116210303                               %Dec(Result.List(i).aveCompRate:30:9);
001117210304                        when calcMethod = 'SAVG';
001118210304                             DailyHistDS.CSMPAV =
001119210304                               %Dec(Result.List(i).simpleAve:30:9);
001120210303                   endsl;
001121210303
001122210303                   exec sql insert into SDHSDRTD
001123210303                   values (:DailyHistDS);
001124210303
001125210304                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001126210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001127210305                      exsr errorHandler;
001128210303                   endif;
001129210303
001130210303       endsr;
001131210310
001132210303       //*************************************************************
001133210303       /EJECT
001134210303       //*************************************************************
001135210303       //                                                            *
001136210303       // insertExtractFile                                          *
001137210303       // =================                                          *
001138210303       //                                                            *
001139210303       // Called by: writeToHistoryFile                               *
001140210303       //                                                            *
001141210303       // Calls: None                                                *
001142210303       //                                                            *
001143210303       //*************************************************************
001144210303
001145210303       begsr insertExtractFile;
001146210303
001147210303                   clear ExtractFLDS;
001148210310                   clear compAveRate;
001149210303                   ExtractFLDS.LDLNRF = transactREF;
001150210303                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
001151210303
001152210303                   select;
001153210303                        when calcMethod = 'NCCR';
001154210310                             compAveRate =
001155210303                               %Dec(Result.List(i).dlyCompRate:30:9);
001156210303                        when calcMethod = 'CCR';
001157210310                             compAveRate =
001158210303                               %Dec(Result.List(i).aveCompRate:30:9);
001159210310                        when calcMethod = 'SARR';
001160210310                             compAveRate =
001161210310                               %Dec(Result.List(i).rateApplied:30:9);
001162210310                        when calcMethod = 'SAVG';
001163210310                             compAveRate =
001164210310                               %Dec(Result.List(i).simpleAve:30:9);
001165210303                   endsl;
001166210303
001167210310                   compAveRate += %dech(benchMarkAdj:13:9);
001168210310                   ExtractFLDS.LDCART =
001169210310                     %dech(compAveRate  :13 :8);
001170210310
001171210303                   exec sql insert into LELIBEPD
001172210303                   values (:ExtractFLDS);
001173210303
001174210304                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001175210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001176210305                      exsr errorHandler;
001177210303                   endif;
001178210303
001179210303       endsr;
001180210303       //*************************************************************
001181210303       /EJECT
001182210303       //*************************************************************
001183210303       //                                                            *
001184210303       // updateExtractFile                                          *
001185210303       // =================                                          *
001186210303       //                                                            *
001187210303       // Called by: writeToExtractFile                               *
001188210303       //                                                            *
001189210303       // Calls: None                                                *
001190210303       //                                                            *
001191210303       //*************************************************************
001192210303
001193210303       begsr updateExtractFile;
001194210304
001195210303                   clear ExtractFLDS;
001196210310                   clear compAveRate;
001197210303                   ExtractFLDS.LDLNRF = transactREF;
001198210303                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
001199210303
001200210310                   select;
001201210310                        when calcMethod = 'NCCR';
001202210310                             compAveRate =
001203210310                               %Dec(Result.List(i).dlyCompRate:30:9);
001204210310                        when calcMethod = 'CCR';
001205210310                             compAveRate =
001206210310                               %Dec(Result.List(i).aveCompRate:30:9);
001207210310                        when calcMethod = 'SARR';
001208210310                             compAveRate =
001209210310                               %Dec(Result.List(i).rateApplied:30:9);
001210210310                        when calcMethod = 'SAVG';
001211210310                             compAveRate =
001212210310                               %Dec(Result.List(i).simpleAve:30:9);
001213210310                   endsl;
001214210310
001215210310                   compAveRate += %dech(benchMarkAdj:13:9);
001216210310                   ExtractFLDS.LDCART =
001217210310                     %dech(compAveRate  :13 :8);
001228210303
001229210303                   wSqlStr = 'update LELIBEPD A '  +
001230210303                              'SET A.LDCART = ' + %Char(ExtractFLDS.LDCART) +
001231210303                              ' where A.LDLNRF = ' + QUO + ExtractFLDS.LDLNRF
001232210303                                 + QUO +
001233210303                              ' and   A.LDVDAT = ' +  %Char(ExtractFLDS.LDVDAT);
001234210303
001235210303                   exec sql
001236210303                   execute immediate :wSqlStr;
001237210303
001238210303                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001239210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001240210305                      exsr errorHandler;
001241210303                   endif;
001242210303
001243210303       endsr;
001244210303
001245210301       //*************************************************************
001246210301       /EJECT
001247210301       //*************************************************************
001248210301       //                                                            *
001249210301       // writeToExtractFile - Write to Extract File                 *
001250210301       // ==================                                         *
001251210301       //                                                            *
001252210301       // Called by: Output File                                     *
001253210301       //                                                            *
001254210301       // Calls: None                                                *
001255210301       //                                                            *
001256210301       //*************************************************************
001257210301
001258210301
001259210301       begsr writeToExtractFile;
001260210304
001261210303                   fileToCheck = LELIBEPD;
001262210303                   exsr checkExist;
001263210304
001264210303                   if action = INSERT;
001265210303                        exsr insertExtractFile;
001266210306
001267210303                   elseif action = UPDATE;
001268210303                        exsr updateExtractFile;
001269210306
001270210303                   endif;
001271210301
001272210304
001273210301       endsr;
001274210303       //*************************************************************
001275210303       /EJECT
001276210303       //*************************************************************
001277210303       //                                                            *
001278210303       // writeToAuditLog - Write to Audit Log                       *
001279210303       // ===============                                            *
001280210303       //                                                            *
001281210303       // Called by: Output File                                     *
001282210303       //                                                            *
001283210303       // Calls: None                                                *
001284210303       //                                                            *
001285210303       //*************************************************************
001286210303
001287210303
001288210303       begsr writeToAuditLog;
001289210303
001290210305                   AuditLogds.SJTMST = %timestamp();
001291210305                   logData = %Trim(jsonData);
001292210305                   exec sql insert into SDARRLOGTD
001293210305                   values (
001294210305                            : AuditLogds.SJMODI,
001295210305                            : AuditLogds.SJTREF,
001296210305                            : AuditLogds.SJSTAT,
001297210305                            : AuditLogds.SJTMST,
001298210305                            : logData
001299210305                          );
001300210305
001301210305                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001302210310                        dBase    = 007;
001303210305                        dBfile   = 'SDARRLOGTD';
001304210305                        dBKey    = *BLANKS;
001305210305                        dBPgm    = 'ZAGETCALRT';
001306210305                        exsr *pssr;
001307210305                   endif;
001308210303
001309210303       endsr;
001310210224
001390210305       //*************************************************************
001391210305       /EJECT
001392210305       //*************************************************************
001393210305       //                                                            *
001394210305       //   errorHandler - Generic Error Handler                     *
001395210305       //                                                            *
001396210305       //   Called By: Various subroutines                           *
001397210305       //                                                            *
001398210305       //*************************************************************
001399210305
001400210305       begsr errorHandler;
001401210306
001402210305                 AuditLogds.SJSTAT = 'F';
001403210305                 jsonData = errorMessage;
001404210306
001405210305       endsr;
001406210310
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
001839210310                   DailyHistDS.CMODID = moduleID;
001840210310                   DailyHistDS.CTRNID = transactREF;
001841210310                   DailyHistDS.CCALCM = calcMethod;
001842210310                   DailyHistDS.CMINPD = result.list(i).intPDMidas;
001843210310                   DailyHistDS.CINPDT = result.list(i).intPrdYMD;
001844210310                   DailyHistDS.CINPDY = result.list(i).intPrdDays;
001845210310                   DailyHistDS.CMOBPD = result.list(i).intOPMidas;
001846210310                   DailyHistDS.COBPDT = result.list(i).intObsYMD;
001847210310                   DailyHistDS.CPBRFR = result.list(i).pubRskFrRt;
001848210310                   DailyHistDS.COBPDY = result.list(i).obsPrdDays;
001849210310                   DailyHistDS.CRTEAP = result.list(i).rateApplied;
001850210310                   if result.list(i).rskFrRtFlAp = 'true';
001851210310                     DailyHistDS.CRFRAP = 'Y';
001852210310                   else;
001853210310                     DailyHistDS.CRFRAP = 'N';
001854210310                   endif;
001855210310                   DailyHistDS.CTIMST = %timestamp();
001856210310
001857210310                   select;
001858210310                        when calcMethod = 'NCCR';
001859210310                             DailyHistDS.CDCMRT =
001860210310                               %Dec(Result.List(i).dlyCompRate:30:9);
001861210310                             DailyHistDS.CCMFAC =
001862210310                               %Dec(Result.List(i).compFactor:30:9);
001863210310                        when calcMethod = 'CCR';
001864210310                             DailyHistDS.CAVCRT =
001865210310                               %Dec(Result.List(i).aveCompRate:30:9);
001866210310                        when calcMethod = 'SAVG';
001867210310                             DailyHistDS.CSMPAV =
001868210310                               %Dec(Result.List(i).simpleAve:30:9);
001869210310                   endsl;
001890210310
001891210310                   wSqlStr = 'update SDHSDRTD A '  +
001892210310                              'SET A.CMINPD = ' + %Char(DailyHistDS.CMINPD) +
001893210310                              ' , ' +
001894210310                              'A.CCALCM = ' + QUO + %trim(DailyHistDS.CCALCM)
001895210310                                + QUO + ' , ' +
001896210310                              'A.CINPDT = ' + QUO + %trim(DailyHistDS.CINPDT) +
001897210310                               QUO + ' , ' +
001898210310                              'A.CINPDY = ' + %Char(DailyHistDS.CINPDY) +
001899210310                              ' , ' +
001900210310                              'A.CMOBPD = ' + %Char(DailyHistDS.CMOBPD) +
001901210310                              ' , ' +
001902210310                              'A.COBPDT = ' + QUO + %trim(DailyHistDS.COBPDT) +
001903210310                              QUO + ' , ' +
001904210310                              'A.COBPDY = ' + %Char(DailyHistDS.COBPDY) +
001905210310                              ' , ' +
001906210310                              'A.CPBRFR = ' + %Char(DailyHistDS.CPBRFR) +
001907210310                              ' , ' +
001908210310                              'A.CRTEAP = ' + %Char(DailyHistDS.CRTEAP) +
001909210310                              ' , ' +
001910210310                              'A.CRFRAP = ' + QUO + %trim(DailyHistDS.CRFRAP) +
001911210310                              QUO + ' , ' +
001912210310                              'A.CAVCRT = ' + %Char(DailyHistDS.CAVCRT) +
001913210310                              ' , ' +
001914210310                              'A.CCMFAC = ' + %Char(DailyHistDS.CCMFAC) +
001915210310                              ' , ' +
001916210310                              'A.CDCMRT = ' + %Char(DailyHistDS.CDCMRT) +
001917210310                              ' , ' +
001918210310                              'A.CSMPAV = ' + %Char(DailyHistDS.CSMPAV) +
001919210310                              ' , ' +
001920210310                              'A.CTIMST = ' + QUO + %Char(DailyHistDS.CTIMST) +
001921210310                              QUO +
001922210310                              ' where A.CMODID = ' +
001923210310                                QUO + %trim(moduleID) + QUO +
001924210310                              ' and   A.CTRNID = ' +
001925210310                                QUO + %trim(transactREF) + QUO;
001926210310
001927210310                   exec sql
001928210310                   execute immediate :wSqlStr;
001929210310
001930210310                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001931210310                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001932210310                      exsr errorHandler;
001933210310                   endif;
001934210305
001935210305                  exec sql  update SDHSDRTD
001936210305                  set CMINPD = DailyHistDS.CMINPD
001937210305                  where CMODID = moduleID
001938210305                  and   CTRNID = transactREF;
001939210305
001940210306                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001941210310                        dBase    = 008;
001942210305                        dBfile   = 'SDHSDRTD';
001943210305                        dBKey    = *BLANKS;
001944210305                        dBPgm    = 'ZAGETCALRT';
001945210305                        exsr *pssr;
001946210305                   endif;
001947210305       endsr;
001948210310
001949210310       //*************************************************************
001950210310       /EJECT
001951210310       //*************************************************************
001952210310       //                                                            *
001953210310       //   *pssr  - Program Error Processing Subroutine.            *
001954210310       //                                                            *
001955210310       //   Called By: Main Processing, various subroutines          *
001956210310       //                                                            *
001957210310       //*************************************************************
001958210310
001959210310       begsr *pssr;
001960210310                   *inu7 = *on;
001961210310                   *inu8 = *on;
001962210310                   *Inlr = *on;
001963210310                   dump;
001964210310                   return;
001965210310       endsr;
002102210305
002103210305       //*************************************************************
002104210222
002105210222      /end-free
002106210222
002107210222     C/COPY ZSRSRC,ZACCHLE
002108210222     C/COPY ZSRSRC,ZBKDT_ILE
002109210222     C/COPY ZSRSRC,ZFWDT_ILE
002110210309** CPY@   **      OBJECT COPYRIGHT
002111210309(c) Finastra International Limited 2001
002112210309** arrCalLoc
002113210310/corporate/lending/alternative-reference-rates/v1/daily-compounding/rates
002114210310/corporate/lending/alternative-reference-rates/v1/compounded-in-arrears/average-rate
002115210310/corporate/lending/alternative-reference-rates/v1/simple-arr/rates
002116210310/corporate/lending/alternative-reference-rates/v1/simple-average/rates
