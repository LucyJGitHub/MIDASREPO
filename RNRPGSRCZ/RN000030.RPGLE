     h debug
     h fixnbr(*zoned : *inputpacked)
     h copyright('(c) Misys International Banking Systems Ltd. 2005')
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Update Next Extract Dates')
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RN000030   - Midas FRS Update Next Extract Dates             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CRN001  *Create    Date 18Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
 
     fgpregfpd  uf   e           k disk
 
      *=====================================================================
 
      /copy zacpysrc,psds
      /copy rncpysrc,rnpssrdfn
 
     d dsfdy         e ds
     d sdbank        e ds                  extname(sdbankpd)
     d sdgelr        e ds                  extname(sdgelrpd)
 
     d pRtnCod         s              7
     d pOption         s              7
     d pErrMsg         s             50
     d pFullChk        s              1
     d pZone           s             10
     d pShtc           s              4
     d pRdnb           s              5  0
     d pDnwd           s              5  0
     d pBccy           s              3
     d pNjob           s              1  0
 
     d midasDay0       c                   d'1971-12-31'
     d evtCtlDat       s                   like(bkapdt)
 
     d zFreq           s              1
     d zDayno          s              5  0
     d zMday           s              2  0
     d zCcy            s              3
     d zLoc            s              3
     d zDfin           s              1
 
      /copy rncpysrc,rndaycnv
 
      *=====================================================================
 
     c                   exsr      main
 
     c                   exsr      closedown
 
      *=====================================================================
 
     c     main          begsr
 
     c     pZone         setll     gpregfpd
     c     pZone         reade     gpregfpd
     c                   dow       not %eof
 
     c                   if        rfextdate  <= %date(rnDayCnv(evtCtlDat))
     c                   exsr      updExtDate
     c                   endif
 
     c     pZone         reade     gpregfpd
     c                   enddo
 
     c                   endsr
 
      *=====================================================================
 
     c     updExtDate    begsr
 
      * Starting parameters for ZFRQA:
      * 1) for day number, use current extract date; if this is too
      *    far back (ie before 1st midas day), use event control date.
      * 2) for frequency 'A', the next accrual date will not be
      *    available yet, so use parameters from general ledger icd.
 
     c                   if        rfextdate   > midasDay0
     c                   eval      zDayno      = %diff(rfextdate
     c                                               : midasDay0
     c                                               : *days     )
     c                   else
     c                   eval      zDayno      = evtCtlDat
     c                   endif
 
     c                   if        rffqy       = 'A'
     c                   eval      zFreq       = bkapfq
     c                   eval      zMday       = bkapfd
     c                   else
     c                   eval      zFreq       = rffqy
     c                   eval      zMday       = rfdayn
     c                   endif
 
     c                   dou       zDayno      > evtCtlDat
     c                   callb     'ZFRQA'
     c                   parm                    zFreq
     c                   parm                    zDayno
     c                   parm                    zMday
     c                   parm      bjlccy        zCcy
     c                   parm      bjslcd        zLoc
     c                   parm      bjdfin        zDfin
     c                   enddo
 
     c                   eval      rfextdate   = %date(rnDayCnv(zDayno))
     c                   update    gpregfd0
 
     c                   endsr
 
      *=====================================================================
 
     c     closedown     begsr
 
     c                   eval      *inlr       = *on
     c                   return
 
     c                   endsr
 
      *=====================================================================
 
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
     c                   eval      wDbase      = 1
     c                   eval      wDbmod      = 'GOGETZONE'
     c                   exsr      *pssr
     c                   endif
 
      *---------------------------------------------------------------------
 
      * Get bank details.
     c                   callb     'AOBANKR0'
     c                   parm      '*DBERR'      pRtnCod
     c                   parm      '*FIRST'      pOption
     c     sdbank        parm                    dsfdy
 
      * Get general ledger details.
     c                   callb     'AOGELRR0'
     c                   parm      '*DBERR'      pRtnCod
     c                   parm      '*FIRST'      pOption
     c     sdgelr        parm                    dsfdy
 
      * Derive event control date.
     c                   if        bkapdt      < bjdnwd
     c                   eval      evtCtlDat   = bkapdt
     c                   else
     c                   eval      evtCtlDat   = bjdnwd - 1
     c                   endif
 
     c                   endsr
 
      *=====================================================================
 
      /copy rncpysrc,rnpssrsr
