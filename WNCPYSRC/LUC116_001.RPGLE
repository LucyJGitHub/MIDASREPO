      *****************************************************************                       LUC116
      *                                                               *                       LUC116
      *  Midas - /COPY Member (LEFCIP1VL)                             *                       LUC116
      *                                                               *                       LUC116
      *  LUC116_001 - LE Facility first screen validation             *                       LUC116
      *                                                               *                       LUC116
      *  Last Amend No. LUC116   *CREATE   Date 18Jan19               *                       LUC116
      *                                                               *                       LUC116
      *---------------------------------------------------------------*                       LUC116
      *                                                               *                       LUC116
      *  LUC116 - Facility Expiry and Last Availability Dates -       *                       LUC116
      *             Until Further Notice                              *                       LUC116
      *                                                               *                       LUC116
      *****************************************************************                       LUC116
      *                                                                                       LUC116
      **  If LUC116 is enabled, do not check for holiday if                                   LUC116
      **  expiry date is 36083 (translated from UFN input on screen                           LUC116
      **  Note:  36083 is 15Oct70                                                             LUC116
     C     LUC116        IFEQ      'N'                                                        LUC116
     C     LUC116        OREQ      'Y'
     C     ZDAYNO        ANDNE     36083
      *****************************************************************                       LUC116
      * End of /COPY LUC116_001                                       *                       LUC116
      *****************************************************************                       LUC116
