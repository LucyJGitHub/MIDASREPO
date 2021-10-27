      *****************************************************************
      *  Start of /COPY DAI104_007                                    *
      *****************************************************************
      *                                                               *
      *  DAI104_007 - LEFCIPRTV - Check for De-Activated flag         *
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
     C                   Move      'N'           DDCssnOK                       DAI104
     C                   Add       1             Ix                             DAI104
     C                   Movel     'DDCSSN'      FldNameArr(Ix)                 DAI104
     C                   EVAL      MsgIdArr(Ix) = 'ABM0027'                     DAI104
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                   DAI104
     C                   EVAL      MsgDtaArr(Ix) = LenStr +%TRIM(BBCUST)        DAI104
      *                                                                         DAI104
     C                   else                                                   DAI104
      *                                                                         DAI104
      *****************************************************************
      *  End of /COPY DAI104_007                                      *
      *****************************************************************
