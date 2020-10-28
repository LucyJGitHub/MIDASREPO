     H DEBUG
     H DFTACTGRP(*NO)
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Compute Interest Amount')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data API - Compute Interest Amount    *
      *                                                               *
      *  ZACMPINT - Midas API - Compute Interest Amount               *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CLE172  *CREATE    Date 01Oct20               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CLE172 - LIBOR Deregulation - Lending                        *
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

     D Main            pr                  extpgm('ZACMPINT')

      ** Option (input)
     D  option                        7a
      ** Return Code
     D  retcode                       7a
      ** LIBOR Fields (Input)
     D  liborfields                 200a

     D Main            pi

      ** Option (input)
     D  option                        7a
      ** Return Code
     D  retcode                       7a
      ** LIBOR Fields (Input)
     D  liborfields                 200a

     D  calculateRate  pr                  extpgm('ZACALRTE')
     D  transactCCY                   3a
     D  baseRateCode                  2a
     D  calcBasis                     1a
     D  startDate                     5  0
     D  endDate                       5  0
     D  lookBackDays                  2s 0
     D  lockOutDays                   2s 0
     D  averagingOpt                  1a
     D  weightConv                    1a
     D  includeEndDat                 1a
     D  provRateFlg                   1a
     D  returnRate                   20p15

      ** Prototype to call ZAGETRTE
     D  getBaseRate    pr                  extpgm('ZAGETRTE')
     D  transactCCY                   3a
     D  baseRateCode                  2a
     D  histDate                      5  0
     D  returnRate                   11p 7
     D  provFlag                      1a

      ** Prototype to call ZINTDY
     D  getIntrstDays  pr                  extpgm('ZINTDY')
     D  retcodeIn                     3a
     D  intrstDays                    5  0
     D  start                         5  0
     D  end                           5  0
     D  calcbasis                     1a
     D  numIntrstDays                15  9

      ** Prototype to call AOSARDR0
     D  check_SARD     pr                  extpgm('AOSARDR0')
     D    returnCode                  7A
     D    option                      7A
     D    sard                        6A
     D    dssdy                     200A

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

     D sdlibor       e ds                  extname(SDLIBRFLD)
     D dssdy         e ds                  extname(DSSDY)
     D scsard        e ds                  extname(SCSARDPD)

      ** +--------------------------------------+
      ** ¦ Constants declaration                ¦
      ** ¦ =====================                ¦
      ** +--------------------------------------+

     D OPT_ACCRUE      c                   const('*ACRRU*')
     D OPT_INTRST      c                   const('*INTMT*')

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+

     D BSRC            s              2a   inz('')
     D BACK            s              2s 0 inz(0)
     D wValueDate      s              5  0 inz(0)
     D wBaseRate       s             11p 7 inz(0)
     D wrkField1       s             30p 9 inz(0)
     D wrkField2       s             30p 9 inz(0)
     D pRetCodeIn      s             10a   inz('')
     D pIntrstDays     s              5  0 inz(0)
     D pNoIntrstDays   s             15  9 inz(0)
     D CIR004          s              1a
     D pReturnCode     s              7A
     D pOption         s              7A
     D pSard           s              6A
     D wrkRATE         s             20p15 inz(0)
     D wrkEFRT         s             20p15 inz(0)

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

                   select;

                        when option = OPT_ACCRUE;

                             exsr getAccrualRate;

                        when option = OPT_INTRST;

                             exsr getInterestRate;

                   endsl;

                   exsr calculateEffRate;

                   exsr computeInterestAmount;

                   liborfields = sdlibor;

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

                   sdlibor = liborfields;

                   //Check if CIR004 is switched on

                   pOption = '*VERIFY';
                   pSARD = 'CIR004';

                   callp check_SARD(
                                      pReturnCode
                                    : pOption
                                    : pSard
                                    : dssdy
                                   );

                   scsard = dssdy;

                   if pReturnCode = *blanks;
                      CIR004 = 'Y';
                   else;
                      CIR004 = 'N';
                   endif;



       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       //   *pssr  - Program Error Processing Subroutine.            *
       //                                                            *
       //   Called By: Main Processing                               *
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
       // getAccrualRate - Get Accrual Rate                          *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr getAccrualRate;

                     select;

                          when avop = '1' or
                               avop = '2' or
                               avop = '3';

                               // If there is an accrual base rate defined on the
                               // settlement base rate then that is the rate used
                               // for accruals, and if not then the settlement base
                               // rate on the transaction is used for accruals

                               if BRAC <> *blanks;
                                    BSRC = BRAC;
                               else;
                                    BSRC = BRST;
                               endif;

                               callp calculateRate(
                                                     TCCY
                                                   : BRAC
                                                   : CALB
                                                   : STDT
                                                   : ENDT
                                                   : LBAC
                                                   : LODY
                                                   : AVOP
                                                   : WGHT
                                                   : INCE
                                                   : PRFL
                                                   : wrkRATE
                                                  );

                          // This option allows banks to do their own external compounding.
                          // They would then feed the result of this manual compounding
                          // into the compounded rate field in the deal to be used for accrual.
                          when avop = '4';
                               wrkRATE = CART;

                     endsl;

       endsr;

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // getInterestRate - Get Interest Rate                        *
       //                                                            *
       // Called by: Main Processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr getInterestRate;

                    // If dual base rates are defined on the transaction,
                    // (settlement base rate and base rate for accrual), the
                    // settlement base rate will be retrieved from the base
                    // rates table. The system will determine the highest of
                    // the Lookback Days and Lockout Days defined on the
                    // transaction. It will then go back that number of business
                    // days from the event date and retrieve the base rate for
                    // such value date. The retrieved rate – plus spread –
                    // will be applied to the whole interest period.

                    select;

                         when AVOP = '1' or
                              AVOP = '2' or
                              AVOP = '3';

                              if LBDY = LODY;
                                   BACK = LBDY;
                              elseif LBDY > LODY;
                                   BACK = LBDY;
                              else;
                                   BACK = LODY;
                              endif;

                              zdayno = VALU;
                              zccy = TCCY;
                              zloc = *blanks;
                              znrdys = BACK;
                              zdynbr = 0;
                              exsr zbkdt;
                              wValueDate = zdynbr;

                              callp getBaseRate(
                                                  TCCY
                                                : BRST
                                                : wValueDate
                                                : wBaseRate
                                                : PRFL
                                               );
                              wrkRATE = wBaseRate;

                         // This option allows banks to do their own external compounding.
                         // They would then feed the result of this manual compounding
                         // into the compounded rate field in the deal to be used for accrual.
                         when AVOP = '4';
                              wrkRATE = CART;
                    endsl;

       endsr;

       //*************************************************************
       //                                                            *
       // calculateEffRate - Calculate Effective Rate                *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr calculateEffRate;

                    select;

                         when SPIN = 'A';
                              wrkEFRT = wrkRATE + SPRD;

                         when SPIN = 'S';
                              wrkEFRT = wrkRATE - SPRD;

                         when SPIN = 'P';
                              wrkEFRT = wrkRATE * (SPRD/100);

                         other;
                              wrkEFRT = wrkRATE;
                    endsl;

       endsr;

      /end-free

       //*************************************************************
       /EJECT
       //*************************************************************
       //                                                            *
       // computeInterestAmount - Compute Interest Amount            *
       //                                                            *
       // Called by: Main processing                                 *
       //                                                            *
       //  Calls: None                                               *
       //                                                            *
       //*************************************************************

       begsr computeInterestAmount;

                    callp getIntrstDays(
                                           pRetCodeIn
                                         : pIntrstDays
                                         : STDT
                                         : ENDT
                                         : CALB
                                         : pNoIntrstDays
                                       );

                    wrkField1 = PAMT * wrkEFRT;

                    select;

                          when CALB = '6';

                               wrkField2 = wrkField1 * pNoIntrstDays;

                          other;

                               wrkField2 = wrkField1 * pIntrstDays;

                    endsl;

                    select;

                          when CALB = '2' or
                               CALB = '3' or
                               CALB = '5' or
                               CALB = '7' and
                               CIR004 = 'Y' or
                               CALB = ' ';

                               TNTA = wrkField2 / 36000;

                          when CALB = '1' or
                               CALB = '4';

                               TNTA = wrkField2 / 36500;

                          when CALB = '6';

                               TNTA = wrkField2 / 36600;

                    endsl;

       endsr;

     C/COPY ZSRSRC,ZACCHLE
     C/COPY ZSRSRC,ZBKDT_ILE
     C/COPY ZSRSRC,ZFWDT_ILE


