      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      *  Last Amend No. LUC109             Date 16Sep16               *
      *  Prev Amend No. 167412             Date 18NOV99               *
      *                 167412             Date 05NOV99               *
      *                 167412   *CREATE   DATE 28OCT99               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FBM 2.1)                   *
      *  167412 - MPDAT INSTEAD OF MPDNB                              *
      *  167412 - Use prev activity date instead of last act. date    *
      *  167412 - Change the way monthly averages are calculated:     *
      *           include non-working days and do not count days      *
      *           when transaction is inactive.                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *   ACTIV - Check transaction is active on date specified.      *
      *              (or account)                                     *
      *       i.e. value date =< specified  date =< maturity date     *
      *       (or opening date)                 (or closure date)     *
      *                                                               *
      *       NOTE:For the purposes of the averaging calculation we   *
      *       count the transaction as active even on maturity date.  *
      *                                                               *
      *    Inputs:                                                    *
      *       @WDAT : Specified date as Midas day                     *
      *       @VDAT : Value date (or opening date) as Midas day       *
      *       @MDAT : Maturity date (or closure date) as Midas day    *
      *                                                               *
      *    Internal:                                                  *
      *       MATURE: 1 if specified date is past maturity date       *
      *    Outputs:                                                   *
      *       ACTIVE: 1 if transaction (or account) is active         *
      *               0 if transaction (or account) is inactive       *
      *                                                               *
      *    CALLED BY - SRACCU                                         *
      *                                                               *
      *****************************************************************
      *
     C     ACTIV         BEGSR                                                  *** ACTIV  ***
      *
      *
     C                   MOVE      *OFF          MATURE
     C                   MOVE      *OFF          ACTIVE
     C     @MDAT         IFNE      0
     C     @MDAT         ANDLT     @WDAT
     C                   MOVE      *ON           MATURE
     C                   ENDIF
      *
     C     MATURE        IFNE      *ON
     C     @VDAT         ANDLE     @WDAT
     C                   MOVE      *ON           ACTIVE
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *****************************************************************
      *                                                               *
      *   AVEMTH - Accumulate running totals of transaction amount    *
      *            in a period until run date but only on those       *
      *            days when transaction is active,                   *
      *            i.e.value date =< specified  date =< maturity date.*
      *            Non-working days are included in the calculation.  *
      *                                                               *
      *    Inputs:                                                    *
      * (15,0)XAMNT : Transaction amount                              *
      *       WDRCR : Today's debit/credit indicator                  *
      * (15,0)XAMNTX: Previous working day's transaction amount       *
      *       WDRCRX: Previous working day's debit/credit indicator   *
      * (2,0) MTHDAY: Day of month (01 -> 31)                         *
      * (2,0) ACUDAY: Day of month to start accumulating from         *
      * (5,0) @VDAT : 1st day active -Midas day. (Used in SR/ACTIV)   *
      * (5,0) @MDAT : Last day active -Midas day.(Used in SR/ACTIV)   *
      * (5,0) BJRDNB: Todays run date as Midas day
      *                                                               *
      *    Internal:                                                  *
      * (5,0) @WDAT : Increment of days of accumulation               *
      *                                                               *
      *    Outputs:                                                   *
      *(15,0) CUMCR : Accumulated cedit over active period in month   *
      *(15,0) CUMDR : Accumulated debit over active period in month   **
      *(15,0) AVECR : Average credit over period when active in month *
      *(15,0) AVEDR : Average credit over period when active in month *
      *    CALLED BY - PROC                                           *
      *                                                               *
      *****************************************************************
      *
      *
     C     AVEMTH        BEGSR                                                  *** SRACCU ***
      *
      *
      * If new month, initialise previous running total to zero.
     C     ACUDAY        IFEQ      1
     C                   Z-ADD     0             CUMCR
     C                   Z-ADD     0             CUMDR
     C                   ELSE
     C                   Z-ADD     CUMCRX        CUMCR
     C                   Z-ADD     CUMDRX        CUMDR
     C                   ENDIF
      *
      * Accumulate all days previous to run date using previous
      * working day's transaction amount and DR/CR indicator and
      * add to running total.
      *
     C                   Z-ADD     @ACDAT        @WDAT
     C     @WDAT         DOWLT     BJRDNB
     C                   EXSR      ACTIV
     C     ACTIVE        IFEQ      *ON
     C     WDRCRX        IFEQ      *ON
     C                   ADD       XAMNTX        CUMCR
     C                   ELSE
     C                   ADD       XAMNTX        CUMDR
     C                   ENDIF
     C                   ENDIF
      *
     C                   ADD       1             @WDAT
     C                   ENDDO
      *
      * For today, add today's amount with today's indicator
      * to the accumulated amount, if active.
      * (@WDAT should equal the run date now)
      *
     C                   EXSR      ACTIV
     C     ACTIVE        IFEQ      *ON
     C     WDRCR         IFEQ      *ON
     C                   ADD       XAMNT         CUMCR
     C                   ELSE
     C                   ADD       XAMNT         CUMDR
     C                   ENDIF
     C                   ENDIF
      *
      * Calculate average
      *
     C     CUMCR         DIV       MTHDAY        AVECR
     C     CUMDR         DIV       MTHDAY        AVEDR
      *
     C                   ENDSR
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  AVINIT -  Initialise variables for averaging procedure       *
      *                                                               *
      *    Inputs:                                                    *
      **(8)***MLACT*:*Last activity date as YYYYMMDD format           *
      **(8)***MPDNB : Prev activity date as YYYYMMDD format           *
      * (8)   MPDAT : Prev activity date as YYYYMMDD format           *
      *                                                               *
      *    internal:                                                  *
      * (2,0) PREDAY: Day of month of previous run                    *
      * (2,0) NOADAY: No. of days to accumulate over                  *
      *                                                               *
      *    Outputs:                                                   *
      * (2,0) MTHDAY: Today's day of month                            *
      * (2,0) ACUDAY: Day of month from which to start accumulating   *
      *               running total.                                  *
      *                                                               *
      *  Called By: #INIT                                             *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
      *
     C     AVINIT        BEGSR
      *
     C     *LIKE         DEFINE    *INLR         ACTIVE
     C     *LIKE         DEFINE    *INLR         MATURE
     C     *LIKE         DEFINE    *INLR         WDRCR
     C     *LIKE         DEFINE    *INLR         WDRCRX
     C                   Z-ADD     0             XAMNT            22 7
     C                   Z-ADD     0             XAMNTX           22 7
     C                   Z-ADD     0             CUMCR            22 7
     C                   Z-ADD     0             CUMDR            22 7
     C                   Z-ADD     0             AVECR            22 7
     C                   Z-ADD     0             AVEDR            22 7
     C                   Z-ADD     0             CUMCRX           22 7
     C                   Z-ADD     0             CUMDRX           22 7
     C                   Z-ADD     0             MTHDAY
     C                   Z-ADD     0             PREDAY
     C                   Z-ADD     0             ACUDAY
     C     *LIKE         DEFINE    BJRDNB        @ACDAT
     C     *LIKE         DEFINE    BJRDNB        @MDAT
     C     *LIKE         DEFINE    BJRDNB        @VDAT
     C     *LIKE         DEFINE    BJRDNB        @WDAT
      *
      ** Store day of month as a decimal
      *
     C                   MOVEL     BJMRDT        MTHDAY            2 0
      *
      ** Store last activity day of month as a decimal
      *
     C*********************MOVE MLACT     PREDAY  20
     C*********************MOVE MPDNB     PREDAY  20
     C                   MOVE      MPDAT         PREDAY            2 0
      *
      ** If previous activity day was in previous month accumulate
      ** only from beginning of month.
      *
     C     PREDAY        IFGT      MTHDAY
     C                   Z-ADD     1             ACUDAY            2 0
     C                   ELSE
     C*********************MOVE MLACT     ACUDAY
     C*********************MOVE MPDNB     ACUDAY
     C                   MOVE      PREDAY        ACUDAY
     C                   ADD       1             ACUDAY
     C                   ENDIF
      *
      ** Calculate accumulation day as Midas day.
      *
     C     MTHDAY        SUB       ACUDAY        NOADAY            2 0
     C     BJRDNB        SUB       NOADAY        @ACDAT
      *
     C                   ENDSR
      *****************************************************************
