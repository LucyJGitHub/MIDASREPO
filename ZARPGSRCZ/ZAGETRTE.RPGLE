000100200916     H DEBUG
000101200903     H DFTACTGRP(*NO)
000102200903     H COPYRIGHT('(c) Finastra International Limited 2020')
000104200903      *****************************************************************
000105200904/*STD *  RPGBASEBND                                                   *
000106200924/*EXI *  TEXT('Midas SD API - Get rates from base rates file')        *
000107200903      *****************************************************************
000108200903      *                                                               *
000109200924      *  Midas - Midas Standing Data API - Get rates from base rates  *
000110200924      *          history file or main file                            *
000111200903      *                                                               *
000112200924      *  ZAGETRTE - Midas API - Get rates from base rates file        *
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
000141200904     FSDBSHSL1  IF   E           K DISK
000142200904
000143200903      **---------------------------------------------------------------
000144200903      ** The following /COPY line includes all the defined fields in
000145200903      ** the Program Status Data Structures.  They have meaningful
000146200903      ** names, prefixed by 'PS'.
000147200904
000148200903     D/COPY ZACPYSRC,PSDS
000149200903     D/COPY ZACPYSRC,STD_D_SPEC
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
000168200923     D Main            pr                  extpgm('ZAGETRTE')
000169200905
000170200911     D  transactCCY                   3a
000171200905      ** Transaction Currency (input)
000172200911     D  baseRateCode                  2a
000173200905      ** Base Rate Code (input)
000178200923     D  histDate                      5  0
000179200923      ** History Date (Input)
000199200923     D  returnRate                   11p 7
000200200923      ** Return Rate (output)
000201200923     D  provFlag                      1a
000202200923      ** Provisional Rate flag
000203200905
000204200903     D Main            pi
000205200923
000206200923     D  transactCCY                   3a
000207200923      ** Transaction Currency (input)
000208200923     D  baseRateCode                  2a
000209200923      ** Base Rate Code (input)
000210200923     D  histDate                      5  0
000211200923      ** History Date (Input)
000212200923     D  returnRate                   11p 7
000213200923      ** Retrun Rate (output)
000214200923     D  provFlag                      1a
000215200923      ** Provisional Rate flag
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
000292200924     D    dsfdy                     200A
000293200910
000294200916      ** Prototype to call getBaseRate function
000295200916     D  getBaseRate    pr            11P 7
000296200916     D    pCCY                        3a
000297200916     D    pBSR                        2a
000298200916     D    pHDT                        5  0
000299200916
000300200905      ** Prototype to call getHistRate function
000301200923     D  getHistRate    pr
000302200903     D    pCurrency                   3a
000303200911     D    pBaseRate                   2a
000304200916     D    pHistDate                   5  0
000305200923     D    preturnRate                11p 7
000306200923     D    pProvFlag                   1a
000307200903
000308200903      ** +--------------------------------------+
000309200903      ** ¦ Manually included D-specs            ¦
000310200903      ** ¦ =========================            ¦
000311200903      ** +--------------------------------------+
000312200910
000313200915     D dssdy         e ds                  extname(DSSDY)
000314200916     D dsfdy         e ds                  extname(DSFDY)
000315200910     D sdbank        e ds                  extname(SDBANKPD)
000316200916     D sdbsrt        e ds                  extname(SDBSRTPD)
000317200910
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
000352200916
000353200924      ** Parameter list for AOBSRTR0, AOBANKR0
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
000375200923                   getHistRate(
000376200923                                 transactCCY
000377200923                                 :baseRateCode
000378200923                                 :histDate
000379200923                                 :returnRate
000380200923                                 :provFlag
000381200923                               );
000397200903
000398200903                   *Inlr = *On;
000400200903                   return;
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
001908200923                   pOptn   = '*FIRST';
001909200923                   pRtcd    = *blanks;
001910200924
001911200910                   callp getSDBANK(
001912200923                                  pRtcd
001913200923                                : pOptn
001914200916                                : dsfdy
001915200910                               );
001916200924
001917200916                   sdbank= dsfdy;
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
002003200903
002004200903      /end-free
002005200910
002010200916      *****************************************************************
002011200916      /EJECT
002012200916      *****************************************************************
002013200916      *                                                               *
002014200916      *  getHistRate - Get rates from history file                    *
002015200916      *  ===========                                                  *
002016200916      *  Called By: Main Processing                                   *
002017200916      *                                                               *
002018200916      *****************************************************************
002019200916
002020200916     P getHistRate     B
002021200923     D getHistRate     PI
002022200916     D    pCCY                        3a
002023200916     D    pBRC                        2a
002024200916     D    pHDT                        5  0
002025200923     D    pRetVal                    11p 7
002026200923     D    pProvFlag                   1a
002027200923
002028200923     D   ProvFlag      S               n
002029200916
002030200916      /free
002031200916
002032200916
002033200916                    chain (pCCY:pBRC:pHDT) SDBSHSL1;
002034200916
002035200916                    if %found(SDBSHSL1);
002036200916
002037200923                         pRetVal = G0CBSR;
002038200916
002039200916                    else;
002040200916
002041200916                         setll (pCCY:pBRC:pHDT) SDBSHSL1;
002042200916
002043200916                         if %equal(SDBSHSL1);
002044200916
002045200923                              pRetVal = G0CBSR;
002046200916
002047200916                         elseif %found(SDBSHSL1);
002048200916
002049200916                              readp SDBSHSL1;
002050200916
002051200916                              if %eof(SDBSHSL1);
002052200916
002053200916                                   read SDBSHSL1;
002054200916
002055200916                                   if %found(SDBSHSL1);
002056200916
002057200923                                        ProvFlag = True;
002058200923                                        pRetVal = G0CBSR;
002059200916
002060200916                                   endif;
002061200916
002062200916                              else;
002063200916
002064200916                                   if (pCCY = G0CYCD) and (pBRC = G0BSRC);
002065200916
002066200923                                        ProvFlag = True;
002067200923                                        pRetVal = G0CBSR;
002068200916
002069200916                                   endif;
002070200916
002071200916                              endif;
002072200916
002073200916                         else;
002074200916
002075200916                              readp SDBSHSL1;
002076200916
002077200916                              if (pCCY = G0CYCD) and (pBRC = G0BSRC);
002078200916
002079200923                                   ProvFlag = True;
002080200923                                   pRetVal = G0CBSR;
002081200916
002082200916                              else;
002083200916
002084200923                                  pRetVal = GetBaseRate( pCCY
002085200916                                                       :pBRC
002086200916                                                       :pHDT );
002087200923                                  ProvFlag = True;
002088200916
002089200916                              endif;
002090200916
002091200916                         endif;
002092200916
002093200916                    endif;
002094200916
002095200916                    if  (BJRDNB < pHDT) and ProvFlag;
002096200923                         pProvFlag = 'Y';
002097200916                    endif;
002098200923
002099200923                    return;
002100200916
002101200916      /end-free
002102200916     P   getHistRate   E
002103200916
002104200916      *****************************************************************
002105200916      /EJECT
002106200916      *****************************************************************
002107200916      *                                                               *
002108200916      *  getBaseRate - Get base rates from file SDBSRTPD              *
002109200916      *  ===========   This subroutine will be called when there are  *
002110200916      *                no records defined in SDBSHSPD                 *
002111200916      *                                                               *
002112200916      *  Called By: getHistRate                                       *
002113200916      *                                                               *
002114200916      *  Calls: getSDBSRT                                             *
002115200916      *                                                               *
002116200916      *****************************************************************
002117200916
002118200916     P getBaseRate     B
002119200916     D getBaseRate     PI            11P 7
002120200916     D    pCCY                        3a
002121200916     D    pBRC                        2a
002122200916     D    pHDT                        5  0
002123200916     D   retVal        S             11P 7
002124200916
002125200916      /free
002126200916                    pRtCd = *blanks;
002127200916                    pOptn = '*KEY';
002128200916                    retVal = 0;
002129200916                    callp getSDBSRT(pRtCd:
002130200916                                    pOptn:
002131200916                                    pCCY:
002132200916                                    pBRC:
002133200916                                    dssdy);
002134200916                    if pRtCd = *blanks;
002135200916                        sdbsrt = dssdy;
002136200916                        retVal = BANBRT;
002137200916                    endif;
002138200916                    return retVal;
002139200916      /end-free
002140200916
002141200916     P   getBaseRate   E
002142200910
002143200903
