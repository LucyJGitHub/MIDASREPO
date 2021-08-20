      *****************************************************************
      *                                                               *
      *  LUC125_019 - LE0450 - Set-up BOKC and PRFC (LOANSR)          *
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
     C                   Move      PRFC          WPRFC                          LUC125
     C                   Move      PRFCPR        PRFC                           LUC125
     C                   Move      BOKC          WBOKC                          LUC125
     C                   Move      W@BOKC        BOKC                           LUC125
     C                   Endif                                                  LUC125
      *                                                                         LUC125
      *****************************************************************
      * End of /COPY LUC125_019                                       *
      *****************************************************************
