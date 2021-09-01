      *****************************************************************
      *                                                               *
      *  Midas GENERAL LEDGER MODULE                                  *
      *                                                               *
      *  GL0420C081 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No.   LUC107                Date 21Dec2015        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC107 - Statement Page Number Enhancement                   *
      *                                                               *
      *****************************************************************
      *
     C     LUC107        IFEQ      'Y'                                                        LUC107
     C     *IN03         ANDEQ     *ON                                                        LUC107
     C                   Z-ADD     W0STPA        STPA                                         LUC107
     C                   ENDIF                                                                LUC107
      *
      *****************************************************************
      * End of /COPY GL0420C081                                       *
      *****************************************************************
