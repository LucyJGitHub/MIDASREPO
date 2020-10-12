     h debug   alwnull(*usrctl)
     h fixnbr(*zoned : *inputpacked)
     h copyright('(c) Finastra International Limited 2005')

      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS General Ledger (Account) Extract')           *
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNACCTXT   - Midas FRS General Ledger (Account) extract      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11372           Date 13Jun06               *
      *                 BUG11435           Date 06Jun06               *
      *                 BUG11350           Date 15May06               *
      *                 CSD027A            Date 09May06               *
      *                 BUG10530           Date 26Apr06               *
      *                 BUG10804           Date 10Mar06               *
      *                 BUG10541           Date 10Mar06               *
      *                 BUG10501           Date 09Feb06               *
      *                 BUG9762            Date 01Feb06               *
      *                 BUG9760            Date 06Jan06               *
      *                 BUG9703            Date 22Dec05               *
      *                 CRN001  *Create    Date 20Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG11372 - Get interest rates for tiered and threshold types.*
      *  BUG11435 - Follow up issue 21. Add more mapping for INDACOBA.*
      *  BUG11350 - ALINDI is not being set for RN_GENELED extract.   *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  BUG10530 - Retrieve interest rate from Retail history rate   *
      *             change files REHRCJ or REHRDJ.                    *
      *  BUG10804 - RN_CUSTACC and RN_GENELED formats have changed    *
      *             for FRS Data Foundation 2.9.3.                    *
      *  BUG10541 - Not output records to RN_PRLAMO, RN_PROFLOS and   *
      *             RN_PROFLOU if zero amount.                        *
      *  BUG10501 - Parameter value '*DBERR' is not correct for       *
      *             access object running in CoB.                     *
      *  BUG9762 - US Product Class not set for customer accounts     *
      *            and general ledger formats not cleared.            *
      *  BUG9760 - General Ledger Reference and related fields        *
      *            (glref, gldetre, glentre) should be blank          *
      *            for non-general ledger accounts.                   *
      *  BUG9703 - Populate posiref from contref for t__proflos       *
      *            and it will also follow for t__prlamo write.       *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     fmrtrapl0  if   e           k disk    infsr(*pssr)

     fgpregbj0  if   e           k disk    infsr(*pssr)

     f****gpacodxl0 if   e       k disk    infsr(*pssr)                                      BUG9760

     ft_rnamad  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnamad:t_rnamadf)
     f                                     prefix(x#)

     fmravbll0  if   e           k disk    infsr(*pssr)

     ft__dfboo  if a e           k disk    infsr(*pssr)
     f                                     rename(t__dfboo: t__dfboof)

      * Midas Retail History - CR and DR Rate Change Records                                BUG10530
     frehrcj    if   e           k disk    infsr(*pssr)                                     BUG10530
     f                                     prefix(rc)                                       BUG10530
     frehrdj    if   e           k disk    infsr(*pssr)                                     BUG10530
     f                                     prefix(rd)                                       BUG10530
                                                                                            BUG10530
     frn_geneledo    e             disk    infsr(*pssr)
     frn_gelamo o    e             disk    infsr(*pssr)
     frn_profloso    e             disk    infsr(*pssr)
     frn_prlamo o    e             disk    infsr(*pssr)
     frn_custacco    e             disk    infsr(*pssr)
     frn_cuaamo o    e             disk    infsr(*pssr)

     frn_genledao    e             disk    infsr(*pssr)  usropn
     frn_cusaccao    e             disk    infsr(*pssr)  usropn

     frn_genleduo    e             disk    infsr(*pssr)  usropn
     frn_proflouo    e             disk    infsr(*pssr)  usropn
     frn_cusaccuo    e             disk    infsr(*pssr)  usropn

     frnaupnpd  o    e             disk    infsr(*pssr)
     frnxcpnpd  o    e             disk    infsr(*pssr)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      /copy zacpysrc,psds
      /copy rncpysrc,rnpssrdfn

     d cpy@            s             80    dim(1) ctdata perrcd(1)
     d dsfdy         e ds
     d dssdy         e ds                  extname(dssdy)
     d sdbank        e ds                  extname(sdbankpd)
     d sdgelr        e ds                  extname(sdgelrpd)
     d sdcurr        e ds                  extname(sdcurrpd)
     d sdcust        e ds                  extname(sdcustpd)
     d accntab       e ds                  extname(accntab)

     d pRaid           s                   like(rbraid)
     d runDatIso       s               d
     d evtDatIso       s               d

      ** Parameters for AOSVALR0 and GPAOSVALR0
     d pValDs          ds
     d  pValK1                       20
     d  pVal1                       200
     d  pValK2                       20
     d  pVal2                       200
     d  pValK3                       20
     d  pVal3                       200
     d  pValK4                       20
     d  pVal4                       200
     d  pValK5                       20
     d  pVal5                       200
     d  pValK6                       20
     d  pVal6                       200
     d  pValK7                       20
     d  pVal7                       200
     d  pValK8                       20
     d  pVal8                       200
     d  pValK9                       20
     d  pVal9                       200
     d  pValK10                      20
     d  pVal10                      200

     d pRtnCod         s              7
     d pOption         s              7
     d pKey1           s             10
     d pKyst           s              7
     d pCcy            s              3
     d pSar            s              6
     d pErrMsg         s             50
     d pFullChk        s              1
     d pZone           s             10
     d pShtc           s              4
     d pRdnb           s              5  0
     d pDnwd           s              5  0
     d pBccy           s              3
     d pNjob           s              1  0
     d pRetl           s             10                                         I:Retail key
     d pCnum           s              6                                         I:Key field 1
     d pCucd           s              3
     d pAccd           s             10
     d pAcsq           s              2
     d pBrca           s              3

     d zFreq           s              1
     d zDayno          s              5  0
     d zMday           s              2  0
     d zCcy            s              3
     d zLoc            s              3
     d zDfin           s              1

     d                 ds
     d excusn
     d expacc
     d exacsq
     d*excusnN**                      6s 0 overlay(excusn)                                   CSD027A
     d excusnN                        6    overlay(excusn)                                   CSD027A
     d expaccN                       10s 0 overlay(expacc)
     d exacsqN                        2s 0 overlay(exacsq)

     d kExsub          s                   like(exsub)
     d                                     inz('ACCT')

     d****CGP010       s               n                                                     BUG9760
     d CRN002          s               n
     d CRN006          s               n
     d splitDrCr       s               n
     d balIsInCr       s               n
     d AcBalExp        s              1
     d extnFound       s               n
     d avblFound       s               n

     d dupKey          c                   01021

     d rtnProduct      s                   like(product)
     d rtnPrdclaUS     s                   like(prdclaus)

     d strPlAcc        S                   like(product)
     d endPlAcc        S                   like(product)
     d strCusAcc       S                   like(product)
     d endCusAcc       S                   like(product)

      ** Parameters for RNPRODMAP
     d pERMS           s             30
     d pAccountCode    s             10
     d pDealType       s              2
     d pDealSubType    s              6
     d pLoanType       s              2
     d pLoanSubType    s              6
     d pFacilityType   s              3
     d pSecuritySNam   s             10
     d pInvestType     s              3
     d pInstitution    s              2
     d pIndustry       s              3
     d pCtryCitizen    s              2
     d pCtryLocation   S              2
     d pBook           S              2
     d pBankNonBank    S              1
     d pAssetLiab      S              1
     d pCollateralTy   S              5
     d pProduct        S             10  0
     d pCntOfClauses   S              5  0

     d @wBals          s             18  0 dim(11) ascend                       work array  BUG11372
     d @wBalsR         s             18  5 dim(11)                              work array  BUG11372
     d @wRates         s             11  7 dim(11)                              work array  BUG11372
                                                                                            BUG11372
      ** Data structure to split alpha RAT2 and RAT3 into numeric rates in array.           BUG11372
      ** and stores the first 11 entries into array.                                        BUG11372
     d wRats           ds                                                                   BUG11372
     d @Rates                  1     66p 7                                      Rates array BUG11372
     d                                     dim(11)                                          BUG11372
     d  wRat1                  1      6p 7                                                  BUG11372
     d  WRat2                  7     12p 7                                                  BUG11372
     d  WRat3                 13     18p 7                                                  BUG11372
     d  WRat4                 19     24p 7                                                  BUG11372
     d  WRat5                 25     30p 7                                                  BUG11372
     d  WRat6                 31     36p 7                                                  BUG11372
     d  wRat7                 37     42p 7                                                  BUG11372
     d  WRat8                 43     48p 7                                                  BUG11372
     d  WRat9                 49     54p 7                                                  BUG11372
     d  WRat10                55     60p 7                                                  BUG11372
     d  WRat11                61     66p 7                                                  BUG11372
     d  WRat12                67     72p 7                                                  BUG11372
                                                                                            BUG11372
      ** Data structure to split alpha BAL2 and BAL3 into numeric balances                  BUG11372
      ** and stores the first 11 entries into array.                                        BUG11372
     d wBals           ds                                                                   BUG11372
     d @Bals                   1     88p 0                                      Balances arrBUG11372
     d                                     dim(11)                                          BUG11372
     d  WBal1                  1      8p 0                                                  BUG11372
     d  WBal2                  9     16p 0                                                  BUG11372
     d  WBal3                 17     24p 0                                                  BUG11372
     d  WBal4                 25     32p 0                                                  BUG11372
     d  WBal5                 33     40p 0                                                  BUG11372
     d  WBal6                 41     48p 0                                                  BUG11372
     d  WBal7                 49     56p 0                                                  BUG11372
     d  WBal8                 57     64p 0                                                  BUG11372
     d  WBal9                 65     72p 0                                                  BUG11372
     d  WBal10                73     80p 0                                                  BUG11372
     d  WBal11                81     88p 0                                                  BUG11372
     d  WBal12                89     96p 0                                                  BUG11372
                                                                                            BUG11372
     d winth           s                   like(rdinth)                         wk init. thrBUG11372
     d wacbal          s                   like(expamt)                         wk ac bal   BUG11372
     d wacBalNoDp      s             18  0                                      wk ac bal noBUG11372
     d y               s              2  0                                      array index BUG11372
     d z               s              2  0                                      array index BUG11372
     d LoopEnd         s              1                                                     BUG11372
     d wAmtR           s                   like(wacBalNoDp)                                 BUG11372
     d wAmt            s                   like(wacBalNoDp)                                 BUG11372
     d winSType        s                   like(rdinst)                                     BUG11372
     d wBalGap         s                   like(wbal1)                          diff % bals BUG11372
                                                                                            BUG11732
      /copy rncpysrc,rnrgaudfn

      /copy rncpysrc,rndaycnv
      /copy rncpysrc,rnamtcnv

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+

     c*****kGpacodx      klist                                                               BUG9760
     c**********         kfld                    pZone                                       BUG9760
     c**********         kfld                    expacc                                      BUG9760

     c     kAccount      klist
     c                   kfld                    exbrch
     c                   kfld                    excusnN
     c                   kfld                    excycd
     c                   kfld                    expaccN
     c                   kfld                    exacsqN

     c     *entry        plist
     c                   parm                    pRaid

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

     c                   exsr      main

     c                   exsr      bootstrap

     c                   exsr      closedown

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN   -  Main subroutine                                    *
      *                                                               *
      *****************************************************************

     c     main          begsr

     c     kExsub        setll     mrtrapl0
     c     kExsub        reade     mrtrapl0
     c                   dow       not %eof

      ** Check if record is to be extracted.
     c                   eval      rgIx = %lookup(exbrch:aBrcd:1:rgEl)
     c                   if        (   rgIx        >  0
     c                             and aNxDt(rgIx) <= evtDatIso )

      ** Get Product Code.
     c                   exsr      getProdCode
     c                   select
     c                   when      rtnProduct  > 0
     c                   exsr      mapData

     c                   when      rtnProduct  < 0
     c                   exsr      wrtExcptn
     c                   endsl

     c                   endif

     c     kExsub        reade     mrtrapl0
     c                   enddo

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  mapData   - Subroutine that maps data to be written to files *
      *                                                               *
      *****************************************************************
     c     mapData       begsr

      ** Get customer details.
     c                   eval      pKey1       = excusn
     c                   exsr      getCust

      ** Get account and account extension details.
     c                   exsr      getAccnt

      ** Get average balance.
     c                   exsr      getAverageBal

     c                   select

      ** Profit & Loss accounts
     c                   when          rtnProduct >= strPlAcc
     c                             and rtnProduct <= endPlAcc
                                                                                            BUG10541
      ** only output if amount is not zero                                                  BUG10541
     c                   if            (   AcBalExp = 'C'                                   BUG10541
     c                                 and exrtcb  <> 0   )                                 BUG10541
     c                             or  (   AcBalExp = 'L'                                   BUG10541
     c                                 and expamt  <> 0   )                                 BUG10541
     c                   clear                   t__proflos
     c                   clear                   t__proflou
     c                   clear                   t__prlamo
     c                   exsr      commonFlds
     c                   exsr      proflosRec

     c                   if        CRN006
     c                   exsr      proflouRec
     c                   endif

     c                   exsr      prlamoRec
     c                   endif                                                              BUG10541

      ** Customer accounts
     c                   when          rtnProduct >= strCusAcc
     c                             and rtnProduct <= endCusAcc

     c                   if            exaamt     <> 0
     c                             and exoaam     <> 0
     c                   eval      splitDrCr       = *on
     c                   else
     c                   eval      splitDrCr       = *off
     c                   exsr      isBalInCr
     c                   endif

     c                   clear                   t__custacc
     c                   clear                   t__cusacca
     c                   clear                   t__cusaccu
     c                   clear                   t__cuaamo
     c                   exsr      commonFlds
     c                   exsr      custaccRec

      ** General Ledger accounts
     c                   other
     c                   clear                   t__geneled
     c                   clear                   t__genleda                                  BUG9762
     c                   clear                   t__genledu                                  BUG9762
     c                   clear                   t__gelamo
     c                   exsr      commonFlds
     c                   exsr      geneledRec

     c                   if        CRN002
     c                   exsr      genledaRec
     c                   endif

     c                   if        CRN006
     c                   exsr      genleduRec
     c                   endif

     c                   exsr      gelamoRec

     c                   endsl

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  commonFlds - Subroutine that assign field values common to   *
      *               all files.                                      *
      *                                                               *
      *****************************************************************
     c     commonFlds    begsr

     c                   eval      product     = rtnProduct
     c                   eval      statusl2    = 5
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on

     c                   eval      counref     = bbbrcd
     c                                         + '-'
     c                                         + excusn

      ** Set up limit ref only if account is linked to a facility.
     c                   if        exfcus     <> *blanks
     c                   eval      pKey1       = exfcus
     c                   exsr      getCust

     c                   eval      limiref     = bbbrcd
     c                                         + '-'
     c                                         + exfcus
     c                                         + exftyp
     c                                         + exfcno
     c                   endif

     c                   eval      sourref     = pZone

      ***Use*Global*A/c*code*if*feature*is*on.**********                                     BUG9760
     c**********         if        CGP010                                                    BUG9760
     c*****kGpacodx      chain     gpacodxl0                                                 BUG9760
     c**********         if        %found                                                    BUG9760
     c**********         eval      glentre     = acgacd                                      BUG9760
     c**********         else                                                                BUG9760
     c**********         eval      wDbfile     = 'GPACODXPD'                                 BUG9760
     c**********         eval      wDbase      = 1                                           BUG9760
     c**********         eval      wDbkey      = expacc                                      BUG9760
     c**********         exsr      *pssr                                                     BUG9760
     c**********         endif                                                               BUG9760
      **********                                                                             BUG9760
     c**********         else                                                                BUG9760
     c**********         eval      glentre     = pZone                                       BUG9760
     c**********                               + expacc                                      BUG9760
     c**********         endif                                                               BUG9760

     c**********         eval      glref       = exbrch                                      BUG9760
     c                   eval      contref     = exbrch                                      BUG9760
     c                                         + excusn
     c                                         + excycd
     c                                         + expacc
     c                                         + exacsq

     c**********         eval      gldetre     = glref                                       BUG9760
     c**********         eval      glentre     = glref                                       BUG9760

     c**********         eval      contref     = glref                                       BUG9760

      ** Get internal customer details.
     c                   eval      pKey1       = exbicn
     c                   exsr      getCust

     c                   eval      intparre    = bbbrcd
     c                                         + '-'
     c                                         + exbicn

     c                   eval      deal        = rnDayCnv(daco)
     c                   eval      maturity    = rnDayCnv(extdat)

     c                   if           expacs   = 'AS'
     c                             or expacs   = 'EX'
     c                             or expacs   = 'CO'
     c                             or expacs   = 'ME'
     c                             or expacs   = 'TR'
     c                             or expacs   = 'CN'
     c                   eval      plindi      = 1
     c                   else
     c                   eval      plindi      = 2
     c                   endif

      ** Get account currency details.
     c                   eval      pCcy        = excycd
     c                   exsr      getCcy

     c                   eval      isocurr     = excycd
     c                   eval      value       = rnDayCnv(extdat)

      ** Set fields derived from the extension record.
     c                   if        extnFound
     c                   move      x#loclfund    locafund
     c                   eval      purpose     = x#purposet
     c                   eval      plclas      = x#productc
     c                   eval      portfoli    = x#portfolo
     c                   eval      eligible    = x#eligible
     c                   eval      parofse     = x#partsett
     c                   eval      liquifya    = x#liquifab
     c                   eval      fdicins     = x#fdicinsr
     c                   eval      accrual     = x#accrind
     c                   eval      plclaus     = x#prodclus
     c                   endif
     c                   eval      intangib    = 0                                          BUG10804
     c                   eval      leasing     = 0                                          BUG10804
     c                   eval      recogniz    = 0                                          BUG10804
     c                   eval      tangible    = 0                                          BUG10804

      ** Get US Product Code.
     c                   if        CRN006
     c                   exsr      getProdCodeUS
     c                   endif

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  isBalInCr - Is balance in credit?                            *
      *                                                               *
      *****************************************************************
     c     isBalInCr     begsr

     c                   if            (   AcBalExp = 'C'
     c                                 and exrtcb   < 0   )
     c                             or  (   AcBalExp = 'L'
     c                                 and expdci   = 1   )
     c                   eval      balIsInCr   = *on
     c                   else
     c                   eval      balIsInCr   = *off
     c                   endif

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  proflosRec - Subroutine that writes records to rn_proflos    *
      *                                                               *
      *****************************************************************
     c     proflosRec    begsr

     c                   eval      posiref     = contref                                     BUG9703
     c                   eval      PosiType    = 9

      ** Since value of the plindi field set in sr. commonFlds is not correct for
      ** this profit and loss record, need to set to value as follow:
     c                   select
     c                   when      expacs      = 'IN'
     c                   eval      plindi      = 1
     c                   when      expacs      = 'EX'
     c                   eval      plindi      = 2
     c                   other
     c                   eval      plindi      = 3
     c                   endsl

     c                   write     t__proflos

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  proflouRec - Subroutine that writes records to rn_proflou    *
      *                                                               *
      *****************************************************************
     c     proflouRec    begsr

     c                   write     t__proflou

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  prlamoRec - Subroutine that writes records to rn_prlamo      *
      *                                                               *
      *****************************************************************
     c     prlamoRec     begsr

      ** Original CCY amount
     c                   if        AcBalExp    = 'C'
      ** use cleared balance
     c                   if        exrtcb      < 0
     c                   eval      dcindi      = 2
     c                   else
     c                   eval      dcindi      = 1
     c                   endif
     c                   eval      ocaamunt    = %abs(exrtcb)

     c                   else
      ** use principal amount
     c                   eval      ocaamunt    = expamt
     c                   if        expali      = 'A'
     c                   eval      dcindi      = 2
     c                   else
     c                   eval      dcindi      = 1
     c                   endif
     c                   endif

     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )

      ** Amount type
     c                   eval      typamunt    = 1

     c                   write     t__prlamo

     c                   exsr      wrtAudit

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine that writes records to rn_custacc.                *
      *  Will either write 2 records (debit and credit),              *
      *  or 1 record (where only one of dr/cr applies).               *
      *                                                               *
      *****************************************************************
     c     custaccRec    begsr

     c                   eval      opening     = rnDayCnv(daco)
     c                   eval      nexintfi    = rnDayCnv(extdat)
     c                   eval      nextroll    = rnDayCnv(extdat)
     c                   eval      closing     = rnDayCnv(dacc)
     c                   eval      lastroll    = rnDayCnv(extdat)
     c                   eval      typintra    = 3
     c                   eval      posiref     = contref

      ** Using Debit values.
     c                   if        splitDrCr
     c                             or not balIsInCr

     c                   eval      nextsett    = rnDayCnv(ndid)
     c                   eval      alindi      = 1                                          BUG11372
                                                                                            BUG10530
      ** Get debit interest rate from retail history debit interest rate file rehrdj.       BUG10530
     c*******************eval      perintra    = cdir                                       BUG10530
     c     kAccount      setgt     rehrdj                                                   BUG10530
     c     kAccount      readpe    rehrdj                                                   BUG10530
     c                   if        not %eof                                                 BUG10530
                                                                                            BUG11372
      ** Set the interest rate according to the interest type.                              BUG11372
     c                   select                                                             BUG11372
                                                                                            BUG11372
      ** when single rate...                                                                BUG11372
     c                   when      rdintp      = 0                                          BUG11372
     c                   eval      perintra    = rdinrt                                     BUG10530
                                                                                            BUG11372
      ** when tiered rate type...                                                           BUG11372
     c                   when      rdintp      = 1                                          BUG11372
     c                   exsr      GetTieredRate                                            BUG11372
                                                                                            BUG11372
      ** when threshold rate type...                                                        BUG11372
     c                   when      rdintp      = 2                                          BUG11372
     c                   exsr      GetThresholdR                                            BUG11372
                                                                                            BUG11372
     c                   other                                                              BUG11372
     c                   eval      perintra    = 0                                          BUG11372
     c                   endsl                                                              BUG11372
                                                                                            BUG11372
      ** else no record.                                                                    BUG11372
     c                   else                                                               BUG10530
     c                   eval      perintra    = 0                                          BUG10530
     c                   endif                                                              BUG10530
                                                                                            BUG10530
     c*******************eval      alindi      = 1                                          BUG11372

     c                   select
     c                   when      dric        = 1
     c                   eval      indacoba    = 15
     c                   when      dric        = 2
     c                   eval      indacoba    = 2
     c                   when      dric        = 3
     c                   eval      indacoba    = 5
     c                   when      dric        = 4                                          BUG11435
     c                   eval      indacoba    = 16                                         BUG11435
     c                   when      dric        = 5                                          BUG11435
     c                   eval      indacoba    = 17                                         BUG11435
     c                   when      dric        = 6                                          BUG11435
     c                   eval      indacoba    = 18                                         BUG11435
     c                   when      dric        = 7                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
     c                   when      dric        = 8                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
     c                   other
     c                   eval      indacoba    = 0
     c                   endsl

     c                   if        splitDrCr
     c                   eval      posiref     = %trimr(contref)
     c                                         + 'D'
     c                   endif

     c                   write     t__custacc
     c                   exsr      cusaccaRec
     c                   exsr      cusaccuRec
     c                   exsr      cuaamoRec

     c                   endif

      ** Using Credit values.
     c                   if        splitDrCr
     c                             or balIsInCr

     c                   eval      nextsett    = rnDayCnv(ncid)
     c                   eval      alindi      = 2                                          BUG11372
                                                                                            BUG10530
      ** Get credit interest rate from retail history credit interest rate file rehrcj.     BUG10530
     c*******************eval      perintra    = ccir                                       BUG10530
     c     kAccount      setgt     rehrcj                                                   BUG10530
     c     kAccount      readpe    rehrcj                                                   BUG10530
     c                   if        not %eof                                                 BUG10530
                                                                                            BUG11372
      ** Set the interest rate according to the interest type.                              BUG11372
     c                   select                                                             BUG11372
                                                                                            BUG11372
      ** when single rate...                                                                BUG11372
     c                   when      rcintp      = 0                                          BUG11372
     c                   eval      perintra    = rcinrt                                     BUG10530
      ** when tiered rate type...                                                           BUG11372
     c                   when      rcintp      = 1                                          BUG11372
     c                   exsr      GetTieredRate                                            BUG11372
                                                                                            BUG11372
      ** when threshold rate type...                                                        BUG11372
     c                   when      rcintp      = 2                                          BUG11372
     c                   exsr      GetThresholdR                                            BUG11372
                                                                                            BUG11372
     c                   other                                                              BUG11372
     c                   eval      perintra    = 0                                          BUG11372
     c                   endsl                                                              BUG11372
                                                                                            BUG11372
      ** else no record.                                                                    BUG11372
     c                   else                                                               BUG10530
     c                   eval      perintra    = 0                                          BUG10530
     c                   endif                                                              BUG10530
                                                                                            BUG10530
     c*******************eval      alindi      = 2                                          BUG11372

     c                   select
     c                   when      cric        = 1
     c                   eval      indacoba    = 15
     c                   when      cric        = 2
     c                   eval      indacoba    = 2
     c                   when      cric        = 3
     c                   eval      indacoba    = 5
     c                   when      cric        = 4                                          BUG11435
     c                   eval      indacoba    = 16                                         BUG11435
     c                   when      cric        = 5                                          BUG11435
     c                   eval      indacoba    = 17                                         BUG11435
     c                   when      cric        = 6                                          BUG11435
     c                   eval      indacoba    = 18                                         BUG11435
     c                   when      cric        = 7                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
     c                   when      cric        = 8                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
     c                   other
     c                   eval      indacoba    = 0
     c                   endsl

     c                   if        splitDrCr
     c                   eval      posiref     = %trimr(contref)
     c                                         + 'C'
     c                   endif

     c                   write     t__custacc
     c                   exsr      cusaccaRec
     c                   exsr      cusaccuRec
     c                   exsr      cuaamoRec

     c                   endif

     c                   endsr

      *****************************************************************
      /EJECT                                                                                BUG11372
      *****************************************************************                     BUG11372
      *                                                               *                     BUG11372
      *  Subroutine that caculates interest rate for tiered interest  *                     BUG11372
      *  type.                                                        *                     BUG11372
      *                                                               *                     BUG11372
      *****************************************************************                     BUG11372
     c     GetTieredRate begsr                                                              BUG11372
                                                                                            BUG11372
      ** get work initial threshold balance and account balance (18,0)                      BUG11372
     c                   exsr      wrkInthAccBal                                            BUG11372
                                                                                            BUG11372
      ** Interest is only calculated on an amount that exceeds the initial                  BUG11372
      ** threshold ballance.                                                                BUG11372
     c                   if        wacBalNoDp  <= winth                                     BUG11372
     c                   eval      perintra    = 0                                          BUG11372
     c                   leavesr                                                            BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
      ** Split alhpa Rat2, Rat3, Bal2 and Bal3 into numeric entries of @Rates               BUG11372
      ** and @Bals.                                                                         BUG11372
     c                   exsr      BalRateArrays                                            BUG11372
                                                                                            BUG11372
      ** Initialise work variables                                                          BUG11372
     c                   eval      z           = 1                                          BUG11372
     c                   eval      y           = 0                                          BUG11372
     c                   eval      LoopEnd     = 'N'                                        BUG11372
     c                   eval      @wBals      = 0                                          BUG11372
     c                   eval      @wBalsR     = 0                                          BUG11372
     c                   eval      wAmtR       = 0                                          BUG11372
     c                   eval      wAmt        = wacBalNoDp                                 BUG11372
                                                                                            BUG11372
      ** interest sub-type                                                                  BUG11372
     c                   if        alindi      = 1                                          BUG11372
     c                   eval      winSType = rdinst                                        BUG11372
     c                   else                                                               BUG11372
     c                   eval      winSType = rcinst                                        BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
      ** Set up @wbals for caculation                                                       BUG11372
     c                   dow       LoopEnd   = 'N'                                          BUG11372
     c                   eval      wAmtR     = wAmt                                         BUG11372
                                                                                            BUG11372
     c                   if        z         = 11                                           BUG11372
     c                   eval      @wbals(z) = wAmtR                                        BUG11372
     c                   eval      LoopEnd   = 'Y'                                          BUG11372
                                                                                            BUG11372
     c                   else                                                               BUG11372
     c                   eval      z         = z + 1                                        BUG11372
     c                   eval      y         = y + 1                                        BUG11372
                                                                                            BUG11372
     c                   if        @bals(z)  = 0                                            BUG11372
     c                   eval      @wBals(y) = wAmtR    + @wBals(y)                         BUG11372
     c                   eval      LoopEnd   = 'Y'                                          BUG11372
                                                                                            BUG11372
     c                   else                                                               BUG11372
     c                   eval      wBalGap   = @bals(z) - @bals(y)                          BUG11372
     c                   eval      wAmt      = wAmtR    - wBalGap                           BUG11372
                                                                                            BUG11372
     c                   if        wAmt      <= 0                                           BUG11372
     c                   eval      @wbals(y) = wAmtR    + @wBals(y)                         BUG11372
     c                   eval      LoopEnd   = 'Y'                                          BUG11372
     c                   else                                                               BUG11372
     c                   eval      @wbals(y) = wBalGap  + @wBals(y)                         BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
     c                   enddo                                                              BUG11372
                                                                                            BUG11372
      ** If the sub-type is from 50000 to 99999, calculate the interest                     BUG11372
      ** on the amount exceeding the initial threshold. Otherwise, the                      BUG11372
      ** intesrest is calculated on the whole balance whenever it exceeds                   BUG11372
      ** the initial threshold.                                                             BUG11372
                                                                                            BUG11372
     c                   if        winSType  >= 50000                                       BUG11372
                                                                                            BUG11372
     c                   eval      z         = 1                                            BUG11372
                                                                                            BUG11372
     c                   dow       (z        < 12) and                                      BUG11372
     c                             (winth    > 0)                                           BUG11372
     c                   eval      @wbals(z) = @wbals(z) - winth                            BUG11372
     c                   if        @wbals(z) < 0                                            BUG11372
     c                   eval      winth     = 0 - @wbals(z)                                BUG11372
     c                   eval      @wbals(z) = 0                                            BUG11372
     c                   else                                                               BUG11372
     c                   eval      winth     = 0                                            BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
     c                   eval      z         = z + 1                                        BUG11372
     c                   enddo                                                              BUG11372
                                                                                            BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
      ** Multiple @wBals entries with @Rates entries to give @wBalsR                        BUG11372
     c     @wBals        mult(h)   @wRates       @wBalsR                                    BUG11372
     c                   xfoot(h)  @wBalsR       allBalRate       18 5                      BUG11372
                                                                                            BUG11372
      ** average interest rate                                                              BUG11372
     c                   eval(h)   perintra  = allBalRate / wacBalNoDp                      BUG11372
                                                                                            BUG11372
     c     GetTieredRateEendsr                                                              BUG11372
                                                                                            BUG11372
      /EJECT                                                                                BUG11372
      *****************************************************************                     BUG11372
      *                                                               *                     BUG11372
      *  Subroutine that caculates interest rate for threshold        *                     BUG11372
      *  interest rate.                                               *                     BUG11372
      *                                                               *                     BUG11372
      *****************************************************************                     BUG11372
     c     GetThresholdR begsr                                                              BUG11372
                                                                                            BUG11372
      ** get work initial threshold balance and account balance (18,0)                      BUG11372
     c                   exsr      wrkInthAccBal                                            BUG11372
                                                                                            BUG11372
      ** Interest is only calculated on an amount that exceeds the initial                  BUG11372
      ** threshold balance.                                                                 BUG11372
     c                   if        wacBalNoDp  <= winth                                     BUG11372
     c                   eval      perintra    = 0                                          BUG11372
     c                   leavesr                                                            BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
      ** Split alhpa Rat2, Rat3, Bal2 and Bal3 into numeric entries of @Rates               BUG11372
      ** and @Bals.                                                                         BUG11372
     c                   exsr      BalRateArrays                                            BUG11372
                                                                                            BUG11372
      ** interest sub-type                                                                  BUG11372
     c                   if        alindi      = 1                                          BUG11372
     c                   eval      winSType = rdinst                                        BUG11372
     c                   else                                                               BUG11372
     c                   eval      winSType = rcinst                                        BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
      ** Fill the end of the table with HIGHVAL.                                            BUG11372
     c                   eval      z           = 2                                          BUG11372
     c                   dow       z <= 11                                                  BUG11372
                                                                                            BUG11372
     c                   if        @bals(z)    = 0                                          BUG11372
     c                   eval      @bals(z)    = *HIVAL                                     BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
     c                   eval      z           = z + 1                                      BUG11372
     c                   enddo                                                              BUG11372
                                                                                            BUG11372
     c                   z-add     @bals         @wbals                                     BUG11372
                                                                                            BUG11372
      ** Get the balance entry in @wbals which is just less than wacBalNoDp.                BUG11372
     c                   eval      z           = 1                                          BUG11372
     c     wacBalNoDp    lookup    @wbals(z)                            40                  BUG11372
                                                                                            BUG11372
      ** If the sub-type is from 50000 to 99999, calculate the interest                     BUG11372
      ** on the amount exceeding the initial threshold. Otherwise, the                      BUG11372
      ** intesrest is calculated on the whole balance whenever it exceeds                   BUG11372
      ** the initial threshold.                                                             BUG11372
                                                                                            BUG11372
     c                   if        winSType  >= 50000                                       BUG11372
     c                   eval(h)   allBalRate = (wacBalNoDp - winth)                        BUG11372
     c                                          * @wrates(z)                                BUG11372
      ** get average interest rate                                                          BUG11372
     c                   eval(h)   perintra  = allBalRate / wacBalNoDp                      BUG11372
      **                                                                                    BUG11372
     c                   else                                                               BUG11372
     c                   eval      perintra    = @wrates(z)                                 BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
     c     GetThresholdE endsr                                                              BUG11372
                                                                                            BUG11372
      /EJECT                                                                                BUG11372
      *****************************************************************                     BUG11372
      *                                                               *                     BUG11372
      *  Subroutine that gets work initial threshold balance (winth), *                     BUG11372
      *  work account balance without decimal places (wacBalNoDp)     *                     BUG11372
      *                                                               *                     BUG11372
      *****************************************************************                     BUG11372
     c     wrkInthAccBal begsr                                                              BUG11372
                                                                                            BUG11372
      ** Use debit values                                                                   BUG11372
     c                   if        alindi      = 1                                          BUG11372
                                                                                            BUG11372
      ** initial threshold balance                                                          BUG11372
     c                   eval      winth       = rdinth                                     BUG11372
                                                                                            BUG11372
      ** account balance                                                                    BUG11372
     c                   select                                                             BUG11372
     c                   when      not splitDrCr                                            BUG11372
     c                   if        AcBalExp    = 'C'                                        BUG11372
     c                   eval      wacbal      = %abs(exrtcb)                               BUG11372
     c                   else                                                               BUG11372
     c                   eval      wacbal      = expamt                                     BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
     c                   when      AcBalExp    = 'C'                                        BUG11372
     c                   if        exrtcb      > 0                                          BUG11372
     c                   eval      wacbal      = exrtcb                                     BUG11372
     c                   else                                                               BUG11372
     c                   eval      wacbal      = 0                                          BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
     c                   other                                                              BUG11372
     c                   if        expdci      = 0                                          BUG11372
     c                   eval      wacbal      = expamt                                     BUG11372
     c                   else                                                               BUG11372
     c                   eval      wacbal      = 0                                          BUG11372
     c                   endif                                                              BUG11372
     c                   endsl                                                              BUG11372
                                                                                            BUG11372
     c                   else                                                               BUG11372
      ** Using Credit values.                                                               BUG11372
                                                                                            BUG11372
      ** initial threshold balance                                                          BUG11372
     c                   eval      winth       = rcinth                                     BUG11372
                                                                                            BUG11372
     c                   select                                                             BUG11372
     c                   when      not splitDrCr                                            BUG11372
     c                   if        AcBalExp    = 'C'                                        BUG11372
     c                   eval      wacbal      = %abs(exrtcb)                               BUG11372
     c                   else                                                               BUG11372
     c                   eval      wacbal      = expamt                                     BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
     c                   when      AcBalExp    = 'C'                                        BUG11372
     c                   if        exrtcb      < 0                                          BUG11372
     c                   eval      wacbal      = %abs(exrtcb)                               BUG11372
     c                   else                                                               BUG11372
     c                   eval      wacbal      = 0                                          BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
     c                   other                                                              BUG11372
     c                   if        expdci      = 1                                          BUG11372
     c                   eval      wacbal      = expamt                                     BUG11372
     c                   else                                                               BUG11372
     c                   eval      wacbal      = 0                                          BUG11372
     c                   endif                                                              BUG11372
     c                   endsl                                                              BUG11372
                                                                                            BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
      ** Convert account balance to without decimal places to match                         BUG11372
      ** the initial threshold balance.                                                     BUG11372
     c                   eval(H)   wacBalNoDp  = wacbal * (10**a6nbdp)                      BUG11372
                                                                                            BUG11372
     c     wrkInthAccBaE endsr                                                              BUG11372
                                                                                            BUG11372
      *****************************************************************                     BUG11372
      /EJECT                                                                                BUG11372
      *****************************************************************                     BUG11372
      *                                                               *                     BUG11372
      *  Subroutine that splits aplha Rat2, Rat3, Bal2 and Bal3       *                     BUG11372
      *  into numberic entries of array @Rates and @Bals.             *                     BUG11372
      *                                                               *                     BUG11372
      *****************************************************************                     BUG11372
     c     BalRateArrays begsr                                                              BUG11372
                                                                                            BUG11372
     c                   clear                   wRats                                      BUG11372
     c                   clear                   wBals                                      BUG11372
                                                                                            BUG11372
      ** Use debit values                                                                   BUG11372
     c                   if        alindi      = 1                                          BUG11372
                                                                                            BUG11372
     c                   if        rdrat2      <> *blank                                    BUG11372
     c                   movel     rdrat2        wrats                                      BUG11372
     c                   end                                                                BUG11372
     c                   if        rdrat3      <> *blank                                    BUG11372
     c                   move      rdrat3        wrats                                      BUG11372
     c                   end                                                                BUG11372
                                                                                            BUG11372
     c                   if        rdbal2      <> *blank                                    BUG11372
     c                   movel     rdbal2        wbals                                      BUG11372
     c                   end                                                                BUG11372
     c                   if        rdbal3      <> *blank                                    BUG11372
     c                   move      rdbal3        wbals                                      BUG11372
     c                   end                                                                BUG11372
                                                                                            BUG11372
     c                   else                                                               BUG11372
      ** Using Credit values.                                                               BUG11372
                                                                                            BUG11372
     c                   if        rcrat2      <> *blank                                    BUG11372
     c                   movel     rcrat2        wrats                                      BUG11372
     c                   end                                                                BUG11372
     c                   if        rcrat3      <> *blank                                    BUG11372
     c                   move      rcrat3        wrats                                      BUG11372
     c                   end                                                                BUG11372
                                                                                            BUG11372
     c                   if        rcbal2      <> *blank                                    BUG11372
     c                   movel     rcbal2        wbals                                      BUG11372
     c                   end                                                                BUG11372
     c                   if        rcbal3      <> *blank                                    BUG11372
     c                   move      rcbal3        wbals                                      BUG11372
     c                   end                                                                BUG11372
                                                                                            BUG11372
     c                   endif                                                              BUG11372
                                                                                            BUG11372
     c                   z-add     @rates        @wrates                                    BUG11372
                                                                                            BUG11372
     c     BalRateArrayE endsr                                                              BUG11372
                                                                                            BUG11372
      *****************************************************************                     BUG11372
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine that writes records to rn_cusacca.                *
      *  Records written correspond to those written in custaccRec,   *
      *  therefore called from custaccRec.                            *
      *                                                               *
      *****************************************************************
     c     cusaccaRec    begsr

     c                   if        CRN002
     c                   write     t__cusacca
     c                   endif

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine that writes records to rn_cusaccu.                *
      *  Records written correspond to those written in custaccRec,   *
      *  therefore called from custaccRec.                            *
      *                                                               *
      *****************************************************************
     c     cusaccuRec    begsr

     c                   if        CRN006
     c                   eval      prdclaus    = rtnPrdclaUS                                 BUG9762
     c                   write     t__cusaccu
     c                   endif

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine that writes records to rn_cuaamo.                 *
      *  Records written correspond to those written in custaccRec,   *
      *  therefore called from custaccRec.                            *
      *                                                               *
      *  3 records are written each time this routine is called:      *
      *  account balance, accrued interest,                           *
      *  quarterly average balance (if available).                    *
      *                                                               *
      *****************************************************************
     c     cuaamoRec     begsr

      ** Using Debit values.
     c                   if        alindi      = 1

      ** Account balance.
     c                   eval      dcindi      = 1

     c                   select
     c                   when      not splitDrCr
     c                   if        AcBalExp    = 'C'
     c                   eval      ocaamunt    = %abs(exrtcb)
     c                   else
     c                   eval      ocaamunt    = expamt
     c                   endif

     c                   when      AcBalExp    = 'C'
     c                   if        exrtcb      > 0
     c                   eval      ocaamunt    = exrtcb
     c                   else
     c                   eval      ocaamunt    = 0
     c                   endif

     c                   other
     c                   if        expdci      = 0
     c                   eval      ocaamunt    = expamt
     c                   else
     c                   eval      ocaamunt    = 0
     c                   endif
     c                   endsl

     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 1

     c                   write     t__cuaamo

     c                   exsr      wrtAudit

      ** Accrued interest.
     c                   if        splitDrCr
     c                             or  exaamt <> 0
     c                   eval      dcindi      = 1
     c                   eval      ocaamunt    = exaamt
     c                   else
     c                   eval      dcindi      = 2
     c                   eval      ocaamunt    = exoaam
     c                   endif

     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 20

     c                   write     t__cuaamo

     c                   exsr      wrtAudit

      ** Average Quarterly Balance.
     c                   if        avblFound

     c                   if        splitDrCr
     c                   eval      dcindi      = 1
     c                   eval      ocaamunt    = avbldr

     c                   else
     c                   if        avblnt      > 0
     c                   eval      dcindi      = 1
     c                   else
     c                   eval      dcindi      = 2
     c                   endif
     c                   eval      ocaamunt    = %abs(avblnt)
     c                   endif

     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 64

     c                   write     t__cuaamo

     c                   exsr      wrtAudit
     c                   endif


      ** Using Credit values.
     c                   else

      ** Account balance.
     c                   eval      dcindi      = 2

     c                   select
     c                   when      not splitDrCr
     c                   if        AcBalExp    = 'C'
     c                   eval      ocaamunt    = %abs(exrtcb)
     c                   else
     c                   eval      ocaamunt    = expamt
     c                   endif

     c                   when      AcBalExp    = 'C'
     c                   if        exrtcb      < 0
     c                   eval      ocaamunt    = %abs(exrtcb)
     c                   else
     c                   eval      ocaamunt    = 0
     c                   endif

     c                   other
     c                   if        expdci      = 1
     c                   eval      ocaamunt    = expamt
     c                   else
     c                   eval      ocaamunt    = 0
     c                   endif
     c                   endsl

     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 1

     c                   write     t__cuaamo

     c                   exsr      wrtAudit

      ** Accrued interest.
     c                   if        splitDrCr
     c                             or  exoaam <> 0
     c                   eval      dcindi      = 2
     c                   eval      ocaamunt    = exoaam
     c                   else
     c                   eval      dcindi      = 1
     c                   eval      ocaamunt    = exaamt
     c                   endif

     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 20

     c                   write     t__cuaamo

     c                   exsr      wrtAudit

      ** Average Quarterly Balance.
     c                   if        avblFound

     c                   if        splitDrCr
     c                   eval      dcindi      = 2
     c                   eval      ocaamunt    = %abs(avblcr)

     c                   else
     c                   if        avblnt      > 0
     c                   eval      dcindi      = 1
     c                   else
     c                   eval      dcindi      = 2
     c                   endif
     c                   eval      ocaamunt    = %abs(avblnt)
     c                   endif

     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 64

     c                   write     t__cuaamo

     c                   exsr      wrtAudit
     c                   endif

     c                   endif

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  geneledRec - Subroutine that writes records to rn_geneled    *
      *                                                               *
      *****************************************************************
     c     geneledRec    begsr

     c                   eval      glref       = contref                                     BUG9760
     c                   eval      gldetre     = glref                                       BUG9760
     c                   eval      glentre     = glref                                       BUG9760

     c                   if           expacs   = 'AS'                                       BUG11350
     c                             or expacs   = 'EX'                                       BUG11350
     c                             or expacs   = 'CO'                                       BUG11350
     c                             or expacs   = 'ME'                                       BUG11350
     c                             or expacs   = 'TR'                                       BUG11350
     c                             or expacs   = 'CN'                                       BUG11350
     c                   eval      alindi      = 1                                          BUG11350
     c                   else                                                               BUG11350
     c                   eval      alindi      = 2                                          BUG11350
     c                   endif                                                              BUG11350
                                                                                            BUG11350
     c                   if        extrty      = 'R'
     c                   eval      thirindi    = 1
     c                   else
     c                   eval      thirindi    = 0
     c                   endif

     c                   write     t__geneled

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  genledaRec - Subroutine that writes records to rn_genleda    *
      *                                                               *
      *****************************************************************
     c     genledaRec    begsr

     c                   write     t__genleda

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  genleduRec - Subroutine that writes records to rn_genledu    *
      *                                                               *
      *****************************************************************
     c     genleduRec    begsr

     c                   eval      prdclaus    = rtnPrdclaUS

     c                   write     t__genledu

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  gelamoRec - Subroutine that writes records to rn_gelamo      *
      *                                                               *
      *****************************************************************
     c     gelamoRec     begsr

      ** output Amount records:
      ** --------------------
      ** 1) Cleared Balance.

      ** Original CCY amount
     c                   if        AcBalExp    = 'C'
      ** use cleared balance:
     c                   if        exrtcb      < 0
     c                   eval      dcindi      = 2
     c                   else
     c                   eval      dcindi      = 1
     c                   endif
     c                   eval      ocaamunt    = %abs(exrtcb)

     c                   else
      ** use principal amount
     c                   eval      ocaamunt    = expamt
     c                   if        expali      = 'A'
     c                   eval      dcindi      = 2
     c                   else
     c                   eval      dcindi      = 1
     c                   endif
     c                   endif

     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )

      ** Type of amount = book value (1)
     c                   eval      typamunt    = 1


      ** General ledger type
     c                   if        exstat      = 'S'
     c                   eval      gltype      = 1
     c                   else
     c                   eval      gltype      = 2
     c                   endif

     c                   write     t__gelamo

     c                   exsr      wrtAudit

      ** ------------------
      ** 2) Original Cost.

     c                   eval      gltype      = 2
     c                   eval      dcindi      = 1

     c                   if        extnFound
     c                   eval      ocaamunt    = x#origcost
     c                   else
     c                   eval      ocaamunt    = 0
     c                   endif

     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 26

     c                   write     t__gelamo

     c                   exsr      wrtAudit

      ** -----------------------------
      ** 3) Quarterly Average Balance.

     c                   if        avblFound

     c                   eval      gltype      = 2

     c                   if        avblnt      > 0
     c                   eval      dcindi      = 1
     c                   else
     c                   eval      dcindi      = 2
     c                   endif

     c                   eval      ocaamunt    = %abs(avblnt)

     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )

     c                   eval      typamunt    = 64

     c                   write     t__gelamo

     c                   exsr      wrtAudit
     c                   endif

     c                   endsr

      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * GetProdCode - Retrieves Product Code                              *
      *                                                                   *
      *********************************************************************
     c     getProdCode   begsr

      * Product mappings
     c                   callb     'RNPRODMAP'
     c                   parm      *blanks       pRtnCod
     c                   parm                    pERMS
     c                   parm      expacc        pAccountCode
     c                   parm                    pDealType
     c                   parm                    pDealSubType
     c                   parm                    pLoanType
     c                   parm                    pLoanSubType
     c                   parm                    pFacilityType
     c                   parm                    pSecuritySNam
     c                   parm                    pInvestType
     c                   parm      excint        pInstitution
     c                   parm      excind        pIndustry
     c                   parm      exccit        pCtryCitizen
     c                   parm      excloc        pCtryLocation
     c                   parm      exbook        pBook
     c                   parm      excbnk        pBankNonBank
     c                   parm      expali        pAssetLiab
     c                   parm                    pCollateralTy
     c     rtnProduct    parm                    pProduct
     c                   parm                    pCntOfClauses

      ** If not found, issue a database error
     c                   if        pRtnCod    <> *blanks
     c                   eval      wDbfile     = 'T_FRSMAPR'
     c                   eval      wDbase      = 2
     c                   eval      wDbkey      = pAccountCode
     c                   exsr      *pssr
     c                   endif

     c                   endsr

      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * GetProdCodeUS - Retrieves Product Code US specific                *
      *                                                                   *
      *********************************************************************
     c     GetProdCodeUS begsr

     c                   callb     'RNPRODMAPU'

     c                   parm      *blanks       pRtnCod
     c                   parm                    pERMS
     c                   parm      expacc        pAccountCode
     c                   parm                    pDealType
     c                   parm                    pDealSubType
     c                   parm                    pLoanType
     c                   parm                    pLoanSubType
     c                   parm                    pFacilityType
     c                   parm                    pSecuritySNam
     c                   parm                    pInvestType
     c                   parm      excint        pInstitution
     c                   parm      excind        pIndustry
     c                   parm      exccit        pCtryCitizen
     c                   parm      excloc        pCtryLocation
     c                   parm      exbook        pBook
     c                   parm      excbnk        pBankNonBank
     c                   parm      expali        pAssetLiab
     c                   parm                    pCollateralTy
     c     rtnPrdclaUS   parm                    pProduct
     c                   parm                    pCntOfClauses


      ** If not found, issue a database error
     c                   if        pRtnCod <> *blanks
     c                   eval      wDbfile     = 'T_FRSMAPR'
     c                   eval      wDbase      = 6
     c                   eval      wDbkey      = pAccountCode
     c                   exsr      *pssr
     c                   endif

     c                   if        rtnPrdclaUS < 0
     c                   eval      rtnPrdclaUS = 0
     c                   endif

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getCust   - Retrieves Customer Details                       *
      *                                                               *
      *****************************************************************
     c     getCust       begsr

     c                   callb     'AOCUSTR0'
     c**********         parm      '*DBERR'      pRtnCod                                    BUG10501
     c                   parm      *blanks       pRtnCod                                    BUG10501
     c                   parm      '*KEY'        pOption
     c                   parm                    pKey1
     c                   parm                    pKyst
     c     sdcust        parm                    dssdy
                                                                                            BUG10501
     c                   if        pRtnCod    <> *blanks                                    BUG10501
     c                   eval      wDbmod      = 'AOCUSTR0'                                 BUG10501
     c                   eval      wDbase      = 21                                         BUG10501
     c                   eval      wDbkey      = pKey1                                      BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getAccnt   - Retrieves Account Details                       *
      *                                                               *
      *****************************************************************
     c     getAccnt      begsr

     c                   callb     'AOACCTR0'
     c**********         parm      '*DBERR'      pRtnCod                                    BUG10501
     c                   parm      *blanks       pRtnCod                                    BUG10501
     c                   parm      '*KEY'        pOption
     c                   parm      *blanks       pRetl
     c                   parm      excusn        pCnum
     c                   parm      excycd        pCucd
     c                   parm      expacc        pAccd
     c                   parm      exacsq        pAcsq
     c                   parm      exbrch        pBrca
     c     accntab       parm                    dssdy
                                                                                            BUG10501
     c                   if        pRtnCod    <> *blanks                                    BUG10501
     c                   eval      wDbmod      = 'AOACCTR0'                                 BUG10501
     c                   eval      wDbase      = 22                                         BUG10501
     c                   eval      wDbkey      = pCnum                                      BUG10501
     c                                         + pCucd                                      BUG10501
     c                                         + pAccd                                      BUG10501
     c                                         + pAcsq                                      BUG10501
     c                                         + pBrca                                      BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501

      * Get extension record.
     c     kAccount      chain     t_rnamadf
     c                   eval      extnFound   = %found

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Retrieve latest Average Balance record for                   *
      *  Calendar/Financial C, Period type Q.                         *
      *                                                               *
      *****************************************************************
     c     getAverageBal begsr

     c     kAccount      setll     mravbll0
     c     kAccount      reade     mravbll0
     c                   dow       not %eof

     c                   if        (   cafi    = 'C'
     c                             and pertyp  = 'Q' )
     c                   leave
     c                   endif

     c     kAccount      reade     mravbll0
     c                   enddo

     c                   eval      avblFound   = not %eof

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getCcy  - Retrieves Currency Details                         *
      *                                                               *
      *****************************************************************
     c     getCcy        begsr

     c                   callb     'AOCURRR0'
     c**********         parm      '*DBERR'      pRtnCod                                    BUG10501
     c                   parm      *blanks       pRtnCod                                    BUG10501
     c                   parm      '*KEY'        pOption
     c                   parm                    pCcy
     c     sdcurr        parm                    dssdy
                                                                                            BUG10501
     c                   if        pRtnCod    <> *blanks                                    BUG10501
     c                   eval      wDbmod      = 'AOCURRR0'                                 BUG10501
     c                   eval      wDbase      = 23                                         BUG10501
     c                   eval      wDbkey      = pCcy                                       BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  wrtAudit -  write Audit Records                              *
      *                                                               *
      *****************************************************************
     c     wrtAudit      begsr

     c                   eval      auregaut    = aRaid(rgIx)
     c                   eval      autrncls    = exsub
     c                   eval      aucntref    = contref
     c                   eval      auprdcod    = product
     c                   eval      aubrch      = exbrch
     c                   eval      aucusn      = excusn
     c                   eval      autrty      = extrty
     c                   eval      autrst      = extrst
     c                   eval      auamttyp    = typamunt
     c                   eval      auorgccy    = isocurr
     c                   eval      auocaamt    = ocaamunt
     c                   eval      aurptccy    = aRpCy(rgIx)
     c                   eval      aurcaamt    = rcaamunt
     C                   if        dcindi      = 1
     C                   eval      audci       = 'D'
     C                   else
     C                   eval      audci       = 'C'
     C                   endif
     c                   write     rnaupnpdf

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  wrtExcptn -  write Exception Records                         *
      *                                                               *
      *****************************************************************
     c     wrtExcptn     begsr

     c                   eval      xcregaut    = aRaid(rgIx)
     c                   eval      xctrncls    = exsub
     c                   eval      xccntref    = exbrch
     c                                         + excusn
     c                                         + excycd
     c                                         + expacc
     c                                         + exacsq
     c                   eval      xcbrch      = exbrch
     c                   eval      xccusn      = excusn
     c                   eval      xctrty      = extrty
     c                   eval      xctrst      = extrst
     c                   write     rnxcpnpdf

     c                   endsr

      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * BootStrap - Write Boot Strap Records                              *
      *                                                                   *
      *********************************************************************
     c     bootstrap     begsr

      ** Loop thru used lots
     c                   for       rgIx        = 1 to rgEl

      ** Write to t__dfboo if not existing
     c                   if        aPosLotUsed(rgIx)
     c     aPosLot(rgIx) setll     t__dfboof

     c                   if        not %equal
     c                   eval      lottypfk    = aPosLot(rgIx)

     c                   monitor
     c                   write     t__dfboof
     c                   on-error  dupKey
     c                   endmon

     C                   endif

     C                   endif

     C                   endfor

     C                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  closedown -  return to calling Program                       *
      *                                                               *
      *****************************************************************
     c     closedown     begsr

     c                   eval      *inlr       = *on
     c                   return

     c                   endsr

      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * called by: Implicitly on program activation                   *
      *                                                               *
      *****************************************************************
     c     *inzsr        begsr

      ** Get zone.
     c                   callb     'GOGETZONE'
     c                   parm      *blanks       pRtnCod
     c                   parm      *blanks       pErrMsg
     c                   parm      'N'           pFullChk
     c                   parm      *blanks       pZone
     c                   parm                    pShtc
     c                   parm                    pRdnb
     c                   parm                    pDnwd
     c                   parm                    pBccy
     c                   parm                    pNjob

     c                   if        pRtnCod    <> *blanks
     c                   eval      wDbfile     = 'GPZONEPD'
     c                   eval      wDbase      = 5
     c                   eval      wDbkey      = pZone
     c                   exsr      *pssr
     c                   endif

      *---------------------------------------------------------------------

      ** Get bank details.
     c                   callb     'AOBANKR0'
     c**********         parm      '*DBERR'      pRtnCod                                    BUG10501
     c                   parm      *blanks       pRtnCod                                    BUG10501
     c                   parm      '*FIRST'      pOption
     c     sdbank        parm                    dsfdy
                                                                                            BUG10501
     c                   if        pRtnCod    <> *blanks                                    BUG10501
     c                   eval      wDbmod      = 'AOBANKR0'                                 BUG10501
     c                   eval      wDbase      = 24                                         BUG10501
     c                   eval      wDbkey      = pOption                                    BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501

     c                   eval      runDatIso   = %date(rnDayCnv(bjrdnb))

      * Get general ledger details.
     c                   callb     'AOGELRR0'
     c**********         parm      '*DBERR'      pRtnCod                                    BUG10501
     c                   parm      *blanks       pRtnCod                                    BUG10501
     c                   parm      '*FIRST'      pOption
     c     sdgelr        parm                    dsfdy
                                                                                            BUG10501
     c                   if        pRtnCod    <> *blanks                                    BUG10501
     c                   eval      wDbmod      = 'AOGELRR0'                                 BUG10501
     c                   eval      wDbase      = 25                                         BUG10501
     c                   eval      wDbkey      = pOption                                    BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501

      * Derive event control date.
     c                   if        bkapdt      < bjdnwd
     c                   eval      evtDatIso   = %date(rnDayCnv(bkapdt))
     c                   else
     c                   eval      evtDatIso   = %date(rnDayCnv(bjdnwd - 1))
     c                   endif

      *---------------------------------------------------------------------

      ** Midas GP System Values
     c                   eval      pValDs      = *blanks

      ** P & L Account Product Code start and end
     c                   eval      pValK1      = 'P&LAcProdCodRngStr'
     c                   eval      pValK2      = 'P&LAcProdCodRngEnd'

      ** Customer Account Product Code start and end
     c                   eval      pValK3      = 'CusAcProdCodRngStr'
     c                   eval      pValK4      = 'CusAcProdCodRngEnd'

     c                   call      'GPAOSVALR0'
     c**********         parm      '*DBERR'      pRtnCod                                    BUG10501
     c                   parm      *blanks       pRtnCod                                    BUG10501
     c                   parm                    pValK1
     c                   parm                    pVal1
     c                   parm                    pValK2
     c                   parm                    pVal2
     c                   parm                    pValK3
     c                   parm                    pVal3
     c                   parm                    pValK4
     c                   parm                    pVal4
     c                   parm                    pValK5
     c                   parm                    pVal5
     c                   parm                    pValK6
     c                   parm                    pVal6
     c                   parm                    pValK7
     c                   parm                    pVal7
     c                   parm                    pValK8
     c                   parm                    pVal8
     c                   parm                    pValK9
     c                   parm                    pVal9
     c                   parm                    pValK10
     c                   parm                    pVal10
                                                                                            BUG10501
     c                   if        pRtnCod    <> *blanks                                    BUG10501
     c                   eval      wDbmod      = 'GPAOSVALR0'                               BUG10501
     c                   eval      wDbase      = 26                                         BUG10501
     c                   eval      wDbkey      = pValK1                                     BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501

      ** Trim spaces and convert to packed decimal
     c                   eval      strPlAcc    = %dec( %trim( pVal1 ): 6: 0 )
     c                   eval      endPlAcc    = %dec( %trim( pVal2 ): 6: 0 )
     c                   eval      strCusAcc   = %dec( %trim( pVal3 ): 6: 0 )
     c                   eval      endCusAcc   = %dec( %trim( pVal4 ): 6: 0 )

      ** Midas AO System Values
     c                   eval      pValDs      = *blanks

      ** A/C Balance Export
     c                   eval      pValK1      = 'AccountBalExport'

     c                   call      'AOSVALR0'
     c**********         parm      '*DBERR'      pRtnCod                                    BUG10501
     c                   parm      *blanks       pRtnCod                                    BUG10501
     c                   parm                    pValK1
     c                   parm                    pVal1
     c                   parm                    pValK2
     c                   parm                    pVal2
     c                   parm                    pValK3
     c                   parm                    pVal3
     c                   parm                    pValK4
     c                   parm                    pVal4
     c                   parm                    pValK5
     c                   parm                    pVal5
     c                   parm                    pValK6
     c                   parm                    pVal6
     c                   parm                    pValK7
     c                   parm                    pVal7
     c                   parm                    pValK8
     c                   parm                    pVal8
     c                   parm                    pValK9
     c                   parm                    pVal9
     c                   parm                    pValK10
     c                   parm                    pVal10
                                                                                            BUG10501
     c                   if        pRtnCod    <> *blanks                                    BUG10501
     c                   eval      wDbmod      = 'AOSVALR0'                                 BUG10501
     c                   eval      wDbase      = 27                                         BUG10501
     c                   eval      wDbkey      = pValK1                                     BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501

     c                   eval      AcBalExp    = pVal1

      *---------------------------------------------------------------------

      /copy rncpysrc,rnrgaulod

      *---------------------------------------------------------------------

      ***Check*for*feature*CGP010.***************************                                BUG9760
     c**********         callb     'AOSARDR0'                                                BUG9760
     c**********         parm      *blanks       pRtnCod                                     BUG9760
     c**********         parm      '*VERIFY'     pOption                                     BUG9760
     c**********         parm      'CGP010'      pSar                                        BUG9760
      **********                                                                             BUG9760
     c**********         if        pRtnCod     = *blanks                                     BUG9760
     c**********         eval      CGP010      = *on                                         BUG9760
      **********                                                                             BUG9760
     c**********         elseif    pRtnCod     = '*NRF'                                      BUG9760
     c**********         eval      CGP010      = *off                                        BUG9760
      **********                                                                             BUG9760
     c**********         else                                                                BUG9760
     c**********         eval      wDbase      = 3                                           BUG9760
     c**********         eval      wDbmod      = 'AOSARDR0'                                  BUG9760
     c**********         exsr      *pssr                                                     BUG9760
     c**********         endif                                                               BUG9760

      ** Check for feature CRN002.
     c                   callb     'AOSARDR0'
     c                   parm      *blanks       pRtnCod
     c                   parm      '*VERIFY'     pOption
     c                   parm      'CRN002'      pSar

     c                   if        pRtnCod     = *blanks
     c                   eval      CRN002      = *on

     c                   elseif    pRtnCod     = '*NRF'
     c                   eval      CRN002      = *off

     c                   else
     c                   eval      wDbase      = 4
     c                   eval      wDbmod      = 'AOSARDR0'
     c                   exsr      *pssr
     c                   endif

      ** Feature CRN002 is present
     c                   if        CRN002
     c                   open      rn_cusacca
     c                   open      rn_genleda
     c                   endif

      ** Check if enhancement CRN006 is on

     c                   callb     'AOSARDR0'
     c                   parm      *blanks       pRtnCod
     c                   parm      '*VERIFY'     pOption
     c                   parm      'CRN006'      pSar

     c                   if        pRtnCod     = *blank
     c                   eval      CRN006      = *on

     c                   elseif    pRtnCod     = '*NRF'
     c                   eval      CRN006      = *off

     c                   else
     c                   eval      wDbase      = 6
     c                   eval      wDbmod      = 'AOSARDR0'
     c                   exsr      *pssr
     c                   endif

      ** Feature CRN006 is present
     c                   if        CRN006
     c                   open      rn_cusaccu
     c                   open      rn_genledu
     c                   open      rn_proflou
     c                   endif

     c                   endsr

      *********************************************************************
      /EJECT
      *********************************************************************
      /copy rncpysrc,rnpssrsr
      *****************************************************************

**ctdata cpy@
(c) Finastra International Limited 2005
