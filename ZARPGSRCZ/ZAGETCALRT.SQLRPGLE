000100210326     H DEBUG
000101210326     H DFTACTGRP(*NO) BNDDIR('HTTPAPI') BNDDIR('YAJL')
000102210326     H COPYRIGHT('(c) Finastra International Limited 2020')
000103210326      *****************************************************************
000104210326/*STD *  RPGSQLBND                                                    *
000105210326/*EXI *  TEXT('Midas SD API - Invoke ARR Calculator')                 *
000106210326      *****************************************************************
000107210326      *                                                               *
000108210326      *  Midas - Midas Standing Data API - Invoke ARR Calculator      *
000109210326      *                                                               *
000110210326      *  ZAGETCALRT Midas API - Invoke ARR Calculator                 *
000111210326      *                                                               *
000112210326      *  (c) Finastra International Limited 2020                      *
000113210326      *                                                               *
000114210326      *  Prev Amend No. CSD103  *CREATE    Date 10Aug20               *
000115210326      *                                                               *
000116210326      *****************************************************************
000117210326      *                                                               *
000118210326      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
000119210326      *                                                               *
000120210326      *****************************************************************
000121210326
000122210326      **---------------------------------------------------------------
000123210326      ** The following /COPY line includes all the defined fields in
000124210326      ** the Program Status Data Structures.  They have meaningful
000125210326      ** names, prefixed by 'PS'.
000126210326
000127210326      *
000128210326      ** Scott Clements library for JSON Parse and HTTP calls
000129210326     D/INCLUDE LIBHTTP123/QRPGLESRC,YAJL_H
000130210326     D/INCLUDE LIBHTTP123/QRPGLESRC,HTTPAPI_H
000131210326
000132210326     D/COPY ZACPYSRC,PSDS
000133210326     D/COPY ZACPYSRC,STD_D_SPEC
000134210326     D/COPY ZSRSRC,ZINTDYZ1LE
000135210326     D/COPY ZSRSRC,ZHOLILE
000136210326     D/COPY ZSRSRC,ZHOLELE
000137210326
000138210326      ** +--------------------------------------+
000139210326      ** ¦ Program Prototypes                   ¦
000140210326      ** ¦ ==================                   ¦
000141210326      ** +--------------------------------------+
000142210326
000143210326     D ACCESS_SVAL     PR                  EXTPGM('AOSVALR0')
000144210326     D pRetCode                       7A
000145210326     D pOP01                         20A
000146210326     D pVL01                        200A
000147210326     D pOP02                         20A
000148210326     D pVL02                        200A
000149210326     D pOP03                         20A
000150210326     D pVL03                        200A
000151210326     D pOP04                         20A
000152210326     D pVL04                        200A
000153210326     D pOP05                         20A
000154210326     D pVL05                        200A
000155210326     D pOP06                         20A
000156210326     D pVL06                        200A
000157210326     D pOP07                         20A
000158210326     D pVL07                        200A
000159210326     D pOP08                         20A
000160210326     D pVL08                        200A
000161210326     D pOP09                         20A
000162210326     D pVL09                        200A
000163210326     D pOP10                         20A
000164210326     D pVL10                        200A
000165210326
000166210326     D  ACCESS_SDBANK  pr                  extpgm('AOBANKR0')
000167210326     D    pReturnCode                 7A
000168210326     D    pOption                     7A
000169210326     D    pDSFDY                    200A
000170210326
000171210326     D  CONVERT_DATE   pr                  extpgm('ZDATE1')
000172210326     D    ErrorFlag                   7a
000173210326     D    DateIN                      6p 0
000174210326     D    DateInd                     1a
000175210326     D    DateOUT                     5p 0
000176210326
000177210326      *  +----------------+
000178210326      ** |Parameter lists |
000179210326      ** +----------------+
000180210326
000181210326     D Main            pr                  extpgm('ZAGETCALRT')
000182210326      **-----------------------------------------------------**
000183210326     D  moduleID                      2a
000184210326      ** Module ID
000185210326      **--** LE - Lending
000186210326      **--** DL - Dealing
000187210326      **--** FR - FRA/IRS
000188210326     D  transactREF                   6a
000189210326      ** Transaction Reference
000190210326     D  calcMethod                    4a
000191210326      ** Calculation Method
000192210326      **--** NCCR - Daily Compounding in Arrears (Non-Cumulative Compounded Rate)
000193210326      **--** CCR  - Average Compounded In Arrears (Cumulative Compounded Rate)
000194210326      **--** SARR - Simple ARR
000195210326      **--** SAVG - Simple Average
000196210326     D  intPrdStartDt                10a
000197210326      ** Interest Period Start Date
000198210326     D  intPrdEndDt                  10a
000199210326      ** Interest Period End Date
000200210326     D  riskFreeRate                  5a
000201210326      ** Risk Free Rate
000202210326     D  riskFreeRatFl                20a
000203210326      ** Risk Free Rate Floor
000204210326     D  lookBackDays                  2a
000205210326      ** Lookback Days
000206210326     D  obserPrdShift                 5a
000207210326      ** Observation Period Shift
000208210326      ** True/False
000209210326     D  RateRndDecPts                 3a
000210210326      ** Rate Rounding Decimal Points
000211210326     D  dayCntConvent                 7a
000212210326      ** Day Count Convention
000213210326     D  lockOutDays                   2a
000214210326      ** Lockout Days
000215210326     D  showDailyDeta                 5a
000216210326      ** Show Dailty Details
000217210326      ** True/False
000218210326     D  callTillDate                 10a
000219210326      ** Calculate Till Date
000220210326     D  benchMarkAdj                 20a
000221210326      ** Benchmark Adjustment
000222210326     D  ratesKnownInd                 1a
000223210326      ** Rates Known Indicator
000224210326     D  returnCD                     20a
000225210326      ** Return Code
000226210326
000227210326     D Main            pi
000228210326      **-----------------------------------------------------**
000229210326     D  moduleID                      2a
000230210326      ** Module ID
000231210326      **--** LE - Lending
000232210326      **--** DL - Dealing
000233210326      **--** FR - FRA/IRS
000234210326     D  transactREF                   6a
000235210326      ** Transaction Reference
000236210326     D  calcMethod                    4a
000237210326      ** Calculation Method
000238210326      **--** NCCR - Daily Compounding in Arrears (Non-Cumulative Compounded Rate)
000239210326      **--** CCR  - Average Compounded In Arrears (Cumulative Compounded Rate)
000240210326      **--** SARR - Simple ARR
000241210326      **--** SAVG - Simple Average
000242210326     D  intPrdStartDt                10a
000243210326      ** Interest Period Start Date
000244210326     D  intPrdEndDt                  10a
000245210326      ** Interest Period End Date
000246210326     D  riskFreeRate                  5a
000247210326      ** Risk Free Rate
000248210326     D  riskFreeRatFl                20a
000249210326      ** Risk Free Rate Floor
000250210326     D  lookBackDays                  2a
000251210326      ** Lookback Days
000252210326     D  obserPrdShift                 5a
000253210326      ** Observation Period Shift
000254210326      ** True/False
000255210326     D  RateRndDecPts                 3a
000256210326      ** Rate Rounding Decimal Points
000257210326     D  dayCntConvent                 7a
000258210326      ** Day Count Convention
000259210326     D  lockOutDays                   2a
000260210326      ** Lockout Days
000261210326     D  showDailyDeta                 5a
000262210326      ** Show Dailty Details
000263210326      ** True/False
000264210326     D  callTillDate                 10a
000265210326      ** Calculate Till Date
000266210326     D  benchMarkAdj                 20a
000267210326      ** Benchmark Adjustment
000268210326     D  ratesKnownInd                 1a
000269210326      ** Rates Known Indicator
000270210326     D  returnCD                     20a
000271210326      ** Return Code
000272210326
000273210326      ** +--------------------------------------+
000274210326      ** ¦ Manually included D-specs            ¦
000275210326      ** ¦ =========================            ¦
000276210326      ** +--------------------------------------+
000277210326      ** +--------------------------------------+
000278210326
000279210326      ** Extract file for LE0370 consumption and BR event creation
000280210326     D LELIBEDS      e ds                  extname(LELIBEPD)
000281210326     D ExtractFLDS     ds                  likeds(LELIBEDS)
000282210326
000283210326      ** Audit Log
000284210326     D SDARRLDS      e ds                  extname(SDARRLOGTD)
000285210326     D AuditLogDS      ds                  likeds(SDARRLDS)
000286210326
000287210326      ** ARR Daily Rates History File
000288210326     D ARRDLYDS      e ds                  extname(SDHSDRTD)
000289210326     D DailyHistDS     ds                  likeds(ARRDLYDS)
000290210326
000291210326      ** Core data structures
000292210326     D dssdy         e ds                  extname(DSSDY)
000293210326     D dsfdy         e ds                  extname(DSFDY)
000294210326
000295210326      ** +--------------------------------------+
000296210326      ** ¦ Constants declaration                ¦
000297210326      ** ¦ =====================                ¦
000298210326      ** +--------------------------------------+
000299210326
000300210326     D AMP             c                   const('&')
000301210326     D HTTP_HEAD       c                   const('http://')
000302210326     D INSERT          c                   const(0)
000303210326     D LELIBEPD        c                   const(1)
000304210326     D NO_ERROR        c                   const(0)
000305210326     D NO_RECORD       c                   const(100)
000306210326     D QUE             c                   const('?')
000307210326     D QUO             c                   const('''')
000308210326     D SDHSDRTD        c                   const(0)
000309210326     D UPDATE          c                   const(1)
000310210326
000311210326      ** +--------------------------------------+
000312210326      ** ¦ Variable declaration                 ¦
000313210326      ** ¦ ====================                 ¦
000314210326      ** +--------------------------------------+
000315210326      ** AOSVALR0 Parameters
000316210326     D pRetCode        S              7A
000317210326     D pOP01           S             20A
000318210326     D pVL01           S            200A
000319210326     D pOP02           S             20A
000320210326     D pVL02           S            200A
000321210326     D pOP03           S             20A
000322210326     D pVL03           S            200A
000323210326     D pOP04           S             20A
000324210326     D pVL04           S            200A
000325210326     D pOP05           S             20A
000326210326     D pVL05           S            200A
000327210326     D pOP06           S             20A
000328210326     D pVL06           S            200A
000329210326     D pOP07           S             20A
000330210326     D pVL07           S            200A
000331210326     D pOP08           S             20A
000332210326     D pVL08           S            200A
000333210326     D pOP09           S             20A
000334210326     D pVL09           S            200A
000335210326     D pOP10           S             20A
000336210326     D pVL10           S            200A
000337210326
000338210326      ** Work variables
000339210326     D i               s             10i 0
000340210326     D err             s             10i 0
000341210326     D msg             s             52a
000342210326     D jsonData        s         999999a   varying
000343210326     D RestAPIParm     s          65535a   varying inz(*blanks)
000344210326     D CalcMetURL      s            500a   varying inz(*blanks)
000345210326     D wSqlStr         S           2000A   INZ(*BLANKS)
000346210326     D pReturnCode     s              7a
000347210326     D pOption         s              7a
000348210326     D ErrorFlag       s              7a
000349210326     D DateIN          s              6p 0
000350210326     D DateOUT         s              5p 0
000351210326     D transactDate    s              5p 0
000352210326     D fileToCheck     s              1s 0
000353210326     D lastElem        s             10i 0
000354210326     D errMsg          s            500a   varying inz('')
000355210326     D action          s              1s 0
000356210326     D errorMessage    s            100a
000357210326     D includeRecord   s              1a   inz('N')
000358210326     D compAveRate     s             30p 9 inz(0)
000359210326     D logData         s          25000a   varying
000360210326     D isError         s               n   inz(false)
000361210326     D isException     s               n   inz(false)
000362210326     D writeLogs       S              1a
000363210326
000364210326      *---------------*
000365210326      ** JSON Details *
000366210326      *---------------*
000367210326
000368210326     D summary_t       ds                  qualified
000369210326     D                                     template
000370210326     D   intPrdDate                  10a
000371210326      ** Interest Period Date
000372210326      ** NCCR, CCR, SAVG, SARR
000373210326     D   intPDMidas                   5p 0
000374210326      ** Interest Period Date in Midas Format
000375210326     D   intPrdYMD                    6a
000376210326      ** Interest Period Date YYMMDD
000377210326     D   intPrdDays                   5s 0
000378210326      ** Interest Period Days
000379210326      ** NCCR, CCR, SAVG, SARR
000380210326     D   obsPrdDate                  10a
000381210326      ** Observation Period Date
000382210326      ** NCCR
000383210326     D   intOPMidas                   5p 0
000384210326      ** Observation Period Date in Midas Format
000385210326     D   intObsYMD                    6a
000386210326      ** Observation Period Date YYMMDD
000387210326     D   obsPrdDays                   5s 0
000388210326      ** Observation Period Days
000389210326      ** NCCR
000390210326     D   pubRskFrRt                  30p 9
000391210326      ** Published Risk Free Rate
000392210326      ** NCCR, CCR, SAVG, SARR
000393210326     D   rateApplied                 30p 9
000394210326      ** Rate Applied
000395210326      ** NCCR, CCR, SAVG, SARR
000396210326     D   rskFrRtFlAp                  5a
000397210326      ** Risk Free Rate Floor Applied
000398210326      ** NCCR, CCR, SAVG, SARR
000399210326     D   compFactor                  10a
000400210326      ** Compounding Factor
000401210326      ** NCCR
000402210326     D   dlyCompRate                 10a
000403210326      ** Daily Compunded Rate
000404210326      ** NCCR
000405210326     D   aveCompRate                 10a
000406210326      ** Average Compunded Rate
000407210326      ** CCR
000408210326     D   simpleAve                   10a
000409210326      ** Simple Average
000410210326      ** SAVG
000411210326
000412210326     D request_t       ds                  qualified
000413210326     D                                     template
000414210326     D   intPrdStart                 10a
000415210326      ** Interest Period Start
000416210326     D   intPrdEnd                   10a
000417210326      ** Interest Period End
000418210326     D   rskFreeRate                  4a
000419210326      ** Risk Free Rate
000420210326     D   rskFreeRtFl                 15s 6
000421210326      ** Risk Free Rate Floor
000422210326     D   obsPrdShift                  8s 0
000423210326      ** Observation Period Shift
000424210326     D   ratRndDecPts                 8s 0
000425210326      ** Rate Rounding Decimal Points
000426210326     D   showDailyDet                 8s 0
000427210326      ** Show Daily Details
000428210326
000429210326     D result          ds                  qualified
000430210326     D   success                      1n
000431210326      ** Success
000432210326     D   errmsg                     500a   varying
000433210326      ** Error Message
000434210326     D   statusCode                   4a   varying
000435210326      ** Status Code
000436210326     D   message                     10a   varying
000437210326      ** Message
000438210326     D   comment                    500a   varying
000439210326      ** Comment
000440210326     D   lastUpdFrSrc               200a   varying
000441210326      ** Last Updated From Source
000442210326     D   legalDisc                  200a   varying
000443210326      ** Legal Disclaimer
000444210326     D   reqParms                          likeds(request_t)
000445210326      ** Request Parameters
000446210326     D   list                              likeds(summary_t) dim(999)
000447210326      ** Daily Rate Summary
000448210326     D   errors                            likeds(exception_t)
000449210326      ** Exception Parameters
000450210326
000451210326     D exception_t     ds                  qualified
000452210326     D                                     template
000453210326     D   title                       50a
000454210326      ** Title
000455210326     D   exceptionMsg               100a
000456210326      ** Exception Message
000457210326     D   status                       4a
000458210326      ** Status
000459210326
000460210326     D SDBANK        e ds                  extname(SDBANKPD)
000461210326     D                 DS
000462210326     D ISODate                 1     10
000463210326     D WkYear                  3      4  0
000464210326     D WkMonth                 6      7  0
000465210326     D WkDay                   9     10  0
000466210326
000467210326     D                 DS
000468210326     D YYMMDD                  1      6
000469210326     D WkY                     1      2
000470210326     D WkM                     3      4
000471210326     D WkD                     5      6
000472210326
000473210326     D                 DS
000474210326     D DateIN_D                1      6  0
000475210326     D DD1D                    1      2  0
000476210326     D DD1M                    3      4  0
000477210326     D DD1Y                    5      6  0
000478210326     D                 DS
000479210326     D DateIN_M                1      6  0
000480210326     D DD2M                    1      2  0
000481210326     D DD2D                    3      4  0
000482210326     D DD2Y                    5      6  0
000483210326
000484210326     D reqParms        s                   like(yajl_val)
000485210326     D errors          s                   like(yajl_val)
000486210326     D docNode         s                   like(yajl_val)
000487210326     D list            s                   like(yajl_val)
000488210326     D node            s                   like(yajl_val)
000489210326     D val             s                   like(yajl_val)
000490210326     D cStr            S             10a   Varying
000491210326
000492210326      ** +--------------------------------------+
000493210326      ** ¦ Array declaration                    ¦
000494210326      ** ¦ ==================                   ¦
000495210326      ** +--------------------------------------+
000496210326
000497210326     D arrCalLoc       s            100a   dim(4) ctdata perrcd(1)
000498210326
000499210326      /free
000500210326
000501210326       // ** +--- Start of Main processing -----------------------------------+
000502210326       // ** ¦                                                                ¦
000503210326       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
000504210326       // ** ¦ executed at program activation.                                ¦
000505210326       // ** ¦                                                                ¦
000506210326       // ** +----------------------------------------------------------------+
000507210326
000508210326                   exsr processTransaction;
000509210326
000510210326                   *Inlr = *On;
000511210326                   return;
000512210326
000513210326       //*************************************************************
000514210326       /EJECT
000515210326       //*************************************************************
000516210326       //                                                            *
000517210326       // inzsr - Program Initialisation routine                     *
000518210326       //                                                            *
000519210326       // Called by: Main processing                                 *
000520210326       //                                                            *
000521210326       //  Calls: None                                               *
000522210326       //                                                            *
000523210326       //*************************************************************
000524210326
000525210326       begsr *inzsr;
000526210326
000527210326                   //Initialise audit log DS
000528210326                   clear AuditLogDS;
000529210326                   isError = false;
000530210326
000531210326                   AuditLogDS.SJMODI = moduleID;
000532210326                   AuditLogDS.SJTREF = transactREF;
000533210326                   AuditLogDS.SJSTAT = 'C';
000534210326                   AuditLogDS.SJMDAY = 0;
000535210326
000536210326                   pOption = '*FIRST';
000537210326                   pReturnCode = *Blanks;
000538210326
000539210326                   callp ACCESS_SDBANK(
000540210326                                  pReturnCode
000541210326                                : pOption
000542210326                                : dsfdy
000543210326                               );
000544210326                   SDBANK = dsfdy;
000545210326
000546210326                   if pReturnCode <> *blanks;
000547210326                      AuditLogDS.SJTMST = %timestamp();
000548210326                      AuditLogDS.SJEXMS = 'Error in access SDBANKPD';
000549210326                      AuditLogDS.SJCODE = '001';
000550210326                      isError = True;
000551210326                      Exsr errorHandler;
000552210326                   endif;
000553210326
000554210326                   AuditLogDS.SJMDAY = BJRDNB;
000555210326                   pOP01 = 'ARRAdapterURL';
000556210326                   pOP02 = 'ARRCalculatorTrace';
000557210326
000558210326                   CallP ACCESS_SVAL(
000559210326                                       pRetCode
000560210326                                     : pOP01
000561210326                                     : pVL01
000562210326                                     : pOP02
000563210326                                     : pVL02
000564210326                                     : pOP03
000565210326                                     : pVL03
000566210326                                     : pOP04
000567210326                                     : pVL04
000568210326                                     : pOP05
000569210326                                     : pVL05
000570210326                                     : pOP06
000571210326                                     : pVL06
000572210326                                     : pOP07
000573210326                                     : pVL07
000574210326                                     : pOP08
000575210326                                     : pVL08
000576210326                                     : pOP09
000577210326                                     : pVL09
000578210326                                     : pOP10
000579210326                                     : pVL10
000580210326                                       );
000581210326
000582210326                   If pRetCode <> *Blanks;
000583210326                        AuditLogDS.SJTMST = %timestamp();
000584210326                        AuditLogDS.SJEXMS = 'Error in access SDSVALPD ' +
000585210326                          %trim(Pvl01);
000586210326                        AuditLogDS.SJCODE = '002';
000587210326                        isError = True;
000588210326                        Exsr errorHandler;
000589210326                   Endif;
000590210326
000591210326                   If pVL01 <> *Blanks;
000592210326                         CalcMetURL     = HTTP_HEAD  + %trim(pVL01);
000593210326                   Else;
000594210326                        AuditLogDS.SJTMST = %timestamp();
000595210326                        AuditLogDS.SJEXMS = 'Error in access SDSVALPD ' +
000596210326                          %trim(calcMetURL);
000597210326                        AuditLogDS.SJCODE = '003';
000598210326                        isError = True;
000599210326                        Exsr errorHandler;
000600210326                   Endif;
000601210326
000602210326                   writeLogs = pVL02;
000603210326
000604210326                   select;
000605210326
000606210326                       when calcMethod = 'NCCR';
000607210326                            calcMetURL =  %trim(calcMetURL) +
000608210326                              %trim(arrCalLoc(1));
000609210326
000610210326                       when calcMethod = 'CCR';
000611210326                            calcMetURL =  %trim(calcMetURL) +
000612210326                              %trim(arrCalLoc(2));
000613210326
000614210326                       when calcMethod = 'SARR';
000615210326                            calcMetURL =  %trim(calcMetURL) +
000616210326                              %trim(arrCalLoc(3));
000617210326
000618210326                       when calcMethod = 'SAVG';
000619210326                            calcMetURL =  %trim(calcMetURL) +
000620210326                              %trim(arrCalLoc(4));
000621210326
000622210326                   endsl;
000623210326
000624210326                   // Get the highest date in the Daily History file
000625210326                   wSQLStr = 'select * from SDHSDRTD ' +
000626210326                             ' where CMODID = ' + QUO + moduleID + QUO +
000627210326                             ' and CTRNID = ' +  QUO + transactREF + QUO +
000628210326                             ' order by CMINPD DESC';
000629210326
000630210326                   exec sql prepare P1 from :wSQLStr;
000631210326                   exec sql declare P1 cursor for P1;
000632210326                   exec sql open P1;
000633210326                   exec sql fetch next From P1 into :DailyHistDS;
000634210326
000635210326                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
000636210326                        AuditLogDS.SJTMST = %timestamp();
000637210326                        AuditLogDS.SJEXMS = 'Error in access SDHSDRTD ' +
000638210326                          %trim(wSQLSTR);
000639210326                        AuditLogDS.SJCODE = '004';
000640210326                        isError = True;
000641210326                        exsr errorHandler;
000642210326                   endif;
000643210326
000644210326                   if sqlCod = NO_RECORD;
000645210326                      transactDate = 0;
000646210326                   else;
000647210326                      transactDate = DailyHistDS.CMINPD;
000648210326                   endif;
000649210326
000650210326                   exec sql close P1;
000651210326       endsr;
000652210326
000653210326       //*************************************************************
000654210326       /EJECT
000655210326       //*************************************************************
000656210326       //                                                            *
000657210326       // processTransaction - Process a Loan Transaction            *
000658210326       // ==================                                         *
000659210326       //                                                            *
000660210326       // Called by: Main Processing                                 *
000661210326       //                                                            *
000662210326       // Calls: None                                                *
000663210326       //                                                            *
000664210326       //*************************************************************
000665210326
000666210326       begsr processTransaction;
000667210326
000668210326                   //** This will build the URL parameter for the Rest API Call
000669210326
000670210326                   exsr buildParameter;
000671210326
000672210326                   //** This will call the http_string function from LIBHTTP123
000673210326                   //** to consume the Rest API
000674210326
000675210326                   exsr consumeRESTAPI;
000676210326
000677210326                   if not(isError);
000678210326
000679210326                      //** This will parse the JSON data returned from ARR Calculator
000680210326                      //** and store it to an array of Data Structure
000681210326
000682210326                      exsr parseJSONData;
000683210326
000684210326                      //** This will handle the output of the array DS to the
000685210326                      //** history and extract files
000686210326
000687210326                      exsr outputFiles;
000688210326
000689210326                      //** log details to audit file
000690210326                      exsr writeToAuditLog;
000691210326
000692210326                   endif;
000693210326
000694210326       endsr;
000695210326
000696210326       //*************************************************************
000697210326       /EJECT
000698210326       //*************************************************************
000699210326       //                                                            *
000700210326       // buildParameter - Build REST API Parameter                  *
000701210326       // ==============                                             *
000702210326       //                                                            *
000703210326       // Called by: processTransaction                              *
000704210326       //                                                            *
000705210326       // Calls: None                                                *
000706210326       //                                                            *
000707210326       //*************************************************************
000708210326
000709210326       begsr buildParameter;
000710210326
000711210326                   RestAPIParm =    %trim(CalcMetURL) +
000712210326                                 QUE + 'interestPeriodStartDate=' +
000713210326                                    %trim(intPrdStartDt) +
000714210326                                 AMP + 'interestPeriodEndDate=' +
000715210326                                    %trim(intPrdEndDt) +
000716210326                                 AMP + 'riskFreeRate=' +
000717210326                                    %trim(riskFreeRate) +
000718210326                                 AMP + 'lookBackDays=' +
000719210326                                    %trim(lookBackDays)  +
000720210326                                 AMP + 'rateRoundingDecimalPoints=' +
000721210326                                    %trim(RateRndDecPts) +
000722210326                                 AMP + 'observationPeriodShift=' +
000723210326                                    %trim(obserPrdShift) +
000724210326                                 AMP + 'lockoutDays=' +
000725210326                                    %trim(lockOutDays) +
000726210326                                 AMP + 'showDailyDetails=' +
000727210326                                    %trim(showDailyDeta) +
000728210326                                 AMP + 'calculateTillDate=' +
000729210326                                    %trim(callTillDate) +
000730210326                                 AMP + 'riskFreeRateFloor=' +
000731210326                                    %trim(riskFreeRatFl);
000732210326
000733210326       endsr;
000734210326
000735210326       //*************************************************************
000736210326       /EJECT
000737210326       //*************************************************************
000738210326       //                                                            *
000739210326       // consumeRESTAPI - Consume REST API                          *
000740210326       // ==============                                             *
000741210326       //                                                            *
000742210326       // Called by: processTransaction                              *
000743210326       //                                                            *
000744210326       // Calls: LIBHTTP123 http_string                              *
000745210326       //                                                            *
000746210326       //*************************************************************
000747210326
000748210326       begsr consumeRestAPI;
000749210326
000750210326              monitor;
000751210326
000752210326                 clear jsonData;
000753210326                 jsonData = http_string( 'GET' : %trim(RestAPIParm));
000754210326                 msg = *blanks;
000755210326                 err = 0;
000756210326
000757210326              on-error;
000758210326
000759210326                 msg = http_error(err);
000760210326                 errorMessage = %trim(msg);
000761210326                 returnCD = 'CONNECTION_ERROR';
000762210326                 isError = True;
000763210326                 AuditLogDS.SJTMST = %timestamp();
000764210326                 AuditLogDS.SJEXMS = %trim(msg);
000765210326                 AuditLogDS.SJCODE = '999';
000766210326                 exsr errorHandler;
000767210326
000768210326              endmon;
000769210326
000770210326       endsr;
000771210326
000772210326       //*************************************************************
000773210326       /EJECT
000774210326       //*************************************************************
000775210326       //                                                            *
000776210326       // parseJSONData - Parse JSON Data                            *
000777210326       // =============                                              *
000778210326       //                                                            *
000779210326       // Called by: processTransaction                              *
000780210326       //                                                            *
000781210326       // Calls: None                                                *
000782210326       //                                                            *
000783210326       //*************************************************************
000784210326
000785210326       begsr parseJSONData;
000786210326
000787210326                   // Load JSON data variable into a tree like structure
000788210326
000789210326                   docNode = yajl_buf_load_tree( %addr(jsonData:*data)
000790210326                             : %len(jsonData)
000791210326                             : ErrMsg );
000792210326
000793210326                   if errMsg <> '';
000794210326                      errorMessage = errMsg;
000795210326                      isError = true;
000796210326                      exsr errorHandler;
000797210326                   endif;
000798210326
000799210326                   node = YAJL_object_find(docNode: 'comment');
000800210326                   result.comment = YAJL_get_string(node);
000801210326
000802210326                   node = YAJL_object_find(docNode: 'errmsg');
000803210326                   result.errmsg  = yajl_get_string(val);
000804210326
000805210326                   // Exception messages
000806210326                   node = YAJL_object_find(docNode: 'exception');
000807210326                   if node <> *null;
000808210326
000809210326                       isException = true;
000810210326                       val = YAJL_object_find(node: 'title');
000811210326                       result.errors.title = yajl_get_string(val);
000812210326
000813210326                       val = YAJL_object_find(node: 'exceptionMessage');
000814210326                       result.errors.exceptionMsg = yajl_get_string(val);
000815210326
000816210326                       val = YAJL_object_find(node: 'status');
000817210326                       result.errors.status = yajl_get_string(val);
000818210326
000819210326                       // free up memory used by YAJL
000820210326                       yajl_tree_free(docNode);
000821210326
000822210326                       exsr errorHandler;
000823210326
000824210326                   endif;
000825210326
000826210326
000827210326                   list = YAJL_object_find(docNode: 'dailyRateSummary');
000828210326
000829210326                   clear result.list;
000830210326
000831210326                   i = 0;
000832210326                   dow YAJL_ARRAY_LOOP( list: i: node );
000833210326
000834210326                       lastElem = i;
000835210326
000836210326                       // All calculation methods
000837210326                       val = YAJL_object_find(node: 'interestPeriodDate');
000838210326                       result.list(i).intPrdDate = yajl_get_string(val);
000839210326
000840210326                       ISODate =  result.list(i).intPrdDate;
000841210326
000842210326                       monitor;
000843210326
000844210326                           WKY = %editc(wkYear:'X');
000845210326                           WKM = %editc(wkMonth:'X');
000846210326                           WKD = %editc(wkDay:'X');
000847210326
000848210326                           result.list(i).intPrdYMD  = YYMMDD;
000849210326
000850210326                           if BJDFIN = 'D';
000851210326                              DD1D = wkDay;
000852210326                              DD1M = wkMonth;
000853210326                              DD1Y = wkYear;
000854210326                              DateIn = DateIn_D;
000855210326                           else;
000856210326                              DD2D = wkDay;
000857210326                              DD2M = wkMonth;
000858210326                              DD2Y = wkYear;
000859210326                              DateIn = DateIn_M;
000860210326                           endif;
000861210326
000862210326                           pOption = '*FIRST';
000863210326                           pReturnCode = *Blanks;
000864210326                           callp CONVERT_DATE(
000865210326                                      ErrorFlag
000866210326                                    : DateIN
000867210326                                    : BJDFIN
000868210326                                    : DateOUT
000869210326                                   );
000870210326
000871210326                           if ErrorFlag   <> *blanks;
000872210326                                AuditLogDS.SJTMST = %timestamp();
000873210326                                AuditLogDS.SJEXMS = 'Error in date conversion';
000874210326                                AuditLogDS.SJCODE = '005';
000875210326                                isError = True;
000876210326                                exsr errorHandler;
000877210326                           endif;
000878210326                           result.list(i).intPDMidas = DateOUT;
000879210326
000880210326                       on-error;
000881210326                       endmon;
000882210326
000883210326                       // All calculation methods
000884210326                       val = YAJL_object_find(node: 'interestPeriodDays');
000885210326                       cStr =  yajl_get_string(val);
000886210326                       result.list(i).intPrdDays =  %dec(%trim(cStr):5:0);
000887210326
000888210326                       val =
000889210326                          YAJL_object_find(node: 'observationPeriodDate');
000890210326                       result.list(i).obsPrdDate =
000891210326                          yajl_get_string(val);
000892210326
000893210326                       ISODate =  result.list(i).obsPrdDate;
000894210326
000895210326                       monitor;
000896210326                            WKY = %editc(wkYear:'X');
000897210326                            WKM = %editc(wkMonth:'X');
000898210326                            WKD = %editc(wkDay:'X');
000899210326
000900210326                            result.list(i).intObsYMD  = YYMMDD;
000901210326
000902210326                            if BJDFIN = 'D';
000903210326                                 DD1D = wkDay;
000904210326                                 DD1M = wkMonth;
000905210326                                 DD1Y = wkYear;
000906210326                                 DateIn = DateIn_D;
000907210326                            else;
000908210326                                 DD2D = wkDay;
000909210326                                 DD2M = wkMonth;
000910210326                                 DD2Y = wkYear;
000911210326                                 DateIn = DateIn_M;
000912210326                             endif;
000913210326
000914210326                             pOption = '*FIRST';
000915210326                             pReturnCode = *Blanks;
000916210326                             callp CONVERT_DATE(
000917210326                                  ErrorFlag
000918210326                                : DateIN
000919210326                                : BJDFIN
000920210326                                : DateOUT
000921210326                               );
000922210326
000923210326                             if ErrorFlag   <> *blanks;
000924210326                                AuditLogDS.SJTMST = %timestamp();
000925210326                                AuditLogDS.SJEXMS = 'Error in date conversion';
000926210326                                AuditLogDS.SJCODE = '005';
000927210326                                isError = True;
000928210326                                exsr errorHandler;
000929210326                             endif;
000930210326
000931210326                             result.list(i).intOPMidas = DateOUT;
000932210326                       on-error;
000933210326                       endmon;
000934210326
000935210326                       val =
000936210326                           YAJL_object_find(node: 'observationPeriodDays');
000937210326
000938210326                       monitor;
000939210326                           cStr =  yajl_get_string(val);
000940210326                           result.list(i).obsPrdDays = %dec(%trim(cStr):5:0);
000941210326                       on-error;
000942210326                       endmon;
000943210326
000944210326                       // All calculation methods
000945210326                       val = YAJL_object_find(node: 'publishedRiskFreeRate');
000946210326
000947210326                       cStr  =  yajl_get_string(val);
000948210326                       result.list(i).pubRskFrRt =  %dec(%trim(cStr):30:9  );
000949210326
000950210326                       // All calculation methods
000951210326                       val = YAJL_object_find(node: 'rateApplied');
000952210326                       cStr  =  yajl_get_string(val);
000953210326
000954210326                       monitor;
000955210326                          result.list(i).rateApplied =  %dec(%trim(cStr):30:9);
000956210326                       on-error;
000957210326                       endmon;
000958210326
000959210326                       // All calculation methods
000960210326                       val = YAJL_object_find(node: 'riskFreeRateFloorApplied');
000961210326                       if YAJL_is_true(node);
000962210326                           result.list(i).rskFrRtFlAp=  'True';
000963210326                       else;
000964210326                           result.list(i).rskFrRtFlAp=  'False';
000965210326                       endif;
000966210326
000967210326                       if calcMethod = 'NCCR';
000968210326                            val = YAJL_object_find(node: 'compoundingFactor');
000969210326                            result.list(i).compFactor=  yajl_get_string(val);
000970210326
000971210326                            val =
000972210326                              YAJL_object_find(node: 'dailyCompoundedRate');
000973210326                            result.list(i).dlyCompRate =
000974210326                              yajl_get_string(val);
000975210326                       endif;
000976210326
000977210326                       if calcMethod = 'CCR';
000978210326                            val =
000979210326                              YAJL_object_find(node: 'averageCompoundedRate');
000980210326                            result.list(i).aveCompRate =  yajl_get_string(val);
000981210326
000982210326                       endif;
000983210326
000984210326                       if calcMethod = 'SAVG';
000985210326                            val =
000986210326                              YAJL_object_find(node: 'simpleAverageRate');
000987210326                            result.list(i).simpleAve =  yajl_get_string(val);
000988210326
000989210326                       endif;
000990210326
000991210326                   enddo;
000992210326
000993210326                   // free up memory used by YAJL
000994210326                   yajl_tree_free(docNode);
000995210326
000996210326       endsr;
000997210326
000998210326       //*************************************************************
000999210326       /EJECT
001000210326       //*************************************************************
001001210326       //                                                            *
001002210326       // outputFile - Output Files                                  *
001003210326       // ==========                                                 *
001004210326       //                                                            *
001005210326       // Called by: processTransaction                              *
001006210326       //                                                            *
001007210326       // Calls: None                                                *
001008210326       //                                                            *
001009210326       //*************************************************************
001010210326
001011210326       begsr outputFiles;
001012210326
001013210326                   i = 1;
001014210326
001015210326                   dow i <= lastElem;
001016210326
001017210326                       // Output information to SDARRLOGTD
001018210326                       exsr writeToARRDailyHistory;
001019210326
001020210326                       //Output information to LELIBEPD
001021210326                       exsr writeToExtractFile;
001022210326
001023210326                       i = i + 1;
001024210326
001025210326                   enddo;
001026210326
001027210326       endsr;
001028210326
001029210326       //*************************************************************
001030210326       /EJECT
001031210326       //*************************************************************
001032210326       //                                                            *
001033210326       // writeToARRDailyHistory - Write to ARR Daily Rates History  *
001034210326       // ======================                                     *
001035210326       //                                                            *
001036210326       // Called by: Output File                                     *
001037210326       //                                                            *
001038210326       // Calls: None                                                *
001039210326       //                                                            *
001040210326       //*************************************************************
001041210326
001042210326       begsr writeToARRDailyHistory;
001043210326
001044210326                   includeRecord = 'N';
001045210326
001046210326                   if (calcMethod = 'NCCR' or calcMethod  = 'SARR')
001047210326                   and  result.list(i).intPDMidas > transactDate;
001048210326                        includeRecord = 'Y';
001049210326
001050210326                   elseif  (calcMethod = 'CCR' or calcMethod  = 'SAVG');
001051210326                        includeRecord = 'Y';
001052210326
001053210326                   endif;
001054210326
001055210326                   fileToCheck = SDHSDRTD;
001056210326                   if includeRecord = 'Y';
001057210326                      exsr checkExist;
001058210326                      if action = INSERT;
001059210326                          exsr insertHistoryFile;
001060210326                      elseif action = UPDATE;
001061210326                          exsr updateHistoryFile;
001062210326                      endif;
001063210326                   endif;
001064210326
001065210326       endsr;
001066210326       //*************************************************************
001067210326       /EJECT
001068210326       //*************************************************************
001069210326       //                                                            *
001070210326       // checkExist - Check if a record exist on a given file       *
001071210326       // ==========                                                 *
001072210326       //                                                            *
001073210326       // Called by: Output File                                     *
001074210326       //                                                            *
001075210326       // Calls: None                                                *
001076210326       //                                                            *
001077210326       //*************************************************************
001078210326
001079210326       begsr checkExist;
001080210326
001081210326                   if fileToCheck = SDHSDRTD;
001082210326                        wSQLStr = 'select * from SDHSDRTD ' +
001083210326                                  'where CMODID = '  + QUO + moduleID + QUO +
001084210326                                  ' and CTRNID = ' + QUO + transactREF + QUO +
001085210326                                  ' and CMINPD = ' +
001086210326                                    %char(result.list(i).intPDMidas);
001087210326                   elseif fileToCheck = LELIBEPD;
001088210326                        wSQLStr = 'select * from LELIBEPD ' +
001089210326                                  'where LDLNRF = ' + QUO + transactREF + QUO +
001090210326                                  ' and LDVDAT = ' +
001091210326                                    %char(result.list(i).intPDMidas);
001092210326                   endif;
001093210326
001094210326                   exec sql prepare P1 from :wSQLStr;
001095210326                   exec sql open P1;
001096210326
001097210326                   if fileToCheck = SDHSDRTD;
001098210326                        exec sql fetch next From P1 into :DailyHistDS;
001099210326                   elseif fileToCheck = LELIBEPD;
001100210326                        exec sql fetch next From P1 into :ExtractFLDS;
001101210326                   endif;
001102210326
001103210326                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001104210326                         errorMessage = 'SQL ERROR ' + %char(sqlCod);
001105210326                         isError = true;
001106210326                         exsr errorHandler;
001107210326                   endif;
001108210326
001109210326                   if sqlCod = NO_RECORD;
001110210326                      action = INSERT;
001111210326                   else;
001112210326                      action = UPDATE;
001113210326                   endif;
001114210326                   exec sql close P1;
001115210326
001116210326       endsr;
001117210326       //*************************************************************
001118210326       /EJECT
001119210326       //*************************************************************
001120210326       //                                                            *
001121210326       // insertHistoryFile                                          *
001122210326       // =================                                          *
001123210326       //                                                            *
001124210326       // Called by: writeToARRDailyHistory                           *
001125210326       //                                                            *
001126210326       // Calls: None                                                *
001127210326       //                                                            *
001128210326       //*************************************************************
001129210326
001130210326       begsr insertHistoryFile;
001131210326
001132210326                   clear DailyHistDS;
001133210326                   DailyHistDS.CMODID = moduleID;
001134210326                   DailyHistDS.CTRNID = transactREF;
001135210326                   DailyHistDS.CCALCM = calcMethod;
001136210326                   DailyHistDS.CMINPD = result.list(i).intPDMidas;
001137210326                   DailyHistDS.CINPDT = result.list(i).intPrdYMD;
001138210326                   DailyHistDS.CINPDY = result.list(i).intPrdDays;
001139210326                   DailyHistDS.CMOBPD = result.list(i).intOPMidas;
001140210326                   DailyHistDS.COBPDT = result.list(i).intObsYMD;
001141210326                   DailyHistDS.CPBRFR = result.list(i).pubRskFrRt;
001142210326                   DailyHistDS.COBPDY = result.list(i).obsPrdDays;
001143210326                   DailyHistDS.CRTEAP = result.list(i).rateApplied;
001144210326                   if result.list(i).rskFrRtFlAp = 'true';
001145210326                      DailyHistDS.CRFRAP = 'Y';
001146210326                   else;
001147210326                      DailyHistDS.CRFRAP = 'N';
001148210326                   endif;
001149210326                   DailyHistDS.CTIMST = %timestamp();
001150210326
001151210326                   select;
001152210326                        when calcMethod = 'NCCR';
001153210326                             DailyHistDS.CDCMRT =
001154210326                               %Dec(Result.List(i).dlyCompRate:30:9);
001155210326                             DailyHistDS.CCMFAC =
001156210326                               %Dec(Result.List(i).compFactor:30:9);
001157210326                        when calcMethod = 'CCR';
001158210326                             DailyHistDS.CAVCRT =
001159210326                               %Dec(Result.List(i).aveCompRate:30:9);
001160210326                        when calcMethod = 'SAVG';
001161210326                             DailyHistDS.CSMPAV =
001162210326                               %Dec(Result.List(i).simpleAve:30:9);
001163210326                   endsl;
001164210326
001165210326                   exec sql insert into SDHSDRTD
001166210326                   values (:DailyHistDS);
001167210326
001168210326                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001169210326                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001170210326                      isError = true;
001171210326                      exsr errorHandler;
001172210326                   endif;
001173210326
001174210326       endsr;
001175210326
001176210326       //*************************************************************
001177210326       /EJECT
001178210326       //*************************************************************
001179210326       //                                                            *
001180210326       // insertExtractFile                                          *
001181210326       // =================                                          *
001182210326       //                                                            *
001183210326       // Called by: writeToHistoryFile                               *
001184210326       //                                                            *
001185210326       // Calls: None                                                *
001186210326       //                                                            *
001187210326       //*************************************************************
001188210326
001189210326       begsr insertExtractFile;
001190210326
001191210326                   clear ExtractFLDS;
001192210326                   clear compAveRate;
001193210326                   ExtractFLDS.LDLNRF = transactREF;
001194210326                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
001195210326
001196210326                   select;
001197210326                        when calcMethod = 'NCCR';
001198210326                             compAveRate =
001199210326                               %Dec(Result.List(i).dlyCompRate:30:9);
001200210326                        when calcMethod = 'CCR';
001201210326                             compAveRate =
001202210326                               %Dec(Result.List(i).aveCompRate:30:9);
001203210326                        when calcMethod = 'SARR';
001204210326                             compAveRate =
001205210326                               %Dec(Result.List(i).rateApplied:30:9);
001206210326                        when calcMethod = 'SAVG';
001207210326                             compAveRate =
001208210326                               %Dec(Result.List(i).simpleAve:30:9);
001209210326                   endsl;
001210210326
001211210326                   compAveRate += %dech(benchMarkAdj:13:9);
001212210326                   ExtractFLDS.LDCART =
001213210326                     %dech(compAveRate  :13 :9);
001214210326
001215210326                   exec sql insert into LELIBEPD
001216210326                   values (:ExtractFLDS);
001217210326
001218210326                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001219210326                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001220210326                      isError = true;
001221210326                      exsr errorHandler;
001222210326                   endif;
001223210326
001224210326       endsr;
001225210326       //*************************************************************
001226210326       /EJECT
001227210326       //*************************************************************
001228210326       //                                                            *
001229210326       // updateExtractFile                                          *
001230210326       // =================                                          *
001231210326       //                                                            *
001232210326       // Called by: writeToExtractFile                               *
001233210326       //                                                            *
001234210326       // Calls: None                                                *
001235210326       //                                                            *
001236210326       //*************************************************************
001237210326
001238210326       begsr updateExtractFile;
001239210326
001240210326                   clear ExtractFLDS;
001241210326                   clear compAveRate;
001242210326                   ExtractFLDS.LDLNRF = transactREF;
001243210326                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
001244210326
001245210326                   select;
001246210326                        when calcMethod = 'NCCR';
001247210326                             compAveRate =
001248210326                               %Dec(Result.List(i).dlyCompRate:30:9);
001249210326                        when calcMethod = 'CCR';
001250210326                             compAveRate =
001251210326                               %Dec(Result.List(i).aveCompRate:30:9);
001252210326                        when calcMethod = 'SARR';
001253210326                             compAveRate =
001254210326                               %Dec(Result.List(i).rateApplied:30:9);
001255210326                        when calcMethod = 'SAVG';
001256210326                             compAveRate =
001257210326                               %Dec(Result.List(i).simpleAve:30:9);
001258210326                   endsl;
001259210326
001260210326                   compAveRate += %dech(benchMarkAdj:13:9);
001261210326                   ExtractFLDS.LDCART =
001262210326                     %dech(compAveRate  :13 :9);
001263210326
001264210326                   wSqlStr = 'update LELIBEPD A '  +
001265210326                              'SET A.LDCART = ' + %Char(ExtractFLDS.LDCART) +
001266210326                              ' where A.LDLNRF = ' + QUO + ExtractFLDS.LDLNRF
001267210326                                 + QUO +
001268210326                              ' and   A.LDVDAT = ' +  %Char(ExtractFLDS.LDVDAT);
001269210326
001270210326                   exec sql
001271210326                   execute immediate :wSqlStr;
001272210326
001273210326                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001274210326                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001275210326                      isError = true;
001276210326                      exsr errorHandler;
001277210326                   endif;
001278210326
001279210326       endsr;
001280210326
001281210326       //*************************************************************
001282210326       /EJECT
001283210326       //*************************************************************
001284210326       //                                                            *
001285210326       // writeToExtractFile - Write to Extract File                 *
001286210326       // ==================                                         *
001287210326       //                                                            *
001288210326       // Called by: Output File                                     *
001289210326       //                                                            *
001290210326       // Calls: None                                                *
001291210326       //                                                            *
001292210326       //*************************************************************
001293210326
001294210326
001295210326       begsr writeToExtractFile;
001296210326
001297210326                   fileToCheck = LELIBEPD;
001298210326                   exsr checkExist;
001299210326
001300210326                   if action = INSERT;
001301210326                        exsr insertExtractFile;
001302210326
001303210326                   elseif action = UPDATE;
001304210326                        exsr updateExtractFile;
001305210326
001306210326                   endif;
001307210326
001308210326       endsr;
001309210326
001310210326       //*************************************************************
001311210326       /EJECT
001312210326       //*************************************************************
001313210326       //                                                            *
001314210326       // writeToAuditLog - Write to Audit Log                       *
001315210326       // ===============                                            *
001316210326       //                                                            *
001317210326       // Called by: Output File                                     *
001318210326       //                                                            *
001319210326       // Calls: None                                                *
001320210326       //                                                            *
001321210326       //*************************************************************
001322210326
001323210326       begsr writeToAuditLog;
001324210326
001325210326                   if isException;
001326210326                       AuditLogDS.SJTMST = %timestamp();
001327210326                       AuditLogDS.SJEXMS = result.errors.exceptionMsg;
001328210326                       AuditLogDS.SJCODE = result.errors.status;
001329210326                       if AuditLogDS.SJCODE = '400';
001330210326                          logData = RestAPIParm;
001331210326                          returnCD = 'EXCEPTION_ERROR';
001332210326                          AuditLogDS.SJSTAT = 'F';
001333210326                       endif;
001334210326                   else;
001335210326                       if not(isError);
001336210326                          AuditLogDS.SJTMST = %timestamp();
001337210326                          AuditLogDS.SJEXMS = 'ARR Calculator completed' +
001338210326                             ' successfully';
001339210326                          AuditLogDS.SJCODE = '000';
001340210326                          returnCD = 'SUCCESS';
001341210326                          AuditLogDS.SJSTAT = 'C';
001342210326                          logData = %Trim(jsonData);
001343210326                       else;
001344210326                          logData = %Trim(errorMessage);
001345210326                          AuditLogDS.SJSTAT = 'F';
001346210326                       endif;
001347210326                   endif;
001348210326
001349210326                   // Write to audit log file if status is completed and
001350210326                   // system value ARRCalculatorTrace is Y
001351210326                   // OR status is failed and this is the last program call
001352210326                   // for the same transaction reference (i.e. RatesKnown = N)
001353210326                   if (AuditLogDS.SJSTAT = 'C' and writeLogs = 'Y') or
001354210326                      (AuditLogDS.SJSTAT = 'F' and RatesKnownInd = 'N');
001355210326                       exec sql insert into SDARRLOGTD
001356210326                       values (
001357210326                            : AuditLogDS.SJMODI,
001358210326                            : AuditLogDS.SJTREF,
001359210326                            : AuditLogDS.SJSTAT,
001360210326                            : AuditLogDS.SJMDAY,
001361210326                            : AuditLogDS.SJTMST,
001362210326                            : AuditLogDS.SJCODE,
001363210326                            : AuditLogDS.SJEXMS,
001364210326                            : logData
001365210326                       );
001366210326                       if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001367210326                          AuditLogDS.SJTMST = %timestamp();
001368210326                          AuditLogDS.SJEXMS = 'Error in access SDARRLOGTD';
001369210326                          AuditLogDS.SJCODE = '007';
001370210326                          isError = True;
001371210326                          exsr errorHandler;
001372210326                       endif;
001373210326                   endif;
001374210326
001375210326       endsr;
001376210326
001377210326       //*************************************************************
001378210326       /EJECT
001379210326       //*************************************************************
001380210326       //                                                            *
001381210326       // updateHistoryFile                                          *
001382210326       // =================                                          *
001383210326       //                                                            *
001384210326       // Called by: writeToARRDailyHistory                           *
001385210326       //                                                            *
001386210326       // Calls: None                                                *
001387210326       //                                                            *
001388210326       //*************************************************************
001389210326
001390210326       begsr updateHistoryFile;
001391210326
001392210326                   clear DailyHistDS;
001393210326                   DailyHistDS.CMODID = moduleID;
001394210326                   DailyHistDS.CTRNID = transactREF;
001395210326                   DailyHistDS.CCALCM = calcMethod;
001396210326                   DailyHistDS.CMINPD = result.list(i).intPDMidas;
001397210326                   DailyHistDS.CINPDT = result.list(i).intPrdYMD;
001398210326                   DailyHistDS.CINPDY = result.list(i).intPrdDays;
001399210326                   DailyHistDS.CMOBPD = result.list(i).intOPMidas;
001400210326                   DailyHistDS.COBPDT = result.list(i).intObsYMD;
001401210326                   DailyHistDS.CPBRFR = result.list(i).pubRskFrRt;
001402210326                   DailyHistDS.COBPDY = result.list(i).obsPrdDays;
001403210326                   DailyHistDS.CRTEAP = result.list(i).rateApplied;
001404210326                   if result.list(i).rskFrRtFlAp = 'true';
001405210326                      DailyHistDS.CRFRAP = 'Y';
001406210326                   else;
001407210326                      DailyHistDS.CRFRAP = 'N';
001408210326                   endif;
001409210326                   DailyHistDS.CTIMST = %timestamp();
001410210326
001411210326                   select;
001412210326                        when calcMethod = 'NCCR';
001413210326                             DailyHistDS.CDCMRT =
001414210326                               %Dec(Result.List(i).dlyCompRate:30:9);
001415210326                             DailyHistDS.CCMFAC =
001416210326                               %Dec(Result.List(i).compFactor:30:9);
001417210326                        when calcMethod = 'CCR';
001418210326                             DailyHistDS.CAVCRT =
001419210326                               %Dec(Result.List(i).aveCompRate:30:9);
001420210326                        when calcMethod = 'SAVG';
001421210326                             DailyHistDS.CSMPAV =
001422210326                               %Dec(Result.List(i).simpleAve:30:9);
001423210326                   endsl;
001424210326
001425210326                   wSqlStr = 'update SDHSDRTD A '  +
001426210326                              'SET A.CMINPD = ' + %Char(DailyHistDS.CMINPD) +
001427210326                              ' , ' +
001428210326                              'A.CCALCM = ' + QUO + %trim(DailyHistDS.CCALCM)
001429210326                                + QUO + ' , ' +
001430210326                              'A.CINPDT = ' + QUO + %trim(DailyHistDS.CINPDT) +
001431210326                               QUO + ' , ' +
001432210326                              'A.CINPDY = ' + %Char(DailyHistDS.CINPDY) +
001433210326                              ' , ' +
001434210326                              'A.CMOBPD = ' + %Char(DailyHistDS.CMOBPD) +
001435210326                              ' , ' +
001436210326                              'A.COBPDT = ' + QUO + %trim(DailyHistDS.COBPDT) +
001437210326                              QUO + ' , ' +
001438210326                              'A.COBPDY = ' + %Char(DailyHistDS.COBPDY) +
001439210326                              ' , ' +
001440210326                              'A.CPBRFR = ' + %Char(DailyHistDS.CPBRFR) +
001441210326                              ' , ' +
001442210326                              'A.CRTEAP = ' + %Char(DailyHistDS.CRTEAP) +
001443210326                              ' , ' +
001444210326                              'A.CRFRAP = ' + QUO + %trim(DailyHistDS.CRFRAP) +
001445210326                              QUO + ' , ' +
001446210326                              'A.CAVCRT = ' + %Char(DailyHistDS.CAVCRT) +
001447210326                              ' , ' +
001448210326                              'A.CCMFAC = ' + %Char(DailyHistDS.CCMFAC) +
001449210326                              ' , ' +
001450210326                              'A.CDCMRT = ' + %Char(DailyHistDS.CDCMRT) +
001451210326                              ' , ' +
001452210326                              'A.CSMPAV = ' + %Char(DailyHistDS.CSMPAV) +
001453210326                              ' , ' +
001454210326                              'A.CTIMST = ' + QUO + %Char(DailyHistDS.CTIMST) +
001455210326                              QUO +
001456210326                              ' where A.CMODID = ' +
001457210326                                QUO + %trim(moduleID) + QUO +
001458210326                              ' and   A.CTRNID = ' +
001459210326                                QUO + %trim(transactREF) + QUO;
001460210326
001461210326                   exec sql
001462210326                   execute immediate :wSqlStr;
001463210326
001464210326                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001465210326                      errorMessage = 'SQL ERROR ' + %char(sqlCod);
001466210326                      isError = true;
001467210326                      exsr errorHandler;
001468210326                   endif;
001469210326
001470210326                  exec sql  update SDHSDRTD
001471210326                  set CMINPD = DailyHistDS.CMINPD
001472210326                  where CMODID = moduleID
001473210326                  and   CTRNID = transactREF;
001474210326
001475210326                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
001476210326                        isError = true;
001477210326                        exsr errorHandler;
001478210326                   endif;
001479210326       endsr;
001480210326
001481210326       //*************************************************************
001482210326       /EJECT
001483210326       //*************************************************************
001484210326       //                                                            *
001485210326       //   errorHandler  - Program Error Processing Subroutine.     *
001486210326       //                                                            *
001487210326       //   Called By: Main Processing, various subroutines          *
001488210326       //                                                            *
001489210326       //*************************************************************
001490210326
001491210326       begsr *pssr;
001492210326                   *inu7 = *on;
001493210326                   *inu8 = *on;
001494210326                   *Inlr = *on;
001495210326                   dump;
001496210326                   return;
001497210326       endsr;
001498210326
001499210326       //*************************************************************
001500210326       /EJECT
001501210326       //*************************************************************
001502210326       //                                                            *
001503210326       //   errorHandler                                             *
001504210326       //                                                            *
001505210326       //   Called By: Main Processing, various subroutines          *
001506210326       //                                                            *
001507210326       //*************************************************************
001508210326
001509210326       begsr errorHandler;
001510210326
001511210326                   exsr writeToAuditLog;
001512210326                   *Inlr = *on;
001513210326                   return;
001514210326       endsr;
001515210326
001516210326       //*************************************************************
001517210326
001518210326      /end-free
001519210326
001520210326     C/COPY ZSRSRC,ZACCHLE
001521210326     C/COPY ZSRSRC,ZBKDT_ILE
001522210326     C/COPY ZSRSRC,ZFWDT_ILE
001523210326** CPY@   **      OBJECT COPYRIGHT
001524210326(c) Finastra International Limited 2020
001525210326** arrCalLoc
001526210326/corporate/lending/alternative-reference-rates/v1/daily-compounding/rates
001527210326/corporate/lending/alternative-reference-rates/v1/compounded-in-arrears/average-rate
001528210326/corporate/lending/alternative-reference-rates/v1/simple-arr/rates
001529210326/corporate/lending/alternative-reference-rates/v1/simple-average/rates
