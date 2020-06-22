      *****************************************************************
      *  Start of /COPY HUT113_004                                    *
      *****************************************************************
      *                                                               *
      *  PMPFDM2CT  - PM Screen convert                               *
      *                                                               *
      *  Last Amend No. HUT113    *Create  Date 01Apr20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT113 - Full Private Banking Functionality in Midas         *
      *           Allow Portfolio Definitions Input in Midas          *
      *           (Upgrade HUT026 to FM2.1 SP22)                      *
      *           Apply MD054322.                                     *
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
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                MD054322
      *                                                                                     MD054322
      ** Data structure for access programs - Long                                          MD054322
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   MD054322
      *                                                                                     MD054322
      *****************************************************************
      * End of /COPY HUT113_004                                       *
      *****************************************************************
