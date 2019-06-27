      *****************************************************************
      *  Start of /COPY LUC123_024                                    *
      *****************************************************************
      *                                                               *
      *  LUC123_024 - GLVIMAC   - Check for De-Activated flag         *
      *                                                               *
      *  Last Amend No. LUC123  *Create    Date 20Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC123 - Extend Customer De-Activation (CSD025) to GL and LE *
      *                                                               *
      *****************************************************************
      *                                                                         LUC123
     C     LUC123        Ifeq      'Y'                                          LUC123
     C     PACTN         andeq     'I'                                          LUC123
     C     WTYPE         andne     '*CUST**'                                    LUC123
      *                                                                         LUC123
     C                   CallB     'AOCUSTR1'                                   LUC123
     C                   Parm      *BLANKS       PRTCD                          LUC123
     C                   Parm      '*KEY   '     POPTN                          LUC123
     C                   Parm      W2CUST        PCUST                          LUC123
     C                   Parm      *BLANKS       PKYST                          LUC123
     C     SDCUST        Parm      SDCUST        DSLDY                          LUC123
      *                                                                         LUC123
     C     BBDEAC        Ifeq      'Y'                                          LUC123
     C                   Move      'N'           DDAcidOK                       LUC123
     C                   Add       1             Idx                            LUC123
     C                   Movel     'DDACID'      FldNamXAr(Idx)                 LUC123
     C                   EVAL      MsgIdXAr(Idx) = 'ABM0027'                    LUC123
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                   LUC123
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(BBCUST)       LUC123
     C                   Endif                                                  LUC123
      *                                                                         LUC123
     C                   Endif                                                  LUC123
      *                                                                         LUC123
      *****************************************************************
      *  End of /COPY LUC123_024                                      *
      *****************************************************************
