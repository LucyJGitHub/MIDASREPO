     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Calc Dayno of Next/Prev Collection Date')     *
      *****************************************************************
      *                                                               *
      *  Midas - ZFREQC ILE Module                                    *
      *                                                               *
      *  ZFREQC - Calculate Day No of Next or Previous                *
      *           Collection Date                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. AR985003           Date 06Jun12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 225342             Date 25Mar04               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR985003 - Introduced additional frequency processing        *
      *  225342 - Next collection date should be set correctly after  *
      *           the first collection date.                          *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrZFreqC    -  Calculate Next Collection Date                *
      *  SrDaily     -  Daily Processing                              *
      *  SrWeekly    -  Weekly Processing                             *
      *  SrMonthly   -  Monthly Processing                            *
      *  SrQuarterly -  Quarterly Processing                          *
      *  SrLstWrkDay -  Last Working Day Processing                   *
      *  SrFortNightly - Fortnightly Processing                       *                     AR985003
      *  SrSemiMonthly - SemiMonthly Processing                       *                     AR985003
      *  SrBiMonthly - BiMonthly Processing                           *                     AR985003
      *  SrSixMonthly -  Six Monthly Processing                       *                     AR985003
      *  SrYearly    - Yearly Processing                              *                     AR985003
      *  SrValDate   -  Validate Date                                 *
      *  SrFmtDate   -  Reformat Date                                 *
      *  SrFHChck    -  Holiday Checking                              *
      *  SrDate1     -  Convert date to day no.                       *
      *  SrDate2     -  Convert day no to date format                 *
      *  SrInit      -  Initial Processing                            *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** Purpose:
      **
      ** To calculate the day number of the next or previous collection date
      ** from current date/day in month and frequency code.
      **
      ** Input:
      **
      ** PNxtColDay - A four character field that will indicate if
      **              the proccessing will get the NEXT or get the
      **              PREVIOUS collection date.
      **
      ** PIncldTday - A one character field that indicate if TODAY is
      **              a next collection day. Used only for input cyle
      **              of computing next data collection date.
      **
      ** PzFreq     - A one character field containing the frequency code.
      **              (D W M B Q only)
      **
      ** PzDayNo    - A five digit field containing the base date
      **              (day number of current payment date.)
      **
      ** PzCcy      - A three character field containing the currency code.
      **              For processing to check a working day has been found,
      **              this currency code is used.
      **
      **
      ** PzWDay     - A three alpha field containing the day of the
      **              week (required only for frequency = W) on which
      **              payment should fall.
      **
      ** PzMDay     - A two digit field containing the day of the month
      **              (required only for frequency = M) on which
      **              payment should fall.
      **
      ** Procedure:
      **
      ** 1.   PzDayNo is converted using ZDATE2 into WrkMnth, WrkYear and
      **      WrkDay.
      **
      ** 2.   The required number of months/days is applied to
      **      to WrkMnth, WrkYear, WrkDay as appropriate.
      **
      ** 3.   ZDATE is converted using ZDATE1 into a MIDAS day number.
      **
      ** 4.   If required, the next working day after that calculated is
      **      found, using ZCHKH.
      **
      **
      ** Output:
      **
      ** PzDayNo - a five digit field containing the MIDAS day no. for the
      **           next payment date calculated.
      **
      ** PBaseDate - a five digit field containing the MIDAS day no. for the
      **             actual next payment date without considering holiday.
      **             If actual next payment date falls on a working date,
      **             then PzDayNo = PBaseDate.
      **
      ** PRetCodeIn - A 10 character field set to blanks if the module
      **              runs successfully and 'Error' if an error occurs.
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Return Code Indicator
     D  PRetCodeIn     S             10A
 
      ** Get next or previous collection day indicator.
     D  PNxtColDay     S              4A
 
      ** Include today indicator, 'Y' if today is a collection day.
     D  PIncldTday     S              1A
 
      ** Rate Change Frequency passed in as parameter from calling program
     D  PzFreq         S              1A
 
      ** MIDAS day number passed in as parameter from calling program
     D  PzDayNo        S              5  0
 
      ** Currency code passed in as parameter from calling program
     D  PzCcy          S              3A
 
      ** Day of the week passed as parameter from calling program
     D  PzWDay         S              3A
 
      ** Rate frequency day passed as parameter from calling program
     D  PzMDay         S              2  0
 
      ** Date format indicator passed as a parameter from calling program.
     D  BJDFIN         S              1A
 
      ** Base day number passed in as parameter from calling program
     D  PBaseDate      S              5  0
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Date data struture used for calculations
      ** If date format indicator is 'D' use WrkDateDS else
      ** use WrkDateDS2 to hold PzNDate temporarily, then
      ** convert it WrkDateDS for proper calculation.
     D  WrkDateDS      DS             6
     DWrkDay                   1      2  0
     DWrkMnth                  3      4  0
     DWrkYear                  5      6  0
 
     D  WrkDateDS2     DS             6
     DWrkMnth2                 1      2  0
     DWrkDay2                  3      4  0
     DWrkYear2                 5      6  0
 
      ** Array containing number of days in month.
     D  ZFMD           S              2  0 DIM(12) CTDATA PERRCD(12)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Date field passed to ZDATE1 to be converted to MIDAS day number.
     D  PzDate         S              6A
 
      ** Error flag passed back as parameter from ZDATE1. Not used in this module.
     D  PErrorFlag     S              1A
 
      ** Error flag for Midas date limitation.
     D  WLimitFlag     S              1A
 
      ** Date field returned from ZDATE2 after conversion from MIDAS day number.
     D  PZADate        S              7A
 
      ** Numerical date format after conversion from MIDAS day number from ZDATE2
     D  PZNDate        S              6  0
 
      ** Location code passed as a parameter from calling program.
     D  PzLoc          S              3A
 
      ** INCREMENTAL or DECREMENTAL variable used in module only
     D  WIncInd        S              1A
 
      ** Result of dividing WrkYear by 4 for leap year caluculations
     D  WLeapYr2       S              2  0
 
      ** Work field containg remainder of WrkYear divided by 4.
      ** Use for leap year caluculations
     D  WLeapYr1       S              1  0
 
      ** Holiday indicator pass to module from ZHCHK
     D  PzInd          S              1A
 
      ** Numeric equivalent of days of the week.
     D  WWeekDay       S              1  0
 
      ** Work field that will contain century.
     D  WrkCentury     S              2  0
 
      ** Work field used for weekly computation.
     D  WrkTmp1        S              5  0
 
      ** Work field containing calendar day number from PZADATE
     D  WrkTmp2        S              2  0
 
      ** Work field containing day value calculated from days in month array.
     D  WrkTmp3        S              2  0
 
      ** Work field containing day and month value calculated.
     D  WrkTmp4        S              4  0
 
      ** Work field for storing WrkDay.
     D  WrkTmp5        S              2  0
 
      ** Work field used to store input day.
     D  WrkTmp6        S              5  0
 
      ** Work field used in calculation for day of the week.
     D  WrkTmp7        S              5  0
 
      ** Used in *PSSR
     D @RUN            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      SrInit
 
     C                   EXSR      SrZFreqC
 
     C                   SELECT
     C                   WHEN      WLimitFlag = 'Y'
     C                   EVAL      PRetCodeIn = '*LIMIT '
 
     C                   WHEN      PErrorFlag = 'Y'
     C                   EVAL      PRetCodeIn = '*ERROR '
 
     C                   ENDSL
 
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZFreqC - Calculate Next Collection Date                    *
      *                                                               *
      *****************************************************************
 
     C     SrZFreqC      BEGSR
 
      ** Convert DAY NUMBER to DATE and place them into date data strucutre.
 
     C                   EXSR      SrDate2
 
      ** If the converted date is not a valid date, skip all processing
 
     C                   IF        PZNDate = 0
     C                   GOTO      ENDPROC
     C                   ENDIF
 
     C                   IF        *IN98 = *OFF
     C                   MOVEL     PzNDate       WrkDateDS
     C                   ELSE
     C                   MOVEL     PzNDate       WrkDateDS2
     C                   EVAL      WrkMnth = WrkMnth2
     C                   EVAL      WrkDay  = WrkDay2
     C                   EVAL      WrkYear = WrkYear2
     C                   ENDIF
 
     C                   IF        WrkYear >= 72
     C                   EVAL      WrkCentury = 19
     C                   ELSE
     C                   EVAL      WrkCentury = 20
     C                   ENDIF
 
      ** If the day number input (PzMDay) is zero set it equal to the day
      ** number of the start day.
 
     C                   IF        PzMDay = *ZERO
     C                   MOVEL     PZADate       WrkTmp2
     C                   MOVE      WrkTmp2       PzMDay
     C                   ENDIF
     C                   MOVE      *OFF          *IN90
 
      ** Do neccesary checking and increment according to PzFreq.
 
     C                   SELECT
     C                   WHEN      PzFreq = 'D'
     C                   EXSR      SrDaily
     C                   WHEN      PzFreq = 'W'
     C                   EXSR      SrWeekly
     C                   WHEN      PzFreq = 'M'
     C                   EXSR      SrMonthly
     C                   WHEN      PzFreq = 'B'
     C                             OR PzFreq = 'R'                                          AR985003
     C                             OR PzFreq = 'L'                                          AR985003
     C                   EXSR      SrLstWrkDay
     C                   WHEN      PzFreq = 'Q'
     C                   EXSR      SrQuarterly
     C                   WHEN      PzFreq = 'F'                                             AR985003
     C                   EXSR      SrFortNightly                                            AR985003
     C                   WHEN      PzFreq = 'S'                                             AR985003
     C                   EXSR      SrSemiMonthly                                            AR985003
     C                   WHEN      PzFreq = 'T'                                             AR985003
     C                   EXSR      SRBiMonthly                                              AR985003
     C                   WHEN      PzFreq = 'X'                                             AR985003
     C                   EXSR      SRSixMonthly                                             AR985003
     C                   WHEN      PzFreq = 'Y'                                             AR985003
     C                   EXSR      SRYearly                                                 AR985003
     C                   ENDSL
 
     C     ENDPROC       ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDaily - Daily Processing                                   *
      *                                                               *
      *****************************************************************
 
     C     SrDaily       BEGSR
 
     ** Get next collection date
 
     C                   IF        PNxtColDay  = 'NEXT'
 
     C                   EVAL      WIncInd = 'Y'
     C                   IF        PIncldTday <> 'Y'
     C                   EVAL      PzDayNo = PzDayNo + 1
     C                   EVAL      PBaseDate = PzdayNo
     C                   EXSR      SrFHChck
     C                   ENDIF
 
     C                   ELSE
 
     ** Get previous collection date
 
     C                   EVAL      PzDayNo = PzDayNo - 1
     C                   EVAL      PBaseDate = PzdayNo
     C                   EXSR      SrFHChck
 
      ** Validate year against Midas limitation: day number 000001 = Jan 01,1972.
 
     C                   IF        PzDayNo < 00001
     C                   EVAL      WLimitFlag = 'Y'
     C                   GOTO      EndDaily
     C                   ENDIF
 
     C                   ENDIF
 
     C     EndDaily      ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrWeekly - Weekly Processing                                 *
      *                                                               *
      *****************************************************************
 
     C     SrWeekly      BEGSR
 
      ** Determine what day of the week is WZDayNo.
 
     C     PzDayNo       DIV       7             WrkTmp7
     C                   MVR                     WWeekDay
 
      ** Since Midas Day 00001 is Saturday we can conclude the following
      ** relations:
      **     Friday    = 0
      **     Saturday  = 1
      **     Sunday    = 2
      **     Monday    = 3
      **     Tuesday   = 4
      **     Wednesday = 5
      **     Thursday  = 6
 
     C                   SELECT
     C                   WHEN      PzWDay = 'FRI'
     C                   EVAL      WrkTmp1 = PzdayNo - WWeekDay + 0
     C                   WHEN      PzWDay = 'SAT'
     C                   EVAL      WrkTmp1 = PzdayNo - WWeekDay + 1
     C                   WHEN      PzWDay = 'SUN'
     C                   EVAL      WrkTmp1 = PzdayNo - WWeekDay + 2
     C                   WHEN      PzWDay = 'MON'
     C                   EVAL      WrkTmp1 = PzdayNo - WWeekDay + 3
     C                   WHEN      PzWDay = 'TUE'
     C                   EVAL      WrkTmp1 = PzdayNo - WWeekDay + 4
     C                   WHEN      PzWDay = 'WED'
     C                   EVAL      WrkTmp1 = PzdayNo - WWeekDay + 5
     C                   WHEN      PzWDay = 'THU'
     C                   EVAL      WrkTmp1 = PzdayNo - WWeekDay + 6
     C                   OTHER
 
      ** If PzWDay is none of the above, default to day of the week of
      ** the input date.
 
     C                   EVAL      WrkTmp1 = PzdayNo
     C                   ENDSL
 
     ** Get next collection date
 
     C                   IF        PNxtColDay  = 'NEXT'
 
     C                   SELECT
     C                   WHEN      WrkTmp1 < PzDayNo
     C                   EVAL      PzDayNo = WrkTmp1 + 7
 
     C                   WHEN      WrkTmp1 > PzDayNo
     C                   EVAL      PzDayNo = WrkTmp1
 
     C                   WHEN      PIncldTday <> 'Y'
     C                   EVAL      PzDayNo = PzDayNo + 7
 
     C                   WHEN      PIncldTday = 'Y'
     C                   GOTO      EndWeekly
 
     C                   ENDSL
 
     C                   ELSE
 
     ** Get previous collection date
 
     C                   SELECT
     C                   WHEN      WrkTmp1 < PzDayNo
     C                   EVAL      PzDayNo = WrkTmp1
     C                   WHEN      WrkTmp1 >= PzDayNo
     C                   EVAL      PzDayNo = WrkTmp1 - 7
     C                   ENDSL
 
      ** Validate year against Midas limitation: day number 000001 = Jan 01,1972.
 
     C                   IF        PzDayNo < 00001
     C                   EVAL      WLimitFlag = 'Y'
     C                   GOTO      EndWeekly
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      PBaseDate = PzdayNo
     C                   EXSR      SrFHChck
 
     C     EndWeekly     ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMonthly -  Monthly Processing                              *
      *                                                               *
      *****************************************************************
 
     C     SrMonthly     BEGSR
 
     ** Get next collection date
 
     C                   IF        PNxtColDay  = 'NEXT'
 
     C                   SELECT
     C                   WHEN      PzMDay < WrkDay
     C                   EVAL      WrkDay = PzMDay
     C                   EVAL      WrkMnth = WrkMnth + 1
 
     C                   WHEN      PzMDay > WrkDay
     C                   EVAL      WrkDay = PzMDay
     C                   IF        PIncldTday <> 'Y'                                          225342
     C                   EVAL      WrkMnth = WrkMnth + 1                                      225342
     C                   ENDIF                                                                225342
 
     C                   WHEN      PIncldTday <> 'Y'
     C                   EVAL      WrkMnth = WrkMnth + 1
 
     C                   WHEN      PIncldTday = 'Y'
     C                   GOTO      EndMonthly
 
     C                   ENDSL
 
     C                   EXSR      SrValDate
     C                   EXSR      SrFmtDate
     C                   EXSR      SrFHChck
 
     C                   ELSE
 
     ** Get previous collection date
 
     C                   SELECT
     C                   WHEN      PzMDay < WrkDay
     C                   EVAL      WrkDay = PzMDay
     C                   WHEN      PzMDay >= WrkDay
     C                   EVAL      WrkDay = PzMDay
     C                   EVAL      WrkMnth = WrkMnth - 1
     C                   ENDSL
 
     C                   EXSR      SrValDate
     C                   IF        WLimitFlag = 'Y'
     C                   GOTO      EndMonthly
     C                   ENDIF
 
     C                   EXSR      SrFmtDate
     C                   EXSR      SrFHChck
 
     C                   ENDIF
 
     C     EndMonthly    ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrQuarterly -  Quarterly Processing                          *
      *                                                               *
      *****************************************************************
 
     C     SrQuarterly   BEGSR
 
     C                   IF        PIncldTday <> 'Y'
     C                   EVAL      WrkDay = PzMDay
 
     C                   IF        PNxtColDay  = 'NEXT'
     C                   EVAL      WrkMnth = WrkMnth + 3
     C                   ELSE
     C                   EVAL      WrkMnth = WrkMnth - 3
     C                   ENDIF
 
     C                   EXSR      SrValDate
     C                   IF        WLimitFlag = 'Y'
     C                   GOTO      EndQuarterly
     C                   ENDIF
 
     C                   EXSR      SrFmtDate
     C                   EXSR      SrFHChck
 
     C                   ENDIF
 
     C     EndQuarterly  ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrLstWrkDay -  Last Working Day Processing                   *
      *                                                               *
      *****************************************************************
 
     C     SrLstWrkDay   BEGSR
 
     C                   EVAL      WrkTmp5 = WrkDay
     C                   EVAL      WrkDay  = 31
     C                   IF        PzFreq = 'R'                                             AR985003
     C                   EVAL      WrkDay = WrkDay - 6                                      AR985003
     C                   ENDIF                                                              AR985003
 
     C                   IF        PNxtColDay  = 'PREV'
     C                   EVAL      WrkMnth = WrkMnth - 1
     C                   ENDIF
 
     C                   EXSR      SrValDate
     C                   IF        WLimitFlag = 'Y'
     C                   GOTO      EndLstWrkDay
     C                   ENDIF
 
      ** Check if input day is end of the month.
 
     C                   IF        WrkDay = WrkTmp5
     C                             AND PNxtColDay  = 'NEXT'
     C                             AND PIncldTday <> 'Y'
     C                   EVAL      WrkMnth = WrkMnth + 1
     C                   EXSR      SrValDate
     C                   ENDIF
 
     C                   EXSR      SrFmtDate
     C                   EXSR      SrFHChck
 
      ** Check if input day is last working day of the month.
 
     C                   IF        PzDayNo = WrkTmp6
     C                             AND PIncldTday <> 'Y'
     C                   EVAL      WrkDay  = 31
     C                   EVAL      WrkMnth = WrkMnth + 1
     C                   EXSR      SrValDate
     C                   IF        WLimitFlag = 'Y'
     C                   GOTO      EndLstWrkDay
     C                   ENDIF
 
     C                   EXSR      SrFmtDate
     C                   EXSR      SrFHChck
     C                   ENDIF
 
      ** PzDayNo should always fall on working day, hence:
 
     C                   EVAL      PBaseDate = PzDayNo
 
     C     EndLstWrkDay  ENDSR
                                                                                            AR985003
      *****************************************************************                     AR985003
      /EJECT                                                                                AR985003
      *****************************************************************                     AR985003
      *                                                               *                     AR985003
      *  SrFortNightly - Fortnightly Processing                       *                     AR985003
      *                                                               *                     AR985003
      *****************************************************************                     AR985003
                                                                                            AR985003
     C     SrFortNightly BEGSR                                                              AR985003
                                                                                            AR985003
      ** Determine what day of the week is WZDayNo.                                         AR985003
                                                                                            AR985003
     C     PzDayNo       DIV       7             WrkTmp7                                    AR985003
     C                   MVR                     WWeekDay                                   AR985003
                                                                                            AR985003
      ** Since Midas Day 00001 is Saturday we can conclude the following                    AR985003
      ** relations:                                                                         AR985003
      **     Friday    = 0                                                                  AR985003
      **     Saturday  = 1                                                                  AR985003
      **     Sunday    = 2                                                                  AR985003
      **     Monday    = 3                                                                  AR985003
      **     Tuesday   = 4                                                                  AR985003
      **     Wednesday = 5                                                                  AR985003
      **     Thursday  = 6                                                                  AR985003
                                                                                            AR985003
     C                   SELECT                                                             AR985003
     C                   WHEN      PzWDay = 'FRI'                                           AR985003
     C                   EVAL      WrkTmp1 = PzdayNo - WWeekDay + 0                         AR985003
     C                   WHEN      PzWDay = 'SAT'                                           AR985003
     C                   EVAL      WrkTmp1 = PzdayNo - WWeekDay + 1                         AR985003
     C                   WHEN      PzWDay = 'SUN'                                           AR985003
     C                   EVAL      WrkTmp1 = PzdayNo - WWeekDay + 2                         AR985003
     C                   WHEN      PzWDay = 'MON'                                           AR985003
     C                   EVAL      WrkTmp1 = PzdayNo - WWeekDay + 3                         AR985003
     C                   WHEN      PzWDay = 'TUE'                                           AR985003
     C                   EVAL      WrkTmp1 = PzdayNo - WWeekDay + 4                         AR985003
     C                   WHEN      PzWDay = 'WED'                                           AR985003
     C                   EVAL      WrkTmp1 = PzdayNo - WWeekDay + 5                         AR985003
     C                   WHEN      PzWDay = 'THU'                                           AR985003
     C                   EVAL      WrkTmp1 = PzdayNo - WWeekDay + 6                         AR985003
     C                   OTHER                                                              AR985003
                                                                                            AR985003
      ** If PzWDay is none of the above, default to day of the week of                      AR985003
      ** the input date.                                                                    AR985003
                                                                                            AR985003
     C                   EVAL      WrkTmp1 = PzdayNo                                        AR985003
     C                   ENDSL                                                              AR985003
                                                                                            AR985003
     ** Get next collection date                                                            AR985003
                                                                                            AR985003
     C                   IF        PNxtColDay  = 'NEXT'                                     AR985003
                                                                                            AR985003
     C                   SELECT                                                             AR985003
     C                   WHEN      WrkTmp1 < PzDayNo                                        AR985003
     C                   EVAL      PzDayNo = WrkTmp1 + 14                                   AR985003
                                                                                            AR985003
     C                   WHEN      WrkTmp1 > PzDayNo                                        AR985003
     C                   EVAL      PzDayNo = WrkTmp1                                        AR985003
                                                                                            AR985003
     C                   WHEN      PIncldTday <> 'Y'                                        AR985003
     C                   EVAL      PzDayNo = PzDayNo + 14                                   AR985003
                                                                                            AR985003
     C                   WHEN      PIncldTday = 'Y'                                         AR985003
     C                   GOTO      ENDFortNight                                             AR985003
                                                                                            AR985003
     C                   ENDSL                                                              AR985003
                                                                                            AR985003
     C                   ELSE                                                               AR985003
                                                                                            AR985003
     ** Get previous collection date                                                        AR985003
                                                                                            AR985003
     C                   SELECT                                                             AR985003
     C                   WHEN      WrkTmp1 < PzDayNo                                        AR985003
     C                   EVAL      PzDayNo = WrkTmp1                                        AR985003
     C                   WHEN      WrkTmp1 >= PzDayNo                                       AR985003
     C                   EVAL      PzDayNo = WrkTmp1 - 14                                   AR985003
     C                   ENDSL                                                              AR985003
                                                                                            AR985003
      ** Validate year against Midas limitation: day number 000001 = Jan 01,1972.           AR985003
                                                                                            AR985003
     C                   IF        PzDayNo < 00001                                          AR985003
     C                   EVAL      WLimitFlag = 'Y'                                         AR985003
     C                   GOTO      ENDFortNight                                             AR985003
     C                   ENDIF                                                              AR985003
                                                                                            AR985003
     C                   ENDIF                                                              AR985003
                                                                                            AR985003
     C                   EVAL      PBaseDate = PzdayNo                                      AR985003
     C                   EXSR      SrFHChck                                                 AR985003
                                                                                            AR985003
     C     ENDFortNight  ENDSR                                                              AR985003
                                                                                            AR985003
      *****************************************************************                     AR985003
      /EJECT                                                                                AR985003
      *****************************************************************                     AR985003
      *                                                               *                     AR985003
      *  SrSemiMonthly - Semi Monthly Processing                      *                     AR985003
      *                                                               *                     AR985003
      *****************************************************************                     AR985003
                                                                                            AR985003
     C     SrSemiMonthly BEGSR                                                              AR985003
                                                                                            AR985003
     ** Get next collection date                                                            AR985003
                                                                                            AR985003
     C                   IF        PNxtColDay  = 'NEXT'                                     AR985003
                                                                                            AR985003
     C                   EVAL      WIncInd = 'Y'                                            AR985003
     C                   IF        WrkDay <= 15                                             AR985003
     C                   Z-ADD     31            WrkDay                                     AR985003
     C                   ELSE                                                               AR985003
     C                   Z-ADD     15            WrkDay                                     AR985003
     C                   EVAL      WrkMnth = WrkMnth + 1                                    AR985003
     C                   ENDIF                                                              AR985003
     C                   EXSR      SrValDate                                                AR985003
     C                   EXSR      SrFmtDate                                                AR985003
     C                   EXSR      SrFHChck                                                 AR985003
                                                                                            AR985003
     C                   ELSE                                                               AR985003
                                                                                            AR985003
     ** Get previous collection date                                                        AR985003
                                                                                            AR985003
     C                   IF        WrkDay <= 15                                             AR985003
     C                   Z-ADD     31            WrkDay                                     AR985003
     C                   EVAL      WrkMnth = WrkMnth - 1                                    AR985003
     C                   ELSE                                                               AR985003
     C                   Z-ADD     15            WrkDay                                     AR985003
     C                   ENDIF                                                              AR985003
     C                   EXSR      SrValDate                                                AR985003
     C                   IF        WLimitFlag = 'Y'                                         AR985003
     C                   GOTO      ENDSemiMonth                                             AR985003
     C                   ENDIF                                                              AR985003
     C                   EXSR      SrFmtDate                                                AR985003
     C                   EXSR      SrFHChck                                                 AR985003
                                                                                            AR985003
     C                   ENDIF                                                              AR985003
                                                                                            AR985003
     C     ENDSemiMonth  ENDSR                                                              AR985003
                                                                                            AR985003
      *****************************************************************                     AR985003
      /EJECT                                                                                AR985003
      *****************************************************************                     AR985003
      *                                                               *                     AR985003
      *  SrBiMonthly - BiMonthly Processing                           *                     AR985003
      *                                                               *                     AR985003
      *****************************************************************                     AR985003
                                                                                            AR985003
     C     SrBiMonthly   BEGSR                                                              AR985003
                                                                                            AR985003
     ** Get next collection date                                                            AR985003
                                                                                            AR985003
     C                   IF        PNxtColDay  = 'NEXT'                                     AR985003
                                                                                            AR985003
     C                   SELECT                                                             AR985003
     C                   WHEN      PzMDay < WrkDay                                          AR985003
     C                   EVAL      WrkDay = PzMDay                                          AR985003
     C                   EVAL      WrkMnth = WrkMnth + 2                                    AR985003
                                                                                            AR985003
     C                   WHEN      PzMDay > WrkDay                                          AR985003
     C                   EVAL      WrkDay = PzMDay                                          AR985003
     C                   IF        PIncldTday <> 'Y'                                        AR985003
     C                   EVAL      WrkMnth = WrkMnth + 2                                    AR985003
     C                   ENDIF                                                              AR985003
                                                                                            AR985003
     C                   WHEN      PIncldTday <> 'Y'                                        AR985003
     C                   EVAL      WrkMnth = WrkMnth + 2                                    AR985003
                                                                                            AR985003
     C                   WHEN      PIncldTday = 'Y'                                         AR985003
     C                   GOTO      ENDBiMonthly                                             AR985003
                                                                                            AR985003
     C                   ENDSL                                                              AR985003
                                                                                            AR985003
     C                   EXSR      SrValDate                                                AR985003
     C                   EXSR      SrFmtDate                                                AR985003
     C                   EXSR      SrFHChck                                                 AR985003
                                                                                            AR985003
     C                   ELSE                                                               AR985003
                                                                                            AR985003
     ** Get previous collection date                                                        AR985003
                                                                                            AR985003
     C                   SELECT                                                             AR985003
     C                   WHEN      PzMDay < WrkDay                                          AR985003
     C                   EVAL      WrkDay = PzMDay                                          AR985003
     C                   WHEN      PzMDay >= WrkDay                                         AR985003
     C                   EVAL      WrkDay = PzMDay                                          AR985003
     C                   EVAL      WrkMnth = WrkMnth - 2                                    AR985003
     C                   ENDSL                                                              AR985003
                                                                                            AR985003
     C                   EXSR      SrValDate                                                AR985003
     C                   IF        WLimitFlag = 'Y'                                         AR985003
     C                   GOTO      ENDBiMonthly                                             AR985003
     C                   ENDIF                                                              AR985003
                                                                                            AR985003
     C                   EXSR      SrFmtDate                                                AR985003
     C                   EXSR      SrFHChck                                                 AR985003
                                                                                            AR985003
     C                   ENDIF                                                              AR985003
                                                                                            AR985003
     C     ENDBiMonthly  ENDSR                                                              AR985003
                                                                                            AR985003
      **********************************************************************                AR985003
      /EJECT                                                                                AR985003
      *****************************************************************                     AR985003
      *                                                               *                     AR985003
      *  SrSixMonthly -  Six Monthly Processing                       *                     AR985003
      *                                                               *                     AR985003
      *****************************************************************                     AR985003
                                                                                            AR985003
     C     SrSixMonthly  BEGSR                                                              AR985003
                                                                                            AR985003
     C                   IF        PIncldTday <> 'Y'                                        AR985003
     C                   EVAL      WrkDay = PzMDay                                          AR985003
                                                                                            AR985003
     C                   IF        PNxtColDay  = 'NEXT'                                     AR985003
     C                   EVAL      WrkMnth = WrkMnth + 6                                    AR985003
     C                   ELSE                                                               AR985003
     C                   EVAL      WrkMnth = WrkMnth - 6                                    AR985003
     C                   ENDIF                                                              AR985003
                                                                                            AR985003
     C                   EXSR      SrValDate                                                AR985003
     C                   IF        WLimitFlag = 'Y'                                         AR985003
     C                   GOTO      ENDSixMonthly                                            AR985003
     C                   ENDIF                                                              AR985003
                                                                                            AR985003
     C                   EXSR      SrFmtDate                                                AR985003
     C                   EXSR      SrFHChck                                                 AR985003
                                                                                            AR985003
     C                   ENDIF                                                              AR985003
                                                                                            AR985003
     C     ENDSixMonthly ENDSR                                                              AR985003
                                                                                            AR985003
      *****************************************************************                     AR985003
      /EJECT                                                                                AR985003
      *****************************************************************                     AR985003
      *                                                               *                     AR985003
      *  SrYearly - Yearly Processing                                 *                     AR985003
      *                                                               *                     AR985003
      *****************************************************************                     AR985003
                                                                                            AR985003
     C     SrYearly      BEGSR                                                              AR985003
                                                                                            AR985003
     C                   IF        PIncldTday <> 'Y'                                        AR985003
     C                   EVAL      WrkDay = PzMDay                                          AR985003
                                                                                            AR985003
     C                   IF        PNxtColDay  = 'NEXT'                                     AR985003
     C                   EVAL      WrkYear = WrkYear + 1                                    AR985003
     C                   ELSE                                                               AR985003
     C                   EVAL      WrkYear = WrkYear - 1                                    AR985003
     C                   ENDIF                                                              AR985003
                                                                                            AR985003
     C                   EXSR      SrValDate                                                AR985003
     C                   IF        WLimitFlag = 'Y'                                         AR985003
     C                   GOTO      EndYearly                                                AR985003
     C                   ENDIF                                                              AR985003
                                                                                            AR985003
     C                   EXSR      SrFmtDate                                                AR985003
     C                   EXSR      SrFHChck                                                 AR985003
                                                                                            AR985003
     C                   ENDIF                                                              AR985003
                                                                                            AR985003
     C     EndYearly     ENDSR                                                              AR985003
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValDate - Validate Date                                    *
      *                                                               *
      *****************************************************************
 
     C     SrValDate     BEGSR
 
      ** Validate month.
 
     C                   IF        WrkMnth > 12
     C                   EVAL      WrkMnth = WrkMnth - 12
     C                   EVAL      WrkYear = WrkYear + 1
     C                   ENDIF
 
     C                   IF        WrkMnth < 1
     C                   EVAL      WrkMnth = WrkMnth + 12
     C                   EVAL      WrkYear = WrkYear - 1
     C                   ENDIF
 
      ** Validate year.
 
     C                   IF        WrkYear = -1
     C                   EVAL      WrkYear = 99
     C                   ENDIF
 
      ** Validate year against Midas limitation: day number 000001 = Jan 01,1972.
 
     C                   IF        WrkYear < 72
     C                             AND WrkCentury = 19
     C                   EVAL      WLimitFlag = 'Y'
     C                   GOTO      EndValDate
     C                   ENDIF
 
      ** Check for leap year.
 
     C     WrkYear       DIV       4             WLeapYr2
     C                   MVR                     WLeapYr1
 
      ** Validate day number.
 
     C                   MOVE      ZFMD(WrkMnth) WrkTmp3
     C                   IF        WrkMnth = 2
     C                             AND WLeapYr1 = 0
     C                   EVAL      WrkTmp3 = 29
     C                   ENDIF
 
     C                   IF        WrkDay > WrkTmp3
     C                   EVAL      WrkDay = WrkTmp3
     C                   ENDIF
 
     C     EndValDate    ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFmtDate -  Reformat Date                                   *
      *                                                               *
      *****************************************************************
 
     C     SrFmtDate     BEGSR
 
      ** Reformat date, DDMMYY or MMDDYY, and convert to day number.
 
     C                   IF        *IN98 = *OFF
     C                   MOVEL     WrkDay        WrkTmp4
     C                   MOVE      WrkMnth       WrkTmp4
     C                   ELSE
     C                   MOVEL     WrkMnth       WrkTmp4
     C                   MOVE      WrkDay        WrkTmp4
     C                   ENDIF
     C                   MOVEL     WrkTmp4       PzDate
     C                   MOVE      WrkYear       PzDate
 
     C                   EXSR      SrDate1
     C                   EVAL      PBaseDate = PzDayNo
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFHChck -  Holiday Checking                                 *
      *                                                               *
      *****************************************************************
 
     C     SrFHChck      BEGSR
 
     C                   DOU       PzInd = 'W'
 
     C                   CALLB     'ZCHKH'
     C                   PARM                    PzDayNo
     C                   PARM                    PzCcy
     C                   PARM                    PzLoc
     C                   PARM                    PzInd
 
     C                   IF        PzInd <> 'W'
 
      ** Increment day number as required.
 
     C                   IF        WIncInd = 'Y'
     C                   EVAL      PzDayNo = PzDayNo + 1
     C                   ELSE
 
      ** Decrement if WIncInd <> 'Y'.
 
     C                   EVAL      PzDayNo = PzDayNo - 1
     C                   ENDIF
 
     C                   ENDIF
 
      ** In getting PREVIOUS collection date, if incrementation makes
      ** the output date greater than or equal to the input date,
      ** return the base date and decrement, WIncInd = 'N'.
 
     C                   IF        PzInd = 'W'
     C                             AND PNxtColDay = 'PREV'
     C                             AND PzDayNo >= WrkTmp6
     C                   EVAL      PzDayNo = PBaseDate - 1
     C                   EVAL      PzInd = 'H'
     C                   EVAL      WIncInd = 'N'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDate1 -  Convert date to day no.                           *
      *                                                               *
      *****************************************************************
 
     C     SrDate1       BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PzDate
     C                   PARM                    PzDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    PErrorFlag
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDate2 -  Convert day no to date format                     *
      *                                                               *
      *****************************************************************
 
     C     SrDate2       BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PzDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    PZNDate
     C                   PARM                    PZADate
 
     C                   ENDSR
 
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initial Processing                                  *
      *                                                               *
      *****************************************************************
 
     C     SrInit        BEGSR
 
      ** Initialised output parameter.
 
     C                   EVAL      PRetCodeIn = *BLANKS
     C                   EVAL      PBaseDate  = *ZERO
 
      ** Store input day into a variable
 
     C                   EVAL      WrkTmp6 = PzDayNo
 
      ** Initialised variables
 
     C                   EVAL      PErrorFlag  = *BLANK
     C                   EVAL      WLimitFlag  = *BLANK
     C                   EVAL      WIncInd     = 'N'
 
     C                   IF        BJDFIN  = 'D'
     C                   EVAL      *IN98 = *OFF
     C                   ELSE
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
 
      ** If PNxtColDay <> 'NEXT', default the following fields.
 
     C                   IF        PNxtColDay  <> 'NEXT'
     C                   EVAL      PNxtColDay  =  'PREV'
     C                   EVAL      PIncldTday  = 'N'
     C                   ENDIF
 
     C                   ENDSR
 
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  *PSSR - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    PRetCodeIn
     C                   PARM                    PNxtColDay
     C                   PARM                    PIncldTday
     C                   PARM                    PzFreq
     C                   PARM                    PzDayNo
     C                   PARM                    PzCcy
     C                   PARM                    PzWDay
     C                   PARM                    PzMDay
     C                   PARM                    BJDFIN
     C                   PARM                    PBaseDate
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
**  ZFMD
312831303130313130313031
