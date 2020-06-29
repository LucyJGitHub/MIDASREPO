      *****************************************************************
      *                                                               *
      *  Last Amend No. DUG502 *Created    Date 23Aug17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DUG502 - Security Diary Enhancements                         *
      *                                                               *
      *****************************************************************
      *                                                                                       DUG502
      ** Check if DUG502 is installed                                                         DUG502
      *                                                                                       DUG502
     C                   MOVE      'N'           DUG502            1                          DUG502
     C                   CALLB     'AOSARDR0'                                                 DUG502
     C                   PARM      *Blanks       PRTCD                                        DUG502
     C                   PARM      '*VERIFY'     POPTN                                        DUG502
     C                   PARM      'DUG502'      PSARD                                        DUG502
     C     SCSARD        PARM      SCSARD        DSSDY                                        DUG502
                                                                                              DUG502
     C                   IF        PRTCD = *Blanks                                            DUG502
     C                   EVAL      DUG502 = 'Y'                                               DUG502
     C                   ELSE                                                                 DUG502
     C                   IF        PRTCD <> '*NRF   '                                         DUG502
     C                   EVAL      DBFILE = 'SCSARDPD'                                        DUG502
     C                   EVAL      DBKEY  = 'DUG502'                                          DUG502
     C                   EVAL      DBASE  = 3                                                 DUG502
     C                   EXSR      *PSSR                                                      DUG502
     C                   ENDIF                                                                DUG502
     C                   ENDIF                                                                DUG502
      *                                                                                       DUG502
