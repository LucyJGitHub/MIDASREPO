000100200903     H DEBUG
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
000163200904
000164200910     D Main            pr                  extpgm('ZACALRTE')
000165200905
000166200910     D  transactCCY                   3a
000167200905      ** Transaction Currency (input)
000168200910     D  baseRateCode                  2s 0
000169200905      ** Base Rate Code (input)
000170200910     D  calcBasis                     1s 0
000171200905      ** Calculation Basis (input)
000172200910     D  startDate                     5s 0
000173200905      ** Start Date of Compounding (input)
000174200910     D  endDate                       5s 0
000175200905      ** End Date of Compounding (input)
000176200910     D  lookBackDays                  2s 0
000177200905      ** Number of Days Lookback (input)
000178200910     D  lockOutDays                   2s 0
000179200905      ** Number of Days Lockout (input)
000180200910     D  averagingOpt                  1s 0
000181200905      ** Averaging Option (input)
000182200905      **    1 - Compund Average
000183200905      **    2 - Simple Average in Arrears
000184200905      **    3 - No Averaging (Base Rates File)
000185200905      **    4 - No Averaging (User Input)
000186200910      *
000187200910     D  weightConv                    1a
000188200905      ** Weight Convention (input)
000189200907      **    1 - Based on the day in the interest period
000190200907      **    2 - Based on the day in the observation period
000191200910     D  includeEndDat                 1a
000192200905      ** Include End Date in Compounding Flag (Y/N)
000193200910     D  provRateFlg                   1a
000194200910      ** Provisional Rate Flag (output)
000195200910     D  calculatedRat                11p 7
000196200905      ** Compounded/Average Rate (output)
000197200910     D  errorCode                     3a
000198200907      ** Error Code (output)
000199200905
000200200903     D Main            pi
000201200910
000202200910     D  transactCCY                   3a
000203200910      ** Transaction Currency (input)
000204200910     D  baseRateCode                  2s 0
000205200910      ** Base Rate Code (input)
000206200910     D  calcBasis                     1s 0
000207200910      ** Calculation Basis (input)
000208200910     D  startDate                     5s 0
000209200910      ** Start Date of Compounding (input)
000210200910     D  endDate                       5s 0
000211200910      ** End Date of Compounding (input)
000212200910     D  lookBackDays                  2s 0
000213200910      ** Number of Days Lookback (input)
000214200910     D  lockOutDays                   2s 0
000215200910      ** Number of Days Lockout (input)
000216200910     D  averagingOpt                  1s 0
000217200910      ** Averaging Option (input)
000218200910      **    1 - Compund Average
000219200910      **    2 - Simple Average in Arrears
000220200910      **    3 - No Averaging (Base Rates File)
000221200910      **    4 - No Averaging (User Input)
000222200910      *
000223200910     D  weightConv                    1a
000224200910      ** Weight Convention (input)
000225200910      **    1 - Based on the day in the interest period
000226200910      **    2 - Based on the day in the observation period
000227200910     D  includeEndDat                 1a
000228200910      ** Include End Date in Compounding Flag (Y/N)
000229200910     D  provRateFlg                   1a
000230200910      ** Provisional Rate Flag (output)
000231200911     D  calculatedRat                11p 7
000232200910      ** Compounded/Average Rate (output)
000233200910     D  errorCode                     3a
000234200910      ** Error Code (output)
000262200905
000281200910     D  getSDBANK      pr                  extpgm('AOBANKR0')                                 CLE168
000282200910     D    pReturnCode                 7A                                                      CLE168
000283200910     D    pOption                     7A                                                      CLE168
000284200910     D    pDSFDY                    200A                                                      CLE168
000285200910
000286200903
000287200905      ** Prototype to call getHistRate function
000288200903     D  getHistRate    pr            11P 7
000289200903     D    pCurrency                   3a
000290200904     D    pBaseRate                   2s 0
000291200903     D    pHistDate                   5s 0
000292200903
000293200903      ** +--------------------------------------+
000294200903      ** ¦ Manually included D-specs            ¦
000295200903      ** ¦ =========================            ¦
000296200903      ** +--------------------------------------+
000297200910
000298200910     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01194
000299200910     D sdbank        e ds                  extname(SDBANKPD)
000300200910
000302200910     D bsrhDS          ds                  dim(1000) qualified
000303200911     D    historyDate                 5s 0
000304200911     D    SOFR_Rate                  20p15
000305200911     D    appliedRate                20p15
000306200910     D    provRateFlg                 1a
000308200907     D    daysApplied                 5s 0
000309200907     D    calendarDay                 5s 0
000310200911     D    effectiRate                20p15
000311200911     D    calculaRate                20p15
000312200911     D    cumulatRate                20p15
000313200911     D    compoundRat                20p15
000314200903
000315200904
000316200903      ** +--------------------------------------+
000317200903      ** ¦ Constants declaration                ¦
000318200903      ** ¦ =====================                ¦
000319200903      ** +--------------------------------------+
000320200903
000321200903      ** +--------------------------------------+
000322200903      ** ¦ Variable declaration                 ¦
000323200903      ** ¦ ====================                 ¦
000324200903      ** +--------------------------------------+
000325200904
000326200911     D i               s              4s 0 inz(0)
000327200910     D ctr             s              4s 0 inz(0)
000328200905     D wLocation       s              3a   inz(*blanks)
000329200904     D wNoDays         s              2s 0 inz(0)
000330200905     D wRetDay         s              5s 0 inz(0)
000331200905     D wStartDate      s              5s 0 inz(0)
000332200910     D wEndDate        s              5s 0 inz(0)
000333200904     D wCalcBasis      s              3s 0 inz(0)
000334200907     D wProvRateFlg    s              1a   inz(*blanks)
000335200907     D wLockOutDate    s              5s 0 inz(0)
000336200910     D pReturnCode     s              7A
000337200910     D pOption         s              7A
000338200910     D pDSFDY          s            200A
000339200903
000340200903      ** +--------------------------------------+
000341200903      ** ¦ Array declaration                    ¦
000342200903      ** ¦ ==================                   ¦
000343200903      ** +--------------------------------------+
000344200903
000345200910      /free
000346200903
000347200903       // ** +--- Start of Main processing -----------------------------------+
000348200903       // ** ¦                                                                ¦
000349200903       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
000350200903       // ** ¦ executed at program activation.                                ¦
000351200903       // ** ¦                                                                ¦
000352200903       // ** +----------------------------------------------------------------+
000353200903
000355200903                   exsr calculateRates;
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
001692200910
001693200910                         wNoDays = 1;
001694200910                         zdayno = wStartDate;
001695200910                         zccy = transactCCY;
001696200910                         zloc = *blanks;
001697200910                         znrdys = wNoDays;
001698200910                         zdynbr = 0;
001699200910                         exsr zfwdt;
001700200910                         wStartDate = zdynbr;
001701200910
001702200910                         //increment historyRateDS
001703200910                         ctr = ctr + 1;
001704200910                    enddo;
001705200910
001706200910                    for i = 1 to ctr;
001707200910                         if bsrhDS(i).historyDate >= startDate;
001709200910
001710200911                              if  bsrhDS(i).historyDate < wEndDate;
001715200911                                   //***** Get Rate (ri) *****//
001716200911                                   if wlockOutDate <= bsrhDS(i).historyDate;
001717200911                                        bsrhDS(i).appliedRate  = bsrhDS(i-1).
001718200911                                                  appliedRate;
001719200911                                   else;
001720200911                                        bsrhDS(i).appliedRate  =
001721200911                                        bsrhDS(i-lookBackDays).
001722200911                                        SOFR_Rate;
001723200911                                   endif;
001724200911                              else;
001725200911                                 iter;
001726200911                              endif;
001727200910
001739200910
001740200910                              //***** Get days applied (ni) and calendar days *****//
001741200910                              select;
001742200910
001743200910                                   when weightConv = '1';
001744200910                                            bsrhDS(i).daysApplied =
001745200910                                            bsrhDS(i + 1).Historydate -
001746200910                                            bsrhDS(i).HistoryDate;
001751200910                                    when weightConv = '2';
001752200910                                            bsrhDS(i).daysApplied =
001753200910                                            bsrhDS(i -
001754200910                                            lookBackDays-1).historydate -
001755200910                                            bsrhDS(i -
001756200910                                            lookBackDays).
001757200910                                            historydate;
001758200910                              endsl;
001759200910
001760200910                              //***** calendar days *****//
001761200910                              if startDate = bsrhDS(i).
001762200910                                   historyDate;
001763200910                                   bsrhDS(i).calendarDay =
001764200910                                   bsrhDS(i).daysApplied;
001765200910                               else;
001766200910                                   bsrhDS(i).calendarDay =
001767200910                                   bsrhDS(i).daysApplied +
001768200910                                   bsrhDS(i-1).CalendarDay;
001769200910                               endif;
001770200910
001771200910
001772200910                               //***** Get Effective Rate (ri x ni /N) *****//
001773200910                               bsrhDS(i).effectiRate =
001774200910                               bsrhDS(i).appliedRate *
001775200910                               bsrhDS(i).daysApplied/wCalcBasis;
001776200910                               select;
001777200910                                   when averagingOpt = 1;
001781200910
001782200910                                        //***** Get Calculated Rate *****//
001783200910                                        bsrhDS(i).calculaRate = 1  +
001784200910                                        (bsrhDS(i).effectiRate/100);
001785200910
001786200910                                        //***** Get cumulative rate *****//
001787200910                                       if startDate = bsrhDS(i).historyDate;
001788200910                                           bsrhDS(i).cumulatRate =
001789200910                                           bsrhDS(i).calculaRate;
001790200910                                       else;
001791200910                                          bsrhDS(i).cumulatRate =
001792200910                                          bsrhDS(i - 1).cumulatRate
001793200910                                          * bsrhDS(i).calculaRate;
001794200910                                       endif;
001795200910
001797200910                                       //***** Get Compounded Rate *****//
001798200910                                       bsrhDS(i).compoundRat =
001799200911                                       ((bsrhDS(i).cumulatRate - 1)*
001800200911                                        wCalcBasis)/bsrhDS(i).calendarDay * 100;
001804200910
001805200910                                   when averagingOpt = 2;
001806200910
001814200910                                        //***** Get Calculated Rate *****//
001815200910                                        bsrhDS(i).calculaRate = 0;
001816200910
001817200910                                        //***** Get cumulative rate *****//
001818200910                                        bsrhDS(i).cumulatRate = 0;
001819200910
001820200910                                        //***** Get Compounded Rate *****//
001821200910                                        bsrhDS(i).compoundRat = 0;
001822200910
001823200910                               endsl;
001824200910                         endif;
001825200910
001826200910                    endfor;
001827200910
001838200903       endsr;
001839200903
001840200903       //*************************************************************
001841200903       /EJECT
001842200903       //*************************************************************
001843200903       //                                                            *
001844200903       // inzsr - Program Initialisation routine                     *
001845200903       //                                                            *
001846200903       // Called by: Main processing                                 *
001847200903       //                                                            *
001848200903       //  Calls: None                                               *
001849200903       //                                                            *
001850200903       //*************************************************************
001851200903
001852200903       begsr *inzsr;
001853200905
001855200909                   clear bsrhDS;
001856200907                   clear wLockOutDate;
001857200907                   provRateFlg = 'N';
001858200907                   errorCode = *blanks;
001859200910
001860200910
001861200910                   pOption = '*FIRST';
001862200910                   pReturnCode = *blanks;
001863200910                   callp getSDBANK(
001864200910                                  pReturnCode
001865200910                                : pOption
001866200910                                : pDSFDY
001867200910                               );
001868200910                   sdbank= pDSFDY;
001869200910
001870200910                   // If lock out days parameter is passed, determine the first day of lockout
001871200910
001872200910                   if lockOutDays <> 0;
001873200910                         zdayno = endDate;
001874200910                         zccy = transactCCY;
001875200910                         zloc = *blanks;
001876200910                         znrdys = lockOutDays;
001877200910                         zdynbr = 0;
001878200910                         exsr zbkdt;
001879200910                         wLockOutDate = zdynbr;
001880200910                   else;
001881200910                        wLockOutDate = endDate;
001882200910                   endif;
001883200910
001884200910                   if includeEndDat = 'Y';
001885200910                         wNoDays = 1;
001886200910                         zdayno = endDate;
001887200910                         zccy = transactCCY;
001888200910                         zloc = *blanks;
001889200910                         znrdys = wNoDays;
001890200910                         zdynbr = 0;
001891200910                         exsr zfwdt;
001892200910                         wEndDate = zdynbr;
001893200910                   else;
001894200910                        wEndDate = EndDate;
001895200910                   endif;
001896200910
001897200910                    //Go backwards depending on the lookBackDays
001898200910                    if lookBackDays <> 0;
001899200910                         zdayno = startDate;
001900200910                         zccy = transactCCY;
001901200910                         zloc = *blanks;
001902200910                         znrdys = lookBackDays;
001903200910                         zdynbr = 0;
001904200910                         exsr zbkdt;
001905200910                         wStartDate = zdynbr;
001906200910                    else;
001907200910                        wStartDate = startDate;
001908200910                    endif;
001909200910
001910200907
001911200907                   //Determine divisor based on calculation basis passed to this program
001912200907
001913200905                   select;
001914200905
001915200905                     when calcBasis = 1
001916200905                             or calcBasis = 4;
001917200905
001918200905                          wCalcBasis = 365;
001919200905
001920200905                     when calcBasis = 2
001921200905                             or calcBasis = 3
001922200905                             or calcBasis = 5;
001923200905
001924200905                          wCalcBasis = 360;
001925200905
001926200905                     when calcBasis = 6;
001927200905
001928200905                          wCalcBasis = 366;
001929200905
001930200905                   endsl;
001931200907
001932200907
001933200903       endsr;
001934200903
001935200903       //*************************************************************
001936200903       /EJECT
001937200903       //*************************************************************
001938200903       //                                                            *
001939200903       //   *pssr  - Program Error Processing Subroutine.            *
001940200903       //                                                            *
001941200903       //   Called By: Main Processing                               *
001942200903       //                                                            *
001943200903       //*************************************************************
001944200903
001945200903       begsr *pssr;
001946200903                   *inu7 = *on;
001947200903                   *inu8 = *on;
001948200903                   *Inlr = *on;
001949200903                   dump;
001950200903                   return;
001951200903       endsr;
001952200903
001953200903      /end-free
001954200910
001955200910     C/COPY ZSRSRC,ZFWDT_ILE
001956200910     C/COPY ZSRSRC,ZBKDT_ILE
001957200910     C/COPY ZSRSRC,ZACCHLE
001958200910
001959200903      *****************************************************************
001960200903      /EJECT
001961200903      *****************************************************************
001962200903      *                                                               *
001963200903      *  getHistRate - Get rates from history file                    *
001964200903      *                                                               *
001965200903      *****************************************************************
001966200903
001967200903     P getHistRate     B
001968200903     D getHistRate     PI            11P 7
001969200903     D    pCCY                        3a
001970200904     D    pBRC                        2s 0
001971200903     D    pHDT                        5s 0
001972200903     D   retVal        S             11P 7
001973200905
001974200903     C                   EVAL      RetVal = *ZEROS
001975200903     C     KHIST         KLIST
001976200904     C                   KFLD                    pCCY
001977200910     C                   KFLD                    pBRC
001978200904     C                   KFLD                    pHDT
001979200905      *
001980200904     C     KHIST         CHAIN (N) SDBSHSL1                           55
001981200903     C     *IN55         IFEQ      *OFF
001982200903     C                   EVAL      RetVal =  G0CBSR
001983200907     C                   EVAL      wProvRateFlg = 'N'
001984200904     C                   ELSE
001985200904     C     KHIST         SETLL     SDBSHSL1                           55
001986200904     C                   READP (N) SDBSHSL1                               55
001987200904     C     *IN55         IFEQ      *OFF
001988200904     C                   EVAL      RetVal =  G0CBSR
001989200910     C     pHDT          IFGT      BJRDNB
001990200907     C                   EVAL      wProvRateFlg = 'Y'
001991200907     C                   EVAL      provRateFlg = 'Y'
001992200904     C                   ENDIF
001993200910     C                   ENDIF
001994200903     C                   ENDIF
001995200905      *
001996200903     C                   RETURN    RetVal
001997200903     P   getHistRate   E
001998200910
001999200903
