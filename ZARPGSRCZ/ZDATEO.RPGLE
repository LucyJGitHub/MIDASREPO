     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Convert Date (DDMMYY/MMDDYY) to Midas Dayno.')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subprograms                                 *
      *                                                               *
      *  ZDATEO - Calculate Day Number from Date                      *
      *                                                               *
      *  Function:  This Program is the ILE Conversion of ZDATEO in   *
      *             Midas Release 4.01,this is being used in Copybook *
      *             RTINTRE                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER016  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016 - German Interest Calculation: Upgarde of FGE059      *
      *           to Midas Plus                                       *
      *                                                               *
      *****************************************************************
      *
      ** Months in Days Cumulative through Year
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)
      *
      ** Years in Days Cumulative, Four Year Span
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)
      *
      ** Entry Parameters
     D ZDate           S              6  0
     D ZDayNo          S              5  0
     D ZError          S              2  0
      *
     D ZLYr            S              2  0
     D ZLY             S              2  0
     D ZWk4            S              4  0
      *
      **  Data Structure
     D                 DS
     DRest                     1      6  0
     DZDay                     1      2  0
     DZMth                     3      4  0
     DZYear                    5      6  0
      *
      ****************************************************************
      *                                                              *
      ** Start of Main processing                                    *
      *                                                              *
      ****************************************************************
      *
      **   Entry Point - Set up Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    ZDate
     C                   PARM                    ZDayNo
     C                   PARM                    ZError
      *
      ** Reset Error Indicator
      *
     C                   EVAL      ZError = 0
      *
      ** Set uo separate Day; Month; Year values
      *
     C                   MOVE      ZDate         Rest
     C                   MOVE      ZDate         ZWk4
      *
      ** Test for invalid low values of Month
      *
     C                   IF        ZMth < 1
     C                   EVAL      ZError = 1
     C                   GOTO      ZEND
     C                   ENDIF
      *
      ** Test for invalid High values of Month
      *
     C                   IF        ZMth > 12
     C                   EVAL      ZError = 2
     C                   GOTO      ZEND
     C                   ENDIF
      *
      ** Error if too many Days in Month
      *
     C                   IF        (ZMth = 4 OR
     C                             ZMth = 6 OR
     C                             ZMth = 9 OR
     C                             ZMth = 11 ) AND
     C                             ZDay > 30
     C                   EVAL      ZError = 3
      *
     C                   GOTO      ZEND
     C                   ENDIF
      *
      ** Adjust for start of Day count in 1972
      *
     C                   EVAL      ZWk4 = ZYear + 28
     c                   MOVE      ZWk4          ZYear
      *
      ** Test for Existance of Leap Year
      *
     C     ZYear         DIV       4             ZLYr
      *
      ** Calculate Number of remaining Years
      *
     C                   MVR                     ZLY
      *
      ** Test for more than 28 Days in February
      *
     C                   IF        ZLY <> 0 AND ZMth = 2 AND
     C                             ZDay > 28
     C                   EVAL      ZError = 3
      *
     C                   GOTO      ZEND
     C                   ENDIF
      *
      ** Test for more than 29 Days in February in Leap Year
      *
     C                   IF        ZLY = 0 AND ZMth = 2 AND
     C                             ZDay > 29
     C                   EVAL      ZError = 3
      *
     C                   GOTO      ZEND
     C                   ENDIF
      *
      ** Otherwise check for more than 31 Days in Month
      *
     C                   IF        ZDay > 31
     C                   EVAL      ZError = 3
      *
     C                   GOTO      ZEND
     C                   ENDIF
      *
      ** Error if less than 1 Day in Month
      *
     C                   IF        ZDay < 1
     C                   EVAL      ZError = 4
      *
     C                   GOTO      ZEND
     C                   ENDIF
      *
      ** Calculate Day Number
      *
     C                   EVAL      ZDayNo = ZLYr * 1461
     C                   IF        ZLY <> 0
     C                   EVAL      ZDayNo = ZDayNo + ZYDY(ZLY)
     C                   ENDIF
      *
      ** Allow for Leap Year after February
      *
     C                   IF        ZLY = 0 AND ZMth > 2
     C                   EVAL      ZDayNo = ZDayNo + 1
     C                   ENDIF
      *
     C                   EVAL      ZDayNo = ZDayNo + ZMDY(ZMth)
     C                   EVAL      ZDayNo = ZDayNo + ZDay
      *
     C     ZEND          TAG
     C                   RETURN
      *
      *****************************************************************
** ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
** ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
