     H DEBUG
     H DFTACTGRP(*NO)
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD API - Calculate Term Rate')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Dat API - Calculate Term Rate         *
      *                                                               *
      *  ZACALRTE - Midas API - Calculate Term Rate                   *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CSD103 *CREATE     Date 10Aug20               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *                                                               *
      *****************************************************************

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC
     D/COPY ZSRSRC,ZINTDYZ1LE
     D/COPY ZSRSRC,ZHOLILE
     D/COPY ZSRSRC,ZHOLELE

      ** +--------------------------------------+
      ** ¦ Program Prototypes                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      *  +----------------+
      ** |Parameter lists |
      ** +----------------+

     D Main            pr                  extpgm('ZACALRTE')

     D  transactCCY                   3a
      ** Transaction Currency (input)
     D  baseRateCode                  2a
      ** Base Rate Code (input)
     D  calcBasis                     1a
      ** Calculation Basis (input)
     D  startDate                     5s 0
      ** Start Date of Compounding (input)
     D  endDate                       5s 0
      ** End Date of Compounding (input)
     D  lookBackDays                  2s 0
      ** Number of Days Lookback (input)
     D  lockOutDays                   2s 0
      ** Number of Days Lockout (input)
     D  averagingOpt                  1a
      ** Averaging Option (input)
      **    1 - Compund Average
      **    2 - Simple Average in Arrears
      **    3 - No Averaging (Base Rates File)
      **    4 - No Averaging (User Input)
      *
     D  weightConv                    1a
      ** Weight Convention (input)
      **    1 - Based on the day in the interest period
      **    2 - Based on the day in the observation period
     D  includeEndDat                 1a
      ** Include End Date in Compounding Flag (Y/N)
     D  provRateFlg                   1a
      ** Provisional Rate Flag (output)
     D  returnRate                   20p15
      ** Compounded/Average Rate (output)

     D Main            pi

     D  transactCCY                   3a
      ** Transaction Currency (input)
     D  baseRateCode                  2a
      ** Base Rate Code (input)
     D  calcBasis                     1a
      ** Calculation Basis (input)
     D  startDate                     5s 0
      ** Start Date of Compounding (input)
     D  endDate                       5s 0
      ** End Date of Compounding (input)
     D  lookBackDays                  2s 0
      ** Number of Days Lookback (input)
     D  lockOutDays                   2s 0
      ** Number of Days Lockout (input)
     D  averagingOpt                  1a
      ** Averaging Option (input)
      **    1 - Compund Average
      **    2 - Simple Average in Arrears
      **    3 - No Averaging (Base Rates File)
      **    4 - No Averaging (User Input)
      *
     D  weightConv                    1a
      ** Weight Convention (input)
      **    1 - Based on the day in the interest period
      **    2 - Based on the day in the observation period
     D  includeEndDat                 1a
      ** Include End Date in Compounding Flag (Y/N)
     D  provRateFlg                   1a
      ** Provisional Rate Flag (output)
     D  returnRate                   20p15
      ** Compounded/Average Rate (output)
      *

      ** Prototype to call ZAGETRTE
     D  getBaseRate    pr                  extpgm('ZAGETRTE')
     D  transactCCY                   3a
     D  baseRateCode                  2a
     D  histDate                      5  0
     D  returnRate                   11p 7
     D  provFlag                      1a


      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

     D dssdy         e ds                  extname(DSSDY)
     D dsfdy         e ds                  extname(DSFDY)

     D bsrhDS          ds                  dim(1000) qualified
     D    historyDate                 5s 0
     D    SOFR_Rate                  11p 7
     D    appliedRate                11p 7
     D    provRateFlg                 1a
     D    daysApplied                 5s 0
     D    calendarDay                 5s 0
     D    effectiRate                 8f
     D    calculaRate                 8f
     D    cumulatRate                 8f
     D    compoundRat                 8f

      ** +--------------------------------------+
      ** ¦ Constants declaration                ¦
      ** ¦ =====================                ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+

     D i               s              4s 0 inz(0)
     D ctr             s              4s 0 inz(0)
     D wNoDays         s              2s 0 inz(0)
     D wStartDate      s              5  0 inz(0)
     D wEndDate        s              5  0 inz(0)
     D wCalcBasis      s              3s 0 inz(0)
     D wLockOutDate    s              5s 0 inz(0)
     D wTotalDays      s              5s 0 inz(0)
     D wTotalRate      s              8f   inz(0)
     D wCalcuRate      s              8f   inz(0)
     D wLatestRat      s             11p 7 inz(0)
     D wLockOutRate    s             11p 7 inz(0)
     D wLockOutFlag    s               n


      ** +--------------------------------------+
      ** ¦ Array declaration                    ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      /free

       // ** +--- Start of Main processing -----------------------------------+
       // ** ¦                                                                ¦
       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
       // ** ¦ executed at program activation.                                ¦
       // ** ¦                                                                ¦
       // ** +----------------------------------------------------------------+

                   exsr calculateRates;

                   *Inlr = *On;
                   return;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // calculateRates - Build History Array from SDBSHSPD and     *
       // ==============   calculate rates                           *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       // Calls: None                                                *
       //                                                            *
       //*************************************************************

       begsr calculateRates;


                    // Build the base rates history data structure initially retrieving the
                    // SOFR applicable rates

                    ctr = 1;

                    dow  wStartDate <= wEndDate;

                         bsrhDS(ctr).historyDate = wStartDate;

                         Callp getBaseRate(
                                          transactCCY
                                          :baseRateCode
                                          :wstartDate
                                          :bsrhDS(ctr).SOFR_Rate
                                          :bsrhDS(ctr).provRateFlg
                                          );

                         if (wLockOutDate = wStartDate) and wLockOutFlag;
                            wLockOutRate = bsrhDS(ctr).SOFR_Rate;
                         endif;

                         // Use ZFWDT API to get the next working day

                         wNoDays = 1;
                         zdayno = wStartDate;
                         zccy = transactCCY;
                         zloc = *blanks;
                         znrdys = wNoDays;
                         zdynbr = 0;
                         exsr zfwdt;
                         wStartDate = zdynbr;

                         ctr = ctr + 1;
                    enddo;

                    // read the base rates history file and calcuate necessary fields

                    for i = 1 to ctr;

                         // applied rates and other fields should be computed only for the
                         // inclusive interest period since bsrhDS contains date earlier
                         // than start date of the interest period when lookback days is
                         // specified

                         if bsrhDS(i).historyDate >= startDate;

                              // When include end date in compounding is set to yes, include
                              // the last day of the interest period in the computation otherwise
                              // only include last day - 1

                              if  (bsrhDS(i).historyDate < wEndDate)
                                  or (bsrhDS(i).historyDate = EndDate
                                 and includeEndDat = 'Y');

                                   //***** Get Rate (ri) *****//
                                   // If lock out days is specified, applied rate should be the same
                                   // as applied rate ofthe previous interest period when
                                   // lock out date has been reached. Otherwise get the applied
                                   // rate in the data structure less the lookback days

                                   if wLockOutRate <> 0;
                                        bsrhDS(i).appliedRate  = wLockOutRate;
                                   else;
                                        if wLockOutDate <> 0 and
                                           (wlockOutDate <
                                             bsrhDS(i).historyDate);
                                             bsrhDS(i).appliedRate  =
                                                bsrhDS(i-1).appliedRate;
                                        else;
                                             bsrhDS(i).appliedRate  =
                                             bsrhDS(i-lookBackDays).
                                             SOFR_Rate;
                                        endif;
                                   endif;
                                   wLatestRat = bsrhDS(i).appliedRate;
                                   if bsrhDS(i).provRateFlg = 'Y';
                                        provRateFlg = bsrhDS(i).provRateFlg;
                                   endif;
                              else;
                                 iter;
                              endif;

                              if averagingOpt = '3';
                                   iter;
                              endif;


                              //*** Get days applied (ni) and calendar days ***//
                              select;

                                   when weightConv = '1';
                                            bsrhDS(i).daysApplied =
                                            bsrhDS(i + 1).Historydate -
                                            bsrhDS(i).HistoryDate;
                                    when weightConv = '2';
                                            bsrhDS(i).daysApplied =
                                            bsrhDS(i -
                                            lookBackDays+1).historydate -
                                            bsrhDS(i -
                                            lookBackDays).
                                            historydate;
                              endsl;

                              // *** Calculate sum of days applied ***//
                              if  startDate = bsrhDS(i).historyDate;
                                   wTotalDays = bsrhDS(i).daysApplied;
                              else;
                                   wTotalDays = wTotalDays +
                                      bsrhDS(i).daysApplied;
                              endif;

                              //*** calendar days ***//
                              if startDate = bsrhDS(i).
                                   historyDate;
                                   bsrhDS(i).calendarDay =
                                   bsrhDS(i).daysApplied;
                               else;
                                   bsrhDS(i).calendarDay =
                                   bsrhDS(i).daysApplied +
                                   bsrhDS(i-1).CalendarDay;
                               endif;


                               //*** Get Effective Rate (ri x ni /N) ***//
                               bsrhDS(i).effectiRate =
                               bsrhDS(i).appliedRate *
                               bsrhDS(i).daysApplied/wCalcBasis;
                               select;
                                   when averagingOpt = '1';

                                        //*** Get Calculated Rate ***//
                                        bsrhDS(i).calculaRate = 1  +
                                        (bsrhDS(i).effectiRate/100);

                                        if  startDate =
                                             bsrhDS(i).historyDate;
                                             wTotalRate = bsrhDS(i).
                                                          calculaRate;
                                        else;
                                             wTotalRate = wTotalRate *
                                             bsrhDS(i).calculaRate;
                                        endif;

                                        //*** Get cumulative rate ***//
                                       if startDate = bsrhDS(i).historyDate;
                                           bsrhDS(i).cumulatRate =
                                           bsrhDS(i).calculaRate;
                                       else;
                                          bsrhDS(i).cumulatRate =
                                          bsrhDS(i - 1).cumulatRate
                                          * bsrhDS(i).calculaRate;
                                       endif;

                                       //*** Get Compounded Rate ***//
                                       bsrhDS(i).compoundRat =
                                       ((bsrhDS(i).cumulatRate - 1)*
                                       wCalcBasis)/bsrhDS(i).calendarDay * 100;

                                   when averagingOpt = '2';

                                        if  startDate =
                                             bsrhDS(i).historyDate;
                                             wTotalRate = bsrhDS(i).
                                                    effectiRate;
                                        else;
                                             wTotalRate = wTotalRate +
                                                    bsrhDS(i).effectiRate;
                                        endif;

                                        //*** Get Calculated Rate ***//
                                        bsrhDS(i).calculaRate = 0;

                                        //*** Get cumulative rate ***//
                                        bsrhDS(i).cumulatRate = 0;

                                        //*** Get Compounded Rate ***//
                                        bsrhDS(i).compoundRat = 0;

                               endsl;
                         endif;

                    endfor;

                    // Compute for the compounded/average rate based on averaging option parameter

                   select;
                        when averagingOpt = '1';
                             // Calculation Basis/ Sum of Total Days Applied *
                             // Product of Total Calculated rates - 1 * 100
                             wCalcuRate  = (wCalcBasis / wTotalDays *
                                           (wTotalRate  - 1) * 100);
                             returnRate = wCalcuRate;

                        when averagingOpt = '2';
                             // Calculation Basis/ Sum of Total Days Applied *
                             // Sum of Effective Rates
                             wCalcuRate  = wCalcBasis / wTotalDays *
                                           wTotalRate;
                             returnRate = wCalcuRate;

                        when averagingOpt = '3';
                             returnRate = wLatestRat;
                   endsl;


       endsr;

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

                   clear bsrhDS;
                   clear wLockOutDate;
                   clear wLockOutRate;
                   clear wLockOutFlag;

                   provRateFlg = 'N';
                   wStartDate = startDate;

                   if AveragingOpt = '3';
                        includeEndDat = 'Y';
                   endif;


                   // If lock out days parameter is passed, determine the first day of lockout

                   if lockOutDays <> 0;
                         zdayno = endDate;
                         zccy = transactCCY;
                         zloc = *blanks;
                         znrdys = lockOutDays;
                         zdynbr = 0;
                         exsr zbkdt;
                         wLockOutDate = zdynbr;
                   endif;

                   if includeEndDat = 'Y';
                         wNoDays = 1;
                         zdayno = endDate;
                         zccy = transactCCY;
                         zloc = *blanks;
                         znrdys = wNoDays;
                         zdynbr = 0;
                         exsr zfwdt;
                         wEndDate = zdynbr;
                   else;
                        wEndDate = EndDate;
                   endif;

                    if (wLockOutDate <= wStartDate) and wLockOutDate <> 0;
                         wStartDate = wLockOutDate;
                         wLockOutFlag = True;
                         lookBackDays = 0;
                    endif;

                    //Go backwards depending on the lookBackDays
                    if lookBackDays <> 0;
                         zdayno = startDate;
                         zccy = transactCCY;
                         zloc = *blanks;
                         znrdys = lookBackDays;
                         zdynbr = 0;
                         exsr zbkdt;
                         wStartDate = zdynbr;
                    endif;



                   //Determine divisor based on calculation basis passed to this program

                   select;

                     when calcBasis = '1'
                             or calcBasis = '4'
                             or calcBasis = '6'
                             or calcBasis = '9';

                          wCalcBasis = 365;

                     when calcBasis = '2'
                             or calcBasis = '3'
                             or calcBasis = '5'
                              or calcBasis = '7';

                          wCalcBasis = 360;


                   endsl;


       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   *pssr  - Program Error Processing Subroutine.            *
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

      /end-free

     C/COPY ZSRSRC,ZACCHLE
     C/COPY ZSRSRC,ZBKDT_ILE
     C/COPY ZSRSRC,ZFWDT_ILE
