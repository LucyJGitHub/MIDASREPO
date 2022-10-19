      *****************************************************************
      *                                                               *
      *  HUT121_013 - Midas /COPY for GPPRICED                        *
      *                                                               *
      *  Last Amend No. HUT121C            Date 29Apr22               *
      *  Prev Amend No. HUT121  *CREATE    Date 07Feb22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121C - Changes to allow SE Price Input for non-working day*
      *  HUT121 -  Allow SE Price Input for Non-working day           *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT121
O    C     HUT121        IFEQ      'N'                                                        HUT121
     C     HUT121        OREQ      'Y'                                                       HUT121C
     C     CPRICE        ANDEQ     'Y'                                                       HUT121C
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_013                                       *
      *****************************************************************
