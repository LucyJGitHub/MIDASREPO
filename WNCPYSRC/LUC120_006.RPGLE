      *****************************************************************
      *                                                               *
      *  Midas - IRS Validation Module                                *
      *                                                               *
      *  LUC120_006 - Midas - Validate rate change frequency          *
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
     C     LUC120        IFEQ      'Y'                                                        LUC120
     C     SUICFR        ANDNE     'W'                                                        LUC120
     C     SUICFR        ANDNE     'F'                                                        LUC120
     C     LUC120        ORNE      'Y'                                                        LUC120
      *                                                                                       LUC120
