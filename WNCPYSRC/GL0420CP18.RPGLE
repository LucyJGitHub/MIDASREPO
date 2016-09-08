      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420C031 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC107   *CREATE   Date 21Dec15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC107 - Statement Page Number Enhancement                   *
      *                                                               *
      *****************************************************************
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'LUC107'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           LUC107            1
     C                   SETON                                        85
     C                   ELSE
     C                   MOVE      'N'           LUC107
     C                   SETOFF                                       85
     C                   ENDIF
      *
     C     *LIKE         DEFINE    STPA          W0STPA
      *
      *****************************************************************
      * End of /COPY GL0420CP18                                       *
      *****************************************************************
