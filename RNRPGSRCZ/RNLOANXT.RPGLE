     H debug   alwnull(*usrctl)
     H fixnbr(*zoned : *inputpacked)
     H copyright('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Customer Loan Extract')                      *
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNLOANXT   - Midas Customer Loan Extract                     *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 27Sep06               *
      *                 BUG11435           Date 06Jun06               *
      *                 BUG10909           Date 02May06               *
      *                 CSD027A            Date 10May06               *
      *                 BUG10168           Date 31Mar06               *
      *                 BUG10804           Date 10Mar06               *
      *                 BUG9828R           Date 20Feb06               *
      *                 BUG9828            Date 15Feb06               *
      *                 BUG10501           Date 09Feb06               *
      *                 BUG10335           Date 03Feb06               *
      *                 BUG9393            Date 21Dec05               *
      *                 CRN001  *Create    Date 17Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  242286 - Enhance calculation of interest for calc basis 6.   *
      *  BUG11435 - Follow up issue 21. Add more mapping for INDACOBA.*
      *  BUG10909 - Use EXRTSP for interest rate  if EXINTR is 0.     *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  BUG10168 - If EXRATE from MRTRAPPD is F (fixed) dont map     *
      *             Next Interest Repricing/fixing date field, which  *
      *             is NEXINTFI.                                      *
      *  BUG10804 - RN_GUARANT and RN_LOANDEP formats have changed    *
      *             for FRS Data Foundation 2.9.3.                    *
      *  BUG9828R - Repoen fix. Use original name ELIGIBLE in         *
      *             T__LOANDEP as in T__CUSTACC for consitency.       *
      *  BUG9828 - T__LOANDEP format changed, populate ELIGIBLT.      *
      *            T__LOADEPU format changed.                         *
      *  BUG10501 - Parameter value '*DBERR' is not correct for       *
      *             access object running in CoB.                     *
      *  BUG10335 - Fix to yield calc.                                *
      *             Negative square root type error.                  *
      *  BUG9393 - Yield calculation                                  *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     fmrtrapl0  if   e           k disk    infsr(*pssr)
 
     fgpregbj0  if   e           k disk    infsr(*pssr)
 
     fcloan     if   e           k disk    infsr(*pssr)
     f                                     include(cloanclf)
     f                                     include(cloanckf)
     f                                     prefix(l#)
     floams     if   e           k disk
     f                                     include(loamsdkf)
     f                                     prefix(la#)
 
     ffclty     if   e           k disk    infsr(*pssr)
     f                                     include(fcltyfmf)
     f                                     prefix(f#)
 
     ft_rnclip  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnclip: t_rnclipf)
     f                                     prefix(lx#)
 
     ft_rnbsrt  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnbsrt:t_rnbsrtf)
     f                                     prefix(bx#)
 
     ft__dfboo  if a e             disk    infsr(*pssr)
     f                                     rename(t__dfboo:t__dfboof)
 
     frn_loandepo    e             disk    infsr(*pssr)
 
     frn_loadepao    e             disk    infsr(*pssr) usropn
 
     frn_loadepuo    e             disk    infsr(*pssr) usropn
 
     frn_lodamo o    e             disk    infsr(*pssr)
 
     frn_guaranto    e             disk    infsr(*pssr)
 
     frn_guaamo o    e             disk    infsr(*pssr)
 
     frnaupnpd  o    e             disk    infsr(*pssr)
 
     frnxcpnpd  o    e             disk    infsr(*pssr)
 
      *=====================================================================
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
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     d pRaid           s                   like(rbraid)
     d runDatIso       s               d
     d evtDatIso       s               d
 
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
                                                                                             BUG9393
     d retCode10       s             10                                                      BUG9393
     d zzindy          s              5  0                                                   BUG9393
     d zzbeg           s              5  0                                                   BUG9393
     d zzend           s              5  0                                                   BUG9393
     d zzcalc          s              1                                                      BUG9393
     d***int6dy*       s             15  7                                            BUG9393 242286
     d int6dy          s             15  9                                                    242286
                                                                                             BUG9393
     d wBasis          s              3  0                                                   BUG9393
     d wLoanPrd        s              8f                                                     BUG9393
     d wDiscRate       s              8f                                                     BUG9393
 
     d extrid          ds
     d**dealNo**                      6s 0                                                    CLE148
     d  dealNo                        6A                                                      CLE148
 
     d                 ds
     d exfcus
     d exftyp
     d exfcno
     d*exfcusN**                      6s 0 overlay(exfcus)                                   CSD027A
     d exfcusN                        6    overlay(exfcus)                                   CSD027A
     d exftypN                        3s 0 overlay(exftyp)
     d exfcnoN                        2s 0 overlay(exfcno)
 
     d fcltyFound      s               n
 
     d kExsub          s                   like(exsub)
     d                                     inz('LOAN')
 
     d CRN002          s               n
     d CRN006          s               n
 
     d negFracPwr      c                   00101                                            BUG10335
     d divByZero       c                   00102                                             BUG9393
     d dupKey          c                   01021
 
     d rtnProduct      s                   like(product)
     d rtnPrdclaUS     s                   like(prdclaus)
 
      * Deal types handled by this extract.
     d aTrty           s                   like(extrty)
     d                                     dim(13) ctdata perrcd(1)
     d ixTrty          s              3u 0
 
     d mmFixed         s               n
 
     d bsrtExtnFound   s               n
 
     d loanExtnFound   s               n
 
     d pstduFound      s               n
 
      * Parameters for RNPRODMAP
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
 
     d pstDuVdat       s                   like(la#vdat)
 
     d*eligible********s                   like(lx#eligible)                                BUG9828R
 
     d brtt            s                   like(bx#babsrc)
 
     d w_maturity      s                   like(exmdat)                         work field
 
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
 
     c     Kbase         klist
     c                   kfld                    excycd
     c                   kfld                    brtt
 
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
 
      * Check if record is to be extracted.
     c                   eval      rgIx = %lookup(exbrch:aBrcd:1:rgEl)
     c                   if        (   rgIx        >  0
     c                             and aNxDt(rgIx) <= evtDatIso )
 
 
      * Get Product Code.
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
 
     c                   exsr      getLoan
 
     c                   exsr      getFclty
 
      * Get customer details.
     c                   eval      pKey1       = excusn
     c                   exsr      getCust
 
      * Get Past Due detail
     c                   exsr      getPastDueRec
 
      * Get Loan Extension record
     c                   exsr      getLoanExtn
 
      * Get Base Rate Extension record
     c                   exsr      getBasRatExtn
 
      ** Risk Loans:
      ** output to guarantee and guarantee amount tables.
 
     c                   if        (   l#ptyp  = 70
     c                             or  l#ptyp  = 71
     c                             or  l#ptyp  = 72 )
     c                   clear                   t__guarant
     c                   clear                   t__guaamo
 
     c                   exsr      commonFlds
 
     c                   exsr      guarantRec
     c                   exsr      guaamoRec
 
      ** Non-risk.
     c                   else
     c                   clear                   t__loandep
     c                   clear                   t__lodamo
 
     c                   if        CRN002
     c                   clear                   t__loadepa
     c                   endif
     c                   if        CRN006
     c                   clear                   t__loadepu
     c                   endif
 
     c                   exsr      commonFlds
 
     c                   exsr      loandepRec
 
     c                   if        CRN002
     c                   exsr      loadepaRec
     c                   endif
     c                   if        CRN006
     c                   exsr      loadepuRec
     c                   endif
 
     c                   exsr      lodamoRec
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine that assigns common field values                  *
      *                                                               *
      *****************************************************************
     c     commonFlds    begsr
 
     c                   eval      product     = rtnProduct
     c                   eval      statusl2    = 5
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on
 
     c                   eval      deal        = rnDayCnv(exddat)
 
      * Maturity date.
     c                   select
     c                   when      exmdat     <> 0
     c                   eval      w_maturity  = exmdat
 
     c                   when         l#nidt   > 0                              next interest date
     c                             or l#nrod   > 0                              next rollover date
     c                             or l#nrpd   > 0                              next repayment date
 
      ** get the greater of l#nidt, l#nrod or l#nrpd.
     c                   if        l#nidt      > l#nrod
     c                   eval      w_maturity  = l#nidt
     c                   else
     c                   eval      w_maturity  = l#nrod
     c                   endif
     c                   if        w_maturity <= l#nrpd
     c                   eval      w_maturity  = l#nrpd
     c                   else
     c                   eval      w_maturity  = w_maturity + 1
     c                   endif
 
     c                   other
      ** get the greater of extraction date (extdat) or value date (exvdat).
     c                   if        extdat      > exvdat
     c                   eval      w_maturity  = extdat + 1
     c                   else
     c                   eval      w_maturity  = exvdat + 1
     c                   endif
 
     c                   endsl
     c                   eval      maturity    = rnDayCnv(w_maturity)
 
     c                   eval      counref     = bbbrcd
     c                                         + '-'
     c                                         + excusn
 
     c                   eval      pKey1       = exfcus
     c                   exsr      getCust
     c                   eval      limiref     = bbbrcd
     c                                         + '-'
     c                                         + exfcus
     c                                         + exftyp
     c                                         + exfcno
 
     c                   eval      sourref     = pZone
 
      * Position ref.
     c                   eval      posiref     = exbrch
     c                                         + 'LE'
     c                                         + extrid
 
      * Contract ref.
     c                   eval      contref     = posiref
 
     c                   eval      pKey1       = exbicn
     c                   exsr      getCust
     c                   eval      intparre    = bbbrcd
     c                                         + '-'
     c                                         + exbicn
 
     c                   if        loanExtnFound
     c                   move      lx#loclfund   locafund
     c                   eval      portfoli    = lx#portfolo
     c                   eval      purpose     = lx#purposet
     c**********         eval      eligiblt    = lx#eligible                        BUG9828 BUG9828R
     c                   eval      eligible    = lx#eligible                                BUG9828R
     c                   else                                                                BUG9828
     c                   move      *blanks       locafund                                    BUG9828
     c                   eval      portfoli    = *zeros                                      BUG9828
     c                   eval      purpose     = *zeros                                      BUG9828
     c**********         eval      eligiblt    = *zeros                             BUG9828 BUG9828R
     c                   eval      eligible    = *zeros                                     BUG9828R
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  loandepRec - Subroutine that writes records to RN_LOANDEP.   *
      *                                                               *
      *****************************************************************
     c     loandepRec    begsr
 
     c                   eval      numberof    = 1
 
     c                   eval      lastroll    = rnDayCnv(l#rldt)
 
     c                   if        l#ormd <> 0
     c                   eval      earlrede    = rnDayCnv(exmdat)
     c                   endif
 
     c                   eval      lasintda    = rnDayCnv(l#dlrc)
 
     c                   if           exnidt  <> 0
     c                             or exnpdt  <> 0
 
     c                   if           exnidt   < exnpdt
     c                             and exnidt <> 0
     c                   eval      nextsett    = rnDayCnv(exnidt)
     c                   else
 
     c                   if        exnpdt     <> 0
     c                   eval      nextsett    = rnDayCnv(exnpdt)
     c                   else
     c                   eval      nextsett    = rnDayCnv(exnidt)
     c                   endif
 
     c                   endif
 
     c                   endif
 
     c                   eval      nextroll    = rnDayCnv(l#nrod)
     c                   if        exrate      = 'F'                                        bug10168
     c                   eval      nexintfi    = *blanks                                    bug10168
     c                   else                                                               bug10168
     c                   eval      nexintfi    = nextroll
     c                   endif                                                              bug10168
     c                   eval      intstar     = rnDayCnv(exvdat)
     c                   eval      intend      = rnDayCnv(exmdat)
     c                   eval      settleme    = rnDayCnv(exnidt)
 
     c                   if        pstDuFound
     c                   eval      dtepastd    = rnDayCnv(pstDuVdat)
     c                   endif
 
     c                   eval      boocntre    = pZone
     c                                         + exbook
 
     c                   eval      original    = w_maturity
     c                                         - exvdat
 
     c                   eval      remainin    = w_maturity
     c                                         - extdat
     c                   if        remainin    < 0
     c                   eval      remainin    = 0
     c                   endif
 
     c                   eval      oriintra    = l#oinr
     c                   if        exintr     <> 0                                          BUG10909
     c                   eval      perintra    = exintr
     c                   eval      intintra    = exintr
     c                   else                                                               BUG10909
     c                   eval      perintra    = exrtsp                                     BUG10909
     c                   eval      intintra    = exrtsp                                     BUG10909
     c                   endif                                                              BUG10909
 
      * Reimbursement frequency
     c                   select
     c                   when      (   l#ipfr  = 'M'
     c                             or  l#ipfr  = 'N' )
     c                   eval      reimfreq    = 12
     c                   when      l#ipfr      = 'Q'
     c                   eval      reimfreq    = 4
     c                   when      l#ipfr      = 'X'
     c                   eval      reimfreq    = 2
     c                   when      l#ipfr      = 'Y'
     c                   eval      reimfreq    = 1
     c                   endsl
 
     c                   if        (    l#ptyp = 63
     c                               or l#ptyp = 65
     c                               or l#ptyp = 67 )
     c                   exsr      calcYield                                                 BUG9393
     c*****                        and l#cpam <> l#toti                                      BUG9393
     c*****              eval(h)   yield       = l#cpam                                      BUG9393
     c*****                                    / (l#cpam - l#toti)                           BUG9393
     c                   endif
 
     c                   eval      spread      = exrtsp
 
     c                   if        expali      = 'A'
     c                   eval      alindi      = 1
     c                   else
     c                   eval      alindi      = 2
     c                   endif
 
     c                   if        exddat      = extdat
     c                   eval      contract    = 1
     c                   else
     c                   eval      contract    = 2
     c                   endif
 
      * Reference Rate Type
     c                   if        exrate  =  'V'
     c                             and bsrtExtnFound
     c                   eval      referate    = bx#refrattp
     c                   endif
 
      * Interest Day Count Basis
     c                   select
     c                   when      l#icbs      = 1
     c                   eval      indacoba    = 15
     c                   when      l#icbs      = 2
     c                   eval      indacoba    = 2
     c                   when      l#icbs      = 3
     c                   eval      indacoba    = 5
 
      ******O/S*** no values provided for 4,5,6 yet.
     c******O/S***       when      l#icbs      = 4
     c******O/S***       eval      indacoba    = ???
     c******O/S***       when      l#icbs      = 5
     c******O/S***       eval      indacoba    = ???
     c******O/S***       when      l#icbs      = 6
     c******O/S***       eval      indacoba    = ???
     c                   when      l#icbs      = 4                                          BUG11435
     c                   eval      indacoba    = 16                                         BUG11435
     c                   when      l#icbs      = 5                                          BUG11435
     c                   eval      indacoba    = 17                                         BUG11435
     c                   when      l#icbs      = 6                                          BUG11435
     c                   eval      indacoba    = 18                                         BUG11435
     c                   when      l#icbs      = 7                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
     c                   when      l#icbs      = 8                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
     c                   other                                                              BUG11435
     c                   eval      indacoba    = 0                                          BUG11435
     c                   endsl
 
     c                   eval      amortisa    = 4
     c                   eval      listed      = 0                                          BUG10804
     c                   eval      reschedu    = 2
     c                   eval      risquain    = 1
 
      * Interest Rate Type
     c                   if        exrate   = 'F'
     c                   eval      typintra    = 1
     c                   else
     c                   eval      typintra    = 2
     c                   endif
 
     c                   eval      intpayfr    = reimfreq
     c                   eval      thirindi    = 1
 
     c                   if        f#rvcr  = 'Y'
     c                   eval      revofac     = 1
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
 
      ** Test bit '4'
     c                   testb     '4'           l#loni               20
 
      ** Bit '4' is on
     c                   if        Not *in20
     c                   eval      intsusp     = 1
     c                   endif
 
     c                   if        loanExtnFound
     c                   eval      liquifya    = lx#liquifab
     c**********         eval      eligible    = lx#eligible                                 BUG9828
     c                   else                                                                BUG9828
     c                   eval      liquifya    = *zeros                                      BUG9828
     c                   endif
 
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
 
     c                   if        loanExtnFound
     c                   eval      fdicins     = lx#fdicinsr
     c                   eval      smbus       = lx#smallbus
     c                   eval      offbal      = lx#offbalan
     c                   eval      othacccl    = lx#othraccl
     c                   eval      fiduciar    = lx#fiduind
     c                   eval      accrual     = lx#accrind
     c                   else                                                                BUG9828
     c                   eval      fdicins     = *zeros                                      BUG9828
     c                   eval      smbus       = *zeros                                      BUG9828
     c                   eval      offbal      = *zeros                                      BUG9828
     c                   eval      othacccl    = *zeros                                      BUG9828
     c                   eval      fiduciar    = *zeros                                      BUG9828
     c                   eval      accrual     = *zeros                                      BUG9828
     c                   endif
 
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
 
      * Output 3 records:
      *---------------
      * 1) Book value.
 
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
 
     c                   if        expdci      = 0
     c                   eval      dcindi      = 1
     c                   else
     c                   eval      dcindi      = 2
     c                   endif
 
      * Get currency details.
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
     c                   eval      value       = rnDayCnv(bjrdnb)
 
     c                   write     t__lodamo
 
     c                   exsr      wrtAudit
 
      ** ---------------------
      ** 2) Original cost.
 
      ***get*original*principal*amount*from*file*CLOANCK*********************               BUG10335
     c*****dealNo        chain     cloanckf                                                 BUG10335
     c**********         if        not %found                                               BUG10335
     c**********         eval      wDbFile     = 'CLOANCK'                                  BUG10335
     c**********         eval      wDbase      = 8                                          BUG10335
     c**********         eval      wDbKey      = %char( dealNo )                            BUG10335
     c**********         exsr      *pssr                                                    BUG10335
     c**********         endif                                                              BUG10335
 
     c                   eval(h)   ocaamunt    = l#opam/(10**a6nbdp)
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 26
 
     c                   write     t__lodamo
 
     c                   exsr      wrtAudit
 
      *---------------------
      * 3) Accrued Interest.
 
     c                   if        exaacc     <> *blanks
     c                   if        exaref      = '1'
     c                   eval      glref       = exbrch
     c                                         + exbicn
     c                                         + excycd
     c                                         + exaacc                         accrued int ac code
     c                                         + exacsq
     c                   else
     c                   eval      glref       = exbrch
     c                                         + excusn
     c                                         + excycd
     c                                         + exaacc                         accrued int ac code
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
      *  Subroutine that writes records to RN_GUARANT                 *
      *                                                               *
      *****************************************************************
     c     guarantRec    begsr
 
     c                   eval      value       = rnDayCnv(exvdat)
 
     c                   eval      pKey1       = exbicn
     c                   exsr      getCust
     c                   eval      issuref     = bbbrcd
     c                                         + '-'
     c                                         + exbicn
 
     c                   if        l#ptyp      = 70
     c                   eval      originv     = 1
     c                   else
     c                   eval      originv     = 2
     c                   endif
 
     c                   write     t__guarant
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine that writes records to RN_GUAAMO.                 *
      *                                                               *
      *****************************************************************
     c     guaamoRec     begsr
 
      * Output 2 records:
      *---------------
      * 1) Book value.
 
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
 
     c                   if        expdci      = 0
     c                   eval      dcindi      = 1
     c                   else
     c                   eval      dcindi      = 2
     c                   endif
 
      * Get currency details.
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
     c                   eval      value       = rnDayCnv(bjrdnb)
 
     c                   write     t__guaamo
 
     c                   exsr      wrtAudit
 
      ** --------------
      ** 2) Face value.
 
     c                   eval      typamunt    = 3
 
     c                   write     t__guaamo
 
     c                   exsr      wrtAudit
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getLoan - Subroutine that retrieves loan details.            *
      *                                                               *
      *****************************************************************
     c     getLoan       begsr
 
     c     dealNo        chain     cloanclf
     c                   if        not %found
     c                   eval      wDbFile     = 'CLOANCL'
     c                   eval      wDbase      = 2
     c**********         eval      wDbKey      = %char( dealNo )                              CLE148
     c                   eval      wDbKey      = dealNo                                       CLE148
     c                   exsr      *pssr
     c                   endif
                                                                                            BUG10335
     c     dealNo        chain     cloanckf                                                 BUG10335
     c                   if        not %found                                               BUG10335
     c                   eval      wDbFile     = 'CLOANCK'                                  BUG10335
     c                   eval      wDbase      = 8                                          BUG10335
     c**********         eval      wDbKey      = %char( dealNo )                     BUG10335 CLE148
     c                   eval      wDbKey      = dealNo                                       CLE148
     c                   exsr      *pssr                                                    BUG10335
     c                   endif                                                              BUG10335
 
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
 
     c                   if        not %found
     c                   eval      wDbFile      = 'FCLTY'
     c                   eval      wDbase       =  7
     c**********         eval      wDbKey       = %char(ExfcusN)                             CSD027A
     c                   eval      wDbKey       = ExfcusN                                    CSD027A
     c                                          + '-'
     c                                          + %char(exftypN)
     c                                          + '-'
     c                                          + %char(exfcnoN)
     c                   exsr      *pssr
     c                   endif
 
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
      *  getPastDueRec   - Retrieves past due record                  *
      *                                                               *
      *****************************************************************
     c     getPastDueRec begsr
 
     c                   eval      pstDuFound = *off
 
     c     l#lnrf        setgt     loamsdkf
     c     l#lnrf        readpe    loamsdkf
     c                   dow       not %eof
     c
     c                   if        la#amtp = 'PD' and
     c                             %date(rnDayCnv(la#vdat)) <= runDatIso
     c                   eval      pstDuFound = *on
     c                   eval      pstDuVdat = la#vdat
     c                   leave
     c                   endif
 
     c     l#lnrf        readpe    loamsdkf
     c                   enddo
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getLoanExtn   - Retrieves loan extension record              *
      *                                                               *
      *****************************************************************
     c     getLoanExtn   begsr
 
     c     la#lnrf       chain     t_rnclip
     c                   eval      loanExtnFound = %found
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getBasRatExtn   - Retrieves base rate extension record       *
      *                                                               *
      *****************************************************************
     c     getBasRatExtn begsr
 
     c                   eval      brtt = %char(l#brtt)
     c     Kbase         chain     t_rnbsrt
     c                   eval      bsrtExtnFound = %found
 
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
     c                   parm                    I#DealType
     c                   parm                    I#DealSubType
     c                   parm      extrty        I#LoanType
     c                   parm      extrst        I#LoanSubType
     c                   parm      exftyp        I#FacilityType
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
     c                   eval      wDbase      = 1
     c                   eval      wDbkey      = I#LoanType
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
     c     rtnPrdclaUS   parm                    O#Product
     c                   parm                    O#CntOfClauses
 
 
      ** If not found, issue a database error
     c                   if        pRtnCod <> *blanks
     c                   eval      wDbfile     = 'T_FRSMAPR'
     c                   eval      wDbase      = 9
     c                   eval      wDbkey      = I#LoanType
     c                   exsr      *pssr
     c                   endif
 
     c                   if        rtnPrdclaUS < 0
     c                   eval      rtnPrdclaUS = 0
     c                   endif
 
     c                   endsr
                                                                                             BUG9393
      *****************************************************************                      BUG9393
      /EJECT                                                                                 BUG9393
      *****************************************************************                      BUG9393
      *                                                               *                      BUG9393
      *  Calculate Yield                                              *                      BUG9393
      *                                                               *                      BUG9393
      *****************************************************************                      BUG9393
     c     calcYield     begsr                                                               BUG9393
                                                                                             BUG9393
      * Store basis.                                                                         BUG9393
     c                   select                                                              BUG9393
     c                   when      (   l#icbs  = 2                                           BUG9393
     c                             or  l#icbs  = 3                                           BUG9393
     c                             or  l#icbs  = 5 )                                         BUG9393
     c                   eval      wBasis      = 360                                         BUG9393
                                                                                             BUG9393
     c                   when      (   l#icbs  = 1                                           BUG9393
     c                             or  l#icbs  = 4 )                                         BUG9393
     c                   eval      wBasis      = 365                                         BUG9393
                                                                                             BUG9393
     c                   when      l#icbs      = 6                                           BUG9393
     c                   eval      wBasis      = 366                                         BUG9393
                                                                                             BUG9393
     c                   other                                                               BUG9393
     c                   eval      wDbase      =  6                                          BUG9393
     c                   eval      wDbKey      = %char(l#icbs)                               BUG9393
     c                   exsr      *pssr                                                     BUG9393
     c                   endsl                                                               BUG9393
                                                                                             BUG9393
      * Get number of interest days.                                                         BUG9393
     c                   eval      zzcalc      = %char(l#icbs)                               BUG9393
     c                   callb     'ZINTDY'                                                  BUG9393
     c                   parm      *blanks       retCode10                                   BUG9393
     c                   parm      *zero         zzindy                                      BUG9393
     c                   parm      exvdat        zzbeg                                       BUG9393
     c                   parm      exmdat        zzend                                       BUG9393
     c                   parm                    zzcalc                                      BUG9393
     c                   parm      *zero         int6dy                                      BUG9393
                                                                                             BUG9393
     c                   if        retCode10  <> *blanks                                     BUG9393
     c                   eval      wDbase      =  10                                         BUG9393
     c                   eval      wDbmod      = 'ZINTDY'                                    BUG9393
     c                   exsr      *pssr                                                     BUG9393
     c                   endif                                                               BUG9393
                                                                                             BUG9393
      * Store loan period.                                                                   BUG9393
     c                   eval      wLoanPrd    = zzindy / wBasis                             BUG9393
                                                                                             BUG9393
     c                   monitor                                                             BUG9393
 
      * Store discount rate.                                                                 BUG9393
     c                   eval      wDiscRate   = ((                                          BUG9393
     c                                             (l#opam/(l#opam-l#toti))                  BUG9393
     c                                               ** (1/wLoanprd)                         BUG9393
     c                                            )                                          BUG9393
     c                                            - 1                                        BUG9393
     c                                           )                                           BUG9393
     c                                           * 100                                       BUG9393
                                                                                             BUG9393
     c                   eval(h)   yield       = (wBasis * 100 * wDiscRate)                  BUG9393
     c                                         / ((wBasis * 100)                             BUG9393
     c                                            - (wDiscRate * wLoanPrd))                  BUG9393
                                                                                             BUG9393
     c                   on-error  negFracPwr                                               BUG10335
     c                   on-error  divByZero                                                 BUG9393
     c                   endmon                                                              BUG9393
                                                                                             BUG9393
     c                   endsr                                                               BUG9393
                                                                                             BUG9393
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
     c                                         + 'LE'
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
 
      * Get zone.
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
 
      * Get bank details.
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
 
      * Check if enhancement CRN002 is on
 
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
 
      * Check if enhancement CRN006 is on
 
     c                   callb     'AOSARDR0'
     c                   parm      *blanks       pRtnCod
     c                   parm      '*VERIFY'     pOption
     c                   parm      'CRN006'      pSar
 
     c                   if        pRtnCod     = *blank
     c                   eval      CRN006      = *on
 
     c                   elseif    pRtnCod     = '*NRF'
     c                   eval      CRN006      = *off
 
     c                   else
     c                   eval      wDbase      = 3
     c                   eval      wDbmod      = 'AOSARDR0'
     c                   exsr      *pssr
     c                   endif
 
      ** Feature CRN002 is present
     c                   if        CRN002
     c                   open      rn_loadepa
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
 
**ctdata CPY@
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
