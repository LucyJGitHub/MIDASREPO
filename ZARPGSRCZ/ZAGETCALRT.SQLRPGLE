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
000454210311     D   reqParms                          likeds(request_t)
000455210311      ** Request Parameters
000456210226     D   list                              likeds(summary_t) dim(999)
000457210226      ** Daily Rate Summary
000458210311     D   errors                            likeds(exception_t)
000459210311      ** Exception Parameters
000460210311
000461210311     D exception_t     ds                  qualified
000462210311     D                                     template
000463210311     D   title                       50a
000464210311      ** Title
000465210311     D   exceptionMsg               100a
000466210311      ** Exception Message
000467210311     D   status                       4a
000468210311      ** Status
000475210301
000476210301     D SDBANK        e ds                  extname(SDBANKPD)
000477210301     D                 DS
000478210301     D ISODate                 1     10
000479210301     D WkYear                  3      4  0
000480210301     D WkMonth                 6      7  0
000481210301     D WkDay                   9     10  0
000482210303
000483210303     D                 DS
000484210303     D YYMMDD                  1      6
000485210303     D WkY                     1      2
000486210303     D WkM                     3      4
000487210303     D WkD                     5      6
000488210301
000489210301     D                 DS
000490210301     D DateIN_D                1      6  0
000491210301     D DD1D                    1      2  0
000492210301     D DD1M                    3      4  0
000493210301     D DD1Y                    5      6  0
000494210301     D                 DS
000495210301     D DateIN_M                1      6  0
000496210301     D DD2M                    1      2  0
000497210301     D DD2D                    3      4  0
000498210301     D DD2Y                    5      6  0
000499210226
000500210311     D reqParms        s                   like(yajl_val)
000501210311     D errors          s                   like(yajl_val)
000502210226     D docNode         s                   like(yajl_val)
000503210226     D list            s                   like(yajl_val)
000504210226     D node            s                   like(yajl_val)
000505210226     D val             s                   like(yajl_val)
000506210305     D cStr            S             10a   Varying
000507210226
000508210222      ** +--------------------------------------+
000509210222      ** ¦ Array declaration                    ¦
000510210222      ** ¦ ==================                   ¦
000511210222      ** +--------------------------------------+
000512210309
000513210309     D arrCalLoc       s            100a   dim(4) ctdata perrcd(1)
000514210222
000515210222      /free
000516210222
000517210222       // ** +--- Start of Main processing -----------------------------------+
000518210222       // ** ¦                                                                ¦
000519210222       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
000520210222       // ** ¦ executed at program activation.                                ¦
000521210222       // ** ¦                                                                ¦
000522210222       // ** +----------------------------------------------------------------+
000523210304
000524210224                   exsr processTransaction;
000525210222
000526210222                   *Inlr = *On;
000527210222                   return;
000528210310
000529210310       //*************************************************************
000530210310       /EJECT
000531210310       //*************************************************************
000532210310       //                                                            *
000533210310       // inzsr - Program Initialisation routine                     *
000534210310       //                                                            *
000535210310       // Called by: Main processing                                 *
000536210310       //                                                            *
000537210310       //  Calls: None                                               *
000538210310       //                                                            *
000539210310       //*************************************************************
000540210310
000541210310       begsr *inzsr;
000542210310
000543210310                   //Initialise audit log DS
000544210310                   clear AuditLogDS;
000545210310
000546210310                   AuditLogds.SJMODI = moduleID;
000547210310                   AuditLogds.SJTREF = transactREF;
000548210310                   AuditLogds.SJSTAT = 'C';
000549210310
000550210310                   pOption = '*FIRST';
000551210310                   pReturnCode = *Blanks;
000552210310
000553210310                   callp ACCESS_SDBANK(
000554210310                                  pReturnCode
000555210310                                : pOption
000556210310                                : dsfdy
000557210310                               );
000558210310                   SDBANK = dsfdy;
000559210310
000560210310                   if pReturnCode <> *blanks;
000561210310                      Dbase    = 001;
000562210310                      DbFile   = 'SDBANKPD';
000563210310                      DbKey    = *BLANKS;
000564210310                      DbPgm    = 'ZAGETCALRT';
000565210310                      Exsr *Pssr;
000566210310                   endif;
000567210310
000568210310                   pOP01 = 'ARRAdapterURL';
000569210310
000570210310                   CallP ACCESS_SVAL(
000571210310                                       pRetCode
000572210310                                     : pOP01
000573210310                                     : pVL01
000574210310                                     : pOP02
000575210310                                     : pVL02
000576210310                                     : pOP03
000577210310                                     : pVL03
000578210310                                     : pOP04
000579210310                                     : pVL04
000580210310                                     : pOP05
000581210310                                     : pVL05
000582210310                                     : pOP06
000583210310                                     : pVL06
000584210310                                     : pOP07
000585210310                                     : pVL07
000586210310                                     : pOP08
000587210310                                     : pVL08
000588210310                                     : pOP09
000589210310                                     : pVL09
000590210310                                     : pOP10
000591210310                                     : pVL10
000592210310                                       );
000593210310
000594210310                   If pRetCode <> *Blanks;
000595210310                      DbFile = 'SDSVALPD';
000596210310                      Dbase  = 002;
000597210310                      DbKey  = pOP01;
000598210310                      DbPgm  = 'ZAGETCALRT';
000599210310                      Exsr *Pssr;
000600210310                   Endif;
000601210310
000602210310                   If pVL01 <> *Blanks;
000603210310                         CalcMetURL     = HTTP_HEAD  + %trim(pVL01);
000604210310                   Else;
000605210310                      DbFile = 'SDSVALPD';
000606210310                      Dbase  = 003;
000607210310                      DbKey  = pOP01;
000608210310                      DbPgm  = 'ZAGETCALRT';
000609210310                      Exsr *Pssr;
000610210310                   Endif;
000611210310
000612210310                   select;
000613210310
000614210310                       when calcMethod = 'NCCR';
000615210310                            calcMetURL =  %trim(calcMetURL) +
000616210310                              %trim(arrCalLoc(1));
000617210310
000618210310                       when calcMethod = 'CCR';
000619210310                            calcMetURL =  %trim(calcMetURL) +
000620210310                              %trim(arrCalLoc(2));
000621210310
000622210310                       when calcMethod = 'SARR';
000623210310                            calcMetURL =  %trim(calcMetURL) +
000624210310                              %trim(arrCalLoc(3));
000625210310
000626210310                       when calcMethod = 'SAVG';
000627210310                            calcMetURL =  %trim(calcMetURL) +
000628210310                              %trim(arrCalLoc(4));
000629210310
000630210310                   endsl;
000631210310
000632210310                   // Get the highest date in the Daily History file
000633210310                   wSQLStr = 'select * from SDHSDRTD ' +
000634210310                             ' where CMODID = ' + QUO + moduleID + QUO +
000635210310                             ' and CTRNID = ' +  QUO + transactREF + QUO +
000636210310                             'order by CMINPD DESC';
000637210310
000638210310                   exec sql prepare P1 from :wSQLStr;
000639210310                   exec sql declare P1 cursor for P1;
000640210310                   exec sql open P1;
000641210310                   exec sql fetch next From P1 into :DailyHistDS;
000642210310
000643210310                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
000644210310                      dBkey = *Blanks;
000645210310                      dBfile = 'SDHSDRTD';
000646210310                      dBase = 004;
000647210310                      dBpgm  = 'ZAGETCALRT';
000648210310                      exsr *pssr;
000649210310                   endif;
000650210310
000651210310                   if sqlCod = NO_RECORD;
000652210310                      transactDate = 0;
000653210310                   else;
000654210310                      transactDate = DailyHistDS.CMINPD;
000655210310                   endif;
000656210310
000657210310                   exec sql close P1;
000658210310       endsr;
000659210222
000660210222       //*************************************************************
000661210222       /EJECT
000662210222       //*************************************************************
000663210222       //                                                            *
000664210224       // processTransaction - Process a Loan Transaction            *
000665210224       // ==================                                         *
000666210222       //                                                            *
000667210222       // Called by: Main Processing                                 *
000668210222       //                                                            *
000669210222       // Calls: None                                                *
000670210222       //                                                            *
000671210222       //*************************************************************
000672210222
000673210224       begsr processTransaction;
000674210305
000675210306                   //** This will build the URL parameter for the Rest API Call
000676210305
000677210304                   exsr buildParameter;
000678210224
000679210306                   //** This will call the http_string function from LIBHTTP123
000680210305                   //** to consume the Rest API
000681210305
000682210304                   exsr consumeRESTAPI;
000683210305
000684210305                   if msg = *blanks;
000685210305
000686210305                      //** This will parse the JSON data returned from ARR Calculator
000687210306                      //** and store it to an array of Data Structure
000688210305
000689210305                      exsr parseJSONData;
000690210305
000691210305                      //** This will handle the output of the array DS to the
000692210305                      //** history and extract files
000693210306
000694210305                      exsr outputFiles;
000695210305
000696210305                   endif;
000697210224
000698210305                   //** log details to audit file
000699210305                   exsr writeToAuditLog;
000700210224
000701210222       endsr;
000702210222
000703210224       //*************************************************************
000704210224       /EJECT
000705210224       //*************************************************************
000706210224       //                                                            *
000707210224       // buildParameter - Build REST API Parameter                  *
000708210224       // ==============                                             *
000709210224       //                                                            *
000710210224       // Called by: processTransaction                              *
000711210224       //                                                            *
000712210224       // Calls: None                                                *
000713210224       //                                                            *
000714210224       //*************************************************************
000715210224
000716210224       begsr buildParameter;
000717210304
000718210305                   RestAPIParm = %trim(CalcMetURL) +
000719210305                                 QUE + 'interestPeriodStartDate=' +
000720210305                                       %trim(intPrdStartDt) +
000721210304                                 AMP + 'interestPeriodEndDate=' +
000722210305                                    %trim(intPrdEndDt) +
000723210305                                 AMP + 'riskFreeRate=' +
000724210305                                    %trim(riskFreeRate) +
000725210305                                 AMP + 'lookBackDays=' +
000726210305                                    %trim(lookBackDays)  +
000727210226                                 AMP + 'rateRoundingDecimalPoints=' +
000728210305                                    %trim(RateRndDecPts) +
000729210226                                 AMP + 'observationPeriodShift=' +
000730210305                                    %trim(obserPrdShift) +
000731210305                                 AMP + 'lockoutDays=' +
000732210305                                    %trim(lockOutDays) +
000733210304                                 AMP + 'showDailyDetails=' +
000734210305                                    %trim(showDailyDeta) +
000735210304                                 AMP + 'calculateTillDate=' +
000736210305                                    %trim(callTillDate) +
000737210304                                 AMP + 'riskFreeRateFloor=' +
000738210305                                    %trim(riskFreeRatFl);
000739210305
000740210224       endsr;
000741210224
000742210224       //*************************************************************
000743210224       /EJECT
000744210224       //*************************************************************
000745210224       //                                                            *
000746210224       // consumeRESTAPI - Consume REST API                          *
000747210224       // ==============                                             *
000748210224       //                                                            *
000749210224       // Called by: processTransaction                              *
000750210224       //                                                            *
000751210306       // Calls: LIBHTTP123 http_string                              *
000752210224       //                                                            *
000753210224       //*************************************************************
000754210224
000755210224       begsr consumeRestAPI;
000756210224
000757210304              monitor;
000758210310
000759210304                 clear jsonData;
000760210305                 jsonData = http_string( 'GET' : %trim(RestAPIParm));
000761210304                 msg = *blanks;
000762210304                 err = 0;
000763210310
000764210304              on-error;
000765210310
000766210305                 msg = http_error(err);
000767210311                 errorMessage = %trim(msg) + ' ' + %trim(RestAPIParm);
000768210305                 exsr errorHandler;
000769210310
000770210304              endmon;
000771210224
000772210224       endsr;
000773210224
000774210224       //*************************************************************
000775210224       /EJECT
000776210224       //*************************************************************
000777210224       //                                                            *
000778210224       // parseJSONData - Parse JSON Data                            *
000779210224       // =============                                              *
000780210224       //                                                            *
000781210224       // Called by: processTransaction                              *
000782210224       //                                                            *
000783210224       // Calls: None                                                *
000784210224       //                                                            *
000785210224       //*************************************************************
000786210224
000787210224       begsr parseJSONData;
000788210304
000789210306                   // Load JSON data variable into a tree like structure
000790210306
000791210304                   docNode = yajl_buf_load_tree( %addr(jsonData:*data)
000792210304                             : %len(jsonData)
000793210304                             : ErrMsg );
000794210304
000795210304                   if errMsg <> '';
000796210305                      errorMessage = errMsg;
000797210305                      exsr errorHandler;
000798210304                   endif;
000799210304
000800210304                   node = YAJL_object_find(docNode: 'comment');
000801210304                   result.comment = YAJL_get_string(node);
000802210226
000803210311                   node = YAJL_object_find(docNode: 'errmsg');
000806210311                   result.errmsg  = yajl_get_string(val);
000820210311
000821210311                   // Error Messages
000822210311                   node = YAJL_object_find(docNode: 'exception');
000823210311                   if node <> *null;
000824210311                       val = YAJL_object_find(node: 'title');
000825210311                       result.errors.title = yajl_get_string(val);
000826210311
000827210311                       val = YAJL_object_find(node: 'exceptionMessage');
000828210311                       result.errors.exceptionMsg = yajl_get_string(val);
000829210311
000830210311                       val = YAJL_object_find(node: 'status');
000831210311                       result.errors.status = yajl_get_string(val);
000833210311                   endif;
000834210311                   // Error Messages
000835210311
000836210311
000837210304                   list = YAJL_object_find(docNode: 'dailyRateSummary');
000838210306
000839210305                   clear result.list;
000840210306
000841210304                   i = 0;
000842210304                   dow YAJL_ARRAY_LOOP( list: i: node );
000843210226
000844210226                       lastElem = i;
000845210226
000846210303                       // All calculation methods
000847210226                       val = YAJL_object_find(node: 'interestPeriodDate');
000848210226                       result.list(i).intPrdDate = yajl_get_string(val);
000849210301
000850210301                       ISODate =  result.list(i).intPrdDate;
000851210303
000852210310                       monitor;
000853210310                           WKY = %editc(wkYear:'X');
000854210310                           WKM = %editc(wkMonth:'X');
000855210310                           WKD = %editc(wkDay:'X');
000856210303
000857210310                           result.list(i).intPrdYMD  = YYMMDD;
000858210301
000859210310                           if BJDFIN = 'D';
000860210310                              DD1D = wkDay;
000861210310                              DD1M = wkMonth;
000862210310                              DD1Y = wkYear;
000863210310                              DateIn = DateIn_D;
000864210310                           else;
000865210310                              DD2D = wkDay;
000866210310                              DD2M = wkMonth;
000867210310                              DD2Y = wkYear;
000868210310                              DateIn = DateIn_M;
000869210310                           endif;
000870210310
000871210310                           pOption = '*FIRST';
000872210310                           pReturnCode = *Blanks;
000873210310                           callp CONVERT_DATE(
000874210310                                      ErrorFlag
000875210310                                    : DateIN
000876210310                                    : BJDFIN
000877210310                                    : DateOUT
000878210310                                   );
000879210301
000880210310                           if ErrorFlag   <> *blanks;
000881210310                               Dbase    = 005;
000882210310                               DbFile   = *Blanks;
000883210310                               DbKey    = *BLANKS;
000884210310                               DbPgm    = 'ZAGETCALRT';
000885210310                               Exsr *Pssr;
000886210310                           endif;
000887210301
000888210310                           result.list(i).intPDMidas = DateOUT;
000889210310                       on-error;
000890210310                       endmon;
000891210310
000892210303                       // All calculation methods
000893210226                       val = YAJL_object_find(node: 'interestPeriodDays');
000894210305                       cStr      =  yajl_get_string(val);
000895210305                       result.list(i).intPrdDays =  %dec(%trim(cStr):2:0);
000896210226
000897210310                       val =
000898210310                          YAJL_object_find(node: 'observationPeriodDate');
000899210310                       result.list(i).obsPrdDate =
000900210310                          yajl_get_string(val);
000901210303
000902210310                       ISODate =  result.list(i).obsPrdDate;
000903210310
000904210310                       monitor;
000905210303                            WKY = %editc(wkYear:'X');
000906210303                            WKM = %editc(wkMonth:'X');
000907210303                            WKD = %editc(wkDay:'X');
000908210303
000909210303                            result.list(i).intObsYMD  = YYMMDD;
000910210303
000911210303                            if BJDFIN = 'D';
000912210303                                 DD1D = wkDay;
000913210303                                 DD1M = wkMonth;
000914210303                                 DD1Y = wkYear;
000915210303                                 DateIn = DateIn_D;
000916210303                            else;
000917210303                                 DD2D = wkDay;
000918210303                                 DD2M = wkMonth;
000919210303                                 DD2Y = wkYear;
000920210303                                 DateIn = DateIn_M;
000921210303                             endif;
000922210303
000923210303                             pOption = '*FIRST';
000924210303                             pReturnCode = *Blanks;
000925210303                             callp CONVERT_DATE(
000926210303                                  ErrorFlag
000927210303                                : DateIN
000928210303                                : BJDFIN
000929210303                                : DateOUT
000930210303                               );
000931210303
000932210303                             if ErrorFlag   <> *blanks;
000933210310                                  Dbase    = 006;
000934210303                                  DbFile   = *Blanks;
000935210303                                  DbKey    = *BLANKS;
000936210303                                  DbPgm    = 'ZAGETCALRT';
000937210303                                 Exsr *Pssr;
000938210303                             endif;
000939210303
000940210303                             result.list(i).intOPMidas = DateOUT;
000941210310                       on-error;
000942210310                       endmon;
000943210310
000944210310                       val =
000945210310                           YAJL_object_find(node: 'observationPeriodDays');
000946210310
000947210310                       monitor;
000948210310                           cStr      =  yajl_get_string(val);
000949210310                              result.list(i).obsPrdDays =
000950210310                              %dec(%trim(cStr):2:0);
000951210310                       on-error;
000952210310                       endmon;
000953210303
000954210303                       // All calculation methods
000955210303                       val = YAJL_object_find(node: 'publishedRiskFreeRate');
000956210305
000957210305                       cStr  =  yajl_get_string(val);
000958210305                       result.list(i).pubRskFrRt =  %dec(%trim(cStr):30:9  );
000959210303
000960210303                       // All calculation methods
000961210303                       val = YAJL_object_find(node: 'rateApplied');
000962210305                       cStr  =  yajl_get_string(val);
000963210305                       result.list(i).rateApplied =  %dec(%trim(cStr):30:9  );
000964210226
000965210303                       // All calculation methods
000966210226                       val = YAJL_object_find(node: 'riskFreeRateFloorApplied');
000967210226                       if YAJL_is_true(node);
000968210226                           result.list(i).rskFrRtFlAp=  'True';
000969210226                       else;
000970210226                           result.list(i).rskFrRtFlAp=  'False';
000971210226                       endif;
000972210226
000973210310                       if calcMethod = 'NCCR';
000974210310                            val = YAJL_object_find(node: 'compoundingFactor');
000975210310                            result.list(i).compFactor=  yajl_get_string(val);
000976210226
000977210310                            val =
000978210310                              YAJL_object_find(node: 'dailyCompoundedRate');
000979210310                            result.list(i).dlyCompRate =
000980210310                              yajl_get_string(val);
000981210310                       endif;
000982210303
000983210310                       if calcMethod = 'CCR';
000984210310                            val =
000985210310                              YAJL_object_find(node: 'averageCompoundedRate');
000986210310                            result.list(i).aveCompRate =  yajl_get_string(val);
000987210303
000988210310                       endif;
000989210303
000990210310                       if calcMethod = 'SAVG';
000991210310                            val =
000992210310                              YAJL_object_find(node: 'simpleAverageRate');
000993210310                            result.list(i).simpleAve =  yajl_get_string(val);
000994210303
000995210310                       endif;
000996210303
000997210304                   enddo;
001004210226
001005210304                   // free up memory used by YAJL
001006210304                   yajl_tree_free(docNode);
001007210224
001008210224       endsr;
001009210224
001010210224       //*************************************************************
001011210224       /EJECT
001012210224       //*************************************************************
001013210224       //                                                            *
001014210301       // outputFile - Output Files                                  *
001015210301       // ==========                                                 *
001016210224       //                                                            *
001017210224       // Called by: processTransaction                              *
001018210224       //                                                            *
001019210224       // Calls: None                                                *
001020210224       //                                                            *
001021210224       //*************************************************************
001022210224
001023210301       begsr outputFiles;
001024210305
001025210226                   i = 1;
001026210306
001027210226                   dow i <= lastElem;
001028210306
001029210306                       // Output information to SDARRLOGTD
001030210303                       exsr writeToARRDailyHistory;
001031210306
001032210306                       //Output information to LELIBEPD
001033210301                       exsr writeToExtractFile;
001034210306
001035210301                       i = i + 1;
001036210306
001037210226                   enddo;
001038210224
001039210224       endsr;
001040210303       //*************************************************************
001041210303       /EJECT
001042210303       //*************************************************************
001043210303       //                                                            *
001044210303       // writeToARRDailyHistory - Write to ARR Daily Rates History  *
001045210303       // ======================                                     *
001046210303       //                                                            *
001047210303       // Called by: Output File                                     *
001048210303       //                                                            *
001049210303       // Calls: None                                                *
001050210303       //                                                            *
001051210303       //*************************************************************
001052210303
001053210303       begsr writeToARRDailyHistory;
001054210303
001055210305                   includeRecord = 'N';
001056210305
001057210305                   if (calcMethod = 'NCCR' or calcMethod  = 'SARR')
001058210305                   and  result.list(i).intPDMidas > transactDate;
001059210305                        includeRecord = 'Y';
001060210306
001061210305                   elseif  (calcMethod = 'CCR' or calcMethod  = 'SAVG');
001062210305                        includeRecord = 'Y';
001063210306
001064210305                   endif;
001065210305
001066210305                   fileToCheck = SDHSDRTD;
001067210305                   if includeRecord = 'Y';
001068210305                      exsr checkExist;
001069210305                      if action = INSERT;
001070210305                          exsr insertHistoryFile;
001071210305                      elseif action = UPDATE;
001072210305                          exsr updateHistoryFile;
001073210305                      endif;
001074210305                   endif;
001075210303
001076210303       endsr;
001077210303       //*************************************************************
001078210303       /EJECT
001079210303       //*************************************************************
001080210303       //                                                            *
001081210306       // checkExist - Check if a record exist on a given file       *
001082210303       // ==========                                                 *
001083210303       //                                                            *
001084210303       // Called by: Output File                                     *
001085210303       //                                                            *
001086210303       // Calls: None                                                *
001087210303       //                                                            *
001088210303       //*************************************************************
001089210303
001090210303       begsr checkExist;
001091210303
001092210303                   if fileToCheck = SDHSDRTD;
001093210303                        wSQLStr = 'select * from SDHSDRTD ' +
001094210303                                  'where CMODID = '  + QUO + moduleID + QUO +
001095210303                                  ' and CTRNID = ' + QUO + transactREF + QUO +
001096210303                                  ' and CMINPD = ' +
001097210303                                    %char(result.list(i).intPDMidas);
001098210303                   elseif fileToCheck = LELIBEPD;
001099210303                        wSQLStr = 'select * from LELIBEPD ' +
001100210303                                  'where LDLNRF = ' + QUO + transactREF + QUO +
001101210303                                  ' and LDVDAT = ' +
001102210303                                    %char(result.list(i).intPDMidas);
001103210303                   endif;
001104210303
001105210303                   exec sql prepare P1 from :wSQLStr;
001106210303                   exec sql open P1;
001107210303
001108210303                   if fileToCheck = SDHSDRTD;
001109210303                        exec sql fetch next From P1 into :DailyHistDS;
001110210303                   elseif fileToCheck = LELIBEPD;
001111210303                        exec sql fetch next From P1 into :ExtractFLDS;
001112210303                   endif;
001113210303
001114210303                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001115210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001116210305                      exsr errorHandler;
001117210303                   endif;
001118210303
001119210303                   if sqlCod = NO_RECORD;
001120210303                      action = INSERT;
001121210303                   else;
001122210303                      action = UPDATE;
001123210303                   endif;
001124210303                   exec sql close P1;
001125210303
001126210303       endsr;
001127210303       //*************************************************************
001128210303       /EJECT
001129210303       //*************************************************************
001130210303       //                                                            *
001131210303       // insertHistoryFile                                          *
001132210303       // =================                                          *
001133210303       //                                                            *
001134210303       // Called by: writeToARRDailyHistory                           *
001135210303       //                                                            *
001136210303       // Calls: None                                                *
001137210303       //                                                            *
001138210303       //*************************************************************
001139210303
001140210303       begsr insertHistoryFile;
001141210303
001142210303                   clear DailyHistDS;
001143210303                   DailyHistDS.CMODID = moduleID;
001144210303                   DailyHistDS.CTRNID = transactREF;
001145210304                   DailyHistDS.CCALCM = calcMethod;
001146210303                   DailyHistDS.CMINPD = result.list(i).intPDMidas;
001147210303                   DailyHistDS.CINPDT = result.list(i).intPrdYMD;
001148210303                   DailyHistDS.CINPDY = result.list(i).intPrdDays;
001149210303                   DailyHistDS.CMOBPD = result.list(i).intOPMidas;
001150210303                   DailyHistDS.COBPDT = result.list(i).intObsYMD;
001151210303                   DailyHistDS.CPBRFR = result.list(i).pubRskFrRt;
001152210305                   DailyHistDS.COBPDY = result.list(i).obsPrdDays;
001153210303                   DailyHistDS.CRTEAP = result.list(i).rateApplied;
001154210305                   if result.list(i).rskFrRtFlAp = 'true';
001155210305                     DailyHistDS.CRFRAP = 'Y';
001156210305                   else;
001157210305                     DailyHistDS.CRFRAP = 'N';
001158210305                   endif;
001159210303                   DailyHistDS.CTIMST = %timestamp();
001160210304
001161210303                   select;
001162210303                        when calcMethod = 'NCCR';
001163210304                             DailyHistDS.CDCMRT =
001164210303                               %Dec(Result.List(i).dlyCompRate:30:9);
001165210304                             DailyHistDS.CCMFAC =
001166210304                               %Dec(Result.List(i).compFactor:30:9);
001167210303                        when calcMethod = 'CCR';
001168210303                             DailyHistDS.CAVCRT =
001169210303                               %Dec(Result.List(i).aveCompRate:30:9);
001170210304                        when calcMethod = 'SAVG';
001171210304                             DailyHistDS.CSMPAV =
001172210304                               %Dec(Result.List(i).simpleAve:30:9);
001173210303                   endsl;
001174210303
001175210303                   exec sql insert into SDHSDRTD
001176210303                   values (:DailyHistDS);
001177210303
001178210304                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001179210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001180210305                      exsr errorHandler;
001181210303                   endif;
001182210303
001183210303       endsr;
001184210310
001185210303       //*************************************************************
001186210303       /EJECT
001187210303       //*************************************************************
001188210303       //                                                            *
001189210303       // insertExtractFile                                          *
001190210303       // =================                                          *
001191210303       //                                                            *
001192210303       // Called by: writeToHistoryFile                               *
001193210303       //                                                            *
001194210303       // Calls: None                                                *
001195210303       //                                                            *
001196210303       //*************************************************************
001197210303
001198210303       begsr insertExtractFile;
001199210303
001200210303                   clear ExtractFLDS;
001201210310                   clear compAveRate;
001202210303                   ExtractFLDS.LDLNRF = transactREF;
001203210303                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
001204210303
001205210303                   select;
001206210303                        when calcMethod = 'NCCR';
001207210310                             compAveRate =
001208210303                               %Dec(Result.List(i).dlyCompRate:30:9);
001209210303                        when calcMethod = 'CCR';
001210210310                             compAveRate =
001211210303                               %Dec(Result.List(i).aveCompRate:30:9);
001212210310                        when calcMethod = 'SARR';
001213210310                             compAveRate =
001214210310                               %Dec(Result.List(i).rateApplied:30:9);
001215210310                        when calcMethod = 'SAVG';
001216210310                             compAveRate =
001217210310                               %Dec(Result.List(i).simpleAve:30:9);
001218210303                   endsl;
001219210303
001220210310                   compAveRate += %dech(benchMarkAdj:13:9);
001221210310                   ExtractFLDS.LDCART =
001222210310                     %dech(compAveRate  :13 :8);
001223210310
001224210303                   exec sql insert into LELIBEPD
001225210303                   values (:ExtractFLDS);
001226210303
001227210304                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001228210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001229210305                      exsr errorHandler;
001230210303                   endif;
001231210303
001232210303       endsr;
001233210303       //*************************************************************
001234210303       /EJECT
001235210303       //*************************************************************
001236210303       //                                                            *
001237210303       // updateExtractFile                                          *
001238210303       // =================                                          *
001239210303       //                                                            *
001240210303       // Called by: writeToExtractFile                               *
001241210303       //                                                            *
001242210303       // Calls: None                                                *
001243210303       //                                                            *
001244210303       //*************************************************************
001245210303
001246210303       begsr updateExtractFile;
001247210304
001248210303                   clear ExtractFLDS;
001249210310                   clear compAveRate;
001250210303                   ExtractFLDS.LDLNRF = transactREF;
001251210303                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
001252210303
001253210310                   select;
001254210310                        when calcMethod = 'NCCR';
001255210310                             compAveRate =
001256210310                               %Dec(Result.List(i).dlyCompRate:30:9);
001257210310                        when calcMethod = 'CCR';
001258210310                             compAveRate =
001259210310                               %Dec(Result.List(i).aveCompRate:30:9);
001260210310                        when calcMethod = 'SARR';
001261210310                             compAveRate =
001262210310                               %Dec(Result.List(i).rateApplied:30:9);
001263210310                        when calcMethod = 'SAVG';
001264210310                             compAveRate =
001265210310                               %Dec(Result.List(i).simpleAve:30:9);
001266210310                   endsl;
001267210310
001268210310                   compAveRate += %dech(benchMarkAdj:13:9);
001269210310                   ExtractFLDS.LDCART =
001270210310                     %dech(compAveRate  :13 :8);
001271210303
001272210303                   wSqlStr = 'update LELIBEPD A '  +
001273210303                              'SET A.LDCART = ' + %Char(ExtractFLDS.LDCART) +
001274210303                              ' where A.LDLNRF = ' + QUO + ExtractFLDS.LDLNRF
001275210303                                 + QUO +
001276210303                              ' and   A.LDVDAT = ' +  %Char(ExtractFLDS.LDVDAT);
001277210303
001278210303                   exec sql
001279210303                   execute immediate :wSqlStr;
001280210303
001281210303                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001282210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001283210305                      exsr errorHandler;
001284210303                   endif;
001285210303
001286210303       endsr;
001287210303
001288210301       //*************************************************************
001289210301       /EJECT
001290210301       //*************************************************************
001291210301       //                                                            *
001292210301       // writeToExtractFile - Write to Extract File                 *
001293210301       // ==================                                         *
001294210301       //                                                            *
001295210301       // Called by: Output File                                     *
001296210301       //                                                            *
001297210301       // Calls: None                                                *
001298210301       //                                                            *
001299210301       //*************************************************************
001300210301
001301210301
001302210301       begsr writeToExtractFile;
001303210304
001304210303                   fileToCheck = LELIBEPD;
001305210303                   exsr checkExist;
001306210304
001307210303                   if action = INSERT;
001308210303                        exsr insertExtractFile;
001309210306
001310210303                   elseif action = UPDATE;
001311210303                        exsr updateExtractFile;
001312210306
001313210303                   endif;
001314210301
001315210304
001316210301       endsr;
001317210303       //*************************************************************
001318210303       /EJECT
001319210303       //*************************************************************
001320210303       //                                                            *
001321210303       // writeToAuditLog - Write to Audit Log                       *
001322210303       // ===============                                            *
001323210303       //                                                            *
001324210303       // Called by: Output File                                     *
001325210303       //                                                            *
001326210303       // Calls: None                                                *
001327210303       //                                                            *
001328210303       //*************************************************************
001329210303
001330210303
001331210303       begsr writeToAuditLog;
001332210303
001333210305                   AuditLogds.SJTMST = %timestamp();
001334210311                   AuditLogds.SJTITL = result.errors.title;
001335210311                   AuditLogds.SJEXMS = result.errors.exceptionMsg;
001336210311                   AuditLogds.SJCODE = result.errors.status;
001337210311
001338210311                   if AuditLogds.SJTITL <> *blanks;
001339210311                       AuditLogds.SJSTAT = 'F';
001340210311                   endif;
001341210311
001342210305                   logData = %Trim(jsonData);
001343210305                   exec sql insert into SDARRLOGTD
001344210305                   values (
001345210305                            : AuditLogds.SJMODI,
001346210305                            : AuditLogds.SJTREF,
001347210305                            : AuditLogds.SJSTAT,
001348210305                            : AuditLogds.SJTMST,
001349210311                            : AuditLogds.SJTITL,
001350210311                            : AuditLogds.SJEXMS,
001351210311                            : AuditLogds.SJcode,
001352210305                            : logData
001353210305                          );
001354210305
001355210305                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001356210310                        dBase    = 007;
001357210305                        dBfile   = 'SDARRLOGTD';
001358210305                        dBKey    = *BLANKS;
001359210305                        dBPgm    = 'ZAGETCALRT';
001360210305                        exsr *pssr;
001361210305                   endif;
001362210303
001363210303       endsr;
001364210224
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
