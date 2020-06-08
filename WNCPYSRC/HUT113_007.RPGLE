      *****************************************************************
      *  Start of /COPY HUT113_007                                    *
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
      *           Apply fix MD054548 MD054322.                        *
      *  MD054548 - Error is found in Portfolio Definition Maintenance*
      *             (Inconsistency on screen).                        *
      *           - Display the new PB screen for customer either PM  *
      *             or PB when HUT026 feature is ON.                  *
      *  MD054322 - Portfolio Management - SE - Incorrect holdings for*
      *             custody fee calculation report.                   *
      *           - Allow portfolio definition for PB customer.       *
      *****************************************************************
      *                                                                                       HUT113
     C                   ELSE                                                              MD0543223
     C                   IF        HUT113 = 'Y'                                   MD054322 MD0545483
      ** Populate management indicator.                                                    MD0543223
     C**********         IF        HUT113 = 'Y' AND BBPRBA = 'Y'                  MD054322 MD0545483
     C                   EVAL      DDMNGI = P1PNMNGI                                       MD0543223
      ** Investment details                                                                MD0543223
      *                                                                                    MD0543223
     C                   EVAL      DDIPIN = P1PNIPIN                                       MD0543223
     C                   EVAL      DDCYIN = P1PNCYIN                                       MD0543223
     C                   EVAL      DDYPIN = P1PNYPIN                                       MD0543223
     C                   EVAL      DDNPIN = P1PNNPIN                                       MD0543223
      ** Report Past Year Performance                                                      MD0543223
      *                                                                                    MD0543223
     C                   EVAL      DDRPYP = P1PNRPYP                                       MD0543223
      ** Account Sequence                                                                  MD0543223
      *                                                                                    MD0543223
     C                   MOVE      P1PNACSQ      DDACSQ                                    MD0543223
     C                   ENDIF                                                             MD0543223
      *                                                                                    MD0543223
      *****************************************************************
      * End of /COPY HUT113_007                                       *
      *****************************************************************
