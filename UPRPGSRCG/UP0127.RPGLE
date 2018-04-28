     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Find job description on SMSETULF')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP0127 - Find job description on SMSETULF                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSC017             Date 26Feb03               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *  CSC017 - Change library list to 250.                         *
      *                                                               *
      *****************************************************************
      *
      *  File containing list of job descriptions
     FSMSETULF  IF   E           K DISK
      *
     C     *ENTRY        PLIST
     C                   PARM                    Job_desc         10
     C                   PARM                    Found             1
      *
     C                   EVAL      Found = 'N'
      *
      * Attempt to find record.
     C     Job_desc      SETLL     SMSETUD0
     C     Job_desc      CHAIN     SMSETUD0                           10
     C     *IN10         IFEQ      *OFF
     C                   EVAL      Found = 'Y'
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      ********************************************************************
