      *****************************************************************                             
      *                                                               *                             
      *  Midas - Customer Lending ILE Module                          *                             
      *                                                               *                             
      *  LELERIVAL - LE Rollover Instructions Validation              *                             
      *                                                               *                             
      *  Function: This Program Validates LE Rollover Input into      *                             
      *            the Midas database.                                *                             
      *                                                               *                             
      *  (c) Finastra International Banking Systems Ltd. 2016         *                             
      *                                                               *                             
      *  Last Amend No. LUC109             Date 23Aug16               *                             
      *                                                               *                             
      *---------------------------------------------------------------*                             
      *                                                               *                             
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *                             
      *           Issue error message if facility is blocked.         *                             
      *                                                               *                             
      *****************************************************************                             
     FFCLTYY0   IF   E           K DISK    INFSR(*PSSR)                                             
