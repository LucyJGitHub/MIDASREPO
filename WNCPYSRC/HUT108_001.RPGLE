      *****************************************************************                       HUT108
      *  Midas - Copy member for FTVIPYDT                             *                       HUT108
      *                                                               *                       HUT108
      *  HUT108_002 - Pay Value Date Validation and defaulting        *                       HUT108
      *                                                               *                       HUT108
      *  Last Amend No. HUT108 *CREATE     Date 26Mar20               *                       HUT108
      * FBMidas 2.1 ---- Base ----------------------------------------*                       HUT108
      *                                                               *                       HUT108
      *---------------------------------------------------------------*                       HUT108
      *                                                               *                       HUT108
      *  HUT108 - Upgrade HUT017 to FBM 2.1 SP22                      *                       HUT108
      *           Pay Value Date Validation and Defaulting Changes    *                       HUT108
      *                                                               *                       HUT108
      *****************************************************************                       HUT108
                                                                                              HUT108
      ** If HUT108 is on, set default Pay Value Date equal to                                 HUT108
      ** Settlement Value Date                                                                HUT108
                                                                                              HUT108
     C                   IF        HUT108 = 'Y'                                               HUT108
                                                                                              HUT108
     C                   IF        DDSLDT = *BLANKS                                           HUT108
     C                   EVAL      WPYDT = BJRDNB                                             HUT108
     C                   CLEAR                   ZDATE                                        HUT108
     C                   CALLB     'ZDATE2'                                                   HUT108
     C                   PARM                    WPYDT                                        HUT108
     C                   PARM      BJDFIN        PFMT              1                          HUT108
     C                   PARM                    ZDATE             6 0                        HUT108
     C                   PARM      *BLANKS       ZADATE            7                          HUT108
                                                                                              HUT108
     C                   MOVE      ZDATE         DDPYDT                                       HUT108
     C                   ELSE                                                                 HUT108
     C                   EVAL      DDPYDT = DDSLDT                                            HUT108
     C                   EVAL      WPYDT = IPSLDT                                             HUT108
     C                   ENDIF                                                                HUT108
                                                                                              HUT108
     C                   ELSE                                                                 HUT108
                                                                                              HUT108
      *****************************************************************                       HUT108
      * End of /COPY HUT108_002                                       *                       HUT108
      *****************************************************************                       HUT108
