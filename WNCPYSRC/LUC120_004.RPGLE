      *****************************************************************
      *                                                               *
      *  Midas - IRS Validation Module                                *
      *                                                               *
      *  LUC120_004 - Midas - Validate rate change frequency          *
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
     C                   IF        (LUC120 = 'Y') AND  (SUICFR <> 'W')                        LUC120
     C                             AND (SUICFR <> 'F')                                        LUC120
     C                             OR (LUC120 <> 'Y')                                         LUC120
      *                                                                                       LUC120
