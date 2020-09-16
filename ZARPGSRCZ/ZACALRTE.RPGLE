000100200916     H DEBUG
000101200903     H DFTACTGRP(*NO)
000102200903     H COPYRIGHT('(c) Finastra International Limited 2020')
000104200903      *****************************************************************
000105200904/*STD *  RPGBASEBND                                                   *
000106200907/*EXI *  TEXT('Midas SD API - Calculate Term Rate')                   *
000107200903      *****************************************************************
000108200903      *                                                               *
000109200903      *  Midas - Midas Standing Dat API - Calculate Term Rate         *
000110200903      *                                                               *
000111200907      *  ZACALRTE - Midas API - Calculate Term Rate                   *
000112200903      *                                                               *
000113200903      *  (c) Finastra International Limited 2020                      *
000114200903      *                                                               *
000115200903      *  Last Amend No. CSD103 *CREATE     Date 10Aug20               *
000122200903      *                                                               *
000123200903      *****************************************************************
000124200903      *                                                               *
000137200903      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
000138200903      *                                                               *
000139200904      *****************************************************************
000140200904
000141200904     FSDBSHSL1  IF   E           K DISK
000142200904
000143200903      **---------------------------------------------------------------
000144200903      ** The following /COPY line includes all the defined fields in
000145200903      ** the Program Status Data Structures.  They have meaningful
000146200903      ** names, prefixed by 'PS'.
000147200904
000148200903     D/COPY ZACPYSRC,PSDS
000149200903     D/COPY ZACPYSRC,STD_D_SPEC
000150200911     D/COPY ZSRSRC,ZINTDYZ1LE
000154200910     D/COPY ZSRSRC,ZHOLILE
000155200911     D/COPY ZSRSRC,ZHOLELE
000158200903
000159200903      ** +--------------------------------------+
000160200903      ** ¦ Program Prototypes                   ¦
000161200903      ** ¦ ==================                   ¦
000162200903      ** +--------------------------------------+
000163200913
000164200913      *  +----------------+
000165200913      ** |Parameter lists |
000166200913      ** +----------------+
000167200913
000168200910     D Main            pr                  extpgm('ZACALRTE')
000169200905
000170200911     D  transactCCY                   3a
000171200905      ** Transaction Currency (input)
000172200911     D  baseRateCode                  2a
000173200905      ** Base Rate Code (input)
000174200911     D  calcBasis                     1a
000175200905      ** Calculation Basis (input)
000176200910     D  startDate                     5s 0
000177200905      ** Start Date of Compounding (input)
000178200910     D  endDate                       5s 0
000179200905      ** End Date of Compounding (input)
000180200910     D  lookBackDays                  2s 0
000181200905      ** Number of Days Lookback (input)
000182200910     D  lockOutDays                   2s 0
000183200905      ** Number of Days Lockout (input)
000184200911     D  averagingOpt                  1a
000185200905      ** Averaging Option (input)
000186200905      **    1 - Compund Average
000187200905      **    2 - Simple Average in Arrears
000188200905      **    3 - No Averaging (Base Rates File)
000189200905      **    4 - No Averaging (User Input)
000190200910      *
000191200910     D  weightConv                    1a
000192200905      ** Weight Convention (input)
000193200907      **    1 - Based on the day in the interest period
000194200907      **    2 - Based on the day in the observation period
000195200910     D  includeEndDat                 1a
000196200905      ** Include End Date in Compounding Flag (Y/N)
000197200910     D  provRateFlg                   1a
000198200910      ** Provisional Rate Flag (output)
000199200911     D  returnRate                   20p15
000200200905      ** Compounded/Average Rate (output)
000203200905
000204200903     D Main            pi
000205200910
000206200910     D  transactCCY                   3a
000207200910      ** Transaction Currency (input)
000208200911     D  baseRateCode                  2a
000209200910      ** Base Rate Code (input)
000210200911     D  calcBasis                     1a
000211200910      ** Calculation Basis (input)
000212200910     D  startDate                     5s 0
000213200910      ** Start Date of Compounding (input)
000214200910     D  endDate                       5s 0
000215200910      ** End Date of Compounding (input)
000216200910     D  lookBackDays                  2s 0
000217200910      ** Number of Days Lookback (input)
000218200910     D  lockOutDays                   2s 0
000219200910      ** Number of Days Lockout (input)
000220200911     D  averagingOpt                  1a
000221200910      ** Averaging Option (input)
000222200910      **    1 - Compund Average
000223200910      **    2 - Simple Average in Arrears
000224200910      **    3 - No Averaging (Base Rates File)
000225200910      **    4 - No Averaging (User Input)
000226200910      *
000227200910     D  weightConv                    1a
000228200910      ** Weight Convention (input)
000229200910      **    1 - Based on the day in the interest period
000230200910      **    2 - Based on the day in the observation period
000231200910     D  includeEndDat                 1a
000232200910      ** Include End Date in Compounding Flag (Y/N)
000233200910     D  provRateFlg                   1a
000234200910      ** Provisional Rate Flag (output)
000235200911     D  returnRate                   20p15
000236200910      ** Compounded/Average Rate (output)
000239200916      *
000262200905
000263200916      ** Prototype to call AOBANKR0
000281200911     D  getSDBANK      pr                  extpgm('AOBANKR0')
000282200911     D    pReturnCode                 7A
000283200911     D    pOption                     7A
000284200916     D    dsfdy                     200A
000285200916
000286200916      ** Prototype to call AOBSRTR0
000287200916     D  getSDBSRT      pr                  extpgm('AOBSRTR0')
000288200916     D    pReturnCode                 7A
000289200916     D    pOption                     7A
000290200916     D    pCurrency                   3a
000291200916     D    pBaseRate                   2a
000292200916     D    pDSFDY                    200A
000293200910
000294200916      ** Prototype to call getBaseRate function
000295200916     D  getBaseRate    pr            11P 7
000296200916     D    pCCY                        3a
000297200916     D    pBSR                        2a
000298200916     D    pHDT                        5  0
000299200916
000300200905      ** Prototype to call getHistRate function
000301200903     D  getHistRate    pr            11P 7
000302200903     D    pCurrency                   3a
000303200911     D    pBaseRate                   2a
000304200916     D    pHistDate                   5  0
000305200903
000306200903      ** +--------------------------------------+
000307200903      ** ¦ Manually included D-specs            ¦
000308200903      ** ¦ =========================            ¦
000309200903      ** +--------------------------------------+
000310200910
000311200915     D dssdy         e ds                  extname(DSSDY)
000312200916     D dsfdy         e ds                  extname(DSFDY)
000313200910     D sdbank        e ds                  extname(SDBANKPD)
000314200916     D sdbsrt        e ds                  extname(SDBSRTPD)
000315200910
000316200910     D bsrhDS          ds                  dim(1000) qualified
000317200911     D    historyDate                 5s 0
000318200911     D    SOFR_Rate                  11p 7
000319200911     D    appliedRate                11p 7
000320200910     D    provRateFlg                 1a
000321200907     D    daysApplied                 5s 0
000322200907     D    calendarDay                 5s 0
000323200911     D    effectiRate                 8f
000324200911     D    calculaRate                 8f
000325200911     D    cumulatRate                 8f
000326200911     D    compoundRat                 8f
000327200904
000328200903      ** +--------------------------------------+
000329200903      ** ¦ Constants declaration                ¦
000330200903      ** ¦ =====================                ¦
000331200903      ** +--------------------------------------+
000332200903
000333200903      ** +--------------------------------------+
000334200903      ** ¦ Variable declaration                 ¦
000335200903      ** ¦ ====================                 ¦
000336200903      ** +--------------------------------------+
000337200904
000338200911     D i               s              4s 0 inz(0)
000339200910     D ctr             s              4s 0 inz(0)
000340200904     D wNoDays         s              2s 0 inz(0)
000341200916     D wStartDate      s              5  0 inz(0)
000342200916     D wEndDate        s              5  0 inz(0)
000343200904     D wCalcBasis      s              3s 0 inz(0)
000344200907     D wProvRateFlg    s              1a   inz(*blanks)
000345200907     D wLockOutDate    s              5s 0 inz(0)
000346200916     D pReturnCode     s              7A   inz(*blanks)
000347200916     D pOption         s              7A   inz(*blanks)
000348200911     D wTotalDays      s              5s 0 inz(0)
000349200911     D wTotalRate      s              8f   inz(0)
000350200911     D wCalcuRate      s              8f   inz(0)
000351200916     D wLatestRat      s             11p 7 inz(0)
000352200916
000353200916      ** Parameter list for AOBSRTR0
000354200916     D PRtCd           S              7A
000355200916     D POptn           S              7A
000359200903
000360200903      ** +--------------------------------------+
000361200903      ** ¦ Array declaration                    ¦
000362200903      ** ¦ ==================                   ¦
000363200903      ** +--------------------------------------+
000364200903
000365200910      /free
000366200903
000367200903       // ** +--- Start of Main processing -----------------------------------+
000368200903       // ** ¦                                                                ¦
000369200903       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
000370200903       // ** ¦ executed at program activation.                                ¦
000371200903       // ** ¦                                                                ¦
000372200903       // ** +----------------------------------------------------------------+
000373200903
000374200903                   exsr calculateRates;
000397200903
000398200903                   *Inlr = *On;
000400200903                   return;
001622200903
001623200903       //*************************************************************
001624200903       /EJECT
001625200903       //*************************************************************
001626200903       //                                                            *
001627200904       // calculateRates - Build History Array from SDBSHSPD and     *
001628200904       // ==============   calculate rates                           *
001629200903       //                                                            *
001630200903       // Called by: Main Processing                                 *
001631200903       //                                                            *
001632200903       // Calls: None                                                *
001633200903       //                                                            *
001634200903       //*************************************************************
001635200903
001636200904       begsr calculateRates;
001637200910
001638200913
001639200913                    // Build the base rates history data structure initially retrieving the
001640200913                    // SOFR applicable rates
001641200913
001680200910                    ctr = 1;
001681200903
001682200910                    dow  wStartDate <= wEndDate;
001683200910
001684200911                         bsrhDS(ctr).historyDate = wStartDate;
001685200910                         bsrhDS(ctr).SOFR_Rate   =
001686200910                                      getHistRate(
001687200910                                                  transactCCY:
001688200910                                                  baseRateCode:
001689200910                                                  wStartDate
001690200910                                                  );
001691200911                         bsrhDS(ctr).provRateFlg = wProvRateFlg;
001693200913
001694200913                         // Use ZFWDT API to get the next working day
001695200913
001696200910                         wNoDays = 1;
001697200910                         zdayno = wStartDate;
001698200910                         zccy = transactCCY;
001699200910                         zloc = *blanks;
001700200910                         znrdys = wNoDays;
001701200910                         zdynbr = 0;
001702200910                         exsr zfwdt;
001703200910                         wStartDate = zdynbr;
001704200910
001705200910                         ctr = ctr + 1;
001706200910                    enddo;
001707200910
001708200913                    // read the base rates history file and calcuate necessary fields
001709200913
001710200910                    for i = 1 to ctr;
001711200913
001712200913                         // applied rates and other fields should be computed only for the
001713200913                         // inclusive interest period since bsrhDS contains date earlier
001714200913                         // than start date of the interest period when lookback days is
001715200913                         // specified
001716200913
001717200910                         if bsrhDS(i).historyDate >= startDate;
001718200910
001719200913                              // When include end date in compounding is set to yes, include
001720200913                              // the last day of the interest period in the computation otherwise
001721200913                              // only include last day - 1
001722200913
001723200912                              if  (bsrhDS(i).historyDate < wEndDate)
001724200912                                  or (bsrhDS(i).historyDate = EndDate
001725200912                                 and includeEndDat = 'Y');
001726200913
001727200911                                   //***** Get Rate (ri) *****//
001728200913                                   // If lock out days is specified, applied rate should be the same
001729200913                                   // as applied rate ofthe previous interest period when
001730200913                                   // lock out date has been reached. Otherwise get the applied
001731200913                                   // rate in the data structure less the lookback days
001733200913
001734200912                                   if wLockOutDate <> 0 and
001735200912                                      (wlockOutDate <= bsrhDS(i).historyDate);
001736200911                                        bsrhDS(i).appliedRate  = bsrhDS(i-1).
001737200911                                                  appliedRate;
001738200911                                   else;
001739200911                                        bsrhDS(i).appliedRate  =
001740200911                                        bsrhDS(i-lookBackDays).
001741200911                                        SOFR_Rate;
001742200911                                   endif;
001743200916                                   wLatestRat = bsrhDS(i).appliedRate;
001744200916                                   if bsrhDS(i).provRateFlg = 'Y';
001745200916                                        provRateFlg = bsrhDS(i).provRateFlg;
001746200916                                   endif;
001747200911                              else;
001748200911                                 iter;
001749200911                              endif;
001750200916
001751200916                              if averagingOpt = '3';
001752200916                                   iter;
001753200916                              endif;
001754200910
001755200910
001756200911                              //*** Get days applied (ni) and calendar days ***//
001757200910                              select;
001758200910
001759200910                                   when weightConv = '1';
001760200910                                            bsrhDS(i).daysApplied =
001761200910                                            bsrhDS(i + 1).Historydate -
001762200910                                            bsrhDS(i).HistoryDate;
001763200910                                    when weightConv = '2';
001764200910                                            bsrhDS(i).daysApplied =
001765200910                                            bsrhDS(i -
001766200911                                            lookBackDays+1).historydate -
001767200910                                            bsrhDS(i -
001768200910                                            lookBackDays).
001769200910                                            historydate;
001770200910                              endsl;
001771200911
001772200911                              // *** Calculate sum of days applied ***//
001773200911                              if  startDate = bsrhDS(i).historyDate;
001774200911                                   wTotalDays = bsrhDS(i).daysApplied;
001775200911                              else;
001776200911                                   wTotalDays = wTotalDays +
001777200911                                      bsrhDS(i).daysApplied;
001778200911                              endif;
001779200911
001780200911                              //*** calendar days ***//
001781200910                              if startDate = bsrhDS(i).
001782200910                                   historyDate;
001783200910                                   bsrhDS(i).calendarDay =
001784200910                                   bsrhDS(i).daysApplied;
001785200910                               else;
001786200910                                   bsrhDS(i).calendarDay =
001787200910                                   bsrhDS(i).daysApplied +
001788200910                                   bsrhDS(i-1).CalendarDay;
001789200910                               endif;
001790200910
001791200910
001792200911                               //*** Get Effective Rate (ri x ni /N) ***//
001793200910                               bsrhDS(i).effectiRate =
001794200910                               bsrhDS(i).appliedRate *
001795200910                               bsrhDS(i).daysApplied/wCalcBasis;
001796200910                               select;
001797200911                                   when averagingOpt = '1';
001798200910
001799200911                                        //*** Get Calculated Rate ***//
001800200910                                        bsrhDS(i).calculaRate = 1  +
001801200911                                        (bsrhDS(i).effectiRate/100);
001802200911
001803200911                                        if  startDate =
001804200911                                             bsrhDS(i).historyDate;
001805200911                                             wTotalRate = bsrhDS(i).
001806200911                                                          calculaRate;
001807200911                                        else;
001808200911                                             wTotalRate = wTotalRate *
001809200911                                             bsrhDS(i).calculaRate;
001810200911                                        endif;
001817200910
001818200911                                        //*** Get cumulative rate ***//
001819200910                                       if startDate = bsrhDS(i).historyDate;
001820200910                                           bsrhDS(i).cumulatRate =
001821200910                                           bsrhDS(i).calculaRate;
001822200910                                       else;
001823200910                                          bsrhDS(i).cumulatRate =
001824200910                                          bsrhDS(i - 1).cumulatRate
001825200910                                          * bsrhDS(i).calculaRate;
001826200910                                       endif;
001829200910
001830200911                                       //*** Get Compounded Rate ***//
001831200910                                       bsrhDS(i).compoundRat =
001832200911                                       ((bsrhDS(i).cumulatRate - 1)*
001833200911                                       wCalcBasis)/bsrhDS(i).calendarDay * 100;
001834200910
001835200911                                   when averagingOpt = '2';
001836200911
001837200911                                        if  startDate =
001838200911                                             bsrhDS(i).historyDate;
001839200911                                             wTotalRate = bsrhDS(i).
001840200911                                                    effectiRate;
001841200911                                        else;
001842200911                                             wTotalRate = wTotalRate +
001843200911                                                    bsrhDS(i).effectiRate;
001844200911                                        endif;
001845200910
001846200911                                        //*** Get Calculated Rate ***//
001847200910                                        bsrhDS(i).calculaRate = 0;
001848200910
001849200911                                        //*** Get cumulative rate ***//
001850200910                                        bsrhDS(i).cumulatRate = 0;
001851200910
001852200911                                        //*** Get Compounded Rate ***//
001853200910                                        bsrhDS(i).compoundRat = 0;
001854200910
001855200910                               endsl;
001856200910                         endif;
001857200910
001858200910                    endfor;
001859200911
001860200911                    // Compute for the compounded/average rate based on averaging option parameter
001861200911
001862200911                   select;
001863200911                        when averagingOpt = '1';
001864200911                             // Calculation Basis/ Sum of Total Days Applied *
001865200911                             // Product of Total Calculated rates - 1 * 100
001866200911                             wCalcuRate  = (wCalcBasis / wTotalDays *
001867200911                                           (wTotalRate  - 1) * 100);
001868200916                             returnRate = wCalcuRate;
001869200911
001870200911                        when averagingOpt = '2';
001871200911                             // Calculation Basis/ Sum of Total Days Applied *
001872200911                             // Sum of Effective Rates
001873200911                             wCalcuRate  = wCalcBasis / wTotalDays *
001874200911                                           wTotalRate;
001875200916                             returnRate = wCalcuRate;
001876200916
001877200916                        when averagingOpt = '3';
001879200916                             returnRate = wLatestRat;
001880200911                   endsl;
001881200916
001882200910
001883200903       endsr;
001884200903
001885200903       //*************************************************************
001886200903       /EJECT
001887200903       //*************************************************************
001888200903       //                                                            *
001889200903       // inzsr - Program Initialisation routine                     *
001890200903       //                                                            *
001891200903       // Called by: Main processing                                 *
001892200903       //                                                            *
001893200903       //  Calls: None                                               *
001894200903       //                                                            *
001895200903       //*************************************************************
001896200903
001897200903       begsr *inzsr;
001898200905
001899200909                   clear bsrhDS;
001900200907                   clear wLockOutDate;
001901200913
001902200907                   provRateFlg = 'N';
001903200916
001904200916                   if AveragingOpt = '3';
001905200916                        includeEndDat = 'Y';
001906200916                   endif;
001907200910
001908200910                   pOption = '*FIRST';
001909200910                   pReturnCode = *blanks;
001910200910                   callp getSDBANK(
001911200910                                  pReturnCode
001912200910                                : pOption
001913200916                                : dsfdy
001914200910                               );
001915200916                   sdbank= dsfdy;
001916200910
001917200910                   // If lock out days parameter is passed, determine the first day of lockout
001918200910
001919200910                   if lockOutDays <> 0;
001920200910                         zdayno = endDate;
001921200910                         zccy = transactCCY;
001922200910                         zloc = *blanks;
001923200910                         znrdys = lockOutDays;
001924200910                         zdynbr = 0;
001925200910                         exsr zbkdt;
001926200910                         wLockOutDate = zdynbr;
001927200910                   endif;
001928200910
001929200910                   if includeEndDat = 'Y';
001930200910                         wNoDays = 1;
001931200910                         zdayno = endDate;
001932200910                         zccy = transactCCY;
001933200910                         zloc = *blanks;
001934200910                         znrdys = wNoDays;
001935200910                         zdynbr = 0;
001936200910                         exsr zfwdt;
001937200910                         wEndDate = zdynbr;
001938200910                   else;
001939200910                        wEndDate = EndDate;
001940200910                   endif;
001941200910
001942200910                    //Go backwards depending on the lookBackDays
001943200910                    if lookBackDays <> 0;
001944200910                         zdayno = startDate;
001945200910                         zccy = transactCCY;
001946200910                         zloc = *blanks;
001947200910                         znrdys = lookBackDays;
001948200910                         zdynbr = 0;
001949200910                         exsr zbkdt;
001950200910                         wStartDate = zdynbr;
001951200910                    else;
001952200910                        wStartDate = startDate;
001953200910                    endif;
001954200910
001955200907
001956200907                   //Determine divisor based on calculation basis passed to this program
001957200907
001958200905                   select;
001959200905
001960200911                     when calcBasis = '1'
001961200911                             or calcBasis = '4';
001962200905
001963200905                          wCalcBasis = 365;
001964200905
001965200911                     when calcBasis = '2'
001966200911                             or calcBasis = '3'
001967200911                             or calcBasis = '5';
001968200905
001969200905                          wCalcBasis = 360;
001970200905
001971200911                     when calcBasis = '6';
001972200905
001973200905                          wCalcBasis = 366;
001974200905
001975200905                   endsl;
001976200907
001977200907
001978200903       endsr;
001979200903
001980200903       //*************************************************************
001981200903       /EJECT
001982200903       //*************************************************************
001983200903       //                                                            *
001984200903       //   *pssr  - Program Error Processing Subroutine.            *
001985200903       //                                                            *
001986200903       //   Called By: Main Processing                               *
001987200903       //                                                            *
001988200903       //*************************************************************
001989200903
001990200903       begsr *pssr;
001991200903                   *inu7 = *on;
001992200903                   *inu8 = *on;
001993200903                   *Inlr = *on;
001994200903                   dump;
001995200903                   return;
001996200903       endsr;
001997200903
001998200903      /end-free
001999200910
002000200913     C/COPY ZSRSRC,ZACCHLE
002001200913     C/COPY ZSRSRC,ZBKDT_ILE
002002200910     C/COPY ZSRSRC,ZFWDT_ILE
002003200910
002004200916      *****************************************************************
002005200916      /EJECT
002006200916      *****************************************************************
002007200916      *                                                               *
002008200916      *  getHistRate - Get rates from history file                    *
002009200916      *  ===========                                                  *
002010200916      *  Called By: Main Processing                                   *
002011200916      *                                                               *
002012200916      *****************************************************************
002013200916
002014200916     P getHistRate     B
002015200916     D getHistRate     PI            11P 7
002016200916     D    pCCY                        3a
002017200916     D    pBRC                        2a
002018200916     D    pHDT                        5  0
002019200916     D   retVal        S             11P 7
002020200916     D   ProvFlag      S               n
002021200916
002022200916      /free
002023200916
002024200916                    ProvFlag = False;
002025200916
002026200916                    chain (pCCY:pBRC:pHDT) SDBSHSL1;
002027200916
002028200916                    if %found(SDBSHSL1);
002029200916
002030200916                         retVal = G0CBSR;
002031200916
002032200916                    else;
002033200916
002034200916                         setll (pCCY:pBRC:pHDT) SDBSHSL1;
002035200916
002036200916                         if %equal(SDBSHSL1);
002037200916
002038200916                              retVal = G0CBSR;
002039200916
002040200916                         elseif %found(SDBSHSL1);
002041200916
002042200916                              readp SDBSHSL1;
002043200916
002044200916                              if %eof(SDBSHSL1);
002045200916
002046200916                                   read SDBSHSL1;
002047200916
002048200916                                   if %found(SDBSHSL1);
002049200916
002050200916                                        ProvFlag = True;
002051200916                                        retVal = G0CBSR;
002052200916
002053200916                                   endif;
002054200916
002055200916                              else;
002056200916
002057200916                                   if (pCCY = G0CYCD) and (pBRC = G0BSRC);
002058200916
002059200916                                        ProvFlag = True;
002060200916                                        retVal = G0CBSR;
002061200916
002062200916                                   endif;
002063200916
002064200916                              endif;
002065200916
002066200916                         else;
002067200916
002068200916                              readp SDBSHSL1;
002069200916
002070200916                              if (pCCY = G0CYCD) and (pBRC = G0BSRC);
002071200916
002073200916                                    ProvFlag = True;
002074200916                                   retVal = G0CBSR;
002075200916
002076200916                              else;
002077200916
002078200916                                  retVal = GetBaseRate( pCCY
002079200916                                                       :pBRC
002080200916                                                       :pHDT );
002081200916                                  ProvFlag = True;
002082200916
002083200916                              endif;
002084200916
002085200916                         endif;
002086200916
002087200916                    endif;
002088200916
002089200916                    if  (BJRDNB < pHDT) and ProvFlag;
002090200916
002091200916                         wProvRateFlg = 'Y';
002092200916
002093200916                    endif;
002094200916
002095200916                    return retVal;
002096200916
002097200916      /end-free
002098200916     P   getHistRate   E
002099200916
002100200916      *****************************************************************
002101200916      /EJECT
002102200916      *****************************************************************
002103200916      *                                                               *
002104200916      *  getBaseRate - Get base rates from file SDBSRTPD              *
002105200916      *  ===========   This subroutine will be called when there are  *
002106200916      *                no records defined in SDBSHSPD                 *
002107200916      *                                                               *
002108200916      *  Called By: getHistRate                                       *
002109200916      *                                                               *
002110200916      *  Calls: getSDBSRT                                             *
002111200916      *                                                               *
002112200916      *****************************************************************
002113200916
002114200916     P getBaseRate     B
002115200916     D getBaseRate     PI            11P 7
002116200916     D    pCCY                        3a
002117200916     D    pBRC                        2a
002118200916     D    pHDT                        5  0
002119200916     D   retVal        S             11P 7
002120200916
002121200916      /free
002122200916                    pRtCd = *blanks;
002123200916                    pOptn = '*KEY';
002124200916                    retVal = 0;
002125200916                    callp getSDBSRT(pRtCd:
002126200916                                    pOptn:
002127200916                                    pCCY:
002128200916                                    pBRC:
002129200916                                    dssdy);
002130200916                    if pRtCd = *blanks;
002131200916                        sdbsrt = dssdy;
002132200916                        retVal = BANBRT;
002133200916                    endif;
002134200916                    return retVal;
002135200916      /end-free
002136200916
002137200916     P   getBaseRate   E
002138200910
002139200903
