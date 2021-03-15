      *****************************************************************
      *  Start of /COPY LUC123_009                                    *
      *****************************************************************
      *                                                               *
      *  LUC123_009 - LEFCIPRTV - Call AOCUSTR1                       *
      *                                                               *
      *  Last Amend No. LUC123  *CREATE    Date 18Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC123 - Extend Customer De-Activation (CSD025) to GL and LE *
      *                                                               *
      *****************************************************************
      *                                                                         
     C     LUC123        Ifeq      'Y'                                          
      *                                                                         
     C                   CallB     'AOCUSTR1'                                   
     C                   Parm      *BLANKS       @RTCD                          
     C                   Parm      '*KEY   '     @OPTN                          
     C                   Parm      DDCSSN        @KEY1                          
     C                   Parm                    @KYST                          
     C     SDCUST        Parm      SDCUST        DSLDY                          
      *                                                                         
     C                   else                                                   
      *                                                                         
      *****************************************************************
      *  End of /COPY LUC123_009                                      *
      *****************************************************************
