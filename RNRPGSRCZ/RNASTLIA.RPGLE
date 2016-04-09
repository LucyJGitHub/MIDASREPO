     h nomain
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Return asset/liability flag')
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNASTLIA   - Return Asset/Liability flag                     *
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
 
     d cTrtyAset       c                   'IP   FL   TI   LN   CL   DP   +
     d                                      LP   DL   C1   C2   BD   BP   +
     d                                      TB   TA   DA   CS   BR   BS   +
     d                                      TS   RA   TR   IL             +
     d                                     '
 
     d cTrtyLiab       c                   'IT   TD   FT   CI   CD   DT   +
     d                                      LT   ID                       +
     d                                     '
 
     d aTrty           s              5    dim(200)
     d ixTrty          s              5u 0
 
     d cLia1st         c                   101
 
      /copy rncpysrc,rnastlia
 
      *=====================================================================
 
     p rnAstLia        b                   export
 
     d                 pi                  like(rnAstLia)
     d extrty                         5    const
 
      *---------------------------------------------------------------------
 
     c                   eval      ixTrty      = %lookup(extrty : aTrty)
 
     c                   select
     c                   when      extrty      = *blanks
     c                   return    0
 
     c                   when      ixTrty     >= cLia1st
     c                   return    2
 
     c                   when      ixTrty      > 0
     c                   return    1
 
     c                   other
     c                   return    0
     c                   endsl
 
     p                 e
 
      *=====================================================================
 
     p rnAstLiaIn      b                   export
 
     c                   movea     cTrtyAset     aTrty
     c                   movea     cTrtyLiab     aTrty(cLia1st)
 
     p                 e
