      *****************************************************************
      *  Start of /COPY GL0420CCP7                                    *
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
     C     APXKEY        KList                                                      LUC110
     C                   Kfld                    BRCA                               LUC110
     C                   Kfld                    CNUM                               LUC110
     C                   Kfld                    CCY                                LUC110
     C                   Kfld                    ACOD                               LUC110
     C                   Kfld                    ACSQ                               LUC110
     C                   Kfld                    PSTD                               LUC110
     C                   Kfld                    VALD                               LUC110
     C                   Kfld                    UNQK                               LUC110
      *                                                                             LUC110
     C                   Move      *IN86         SAV86             1                LUC110
     C                   Move      *BLANK        GNAR1                              LUC110
     C                   Move      *BLANK        GNAR2                              LUC110
     C                   Move      *BLANK        GNAR3                              LUC110
      *                                                                             LUC110
     C     ACNO          Ifne      0                                                LUC110
     C     APXKEY        Chain     XXAPOSY1                           86            LUC110
     C                   Endif                                                      LUC110
      *                                                                             LUC110
     C                   Move      Sav86         *IN86                              LUC110
      *                                                                             LUC110
     C                   Endif                                                      LUC110
      **                                                                            LUC110
      *****************************************************************
      *  End of /COPY GL0420CCP7                                      *
      *****************************************************************
