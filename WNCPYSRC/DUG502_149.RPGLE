      *****************************************************************
      *                                                               *
      *  Last Amend No. DUG502 *Created    Date 05Dec17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DUG502 - Security Diary Enhancements                         *
      *                                                               *
      *****************************************************************
      *                                                                                       DUG502
      ** Check if DUG502 is enabled.                                                          DUG502
      *                                                                                       DUG502
     C                   CALLB     'AOSARDR0'                                                 DUG502
     C                   PARM      *BLANKS       PRtCd                                        DUG502
     C                   PARM      '*VERIFY'     POptn                                        DUG502
     C                   PARM      'DUG502'      PSARD             6                          DUG502
     C     SCSARD        PARM      SCSARD        DSFDY                                        DUG502
                                                                                              DUG502
     C                   MOVEL     'N'           DUG502            1                          DUG502
                                                                                              DUG502
     C                   IF        PRtCd = *BLANKS                                            DUG502
     C                   EVAL      DUG502 = 'Y'                                               DUG502
     C                   ELSE                                                                 DUG502
                                                                                              DUG502
     C                   IF        PRtCd <> '*NRF   '                                         DUG502
     C     *LOCK         IN        LDA                                                        DUG502
     C                   EVAL      DBFile = 'SCSARDPD'                                        DUG502
     C                   EVAL      DBKey = PSARD                                              DUG502
     C                   EVAL      DBase = 101                                                DUG502
     C                   OUT       LDA                                                        DUG502
     C                   EXSR      *PSSR                                                      DUG502
     C                   ENDIF                                                                DUG502
                                                                                              DUG502
     C                   ENDIF                                                                DUG502
