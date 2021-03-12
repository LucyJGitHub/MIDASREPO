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
     D                 DS                                                                           
      ***  Data structure of key list used in chaining to FCLTY                                     
      *                                                                                             
     D  WFCNUM                 1      6                                                             
     D  WFFACT                 7      9  0                                                          
     D  WFFCNO                10     11  0                                                          
