      *****************************************************************
      *  Start of /COPY LUC123_015                                    *
      *****************************************************************
      *                                                               *
      *  LUC123_015 - LECLIP1VL - Check for De-Activated flag         *
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
     C                   Move      'N'           DDCustOK                       LUC123
     C                   Add       1             Idx                            LUC123
     C                   Movel     'DDCUST'      FldNamXar(Idx)                 LUC123
     C                   EVAL      MsgIdXAr(Idx) = 'ABM0027'                    LUC123
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                   LUC123
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(BBCUST)       LUC123
      *                                                                         LUC123
     C                   Endif                                                  LUC123
      *                                                                         LUC123
      *****************************************************************
      *  End of /COPY LUC123_015                                      *
      *****************************************************************
