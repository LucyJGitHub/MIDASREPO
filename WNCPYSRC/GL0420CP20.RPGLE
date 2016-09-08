      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420CP20 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC108             Date 19Apr16               *
      *  Prev Amend No. LUC107   *CREATE   Date 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC108 - Statement of Accounts                               *
      *  LUC107 - Statement Page Number Enhancement                   *
      *                                                               *
      *****************************************************************
      *
     C     LUC108        IFEQ      'Y'
     C     LUC107        OREQ      'Y'
     C   45STPP          ADD       1             STPP
     C                   ELSE
      *
      *****************************************************************
      * End of /COPY GL0420CP20                                       *
      *****************************************************************
