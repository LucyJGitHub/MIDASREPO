      *****************************************************************
      *                                                               *
      *  Midas GENERAL LEDGER MODULE                                  *
      *                                                               *
      *  GL0420CP20 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC108             DATE 19Apr16               *
      *  Prev Amend No. LUC107  *CREATE    DATE 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC108 - Statement of Accounts                               *
      *  LUC107 - Statement Page Number Enhancement                   *
      *                                                               *
      *****************************************************************
      *
     C     LUC108        IFEQ      'Y'                                                        LUC108
     C     LUC107        OREQ      'Y'                                                        LUC107
     C   45STPP          ADD       1             STPP                                         LUC107
     C                   ELSE                                                                 LUC107
      *
      *****************************************************************
      * End of /COPY GL0420CP20                                       *
      *****************************************************************
