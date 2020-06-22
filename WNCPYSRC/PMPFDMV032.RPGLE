      *****************************************************************
      * Start of /COPY PMPFDMV032                                     *
      *****************************************************************
      *                                                               *
      *  PMPFDM2RV                                                    *
      *                                                               *
      *  Last Amend No. HUT113    *CREATE  Date 01Apr20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT113 - Full Private Banking Functionality in Midas         *
      *           Upgrade HUT026 to FBM 2.1 SP 22                     *
      *           Allow Portfolio Definitions Input in Midas          *
      *           Apply MD054322 MD054548                             *
      *  MD054548 - Error is found in Portfolio Definition Maintenance*
      *             (Inconsistency on screen).                        *
      *             Display the new PB screen for customer either PM  *
      *             or PB when HUT113 feature is ON.                  *
      *  MD054322 - Portfolio Management - SE - Incorrect holdings for*
      *             custody fee calculation report.                   *
      *             Allow portfolio definition for PB customer.       *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT113
      ** Default 'N' value for Investment policy code fields                                MD054322
     C*                                                                                     MD054322
     C                   IF        HUT113 = 'Y'                                             MD054548
     C                   EVAL      DDIPIN = 'N'                                             MD054322
     C                   EVAL      DDCYIN = 'N'                                             MD054322
     C                   EVAL      DDYPIN = 'N'                                             MD054322
     C                   EVAL      DDNPIN = 'N'                                             MD054322
     C                   ENDIF                                                              MD054322
      *****************************************************************
      * End of /COPY PMPFDMV032                                       *
      *****************************************************************
