     h debug   alwnull(*usrctl)
     h fixnbr(*zoned : *inputpacked)
     h copyright('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Customer Lending Events Extract')            *
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNLEEVXT   - Midas FRS Customer Lending Events Extract       *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. CLE172             Date 01Oct20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03May06               *
      *                 BUG9792            Date 20Apr06               *
      *                 BUG10804           Date 10Mar06               *
      *                 BUG10560           Date 06Mar06               *
      *                 BUG10501           Date 09Feb06               *
      *                 BUG9793            Date 10Jan06               *
      *                 CRN001  *Create    Date 17Oct05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE172 - LIBOR Deregulation - Lending                        *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  BUG9792  - Set up Transaction id output to RNXCCFPD.         *
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

     flvntxel   if   e           k disk    infsr(*pssr)

     fgpregbj0  if   e           k disk    infsr(*pssr)

     fcloan     if   e           k disk    infsr(*pssr)
     f                                     include(cloanclf)
     f                                     prefix(l#)

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

     d pRaid           s                   like(rbraid)
     d runDatIso       s               d
     d evtDatIso       s               d
     d wrkDatIso       s               d

     d pRtnCod         s              7
     d pOption         s              7
     d pKey1           s             10
     d pKyst           s              7
     d pBrca           s              3
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

     d kExsub          s              4    inz('LEEV')

     d CRN002          s               n
     d cashflowFound   s               n
     d rtnEvntLk       s                   like(rnEvntLk)
     d wrkAmt          s                   like(principa)
     d EAmtDp          s                   like(principa)                       EAmt with decimal pl

     d dupKey          c                   01021

      * branch data, loaded in initial s/r.
     d                 ds
     d aBranchData                         dim(9999)
     d aBicn                               like(a8bicn)
     d                                     overlay(aBranchData: *next)
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
      *  main   -  Main subroutine                                    *
      *                                                               *
      *****************************************************************

     c     main          begsr

     c                   read      lvntxel

     c                   dow       not %eof
     c                   eval      rgIx        = %lookup(brca
     c                                                 : aBrcd
     c                                                 : 1
     c                                                 : rgEl )

      * check if record is to be extracted.

     c                   if        (   rgIx        >  0
     c                             and aNxDt(rgIx) <= evtDatIso )

     c                   eval      rtnEvntLk   = rnevntlk(etyp
     c                                                  : ltyp
     c                                                  : sutp
     c                                                  : eccy
     c                                                  : bjcycd )

     c                   if        rtnEvntLk   = '*'
     c                   exsr      wrtExcptn

     c                   elseif    rtnEvntLk   = *blanks

     c                   else
     c                   exsr      mapData
     c                   endif

     c                   endif

     c                   read      lvntxel
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

      * get reporting currency.
     c                   eval      pCcy        = eccy
     c                   exsr      getCcy

      * clear output formats.
     c                   clear                   t__cashflo

     c                   if        CRN002
     c                   clear                   t__casfloa
     c                   endif

     c                   exsr      cashfloRec

     c                   if        not cashflowFound
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

     c                   if        edat        <> 0
     c                   eval      wrkDatIso   = %date(rnDayCnv(edat))
     c                   else
     c                   eval      wrkDatIso   = %date(rnDayCnv(bjrdnb))
     c                   endif
     c                   move      wrkDatIso     cashflow

     c                   eval      posiref     = brca
     c                                         + 'LE'
     C**********                               + %editc(lnrf: 'X')                            CLE148
     C                                         + LNRF                                         CLE148
     c**********                               + %triml(                                     BUG9793
     c**********                                   %editc(cashflow: 'Z'))                    BUG9793
     c*****posiref       chain     rn_cashflo                                                BUG9793
     c     kCashflo      chain     rn_cashflo                                                BUG9793
     c                   eval      cashflowFound = %found

     c                   eval      statusl2    = 5
     c                   move      runDatIso     validon
     c                   eval      Lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on
     c                   eval      isocurr     = eccy                                       BUG10804
     c                   eval      cfposirf    = posiref                                    BUG10804
                                                                                            BUG10804
     c                   if        inoi        = 'O'                            B01         BUG10804
     c                   if        eamt        < 0                              B02         BUG10804
     c                   eval      dcindi      = 1                                          BUG10804
     c                   else                                                   X02         BUG10804
     c                   eval      dcindi      = 2                                          BUG10804
     c                   endif                                                  E02         BUG10804
     c                   else                                                   X01         BUG10804
     c                   if        eamt        < 0                              B02         BUG10804
     c                   eval      dcindi      = 2                                          BUG10804
     c                   else                                                   X02         BUG10804
     c                   eval      dcindi      = 1                                          BUG10804
     c                   endif                                                  E02         BUG10804
     c                   endif                                                  E01         BUG10804

     c                   eval      Intparre    = aBicnBrcd(rgIx)
     c                                         + '-'
     c                                         + aBicn (rgIx)

     c                   eval(h)   EAmtDp      = eamt/(10**a6nbdp)
     c                   eval      wrkAmt      = rnAmtCnv(EAmtDp
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )

     c                   if        cashflowFound

     c                   if        rtnEvntLk   = 'P'
     c                   eval      princoca   += EAmtDp                                     BUG10804
     c                   eval      principa   += wrkAmt
     c                   elseif    rtnEvntLk   = 'I'
     c                   eval      interoca   += EAmtDp                                     BUG10804
     c                   eval      interest   += wrkAmt
     c                   endif

     c                   else

     c                   if        rtnEvntLk   = 'P'
     c                   eval      princoca    = EAmtDp                                     BUG10804
     c                   eval      principa    = wrkAmt
     c                   elseif    rtnEvntLk   = 'I'
     c                   eval      interoca    = EAmtDp                                     BUG10804
     c                   eval      interest    = wrkAmt
     c                   endif

     c                   endif

     c                   eval      totacf      = principa
     c                                         + interest

  -> c                   eval      positype    = 3

     c                   if        cashflowFound
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

  -> c                   eval      trancode    = 0

     c                   write     t__casfloa

     c                   endsr

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getLoan - Retrieve loan details.                             *
      *                                                               *
      *****************************************************************

     c     getLoan       begsr

     c     lnrf          chain     cloan

     c                   if        not %found
     c                   eval      wDbFile     = 'CLOAN'
     c                   eval      wDbase      = 1
     C**********         eval      wDbKey      = %editc(lnrf: 'X')                            CLE148
     C                   EVAL      WDBKEY      = LNRF                                         CLE148
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
     c                   eval      auevtccy    = eccy

     c                   eval      autrntyp    = ltyp
     c                                         + '-'
     c                                         + sutp

     c                   eval      auevttyp    = etyp
     c                   eval      aubrch      = brca
     c                   eval      aucusn      = cunr
     c                   eval      autranid    = posiref
     c                   if        EAmtDp      < 0
     c                   eval      audci       = 'C'
     c                   else
     c                   eval      audci       = 'D'
     c                   endif
     c                   eval      auevtamt    = %abs(EAmtDp)
     c                   eval      aurptccy    = aRpCy(rgIx)
     c                   eval      aurcaamt    = %abs(wrkAmt)

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
     c                   eval      pCcy        = eccy
     c                   exsr      getCcy

     c                   eval      xcregaut    = aRaid(rgIx)
     c                   eval      xcmodule    = 'LE'
     c                   eval      xcevtccy    = eccy

     c                   eval      xctrntyp    = ltyp
     c                                         + sutp

     c                   eval      xcevttyp    = etyp
     c                   eval      xcbrch      = brca
     c                   eval      xccusn      = cunr
      * Position Ref not set up at this point, so cannot be used.                            BUG9792
     c*******************eval      xctranid    = posiref                                     BUG9792
     c                   eval      xctranid    = brca                                        BUG9792
     c                                         + 'LE'                                        BUG9792
     C**********                               + %editc(lnrf: 'X')                    BUG9792 CLE148
     C                                         + LNRF                                         CLE148
     c                   eval(h)   EAmtDp      = eamt/(10**a6nbdp)
     c                   if        EAmtDp      < 0
     c                   eval      xcdci       = 'C'
     c                   else
     c                   eval      xcdci       = 'D'
     c                   endif
     c                   eval      xcevtamt    = %abs(EAmtDp)

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

      * loop thru used lots

     c                   for       rgIx        = 1 to rgEl

      * write to t__dfboo if not existing

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
      *  getBranch - Retrieve branch details.                         *
      *                                                               *
      *****************************************************************

     c     getBranch     begsr

     c                   callb     'AOBRCHR0'
     c**********         parm      '*DBERR'      pRtnCod                                    BUG10501
     c                   parm      *blanks       pRtnCod                                    BUG10501
     c                   parm      '*KEY'        pOption
     c                   parm                    pBrca
     c     sdbrch        parm                    dsfdy
                                                                                            BUG10501
     c******             if        pRtnCod    <> *blanks                           BUG10501 BUG10560
     c                   if        pRtnCod    <> *blanks  and                               BUG10560
     c                             pRtnCod    <> '*NRF'                                     BUG10560
     c                   eval      wDbmod      = 'AOBRCHR0'                                 BUG10501
     c                   eval      wDbase      = 23                                         BUG10501
     c                   eval      wDbkey      = pBrca                                      BUG10501
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

      * get zone.

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

      * get bank details.

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

      * populate array with branch internal customers,
      * and their branches.

     c                   for       rgIx        = 1 to rgEl
     c                   eval      pBrca       = aBrcd(rgIx)
     c                   exsr      getBranch
     c                   if        pRtnCod     = *blanks                                    BUG10560
     c                   eval      aBicn(rgIx) = a8bicn
     c                   eval      pKey1       = a8bicn
     c                   exsr      getCust
     c                   eval      aBicnBrcd(rgIx) = bbbrcd
     c                   endif                                                              BUG10560
     c                   endfor

      *---------------------------------------------------------------------

      * check for enhancement CRN002.

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

      * feature CRN002 is present.

     c                   if        CRN002
     c                   open      rn_casfloa
     c                   endif

      * event lookup initialisation.

     c                   callp     rnEvntLkIn(pzone)

     c                   endsr

      *********************************************************************
      /EJECT
      *********************************************************************
      /copy rncpysrc,rnpssrsr
      *****************************************************************

**ctdata cpy@
(c) Finastra International Limited 2004
