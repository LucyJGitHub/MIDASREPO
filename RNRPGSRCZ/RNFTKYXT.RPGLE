     h debug
     h copyright('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Account Keys Extract')                        *
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNFTKYXT   - Midas FT Account Keys Extract                   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP212             Date 15Sep14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG15105A          Date 25Oct07               *
      *                 BUG15105           Date 23Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG10742           Date 08May06               *
      *                 CSD027A            Date 10May06               *
      *                 BUG9792            Date 20Mar06               *
      *                 BUG10804           Date 10Mar06               *
      *                 BUG10623           Date 27Feb06               *
      *                 BUG10667           Date 22Feb06               *
      *                 BUG9853            Date 16Feb06               *
      *                 BUG9799            Date 16Feb06               *
      *                 BUG10501           Date 09Feb06               *
      *                 BUG9705            Date 24Jan06               *
      *                 CRN001  *Create    Date 20Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP212 - FT Nostro Transfer API (Recompile)                  *
      *  BUG15105A - Missing process for SWIFT 2007 (Reopen)          *
      *  BUG15105 - Missing process for SWIFT 2007                    *
      *  BUG10742 - AC key in files RNAUMVPD and RNXCMVPD changed to  *
      *             20A due to CDL038. Recompile is needed.           *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  BUG9792 - AC key valiation enhancement: apply suppression    *
      *            rules.                                             *
      *  BUG10804 - RN_UICUSA format has changed for FRS Data         *
      *             Foundation 2.9.3.                                 *
      *  BUG10623 - If Associated Customer is 000000 then dont        *
      *             call getCust for this customer.                   *
      *  BUG10667 - RN_MOVLEGA was not set to latest T__MOVLEGA       *
      *             format at last compilation - recompile only.      *
      *  BUG9853 - T__MOVLEGA format changed.                         *
      *  BUG9799  - Rn_movleg now keyed. Write unique values by       *
      *             appending sequence number to leg reference.       *
      *  BUG10501 - Parameter value '*DBERR' is not correct for       *
      *             access object running in CoB.                     *
      *  BUG9705 - Account key mapping uses wrong key fields and      *
      *            should map to records of same zone only.           *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     ffpkeyl2   if   e           k disk    infsr(*pssr)
 
     fgpregbj0  if   e           k disk    infsr(*pssr)
 
     ** This file is not used in this program.                                              BUG9792
     f*****sdbankpd  if   e           k disk    infsr(*pssr)                                BUG9792
 
     fotpay     if   e           k disk    infsr(*pssr)
     f                                     prefix(o#)
 
     finpay     if   e           k disk    infsr(*pssr)
     f                                     prefix(i#)
 
     finpayxl0  if   e           k disk    infsr(*pssr)
 
     fcqpac1    if   e           k disk    infsr(*pssr)
     f                                     prefix(c1#)
 
     fcqpaddl1  if   e           k disk    infsr(*pssr)
     f                                     prefix(c2#)
 
     fcqcocdl1  if   e           k disk    infsr(*pssr)
     f                                     prefix(c3#)
 
     fcqcod     if   e           k disk    infsr(*pssr)
     f                                     ignore(cqcocddf)
     f                                     prefix(c4#)
 
     fntran     if   e           k disk    infsr(*pssr)
     f                                     prefix(n#)
 
     fft101dl0  if   e           k disk    infsr(*pssr)
     f                                     prefix(f1#)
 
     fft101hl3  if   e           k disk    infsr(*pssr)
     f                                     prefix(f2#)
 
     fft102dl0  if   e           k disk    infsr(*pssr)
     f                                     prefix(f3#)
 
     fft102hl3  if   e           k disk    infsr(*pssr)
     f                                     prefix(f4#)
 
     frn_movemenif a e           k disk    infsr(*pssr)
 
     f******rn_movleg o    e       disk    infsr(*pssr)                                      BUG9799
     frn_movleg if a e           k disk    infsr(*pssr)                                      BUG9799
 
     frn_movlegao    e             disk    infsr(*pssr)
     f                                     usropn
     f                                     prefix(m#)
 
     frn_uicusa if a e           k disk    infsr(*pssr)
 
     frnaumvpd  o    e             disk    infsr(*pssr)
 
     frnxcmvpd  o    e             disk    infsr(*pssr)
 
     ft__dfboo  if a e           k disk    infsr(*pssr)
     f                                     rename(t__dfboo:t__dfboof)
 
     ft_frsamap if a e           k disk    infsr(*pssr)
     f                                     rename(t_frsamap:t_frsamapf)
 
     ft_rnamad  if a e           k disk    infsr(*pssr)
     f                                     rename(t_rnamad:t_rnamadpf)
 
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
     d sdnost        e ds                  extname(sdnostpd)
     d  qqaccdx      e                     extfld(qqaccd)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     d pRaid           s                   like(rbRaid)
     d rsnCde          s                   like(xmrsncde)
     d runDatIso       s               D
     d runDatIso8      s              8
     d evtDatIso       s               d
     d CRN002          s               n
     d trans           s              2
     d acctkey         s                   like(acckey)
     d kfdCurrency     s                   like(Currency)                                    BUG9705
     d #acbn           s              2
     d settleacct      s             10
     d #cnum           s              6
     d #acod           s             10
     d #acsq           s              2
     d kExsub          s              4    INZ('FTKY')
     d rtnMap          s                   like(movamou)
     d accountkey      s                   like(akey)
     d loopft          s              1
     d endloop         s              1
     d #crpy           s             18
     d #crpy1char      s              6
     d #crpy2char      s             12
     d*#crpy1num       s              6  0                                                   CSD027A
     d*#crpy2num       s             12  0                                                   CSD027A
     d payrec          s              1
     d legSeq          s              5p 0                                                   BUG9799
 
     d pRtnCod         s              7
     d pOption         s              7
     d pKey1           s             10
     d pKyst           s              7
     d pBrca           s              3
     d pCcy            s              3
     d pSar            s              6
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
 
     d extrid          ds
     d  dealno                        6s 0
 
     d dupKey          c                   01021
 
     d rtnProduct      s                   like(product)
     d Suppressed      s                   like(rnAcKyLs)                                    BUG9792
 
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
 
      ** Used in plist RNPRODMAP
     d pCust           s              6
     d pCycd           s                   like(n#ccy)
     d pAccd           s              4
     d pAcsn           s              2
     d pNonb           s              2
     d pBrcd           s              3
     d pCssn           s             10
     d pPnoi           s              1
 
      /copy rncpysrc,rnrgaudfn
 
      /copy rncpysrc,rndaycnv
      /copy rncpysrc,rnamtcnv
      /copy rncpysrc,rnpayrec
      /copy rncpysrc,rnackylsd1                                                              BUG9792
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+
 
     c     *entry        plist
     c                   parm                    pRaid
 
     c     kT_rnamad     klist
     c                   kfld                    rnbrca
     c                   kfld                    rncnum
     c                   kfld                    rnccy
     c                   kfld                    rnacod
     c                   kfld                    rnacsq
 
      ** Key for t_frsamap                                                                   BUG9705
     c     kt_frsamap    klist                                                               BUG9705
     c                   kfld                    acctkey                                     BUG9705
     c                   kfld                    kfdCurrency                                 BUG9705
     c                   kfld                    pzone                                       BUG9705
                                                                                             BUG9799
     c     kMovleg       klist                                                               BUG9799
     c                   kfld                    moveref                                     BUG9799
     c                   kfld                    legref                                      BUG9799
                                                                                             BUG9705
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
 
     c     *loval        setll     fpkeyl2
     c                   read      fpkeyl2
     c                   dow       not %eof
 
      ** Check if record is to be extracted.
     c                   eval      rgIx = %lookup(brca:aBrcd:1:rgEl)
     c                   if        (   rgIx        >  0
     c                             and aNxDt(rgIx) <= evtDatIso )
 
      ** Get key map code
     c                   exsr      chkAcctKeyMap
 
     c                   if        RtnMap   > 0
     c                   exsr      chkPayRec
     c                   if        payrec <> *blank
     c                   exsr      mapData
     c                   endif
     c                   endif
 
     c                   endif
     c                   read      fpkeyl2
     c                   enddo
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * chkAcctKeyMap - Check account key map                             *
      *                                                                   *
      *********************************************************************
     c     chkAcctKeyMap begsr
 
      ** If the account key is suppressed, do not check for selection.                       BUG9792
     c                   eval      Suppressed  = rnAcKyLs(akey                               BUG9792
     c                                                  : eccy                               BUG9792
     c                                                  : bjcycd )                           BUG9792
     c                   if        Suppressed                                                BUG9792
     c                   eval      rtnMap      = 0                                           BUG9792
     c                   leavesr                                                             BUG9792
     c                   endif                                                               BUG9792
                                                                                             BUG9792
      ** set up key fields to access t_frsamap                                               BUG9705
     c                   eval      acctkey     = akey
 
      ** Check if event currency                                                             BUG9705
     c                   eval      kfdCurrency   = eccy                                      BUG9705
     c*****acctkey       chain     t_frsamap                                                 BUG9705
     c     Kt_frsamap    chain     t_frsamap                                                 BUG9705
 
      ** Check if all currency excluding base
     c                   if        not %found
     c                   if        eccy <> bjcycd                                            BUG9792
     c*****              eval      %subst( acctkey: 6: 3 )                                   BUG9705
     c*****                        = '*XB'                                                   BUG9705
     c                   eval      kfdCurrency   = '*XB'                                     BUG9705
     c*****acctkey       chain     t_frsamap                                                 BUG9705
     c     Kt_frsamap    chain     t_frsamap                                                 BUG9705
     c                   endif                                                               BUG9792
     c                   endif
 
      ** Check if all currency
     c                   if        not %found
     c*****              eval      %subst( acctkey: 6: 3 )                                   BUG9705
     c*****                        = '***'                                                   BUG9705
     c                   eval      kfdCurrency = '***'                                       BUG9705
     c*****acctkey       chain     t_frsamap                                                 BUG9705
     c     Kt_frsamap    chain     t_frsamap                                                 BUG9705
     c                   endif
 
     c                   if        not %found
      ***Reset*account*key                                                                   BUG9705
     c*****              eval      acctkey     = akey                                        BUG9705
 
      ** Use wildcard for deal subtype
     c                   eval      %subst( acctkey: 4: 2 )
     c                             = '**'
     c                   eval      kfdCurrency   = eccy                                      BUG9705
     c*****acctkey       chain     t_frsamap                                                 BUG9705
     c     Kt_frsamap    chain     t_frsamap                                                 BUG9705
     c                   endif
 
      ** Check if all currency excluding base (wildcard deal subtype)
     c                   if        not %found
     c                   if        eccy <> bjcycd                                            BUG9792
     c*****              eval      %subst( acctkey: 6: 3 )                                   BUG9705
     c*****                        = '*XB'                                                   BUG9705
     c                   eval      kfdCurrency = '*XB'                                       BUG9705
     c*****acctkey       chain     t_frsamap                                                 BUG9705
     c     Kt_frsamap    chain     t_frsamap                                                 BUG9705
     c                   endif                                                               BUG9792
     c                   endif
 
      ** Check if all currency (wildcard deal subtype)
     c                   if        not %found
     c*****              eval      %subst( acctkey: 6: 3 )                                   BUG9705
     c*****                        = '***'                                                   BUG9705
     c                   eval      kfdCurrency = '***'                                       BUG9705
     c*****acctkey       chain     t_frsamap                                                 BUG9705
     c     Kt_frsamap    chain     t_frsamap                                                 BUG9705
     c                   endif
 
     c                   if        not %found
      ** Reset account key
     c                   eval      acctkey     = akey
      ** Use wildcard for deal type/subtype
     c                   eval      %subst( acctkey: 1: 2 )
     c                             = '**'
     c                   eval      %subst( acctkey: 4: 2 )
     c                             = '**'
     c                   eval      kfdCurrency   = eccy                                      BUG9705
     c*****acctkey       chain     t_frsamap                                                 BUG9705
     c     Kt_frsamap    chain     t_frsamap                                                 BUG9705
     c                   endif
 
      ** Check if all currency excluding base (wildcard deal type/subtype)
     c                   if        not %found
     c                   if        eccy <> bjcycd                                            BUG9792
     c*****              eval      %subst( acctkey: 6: 3 )                                   BUG9705
     c*****                        = '*XB'                                                   BUG9705
     c                   eval      kfdCurrency = '*XB'                                       BUG9705
     c*****acctkey       chain     t_frsamap                                                 BUG9705
     c     Kt_frsamap    chain     t_frsamap                                                 BUG9705
     c                   endif                                                               BUG9792
     c                   endif
 
      ** Check if all currency (wildcard deal type/subtype)
     c                   if        not %found
     c*****              eval      %subst( acctkey: 6: 3 )                                   BUG9705
     c*****                        = '***'                                                   BUG9705
     c                   eval      kfdCurrency = '***'                                       BUG9705
     c*****acctkey       chain     t_frsamap                                                 BUG9705
     c     Kt_frsamap    chain     t_frsamap                                                 BUG9705
     c                   endif
 
     c                   if        not %found
     c                   eval      rtnMap      = 0
     c                   eval      rsnCde      = 'M'
     c                   exsr      wrtExcptn
     c                   else
     c                   eval      rtnMap      = movetype
     c                   endif
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * chkPayRec - Check Account Key representation                      *
      *                                                                   *
      *********************************************************************
     c     chkPayRec     begsr
 
     c                   eval      accountkey  = akey
     c                   if            %subst(accountkey:6:1) <> *blank
     c                             and %subst(accountkey:7:1) <> *blank
     c                             and %subst(accountkey:8:1) <> *blank
     c                   eval      %subst(accountkey:6:3) = 'zzz'
     c                   endif
     c                   eval      %subst(accountkey:4:2) = 'yy'
 
     c                   eval      payrec      = rnPayRec(accountkey)
 
      ** If not found, generate exception record
     c                   if        payrec      = '*'
     c                   eval      payrec      = *blanks
     c                   eval      rsnCde      = 'P'
     c                   exsr      wrtExcptn
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  mapData   - Subroutine that maps data to be written to files *
      *                                                               *
      *****************************************************************
     c     mapData       begsr
 
     c                   clear                   t__movemen
     c                   clear                   t__movleg
     c                   clear                   t__movlega
     c                   clear                   t__uicusa
 
     c                   eval      trans = %subst(akey:1:2)
     c                   exsr      rtvFiles
     c                   eval      endloop  = 'N'
 
     c                   dow       endloop = 'N'
 
     c                   exsr      movemenRec
     c                   exsr      moveLeg
     c                   if        CRN002
     c                   exsr      moveLegAPJ
     c                   endif
     c                   exsr      UICustAcc
 
     c                   if        loopft <> 'Y'
     c                   eval      endloop  = 'Y'
     c                   else
 
     c                   if        trans = 'RI'
     c                             or trans = 'RO'
     c     pref          reade     ft101dd0
     c                   else
     c     pref          reade     ft102dd0
     c                   endif
 
     c                   if        %eof
     c                   eval      endloop  = 'Y'
     c                   endif
     c                   endif
 
     c                   enddo
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  movemenRec - Subroutine that writes Records To rn_movemen    *
      *                                                               *
      *****************************************************************
     c     movemenRec    begsr
 
     c                   eval      pKey1       = a8bicn
     c                   exsr      getCust
     c                   eval      intparre    = bbbrcd
     c                                         + '-'
     c                                         + a8bicn
 
     c                   eval      moveref     = brca
     c                                         + 'FT'
     c                                         + %trimr(pref)
     c                                         + %editc(cqsq: 'X')
     c                                         + runDatIso8
     c     moveref       chain     t__movemen
     c                   if        not(%found)
 
     c                   eval      rowId       = 0
     c                   eval      statusl2    = 5
     c                   eval      modfdate    = *blanks
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      rowType     = 0
     c                   eval      sourref     = pzone
     c                   eval      bankref     = *blanks
     c                   eval      globindi    = *zeros
 
     c                   select
     c                   when      trans  = 'OP'
     c                   if        %subst(o#rco1:1:1) = '/'
     c                             and o#rco2 <> *blanks
     c                   eval      corrvia     = o#rco2
     c                   else
     c                   eval      corrvia     = o#rco1
     c                   endif
 
     c                   when      trans  = 'IN'
     c                   if        %subst(i#inrco1:1:1) = '/'
     c                             and i#inrco2 <> *blanks
     c                   eval      corrvia     = i#inrco2
     c                   else
     c                   eval      corrvia     = i#inrco1
     c                   endif
 
     c                   when      trans  = 'CP'
     c                   if        %subst(c1#rco1:1:1) = '/'
     c                             and c1#rco2 <> *blanks
     c                   eval      corrvia     = c1#rco2
     c                   else
     c                   eval      corrvia     = c1#rco1
     c                   endif
 
     c                   when      trans  = 'CC'
     c**********         eval      corrvia     = %editc(c4#rcco:'X')                         CSD027A
     c                   eval      corrvia     = c4#rcco                                     CSD027A
 
     c                   when      trans  = 'RI'
     c                             or trans  = 'RO'
     c                   eval      corrvia     = '0'
 
     c                   when      trans  = 'BI'
     c                             or trans  = 'BO'
     c                   eval      corrvia     = f4#rcvcor
 
     c                   when      trans  = 'NT'
     c                   eval      corrvia     = *blanks
     c                   endsl
 
     c                   select
     c                   when      trans    = 'OP'
     c                   select
     c                   when      payrec = 'P'
     c                   if        o#dstt   = 'N'  or o#dstt = 'G'
     c                             or o#dstt = 'F' or o#dstt = 'R'
     c                             or o#dstt = 'P'
     c                   eval      corrto      = o#dst1
     c                   else
     c**********         eval      corrto      = %editc(o#snco:'X')                          CSD027A
     c                   eval      corrto      = o#snco                                      CSD027A
     c                   endif
     c                   when      payrec = 'R'
     c                   if        o#orct   = 'N'  or o#orct = 'G'
     c                             or o#orct = 'F' or o#orct = 'R'
     c                             or o#orct = 'P'
     c                             or o#orct = 'I'                                         BUG15105A
     c                   if        %subst(o#orc1:1:1) <> '/'                                BUG15105
     c                   eval      corrto      = o#orc1
     c                   else                                                               BUG15105
     c**********         if        o#orct = 'C' or o#orct = 'S'                   BUG15105 BUG15105A
     c**********         eval      corrto = o#orc2                                BUG15105 BUG15105A
     c**********         else                                                     BUG15105 BUG15105A
     c                   eval      corrto = %subst(o#orc1:2:34)                             BUG15105
     c**********         endif                                                    BUG15105 BUG15105A
     c                   endif                                                              BUG15105
     c                   else
     c**********         eval      corrto      = %editc(o#orbk:'X')                          CSD027A
     c                   eval      corrto      = o#orbk                                      CSD027A
     c                   endif
     c                   endsl
 
     c                   when      trans    = 'IN'
     c                   select
     c                   when      payrec = 'P'
     c                   if        i#bnct   = 'N'  or i#bnct = 'G'
     c                             or i#bnct = 'F' or i#bnct = 'R'
     c                             or i#bnct = 'P'
     c                             or i#bnct = 'I'                                         BUG15105A
     c                   if        %subst(i#bnc1:1:1) <> '/'                               BUG15105A
     c                   eval      corrto      = i#bnc1
     c                   else                                                              BUG15105A
     c                   eval      corrto = %subst(i#bnc1:2:34)                            BUG15105A
     c                   endif                                                             BUG15105A
     c                   else
     c                   eval      corrto      = i#acbk
     c                   endif
     c                   when      payrec = 'R'
     c                   if        i#sntp   = 'N'  or i#sntp = 'G'
     c                             or i#sntp = 'F' or i#sntp = 'R'
     c                             or i#sntp = 'P'
     c                   eval      corrto      = i#snd1
     c                   else
     c                   if        i#rcrt   = 'N'  or i#rcrt = 'G'
     c                             or i#rcrt = 'F' or i#rcrt = 'R'
     c                             or i#rcrt = 'P'
     c**********         eval      corrto      = %editc(i#rcco:'X')                          CSD027A
     c                   eval      corrto      = i#rcco                                      CSD027A
     c                   else
     c                   eval      corrto      = intrib
     c                   endif
     c                   endif
     c                   endsl
 
     c                   when      trans    = 'CC'
     c                   select
     c                   when      payrec = 'P'
     c                   movel     c3#crpy       #crpy
     c                   eval      #crpy1char = %subst(#crpy:1:6)
     c                   eval      #crpy2char = %subst(#crpy:7:12)
     c**********         movel     #crpy1char    #crpy1num                                   CSD027A
     c**********         movel     #crpy2char    #crpy2num                                   CSD027A
     c**********         if        #crpy1num <> 0                                            CSD027A
     c**********                   and #crpy2num = 0                                         CSD027A
     c**********         eval      corrto      = %editc(c3#crpy:'X')                         CSD027A
     c                   if        #crpy1char <> *BLANKS                                     CSD027A
     c                             and #crpy2char = *BLANKS                                  CSD027A
     c                   eval      corrto      = c3#crpy                                     CSD027A
     c                   endif
     c                   when      payrec = 'R'
     c                   if        c4#cobt  = 'N'   or c4#cobt = 'G'
     c                             or c4#cobt = 'F' or c4#cobt = 'R'
     c                             or c4#cobt = 'P'
     c                   eval      corrto      = c4#cob1
     c                   else
     c**********         eval      corrto      = %editc(c4#rcco: 'X')                        CSD027A
     c                   eval      corrto      = c4#rcco                                     CSD027A
     c                   endif
     c                   endsl
 
     c                   when      trans    = 'CP'
     c                   select
     c                   when      payrec = 'P'
     c                   if        c1#rbkt  = 'N'   or c1#rbkt = 'G'
     c                             or c1#rbkt = 'F' or c1#rbkt = 'R'
     c                             or c1#rbkt = 'P'
     c                   eval      corrto      = c1#rbk1
     c                   else
     c**********         eval      corrto      = %editc(c1#snco:'X')                         CSD027A
     c                   eval      corrto      = c1#snco                                     CSD027A
     c                   endif
     c                   when      payrec = 'R'
     c**********         eval      corrto      = %editc(c2#drpy: 'X')                        CSD027A
     c                   eval      corrto      = c2#drpy                                     CSD027A
     c                   endsl
 
     c                   when      trans    = 'RI'
     c                   select
     c                   when      payrec = 'P'
     c                   eval      corrto      = f2#hocus1
     c                   when      payrec = 'R'
     c                   if        f1#benttp = 'N'   or f1#benttp = 'G'
     c                             or f1#benttp = 'F' or f1#benttp = 'R'
     c                             or f1#benttp = 'P'
     c                   eval      corrto      = f1#tbna35
     c                   else
     c                   if        f1#awittp = 'N'   or f1#awittp = 'G'
     c                             or f1#awittp = 'F' or f1#awittp = 'R'
     c                             or f1#awittp = 'P'
     c                   eval      corrto      = f1#taca35
     c                   else
     c                   eval      corrto      = f1#tinsta
     c                   endif
     c                   endif
     c                   endsl
 
     c                   when      trans    = 'RO'
     c                   eval      corrto      = *blanks
 
     c                   when      trans    = 'BI'
     c                   select
     c                   when      payrec = 'P'
     c                   if        f3#benttd = 'N'   or f3#benttd = 'G'
     c                             or f3#benttd = 'F' or f3#benttd = 'R'
     c                             or f3#benttd = 'P'
     c                   eval      corrto      = f3#benf1
     c                   else
     c                   eval      corrto      = f3#acci11
     c                   endif
     c                   when      payrec = 'R'
     c                   if        f4#sinstt = 'N'   or f4#sinstt = 'G'
     c                             or f4#sinstt = 'F' or f4#sinstt = 'R'
     c                             or f4#sinstt = 'P'
     c                   eval      corrto      = f4#sinst
     c                   else
     c                   if        f4#sndtyp = 'N'   or f4#sndtyp = 'G'
     c                             or f4#sndtyp = 'F' or f4#sndtyp = 'R'
     c                             or f4#sndtyp = 'P'
     c                   eval      corrto      = f4#sndcor
     c                   else
     c                   eval      corrto      = f4#rcvcor
     c                   endif
     c                   endif
     c                   endsl
 
     c                   when      trans    = 'NT'
     c                   select
     c                   when      payrec = 'P'
     c                   eval      corrto      = %editc(n#acbn:'X')
     c                   when      payrec = 'R'
     c                   eval      corrto      = %editc(n#dest:'X')
     c                   endsl
 
     c                   endsl
 
     c                   eval      corrvia2    = *blanks
     c                   eval      corrto2     = *blanks
 
     c                   eval      paymtxt     = brca
     c                                         + 'FT'
     c                                         + %trimr(pref)
     c                                         + %editc(cqsq:'X')
     c                                         + runDatIso8
     c                   eval      inteli      = 0
     c                   eval      cancella    = *blanks
     c                   eval      expesett    = rndaycnv(epsd)
     c                   eval      actusett    = rndaycnv(epsd)
     c                   eval      correcti    = 0
     c                   eval      portfoli    = 0
     c                   eval      contract    = 0
     c                   eval      movement    = 3
 
     c                   eval      aPosLotUsed(rgIx) = *on
 
     c                   write     t__movemen
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  moveLeg    - Subroutine that writes Records To rn_movleg     *
      *                                                               *
      *****************************************************************
     c     moveLeg       begsr
 
     c                   eval      rowId       = 0
     c                   eval      statusl2    = 5
     c                   eval      modfdate    = *blanks
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      rowType     = 0
     c**********         eval      legref      = akey                                        BUG9799
     c                   eval      leglinre    = brca
     c                                         + 'FT'
     c                                         + %trimr(pref)
     c                                         + %editc(cqsq:'X')
     c                   eval      uiref       = seac
     c                   eval      insttype    = 1
     c                   eval      transact    = 0
 
     c**********         eval      pKey1       = %editc(fpasoc:'X')                          CSD027A
     c                   eval      pKey1       = fpasoc                                      CSD027A
      ** If associated customer is '000000' then don't call getCust                         BUG10623
     c                   if        pKey1       <> '000000'                                  BUG10623
     c                   exsr      getCust
     c                   eval      counref     = bbbrcd
     c                                         + '-'
     c                                         + fpasoc                                      CSD027A
     c**********                               + %editc(fpasoc:'X')                          CSD027A
     c                   else                                                               BUG10623
     c                   eval      counref     = *blanks                                    BUG10623
     c                   endif                                                              BUG10623
 
     c                   eval      moveref     = brca
     c                                         + 'FT'
     c                                         + %trimr(pref)
     c                                         + %editc(cqsq:'X')
     c                                         + runDatIso8
     c                   eval      paymtxt     = brca
     c                                         + 'FT'
     c                                         + %trimr(pref)
     c                                         + %editc(cqsq:'X')
     c                                         + akey
     c                   eval      accomov     = 0
 
     c                   if        payrec = 'P'
     c                   eval      dcindi      = 2
     c                   else
     c                   eval      dcindi      = 1
     c                   endif
 
     c                   eval      bsindi      = 1
     c                   eval      thirindi    = 0
     c                   eval      setttype    = 3
     c                   eval      movamou     = movetype
     c                   eval      isocurr     = eccy
 
     c                   select
     c                   when      trans  = 'OP'
     c                   if        %subst(o#bnc1:1:6) <> *blanks
     c                             and %subst(o#bnc1:7:29) = *blanks
      ** Get customer details of the beneficiary.
     c                   eval      pKey1       = o#bnc1
     c                   exsr      getCust
     c                   eval      residenc    = bbcncz
     c                   endif
 
     c                   when      trans  = 'IN'
     c                   if        %subst(i#bnc1:1:6) <> *blanks
     c                             and %subst(i#bnc1:7:29) = *blanks
     c                   eval      pKey1       = i#bnc1
     c                   exsr      getCust
     c                   eval      residenc    = bbcncz
     c                   endif
 
     c                   when      trans  = 'CC'
     c                   movel     c3#crpy       #crpy
     c                   eval      #crpy1char = %subst(#crpy:1:6)
     c                   eval      #crpy2char = %subst(#crpy:7:12)
     c**********         movel     #crpy1char    #crpy1num                                   CSD027A
     c**********         movel     #crpy2char    #crpy2num                                   CSD027A
     c**********         if        #crpy1num <> 0                                            CSD027A
     c**********                   and #crpy2num = 0                                         CSD027A
     c                   if        #crpy1char <> *BLANKS                                     CSD027A
     c                             and #crpy2char = *BLANKS                                  CSD027A
     c                   eval      pKey1       = #crpy1char
     c                   exsr      getCust
     c                   eval      residenc    = bbcncz
     c                   endif
 
     c                   when      trans  = 'CP'
     c                   if        %subst(c1#rbk1:1:6) <> *blanks
     c                             and %subst(c1#rbk1:7:29) = *blanks
     c                   eval      pKey1       = c1#rbk1
     c                   exsr      getCust
     c                   eval      residenc    = bbcncz
     c                   endif
 
     c                   when      trans  = 'RI'
     c                             or trans  = 'RO'
     c                   if        %subst(f1#tbna35:1:6) <> *blanks
     c                             and %subst(f1#tbna35:7:29) = *blanks
     c                   eval      pKey1       = f1#tbna35
     c                   exsr      getCust
     c                   eval      residenc    = bbcncz
     c                   endif
 
     c                   when      trans  = 'BI'
     c                   if        %subst(f3#benf1:1:6) <> *blanks
     c                             and %subst(f3#benf1:7:29) = *blanks
     c                   eval      pKey1       = f3#benf1
     c                   exsr      getCust
     c                   eval      residenc    = bbcncz
     c                   endif
 
     c                   when      trans  = 'BO'
     c                   if        %subst(f4#cctdst:1:6) <> *blanks
     c                             and %subst(f4#cctdst:7:29) = *blanks
     c                   eval      pKey1       = f4#cctdst
     c                   exsr      getCust
     c                   eval      residenc    = bbcncz
     c                   endif
 
     c                   when      trans  = 'NT'
     c                   movel     n#acbn        #acbn
     c                   callb     'AONOSTR0'
     c                   parm      *blanks       pRtnCod
     c                   parm      '*KEY'        pOption
     c                   parm                    pCust
     c                   parm      n#ccy         pCycd
     c                   parm                    pAccd
     c                   parm                    pAcsn
     c                   parm      #acbn         pNonb
     c                   parm                    pBrcd
     c                   parm                    pCssn
     c                   parm                    pPnoi
     c     sdnost        parm                    dssdy
     c                   if        pRtnCod = *blanks
     c                   eval      pKey1       = A7CUST
     c                   exsr      getCust
     c                   if        pRtnCod <> *blanks
     c                   eval      residenc    = bbcncz
     c                   endif
     c                   endif
     c                   eval      pKey1       = %subst(seac:1:6)
     c                   exsr      getCust
 
     c                   endsl
 
      ** Get event currency details.
     c                   eval      pCcy        = eccy
     c                   exsr      getCcy
 
     c                   eval(h)   ocaamunt    = %abs(eamt)/(10**a6nbdp)
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
 
     c                   select
     c                   when      trans  = 'OP'
     c                   eval      deal        = rndaycnv(o#oedt)
     c                   when      trans  = 'IN'
     c                   eval      deal        = rndaycnv(i#oedt)
     c                   when      trans  = 'CC'
     c                   eval      deal        = rndaycnv(c4#oedt)
     c                   when      trans  = 'CP'
     c                   eval      deal        = rndaycnv(c1#oedt)
     c                   when      trans  = 'RI'
     c                             or trans  = 'RO'
     c                   eval      deal        = rndaycnv(f2#indate)
     c                   when      trans  = 'BI'
     c                             or trans  = 'BO'
     c                   eval      deal        = rndaycnv(f4#indate)
     c                   when      trans  = 'NT'
     c                   eval      deal        = rndaycnv(n#oedt)
     c                   endsl
 
     c                   eval      tmetrade    = *blanks
     c                   eval      dtetrade    = rndaycnv(vdat)
     c                   eval      value       = rndaycnv(vdat)
     c                   eval      numberof    = 0
                                                                                             BUG9799
     c                   eval      legSeq      = 0                                           BUG9799
     c                   dou       not %equal                                                BUG9799
     c                   eval      legSeq     += 1                                           BUG9799
     c                   eval      legref      = akey                                        BUG9799
     c                                         + %editc(legSeq: 'X')                         BUG9799
     c     kMovleg       setll     rn_movleg                                                 BUG9799
     c                   enddo                                                               BUG9799
 
     c                   write     T__movLeg
 
     c                   exsr      wrtAudit
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  moveLegAPJ - Subroutine that writes Records To rn_movlega    *
      *                                                               *
      *****************************************************************
     c     moveLegAPJ    begsr
 
     c                   eval      m#rowId     = 0
     c                   eval      m#statusl2  = 5
     c                   eval      m#modfdate  = *blanks
     c                   move      runDatIso     m#validon
     c                   eval      m#lottypfk  = aPosLot(rgIx)
     c                   eval      m#rowType   = 0
     c                   eval      m#inteone   = *blanks
     c                   eval      m#intetwo   = *blanks
     c**********         eval      m#legref    = akey                                        BUG9799
     c**********         eval      m#moveref   = brca                                        BUG9799
     c**********                               + 'FT'                                        BUG9799
     c**********                               + %trimr(pref)                                BUG9799
     c**********                               + %editc(cqsq:'X')                            BUG9799
     c**********                               + runDatIso8                                  BUG9799
     c                   eval      m#legref    = legref                                      BUG9799
     c                   eval      m#moveref   = moveref                                     BUG9799
 
     c                   select
     c                   when      trans  = 'OP'
     c                   eval      m#rmbaccnu  = o#orc1
     c                   eval      m#actuexch  = o#rate
     c                   eval      m#ordecust  = o#orc1
     c**********         eval      m#ordeinst  = %editc(o#orbk:'X')                          CSD027A
     c                   eval      m#ordeinst  = o#orbk                                      CSD027A
     c                   eval      m#accwitin  = o#acb1
     c                   eval      m#benecust  = o#bnc1
     c                   eval      m#ovbeacnu  = o#bnc1
     c                   when      trans  = 'IN'
     c                   eval      m#rmbaccnu  = i#bnc1
     c                   eval      m#actuexch  = i#rate
     c                   eval      m#ordecust  = i#orc1
     c                   eval      m#ordeinst  = i#orb1
     c                   eval      m#accwitin  = i#inacb1
     c                   eval      m#benecust  = i#bnc1
     c                   eval      m#ovbeacnu  = i#bnc1
     c                   when      trans  = 'CC'
     c**********         eval      m#rmbaccnu  = %editc(c3#crpy:'X')                         CSD027A
     c                   eval      m#rmbaccnu  = c3#crpy                                     CSD027A
     c                   eval      m#actuexch  = c3#rate
     c                   eval      m#ordecust  = *blanks
     c                   eval      m#ordeinst  = *blanks
     c                   eval      m#accwitin  = *blanks
     c**********         eval      m#benecust  = %editc(c3#crpy:'X')                         CSD027A
     c**********         eval      m#ovbeacnu  = %editc(c3#crpy:'X')                         CSD027A
     c                   eval      m#benecust  = c3#crpy                                     CSD027A
     c                   eval      m#ovbeacnu  = c3#crpy                                     CSD027A
     c                   when      trans  = 'CP'
     c**********         eval      m#rmbaccnu  = %editc(c2#drpy:'X')                         CSD027A
     c                   eval      m#rmbaccnu  = c2#drpy                                     CSD027A
     c                   eval      m#actuexch  = c2#rate
     c                   eval      m#ordecust  = *blanks
     c                   eval      m#ordeinst  = *blanks
     c                   eval      m#accwitin  = c1#acb1
     c**********         eval      m#benecust  = %editc(c2#drpy:'X')                         CSD027A
     c**********         eval      m#ovbeacnu  = %editc(c2#drpy:'X')                         CSD027A
     c                   eval      m#benecust  = c2#drpy                                     CSD027A
     c                   eval      m#ovbeacnu  = c2#drpy                                     CSD027A
     c                   when      trans  = 'RI'
     c                   eval      m#rmbaccnu  = f1#tbna35
     c                   eval      m#actuexch  = f1#xrate
     c                   eval      m#ordecust  = f2#hocus1
     c                   eval      m#ordeinst  = f2#sinst
     c                   eval      m#accwitin  = f1#taca11
     c                   eval      m#benecust  = f1#tbna35
     c                   eval      m#ovbeacnu  = f1#tbna35
     c                   when      trans  = 'RO'
     c                   eval      m#rmbaccnu  = *blanks
     c                   eval      m#actuexch  = 0
     c                   eval      m#ordecust  = *blanks
     c                   eval      m#ordeinst  = *blanks
     c                   eval      m#accwitin  = f1#taca11
     c                   eval      m#benecust  = f1#tbna35
     c                   eval      m#ovbeacnu  = f1#tbna35
     c                   when      trans  = 'BI'
     c                   eval      m#rmbaccnu  = f3#benf1
     c                   eval      m#actuexch  = f3#xrate
     c                   eval      m#ordecust  = f4#tocus1
     c                   eval      m#ordeinst  = f4#oinst1
     c                   eval      m#accwitin  = f3#acci11
     c                   eval      m#benecust  = f3#benf1
     c                   eval      m#ovbeacnu  = f3#benf1
     c                   when      trans  = 'BO'
     c                   eval      m#rmbaccnu  = f4#tocus1
     c                   eval      m#actuexch  = f3#xrate
     c                   eval      m#ordecust  = f4#tocus1
     c                   eval      m#ordeinst  = f4#oinst1
     c                   eval      m#accwitin  = f3#acci11
     c                   eval      m#benecust  = f3#benf1
     c                   eval      m#ovbeacnu  = f3#benf1
     c                   when      trans  = 'NT'
     c                   eval      m#rmbaccnu  = %editc(n#dest:'X')
     c                   eval      m#actuexch  = 0
     c                   eval      m#ordecust  = *blanks
     c                   eval      m#ordeinst  = *blanks
     c                   eval      m#accwitin  = %editc(n#acbn:'X')
     c                   eval      m#benecust  = %editc(n#dest:'X')
     c                   eval      m#ovbeacnu  = %editc(n#dest:'X')
     c                   endsl
      *
     c                   eval      m#principa  = *blanks
     c                   if        payrec    = 'P'
     c                   eval      m#transact  = 40
     c                   else
     c                   eval      m#transact  = 30
     c                   endif
     c                   eval      m#paymmtd   = 0
     c                   eval      m#remittan  = *blanks
     c                   eval      m#settmtd   = 0
     c                   eval      m#medoftr   = 0
 
     c                   if        trans = 'CP' or trans = 'CC'
     c                   eval      m#trancode  = 6
     c                   else
     c                   eval      m#trancode  = 0
     c                   endif
 
     c                   eval      m#limenqre  = *blanks
     c                   eval      m#speappre  = *blanks
 
     c                   write     t__movLega
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UICustAcc  - Subroutine that writes Records To rn_uicusa     *
      *                                                               *
      *****************************************************************
     c     UICustAcc     begsr
 
     c                   eval      uiref       = seac
     c     uiref         chain     t__uicusa
     c                   if        not(%found)
 
     c                   eval      rowId       = 0
     c                   eval      statusl2    = 5
     c                   eval      modfdate    = *blanks
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      rowType     = 0
     c                   eval      accoref     = seac
 
     c                   eval      pBrca       = %subst(seac:22:3)
     c                   exsr      getBranch
     c                   eval      pKey1       = a8bicn
     c                   exsr      getCust
     c                   eval      intparre    = bbbrcd
     c                                         + '-'
     c                                         + a8bicn
 
     c                   eval      contref     = brca
     c                                         + 'FT'
     c                                         + %trimr(pref)
     c                                         + %editc(cqsq:'X')
     c                   eval      nexintfi    = *blanks
     c                   eval      reimfreq    = 0
     c                   eval      perintra    = 0
     c                   eval      intintra    = 0
 
     c                   eval      settleacct  = %subst(SEAC:10:10)
     c                   exsr      GetProdCode
     c                   eval      product     = rtnProduct
 
     c                   eval      alindi      = 0
     c                   eval      risquain    = 0
     c                   eval      reschedu    = 0
 
     c                   eval      rnbrca      = %subst(SEAC:22:3)
     c                   eval      #cnum       = %subst(SEAC:1:6)
     c                   eval      rnccy       = %subst(SEAC:7:3)
     c                   eval      #acod       = %subst(SEAC:10:10)
     c                   eval      #acsq       = %subst(SEAC:20:2)
     c                   movel     #cnum         rncnum
     c                   movel     #acod         rnacod
     c                   movel     #acsq         rnacsq
     c     kT_rnamad     chain     T_rnamadpf
     c                   if        %found
     c                   eval      purpose     = PURPOSET
     c                   endif
 
     c                   eval      typintra    = 3
     c                   eval      portfoli    = 0                                          BUG10804
 
     c                   write     t__uicusa
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  rtvFiles   - Retrieve files                                  *
      *                                                               *
      *****************************************************************
     c     rtvFiles      begsr
 
     c                   eval      loopft = 'N'
 
      ** Get internal customer
     c                   eval      pBrca       = brca
     c                   exsr      getBranch
 
     ** Get files depending on transaction type
     c                   select
     c                   when      trans = 'CP'
     c                   clear                   cqpacddf
     c                   clear                   cqpadddf
     c     pref          chain     cqpacddf
     c     pref          chain     cqpadddf
 
     c                   when      trans ='CC'
     c                   clear                   cqcocddf
     c                   clear                   cqcodddf
     c     pref          chain     cqcocddf
     c     pref          chain     cqcodddf
 
     c                   when      trans = 'IN'
     c                   clear                   inpayddf
     c                   clear                   inpayxdf
     c     pref          chain     inpayddf
     c     pref          chain     inpayxdf
 
     c                   when      trans = 'OP'
     c                   clear                   otpayddf
     c     pref          chain     otpayddf
 
     c                   when      trans = 'NT'
     c                   clear                   ntranddf
     c     pref          chain     ntranddf
 
     c                   when      trans = 'RI'
     c                             or trans = 'RO'
     c                   clear                   ft101hd0
     c                   clear                   ft101dd0
     c     pref          chain     ft101hd0
     c                   if        %found
     c     pref          setll     ft101dd0
     c     pref          reade     ft101dd0
     c                   if        not %eof
     c                   eval      loopft = 'Y'
     c                   endif
     c                   endif
 
     c                   when      trans = 'BI'
     c                             or trans = 'BO'
     c                   clear                   ft102hd0
     c                   clear                   ft102dd0
     c     pref          chain     ft102hd0
     c                   if        %found
     c     pref          setll     ft102dd0
     c     pref          reade     ft102dd0
     c                   if        not %eof
     c                   eval      loopft = 'Y'
     c                   endif
     c                   endif
 
     c                   endsl
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  wrtAudit -  write Audit Records                              *
      *                                                               *
      *****************************************************************
     c     wrtAudit      begsr
 
     c                   eval      amregaut    = aRaid(rgIx)
     c                   eval      ammodule    = 'FT'
     c                   eval      amcntref    = pref
     c                   eval      ammovtyp    = movetype
     c                   eval      amorgccy    = isocurr
     c                   eval      amakey      = akey
     c                   eval      ambrch      = brca
     c**********         eval      amcusn      = %editc(fpasoc:'X')                          CSD027A
     c                   eval      amcusn      = fpasoc                                      CSD027A
     c                   eval      amocamnt    = ocaamunt
     c                   eval      amrptccy    = aRpCy(rgIx)
     c                   eval      amrcamnt    = rcaamunt
     C                   if        dcindi      = 1
     C                   eval      amdci       = 'D'
     C                   else
     C                   eval      amdci       = 'C'
     C                   endif
     c                   write     rnaumvpdF
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  wrtExcptn -  write Exception Records                         *
      *                                                               *
      *****************************************************************
     c     wrtExcptn     begsr
 
     c                   eval      xmregaut    = aRaid(rgIx)
     c                   eval      xmmodule    = 'FT'
     c                   eval      xmcntref    = pref
     c                   eval      xmakey      = akey
     c                   eval      xmbrch      = brca
     c**********         eval      xmcusn      = %editc(fpasoc:'X')                          CSD027A
     c                   eval      xmcusn      = fpasoc                                      CSD027A
     c                   eval      xmrsncde    = rsnCde
     c                   write     rnxcmvpdF
 
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
     c                   parm      settleacct    I#AccountCode
     c                   parm                    I#dealType
     c                   parm                    I#dealsubType
     c                   parm                    I#LoanType
     c                   parm                    I#LoanSubType
     c                   parm                    I#FacilityType
     c                   parm                    I#SecuritySNam
     c                   parm                    I#InvestType
     c                   parm      bblinc        I#Institution
     c                   parm      bblicd        I#Industry
     c                   parm      bbcncz        I#CtryCitizen
     c                   parm      bbcolc        I#CtryLocation
     c                   parm      bokc          I#Book
     c                   parm      bbbnbi        I#BankNonBank
     c                   parm                    I#AssetLiab
     c                   parm                    I#CollateralTy
     c     rtnProduct    parm                    O#product
     c                   parm                    O#CntOfClauses
 
      ** If not found, issue a database error
      *
     c                   if        pRtnCod    <> *blanks
     c                   eval      wDbfile     = 'T_FRSMAPR'
     c                   eval      wDbase      = 2
     c                   eval      wDbkey      = I#AccountCode
     c                   exsr      *pssr
     c                   endif
 
     c                   if        rtnProduct  < 0
     c                   eval      rtnProduct  = 0
     c                   endif
 
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
     c                   parm                    pBrca
     c     sdbrch        parm                    dsfdy
                                                                                            BUG10501
     c                   if        pRtnCod    <> *blanks                                    BUG10501
     c                   eval      wDbmod      = 'AOBRCHR0'                                 BUG10501
     c                   eval      wDbase      = 21                                         BUG10501
     c                   eval      wDbkey      = pBrca                                      BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501
 
     c                   endsr
 
      *********************************************************************
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
     c                   eval      wDbase      = 22                                         BUG10501
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
     c                   eval      wDbmod      = 'AO    R0'                                 BUG10501
     c                   eval      wDbase      = 23                                         BUG10501
     c                   eval      wDbkey      = pCcy                                       BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501
 
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
     c                   eval      wDbmod      = 'AO    R0'                                 BUG10501
     c                   eval      wDbase      = 24                                         BUG10501
     c                   eval      wDbkey      = pOption                                    BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501
 
     c                   eval      runDatIso   = %date(rndaycnv(bjrdnb))
     c     *iso0         move      runDatIso     runDatIso8
 
      * Get general ledger details.
     c                   callb     'AOGELRR0'
     c**********         parm      '*DBERR'      pRtnCod                                    BUG10501
     c                   parm      *blanks       pRtnCod                                    BUG10501
     c                   parm      '*FIRST'      pOption
     c     sdgelr        parm                    dsfdy
                                                                                            BUG10501
     c                   if        pRtnCod    <> *blanks                                    BUG10501
     c                   eval      wDbmod      = 'AO    R0'                                 BUG10501
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
 
      /copy rncpysrc,rnrgaulod
 
     c                   callp     rnPayRecIn
 
      ** Check if  CRN002 is on
 
     c                   callb     'AOSARDR0'
     c                   parm      *BLANKS       pRtnCod
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
     c                   open      rn_movlega
     c                   endif
 
      ** Suppressed Account Key Lookup Initialisation                                        BUG9792
     c                   callp     rnAcKyLsIn(pzone)                                         BUG9792
                                                                                             BUG9792
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      /copy rncpysrc,rnpssrsr
      ********************************************************************
 
**ctdata cpy@
(c) Finastra International Limited 2005
