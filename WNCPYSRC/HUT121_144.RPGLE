      *****************************************************************
      *                                                               *
      *  HUT121_144 - Midas /COPY for SE4652                          *
      *                                                               *
      *  Last Amend No. HUT121  *CREATE    Date 09Mar22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121 -  Allow SE Price Input for Non-working day           *
      *                                                               *
      *****************************************************************
                                                                                              HUT121
      ** Access Switchable features                                                           HUT121
                                                                                              HUT121
     C                   EVAL      HUT121 = 'N'                                               HUT121
     C                   CALL      'AOSARDR0'                                                 HUT121
     C                   PARM      *BLANKS       @RTCD                                        HUT121
     C                   PARM      '*VERIFY'     @OPTN                                        HUT121
     C                   PARM      'HUT121'      @SARD             6                          HUT121
     C                   IF        @RTCD = *Blanks                                            HUT121
     C                   EVAL      HUT121 = 'Y'                                               HUT121
     C                   ENDIF                                                                HUT121
                                                                                              HUT121
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_144                                       *
      *****************************************************************
