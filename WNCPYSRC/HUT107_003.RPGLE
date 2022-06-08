      *****************************************************************
      *  Start of /COPY HUT107_003                                    *
      *****************************************************************
      *                                                               *
      *  SDCUSD2DP  - Customer Details                                *
      *                                                               *
      *  Last Amend No. HUT107    *Create  Date 27May20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT107 - Additional 3rd Party Trust Indicator                *
      *           (Upgrade HUT016 to FM2.1 SP22)                      *
      *                                                               *
      *****************************************************************
      *                                                                                    HUT107
      ** Check if 3rd Party Trust Customer                                                 HUT107
      *                                                                                    HUT107
     C                   MOVE      *BLANK        DD3PYN                                    HUT107
     C                   If        HUT107 = 'Y'                                            HUT107
     C     DDCUSN        Setll     UTRACCTDM                                               HUT107
     C                   If        %EQUAL()                                                HUT107
     C                   Eval      DD3PYN = 'Y'                                            HUT107
     C                   Else                                                              HUT107
     C                   Eval      DD3PYN = 'N'                                            HUT107
     C                   Endif                                                             HUT107
     C                   Endif                                                             HUT107
                                                                                           HUT107
      *****************************************************************
      * End of /COPY HUT107_003                                       *
      *****************************************************************
