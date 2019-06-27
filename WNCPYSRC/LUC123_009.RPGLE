      *****************************************************************
      *  Start of /COPY LUC123_009                                    *
      *****************************************************************
      *                                                               *
      *  LUC123_009 - LEFCIPRTV - Call AOCUSTR1                       *
      *                                                               *
      *  Last Amend No. LUC123  *Create    Date 18Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC123 - Extend Customer De-Activation (CSD025) to GL and LE *
      *                                                               *
      *****************************************************************
      *                                                                         LUC123
     C     LUC123        Ifeq      'Y'                                          LUC123
      *                                                                         LUC123
     C                   CallB     'AOCUSTR1'                                   LUC123
     C                   Parm      *BLANKS       @RTCD                          LUC123
     C                   Parm      '*KEY   '     @OPTN                          LUC123
     C                   Parm      DDCSSN        @KEY1                          LUC123
     C                   Parm                    @KYST                          LUC123
     C     SDCUST        Parm      SDCUST        DSLDY                          LUC123
      *                                                                         LUC123
     C                   else                                                   LUC123
      *                                                                         LUC123
      *****************************************************************
      *  End of /COPY LUC123_009                                      *
      *****************************************************************
