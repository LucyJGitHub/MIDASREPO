      *****************************************************************
      *  Start of /COPY HUT113_008                                    *
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
     C                   CALLB     'AOSARDR0'                                               MD054322
     C                   PARM      *BLANKS       P@Rtcd                                     MD054322
     C                   PARM      '*VERIFY'     P@Optn                                     MD054322
     C                   PARM      'HUT113'      P@Sard                                     MD054322
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD054322
      *                                                                                     MD054322
     C                   IF        P@Rtcd = *BLANKS                                         MD054322
     C                   EVAL      HUT113 = 'Y'                                             MD054322
     C                   ELSE                                                               MD054322
     C                   EVAL      HUT113 = 'N'                                             MD054322
     C                   ENDIF                                                              MD054322
      *                                                                                     MD054322
      ** Access customer details to determine if customer is PB.                            MD054322
      *                                                                                     MD054322
     C                   IF        HUT113 = 'Y'                                             MD054322
     C                   MOVEL     P1PNCNUM      DDCSNM                                     MD054322
     C                   CALLB     'AOCUSTR1'                                               MD054322
     C                   PARM      *BLANKS       PRTCD             7                        MD054322
     C                   PARM      '*KEY'        POPTN             7                        MD054322
     C                   PARM      DDCSNM        PCNUM            10                        MD054322
     C                   PARM                    PKEY              7                        MD054322
     C     SDCUST        PARM      SDCUST        DSLDY                                      MD054322
     C                   ENDIF                                                              MD054322
      *                                                                                     MD054322
      *****************************************************************
      * End of /COPY HUT1130_008                                      *
      *****************************************************************
