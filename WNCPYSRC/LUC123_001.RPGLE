      *****************************************************************
      *  Start of /COPY LUC123_001                                    *
      *****************************************************************
      *                                                               *
      *  LUC123_001 - GLVIMAC - Check for De-Activated Flag           *
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
     C     PACTN         andeq     'I'                                          LUC123
     C     BBDEAC        andeq     'Y'                                          LUC123
      *                                                                         LUC123
     C                   Move      'N'           DDAcidOK                       LUC123
     C                   Add       1             Idx                            LUC123
     C                   Movel     'DDACID'      FldNamXAr(Idx)                 LUC123
     C                   EVAL      MsgIdXAr(Idx) = 'ABM0027'                    LUC123
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                   LUC123
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(BBCUST)       LUC123
      *                                                                         LUC123
     C                   else                                                   LUC123
      *                                                                         LUC123
      *****************************************************************
      *  End of /COPY LUC123_001                                      *
      *****************************************************************
