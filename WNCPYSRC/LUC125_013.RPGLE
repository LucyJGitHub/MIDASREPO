      *****************************************************************
      *                                                               *
      *  LUC125_013 - LE0450 - Restore BOKC and PRFC values (MATRTY)  *
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
     C  N88              Move      WPRFC         PRFC                           LUC125
     C  N88              Move      WBOKC         BOKC                           LUC125
     C                   Endif                                                  LUC125
      *                                                                         LUC125
      *****************************************************************
      * End of /COPY LUC125_013                                       *
      *****************************************************************
