      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  SDCUSD5DP                                                    *
      *                                                               *
      *  Last Amend No. HUT113    *CREATE  Date 01Apr20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT113 - Upgrade HUT026 to FBM 2.1 SP 22                     *
      *         - Full Private Banking Functionality in Midas         *
      *         - Allow Portfolio Definitions Input in Midas          *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT113
     C** Check if HUT113 is installed                                                         HUT113
      *                                                                                       HUT113
     C                   CALLB     'AOSARDR0'                                                 HUT113
     C                   PARM      *BLANKS       P@Rtcd                                       HUT113
     C                   PARM      '*VERIFY'     P@Optn                                       HUT113
     C                   PARM      'HUT113'      P@Sard                                       HUT113
     C     SCSARD        PARM      SCSARD        DSFDY                                        HUT113
                                                                                              HUT026
     C                   IF        P@Rtcd <> *BLANKS  AND P@Rtcd <> '*NRF   '                 HUT026
     C                   MOVEL     'SCSARDPD'    DBFILE                                       HUT026
     C                   MOVEL     '909'         DBASE                                        HUT113
     C                   MOVEL     P@Sard        DBKEY                                        HUT113
     C                   EXSR      SRERR                                                      HUT113
     C                   ENDIF                                                                HUT113
      *                                                                                       HUT113
     C                   EVAL      *IN90  = *OFF                                              HUT113
      *                                                                                       HUT113
     C                   IF        P@Rtcd = *BLANKS                                           HUT113
     C                   EVAL      HUT113 = 'Y'                                               HUT113
     C                   EVAL      *IN90  = *ON                                               HUT113
     C                   ELSE                                                                 HUT113
     C                   EVAL      HUT113 = 'N'                                               HUT113
     C                   ENDIF                                                                HUT113
      *                                                                                       HUT113
      *****************************************************************
      * End of /COPY HUT113_112                                       *
      *****************************************************************
