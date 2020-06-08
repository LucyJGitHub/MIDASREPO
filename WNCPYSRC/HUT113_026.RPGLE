      *****************************************************************
      * Start of /COPY HUT113_026                                     *
      *****************************************************************
      *                                                               *
      *  PMPFDM3DP - PM Maintenance                                   *
      *                                                               *
      *  Last Amend No. HUT113    *Create  Date 01Apr20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT113 - Full Private Banking Functionality in Midas         *
      *           Allow Portfolio Definitions Input in Midas          *
      *           (Upgrade HUT026 to FM2.1 SP22)                      *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT113
     C                   CALLB     'AOSARDR0'                                                 HUT113
     C                   PARM      *BLANKS       P@Rtcd                                       HUT113
     C                   PARM      '*VERIFY'     P@Optn                                       HUT113
     C                   PARM      'HUT113'      P@Sard                                       HUT113
     C     SCSARD        PARM      SCSARD        DSFDY                                        HUT113
      *                                                                                       HUT113
     C                   IF        P@Rtcd = *BLANKS                                           HUT113
     C                   EVAL      HUT113 = 'Y'                                               HUT113
     C                   ELSE                                                                 HUT113
     C                   EVAL      HUT113 = 'N'                                               HUT113
     C                   ENDIF                                                                HUT113
      *                                                                                       HUT113
      *****************************************************************
      * End of /COPY HUT113_026                                       *
      *****************************************************************
