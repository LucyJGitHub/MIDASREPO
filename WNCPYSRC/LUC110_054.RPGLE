      *****************************************************************
      *  Start of /COPY LUC110_054                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. LUC110  *Create    Date 23Jan19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)     *
      *                                                               *
      *****************************************************************
      *                                                                                   LUC110
     C     LUC110        Ifeq      'Y'                                                    LUC110
     C                   Move      *Blanks       GNAR1                                    LUC110
     C                   Move      *Blanks       GNAR2                                    LUC110
     C                   Move      *Blanks       GNAR3                                    LUC110
     C                   Movel     PNAR          GNAR1                                    LUC110
      *                                                                                   LUC110
      *   Setup key to access LF/XXACP1Y1 for extended narratives.                        LUC110
     C                   Movel     BRCDJ         BRCDJ1                                   LUC110
     C                   Movel     CNUMJ         CNUMJ1                                   LUC110
     C                   Movel     CCYJ          CCYJ1                                    LUC110
     C                   Movel     ACODJ         ACODJ1                                   LUC110
     C                   Movel     ACSQJ         ACSQJ1                                   LUC110
     C                   Z-Add     PSTD          PSTDJ1                                   LUC110
     C                   Z-Add     VALD          VALDJ1                                   LUC110
     C                   Movel     UNQK          UNQKJ1                                   LUC110
      *                                                                                   LUC110
     C                   Move      *IN99         SAVE99            1                      LUC110
     C     ACJKY         Chain     XXACP1Y1                           99                  LUC110
     C     *IN99         Ifeq      '0'                                                    LUC110
     C     GNAR1         Ifeq      *Blanks                                                LUC110
     C                   Movel     PNAR          GNAR1                                    LUC110
     C                   Endif                                                            LUC110
     C                   Endif                                                            LUC110
     C                   Move      SAVE99        *IN99                                    LUC110
      **                                                                                  LUC110
     C                   Endif                                                            LUC110
      **                                                                                  LUC110
      *****************************************************************
      *  End of /COPY LUC110_054                                      *
      *****************************************************************
