      *****************************************************************
      * Start of /COPY HUT113_010                                     *
      *****************************************************************
      *                                                               *
      *  PMPFDM2VL                                                    *
      *                                                               *
      *  Last Amend No. HUT113    *CREATE  Date 01Apr20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT113 - Full Private Banking Functionality in Midas         *
      *           Upgrade HUT026 to FBM 2.1 SP 22                     *
      *           Allow Portfolio Definitions Input in Midas          *
      *         - Apply MD054322.                                     *
      *  MD054322 - Portfolio Management - SE - Incorrect holdings for*
      *             custody fee calculation report.                   *
      *           - Allow portfolio definition for PB customer.       *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT113
     C     HUT113        ANDEQ     'N'                                                      MD054548
     C     HUT113        OREQ      'Y'                                                      MD054322
     C*****V_BBPRBA      ANDEQ     'Y'                                             MD054322 MD054548
      *                                                                                       HUT113
      *****************************************************************
      * End of /COPY HUT113_010                                       *
      *****************************************************************
