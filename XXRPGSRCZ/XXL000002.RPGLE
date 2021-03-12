     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Update of File XXINCPPD FBM')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Data Extract Module                                  *
      *                                                               *
      *  XXL000002 - Update of File XXINCPPD FBM                      *
      *                                                               *
      *  Function:  This program will update the contents of field    *
      *             IMDFN with the name corresponding to the file     *
      *             name specified in field ITGFN.                    *
      *                                                               *
      *  Called By: XXLC000002                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC109  *Create    Date 12Sep16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *                                                               *
      *****************************************************************
 
     FXXINCPPD  UF   E             DISK
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      * Read first record from MidasPlus File
     C                   READ      XXINCPD0
 
     C                   DOW       NOT %EOF
      * Convert Data fields
 
     C                   Select
 
     C                   When      ITGFN = 'ACCNTAA'
     C                   Eval      IMDFN = 'XXACCNTAA'
 
     C                   When      ITGFN = 'ACCNTAC'
     C                   Eval      IMDFN = 'XXACCNTAC'
 
     C                   When      ITGFN = 'DEALSDA'
     C                   Eval      IMDFN = 'XXDEALSDA'
 
     C                   When      ITGFN = 'DEALSDF'
     C                   Eval      IMDFN = 'XXDEALSDF'
 
     C                   When      ITGFN = 'FCLTYHH'
     C                   Eval      IMDFN = 'XXFCLTYHH'
 
     C                   When      ITGFN = 'FCLTYX0'
     C                   Eval      IMDFN = 'XXFCLTYX0'
 
     C                   When      ITGFN = 'FCLTYZZ'
     C                   Eval      IMDFN = 'XXFCLTYZZ'
 
     C                   When      ITGFN = 'GTEESGT'
     C                   Eval      IMDFN = 'XXGTEESGT'
 
     C                   When      ITGFN = 'REIACA'
     C                   Eval      IMDFN = 'XXREIACA'
 
     C                   When      ITGFN = 'REIACZ'
     C                   Eval      IMDFN = 'XXREIACZ'
 
     C                   When      ITGFN = 'SECTYD'
     C                   Eval      IMDFN = 'XXSECTYD'
 
     C                   When      ITGFN = 'MCLONHH'
     C                   Eval      IMDFN = 'XXMCLONHH'
 
     C                   When      ITGFN = 'MCLONZ1'
     C                   Eval      IMDFN = 'XXMCLONZ1'
 
     C                   When      ITGFN = 'HISTSHP'
     C                   Eval      IMDFN = 'XXHISTSHP'
 
     C                   When      ITGFN = 'HISTSHM'
     C                   Eval      IMDFN = 'XXHISTSHM'
 
     C                   When      ITGFN = 'HISTSHQ'
     C                   Eval      IMDFN = 'XXHISTSHQ'
 
     C                   When      ITGFN = 'MHISTHP'
     C                   Eval      IMDFN = 'XXMHISTHP'
 
     C                   When      ITGFN = 'MHISTHM'
     C                   Eval      IMDFN = 'XXMHISTHM'
 
     C                   When      ITGFN = 'MHISTHQ'
     C                   Eval      IMDFN = 'XXMHISTHQ'
 
     C                   When      ITGFN = 'T_GZFXDLEX'
     C                   Eval      IMDFN = 'DEALSBX0'
     C                   Eval      ITGFN = 'DEALSBX0'
 
     C                   When      ITGFN = 'T_GZNASPEX'
     C                   Eval      IMDFN = 'DEALSEX0'
     C                   Eval      ITGFN = 'DEALSEX0'
 
     C                   When      ITGFN = 'T_GZSIRSEX'
     C                   Eval      IMDFN = 'DEALSGX0'
     C                   Eval      ITGFN = 'DEALSGX0'
 
     C                   Endsl
 
      * Update File
     C                   UPDATE    XXINCPD0
 
      * Read next record from File
     C                   READ      XXINCPD0
 
     C                   Enddo
 
     C                   Eval      *INLR = *ON
     C                   Return
 
