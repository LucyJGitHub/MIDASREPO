      *****************************************************************
      *  Start of /COPY LUC123_015                                    *
      *****************************************************************
      *                                                               *
      *  LUC123_015 - LECLIP1VL - Check for De-Activated flag         *
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
     C     DDACTN        andeq     'I'                                          
     C     BBDEAC        andeq     'Y'                                          
      *                                                                         
     C                   Move      'N'           DDCustOK                       
     C                   Add       1             Idx                            
     C                   Movel     'DDCUST'      FldNamXar(Idx)                 
     C                   EVAL      MsgIdXAr(Idx) = 'ABM0027'                        
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                       
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(BBCUST)       
      *                                                                         
     C                   Endif                                                  
      *                                                                         
      *****************************************************************
      *  End of /COPY LUC123_015                                      *
      *****************************************************************
