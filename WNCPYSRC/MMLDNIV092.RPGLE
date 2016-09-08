      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (MMLDNIVAL)                             *
      *                                                               *
      *  MMLDNIV092  - MM Loans/Deposits Validation                   *
      *                                                               *
      *  (C) Copyright Misys Banking Systems, 2016.                   *
      *                                                               *
      *  Last Amend No. LUC104  *CREATE    Date 14Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC104 - KondorPlus Details on Deals                         *
      *                                                               *
      *****************************************************************
      *
     C                   MOVEL     'N'           LUC104
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'LUC104'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           LUC104            1
     C                   ENDIF
