      *****************************************************************
      *                                                               *
      *  LUC127_008 - ZAVPROFITC - Clear account officer              *
      *                                                               *
      *  Last Amend No. LUC127   *Create   Date 14Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC127 - Output PRFC in all cases                            *
      *                                                               *
      *****************************************************************
      *                                                                                       LUC127
     C     LUC127        IfEq      'Y'                                                        LUC127
      *                                                                                       LUC127
      ** Don't use account officer for all treasury deals                                     LUC127
     C                   MOVE      *BLANKS       ACOF                                         LUC127
      *                                                                                       LUC127
     C                   EndIF                                                                LUC127
      *                                                                                       LUC127
      *****************************************************************                       LUC127
      * End of /COPY LUC127_008                                       *                       LUC127
      *****************************************************************                       LUC127
