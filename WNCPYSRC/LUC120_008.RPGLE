      *****************************************************************
      *                                                               *
      *  Midas - IRS Validation Module                                *
      *                                                               *
      *  LUC120_008 - Midas - Validate rate change frequency          *
      *                                                               *
      *  (C) Copyright Finastra Internatonal Limited 2019             *
      *                                                               *
      *  Last Amend No. LUC120  *CREATE    Date 13Feb19               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC120 - Allow frequency 'W' (Weekly) or 'F' (Fortnightly).  *
      *                                                               *
      *---------------------------------------------------------------*
      *
      ** Access AOSARDR0 and check if LUC120 is installed                                     LUC120
      *                                                                                       LUC120
     C                   CALL      'AOSARDR0'                                                 LUC120
     C                   PARM      *BLANKS       PRTCD             7                          LUC120
     C                   PARM      '*VERIFY'     POPTN             7                          LUC120
     C                   PARM      'LUC120'      PSARD             6                          LUC120
     C     SCSARD        PARM      SCSARD        DSFDY                                        LUC120
      *                                                                                       LUC120
     C     PRTCD         IFNE      *BLANKS                                                    LUC120
     C     PRTCD         ANDNE     '*NRF    '                                                 LUC120
     C                   MOVEL     'SCSARDPD'    DBFILE                                       LUC120
     C                   MOVEL     '055'         DBASE                                        LUC120
     C                   MOVEL     'LUC120'      DBKEY                                        LUC120
     C                   MOVE      *ON           *INU7                                        LUC120
     C                   MOVE      *ON           *INU8                                        LUC120
     C                   MOVE      *ON           *INLR                                        LUC120
     C                   EXSR      *PSSR                                                      LUC120
     C                   ENDIF                                                                LUC120
      *                                                                                       LUC120
     C     PRTCD         IFEQ      *BLANKS                                                    LUC120
     C                   MOVE      'Y'           LUC120            1                          LUC120
     C                   ELSE                                                                 LUC120
     C                   MOVE      'N'           LUC120                                       LUC120
     C                   ENDIF                                                                LUC120
      *                                                                                       LUC120
