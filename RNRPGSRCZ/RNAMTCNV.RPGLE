     h nomain
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Return converted amount')
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNAMTCNV   - Convert Amount                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CRN001  *Create    Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
 
      /copy rncpysrc,rnamtcnv
 
      *=====================================================================
 
     p rnAmtCnv        b                   export
 
     d                 pi                  like(rnAmtCnv)
     d pFmAmnt                             like(rnAmtCnv)
     d                                     const
     d pFmExrt                       13  8 const
     d pFmMdin                        1    const
     d pToExrt                       13  8 const
     d pToMdin                        1    const
     d pToNbdp                        1  0 const
 
     d lenAmt          c                   %len(pFmAmnt)
     d wRtnAmount      s             20  4
 
      *---------------------------------------------------------------------
 
      * Calculate returned amount (unrounded with extra decimal place).
     c                   select
     c                   when      (   pFmAmnt = 0
     c                             or  pFmExrt = 0
     c                             or  pToExrt = 0       )
     c                   return    0
 
     c                   when      (   pFmExrt = pToExrt
     c                             and pFmMdin = pToMdin )
     c                   eval      wRtnAmount  = pFmAmnt
 
     c                   when      (   pFmMdin = 'M'
     c                             and pToMdin = 'M'     )
     c                   eval      wRtnAmount  = pFmAmnt * pFmExrt
     c                                                   / pToExrt
 
     c                   when      (   pFmMdin = 'M'
     c                             and pToMdin = 'D'     )
     c                   eval      wRtnAmount  = pFmAmnt * pFmExrt
     c                                                   * pToExrt
 
     c                   when      (   pFmMdin = 'D'
     c                             and pToMdin = 'M'     )
     c                   eval      wRtnAmount  = (pFmAmnt / pFmExrt)
     c                                                    / pToExrt
 
     c                   when      (   pFmMdin = 'D'
     c                             and pToMdin = 'D'     )
     c                   eval      wRtnAmount  = (pFmAmnt / pFmExrt)
     c                                                    * pToExrt
 
     c                   other
     c                   return    0
 
     c                   endsl
 
      * Half-adjust to correct number of decimals.
     c                   select
     c                   when      pToNbdp     = 2
     c                   return    %dech(wRtnAmount : lenAmt : 2)
 
     c                   when      pToNbdp     = 0
     c                   return    %dech(wRtnAmount : lenAmt : 0)
 
     c                   when      pToNbdp     = 3
     c                   return    %dech(wRtnAmount : lenAmt : 3)
 
     c                   when      pToNbdp     = 1
     c                   return    %dech(wRtnAmount : lenAmt : 1)
 
     c                   other
     c                   return    0
     c                   endsl
 
     p                 e
