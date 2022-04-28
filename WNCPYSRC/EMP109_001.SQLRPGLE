      *****************************************************************
      *  Start of /COPY EMP109_001                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. EMP109  *Create    Date 07Jul21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EMP109 - Fixed number of days in RE APR Calculation          *
      *                                                               *
      *****************************************************************
      *                                                                                  EMP109
     C                   CALL      'AOSARDR0'                                            EMP109
     C                   PARM      *BLANKS       PRTCD                                   EMP109
     C                   PARM      '*VERIFY'     POPTN                                   EMP109
     C                   PARM      'EMP109'      PSARD                                   EMP109
      *                                                                                  EMP109
     C     PRTCD         Ifeq      *BLANKS                                               EMP109
     C                   Move      'Y'           EMP109            1                     EMP109
     C                   else                                                            EMP109
     C                   Move      'N'           EMP109                                  EMP109
     C                   Endif                                                           EMP109
      *                                                                                  EMP109
      *****************************************************************
      *  End of /COPY EMP109_001                                      *
      *****************************************************************
