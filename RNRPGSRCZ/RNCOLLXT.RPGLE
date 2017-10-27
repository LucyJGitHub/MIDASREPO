     h debug   alwnull(*usrctl)
     h fixnbr(*zoned : *inputpacked)
     h copyright('(c) Misys International Banking Systems Ltd. 2005')
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Collateral Details Extract')                 *
      *****************************************************************
      *                                                               *
      *  MidasPlus - FRS Regulatory Reporting Interface               *
      *                                                               *
      *  RNCOLLXT   - Midas FRS Collateral Details Extract            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 09May06               *
      *                 BUG11158           Date 27Apr06               *
      *                 BUG10804           Date 10Mar06               *
      *                 BUG10501           Date 09Feb06               *
      *                 CRN001  *Create    Date 26Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  BUG11158 - Change field DCINDI from 0 to 1.                  *
      *  BUG10804 - RN_COLLATE format has changed for FRS Data        *
      *             Foundation 2.9.3. Remove deleted fields.          *
      *  BUG10501 - Parameter value '*DBERR' is not correct for       *
      *             access object running in CoB.                     *
      *  CRN001 - FRS Regulatory Reporting Interface                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     fglcolll1  if   e           k disk    infsr(*pssr)
 
     fgpregbj0  if   e           k disk    infsr(*pssr)
 
     fsecty     if   e           k disk    infsr(*pssr)
 
     fmemosl2   if   e           k disk    infsr(*pssr)
 
     fsdcllml1  if   e           k disk    infsr(*pssr)
 
     fsdacodl1  if   e           k disk    infsr(*pssr)
 
     fsdplinl0  if   e           k disk    infsr(*pssr)
 
     fgpweigl1  if   e           k disk    infsr(*pssr)
 
     ffddtstl1  if   e           k disk    infsr(*pssr)
 
     freiac     if   e           k disk    infsr(*pssr)
     f                                     include(reiacdf)
 
     freint     if   e           k disk    infsr(*pssr)
     f                                     include(reintdf)
 
     fdeals     if   e           k disk    infsr(*pssr)
     f                                     include(dealsdcf)
     f                                     prefix(d#)
 
     ffclty     if   e           k disk    infsr(*pssr)
     f                                     include(fcltyfmf: fcltyfnf)
     f                                     prefix(f#)
 
     fcloan     if   e           k disk    infsr(*pssr)
     f                                     include(cloanclf)
     f                                     prefix(l#)
 
     ft__dfboo  if a e           k disk    infsr(*pssr)
     f                                     rename(t__dfboo:t__dfboof)
 
     ft_rnfcip  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnfcip: t_rnfcipf)
 
     ft_rnclip  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnclip: t_rnclipf)
 
     ft_rnamad  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnamad: t_rnamadf)
 
     ft_rnfxdl  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnfxdl: t_rnfxdlf)
 
     ft_rnldni  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnldni: t_rnldnif)
 
     frn_collateo    e             disk    infsr(*pssr)
     frn_collus o    e             disk    infsr(*pssr) usropn
     frn_colamo o    e             disk    infsr(*pssr)
 
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
     d sdbrch        e ds                  extname(sdbrchpd)
     d  qqdfacx      e                     extfld(qqdfac)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     d pRaid           s                   like(rbraid)
     d runDatIso       s               d
     d evtDatIso       s               d
     d wrkDatIso       s               d
 
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
 
     d                 ds
     d cdcacd
     d  acctcode                     10    overlay(cdcacd)
     d cdcnum
     d  custnbr                       6    overlay(cdcnum)
     d kReint                        12
     d  calctype                      2    overlay(kReint)
     d   cict                              overlay(calctype)
     d  calcstyp                      5    overlay(kReint: *next)
     d   ccst                              overlay(calcstyp)
     d  ccy                                overlay(kReint: *next)
     d                                1    overlay(kReint: *next) inz('D')
 
     d dealFound       s               n
     d fcltyFound      s               n
     d diff            s              5u 0
 
     d kExsub          s              4    inz('COLL')
 
     d CRN006          s               n
 
     d dupKey          c                   01021
 
     d rtnProduct      s                   like(product)
     d exposure        s                   like(f#camd)
 
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
     d pCollateralTy   S              5
     d pProduct        s             10  0
     d pCntOfClauses   s              5  0
 
      /copy rncpysrc,rnrgaudfn
 
      /copy rncpysrc,rndaycnv
      /copy rncpysrc,rnastlia
      /copy rncpysrc,rnamtcnv
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+
     c     kFddtst       klist
     c                   kfld                    d#dtyp
     c                   kfld                    d#dlst
 
     c     kReiac        klist
     c                   kfld                    cdccnm
     c                   kfld                    cdcccy
     c                   kfld                    cdcacd
     c                   kfld                    cdcseq
     c                   kfld                    cdcbrc
 
     c     kRnamad       klist
     c                   kfld                    cdbrca
     c                   kfld                    cdcnum
     c                   kfld                    cdcccy
     c                   kfld                    cdcacd
     c                   kfld                    cdcseq
 
     c     kFclty        klist
     c                   kfld                    cdfcus
     c                   kfld                    cdftyp
     c                   kfld                    cdfseq
 
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
      *  main   -  Main subroutine                                    *
      *                                                               *
      *****************************************************************
 
     c     main          begsr
 
     c                   read      glcolll1
 
     c                   dow       not %eof
 
      * Check if record is to be extracted.
     c                   eval      rgIx = %lookup(cdbrca:aBrcd:1:rgEl)
     c                   if        (   rgIx        >  0
     c                             and aNxDt(rgIx) <= evtDatIso )
     c                   exsr      getProdCode
 
     c                   select
     c                   when      rtnProduct  > 0
     c                   exsr      mapData
 
     c                   when      rtnProduct  < 0
     c                   exsr      wrtExcptn
     c                   endsl
 
     c                   endif
 
     c                   read      glcolll1
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
 
     c                   exsr      getBranch
 
     c                   eval      pKey1       = custnbr
     c                   exsr      getCust
 
     c                   clear                   t__collate
     c                   clear                   t__colamo
 
     c                   if        CRN006
     c                   clear                   t__collus
     c                   endif
 
     c                   exsr      collatRec
 
     c                   if        CRN006
     c                   exsr      collusRec
     c                   endif
 
     c                   exsr      colamoRec
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  collatRec - Subroutine that writes to rn_collate             *
      *                                                               *
      *****************************************************************
     c     collatRec     begsr
 
     c                   eval      statusl2    = 5
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on
 
     c                   eval      deal        = rnDayCnv(cdsdat)
     c                   eval      maturity    = rnDayCnv(cdedat)
 
     c                   eval      counref     = bbbrcd
     c                                         + '-'
     c                                         + cdcnum                                      CSD027A
     c**********                               + %editc( cdcnum: 'X')                        CSD027A
 
     c**********         eval      pKey1       = %editc( cdpr01: 'X')                        CSD027A
     c                   eval      pKey1       = cdpr01                                      CSD027A
     c                   exsr      getCust
     c                   eval      issuref     = bbbrcd
     c                                         + '-'
     c                                         + cdpr01                                      CSD027A
     c**********                               + %editc( cdpr01: 'X')                        CSD027A
 
     c                   eval      posiref     = cdbrca
     c                                         + '-'
     c                                         + cdcref
 
     c                   if        cdmods      = 'LE'
     c**********         eval      pKey1       = %editc( cdfcus: 'X')                        CSD027A
     c                   eval      pKey1       = cdfcus                                      CSD027A
     c                   exsr      getCust
     c                   eval      limiref     = bbbrcd
     c                                         + '-'
     c**********                               + %editc(cdfcus: 'X')                         CSD027A
     c                                         + cdfcus                                      CSD027A
     c                                         + %editc(cdftyp: 'X')
     c                                         + %editc(cdfseq: 'X')
     c                   endif
 
     c                   eval      contref     = cdbrca
     c                                         + '-'
     c                                         + cdcref
 
     c                   eval      pKey1       = a8bicn
     c                   exsr      getCust
     c                   eval      intparre    = bbbrcd
     c                                         + '-'
     c                                         + a8bicn
 
     c                   select
     c                   when      cdcopt      = 'A'
     c                   eval      cotopore    = cdcbrc
     c**********                               + %editc( cdccnm: 'X')                        CSD027A
     c                                         + cdccnm                                      CSD027A
     c                                         + cdcccy
     c                                         + %editc( cdcacd: 'X')
     c                                         + %editc( cdcseq: 'X')
     c                   eval      positype    = 1
     c                   when      cdcopt      = 'D'
     c                   eval      cotopore    = d#brca
     c                                         + 'DL'
     c                                         + %editc( cddeal: 'X')
     c                   eval      positype    = 3
     c                   other
     c                   eval      positype    = 0
     c                   eval      cotopore    = *blanks
     c                   endsl
 
     c                   eval      sourref     = pZone
     c                   eval      product     = rtnProduct
 
      ** Map coverage and portfolo
     c                   eval      exposure    = 0
 
     c                   select
      ** Facility
     c                   when          cdmods  = 'LE'
     C**********                   and cdlnlm  = 0                                            CLE148
     C                             AND CDLNLM  = *BLANKS                                      CLE148
     c                   if        fcltyFound
     c                   eval      exposure    = f#camd
     c                   eval      wrkDatIso   = %date(rnDayCnv(f#dtex))
 
     c     cdcnum        chain     t_rnfcipf
     c                   if        %found
     c                   eval      portfoli    = portfolo
     c                   endif
     c                   endif
 
      ** Loan
     c                   when          cdmods  = 'LE'
     C**********                   and cdlnlm <> 0                                            CLE148
     C                             AND CDLNLM <> *BLANKS                                      CLE148
     c     cdlnlm        chain     cloan
     c                   if        %found
     c                   eval      exposure    = l#cpam
     c                   eval      wrkDatIso   = %date(rnDayCnv(l#mdat))
     c                   endif
 
     c     cdlnlm        chain     t_rnclipf
     c                   if        %found
     c                   eval      portfoli    = portfolo
     c                   endif
 
     c                   when      cdmods      = 'RE'
     c     cdsacn        chain     memosl2
     c                   if        %found
     c                   eval      exposure    = clbln
     c                   eval      ccf         = 0
     c                   endif
 
     c     kRnamad       chain     t_rnamadf
     c                   if        %found
     c                   eval      portfoli    = portfolo
     c                   endif
 
     c                   when         cdmods   = 'FX'
     c                             or cdmods   = 'MM'
     c     custnbr       chain     sdcllml1
     c                   if        %found
     c                   eval      wrkDatIso   = %date(rnDayCnv(dzfled))
 
     c                   if        cdmods      = 'FX'
     c                   eval      exposure    = dzflam
     c     cddeal        chain     t_rnfxdlf
     c                   else
     c                   eval      exposure    = dzmmam
     c     cddeal        chain     t_rnldnif
     c                   endif
     c                   endif
 
     c                   if        %found
     c                   eval      portfolo    = portfolo
     c                   endif
     c                   endsl
 
      ** Map ccf
     c                   if        wrkDatIso   > runDatIso
     c                   eval      diff        = %diff(wrkDatIso: runDatIso:
     c                                                 *years)
 
     c                   if        diff       >= 1
     c                   eval      ccf         = 50
     c                   endif
 
     c                   else
     c                   eval      diff        = %diff(runDatIso: wrkDatIso:
     c                                                 *years)
 
     c                   if        diff        < 1
     c                   eval      ccf         = 20
     c                   endif
     c                   endif
 
     c                   if        exposure    > 0
     c                   eval      coverage    = (cdlamt / exposure) * 100
     c                   endif
 
      ** Map collhct
     c**********         select                                                             BUG10804
     c**********         when      cdcopt      = 'A'                                        BUG10804
     c*****acctcode      chain     sdacodl1                                                 BUG10804
 
     c**********         if        %found                                                   BUG10804
     c*****innr*         chain     sdplinl0                                                 BUG10804
     c**********         endif                                                              BUG10804
 
     c**********         when      cdcopt      = 'D'                                        BUG10804
     c**********         if        dealFound                                                BUG10804
     c*****kFddtst       chain     fddtstl1                                                 BUG10804
 
     c**********         if        %found                                                   BUG10804
     c*****innr*         chain     sdplinl0                                                 BUG10804
     c**********         endif                                                              BUG10804
     c**********         endif                                                              BUG10804
 
     c**********         when      cdcopt      = 'P'                                        BUG10804
     c*****cdcsec        chain     secty                                                    BUG10804
 
     c**********         if        %found                                                   BUG10804
     c*****pbit*         chain     sdplinl0                                                 BUG10804
     c**********         endif                                                              BUG10804
     c**********         endsl                                                              BUG10804
 
     c**********         if        %found                                                   BUG10804
     c*****pdweig        chain     gpweigl1                                                 BUG10804
 
     c**********         if        %found                                                   BUG10804
     c**********         eval      collhct     = pdperc                                     BUG10804
     c**********         endif                                                              BUG10804
     c**********         endif                                                              BUG10804
 
      ** Map currhct
     c*****cdweig        chain     gpweigl1                                                 BUG10804
 
     c**********         if            %found                                               BUG10804
     c**********                   and pdcuml  = 'N'                                        BUG10804
     c**********         eval      currhct     = 0                                          BUG10804
     c**********         else                                                               BUG10804
 
     c**********         select                                                             BUG10804
     c**********         when      cdcopt      = 'A'                                        BUG10804
     c**********         eval      pCcy        = cdcccy                                     BUG10804
     c**********         exsr      getCcy                                                   BUG10804
 
     c*****a6powc        chain     gpweigl1                                                 BUG10804
     c**********         if        %found                                                   BUG10804
     c**********         eval      currhct     = pdperc                                     BUG10804
     c**********         endif                                                              BUG10804
 
     c**********         when      cdcopt      = 'D'                                        BUG10804
     c**********         if        dealFound                                                BUG10804
     c**********         eval      pCcy        = ccy                                        BUG10804
     c**********         exsr      getCcy                                                   BUG10804
 
     c*****a6powc        chain     gpweigl1                                                 BUG10804
     c**********         if        %found                                                   BUG10804
     c**********         eval      currhct     = pdperc                                     BUG10804
     c**********         endif                                                              BUG10804
     c**********         endif                                                              BUG10804
 
     c**********         when      cdcopt      = 'P'                                        BUG10804
     c*****cdcsec        chain     secty                                                    BUG10804
 
     c**********         if        %found                                                   BUG10804
     c**********         eval      pCcy        = nmcy                                       BUG10804
     c**********         exsr      getCcy                                                   BUG10804
 
     c*****a6powc        chain     gpweigl1                                                 BUG10804
     c**********         if        %found                                                   BUG10804
     c**********         eval      currhct     = pdperc                                     BUG10804
     c**********         endif                                                              BUG10804
     c**********         endif                                                              BUG10804
 
     c**********         endsl                                                              BUG10804
     c**********         endif                                                              BUG10804
 
     c                   eval      original    = cdedat
     c                                         - cdvdat
     c                   eval      remainin    = cdedat
     c                                         - bjrdnb
 
      ** Map typintra and collater
     c                   select
     c                   when      cdcopt      = 'A'
     c                   eval      collater    = 110100
     c     kReiac        chain     reiac
 
     c                   if        %found
     c     kReint        chain     reint
 
     c                   if        %found
 
     c                   if        brt        <> 00
     c                   eval      typintra    = 2
     c                   else
     c                   eval      typintra    = 1
     c                   endif
     c                   endif
     c                   endif
 
     c                   when      cdcopt      = 'C'
     c                   eval      collater    = 120000
 
     c                   when      cdcopt      = 'D'
     c                   eval      collater    = 110100
     c                   if        dealFound
 
     c                   if           d#brtt  <> 00
     c                             or d#notd  <> -999
     c                   eval      typintra    = 2
     c                   else
     c                   eval      typintra    = 1
     c                   endif
     c                   endif
 
     c                   when         cdcopt   = 'G'
     c                             or cdcopt   = 'L'
     c                             or cdcopt   = 'O'
     c                   eval      collater    = 000001
 
     c                   when      cdcopt      = 'H'
     c                   eval      collater    = 100300
 
     c                   when      cdcopt      = 'M'
     c                   eval      collater    = 120000
 
     c                   when      cdcopt      = 'P'
     c                   eval      collater    = 110400
     c     cdcsec        chain     secty
     c                   if        %found
 
     c                   if        basc       <> 00
     c                   eval      typintra    = 2
     c                   else
     c                   eval      typintra    = 1
     c                   endif
     c                   endif
 
     c                   endsl
 
     c                   write     t__collate
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  collusRec - Subroutine that writes records to RN_COLLUS.     *
      *                                                               *
      *****************************************************************
     c     collusRec     begsr
 
     c                   write     t__collus
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  colamoRec - Subroutine that writes to rn_colamo              *
      *                                                               *
      *****************************************************************
     c     colamoRec     begsr
 
      * Output 3 records for each rn_collate record.
 
      ** --------------
      ** 1) Book Value.
     c                   eval      statusl2    = 5
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on
     c                   eval      value       = rnDayCnv(cdvdat)
 
      * Get purchase currency details.
     c                   eval      pCcy        = cdccy
     c                   exsr      getCcy
 
     c                   eval      isocurr     = cdccy
     c                   eval(h)   ocaamunt    = cdnamt/(10**a6nbdp)
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
 
     c*******************eval      dcindi      = 0                                          BUG11158
     c                   eval      dcindi      = 1                                          BUG11158
     c                   eval      typamunt    = 1
 
     c                   write     t__colamo
 
     c                   exsr      wrtAudit
 
      ** -------------------
      ** 2) Notional amount.
     c                   eval      typamunt    = 3
 
     c                   write     t__colamo
 
     c                   exsr      wrtAudit
 
      ** ----------------------------
      ** 3) Market value deal amount.
     c                   eval(h)   ocaamunt    = cdvamt/(10**a6nbdp)
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
     c                   eval      typamunt    = 8
 
     c                   write     t__colamo
 
     c                   exsr      wrtAudit
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getDeal   - Subroutine that retrieves deal data              *
      *                                                               *
      *****************************************************************
     c     getDeal       begsr
 
     c     cddeal        chain     deals
     c                   if        not %found
     c                   eval      wDbfile     = 'DEALS'
     c                   eval      wDbase      =  3
     c                   eval      wDbkey      = %editc(cddeal: 'X')
     c                   exsr      *pssr
     c                   endif
 
     c                   eval      dealFound   = %found
 
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
      *  getBranch - Subroutine that retrieves branch details.        *
      *                                                               *
      *****************************************************************
     c     getBranch     begsr
 
     c                   callb     'AOBRCHR0'
     c**********         parm      '*DBERR'      pRtnCod                                    BUG10501
     c                   parm      *blanks       pRtnCod                                    BUG10501
     c                   parm      '*KEY'        pOption
     c                   parm                    cdbrca
     c     sdbrch        parm                    dsfdy
                                                                                            BUG10501
     c                   if        pRtnCod    <> *blanks                                    BUG10501
     c                   eval      wDbmod      = 'AOBRCHR0'                                 BUG10501
     c                   eval      wDbase      = 22                                         BUG10501
     c                   eval      wDbkey      = cdbrca                                     BUG10501
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
     c                   eval      autrncls    = 'COLL'
     c                   eval      aucntref    = contref
     c                   eval      auprdcod    = product
     c                   eval      aubrch      = cdbrca
     c                   eval      aucusn      = custnbr
     c                   eval      autrty      = 'COLL'
     c                   eval      autrst      = cdcolt
     c                   eval      auamttyp    = typamunt
     c                   eval      auorgccy    = isocurr
     c                   eval      auocaamt    = ocaamunt
     c                   eval      aurptccy    = aRpCy(rgIx)
     c                   eval      aurcaamt    = rcaamunt
     C                   eval      audci       = '0'
 
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
     c                   eval      xctrncls    = 'COLL'
     c                   eval      xccntref    = cdbrca
     c                                         + '-'
     c                                         + cdcref
     c                   eval      xcbrch      = cdbrca
     c                   eval      xccusn      = custnbr
     c                   eval      xctrty      = 'COLL'
     c                   eval      xctrst      = cdcolt
 
     c                   write     rnxcpnpdf
 
     c                   endsr
 
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
     c                   parm                    pERMS
     c                   parm      acctcode      pAccountCode
     c                   parm                    pDealType
     c                   parm                    pdealsubType
     c                   parm                    pLoanType
     c                   parm                    pLoanSubType
     c                   parm                    pFacilityType
     c                   parm                    pSecuritySNam
     c                   parm                    pInvestType
     c                   parm                    pInstitution
     c                   parm                    pIndustry
     c                   parm                    pCtryCitizen
     c                   parm                    pCtryLocation
     c                   parm                    pBook
     c                   parm                    pBankNonBank
     c                   parm                    pAssetLiab
     c                   parm      cdcolt        pCollateralTy
     c     rtnProduct    parm                    pProduct
     c                   parm                    pCntOfClauses
 
 
      ** If not found, issue a database error
     c                   if        pRtnCod <> *blanks
     c                   eval      wDbfile     = 'T_FRSMAPR'
     c                   eval      wDbase      = 7
     c                   eval      wDbkey      = cdcolt
     c                   exsr      *pssr
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
     c                   eval      wDbase      = 1
     c                   eval      wDbmod      = 'AOSARDR0'
     c                   exsr      *pssr
     c                   endif
 
      ** Feature CRN006 is present
     c                   if        CRN006
     c                   open      rn_collus
     c                   endif
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      /copy rncpysrc,rnpssrsr
      *****************************************************************
 
**ctdata cpy@
(c) Misys International Banking Systems Ltd. 2005
