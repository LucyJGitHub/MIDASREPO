      *****************************************************************
      *                                                               *
      *  LUC125_024 - LE0450 - Set-up  BOKC and PRFC values (INTRST)  *
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
     C  N45                                                                     LUC125
     CORN88              Move      PRFCPR        PRFC                           LUC125
     C                   Move      BOKC          WBOKC                          LUC125
     C  N45                                                                     LUC125
     CORN88              Move      W@BOKC        BOKC                           LUC125
     C                   Endif                                                  LUC125
      *                                                                         LUC125
      *****************************************************************
      * End of /COPY LUC125_024                                       *
      *****************************************************************
