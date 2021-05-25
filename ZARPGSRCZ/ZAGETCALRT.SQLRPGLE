     H DEBUG
     H DFTACTGRP(*NO) BNDDIR('HTTPAPI') BNDDIR('YAJL')
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD API - Invoke ARR Calculator')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data API - Invoke ARR Calculator      *
      *                                                               *
      *  ZAGETCALRT Midas API - Invoke ARR Calculator                 *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD058182           Date 25May21               *
      *  Prev Amend No. MD058040A          Date 25May21               *
      *                 MD058040           Date 11May21               *
      *                 MD057871           Date 30Apr21               *
      *                 CSD103  *CREATE    Date 10Aug20               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058182 - Missing BR event on LOAC despite calculator       *
      *             returned complete rates. Write returned rates     *
      *             to SDHSDRTD with Int Period Date <= Control Date. *
      *  MD058040A - Duplicate records still found in HISTSHQ. Fix    *
      *              the number of decimal places used in checking    *
      *              whether the returned rate is changed or not.     *
      *  MD058040 - Calculator returned the same rates causing        *
      *             duplicate interest entries generated on HISTSHQ.  *
      *             Write to LELIBEPD only if interest period date    *
      *             and extracted rate not yet exist on SDHSDRTD.     *
      *  MD057871 - Allow a blank floor in calling ARR Calculator     *
      *  CSD103 - LIBOR Deregulation - Common Layer Standing Data     *
      *                                                               *
      *****************************************************************

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.

      ** Scott Clements library for JSON parse and HTTP calls
     D/INCLUDE LIBHTTP123/QRPGLESRC,YAJL_H
     D/INCLUDE LIBHTTP123/QRPGLESRC,HTTPAPI_H

     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZSRSRC,ZINTDYZ1LE
     D/COPY ZSRSRC,ZHOLILE
     D/COPY ZSRSRC,ZHOLELE

      ** +--------------------------------------+
      ** ¦ Program Prototypes                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D ACCESS_SVAL     PR                  EXTPGM('AOSVALR0')
     D pRetCode                       7A
     D pOP01                         20A
     D pVL01                        200A
     D pOP02                         20A
     D pVL02                        200A
     D pOP03                         20A
     D pVL03                        200A
     D pOP04                         20A
     D pVL04                        200A
     D pOP05                         20A
     D pVL05                        200A
     D pOP06                         20A
     D pVL06                        200A
     D pOP07                         20A
     D pVL07                        200A
     D pOP08                         20A
     D pVL08                        200A
     D pOP09                         20A
     D pVL09                        200A
     D pOP10                         20A
     D pVL10                        200A

     D  ACCESS_SDBANK  pr                  extpgm('AOBANKR0')
     D    pReturnCode                 7A
     D    pOption                     7A
     D    pDSFDY                    200A

     D  CONVERT_DATE   pr                  extpgm('ZDATE1')
     D    ErrorFlag                   7a
     D    DateIN                      6p 0
     D    DateInd                     1a
     D    DateOUT                     5p 0

      *  +----------------+
      ** |Parameter lists |
      ** +----------------+

     D Main            pr                  extpgm('ZAGETCALRT')
      **-----------------------------------------------------**
     D  moduleID                      2a
      ** Module ID
      **--** LE - Lending
      **--** DL - Dealing
      **--** FR - FRA/IRS
     D  transactREF                   6a
      ** Transaction Reference
     D  calcMethod                    4a
      ** Calculation Method
      **--** NCCR - Daily Compounding in Arrears (Non-Cumulative Compounded Rate)
      **--** CCR  - Average Compounded In Arrears (Cumulative Compounded Rate)
      **--** SARR - Simple ARR
      **--** SAVG - Simple Average
     D  intPrdStartDt                10a
      ** Interest Period Start Date
     D  intPrdStrMDAY                 5a
      ** Interest Period Start Date in Midas Day
     D  intPrdEndDt                  10a
      ** Interest Period End Date
     D  intPrdEndMDAY                 5a
      ** Interest Period End Date in Midas Day
     D  riskFreeRate                  5a
      ** Risk Free Rate
     D  riskFreeRatFl                20a
      ** Risk Free Rate Floor
     D  lookBackDays                  2a
      ** Lookback Days
     D  obserPrdShift                 5a
      ** Observation Period Shift
      ** True/False
     D  RateRndDecPts                 3a
      ** Rate Rounding Decimal Points
     D  dayCntConvent                 7a
      ** Day Count Convention
     D  lockOutDays                   2a
      ** Lockout Days
     D  showDailyDeta                 5a
      ** Show Dailty Details
      ** True/False
     D  callTillDate                 10a
      ** Calculate Till Date
     D  benchMarkAdj                 20a
      ** Benchmark Adjustment
     D  ratesKnownInd                 1a
      ** Rates Known Indicator
     D  controlDate                   5a                                                    MD058182
      ** Event Control Date                                                                 MD058182
     D  returnCD                     20a
      ** Return Code

     D Main            pi
      **-----------------------------------------------------**
     D  moduleID                      2a
      ** Module ID
      **--** LE - Lending
      **--** DL - Dealing
      **--** FR - FRA/IRS
     D  transactREF                   6a
      ** Transaction Reference
     D  calcMethod                    4a
      ** Calculation Method
      **--** NCCR - Daily Compounding in Arrears (Non-Cumulative Compounded Rate)
      **--** CCR  - Average Compounded In Arrears (Cumulative Compounded Rate)
      **--** SARR - Simple ARR
      **--** SAVG - Simple Average
     D  intPrdStartDt                10a
      ** Interest Period Start Date
     D  intPrdStrMDAY                 5a
      ** Interest Period Start Date in Midas Day
     D  intPrdEndDt                  10a
      ** Interest Period End Date
     D  intPrdEndMDAY                 5a
      ** Interest Period End Date in Midas Day
     D  riskFreeRate                  5a
      ** Risk Free Rate
     D  riskFreeRatFl                20a
      ** Risk Free Rate Floor
     D  lookBackDays                  2a
      ** Lookback Days
     D  obserPrdShift                 5a
      ** Observation Period Shift
      ** True/False
     D  RateRndDecPts                 3a
      ** Rate Rounding Decimal Points
     D  dayCntConvent                 7a
      ** Day Count Convention
     D  lockOutDays                   2a
      ** Lockout Days
     D  showDailyDeta                 5a
      ** Show Dailty Details
      ** True/False
     D  callTillDate                 10a
      ** Calculate Till Date
     D  benchMarkAdj                 20a
      ** Benchmark Adjustment
     D  ratesKnownInd                 1a
      ** Rates Known Indicator
     D  controlDate                   5a                                                    MD058182
      ** Event Control Date                                                                 MD058182
     D  returnCD                     20a
      ** Return Code

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      ** +--------------------------------------+

      ** Extract file for LE0370 consumption and BR event creation
     D LELIBEDS      e ds                  extname(LELIBEPD)
     D ExtractFLDS     ds                  likeds(LELIBEDS)

      ** Audit Log
     D SDARRLDS      e ds                  extname(SDARRLOGTD)
     D AuditLogDS      ds                  likeds(SDARRLDS)

      ** ARR Daily Rates History File
     D ARRDLYDS      e ds                  extname(SDHSDRTD)
     D DailyHistDS     ds                  likeds(ARRDLYDS)

      ** Core data structures
     D dssdy         e ds                  extname(DSSDY)
     D dsfdy         e ds                  extname(DSFDY)

      ** +--------------------------------------+
      ** ¦ Constants declaration                ¦
      ** ¦ =====================                ¦
      ** +--------------------------------------+

     D AMP             c                   const('&')
     D HTTP_HEAD       c                   const('http://')
     D INSERT          c                   const(0)
     D LELIBEPD        c                   const(1)
     D NO_ERROR        c                   const(0)
     D NO_RECORD       c                   const(100)
     D QUE             c                   const('?')
     D QUO             c                   const('''')
     D SDHSDRTD        c                   const(0)
     D UPDATE          c                   const(1)
     D BLANK_FLOOR     c                   const('9999.9999999')                            MD057871
     D SDHSDRTD2       c                   const(2)                                         MD058040

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+

      ** AOSVALR0 Parameters
     D pRetCode        S              7A
     D pOP01           S             20A
     D pVL01           S            200A
     D pOP02           S             20A
     D pVL02           S            200A
     D pOP03           S             20A
     D pVL03           S            200A
     D pOP04           S             20A
     D pVL04           S            200A
     D pOP05           S             20A
     D pVL05           S            200A
     D pOP06           S             20A
     D pVL06           S            200A
     D pOP07           S             20A
     D pVL07           S            200A
     D pOP08           S             20A
     D pVL08           S            200A
     D pOP09           S             20A
     D pVL09           S            200A
     D pOP10           S             20A
     D pVL10           S            200A

      ** Work variables
     D i               s             10i 0
     D err             s             10i 0
     D msg             s             52a
     D jsonData        s         999999a   varying
     D RestAPIParm     s          65535a   varying inz(*blanks)
     D CalcMetURL      s            500a   varying inz(*blanks)
     D wSqlStr         S           2000A   INZ(*BLANKS)
     D pReturnCode     s              7a
     D pOption         s              7a
     D ErrorFlag       s              7a
     D DateIN          s              6p 0
     D DateOUT         s              5p 0
     D transactDate    s              5p 0
     D fileToCheck     s              1s 0
     D lastElem        s             10i 0
     D errMsg          s            500a   varying inz('')
     D action          s              1s 0
     D errorMessage    s            100a
     D includeRecord   s              1a   inz('N')
     D compAveRate     s             11s 7 inz(0)
     D finalAveRate    s             15s 9 inz(0)
     D logData         s          25000a   varying
     D isError         s               n   inz(false)
     D isException     s               n   inz(false)
     D writeLogs       S              1a
     D strDate         s              5s 0
     D endDate         s              5s 0
     D writeRecord     s              1a                                                    MD058040

      *---------------*
      ** JSON Details *
      *---------------*

     D summary_t       ds                  qualified
     D                                     template
     D   intPrdDate                  10a
      ** Interest Period Date
      ** NCCR, CCR, SAVG, SARR
     D   intPDMidas                   5s 0
      ** Interest Period Date in Midas Format
     D   intPrdDays                   5s 0
      ** Interest Period Days
      ** NCCR, CCR, SAVG, SARR
     D   obsPrdDate                  10a
      ** Observation Period Date
      ** NCCR
     D   intOPMidas                   5S 0
      ** Observation Period Date in Midas Format
     D   obsPrdDays                   5s 0
      ** Observation Period Days
      ** NCCR
     D   pubRskFrRt                  17s12
      ** Published Risk Free Rate
      ** NCCR, CCR, SAVG, SARR
     D   rateApplied                 17s12
      ** Rate Applied
      ** NCCR, CCR, SAVG, SARR
     D   rskFrRtFlAp                  5a
      ** Risk Free Rate Floor Applied
      ** NCCR, CCR, SAVG, SARR
     D   compFactor                  17a
      ** Compounding Factor
      ** NCCR
     D   dlyCompRate                 17a
      ** Daily Compunded Rate
      ** NCCR
     D   aveCompRate                 17a
      ** Average Compunded Rate
      ** CCR
     D   simpleAve                   17a
      ** Simple Average
      ** SAVG

     D request_t       ds                  qualified
     D                                     template
     D   intPrdStart                 10a
      ** Interest Period Start
     D   intPrdEnd                   10a
      ** Interest Period End
     D   rskFreeRate                  4a
      ** Risk Free Rate
     D   rskFreeRtFl                 15s 6
      ** Risk Free Rate Floor
     D   obsPrdShift                  8s 0
      ** Observation Period Shift
     D   ratRndDecPts                 8s 0
      ** Rate Rounding Decimal Points
     D   showDailyDet                 8s 0
      ** Show Daily Details

     D result          ds                  qualified
     D   success                      1n
      ** Success
     D   errmsg                     500a   varying
      ** Error Message
     D   statusCode                   4a   varying
      ** Status Code
     D   message                     10a   varying
      ** Message
     D   comment                    500a   varying
      ** Comment
     D   lastUpdFrSrc               200a   varying
      ** Last Updated From Source
     D   legalDisc                  200a   varying
      ** Legal Disclaimer
     D   reqParms                          likeds(request_t)
      ** Request Parameters
     D   list                              likeds(summary_t) dim(999)
      ** Daily Rate Summary
     D   errors                            likeds(exception_t)
      ** Exception Parameters

     D exception_t     ds                  qualified
     D                                     template
     D   title                       50a
      ** Title
     D   exceptionMsg               100a
      ** Exception Message
     D   status                       4a
      ** Status

     D SDBANK        e ds                  extname(SDBANKPD)
     D                 DS
     D ISODate                 1     10
     D WkYear                  3      4  0
     D WkMonth                 6      7  0
     D WkDay                   9     10  0

     D                 DS
     D YYMMDD                  1      6
     D WkY                     1      2
     D WkM                     3      4
     D WkD                     5      6

     D                 DS
     D DateIN_D                1      6  0
     D DD1D                    1      2  0
     D DD1M                    3      4  0
     D DD1Y                    5      6  0
     D                 DS
     D DateIN_M                1      6  0
     D DD2M                    1      2  0
     D DD2D                    3      4  0
     D DD2Y                    5      6  0

     D reqParms        s                   like(yajl_val)
     D errors          s                   like(yajl_val)
     D docNode         s                   like(yajl_val)
     D list            s                   like(yajl_val)
     D node            s                   like(yajl_val)
     D val             s                   like(yajl_val)
     D cStr            S             10a   Varying

      ** +--------------------------------------+
      ** ¦ Array declaration                    ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D arrCalLoc       s            100a   dim(4) ctdata perrcd(1)

      /free

       // ** +--- Start of Main processing -----------------------------------+
       // ** ¦                                                                ¦
       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
       // ** ¦ executed at program activation.                                ¦
       // ** ¦                                                                ¦
       // ** +----------------------------------------------------------------+

       // Set compile options for this program, Commit = *Chg is specified to
       // ensure that commit/rollback processing would be peformed

                   exec sql
                      set option
                         Naming    = *Sys,
                         Commit    = *Chg,
                         UsrPrf    = *Owner,
                         DynUsrPrf = *Owner,
                         Datfmt    = *iso,
                         CloSqlCsr = *EndMod;

                   exsr processTransaction;

                   *Inlr = *On;
                   return;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // inzsr - Program Initialisation routine                     *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr *inzsr;

                   //Initialise audit log DS
                   clear AuditLogDS;
                   isError = false;

                   AuditLogDS.SJMODI = moduleID;
                   AuditLogDS.SJTREF = transactREF;
                   AuditLogDS.SJSTAT = 'C';
                   AuditLogDS.SJMDAY = 0;

                   pOption = '*FIRST';
                   pReturnCode = *Blanks;

                   callp ACCESS_SDBANK(
                                  pReturnCode
                                : pOption
                                : dsfdy
                               );
                   SDBANK = dsfdy;

                   if pReturnCode <> *blanks;
                      AuditLogDS.SJTMST = %timestamp();
                      AuditLogDS.SJEXMS = 'Error in access SDBANKPD';
                      AuditLogDS.SJCODE = '001';
                      isError = True;
                      exsr errorHandler;
                   endif;

                   AuditLogDS.SJMDAY = BJRDNB;
                   pOP01 = 'ARRAdapterURL';
                   pOP02 = 'ARRCalculatorTrace';

                   CallP ACCESS_SVAL(
                                       pRetCode
                                     : pOP01
                                     : pVL01
                                     : pOP02
                                     : pVL02
                                     : pOP03
                                     : pVL03
                                     : pOP04
                                     : pVL04
                                     : pOP05
                                     : pVL05
                                     : pOP06
                                     : pVL06
                                     : pOP07
                                     : pVL07
                                     : pOP08
                                     : pVL08
                                     : pOP09
                                     : pVL09
                                     : pOP10
                                     : pVL10
                                       );

                   If pRetCode <> *Blanks;
                        AuditLogDS.SJTMST = %timestamp();
                        AuditLogDS.SJEXMS = 'Error in access SDSVALPD ' +
                          %trim(Pvl01);
                        AuditLogDS.SJCODE = '002';
                        isError = True;
                        exsr errorHandler;
                   Endif;

                   If pVL01 <> *Blanks;
                         CalcMetURL     = HTTP_HEAD  + %trim(pVL01);
                   Else;
                        AuditLogDS.SJTMST = %timestamp();
                        AuditLogDS.SJEXMS = 'Error in access SDSVALPD ' +
                          %trim(calcMetURL);
                        AuditLogDS.SJCODE = '003';
                        isError = True;
                        exsr errorHandler;
                   Endif;

                   writeLogs = pVL02;

                   select;

                       when calcMethod = 'NCCR';
                            calcMetURL =  %trim(calcMetURL) +
                              %trim(arrCalLoc(1));

                       when calcMethod = 'CCR';
                            calcMetURL =  %trim(calcMetURL) +
                              %trim(arrCalLoc(2));

                       when calcMethod = 'SARR';
                            calcMetURL =  %trim(calcMetURL) +
                              %trim(arrCalLoc(3));

                       when calcMethod = 'SAVG';
                            calcMetURL =  %trim(calcMetURL) +
                              %trim(arrCalLoc(4));

                   endsl;

                   // Get the highest date in the Daily History file
                   wSQLStr = 'select * from SDHSDRTD ' +
                             ' where CMODID = ' + QUO + moduleID + QUO +
                             ' and CTRNID = ' +  QUO + transactREF + QUO +
                             ' order by CINPDT DESC';

                   exec sql prepare P1 from :wSQLStr;
                   exec sql declare P1 cursor for P1;
                   exec sql open P1;
                   exec sql fetch next From P1 into :DailyHistDS;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                        AuditLogDS.SJTMST = %timestamp();
                        AuditLogDS.SJEXMS = 'Error in access SDHSDRTD ' +
                          %trim(wSQLSTR);
                        AuditLogDS.SJCODE = '004';
                        isError = True;
                        exsr errorHandler;
                   endif;

                   if sqlCod = NO_RECORD;
                      transactDate = 0;
                   else;
                      transactDate = DailyHistDS.CINPDT;
                   endif;

                   exec sql close P1;

                   // Set Current Interest Period Flag to N
                   eval strDate = %dec(intPrdStrMDAY:5:0);
                   eval endDate = %dec(intPrdEndMDAY:5:0);
                   exec sql  update SDHSDRTD set CINFLG = 'N'
                    where CMODID = :moduleID
                    and   CTRNID = :transactREF
                    and   CINPSD <> :strDate
                    and   CINPED <> :endDate;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                     AuditLogDS.SJTMST = %timestamp();
                     AuditLogDS.SJEXMS = 'Error in access SDHSDRTD '
                                       + 'SQL ERROR ' + %char(sqlCod);
                     AuditLogDS.SJCODE = '005';
                     isError = true;
                     exsr errorHandler;
                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // processTransaction - Process a Loan Transaction            *
       // ==================                                         *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr processTransaction;

                   //** This will build the URL parameter for the REST API Call

                   exsr buildParameter;

                   //** This will call the http_string function from LIBHTTP123
                   //** to consume the Rest API

                   exsr consumeRESTAPI;

                   if not(isError);

                      //** This will parse the JSON data returned from ARR Calculator
                      //** and store it to an array of Data Structure

                      exsr parseJSONData;

                      //** This will handle the output of the array DS to the
                      //** history and extract files

                      exsr outputFiles;

                      //** log details to audit file

                      exsr writeToAuditLog;

                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // buildParameter - Build REST API Parameter                  *
       // ==============                                             *
       //                                                            *
       // Called by: processTransaction                              *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr buildParameter;

                   if not(riskFreeRatFl = BLANK_FLOOR);                                   //MD057871

                      RestAPIParm =    %trim(CalcMetURL) +
                                    QUE + 'interestPeriodStartDate=' +
                                      %trim(intPrdStartDt) +
                                    AMP + 'interestPeriodEndDate=' +
                                      %trim(intPrdEndDt) +
                                    AMP + 'riskFreeRate=' +
                                      %trim(riskFreeRate) +
                                    AMP + 'lookBackDays=' +
                                      %trim(lookBackDays)  +
                                    AMP + 'rateRoundingDecimalPoints=' +
                                      %trim(RateRndDecPts) +
                                    AMP + 'dayCountConvention=' +
                                      %trim(dayCntConvent) +
                                    AMP + 'observationPeriodShift=' +
                                      %trim(obserPrdShift) +
                                    AMP + 'lockoutDays=' +
                                       %trim(lockOutDays) +
                                    AMP + 'showDailyDetails=' +
                                      %trim(showDailyDeta) +
                                    AMP + 'calculateTillDate=' +
                                      %trim(callTillDate) +
                                    AMP + 'riskFreeRateFloor=' +
                                      %trim(riskFreeRatFl);

                   else;                                                                  //MD057871
                                                                                          //MD057871
                      RestAPIParm =    %trim(CalcMetURL) +                                //MD057871
                                    QUE + 'interestPeriodStartDate=' +                    //MD057871
                                      %trim(intPrdStartDt) +                              //MD057871
                                    AMP + 'interestPeriodEndDate=' +                      //MD057871
                                      %trim(intPrdEndDt) +                                //MD057871
                                    AMP + 'riskFreeRate=' +                               //MD057871
                                      %trim(riskFreeRate) +                               //MD057871
                                    AMP + 'lookBackDays=' +                               //MD057871
                                      %trim(lookBackDays)  +                              //MD057871
                                    AMP + 'rateRoundingDecimalPoints=' +                  //MD057871
                                      %trim(RateRndDecPts) +                              //MD057871
                                    AMP + 'dayCountConvention=' +                         //MD057871
                                      %trim(dayCntConvent) +                              //MD057871
                                    AMP + 'observationPeriodShift=' +                     //MD057871
                                      %trim(obserPrdShift) +                              //MD057871
                                    AMP + 'lockoutDays=' +                                //MD057871
                                       %trim(lockOutDays) +                               //MD057871
                                    AMP + 'showDailyDetails=' +                           //MD057871
                                      %trim(showDailyDeta) +                              //MD057871
                                    AMP + 'calculateTillDate=' +                          //MD057871
                                      %trim(callTillDate);                                //MD057871
                                                                                          //MD057871
                   endif;                                                                 //MD057871

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // consumeRESTAPI - Consume REST API                          *
       // ==============                                             *
       //                                                            *
       // Called by: processTransaction                              *
       //                                                            *
       // Calls: LIBHTTP123/http_string                              *
       //                                                            *
       //*************************************************************

       begsr consumeRestAPI;

              monitor;

                 clear jsonData;
                 jsonData = http_string( 'GET' : %trim(RestAPIParm));
                 msg = *blanks;
                 err = 0;

              on-error;

                 msg = http_error(err);
                 errorMessage = %trim(msg);
                 returnCD = 'CONNECTION_ERROR';
                 isError = True;
                 AuditLogDS.SJTMST = %timestamp();
                 AuditLogDS.SJEXMS = %trim(msg);
                 AuditLogDS.SJCODE = '999';
                 exsr errorHandler;

              endmon;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // parseJSONData - Parse JSON Data                            *
       // =============                                              *
       //                                                            *
       // Called by: processTransaction                              *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr parseJSONData;

                   // Load JSON data variable into a tree like structure

                   docNode = yajl_buf_load_tree( %addr(jsonData:*data)
                             : %len(jsonData)
                             : ErrMsg );

                   if errMsg <> '';
                      errorMessage = errMsg;
                      isError = true;
                      exsr errorHandler;
                   endif;

                   node = YAJL_object_find(docNode: 'comment');
                   result.comment = YAJL_get_string(node);

                   node = YAJL_object_find(docNode: 'errmsg');
                   result.errmsg  = yajl_get_string(val);

                   // Exception messages
                   node = YAJL_object_find(docNode: 'exception');
                   if node <> *null;

                       isException = true;
                       val = YAJL_object_find(node: 'title');
                       result.errors.title = yajl_get_string(val);

                       val = YAJL_object_find(node: 'exceptionMessage');
                       result.errors.exceptionMsg = yajl_get_string(val);

                       val = YAJL_object_find(node: 'status');
                       result.errors.status = yajl_get_string(val);

                       // free up memory used by YAJL
                       yajl_tree_free(docNode);

                       exsr errorHandler;

                   endif;


                   list = YAJL_object_find(docNode: 'dailyRateSummary');

                   clear result.list;

                   i = 0;
                   dow YAJL_ARRAY_LOOP( list: i: node );

                       lastElem = i;

                       // All calculation methods
                       val = YAJL_object_find(node: 'interestPeriodDate');
                       result.list(i).intPrdDate = yajl_get_string(val);

                       ISODate =  result.list(i).intPrdDate;

                       monitor;

                           WKY = %editc(wkYear:'X');
                           WKM = %editc(wkMonth:'X');
                           WKD = %editc(wkDay:'X');

                           if BJDFIN = 'D';
                              DD1D = wkDay;
                              DD1M = wkMonth;
                              DD1Y = wkYear;
                              DateIn = DateIn_D;
                           else;
                              DD2D = wkDay;
                              DD2M = wkMonth;
                              DD2Y = wkYear;
                              DateIn = DateIn_M;
                           endif;

                           pOption = '*FIRST';
                           pReturnCode = *Blanks;
                           callp CONVERT_DATE(
                                      ErrorFlag
                                    : DateIN
                                    : BJDFIN
                                    : DateOUT
                                   );

                           if ErrorFlag   <> *blanks;
                                AuditLogDS.SJTMST = %timestamp();
                                AuditLogDS.SJEXMS = 'Error in date conversion';
                                AuditLogDS.SJCODE = '006';
                                isError = True;
                                exsr errorHandler;
                           endif;

                           result.list(i).intPDMidas = DateOUT;

                       on-error;
                       endmon;

                       // All calculation methods
                       val = YAJL_object_find(node: 'interestPeriodDays');
                       cStr =  yajl_get_string(val);
                       result.list(i).intPrdDays =  %dec(%trim(cStr):5:0);

                       val =
                          YAJL_object_find(node: 'observationPeriodDate');
                       result.list(i).obsPrdDate =
                          yajl_get_string(val);

                       ISODate =  result.list(i).obsPrdDate;

                       monitor;
                            WKY = %editc(wkYear:'X');
                            WKM = %editc(wkMonth:'X');
                            WKD = %editc(wkDay:'X');

                            if BJDFIN = 'D';
                                 DD1D = wkDay;
                                 DD1M = wkMonth;
                                 DD1Y = wkYear;
                                 DateIn = DateIn_D;
                            else;
                                 DD2D = wkDay;
                                 DD2M = wkMonth;
                                 DD2Y = wkYear;
                                 DateIn = DateIn_M;
                             endif;

                             pOption = '*FIRST';
                             pReturnCode = *Blanks;
                             callp CONVERT_DATE(
                                  ErrorFlag
                                : DateIN
                                : BJDFIN
                                : DateOUT
                               );

                             if ErrorFlag   <> *blanks;
                                AuditLogDS.SJTMST = %timestamp();
                                AuditLogDS.SJEXMS = 'Error in date conversion';
                                AuditLogDS.SJCODE = '007';
                                isError = True;
                                exsr errorHandler;
                             endif;

                             result.list(i).intOPMidas = DateOUT;

                       on-error;
                       endmon;

                       val =
                           YAJL_object_find(node: 'observationPeriodDays');

                       monitor;
                           cStr =  yajl_get_string(val);
                           result.list(i).obsPrdDays = %dec(%trim(cStr):5:0);
                       on-error;
                       endmon;

                       // All calculation methods
                       val = YAJL_object_find(node: 'publishedRiskFreeRate');

                       cStr  =  yajl_get_string(val);
                       result.list(i).pubRskFrRt =  %dec(%trim(cStr):17:12);

                       // All calculation methods
                       val = YAJL_object_find(node: 'rateApplied');
                       cStr  =  yajl_get_string(val);

                       monitor;
                          result.list(i).rateApplied =  %dec(%trim(cStr):17:12);
                       on-error;
                       endmon;

                       // All calculation methods
                       val = YAJL_object_find(node: 'riskFreeRateFloorApplied');
                       if YAJL_is_true(node);
                           result.list(i).rskFrRtFlAp = 'True';
                       else;
                           result.list(i).rskFrRtFlAp = 'False';
                       endif;

                       if calcMethod = 'NCCR';
                            val = YAJL_object_find(node: 'compoundingFactor');
                            result.list(i).compFactor =  yajl_get_string(val);

                            val =
                              YAJL_object_find(node: 'dailyCompoundedRate');
                            result.list(i).dlyCompRate =
                              yajl_get_string(val);
                       endif;

                       if calcMethod = 'CCR';
                            val =
                              YAJL_object_find(node: 'averageCompoundedRate');
                            result.list(i).aveCompRate =  yajl_get_string(val);

                       endif;

                       if calcMethod = 'SAVG';
                            val =
                              YAJL_object_find(node: 'simpleAverageRate');
                            result.list(i).simpleAve =  yajl_get_string(val);

                       endif;

                   enddo;

                   // free up memory used by YAJL
                   yajl_tree_free(docNode);

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // outputFile - Output Files                                  *
       // ==========                                                 *
       //                                                            *
       // Called by: processTransaction                              *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr outputFiles;

                   i = 1;

                   dow i <= lastElem;

                       // Output information to SDARRLOGTD
                       exsr writeToARRDailyHistory;

                       //Output information to LELIBEPD
                       exsr writeToExtractFile;

                       i = i + 1;

                   enddo;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // writeToARRDailyHistory - Write to ARR Daily Rates History  *
       // ======================                                     *
       //                                                            *
       // Called by: Output File                                     *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr writeToARRDailyHistory;

                   includeRecord = 'N';

                   if (calcMethod = 'NCCR' or calcMethod  = 'SARR')
                   and  result.list(i).intPDMidas > transactDate;
                        includeRecord = 'Y';

                   elseif  (calcMethod = 'CCR' or calcMethod  = 'SAVG');
                        includeRecord = 'Y';
                   endif;

                   if result.list(i).intPDMidas <= controlDate;                           //MD058182
                        includeRecord = 'Y';                                              //MD058182
                   else;                                                                  //MD058182
                        includeRecord = 'N';                                              //MD058182
                   endif;                                                                 //MD058182

                   fileToCheck = SDHSDRTD;
                   if includeRecord = 'Y';
                      exsr checkExist;
                      if action = INSERT;
                          exsr insertHistoryFile;
                      elseif action = UPDATE;
                          exsr updateHistoryFile;
                      endif;
                   endif;

       endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // checkExist - Check if a record exist on a given file       *
       // ==========                                                 *
       //                                                            *
       // Called by: Output File                                     *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr checkExist;

                   if fileToCheck = SDHSDRTD;
                        wSQLStr = 'select * from SDHSDRTD ' +
                                  'where CMODID = '  + QUO + moduleID + QUO +
                                  ' and CTRNID = ' + QUO + transactREF + QUO +
                                  ' and CINPDT = ' +
                                    %char(result.list(i).intPDMidas);
                   elseif fileToCheck = LELIBEPD;
                        wSQLStr = 'select * from LELIBEPD ' +
                                  'where LDLNRF = ' + QUO + transactREF + QUO +
                                  ' and LDINDT = ' +
                                    %char(result.list(i).intPDMidas);
                   elseif fileToCheck = SDHSDRTD2;                                        //MD058040
                        wSQLStr = 'select * from SDHSDRTD ' +                             //MD058040
                                  'where CMODID = '  + QUO + moduleID + QUO +             //MD058040
                                  ' and CTRNID = ' + QUO + transactREF + QUO +            //MD058040
                                  ' and CINPDT = ' +                                      //MD058040
                                    %char(result.list(i).intPDMidas) +                    //MD058040
                                  ' and CINPDT < '  + %char(BJRDNB)  +                    //MD058040
                                  ' and CRORED <> ' + %char(BJRDNB);                      //MD058040
                   endif;

                   exec sql prepare P1 from :wSQLStr;
                   exec sql open P1;

                   if fileToCheck = SDHSDRTD;
                        exec sql fetch next From P1 into :DailyHistDS;
                   elseif fileToCheck = LELIBEPD;
                        exec sql fetch next From P1 into :ExtractFLDS;
                   elseif fileToCheck = SDHSDRTD2;                                        //MD058040
                        exec sql fetch next From P1 into :DailyHistDS;                    //MD058040
                   endif;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                       AuditLogDS.SJTMST = %timestamp();
                       AuditLogDS.SJEXMS = 'Error in access '
                                         + ' SQL ERROR ' + %char(sqlCod);
                       AuditLogDS.SJCODE = '008';
                       isError = true;
                       exsr errorHandler;
                   endif;

                   if sqlCod = NO_RECORD;
                      action = INSERT;
                   else;
                      action = UPDATE;
                   endif;

                   // If extracted rate is different to ARR History File,                 //MD058040
                   // write record to Extract File                                        //MD058040
                   writeRecord = 'N';                                                     //MD058040
                   if sqlCod = NO_RECORD and fileToCheck = SDHSDRTD2;                     //MD058040
                      writeRecord = 'Y';                                                  //MD058040
                   endif;                                                                 //MD058040
                                                                                          //MD058040
                   if sqlCOD <> NO_RECORD and fileToCheck = SDHSDRTD2;                    //MD058040
                      select;                                                             //MD058040
                         when calcMethod = 'NCCR'                                         //MD058040
                          and DailyHistDS.CDCMRT <>                                       //MD058040
                   //**********%dec(Result.List(i).dlyCompRate:11:7);           //MD058040 MD058040A
                               %dec(Result.List(i).dlyCompRate:17:12);                   //MD058040A
                            writeRecord = 'Y';                                            //MD058040
                                                                                          //MD058040
                         when calcMethod = 'CCR'                                          //MD058040
                          and DailyHistDS.CAVCRT <>                                       //MD058040
                   //**********%dec(Result.List(i).aveCompRate:11:7);           //MD058040 MD058040A
                               %dec(Result.List(i).aveCompRate:17:12);                   //MD058040A
                            writeRecord = 'Y';                                            //MD058040
                                                                                          //MD058040
                         when calcMethod = 'SARR'                                         //MD058040
                          and DailyHistDS.CRTEAP <>                                       //MD058040
                   //**********%dec(Result.List(i).rateApplied:11:7);           //MD058040 MD058040A
                               %dec(Result.List(i).rateApplied:17:12);                   //MD058040A
                            writeRecord = 'Y';                                            //MD058040
                                                                                          //MD058040
                         when calcMethod = 'SAVG'                                         //MD058040
                          and DailyHistDS.CSMPAV<>                                        //MD058040
                   //**********%dec(Result.List(i).simpleAve:11:7);             //MD058040 MD058040A
                               %dec(Result.List(i).simpleAve:17:12);                     //MD058040A
                            writeRecord = 'Y';                                            //MD058040
                      endsl;                                                              //MD058040
                   endif;                                                                 //MD058040
                                                                                          //MD058040
                   exec sql close P1;

       endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // insertHistoryFile                                          *
       // =================                                          *
       //                                                            *
       // Called by: writeToARRDailyHistory                          *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr insertHistoryFile;

                   clear DailyHistDS;
                   DailyHistDS.CMODID = moduleID;
                   DailyHistDS.CTRNID = transactREF;
                   DailyHistDS.CCALCM = calcMethod;
                   DailyHistDS.CINPSD = %dec(intPrdStrMDAY:5:0);
                   DailyHistDS.CINPED = %dec(intPrdEndMDAY:5:0);
                   DailyHistDS.CINFLG = 'Y';
                   DailyHistDS.CINPDT = result.list(i).intPDMidas;
                   DailyHistDS.CINPDY = result.list(i).intPrdDays;
                   DailyHistDS.COBPDT = result.list(i).intOPMidas;
                   DailyHistDS.COBPDY = result.list(i).obsPrdDays;
                   DailyHistDS.CPBRFR = result.list(i).pubRskFrRt;
                   DailyHistDS.CRTEAP = result.list(i).rateApplied;
                   if result.list(i).rskFrRtFlAp = 'true';
                      DailyHistDS.CRFRAP = 'Y';
                   else;
                      DailyHistDS.CRFRAP = 'N';
                   endif;
                   DailyHistDS.CTIMST = %timestamp();
                   DailyHistDS.CRORED = BJRDNB;                                           //MD058040
                   DailyHistDS.CRLCDT = BJRDNB;                                           //MD058040

                   select;
                        when calcMethod = 'NCCR';
                             DailyHistDS.CDCMRT =
                               %Dec(Result.List(i).dlyCompRate:17:12);
                             DailyHistDS.CCMFAC =
                               %Dec(Result.List(i).compFactor:17:12);
                        when calcMethod = 'CCR';
                             DailyHistDS.CAVCRT =
                               %Dec(Result.List(i).aveCompRate:17:12);
                        when calcMethod = 'SAVG';
                             DailyHistDS.CSMPAV =
                               %Dec(Result.List(i).simpleAve:17:12);
                   endsl;

                   exec sql insert into SDHSDRTD
                   values (:DailyHistDS);

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                       AuditLogDS.SJTMST = %timestamp();
                       AuditLogDS.SJEXMS = 'Error in access SDHSDRTD '
                                         + 'SQL ERROR ' + %char(sqlCod);
                       AuditLogDS.SJCODE = '009';
                       isError = true;
                       exsr errorHandler;
                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // insertExtractFile                                          *
       // =================                                          *
       //                                                            *
       // Called by: writeToHistoryFile                               *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr insertExtractFile;

                   clear ExtractFLDS;
                   clear compAveRate;
                   clear finalAveRate;
                   ExtractFLDS.LDLNRF = transactREF;
                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
                   ExtractFLDS.LDINDT = result.list(i).intPDMidas;
                   ExtractFLDS.LDINPD = result.list(i).intPrdDays;

                   select;
                        when calcMethod = 'NCCR';
                             compAveRate =
                               %dec(Result.List(i).dlyCompRate:11:7);
                        when calcMethod = 'CCR';
                             ExtractFLDS.LDVDAT = %dec(intPrdStrMDAY:5:0);
                             compAveRate =
                               %dec(Result.List(i).aveCompRate:11:7);
                        when calcMethod = 'SARR';
                             compAveRate =
                               %dec(Result.List(i).rateApplied:11:7);
                        when calcMethod = 'SAVG';
                             ExtractFLDS.LDVDAT = %dec(intPrdStrMDAY:5:0);
                             compAveRate =
                               %dec(Result.List(i).simpleAve:11:7);
                   endsl;

                   finalAveRate = compAveRate + %dec(benchMarkAdj:11:7);
                   ExtractFLDS.LDCART = %dech(finalAveRate:11:7);

                   exec sql insert into LELIBEPD
                   values (:ExtractFLDS);

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      AuditLogDS.SJTMST = %timestamp();
                      AuditLogDS.SJEXMS = 'Error in access LELIBEPD '
                                       + 'SQL ERROR ' + %char(sqlCod);
                      AuditLogDS.SJCODE = '010';
                      isError = true;
                      exsr errorHandler;
                   endif;

       endsr;
       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // updateExtractFile                                          *
       // =================                                          *
       //                                                            *
       // Called by: writeToExtractFile                              *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr updateExtractFile;

                   clear ExtractFLDS;
                   clear compAveRate;
                   clear finalAveRate;
                   ExtractFLDS.LDLNRF = transactREF;
                   ExtractFLDS.LDVDAT = result.list(i).intPDMidas;
                   ExtractFLDS.LDINDT = result.list(i).intPDMidas;
                   ExtractFLDS.LDINPD = result.list(i).intPrdDays;

                   select;
                        when calcMethod = 'NCCR';
                             compAveRate =
                               %dec(Result.List(i).dlyCompRate:11:7);
                        when calcMethod = 'CCR';
                             ExtractFLDS.LDVDAT = %dec(intPrdStrMDAY:5:0);
                             compAveRate =
                               %dec(Result.List(i).aveCompRate:11:7);
                        when calcMethod = 'SARR';
                             compAveRate =
                               %dec(Result.List(i).rateApplied:11:7);
                        when calcMethod = 'SAVG';
                             ExtractFLDS.LDVDAT = %dec(intPrdStrMDAY:5:0);
                             compAveRate =
                               %dec(Result.List(i).simpleAve:11:7);
                   endsl;

                   finalAveRate = compAveRate + %dec(benchMarkAdj:11:7);
                   ExtractFLDS.LDCART = %dech(finalAveRate:11:7);

                   wSqlStr = 'update LELIBEPD A '  +
                              'SET A.LDCART = ' + %Char(ExtractFLDS.LDCART) +
                              ' where A.LDLNRF = ' + QUO + ExtractFLDS.LDLNRF
                                 + QUO +
                              ' and   A.LDINDT = ' +  %Char(ExtractFLDS.LDINDT);

                   exec sql
                   execute immediate :wSqlStr;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      AuditLogDS.SJTMST = %timestamp();
                      AuditLogDS.SJEXMS = 'Error in access LELIBEPD '
                                       + 'SQL ERROR ' + %char(sqlCod);
                      AuditLogDS.SJCODE = '011';
                      isError = true;
                      exsr errorHandler;
                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // writeToExtractFile - Write to Extract File                 *
       // ==================                                         *
       //                                                            *
       // Called by: Output File                                     *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr writeToExtractFile;

       //**********fileToCheck = LELIBEPD;                                                //MD058040
       // Check if the interest period date and rate is already                           //MD058040
       // inserted in ARR History File from the previous COB run                          //MD058040
       // (it means that the rate have already BR event record)                           //MD058040
                   fileToCheck = SDHSDRTD2;                                               //MD058040
                   exsr checkExist;

       //**********if action = INSERT;                                                    //MD058040
                   if writeRecord = 'Y';                                                  //MD058040
                        exsr insertExtractFile;

       //**********elseif action = UPDATE;                                                //MD058040
       //**********     exsr updateExtractFile;                                           //MD058040

                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // writeToAuditLog - Write to Audit Log                       *
       // ===============                                            *
       //                                                            *
       // Called by: Output File                                     *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr writeToAuditLog;

                   if isException;
                       AuditLogDS.SJTMST = %timestamp();
                       AuditLogDS.SJEXMS = result.errors.exceptionMsg;
                       AuditLogDS.SJCODE = result.errors.status;
                       AuditLogDS.SJSTAT = 'F';
                       if AuditLogDS.SJCODE = '400';
                          logData = RestAPIParm;
                          returnCD = 'EXCEPTION_ERROR';
                       endif;
                   else;
                       if not(isError);
                          AuditLogDS.SJTMST = %timestamp();
                          AuditLogDS.SJEXMS = 'ARR Calculator completed' +
                             ' successfully';
                          AuditLogDS.SJCODE = '000';
                          returnCD = 'SUCCESS';
                          AuditLogDS.SJSTAT = 'C';
                          logData = %Trim(jsonData);
                       else;
                          logData = %Trim(errorMessage);
                          AuditLogDS.SJSTAT = 'F';
                       endif;
                   endif;

                   // Write to audit log file if status is completed and
                   // system value ARRCalculatorTrace is Y
                   // OR status is failed and this is the last program call
                   // for the same transaction reference (i.e. RatesKnown = N)
                   if (AuditLogDS.SJSTAT = 'C' and writeLogs = 'Y') or
                      (AuditLogDS.SJSTAT = 'F' and RatesKnownInd = 'N');
                       exec sql insert into SDARRLOGTD
                       values (
                            : AuditLogDS.SJMODI,
                            : AuditLogDS.SJTREF,
                            : AuditLogDS.SJSTAT,
                            : AuditLogDS.SJMDAY,
                            : AuditLogDS.SJTMST,
                            : AuditLogDS.SJCODE,
                            : AuditLogDS.SJEXMS,
                            : logData
                       );
                       if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                          AuditLogDS.SJTMST = %timestamp();
                          AuditLogDS.SJEXMS = 'Error in access SDARRLOGTD';
                          AuditLogDS.SJCODE = '012';
                          isError = True;
                          exsr errorHandler;
                       endif;
                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // updateHistoryFile                                          *
       // =================                                          *
       //                                                            *
       // Called by: writeToARRDailyHistory                          *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr updateHistoryFile;

                   clear DailyHistDS;
                   DailyHistDS.CMODID = moduleID;
                   DailyHistDS.CTRNID = transactREF;
                   DailyHistDS.CCALCM = calcMethod;
                   DailyHistDS.CINPSD = %dec(intPrdStrMDAY:5:0);
                   DailyHistDS.CINPED = %dec(intPrdEndMDAY:5:0);
                   DailyHistDS.CINFLG = 'Y';
                   DailyHistDS.CINPDT = result.list(i).intPDMidas;
                   DailyHistDS.CINPDY = result.list(i).intPrdDays;
                   DailyHistDS.COBPDT = result.list(i).intOPMidas;
                   DailyHistDS.COBPDY = result.list(i).obsPrdDays;
                   DailyHistDS.CPBRFR = result.list(i).pubRskFrRt;
                   DailyHistDS.CRTEAP = result.list(i).rateApplied;
                   DailyHistDS.CRLCDT = BJRDNB;                                           //MD058040
                   if result.list(i).rskFrRtFlAp = 'true';
                      DailyHistDS.CRFRAP = 'Y';
                   else;
                      DailyHistDS.CRFRAP = 'N';
                   endif;
                   DailyHistDS.CTIMST = %timestamp();

                   select;
                        when calcMethod = 'NCCR';
                             DailyHistDS.CDCMRT =
                               %dec(Result.List(i).dlyCompRate:17:12);
                             DailyHistDS.CCMFAC =
                               %dec(Result.List(i).compFactor:17:12);
                        when calcMethod = 'CCR';
                             DailyHistDS.CAVCRT =
                               %dec(Result.List(i).aveCompRate:17:12);
                        when calcMethod = 'SAVG';
                             DailyHistDS.CSMPAV =
                               %dec(Result.List(i).simpleAve:17:12);
                   endsl;

                   wSqlStr = 'update SDHSDRTD A SET '  +
                              'A.CCALCM = ' + QUO + %trim(DailyHistDS.CCALCM) +
                               QUO + ' , ' +
                              'A.CINPSD = ' + %char(DailyHistDS.CINPSD) +
                               ' , ' +
                              'A.CINPED = ' + %char(DailyHistDS.CINPED) +
                               ' , ' +
                              'A.CINFLG = ' + QUO + %trim(DailyHistDS.CINFLG) +
                               QUO + ' , ' +
                              'A.CINPDT = ' + %char(DailyHistDS.CINPDT) +
                              ' , ' +
                              'A.CINPDY = ' + %char(DailyHistDS.CINPDY) +
                              ' , ' +
                              'A.COBPDT = ' + %char(DailyHistDS.COBPDT) +
                              ' , ' +
                              'A.COBPDY = ' + %char(DailyHistDS.COBPDY) +
                              ' , ' +
                              'A.CPBRFR = ' + %char(DailyHistDS.CPBRFR) +
                              ' , ' +
                              'A.CRTEAP = ' + %char(DailyHistDS.CRTEAP) +
                              ' , ' +
                              'A.CRFRAP = ' + QUO + %trim(DailyHistDS.CRFRAP) +
                              QUO + ' , ' +
                              'A.CAVCRT = ' + %char(DailyHistDS.CAVCRT) +
                              ' , ' +
                              'A.CCMFAC = ' + %char(DailyHistDS.CCMFAC) +
                              ' , ' +
                              'A.CDCMRT = ' + %char(DailyHistDS.CDCMRT) +
                              ' , ' +
                              'A.CSMPAV = ' + %char(DailyHistDS.CSMPAV) +
                              ' , ' +
                              'A.CTIMST = ' + QUO + %char(DailyHistDS.CTIMST) +
                              QUO +
                              ' , ' +                                                     //MD058040
                              'A.CRLCDT = ' + %char(DailyHistDS.CRLCDT) +                 //MD058040
                              ' where A.CMODID = ' +
                                QUO + %trim(moduleID) + QUO +
                              ' and   A.CTRNID = ' +
                                QUO + %trim(transactREF) + QUO +
                              ' and CINPDT = ' +
                                      %char(DailyHistDS.CINPDT);

                   exec sql
                   execute immediate :wSqlStr;

                   if sqlCod <> NO_ERROR and sqlCod <> NO_RECORD;
                      AuditLogDS.SJTMST = %timestamp();
                      AuditLogDS.SJEXMS = 'Error in access SDHSDRTD '
                                       + 'SQL ERROR ' + %char(sqlCod);
                      AuditLogDS.SJCODE = '013';
                      isError = true;
                      exsr errorHandler;
                   endif;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   errorHandler  - Program Error Processing Subroutine.     *
       //                                                            *
       //   Called By: Main Processing, various subroutines          *
       //                                                            *
       //*************************************************************

       begsr *pssr;
                   *inu7 = *on;
                   *inu8 = *on;
                   *Inlr = *on;
                   dump;
                   return;
       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   errorHandler                                             *
       //                                                            *
       //   Called By: Main Processing, various subroutines          *
       //                                                            *
       //*************************************************************

       begsr errorHandler;

                   exsr writeToAuditLog;
                   *Inlr = *on;
                   return;
       endsr;

       //*************************************************************

      /end-free

     C/COPY ZSRSRC,ZACCHLE
     C/COPY ZSRSRC,ZBKDT_ILE
     C/COPY ZSRSRC,ZFWDT_ILE
** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2020
** arrCalLoc
/corporate/lending/alternative-reference-rates/v1/daily-compounding/rates
/corporate/lending/alternative-reference-rates/v1/compounded-in-arrears/average-rate
/corporate/lending/alternative-reference-rates/v1/simple-arr/rates
/corporate/lending/alternative-reference-rates/v1/simple-average/rates
