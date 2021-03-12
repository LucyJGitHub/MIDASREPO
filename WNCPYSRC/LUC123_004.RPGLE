      *****************************************************************
      *  Start of /COPY LUC123_004                                    *
      *****************************************************************
      *                                                               *
      *  LUC123_004 - GLVIMAC - Call AOCUSTR1                         *
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
     C                   Parm      *BLANKS       PRTCD                          
     C                   Parm      '*KEY   '     POPTN                          
     C                   Parm      DDACID        PCUST                          
     C                   Parm      *BLANKS       PKYST                          
     C     SDCUST        Parm      SDCUST        DSLDY                          
      *                                                                         
     C                   else                                                   
      *                                                                         
      *****************************************************************
      *  End of /COPY LUC123_004                                      *
      *****************************************************************
