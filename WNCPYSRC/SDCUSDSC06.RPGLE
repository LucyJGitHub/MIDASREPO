      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  SDCUSDSIN                                                    *
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
     C** Check if HUT113 is installed                                                         HUT113
                                                                                              HUT113
     C                   CALLB     'AOSARDR0'                                                 HUT113
     C                   PARM      *BLANKS       PRTCD                                        HUT113
     C                   PARM      '*VERIFY'     POPTN                                        HUT113
     C                   PARM      'HUT113'      PSARD                                        HUT113
     C     SCSARD        PARM      SCSARD        DSFDY                                        HUT113
                                                                                              HUT113
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  HUT113
     C                   EVAL      DBFILE = 'SCSARDPD'                                        HUT113
     C                   EVAL      DBKEY  = 'HUT113'                                          HUT113
     C                   EVAL      DBASE  = 915                                               HUT113
     C                   EXSR      *PSSR                                                      HUT113
     C                   ENDIF                                                                HUT113
      *                                                                                       HUT113
     C                   IF        PRTCD = *BLANKS                                            HUT113
     C                   EVAL      HUT113 = 'Y'                                               HUT113
     C                   ELSE                                                                 HUT113
     C                   EVAL      HUT113 = 'N'                                               HUT113
     C                   ENDIF                                                                HUT113
     C                                                                                        HUT113
      *                                                                                       HUT113
      *****************************************************************
      * End of /COPY SDCUSDSC06                                       *
      *****************************************************************
