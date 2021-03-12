      *****************************************************************
      *  Start of /COPY LUC123_001                                    *
      *****************************************************************
      *                                                               *
      *  LUC123_001 - GLVIMAC - Check for De-Activated Flag           *
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
     C     PACTN         andeq     'I'                                          
     C     BBDEAC        andeq     'Y'                                          
      *                                                                         
     C                   Move      'N'           DDAcidOK                       
     C                   Add       1             Idx                            
     C                   Movel     'DDACID'      FldNamXAr(Idx)                 
     C                   EVAL      MsgIdXAr(Idx) = 'ABM0027'                        
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                       
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(BBCUST)       
      *                                                                         
     C                   else                                                   
      *                                                                         
      *****************************************************************
      *  End of /COPY LUC123_001                                      *
      *****************************************************************
