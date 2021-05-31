      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (DSPF)                                  *
      *                                                               *
      *  SDVACOF                                                      *
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
                                                                                              HUT113
     C                   CALLB     'AOSARDR0'                                                 HUT113
     C                   PARM      *BLANKS       P@Rtcd                                       HUT113
     C                   PARM      '*VERIFY'     P@Optn                                       HUT113
     C                   PARM      'HUT113'      P@Sard                                       HUT113
     C     SCSARD        PARM      SCSARD        DSFDY                                        HUT113
                                                                                              HUT113
     C                   IF        P@Rtcd <> *BLANKS  AND  P@Rtcd <> '*NRF   '                HUT113
     C                   EVAL      DBFILE = 'SCSARDPD'                                        HUT113
     C                   EVAL      DBKEY  = 'HUT113'                                          HUT113
     C                   EVAL      DBASE  = 915                                               HUT113
     C                   EXSR      *PSSR                                                      HUT113
     C                   ENDIF                                                                HUT113
      *                                                                                       HUT113
     C                   IF        P@Rtcd = *BLANKS                                           HUT113
     C                   EVAL      HUT113 = 'Y'                                               HUT113
     C                   ELSE                                                                 HUT113
     C                   EVAL      HUT113 = 'N'                                               HUT113
     C                   ENDIF                                                                HUT113
     C*                                                                                       HUT113
      *****************************************************************
      * End of /COPY HUT113_064                                       *
      *****************************************************************
