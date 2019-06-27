      *****************************************************************
      *  Start of /COPY LUC123_013                                    *
      *****************************************************************
      *                                                               *
      *  LUC123_013 - LECLIP1VL - Call AOCUSTR1                       *
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
     C                   Parm      DDCUST        @CUST                          LUC123
     C                   Parm                    @KEYSTS                        LUC123
     C     SDCUST        Parm      SDCUST        DSLDY                          LUC123
      *                                                                         LUC123
     C                   else                                                   LUC123
      *                                                                         LUC123
      *****************************************************************
      *  End of /COPY LUC123_013                                      *
      *****************************************************************
