      *****************************************************************
      *                                                               *
      *  Last Amend No.   LUC107                Date 21Dec2015        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC107 - Statement Page Number Enhancement                   *
      *                                                               *
      *****************************************************************
     C                   CALL      'AOSARDR0'                                                 LUC107
     C                   PARM      *BLANKS       PRTCD                                        LUC107
     C                   PARM      '*VERIFY'     POPTN                                        LUC107
     C                   PARM      'LUC107'      PSARD                                        LUC107
     C     SCSARD        PARM      SCSARD        DSFDY                                        LUC107
      *                                                                                       LUC107
     C     PRTCD         IFEQ      *BLANKS                                                    LUC107
     C                   MOVE      'Y'           LUC107            1                          LUC107
     C                   SETON                                        85                      LUC107
     C                   ELSE                                                                 LUC107
     C                   MOVE      'N'           LUC107                                       LUC107
     C                   SETOFF                                       85                      LUC107
     C                   ENDIF                                                                LUC107
      *
     C     *LIKE         DEFINE    STPA          W0STPA                                       LUC107
      *
      *****************************************************************
      * End of /COPY GL0420CP18                                       *
      *****************************************************************
