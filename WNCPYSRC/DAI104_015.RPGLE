      *****************************************************************
      *  Start of /COPY DAI104_015                                    *
      *****************************************************************
      *                                                               *
      *  DAI104_015 - LECLIP1VL - Check for De-Activated flag         *
      *                                                               *
      *  Last Amend No. DAI104  *Create    Date 18Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI104 - Extend Customer De-Activation (CSD025) to GL and LE *
      *                                                               *
      *****************************************************************
      *                                                                         DAI104
     C     DAI104        Ifeq      'Y'                                          DAI104
     C     DDACTN        andeq     'I'                                          DAI104
     C     BBDEAC        andeq     'Y'                                          DAI104
      *                                                                         DAI104
     C                   Move      'N'           DDCustOK                       DAI104
     C                   Add       1             Idx                            DAI104
     C                   Movel     'DDCUST'      FldNamXar(Idx)                 DAI104
     C                   EVAL      MsgIdXAr(Idx) = 'ABM0027'                    DAI104
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                   DAI104
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(BBCUST)       DAI104
      *                                                                         DAI104
     C                   Endif                                                  DAI104
      *                                                                         DAI104
      *****************************************************************
      *  End of /COPY DAI104_015                                      *
      *****************************************************************
