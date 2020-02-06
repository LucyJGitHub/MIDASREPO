     h debug   alwnull(*usrctl)
     h fixnbr(*zoned : *inputpacked)
     h copyright('(c) Finastra International Limited 2005')

      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Foreign Exchange Extract')                   *
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNFXDLXT   - Midas FRS Foreign Exchange extract              *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Pret Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 10May06               *
      *                 BUG10804           Date 10Mar06               *
      *                 BUG10501           Date 09Feb06               *
      *                 BUG9978            Date 19Jan06               *
      *                 BUG9935            Date 17Jan06               *
      *                 CRN001  *Create    Date 20Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *            (Recompile)                                        *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  BUG10804 - RN_DERIVAT format has changed for FRS Data        *
      *             Foundation 2.9.3.                                 *
      *  BUG10501 - Parameter value '*DBERR' is not correct for       *
      *             access object running in CoB.                     *
      *  BUG9978- Correction to Position Reference                    *
      *  BUG9935- Missing book values                                 *
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
     f                                     include(dealsdbf)
     f                                     prefix(d#)

     ft_rnfxdl  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnfxdl:t_rnfxdlf)

     ffclty     if   e           k disk    infsr(*pssr)
     f                                     include(fcltyfmf)
     f                                     prefix(f#)

     frn_derivato    e             disk    infsr(*pssr)

     frn_derius o    e             disk    infsr(*pssr)  usropn

     frn_deramo o    e             disk    infsr(*pssr)

     frnaupnpd  o    e             disk    infsr(*pssr)
     frnxcpnpd  o    e             disk    infsr(*pssr)
     ft__dfboo  if a e           k disk    infsr(*pssr)
     f                                     rename(t__dfboo:t__dfboof)

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
     d dssdy         e ds
     d sdbank        e ds                  extname(sdbankpd)
     d sdgelr        e ds                  extname(sdgelrpd)
     d sdcurr        e ds                  extname(sdcurrpd)
     d sdcust        e ds                  extname(sdcustpd)

     d pRaid           s                   like(rbraid)
     d runDatIso       s               d
     d evtDatIso       s               d

     d pRtnCod         s              7
     d pOption         s              7
     d pKey1           s             10
     d pKyst           s              7
     d pCcy            s              3
     d psar            s              6
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
     d*exfcusN**                      6s 0 overlay(exfcus)                                   CSD027A
     d exfcusN                        6    overlay(exfcus)                                   CSD027A
     d exftypN                        3s 0 overlay(exftyp)
     d exfcnoN                        2s 0 overlay(exfcno)

     d fcltyFound      s               n

     d kExsub          s                   like(exsub)
     d                                     inz('FXDL')

     d lg1Extrid       s                   like(extrid)
     d lg1Exumtb       s                   like(exumtb)
     d lg1Exusgn       s                   like(exusgn)

     d CRN006          s               n

     d dupKey          c                   01021

     d rtnProduct      s                   like(product)
     d rtnPrdclaUS     s                   like(prdclaus)

      * Deal types handled by this extract.
     d aTrty           s                   like(extrty)
     d                                     dim(8) ctdata perrcd(1)

      * Used in plist RNPRODMAP
     d i#ERMS          s             30
     d i#AccountCode   s             10
     d i#DealType      s              2
     d i#DealSubType   s              6
     d i#LoanType      s              2
     d i#LoanSubType   s              6
     d i#FacilityType  s              3
     d i#SecuritySNam  s             10
     d i#InvestType    s              3
     d i#Institution   s              2
     d i#Industry      s              3
     d i#CtryCitizen   s              2
     d i#CtryLocation  s              2
     d i#Book          s              2
     d i#BankNonBank   s              1
     d i#AssetLiab     s              1
     d i#CollateralTy  s              5
     d o#Product       s             10  0
     d o#CntOfClauses  s              5  0

      /copy rncpysrc,rnrgaudfn

      /copy rncpysrc,rndaycnv
      /copy rncpysrc,rnamtcnv

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+
     c     kMrtrapNxt    klist
     c                   kfld                    kExsub
     c                   kfld                    extrid

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

      * There should be 2 records on mrtrappd for an fx deal; 1st for
      * purchase, 2nd for sale.

     c     kExsub        setll     mrtrapl0
     c     kExsub        reade     mrtrapl0
     c                   dow       not %eof

      * Check if record is to be extracted.
     c                   eval      rgIx = %lookup(exbrch:aBrcd:1:rgEl)
     c                   if        (   rgIx        >  0
     c                             and aNxDt(rgIx) <= evtDatIso )

      * Check transaction (deal) type.
     c                   if        %lookup(extrty : aTrty) > 0

      * Get Product Code.
     c                   exsr      getProdCode
     c                   select
     c                   when      rtnProduct  > 0
     c                   exsr      mapData

     c                   when      rtnProduct  < 0
     c                   exsr      wrtExcptn
     c     kMrtrapNxt    setgt     mrtrapl0
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

      * Get customer details.
     c                   eval      pKey1       = excusn
     c                   exsr      getCust

     c                   clear                   t__derivat
     c                   clear                   t__deramo

     c                   if        CRN006
     c                   clear                   t__derius
     c                   endif

     c                   if        extrty  = 'SW'
     c                   exsr      derivatRecSW
     c                   else
     c                   exsr      derivatRecOR
     c                   endif

     c                   if        CRN006
     c                   exsr      deriusRec
     c                   endif

     c                   if        extrty  = 'SW'
     c                   exsr      deramoMarSW
     c                   else
     c                   exsr      deramoMarOR
     c                   endif

     c                   exsr      deramoFac

      * If this is the 1st leg of a swap, retain details for the 2nd leg.
     c                   if        (   extrty  = 'SW'
     c                             and d#fsli   = 1  )
     c                   exsr      swap2ndLeg
     c                   endif

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  derivatRecSW - Subroutine that writes to RN_DERIVAT          *
      *                 For Swap deals                                *
      *                                                               *
      *****************************************************************
     c     derivatRecSW  begsr

      * Variations exist according to whether this is the 1st or 2nd leg,
      * d#fsli = 1 or 2.

     c                   eval      product     = rtnProduct
     c                   eval      statusl2    = 5
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on
     c                   eval      coverage    = 0                                          BUG10804
     c                   eval      valumeth    = 0                                          BUG10804
     c                   eval      funded      = 0                                          BUG10804
     c                   eval      deliveui    = 0                                          BUG10804

     c                   eval      deal        = rnDayCnv(exddat)

      * BS indicator
     c                   if        expali      = 'P'
     c                   eval      bsindi      = 1
     c                   else
     c                   eval      bsindi      = 2
     c                   end

      * Maturity date: for 1st leg of swap, set to value date of
      * the 2nd leg; £held in Option to Date field on 1st leg!]
     c                   if        d#fsli      = 1
     c                   eval      maturity    = rnDayCnv(d#otdt)
     c                   else
     c                   eval      maturity    = rnDayCnv(exmdat)
     c                   endif

     c                   eval      settleme    = rnDayCnv(exvdat)

     c                   eval      boocntre    = pZone
     c                                         + exbook

     c                   eval      counref     = bbbrcd
     c                                         + '-'
     c                                         + excusn

     c                   if        fcltyFound

      * Get facility customer details.
     c                   eval      pKey1       = exfcus
     c                   exsr      getCust

     c                   eval      limiref     = bbbrcd
     c                                         + '-'
     c                                         + exfcus
     c                                         + exftyp
     c                                         + exfcno
     c                   endif

     c                   eval      sourref     = pZone

      * Position ref.
     c                   eval      posiref     = exbrch
     c                                         + 'DL'
     c**********                               + extrid                                      BUG9978
     c                                         + %trimr(extrid)                              BUG9978
     c                                         + expali

      * Contract ref.
     c                   if        d#fsli      = 2
     c                   eval      contref     = exbrch
     c                                         + 'DL'
     c                                         + lg1Extrid
     c                   else
     c                   eval      contref     = exbrch
     c                                         + 'DL'
     c                                         + extrid
     c                   endif

      * Instrument id.
     c                   eval      instid      = exbrch
     c                                         + 'DL'
     c                                         + extrid

      * Get internal customer details.
     c                   eval      pKey1       = exbicn
     c                   exsr      getCust

     c                   eval      intparre    = bbbrcd
     c                                         + '-'
     c                                         + exbicn

     c                   if        d#fsli      = 1
     c                   eval      original    = d#otdt
     c                                         - exddat
     c                   eval      remainin    = d#otdt
     c                                         - extdat
     c                   else
     c                   eval      original    = exmdat
     c                                         - d#otdt
     c                   eval      remainin    = exmdat
     c                                         - extdat
     c                   endif

     c                   if        remainin    < 0
     c                   eval      remainin    = 0
     c                   endif

     c                   eval      numberof    = %inth(expamt)

     c                   eval      forconra    = excnrt

     c                   if        (   d#netby = 'Y'
     c                             or  d#netsl = 'Y' )
     c                   eval      nettagre    = 2
     c                   else
     c                   eval      nettagre    = 0
     c                   endif

     c     dealno        chain     t_rnfxdl
     c                   if        %found

      * (NB: offbal, othacccl, fiduciar and accrual are used by t__derius)
     c                   eval      offbal      = offbalan
     c                   eval      othacccl    = othraccl
     c                   eval      fiduciar    = fiduind
     c                   eval      accrual     = accrind
     c                   eval      portfoli    = portfolo
     c                   eval      purpose     = purposet
     c                   else
     c                   eval      offbal      = 0
     c                   eval      othacccl    = 0
     c                   eval      fiduciar    = 0
     c                   eval      accrual     = 0
     c                   eval      portfoli    = 0
     c                   eval      purpose     = 0
     c                   endif

     c                   write     t__derivat

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  derivatRecOR - Subroutine that writes to RN_DERIVAT          *
      *                 For Outright deals                            *
      *                                                               *
      *****************************************************************
     c     derivatRecOR  begsr

     c                   eval      product     = rtnProduct
     c                   eval      statusl2    = 5
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on
     c                   eval      coverage    = 0                                          BUG10804
     c                   eval      valumeth    = 0                                          BUG10804
     c                   eval      funded      = 0                                          BUG10804
     c                   eval      deliveui    = 0                                          BUG10804

     c                   eval      deal        = rnDayCnv(exddat)

      * BS indicator
     c                   if        expali      = 'P'
     c                   eval      bsindi      = 1
     c                   else
     c                   eval      bsindi      = 2
     c                   end

      * Maturity date.
     c                   eval      maturity    = rnDayCnv(exmdat)

     c                   eval      settleme    = rnDayCnv(exvdat)

     c                   eval      boocntre    = pZone
     c                                         + exbook

     c                   eval      counref     = bbbrcd
     c                                         + '-'
     c                                         + excusn

     c                   if        fcltyFound

      * Get facility customer details.
     c                   eval      pKey1       = exfcus
     c                   exsr      getCust

     c                   eval      limiref     = bbbrcd
     c                                         + '-'
     c                                         + exfcus
     c                                         + exftyp
     c                                         + exfcno
     c                   endif

     c                   eval      sourref     = pZone

      * Position ref.
     c                   eval      posiref     = exbrch
     c                                         + 'DL'
     c**********                               + extrid                                      BUG9978
     c                                         + %trimr(extrid)                              BUG9978
     c                                         + expali

      * Contract ref.
     c                   eval      contref     = exbrch
     c                                         + 'DL'
     c                                         + extrid

      * Instrument id.
     c                   eval      instid      = exbrch
     c                                         + 'DL'
     c                                         + extrid

      * Get internal customer details.
     c                   eval      pKey1       = exbicn
     c                   exsr      getCust

     c                   eval      intparre    = bbbrcd
     c                                         + '-'
     c                                         + exbicn

     c                   eval      original    = exmdat
     c                                         - exddat

     c                   eval      remainin    = exmdat
     c                                         - extdat
     c                   if        remainin    < 0
     c                   eval      remainin    = 0
     c                   endif

     c                   eval      numberof    = %inth(expamt)

     c                   eval      forconra    = excnrt

     c                   if        (   d#netby = 'Y'
     c                             or  d#netsl = 'Y' )
     c                   eval      nettagre    = 2
     c                   else
     c                   eval      nettagre    = 0
     c                   endif

     c     dealno        chain     t_rnfxdl
     c                   if        %found

      * (NB: offbal, othacccl, fiduciar and accrual are used by t__derius)
     c                   eval      offbal      = offbalan
     c                   eval      othacccl    = othraccl
     c                   eval      fiduciar    = fiduind
     c                   eval      accrual     = accrind
     c                   eval      portfoli    = portfolo
     c                   eval      purpose     = purposet
     c                   else
     c                   eval      offbal      = 0
     c                   eval      othacccl    = 0
     c                   eval      fiduciar    = 0
     c                   eval      accrual     = 0
     c                   eval      portfoli    = 0
     c                   eval      purpose     = 0
     c                   endif

     c                   write     t__derivat

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine that writes Records To RN_DERIUS                  *
      *                                                               *
      *****************************************************************
     c     deriusRec     begsr

      ** Get US product Code.
     c                   exsr      getProdCodeUS
     c                   eval      prdclaus    = rtnPrdclaUS

     c                   write     t__derius

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  deramoFac - Subroutine that writes to RN_DERAMO Face value/  *
      *              Notional amount                                  *
      *              and Book value amount                            *                      BUG9935
      *                                                               *
      *****************************************************************
     c     deramoFac     begsr

      * Output 1 Face value/ Notional amount records for each MRTRAPPD
      * record - same for all deal types and purchse or sale records.

      *--------------------------
      * Face value (purchase and sale), (1st and 2nd leg).

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

      * Get purchase or sale currency details.
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
     c                   eval      typamunt    = 3
     c                   eval      value       = rnDayCnv(exvdat)

     c                   write     t__deramo

     c                   exsr      wrtAudit

      * Output 1 Book value amount record which is same as face value amount,                BUG9935
      * with a different amount type = 1                                                     BUG9935
     c                   eval      typamunt    = 1                                           BUG9935
                                                                                             BUG9935
     c                   write     t__deramo                                                 BUG9935
                                                                                             BUG9935
     c                   exsr      wrtAudit                                                  BUG9935
                                                                                             BUG9935
     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  deramoMarSW - Subroutine that writes to RN_DERAMO Market     *
      *                value for a Swap deal                          *
      *                                                               *
      *****************************************************************
     c     deramoMarSW   begsr

      * Output 1 or 2 Amount records. Output the leg details for the 'P'
      * side and the deal value details while processing the 'S' side 2nd leg.

      *------------------------------------
      * 1) Market Value (base) of purchase

     c                   if        expali      = 'P'

     c                   if        exuacc     <> *blanks
     c                   if        exuref      = '1'
     c                   eval      glref       = exbrch
     c                                         + exbicn
     c                                         + excycd
     c                                         + exuacc
     c                                         + exacsq
     c                   else
     c                   eval      glref       = exbrch
     c                                         + excusn
     c                                         + excycd
     c                                         + exuacc
     c                                         + exacsq
     c                   endif
     c                   else
     c                   eval      glref       = *blanks
     c                   endif

     c                   eval      gldetre     = glref
     c                   eval      glentre     = glref

     c                   if        exudci      = 0
     c                   eval      dcindi      = 1
     c                   else
     c                   eval      dcindi      = 2
     c                   endif

     c                   eval      isocurr     = bjcycd
     c                   eval      ocaamunt    = exuamt
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : 1
     c                                                  : 'M'
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )

     c                   eval      typamunt    = 7

     c                   eval      value       = rnDayCnv(extdat)

     c                   write     t__deramo

     c                   exsr      wrtAudit

     c                   endif

      *---------------------------------------------------------------
      * 2) Market Value (base).
      *    Representing the swap as a whole (leg1 & leg2).

     c                   if        expali      = 'S' and d#fsli = 2

     c                   eval      isocurr     = bjcycd

     c                   eval      ocaamunt    = (lg1Exumtb * lg1Exusgn)
     c                                         + (   exumtb *    exusgn)
     c                   if        ocaamunt    > 0
     c                   eval      dcindi      = 1
     c                   else
     c                   eval      dcindi      = 2
     c                   endif

     c                   eval      ocaamunt    = %abs(ocaamunt)
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : 1
     c                                                  : 'M'
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 8
     c                   eval      value       = rnDayCnv(extdat)

     c                   write     t__deramo

     c                   exsr      wrtAudit
     c                   endif

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  deramoMarOR - Subroutine that writes to RN_DERAMO Market     *
      *                value for an Outright deal                     *
      *                                                               *
      *****************************************************************
     c     deramoMarOR   begsr

      * Output 1 Amount record for the purchase side MRTRAPPD record
      * of the deal. (This one side represents the market value of the
      * whole deal - using the other record would have given the same results).

      *------------------------------------
      * Market Value (base) of purchase

     c                   if        expali      = 'P'

     c                   if        exuacc     <> *blanks
     c                   if        exuref      = '1'
     c                   eval      glref       = exbrch
     c                                         + exbicn
     c                                         + excycd
     c                                         + exuacc
     c                                         + exacsq
     c                   else
     c                   eval      glref       = exbrch
     c                                         + excusn
     c                                         + excycd
     c                                         + exuacc
     c                                         + exacsq
     c                   endif
     c                   else
     c                   eval      glref       = *blanks
     c                   endif

     c                   eval      gldetre     = glref
     c                   eval      glentre     = glref

     c                   if        exudci      = 0
     c                   eval      dcindi      = 1
     c                   else
     c                   eval      dcindi      = 2
     c                   endif

     c                   eval      isocurr     = bjcycd
     c                   eval      ocaamunt    = exuamt
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : 1
     c                                                  : 'M'
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )

     c                   eval      typamunt    = 8

     c                   eval      value       = rnDayCnv(extdat)

     c                   write     t__deramo

     c                   exsr      wrtAudit

     c                   endif
     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getDeal   - Subroutine that retrieves deal data              *
      *                                                               *
      *****************************************************************
     c     getDeal       begsr

     c     dealNo        chain     deals
     c                   if        not %found
     c                   eval      wDbfile     = 'DEALS'
     c                   eval      wDbase      =  3
     c                   eval      wDbkey      = extrid
     c                   exsr      *pssr
     c                   endif

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getFclty  - Subroutine that retrieves facility data          *
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
     c                   eval      wDbase      = 22                                         BUG10501
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
     c                                         + 'DL'
     c                                         + extrid
     c                   eval      xcbrch      = exbrch
     c                   eval      xccusn      = excusn
     c                   eval      xctrty      = extrty
     c                   eval      xctrst      = extrst
     c                   write     rnxcpnpdf

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  swap2ndLeg - Retain 1st leg details for 2nd leg extract      *
      *                                                               *
      *****************************************************************
     c     swap2ndLeg    begsr

      * Save 1st leg values.
     c                   eval      lg1Extrid   = extrid
     c                   eval      lg1Exumtb   = exumtb
     c                   eval      lg1Exusgn   = exusgn

     c                   endsr
      *
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

      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * GetProdCode - Retrieves Product Code                              *
      *                                                                   *
      *********************************************************************
     c     GetProdCode   begsr

     c                   callb     'RNPRODMAP'

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
     c     rtnProduct    parm                    o#Product
     c                   parm                    o#CntOfClauses


      ** If not found, issue a database error
     c                   if        pRtnCod <> *blanks
     c                   eval      wDbfile     = 'T_FRSMAPR'
     c                   eval      wDbase      = 7
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
     c                   eval      wDbase      = 8
     c                   eval      wDbkey      = I#DealType
     c                   exsr      *pssr
     c                   endif

     c                   if        rtnPrdclaUS < 0
     c                   eval      rtnPrdclaUS = 0
     c                   endif

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
     c     aPosLot(rgIx) setll     t__dfboo

     c                   if        not %equal
     c                   eval      lottypfk    = aPosLot(rgIx)

     c                   monitor
     c                   write     t__dfboof
     c                   on-error  dupKey
     c                   endmon

     c                   endif

     c                   endif

     c                   endfor

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
     c                   eval      wDbase      = 10
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
     c                   open      rn_derius
     c                   endif

     c                   endsr

      *********************************************************************
      /EJECT
      *********************************************************************
      /copy rncpysrc,rnpssrsr
      *****************************************************************

**ctdata cpy@
(c) Finastra International Limited 2005
**ctdata aTrty
FS     FX Sold
FP     FX Purchased
CX     FX Cross-currency
PI     FX Purchase Covering Interest
SI     FX Sale Covering Interest
OP     FX Option
OT     FX Option Takedown
SW     FX Swap
