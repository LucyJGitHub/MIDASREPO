      *****************************************************************
      *  Start of /COPY LUC123_007                                    *
      *****************************************************************
      *                                                               *
      *  LUC123_007 - LEFCIPRTV - Check for De-Activated flag         *
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
     C     DDACTN        andeq     'I'                                          LUC123
     C     BBDEAC        andeq     'Y'                                          LUC123
      *                                                                         LUC123
     C                   Move      'N'           DDCssnOK                       LUC123
     C                   Add       1             Ix                             LUC123
     C                   Movel     'DDCSSN'      FldNameArr(Ix)                 LUC123
     C                   EVAL      MsgIdArr(Ix) = 'ABM0027'                     LUC123
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                   LUC123
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(BBCUST)        LUC123
      *                                                                         LUC123
     C                   else                                                   LUC123
      *                                                                         LUC123
      *****************************************************************
      *  End of /COPY LUC123_007                                      *
      *****************************************************************
