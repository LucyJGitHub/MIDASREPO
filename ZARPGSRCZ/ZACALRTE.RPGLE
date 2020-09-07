000100200903     H DEBUG
000101200903     H DFTACTGRP(*NO)
000102200903     H COPYRIGHT('(c) Finastra International Limited 2020')
000104200903      *****************************************************************
000105200904/*STD *  RPGBASEBND                                                   *
000106200905/*EXI *  TEXT('Midas SD API - Calculate Term Rate')                   *
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
000150200903
000151200903      ** +--------------------------------------+
000152200903      ** ¦ Program Prototypes                   ¦
000153200903      ** ¦ ==================                   ¦
000154200903      ** +--------------------------------------+
000155200904
000156200903     D Main            pr                  extpgm('SDCALRTE')
000157200905
000158200903     D  transactCCY                   3a
000159200905      ** Transaction Currency (input)
000160200904     D  baseRateCode                  2s 0
000161200905      ** Base Rate Code (input)
000162200904     D  calcBasis                     1s 0
000163200905      ** Calculation Basis (input)
000164200903     D  startDate                     5s 0
000165200905      ** Start Date of Compounding (input)
000166200903     D  endDate                       5s 0
000167200905      ** End Date of Compounding (input)
000168200903     D  lookBackDays                  2s 0
000169200905      ** Number of Days Lookback (input)
000170200903     D  lockOutDays                   2s 0
000171200905      ** Number of Days Lockout (input)
000172200903     D  averagingOpt                  1s 0
000173200905      ** Averaging Option (input)
000174200905      **    1 - Compund Average
000175200905      **    2 - Simple Average in Arrears
000176200905      **    3 - No Averaging (Base Rates File)
000177200905      **    4 - No Averaging (User Input)
000178200907     D  weightConv                    1a
000179200905      ** Weight Convention (input)
000180200907      **    1 - Based on the day in the interest period
000181200907      **    2 - Based on the day in the observation period
000182200903     D  includeEndDat                 1a
000183200905      ** Include End Date in Compounding Flag (Y/N)
000184200905     D  provRateFlg                   1a
000185200905      ** Provisional Rate Flag (output)
000186200905     D  calculatedRat                11p 7
000187200905      ** Compounded/Average Rate (output)
000188200907     D  errorCode                     3a
000189200907      ** Error Code (output)
000190200905
000191200903     D Main            pi
000192200905
000193200905     D  transactCCY                   3a
000194200905      ** Transaction Currency (input)
000195200905     D  baseRateCode                  2s 0
000196200905      ** Base Rate Code (input)
000197200905     D  calcBasis                     1s 0
000198200905      ** Calculation Basis (input)
000199200905     D  startDate                     5s 0
000200200905      ** Start Date of Compounding (input)
000201200905     D  endDate                       5s 0
000202200905      ** End Date of Compounding (input)
000203200905     D  lookBackDays                  2s 0
000204200905      ** Number of Days Lookback (input)
000205200905     D  lockOutDays                   2s 0
000206200905      ** Number of Days Lockout (input)
000207200905     D  averagingOpt                  1s 0
000208200905      ** Averaging Option (input)
000209200905      **    1 - Compund Average
000210200905      **    2 - Simple Average in Arrears
000211200905      **    3 - No Averaging (Base Rates File)
000212200905      **    4 - No Averaging (User Input)
000213200907     D  weightConv                    1a
000214200905      ** Weight Convention (input)
000215200907      **    1 - Based on the day in the interest period
000216200907      **    2 - Based on the day in the observation period
000217200905     D  includeEndDat                 1a
000218200905      ** Include End Date in Compounding Flag (Y/N)
000219200905     D  provRateFlg                   1a
000220200905      ** Provisional Rate Flag (output)
000221200905     D  calculatedRat                11p 7
000222200905      ** Compounded/Average Rate (output)
000223200907     D  errorCode                     3a
000224200907      ** Error Code (output)
000225200905
000226200905      ** Prototype to call ZBKDT module
000227200903     D  backwardDays   pr                  extpgm('ZBKDT')
000228200903     D    pDayno                      5s 0
000229200903     D    pCurrency                   3a
000230200903     D    pLocation                   3a
000231200903     D    pNoDays                     2s 0
000232200903     D    pRetDay                     5s 0
000233200903
000234200905      ** Prototype to call ZFWDT module
000235200903     D  forwardDays    pr                  extpgm('ZFWDT')
000236200903     D    pDayno                      5s 0
000237200903     D    pNoDays                     2s 0
000238200903     D    pRetDay                     5s 0
000239200903     D    pCurrency                   3a
000240200903     D    pLocation                   3a
000241200903
000242200905      ** Prototype to call getHistRate function
000243200903     D  getHistRate    pr            11P 7
000244200903     D    pCurrency                   3a
000245200904     D    pBaseRate                   2s 0
000246200903     D    pHistDate                   5s 0
000247200903
000248200903      ** +--------------------------------------+
000249200903      ** ¦ Manually included D-specs            ¦
000250200903      ** ¦ =========================            ¦
000251200903      ** +--------------------------------------+
000252200904
000253200904     D calcRateDS      ds                  dim(1000) qualified
000254200907     D    runDate                     5s 0
000255200907     D    appliedRate                11p 7
000256200907     D    daysApplied                 5s 0
000257200907     D    calendarDay                 5s 0
000258200907     D    effectiRate                11p 7
000259200907     D    calculaRate                11p 7
000260200907     D    cumulatRate                11p 7
000261200907     D    compoundRat                11p 7
000262200903
000263200904     D baseRateHistDS  ds                  dim(1000) qualified
000264200907     D    historyDate                 5s 0
000265200907     D    appliedRate                11p 7
000266200907     D    provRateFlg                 1a
000267200904
000268200903      ** +--------------------------------------+
000269200903      ** ¦ Constants declaration                ¦
000270200903      ** ¦ =====================                ¦
000271200903      ** +--------------------------------------+
000272200903
000273200903      ** +--------------------------------------+
000274200903      ** ¦ Variable declaration                 ¦
000275200903      ** ¦ ====================                 ¦
000276200903      ** +--------------------------------------+
000277200904
000311200903     D histCtr         s              4s 0 inz(0)
000312200903     D calcCtr         s              4s 0 inz(0)
000314200905     D wLocation       s              3a   inz(*blanks)
000315200904     D wNoDays         s              2s 0 inz(0)
000316200905     D wRetDay         s              5s 0 inz(0)
000317200905     D wStartDate      s              5s 0 inz(0)
000318200904     D wCalcBasis      s              3s 0 inz(0)
000319200907     D wProvRateFlg    s              1a   inz(*blanks)
000320200907     D wLockOutDate    s              5s 0 inz(0)
000321200907     D wLockOutRate    s             11p 7 inz(0)
000322200903
000323200903      ** +--------------------------------------+
000324200903      ** ¦ Array declaration                    ¦
000325200903      ** ¦ ==================                   ¦
000326200903      ** +--------------------------------------+
000327200903
000328200903      /free
000329200903
000330200903       // ** +--- Start of Main processing -----------------------------------+
000331200903       // ** ¦                                                                ¦
000332200903       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
000333200903       // ** ¦ executed at program activation.                                ¦
000334200903       // ** ¦                                                                ¦
000335200903       // ** +----------------------------------------------------------------+
000336200903
000343200903                   exsr calculateRates;
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
001637200903
001638200904                    //Go backwards depending on the lookBackDays
001640200904                    if lookBackDays > 0;
001644200905                         callp backwardDays ( startDate
001645200905                                             :transactCCY
001646200905                                             :wLocation
001647200905                                             :lookBackDays
001648200905                                             :wRetDay
001649200905                                            );
001650200905                        wStartDate = wRetDay;
001651200903                    else;
001653200905                        wStartDate = startDate;
001654200903                    endif;
001655200903
001656200903                    histCtr = 1;
001657200903                    calcCtr = 1;
001658200903
001659200905                    dow  wStartDate <= endDate;
001660200905                         baseRateHistDS(histCtr).historyDate = wStartDate;
001661200905                         baseRateHistDS(histCtr).appliedRate = getHistRate
001662200905                                                              (
001663200905                                                                transactCCY:
001664200905                                                                baseRateCode:
001665200905                                                                wStartDate
001666200905                                                              );
001667200907                         baseRateHistDS(histCtr).provRateFlg = wProvRateFlg;
001668200904
001669200905                         if wStartDate >= StartDate;
001670200905                              calcRateDS(calcCtr).runDate = wStartDate;
001671200905
001672200905                              if (startDate <> endDate) and
001673200907                                   (wStartDate = endDate) and
001674200907                                   (includeEndDat = 'N');
001675200905                                   calcRateDS(calcCtr).daysApplied = 0;
001676200905                                   calcRateDS(calcCtr).calendarDay = 0;
001677200905                                   calcRateDS(calcCtr).appliedRate = 0;
001678200905                                   calcRateDS(calcCtr).effectiRate = 0;
001679200905                                   calcRateDS(calcCtr).calculaRate = 0;
001680200905                                   calcRateDS(calcCtr).cumulatRate = 0;
001681200905                                   calcRateDS(calcCtr).compoundRat = 0;
001687200905                                   leave;
001689200905                              endif;
001690200904
001691200905                              //***** Get days applied (ni) and calendar days *****//
001692200907                              select;
001693200907
001694200907                                   when weightConv = 1;
001695200907                                        if calcCtr > 1;
001696200907                                            calcRateDS(calcCtr -1).daysApplied =
001697200907                                            calcRateDS(calcCtr).RunDate -
001698200907                                            calcRateDS(calcCtr-1).RunDate;
001699200907                                            calcRateDS(calcCtr -1).calendarDay =
001700200907                                            calcRateDS(calcCtr).RunDate +
001701200907                                            calcRateDS(calcCtr-1).RunDate;
001702200907                                        else;
001703200907                                             calcRateDS(calcCtr).daysApplied
001704200907                                             = 1;
001705200907                                             calcRateDS(calcCtr).calendarDay
001706200907                                             = 1;
001707200907                                        endif;
001708200907                                     when weightConv = 2;
001709200907                                            calcRateDS(calcCtr).daysApplied =
001710200907                                            baseRateHistDS(calcCtr -
001711200907                                            (lookBackDays-1)).rundate -
001713200907                                            baseRateHistDS(calcCtr -
001714200907                                            lookBackDays).
001715200907                                            RunDate;
001720200907                              endsl;
001721200904
001722200905                              //***** Get Rate (ri) *****//
001723200905                              calcRateDS(calcCtr).appliedRate  = baseRateHistDS
001724200905                              (calcCtr - lookBackDays).appliedRate;
001725200904
001726200904
001727200905                              select;
001728200905                                   when averagingOpt = 1;
001729200905                                        //***** Get Effective Rate (ri x ni /N) *****//
001730200905                                        calcRateDS(calcCtr).effectiRate =
001731200905                                        calcRateDS(calcCtr).appliedRate /
001732200905                                        (wCalcBasis  *
001733200905                                         calcRateDS(calcCtr).daysApplied);
001734200905
001735200904
001736200905                                        //***** Get Calculated Rate *****//
001737200905                                        calcRateDS(calcCtr).calculaRate = 1  +
001738200905                                        (calcRateDS(calcCtr).effectiRate/100);
001739200904
001740200905                                        //***** Get cumulative rate *****//
001741200905                                       if calcCtr <= 1;
001742200905                                           calcRateDS(calcCtr).cumulatRate =
001743200905                                           calcRateDS(calcCtr).calculaRate;
001744200905                                       else;
001745200905                                          calcRateDS(calcCtr).cumulatRate =
001746200905                                          calcRateDS(calcCtr-1).cumulatRate
001747200905                                          * calcRateDS(calcCtr).calculaRate;
001748200905                                       endif;
001749200904
001750200904
001751200905                                       //***** Get Compounded Rate *****//
001752200905                                       calcRateDS(calcCtr).compoundRat =
001753200905                                       (calcRateDS(calcCtr).cumulatRate - 1) *
001754200905                                       (wCalcBasis/calcRateDS(calcCtr).
001755200905                                         calendarDay
001756200905                                        * 100);
001757200905
001758200905
001759200905                                   when averagingOpt = 2;
001760200905
001761200905                                        //***** Get Effective Rate (ri x ni /N) *****//
001762200905                                        calcRateDS(calcCtr).effectiRate =
001763200905                                        calcRateDS(calcCtr).appliedRate /
001764200905                                        (wCalcBasis  *
001765200905                                         calcRateDS(calcCtr).daysApplied);
001766200905
001767200905
001768200905                                        //***** Get Calculated Rate *****//
001769200905                                        calcRateDS(calcCtr).calculaRate = 0;
001770200905
001771200905                                        //***** Get cumulative rate *****//
001772200905                                        calcRateDS(calcCtr).cumulatRate = 0;
001773200905
001774200905                                        //***** Get Compounded Rate *****//
001775200905                                        calcRateDS(calcCtr).compoundRat = 0;
001776200905
001777200905                              endsl;
001778200905                              //increment calculatedDS index
001779200905                              calcCtr = calcCtr + 1;
001780200905                         endif;
001781200904
001782200905                         wNoDays = 1;
001783200905                         callp forwardDays  ( wStartDate
001784200905                                              :wNoDays
001785200905                                              :wRetDay
001786200905                                              :transactCCY
001787200905                                              :wLocation
001788200905                                             );
001789200905                         wStartDate = wRetDay;
001790200904
001791200905                         //increment historyRateDS
001792200905                         histCtr = histCtr + 1;
001793200903                    enddo;
001794200903       endsr;
001795200903
001796200903       //*************************************************************
001797200903       /EJECT
001798200903       //*************************************************************
001799200903       //                                                            *
001800200903       // inzsr - Program Initialisation routine                     *
001801200903       //                                                            *
001802200903       // Called by: Main processing                                 *
001803200903       //                                                            *
001804200903       //  Calls: None                                               *
001805200903       //                                                            *
001806200903       //*************************************************************
001807200903
001808200903       begsr *inzsr;
001809200905
001810200905                   clear calcRateDS;
001811200907                   clear baseRateHistDS;
001812200907                   clear wLockOutDate;
001813200907                   clear wLockOutRate;
001814200907                   provRateFlg = 'N';
001815200907                   errorCode = *blanks;
001816200907
001817200907                   //Determine divisor based on calculation basis passed to this program
001818200907
001819200905                   select;
001820200905
001821200905                     when calcBasis = 1
001822200905                             or calcBasis = 4;
001823200905
001824200905                          wCalcBasis = 365;
001825200905
001826200905                     when calcBasis = 2
001827200905                             or calcBasis = 3
001828200905                             or calcBasis = 5;
001829200905
001830200905                          wCalcBasis = 360;
001831200905
001832200905                     when calcBasis = 6;
001833200905
001834200905                          wCalcBasis = 366;
001835200905
001836200905                   endsl;
001837200907
001838200907                   // If lock out days parameter is passed, determine the first day of lockout
001839200907
001840200907                   if lockOutDays <> 0;
001841200907                        callp backwardDays (  endDate
001842200907                                             :transactCCY
001843200907                                             :wLocation
001844200907                                             :lockOutDays
001845200907                                             :wRetDay
001846200907                                            );
001847200907
001848200907                        wLockOutDate = wRetDay;
001849200907
001850200907                   endif;
001851200907
001852200903       endsr;
001853200903
001854200903       //*************************************************************
001855200903       /EJECT
001856200903       //*************************************************************
001857200903       //                                                            *
001858200903       //   *pssr  - Program Error Processing Subroutine.            *
001859200903       //                                                            *
001860200903       //   Called By: Main Processing                               *
001861200903       //                                                            *
001862200903       //*************************************************************
001863200903
001864200903       begsr *pssr;
001865200903                   *inu7 = *on;
001866200903                   *inu8 = *on;
001867200903                   *Inlr = *on;
001868200903                   dump;
001869200903                   return;
001870200903       endsr;
001871200903
001872200903      /end-free
001873200903
001874200903      *****************************************************************
001875200903      /EJECT
001876200903      *****************************************************************
001877200903      *                                                               *
001878200903      *  getHistRate - Get rates from history file                    *
001879200903      *                                                               *
001880200903      *****************************************************************
001881200903
001882200903     P getHistRate     B
001883200903     D getHistRate     PI            11P 7
001884200903     D    pCCY                        3a
001885200904     D    pBRC                        2s 0
001886200903     D    pHDT                        5s 0
001887200903     D   retVal        S             11P 7
001888200905
001889200903     C                   EVAL      RetVal = *ZEROS
001890200903     C     KHIST         KLIST
001891200904     C                   KFLD                    pCCY
001892200904     C                   KFLD                    pBRC
001893200904     C                   KFLD                    pHDT
001894200907
001895200907     C                   IF        lockOutDays <> 0
001896200907     C                   IF        pHDT >= wLockOutDate
001897200907     C                   IF        wLockOutRate = 0
001898200907     C                   EVAL      wLockOutRate =
001899200907     C                             baseRateHistDS(histCtr -1).AppliedRate
001900200907     C                   ELSE
001901200907     C                   EVAL      RetVal = wLockOutRate
001902200907     C                   RETURN    RetVal
001903200907     C                   ENDIF
001904200907     C                   ENDIF
001905200907     C                   ENDIF
001906200905      *
001907200904     C     KHIST         CHAIN (N) SDBSHSL1                           55
001908200903     C     *IN55         IFEQ      *OFF
001909200903     C                   EVAL      RetVal =  G0CBSR
001910200907     C                   EVAL      wProvRateFlg = 'N'
001911200904     C                   ELSE
001912200904     C     KHIST         SETLL     SDBSHSL1                           55
001913200904     C                   READP (N) SDBSHSL1                               55
001914200904     C     *IN55         IFEQ      *OFF
001915200904     C                   EVAL      RetVal =  G0CBSR
001916200907     C                   EVAL      wProvRateFlg = 'Y'
001917200907     C                   EVAL      provRateFlg = 'Y'
001918200904     C                   ENDIF
001919200903     C                   ENDIF
001920200905      *
001921200903     C                   RETURN    RetVal
001922200903     P   getHistRate   E
001923200903
