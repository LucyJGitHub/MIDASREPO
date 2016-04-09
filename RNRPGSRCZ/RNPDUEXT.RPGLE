     h debug   alwnull(*usrctl)
     h fixnbr(*zoned : *inputpacked)
     h copyright('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Lending Past Due Events extract')            *
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNPDUEXT   - Midas FRS Lending Past Due Events extract       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 10May06               *
      *                 BUG9792            Date 04Apr06               *
      *                 BUG10804           Date 10Mar06               *
      *                 BUG10560           Date 06Mar06               *
      *                 BUG10501           Date 09Feb06               *
      *                 BUG9793            Date 10Jan06               *
      *                 CRN001  *Create    Date 12Oct05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  BUG9792  - Event rule validation enhancement: apply          *
      *              suppression rules first.                         *
      *             No exception report for suppressed event key.     *
      *             Set up Transaction id output to RNXCCFPD.         *
      *  BUG10804 - RN_CASHFLO format has changed for FRS Data        *
      *             Foundation 2.9.3.                                 *
      *  BUG10560 - Ignore branches in other zone                     *
      *  BUG10501 - Parameter value '*DBERR' is not correct for       *
      *             access object running in CoB.                     *
      *  BUG9793 - Date removed from 'posiref' and added as           *
      *            separate key field on rn_cashflo                   *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     fpduedu    if   e           k disk    infsr(*pssr)
 
     fgpregbj0  if   e           k disk    infsr(*pssr)
 
     ft__dfboo  if a e           k disk    infsr(*pssr)
     f                                     rename(t__dfboo:t__dfboof)
 
     frn_cashflouf a e           k disk    infsr(*pssr)
     frn_casfloao    e             disk    infsr(*pssr) usropn
 
     frnaucfpd  o    e             disk    infsr(*pssr)
     frnxccfpd  o    e             disk    infsr(*pssr)
 
 
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
     d sdbrch        e ds                  extname(sdbrchpd)
     d  qqdfacx      e                     extfld(qqdfac)
     d sdcurr        e ds                  extname(sdcurrpd)
     d sdcust        e ds                  extname(sdcustpd)
 
      ** External DS for SAR details
     d scsard        e ds                  extname(scsardpd)
 
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
 
     d kExsub          s              4    inz('PDUE')
 
     d CRN002          s               n
     d cashFlowFnd     s               n
     d PpduDp          s                   like(principa)                       PPDU w decimal place
     d InpdDp          s                   like(principa)                       Inpd w decimal place
 
     d dupKey          c                   01021
 
     d rtnEvntLk       s                   like(rnEvntLk)
 
      ** Branch data, loaded in initial s/r.
     d                 ds
     d aBranchData                         dim(9999)
     d aBicn                               like(a8bicn)
     d                                     overlay(aBranchData : *next)
     d aBicnBrcd                           like(bbbrcd)
     d                                     overlay(aBranchData: *next)
 
      /copy rncpysrc,rnrgaudfn
      /copy rncpysrc,rndaycnv
      /copy rncpysrc,rnamtcnv
      /copy rncpysrc,rnevntlk
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+
 
     c     kCashflo      klist                                                               BUG9793
     c                   kfld                    posiref                                     BUG9793
     c                   kfld                    cashflow                                    BUG9793
 
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
 
     c                   read      pduedu
 
     c                   dow       not %eof
 
      ** Check if record is to be extracted.
     c                   eval      rgIx = %lookup(brca: aBrcd: 1: rgEl)
     c                   if        (   rgIx        >  0
     c                             and aNxDt(rgIx) <= evtDatIso )
 
     c                   eval      rtnEvntLk   = rnevntlk('PDUE'
     c                                                  : '**'
     c                                                  : '**'
     c                                                  : ccy
     c                                                  : bjcycd )
 
     c                   if           rtnEvntLk = '*'
     c*****                        or rtnEvntLk = *blanks                                    BUG9792
     c                   exsr      wrtExcptn
                                                                                             BUG9792
     c                   elseif    rtnEvntLk   = *blanks                                     BUG9792
                                                                                             BUG9792
     c                   else
     c                   exsr      mapData
     c                   endif
 
     c                   endif
 
     c                   read      pduedu
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
 
      * Get reporting currency
     c                   eval      pCcy        = ccy
     c                   exsr      getCcy
 
      ** Clear Output formats
     c                   clear                   t__cashflo
 
     c                   if        CRN002
     c                   clear                   t__casfloa
     c                   endif
 
      ** Call Output Subroutines
     c                   exsr      cashfloRec
 
     c                   if        not cashFlowFnd
     c                             and CRN002
     c                   exsr      casfloaRec
     c                   endif
 
     c                   exsr      wrtAudit
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  cashfloRec - Writes records to rn_cashflo                    *
      *                                                               *
      *****************************************************************
     c     cashfloRec    begsr
 
     c                   eval      wrkDatIso   = %date(rnDayCnv(vdat))
     c                   move      wrkDatIso     cashflow
 
     c                   eval      posiref     = brca
     c                                         + 'LE'
     C**********                               + %editc(lnrf: 'X')                            CLE148
     C                                         + LNRF                                         CLE148
     c**********                               + %triml(                                     BUG9793
     c**********                                   %editc(cashflow: 'Z'))                    BUG9793
     c*****posiref       chain     rn_cashflo                                                BUG9793
     c     kCashflo      chain     rn_cashflo                                                BUG9793
     c                   eval      cashFlowFnd = %found
 
     c                   eval      statusl2    = 5
     c                   move      runDatIso     validon
     c                   eval      Lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on
     c                   eval      isocurr     = ccy                                        BUG10804
     c                   eval      cfposirf    = posiref                                    BUG10804
     c                   eval      dcindi      = 1                                          BUG10804
     c                   eval      Intparre    = aBicnBrcd (rgIx)
     c                                         + '-'
     c                                         + aBicn (rgIx)
 
     c                   eval(h)   PpduDp      = Ppdu/(10**a6nbdp)
     c                   eval      princoca    = PpduDp                                     BUG10804
     c                   eval      principa    = rnAmtCnv(PpduDp
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
 
     c                   eval(h)   InpdDp      = Inpd/(10**a6nbdp)
     c                   eval      interoca    = InpdDp                                     BUG10804
     c                   eval      interest    = rnAmtCnv(InpdDp
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
 
     c                   eval      totacf      = principa
     c                                         + interest
 
     c                   eval      positype    = 3
 
     c                   if        cashFlowFnd
     c                   update    t__cashflo
     c                   else
     c                   write     t__cashflo
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  casfloaRec - writes records to rn_casfloa                    *
      *                                                               *
      *****************************************************************
     c     casfloaRec    begsr
 
     c                   eval      trancode    = 0
 
     c                   write     t__casfloa
 
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
      *  wrtAudit -  Write Audit Records                              *
      *                                                               *
      *****************************************************************
     c     wrtAudit      begsr
 
     c                   eval      auregaut    = aRaid(rgIx)
     c                   eval      aumodule    = 'LE'
     c                   eval      auevtccy    = ccy
     c                   eval      autrntyp    = *blank
     c                   eval      auevttyp    = 'PDUE'
     c                   eval      aubrch      = brca
     c                   movel     cnum          aucusn
     c                   eval      autranid    = posiref
     c                   if        PpduDp      < 0
     c                   eval      audci       = 'C'
     c                   else
     c                   eval      audci       = 'D'
     c                   endif
     c                   eval      auevtamt    = %abs(PpduDp)
     c                   eval      aurptccy    = aRpCy(rgIx)
     c                   eval      aurcaamt    = %abs(principa)
 
     c                   write     rnaucfpdf
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  wrtExcptn -  Write Exception Records                         *
      *                                                               *
      *****************************************************************
     c     wrtExcptn     begsr
 
      * Get reporting currency
     c                   eval      pCcy        = ccy
     c                   exsr      getCcy
 
     c                   eval      xcregaut    = aRaid(rgIx)
     c                   eval      xcmodule    = 'LE'
     c                   eval      xcevtccy    = ccy
     c                   eval      xctrntyp    = *blank
     c                   eval      xcevttyp    = 'PDUE'
     c                   eval      xcbrch      = brca
     c                   movel     cnum          xccusn
     c*******            eval      xctranid    = posiref                                     BUG9792
     c                   eval      xctranid    = brca                                        BUG9792
     c                                         + 'LE'                                        BUG9792
     C**********                               + %editc(lnrf: 'X')                    BUG9792 CLE148
     C                                         + LNRF                                         CLE148
     c                   eval(h)   PpduDp      = Ppdu/(10**a6nbdp)
     c                   if        PpduDp      < 0
     c                   eval      xcdci       = 'C'
     c                   else
     c                   eval      xcdci       = 'D'
     c                   endif
     c                   eval      xcevtamt    = %abs(PpduDp)
 
     c                   write     rnxccfpdf
 
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
      *  getBranch - Subroutine that retrieves branch details.        *
      *                                                               *
      *****************************************************************
     c     getBranch     begsr
 
     c                   callb     'AOBRCHR0'
     c**********         parm      '*DBERR'      pRtnCod                                    BUG10501
     c                   parm      *blanks       pRtnCod                                    BUG10501
     c                   parm      '*KEY'        pOption
     c                   parm                    RBBRCD
     c     sdbrch        parm                    dsfdy
                                                                                            BUG10501
     c******             if        pRtnCod    <> *blanks                           BUG10501 BUG10560
     c                   if        pRtnCod    <> *blanks  and                               BUG10560
     c                             pRtnCod    <> '*NRF'                                     BUG10560
     c                   eval      wDbmod      = 'AOBRCHR0'                                 BUG10501
     c                   eval      wDbase      = 23                                         BUG10501
     c                   eval      wDbkey      = RBBRCD                                     BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501
 
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
 
 
     c                   for       rgIx        = 1 to rgEl
     c                   exsr      getBranch
     c                   if        pRtnCod     = *blanks                                    BUG10560
     c                   eval      aBicn(rgIx) = a8bicn
     c                   eval      pKey1       = a8bicn
     c                   exsr      getCust
     c                   eval      aBicnBrcd(rgIx) = bbbrcd
     c                   endif                                                              BUG10560
     c                   endfor
      *---------------------------------------------------------------------
 
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
     c                   open      rn_casfloa
     c                   endif
 
      ** Event Lookup Initialisation
     c                   callp     rnEvntLkIn(pzone)
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      /copy rncpysrc,rnpssrsr
      *****************************************************************
 
**ctdata cpy@
(c) Misys International Banking Systems Ltd. 2005
