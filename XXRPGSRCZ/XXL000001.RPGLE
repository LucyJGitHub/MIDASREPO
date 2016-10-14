     H DEBUG
     H*COPYRIGHT('(c)*Misys*International*Banking*Systems*Ltd.*2008')**                       LUC109
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2016')                         LUC109
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Update of File XXINCPPD')                              *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Data Extract Module                                  *
      *                                                               *
      ***DEL000001*-*Update*of*File*GLINCPPP***************************                       LUC109
      *  XXL000001 - Update of File XXINCPPD                          *                       LUC109
      *                                                               *
      *  Function:  This program will update the contents of field    *
      *             IMDFN with the name corresponding to the file     *
      *             name specified in field ITGFN.                    *
      *                                                               *
      ***Called*By:*DELC000001*****************************************                       LUC109
      *  Called By: XXLC000001                                        *                       LUC109
      *                                                               *
      ***(c) Misys*International*Banking*Systems*Ltd.*2008*************                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 09Sep16               *
      *  Prev Amend No. LUC013  *CREATE    Date 01May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  LUC013 - Head Office Reporting Upgrade to MidasPlus          *
      *                                                               *
      *****************************************************************
 
     F***GLINCPPP  UF   E             DISK                                                    LUC109
     FXXINCPPD  UF   E             DISK                                                       LUC109
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      * Read first record from MidasPlus File
     C**********         READ(E)   GLINCPP0                                                   LUC109
     C                   READ      XXINCPD0                                                   LUC109
 
     C                   DOW       NOT %EOF
      * Convert Data fields
 
     C                   Select
 
     C                   When      ITGFN = 'ACCNTAB'
     C**********         Eval      IMDFN = 'DEACCNTBPP'                                       LUC109
     C                   Eval      IMDFN = 'XXACCNTBPP'                                       LUC109
 
     C                   When      ITGFN = 'ACKEYAL'
     C**********         Eval      IMDFN = 'DEACKEYLPP'                                       LUC109
     C                   Eval      IMDFN = 'XXACKEYLPP'                                       LUC109
 
     C                   When      ITGFN = 'CLOANCK'
     C**********         Eval      IMDFN = 'DECLOANKPP'                                       LUC109
     C                   Eval      IMDFN = 'XXCLOANKPP'                                       LUC109
 
     C                   When      ITGFN = 'CLOANCL'
     C**********         Eval      IMDFN = 'DECLOANLPP'                                       LUC109
     C                   Eval      IMDFN = 'XXCLOANLPP'                                       LUC109
 
     C                   When      ITGFN = 'DEALSDB'
     C**********         Eval      IMDFN = 'DEDEALSBPP'                                       LUC109
     C                   Eval      IMDFN = 'XXDEALSBPP'                                       LUC109
 
     C                   When      ITGFN = 'DEALSDC'
     C**********         Eval      IMDFN = 'DEDEALSCPP'                                       LUC109
     C                   Eval      IMDFN = 'XXDEALSCPP'                                       LUC109
 
     C                   When      ITGFN = 'DEALSDD'
     C**********         Eval      IMDFN = 'DEDEALSDPP'                                       LUC109
     C                   Eval      IMDFN = 'XXDEALSDPP'                                       LUC109
 
     C                   When      ITGFN = 'DEALSDE'
     C**********         Eval      IMDFN = 'DEDEALSEPP'                                       LUC109
     C                   Eval      IMDFN = 'XXDEALSEPP'                                       LUC109
 
     C                   When      ITGFN = 'DEALSDG'
     C**********         Eval      IMDFN = 'DEDEALSGPP'                                       LUC109
     C                   Eval      IMDFN = 'XXDEALSGPP'                                       LUC109
 
     C                   When      ITGFN = 'DLACKRPD'
     C**********         Eval      IMDFN = 'DEDLACKRPP'                                       LUC109
     C                   Eval      IMDFN = 'XXDLACKRPP'                                       LUC109
 
     C                   When      ITGFN = 'DLBHISPD'
     C**********         Eval      IMDFN = 'DEDLBHISPP'                                       LUC109
     C                   Eval      IMDFN = 'XXDLBHISPP'                                       LUC109
 
     C                   When      ITGFN = 'DLCHISPD'
     C**********         Eval      IMDFN = 'DEDLCHISPP'                                       LUC109
     C                   Eval      IMDFN = 'XXDLCHISPP'                                       LUC109
 
     C                   When      ITGFN = 'DLDHISPD'
     C**********         Eval      IMDFN = 'DEDLDHISPP'                                       LUC109
     C                   Eval      IMDFN = 'XXDLDHISPP'                                       LUC109
 
     C                   When      ITGFN = 'EODPOPD'
     C**********         Eval      IMDFN = 'DEEODPOPP'                                        LUC109
     C                   Eval      IMDFN = 'XXEODPOPP'                                        LUC109
 
     C                   When      ITGFN = 'EVNTXED'
     C**********         Eval      IMDFN = 'DEEVNTXDPP'                                       LUC109
     C                   Eval      IMDFN = 'XXEVNTXDPP'                                       LUC109
 
     C                   When      ITGFN = 'FCLTYFM'
     C**********         Eval      IMDFN = 'DEFCLTYMPP'                                       LUC109
     C                   Eval      IMDFN = 'XXFCLTYMPP'                                       LUC109
 
     C                   When      ITGFN = 'FCLTYFN'
     C**********         Eval      IMDFN = 'DEFCLTYNPP'                                       LUC109
     C                   Eval      IMDFN = 'XXFCLTYNPP'                                       LUC109
 
     C                   When      ITGFN = 'HELDIHB'
     C**********         Eval      IMDFN = 'DEHELDIBPP'                                       LUC109
     C                   Eval      IMDFN = 'XXHELDIBPP'                                       LUC109
 
     C                   When      ITGFN = 'INPAYDD'
     C**********         Eval      IMDFN = 'DEINPAYPP'                                        LUC109
     C                   Eval      IMDFN = 'XXINPAYPP'                                        LUC109
 
     C                   When      ITGFN = 'LEFEED'
     C**********         Eval      IMDFN = 'DELEFEEDPP'                                       LUC109
     C                   Eval      IMDFN = 'XXLEFEEDPP'                                       LUC109
 
     C                   When      ITGFN = 'LOAMSDK'
     C**********         Eval      IMDFN = 'DELOAMSKPP'                                       LUC109
     C                   Eval      IMDFN = 'XXLOAMSKPP'                                       LUC109
 
     C                   When      ITGFN = 'LVENTEL'
     C**********         Eval      IMDFN = 'DELVENTLPP'                                       LUC109
     C                   Eval      IMDFN = 'XXLVENTLPP'                                       LUC109
 
     C                   When      ITGFN = 'MCLONCK'
     C**********         Eval      IMDFN = 'DEMCLONKPP'                                       LUC109
     C                   Eval      IMDFN = 'XXMCLONKPP'                                       LUC109
 
     C                   When      ITGFN = 'MCLONCL'
     C**********         Eval      IMDFN = 'DEMCLONLPP'                                       LUC109
     C                   Eval      IMDFN = 'XXMCLONLPP'                                       LUC109
 
     C                   When      ITGFN = 'OTPAYDD'
     C**********         Eval      IMDFN = 'DEOTPAYPP'                                        LUC109
     C                   Eval      IMDFN = 'XXOTPAYPP'                                        LUC109
 
     C                   When      ITGFN = 'REIACD'
     C**********         Eval      IMDFN = 'DEREIACDPP'                                       LUC109
     C                   Eval      IMDFN = 'XXREIACDPP'                                       LUC109
 
     C                   When      ITGFN = 'SDACODPD'
     C**********         Eval      IMDFN = 'DESDACODPP'                                       LUC109
     C                   Eval      IMDFN = 'XXSDACODPP'                                       LUC109
 
     C                   When      ITGFN = 'SDACRCPD'
     C**********         Eval      IMDFN = 'DESDACRCPP'                                       LUC109
     C                   Eval      IMDFN = 'XXSDACRCPP'                                       LUC109
 
     C                   When      ITGFN = 'SDBRCHPD'
     C**********         Eval      IMDFN = 'DESDBRCHPP'                                       LUC109
     C                   Eval      IMDFN = 'XXSDBRCHPP'                                       LUC109
 
     C                   When      ITGFN = 'SDCURRPD'
     C**********         Eval      IMDFN = 'DESDCURRPP'                                       LUC109
     C                   Eval      IMDFN = 'XXSDCURRPP'                                       LUC109
 
     C                   When      ITGFN = 'SDCUSTPD'
     C**********         Eval      IMDFN = 'DESDCUSTPP'                                       LUC109
     C                   Eval      IMDFN = 'XXSDCUSTPP'                                       LUC109
 
     C                   When      ITGFN = 'SDDEALPD'
     C**********         Eval      IMDFN = 'DESDDEALPP'                                       LUC109
     C                   Eval      IMDFN = 'XXSDDEALPP'                                       LUC109
 
     C                   When      ITGFN = 'SDGELRPD'
     C**********         Eval      IMDFN = 'DESDGELRPP'                                       LUC109
     C                   Eval      IMDFN = 'XXSDGELRPP'                                       LUC109
 
     C                   When      ITGFN = 'SDNOSTPD'
     C**********         Eval      IMDFN = 'DESDNOSTPP'                                       LUC109
     C                   Eval      IMDFN = 'XXSDNOSTPP'                                       LUC109
 
     C                   When      ITGFN = 'SDPCACPD'
     C**********         Eval      IMDFN = 'DESDPCACPP'                                       LUC109
     C                   Eval      IMDFN = 'XXSDPCACPP'                                       LUC109
 
     C                   When      ITGFN = 'SDTIINPD'
     C**********         Eval      IMDFN = 'DESDTIINPP'                                       LUC109
     C                   Eval      IMDFN = 'XXSDTIINPP'                                       LUC109
 
     C                   Endsl
 
      * Update File
     C**********         UPDATE    GLINCPP0                                                   LUC109
     C                   UPDATE    XXINCPD0                                                   LUC109
 
      * Read next record from File
     C**********         READ(E)   GLINCPP0                                                   LUC109
     C                   READ      XXINCPD0                                                   LUC109
 
     C                   Enddo
 
     C                   Eval      *INLR = *ON
     C                   Return
 
