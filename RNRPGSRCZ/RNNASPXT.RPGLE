     h debug   alwnull(*usrctl)
     h fixnbr(*zoned : *inputpacked)
     h copyright('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Negotiable Assets Purchased extract')        *
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNNASPXT   - Midas FRS Negotiable Assets Purchased Extract   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CGL165             Date 23Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11435           Date 06Jun06               *
      *                 CSD027A            Date 10May06               *
      *                 BUG10804           Date 10Mar06               *
      *                 BUG10544           Date 20Feb06               *
      *                 BUG9828            Date 15Feb06               *
      *                 BUG10168           Date 13Feb06               *
      *                 BUG10501           Date 09Feb06               *
      *                 CRN001  *Create    Date 30Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  BUG11435 - Follow up issue 21. Add more mapping for INDACOBA.*
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  BUG10804 - RN_SECURIT format has changed for FRS Data        *
      *             Foundation 2.9.3. Remove deleted fields.          *
      *  BUG10544 - Position should not be 0 in Security_APJ table.   *
      *  BUG9828 - T__SECUUS format changed - recompile.              *
      *  BUG10168 - In Security table, the Next Interest Repricing/   *
      *             Fixing date should be blank since NASP deals have *
      *             fixed interest rate.                              *
      *  BUG10501 - Parameter value '*DBERR' is not correct for       *
      *             access object running in CoB.                     *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     fmrtrapl0  if   e           k disk    infsr(*pssr)
 
     fgpregbj0  if   e           k disk    infsr(*pssr)
 
     ft_rnnasp  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnnasp:t_rnnaspf)
 
     fdeals     if   e           k disk    infsr(*pssr)
     f                                     include(dealsddf)
     f                                     prefix(d#)
 
     ffclty     if   e           k disk    infsr(*pssr)
     f                                     include(fcltyfmf)
     f                                     prefix(f#)
 
     ft__dfboo  if a e           k disk    infsr(*pssr)
     f                                     rename(t__dfboo:t__dfboof)
 
     frn_securito    e             disk    infsr(*pssr)
 
     frn_secuus o    e             disk    infsr(*pssr) usropn
 
     frn_secuapjo    e             disk    infsr(*pssr) usropn
 
     frn_secamo o    e             disk    infsr(*pssr)
 
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
     d wkFval          s             28  8
 
     d extrid          ds
     d  dealNo                        6s 0
 
     d                 ds
     d exfcus
     d exftyp
     d exfcno
     d*exfcusN**                      6s 0 overlay(exfcus)                                   CSD027A
     d exfcusN                        6    overlay(exfcus)                                   CSD027A
     d exftypN                        3s 0 overlay(exftyp)
     d exfcnoN                        2s 0 overlay(exfcno)
 
     d fcltyFound      s               n
     d rnExtFound      s               n
 
     d kExsub          s                   like(exsub)
     d                                     inz('NASP')
 
     d CRN002          s               n
     d CRN006          s               n
 
     d dupKey          c                   01021
 
     d rtnProduct      s                   like(product)
     d rtnPrdclaUS     s                   like(prdclaus)
 
      ** Deal types handled by this extract.
     d aTrty           s                   like(extrty)
     d                                     dim(7) ctdata perrcd(1)
     d ixTrty          s              3u 0
 
     d mmFixed         s               n
 
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
 
     c                   exsr      getNaspE
 
      ** Get customer details.
     c                   eval      pKey1       = excusn
     c                   exsr      getCust
 
     c                   clear                   t__securit
     c                   if        CRN002
     c                   clear                   t__secuapj
     c                   endif
 
     c                   if        CRN006
     c                   clear                   t__secuus
     c                   endif
 
     c                   clear                   t__secamo
 
     c                   exsr      securitRec
 
     c                   if        CRN002
     c                   exsr      secuapjRec
     c                   endif
 
     c                   if        CRN006
     c                   exsr      secuusRec
     c                   endif
 
     c                   exsr      secamoRec
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  securitRec - Subroutine that writes records to RN_SECURIT.   *
      *                                                               *
      *****************************************************************
     c     securitRec    begsr
 
     c                   eval      rowid       = 0
     c                   eval      statusl2    = 5
     c                   eval      modfdate    = *blanks
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on
     c                   eval      rowtype     = 0
     c                   eval      deal        = rnDayCnv(exddat)
     c                   eval      earlrede    = *blanks
     c                   eval      maturity    = rnDayCnv(exmdat)
     c                   eval      nextsett    = rnDayCnv(exnidt)
      ** Since the NASP deal always has fixed interest rate, the next interest              BUG10168
      ** repricing/fixing date should be blank.                                             BUG10168
     c******             eval      nexintfi    = rnDayCnv(exnidt)                           BUG10168
     c                   eval      intstar     = rnDayCnv(exvdat)
     c                   eval      intend      = rnDayCnv(exmdat)
     c                   eval      issue       = *blanks
     c                   eval      settleme    = rnDayCnv(exnidt)
     c                   eval      boocntre    = pZone
     c                                         + exbook
     c                   eval      issuref     = bbbrcd
     c                                         + '-'
     c                                         + excusn
 
     c**********         eval      pKey1       = %editc(d#cnum: 'X')                         CSD027A
     c                   eval      pKey1       = d#cnum                                      CSD027A
     c                   exsr      getCust
     c                   eval      counref     = bbbrcd
     c                                         + '-'
     c                                         + d#cnum                                      CSD027A
     c**********                               + %editc(d#cnum: 'X')                         CSD027A
     c                   eval      custref     = *blanks
     c                   eval      limiref     = *blanks
     c                   eval      sourref     = pZone
     c                   eval      posiref     = exbrch
     c                                         + 'DL'
     c                                         + extrid
     c                   eval      markref     = *blanks
     c                   eval      reporef     = *blanks
     c                   eval      contref     = exbrch
     c                                         + 'DL'
     c                                         + extrid
     c                   eval      priciden    = *blanks
     c                   eval      isin        = d#rnna
     c                   eval      intcodre    = exbrch
     c                                         + 'DL'
     c                                         + extrid
 
     c                   eval      pKey1       = exbicn
     c                   exsr      getCust
     c                   eval      intparre    = bbbrcd
     c                                         + '-'
     c                                         + exbicn
     c                   eval      deriref     = *blanks
     c                   eval      inteone     = *blanks
     c                   eval      intetwo     = *blanks
     c                   eval      original    = exmdat - exvdat
     c                   eval      remainin    = exmdat - extdat
     c                   if        remainin    < 0
     c                   eval      remainin    = 0
     c                   endif
     c                   eval      ccf         = 0
     c**********         eval      lgd         = 0                                          BUG10804
     c**********         eval      effelgd     = 0                                          BUG10804
     c**********         eval      expohct     = 0                                          BUG10804
     c**********         eval      effemat     = 0                                          BUG10804
     c                   eval      minhold     = 0
     c                   eval      perintra    = exintr
     c                   eval      intintra    = 0
     c                   eval      ownershi    = 0
     c                   eval      votingri    = 0
     c                   eval      oriintra    = 0
     c                   eval      product     = rtnProduct
 
     c                   if        d#pcli      = 'P'
     c                   eval      numberof    = d#nsdd
     c                   else
     c                   eval      numberof    = 1
     c                   endif
 
     c                   select
     c                   when      d#ipfr = 'M'
     c                             or d#ipfr = 'N'
     c                   eval      reimfreq    = 12
     c                   eval      intpayfr    = 12
     c                   when      d#ipfr = 'Q'
     c                   eval      reimfreq    = 4
     c                   eval      intpayfr    = 4
     c                   when      d#ipfr = 'X'
     c                   eval      reimfreq    = 2
     c                   eval      intpayfr    = 2
     c                   when      d#ipfr = 'Y'
     c                   eval      reimfreq    = 1
     c                   eval      intpayfr    = 1
     c                   endsl
 
     c                   eval      moddura     = 0
     c                   eval      duration    = 0
     c                   eval      yield       = exyldr
     c                   eval      intretra    = 0
     c                   eval      spread      = exrtsp
     c                   eval      aarinte     = 0
     c                   eval      aprcinte    = 0
     c                   eval      cdryinte    = 0
     c                   eval      avgweig     = 0
     c                   eval      deductio    = 0
     c                   eval      originv     = 0
     c**********         eval      secexp      = 0                                          BUG10804
     c                   eval      asseback    = 0
     c                   eval      accrinte    = 0
     c                   eval      bsindi      = 1
     c                   eval      contcomm    = 0
     c                   eval      contract    = 0
     c                   eval      converti    = 0
     c                   eval      entrtype    = 0
     c                   eval      referate    = 0
     c                   eval      ifrvalme    = 0
      ** Interest Day Count Basis
     c**********         eval      indacoba    = 0                                          BUG11435
     c                   select                                                             BUG11435
     c                   when      d#icbs      = 1                                          BUG11435
     c                   eval      indacoba    = 15                                         BUG11435
     c                   when      d#icbs      = 2                                          BUG11435
     c                   eval      indacoba    = 2                                          BUG11435
     c                   when      d#icbs      = 3                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
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
     c                   endsl                                                              BUG11435
                                                                                            BUG11435
     c                   eval      listed      = 0
 
     c                   if        rnExtFound
     c                   move      loclfund      locafund
     c                   eval      purpose     = purposet
     c                   eval      portfoli    = portfolo
     c                   endif
 
     c                   eval      rediscou    = 0
     c                   eval      reschedu    = 2
     c                   eval      risquain    = 0
     c                   eval      subordin    = 0
     c                   eval      valuindi    = 0
     c                   eval      typintra    = 1
     c                   eval      valumeth    = 0
     c                   eval      votirigh    = 0
     c                   eval      nettagre    = 0
     c                   eval      marketab    = 1
     c                   eval      repfixe     = 0
     c                   eval      thirindi    = 0
     c                   eval      securiti    = 0
     c                   eval      pledged     = 0                                          BUG10804
     c                   eval      issucty     = *blanks                                    BUG10804
 
     c                   write     t__securit
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  secuapjRec - Subroutine that writes records to RN_SECUAPJ.   *
      *                                                               *
      *****************************************************************
     c     secuapjRec    begsr
 
     c                   eval      rowid       = 0
     c                   eval      statusl2    = 5
     c                   eval      modfdate    = *blanks
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      rowtype     = 0
     c                   eval      inteone     = *blanks
     c                   eval      intetwo     = *blanks
     c                   eval      posiref     = exbrch
     c                                         + 'DL'
     c                                         + extrid
     c                   eval      intsusp     = 0
 
     c                   if        rnExtFound
     c                   eval      liquifya    = liquifab
     c                   eval      parofse     = partsett
     c                   endif
 
     c*****              eval      position    = 0                                          BUG10544
     c                   eval      position    = 12                                         BUG10544
 
     c                   if        d#iscn = d#cnum
     c                   eval      prisecma    = 1
     c                   else
     c                   eval      prisecma    = 2
     c                   endif
 
     c                   write     t__secuapj
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  secuusRec - Subroutine that writes records to RN_SECUUS.     *
      *                                                               *
      *****************************************************************
     c     secuusRec     begsr
 
     c                   if        rnExtFound
     c                   eval      offbal      = offbalan
     c                   eval      othacccl    = othraccl
     c                   eval      fiduciar    = fiduind
     c                   eval      accrual     = accrind
     c                   endif
 
      ** Get US product Code.
     c                   exsr      getProdCodeUS
     c                   eval      prdclaus    = rtnPrdclaUS
 
     c                   write     t__secuus
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  secamoRec - Subroutine that writes records to RN_SECAMO.     *
      *                                                               *
      *****************************************************************
     c     secamoRec     begsr
 
     c                   eval      rowid       = 0
     c                   eval      statusl2    = 5
     c                   eval      modfdate    = *blanks
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      rowtype     = 0
     c                   eval      posiref     = exbrch
     c                                         + 'DL'
     c                                         + extrid
 
     c                   if        expacc     <> *blanks
     c                   if        expref      = '1'
     c                   eval      glref       = exbrch
     c                                         + exbicn
     c                                         + excycd
     c                                         + expacc
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
     c                   eval      contref     = exbrch
     c                                         + 'DL'
     c                                         + extrid
     c                   eval      scenfk      = 0
 
      ** Get currency details.
     c                   eval      pCcy        = excycd
     c                   exsr      getCcy
 
     c                   eval      isocurr     = excycd
     c                   eval      value       = rnDayCnv(extdat)
 
      ** Output 6 records:
      ** -----------------
      ** 1) Book value.
 
     c                   if        expdci      = 0
     c                   eval      dcindi      = 1
     c                   else
     c                   eval      dcindi      = 2
     c                   endif
 
     c                   eval      ocaamunt    = expamt
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 1
 
     c                   write     t__secamo
 
     c                   exsr      wrtAudit
 
      ** -------------------------------------------
      ** 6) Average balance (similar to Book value).
 
     c                   eval      typamunt    = 64
 
     c                   write     t__secamo
 
     c                   exsr      wrtAudit
 
      ** ---------------------
      ** 2) Face value.
 
     c                   eval(h)   WkFval      = d#fval/(10**a6Nbdp)
     c                   eval      ocaamunt    = WkFval
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 3
 
     c                   write     t__secamo
 
     c                   exsr      wrtAudit
 
      ** ---------------------
      ** 3) Accrued Interest.
 
     c                   if        exaacc     <> *blanks
     c                   if        exaref      = '1'
     c                   eval      glref       = exbrch
     c                                         + exbicn
     c                                         + excycd
     c                                         + exaacc
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
 
     c                   write     t__secamo
 
     c                   exsr      wrtAudit
 
      ** ---------------------
      ** 4) Original Cost.
 
     c                   if        expacc     <> *blanks
     c                   if        expref      = '1'
     c                   eval      glref       = exbrch
     c                                         + exbicn
     c                                         + excycd
     c                                         + expacc
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
 
     c                   eval(h)   WkFval      = d#opup/(10**a6Nbdp)
     c                   eval      ocaamunt    = WkFval
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 26
 
     c                   write     t__secamo
 
     c                   exsr      wrtAudit
 
      ** ---------------------
      ** 5) Market Value.
 
      ** Get currency details.
     c                   eval      pCcy        = bjcycd
     c                   exsr      getCcy
 
     c                   eval      isocurr     = bjcycd
     c                   eval      ocaamunt    = expmtb
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 8
 
     c                   write     t__secamo
 
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
 
     c     dealNo        chain     dealsddf
 
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
      *****************************************************************
      *                                                               *
      *  getNaspE  - Retrieves NASP Extension File                    *
      *                                                               *
      *****************************************************************
     c     getNaspE      begsr
 
     c     dealno        chain     t_rnnaspf
     c                   eval      rnExtFound  = %found
 
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
     c                   open      rn_secuapj
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
     c                   eval      wDbase      = 3
     c                   eval      wDbmod      = 'AOSARDR0'
     c                   exsr      *pssr
     c                   endif
 
      ** Feature CRN006 is present
     c                   if        CRN006
     c                   open      rn_secuus
     c                   endif
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      /copy rncpysrc,rnpssrsr
      *****************************************************************
 
**ctdata cpy@
(c) Misys International Banking Systems Ltd. 2004
**ctdata aTrty
C1
C2
BP
BD
TB
DA
TA
