      *****************************************************************                       LUC109
      *                                                               *                       LUC109
      *  Midas - Customer Lending ILE Module                          *                       LUC109
      *                                                               *                       LUC109
      *  LELERIVAL - LE Rollover Instructions Validation              *                       LUC109
      *                                                               *                       LUC109
      *  Function: This Program Validates LE Rollover Input into      *                       LUC109
      *            the Midas database.                                *                       LUC109
      *                                                               *                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *                       LUC109
      *  Last Amend No. LUC109             Date 23Aug16               *                       LUC109
      *                                                               *                       LUC109
      *---------------------------------------------------------------*                       LUC109
      *                                                               *                       LUC109
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *                       LUC109
      *           Issue error message if facility is blocked.         *                       LUC109
      *                                                               *                       LUC109
      *****************************************************************                       LUC109
     D                 DS                                                                     LUC109
      ***  Data structure of key list used in chaining to FCLTY                               LUC109
      *                                                                                       LUC109
     D  WFCNUM                 1      6                                                       LUC109
     D  WFFACT                 7      9  0                                                    LUC109
     D  WFFCNO                10     11  0                                                    LUC109
