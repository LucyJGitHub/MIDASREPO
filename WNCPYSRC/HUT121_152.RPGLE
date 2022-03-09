      *****************************************************************
      *                                                               *
      *  HUT121_152 - Midas /COPY for SE4654                          *
      *                                                               *
      *  Last Amend No. HUT121  *CREATE    Date 09Mar22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121 -  Allow SE Price Input for Non-working day           *
      *                                                               *
      *****************************************************************
      ** Access Switchable feature HUT121                                                     HUT121
                                                                                              HUT121
     C                   MOVEL     'N'           HUT121            1                          HUT121
     C                   CALLB     'AOSARDR0'                                                 HUT121
     C                   PARM      *BLANKS       @RTCD                                        HUT121
     C                   PARM      '*VERIFY'     @OPTN                                        HUT121
     C                   PARM      'HUT121'      @SARD             6                          HUT121
                                                                                              HUT121
     C     @RTCD         IFEQ      *BLANK                                                     HUT121
     C                   MOVEL     'Y'           HUT121                                       HUT121
     C                   ENDIF                                                                HUT121
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_152                                       *
      *****************************************************************
