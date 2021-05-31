      *****************************************************************
      * Start of /COPY HUT113_014                                     *
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
      *         - Apply MD054322 MD054548                             *
      *  MD054322 - Portfolio Management - SE - Incorrect holdings for*
      *             custody fee calculation report.                   *
      *           - Allow portfolio definition for PB customer.       *
      *                                                               *
      *****************************************************************
      *                                                                                     MD054322
      ** Data structure for switchable features                                             MD054322
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                MD054322
      *                                                                                     MD054322
      ** Data structure for access programs                                                 MD054322
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   MD054322
      *                                                                                     MD054322
      ** Data structure for Customer Details                                                MD054322
     D SDCUST        E DS                  EXTNAME(SDCUSTPD) PREFIX(V_)                     MD054322
      *                                                                                     MD054322
      ** Data structure for access programs - Long                                          MD054322
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   MD054322
      *                                                                                     MD054322
      *****************************************************************
      * End of /COPY HUT113_014                                       *
      *****************************************************************
