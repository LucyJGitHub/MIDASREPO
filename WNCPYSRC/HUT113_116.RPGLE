      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  SDCUSDSIN                                                    *
      *                                                               *
      *  Last Amend No. HUT113    *CREATE  Date 01Apr20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT113 - Upgrade HUT026 to FBM 2.1 SP 22                     *
      *         - Full Private Banking Functionality in Midas         *
      *         - Allow Portfolio Definitions Input in Midas          *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT113
      *                                                                                       HUT113
      * Reset Private Banking indicator                                                       HUT113
     C                   IF        HUT113 = 'Y'                                               HUT113
     C                   MOVE      'N'           NOREDO                                       HUT113
     C                   ENDIF                                                                HUT113
      *****************************************************************
      * End of /COPY HUT113_116                                       *
      *****************************************************************
