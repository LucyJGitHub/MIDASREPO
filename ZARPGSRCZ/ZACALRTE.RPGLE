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
000143200903      **---------------------------------------------------------------
000144200903      ** The following /COPY line includes all the defined fields in
000145200903      ** the Program Status Data Structures.  They have meaningful
000146200903      ** names, prefixed by 'PS'.
000147200904
000148200923     D/COPY ZACPYSRC,PSDS
000149200923     D/COPY ZACPYSRC,STD_D_SPEC
000150200923     D/COPY ZSRSRC,ZINTDYZ1LE
000151200923     D/COPY ZSRSRC,ZHOLILE
000152200923     D/COPY ZSRSRC,ZHOLELE
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
000294200923      ** Prototype to call ZAGETRTE
000295200923     D  getBaseRate    pr                  extpgm('ZAGETRTE')
000297200923     D  transactCCY                   3a
000299200923     D  baseRateCode                  2a
000301200923     D  histDate                      5  0
000303200923     D  returnRate                   11p 7
000305200923     D  provFlag                      1a
000308200910
000320200903
000321200903      ** +--------------------------------------+
000322200903      ** ¦ Manually included D-specs            ¦
000323200903      ** ¦ =========================            ¦
000324200903      ** +--------------------------------------+
000325200910
000326200923     D dssdy         e ds                  extname(DSSDY)
000328200916     D dsfdy         e ds                  extname(DSFDY)
000330200910
000331200910     D bsrhDS          ds                  dim(1000) qualified
000332200911     D    historyDate                 5s 0
000333200911     D    SOFR_Rate                  11p 7
000334200911     D    appliedRate                11p 7
000335200910     D    provRateFlg                 1a
000336200907     D    daysApplied                 5s 0
000337200907     D    calendarDay                 5s 0
000338200911     D    effectiRate                 8f
000339200911     D    calculaRate                 8f
000340200911     D    cumulatRate                 8f
000341200911     D    compoundRat                 8f
000342200904
000343200903      ** +--------------------------------------+
000344200903      ** ¦ Constants declaration                ¦
000345200903      ** ¦ =====================                ¦
000346200903      ** +--------------------------------------+
000347200903
000348200903      ** +--------------------------------------+
000349200903      ** ¦ Variable declaration                 ¦
000350200903      ** ¦ ====================                 ¦
000351200903      ** +--------------------------------------+
000352200904
000353200911     D i               s              4s 0 inz(0)
000354200910     D ctr             s              4s 0 inz(0)
000355200904     D wNoDays         s              2s 0 inz(0)
000356200916     D wStartDate      s              5  0 inz(0)
000357200916     D wEndDate        s              5  0 inz(0)
000358200904     D wCalcBasis      s              3s 0 inz(0)
000360200907     D wLockOutDate    s              5s 0 inz(0)
000363200911     D wTotalDays      s              5s 0 inz(0)
000364200911     D wTotalRate      s              8f   inz(0)
000365200911     D wCalcuRate      s              8f   inz(0)
000366200916     D wLatestRat      s             11p 7 inz(0)
000367200923     D wLockOutRate    s             11p 7 inz(0)
000368200923     D wLockOutFlag    s               n
000369200916
000371200903
000372200903      ** +--------------------------------------+
000373200903      ** ¦ Array declaration                    ¦
000374200903      ** ¦ ==================                   ¦
000375200903      ** +--------------------------------------+
000376200903
000377200910      /free
000378200903
000379200903       // ** +--- Start of Main processing -----------------------------------+
000380200903       // ** ¦                                                                ¦
000381200903       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
000382200903       // ** ¦ executed at program activation.                                ¦
000383200903       // ** ¦                                                                ¦
000384200903       // ** +----------------------------------------------------------------+
000385200903
000386200903                   exsr calculateRates;
000397200903
000398200903                   *Inlr = *On;
000400200903                   return;
001622200903
001625200903       //*************************************************************
001626200903       /EJECT
001627200903       //*************************************************************
001628200903       //                                                            *
001629200904       // calculateRates - Build History Array from SDBSHSPD and     *
001630200904       // ==============   calculate rates                           *
001631200903       //                                                            *
001632200903       // Called by: Main Processing                                 *
001633200903       //                                                            *
001634200903       // Calls: None                                                *
001635200903       //                                                            *
001636200903       //*************************************************************
001637200903
001638200904       begsr calculateRates;
001639200910
001640200913
001641200913                    // Build the base rates history data structure initially retrieving the
001642200913                    // SOFR applicable rates
001643200913
001680200910                    ctr = 1;
001681200903
001682200910                    dow  wStartDate <= wEndDate;
001683200910
001684200911                         bsrhDS(ctr).historyDate = wStartDate;
001685200923
001691200923                         Callp getBaseRate(
001692200923                                          transactCCY
001693200923                                          :baseRateCode
001694200923                                          :wstartDate
001695200923                                          :bsrhDS(ctr).SOFR_Rate
001696200923                                          :bsrhDS(ctr).provRateFlg
001697200923                                          );
001698200923
001699200923                         if (wLockOutDate = wStartDate) and wLockOutFlag;
001700200923                            wLockOutRate = bsrhDS(ctr).SOFR_Rate;
001703200923                         endif;
001704200923
001705200913                         // Use ZFWDT API to get the next working day
001706200913
001707200910                         wNoDays = 1;
001708200910                         zdayno = wStartDate;
001709200910                         zccy = transactCCY;
001710200910                         zloc = *blanks;
001711200910                         znrdys = wNoDays;
001712200910                         zdynbr = 0;
001713200910                         exsr zfwdt;
001714200910                         wStartDate = zdynbr;
001715200910
001716200910                         ctr = ctr + 1;
001717200910                    enddo;
001718200910
001719200913                    // read the base rates history file and calcuate necessary fields
001720200913
001721200910                    for i = 1 to ctr;
001722200913
001723200913                         // applied rates and other fields should be computed only for the
001724200913                         // inclusive interest period since bsrhDS contains date earlier
001725200913                         // than start date of the interest period when lookback days is
001726200913                         // specified
001727200913
001728200910                         if bsrhDS(i).historyDate >= startDate;
001729200910
001730200913                              // When include end date in compounding is set to yes, include
001731200913                              // the last day of the interest period in the computation otherwise
001732200913                              // only include last day - 1
001733200913
001734200912                              if  (bsrhDS(i).historyDate < wEndDate)
001735200912                                  or (bsrhDS(i).historyDate = EndDate
001736200912                                 and includeEndDat = 'Y');
001737200913
001738200911                                   //***** Get Rate (ri) *****//
001739200913                                   // If lock out days is specified, applied rate should be the same
001740200913                                   // as applied rate ofthe previous interest period when
001741200913                                   // lock out date has been reached. Otherwise get the applied
001742200913                                   // rate in the data structure less the lookback days
001743200913
001744200923                                   if wLockOutRate <> 0;
001745200923                                        bsrhDS(i).appliedRate  = wLockOutRate;
001747200923                                   else;
001748200923                                        if wLockOutDate <> 0 and
001749200923                                           (wlockOutDate <
001750200923                                             bsrhDS(i).historyDate);
001751200923                                             bsrhDS(i).appliedRate  =
001752200923                                                bsrhDS(i-1).appliedRate;
001754200923                                        else;
001755200923                                             bsrhDS(i).appliedRate  =
001756200923                                             bsrhDS(i-lookBackDays).
001757200923                                             SOFR_Rate;
001758200923                                        endif;
001759200923                                   endif;
001760200923                                   wLatestRat = bsrhDS(i).appliedRate;
001761200916                                   if bsrhDS(i).provRateFlg = 'Y';
001762200916                                        provRateFlg = bsrhDS(i).provRateFlg;
001763200916                                   endif;
001764200911                              else;
001765200911                                 iter;
001766200911                              endif;
001767200916
001768200916                              if averagingOpt = '3';
001769200916                                   iter;
001770200916                              endif;
001771200910
001772200910
001773200911                              //*** Get days applied (ni) and calendar days ***//
001774200910                              select;
001775200910
001776200910                                   when weightConv = '1';
001777200910                                            bsrhDS(i).daysApplied =
001778200910                                            bsrhDS(i + 1).Historydate -
001779200910                                            bsrhDS(i).HistoryDate;
001780200910                                    when weightConv = '2';
001781200910                                            bsrhDS(i).daysApplied =
001782200910                                            bsrhDS(i -
001783200911                                            lookBackDays+1).historydate -
001784200910                                            bsrhDS(i -
001785200910                                            lookBackDays).
001786200910                                            historydate;
001787200910                              endsl;
001788200911
001789200911                              // *** Calculate sum of days applied ***//
001790200911                              if  startDate = bsrhDS(i).historyDate;
001791200911                                   wTotalDays = bsrhDS(i).daysApplied;
001792200911                              else;
001793200911                                   wTotalDays = wTotalDays +
001794200911                                      bsrhDS(i).daysApplied;
001795200911                              endif;
001796200911
001797200911                              //*** calendar days ***//
001798200910                              if startDate = bsrhDS(i).
001799200910                                   historyDate;
001800200910                                   bsrhDS(i).calendarDay =
001801200910                                   bsrhDS(i).daysApplied;
001802200910                               else;
001803200910                                   bsrhDS(i).calendarDay =
001804200910                                   bsrhDS(i).daysApplied +
001805200910                                   bsrhDS(i-1).CalendarDay;
001806200910                               endif;
001807200910
001808200910
001809200911                               //*** Get Effective Rate (ri x ni /N) ***//
001810200910                               bsrhDS(i).effectiRate =
001811200910                               bsrhDS(i).appliedRate *
001812200910                               bsrhDS(i).daysApplied/wCalcBasis;
001813200910                               select;
001814200911                                   when averagingOpt = '1';
001815200910
001816200911                                        //*** Get Calculated Rate ***//
001817200910                                        bsrhDS(i).calculaRate = 1  +
001818200911                                        (bsrhDS(i).effectiRate/100);
001819200911
001820200911                                        if  startDate =
001821200911                                             bsrhDS(i).historyDate;
001822200911                                             wTotalRate = bsrhDS(i).
001823200911                                                          calculaRate;
001824200911                                        else;
001825200911                                             wTotalRate = wTotalRate *
001826200911                                             bsrhDS(i).calculaRate;
001827200911                                        endif;
001828200910
001829200911                                        //*** Get cumulative rate ***//
001830200910                                       if startDate = bsrhDS(i).historyDate;
001831200910                                           bsrhDS(i).cumulatRate =
001832200910                                           bsrhDS(i).calculaRate;
001833200910                                       else;
001834200910                                          bsrhDS(i).cumulatRate =
001835200910                                          bsrhDS(i - 1).cumulatRate
001836200910                                          * bsrhDS(i).calculaRate;
001837200910                                       endif;
001838200910
001839200911                                       //*** Get Compounded Rate ***//
001840200910                                       bsrhDS(i).compoundRat =
001841200911                                       ((bsrhDS(i).cumulatRate - 1)*
001842200911                                       wCalcBasis)/bsrhDS(i).calendarDay * 100;
001843200910
001844200911                                   when averagingOpt = '2';
001845200911
001846200911                                        if  startDate =
001847200911                                             bsrhDS(i).historyDate;
001848200911                                             wTotalRate = bsrhDS(i).
001849200911                                                    effectiRate;
001850200911                                        else;
001851200911                                             wTotalRate = wTotalRate +
001852200911                                                    bsrhDS(i).effectiRate;
001853200911                                        endif;
001854200910
001855200911                                        //*** Get Calculated Rate ***//
001856200910                                        bsrhDS(i).calculaRate = 0;
001857200910
001858200911                                        //*** Get cumulative rate ***//
001859200910                                        bsrhDS(i).cumulatRate = 0;
001860200910
001861200911                                        //*** Get Compounded Rate ***//
001862200910                                        bsrhDS(i).compoundRat = 0;
001863200910
001864200910                               endsl;
001865200910                         endif;
001866200910
001867200910                    endfor;
001868200911
001869200911                    // Compute for the compounded/average rate based on averaging option parameter
001870200911
001871200911                   select;
001872200911                        when averagingOpt = '1';
001873200911                             // Calculation Basis/ Sum of Total Days Applied *
001874200911                             // Product of Total Calculated rates - 1 * 100
001875200911                             wCalcuRate  = (wCalcBasis / wTotalDays *
001876200911                                           (wTotalRate  - 1) * 100);
001877200916                             returnRate = wCalcuRate;
001878200911
001879200911                        when averagingOpt = '2';
001880200911                             // Calculation Basis/ Sum of Total Days Applied *
001881200911                             // Sum of Effective Rates
001882200911                             wCalcuRate  = wCalcBasis / wTotalDays *
001883200911                                           wTotalRate;
001884200916                             returnRate = wCalcuRate;
001885200916
001886200916                        when averagingOpt = '3';
001887200916                             returnRate = wLatestRat;
001888200911                   endsl;
001889200916
001890200910
001891200903       endsr;
001892200903
001893200903       //*************************************************************
001894200903       /EJECT
001895200903       //*************************************************************
001896200903       //                                                            *
001897200903       // inzsr - Program Initialisation routine                     *
001898200903       //                                                            *
001899200903       // Called by: Main processing                                 *
001900200903       //                                                            *
001901200903       //  Calls: None                                               *
001902200903       //                                                            *
001903200903       //*************************************************************
001904200903
001905200903       begsr *inzsr;
001906200905
001907200909                   clear bsrhDS;
001908200907                   clear wLockOutDate;
001909200923                   clear wLockOutRate;
001910200923                   clear wLockOutFlag;
001911200913
001912200907                   provRateFlg = 'N';
001913200923                   wStartDate = startDate;
001914200916
001915200916                   if AveragingOpt = '3';
001916200916                        includeEndDat = 'Y';
001917200916                   endif;
001918200910
001919200910
001920200910                   // If lock out days parameter is passed, determine the first day of lockout
001921200910
001922200910                   if lockOutDays <> 0;
001923200910                         zdayno = endDate;
001924200910                         zccy = transactCCY;
001925200910                         zloc = *blanks;
001926200910                         znrdys = lockOutDays;
001927200910                         zdynbr = 0;
001928200910                         exsr zbkdt;
001929200910                         wLockOutDate = zdynbr;
001930200910                   endif;
001931200910
001932200910                   if includeEndDat = 'Y';
001933200910                         wNoDays = 1;
001934200910                         zdayno = endDate;
001935200910                         zccy = transactCCY;
001936200910                         zloc = *blanks;
001937200910                         znrdys = wNoDays;
001938200910                         zdynbr = 0;
001939200910                         exsr zfwdt;
001940200910                         wEndDate = zdynbr;
001941200910                   else;
001942200910                        wEndDate = EndDate;
001943200910                   endif;
001944200923
001945200923                    if (wLockOutDate <= wStartDate) and wLockOutDate <> 0;
001946200923                         wStartDate = wLockOutDate;
001947200923                         wLockOutFlag = True;
001948200923                         lookBackDays = 0;
001949200923                    endif;
001950200910
001951200910                    //Go backwards depending on the lookBackDays
001952200910                    if lookBackDays <> 0;
001953200910                         zdayno = startDate;
001954200910                         zccy = transactCCY;
001955200910                         zloc = *blanks;
001956200910                         znrdys = lookBackDays;
001957200910                         zdynbr = 0;
001958200910                         exsr zbkdt;
001959200910                         wStartDate = zdynbr;
001962200910                    endif;
001963200923
001964200910
001965200907
001966200907                   //Determine divisor based on calculation basis passed to this program
001967200907
001968200905                   select;
001969200905
001970200911                     when calcBasis = '1'
001971200918                             or calcBasis = '4'
001972200918                             or calcBasis = '6'
001973200918                             or calcBasis = '9';
001974200905
001975200905                          wCalcBasis = 365;
001976200905
001977200911                     when calcBasis = '2'
001978200911                             or calcBasis = '3'
001979200918                             or calcBasis = '5'
001980200918                              or calcBasis = '7';
001981200905
001982200905                          wCalcBasis = 360;
001983200905
001984200918
001985200905                   endsl;
001986200907
001987200907
001988200903       endsr;
001989200903
001990200903       //*************************************************************
001991200903       /EJECT
001992200903       //*************************************************************
001993200903       //                                                            *
001994200903       //   *pssr  - Program Error Processing Subroutine.            *
001995200903       //                                                            *
001996200903       //   Called By: Main Processing                               *
001997200903       //                                                            *
001998200903       //*************************************************************
001999200903
002000200903       begsr *pssr;
002001200903                   *inu7 = *on;
002002200903                   *inu8 = *on;
002003200903                   *Inlr = *on;
002004200903                   dump;
002005200903                   return;
002006200903       endsr;
002007200903
002008200903      /end-free
002009200924
002010200923     C/COPY ZSRSRC,ZACCHLE
002011200923     C/COPY ZSRSRC,ZBKDT_ILE
002012200923     C/COPY ZSRSRC,ZFWDT_ILE
