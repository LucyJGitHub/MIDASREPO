     H DEBUG
     H DFTACTGRP(*NO)
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD API - Get Rate from Base Rates File')         *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data API - Get rates from base rates  *
      *          history file or main file                            *
      *                                                               *
      *  ZAGETRTE - Midas API - Get rates from base rates file        *
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

     FSDBSHSL1  IF   E           K DISK

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
     D/COPY ZACPYSRC,STD_D_SPEC

      ** +--------------------------------------+
      ** ¦ Program Prototypes                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      *  +----------------+
      ** |Parameter lists |
      ** +----------------+

     D Main            pr                  extpgm('ZAGETRTE')

     D  transactCCY                   3a
      ** Transaction Currency (input)
     D  baseRateCode                  2a
      ** Base Rate Code (input)
     D  histDate                      5  0
      ** History Date (Input)
     D  returnRate                   11p 7
      ** Return Rate (output)
     D  provFlag                      1a
      ** Provisional Rate flag

     D Main            pi

     D  transactCCY                   3a
      ** Transaction Currency (input)
     D  baseRateCode                  2a
      ** Base Rate Code (input)
     D  histDate                      5  0
      ** History Date (Input)
     D  returnRate                   11p 7
      ** Retrun Rate (output)
     D  provFlag                      1a
      ** Provisional Rate flag

      ** Prototype to call AOBANKR0
     D  getSDBANK      pr                  extpgm('AOBANKR0')
     D    pReturnCode                 7A
     D    pOption                     7A
     D    dsfdy                     200A

      ** Prototype to call AOBSRTR0
     D  getSDBSRT      pr                  extpgm('AOBSRTR0')
     D    pReturnCode                 7A
     D    pOption                     7A
     D    pCurrency                   3a
     D    pBaseRate                   2a
     D    dsfdy                     200A

      ** Prototype to call getBaseRate function
     D  getBaseRate    pr            11P 7
     D    pCCY                        3a
     D    pBSR                        2a
     D    pHDT                        5  0

      ** Prototype to call getHistRate function
     D  getHistRate    pr
     D    pCurrency                   3a
     D    pBaseRate                   2a
     D    pHistDate                   5  0
     D    preturnRate                11p 7
     D    pProvFlag                   1a

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

     D dssdy         e ds                  extname(DSSDY)
     D dsfdy         e ds                  extname(DSFDY)
     D sdbank        e ds                  extname(SDBANKPD)
     D sdbsrt        e ds                  extname(SDBSRTPD)


      ** +--------------------------------------+
      ** ¦ Constants declaration                ¦
      ** ¦ =====================                ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Variable declaration                 ¦
      ** ¦ ====================                 ¦
      ** +--------------------------------------+


      ** Parameter list for AOBSRTR0, AOBANKR0
     D PRtCd           S              7A
     D POptn           S              7A

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

                   getHistRate(
                                 transactCCY
                                 :baseRateCode
                                 :histDate
                                 :returnRate
                                 :provFlag
                               );

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

                   pOptn   = '*FIRST';
                   pRtcd    = *blanks;

                   callp getSDBANK(
                                  pRtcd
                                : pOptn
                                : dsfdy
                               );

                   sdbank= dsfdy;

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

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getHistRate - Get rates from history file                    *
      *  ===========                                                  *
      *  Called By: Main Processing                                   *
      *                                                               *
      *****************************************************************

     P getHistRate     B
     D getHistRate     PI
     D    pCCY                        3a
     D    pBRC                        2a
     D    pHDT                        5  0
     D    pRetVal                    11p 7
     D    pProvFlag                   1a

     D   ProvFlag      S               n
     D   notInHist     S               n   inz(False)

      /free


                    chain (pCCY:pBRC:pHDT) SDBSHSL1;

                    // if an exact match is found in SDBSHSPD retrieve the record
                    if %found(SDBSHSL1);

                         pRetVal = G0CBSR;

                    else;

                         // Use SETLL to position the record to the next highest matching entry
                         setll (pCCY:pBRC:pHDT) SDBSHSL1;

                         // if the record found is having the exact match retrieve the record
                         if %equal(SDBSHSL1);

                              pRetVal = G0CBSR;

                         // if the record found has a value greater than the key specified
                         elseif %found(SDBSHSL1);

                              //go to the previous record to retrieve the needed information
                              readp SDBSHSL1;


                              if %eof(SDBSHSL1);

                                   // move forward to retrieve the correct information
                                   read SDBSHSL1;

                                   if %found(SDBSHSL1);

                                        ProvFlag = True;
                                        pRetVal = G0CBSR;

                                   endif;

                              else;

                                   // ensure that the current record read is having the same ccy
                                   // and base rate code
                                   if (pCCY = G0CYCD) and (pBRC = G0BSRC);

                                        ProvFlag = True;
                                        pRetVal = G0CBSR;

                                   else;

                                        // otherwise, use only the ccy and base rate code to get the
                                        //  first occurence of the needed information
                                        chain (pCCY:pBRC) SDBSHSL1;
                                        if %found(SDBSHSL1);
                                             ProvFlag = True;
                                             pRetVal = G0CBSR;
                                        else;

                                             // if still none is found this means that it does
                                             // not exist in SDBSHSPD, use the main base rate file
                                             // instead
                                             notInHist = True;

                                        endif;

                                   endif;

                              endif;

                         else;

                              // this will be executed when the key values specified in SETLL is
                              // greater than the last record on the file SDBSHSPD, read the
                              //  previous record
                              readp SDBSHSL1;

                              // ensure that the current record read is having the same ccy
                              // and base rate code

                              if (pCCY = G0CYCD) and (pBRC = G0BSRC);

                                   ProvFlag = True;
                                   pRetVal = G0CBSR;

                              else;

                                   // if still none is found this means that it does
                                   // not exist in SDBSHSPD, use the main base rate file
                                   // instead
                                   notInHist = True;

                              endif;

                         endif;

                    endif;

                    // if record does not exist in SDBSHSPD, retrieve the information from
                    // SDBSRTPD
                    if NotInHist;
                         pRetVal = GetBaseRate( pCCY
                                               :pBRC
                                               :pHDT
                                              );
                         ProvFlag = True;
                    endif;

                    // if the record retrieved from base rates history file is not an
                    // exact match we will flag those as provisional rates.
                    // However, the flag returned to the calling program will be set to 'Yes'
                    // only when the current rundate is less than the history date

                    if  (BJRDNB < pHDT) and ProvFlag;
                         pProvFlag = 'Y';
                    endif;

                    return;

      /end-free
     P   getHistRate   E

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getBaseRate - Get base rates from file SDBSRTPD              *
      *  ===========   This subroutine will be called when there are  *
      *                no records defined in SDBSHSPD                 *
      *                                                               *
      *  Called By: getHistRate                                       *
      *                                                               *
      *  Calls: getSDBSRT                                             *
      *                                                               *
      *****************************************************************

     P getBaseRate     B
     D getBaseRate     PI            11P 7
     D    pCCY                        3a
     D    pBRC                        2a
     D    pHDT                        5  0
     D   retVal        S             11P 7

      /free
                    pRtCd = *blanks;
                    pOptn = '*KEY';
                    retVal = 0;
                    callp getSDBSRT(pRtCd:
                                    pOptn:
                                    pCCY:
                                    pBRC:
                                    dssdy);
                    if pRtCd = *blanks;
                        sdbsrt = dssdy;
                        retVal = BANBRT;
                    endif;
                    return retVal;
      /end-free

     P   getBaseRate   E


