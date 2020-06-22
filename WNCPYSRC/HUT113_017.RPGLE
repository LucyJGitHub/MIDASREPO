      *****************************************************************
      *  Start of /COPY HUT113_017                                    *
      *****************************************************************
      *                                                               *
      *  PMPFDM3DP  - PM Maintenance                                  *
      *                                                               *
      *  Last Amend No. HUT113    *Create  Date 01Apr20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT113 - Full Private Banking Functionality in Midas         *
      *           Allow Portfolio Definitions Input in Midas          *
      *           (Upgrade HUT026 to FM2.1 SP22)                      *
      *         - Apply MD054548                                      *
      *  MD054548 - Error is found in Portfolio Definition Maintenance*
      *             (Inconsistency on screen).                        *
      *           - Display the new PB screen for customer either PM  *
      *             or PB when HUT113 feature is ON.                  *
      *                                                               *
      *****************************************************************
      *                                                                                     MD054548
     C                   IF        HUT113 = 'Y'                                             MD054548
     C                   EVAL      *IN71 = *OFF                                             MD054548
     C                   ELSE                                                               MD054548
      *                                                                                     MD054548
      *****************************************************************
      * End of /COPY HUT113_017                                       *
      *****************************************************************
