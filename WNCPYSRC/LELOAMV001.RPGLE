      *****************************************************************
      *                                                               *                             
      *  Midas - Customer Lending ILE Module                          *                             
      *                                                               *                             
      *  LELOAMVAL - LE Loan amendment detail screen validation       *                             
      *                                                               *                             
      *  Function: This program validates a loan amendment input into *                             
      *            the Midas database.                                *                             
      *                                                               *                             
      *  (c) Finastra International Banking Systems Ltd. 2016         *                             
      *                                                               *                             
      *  Last Amend No. LUC109             Date 23Aug16               *                             
      *                                                               *                             
      *---------------------------------------------------------------*                             
      *                                                               *                             
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *                             
      *           Bypass check for PI date against last availablity   *                             
      *           date.                                               *                             
      *                                                               *                             
      *****************************************************************                             
     FFCLTYY0   IF   E           K DISK    INFSR(*PSSR)                                             
