     h nomain
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Return pay/receive flag')
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNPAYREC   - Return Pay/Receive flag                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CRN001  *Create    Date 26Sep05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
     frnkyprpd  if   e           k disk    usropn
     f                                     prefix(p_)
 
     d                 ds
     d aPayRec                             dim(9999)
     d  acctKey                            like(p_rnkey)
     d                                     overlay(aPayRec)
     d  payRec                             like(p_rnpayrec)
     d                                     overlay(aPayRec: *next)
 
     d elm             s              5u 0                                      no. of array entries
     d elmIx           s              5u 0                                      arrary index
 
      /copy rncpysrc,rnpayrec
 
      *=====================================================================
 
     p rnPayRec        b                   export
 
     d                 pi                  like(p_rnPayRec)
     d acctKeyIn                           like(p_rnkey) const
 
      *---------------------------------------------------------------------
 
     c                   eval      elmIx =  0
 
     c                   eval      elmIx =  %lookup(acctKeyIn
     c                                      : acctKey
     c                                      : 1
     c                                      : elm )
     c                   select
     c                   when      elmIx > 0
     c                   return    payRec(elmIx)
 
     c                   other
     c                   return    '*'
     c                   endsl
 
     p                 e
 
      *=====================================================================
 
     p rnPayRecIn      b                   export
 
     c                   if        not %open(rnkyprpd)
     c                   open      rnkyprpd
     c                   endif
 
     c     *loval        setll     rnkyprpd
     c                   read      rnkyprpd
 
     c                   eval      elm         = 0
 
     c                   dow       not %eof
     c                   eval      elm          += 1
     c                   eval      acctKey(elm)  = p_rnkey
     c                   eval      payRec(elm)   = p_rnpayrec
 
     c                   read      rnkyprpd
     c                   enddo
 
     c                   close     rnkyprpd
 
     p                 e
