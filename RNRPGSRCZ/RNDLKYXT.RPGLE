     h debug   alwnull(*usrctl)
     h fixnbr(*zoned : *inputpacked)
     h copyright('(c) Finastra International Limited. 2005')
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Account Keys Extract')                        *
      *****************************************************************
      *                                                               *
      *  MidasPlus - FRS Regulatory Reporting Interface               *
      *                                                               *
      *  RNDLKYXT   - Midas FRS DL Account Keys Extract               *
      *                                                               *
      *  (c) Finastra International Limited. 2005                     *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11435           Date 06Jun06               *
      *                 BUG10742           Date 03May06               *
      *                 CSD027A            Date 10May06               *
      *                 BUG9792            Date 17Mar06               *
      *                 BUG10804           Date 10Mar06               *
      *                 BUG9853            Date 16Feb06               *
      *                 BUG9799            Date 16Feb06               *
      *                 BUG10501           Date 09Feb06               *
      *                 BUG9705            Date 24Jan06               *
      *                 BUG9685            Date 03Jan06               *
      *                 CRN001  *Create    Date 13Sep05               *
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
      *  CLE148 - Alpha Loan Reference                                *
      *  BUG11435 - Follow up issue 21. Add more mapping for INDACOBA.*
      *  BUG10742 - Include checking wildcard for extended subtype in *
      *             sr. chkAcctKeyMap.                                *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  BUG9792 - AC key valiation enhancement: apply suppression    *
      *            rules.                                             *
      *  BUG10804 - RN_UILOAD and RN_UISEC formats have changed       *
      *             for FRS Data Foundation 2.9.3.                    *
      *  BUG9853 - T__MOVLEGA format changed. Populate new field      *
      *            PRISECMA - primary/secondary market indicator.     *
      *  BUG9799  - Rn_movleg now keyed. Write unique values by       *
      *             appending sequence number to leg reference.       *
      *  BUG10501 - Parameter value '*DBERR' is not correct for       *
      *             access object running in CoB.                     *
      *  BUG9705 - Account key mapping uses wrong key fields and      *
      *            should map to records of same zone only.           *
      *  BUG9685 - Handle special cases. Contents of deliverable      *
      *            file rnkyprpd amended under this fix.              *
      *  CRN001 - FRS Regulatory Reporting Interface                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     fdkeysdp   if   e             disk    infsr(*pssr)
 
     fgpregbj0  if   e           k disk    infsr(*pssr)
 
     fdealall   if   e           k disk    infsr(*pssr)
     f                                     prefix(d#)
 
     ffclty     if   e           k disk    infsr(*pssr)
     f                                     include(fcltyfmf)
     f                                     prefix(f#)
 
     fashtrnj1  if   e           k disk    infsr(*pssr)
 
     fsdhgstl1  if   e           k disk    infsr(*pssr)
 
     fdldeall5  if   e           k disk    infsr(*pssr)
     f                                     include(dldldcd0)
 
     ft__dfboo  if a e           k disk    infsr(*pssr)
     f                                     rename(t__dfboo:t__dfboof)
 
     ft_rnbsrt  if a e           k disk    infsr(*pssr)
     f                                     rename(t_rnbsrt:t_rnbsrtf)
 
     ft_rnfxdl  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnfxdl:t_rnfxdlf)
 
     ft_rnfras  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnfras:t_rnfrasf)
 
     ft_rnldni  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnldni:t_rnldnif)
 
     ft_rnnasp  if   e           k disk    infsr(*pssr)
     f                                     rename(t_rnnasp:t_rnnaspf)
 
     ft_frsamap if   e           k disk    infsr(*pssr)
     f                                     rename(t_frsamap:t_frsamapf)
 
     frn_movemenif a e           k disk    infsr(*pssr)
     f******rn_movleg o    e       disk    infsr(*pssr)                                      BUG9799
     frn_movleg if a e           k disk    infsr(*pssr)                                      BUG9799
     f                                     prefix(m#)
     frn_movlegao    e             disk    infsr(*pssr)
     f                                     usropn
     frn_uider  if a e           k disk    infsr(*pssr)
     frn_uiload if a e           k disk    infsr(*pssr)
     frn_uisec  if a e           k disk    infsr(*pssr)
 
     frnaumvpd  o    e             disk    infsr(*pssr)
     frnxcmvpd  o    e             disk    infsr(*pssr)
 
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
 
     d cpy@            s             80    dim(1)  ctdata perrcd(1)
     d aDealType       s              2    dim(40) ctdata perrcd(10)
     d aTranType       s              2    dim(40) alt(aDealType)
     d aPayDeal        s              2    dim(19) ctdata perrcd(19)
     d aSpcCases       s              2    dim(13) ctdata perrcd(13)                         BUG9685
 
     d dsfdy         e ds
     d dssdy         e ds
     d sdbank        e ds                  extname(sdbankpd)
     d sdgelr        e ds                  extname(sdgelrpd)
     d sdcurr        e ds                  extname(sdcurrpd)
     d sdcust        e ds                  extname(sdcustpd)
     d sdbrch        e ds                  extname(sdbrchpd)
     d  qqdfacx      e                     extfld(qqdfac)
 
     d                 ds
     d akey
     d  dealType                      2    overlay( akey )
     d  dealStyp               4      5
     d dlno
     d  dealno                        6    overlay( dlno )
 
     d pRaid           s                   like(rbraid)
     d rsnCde          s                   like(xmrsncde)
     d runDatIso       s               d
     d runDatIso8      s              8
     d evtDatIso       s               d
     d wMdat           s                   like(mdat)
 
     d pRtnCod         S              7
     d pOption         S              7
     d pKey1           S             10
     d pKyst           S              7
     d pCcy            S              3
     d pSar            s              6
     d pErrMsg         S             50
     d pFullChk        S              1
     d pZone           S             10
     d pShtc           S              4
     d pRdnb           S              5  0
     d pDnwd           S              5  0
     d pBccy           S              3
     d pNjob           S              1  0
 
     d fcltyFound      s               n
     d CRN002          s               n
     d Suppressed      s                   like(rnAcKyLs)                                    BUG9792
 
     d kExsub          s              4    inz('DLKY')
 
     d dupKey          c                   01021
 
     d payrec          s              1
     d trantype        s              2
     d elmDT           s              5U 0
     d rtnMap          s                   like(m#movamou)
     d acctkey         s                   like(acckey)
     d kfdCurrency     s                   like(Currency)                                    BUG9705
     d rateType        s                   like(babsrc)
     d curr            s                   like(d#ucucy)
     d cnumbrcd        s                   like(bbbrcd)                         Brch code for cnum
     d legSeq          s              5p 0                                                   BUG9799
 
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
     D DLNOA           S              6A                                                      CLE148
 
      /copy rncpysrc,rnrgaudfn
 
      /copy rncpysrc,rndaycnv
      /copy rncpysrc,rnastlia
      /copy rncpysrc,rnamtcnv
      /copy rncpysrc,rnpayrec
      /copy rncpysrc,rnackylsd1                                                              BUG9792
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+
 
      ** Key field for fclty
     c     kFclty        klist
     c                   kfld                    f1fccu
     c                   kfld                    f1fact
     c                   kfld                    f1fcno
 
      ** Key field for t_rnbsrt
     c     kyt_rnbsrt    klist
     c                   kfld                    curr
     c                   kfld                    rateType
 
      ** Key for t_frsamap                                                                   BUG9705
     c     kt_frsamap    klist                                                               BUG9705
     c                   kfld                    acctkey                                     BUG9705
     c                   kfld                    kfdCurrency                                 BUG9705
     c                   kfld                    pzone                                       BUG9705
                                                                                             BUG9799
     c     kMovleg       klist                                                               BUG9799
     c                   kfld                    m#moveref                                   BUG9799
     c                   kfld                    m#legref                                    BUG9799
                                                                                             BUG9705
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
 
     c                   read      dkeysdp
 
     c                   dow       not %eof
 
      ** Check if record is to be extracted.
     c                   eval      rgIx = %lookup(brca: aBrcd: 1: rgEl)
     c                   if        (   rgIx        >  0
     c                             and aNxDt(rgIx) <= evtDatIso )
 
      ** Waiting for UK to finish called program
     c                   exsr      chkAcctKeyMap
 
     c                   if        rtnMap      > 0
     c                   exsr      chkPayRec
 
     c                   if        payrec     <> *blank
     c                   exsr      mapData
     c                   endif
 
     c                   endif
     c                   endif
 
     c                   read      dkeysdp
     c                   enddo
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * chkAcctKeyMap - Check Account Key Mapping                         *
      *                                                                   *
      *********************************************************************
     c     chkAcctKeyMap begsr
 
      ** If the account key is suppressed, do not check for selection                        BUG9792
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
 
     c                   if        not %found                                               BUG10742
      ** Use wildcard for extended deal subtype                                             BUG10742
     c                   eval      %subst( acctkey: 11: 4 )                                 BUG10742
     c                             = '****'                                                 BUG10742
     c                   eval      kfdCurrency   = eccy                                     BUG10742
     c     Kt_frsamap    chain     t_frsamap                                                BUG10742
     c                   endif                                                              BUG10742
                                                                                            BUG10742
      ** Check if all currency excluding base (wildcard extended deal subtype)              BUG10742
     c                   if        not %found                                               BUG10742
     c                   if        eccy <> bjcycd                                           BUG10742
     c                   eval      kfdCurrency = '*XB'                                      BUG10742
     c     Kt_frsamap    chain     t_frsamap                                                BUG10742
     c                   endif                                                              BUG10742
     c                   endif                                                              BUG10742
                                                                                            BUG10742
      ** Check if all currency (wildcard extended deal subtype)                             BUG10742
     c                   if        not %found                                               BUG10742
     c                   eval      kfdCurrency = '***'                                      BUG10742
     c     Kt_frsamap    chain     t_frsamap                                                BUG10742
     c                   endif                                                              BUG10742
                                                                                            BUG10742
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
 
     c                   if        not %found                                               BUG10742
      ** Use wildcard for deal type/extended subtype                                        BUG10742
     c                   eval      %subst( acctkey: 11: 4 )                                 BUG10742
     c                             = '****'                                                 BUG10742
     c                   eval      kfdCurrency   = eccy                                     BUG10742
     c     Kt_frsamap    chain     t_frsamap                                                BUG10742
     c                   endif                                                              BUG10742
                                                                                            BUG10742
      ** Check if all currency excluding base (wildcard deal type/extended subtype)         BUG10742
     c                   if        not %found                                               BUG10742
     c                   if        eccy <> bjcycd                                           BUG10742
     c                   eval      kfdCurrency = '*XB'                                      BUG10742
     c     Kt_frsamap    chain     t_frsamap                                                BUG10742
     c                   endif                                                              BUG10742
     c                   endif                                                              BUG10742
                                                                                            BUG10742
      ** Check if all currency (wildcard deal type/extended subtype)                        BUG10742
     c                   if        not %found                                               BUG10742
     c                   eval      kfdCurrency = '***'                                      BUG10742
     c     Kt_frsamap    chain     t_frsamap                                                BUG10742
     c                   endif                                                              BUG10742
                                                                                            BUG10742
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
 
     c                   eval      acctKey     = akey
 
     c                   if        %lookup(dealType: aPayDeal)
     c                                         = 0
     c                   eval      %subst(acctKey: 1: 2)
     c                                         = 'xx'
     c                   endif
 
     c                   eval      %subst(acctKey: 4: 2)
     c                                         = 'yy'
     c                   if            %subst(acctKey: 6: 1) <> *blank
     c                             and %subst(acctKey: 7: 1) <> *blank
     c                             and %subst(acctKey: 8: 1) <> *blank
     c                   eval      %subst(acctKey: 6: 3)      = 'zzz'
     c                   endif
                                                                                             BUG9685
      ** Special cases: first attempt look-up with original deal type,                       BUG9685
      ** then with 'xx'.                                                                     BUG9685
     c                   if        %lookup(dealType: aSpcCases) > 0                          BUG9685
     c                   eval      %subst(acctKey: 1: 2)                                     BUG9685
     c                                         = dealType                                    BUG9685
     c                   eval      payrec      = rnPayRec(acctKey)                           BUG9685
     c                   if        payrec      = '*'                                         BUG9685
     c                   eval      %subst(acctKey: 1: 2)                                     BUG9685
     c                                         = 'xx'                                        BUG9685
     c                   else                                                                BUG9685
     c                   leavesr                                                             BUG9685
     c                   endif                                                               BUG9685
     c                   endif                                                               BUG9685
 
     c                   eval      payrec      = rnPayRec(acctKey)
 
      ** If not found, generate exception record
     c                   if        payrec      = '*'
     c                   eval      payrec      = *blank
 
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
     c                   clear                   t__uider
     c                   clear                   t__uiload
     c                   clear                   t__uisec
 
     c                   exsr      getDeal
 
     c                   exsr      getBranch
 
      ** Get customer details.
     c**********         eval      pKey1       = %editc( cnum: 'X' )                         CSD027A
     c                   eval      pKey1       = cnum                                        CSD027A
     c                   exsr      getCust
      ** Save branch code of customer number from DKEYSDP.
     c                   eval      cnumbrcd    = bbbrcd
 
      ** Get the product code
     c                   exsr      getProdCode
 
      ** Get transaction type
     c                   eval      elmDT       = %lookup( d#dtyp: aDealType )
 
     c                   if        elmDT       > 0
     c                   eval      trantype    = aTrantype( elmDT)
     c                   else
     c                   eval      trantype    = *blank
     c                   endif
 
     c                   exsr      movemenRec
 
     c                   exsr      movlegRec
 
      ** Feature CRN002 is present
     c                   if        CRN002
     c                   exsr      movlegaRec
     c                   endif
 
     c                   if           trantype = 'FX'
     c                             or trantype = 'IR'
     c                   exsr      uiDerivat
     c                   endif
 
     c                   if        trantype    = 'MM'
     c                   exsr      uiLoanDeposit
     c                   endif
 
     c                   if           trantype = 'NP'
     c                             or trantype = 'NS'
     c                   exsr      uiSecurity
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  movemenRec - Subroutine that writes records to rn_movemen    *
      *                                                               *
      *****************************************************************
     c     movemenRec    begsr
 
     c                   eval      moveref     = brca
     c                                         + 'DL'
     c                                         + dealno
     c                                         + runDatIso8
     c     moveref       chain     t__movemen
     c                   if        not(%found)
 
     c                   eval      statusl2    = 5
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on
 
     c                   eval      sourref     = pZone
     c                   eval      corrvia     = d#rcrn
 
     c                   if        payrec      = 'P'
     c                   eval      corrto      = d#pons
     c                   else
     c                   eval      corrto      = d#rons
     c                   endif
 
     c                   eval      pKey1       = a8bicn
     c                   exsr      getCust
     c                   eval      intparre    = bbbrcd
     c                                         + '-'
     c                                         + a8bicn
 
     c                   eval      paymtxt     = moveref
 
     c                   if        revi        = 1
     c                   eval      cancella    = %editc( edat: 'X' )
     c                   endif
 
     c                   eval      expesett    = rnDayCnv( edat )
     c                   eval      actusett    = expesett
 
     c                   select
     c                   when      trantype    = 'FX'
     c     dlno          chain     t_rnfxdlf
 
     c                   when      trantype    = 'MM'
     c     dlno          chain     t_rnldnif
 
     c                   when      trantype    = 'NP'
     c     dlno          chain     t_rnnaspf
 
     c                   when      trantype    = 'IR'
     c     dlno          chain     t_rnfrasf
     c                   endsl
 
     c                   if        %found
     c                   eval      portfoli    = portfolo
     c                   endif
 
     c                   eval      movement    = 3
 
     c                   write     t__movemen
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  movlegRec  - Subroutine that writes records to rn_movleg     *
      *                                                               *
      *****************************************************************
     c     movlegRec     begsr
 
     c                   eval      m#statusl2  = 5
     c                   move      runDatIso     m#validon
     c                   eval      m#lottypfk  = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on
     c**********         eval      m#legref    = akey                                        BUG9799
     c                   eval      m#leglinre  = brca
     c                                         + 'DL'
     c                                         + dealno
     c                   eval      m#uiref     = m#leglinre
 
     c                   select
     c                   when      trantype    = 'FX'
     c                   eval      m#insttype  = 2
 
     c                   when      trantype    = 'MM'
     c                   eval      m#insttype  = 3
 
     c                   when         trantype = 'NP'
     c                             or trantype = 'NS'
     c                   eval      m#insttype  = 4
 
     c                   when      trantype    = 'IR'
     c                   eval      m#insttype  = 2
     c                   endsl
 
     c                   eval      m#counref   = cnumbrcd
     c                                         + '-'
     c                                         + cnum                                        CSD027A
     c**********                               + %editc( cnum: 'X' )                         CSD027A
 
     c                   eval      m#moveref   = brca
     c                                         + 'DL'
     c                                         + dealno
     c                                         + runDatIso8
 
     c                   eval      m#intparre  = intparre
 
     c                   eval      m#paymtxt   = brca
     c                                         + 'DL'
     c                                         + dealno
     c                                         + akey
 
     c                   if        payrec      = 'P'
     c                   eval      m#dcindi    = 2
     c                   else
     c                   eval      m#dcindi    = 1
     c                   endif
 
     c                   select
     c                   when         trantype = 'FX'
     c                             or trantype = 'MM'
     c                             or trantype = 'NP'
     c                   eval      m#bsindi    = 1
 
     c                   when      trantype    = 'NS'
     c                   eval      m#bsindi    = 2
 
     c                   when      trantype    = 'IR'
 
     c                   if        d#bysl      = 'B'
     c                   eval      m#bsindi    = 1
     c                   else
     c                   eval      m#bsindi    = 2
     c                   endif
 
     c                   endsl
 
     c                   eval      m#setttype  = 3
     c                   eval      m#movamou   = movetype
     c                   eval      m#isocurr   = eccy
 
     c                   if        d#benn     <> *blank
      ** Get customer details of the beneficiary.
     c                   eval      pKey1       = d#benn
     c                   exsr      getCust
     c                   eval      m#residenc  = bbcncz                         country of citizensh
     c                   endif
 
      * Get currency details.
     c                   eval      pCcy        = eccy
     c                   exsr      getCcy
 
     c                   eval(h)   m#ocaamunt  = %abs(eamt)/(10**a6nbdp)
     c                   eval      m#rcaamunt  = rnAmtCnv(m#ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
 
     c                   eval      m#deal      = rnDayCnv( d#ddat )
     c                   eval      m#dtetrade  = rnDayCnv( vdat )
     c                   eval      m#value     = m#dtetrade
                                                                                             BUG9799
     c                   eval      legSeq      = 0                                           BUG9799
     c                   dou       not %equal                                                BUG9799
     c                   eval      legSeq     += 1                                           BUG9799
     c                   eval      m#legref    = akey                                        BUG9799
     c                                         + %editc(legSeq: 'X')                         BUG9799
     c     kMovleg       setll     rn_movleg                                                 BUG9799
     c                   enddo                                                               BUG9799
 
     c                   write     t__movleg
 
     c                   exsr      wrtAudit
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  movlegaRec  - Subroutine that writes records to rn_movlega   *
      *                                                               *
      *****************************************************************
     c     movlegaRec    begsr
 
     c                   eval      statusl2    = 5
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on
     c**********         eval      legref      = akey                                        BUG9799
     c**********         eval      moveref     = brca                                        BUG9799
     c**********         eval                  + 'DL'                                        BUG9799
     c**********         eval                  + dealno                                      BUG9799
     c**********         eval                  + runDatIso8                                  BUG9799
     c                   eval      legref      = m#legref                                    BUG9799
     c                   eval      moveref     = m#moveref                                   BUG9799
 
     c**********         eval      rmbaccnu    = %editc( d#pocn: 'X' )                       CSD027A
     c                   eval      rmbaccnu    = d#pocn                                      CSD027A
     c                   eval      actuexch    = exrt
 
     c                   if        payrec      = 'P'
     c**********         eval      ordecust    = %editc( d#pocn: 'X' )                       CSD027A
     c**********         eval      ordeinst    = %editc( d#pobn: 'X' )                       CSD027A
     c                   eval      ordecust    = d#pocn                                      CSD027A
     c                   eval      ordeinst    = d#pobn                                      CSD027A
     c                   else
     c**********         eval      ordecust    = %editc( d#rocn: 'X' )                       CSD027A
     c**********         eval      ordeinst    = %editc( d#robn: 'X' )                       CSD027A
     c                   eval      ordecust    = d#rocn                                      CSD027A
     c                   eval      ordeinst    = d#robn                                      CSD027A
     c                   endif
 
     c                   eval      accwitin    = d#awbn
     c                   eval      benecust    = d#benn
 
     c                   if        payrec      = 'P'
     c                   eval      transact    = 40
     c                   else
     c                   eval      transact    = 30
     c                   endif
 
     c                   select
     c                   when      trantype    = 'FX'
     c                   eval      trancode    = 0
 
     c                   when      trantype    = 'MM'
 
     c                   if        %subst( akey: 2 ) = 'CI'
     c                   eval      trancode    = 3
     c                   else
     c                   eval      trancode    = 0
     c                   endif
 
     c                   when      trantype    = 'NP'
     c                   eval      trancode    = 1
 
     c                   when      trantype    = 'NS'
     c                   eval      trancode    = 2
 
     c                   when      trantype    = 'IR'
 
     c                   if        d#bysl      = 'B'
     c                   eval      trancode    = 1
     c                   else
     c                   eval      trancode    = 2
     c                   endif
 
     c                   endsl
 
     c                   if        trantype    = 'NP'                                        BUG9853
     c                   if        d#iscn      = d#cnum                                      BUG9853
     c                   eval      prisecma    = 1                                           BUG9853
     c                   else                                                                BUG9853
     c                   eval      prisecma    = 2                                           BUG9853
     c                   endif                                                               BUG9853
     c                   else                                                                BUG9853
     c                   eval      prisecma    = 0                                           BUG9853
     c                   endif                                                               BUG9853
                                                                                             BUG9853
     c                   eval      ovbeacnu    = d#bena
 
     c                   write     t__movlega
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  uiDerivat - Subroutine that writes records to rn_uider       *
      *                                                               *
      *****************************************************************
     c     uiDerivat     begsr
 
     c                   eval      uiref       = brca
     c                                         + 'DL'
     c                                         + dealno
     c     uiref         chain     t__uider
     c                   if        not(%found)
 
     c                   eval      statusl2    = 5
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on
     c                   eval      start       = rnDayCnv( vdat )
 
     c                   select
     c                   when      (  trantype = 'FX'
     c                             and d#otdt <> 0   )
     c                   eval      wMdat       = d#otdt
 
     c                   when      trantype    = 'FX'
     c                   eval      wMdat       = vdat
 
     c                   other
     c                   eval      wMdat       = mdat
     c                   endsl
     c                   eval      maturity    = rnDayCnv( wMdat )
 
     c                   select
     c                   when      trantype    = 'FX'
     c                   eval      forconra    = exrt
 
     c     dlno          chain     t_rnfxdlf
     c                   if        %found
     c                   eval      purpose     = purposet
     c                   endif
 
     c                   when      trantype    = 'IR'
     c                   eval      isda        = d#agty
     c                                         + rnDayCnv( d#agdt )
     c                                         + %editc( d#agvv: 'X' )
     c                   eval      perintra    = intr
     c                   eval      intintra    = intr
     c                   eval      forconra    = intr
 
      ** Map referate
     c                   if        d#ubrtt    <> 0
     c                   move      d#ucucy       curr
     c                   move      d#ubrtt       rateType
     c                   elseif    d#tbrtt    <> 0
     c                   move      d#tcucy       curr
     c                   move      d#tbrtt       rateType
     c                   endif
 
     c     kyt_rnbsrt    chain     t_rnbsrtf
 
     c                   if        %found
     c                   eval      referate    = refrattp
     c                   else
     c                   eval      referate    = 7
     c                   endif
 
      ** Map indacoba
     c                   if        d#bysl      = 'S'
 
     c                   select
     c                   when      d#uicbs     = 1
     c                   eval      indacoba    = 15
 
     c                   when      d#uicbs     = 2
     c                   eval      indacoba    = 2
 
     c                   when      d#uicbs     = 3
     c                   eval      indacoba    = 5
 
      ***Not*populated*-*see*issue*21                                                       BUG11435
     c**********         when         d#uicbs  = 4                                          BUG11435
     c**********                   or d#uicbs  = 5                                          BUG11435
     c**********                   or d#uicbs  = 6                                          BUG11435
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
     c                   other                                                              BUG11435
     c                   eval      indacoba    = 0                                          BUG11435
                                                                                            BUG11435
     c                   endsl
 
     c                   elseif    d#bysl      = 'B'
 
     c                   select
     c                   when      d#ticbs     = 1
     c                   eval      indacoba    = 15
 
     c                   when      d#ticbs     = 2
     c                   eval      indacoba    = 2
 
     c                   when      d#ticbs     = 3
     c                   eval      indacoba    = 5
 
      ***Not*populated*-*see*issue*21                                                       BUG11435
     c**********         when         d#ticbs  = 4                                          BUG11435
     c**********                   or d#ticbs  = 5                                          BUG11435
     c**********                   or d#ticbs  = 6                                          BUG11435
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
     c                   other                                                              BUG11435
     c                   eval      indacoba    = 0                                          BUG11435
                                                                                            BUG11435
     c                   endsl
 
     c                   endif
 
 
     c     dlno          chain     t_rnfrasf
     c                   if        %found
     c                   eval      purpose     = purposet
     c                   endif
 
     c                   endsl
 
     c                   eval      contref     = brca
     c                                         + 'DL'
     c                                         + dealno
 
     c                   eval      detailed    = contref
     c                   eval      original    = wMdat
     c                                         - d#ddat
 
      ** Get hedge strategy shortname
     C*****dlno*         chain     ashtrnj1                                                   CLE148
     C                   MOVEL     DLNO          DLNOA                                        CLE148
     C     DLNOA         CHAIN     ASHTRNJ1                                                   CLE148
 
      ** If found, get hedge product type
     c                   if        %found
     c     fshgst        chain     sdhgstl1
 
     c                   if        %found
 
     c                   select
     c                   when      fsprtp      = 'FV'
     c                   eval      hedging     = 1
 
     c                   when      fsprtp      = 'CF'
     c                   eval      hedging     = 2
 
     c                   other
     c                   eval      hedging     = 0
     c                   endsl
 
     c                   endif
     c                   endif
 
     c                   write     t__uider
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  uiLoanDeposit - Subroutine that writes records to rn_uiload  *
      *                                                               *
      *****************************************************************
     c     uiLoanDeposit begsr
 
     c                   eval      uiref       = brca
     c                                         + 'DL'
     c                                         + dealno
     c     uiref         chain     t__uiload
     c                   if        not(%found)
 
     c                   eval      statusl2    = 5
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on
     c                   eval      contref     = uiref
 
     c                   eval      start       = rnDayCnv( vdat )
     c                   eval      lasintda    = rnDayCnv( slid )
 
     c                   if        mdat       <> 0
     c                   eval      wMdat       = mdat
     c                   else
     c                   eval      wMdat       = bjrdnb
     c                                         + d#notd
     c                   endif
     c                   eval      maturity    = rnDayCnv( wMdat )
 
     c                   eval      original    = wMdat
     c                                         - d#ddat
     c                   eval      perintra    = intr
     c                   eval      intintra    = intr
 
      ** Map reimfreq/intpayfr
     c                   select
     c                   when         d#ipfr   = 'M'
     c                             or d#ipfr   = 'N'
     c                   eval      reimfreq    = 12
     c                   eval      intpayfr    = 12
 
     c                   when      d#ipfr      = 'Q'
     c                   eval      reimfreq    = 4
     c                   eval      intpayfr    = 4
 
     c                   when      d#ipfr      = 'X'
     c                   eval      reimfreq    = 2
     c                   eval      intpayfr    = 2
 
     c                   when      d#ipfr      = 'Y'
     c                   eval      reimfreq    = 1
     c                   eval      intpayfr    = 1
     c                   endsl
 
     c                   eval      alindi      = rnAstLia(dealtype)
     c                   eval      risquain    = 1
 
      ** Map indacoba
     c                   select
     c                   when      d#icbs      = 1
     c                   eval      indacoba    = 15
 
     c                   when      d#icbs      = 2
     c                   eval      indacoba    = 2
 
     c                   when      d#icbs      = 3
     c                   eval      indacoba    = 5
 
      ***Not*populated*-*see*issue*21                                                       BUG11435
     c**********         when         d#icbs   = 4                                          BUG11435
     c**********                   or d#icbs   = 5                                          BUG11435
     c**********                   or d#icbs   = 6                                          BUG11435
     c                   when      d#icbs      = 4                                          BUG11435
     c                   eval      indacoba    = 16                                         BUG11435
                                                                                            BUG11435
     c                   when      d#icbs      = 5                                          BUG11435
     c                   eval      indacoba    = 17                                         BUG11435
                                                                                            BUG11435
     c                   when      d#icbs      = 6                                          BUG11435
     c                   eval      indacoba    = 18                                         BUG11435
                                                                                            BUG11435
     c                   when      d#icbs      = 7                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
                                                                                            BUG11435
     c                   when      d#icbs      = 8                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
                                                                                            BUG11435
     c                   other                                                              BUG11435
     c                   eval      indacoba    = 0                                          BUG11435
                                                                                            BUG11435
     c                   endsl
 
     c                   eval      amortisa    = 2
 
     c                   if           brtt    <> 0
     c                             or d#notd  <> -999
     c                   eval      typintra    = 2
     c                   else
     c                   eval      typintra    = 1
     c                   endif
 
      ** Map revofac
     c     dealno        chain     dldeall5
     c                   if        %found
     c                   exsr      getFclty
 
     c                   if            fcltyFound
     c                             and f#rvcr  = 'Y'
     c                   eval      revofac     = 1
     c                   endif
 
     c                   endif
 
     c     dlno          chain     t_rnldnif
     c                   if        %found
     c                   eval      purpose     = purposet
     c                   endif
     c                   eval      portfoli    = 0                                          BUG10804
 
     c                   write     t__uiload
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  uiSecurity - Subroutine that writes records to rn_uisec      *
      *                                                               *
      *****************************************************************
     c     uiSecurity    begsr
 
     c                   eval      uiref       = brca
     c                                         + 'DL'
     c                                         + dealno
     c     uiref         chain     t__uisec
     c                   if        not(%found)
 
     c                   eval      statusl2    = 5
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      aPosLotUsed(rgIx) = *on
     c                   eval      start       = rnDayCnv( vdat )
     c                   eval      maturity    = rnDayCnv( mdat )
 
     c**********         eval      pKey1       = %editc( d#iscn: 'X' )                      CSD027A
     c                   eval      pKey1       = d#iscn                                     CSD027A
     c                   exsr      getCust
     c                   eval      issuref     = bbbrcd
     c                                         + '-'
     c**********                               + %editc( d#iscn: 'X' )                      CSD027A
     c                                         + d#iscn                                     CSD027A
 
     c                   eval      isin        = d#rnna
     c                   eval      intcodre    = uiref
     c                   eval      contref     = uiref
     c                   eval      detailed    = uiref
 
     c                   eval      original    = mdat
     c                                         - d#ddat
     c                   eval      perintra    = intr
     c                   eval      intintra    = intr
 
     c                   if        trantype    = 'NP'
      ** Map reimfreq
     c                   select
     c                   when         d#ipfr   = 'M'
     c                             or d#ipfr   = 'N'
     c                   eval      reimfreq    = 12
     c                   eval      intpayfr    = 12
 
     c                   when      d#ipfr      = 'Q'
     c                   eval      reimfreq    = 4
     c                   eval      intpayfr    = 4
 
     c                   when      d#ipfr      = 'X'
     c                   eval      reimfreq    = 2
     c                   eval      intpayfr    = 2
 
     c                   when      d#ipfr      = 'Y'
     c                   eval      reimfreq    = 1
     c                   eval      intpayfr    = 1
     c                   endsl
 
      ** Map indacoba
     c                   select
     c                   when      d#icbs      = 1
     c                   eval      indacoba    = 15
 
     c                   when      d#icbs      = 2
     c                   eval      indacoba    = 2
 
     c                   when      d#icbs      = 3
     c                   eval      indacoba    = 5
 
      ***Not*populated*-*see*issue*21                                                       BUG11435
     c**********         when         d#icbs   = 4                                          BUG11435
     c**********                   or d#icbs   = 5                                          BUG11435
     c**********                   or d#icbs   = 6                                          BUG11435
     c                   when      d#icbs      = 4                                          BUG11435
     c                   eval      indacoba    = 16                                         BUG11435
                                                                                            BUG11435
     c                   when      d#icbs      = 5                                          BUG11435
     c                   eval      indacoba    = 17                                         BUG11435
                                                                                            BUG11435
     c                   when      d#icbs      = 6                                          BUG11435
     c                   eval      indacoba    = 18                                         BUG11435
                                                                                            BUG11435
     c                   when      d#icbs      = 7                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
                                                                                            BUG11435
     c                   when      d#icbs      = 8                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
                                                                                            BUG11435
     c                   other                                                              BUG11435
     c                   eval      indacoba    = 0                                          BUG11435
                                                                                            BUG11435
     c                   endsl
 
      ** Map locafund/marketab/purpose
     c     dlno          chain     t_rnnaspf
     c                   if        %found
     c                   move      loclfund      locafund
  -> c*-                 eval      marketab    = ...
     c                   eval      purpose     = purposet
     c                   endif
     c                   endif
 
     c                   eval      yield       = yrat
     c                   eval      risquain    = 1
     c                   eval      typintra    = 1
     c                   eval      portfoli    = 0                                          BUG10804
 
     c                   write     t__uisec
     c                   endif
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getDeal   - Subroutine to Get Deal Details                   *
      *                                                               *
      *****************************************************************
     c     getDeal       begsr
 
     c     dlno          chain     dealall
     c                   if        not %found
     c                   eval      wDbfile     = 'DEALALL'
     c                   eval      wDbase      =  3
     c                   eval      wDbkey      = dealno
     c                   exsr      *pssr
     c                   endif
 
     C                   endsr
 
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
     c                   if        pRtnCod    <> *blanks                                    BUG10501
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
     c                   eval      wDbase      = 22                                         BUG10501
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
     c                   eval      wDbase      = 23                                         BUG10501
     c                   eval      wDbkey      = pCcy                                       BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * GetProdCode - Retrieve Product Code                               *
      *                                                                   *
      *********************************************************************
     c     getProdCode   begsr
 
      ** Product mappings
     c                   callb     'RNPRODMAP'
     c                   parm      *blanks       pRtnCod
     c                   parm                    pERMS
     c                   parm                    pAccountCode
     c                   parm      dealType      pDealType
     c                   parm      dealStyp      pdealsubType
     c                   parm                    pLoanType
     c                   parm                    pLoanSubType
     c                   parm                    pFacilityType
     c                   parm                    pSecuritySNam
     c                   parm                    pInvestType
     c                   parm      bblinc        pInstitution
     c                   parm      bblicd        pIndustry
     c                   parm      bbcncz        pCtryCitizen
     c                   parm      bbcolc        pCtryLocation
     c                   parm      bokc          pBook
     c                   parm      bbbnbi        pBankNonBank
     c                   parm                    pAssetLiab
     c                   parm                    pCollateralTy
     c     product       parm                    pProduct
     c                   parm                    pCntOfClauses
 
      ** If not found, issue a database error
     c                   if        pRtnCod    <> *blanks
     c                   eval      wDbfile     = 'T_FRSMAPR'
     c                   eval      wDbase      = 2
     c                   eval      wDbkey      = pDealType
     c                   exsr      *pssr
     c                   endif
 
     c                   if        product     < 0
     c                   eval      product     = 0
     c                   endif
 
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
     c                   eval      ammodule    = 'DL'
     c                   eval      amcntref    = brca
     c                                         + 'DL'
     c                                         + dealno
     c                   eval      ammovtyp    = movetype
     c                   eval      amakey      = akey
     c                   eval      ambrch      = brca
     c**********         eval      amcusn      = %editc( cnum: 'X' )                         CSD027A
     c                   eval      amcusn      = cnum                                        CSD027A
     c                   eval      amorgccy    = eccy
     c                   eval(h)   amocamnt    = %abs(eamt)/(10**a6nbdp)
     c                   eval      amrptccy    = aRpCy(rgIx)
     c                   eval      amrcamnt    = m#rcaamunt
     C                   if        m#dcindi    = 1
     C                   eval      amdci       = 'D'
     C                   else
     C                   eval      amdci       = 'C'
     C                   endif
 
     c                   write     rnaumvpdf
 
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
     c                   eval      xmcntref    = brca
     c                                         + 'DL'
     c                                         + dealno
     c                   eval      xmmodule    = 'DL'
     c                   eval      xmakey      = akey
     c                   eval      xmbrch      = brca
     c**********         eval      xmcusn      = %editc(cnum: 'X')                           CSD027A
     c                   eval      xmcusn      = cnum                                        CSD027A
     c                   eval      xmrsncde    = rsnCde
 
     c                   write     rnxcmvpdf
 
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
     c                   parm      *blanks       pRtnCod
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
     c     *iso0         move      runDatIso     runDatIso8
 
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
 
     c                   callp     rnAstLiaIn
     c                   callp     rnPayRecIn
 
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
     c                   open      rn_movlega
     c                   endif
 
      ** Suppressed Account Key Lookup Initialisation                                        BUG9792
     c                   callp     rnAcKyLsIn(pzone)                                         BUG9792
                                                                                             BUG9792
     C                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      /copy rncpysrc,rnpssrsr
      *********************************************************************
**ctdata cpy@
(c) Misys International Banking Systems Ltd. 2005
**ctdata aDealType
BDNPBPNPBRNSBSNSCDMMCIMMCLMMCSNSCXFXC1NP
C2NPDANPDPMMDTMMFLMMFPFXFRIRFSFXFTMMIPMM
ITMMLPMMLTMMOPFXOTFXPIFXRANSRFIRRPIRRRIR
RSIRRXIRSIFXSWFXTANPTBNPTDMMTIMMTRNSTSNS
**ctdata aPayDeal
CDCICLDPDTFLFRFTIPITLPLTRFRPRRRSRXTDTI
**ctdata aSpcCases                                                                           BUG9685
C1C2BDBPTBTADACSBRBSTSRATR                                                                   BUG9685
