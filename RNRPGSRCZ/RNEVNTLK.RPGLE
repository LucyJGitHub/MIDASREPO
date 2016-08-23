     h nomain
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Event Lookup function')
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNEVTLKP   - Event Lookup function                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG9792            Date 04Apr06               *
      *  Prev Amend No. BUG10439           Date 14Feb06               *
      *                 BUG10017           Date 20Jan06               *
      *                 CRN001  *Create    Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *  BUG9792  -  Event rule validation enhancement: apply         *
      *              suppression rules first.                         *
      *              Do not set up printintr if 'PDUE' and return     *
      *              Reportind instead for 'PDUE' in sr. tryLookup.   *
      *  BUG10439 - Past dues do not consider the principal/interest  *
      *             flag from RNEVPIPD.                               *
      *  BUG10017 - Wrong field used in decision to extract.          *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
 
     ft_frsemap if   e             disk    usropn
     f                                     rename(t_frsemap: t_frsemapf)
 
     frnevpipd  if   e           k disk    usropn
 
      *=====================================================================
 
     d                 ds
     d aEvntData                           dim(9999)
     d aEvntcode                           like(evntcode)
     d                                     overlay(aEvntData : *next)
     d aTrantype                           like(trantype)
     d                                     overlay(aEvntData : *next)
     d aSubtype                            like(subtype)
     d                                     overlay(aEvntData : *next)
     d aCurrency                           like(currency)
     d                                     overlay(aEvntData : *next)
     d aReportind                          like(reportind)
     d                                     overlay(aEvntData : *next)
     d aPrinintr                           like(prinintr)
     d                                     overlay(aEvntData : *next)
     d aEvntLkp                      11    overlay(aEvntData)
 
     d evEl            s              5u 0
     d evIx            s              5u 0
 
     d matchFnd        s              1                                                      BUG9792
 
     d wEvent          ds
     d  wEvntcode                          like(evntcode)
     d  wTrantype                          like(trantype)
     d  wSubtype                           like(subtype)
     d  wCurrency                          like(currency)
 
      /copy rncpysrc,rnevntlk
 
      *=====================================================================
 
     p rnEvntLk        b                   export
 
     d                 pi                  like(rnEvntLk)
     d evntcode                       4    const
     d trantype                       2    const
     d subtype                        2    const
     d currency                       3    const
     d baseCcy                        3    const
 
      *---------------------------------------------------------------------                 BUG9792
      * Look up if the event is suppressed:                                                  BUG9792
 
     c                   eval      matchFnd    = 'N'                                         BUG9792
 
      * a)  Look up eeee-**-**-***, eeee-**-**-*XB, eeee-**-**-ccc.                          BUG9792
      *     Wildcard in tran type and subtype.                                               BUG9792
     c                   eval      wEvntcode   = evntcode                                    BUG9792
     c                   eval      wSubtype    = '**'                                        BUG9792
     c                   eval      wTrantype   = '**'                                        BUG9792
     c                   eval      wCurrency   = '***'                                       BUG9792
     c                   exsr      tryLookupSupp                                             BUG9792
                                                                                             BUG9792
     c                   if        currency   <> baseCcy                                     BUG9792
     c                   eval      wCurrency   = '*XB'                                       BUG9792
     c                   exsr      tryLookupSupp                                             BUG9792
     c                   endif                                                               BUG9792
                                                                                             BUG9792
     c                   eval      wCurrency   = currency                                    BUG9792
     c                   exsr      tryLookupSupp                                             BUG9792
                                                                                             BUG9792
      * If event code is 'PDUE', stop check for suppress here.                               BUG9792
     c                   if        evntcode    = 'PDUE'                                      BUG9792
     c                   goto      ChkMatchFnd                                               BUG9792
     c                   endif                                                               BUG9792
                                                                                             BUG9792
      * b)  Look up eeee-tt-**-***, eeee-tt-**-*XB, eeee-tt-**-ccc.                          BUG9792
      *     Wildcard in subtype.                                                             BUG9792
                                                                                             BUG9792
     c                   eval      wTrantype   = trantype                                    BUG9792
     c                   eval      wSubtype    = '**'                                        BUG9792
     c                   eval      wCurrency   = '***'                                       BUG9792
     c                   exsr      tryLookupSupp                                             BUG9792
                                                                                             BUG9792
     c                   if        currency   <> baseCcy                                     BUG9792
     c                   eval      wCurrency   = '*XB'                                       BUG9792
     c                   exsr      tryLookupSupp                                             BUG9792
     c                   endif                                                               BUG9792
                                                                                             BUG9792
     c                   eval      wCurrency   = currency                                    BUG9792
     c                   exsr      tryLookupSupp                                             BUG9792
                                                                                             BUG9792
      * c)  Look up eeee-tt-ss-***, eeee tt-ss-*XB, eeee-tt-ss-ccc.                          BUG9792
                                                                                             BUG9792
     c                   eval      wEvntcode   = evntcode                                    BUG9792
     c                   eval      wTrantype   = trantype                                    BUG9792
     c                   eval      wSubtype    = subtype                                     BUG9792
     c                   eval      wCurrency   = '***'                                       BUG9792
     c                   exsr      tryLookupSupp                                             BUG9792
                                                                                             BUG9792
     c                   if        currency   <> baseCcy                                     BUG9792
     c                   eval      wCurrency   = '*XB'                                       BUG9792
     c                   exsr      tryLookupSupp                                             BUG9792
     c                   endif                                                               BUG9792
                                                                                             BUG9792
     c                   eval      wCurrency   = currency                                    BUG9792
     c                   exsr      tryLookupSupp                                             BUG9792
                                                                                             BUG9792
     c     ChkMatchFnd   tag                                                                 BUG9792
      * if not match event found, return                                                     BUG9792
     c                   if        matchfnd    = 'N'                                         BUG9792
     c                   return    '*'                                                       BUG9792
     c                   endif                                                               BUG9792
                                                                                             BUG9792
      *---------------------------------------------------------------------
      * Not suppressed event and match event have been found.                                BUG9792
      * Look up and get print indicator:                                                     BUG9792
 
      * a)  Look up eeee-tt-ss-ccc, eeee tt-ss-*XB, eeee-tt-ss-***.
 
     c                   eval      wEvntcode   = evntcode
     c                   eval      wTrantype   = trantype
     c                   eval      wSubtype    = subtype
     c                   eval      wCurrency   = currency
     c                   exsr      tryLookup
 
     c                   if        currency   <> baseCcy
     c                   eval      wCurrency   = '*XB'
     c                   exsr      tryLookup
     c                   endif
 
     c                   eval      wCurrency   = '***'
     c                   exsr      tryLookup
 
      * b)  Look up eeee-tt-**-ccc, eeee-tt-**-*XB, eeee-tt-**-***.
      *     Wildcard in subtype.
 
     c                   eval      wSubtype    = '**'
     c                   eval      wCurrency   = currency
     c                   exsr      tryLookup
 
     c                   if        currency   <> baseCcy
     c                   eval      wCurrency   = '*XB'
     c                   exsr      tryLookup
     c                   endif
 
     c                   eval      wCurrency   = '***'
     c                   exsr      tryLookup
 
      * c)  Look up eeee-**-**-ccc, eeee-**-**-*XB, eeee-**-**-***.
      *     Wildcard in tran type and subtype.
     c                   eval      wTrantype   = '**'
     c                   eval      wCurrency   = currency
     c                   exsr      tryLookup
 
     c                   if        currency   <> baseCcy
     c                   eval      wCurrency   = '*XB'
     c                   exsr      tryLookup
     c                   endif
 
     c                   eval      wCurrency   = '***'
     c                   exsr      tryLookup
 
      * Value returned to signify that no match was found.
     c                   return    '*'
 
      *---------------------------------------------------------------------                 BUG9792
      * If the look up is successful, return blank if Report indicator is                    BUG9792
      * 'N' for event mapping suppression.                                                   BUG9792
                                                                                             BUG9792
     c     tryLookupSupp begsr                                                               BUG9792
                                                                                             BUG9792
     c                   eval      evIx        = %lookup(wEvent                              BUG9792
     c                                                 : aEvntLkp                            BUG9792
     c                                                 : 1                                   BUG9792
     c                                                 : evEl )                              BUG9792
     c                   select                                                              BUG9792
     c                   when      evIx        = 0                                           BUG9792
                                                                                             BUG9792
     c                   when      aReportind(evIx) = 'Y'                                    BUG9792
     c                   eval      matchFnd    = 'Y'                                         BUG9792
     c                   other                                                               BUG9792
     c                   return    *blank                                                    BUG9792
     c                   endsl                                                               BUG9792
                                                                                             BUG9792
     c                   endsr                                                               BUG9792
                                                                                             BUG9792
      *---------------------------------------------------------------------
      * If the look up is successful, return the Principal/Interest
      * flag or blank depending on the Report Indicator.
 
     c     tryLookup     begsr
 
     c                   eval      evIx        = %lookup(wEvent
     c                                                 : aEvntLkp
     c                                                 : 1
     c                                                 : evEl )
     c                   select
     c                   when      evIx        = 0
 
     c**********         when      reportind   = 'Y'                                        BUG10017
     c                   when      aReportind(evIx) = 'Y'                                   BUG10017
     c                   if        evntcode      <> 'PDUE'                                  BUG09792
     c                   return    aPrinintr(evIx)
 
     c                   else                                                               BUG09792
     c                   return    'Y'                                                      BUG09792
     c                   endif                                                              BUG09792
 
     c                   other
     c                   return    *blank
     c                   endsl
 
     c                   endsr
      *---------------------------------------------------------------------
 
     p                 e
 
      *=====================================================================
 
      * Event lookup initialisation.
      * This procedure loads the arrays, and will be called
      * from the initial subroutine of the extract program.
 
     p rnEvntLkIn      b                   export
 
     d                 pi
     d currZone                      10    const
 
     c                   if        not %open(t_frsemap)
     c                   open      t_frsemap
     c                   endif
     c                   if        not %open(rnevpipd)
     c                   open      rnevpipd
     c                   endif
 
     c                   eval      evEl        = 0
     c     *start        setll     t_frsemap
     c                   read      t_frsemap
     c                   dow       not %eof
 
     c                   if        zone        = currZone
     c                   eval      evEl        = evEl + 1
     c                   eval      aEvntcode(evEl) = evntcode
     c                   eval      aTrantype(evEl) = trantype
     c                   eval      aSubtype(evEl)  = subtype
     c                   eval      aCurrency(evEl) = currency
     c                   eval      aReportind(evEl)= reportind
     c                   eval      aPrinintr(evEl) = *blank                                 BUG09792
 
      * If 'Report Indicator' is Y, get 'Principal/Interest' flag.
 
     c                   if        reportind   = 'Y'
     c                             and evntcode <> 'PDUE'                                   BUG10439
     c     evntcode      chain     rnevpipd
     c                   if        not %found
     c                             or (   prinintr <> 'P'
     c                                and prinintr <> 'I' )
     c                   eval      prinintr    = '*'
     c                   endif
                                                                                            BUG10439
      **Do*not*fail*lookup*with*'*'*if*a*past*due*event.*Set*to*'N'*for*not*applicable. BUG10439
                                                                                   BUG10439 BUG09792
     c*******            if        reportind   = 'Y'                               BUG10439 BUG09792
     c*******                      and evntcode = 'PDUE'                           BUG10439 BUG09792
     c*******            eval      prinintr    = 'N'                               BUG10439 BUG09792
     c*******            endif                                                     BUG10439 BUG09792
                                                                                            BUG10439
     c                   eval      aPrinintr(evEl) = prinintr
     c                   endif
 
     c                   endif
 
     c                   read      t_frsemap
     c                   enddo
 
     c                   close     t_frsemap
     c                   close     rnevpipd
 
     p                 e
