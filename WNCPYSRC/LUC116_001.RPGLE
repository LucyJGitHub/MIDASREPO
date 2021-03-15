      *****************************************************************                       
      *                                                               *                       
      *  Midas - /COPY Member (LEFCIP1VL)                             *                       
      *                                                               *                       
      *  LUC116_001 - LE Facility first screen validation             *                       
      *                                                               *                       
      *  Last Amend No. LUC116   *CREATE   Date 18Jan19               *                       
      *                                                               *                       
      *---------------------------------------------------------------*                       
      *                                                               *                       
      *  LUC116 - Facility Expiry and Last Availability Dates -       *                       
      *             Until Further Notice                              *                       
      *                                                               *                       
      *****************************************************************                       
      *                                                                                       
      **  If LUC116 is enabled, do not check for holiday if                                   
      **  expiry date is 36083 (translated from UFN input on screen                           
      **  Note:  36083 is 15Oct70                                                             
     C     LUC116        IFEQ      'N'                                                        
     C     LUC116        OREQ      'Y'
     C     ZDAYNO        ANDNE     36083
      *****************************************************************                       
      * End of /COPY LUC116_001                                       *                       
      *****************************************************************                       
