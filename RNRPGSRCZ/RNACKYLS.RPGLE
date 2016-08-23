     h nomain
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Suppressed Account Keys Lookup Function')
      *****************************************************************
      *                                                               *
      *  MidasPlus - FRS Regulatory Reporting Interface               *
      *                                                               *
      *  RNACKYLS   - Suppressed Account Keys Lookup Function         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG10742           Date 03May06               *
      *  Prev Amend No. BUG9792 *Create    Date 16Mar06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG10742 - Include checking wildcard for extended subtype.   *
      *  BUG9792  - Created for looking up if the account key is      *
      *             suppressed for extraction.                        *
      *                                                               *
      *****************************************************************
 
     ft_frsamap if   e             disk    usropn
     f                                     rename(t_frsamap: t_frsamapf)
 
      *=====================================================================
 
     d                 ds
     d aSuppAcKy                           dim(9999)
     d aAccKey                             like(Acckey)
     d                                     overlay(aSuppAcKy : *next)
     d aCurrency                           like(currency)
     d                                     overlay(aSuppAcKy : *next)
     d aAcKyLkp                      23    overlay(aSuppAcky)
 
     d akEl            s              5u 0
     d akIx            s              5u 0
 
     d wAcKyMap        ds
     d  wAccKey                            like(AccKey)
     d  wCurrency                          like(currency)
 
      /copy rncpysrc,rnackylsd1
 
      *=====================================================================
      * Account key lookup for deal type or loan type.
      * Check if the account type is suppressed for movetype extraction,
      * indicator returned will be set on. Otherwise, indicator returned off.
 
     p rnAcKyLS        b                   export
 
     d                 pi                  like(rnAcKyLS)
     d AccKey                        20    const
     d currency                       3    const
     d baseCcy                        3    const
 
      *---------------------------------------------------------------------
      * a)  Wildcard for deal type/subtype.
 
     c                   eval      wAccKey     = AccKey
     c                   eval      %subst(wAcckey: 1: 2 )
     c                             = '**'
     c                   eval      %subst(wAcckey: 4: 2 )
     c                             = '**'
 
      ** Check if all currency (wildcard deal type/subtype)
     c                   eval      wCurrency   = '***'
     c                   exsr      tryLookup
 
      ** If not base ccy, check if all currency excluding base (wildcard deal type/subtype)
     c                   if        currency   <> baseCcy
     c                   eval      wCurrency   = '*XB'
     c                   exsr      tryLookup
     c                   endif
 
      ** Check if event currency (wildcard deal type/subtype)
     c                   eval      wCurrency   = currency
     c                   exsr      tryLookup
 
      ** a.1) Wildcard for deal type/extended subtype.                                      BUG10742
                                                                                            BUG10742
     c                   eval      %subst(wAcckey: 11: 4 )                                  BUG10742
     c                             = '****'                                                 BUG10742
                                                                                            BUG10742
      ** Check if all currency (wildcard deal type/extended subtype)                        BUG10742
     c                   eval      wCurrency   = '***'                                      BUG10742
     c                   exsr      tryLookup                                                BUG10742
                                                                                            BUG10742
      ** If not base ccy, check if all currency excluding base (wildcard deal type/         BUG10742
      **    extended subtype                                                                BUG10742
     c                   if        currency   <> baseCcy                                    BUG10742
     c                   eval      wCurrency   = '*XB'                                      BUG10742
     c                   exsr      tryLookup                                                BUG10742
     c                   endif                                                              BUG10742
                                                                                            BUG10742
      ** Check if event currency (wildcard deal type/extended subtype)                      BUG10742
     c                   eval      wCurrency   = currency                                   BUG10742
     c                   exsr      tryLookup                                                BUG10742
                                                                                            BUG10742
      * b)  Wildcard in subtype.
     c                   eval      wAccKey     = AccKey
     c                   eval      %subst(wAccKey: 4: 2 )
     c                             = '**'
 
      ** Check if all currency (wildcard subtype)
     c                   eval      wCurrency   = '***'
     c                   exsr      tryLookup
 
      ** If not base ccy, check if all currency excluding base (wildcard subtype)
     c                   if        currency   <> baseCcy
     c                   eval      wCurrency   = '*XB'
     c                   exsr      tryLookup
     c                   endif
 
      ** Check if event currency (wildcard subtype)
     c                   eval      wCurrency   = currency
     c                   exsr      tryLookup
 
      ** b.1) Wildcard in extended subtype.                                                 BUG10742
     c                   eval      %subst(wAccKey: 11: 4)                                   BUG10742
     c                             = '****'                                                 BUG10742
                                                                                            BUG10742
      ** Check if all currency (wildcard extended subtype)                                  BUG10742
     c                   eval      wCurrency   = '***'                                      BUG10742
     c                   exsr      tryLookup                                                BUG10742
                                                                                            BUG10742
      ** If not base ccy, check if all currency excluding base (wildcard extended subtype)  BUG10742
     c                   if        currency   <> baseCcy                                    BUG10742
     c                   eval      wCurrency   = '*XB'                                      BUG10742
     c                   exsr      tryLookup                                                BUG10742
     c                   endif                                                              BUG10742
                                                                                            BUG10742
      ** Check if event currency (wildcard extended subtype)                                BUG10742
     c                   eval      wCurrency   = currency                                   BUG10742
     c                   exsr      tryLookup                                                BUG10742
                                                                                            BUG10742
      * c)  Account key.
      ** Check if all currency
     c                   eval      wAccKey     = AccKey
     c                   eval      wCurrency   = '***'
     c                   exsr      tryLookup
 
      ** If not base ccy, check if all currency excluding base
     c                   if        currency   <> baseCcy
     c                   eval      wCurrency   = '*XB'
     c                   exsr      tryLookup
     c                   endif
 
      ** Check if event currency
     c                   eval      wCurrency   = currency
     c                   exsr      tryLookup
 
      * Value returned to signify that no match was found.
     c                   return    '0'
 
      *---------------------------------------------------------------------
      * If the look up is successful, return %equal indicator which is '1'.
 
     c     tryLookup     begsr
 
     c     wAcKyMap      lookup    aAcKyLkp                               26
     c                   if        *in26 = '1'
     c                   return    %equal
     c                   end
 
     c                   endsr
      *---------------------------------------------------------------------
 
     p                 e
 
      *=====================================================================
      * Account key lookup for facility type.
      * Check if the account type is suppressed for movetype extraction,
      * indicator returned will be set on. Otherwise, indicator returned off.
 
 
     p rnFcKyLS        b                   export
 
     d                 pi                  like(rnFcKyLS)
     d AccKey                        20    const
     d currency                       3    const
     d baseCcy                        3    const
 
      *---------------------------------------------------------------------
      * a)  Wildcard for Facility Type.
 
     c                   eval      wAccKey     = AccKey
     c                   eval      %subst(wAcckey: 1: 3 )
     c                             = '***'
 
      ** Check if all currency (wildcard facility type)
     c                   eval      wCurrency   = '***'
     c                   exsr      tryLookup
 
      ** If not base ccy, check if all currency excluding base (wildcard facility type)
     c                   if        currency   <> baseCcy
     c                   eval      wCurrency   = '*XB'
     c                   exsr      tryLookup
     c                   endif
 
      ** Check if event currency (wildcard facility type)
     c                   eval      wCurrency   = currency
     c                   exsr      tryLookup
 
      * b)  Account key.
      ** Check if all currency
     c                   eval      wAccKey     = AccKey
     c                   eval      wCurrency   = '***'
     c                   exsr      tryLookup
 
      ** If not base ccy, check if all currency excluding base
     c                   if        currency   <> baseCcy
     c                   eval      wCurrency   = '*XB'
     c                   exsr      tryLookup
     c                   endif
 
      ** Check if event currency (wildcard facility type)
     c                   eval      wCurrency   = currency
     c                   exsr      tryLookup
 
      * Value returned to signify that no match was found.
     c                   return    '0'
 
      *---------------------------------------------------------------------
      * If the look up is successful, return %equal indicator which is '1'.
 
     c     tryLookup     begsr
 
     c     wAcKyMap      lookup    aAcKyLkp                               26
     c                   if        *in26 = '1'
     c                   return    %equal
     c                   end
 
     c                   endsr
      *---------------------------------------------------------------------
 
     p                 e
 
      *=====================================================================
 
      * Account key lookup initialisation.
      * This procedure loads the array aSuppAcKy with account keys whose
      * movetype is 0 (ie, suppressed).  This procedure will be called
      * from the initial subroutine of the extract program.
      *
 
     p rnAcKyLsIn      b                   export
 
     d                 pi
     d currZone                      10    const
 
     c                   if        not %open(t_frsamap)
     c                   open      t_frsamap
     c                   endif
 
     c                   eval      akEl       = 0
     c     *start        setll     t_frsamap
     c                   read      t_frsamap
     c                   dow       not %eof
 
     c                   if        zone        = currZone  and
     c                             movetype    = 0
     c                   eval      akEl        = akEl + 1
     c                   eval      aAccKey(akEl )   = acckey
     c                   eval      aCurrency(akEl) = currency
 
     c                   endif
 
     c                   read      t_frsamap
     c                   enddo
 
     c                   close     t_frsamap
 
     p                 e
