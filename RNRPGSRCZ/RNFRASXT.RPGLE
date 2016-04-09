     h debug
     h copyright('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Forward Rate Agreement Extract')             *
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNFRASXT   - Midas FRS Forward Rate Agreement extract        *
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
      *                 BUG11435           Date 07Jun06               *
      *                 CSD027A            Date 10May06               *
      *                 BUG10896           Date 28Mar06               *
      *                 BUG10804           Date 10Mar06               *
      *                 BUG10168           Date 13Feb06               *
      *                 BUG10501           Date 09Feb06               *
      *                 CRN001  *Create    Date 10Aug05               *
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
      *  BUG10896 - Map instrument id field in file RN_DERIVAT.       *
      *  BUG10804 - RN_DERIVAT format has changed for FRS Data        *
      *             Foundation 2.9.3. Remove deleted fields.          *
      *  BUG10168 - In Derivative table, the Interest Rate Type should*
      *             be 2 for variable rate.                           *
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
 
     fdeals     if   e           k disk    infsr(*pssr)
     f                                     include(dealsdgf)
     f                                     include(dealsdbf)
     f                                     prefix(d#)
 
     ffclty     if   e           k disk    infsr(*pssr)
     f                                     include(fcltyfmf)
     f                                     prefix(f#)
 
     ft_rnbsrt  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnbsrt:t_rnbsrtf)
 
     ft_rnfras  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnfras:t_rnfrasf)
 
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
 
     d pRaid           s                   like(rbRaid)
     d runDatIso       s               D
     d evtDatIso       s               d
 
     d pRtnCod         s              7
     d pOption         s              7
     d pKey1           s             10
     d pKyst           s              7
     d pCcy            s              3
     d psar            s              6
     d pErrMsg         s             50
     d pFullChk        s              1
     d pzone           s             10
     d pShtc           s              4
     d pRdnb           s              5  0
     d pDnwd           s              5  0
     d pBccy           s              3
     d pNjob           s              1  0
     d pIDate          s              6
     d pODate          s              5P 0
     d pDateOut        s              8S 0
     d pRetCod         s              1
     d #agdt           s              8
     d #agvv           s              2
 
     d #YYMMDD         ds
     d #YY                            2
     d #MM                            2
     d #DD                            2
 
     d #DDMMYY         ds
     d #DD1                           2
     d #MM1                           2
     d #YY1                           2
 
     d extrid          ds
     d  dealno                        6s 0
 
     d                 ds
     d exfcus
     d exftyp
     d exfcno
     d*exfcusN**                      6s 0 overlay(exfcus)                                   CSD027A
     d exfcusN                        6    overlay(exfcus)                                   CSD027A
     d exftypN                        3s 0 overlay(exftyp)
     d exfcnoN                        2s 0 overlay(exfcno)
 
     d fcltyfound      s               n
 
     d kExsub          s                   like(exsub)
     d                                     INZ('FRAS')
 
     d CRN006          s               n
 
     d dupKey          c                   01021
 
     d rtnProduct      s                   like(product)
     d rtnPrdclaUS     s                   like(prdclaus)
 
      ** deal types handled by this extract.
     d atrty           s                   like(extrty)
     d                                     dim(1) ctdata perrcd(1)
 
     d #cycd           s                   like(bacycd)
     d #bsrc           s                   like(babsrc)
 
      ** Used in plist RNPRODMAP
     dI#ERMS           s             30    inz(*blank)
     dI#AccountCode    s             10    inz(*blank)
     dI#dealType       s              2    inz(*blank)
     dI#dealsubType    s              6    inz(*blank)
     dI#LoanType       s              2    inz(*blank)
     dI#LoanSubType    s              6    inz(*blank)
     dI#FacilityType   s              3    inz(*blank)
     dI#SecuritySNam   s             10    inz(*blank)
     dI#InvestType     s              3    inz(*blank)
     dI#Institution    s              2    inz(*blank)
     dI#Industry       s              3    inz(*blank)
     dI#CtryCitizen    s              2    inz(*blank)
     dI#CtryLocation   s              2    inz(*blank)
     dI#Book           s              2    inz(*blank)
     dI#BankNonBank    s              1    inz(*blank)
     dI#AssetLiab      s              1    inz(*blank)
     dI#CollateralTy   s              5    inz(*blank)
     dO#product        s             10  0 inz(*zero)
     dO#CntOfClauses   s              5  0 inz(*zero)
      *
      /copy rncpysrc,rnrgaudfn
 
      /copy rncpysrc,rndaycnv
      /copy rncpysrc,rnamtcnv
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+
 
     c     kfclty        klist
     c                   kfld                    exfcusN
     c                   kfld                    exftypN
     c                   kfld                    exfcnoN
 
     c     kBsrt         klist
     c                   kfld                    #cycd
     c                   kfld                    #bsrc
 
     c     kMrtrapNxt    klist
     c                   kfld                    kExsub
     c                   kfld                    extrid
 
     c     *entry        plist
     c                   parm                    pRaid
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of main processing -----------------------------------+
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
     c                   IF        (   rgIx        >  0
     c                             and aNxDt(rgIx) <= evtDatIso )
 
      ** Check transaction (deal) type.
     c                   if        %lookup(extrty : atrty) > 0
 
      ** Get product Code.
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
 
     c                   exsr      getdeal
 
     c                   exsr      getfclty
 
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
      *  derivatRec - Subroutine that writes Records To rn_derivat    *
      *                                                               *
      *****************************************************************
     c     derivatRec    begsr
 
     c                   eval      rowId       = 0
     c                   eval      statusl2    = 5
     c                   eval      modfdate    = *blanks
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      rowType     = 0
     c                   eval      deal        = rndaycnv(exddat)
     c                   eval      exercise    = *blanks
     c                   eval      maturity    = rndaycnv(exmdat)
     c                   eval      nextsett    = *blanks
 
     c                   if        expali      = 'S'
     c                   eval      nexintfi    = rndaycnv(d#uinfd)
     c                   else
     c                   eval      nexintfi    = rndaycnv(d#tinfd)
     c                   endif
 
     c                   eval      statakdo    = *blanks
     c                   eval      settleme    = rndaycnv(exvdat)
     c                   eval      boocntre    = pzone + exbook
     c                   eval      deacmgre    = *blanks
     c                   eval      counref     = bbbrcd + '-' + excusn
     c                   eval      custref     = *blanks
 
     c                   if        fcltyfound
 
      ** Get facility customer details.
     c                   eval      pKey1       = exfcus
     c                   exsr      getCust
 
     c                   eval      limiref     = bbbrcd + '-' + exfcus
     c                                         + exftyp + exfcno
     c                   endif
 
     c                   eval      issuref     = *blanks
     c                   eval      sourref     = pzone
     c                   eval      posiref     = exbrch + 'DL' + extrid
     c                   eval      markref     = *blanks
     c                   eval      contref     = exbrch + 'DL' + extrid
     c                   eval      priciden    = *blanks
     c*******************eval      instid      = *blanks                                    BUG10896
     c                   eval      instid      = exbrch + 'DL' + extrid                     BUG10896
 
      ** Get internal customer details.
     c                   eval      pKey1       = exbicn
     c                   exsr      getCust
 
     c                   eval      intparre    = bbbrcd + '-' + exbicn
     c                   eval      deriref     = *blanks
     c                   eval      inteone     = *blanks
     c                   eval      intetwo     = *blanks
 
     c                   If        d#agdt      = 0
     c                   eval      #agdt       = '00000000'
     c                   else
     c                   movel     d#agdt        #YYMMDD
     c                   eval      #DD1        = #DD
     c                   eval      #MM1        = #MM
     c                   eval      #YY1        = #YY
     c                   eval      PIDate      = #DDMMYY
     c                   exsr      DateConvrt
     c                   movel     pDateOut      #agdt
     c                   Endif
     c                   move      d#agvv        #agvv
     c                   eval      isda        = d#agty +  #agdt + #agvv
 
     c                   eval      original    = exmdat - exddat
     c                   eval      remainin    = exmdat - extdat
     c                   eval      coverage    = 0                                          BUG10804
     c**********         eval      effemat     = 0                                          BUG10804
     c                   eval      ccf         = 0
     c**********         eval      lgd         = 0                                          BUG10804
     c**********         eval      effelgd     = 0                                          BUG10804
     c**********         eval      expohct     = 0                                          BUG10804
     c                   eval      perintra    = EXYLDR
     c                   eval      intintra    = 0
     c                   eval      product     = rtnProduct
     c                   eval      effmktd     = 0
     c                   eval      numberof    = 0
     c                   eval      duration    = 0
     c                   eval      moddurle    = 0
     c                   eval      moddurco    = 0
     c                   eval      intretra    = 0
     c                   eval      forconra    = exyldr
     c                   eval      strioca     = 0
     c                   eval      strirca     = 0
     c                   eval      yield       = 0
     c                   eval      delta       = 0
     c                   eval      gamma       = 0
     c                   eval      vega        = 0
     c                   eval      spremarg    = 0
     c                   eval      spread      = 0
     c                   eval      avgweig     = 0
     c                   eval      deductio    = 0
     c                   eval      ORIGINV     = 0
     c**********         eval      SECEXP      = 0                                          BUG10804
 
     c                   if        expali      = 'S'
     c                   eval      #cycd       = d#ucucy
     c                   movel     d#ubrtt       #bsrc
     c                   else
     c                   eval      #cycd       = d#tcucy
     c                   movel     d#tbrtt       #bsrc
     c                   endif
 
     c     kBsrt         chain     t_rnbsrtf
     c                   if        %found
     c                   eval      referate    =  refrattp
     c                   else
     c                   eval      referate    = 7
     c                   endif
 
     c                   eval      amortisa    = 0
     c                   eval      contcomm    = 0
     c                   eval      valumeth    = 0                                          BUG10804
     c                   eval      entrtype    = 0
     c                   eval      optistyl    = 0
     c                   eval      callindi    = 0
     c                   eval      funded      = 0                                          BUG10804
 
     c                   select
     c                   when      expali      = 'B'
     c                   eval      bsindi      = 1
     c                   when      expali      = 'S'
     c                   eval      bsindi      = 2
     c                   endsl
 
     c                   eval      risquain    = 0
     c                   eval      thirindi    = 0
     c                   eval      ifrvalme    = 0
     c                   eval      listed      = 0
     c                   eval      nettagre    = 0
     c*****              eval      typintra    = 1                                          BUG10168
     c                   eval      typintra    = 2                                          BUG10168
     c                   eval      intpayfr    = 0
     c                   eval      hedging     = 0
     c                   eval      deliveui    = 0                                          BUG10804
 
     c                   if        expali      = 'S'
 
     c                   select
     c                   when      d#uicbs     = 1
     c                   eval      indacoba    = 15
     c                   when      d#uicbs     = 2
     c                   eval      indacoba    = 2
     c                   when      d#uicbs     = 3
     c                   eval      indacoba    = 5
     c******             when      d#uicbs     = 4                                          BUG11435
     c******                       or d#uicbs  = 5                                          BUG11435
     c******                       or d#uicbs  = 6                                          BUG11435
     c* Unpopulated due to issue 21
     c*                  eval      indacoba    =
     c                   when      d#uicbs     = 4                                          BUG11435
     c                   eval      indacoba    = 16                                         BUG11435
     c                   when      d#uicbs     = 5                                          BUG11435
     c                   eval      indacoba    = 17                                         BUG11435
     c                   when      d#uicbs     = 6                                          BUG11435
     c                   eval      indacoba    = 18                                         BUG11435
     c                   when      d#uicbs     = 7                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
     c                   when      d#uicbs     = 8                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
     c                   when      d#uicbs     = 9                                          BUG11435
     c                   eval      indacoba    = 1                                          BUG11435
     c                   other                                                              BUG11435
     c                   eval      indacoba    = 0                                          BUG11435
     c                   endsl
 
     c                   else
 
     c                   select
     c                   when      d#ticbs     = 1
     c                   eval      indacoba    = 15
     c                   when      d#ticbs     = 2
     c                   eval      indacoba    = 2
     c                   when      d#ticbs     = 3
     c                   eval      indacoba    = 5
     c******             when      d#ticbs     = 4                                          BUG11435
     c******                       or d#ticbs  = 5                                          BUG11435
     c******                       or d#ticbs  = 6                                          BUG11435
     c* Unpopulated due to issue 21
     c*                  eval      indacoba    =
     c                   when      d#ticbs     = 4                                          BUG11435
     c                   eval      indacoba    = 16                                         BUG11435
     c                   when      d#ticbs     = 5                                          BUG11435
     c                   eval      indacoba    = 17                                         BUG11435
     c                   when      d#ticbs     = 6                                          BUG11435
     c                   eval      indacoba    = 18                                         BUG11435
     c                   when      d#ticbs     = 7                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
     c                   when      d#ticbs     = 8                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
     c                   when      d#ticbs     = 9                                          BUG11435
     c                   eval      indacoba    = 1                                          BUG11435
     c                   other                                                              BUG11435
     c                   eval      indacoba    = 0                                          BUG11435
     c                   endsl
     c                   endif
 
     c                   eval      valuindi    = 0
     c                   eval      securiti    = 0
 
     c     dealno        chain     t_rnfras
     c                   if        %found
     c                   eval      portfoli    = portfolo
     c                   eval      purpose     = purposet
     c                   eval      offbal      = offbalan
     c                   eval      othacccl    = othraccl
     c                   eval      fiduciar    = fiduind
     c                   eval      accrual     = accrind
     c                   else
     c                   eval      portfoli    = 0
     c                   eval      purpose     = 0
     c                   eval      offbal      = 0
     c                   eval      othacccl    = 0
     c                   eval      fiduciar    = 0
     c                   eval      accrual     = 0
     c                   endif
 
     c                   eval      aPosLotUsed(rgIx) = *on
 
     c                   write     t__derivat
 
     c                   endsr
 
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
      *  deramoRec  - Subroutine that writes Records To rn_deramo     *
      *                                                               *
      *****************************************************************
     c     deramoRec     begsr
 
      ** Output 4 Amount records for each mrtrap records.
      ** ------------------------------------
      ** 1) Principal amount
 
     c                   eval      rowId       = 0
     c                   eval      statusl2    = 5
     c                   eval      modfdate    = *blanks
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      rowType     = 0
 
     c                   if        expacc     <> *blanks
     c                   if        expref      = '1'
     c                   eval      glref       = exbrch + exbicn + excycd
     c                                         + expacc + exacsq
     c                   else
     c                   eval      glref       = exbrch + excusn + excycd
     c                                         + expacc + exacsq
     c                   endif
     c                   else
     c                   eval      glref       = *blanks
     c                   endif
 
     c                   eval      gldetre     = glref
     c                   eval      glentre     = glref
     c                   eval      scenfk      = 0
 
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
     c                   eval      value       = rndaycnv(exvdat)
 
     c                   write     t__deramo
     c                   exsr      wrtAudit
 
      ** --------------------------
      ** 2) Face value/nominal amount
 
     c                   eval      rowId       = 0
     c                   eval      statusl2    = 5
     c                   eval      modfdate    = *blanks
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      rowType     = 0
 
     c                   if        expacc     <> *blanks
     c                   if        expref      = '1'
     c                   eval      glref       = exbrch + exbicn + excycd
     c                                         + expacc + exacsq
     c                   else
     c                   eval      glref       = exbrch + excusn + excycd
     c                                         + expacc + exacsq
     c                   endif
     c                   else
     c                   eval      glref       = *blanks
     c                   endif
 
     c                   eval      gldetre     = glref
     c                   eval      glentre     = glref
     c                   eval      scenfk      = 0
 
     c                   if        expdci      = 0
     c                   eval      dcindi      = 1
     c                   else
     c                   eval      dcindi      = 2
     c                   endif
 
     c                   eval      isocurr     = excycd
     c                   eval      ocaamunt    = expamt
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
 
     c                   eval      typamunt    = 3
     c                   eval      value       = rndaycnv(exvdat)
 
     c                   write     t__deramo
     c                   exsr      wrtAudit
 
      ** ----------------------
      ** 3) Market value deal amount
 
     c                   eval      rowId       = 0
     c                   eval      statusl2    = 5
     c                   eval      modfdate    = *blanks
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      rowType     = 0
 
     c                   if        exuacc     <> *blanks
     c                   if        exuref      = '1'
     c                   eval      glref       = exbrch + exbicn + excycd
     c                                         + exuacc + exacsq
     c                   else
     c                   eval      glref       = exbrch + excusn + excycd
     c                                         + exuacc + exacsq
     c                   endif
     c                   else
     c                   eval      glref       = *blanks
     c                   endif
 
     c                   eval      gldetre     = glref
     c                   eval      glentre     = glref
     c                   eval      scenfk      = 0
 
     c                   if        expdci      = 0
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
     c                   eval      value       = rndaycnv(extdat)
 
     c                   write     t__deramo
     c                   exsr      wrtAudit
 
      ** ---------------------------------
      ** 4) Accrued interest amount
 
     c                   eval      rowId       = 0
     c                   eval      statusl2    = 5
     c                   eval      modfdate    = *blanks
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      rowType     = 0
 
     c                   if        exaacc     <> *blanks
     c                   if        exaref      = '1'
     c                   eval      glref       = exbrch + exbicn + excycd
     c                                         + exaacc + exacsq
     c                   else
     c                   eval      glref       = exbrch + excusn + excycd
     c                                         + exaacc + exacsq
     c                   endif
     c                   else
     c                   eval      glref       = *blanks
     c                   endif
 
     c                   eval      gldetre     = glref
     c                   eval      glentre     = glref
     c                   eval      scenfk      = 0
 
     c                   if        expdci      = 0
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
     c                   eval      value       = *blanks
     c                   move      runDatIso     value
 
     c                   write     t__deramo
     c                   exsr      wrtAudit
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getdeal   - Subroutine to Get deal Details                   *
      *                                                               *
      *****************************************************************
     c     getdeal       begsr
 
     c     dealno        chain     deals
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
      *  getfclty  - Retrieve Customer Lending Facility               *
      *                                                               *
      *****************************************************************
     c     getfclty      begsr
 
     c     kfclty        chain     fclty
     c                   eval      fcltyfound  = %found
 
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
     c                   write     rnaupnpdF
 
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
     c                   write     rnxcpnpdF
 
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
      * GetProdCode - Retrieve product Code                               *
      *                                                                   *
      *********************************************************************
     c     GetProdCode   begsr
 
     c                   callb     'RNPRODMAP'
     c                   parm      *blanks       pRtnCod
     c                   parm                    I#ERMS
     c                   parm                    I#AccountCode
     c                   parm      extrty        I#dealType
     c                   parm      extrst        I#dealsubType
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
     c     rtnProduct    parm                    O#product
     c                   parm                    O#CntOfClauses
 
      ** If not found, issue a database error
      *
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
      * GetProdCodeUS - Retrieve product Code US specific                 *
      *                                                                   *
      *********************************************************************
     c     GetProdCodeUS begsr
 
     c                   callb     'RNPRODMAPU'
     c                   parm      *blanks       pRtnCod
     c                   parm                    I#ERMS
     c                   parm                    I#AccountCode
     c                   parm      extrty        I#dealType
     c                   parm      extrst        I#dealsubType
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
     c     rtnPrdclaUS   parm                    O#product
     c                   parm                    O#CntOfClauses
 
      ** If not found, issue a database error
      *
     c                   if        pRtnCod    <> *blanks
     c                   eval      wDbfile     = 'T_FRSMAPR'
     c                   eval      wDbase      = 6
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
      * bootstrap - write Boot Strap Records                              *
      *                                                                   *
      *********************************************************************
     c     bootstrap     begsr
 
      ** Loop thru used lots
     c                   for       rgIx        = 1 to rgEl
 
      ** Write to t__dfboo if not existing
     C                   if        aPosLotUsed(rgIx)
     c     APosLot(rgIx) setll     t__dfboof
 
     c                   if        not %equal
     c                   eval      lottypfk        = aPosLot(rgIx)
     c                   move      runDatIso     validon
 
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
      *********************************************************************
      *                                                                   *
      * DateConvrt - Convert date from YYMMDD to CCYYMMDD                 *
      *                                                                   *
      *********************************************************************
     c     DateConvrt    begsr
 
     c                   callb     'ZDATE1'
     c                   parm                    pIDate
     c                   parm      *zero         pODate
     c                   parm                    BJDFIN
     c                   parm                    pRetCod
 
     c                   callb     'ZDATE9'
     c                   parm                    pODate
     c                   parm      *zero         pDateOut
     c                   parm                    pRetCod
 
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
     c                   parm      *blanks       pzone
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
 
     c                   eval      runDatIso   = %date(rndaycnv(bjrdnb))
 
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
 
      /copy rncpysrc,rnrgaulod
 
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
      ********************************************************************
 
**ctdata cpy@
(c) Misys International Banking Systems Ltd. 2005
**ctdata atrty
FR
