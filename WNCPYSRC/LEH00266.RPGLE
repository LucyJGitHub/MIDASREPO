      *****************************************************************
      *  Start of /COPY LEH00266                                      *
      *****************************************************************
      *                                                               *
      *  LEH00266 - LEFCIPRTV - Call AOSARDR0                         *
      *                                                               *
      *  Last Amend No. LUC123  *CREATE    Date 18Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC123 - Extend Customer De-Activation (CSD025) to GL and LE *
      *                                                               *
      *****************************************************************
      *
     C                   MOVE      'N'           LUC123            1            
     C                   CallB     'AOSARDR0'                                   
     C                   Parm      *BLANKS       @RTCD                          
     C                   Parm      '*VERIFY '    @OPTN                          
     C                   Parm      'LUC123'      @SARD                          
      *                                                                         
     C     @RTCD         Ifeq      *Blank                                       
     C                   Move      'Y'           LUC123                         
     C                   Endif                                                  
      *
      *****************************************************************
      *  End of /COPY LEH00266                                        *
      *****************************************************************
