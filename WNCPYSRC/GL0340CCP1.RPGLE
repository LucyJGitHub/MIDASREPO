      *****************************************************************
      *  Start of /COPY GL0340CCP1                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. LUC110  *CREATE    Date 23Jan19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)     *
      *                                                               *
      *****************************************************************
      *                                                                                         
     C                   Call      'AOSARDR0'                                                   
     C                   Parm      *BLANKS       @RTCD                                          
     C                   Parm      '*VERIFY'     @OPTN                                          
     C                   Parm      'LUC110'      @KEY              6                            
     C                   Parm                    DSFDY                                          
      *                                                                                         
     C     @RTCD         Ifeq      *BLANKS                                                      
     C                   Move      'Y'           LUC110            1                            
     C                   Move      *On           *In24                                          
     C                   else                                                                   
     C                   Move      'N'           LUC110                                         
     C                   Move      *Off          *In24                                          
     C                   Endif                                                                  
      **                                                                                        
      *****************************************************************
      *  End of /COPY GL0340CCP1                                      *
      *****************************************************************
