     h debug   alwnull(*usrctl)
     h fixnbr(*zoned : *inputpacked)
     h copyright('(c) Finastra International Limited 2005')

      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS IRS Details Extract')                        *
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNSWAPXT   - Midas FRS IRS Details Extract                   *
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
      *                 BUG10896           Date 28Mar06               *
      *                 BUG10804           Date 10Mar06               *
      *                 BUG10168           Date 09Feb06               *
      *                 BUG10501           Date 09Feb06               *
      *                 BUG9978            Date 19Jan06               *
      *                 CRN001  *Create    Date 10Aug05               *
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
      *  BUG10896 - Map instrument id field in file RN_DERIVAT.       *
      *  BUG10804 - RN_DERIVAT format has changed for FRS Data        *
      *             Foundation 2.9.3.                                 *
      *  BUG10168 - In Derivative table, the Next Interest Repricing/ *
      *             Fixing date should be blank if it is fixed        *
      *             interest.                                         *
      *  BUG10501 - Parameter value '*DBERR' is not correct for       *
      *             access object running in CoB.                     *
      *  BUG9978- Correction to Position Reference                    *
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
     f                                     include(dealsdgf)
     f                                     prefix(d#)

     ffclty     if   e           k disk    infsr(*pssr)
     f                                     include(fcltyfmf)
     f                                     prefix(f#)

     ft__dfboo  if a e           k disk    infsr(*pssr)
     f                                     rename(t__dfboo:t__dfboof)

     ft_rnbsrt  if a e           k disk    infsr(*pssr)
     f                                     rename(t_rnbsrt:t_rnbsrtf)

     ft_rnfras  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnfras:t_rnfrasf)

     frn_derivato    e             disk    infsr(*pssr)
     frn_derius o    e             disk    infsr(*pssr)  usropn
     frn_deramo o    e             disk    infsr(*pssr)

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
     d dssdy         e ds
     d sdbank        e ds                  extname(sdbankpd)
     d sdgelr        e ds                  extname(sdgelrpd)
     d sdcurr        e ds                  extname(sdcurrpd)
     d sdcust        e ds                  extname(sdcustpd)

     d pRaid           s                   like(rbraid)
     d runDatIso       s               d
     d evtDatIso       s               d

     d pRtnCod         S              7
     d pOption         S              7
     d pKey1           S             10
     d pKyst           S              7
     d pCcy            S              3
     d psar            S              6
     d pErrMsg         S             50
     d pFullChk        S              1
     d pZone           S             10
     d pShtc           S              4
     d pRdnb           S              5  0
     d pDnwd           S              5  0
     d pBccy           S              3
     d pNjob           S              1  0

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

     d fcltyFound      S               N

     d kExsub          s                   like(exsub)
     d                                     inz('SWAP')

     d lg1Extrid       s                   like(extrid)
     d lg1Exumtb       s                   like(exumtb)
     d lg1Exusgn       s                   like(exusgn)
     d lg1Posiref      s                   like(posiref)
     d lg1Intparre     s                   like(intparre)

     d CRN006          s               n

     d dupKey          c                   01021

     d rtnProduct      s                   like(product)
     d rtnPrdclaUS     s                   like(prdclaus)
     d rateType        s                   like(babsrc)

      ** Deal types handled by this extract.
     d aTrty           s                   like(extrty)
     d                                     dim(2) ctdata perrcd(1)

      ** Parameters for RNPRODMAP
     d pERMS           s             30
     d pAccountCode    s             10
     d pDealType       s              2
     d pdealsubType    s              6
     d pLoanType       s              2
     d pLoanSubType    s              6
     d pFacilityType   s              3
     d pSecuritySNam   s             10
     d pInvestType     s              3
     d pInstitution    s              2
     d pIndustry       s              3
     d pCtryCitizen    s              2
     d pCtryLocation   s              2
     d pBook           s              2
     d pBankNonBank    s              1
     d pAssetLiab      s              1
     d pCollateralTy   s              5
     d pProduct        s             10  0
     d pCntOfClauses   s              5  0

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

     c     kMrtrapLg1    klist
     c                   kfld                    kExsub
     c                   kfld                    lg1Extrid

     c     kMrtrapLg2    klist
     c                   kfld                    kExsub
     c                   kfld                    exltid

     c     kFclty        klist
     c                   kfld                    exfcusN
     c                   kfld                    exftypN
     c                   kfld                    exfcnoN

      ** Key field for t_rnbsrt
     c     kyt_rnbsrt    klist
     c                   kfld                    excycd
     c                   kfld                    rateType

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
     c                   if        %lookup(extrty : aTrty) > 0

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

     c                   clear                   t__derivat
     c                   clear                   t__deramo

     c                   if        CRN006
     c                   clear                   t__derius
     c                   endif

     c                   exsr      derivatRec

     c                   if        CRN006
     c                   exsr      deriusRec
     c                   endif

     c                   exsr      deramoRec

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  derivatRec - Subroutine that writes records to rn_derivat    *
      *                                                               *
      *****************************************************************
     c     derivatRec    begsr

     c                   move      runDatIso     validon

     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      statusl2    = 5
     c                   eval      aPosLotUsed(rgIx) = *on
     c                   eval      boocntre    = pZone
     c                                         + exbook

     c                   eval      deal        = rnDayCnv(exddat)
     c                   eval      maturity    = rnDayCnv(exmdat)
     c                   eval      nextsett    = rnDayCnv(exnidt)

     c                   eval      settleme    = maturity

     c                   eval      counref     = bbbrcd
     c                                         + '-'
     c                                         + excusn

     c                   if        fcltyfound

      ** Get facility customer details.
     c                   eval      pKey1       = exfcus
     c                   exsr      getCust

     c                   eval      limiref     = bbbrcd
     c                                         + '-'
     c                                         + exfcus
     c                                         + exftyp
     c                                         + exfcno
     c                   endif

     c                   eval      sourref     = pZone

     c                   eval      contref     = exbrch
     c                                         + 'DL'
     c                                         + extrid

     c                   eval      instid      = exbrch + 'DL'+ extrid                      BUG10896

      ** Get internal customer details.
     c                   eval      pKey1       = exbicn
     c                   exsr      getCust

     c                   eval      intparre    = bbbrcd
     c                                         + '-'
     c                                         + exbicn

     c                   eval      original    = exmdat
     c                                         - exddat
     c                   eval      remainin    = exmdat
     c                                         - extdat

     c                   eval      coverage    = 0                                          BUG10804
     c                   eval      product     = rtnProduct
     c                   eval      perintra    = exintr
     c                   eval      forconra    = exintr

     c                   eval      bsindi      = 1
     c                   eval      valumeth    = 0                                          BUG10804
     c                   eval      funded      = 0                                          BUG10804
     c                   eval      deliveui    = 0                                          BUG10804

      ** Interest rate type
     c                   if        exrate      = 'F'
     c                   eval      typintra    = 1
     c                   else
     c                   eval      typintra    = 2
     c                   endif

     c     dealno        chain     t_rnfrasf

     c                   if        %found
     c                   eval      portfoli    = portfolo
     c                   eval      purpose     = purposet
     c                   eval      offbal      = offbalan
     c                   eval      othacccl    = othraccl
     c                   eval      fiduciar    = fiduind
     c                   eval      accrual     = accrind
     c                   endif

     c                   select
     c                   when      expali      = 'A'

     c                   if        exrate      = 'F'                                        BUG10168
     c                   eval      nexintfi    = *blank                                     BUG10168
     c                   else                                                               BUG10168
     c                   eval      nexintfi    = rnDayCnv(d#tinfd)
     c                   endif                                                              BUG10168

     c                   eval      posiref     = exbrch
     c                                         + 'DL'
     c**********                               + extrid                                      BUG9978
     c                                         + %trimr(extrid)                              BUG9978
     c                                         + 'A'

     c                   move      d#tbrtt       rateType

      ** Their interest payment frequency
     c                   select
     c                   when      d#tipfr     = 'M'
     c                   eval      intpayfr    = 12

     c                   when      d#tipfr     = 'Q'
     c                   eval      intpayfr    = 4

     c                   when      d#tipfr     = 'X'
     c                   eval      intpayfr    = 2

     c                   when      d#tipfr     = 'Y'
     c                   eval      intpayfr    = 1

     c                   other
     c                   eval      intpayfr    = 0
     c                   endsl

      ** Interest calculation basis
     c                   select
     c                   when      d#ticbs     = 1
     c                   eval      indacoba    = 15

     c                   when      d#ticbs     = 2
     c                   eval      indacoba    = 2

     c                   when      d#ticbs     = 3
     c                   eval      indacoba    = 5

      ** Not*to*be*populated*until*issue*21*is*resolved                                     BUG11435
  -> c*-                 when         d#ticbs  = 4
  -> c*-                           or d#ticbs  = 5
  -> c*-                           or d#ticbs  = 6
  -> c*-                 eval      indacoba    = 5
     c                   when      d#ticbs     = 4                                          BUG11435
     c                   eval      indacoba    = 16                                         BUG11435
                                                                                            BUG11435
     c                   when      d#ticbs     = 5                                          BUG11435
     c                   eval      indacoba    = 17                                         BUG11435
                                                                                            BUG11435
     c                   when      d#ticbs     = 6                                          BUG11435
     c                   eval      indacoba    = 18                                         BUG11435
                                                                                            BUG11435
     c                   when      d#ticbs     = 7                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
                                                                                            BUG11435
     c                   when      d#ticbs     = 8                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
                                                                                            BUG11435
     c                   when      d#ticbs     = 9                                          BUG11435
     c                   eval      indacoba    = 1                                          BUG11435
                                                                                            BUG11435
     c                   other                                                              BUG11435
     c                   eval      indacoba    = 0                                          BUG11435
                                                                                            BUG11435
     c                   endsl

     c                   when      expali      = 'L'

     c                   if        exrate      = 'F'                                        BUG10168
     c                   eval      nexintfi    = *blank                                     BUG10168
     c                   else                                                               BUG10168
     c                   eval      nexintfi    = rnDayCnv(d#uinfd)
     c                   endif                                                              BUG10168

     c                   eval      posiref     = exbrch
     c                                         + 'DL'
     c**********                               + extrid                                      BUG9978
     c                                         + %trimr(extrid)                              BUG9978
     c                                         + 'L'

     c                   move      d#ubrtt       rateType

      ** Their interest payment frequency
     c                   select
     c                   when      d#uipfr     = 'M'
     c                   eval      intpayfr    = 12

     c                   when      d#uipfr     = 'Q'
     c                   eval      intpayfr    = 4

     c                   when      d#uipfr     = 'X'
     c                   eval      intpayfr    = 2

     c                   when      d#uipfr     = 'Y'
     c                   eval      intpayfr    = 1

     c                   other
     c                   eval      intpayfr    = 0
     c                   endsl

     ** Interest calculation basis
     c                   select
     c                   when      d#uicbs     = 1
     c                   eval      indacoba    = 15

     c                   when      d#uicbs     = 2
     c                   eval      indacoba    = 2

     c                   when      d#uicbs     = 3
     c                   eval      indacoba    = 5

      ** Not to be populated until issue 21 is resolved
  -> c*-                 when         d#uicbs  = 4
  -> c*-                           or d#uicbs  = 5
  -> c*-                           or d#uicbs  = 6
  -> c*-                 eval      indacoba    = 5
     c                   when      d#uicbs     = 4                                          BUG11435
     c                   eval      indacoba    = 16                                         BUG11435
                                                                                            BUG11435
     c                   when      d#uicbs     = 5                                          BUG11435
     c                   eval      indacoba    = 17                                         BUG11435
                                                                                            BUG11435
     c                   when      d#uicbs     = 6                                          BUG11435
     c                   eval      indacoba    = 18                                         BUG11435
                                                                                            BUG11435
     c                   when      d#uicbs     = 7                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
                                                                                            BUG11435
     c                   when      d#uicbs     = 8                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
                                                                                            BUG11435
     c                   when      d#uicbs     = 9                                          BUG11435
     c                   eval      indacoba    = 1                                          BUG11435
                                                                                            BUG11435
     c                   other                                                              BUG11435
     c                   eval      indacoba    = 0                                          BUG11435
                                                                                            BUG11435
     c                   endsl

     c                   endsl

      ** Reference rate type
     c                   if        exrate      = 'V'
     c     kyt_rnbsrt    chain     t_rnbsrtf

     c                   if        %found
     c                   eval      referate    = refrattp
     c                   else
     c                   eval      referate    = 7
     c                   endif

     c                   else
     c                   eval      referate    = 0
     c                   endif

     c                   write     t__derivat

     C                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine that writes Records To rn_derius                  *
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
      *  deramoRec  - Subroutine that writes records To rn_deramo     *
      *                                                               *
      *****************************************************************
     c     deramoRec     begsr

      ** Output 4 Amount records.

      ** ------------------------------------
      ** 1) Principal amount.

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

     c                   eval      value       = rnDayCnv(exvdat)

     c                   write     t__deramo

     c                   exsr      wrtAudit

      ** ------------------------------------
      ** 2) Face value / nominal amount.

     c                   eval      typamunt    = 3

     c                   write     t__deramo

     c                   exsr      wrtAudit

      ** ------------------------------------
      ** 3) Market value deal amount.

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
     c                   eval      ocaamunt    = exumtb
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

      ** ------------------------------------
      ** 4) Accrued interest amount.

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

     c                   eval      isocurr     = excycd
     c                   eval      ocaamunt    = exaamt
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 20
     c                   move      runDatIso     value

     c                   write     t__deramo

     c                   exsr      wrtAudit

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getDeal   - Subroutine to Get Deal Details                   *
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

     C                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getFclty  - Retrieve Customer Lending Facility               *
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
      *  getCust   - Retrieve Customer Details                        *
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
      *  closedown -  Return to Calling Program                       *
      *                                                               *
      *****************************************************************
     c     closedown     begsr

     c                   eval      *inlr       = *on
     c                   return

     C                   endsr

      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * GetProdCode - Retrieve Product Code                               *
      *                                                                   *
      *********************************************************************
     c     GetProdCode   begsr

      ** Product mappings
     c                   callb     'RNPRODMAP'
     c                   parm      *blanks       pRtnCod
     c                   parm                    pERMS
     c                   parm                    pAccountCode
     c                   parm      extrty        pDealType
     c                   parm      extrst        pdealsubType
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
     c                   eval      wDbkey      = pDealType
     c                   exsr      *pssr
     c                   endif

     c                   endsr

      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * GetProdCodeUS - Retrieve Product Code US specific                 *
      *                                                                   *
      *********************************************************************
     c     GetProdCodeUS begsr

      ** Product mappings
     c                   callb     'RNPRODMAPU'
     c                   parm      *blanks       pRtnCod
     c                   parm                    pERMS
     c                   parm                    pAccountCode
     c                   parm      extrty        pDealType
     c                   parm      extrst        pdealsubType
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
     c                   if        pRtnCod    <> *blanks
     c                   eval      wDbfile     = 'T_FRSMAPR'
     c                   eval      wDbase      = 6
     c                   eval      wDbkey      = pDealType
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
      * BootStrap - write Boot Strap Records                              *
      *                                                                   *
      *********************************************************************
     c     bootstrap     begsr

      * Loop thru used lots
     c                   for       rgIx        = 1 to rgEl

      * write to t__dfboo if not existing
     c                   if        aPosLotUsed(rgIx)
     c     aPosLot(rgIx) setll     t__dfboof

     c                   if        not %equal
     c                   move      rundatiso     validon
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

     C                   endsr

      *********************************************************************
      /EJECT
      *********************************************************************
      /copy rncpysrc,rnpssrsr
      *****************************************************************
**ctdata cpy@
(c) Finastra International Limited 2005
**ctdata aTrty
RS     Single Currency IRS
RX     Cross Currency IRS
