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
000227210312     D  returnCD                     20a
000228210312      ** Return Code
000229210222
000230210222     D Main            pi
000231210301      **-----------------------------------------------------**
000232210301     D  moduleID                      2a
000233210301      ** Module ID
000234210301      **--** LE - Lending
000235210301      **--** DL - Dealing
000236210301      **--** FR - FRA/IRS
000237210301     D  transactREF                   6a
000238210301      ** Transaction Reference
000239210226     D  calcMethod                    4a
000240210226      ** Calculation Method
000241210301      **--** NCCR - Daily Compounding in Arrears (Non-Cumulative Compounded Rate)
000242210301      **--** CCR  - Average Compounded In Arrears (Cumulative Compounded Rate)
000243210301      **--** SARR - Simple Average
000244210301      **--** SAVG - Simple Average
000246210226     D  intPrdStartDt                10a
000247210226      ** Interest Period Start Date
000248210226     D  intPrdEndDt                  10a
000249210226      ** Interest Period End Date
000250210310     D  riskFreeRate                  5a
000251210226      ** Risk Free Rate
000252210226     D  riskFreeRatFl                20a
000253210226      ** Risk Free Rate Floor
000254210226     D  lookBackDays                  2a
000255210226      ** Lookback Days
000256210301     D  obserPrdShift                 5a
000257210226      ** Observation Period Shift
000258210301      ** True/False
000259210226     D  RateRndDecPts                 3a
000260210226      ** Rate Rounding Decimal Points
000261210303     D  dayCntConvent                 7a
000262210226      ** Day Count Convention
000263210226     D  lockOutDays                   2a
000264210226      ** Lockout Days
000265210301     D  showDailyDeta                 5a
000266210226      ** Show Dailty Details
000267210301      ** True/False
000268210226     D  callTillDate                 10a
000269210226      ** Calculate Till Date
000270210310     D  benchMarkAdj                 20a
000271210305      ** Benchmark Adjustment
000272210312     D  returnCD                     20a
000273210312      ** Return Code
000274210224
000275210222      ** +--------------------------------------+
000276210222      ** ¦ Manually included D-specs            ¦
000277210222      ** ¦ =========================            ¦
000278210222      ** +--------------------------------------+
000279210310      ** +--------------------------------------+
000280210303
000281210301      ** Extract File
000282210301     D LELIBEDS      e ds                  extname(LELIBEPD)
000283210301     D ExtractFLDS     ds                  likeds(LELIBEDS)
000284210303
000285210303      ** Audit Log
000286210303     D SDARRLDS      e ds                  extname(SDARRLOGTD)
000287210312     D AuditLogDS      ds                  likeds(SDARRLDS)
000288210303
000289210303      ** ARR Daily Rates History File
000290210303     D ARRDLYDS      e ds                  extname(SDHSDRTD)
000291210303     D DailyHistDS     ds                  likeds(ARRDLYDS)
000292210303
000293210304      ** Core DS
000294210222     D dssdy         e ds                  extname(DSSDY)
000295210222     D dsfdy         e ds                  extname(DSFDY)
000296210222
000297210222      ** +--------------------------------------+
000298210222      ** ¦ Constants declaration                ¦
000299210222      ** ¦ =====================                ¦
000300210222      ** +--------------------------------------+
000301210304
000302210304     D AMP             c                   const('&')
000303210304     D INSERT          c                   const(0)
000304210304     D LELIBEPD        c                   const(1)
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
000373210312     D logData         s          25000a   varying
000374210312     D isError         s               n   inz(false)
000375210312     D isException     s               n   inz(false)
000376210226
000377210226      *---------------*
000378210226      ** JSON Details *
000379210226      *---------------*
000380210226
000381210226     D summary_t       ds                  qualified
000382210226     D                                     template
000383210226     D   intPrdDate                  10a
000384210226      ** Interest Period Date
000385210303      ** NCCR, CCR, SAVG, SARR
000386210301     D   intPDMidas                   5p 0
000387210301      ** Interest Period Date in Midas Format
000388210303     D   intPrdYMD                    6a
000389210303      ** Interest Period Date YYMMDD
000390210226     D   intPrdDays                   2s 0
000391210226      ** Interest Period Days
000392210303      ** NCCR, CCR, SAVG, SARR
000393210226     D   obsPrdDate                  10a
000394210226      ** Observation Period Date
000395210303      ** NCCR
000396210303     D   intOPMidas                   5p 0
000397210303      ** Observation Period Date in Midas Format
000398210303     D   intObsYMD                    6a
000399210303      ** Observation Period Date YYMMDD
000400210226     D   obsPrdDays                   2s 0
000401210226      ** Observation Period Days
000402210303      ** NCCR
000403210305     D   pubRskFrRt                  30p 9
000404210226      ** Published Risk Free Rate
000405210303      ** NCCR, CCR, SAVG, SARR
000406210226     D   rateApplied                 30p 9
000407210226      ** Rate Applied
000408210303      ** NCCR, CCR, SAVG, SARR
000409210226     D   rskFrRtFlAp                  5a
000410210226      ** Risk Free Rate Floor Applied
000411210303      ** NCCR, CCR, SAVG, SARR
000412210304     D   compFactor                  10a
000413210226      ** Compounding Factor
000414210303      ** NCCR
000415210301     D   dlyCompRate                 10a
000416210226      ** Daily Compunded Rate
000417210303      ** NCCR
000418210303     D   aveCompRate                 10a
000419210303      ** Average Compunded Rate
000420210303      ** CCR
000421210303     D   simpleAve                   10a
000422210303      ** Simple Average
000423210303      ** SAVG
000424210226
000425210226     D request_t       ds                  qualified
000426210226     D                                     template
000427210226     D   intPrdStart                 10a
000428210226      ** Interest Period Start
000429210226     D   intPrdEnd                   10a
000430210226      ** Interest Period End
000431210226     D   rskFreeRate                  4a
000432210226      ** Risk Free Rate
000433210226     D   rskFreeRtFl                 15s 6
000434210226      ** Risk Free Rate Floor
000435210226     D   obsPrdShift                  8s 0
000436210226      ** Observation Period Shift
000437210226     D   ratRndDecPts                 8s 0
000438210226      ** Rate Rounding Decimal Points
000439210226     D   showDailyDet                 8s 0
000440210226      ** Show Daily Details
000441210226
000442210226     D result          ds                  qualified
000443210226     D   success                      1n
000444210226      ** Success
000445210226     D   errmsg                     500a   varying
000446210226      ** Error Message
000447210226     D   statusCode                   4a   varying
000448210226      ** Status Code
000449210226     D   message                     10a   varying
000450210226      ** Message
000451210226     D   comment                    500a   varying
000452210226      ** Comment
000453210226     D   lastUpdFrSrc               200a   varying
000454210226      ** Last Updated From Source
000455210226     D   legalDisc                  200a   varying
000456210226      ** Legal Disclaimer
000457210311     D   reqParms                          likeds(request_t)
000458210311      ** Request Parameters
000459210226     D   list                              likeds(summary_t) dim(999)
000460210226      ** Daily Rate Summary
000461210311     D   errors                            likeds(exception_t)
000462210311      ** Exception Parameters
000463210311
000464210311     D exception_t     ds                  qualified
000465210311     D                                     template
000466210311     D   title                       50a
000467210311      ** Title
000468210311     D   exceptionMsg               100a
000469210311      ** Exception Message
000470210311     D   status                       4a
000471210311      ** Status
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
000516210312
000517210222      /free
000518210222
000519210222       // ** +--- Start of Main processing -----------------------------------+
000520210222       // ** ¦                                                                ¦
000521210222       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
000522210222       // ** ¦ executed at program activation.                                ¦
000523210222       // ** ¦                                                                ¦
000524210222       // ** +----------------------------------------------------------------+
000525210304
000526210224                   exsr processTransaction;
000527210222
000528210222                   *Inlr = *On;
000529210222                   return;
000530210310
000531210310       //*************************************************************
000532210310       /EJECT
000533210310       //*************************************************************
000534210310       //                                                            *
000535210310       // inzsr - Program Initialisation routine                     *
000536210310       //                                                            *
000537210310       // Called by: Main processing                                 *
000538210310       //                                                            *
000539210310       //  Calls: None                                               *
000540210310       //                                                            *
000541210310       //*************************************************************
000542210310
000543210310       begsr *inzsr;
000544210310
000545210310                   //Initialise audit log DS
000546210312                   clear AuditLogDS;
000547210312                   isError = false;
000548210310
000549210312                   AuditLogDS.SJMODI = moduleID;
000550210312                   AuditLogDS.SJTREF = transactREF;
000551210312                   AuditLogDS.SJSTAT = 'C';
000552210310
000553210310                   pOption = '*FIRST';
000554210310                   pReturnCode = *Blanks;
000555210310
000556210310                   callp ACCESS_SDBANK(
000557210310                                  pReturnCode
000558210310                                : pOption
000559210310                                : dsfdy
000560210310                               );
000561210310                   SDBANK = dsfdy;
000562210310
000563210310                   if pReturnCode <> *blanks;
000564210312                      AuditLogDS.SJTMST = %timestamp();
000565210312                      AuditLogDS.SJTITL = 'SDBANKPD';
000566210312                      AuditLogDS.SJEXMS = 'Error in access SDBANKPD';
000567210312                      AuditLogDS.SJCODE = '001';
000568210312                      isError = True;
000571210312                      Exsr errorHandler;
000572210310                   endif;
000573210310
000574210310                   pOP01 = 'ARRAdapterURL';
000575210310
000576210310                   CallP ACCESS_SVAL(
000577210310                                       pRetCode
000578210310                                     : pOP01
000579210310                                     : pVL01
000580210310                                     : pOP02
000581210310                                     : pVL02
000582210310                                     : pOP03
000583210310                                     : pVL03
000584210310                                     : pOP04
000585210310                                     : pVL04
000586210310                                     : pOP05
000587210310                                     : pVL05
000588210310                                     : pOP06
000589210310                                     : pVL06
000590210310                                     : pOP07
000591210310                                     : pVL07
000592210310                                     : pOP08
000593210310                                     : pVL08
000594210310                                     : pOP09
000595210310                                     : pVL09
000596210310                                     : pOP10
000597210310                                     : pVL10
000598210310                                       );
000599210310
000600210310                   If pRetCode <> *Blanks;
000601210312                        AuditLogDS.SJTMST = %timestamp();
000602210312                        AuditLogDS.SJTITL = 'SDSVALPD';
000603210312                        AuditLogDS.SJEXMS = 'Error in access SDSVALPD ' +
000604210312                          %trim(Pvl01);
000605210312                        AuditLogDS.SJCODE = '002';
000607210312                        isError = True;
000608210312                        Exsr errorHandler;
000614210310                   Endif;
000615210310
000616210310                   If pVL01 <> *Blanks;
000617210310                         CalcMetURL     = HTTP_HEAD  + %trim(pVL01);
000618210310                   Else;
000619210312                        AuditLogDS.SJTMST = %timestamp();
000620210312                        AuditLogDS.SJTITL = 'SDSVALPD';
000621210312                        AuditLogDS.SJEXMS = 'Error in access SDSVALPD ' +
000622210312                          %trim(calcMetURL);
000624210312                        AuditLogDS.SJCODE = '003';
000625210312                        isError = True;
000626210312                        Exsr errorHandler;
000632210310                   Endif;
000633210310
000634210310                   select;
000635210310
000636210310                       when calcMethod = 'NCCR';
000637210310                            calcMetURL =  %trim(calcMetURL) +
000638210310                              %trim(arrCalLoc(1));
000639210310
000640210310                       when calcMethod = 'CCR';
000641210310                            calcMetURL =  %trim(calcMetURL) +
000642210310                              %trim(arrCalLoc(2));
000643210310
000644210310                       when calcMethod = 'SARR';
000645210310                            calcMetURL =  %trim(calcMetURL) +
000646210310                              %trim(arrCalLoc(3));
000647210310
000648210310                       when calcMethod = 'SAVG';
000649210310                            calcMetURL =  %trim(calcMetURL) +
000650210310                              %trim(arrCalLoc(4));
000651210310
000652210310                   endsl;
000653210310
000654210310                   // Get the highest date in the Daily History file
000655210310                   wSQLStr = 'select * from SDHSDRTD ' +
000656210310                             ' where CMODID = ' + QUO + moduleID + QUO +
000657210310                             ' and CTRNID = ' +  QUO + transactREF + QUO +
000658210310                             'order by CMINPD DESC';
000659210310
000660210310                   exec sql prepare P1 from :wSQLStr;
000661210310                   exec sql declare P1 cursor for P1;
000662210310                   exec sql open P1;
000663210310                   exec sql fetch next From P1 into :DailyHistDS;
000664210310
000665210310                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
000666210312                        AuditLogDS.SJTMST = %timestamp();
000667210312                        AuditLogDS.SJTITL = 'SDHSDRTD';
000668210312                        AuditLogDS.SJEXMS = 'Error in access SDHSDRTD ' +
000669210312                          %trim(wSQLSTR);
000670210312                        AuditLogDS.SJCODE = '004';
000671210312                        isError = True;
000677210312                        exsr errorHandler;
000678210310                   endif;
000679210310
000680210310                   if sqlCod = NO_RECORD;
000681210310                      transactDate = 0;
000682210310                   else;
000683210310                      transactDate = DailyHistDS.CMINPD;
000684210310                   endif;
000685210310
000686210310                   exec sql close P1;
000687210310       endsr;
000688210222
000689210222       //*************************************************************
000690210222       /EJECT
000691210222       //*************************************************************
000692210222       //                                                            *
000693210224       // processTransaction - Process a Loan Transaction            *
000694210224       // ==================                                         *
000695210222       //                                                            *
000696210222       // Called by: Main Processing                                 *
000697210222       //                                                            *
000698210222       // Calls: None                                                *
000699210222       //                                                            *
000700210222       //*************************************************************
000701210222
000702210224       begsr processTransaction;
000703210305
000704210306                   //** This will build the URL parameter for the Rest API Call
000705210305
000706210304                   exsr buildParameter;
000707210224
000708210306                   //** This will call the http_string function from LIBHTTP123
000709210305                   //** to consume the Rest API
000710210305
000711210304                   exsr consumeRESTAPI;
000712210305
000713210312                   if not(isError);
000714210305
000715210305                      //** This will parse the JSON data returned from ARR Calculator
000716210306                      //** and store it to an array of Data Structure
000717210305
000718210305                      exsr parseJSONData;
000719210305
000720210305                      //** This will handle the output of the array DS to the
000721210305                      //** history and extract files
000722210306
000723210305                      exsr outputFiles;
000724210312
000725210312                      //** log details to audit file
000726210312                      exsr writeToAuditLog;
000731210305
000732210305                   endif;
000733210224
000736210224
000737210222       endsr;
000738210222
000739210224       //*************************************************************
000740210224       /EJECT
000741210224       //*************************************************************
000742210224       //                                                            *
000743210224       // buildParameter - Build REST API Parameter                  *
000744210224       // ==============                                             *
000745210224       //                                                            *
000746210224       // Called by: processTransaction                              *
000747210224       //                                                            *
000748210224       // Calls: None                                                *
000749210224       //                                                            *
000750210224       //*************************************************************
000751210224
000752210224       begsr buildParameter;
000753210304
000754210305                   RestAPIParm = %trim(CalcMetURL) +
000755210305                                 QUE + 'interestPeriodStartDate=' +
000756210305                                       %trim(intPrdStartDt) +
000757210304                                 AMP + 'interestPeriodEndDate=' +
000758210305                                    %trim(intPrdEndDt) +
000759210305                                 AMP + 'riskFreeRate=' +
000760210305                                    %trim(riskFreeRate) +
000761210305                                 AMP + 'lookBackDays=' +
000762210305                                    %trim(lookBackDays)  +
000763210226                                 AMP + 'rateRoundingDecimalPoints=' +
000764210305                                    %trim(RateRndDecPts) +
000765210226                                 AMP + 'observationPeriodShift=' +
000766210305                                    %trim(obserPrdShift) +
000767210305                                 AMP + 'lockoutDays=' +
000768210305                                    %trim(lockOutDays) +
000769210304                                 AMP + 'showDailyDetails=' +
000770210305                                    %trim(showDailyDeta) +
000771210304                                 AMP + 'calculateTillDate=' +
000772210305                                    %trim(callTillDate) +
000773210304                                 AMP + 'riskFreeRateFloor=' +
000774210305                                    %trim(riskFreeRatFl);
000775210305
000776210224       endsr;
000777210224
000778210224       //*************************************************************
000779210224       /EJECT
000780210224       //*************************************************************
000781210224       //                                                            *
000782210224       // consumeRESTAPI - Consume REST API                          *
000783210224       // ==============                                             *
000784210224       //                                                            *
000785210224       // Called by: processTransaction                              *
000786210224       //                                                            *
000787210306       // Calls: LIBHTTP123 http_string                              *
000788210224       //                                                            *
000789210224       //*************************************************************
000790210224
000791210224       begsr consumeRestAPI;
000792210224
000793210304              monitor;
000794210310
000795210304                 clear jsonData;
000796210305                 jsonData = http_string( 'GET' : %trim(RestAPIParm));
000797210304                 msg = *blanks;
000798210304                 err = 0;
000799210310
000800210304              on-error;
000801210310
000802210305                 msg = http_error(err);
000803210312                 errorMessage = %trim(msg);
000804210312                 returnCD = 'CONNECTION_ERROR';
000805210312
000806210312                 exsr errorHandler;
000807210310
000808210304              endmon;
000809210224
000810210224       endsr;
000811210224
000812210224       //*************************************************************
000813210224       /EJECT
000814210224       //*************************************************************
000815210224       //                                                            *
000816210224       // parseJSONData - Parse JSON Data                            *
000817210224       // =============                                              *
000818210224       //                                                            *
000819210224       // Called by: processTransaction                              *
000820210224       //                                                            *
000821210224       // Calls: None                                                *
000822210224       //                                                            *
000823210224       //*************************************************************
000824210224
000825210224       begsr parseJSONData;
000826210304
000827210306                   // Load JSON data variable into a tree like structure
000828210306
000829210304                   docNode = yajl_buf_load_tree( %addr(jsonData:*data)
000830210304                             : %len(jsonData)
000831210304                             : ErrMsg );
000832210304
000833210304                   if errMsg <> '';
000834210305                      errorMessage = errMsg;
000835210312                      isError = true;
000836210312                      exsr errorHandler;
000837210304                   endif;
000838210304
000839210304                   node = YAJL_object_find(docNode: 'comment');
000840210304                   result.comment = YAJL_get_string(node);
000841210226
000842210311                   node = YAJL_object_find(docNode: 'errmsg');
000843210311                   result.errmsg  = yajl_get_string(val);
000844210311
000845210312                   // Exception messages
000846210311                   node = YAJL_object_find(docNode: 'exception');
000847210311                   if node <> *null;
000848210312                       isException = true;
000849210311                       val = YAJL_object_find(node: 'title');
000850210311                       result.errors.title = yajl_get_string(val);
000851210311
000852210311                       val = YAJL_object_find(node: 'exceptionMessage');
000853210311                       result.errors.exceptionMsg = yajl_get_string(val);
000854210311
000855210311                       val = YAJL_object_find(node: 'status');
000856210311                       result.errors.status = yajl_get_string(val);
000857210312
000858210312                       // free up memory used by YAJL
000859210312                       yajl_tree_free(docNode);
000860210312
000861210312                       exsr errorHandler;
000862210312
000863210311                   endif;
000864210311
000865210311
000866210304                   list = YAJL_object_find(docNode: 'dailyRateSummary');
000867210306
000868210305                   clear result.list;
000869210306
000870210304                   i = 0;
000871210304                   dow YAJL_ARRAY_LOOP( list: i: node );
000872210226
000873210226                       lastElem = i;
000874210226
000875210303                       // All calculation methods
000876210226                       val = YAJL_object_find(node: 'interestPeriodDate');
000877210226                       result.list(i).intPrdDate = yajl_get_string(val);
000878210301
000879210301                       ISODate =  result.list(i).intPrdDate;
000880210303
000881210310                       monitor;
000882210310                           WKY = %editc(wkYear:'X');
000883210310                           WKM = %editc(wkMonth:'X');
000884210310                           WKD = %editc(wkDay:'X');
000885210303
000886210310                           result.list(i).intPrdYMD  = YYMMDD;
000887210301
000888210310                           if BJDFIN = 'D';
000889210310                              DD1D = wkDay;
000890210310                              DD1M = wkMonth;
000891210310                              DD1Y = wkYear;
000892210310                              DateIn = DateIn_D;
000893210310                           else;
000894210310                              DD2D = wkDay;
000895210310                              DD2M = wkMonth;
000896210310                              DD2Y = wkYear;
000897210310                              DateIn = DateIn_M;
000898210310                           endif;
000899210310
000900210310                           pOption = '*FIRST';
000901210310                           pReturnCode = *Blanks;
000902210310                           callp CONVERT_DATE(
000903210310                                      ErrorFlag
000904210310                                    : DateIN
000905210310                                    : BJDFIN
000906210310                                    : DateOUT
000907210310                                   );
000908210301
000909210310                           if ErrorFlag   <> *blanks;
000910210312                                AuditLogDS.SJTMST = %timestamp();
000911210312                                AuditLogDS.SJTITL = 'ZDATE1';
000912210312                                AuditLogDS.SJEXMS = 'Error in date conversion';
000913210312                                AuditLogDS.SJCODE = '005';
000914210312                                isError = True;
000915210312                                exsr errorHandler;
000916210310                           endif;
000917210310                           result.list(i).intPDMidas = DateOUT;
000918210312
000919210310                       on-error;
000920210310                       endmon;
000921210310
000922210303                       // All calculation methods
000923210226                       val = YAJL_object_find(node: 'interestPeriodDays');
000924210305                       cStr      =  yajl_get_string(val);
000925210305                       result.list(i).intPrdDays =  %dec(%trim(cStr):2:0);
000926210226
000927210310                       val =
000928210310                          YAJL_object_find(node: 'observationPeriodDate');
000929210310                       result.list(i).obsPrdDate =
000930210310                          yajl_get_string(val);
000931210303
000932210310                       ISODate =  result.list(i).obsPrdDate;
000933210310
000934210310                       monitor;
000935210303                            WKY = %editc(wkYear:'X');
000936210303                            WKM = %editc(wkMonth:'X');
000937210303                            WKD = %editc(wkDay:'X');
000938210303
000939210303                            result.list(i).intObsYMD  = YYMMDD;
000940210303
000941210303                            if BJDFIN = 'D';
000942210303                                 DD1D = wkDay;
000943210303                                 DD1M = wkMonth;
000944210303                                 DD1Y = wkYear;
000945210303                                 DateIn = DateIn_D;
000946210303                            else;
000947210303                                 DD2D = wkDay;
000948210303                                 DD2M = wkMonth;
000949210303                                 DD2Y = wkYear;
000950210303                                 DateIn = DateIn_M;
000951210303                             endif;
000952210303
000953210303                             pOption = '*FIRST';
000954210303                             pReturnCode = *Blanks;
000955210303                             callp CONVERT_DATE(
000956210303                                  ErrorFlag
000957210303                                : DateIN
000958210303                                : BJDFIN
000959210303                                : DateOUT
000960210303                               );
000961210303
000962210303                             if ErrorFlag   <> *blanks;
000963210312                                AuditLogDS.SJTMST = %timestamp();
000964210312                                AuditLogDS.SJTITL = 'ZDATE1';
000965210312                                AuditLogDS.SJEXMS = 'Error in date conversion';
000966210312                                AuditLogDS.SJCODE = '005';
000967210312                                isError = True;
000968210312                                exsr errorHandler;
000972210303                             endif;
000973210303
000974210303                             result.list(i).intOPMidas = DateOUT;
000975210310                       on-error;
000976210310                       endmon;
000977210310
000978210310                       val =
000979210310                           YAJL_object_find(node: 'observationPeriodDays');
000980210310
000981210310                       monitor;
000982210310                           cStr      =  yajl_get_string(val);
000983210310                              result.list(i).obsPrdDays =
000984210310                              %dec(%trim(cStr):2:0);
000985210310                       on-error;
000986210310                       endmon;
000987210303
000988210303                       // All calculation methods
000989210303                       val = YAJL_object_find(node: 'publishedRiskFreeRate');
000990210305
000991210305                       cStr  =  yajl_get_string(val);
000992210305                       result.list(i).pubRskFrRt =  %dec(%trim(cStr):30:9  );
000993210303
000994210303                       // All calculation methods
000995210303                       val = YAJL_object_find(node: 'rateApplied');
000996210305                       cStr  =  yajl_get_string(val);
000997210305                       result.list(i).rateApplied =  %dec(%trim(cStr):30:9  );
000998210226
000999210303                       // All calculation methods
001000210226                       val = YAJL_object_find(node: 'riskFreeRateFloorApplied');
001001210226                       if YAJL_is_true(node);
001002210226                           result.list(i).rskFrRtFlAp=  'True';
001003210226                       else;
001004210226                           result.list(i).rskFrRtFlAp=  'False';
001005210226                       endif;
001006210226
001007210310                       if calcMethod = 'NCCR';
001008210310                            val = YAJL_object_find(node: 'compoundingFactor');
001009210310                            result.list(i).compFactor=  yajl_get_string(val);
001010210226
001011210310                            val =
001012210310                              YAJL_object_find(node: 'dailyCompoundedRate');
001013210310                            result.list(i).dlyCompRate =
001014210310                              yajl_get_string(val);
001015210310                       endif;
001016210303
001017210310                       if calcMethod = 'CCR';
001018210310                            val =
001019210310                              YAJL_object_find(node: 'averageCompoundedRate');
001020210310                            result.list(i).aveCompRate =  yajl_get_string(val);
001021210303
001022210310                       endif;
001023210303
001024210310                       if calcMethod = 'SAVG';
001025210310                            val =
001026210310                              YAJL_object_find(node: 'simpleAverageRate');
001027210310                            result.list(i).simpleAve =  yajl_get_string(val);
001028210303
001029210310                       endif;
001030210303
001031210304                   enddo;
001032210226
001033210304                   // free up memory used by YAJL
001034210304                   yajl_tree_free(docNode);
001035210224
001036210224       endsr;
001037210224
001038210224       //*************************************************************
001039210224       /EJECT
001040210224       //*************************************************************
001041210224       //                                                            *
001042210301       // outputFile - Output Files                                  *
001043210301       // ==========                                                 *
001044210224       //                                                            *
001045210224       // Called by: processTransaction                              *
001046210224       //                                                            *
001047210224       // Calls: None                                                *
001048210224       //                                                            *
001049210224       //*************************************************************
001050210224
001051210301       begsr outputFiles;
001052210305
001053210226                   i = 1;
001054210306
001055210226                   dow i <= lastElem;
001056210306
001057210306                       // Output information to SDARRLOGTD
001058210303                       exsr writeToARRDailyHistory;
001059210306
001060210306                       //Output information to LELIBEPD
001061210301                       exsr writeToExtractFile;
001062210306
001063210301                       i = i + 1;
001064210306
001065210226                   enddo;
001066210224
001067210224       endsr;
001068210303       //*************************************************************
001069210303       /EJECT
001070210303       //*************************************************************
001071210303       //                                                            *
001072210303       // writeToARRDailyHistory - Write to ARR Daily Rates History  *
001073210303       // ======================                                     *
001074210303       //                                                            *
001075210303       // Called by: Output File                                     *
001076210303       //                                                            *
001077210303       // Calls: None                                                *
001078210303       //                                                            *
001079210303       //*************************************************************
001080210303
001081210303       begsr writeToARRDailyHistory;
001082210303
001083210305                   includeRecord = 'N';
001084210305
001085210305                   if (calcMethod = 'NCCR' or calcMethod  = 'SARR')
001086210305                   and  result.list(i).intPDMidas > transactDate;
001087210305                        includeRecord = 'Y';
001088210306
001089210305                   elseif  (calcMethod = 'CCR' or calcMethod  = 'SAVG');
001090210305                        includeRecord = 'Y';
001091210306
001092210305                   endif;
001093210305
001094210305                   fileToCheck = SDHSDRTD;
001095210305                   if includeRecord = 'Y';
001096210305                      exsr checkExist;
001097210305                      if action = INSERT;
001098210305                          exsr insertHistoryFile;
001099210305                      elseif action = UPDATE;
001100210305                          exsr updateHistoryFile;
001101210305                      endif;
001102210305                   endif;
001103210303
001104210303       endsr;
001105210303       //*************************************************************
001106210303       /EJECT
001107210303       //*************************************************************
001108210303       //                                                            *
001109210306       // checkExist - Check if a record exist on a given file       *
001110210303       // ==========                                                 *
001111210303       //                                                            *
001112210303       // Called by: Output File                                     *
001113210303       //                                                            *
001114210303       // Calls: None                                                *
001115210303       //                                                            *
001116210303       //*************************************************************
001117210303
001118210303       begsr checkExist;
001119210303
001120210303                   if fileToCheck = SDHSDRTD;
001121210303                        wSQLStr = 'select * from SDHSDRTD ' +
001122210303                                  'where CMODID = '  + QUO + moduleID + QUO +
001123210303                                  ' and CTRNID = ' + QUO + transactREF + QUO +
001124210303                                  ' and CMINPD = ' +
001125210303                                    %char(result.list(i).intPDMidas);
001126210303                   elseif fileToCheck = LELIBEPD;
001127210303                        wSQLStr = 'select * from LELIBEPD ' +
001128210303                                  'where LDLNRF = ' + QUO + transactREF + QUO +
001129210303                                  ' and LDVDAT = ' +
001130210303                                    %char(result.list(i).intPDMidas);
001131210303                   endif;
001132210303
001133210303                   exec sql prepare P1 from :wSQLStr;
001134210303                   exec sql open P1;
001135210303
001136210303                   if fileToCheck = SDHSDRTD;
001137210303                        exec sql fetch next From P1 into :DailyHistDS;
001138210303                   elseif fileToCheck = LELIBEPD;
001139210303                        exec sql fetch next From P1 into :ExtractFLDS;
001140210303                   endif;
001141210303
001142210303                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001143210312                         errorMessage = 'SQL ERROR ' + %char(sqlCod);
001144210312                         isError = true;
001145210312                         exsr errorHandler;
001146210303                   endif;
001147210303
001148210303                   if sqlCod = NO_RECORD;
001149210303                      action = INSERT;
001150210303                   else;
001151210303                      action = UPDATE;
001152210303                   endif;
001153210303                   exec sql close P1;
001154210303
001155210303       endsr;
001156210303       //*************************************************************
001157210303       /EJECT
001158210303       //*************************************************************
001159210303       //                                                            *
001160210303       // insertHistoryFile                                          *
001161210303       // =================                                          *
001162210303       //                                                            *
001163210303       // Called by: writeToARRDailyHistory                           *
001164210303       //                                                            *
001165210303       // Calls: None                                                *
001166210303       //                                                            *
001167210303       //*************************************************************
001168210303
001169210303       begsr insertHistoryFile;
001170210303
001171210303                   clear DailyHistDS;
001172210303                   DailyHistDS.CMODID = moduleID;
001173210303                   DailyHistDS.CTRNID = transactREF;
001174210304                   DailyHistDS.CCALCM = calcMethod;
001175210303                   DailyHistDS.CMINPD = result.list(i).intPDMidas;
001176210303                   DailyHistDS.CINPDT = result.list(i).intPrdYMD;
001177210303                   DailyHistDS.CINPDY = result.list(i).intPrdDays;
001178210303                   DailyHistDS.CMOBPD = result.list(i).intOPMidas;
001179210303                   DailyHistDS.COBPDT = result.list(i).intObsYMD;
001180210303                   DailyHistDS.CPBRFR = result.list(i).pubRskFrRt;
001181210305                   DailyHistDS.COBPDY = result.list(i).obsPrdDays;
001182210303                   DailyHistDS.CRTEAP = result.list(i).rateApplied;
001183210305                   if result.list(i).rskFrRtFlAp = 'true';
001184210305                     DailyHistDS.CRFRAP = 'Y';
001185210305                   else;
001186210305                     DailyHistDS.CRFRAP = 'N';
001187210305                   endif;
001188210303                   DailyHistDS.CTIMST = %timestamp();
001189210304
001190210303                   select;
001191210303                        when calcMethod = 'NCCR';
001192210304                             DailyHistDS.CDCMRT =
001193210303                               %Dec(Result.List(i).dlyCompRate:30:9);
001194210304                             DailyHistDS.CCMFAC =
001195210304                               %Dec(Result.List(i).compFactor:30:9);
001196210303                        when calcMethod = 'CCR';
001197210303                             DailyHistDS.CAVCRT =
001198210303                               %Dec(Result.List(i).aveCompRate:30:9);
001199210304                        when calcMethod = 'SAVG';
001200210304                             DailyHistDS.CSMPAV =
001201210304                               %Dec(Result.List(i).simpleAve:30:9);
001202210303                   endsl;
001203210303
001204210303                   exec sql insert into SDHSDRTD
001205210303                   values (:DailyHistDS);
001206210303
001207210304                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001208210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001209210312                      isError = true;
001210210312                      exsr errorHandler;
001211210303                   endif;
001212210303
001213210303       endsr;
001214210310
001215210303       //*************************************************************
001216210303       /EJECT
001217210303       //*************************************************************
001218210303       //                                                            *
001219210303       // insertExtractFile                                          *
001220210303       // =================                                          *
001221210303       //                                                            *
001222210303       // Called by: writeToHistoryFile                               *
001223210303       //                                                            *
001224210303       // Calls: None                                                *
001225210303       //                                                            *
001226210303       //*************************************************************
001227210303
001228210303       begsr insertExtractFile;
001229210303
001230210303                   clear ExtractFLDS;
001231210310                   clear compAveRate;
001232210303                   ExtractFLDS.LDLNRF = transactREF;
001233210303                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
001234210303
001235210303                   select;
001236210303                        when calcMethod = 'NCCR';
001237210310                             compAveRate =
001238210303                               %Dec(Result.List(i).dlyCompRate:30:9);
001239210303                        when calcMethod = 'CCR';
001240210310                             compAveRate =
001241210303                               %Dec(Result.List(i).aveCompRate:30:9);
001242210310                        when calcMethod = 'SARR';
001243210310                             compAveRate =
001244210310                               %Dec(Result.List(i).rateApplied:30:9);
001245210310                        when calcMethod = 'SAVG';
001246210310                             compAveRate =
001247210310                               %Dec(Result.List(i).simpleAve:30:9);
001248210303                   endsl;
001249210303
001250210310                   compAveRate += %dech(benchMarkAdj:13:9);
001251210310                   ExtractFLDS.LDCART =
001252210310                     %dech(compAveRate  :13 :8);
001253210310
001254210303                   exec sql insert into LELIBEPD
001255210303                   values (:ExtractFLDS);
001256210303
001257210304                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001258210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001259210312                      isError = true;
001260210312                      exsr errorHandler;
001261210303                   endif;
001262210303
001263210303       endsr;
001264210303       //*************************************************************
001265210303       /EJECT
001266210303       //*************************************************************
001267210303       //                                                            *
001268210303       // updateExtractFile                                          *
001269210303       // =================                                          *
001270210303       //                                                            *
001271210303       // Called by: writeToExtractFile                               *
001272210303       //                                                            *
001273210303       // Calls: None                                                *
001274210303       //                                                            *
001275210303       //*************************************************************
001276210303
001277210303       begsr updateExtractFile;
001278210304
001279210303                   clear ExtractFLDS;
001280210310                   clear compAveRate;
001281210303                   ExtractFLDS.LDLNRF = transactREF;
001282210303                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
001283210303
001284210310                   select;
001285210310                        when calcMethod = 'NCCR';
001286210310                             compAveRate =
001287210310                               %Dec(Result.List(i).dlyCompRate:30:9);
001288210310                        when calcMethod = 'CCR';
001289210310                             compAveRate =
001290210310                               %Dec(Result.List(i).aveCompRate:30:9);
001291210310                        when calcMethod = 'SARR';
001292210310                             compAveRate =
001293210310                               %Dec(Result.List(i).rateApplied:30:9);
001294210310                        when calcMethod = 'SAVG';
001295210310                             compAveRate =
001296210310                               %Dec(Result.List(i).simpleAve:30:9);
001297210310                   endsl;
001298210310
001299210310                   compAveRate += %dech(benchMarkAdj:13:9);
001300210310                   ExtractFLDS.LDCART =
001301210310                     %dech(compAveRate  :13 :8);
001302210303
001303210303                   wSqlStr = 'update LELIBEPD A '  +
001304210303                              'SET A.LDCART = ' + %Char(ExtractFLDS.LDCART) +
001305210303                              ' where A.LDLNRF = ' + QUO + ExtractFLDS.LDLNRF
001306210303                                 + QUO +
001307210303                              ' and   A.LDVDAT = ' +  %Char(ExtractFLDS.LDVDAT);
001308210303
001309210303                   exec sql
001310210303                   execute immediate :wSqlStr;
001311210303
001312210303                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001313210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001314210312                      isError = true;
001315210312                      exsr errorHandler;
001316210303                   endif;
001317210303
001318210303       endsr;
001319210303
001320210301       //*************************************************************
001321210301       /EJECT
001322210301       //*************************************************************
001323210301       //                                                            *
001324210301       // writeToExtractFile - Write to Extract File                 *
001325210301       // ==================                                         *
001326210301       //                                                            *
001327210301       // Called by: Output File                                     *
001328210301       //                                                            *
001329210301       // Calls: None                                                *
001330210301       //                                                            *
001331210301       //*************************************************************
001332210301
001333210301
001334210301       begsr writeToExtractFile;
001335210304
001336210303                   fileToCheck = LELIBEPD;
001337210303                   exsr checkExist;
001338210304
001339210303                   if action = INSERT;
001340210303                        exsr insertExtractFile;
001341210306
001342210303                   elseif action = UPDATE;
001343210303                        exsr updateExtractFile;
001344210306
001345210303                   endif;
001346210301
001347210304
001348210301       endsr;
001349210303       //*************************************************************
001350210303       /EJECT
001351210303       //*************************************************************
001352210303       //                                                            *
001353210303       // writeToAuditLog - Write to Audit Log                       *
001354210303       // ===============                                            *
001355210303       //                                                            *
001356210303       // Called by: Output File                                     *
001357210303       //                                                            *
001358210303       // Calls: None                                                *
001359210303       //                                                            *
001360210303       //*************************************************************
001361210303
001362210303
001363210303       begsr writeToAuditLog;
001364210312
001365210312                   if isException;
001366210312                       AuditLogDS.SJTMST = %timestamp();
001367210312                       AuditLogDS.SJTITL = result.errors.title;
001368210312                       AuditLogDS.SJEXMS = result.errors.exceptionMsg;
001369210312                       AuditLogDS.SJCODE = result.errors.status;
001370210312                       if AuditLogDS.SJCODE = '400';
001371210312                          logData = RestAPIParm;
001372210312                          returnCD = 'EXCEPTION_ERROR';
001373210312                         AuditLogDS.SJSTAT = 'F';
001374210312                       endif;
001376210312                   else;
001377210312                       if not(isError);
001378210312                           AuditLogDS.SJTMST = %timestamp();
001379210312                           AuditLogDS.SJTITL = 'ZAGETCALRT_SUCCESS';
001380210312                           AuditLogDS.SJEXMS = 'ARR Calculator completed' +
001381210312                             ' successfully';
001382210312                           AuditLogDS.SJCODE = '000';
001383210312                           returnCD = 'SUCCESS';
001384210312                           AuditLogDS.SJSTAT = 'C';
001385210312                           logData = %Trim(jsonData);
001386210312                       else;
001387210312                           returnCD = 'CONNECTION_ERROR';
001388210312                           logData = %Trim(errorMessage);
001389210312                           AuditLogDS.SJSTAT = 'F';
001390210312                       endif;
001391210312                   endif;
001392210312
001393210305                   exec sql insert into SDARRLOGTD
001394210305                   values (
001395210312                            : AuditLogDS.SJMODI,
001396210312                            : AuditLogDS.SJTREF,
001397210312                            : AuditLogDS.SJSTAT,
001398210312                            : AuditLogDS.SJTMST,
001399210312                            : AuditLogDS.SJTITL,
001400210312                            : AuditLogDS.SJEXMS,
001401210312                            : AuditLogDS.SJcode,
001402210312                            : logData
001403210305                          );
001404210305
001405210305                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001406210312                        AuditLogDS.SJTMST = %timestamp();
001407210312                        AuditLogDS.SJTITL = 'SDARRLOGTD';
001408210312                        AuditLogDS.SJEXMS = 'Error in access SDARRLOGTD';
001409210312                        AuditLogDS.SJCODE = '007';
001410210312                        isError = True;
001411210312                        exsr errorHandler;
001412210305                   endif;
001413210303
001414210303       endsr;
001415210224
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
001932210312                      isError = true;
001933210312                      exsr errorHandler;
001934210310                   endif;
001935210305
001936210305                  exec sql  update SDHSDRTD
001937210305                  set CMINPD = DailyHistDS.CMINPD
001938210305                  where CMODID = moduleID
001939210305                  and   CTRNID = transactREF;
001940210305
001941210306                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001943210312                        isError = true;
001947210312                        exsr errorHandler;
001948210305                   endif;
001949210305       endsr;
001950210310
001951210310       //*************************************************************
001952210310       /EJECT
001953210310       //*************************************************************
001954210310       //                                                            *
001955210312       //   errorHandler  - Program Error Processing Subroutine.            *
001956210310       //                                                            *
001957210310       //   Called By: Main Processing, various subroutines          *
001958210310       //                                                            *
001959210310       //*************************************************************
001960210310
001961210312       begsr *pssr;
001962210312                   *inu7 = *on;
001963210312                   *inu8 = *on;
001964210312                   *Inlr = *on;
001965210312                   dump;
001969210312                   return;
001973210310       endsr;
001974210312
001975210312       //*************************************************************
001976210312       /EJECT
001977210312       //*************************************************************
001978210312       //                                                            *
001979210312       //   errorHandler                                             *
001980210312       //                                                            *
001981210312       //   Called By: Main Processing, various subroutines          *
001982210312       //                                                            *
001983210312       //*************************************************************
001984210312
001985210312       begsr errorHandler;
001986210312
001987210312                   exsr writeToAuditLog;
001988210312                   *Inlr = *on;
001989210312                   return;
001990210312       endsr;
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
