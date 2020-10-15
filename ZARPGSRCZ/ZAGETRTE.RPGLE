000100200916     H DEBUG
000101200903     H DFTACTGRP(*NO)
000102200903     H COPYRIGHT('(c) Finastra International Limited 2020')
000104200903      *****************************************************************
000105200904/*STD *  RPGBASEBND                                                   *
000106201015/*EXI *  TEXT('Midas SD API - Get Rate from Base Rates File')         *
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
002029201015     D   notInHist     S               n   inz(False)
002030200916
002031200916      /free
002032200916
002033200916
002034200916                    chain (pCCY:pBRC:pHDT) SDBSHSL1;
002035201015
002036201015                    // if an exact match is found in SDBSHSPD retrieve the record
002037200916                    if %found(SDBSHSL1);
002038200916
002039200923                         pRetVal = G0CBSR;
002040200916
002041200916                    else;
002042200916
002043201015                         // Use SETLL to position the record to the next highest matching entry
002044200916                         setll (pCCY:pBRC:pHDT) SDBSHSL1;
002045200916
002046201015                         // if the record found is having the exact match retrieve the record
002047200916                         if %equal(SDBSHSL1);
002048200916
002049200923                              pRetVal = G0CBSR;
002050200916
002051201015                         // if the record found has a value greater than the key specified
002052200916                         elseif %found(SDBSHSL1);
002053200916
002054201015                              //go to the previous record to retrieve the needed information
002055200916                              readp SDBSHSL1;
002056200916
002057201015
002058200916                              if %eof(SDBSHSL1);
002059201015
002060201015                                   // move forward to retrieve the correct information
002061200916                                   read SDBSHSL1;
002062200916
002063200916                                   if %found(SDBSHSL1);
002064200916
002065200923                                        ProvFlag = True;
002066200923                                        pRetVal = G0CBSR;
002067200916
002068200916                                   endif;
002069200916
002070200916                              else;
002071200916
002072201015                                   // ensure that the current record read is having the same ccy
002073201015                                   // and base rate code
002074200916                                   if (pCCY = G0CYCD) and (pBRC = G0BSRC);
002075200916
002076200923                                        ProvFlag = True;
002077200923                                        pRetVal = G0CBSR;
002078201015
002079201015                                   else;
002080201015
002081201015                                        // otherwise, use only the ccy and base rate code to get the
002082201015                                        //  first occurence of the needed information
002083201015                                        chain (pCCY:pBRC) SDBSHSL1;
002084201015                                        if %found(SDBSHSL1);
002085201015                                             ProvFlag = True;
002086201015                                             pRetVal = G0CBSR;
002087201015                                        else;
002088201015
002089201015                                             // if still none is found this means that it does
002090201015                                             // not exist in SDBSHSPD, use the main base rate file
002091201015                                             // instead
002092201015                                             notInHist = True;
002093201015
002094201015                                        endif;
002095201015
002096200916                                   endif;
002097200916
002098200916                              endif;
002099200916
002100200916                         else;
002101200916
002102201015                              // this will be executed when the key values specified in SETLL is
002103201015                              // greater than the last record on the file SDBSHSPD, read the
002104201015                              //  previous record
002105200916                              readp SDBSHSL1;
002106200916
002107201015                              // ensure that the current record read is having the same ccy
002108201015                              // and base rate code
002109201015
002110200916                              if (pCCY = G0CYCD) and (pBRC = G0BSRC);
002111200916
002112201015                                   ProvFlag = True;
002113200923                                   pRetVal = G0CBSR;
002114200916
002115200916                              else;
002116201015
002117201015                                   // if still none is found this means that it does
002118201015                                   // not exist in SDBSHSPD, use the main base rate file
002119201015                                   // instead
002120201015                                   notInHist = True;
002121200916
002122200916                              endif;
002123200916
002124200916                         endif;
002125200916
002126200916                    endif;
002127201015
002128201015                    // if record does not exist in SDBSHSPD, retrieve the information from
002129201015                    // SDBSRTPD
002130201015                    if NotInHist;
002131201015                         pRetVal = GetBaseRate( pCCY
002132201015                                               :pBRC
002133201015                                               :pHDT
002134201015                                              );
002135201015                         ProvFlag = True;
002136201015                    endif;
002137201015
002138201015                    // if the record retrieved from base rates history file is not an
002139201015                    // exact match we will flag those as provisional rates.
002140201015                    // However, the flag returned to the calling program will be set to 'Yes'
002141201015                    // only when the current rundate is less than the history date
002142201015
002143200916                    if  (BJRDNB < pHDT) and ProvFlag;
002144200923                         pProvFlag = 'Y';
002145200916                    endif;
002146200923
002147200923                    return;
002148200916
002149200916      /end-free
002150200916     P   getHistRate   E
002151200916
002152200916      *****************************************************************
002153200916      /EJECT
002154200916      *****************************************************************
002155200916      *                                                               *
002156200916      *  getBaseRate - Get base rates from file SDBSRTPD              *
002157200916      *  ===========   This subroutine will be called when there are  *
002158200916      *                no records defined in SDBSHSPD                 *
002159200916      *                                                               *
002160200916      *  Called By: getHistRate                                       *
002161200916      *                                                               *
002162200916      *  Calls: getSDBSRT                                             *
002163200916      *                                                               *
002164200916      *****************************************************************
002165200916
002166200916     P getBaseRate     B
002167200916     D getBaseRate     PI            11P 7
002168200916     D    pCCY                        3a
002169200916     D    pBRC                        2a
002170200916     D    pHDT                        5  0
002171200916     D   retVal        S             11P 7
002172200916
002173200916      /free
002174200916                    pRtCd = *blanks;
002175200916                    pOptn = '*KEY';
002176200916                    retVal = 0;
002177200916                    callp getSDBSRT(pRtCd:
002178200916                                    pOptn:
002179200916                                    pCCY:
002180200916                                    pBRC:
002181200916                                    dssdy);
002182200916                    if pRtCd = *blanks;
002183200916                        sdbsrt = dssdy;
002184200916                        retVal = BANBRT;
002185200916                    endif;
002186200916                    return retVal;
002187200916      /end-free
002188200916
002189200916     P   getBaseRate   E
002190200910
002191200903
