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
      *         - Apply MD052193                                      *
      *  MD052193 - Private Banking Customer Field is always          *
      *             defaulting to N even if user input is Y           *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT113
      * Inject 'once only' default for Private Banking                                        HUT113
     C                   IF        DDACTN = 'I' and BGN4ST = 'Y'                              HUT113
     C                             and HUT113 = 'Y' and NOREDO = 'N'                          HUT113
     C                   IF        DDPRBA = *BLANKS                                         MD052193
     C                   EVAL      DDPRBA = 'N'                                               HUT113
     C                   ENDIF                                                              MD052193
     C                   MOVE      'Y'           NOREDO                                       HUT113
     C                   ENDIF                                                                HUT113
      *                                                                                       HUT113
      *****************************************************************
      * End of /COPY HUT113_118                                       *
      *****************************************************************
