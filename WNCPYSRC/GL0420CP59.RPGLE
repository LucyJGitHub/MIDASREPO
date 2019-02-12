      *****************************************************************
      *  Start of /COPY GL0420CP59                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. LUC110  *Create    Date 23Jan19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)     *
      *                                                               *
      *****************************************************************
      *                                                                                       LUC110
     C     LUC110        Ifeq      'Y'                                                        LUC110
      *                                                                                       LUC110
      *  For Posting records (*IN06 *ON), output up to                                        LUC110
      *  three lines for the 35 character Extended Narratives                                 LUC110
      *  if they are present on the Extension file.                                           LUC110
      *                                                                                       LUC110
      *  For Rate Change records (*IN04 *ON), output only the                                 LUC110
      *  standard one line 30 character posting narrative (PNAR).                             LUC110
      *                                                                                       LUC110
     C                   Move      *IN86         SAV86             1                          LUC110
     C                   Setoff                                           86                  LUC110
      *                                                                                       LUC110
     C     ACNO          Ifne      0                                                          LUC110
     C     APXKEY        Chain     XXAPOSY1                           86                      LUC110
     C                   Endif                                                                LUC110
      *                                                                                       LUC110
B1   C     *In86         Ifeq      '0'                                                        LUC110
      *                                                                                       LUC110
      *  Narrative Line 1. ----------------------------------------------                     LUC110
      *                                                                                       LUC110
B2   C     *In06         Ifeq      '1'                                                        LUC110
B3   C     PNAR          Ifeq      *Blanks                                                    LUC110
     C                   Movel     GNAR1         PNAR                                         LUC110
E3   C                   Endif                                                                LUC110
B3   C     GNAR1         Ifeq      *Blanks                                                    LUC110
     C                   Movel     PNAR          GNAR1                                        LUC110
E3   C                   Endif                                                                LUC110
E2   C                   Endif                                                                LUC110
      *                                                                                       LUC110
B2   C     *IN04         Ifeq      '1'                                                        LUC110
     C                   Movel     PNAR          GNAR1                                        LUC110
     C                   Move      '     '       GNAR1                                        LUC110
E2   C                   Endif                                                                LUC110
      *                                                                                       LUC110
     C                   Setoff                                       0953                    LUC110
      *                                                                                       LUC110
      *  Narrative Line 2 (for Posting Details only.) -------------------                     LUC110
      *                                                                                       LUC110
B2   C     *IN06         Ifeq      '1'                                                        LUC110
     C     GNAR2         andne     *Blanks                                                    LUC110
     C                   Move      '1'           *In53                                        LUC110
E2   C                   Endif                                                                LUC110
      *                                                                                       LUC110
      *  Narrative Line 3 (for Posting Details only.) -------------------                     LUC110
      *                                                                                       LUC110
B2   C     *IN06         Ifeq      '1'                                                        LUC110
     C     GNAR3         andne     *Blanks                                                    LUC110
     C                   Move      '1'           *In09                                        LUC110
E2   C                   Endif                                                                LUC110
      *                                                                                       LUC110
X1   C                   Else                                                                 LUC110
      *                                                                                       LUC110
     C                   Setoff                                       0953                    LUC110
      *                                                                                       LUC110
      * SETOF 09 53 to not print 2nd and 3rd lines if no extended                             LUC110
      * narratives exist.                                                                     LUC110
     C                   Move      *Blanks       GNAR1                                        LUC110
     C                   Movel     PNAR          GNAR1                                        LUC110
     C                   Move      *Blanks       GNAR2                                        LUC110
     C                   Move      *Blanks       GNAR3                                        LUC110
E1   C                   Endif                                                                LUC110
      **                                                                                      LUC110
     C                   Move      Sav86         *In86                                        LUC110
     C                   Endif                                                                LUC110
      **                                                                                      LUC110
      *****************************************************************
      *  End of /COPY GL0420CP59                                      *
      *****************************************************************
