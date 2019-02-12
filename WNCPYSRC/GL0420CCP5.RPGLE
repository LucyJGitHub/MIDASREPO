      *****************************************************************
      *  Start of /COPY GL0420CCP5                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. LUC110  *Create    Date 23Jan19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)     *
      *                                                               *
      *****************************************************************
      *                                                                             LUC110
     C     LUC110        Ifeq      'Y'                                              LUC110
      *                                                                             LUC110
     C     G2AT          Ifeq      'AT'                                             LUC110
     C     G1CY          andeq     '   '                                            LUC110
     C                   Move      G2CY          G1CY                               LUC110
     C                   Move      G2AT          G1AT                               LUC110
     C                   Move      G2EX          G1EX                               LUC110
     C                   Endif                                                      LUC110
     C                   Movel     GNAR1         PNAR                               LUC110
      *                                                                             LUC110
     C                   Endif                                                      LUC110
      **                                                                            LUC110
      *****************************************************************
      *  End of /COPY GL0420CCP5                                      *
      *****************************************************************
