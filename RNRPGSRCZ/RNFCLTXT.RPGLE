     h debug   alwnull(*usrctl)
     h fixnbr(*zoned : *inputpacked)
     h copyright('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Facilities Extract')
      *****************************************************************
      *                                                               *
      *  MidasPlus - FRS Regulatory Reporting                         *
      *                                                               *
      *  RNFCLTXT  - Midas Facilities Extract                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG10804           Date 10Mar06               *
      *  Prev Amend No. BUG10501           Date 09Feb06               *
      *                 BUG9801            Date 17Jan06               *
      *                 CRN001  *Create    Date 11Oct05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG10804 - RN_LIMIT format has changed for FRS Data          *
      *             Foundation 2.9.3. Recompile only.                 *
      *  BUG10501 - Parameter value '*DBERR' is not correct for       *
      *             access object running in CoB.                     *
      *  BUG9801 - Do not use Credit Agreement reference              *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     fmrtrapl0  if   e           k disk    infsr(*pssr)
 
     fgpregbj0  if   e           k disk    infsr(*pssr)
 
     ffclty     if   e           k disk    infsr(*pssr)
     f                                     include(fcltyfmf)
     f                                     prefix(f#)
 
     ft_rnfcip  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnfcip: t_rnfcipf)
     f                                     prefix(fx#)
 
     ft__dfboo  if a e             disk    infsr(*pssr)
     f                                     rename(t__dfboo: t__dfboof)
 
     frn_limit  o    e             disk    infsr(*pssr)
 
     frn_limiamoo    e             disk    infsr(*pssr)
 
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
 
     d pRaid           s                   like(rbraid)
     d runDatIso       s               d
     d evtDatIso       s               d
 
     d dsfdy         e ds
     d dssdy         e ds
     d sdbank        e ds                  extname(sdbankpd)
     d sdgelr        e ds                  extname(sdgelrpd)
     d sdcurr        e ds                  extname(sdcurrpd)
     d sdcust        e ds                  extname(sdcustpd)
 
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
     d**cnumTrid*                     6s 0                                                   CSD027A
     d  cnumTrid                      6                                                      CSD027A
     d  factTrid                      3s 0
     d  fcnoTrid                      2s 0
 
     d fcltExtnFnd     s               n
 
     d kExsub          s                   like(exsub)
     d                                     inz('FCLT')
 
     d dupKey          c                   01021
 
     d rtnProduct      s                   like(product)
 
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
 
      /copy rncpysrc,rnrgaudfn
 
      /copy rncpysrc,rndaycnv
      /copy rncpysrc,rnamtcnv
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+
 
     c     kFclty        klist
     c                   kfld                    cnumTrid
     c                   kfld                    factTrid
     c                   kfld                    fcnoTrid
 
     c     *entry        plist
     c                   parm                    pRaid
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     c                   exsr      main
 
     c                   exsr      bootstrap
 
     c                   exsr      closedown
 
      *****************************************************************
      /EJECT
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
 
     c     mapData       begsr
 
      * Get Facility record.
     c                   exsr      getFclty
 
      * Get Facility Extension record.
     c                   exsr      getFcltExtn
 
     c                   clear                   t__limit
     c                   clear                   t__limiamo
 
     c                   exsr      limitRec
     c                   exsr      limiamoRec
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine that writes records to rn_limit.                  *
      *                                                               *
      *****************************************************************
 
     c     limitRec      begsr
 
     c                   eval      product     = rtnProduct
     c                   eval      statusl2    = 5
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on
 
     c                   eval      deal        = rnDayCnv(exddat)
     c                   eval      maturity    = rnDayCnv(exmdat)
     c                   eval      approval    = deal
 
      * Get facility customer.
     c**********         eval      pKey1       = %editc(cnumTrid: 'X')                       CSD027A
     c                   eval      pKey1       = cnumTrid                                    CSD027A
     c                   exsr      getCust
     c                   eval      limiref     = bbbrcd
     c                                         + '-'
     c                                         + extrid
 
     c                   eval      contref     = exbrch
     c                                         + '-'
     c                                         + extrid
 
      **Set*Parent*Limit*Ref*to*credit*agreement*ref*(if*present),****                       BUG9801
      **or*to*prime*facility*ref*(if*present),************************                       BUG9801
      **or,*where*neither*present,*to*(original)*Limit*Ref.***********                       BUG9801
     c**********         if        f#canm     <> 0                                           BUG9801
     c**********         eval      pKey1       = %editc(f#canm: 'X')                         BUG9801
     c**********         exsr      getCust                                                   BUG9801
     c**********         eval      parlimre    = bbbrcd                                      BUG9801
     c**********                               + '-'                                         BUG9801
     c**********                               + %editc(f#canm: 'X')                         BUG9801
     c**********                               + %editc(f#caft: 'X')                         BUG9801
     c**********                               + %editc(f#cafn: 'X')                         BUG9801
      **********                                                                             BUG9801
     c**********         elseif    f#pmfc     <> 0                                           BUG9801
                                                                                             BUG9801
      * Set Parent Limit Ref to prime facility ref (if*present),                             BUG9801
      * otherwise set to (original) Limit Ref.                                               BUG9801
     c**********         if        f#pmfc     <> 0                                   BUG9801 CSD027A
     c**********         eval      pKey1       = %editc(f#pmfc: 'X')                         CSD027A
     c                   if        f#pmfc     <> *BLANKS                                     CSD027A
     c                   eval      pKey1       = f#pmfc                                      CSD027A
     c                   exsr      getCust
     c                   eval      parlimre    = bbbrcd
     c                                         + '-'
     c**********                               + %editc(f#pmfc: 'X')                         CSD027A
     c                                         + f#pmfc                                      CSD027A
     c                                         + %editc(f#pmft: 'X')
     c                                         + %editc(f#pmfn: 'X')
 
     c                   else
     c                   eval      parlimre    = limiref
     c                   endif
 
     c                   eval      pKey1       = excusn
     c                   exsr      getCust
     c                   eval      counref     = bbbrcd
     c                                         + '-'
     c                                         + excusn
 
     c                   eval      pKey1       = exbicn
     c                   exsr      getCust
     c                   eval      intparre    = bbbrcd
     c                                         + '-'
     c                                         + exbicn
 
     c                   eval      sourref     = pZone
 
     c                   eval      original    = exmdat
     c                                         - exvdat
 
     c                   eval      remainin    = exmdat
     c                                         - extdat
 
     c                   eval      alindi      = 0
 
     c                   if        f#rvcr  = 'Y'
     c                   eval      revofac     = 1
     c                   else
     c                   eval      revofac     = 2
     c                   endif
 
     c                   eval      revocabl    = 2
 
     c                   if        fcltExtnFnd
     c                   eval      portfoli    = fx#portfolo
     c                   eval      purpose     = fx#purposet
     c                   endif
 
     c                   write     t__limit
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Subroutine that writes records to rn_limiamo.                *
      *                                                               *
      *****************************************************************
 
     c     limiamoRec    begsr
 
      * Output 2 records:
      * £The normal setting for 'dcindi' is 2; a value of 1 in the
      * 'Unused Credit' record indicates an 'overdrawn' facility.]
      *-----------------
      * 1) Credit Limit.
 
     c                   eval      scenfk      = 0
 
     c                   eval      dcindi      = 2
 
      * Get currency details.
     c                   eval      pCcy        = excycd
     c                   exsr      getCcy
 
     c                   eval      isocurr     = excycd
 
     c                   eval(h)   ocaamunt    = f#famt
     c                                         / (10 ** a6nbdp)
 
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
 
     c                   eval      typamunt    = 16
     c                   eval      value       = rnDayCnv(bjrdnb)
 
     c                   write     t__limiamo
 
     c                   exsr      wrtAudit
 
      *------------------------
      * 2) Unused Credit Limit.
 
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
 
     c                   eval      typamunt    = 17
 
     c                   write     t__limiamo
 
     c                   exsr      wrtAudit
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     c     getFclty      begsr
 
     c     kFclty        chain     fclty
 
     c                   if        not %found
     c                   eval      wDbfile      = 'FCLTY'
     c                   eval      wDbase       = 2
     c                   eval      wDbkey       = extrid
     c                   exsr      *pssr
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
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
 
     c     getFcltExtn   begsr
 
     c     kFclty        chain     t_rnfcip
     c                   eval      fcltExtnFnd = %found
 
     c                   endsr
 
      *****************************************************************
      /EJECT
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
      *  Subroutine that calls the Product Code mapping module,           *
      *  which returns the Product Code.                                  *
      *                                                                   *
      *********************************************************************
 
     c     getProdCode   begsr
 
     c                   callb     'RNPRODMAP'
     c                   parm      *blanks       pRtnCod
     c                   parm                    I#ERMS
     c                   parm                    I#AccountCode
     c                   parm                    I#DealType
     c                   parm                    I#DealSubType
     c                   parm                    I#LoanType
     c                   parm                    I#LoanSubType
     c                   parm      extrty        I#FacilityType
     c                   parm                    I#SecuritySNam
     c                   parm                    I#InvestType
     c                   parm      excint        I#Institution
     c                   parm      excind        I#Industry
     c                   parm      exccit        I#CtryCitizen
     c                   parm      excloc        I#CtryLocation
     c                   parm                    I#Book
     c                   parm      excbnk        I#BankNonBank
     c                   parm                    I#AssetLiab
     c                   parm                    I#CollateralTy
     c     rtnProduct    parm                    O#Product
     c                   parm                    O#CntOfClauses
 
     c                   if        pRtnCod    <> *blanks
     c                   eval      wDbmod      = 'RNPRODMAP'
     c                   eval      wDbase      = 3
     c                   eval      wDbkey      = exftyp
     c                   exsr      *pssr
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
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
 
     c     wrtExcptn     begsr
 
     c                   eval      xcregaut    = aRaid(rgIx)
     c                   eval      xctrncls    = exsub
     c                   eval      xccntref    = exbrch
     c                                         + '-'
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
      *  Subroutine that writes (unique) records to the t__dfboo.         *
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     c     closedown     begsr
 
     c                   eval      *inlr       = *on
     c                   return
 
     c                   endsr
 
      *********************************************************************
      /EJECT
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
     c                   eval      wDbmod      = 'GOGETZONE'
     c                   eval      wDbase      = 1
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
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      /copy rncpysrc,rnpssrsr
