000100200916     H DEBUG
000101200903     H DFTACTGRP(*NO)
000102200903     H COPYRIGHT('(c) Finastra International Limited 2020')
000104200903      *****************************************************************
000105200904/*STD *  RPGBASEBND                                                   *
000106201001/*EXI *  TEXT('Midas SD Compute Interest Amount')                     *
000107200903      *****************************************************************
000108200903      *                                                               *
000109201001      *  Midas - Midas Standing Data API - Compute Interest Amount    *
000111200903      *                                                               *
000112201001      *  ZACMPINT - Midas API - Compute Interest Amount               *
000113200903      *                                                               *
000114200903      *  (c) Finastra International Limited 2020                      *
000115200903      *                                                               *
000116200903      *  Last Amend No. CSD103 *CREATE     Date 10Aug20               *
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
000148200903     D/COPY ZACPYSRC,PSDS
000149200903     D/COPY ZACPYSRC,STD_D_SPEC
000152200925     D/COPY ZSRSRC,ZINTDYZ1LE
000153200925     D/COPY ZSRSRC,ZHOLILE
000154200925     D/COPY ZSRSRC,ZHOLELE
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
000168201001     D Main            pr                  extpgm('ZACMPINT')
000169200905
000170201001      ** Option (input)
000171200925     D  option                        7a
000172201001      ** Return Code
000173200930     D  retcode                       7a
000174201001      ** LIBOR Fields (Input)
000178200925     D  liborfields                 200a
000203200905
000204200903     D Main            pi
000205200925
000206201001      ** Option (input)
000207200925     D  option                        7a
000208201001      ** Return Code
000209200930     D  retcode                       7a
000210201001      ** LIBOR Fields (Input)
000211200925     D  liborfields                 200a
000212200925
000213200925     D  calculateRate  pr                  extpgm('ZACALRTE')
000308200925     D  transactCCY                   3a
000310200925     D  baseRateCode                  2a
000312200925     D  calcBasis                     1a
000314200930     D  startDate                     5  0
000316200930     D  endDate                       5  0
000318200925     D  lookBackDays                  2s 0
000320200925     D  lockOutDays                   2s 0
000322200925     D  averagingOpt                  1a
000329200925     D  weightConv                    1a
000333200925     D  includeEndDat                 1a
000335200925     D  provRateFlg                   1a
000337200925     D  returnRate                   20p15
000338200925
000339200925      ** Prototype to call ZAGETRTE
000340200925     D  getBaseRate    pr                  extpgm('ZAGETRTE')
000341200925     D  transactCCY                   3a
000342200925     D  baseRateCode                  2a
000343200925     D  histDate                      5  0
000344200925     D  returnRate                   11p 7
000345200925     D  provFlag                      1a
000346201001
000347201001      ** Prototype to call ZINTDY
000348201001     D  getIntrstDays  pr                  extpgm('ZINTDY')
000349201001     D  retcodeIn                     3a
000350201001     D  intrstDays                    5  0
000351201001     D  start                         5  0
000352201001     D  end                           5  0
000353201001     D  calcbasis                     1a
000354201001     D  numIntrstDays                15  9
000355201001
000356201001      ** Prototype to call AOSARDR0
000357201001     D  check_SARD     pr                  extpgm('AOSARDR0')
000358201001     D    returnCode                  7A
000359201001     D    option                      7A
000360201001     D    sard                        6A
000361201001     D    dssdy                     200A
000362200925
000363200903      ** +--------------------------------------+
000364200903      ** ¦ Manually included D-specs            ¦
000365200903      ** ¦ =========================            ¦
000366200903      ** +--------------------------------------+
000367201001
000368200930     D sdlibor       e ds                  extname(SDLIBRFLD)
000369200930     D dssdy         e ds                  extname(DSSDY)
000370201001     D scsard        e ds                  extname(SCSARDPD)
000371200904
000372200903      ** +--------------------------------------+
000373200903      ** ¦ Constants declaration                ¦
000374200903      ** ¦ =====================                ¦
000375200903      ** +--------------------------------------+
000376200925
000377200925     D OPT_ACCRUE      c                   const('*ACRRU*')
000378200925     D OPT_INTRST      c                   const('*INTMT*')
000379200925
000380200903      ** +--------------------------------------+
000381200903      ** ¦ Variable declaration                 ¦
000382200903      ** ¦ ====================                 ¦
000383200903      ** +--------------------------------------+
000384201001
000385200925     D BSRC            s              2a   inz('')
000386200925     D BACK            s              2s 0 inz(0)
000387200925     D wValueDate      s              5  0 inz(0)
000388200930     D wBaseRate       s             11p 7 inz(0)
000389201001     D wrkField1       s             30p 9 inz(0)
000390201001     D wrkField2       s             30p 9 inz(0)
000391201001     D pRetCodeIn      s             10a   inz('')
000392201001     D pIntrstDays     s              5  0 inz(0)
000393201001     D pNoIntrstDays   s             15  9 inz(0)
000394201001     D CIR004          s              1a
000395201001     D pReturnCode     s              7A
000396201001     D pOption         s              7A
000397201001     D pSard           s              6A
000398200925
000399200903      ** +--------------------------------------+
000400200903      ** ¦ Array declaration                    ¦
000401200903      ** ¦ ==================                   ¦
000402200903      ** +--------------------------------------+
000403200903
000404200910      /free
000405200903
000406200903       // ** +--- Start of Main processing -----------------------------------+
000407200903       // ** ¦                                                                ¦
000408200903       // ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
000409200903       // ** ¦ executed at program activation.                                ¦
000410200903       // ** ¦                                                                ¦
000411200903       // ** +----------------------------------------------------------------+
000412200903
000413201001                   select;
000414201001
000416201001                        when option = OPT_ACCRUE;
000417200930
000418201001                             exsr getAccrualRate;
000419200930
000420201001                        when option = OPT_INTRST;
000421200930
000422201001                             exsr getInterestRate;
000423201001
000424201001                   endsl;
000425200925
000426200925                   exsr calculateEffRate;
000427201001
000428201001                   exsr computeInterestAmount;
000429200925
000430200903                   *Inlr = *On;
000431200930
000432200903                   return;
001622200903
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
001907200910
001908201001                   //Check if CIR004 is switched on
001909201001
001910201001                   pOption = '*VERIFY';
001911201001                   pSARD = 'CIR004';
001912201001
001913201001                   callp check_SARD(
001914201001                                      pReturnCode
001915201001                                    : pOption
001916201001                                    : pSard
001917201001                                    : dssdy
001918201001                                   );
001919201001
001920201001                   scsard = dssdy;
001921201001
001922201001                   if pReturnCode = *blanks;
001923201001                      CIR004 = 'Y';
001924201001                   else;
001925201001                      CIR004 = 'N';
001926201001                   endif;
001927201001
001928200925                   sdlibor = liborfields;
001980200907
001981200903       endsr;
001982200903
001983200903       //*************************************************************
001984200903       /EJECT
001985200903       //*************************************************************
001986200903       //                                                            *
001987200903       //   *pssr  - Program Error Processing Subroutine.            *
001988200903       //                                                            *
001989200903       //   Called By: Main Processing                               *
001990200903       //                                                            *
001991200903       //*************************************************************
001992200903
001993200903       begsr *pssr;
001994200924
001995200903                   *inu7 = *on;
001996200903                   *inu8 = *on;
001997200903                   *Inlr = *on;
001998200924
001999200903                   dump;
002000200924
002001200903                   return;
002002200903       endsr;
002031200925
002032200925       //*************************************************************
002033200925       /EJECT
002034200925       //*************************************************************
002035200925       //                                                            *
002036200925       // getAccrualRate - Get Accrual Rate                          *
002037200925       //                                                            *
002038200925       // Called by: Main processing                                 *
002039200925       //                                                            *
002040200925       //  Calls: None                                               *
002041200925       //                                                            *
002042200925       //*************************************************************
002043200925
002044200925       begsr getAccrualRate;
002045200925
002050200925                     select;
002051201001
002052200930                          when avop = '1' or
002053200930                               avop = '2' or
002054200930                               avop = '3';
002055200925
002056200925                               // If there is an accrual base rate defined on the
002057200925                               // settlement base rate then that is the rate used
002058200925                               // for accruals, and if not then the settlement base
002059200925                               // rate on the transaction is used for accruals
002060200925
002061200925                               if BRAC <> *blanks;
002062200925                                    BSRC = BRAC;
002063200925                               else;
002064200925                                    BSRC = BRST;
002065200925                               endif;
002066200925
002067200925                               callp calculateRate(
002068200925                                                     TCCY
002069200925                                                   : BRAC
002070200925                                                   : CALC
002071200925                                                   : STDT
002072200925                                                   : ENDT
002073200925                                                   : LBAC
002074200925                                                   : LODY
002075200925                                                   : AVOP
002076200925                                                   : WGHT
002077200925                                                   : INCE
002078200925                                                   : PRFL
002079200925                                                   : RATE
002080200925                                                  );
002081200925
002082200925                          // This option allows banks to do their own external compounding.
002083200925                          // They would then feed the result of this manual compounding
002084200925                          // into the compounded rate field in the deal to be used for accrual.
002087200930                          when avop = '4';
002088200925                               RATE = CART;
002089201001
002090200925                     endsl;
002091200925
002092200925       endsr;
002093200925
002094200925       //*************************************************************
002095200925       /EJECT
002096200925       //*************************************************************
002097200925       //                                                            *
002098200925       // getInterestRate - Get Interest Rate                        *
002099200925       //                                                            *
002100201007       // Called by: Main Processing                                 *
002101200925       //                                                            *
002102200925       //  Calls: None                                               *
002103200925       //                                                            *
002104200925       //*************************************************************
002105200925
002106200925       begsr getInterestRate;
002107200925
002108200925                    // If dual base rates are defined on the transaction,
002109200925                    // (settlement base rate and base rate for accrual), the
002110200925                    // settlement base rate will be retrieved from the base
002111200925                    // rates table. The system will determine the highest of
002112200925                    // the Lookback Days and Lockout Days defined on the
002113200925                    // transaction. It will then go back that number of business
002114200925                    // days from the event date and retrieve the base rate for
002115200925                    // such value date. The retrieved rate – plus spread –
002116200925                    // will be applied to the whole interest period.
002117200925
002118200925                    select;
002119200925
002120200930                         when AVOP = '1' or
002121200930                              AVOP = '2' or
002122200930                              AVOP = '3';
002123200925
002124200925                              if LBAC = LODY;
002125200925                                   BACK = LBAC;
002126200925                              elseif LBAC > LODY;
002127200925                                   BACK = LBAC;
002128200925                              else;
002129200925                                   BACK = LODY;
002130200925                              endif;
002131200925
002132200925                              zdayno = VALU;
002133200925                              zccy = TCCY;
002134200925                              zloc = *blanks;
002135200925                              znrdys = BACK;
002136200925                              zdynbr = 0;
002137200925                              exsr zbkdt;
002138200925                              wValueDate = zdynbr;
002139200925
002140200925                              callp getBaseRate(
002141200925                                                  TCCY
002142200925                                                : BRST
002143200925                                                : wValueDate
002144200930                                                : wBaseRate
002145200925                                                : PRFL
002146200925                                               );
002147200930                              RATE = wBaseRate;
002148200925
002149200925                         // This option allows banks to do their own external compounding.
002150200925                         // They would then feed the result of this manual compounding
002151200925                         // into the compounded rate field in the deal to be used for accrual.
002152200930                         when AVOP = '4';
002153200925                              RATE = CART;
002154200925                    endsl;
002155200925
002156200925       endsr;
002157200925
002158200925       //*************************************************************
002159200925       //                                                            *
002160200925       // calculateEffRate - Calculate Effective Rate                *
002161200925       //                                                            *
002162200925       // Called by: Main processing                                 *
002163200925       //                                                            *
002164200925       //  Calls: None                                               *
002165200925       //                                                            *
002166200925       //*************************************************************
002167200925
002168200925       begsr calculateEffRate;
002169200925
002170200925                    select;
002171200925
002172200925                         when SPIN = 'A';
002173200930                              EFRT = RATE + SPRD;
002174200925
002175200925                         when SPIN = 'S';
002176200930                              EFRT = RATE - SPRD;
002177200925
002178200925                         when SPIN = 'P';
002179200930                              EFRT = RATE * (SPRD/100);
002181200925
002182200925                    endsl;
002183200925
002184200925       endsr;
002185200925
002186200903      /end-free
002187201001
002188201001       //*************************************************************
002189201001       /EJECT
002190201001       //*************************************************************
002191201001       //                                                            *
002192201001       // computeInterestAmount - Compute Interest Amount            *
002193201001       //                                                            *
002194201001       // Called by: Main processing                                 *
002195201001       //                                                            *
002196201001       //  Calls: None                                               *
002197201001       //                                                            *
002198201001       //*************************************************************
002199201001
002200201001       begsr computeInterestAmount;
002201201001
002202201001                    callp getIntrstDays(
002203201001                                           pRetCodeIn
002204201001                                         : pIntrstDays
002205201001                                         : STDT
002206201001                                         : ENDT
002207201001                                         : CALC
002208201001                                         : pNoIntrstDays
002210201001                                       );
002211201001
002212201001                    wrkField1 = PAMT * EFRT;
002213201001
002214201001                    select;
002215201001
002216201001                          when CALC = '6';
002217201001
002218201001                               wrkField2 = wrkField1 * pNoIntrstDays;
002219201001
002220201001                          other;
002221201001
002222201001                               wrkField2 = wrkField1 * pIntrstDays;
002223201001
002224201001                    endsl;
002225201001
002226201001                    select;
002227201001
002228201001                          when CALC = '2' or
002229201001                               CALC = '3' or
002230201001                               CALC = '5' or
002231201001                               CALC = '7' and
002232201001                               CIR004 = 'Y' or
002233201001                               CALC = ' ';
002234201001
002235201001                               INTA = wrkField2 / 36000;
002236201001
002237201001                          when CALC = '1' or
002238201001                               CALC = '4';
002242201001
002243201001                               INTA = wrkField2 / 36500;
002244201001
002245201001                          when CALC = '6';
002247201001
002248201001                               INTA = wrkField2 / 36600;
002249201001
002250201001                    endsl;
002252201001
002253201001       endsr;
002254200925
002255200925     C/COPY ZSRSRC,ZACCHLE
002256200925     C/COPY ZSRSRC,ZBKDT_ILE
002257200925     C/COPY ZSRSRC,ZFWDT_ILE
002258200910
002259200903
