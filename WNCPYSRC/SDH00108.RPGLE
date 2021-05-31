      *****************************************************************
      *  Start of /COPY SDH00108                                      *
      *****************************************************************
      *                                                               *
      *  SDCUSD2DP  - Customer Details                                *
      *                                                               *
      *  Last Amend No. HUT113             Date 27May20               *
      *  Prev Amend No. HUT107    *Create  Date 27May20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT113 - Full Private Banking Functionality at FM            *
      *           (Upgrade HUT026 to FM2.1 SP22)                      *
      *  HUT107 - Additional 3rd Party Trust Indicator                *
      *           (Upgrade HUT016 to FM2.1 SP22)                      *
      *                                                               *
      *****************************************************************
                                                                                           HUT107
      ** Check if switchable feature HUT107 is on                                          HUT107
                                                                                           HUT107
     C                   Callb     'AOSARDR0'                                              HUT107
     C                   Parm      *BLANKS       P@Rtcd                                    HUT107
     C                   Parm      '*VERIFY'     P@Optn                                    HUT107
     C                   Parm      'HUT107'      P@Sard                                    HUT107
     C     SCSARD        Parm      SCSARD        DSFDY                                     HUT107
                                                                                           HUT107
     C                   If        P@Rtcd = *BLANKS                                        HUT107
     C                   move      'Y'           HUT107            1                       HUT107
     C                   Eval      *IN53  = *ON                                            HUT107
     C                   Open      UTRACCTDM                                               HUT107
     C                   Else                                                              HUT107
     C                   Eval      HUT107 = 'N'                                            HUT107
     C                   Endif                                                             HUT107
                                                                                           HUT113
      ** Check if HUT113 is installed                                                      HUT113
                                                                                           HUT113
     C                   CALLB     'AOSARDR0'                                              HUT113
     C                   PARM      *BLANKS       P@Rtcd                                    HUT113
     C                   PARM      '*VERIFY'     P@Optn                                    HUT113
     C                   PARM      'HUT113'      P@Sard                                    HUT113
     C     SCSARD        PARM      SCSARD        DSFDY                                     HUT113
                                                                                           HUT113
     C                   EVAL      *IN90  = *OFF                                           HUT113
                                                                                           HUT113
     C                   IF        P@Rtcd = *BLANKS                                        HUT113
     C                   move      'Y'           HUT113            1                       HUT107
     C                   EVAL      *IN90  = *ON                                            HUT113
     C                   ELSE                                                              HUT113
     C                   EVAL      HUT113 = 'N'                                            HUT113
     C                   ENDIF                                                             HUT113
                                                                                           HUT113
      *****************************************************************
      * End of /COPY SDH00108                                         *
      *****************************************************************
