     h debug   alwnull(*usrctl)
     h fixnbr(*zoned : *inputpacked)
     h copyright('(c) Finastra International Limited 2005')
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Counterparty (customer) Extract')            *
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNCPTYXT   - Counterparty (customer) Extract                 *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 03May06               *
      *                 BUG11157           Date 07Apr06               *
      *                 BUG10804           Date 10Mar06               *
      *                 BUG10169           Date 08Mar06               *
      *                 BUG10560           Date 03Mar06               *
      *                 BUG10501           Date 09Feb06               *
      *                 CRN001  *Create    Date 20Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  BUG11157 - Reinstate RESIDENC field with correct description *
      *             in T__COUNUS. Output data to this field from      *
      *             field CPRTYRES in file SDCUSTXB.                  *
      *  BUG10804 - RN_RATIEXT format has changed for FRS Data        *
      *             Foundation 2.9.3. Recompile only.                 *
      *  BUG10169 - Replace , and ; in customer shortname with ' '.   *
      *  BUG10560 - Ignore branches in other zone                     *
      *  BUG10501 - Parameter value '*DBERR' is not correct for       *
      *             access object running in CoB.                     *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     fsdcustpd  if   e             disk    infsr(*pssr)
 
     fsdcustl0  if   e           k disk    infsr(*pssr)
     f                                     prefix(l0#)
 
     fgpregbj0  if   e           k disk    infsr(*pssr)
 
     fsdacusl0  if   e           k disk    infsr(*pssr)
 
     fsdcustxb  if   e           k disk    infsr(*pssr)
     f                                     prefix(x#)
 
     ft__dfboo  if a e           k disk    infsr(*pssr)
     f                                     rename(t__dfboo : t__dfboof)
 
     frn_countero    e             disk    infsr(*pssr)
 
     frn_ratiexto    e             disk    infsr(*pssr)
 
     frn_counapjo    e             disk    infsr(*pssr) usropn
 
     frn_ctpfim o    e             disk    infsr(*pssr)
 
     frn_counus o    e             disk    infsr(*pssr)
     f                                     usropn
 
     frn_ctpfimuo    e             disk    infsr(*pssr)
     f                                     usropn
 
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
     d sdbank        e ds                  extname(sdbankpd)
     d sdgelr        e ds                  extname(sdgelrpd)
     d sdbrch        e ds                  extname(sdbrchpd)
     d qqdfac_       e                     extfld(qqdfac)
 
     d pRaid           s                   like(rbraid)
     d runDatIso       s               d
     d evtDatIso       s               d
 
     d pRtnCod         s              7
     d pOption         s              7
     d pSar            s              6
     d pErrMsg         s             50
     d pFullChk        s              1
     d pZone           s             10
     d pShtc           s              4
     d pRdnb           s              5  0
     d pDnwd           s              5  0
     d pBccy           s              3
     d pNjob           s              1  0
 
      ** Branch data, loaded in initial s/r.
     d                 ds
     d aBranchData                         dim(9999)
     d aBrcd                               like(rbbrcd)
     d                                     overlay(aBranchData : *next)
     d aFinum                              like(rbfinum)
     d                                     overlay(aBranchData : *next)
     d aLotTyp                             like(rbposlot)
     d                                     overlay(aBranchData : *next)
     d aLotTypDup                      n   overlay(aBranchData : *next)
     d aRptEnt                             like(rbrptent)
     d                                     overlay(aBranchData : *next)
     d aBicn                               like(a8bicn)
     d                                     overlay(aBranchData : *next)
     d aBicnBrcd                           like(bbbrcd)
     d                                     overlay(aBranchData : *next)
 
     d brEl            s              5u 0
     d brIx            s              5u 0
 
     d cusNamAddr      ds
     d  bbcna1
     d  bbcna2
     d  bbcna3
     d  bbcna4
     d  aCna                               like(bbcna1)
     d                                     dim(4)
     d                                     overlay(cusNamAddr)
 
     d cnaIx           s              3u 0
     d cnaEl           c                   %elem(aCna)
     d cSemicoSpace    c                   '; '
 
     d MatchPos        s              2  0                                      Scan result BUG10169
     d StrPos          s              2  0                                      Start Pos   BUG10169
     d ScanChar        s              1                                                     BUG10169
 
     d CRN002          s               n
     d CRN006          s               n
     d dueToRun        s               n
     d acusFound       s               n
     d extnFound       s               n
 
     d dupKey          c                   01021
 
      /copy rncpysrc,rndaycnv
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+
 
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
 
     c     *start        setll     sdcustpd
     c                   read      sdcustpd
     c                   dow       not %eof
 
     c                   exsr      mapData
 
     c                   read      sdcustpd
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
 
     c                   exsr      getExtnFlds
 
     c                   exsr      getAcus
 
     c                   clear                   t__counter
     c                   clear                   t__ratiext
     c                   clear                   t__ctpfim
 
     c                   if        CRN002
     c                   clear                   t__counapj
     c                   endif
 
     c                   if        CRN006
     c                   clear                   t__counus
     c                   clear                   t__ctpfimu
     c                   endif
 
     c                   exsr      commonFlds
 
     c                   exsr      branchFlds
 
      ** Output counterparty, rating, and APJ records for each lot type.
     c                   for       brIx        = 1 to brEl
 
     c                   if        aLotTypDup(brIx)
     c                   iter
 
     c                   else
     c                   eval      lottypfk    = aLotTyp(brIx)
     c                   endif
 
     c                   exsr      counterRec
     c                   exsr      ratiextRec
 
     c                   if        CRN002
     c                   exsr      counapjRec
     c                   endif
 
     c                   if        CRN006
     c                   exsr      counusRec
     c                   endif
 
      ** Counterparty Financial Institution data is only required when
      ** the customer is the internal customer of one of the branches.
 
     c                   if        %lookup(bbcust
     c                                   : aBicn
     c                                   : 1
     c                                   : brEl  ) > 0
     c                   exsr      ctpfimRec
 
     c                   if        CRN006
     c                   exsr      ctpfimuRec
     c                   endif
     c                   endif
 
     c                   endfor
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  commonFlds - Subroutine that assign field values common to   *
      *               all files.                                      *
      *                                                               *
      *****************************************************************
     c     commonFlds    begsr
 
     c                   eval      statusl2    = 5
     c                   move      runDatIso     validon
 
     c                   eval      counref     = bbbrcd
     c                                         + '-'
     c                                         + bbcust
 
      * Parent ref.
     c                   if        bbpcnb      = *blanks
     c                   eval      cregrore    = counref
 
     c                   else
     c     bbpcnb        chain     sdcustl0
     c                   if        %found
     c                   eval      cregrore    = l0#bbbrcd
     c                                         + '-'
     c                                         + l0#bbcust
     c                   else
     C                   eval      wDbfile     ='SDCUSTL0'
     C                   eval      wDbase      = 1
     C                   eval      wDbkey      = bbpcnb
     c                   exsr      *pssr
     c                   endif
     c                   endif
 
     c                   eval      sourref     = pZone
     c                   eval      swifbic     = bbcsid
     c                   eval      firparre    = cregrore
 
     c                   select
     c                   when      bbbsin      = 'H'
     c                   eval      consolid    = 11
 
     c                   when      bbbsin      = 'B'
     c                   eval      consolid    = 9
 
     c                   when      bbbsin      = 'P'
     c                   eval      consolid    = 5
 
     c                   when      bbbsin      = 'W'
     c                   eval      consolid    = 7
     c                   endsl
 
     c                   eval      residenc    = bbcolc
     c                   eval      national    = bbcncz
 
      ** Discard trailing blanks from each line,
      ** and insert semicolon + space between them.
     c                   for       cnaIx       = 1 to cnaEl
     c                   if        (   address     <> *blanks
     c                             and aCna(cnaIx) <> *blanks )
     c                   eval      address     = address
     c                                         + cSemicoSpace
     c                   endif
     c                   eval      address     = address
     c                                         + %trimr(aCna(cnaIx))
     c                   endfor
 
     c                   eval      city        = bbcrtn
 
     c                   if        acusFound
     c                   eval      faxnumbe    = e5fxnb
     c                   eval      taxnumbe    = e5idno
 
     c                   if        e5brt1     <> *blanks
     c                   eval      birth       = e5brt2
     c                                         + %subst(e5brt1:5:2)
     c                                         + '-'
     c                                         + %subst(e5brt1:3:2)
     c                                         + '-'
     c                                         + %subst(e5brt1:1:2)
     c                   endif
     c                   endif
 
     c                   eval      longname    = bbcrnm
     c                   eval      phonnumb    = bbctnb
     c                   eval      shortnam    = bbcssn
                                                                                            BUG10169
      ** Replace ',' in shortnam with blank.                                                BUG10169
     c                   eval      ScanChar    = ','                                        BUG10169
     c                   exsr      ModShortName                                             BUG10169
                                                                                            BUG10169
      ** Replace ';' in shortnam with blank.                                                BUG10169
     c                   eval      ScanChar    = ';'                                        BUG10169
     c                   exsr      ModShortName                                             BUG10169
 
     c                   if        extnFound
     c                   eval      cptytype    = x#cptytype
     c                   eval      econsect    = x#econsect
     c                   eval      risquain    = x#riskqual
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  The branch specific fields are set in this subroutine.       *
      *                                                               *
      *  Look up the branch data using the customer's branch.         *
      *                                                               *
      *****************************************************************
 
     c     branchFlds    begsr
 
     c                   eval      brIx        = %lookup(bbbrcd
     c                                                 : aBrcd
     c                                                 : 1
     c                                                 : brEl )
 
     c                   if        brIx        > 0
     c                   eval      fiobji      = aFinum(brIx)
     c                   eval      intparre    = aBicnBrcd(brIx)
     c                                         + '-'
     c                                         + aBicn(brIx)
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT                                                                                BUG10169
      *****************************************************************                     BUG10169
      *                                                               *                     BUG10169
      *  ModShortname - Replace all occurence of scan argument in     *                     BUG10169
      *                 field Shortnam with blank.                    *                     BUG10169
      *                                                               *                     BUG10169
      *****************************************************************                     BUG10169
     c     ModShortname  begsr                                                              BUG10169
                                                                                            BUG10169
     c                   eval      MatchPos  = 0                                            BUG10169
                                                                                            BUG10169
     c                   Dou       MatchPos  = 0                                            BUG10169
     c                   eval      StrPos    = MatchPos + 1                                 BUG10169
     c                   eval      MatchPos  = %scan(ScanChar:Shortnam:StrPos)              BUG10169
                                                                                            BUG10169
      ** if ScanChar found, replace it with blank.                                          BUG10169
     c                   if        MatchPos  > 0                                            BUG10169
     c                   eval      %subst(Shortnam:MatchPos:1) = ' '                        BUG10169
     c                   endif                                                              BUG10169
     c                   enddo                                                              BUG10169
                                                                                            BUG10169
     c                   endsr                                                              BUG10169
                                                                                            BUG10169
      *****************************************************************                     BUG10169
      /EJECT
      *****************************************************************
      *                                                               *
      *  counterRec - Subroutine that writes records to RN_COUNTER.   *
      *                                                               *
      *****************************************************************
     c     counterRec    begsr
 
     c                   write     t__counter
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ratiextRec - Subroutine that writes records to RN_RATIEX.    *
      *                                                               *
      *****************************************************************
     c     ratiextRec    begsr
 
     c                   if        extnFound
     c                   eval      cddfexra    = x#striskrt
     c                   endif
     c                   eval      shorterm    = 2
     c                   write     t__ratiext
 
     c                   if        extnFound
     c                   eval      cddfexra    = x#ltriskrt
     c                   endif
     c                   eval      shorterm    = 1
     c                   write     t__ratiext
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  counapjRec - Subroutine that writes records to RN_COUNAPJ.   *
      *                                                               *
      *****************************************************************
     c     counapjRec    begsr
 
     c                   if        extnFound
     c                   eval      identity    = x#idencode
     c                   eval      secclahk    = x#hksectcl
     c                   eval      secclacn    = x#cnsectcl
     c                   eval      secclasg    = x#sgsectcl
     c                   eval      partsize    = x#ownrperc
     c                   eval      relatype    = x#relntype
     c                   eval      chininfl    = x#chininfl
     c                   eval      resindhk    = x#hkressts
     c                   eval      resindsg    = x#sgressts
     c                   endif
 
     c                   write     t__counapj
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  counusRec - Subroutine that writes records to RN_COUNUS.     *
      *                                                               *
      *****************************************************************
     c     counusRec     begsr
 
      ** Since residenc field has been set up in sr. commonFlds, need to                    BUG11157
      ** set it blank first in case extnFound = '0' (ie, no extension                       BUG11157
      ** record for the customer).                                                          BUG11157
     c                   eval      residenc    = *blank                                     BUG11157
     c                   if        extnFound
     c                   eval      intcptty    = x#intctype
     c                   eval      cpttypus    = x#insttype
     c                   eval      residenc    = x#cprtyres                                 BUG11157
     c                   endif
 
     c                   write     t__counus
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ctpfimRec - Subroutine that writes records to RN_CTPFIM.     *
      *                                                               *
      *****************************************************************
     c     ctpfimRec     begsr
 
     c                   select
     c                   when      bbbsin      = 'H'
     c                   eval      lgetype     = 1
 
     c                   when      bbbsin      = 'B'
     c                   eval      lgetype     = 2
 
     c                   when      (   bbbsin  = 'P'
     c                             or  bbbsin  = 'W' )
     c                   eval      lgetype     = 3
 
     c                   other
     c                   eval      lgetype     = 2
     c                   endsl
 
     c                   write     t__ctpfim
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ctpfimuRec - Subroutine that writes records to RN_CTPFIMU.   *
      *                                                               *
      *****************************************************************
     c     ctpfimuRec    begsr
 
     c                   write     t__ctpfimu
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getExtnFlds - Subroutine that retrieves extension fields.    *
      *                                                               *
      *****************************************************************
     c     getExtnFlds   begsr
 
     c     bbcust        chain     sdcustxb
     c                   eval      extnFound   = %found
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getAcus - Subroutine that retrieves additional customer      *
      *            details.                                           *
      *                                                               *
      *****************************************************************
     c     getAcus       begsr
 
     c     bbcust        chain     sdacusl0
     c                   eval      acusFound   = %found
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  bootstrap - Subroutine that writes records to T__DFBOO.      *
      *                                                               *
      *****************************************************************
     c     bootstrap     begsr
 
     c                   for       brIx        = 1 to brEl
     c     aLotTyp(brIx) setll     t__dfboo
 
     c                   if        not %equal
     c                   eval      lottypfk    = aLotTyp(brIx)
 
     c                   monitor
     c                   write     t__dfboof
     c                   on-error  dupKey
     c                   endmon
 
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
     c*****              if        pRtnCod    <> *blanks                           BUG10501 BUG10560
     c                   if        pRtnCod    <> *blanks  and                               BUG10560
     c                             pRtnCod    <> '*NRF'                                     BUG10560
     c                   eval      wDbmod      = 'AOBRCHR0'                                 BUG10501
     c                   eval      wDbase      = 21                                         BUG10501
     c                   eval      wDbkey      = RBBRCD                                     BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501
 
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
 
      ** Get bank details.
     c                   callb     'AOBANKR0'
     c**********         parm      '*DBERR'      pRtnCod                                    BUG10501
     c                   parm      *blanks       pRtnCod                                    BUG10501
     c                   parm      '*FIRST'      pOption
     c     sdbank        parm                    dsfdy
                                                                                            BUG10501
     c                   if        pRtnCod    <> *blanks                                    BUG10501
     c                   eval      wDbmod      = 'AOBANKR0'                                 BUG10501
     c                   eval      wDbase      = 22                                         BUG10501
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
     c                   eval      wDbase      = 23                                         BUG10501
     c                   eval      wDbkey      = pOption                                    BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501
 
      * Derive event control date.
     c                   if        bkapdt      < bjdnwd
     c                   eval      evtDatIso   = %date(rnDayCnv(bkapdt))
     c                   else
     c                   eval      evtDatIso   = %date(rnDayCnv(bjdnwd - 1))
     c                   endif
 
      ** Access Regulatory Authority control data, and load arrays.
      ** Also, this extract should only run if at least one of the
      ** transaction extracts is due to run.
     c                   eval      dueToRun    = *off
     c                   eval      brEl        = 0
 
     c                   if        pRaid       = *blanks
     c     *start        setll     gpregbj0
     c                   read      gpregbj0
     c                   else
     c     pRaid         setll     gpregbj0
     c     pRaid         reade     gpregbj0
     c                   endif
 
     c                   dow       not %eof
     c                   if        rfzone      = pZone
 
     c                   if        rfextdate  <= evtDatIso
     c                   eval      dueToRun    = *on
     c                   endif
 
      ** Load array elements for each branch, if not already present.
      ** One element for position lot:
 
     c                   if        (   brEl    = 0
     c                             or  %lookup(rbbrcd:aBrcd:1:brEl) = 0 )
     c                   exsr      getBranch
     c                   eval      brEl        = brEl + 1
     c                   eval      aBrcd(brEl) = rbbrcd
     c                   eval      aFinum(brEl) = rbfinum
     c                   eval      aLotTyp(brEl) = rbposlot
     c                   eval      aLotTypDup(brEl) = *off
     c                   eval      aRptEnt(brEl) = rbrptent
     c                   if        pRtnCod    = *blanks                                     BUG10560
     c                   eval      aBicn(brEl) = a8bicn
 
     c     a8bicn        chain     sdcustl0
     c                   if        %found
     c                   eval      aBicnBrcd(brEl) = l0#bbbrcd
     c                   else
     c                   eval      wDbfile     ='SDCUSTL0'
     c                   eval      wDbase      = 2
     c                   eval      wDbkey      = a8bicn
     c                   exsr      *pssr
     c                   endif
     c                   endif                                                              BUG10560
 
      ** One element for movement lot:
 
     c                   eval      brEl        = brEl + 1
     c                   eval      aBranchData(brEl)
     c                                         = aBranchData(brEl-1)
     c                   eval      aLotTyp(brEl) = rbmovlot
 
     c                   endif
     c                   endif
 
     c                   if        pRaid       = *blanks
     c                   read      gpregbj0
     c                   else
     c     pRaid         reade     gpregbj0
     c                   endif
     c                   enddo
 
      ** Flag duplicate lot types.
 
     c                   if        brEl        > 1
     c                   for       brIx = brEl downto 2
 
     c                   if        %lookup(aLotTyp(brIx)
     c                                   : aLotTyp
     c                                   : 1
     c                                   : brIx -1 ) > 0
     c                   eval      aLotTypDup(brIx) = *on
     c                   endif
 
     c                   endfor
     c                   endif
 
      ** If not due to run (ie no transaction extracts will run),
      ** or no applicable branches, then closedown.
     c                   if        not dueToRun
     c                             or  brEl    = 0
     c                   exsr      closedown
     c                   endif
 
      ** Check for feature CRN002.
     c                   callb     'AOSARDR0'
     c                   parm      *blanks       pRtnCod
     c                   parm      '*VERIFY'     pOption
     c                   parm      'CRN002'      pSar
 
     c                   if        pRtnCod     = *blanks
     c                   eval      CRN002      = *on
 
     c                   elseif    pRtnCod     = '*NRF'
     c                   eval      CRN002      = *off
 
     c                   else
     c                   eval      wDbase      = 3
     c                   eval      wDbmod      = 'AOSARDR0'
     c                   exsr      *pssr
     c                   endif
 
      ** Check for feature CRN006.
     c                   callb     'AOSARDR0'
     c                   parm      *blanks       pRtnCod
     c                   parm      '*VERIFY'     pOption
     c                   parm      'CRN006'      pSar
 
     c                   if        pRtnCod     = *blanks
     c                   eval      CRN006      = *on
 
     c                   elseif    pRtnCod     = '*NRF'
     c                   eval      CRN006      = *off
 
     c                   else
     c                   eval      wDbase      = 4
     c                   eval      wDbmod      = 'AOSARDR0'
     c                   exsr      *pssr
     c                   endif
 
      ** Feature CRN002 is present
     c                   if        CRN002
     c                   open      rn_counapj
     c                   endif
 
      ** Feature CRN006 is present
     c                   if        CRN006
     c                   open      rn_counus
     c                   open      rn_ctpfimu
     c                   endif
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      /copy rncpysrc,rnpssrsr
      *****************************************************************
 
**ctdata cpy@
(c) Finastra International Limited 2005
