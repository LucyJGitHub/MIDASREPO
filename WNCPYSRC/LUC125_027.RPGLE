      *****************************************************************
      *                                                               *
      *  LUC125_027 - LE0450 - Set-up  BOKC and PRFC values (LOANB)   *
      *                                                               *
      *  Last Amend No. LUC125   *Create   Date 14Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC125 - Make profit center pass through from transaction    *
      *           (Upgrade pf A66108)                                 *
      *                                                               *
      *****************************************************************
      *                                                                         LUC125
     C     LUC125        Ifeq      'Y'                                          LUC125
     C  N88              Move      PRFCPR        PRFC                           LUC125
     C  N88              Move      W@BOKC        BOKC                           LUC125
     C                   Endif                                                  LUC125
      *                                                                         LUC125
      *****************************************************************
      * End of /COPY LUC125_027                                       *
      *****************************************************************
