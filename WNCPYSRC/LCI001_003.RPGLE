      *****************************************************************
      *                                                               *
      *  MMVLDNICUS - Midas MM Validate Cust number (Loans/Deposits)  *
      *                                                               *
      *  Last Amend No. LCI001  *CREATE    Date 27Jul20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LCI001 - MM Deals Validation - Deal Types against Cust Types *
      *                                                               *
      *****************************************************************
      *
     C     LCI001        IFEQ      'N'
     C     LCI001        OREQ      'Y'
     C     ITIPSV        ANDEQ     'N'
      *
