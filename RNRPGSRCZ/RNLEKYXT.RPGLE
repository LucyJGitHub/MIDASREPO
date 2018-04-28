     h debug
     h copyright('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Account Keys Extract')                        *
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNLEKYXT   - Midas LE Account Keys Extract                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. AR1056323          Date 14Nov12               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11435           Date 06Jun06               *
      *                 BUG10742           Date 09May06               *
      *                 CSD027A            Date 10May06               *
      *                 BUG9792            Date 24Mar06               *
      *                 BUG10804           Date 10Mar06               *
      *                 BUG9853            Date 16Feb06               *
      *                 BUG9799            Date 16Feb06               *
      *                 BUG10118           Date 09Feb06               *
      *                 CPK024             Date 13Feb06               *
      *                 BUG10501           Date 09Feb06               *
      *                 BUG10258           Date 31Jan06               *
      *                 BUG9705            Date 24Jan06               *
      *                 BUG9686            Date 19Jan06               *
      *                 CRN001  *Create    Date 07Oct05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1056323 - Revert back changes of CLE134 for LKEY1DP and    *
      *              LKEYFED (Recompile)                              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BUG11435 - Follow up issue 21. Add more mapping for INDACOBA.*
      *  BUG10742 - Include checking wildcard for extended subtype in *
      *             sr. chkAcctKeyMap.                                *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  BUG9792 - AC key valiation enhancement: apply suppression    *
      *            rules.                                             *
      *            Set field RtnMap after checking facility type      *
      *            account from file T_FRSAMAP in sr. chkAcctKeyMap.  *
      *  BUG10804 - RN_UILOAD format has changed for FRS Data         *
      *             Foundation 2.9.3.                                 *
      *  BUG9853 - T__MOVLEGA format changed.                         *
      *  BUG9799  - Rn_movleg now keyed. Write unique values by       *
      *             appending sequence number to leg reference.       *
      *  BUG10118 - Fee key extraction should be handled              *
      *             differntly to loan keys. Separate out the code    *
      *             so further specific enhancements are possible.    *
      *  CPK024 - rename field to correct compilation error           *
      *  BUG10501 - Parameter value '*DBERR' is not correct for       *
      *             access object running in CoB.                     *
      *  BUG10258 - Instrument Type should be set to 3.               *
      *  BUG9705 - Account key mapping uses wrong key fields and      *
      *            should map to records of same zone only.           *
      *  BUG9686- Incorrect key set up to lookup on file RNKYPRPD.    *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     flkey1dp   if   e             disk    infsr(*pssr)
 
     flkey2dp   if   e             disk    infsr(*pssr)
 
     flkey3dp   if   e             disk    infsr(*pssr)
     f                                     rename(lkey1dpf:lkey3dpf)
 
     flkeycfd   if   e             disk    infsr(*pssr)
     f                                     rename(lkeyfedf:lkeycfdf)
 
     flkeyfed   if   e             disk    infsr(*pssr)
 
     ** This file is not used in this program.                                              BUG9792
     f*****sdbankpd  if   e           k disk    infsr(*pssr)                                BUG9792
 
     fsdloanl1  if   e           k disk    infsr(*pssr)
 
     fcloanc    if   e           k disk    infsr(*pssr)
     f                                     include(cloanclf)
 
     fgpregbj0  if   e           k disk    infsr(*pssr)
 
     ffclty     if   e           k disk    infsr(*pssr)
     f                                     include(fcltyfmf)
     f                                     prefix(f#)
 
     frn_movemenif a e           k disk    infsr(*pssr)
 
     f******rn_movleg o    e       disk    infsr(*pssr)                                      BUG9799
     frn_movleg if a e           k disk    infsr(*pssr)                                      BUG9799
 
     frn_movlegao    e             disk    infsr(*pssr)
     f                                     usropn
     f                                     prefix(m#)
 
     frn_uiload if a e           k disk    infsr(*pssr)
 
     frnaumvpd  o    e             disk    infsr(*pssr)
 
     frnxcmvpd  o    e             disk    infsr(*pssr)
 
     ft__dfboo  if a e           k disk    infsr(*pssr)
     f                                     rename(t__dfboo:t__dfboof)
 
     ft_frsamap if a e           k disk    infsr(*pssr)
     f                                     rename(t_frsamap:t_frsamapf)
 
     ft_rnclip  if a e           k disk    infsr(*pssr)
     f                                     rename(t_rnclip:t_rnclippf)
 
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
     d Suppressed      s                   like(rnAcKyLs)                                    BUG9792
     d acctkey         s                   like(acckey)
     d kfdCurrency     s                   like(Currency)                                    BUG9705
     d maturkey        s              1
     d fcltyfound      s               n
     d ExtFlfound      s               n
     d keyTyp          s              1
     d kExsub          s              4    INZ('LEKY')
     d rtnMap          s                   like(movamou)
     d accountkey      s                   like(akey)
     d payrec          s              1
     d wMdat           s                   like(mdat)
     d legSeq          s              5p 0                                                   BUG9799
 
     d pRtnCod         s              7
     d pOption         s              7
     d pKey1           s             10
     d pKyst           s              7
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
     d ftypa           s              3
     d aylnpta         s              2
     d ktyp            s              2
     d kstp            s              2
 
     d dupKey          c                   01021
 
     d rtnProduct      s                   like(product)
 
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
 
      /copy rncpysrc,rnrgaudfn
 
      /copy rncpysrc,rndaycnv
      /copy rncpysrc,rnamtcnv
      /copy rncpysrc,rnpayrec
      /copy rncpysrc,rnackylsd1                                                              BUG9792
                                                                                              CPK024
     ilkey1dpF                                                                                CPK024
     i              okey                        wokey                                         CPK024
                                                                                              CPK024
     ilkey3dpF                                                                                CPK024
     i              okey                        pokey                                         CPK024
 
     ilkeyfedf
     i              lkreci                      reci
     i              lkakey                      akey
     i              lklnno                      lnno
     i              lkcnum                      cnum
     i**********    lkbrcd                      brcd                                        BUG10118
     i              lkbrcd                      brca                                        BUG10118
     i              lkacsq                      acsq
     i              lkedat                      edat
     i              lkeamt                      eamt
     i              lkeccy                      eccy
     i              lksetp                      setp
     i              lkrevi                      revi
     i              lkotha                      otha
     i              lkothc                      othc
     i              lkexrt                      exrt
     i              lkstdt                      stdt
     i              lkslid                      slid
     i              lkmdat                      mdat
     i              lkbrtt                      brtt
     i              lkbrte                      brte
     i              lkrtsp                      rtsp
     i              lkintr                      intr
     i              lksseq                      sseq
     i              lkcpam                      cpam
     i              lkpacd                      pacd
     i              lkprfc                      prfc
     i              lkosbr                      osbr
     i              lkbokc                      bokc
     i              lksccy                      sccy
     i              lksind                      sind
     i              lkrind                      rind
     i              lkokey                      okey
     i              lkosac                      osac
 
     ilkeycfdf
     i              lkreci                      reci
     i              lkakey                      akey
     i              lklnno                      lnno
     i              lkcnum                      cnum
     i**********    lkbrcd                      brcd                                        BUG10118
     i              lkbrcd                      brca                                        BUG10118
     i              lkacsq                      acsq
     i              lkedat                      edat
     i              lkeamt                      eamt
     i              lkeccy                      eccy
     i              lksetp                      setp
     i              lkrevi                      revi
     i              lkotha                      otha
     i              lkothc                      othc
     i              lkexrt                      exrt
     i              lkstdt                      stdt
     i              lkslid                      slid
     i              lkmdat                      mdat
     i              lkbrtt                      brtt
     i              lkbrte                      brte
     i              lkrtsp                      rtsp
     i              lkintr                      intr
     i              lksseq                      sseq
     i              lkcpam                      cpam
     i              lkpacd                      pacd
     i              lkprfc                      prfc
     i              lkosbr                      osbr
     i              lkbokc                      bokc
     i              lksccy                      sccy
     i              lksind                      sind
     i              lkrind                      rind
     i              lkokey                      okey
     i              lkosac                      osac
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+
 
     c     *entry        plist
     c                   parm                    pRaid
 
      ** Key field for fclty
     c     kFclty        klist
     c                   kfld                    fcus
     c                   kfld                    ftyp
     c                   kfld                    fseq
 
      ** Key field for loan processing type
     c     kProtp        klist
     c                   kfld                    ktyp
     c                   kfld                    kstp
 
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
 
     c                   eval      keytyp = '1'
     c                   exsr      rtvFile
 
     c                   eval      keytyp = '2'
     c                   exsr      rtvFile
 
     c                   eval      keytyp = '3'
     c                   exsr      rtvFile
 
     c                   eval      keytyp = 'C'
     c                   exsr      rtvFile
 
     c                   eval      keytyp = 'F'
     c                   exsr      rtvFile
 
     c                   endsr
 
      ********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * rtvFile - Retrieve file                                           *
      *                                                                   *
      *********************************************************************
     c     RtvFile       begsr
 
     c                   select
     c                   when      keytyp = '1'
     c                   read      lkey1dpf
     c                   when      keytyp = '2'
     c                   read      lkey2dpf
     c                   when      keytyp = '3'
     c                   read      lkey3dpf
     c*****              when      keytyp = '3'                                              BUG9686
     c*****              read      lkey3dpf                                                  BUG9686
     c                   when      keytyp = 'C'
     c                   read      lkeycfdf
     c                   when      keytyp = 'F'
     c                   read      lkeyfedf
     c                   endsl
 
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
 
     c                   select
     c                   when      keytyp = '1'
     c                   read      lkey1dpf
     c                   when      keytyp = '2'
     c                   read      lkey2dpf
     c                   when      keytyp = '3'
     c                   read      lkey3dpf
     c*****              when      keytyp = '3'                                              BUG9686
     c*****              read      lkey3dpf                                                  BUG9686
     c                   when      keytyp = 'C'
     c                   read      lkeycfdf
     c                   when      keytyp = 'F'
     c                   read      lkeyfedf
     c                   endsl
 
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
 
      ** First handle loan key suppression check                                             BUG9792
     c                   if        (%subst( akey: 1: 1 ) = 'H'                               BUG9792
     c                             or %subst( akey: 1: 1 ) = 'J'                             BUG9792
     c                             or %subst( akey: 1: 1 ) = 'K')                            BUG9792
     c                   eval      Suppressed  = rnAcKyLs(akey                               BUG9792
     c                                                  : eccy                               BUG9792
     c                                                  : bjcycd )                           BUG9792
     c                   else                                                                BUG9792
      ** else handle facility type account key suppression check                             BUG9792
     c                   eval      Suppressed  = rnFcKyLs(akey                               BUG9792
     c                                                  : eccy                               BUG9792
     c                                                  : bjcycd )                           BUG9792
     c                   endif                                                               BUG9792
 
      ** If the account key is suppressed, do not check for selection.                       BUG9792
     c                   if        Suppressed                                                BUG9792
     c                   eval      rtnMap      = 0                                           BUG9792
     c                   leavesr                                                             BUG9792
     c                   endif                                                               BUG9792
                                                                                             BUG9792
      ** set up key fields to access t_frsamap                                               BUG9705
     c                   eval      acctkey     = akey
 
      ** Determine if this is a facility or loan key                                        BUG10118
      ** First handle loan key processing                                                   BUG10118
     c                   if        (%subst( acctkey: 1: 1 ) = 'H'               B01         BUG10118
     c                             or %subst( acctkey: 1: 1 ) = 'J'                         BUG10118
     c                             or %subst( acctkey: 1: 1 ) = 'K')                        BUG10118
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
      ** Use wildcard for deal extended subtype                                             BUG10742
     c                   eval      %subst( acctkey: 11: 4 )                                 BUG10742
     c                             = '****'                                                 BUG10742
     c                   eval      kfdCurrency   = eccy                                     BUG10742
     c     Kt_frsamap    chain     t_frsamap                                                BUG10742
     c                   endif                                                              BUG10742
                                                                                            BUG10742
      ** Check if all currency excluding base (wildcard deal extended subtype)              BUG10742
     c                   if        not %found                                               BUG10742
     c                   if        eccy <> bjcycd                                           BUG10742
     c                   eval      kfdCurrency = '*XB'                                      BUG10742
     c     Kt_frsamap    chain     t_frsamap                                                BUG10742
     c                   endif                                                              BUG10742
     c                   endif                                                              BUG10742
                                                                                            BUG10742
      ** Check if all currency (wildcard deal extended subtype)                             BUG10742
     c                   if        not %found                                               BUG10742
     c                   eval      kfdCurrency = '***'                                      BUG10742
     c     Kt_frsamap    chain     t_frsamap                                                BUG10742
     c                   endif                                                              BUG10742
 
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
 
     c                   if        not %found
     c                   eval      rtnMap      = 0
     c                   eval      rsnCde      = 'M'
     c                   exsr      wrtExcptn
     c                   else
     c                   eval      rtnMap      = movetype
     c                   endif
 
      ** Facility key processing                                                            BUG10118
     c                   else                                                   X01         BUG10118
      ** Check if event currency                                                            BUG10118
     c                   eval      kfdCurrency   = eccy                                     BUG10118
     c     Kt_frsamap    chain     t_frsamap                                                BUG10118
                                                                                            BUG10118
      ** Check if all currency excluding base                                               BUG10118
     c                   if        not %found                                   B02         BUG10118
     c                   if        eccy <> bjcycd                                            BUG9792
     c                   eval      kfdCurrency   = '*XB'                                    BUG10118
     c     Kt_frsamap    chain     t_frsamap                                                BUG10118
     c                   endif                                                               BUG9792
     c                   endif                                                  E02         BUG10118
                                                                                            BUG10118
      ** Check if all currency                                                              BUG10118
     c                   if        not %found                                   B02         BUG10118
     c                   eval      kfdCurrency = '***'                                      BUG10118
     c     Kt_frsamap    chain     t_frsamap                                                BUG10118
     c                   endif                                                  E02         BUG10118
                                                                                            BUG10118
     c                   if        not %found                                   B02         BUG10118
      ** Reset account key                                                                  BUG10118
     c                   eval      acctkey     = akey                                       BUG10118
      ** Use wildcard for facility type                                                     BUG10118
     c                   eval      %subst( acctkey: 1: 3 )                                  BUG10118
     c                             = '***'                                                  BUG10118
     c                   eval      kfdCurrency   = eccy                                     BUG10118
     c     Kt_frsamap    chain     t_frsamap                                                BUG10118
     c                   endif                                                  E02         BUG10118
                                                                                            BUG10118
      ***Check*if*all*currency excluding base (wildcard deal subtype)              BUG10118 BUG10742
      ** Check if all currency excluding base (wildcard facility type)                      BUG10742
     c                   if        not %found                                   B02         BUG10118
     c                   if        eccy <> bjcycd                                            BUG9792
     c                   eval      kfdCurrency = '*XB'                                      BUG10118
     c     Kt_frsamap    chain     t_frsamap                                                BUG10118
     c                   endif                                                               BUG9792
     c                   endif                                                  E02         BUG10118
                                                                                            BUG10118
      ***Check*if*all*currency (wildcard deal subtype)                             BUG10118 BUG10742
      ** Check if all currency (wildcard facility type)                                     BUG10742
     c                   if        not %found                                   B02         BUG10118
     c                   eval      kfdCurrency = '***'                                      BUG10118
     c     Kt_frsamap    chain     t_frsamap                                                BUG10118
     c                   endif                                                  E02         BUG10118
                                                                                            BUG10118
     c                   if        not %found                                   B02          BUG9792
     c                   eval      rtnMap      = 0                                           BUG9792
     c                   eval      rsnCde      = 'M'                                         BUG9792
     c                   exsr      wrtExcptn                                                 BUG9792
     c                   else                                                                BUG9792
     c                   eval      rtnMap      = movetype                                    BUG9792
     c                   endif                                                  B02          BUG9792
 
     c                   end                                                    E01         BUG10118
                                                                                            BUG10118
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
 
      ** Comment out the following because 'zzz' is not used as a curreny code for           BUG9686
      ** the lending records in RNKYPRPD.                                                    BUG9686
     c*****              if        %subst(accountkey:6:1) <> *blanks                         BUG9686
     c*****                        and %subst(accountkey:7:1) <> *blanks                     BUG9686
     c*****                        and %subst(accountkey:8:1) <> *blanks                     BUG9686
     c*****              eval      %subst(accountkey:6:3) = 'zzz'                            BUG9686
     c*****              endif                                                               BUG9686
                                                                                             BUG9686
      ** Set key for a/c key rcords:                                                         BUG9686
     c                   select                                                              BUG9686
                                                                                             BUG9686
      ** facility fee a/c key:                                                               BUG9686
     c                   when      keytyp  = '2'  or                                         BUG9686
     c                             (keytyp = 'F' and reci = 'F')                             BUG9686
     c                   eval      %subst(accountkey:1:3) = 'fff'                            BUG9686
     c                   eval      %subst(accountkey:8:2) = '  '                             BUG9686
      **  if position 5-7 is a currency, replace it with blank.                              BUG9686
     c                   eval      pccy    = %subst(accountkey:5:3)                          BUG9686
     c                   callb     'AOCURRR0'                                                BUG9686
     c                   parm      *blank        pRtnCod                                     BUG9686
     c                   parm      '*VERIFY'     pOption                                     BUG9686
     c                   parm                    pCcy                                        BUG9686
     c                   parm                    dssdy                                       BUG9686
     c                   if        pRtnCod = *blank                                          BUG9686
     c                   eval      %subst(accountkey:5:3) = '   '                            BUG9686
     c                   endif                                                               BUG9686
                                                                                             BUG9686
      ** contingent facility a/c key:                                                        BUG9686
     c                   when      keytyp = 'C'                                              BUG9686
     c                   eval      %subst(accountkey:1:3) = 'fff'                            BUG9686
     c                   eval      %subst(accountkey:4:1) = 'c'                              BUG9686
                                                                                             BUG9686
      ** Loan fee a/c key:                                                                   BUG9686
     c                   when      keytyp = 'F'  and reci = 'L'                              BUG9686
     c                   eval      %subst(accountkey:4:2) = 'yy'                             BUG9686
     c                   eval      %subst(accountkey:8:2) = '  '                             BUG9686
                                                                                             BUG9686
      ** Loan a/c key:                                                                       BUG9686
     c                   when      keytyp = '1'  or keytyp = '3'                             BUG9686
     c                   eval      %subst(accountkey:4:2) = 'yy'
     c                   endsl                                                               BUG9686
 
      ** Access processing type from loan type/ sub-type
      ** only for loan fee a/c type and Loan a/c type                                        BUG9686
     c                   if        (keytyp = 'F'  and reci = 'L') or                         BUG9686
     c                             keytyp = '1'  or keytyp = '3'                             BUG9686
     c                   eval      ktyp        = %subst(akey:1:2)
     c                   eval      kstp        = %subst(akey:4:2)
     c     kProtp        chain     sdloanl1
     c                   move      aylnpt        aylnpta
     c                   eval      %subst(accountkey:1:2) = aylnpta
     c                   endif                                                               BUG9686
 
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
     c                   clear                   t__uiload
 
      ** Get LE customer loans
     c                   exsr      getLoans
 
      ** Get internal customer
     c                   exsr      getBranch
 
      ** Get LE extension fields
     c                   exsr      getExtFld
 
     c                   exsr      movemenRec
     c                   exsr      moveLeg
     c                   if        CRN002
     c                   exsr      moveLegAPJ
     c                   endif
     c                   exsr      UILoanDep
 
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
     c                                         + 'LE'
     C**********                               + %editc( lnno: 'X' )                          CLE148
     C                                         + LNNO                                         CLE148
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
     c                   eval      corrvia     = rcrn
 
     c                   if        payrec      = 'P'
     c                   eval      corrto      = pons
     c                   else
     c                   eval      corrto      = rons
     c                   endif
 
     c                   eval      corrvia2    = *blanks
     c                   eval      corrto2     = *blanks
     c                   eval      paymtxt     = brca
     c                                         + 'LE'
     C**********                               + %editc( lnno: 'X')                           CLE148
     C                                         + LNNO                                         CLE148
     c                                         + runDatIso8
     c                   eval      inteli      = 0
 
     c                   if        revi        = 1
     c                   eval      cancella    = %editc( edat: 'X')
     c                   else
     c                   eval      cancella    = *blanks
     c                   endif
 
     c                   eval      expesett    = rndaycnv(edat)
     c                   eval      actusett    = rndaycnv(edat)
     c                   eval      correcti    = 0
 
     c                   if        extFlFound
     c                   eval      portfoli    = portfolo
     c                   endif
 
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
 
      ** Retrieve customer
     c**********         eval      pKey1       = %editc( cnum: 'X' )                         CSD027A
     c                   eval      pKey1       = cnum                                        CSD027A
     c                   exsr      getCust
 
     c                   eval      rowId       = 0
     c                   eval      statusl2    = 5
     c                   eval      modfdate    = *blanks
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      rowType     = 0
     c**********         eval      legref      = akey                                        BUG9799
     c                   eval      leglinre    = brca
     c                                         + 'LE'
     C**********                               + %editc( lnno: 'X')                           CLE148
     C                                         + LNNO                                         CLE148
     c                   eval      uiref       = brca
     c                                         + 'LE'
     C**********                               + %editc( lnno: 'X')                           CLE148
     C                                         + LNNO                                         CLE148
     c**********         eval      insttype    = 1                                          BUG10258
     c                   eval      insttype    = 3                                          BUG10258
     c                   eval      transact    = 0
     c                   eval      counref     = bbbrcd
     c                                         + '-'
     c                                         + cnum                                        CSD027A
     c**********                               + %editc( cnum: 'X')                          CSD027A
     c                   eval      moveref     = brca
     c                                         + 'LE'
     C**********                               + %editc( lnno: 'X')                           CLE148
     C                                         + LNNO                                         CLE148
     c                                         + runDatIso8
     c                   eval      paymtxt     = brca
     c                                         + 'LE'
     C**********                               + %editc( lnno: 'X')                           CLE148
     C                                         + LNNO                                         CLE148
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
 
     c                   if        benn <> *blanks
     c                   eval      pKey1       = benn
     c                   exsr      getCust
     c                   eval      residenc    = bbcncz
     c                   endif
 
      * Get currency details.
     c                   eval      pCcy        = eccy
     c                   exsr      getCcy
 
     c                   eval(h)   ocaamunt    = %abs(eamt)/(10**a6nbdp)
     c                   eval      rcaamunt    = rnAmtCnv(ocaamunt
     c                                                  : a6sprt
     c                                                  : a6mdin
     c                                                  : aRpCySprt(rgIx)
     c                                                  : aRpCyMdin(rgIx)
     c                                                  : aRpCyNbdp(rgIx) )
 
     c                   eval      deal        = rndaycnv(ddat)
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
     c**********                               + 'LE'                                        BUG9799
     c**********                               + %editc( lnno: 'X')                          BUG9799
     c**********                               + runDatIso8                                  BUG9799
     c                   eval      m#legref    = legref                                      BUG9799
     c                   eval      m#moveref   = moveref                                     BUG9799
     c**********         eval      m#rmbaccnu  = %editc( pocn: 'X')                          CSD027A
     c                   eval      m#rmbaccnu  = pocn                                        CSD027A
     c                   eval      m#actuexch  = exrt
 
     c                   if        payrec = 'P'
     c**********         eval      m#ordecust  = %editc( pocn: 'X')                          CSD027A
     c**********         eval      m#ordeinst  = %editc( pobn: 'X')                          CSD027A
     c                   eval      m#ordecust  = pocn                                        CSD027A
     c                   eval      m#ordeinst  = pobn                                        CSD027A
     c                   eval      m#transact  = 40
     c                   else
     c**********         eval      m#ordecust  = %editc( rocn: 'X')                          CSD027A
     c**********         eval      m#ordeinst  = %editc( robn: 'X')                          CSD027A
     c                   eval      m#ordecust  = pocn                                        CSD027A
     c                   eval      m#ordeinst  = robn                                        CSD027A
     c                   eval      m#transact  = 30
     c                   endif
 
     c                   eval      m#accwitin  = awbn
     c                   eval      m#principa  = *blanks
     c                   eval      m#benecust  = benn
     c                   eval      m#paymmtd   = 0
     c                   eval      m#remittan  = *blanks
     c                   eval      m#settmtd   = 0
     c                   eval      m#medoftr   = 0
     c                   eval      m#trancode  = 0
     c                   eval      m#limenqre  = *blanks
     c                   eval      m#speappre  = *blanks
     c                   eval      m#ovbeacnu  = bena
 
     c                   write     t__movLega
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UILoanDep - Subroutine that writes Records To rn_uiload      *
      *                                                               *
      *****************************************************************
     c     UILoanDep     begsr
 
     c                   eval      uiref       = brca
     c                                         + 'LE'
     C**********                               + %editc( lnno: 'X')                           CLE148
     C                                         + LNNO                                         CLE148
     c     uiref         chain     rn_uiload
     c                   if        not(%found)
 
     c                   eval      rowId       = 0
     c                   eval      statusl2    = 5
     c                   eval      modfdate    = *blanks
     c                   move      runDatIso     validon
     c                   eval      lottypfk    = aPosLot(rgIx)
     c                   eval      rowType     = 0
     c                   eval      contref     = brca
     c                                         + 'LE'
     C**********                               + %editc( lnno: 'X')                           CLE148
     C                                         + LNNO                                         CLE148
 
     c                   if        keytyp = '2'
     c                   eval      start       = rndaycnv(slid)
     c                   else
     c                   eval      start       = rndaycnv(stdt)
     c                   endif
 
     c                   eval      lasintda    = rndaycnv(slid)
 
      * Maturity date.
     c                   select
     c                   when      mdat       <> 0
     c                   eval      wMdat       = mdat
 
     c                   when      (   nidt    > 0
     c                             or  nrod    > 0
     c                             or  nrpd    > 0 )
     c                   if        nidt        > nrod
     c                   eval      wMdat       = nidt
     c                   else
     c                   eval      wMdat       = nrod
     c                   endif
     c                   if        wMdat      <= nrpd
     c                   eval      wMdat       = nrpd
     c                   else
     c                   eval      wMdat       = wMdat + 1
     c                   endif
 
     c                   other
     c                   if        bjrdnb      > vdat
     c                   eval      wMdat       = bjrdnb + 1
     c                   else
     c                   eval      wMdat       = vdat + 1
     c                   endif
 
     c                   endsl
     c                   eval      maturity    = rnDayCnv(wMdat)
 
     c                   eval      nexintfi    = *blanks
     c                   eval      original    = wMdat - ddat
     c                   eval      perintra    = intr
     c                   eval      intintra    = intr
 
     c**********         eval      pKey1       = %editc( cnum: 'X' )                         CSD027A
     c                   eval      pKey1       = cnum                                        CSD027A
     c                   exsr      getCust
     c                   move      ftyp          ftypa
     c                   exsr      getProdCode
     c                   eval      product     = rtnProduct
 
     c                   select
     c                   when      ipfr = 'M'
     c                             or ipfr = 'N'
     c                   eval      reimfreq    = 12
     c                   eval      intpayfr    = 12
     c                   when      ipfr = 'Q'
     c                   eval      reimfreq    = 4
     c                   eval      intpayfr    = 4
     c                   when      ipfr = 'X'
     c                   eval      reimfreq    = 2
     c                   eval      intpayfr    = 2
     c                   when      ipfr = 'Y'
     c                   eval      reimfreq    = 1
     c                   eval      intpayfr    = 1
     c                   endsl
 
     c                   eval      intretra    = 0
 
     c                   select
     c                   when      ltyp = '61'
     c                             or ltyp = '62'
     c                             or ltyp = '63'
     c                             or ltyp = '80'
     c                             or ltyp = '68'
     c                             or ltyp = '64'
     c                             or ltyp = '65'
     c                             or ltyp = '71'
     c                   eval      alindi      = 1
     c                   when      ltyp = '69'
     c                             or ltyp = '66'
     c                             or ltyp = '67'
     c                             or ltyp = '72'
     c                   eval      alindi      = 2
     c                   when      ltyp = '70'
     c                   eval      alindi      = 0
     c                   endsl
 
     c                   eval      risquain    = 1
 
     c                   select
     c                   when      icbs = 1
     c                   eval      indacoba    = 15
     c                   when      icbs = 2
     c                   eval      indacoba    = 2
     c                   when      icbs = 3
     c                   eval      indacoba    = 5
 
      **Unpopulated*due*to*issue*21                                                         BUG11435
     c**********         when      icbs = 4                                                 BUG11435
     c**********                   or icbs = 5                                              BUG11435
     c**********                   or icbs = 6                                              BUG11435
     c*                  eval      indacoba    =
     c                   when      icbs        = 4                                          BUG11435
     c                   eval      indacoba    = 16                                         BUG11435
     c                   when      icbs        = 5                                          BUG11435
     c                   eval      indacoba    = 17                                         BUG11435
     c                   when      icbs        = 6                                          BUG11435
     c                   eval      indacoba    = 18                                         BUG11435
     c                   when      icbs        = 7                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
     c                   when      icbs        = 8                                          BUG11435
     c                   eval      indacoba    = 5                                          BUG11435
     c                   other                                                              BUG11435
     c                   eval      indacoba    = 0                                          BUG11435
     c                   endsl
 
     c                   if        brtt <> 0
     c                   eval      amortisa    = 2
     c                   eval      typintra    = 2
     c                   else
     c                   eval      amortisa    = 1
     c                   eval      typintra    = 1
     c                   endif
 
     c                   eval      rediscou    = 0
 
     c                   exsr      getFclty
     c                   if        fcltyFound
     c                             and f#rvcr  = 'Y'
     c                   eval      revofac     = 1
     c                   endif
 
     c                   eval      subordin    = 0
     c                   if        extFlFound
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
      *  wrtAudit -  write Audit Records                              *
      *                                                               *
      *****************************************************************
     c     wrtAudit      begsr
 
     c                   eval      amregaut    = aRaid(rgIx)
     c                   eval      ammodule    = 'LE'
     C**********         eval      amcntref    = %editc( lnno: 'X')                           CLE148
     C                   EVAL      AMCNTREF    = LNNO                                         CLE148
     c                   eval      ammovtyp    = movetype
     c                   eval      amorgccy    = isocurr
     c                   eval      amakey      = akey
     c                   eval      ambrch      = brca
     c**********         eval      amcusn      = %editc( cnum: 'X')                          CSD027A
     c                   eval      amcusn      = cnum                                        CSD027A
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
     c                   eval      xmmodule    = 'LE'
     C**********         eval      xmcntref    = %editc( lnno: 'X')                           CLE148
     C                   EVAL      XMCNTREF    = LNNO                                         CLE148
     c                   eval      xmakey      = akey
     c                   eval      xmbrch      = brca
     c**********         eval      xmcusn      = %editc( cnum: 'X')                          CSD027A
     c                   eval      xmcusn      = cnum                                        CSD027A
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
     c                   parm                    I#AccountCode
     c                   parm                    I#dealType
     c                   parm                    I#dealsubType
     c                   parm      ltyp          I#LoanType
     c                   parm      sutp          I#LoanSubType
     c                   parm      ftypa         I#FacilityType
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
     c                   eval      wDbkey      = I#LoanType
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
      *  getLoans  - Subroutine that retrieves customer loans details *
      *                                                               *
      *****************************************************************
     c     getLoans      begsr
 
     c     lnno          chain     cloanclf
 
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
     c                   parm                    BRCA
     c     sdbrch        parm                    dsfdy
                                                                                            BUG10501
     c                   if        pRtnCod    <> *blanks                                    BUG10501
     c                   eval      wDbmod      = 'AOBRCHR0'                                 BUG10501
     c                   eval      wDbase      = 21                                         BUG10501
     c                   eval      wDbkey      = BRCA                                       BUG10501
     c                   exsr      *pssr                                                    BUG10501
     c                   endif                                                              BUG10501
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  getExtFld - Subroutine that retrieves LE extension fields.   *
      *                                                               *
      *****************************************************************
     c     getExtFld     begsr
 
     c     lnno          chain     t_rnclip
     c                   eval      ExtFlfound  = %found
 
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
     c                   eval      wDbmod      = 'AOBANKR0'                                 BUG10501
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
(c) Misys International Banking Systems Ltd. 2005
