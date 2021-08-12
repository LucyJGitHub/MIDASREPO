      *****************************************************************
      *                                                               *
      *  LUC125_008 - LE0450 - Set-up  BOKC and PRFC values (REPSCD)  *
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
     C     LUC125        IFEQ      'Y'                                          LUC125
     C                   MOVE      PRFCPR        PRFC                           LUC125
     C                   MOVE      W@BOKC        BOKC                           LUC125
     C                   ENDIF                                                  LUC125
      *                                                                         LUC125
      *****************************************************************
      * End of /COPY LUC125_008                                       *
      *****************************************************************
