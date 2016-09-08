      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420CP35 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC108   *CREATE   Date 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC108 - Statement of Accounts                               *
      *                                                               *
      *****************************************************************
      *
      **  Access SAR details file to see if LUC108 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'LUC108'      PSARD
     C     SCSARD        PARM      SCSARD        DSSDY
      *
     C                   MOVE      'N'           LUC108
     C                   MOVE      *OFF          *IN79
     C     PRTCD         IFEQ      *BLANKS
     C                   OPEN      SDBSRTL1
     C                   MOVE      'Y'           LUC108            1
     C                   MOVE      *ON           *IN79
     C                   ENDIF
      *
      *****************************************************************
      * End of /COPY GL0420CP35                                       *
      *****************************************************************
