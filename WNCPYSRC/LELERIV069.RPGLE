      *****************************************************************                       LUC109
      *                                                               *                       LUC109
      *  Midas - Customer Lending Module.                             *                       LUC109
      *                                                               *                       LUC109
      *  LELERIVAL - LE Rollover Instructions Validation              *                       LUC109
      *                                                               *                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *                       LUC109
      *  Last Amend No. LUC109             Date 23Aug16               *                       LUC109
      *                                                               *                       LUC109
      *---------------------------------------------------------------*                       LUC109
      *                                                               *                       LUC109
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *                       LUC109
      *           Issue error message if facility is blocked.         *                       LUC109
      *                                                               *                       LUC109
      *****************************************************************                       LUC109
      ** Check switch LUC013.                                                                 LUC109
     C                   MOVE      'N'           LUC109            1                          LUC109
     C                   CALLB     'AOSARDR0'                                                 LUC109
     C                   PARM      *BLANKS       @RTCD                                        LUC109
     C                   PARM      '*VERIFY '    @OPTN                                        LUC109
     C                   PARM      'LUC109'      @SARD                                        LUC109
     C     SCSARD        PARM      SCSARD        DSFDY                                        LUC109
      *                                                                                       LUC109
     C                   IF        @RTCD = *BLANKS                                            LUC109
     C                   EVAL      LUC109 = 'Y'                                               LUC109
     C                   ELSE                                                                 LUC109
     C                   EVAL      LUC109 = 'N'                                               LUC109
     C                   ENDIF                                                                LUC109
      *                                                                                       LUC109
      ***  Key list for Facilities file (access of prime facility)                            LUC109
      *                                                                                       LUC109
     C     WFCLT         KLIST                                                                LUC109
     C                   KFLD                    WFCNUM                                       LUC109
     C                   KFLD                    WFFACT                                       LUC109
     C                   KFLD                    WFFCNO                                       LUC109
