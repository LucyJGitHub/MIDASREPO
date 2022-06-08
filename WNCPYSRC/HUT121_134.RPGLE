      *****************************************************************
      *                                                               *
      *  HUT121_134 - Midas /COPY for SEPRCSRTV                       *
      *                                                               *
      *  Last Amend No. HUT121  *CREATE    Date 09Mar22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121 -  Allow SE Price Input for Non-working day           *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT121
      ** Convert Value date to Midas day                                                      HUT121
     C                   MOVEL     DDPVDT        NUM7              7 0                        HUT121
     C                   MOVEL     NUM7          ALF6              6                          HUT121
      *                                                                                       HUT121
     C                   CALLB     'ZDATE1'                                                   HUT121
     C                   PARM      ALF6          ZDATEA            6                          HUT121
     C                   PARM                    ZDAYNO            5 0                        HUT121
     C                   PARM      BJDFIN        DateFmt           1                          HUT121
     C                   PARM                    ErrorFlag         1                          HUT121
      *                                                                                       HUT121
     C                   MOVE      ZDAYNO        @@PVDT            5 0                        HUT121
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_134                                       *
      *****************************************************************
