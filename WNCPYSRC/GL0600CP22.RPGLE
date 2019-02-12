      *****************************************************************
      *  Start of /COPY GL0600CP22                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. LUC110  *Create    Date 24Jan19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)     *
      *                                                               *
      *****************************************************************
      *                                                                             LUC110
     C     LUC110        Ifeq      'Y'                                              LUC110
      *                                                                             LUC110
     C                   Move      BRCDP         GBRCA                              LUC110
     C                   Move      CNUM          GCNUM                              LUC110
     C                   Move      CCY           GCCY                               LUC110
     C                   Move      ACOD          GACOD                              LUC110
     C                   Move      ACSQ          GACSQ                              LUC110
     C                   Move      PSTD          GPSTD                              LUC110
     C                   Move      VALD          GVALD                              LUC110
     C                   Move      ZZ009         GUNQK                              LUC110
      *                                                                             LUC110
     C                   Move      *BLANK        GNAR1                              LUC110
     C                   Move      *BLANK        GNAR2                              LUC110
     C                   Move      *BLANK        GNAR3                              LUC110
      *                                                                             LUC110
     C     *IN88         Ifeq      '1'                                              LUC110
     C     GEKEY         Chain     SACPOX                             15            LUC110
     C   88                                                                         LUC110
     CAN U5              Except    EXCPT4X                                          LUC110
     C                   Endif                                                      LUC110
      *                                                                             LUC110
     C                   Endif                                                      LUC110
      *                                                                             LUC110
      *****************************************************************
      *  End of /COPY GL0600CP22                                      *
      *****************************************************************
