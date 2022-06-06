      *****************************************************************
      *                                                               *
      *  HUT121_125 - Midas /COPY for SEVVLDT01                       *
      *                                                               *
      *  Last Amend No. HUT121  *CREATE    Date 09Mar22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121 -  Allow SE Price Input for Non-working day           *
      *                                                               *
      *****************************************************************
     C     ZDAYNO        Ifle      PRUN                                                       HUT121
     C     HUT121        Andeq     'Y'                                                        HUT121
     C                   ADD       1             Idx                                          HUT121
     C                   EVAL      FldNamXAr (Idx) = 'DDPVDT'                                 HUT121
     C                   EVAL      MsgIDXAr(Idx) = 'XXX9001'                                  HUT121
     C                   EVAL      DDVDTOK   = 'N'                                            HUT121
     C                   Else                                                                 HUT121
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_125                                       *
      *****************************************************************
