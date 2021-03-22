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
000132210322      ** Scott Clements library for Parsing JSON Data
000133210322      ** and HTTP Calls
000134210306     D/INCLUDE LIBHTTP123/QRPGLESRC,YAJL_H
000135210319     D/INCLUDE LIBHTTP123/QRPGLESRC,HTTPAPI_H
000138210322
000139210222     D/COPY ZACPYSRC,PSDS
000140210222     D/COPY ZACPYSRC,STD_D_SPEC
000141210306     D/COPY ZSRSRC,ZINTDYZ1LE
000142210306     D/COPY ZSRSRC,ZHOLILE
000143210306     D/COPY ZSRSRC,ZHOLELE
000144210222
000145210222      ** +--------------------------------------+
000146210222      ** ¦ Program Prototypes                   ¦
000147210222      ** ¦ ==================                   ¦
000148210222      ** +--------------------------------------+
000149210304
000150210226     D ACCESS_SVAL     PR                  EXTPGM('AOSVALR0')
000151210226     D pRetCode                       7A
000152210226     D pOP01                         20A
000153210226     D pVL01                        200A
000154210226     D pOP02                         20A
000155210226     D pVL02                        200A
000156210226     D pOP03                         20A
000157210226     D pVL03                        200A
000158210226     D pOP04                         20A
000159210226     D pVL04                        200A
000160210226     D pOP05                         20A
000161210226     D pVL05                        200A
000162210226     D pOP06                         20A
000163210226     D pVL06                        200A
000164210226     D pOP07                         20A
000165210226     D pVL07                        200A
000166210226     D pOP08                         20A
000167210226     D pVL08                        200A
000168210226     D pOP09                         20A
000169210226     D pVL09                        200A
000170210226     D pOP10                         20A
000171210226     D pVL10                        200A
000172210301
000173210301     D  ACCESS_SDBANK  pr                  extpgm('AOBANKR0')
000174210301     D    pReturnCode                 7A
000175210301     D    pOption                     7A
000176210301     D    pDSFDY                    200A
000177210304
000178210301     D  CONVERT_DATE   pr                  extpgm('ZDATE1')
000179210301     D    ErrorFlag                   7a
000180210301     D    DateIN                      6p 0
000181210301     D    DateInd                     1a
000182210301     D    DateOUT                     5p 0
000183210301
000184210222      *  +----------------+
000185210222      ** |Parameter lists |
000186210222      ** +----------------+
000187210222
000188210222     D Main            pr                  extpgm('ZAGETCALRT')
000189210301      **-----------------------------------------------------**
000190210301     D  moduleID                      2a
000191210301      ** Module ID
000192210301      **--** LE - Lending
000193210301      **--** DL - Dealing
000194210301      **--** FR - FRA/IRS
000195210301     D  transactREF                   6a
000196210301      ** Transaction Reference
000197210226     D  calcMethod                    4a
000198210301      ** Calculation Method
000199210301      **--** NCCR - Daily Compounding in Arrears (Non-Cumulative Compounded Rate)
000200210301      **--** CCR  - Average Compounded In Arrears (Cumulative Compounded Rate)
000201210301      **--** SARR - Simple Average
000202210301      **--** SAVG - Simple Average
000203210224     D  intPrdStartDt                10a
000204210224      ** Interest Period Start Date
000205210224     D  intPrdEndDt                  10a
000206210224      ** Interest Period End Date
000207210310     D  riskFreeRate                  5a
000208210224      ** Risk Free Rate
000209210226     D  riskFreeRatFl                20a
000210210224      ** Risk Free Rate Floor
000211210226     D  lookBackDays                  2a
000212210224      ** Lookback Days
000213210301     D  obserPrdShift                 5a
000214210224      ** Observation Period Shift
000215210301      ** True/False
000216210226     D  RateRndDecPts                 3a
000217210224      ** Rate Rounding Decimal Points
000218210303     D  dayCntConvent                 7a
000219210224      ** Day Count Convention
000220210226     D  lockOutDays                   2a
000221210224      ** Lockout Days
000222210301     D  showDailyDeta                 5a
000223210224      ** Show Dailty Details
000224210301      ** True/False
000225210224     D  callTillDate                 10a
000226210224      ** Calculate Till Date
000227210310     D  benchMarkAdj                 20a
000228210305      ** Benchmark Adjustment
000229210312     D  returnCD                     20a
000230210312      ** Return Code
000231210222
000232210222     D Main            pi
000233210301      **-----------------------------------------------------**
000234210301     D  moduleID                      2a
000235210301      ** Module ID
000236210301      **--** LE - Lending
000237210301      **--** DL - Dealing
000238210301      **--** FR - FRA/IRS
000239210301     D  transactREF                   6a
000240210301      ** Transaction Reference
000241210226     D  calcMethod                    4a
000242210226      ** Calculation Method
000243210301      **--** NCCR - Daily Compounding in Arrears (Non-Cumulative Compounded Rate)
000244210301      **--** CCR  - Average Compounded In Arrears (Cumulative Compounded Rate)
000245210301      **--** SARR - Simple Average
000246210301      **--** SAVG - Simple Average
000247210226     D  intPrdStartDt                10a
000248210226      ** Interest Period Start Date
000249210226     D  intPrdEndDt                  10a
000250210226      ** Interest Period End Date
000251210310     D  riskFreeRate                  5a
000252210226      ** Risk Free Rate
000253210226     D  riskFreeRatFl                20a
000254210226      ** Risk Free Rate Floor
000255210226     D  lookBackDays                  2a
000256210226      ** Lookback Days
000257210301     D  obserPrdShift                 5a
000258210226      ** Observation Period Shift
000259210301      ** True/False
000260210226     D  RateRndDecPts                 3a
000261210226      ** Rate Rounding Decimal Points
000262210303     D  dayCntConvent                 7a
000263210226      ** Day Count Convention
000264210226     D  lockOutDays                   2a
000265210226      ** Lockout Days
000266210301     D  showDailyDeta                 5a
000267210226      ** Show Dailty Details
000268210301      ** True/False
000269210226     D  callTillDate                 10a
000270210226      ** Calculate Till Date
000271210310     D  benchMarkAdj                 20a
000272210305      ** Benchmark Adjustment
000273210312     D  returnCD                     20a
000274210312      ** Return Code
000275210224
000276210222      ** +--------------------------------------+
000277210222      ** ¦ Manually included D-specs            ¦
000278210222      ** ¦ =========================            ¦
000279210222      ** +--------------------------------------+
000280210310      ** +--------------------------------------+
000281210303
000282210318      ** Extract file for LE0370 consumption and BR event creation
000283210301     D LELIBEDS      e ds                  extname(LELIBEPD)
000284210301     D ExtractFLDS     ds                  likeds(LELIBEDS)
000285210303
000286210303      ** Audit Log
000287210303     D SDARRLDS      e ds                  extname(SDARRLOGTD)
000288210312     D AuditLogDS      ds                  likeds(SDARRLDS)
000289210303
000290210303      ** ARR Daily Rates History File
000291210303     D ARRDLYDS      e ds                  extname(SDHSDRTD)
000292210303     D DailyHistDS     ds                  likeds(ARRDLYDS)
000293210303
000294210318      ** Core data structures
000295210318     D dssdy         e ds                  extname(DSSDY)
000296210222     D dsfdy         e ds                  extname(DSFDY)
000297210222
000298210222      ** +--------------------------------------+
000299210222      ** ¦ Constants declaration                ¦
000300210222      ** ¦ =====================                ¦
000301210222      ** +--------------------------------------+
000302210304
000303210304     D AMP             c                   const('&')
000304210315     D HTTP_HEAD       c                   const('http://')
000305210304     D INSERT          c                   const(0)
000306210304     D LELIBEPD        c                   const(1)
000307210301     D NO_ERROR        c                   const(0)
000308210301     D NO_RECORD       c                   const(100)
000309210315     D QUE             c                   const('?')
000310210301     D QUO             c                   const('''')
000312210304     D SDHSDRTD        c                   const(0)
000315210303     D UPDATE          c                   const(1)
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
000658210315                             ' order by CMINPD DESC';
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
000754210318                   RestAPIParm =    %trim(CalcMetURL) +
000755210305                                 QUE + 'interestPeriodStartDate=' +
000756210318                                    %trim(intPrdStartDt) +
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
000805210315                 isError = True;
000806210315                 AuditLogDS.SJTMST = %timestamp();
000807210315                 AuditLogDS.SJTITL = 'ZAGETCALRT_ERROR';
000808210315                 AuditLogDS.SJEXMS = %trim(msg);
000809210315                 AuditLogDS.SJCODE = '999';
000812210312                 exsr errorHandler;
000813210310
000814210304              endmon;
000815210224
000816210224       endsr;
000817210224
000818210224       //*************************************************************
000819210224       /EJECT
000820210224       //*************************************************************
000821210224       //                                                            *
000822210224       // parseJSONData - Parse JSON Data                            *
000823210224       // =============                                              *
000824210224       //                                                            *
000825210224       // Called by: processTransaction                              *
000826210224       //                                                            *
000827210224       // Calls: None                                                *
000828210224       //                                                            *
000829210224       //*************************************************************
000830210224
000831210224       begsr parseJSONData;
000832210304
000833210306                   // Load JSON data variable into a tree like structure
000834210306
000835210304                   docNode = yajl_buf_load_tree( %addr(jsonData:*data)
000836210304                             : %len(jsonData)
000837210304                             : ErrMsg );
000838210304
000839210304                   if errMsg <> '';
000840210305                      errorMessage = errMsg;
000841210312                      isError = true;
000842210312                      exsr errorHandler;
000843210304                   endif;
000844210304
000845210304                   node = YAJL_object_find(docNode: 'comment');
000846210304                   result.comment = YAJL_get_string(node);
000847210226
000848210311                   node = YAJL_object_find(docNode: 'errmsg');
000849210311                   result.errmsg  = yajl_get_string(val);
000850210311
000851210312                   // Exception messages
000852210311                   node = YAJL_object_find(docNode: 'exception');
000853210311                   if node <> *null;
000854210312                       isException = true;
000855210311                       val = YAJL_object_find(node: 'title');
000856210311                       result.errors.title = yajl_get_string(val);
000857210311
000858210311                       val = YAJL_object_find(node: 'exceptionMessage');
000859210311                       result.errors.exceptionMsg = yajl_get_string(val);
000860210311
000861210311                       val = YAJL_object_find(node: 'status');
000862210311                       result.errors.status = yajl_get_string(val);
000863210312
000864210312                       // free up memory used by YAJL
000865210312                       yajl_tree_free(docNode);
000866210312
000867210312                       exsr errorHandler;
000868210312
000869210311                   endif;
000870210311
000871210311
000872210304                   list = YAJL_object_find(docNode: 'dailyRateSummary');
000873210306
000874210305                   clear result.list;
000875210306
000876210304                   i = 0;
000877210304                   dow YAJL_ARRAY_LOOP( list: i: node );
000878210226
000879210226                       lastElem = i;
000880210226
000881210303                       // All calculation methods
000882210226                       val = YAJL_object_find(node: 'interestPeriodDate');
000883210226                       result.list(i).intPrdDate = yajl_get_string(val);
000884210301
000885210301                       ISODate =  result.list(i).intPrdDate;
000886210303
000887210310                       monitor;
000888210315
000889210310                           WKY = %editc(wkYear:'X');
000890210310                           WKM = %editc(wkMonth:'X');
000891210310                           WKD = %editc(wkDay:'X');
000892210303
000893210310                           result.list(i).intPrdYMD  = YYMMDD;
000894210301
000895210310                           if BJDFIN = 'D';
000896210310                              DD1D = wkDay;
000897210310                              DD1M = wkMonth;
000898210310                              DD1Y = wkYear;
000899210310                              DateIn = DateIn_D;
000900210310                           else;
000901210310                              DD2D = wkDay;
000902210310                              DD2M = wkMonth;
000903210310                              DD2Y = wkYear;
000904210310                              DateIn = DateIn_M;
000905210310                           endif;
000906210310
000907210310                           pOption = '*FIRST';
000908210310                           pReturnCode = *Blanks;
000909210310                           callp CONVERT_DATE(
000910210310                                      ErrorFlag
000911210310                                    : DateIN
000912210310                                    : BJDFIN
000913210310                                    : DateOUT
000914210310                                   );
000915210301
000916210310                           if ErrorFlag   <> *blanks;
000917210312                                AuditLogDS.SJTMST = %timestamp();
000918210312                                AuditLogDS.SJTITL = 'ZDATE1';
000919210312                                AuditLogDS.SJEXMS = 'Error in date conversion';
000920210312                                AuditLogDS.SJCODE = '005';
000921210312                                isError = True;
000922210312                                exsr errorHandler;
000923210310                           endif;
000924210310                           result.list(i).intPDMidas = DateOUT;
000925210312
000926210310                       on-error;
000927210310                       endmon;
000928210310
000929210303                       // All calculation methods
000930210226                       val = YAJL_object_find(node: 'interestPeriodDays');
000931210305                       cStr      =  yajl_get_string(val);
000932210305                       result.list(i).intPrdDays =  %dec(%trim(cStr):2:0);
000933210226
000934210310                       val =
000935210310                          YAJL_object_find(node: 'observationPeriodDate');
000936210310                       result.list(i).obsPrdDate =
000937210310                          yajl_get_string(val);
000938210303
000939210310                       ISODate =  result.list(i).obsPrdDate;
000940210310
000941210310                       monitor;
000942210303                            WKY = %editc(wkYear:'X');
000943210303                            WKM = %editc(wkMonth:'X');
000944210303                            WKD = %editc(wkDay:'X');
000945210303
000946210303                            result.list(i).intObsYMD  = YYMMDD;
000947210303
000948210303                            if BJDFIN = 'D';
000949210303                                 DD1D = wkDay;
000950210303                                 DD1M = wkMonth;
000951210303                                 DD1Y = wkYear;
000952210303                                 DateIn = DateIn_D;
000953210303                            else;
000954210303                                 DD2D = wkDay;
000955210303                                 DD2M = wkMonth;
000956210303                                 DD2Y = wkYear;
000957210303                                 DateIn = DateIn_M;
000958210303                             endif;
000959210303
000960210303                             pOption = '*FIRST';
000961210303                             pReturnCode = *Blanks;
000962210303                             callp CONVERT_DATE(
000963210303                                  ErrorFlag
000964210303                                : DateIN
000965210303                                : BJDFIN
000966210303                                : DateOUT
000967210303                               );
000968210303
000969210303                             if ErrorFlag   <> *blanks;
000970210312                                AuditLogDS.SJTMST = %timestamp();
000971210312                                AuditLogDS.SJTITL = 'ZDATE1';
000972210312                                AuditLogDS.SJEXMS = 'Error in date conversion';
000973210312                                AuditLogDS.SJCODE = '005';
000974210312                                isError = True;
000975210312                                exsr errorHandler;
000976210303                             endif;
000977210303
000978210303                             result.list(i).intOPMidas = DateOUT;
000979210310                       on-error;
000980210310                       endmon;
000981210310
000982210310                       val =
000983210310                           YAJL_object_find(node: 'observationPeriodDays');
000984210310
000985210310                       monitor;
000986210315                           cStr =  yajl_get_string(val);
000987210310                              result.list(i).obsPrdDays =
000988210310                              %dec(%trim(cStr):2:0);
000989210310                       on-error;
000990210310                       endmon;
000991210303
000992210303                       // All calculation methods
000993210303                       val = YAJL_object_find(node: 'publishedRiskFreeRate');
000994210305
000995210305                       cStr  =  yajl_get_string(val);
000996210305                       result.list(i).pubRskFrRt =  %dec(%trim(cStr):30:9  );
000997210303
000998210303                       // All calculation methods
000999210303                       val = YAJL_object_find(node: 'rateApplied');
001000210305                       cStr  =  yajl_get_string(val);
001001210305                       result.list(i).rateApplied =  %dec(%trim(cStr):30:9  );
001002210226
001003210303                       // All calculation methods
001004210226                       val = YAJL_object_find(node: 'riskFreeRateFloorApplied');
001005210226                       if YAJL_is_true(node);
001006210226                           result.list(i).rskFrRtFlAp=  'True';
001007210226                       else;
001008210226                           result.list(i).rskFrRtFlAp=  'False';
001009210226                       endif;
001010210226
001011210310                       if calcMethod = 'NCCR';
001012210310                            val = YAJL_object_find(node: 'compoundingFactor');
001013210310                            result.list(i).compFactor=  yajl_get_string(val);
001014210226
001015210310                            val =
001016210310                              YAJL_object_find(node: 'dailyCompoundedRate');
001017210310                            result.list(i).dlyCompRate =
001018210310                              yajl_get_string(val);
001019210310                       endif;
001020210303
001021210310                       if calcMethod = 'CCR';
001022210310                            val =
001023210310                              YAJL_object_find(node: 'averageCompoundedRate');
001024210310                            result.list(i).aveCompRate =  yajl_get_string(val);
001025210303
001026210310                       endif;
001027210303
001028210310                       if calcMethod = 'SAVG';
001029210310                            val =
001030210310                              YAJL_object_find(node: 'simpleAverageRate');
001031210310                            result.list(i).simpleAve =  yajl_get_string(val);
001032210303
001033210310                       endif;
001034210303
001035210304                   enddo;
001036210226
001037210304                   // free up memory used by YAJL
001038210304                   yajl_tree_free(docNode);
001039210224
001040210224       endsr;
001041210224
001042210224       //*************************************************************
001043210224       /EJECT
001044210224       //*************************************************************
001045210224       //                                                            *
001046210301       // outputFile - Output Files                                  *
001047210301       // ==========                                                 *
001048210224       //                                                            *
001049210224       // Called by: processTransaction                              *
001050210224       //                                                            *
001051210224       // Calls: None                                                *
001052210224       //                                                            *
001053210224       //*************************************************************
001054210224
001055210301       begsr outputFiles;
001056210305
001057210226                   i = 1;
001058210306
001059210226                   dow i <= lastElem;
001060210306
001061210306                       // Output information to SDARRLOGTD
001062210303                       exsr writeToARRDailyHistory;
001063210306
001064210306                       //Output information to LELIBEPD
001065210301                       exsr writeToExtractFile;
001066210306
001067210301                       i = i + 1;
001068210306
001069210226                   enddo;
001070210224
001071210224       endsr;
001072210303       //*************************************************************
001073210303       /EJECT
001074210303       //*************************************************************
001075210303       //                                                            *
001076210303       // writeToARRDailyHistory - Write to ARR Daily Rates History  *
001077210303       // ======================                                     *
001078210303       //                                                            *
001079210303       // Called by: Output File                                     *
001080210303       //                                                            *
001081210303       // Calls: None                                                *
001082210303       //                                                            *
001083210303       //*************************************************************
001084210303
001085210303       begsr writeToARRDailyHistory;
001086210303
001087210305                   includeRecord = 'N';
001088210305
001089210305                   if (calcMethod = 'NCCR' or calcMethod  = 'SARR')
001090210305                   and  result.list(i).intPDMidas > transactDate;
001091210305                        includeRecord = 'Y';
001092210306
001093210305                   elseif  (calcMethod = 'CCR' or calcMethod  = 'SAVG');
001094210305                        includeRecord = 'Y';
001095210306
001096210305                   endif;
001097210305
001098210305                   fileToCheck = SDHSDRTD;
001099210305                   if includeRecord = 'Y';
001100210305                      exsr checkExist;
001101210305                      if action = INSERT;
001102210305                          exsr insertHistoryFile;
001103210305                      elseif action = UPDATE;
001104210305                          exsr updateHistoryFile;
001105210305                      endif;
001106210305                   endif;
001107210303
001108210303       endsr;
001109210303       //*************************************************************
001110210303       /EJECT
001111210303       //*************************************************************
001112210303       //                                                            *
001113210306       // checkExist - Check if a record exist on a given file       *
001114210303       // ==========                                                 *
001115210303       //                                                            *
001116210303       // Called by: Output File                                     *
001117210303       //                                                            *
001118210303       // Calls: None                                                *
001119210303       //                                                            *
001120210303       //*************************************************************
001121210303
001122210303       begsr checkExist;
001123210303
001124210303                   if fileToCheck = SDHSDRTD;
001125210303                        wSQLStr = 'select * from SDHSDRTD ' +
001126210303                                  'where CMODID = '  + QUO + moduleID + QUO +
001127210303                                  ' and CTRNID = ' + QUO + transactREF + QUO +
001128210303                                  ' and CMINPD = ' +
001129210303                                    %char(result.list(i).intPDMidas);
001130210303                   elseif fileToCheck = LELIBEPD;
001131210303                        wSQLStr = 'select * from LELIBEPD ' +
001132210303                                  'where LDLNRF = ' + QUO + transactREF + QUO +
001133210303                                  ' and LDVDAT = ' +
001134210303                                    %char(result.list(i).intPDMidas);
001135210303                   endif;
001136210303
001137210303                   exec sql prepare P1 from :wSQLStr;
001138210303                   exec sql open P1;
001139210303
001140210303                   if fileToCheck = SDHSDRTD;
001141210303                        exec sql fetch next From P1 into :DailyHistDS;
001142210303                   elseif fileToCheck = LELIBEPD;
001143210303                        exec sql fetch next From P1 into :ExtractFLDS;
001144210303                   endif;
001145210303
001146210303                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001147210312                         errorMessage = 'SQL ERROR ' + %char(sqlCod);
001148210312                         isError = true;
001149210312                         exsr errorHandler;
001150210303                   endif;
001151210303
001152210303                   if sqlCod = NO_RECORD;
001153210303                      action = INSERT;
001154210303                   else;
001155210303                      action = UPDATE;
001156210303                   endif;
001157210303                   exec sql close P1;
001158210303
001159210303       endsr;
001160210303       //*************************************************************
001161210303       /EJECT
001162210303       //*************************************************************
001163210303       //                                                            *
001164210303       // insertHistoryFile                                          *
001165210303       // =================                                          *
001166210303       //                                                            *
001167210303       // Called by: writeToARRDailyHistory                           *
001168210303       //                                                            *
001169210303       // Calls: None                                                *
001170210303       //                                                            *
001171210303       //*************************************************************
001172210303
001173210303       begsr insertHistoryFile;
001174210303
001175210303                   clear DailyHistDS;
001176210303                   DailyHistDS.CMODID = moduleID;
001177210303                   DailyHistDS.CTRNID = transactREF;
001178210304                   DailyHistDS.CCALCM = calcMethod;
001179210303                   DailyHistDS.CMINPD = result.list(i).intPDMidas;
001180210303                   DailyHistDS.CINPDT = result.list(i).intPrdYMD;
001181210303                   DailyHistDS.CINPDY = result.list(i).intPrdDays;
001182210303                   DailyHistDS.CMOBPD = result.list(i).intOPMidas;
001183210303                   DailyHistDS.COBPDT = result.list(i).intObsYMD;
001184210303                   DailyHistDS.CPBRFR = result.list(i).pubRskFrRt;
001185210305                   DailyHistDS.COBPDY = result.list(i).obsPrdDays;
001186210303                   DailyHistDS.CRTEAP = result.list(i).rateApplied;
001187210305                   if result.list(i).rskFrRtFlAp = 'true';
001188210315                      DailyHistDS.CRFRAP = 'Y';
001189210305                   else;
001190210315                      DailyHistDS.CRFRAP = 'N';
001191210305                   endif;
001192210303                   DailyHistDS.CTIMST = %timestamp();
001193210304
001194210303                   select;
001195210303                        when calcMethod = 'NCCR';
001196210304                             DailyHistDS.CDCMRT =
001197210303                               %Dec(Result.List(i).dlyCompRate:30:9);
001198210304                             DailyHistDS.CCMFAC =
001199210304                               %Dec(Result.List(i).compFactor:30:9);
001200210303                        when calcMethod = 'CCR';
001201210303                             DailyHistDS.CAVCRT =
001202210303                               %Dec(Result.List(i).aveCompRate:30:9);
001203210304                        when calcMethod = 'SAVG';
001204210304                             DailyHistDS.CSMPAV =
001205210304                               %Dec(Result.List(i).simpleAve:30:9);
001206210303                   endsl;
001207210303
001208210303                   exec sql insert into SDHSDRTD
001209210303                   values (:DailyHistDS);
001210210303
001211210304                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001212210315                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001213210312                      isError = true;
001214210312                      exsr errorHandler;
001215210303                   endif;
001216210303
001217210303       endsr;
001218210310
001219210303       //*************************************************************
001220210303       /EJECT
001221210303       //*************************************************************
001222210303       //                                                            *
001223210303       // insertExtractFile                                          *
001224210303       // =================                                          *
001225210303       //                                                            *
001226210303       // Called by: writeToHistoryFile                               *
001227210303       //                                                            *
001228210303       // Calls: None                                                *
001229210303       //                                                            *
001230210303       //*************************************************************
001231210303
001232210303       begsr insertExtractFile;
001233210303
001234210303                   clear ExtractFLDS;
001235210310                   clear compAveRate;
001236210303                   ExtractFLDS.LDLNRF = transactREF;
001237210303                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
001238210303
001239210303                   select;
001240210303                        when calcMethod = 'NCCR';
001241210310                             compAveRate =
001242210303                               %Dec(Result.List(i).dlyCompRate:30:9);
001243210303                        when calcMethod = 'CCR';
001244210310                             compAveRate =
001245210303                               %Dec(Result.List(i).aveCompRate:30:9);
001246210310                        when calcMethod = 'SARR';
001247210310                             compAveRate =
001248210310                               %Dec(Result.List(i).rateApplied:30:9);
001249210310                        when calcMethod = 'SAVG';
001250210310                             compAveRate =
001251210310                               %Dec(Result.List(i).simpleAve:30:9);
001252210303                   endsl;
001253210303
001254210310                   compAveRate += %dech(benchMarkAdj:13:9);
001255210310                   ExtractFLDS.LDCART =
001256210315                     %dech(compAveRate  :13 :9);
001257210310
001258210303                   exec sql insert into LELIBEPD
001259210303                   values (:ExtractFLDS);
001260210303
001261210304                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001262210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001263210312                      isError = true;
001264210312                      exsr errorHandler;
001265210303                   endif;
001266210303
001267210303       endsr;
001268210303       //*************************************************************
001269210303       /EJECT
001270210303       //*************************************************************
001271210303       //                                                            *
001272210303       // updateExtractFile                                          *
001273210303       // =================                                          *
001274210303       //                                                            *
001275210303       // Called by: writeToExtractFile                               *
001276210303       //                                                            *
001277210303       // Calls: None                                                *
001278210303       //                                                            *
001279210303       //*************************************************************
001280210303
001281210303       begsr updateExtractFile;
001282210304
001283210303                   clear ExtractFLDS;
001284210310                   clear compAveRate;
001285210303                   ExtractFLDS.LDLNRF = transactREF;
001286210303                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
001287210303
001288210310                   select;
001289210310                        when calcMethod = 'NCCR';
001290210310                             compAveRate =
001291210310                               %Dec(Result.List(i).dlyCompRate:30:9);
001292210310                        when calcMethod = 'CCR';
001293210310                             compAveRate =
001294210310                               %Dec(Result.List(i).aveCompRate:30:9);
001295210310                        when calcMethod = 'SARR';
001296210310                             compAveRate =
001297210310                               %Dec(Result.List(i).rateApplied:30:9);
001298210310                        when calcMethod = 'SAVG';
001299210310                             compAveRate =
001300210310                               %Dec(Result.List(i).simpleAve:30:9);
001301210310                   endsl;
001302210310
001303210310                   compAveRate += %dech(benchMarkAdj:13:9);
001304210310                   ExtractFLDS.LDCART =
001305210315                     %dech(compAveRate  :13 :9);
001306210303
001307210303                   wSqlStr = 'update LELIBEPD A '  +
001308210303                              'SET A.LDCART = ' + %Char(ExtractFLDS.LDCART) +
001309210303                              ' where A.LDLNRF = ' + QUO + ExtractFLDS.LDLNRF
001310210303                                 + QUO +
001311210303                              ' and   A.LDVDAT = ' +  %Char(ExtractFLDS.LDVDAT);
001312210303
001313210303                   exec sql
001314210303                   execute immediate :wSqlStr;
001315210303
001316210303                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001317210305                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001318210312                      isError = true;
001319210312                      exsr errorHandler;
001320210303                   endif;
001321210303
001322210303       endsr;
001323210303
001324210301       //*************************************************************
001325210301       /EJECT
001326210301       //*************************************************************
001327210301       //                                                            *
001328210301       // writeToExtractFile - Write to Extract File                 *
001329210301       // ==================                                         *
001330210301       //                                                            *
001331210301       // Called by: Output File                                     *
001332210301       //                                                            *
001333210301       // Calls: None                                                *
001334210301       //                                                            *
001335210301       //*************************************************************
001336210301
001337210301
001338210301       begsr writeToExtractFile;
001339210304
001340210303                   fileToCheck = LELIBEPD;
001341210303                   exsr checkExist;
001342210304
001343210303                   if action = INSERT;
001344210303                        exsr insertExtractFile;
001345210306
001346210303                   elseif action = UPDATE;
001347210303                        exsr updateExtractFile;
001348210306
001349210303                   endif;
001350210301
001351210304
001352210301       endsr;
001353210303       //*************************************************************
001354210303       /EJECT
001355210303       //*************************************************************
001356210303       //                                                            *
001357210303       // writeToAuditLog - Write to Audit Log                       *
001358210303       // ===============                                            *
001359210303       //                                                            *
001360210303       // Called by: Output File                                     *
001361210303       //                                                            *
001362210303       // Calls: None                                                *
001363210303       //                                                            *
001364210303       //*************************************************************
001365210303
001366210303
001367210303       begsr writeToAuditLog;
001368210312
001369210312                   if isException;
001370210312                       AuditLogDS.SJTMST = %timestamp();
001371210312                       AuditLogDS.SJTITL = result.errors.title;
001372210312                       AuditLogDS.SJEXMS = result.errors.exceptionMsg;
001373210312                       AuditLogDS.SJCODE = result.errors.status;
001374210312                       if AuditLogDS.SJCODE = '400';
001375210315                          logData = RestAPIParm;
001376210312                          returnCD = 'EXCEPTION_ERROR';
001377210315                          AuditLogDS.SJSTAT = 'F';
001378210312                       endif;
001379210312                   else;
001380210312                       if not(isError);
001381210315                          AuditLogDS.SJTMST = %timestamp();
001382210315                          AuditLogDS.SJTITL = 'ZAGETCALRT_SUCCESS';
001383210315                          AuditLogDS.SJEXMS = 'ARR Calculator completed' +
001384210312                             ' successfully';
001385210315                          AuditLogDS.SJCODE = '000';
001386210315                          returnCD = 'SUCCESS';
001387210315                          AuditLogDS.SJSTAT = 'C';
001388210315                          logData = %Trim(jsonData);
001389210312                       else;
001393210315                          logData = %Trim(errorMessage);
001394210315                          AuditLogDS.SJSTAT = 'F';
001395210312                       endif;
001396210312                   endif;
001397210312
001398210305                   exec sql insert into SDARRLOGTD
001399210305                   values (
001400210312                            : AuditLogDS.SJMODI,
001401210312                            : AuditLogDS.SJTREF,
001402210312                            : AuditLogDS.SJSTAT,
001403210312                            : AuditLogDS.SJTMST,
001404210312                            : AuditLogDS.SJTITL,
001405210312                            : AuditLogDS.SJEXMS,
001406210312                            : AuditLogDS.SJcode,
001407210312                            : logData
001408210305                          );
001409210305
001410210305                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001411210312                        AuditLogDS.SJTMST = %timestamp();
001412210312                        AuditLogDS.SJTITL = 'SDARRLOGTD';
001413210312                        AuditLogDS.SJEXMS = 'Error in access SDARRLOGTD';
001414210312                        AuditLogDS.SJCODE = '007';
001415210312                        isError = True;
001416210312                        exsr errorHandler;
001417210305                   endif;
001418210303
001419210303       endsr;
001420210224
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
001851210315                      DailyHistDS.CRFRAP = 'Y';
001852210310                   else;
001853210315                      DailyHistDS.CRFRAP = 'N';
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
