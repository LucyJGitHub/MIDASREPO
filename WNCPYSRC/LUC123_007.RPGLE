      *****************************************************************
      *  Start of /COPY LUC123_007                                    *
      *****************************************************************
      *                                                               *
      *  LUC123_007 - LEFCIPRTV - Check for De-Activated flag         *
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
     C                   Move      'N'           DDCssnOK                       
     C                   Add       1             Ix                             
     C                   Movel     'DDCSSN'      FldNameArr(Ix)                 
     C                   EVAL      MsgIdArr(Ix) = 'ABM0027'                         
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                       
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(BBCUST)        
      *                                                                         
     C                   else                                                   
      *                                                                         
      *****************************************************************
      *  End of /COPY LUC123_007                                      *
      *****************************************************************
