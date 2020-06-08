      *****************************************************************                       HUT108
      *  Midas - Copy member for FTVIPYDT                             *                       HUT108
      *                                                               *                       HUT108
      *  HUT108_006 - Pay Value Date Validation and defaulting        *                       HUT108
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
     C                   CALL      'AOSARDR0'                                                 HUT108
     C                   PARM      *BLANKS       @RTCD             7                          HUT108
     C                   PARM      '*VERIFY'     @OPTN             7                          HUT108
     C                   PARM      'HUT108'      @SARD             6                          HUT108
     C                   PARM                    DSFDY                                        HUT108
                                                                                              HUT108
     C                   MOVE      'N'           HUT108            1                          HUT108
     C                   IF        @RTCD = *BLANKS                                            HUT108
     C                   EVAL      HUT108 = 'Y'                                               HUT108
     C                   ENDIF                                                                HUT108
                                                                                              HUT108
      *****************************************************************                       HUT108
      * End of /COPY HUT108_006                                       *                       HUT108
      *****************************************************************                       HUT108
