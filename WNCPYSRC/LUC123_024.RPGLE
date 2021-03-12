      *****************************************************************
      *  Start of /COPY LUC123_024                                    *
      *****************************************************************
      *                                                               *
      *  LUC123_024 - GLVIMAC   - Check for De-Activated flag         *
      *                                                               *
      *  Last Amend No. LUC123  *CREATE    Date 20Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC123 - Extend Customer De-Activation (CSD025) to GL and LE *
      *                                                               *
      *****************************************************************
      *                                                                         
     C     LUC123        Ifeq      'Y'                                          
     C     PACTN         andeq     'I'                                          
     C     WTYPE         andne     '*CUST**'                                    
      *                                                                         
     C                   CallB     'AOCUSTR1'                                   
     C                   Parm      *BLANKS       PRTCD                          
     C                   Parm      '*KEY   '     POPTN                          
     C                   Parm      W2CUST        PCUST                          
     C                   Parm      *BLANKS       PKYST                          
     C     SDCUST        Parm      SDCUST        DSLDY                          
      *                                                                         
     C     BBDEAC        Ifeq      'Y'                                          
     C                   Move      'N'           DDAcidOK                       
     C                   Add       1             Idx                            
     C                   Movel     'DDACID'      FldNamXAr(Idx)                 
     C                   EVAL      MsgIdXAr(Idx) = 'ABM0027'                        
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                       
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(BBCUST)       
     C                   Endif                                                  
      *                                                                         
     C                   Endif                                                  
      *                                                                         
      *****************************************************************
      *  End of /COPY LUC123_024                                      *
      *****************************************************************
