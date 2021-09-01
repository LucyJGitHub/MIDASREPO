      *****************************************************************
      *                                                               *
      *  Midas GENERAL LEDGER MODULE                                  *
      *                                                               *
      *  GL0420CP35 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC132             DATE 30Jul19               *
      *  Prev Amend No. LUC108  *CREATE    DATE 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC132 - Amendments to Statement of Account feature AG       *
      *  LUC108 - Statement of Accounts                               *
      *                                                               *
      *****************************************************************
      *
      **  Access SAR details file to see if LUC108 is installed.                              LUC108
      *                                                                                       LUC108
     C                   CALL      'AOSARDR0'                                                 LUC108
     C                   PARM      *BLANKS       PRTCD                                        LUC108
     C                   PARM      '*VERIFY'     POPTN                                        LUC108
     C                   PARM      'LUC108'      PSARD                                        LUC108
     C     SCSARD        PARM      SCSARD        DSSDY                                        LUC108
      *                                                                                       LUC108
     C                   MOVE      'N'           LUC108                                       LUC108
     C                   MOVE      *OFF          *IN79                                        LUC108
     C     PRTCD         IFEQ      *BLANKS                                                    LUC108
     C                   OPEN      SDBSRTL1                                                   LUC108
     C                   MOVE      'Y'           LUC108            1                          LUC108
     C                   MOVE      *ON           *IN79                                        LUC108
     C                   ENDIF                                                                LUC108
      *
      **  Access SAR details file to see if LUC132 is installed.                              LUC132
      *                                                                                       LUC132
     C                   CALL      'AOSARDR0'                                                 LUC132
     C                   PARM      *BLANKS       PRTCD                                        LUC132
     C                   PARM      '*VERIFY'     POPTN                                        LUC132
     C                   PARM      'LUC132'      PSARD                                        LUC132
     C     SCSARD        PARM      SCSARD        DSSDY                                        LUC132
      *                                                                                       LUC132
     C                   MOVE      'N'           LUC132                                       LUC132
     C                   MOVE      *OFF          *IN86                                        LUC132
     C     PRTCD         IFEQ      *BLANKS                                                    LUC132
     C                   MOVE      'Y'           LUC132            1                          LUC132
     C                   MOVE      *ON           *IN86                                        LUC132
     C                   ENDIF                                                                LUC132
      *****************************************************************
      * End of /COPY GL0420CP35                                       *
      *****************************************************************
