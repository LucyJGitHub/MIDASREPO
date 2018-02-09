     h debug   alwnull(*usrctl)
     h fixnbr(*zoned : *inputpacked)
     h copyright('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Money Market Loan/Deposit Extract')          *
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNLDNIXT   - Midas FRS MM Loan / Deposit extract             *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11435           Date 06Jun06               *
      *                 CSD027A            Date 10May06               *
      *                 BUG10804           Date 10Mar06               *
      *                 BUG9828R           Date 20Feb06               *
      *                 BUG9828            Date 15Feb06               *
      *                 BUG10501           Date 09Feb06               *
      *                 BUG9935            Date 17Jan06               *
      *                 BUG9795            Date 09Jan06               *
      *                 CRN001  *Create    Date 20Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  BUG11435 - Follow up issue 21. Add more mapping for INDACOBA.*
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  BUG10804 - RN_LOANDEP format has changed for FRS Data        *
      *             Foundation 2.9.3.                                 *
      *  BUG9828R - Repoen fix. Use original name ELIGIBLE in         *
      *             T__LOANDEP as in T__CUSTACC for consitency.       *
      *  BUG9828 - T__LOANDEP format changed, populate ELIGIBLT.      *
      *            T__LOADEPU format changed.                         *
      *  BUG10501 - Parameter value '*DBERR' is not correct for       *
      *             access object running in CoB.                     *
      *  BUG9935 - Missing audit record for original cost amount      *
      *            records output to T_LODAMO.                        *
      *  BUG9795 - Wrong field used in setting 'glref' for            *
      *            accrued interest record.                           *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     fmrtrapl0  if   e           k disk    infsr(*pssr)

     fgpregbj0  if   e           k disk    infsr(*pssr)

     fdeals     if   e           k disk    infsr(*pssr)
     f                                     include(dealsdcf)
     f                                     prefix(d#)

     ffclty     if   e           k disk    infsr(*pssr)
     f                                     include(fcltyfmf)
     f                                     prefix(f#)

     ft_rnldni  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnldni:t_rnldnif)
     f                                     prefix(lx#)                                      BUG9828R

     ft_rnbsrt  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnbsrt:t_rnbsrtf)

     ft__dfboo  if a e           k disk    infsr(*pssr)
     f                                     rename(t__dfboo:t__dfboof)

     frn_loandepo    e             disk    infsr(*pssr)

     frn_loadepao    e             disk    infsr(*pssr) usropn

     frn_loadepuo    e             disk    infsr(*pssr) usropn

     frn_lodamo o    e             disk    infsr(*pssr)

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

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     d cpy@            s             80    dim(1) ctdata perrcd(1)
     d dsfdy         e ds
     d dssdy         e ds
     d sdbank        e ds                  extname(sdbankpd)
     d sdgelr        e ds                  extname(sdgelrpd)
     d sdcurr        e ds                  extname(sdcurrpd)
     d sdcust        e ds                  extname(sdcustpd)

      ** External DS for SAR details
     d scsard        e ds                  extname(scsardpd)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     d pRaid           s                   like(rbraid)
     d runDatIso       s               d
     d evtDatIso       s               d

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

     d extrid          ds
     d  dealNo                        6s 0

     d                 ds
     d exfcus
     d exftyp
     d exfcno
     d*exfcusN*                       6s 0 overlay(exfcus)                                   CSD027A
     d exfcusN                        6    overlay(exfcus)                                   CSD027A
     d exftypN                        3s 0 overlay(exftyp)
     d exfcnoN                        2s 0 overlay(exfcno)

     d fcltyFound      s               n

     d kExsub          s                   like(exsub)
     d                                     inz('LDNI')

     d CRN002          s               n
     d CRN006          s               n

     d dupKey          c                   01021

     d rtnProduct      s                   like(product)
     d rtnPrdclaUS     s                   like(prdclaus)

      ** Deal types handled by this extract.
     d aTrty           s                   like(extrty)
     d                                     dim(13) ctdata perrcd(1)
     d ixTrty          s              3u 0

     d mmFixed         s               n

     d #cycd           s                   like(bacycd)
     d #bsrc           s                   like(babsrc)

      ** Parameters for RNPRODMAP
     d I#ERMS          s             30
     d I#AccountCode   s             10
     d I#DealType      s              2
     d I#DealSubType   s              6
     d I#LoanType      s              2
     d I#LoanSubType   s              6
     d I#FacilityType  s              3
     d I#SecuritySNam  s             10
     d I#InvestType    s              3
     d I#Institution   s              2
     d I#Industry      s              3
     d I#CtryCitizen   s              2
     d I#CtryLocation  s              2
     d I#Book          s              2
     d I#BankNonBank   s              1
     d I#AssetLiab     s              1
     d I#CollateralTy  s              5
     d O#Product       s             10  0
     d O#CntOfClauses  s              5  0

      /copy rncpysrc,rnrgaudfn

      /copy rncpysrc,rndaycnv
      /copy rncpysrc,rnamtcnv
      /copy rncpysrc,rnastlia

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+

     c     kFclty        klist
     c                   kfld                    exfcusN
     c                   kfld                    exftypN
     c                   kfld                    exfcnoN

     c     kBsrt         klist
     c                   kfld                    #cycd
     c                   kfld                    #bsrc

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

      ** Check transaction (deal) type.
     c                   eval      ixTrty      = %lookup(extrty : aTrty)
     c                   if        ixTrty      > 0
     c                   eval      mmFixed     = (ixTrty < 8)

      ** Get Product Code.
     c                   exsr      getProdCode
     c                   select
     c                   when      rtnProduct  > 0
     c                   exsr      mapData

     c                   when      rtnProduct  < 0
     c                   exsr      wrtExcptn
     c                   endsl

     c                   endif
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

     c                   exsr      getDeal

     c                   exsr      getFclty

      ** Get customer details.
     c                   eval      pKey1       = excusn
     c                   exsr      getCust

     c                   clear                   t__loandep
     c                   clear                   t__lodamo

     c                   if        CRN002
     c                   clear                   t__loadepa
     c                   endif

     c                   if        CRN006
     c                   clear                   t__loadepu
     c                   endif

     c                   exsr      loandepRec

     c                   if        CRN002
     c                   exsr      loadepaRec
     c                   endif

     c                   if        CRN006
     c                   exsr      loadepuRec
     c                   endif

     c                   exsr      lodamoRec

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  loandepRec - Subroutine that writes records to RN_LOANDEP.   *
      *                                                               *
      *****************************************************************
     c     loandepRec    begsr

     c                   eval      product     = rtnProduct
     c                   eval      statusl2    = 5
     c                   eval      numberof    = 1
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on

     c                   eval      cancella    = rnDayCnv(d#fscand)

     c                   select
     c                   when      d#rbdn     <> 0
     c                   eval      lastroll    = rnDayCnv(exmdat)
     c                   when      d#rodn     <> 0
     c                   eval      lastroll    = rnDayCnv(exvdat)
     c                   other
     c                   eval      lastroll    = *blanks
     c                   endsl

     c                   eval      deal        = rnDayCnv(exddat)
     c                   eval      earlrede    = rnDayCnv(d#fscand)
     c                   eval      lasintda    = rnDayCnv(d#slid)

     c                   if        (   mmFixed
     c                             or  exmdat  > 0 )
     c                   eval      maturity    = rnDayCnv(exmdat)
     c                   else
     c                   eval      maturity    = rnDayCnv(extdat + d#notd)
     c                   endif

     c                   eval      nextsett    = rnDayCnv(exnidt)

     c                   if        (   d#rbdn <> 0
     c                             or  d#auro  = 'Y' )
     c                   eval      nextroll    = rnDayCnv(exmdat)
     c                   endif

     c                   eval      intstar     = rnDayCnv(exvdat)
     c                   eval      intend      = rnDayCnv(exmdat)
     c                   eval      settleme    = rnDayCnv(exnidt)

     c                   eval      boocntre    = pZone
     c                                         + exbook

     c                   eval      counref     = bbbrcd
     c                                         + '-'
     c                                         + excusn

     c                   if        fcltyFound
     c                   eval      pKey1       = exfcus
     c                   exsr      getCust
     c                   eval      limiref     = bbbrcd
     c                                         + '-'
     c                                         + exfcus
     c                                         + exftyp
     c                                         + exfcno
     c                   endif

     c                   eval      sourref     = pZone

      ** Position ref.
     c                   eval      posiref     = exbrch
     c                                         + 'DL'
     c                                         + extrid

     c                   eval      reporef     = *blank

      ** Contract ref.
     c                   eval      contref     = posiref

     c                   eval      pKey1       = exbicn
     c                   exsr      getCust
     c                   eval      intparre    = bbbrcd
     c                                         + '-'
     c                                         + exbicn

     c                   if        mmFixed
     c                   eval      original    = exmdat
     c                                         - exvdat
     c                   else
     c                   eval      original    = d#notd
     c                   endif

     c                   if        (   mmFixed
     c                             or  exmdat <> 0 )
     c                   eval      remainin    = exmdat
     c                                         - extdat
     c                   else
     c                   eval      remainin    = d#notd
     c                   endif

     c                   eval      perintra    = exintr
     c                   eval      intintra    = exintr

      ** Reimbursement frequency
     c                   select
     c                   when      (   d#ipfr  = 'M'
     c                             or  d#ipfr  = 'N' )
     c                   eval      reimfreq    = 12
     c                   when      d#ipfr      = 'Q'
     c                   eval      reimfreq    = 4
     c                   when      d#ipfr      = 'X'
     c                   eval      reimfreq    = 2
     c                   when      d#ipfr      = 'Y'
     c                   eval      reimfreq    = 1
     c                   endsl

     c                   if        d#notd     <> -999
     c                   eval      noticepe    = d#notd
     c                   endif

     c                   eval      spread      = exrtsp

     c                   eval      alindi      = rnAstLia(extrty)

     c                   if        d#rodn     <> 0
     c                   eval      contract    = 2
     c                   else
     c                   eval      contract    = 1
     c                   endif

      ** Reference Rate Type
     c                   eval      #cycd       = excycd
     c                   movel     d#brtt        #bsrc

     c                   if        d#brtt     <> 0

     c     kBsrt         chain     t_rnbsrtf
     c                   if        %found
     c                   eval      referate    =  refrattp
     c                   else
     c                   eval      referate    = 7
     c                   endif

     c                   else
     c                   eval      referate    = 0
     c                   endif

      ** Interest Day Count Basis
     c                   select
     c                   when      d#icbs      = 1
     c                   eval      indacoba    = 15
     c                   when      d#icbs      = 2
     c                   eval      indacoba    = 2
     c                   when      d#icbs      = 3
     c                   eval      indacoba    = 5

      ******O/S*** no values provided for 4,5,6 yet, unpopulated due to issue 21.
     c******O/S***       when      d#icbs      = 4
     c******O/S***       eval      indacoba    = ???
     c******O/S***       when      d#icbs      = 5
     c******O/S***       eval      indacoba    = ???
     c******O/S***       when      d#icbs      = 6
     c******O/S***       eval      indacoba    = ???
     c                   when      d#icbs      = 4                                          BUG11435
     c                   eval      indacoba    = 16                                         BUG11435
     c                   when      d#icbs      = 5                                          BUG11435
     c                   eval      indacoba    = 17                                         BUG11435
     c                   when      d#icbs      = 6                                          BUG11435
     c                   eval      indacoba    = 18                                         BUG11435
     c                   when      d#icbs      = 7                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
     c                   when      d#icbs      = 8                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
     c                   other                                                              BUG11435
     c                   eval      indacoba    = 0                                          BUG11435
     c                   endsl

     c                   eval      amortisa    = 2
     c                   eval      listed      = 0                                          BUG10804
     c                   eval      reschedu    = 2
     c                   eval      risquain    = 1

      ** Interest Rate Type
     c                   if        (   d#brtt <> 0
     c                             or  d#notd <> -999 )
     c                   eval      typintra    = 2
     c                   else
     c                   eval      typintra    = 1
     c                   endif

     c                   eval      intpayfr    = reimfreq

     c                   if        (   fcltyFound
     c                             and f#rvcr  = 'Y' )
     c                   eval      revofac     = 1
     c                   endif

     c     dealNo        chain     t_rnldnif
     c                   if        %found
     c**********         move      loclfund      locafund                                   BUG9828R
     c**********         eval      portfoli    = portfolo                                   BUG9828R
     c**********         eval      purpose     = purposet                                   BUG9828R
     c**********         eval      liquifya    = liquifab                                   BUG9828R
     c**********         eval      eligiblt    = eligible                           BUG9828 BUG9828R
     c**********         eval      fdicins     = fdicinsr                                   BUG9828R
     c**********         eval      smbus       = smallbus                                   BUG9828R
     c**********         eval      offbal      = offbalan                                   BUG9828R
     c**********         eval      othacccl    = othraccl                                   BUG9828R
     c**********         eval      fiduciar    = fiduind                                    BUG9828R
     c**********         eval      accrual     = accrind                                    BUG9828R
     c                   move      lx#loclfund   locafund                                   BUG9828R
     c                   eval      portfoli    = lx#portfolo                                BUG9828R
     c                   eval      purpose     = lx#purposet                                BUG9828R
     c                   eval      liquifya    = lx#liquifab                                BUG9828R
     c                   eval      eligible    = lx#eligible                                BUG9828R
     c                   eval      fdicins     = lx#fdicinsr                                BUG9828R
     c                   eval      smbus       = lx#smallbus                                BUG9828R
     c                   eval      offbal      = lx#offbalan                                BUG9828R
     c                   eval      othacccl    = lx#othraccl                                BUG9828R
     c                   eval      fiduciar    = lx#fiduind                                 BUG9828R
     c                   eval      accrual     = lx#accrind                                 BUG9828R
     c                   else
     c                   eval      locafund    = *zeros
     c                   eval      portfoli    = *zeros
     c                   eval      purpose     = *zeros
     c                   eval      liquifya    = *zeros
     c**********         eval      eligiblt    = *zeros                             BUG9828 BUG9828R
     c                   eval      eligible    = *zeros                                     BUG9828R
     c                   eval      fdicins     = *zeros
     c                   eval      smbus       = *zeros
     c                   eval      offbal      = *zeros
     c                   eval      othacccl    = *zeros
     c                   eval      fiduciar    = *zeros
     c                   eval      accrual     = *zeros
     c                   endif

     c                   write     t__loandep

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  loadepaRec - Subroutine that writes records to RN_LOADEPA.   *
      *                                                               *
      *****************************************************************
     c     loadepaRec    begsr

     c                   eval      intsusp     = *zeros
     c                   eval      position    = *zeros

     c                   write     t__loadepa

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  loadepuRec - Subroutine that writes records to RN_LOADEPU.   *
      *                                                               *
      *****************************************************************
     c     loadepuRec    begsr

      ** Get US product Code.
     c                   exsr      getProdCodeUS
     c                   eval      prdclaus    = rtnPrdclaUS

     c                   write     t__loadepu

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  lodamoRec - Subroutine that writes records to RN_LODAMO.     *
      *                                                               *
      *****************************************************************
     c     lodamoRec     begsr

     c                   if        expacc     <> *blanks
     c                   if        expref      = '1'
     c                   eval      glref       = exbrch
     c                                         + exbicn
     c                                         + excycd
     c                                         + expacc                         Principal ac code
     c                                         + exacsq
     c                   else
     c                   eval      glref       = exbrch
     c                                         + excusn
     c                                         + excycd
     c                                         + expacc
     c                                         + exacsq
     c                   endif
     c                   else
     c                   eval      glref       = *blanks
     c                   endif

     c                   eval      gldetre     = glref
     c                   eval      glentre     = glref

      ** Output 3 records:
      ** -----------------
      ** 1) Book value.

     c                   if        expdci      = 0
     c                   eval      dcindi      = 1
     c                   else
     c                   eval      dcindi      = 2
     c                   endif

      ** Get currency details.
     c                   eval      pCcy        = excycd
     c                   exsr      getCcy

     c                   eval      isocurr     = excycd
     c                   eval      ocaamunt    = expamt
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 1
     c                   eval      value       = rnDayCnv(extdat)

     c                   write     t__lodamo

     c                   exsr      wrtAudit

      ** ---------------------
      ** 2) Original cost.

     c                   eval(h)   ocaamunt    = d#opam/(10**a6nbdp)
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 26

     c                   write     t__lodamo
                                                                                             BUG9935
     c                   exsr      wrtAudit                                                  BUG9935

      ** ---------------------
      ** 3) Accrued Interest.

     c                   if        exaacc     <> *blanks
     c**********         if        expref      = '1'                                         BUG9795
     c                   if        exaref      = '1'                                         BUG9795
     c                   eval      glref       = exbrch
     c                                         + exbicn
     c                                         + excycd
     c                                         + exaacc                         accrued int ac code
     c                                         + exacsq
     c                   else
     c                   eval      glref       = exbrch
     c                                         + excusn
     c                                         + excycd
     c                                         + exaacc
     c                                         + exacsq
     c                   endif
     c                   else
     c                   eval      glref       = *blanks
     c                   endif

     c                   eval      gldetre     = glref
     c                   eval      glentre     = glref

     c                   if        exadci      = 0
     c                   eval      dcindi      = 1
     c                   else
     c                   eval      dcindi      = 2
     c                   endif

     c                   eval      ocaamunt    = exaamt
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 20

     c                   write     t__lodamo

     c                   exsr      wrtAudit

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getDeal - Subroutine that retrieves deal details.            *
      *                                                               *
      *****************************************************************
     c     getDeal       begsr

     c     dealNo        chain     deals

     c                   if        not %found
     c                   eval      wDbFile     = 'DEALS'
     c                   eval      wDbase      = 1
     c                   eval      wDbKey      = %char( dealno )
     c                   exsr      *pssr
     c                   endif

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getFclty  - Retrieves Customer Lending Facility              *
      *                                                               *
      *****************************************************************
     c     getFclty      begsr

     c     kFclty        chain     fclty
     c                   eval      fcltyFound  = %found

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
      *  getCcy  - Retrieve Currency Details                          *
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
     c                   eval      wDbase      = 22                                         BUG10501
     c                   eval      wDbkey      = pCcy                                       BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501

     c                   endsr

      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * GetProdCode - Retrieve Product Code                               *
      *                                                                   *
      *********************************************************************
     c     getProdCode   begsr

     c                   callb     'RNPRODMAP'
     c                   parm      *blanks       pRtnCod
     c                   parm                    I#ERMS
     c                   parm                    I#AccountCode
     c                   parm      extrty        I#DealType
     c                   parm      extrst        I#DealSubType
     c                   parm                    I#LoanType
     c                   parm                    I#LoanSubType
     c                   parm                    I#FacilityType
     c                   parm                    I#SecuritySNam
     c                   parm                    I#InvestType
     c                   parm      excint        I#Institution
     c                   parm      excind        I#Industry
     c                   parm      exccit        I#CtryCitizen
     c                   parm      excloc        I#CtryLocation
     c                   parm      exbook        I#Book
     c                   parm      excbnk        I#BankNonBank
     c                   parm      expali        I#AssetLiab
     c                   parm                    I#CollateralTy
     c     rtnProduct    parm                    O#Product
     c                   parm                    O#CntOfClauses

      ** If not found, issue a database error
     c                   if        pRtnCod    <> *blanks
     c                   eval      wDbfile     = 'T_FRSMAPR'
     c                   eval      wDbase      = 2
     c                   eval      wDbkey      = I#DealType
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
     c                   parm                    i#ERMS
     c                   parm                    i#AccountCode
     c                   parm      extrty        i#DealType
     c                   parm      extrst        i#DealSubType
     c                   parm                    i#LoanType
     c                   parm                    i#LoanSubType
     c                   parm                    i#FacilityType
     c                   parm                    i#SecuritySNam
     c                   parm                    i#InvestType
     c                   parm      excint        i#Institution
     c                   parm      excind        i#Industry
     c                   parm      exccit        i#CtryCitizen
     c                   parm      excloc        i#CtryLocation
     c                   parm      exbook        i#Book
     c                   parm      excbnk        i#BankNonBank
     c                   parm      expali        i#AssetLiab
     c                   parm                    i#CollateralTy
     c     rtnPrdclaUS   parm                    o#Product
     c                   parm                    o#CntOfClauses


      ** If not found, issue a database error
     c                   if        pRtnCod <> *blanks
     c                   eval      wDbfile     = 'T_FRSMAPR'
     c                   eval      wDbase      = 6
     c                   eval      wDbkey      = I#DealType
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
      *  wrtAudit -  Write Audit Records                              *
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
      *  wrtExcptn -  Write Exception Records                         *
      *                                                               *
      *****************************************************************
     c     wrtExcptn     begsr

     c                   eval      xcregaut    = aRaid(rgIx)
     c                   eval      xctrncls    = exsub
     c                   eval      xccntref    = exbrch
     c                                         + 'DL'
     c                                         + extrid
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
     c                   if        APosLotUsed(rgIx)
     c     APosLot(rgIx) setll     t__dfboof

     c                   if        not %equal
     c                   eval      lottypfk    = APosLot(rgIx)

     c                   monitor
     c                   write     t__dfboof
     c                   on-error  dupKey
     c                   endmon

     c                   endif

     c                   endif

     c                   endfor

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  closedown -  Return to Calling Program                       *
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
      * Called by: Implicitly on program activation                   *
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
     c                   eval      wDbase      = 23                                         BUG10501
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
     c                   eval      wDbase      = 24                                         BUG10501
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

      /copy rncpysrc,rnrgaulod

      *---------------------------------------------------------------------

     c                   callp     rnAstLiaIn

      ** Check if enhancement CRN002 is on

     c                   callb     'AOSARDR0'
     c                   parm      *blanks       pRtnCod
     c                   parm      '*VERIFY'     pOption
     c                   parm      'CRN002'      pSar

     c                   if        pRtnCod     = *blank
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
     c                   open      rn_loadepa
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
     c                   eval      wDbase      = 4
     c                   eval      wDbmod      = 'AOSARDR0'
     c                   exsr      *pssr
     c                   endif

      ** Feature CRN006 is present
     c                   if        CRN006
     c                   open      rn_loadepu
     c                   endif

     c                   endsr

      *********************************************************************
      /EJECT
      *********************************************************************
      /copy rncpysrc,rnpssrsr
      *****************************************************************

**ctdata cpy@
(c) Finastra International Limited 2004
**ctdata aTrty
IT     Fixed       MM Interbank Taking
IP     Fixed       MM Interbank Placing
TD     Fixed       MM Time Deposit
TI     Fixed       MM Time Loan
DL     Fixed       MM Demand Loan
FL     Fixed       MM Fixed Term Placing (Bank side)
FT     Fixed       MM Fixed Term Taking (Customer side)
CD     Call/notice MM Call or Notice Deposit Taken
DT     Call/notice MM Call Taking
LT     Call/notice MM Call Taking (Fiduciary Loan)
CL     Call/notice MM Call or Notice Deposit Placed
DP     Call/notice MM Call Placing
LP     Call/notice MM Call Placing (Fiduciary Loan)
