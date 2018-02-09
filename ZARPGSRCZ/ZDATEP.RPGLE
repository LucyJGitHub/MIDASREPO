     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('ST Daynumber Conversion Subroutine')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subprograms                                 *
      *                                                               *
      *  ZDATEP - Calculate Date from Day Number                      *
      *                                                               *
      *  Function:  This Program is the ILE Conversion of ZDATEP in   *
      *             Midas Release 4.01,this is being used in Copybook *
      *             RTINTRE                                           *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER016  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
     D ZDayNo          S              5  0
     D ZDate           S              6  0
     D ZError          S              2  0
      *
     D ZDayN1          S              5  0
     D ZLYr            S              4  0
     D ZWk1            S              2  0
     D ZWk2            S              2  0
      *
      ****************************************************************
      * Start of Main processing                                     *
      ****************************************************************
      *
      **   Entry Point - Set up Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    ZDayNo
     C                   PARM                    ZDate
     C                   PARM                    ZError
      *
     C                   SETOFF                                         9899
     C                   EVAL      ZDayN1 = ZDayNo
      *
      **   Reset Error Indicator
      *
     C                   EVAL      ZError = 0
      *
      ** Test for invalid low values of ZDayN1
      *
     C                   IF        ZDayN1 < 1
     C                   EVAL      ZError = 1
     C                   GOTO      ZEND
     C                   ENDIF
      *
      ** Test for invalid High values of ZDayN1
      *
     C                   IF        ZDayN1 > 36525
     C                   EVAL      ZError = 2
     C                   GOTO      ZEND
     C                   ENDIF
      *
      ** Adjust Day Number incase last Day of the Year
      *
     C                   EVAL      ZDayN1 = ZDayN1 - 1
      *
      ** Calculate Number of 4 Year Spans since 31st Dec 1971
      *
     C     ZDayN1        DIV       1461          ZLYr
      *
      ** Calculate Number of remaining Years
      *
     C                   MVR                     ZDayN1
      *
      ** Calculate Actual Year number
      *
     C                   EVAL      ZDate = ZLYr * 4
     C                   EVAL      ZDate = ZDate + 72
     C                   MOVE      ZDate         ZWk1
     C                   EVAL      ZDate = ZWk1
     C                   EVAL      ZWk2 = 1
      *
     C                   DOW       ZDayN1 >= ZYDY(ZWk2)
     C                   EVAL      ZWk2 = ZWk2 + 1
     C                   ENDDO
      *
     C                   SUB       1             ZWk2
     C                   EVAL      ZDate = ZDate + ZWk2
      *
     C                   IF        ZWk2 <> 0
      *
      ** Decrement day no. by days in remaining years
      *
     C                   SUB       ZYDY(ZWk2)    ZDayN1
     C                   ELSE
      *
      ** Adjust day no. in case last day of Leap year February
      *
     C     ZDayN1        COMP      59                                     99
      *
     C                   IF        ZDayN1 >= 59
     C                   EVAL      ZDayN1 = ZDayN1 - 1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EVAL      ZWk2 = 2
      *
      **   Calculate Month number
      *
     C                   DOW       ZDayN1 >= ZMDY(ZWk2)
     C                   EVAL      ZWk2 = ZWk2 + 1
     C                   ENDDO
      *
     C                   EVAL      ZWk2 = ZWk2 - 1
     C                   EVAL      ZLYr = ZWk2 * 100
      *
      ** Add back last day of year Adjustment
      *
     C                   EVAL      ZDayN1 = ZDayN1 + 1
     C                   EVAL      ZWk2 = ZDayN1 - ZMDY(ZWk2)
     C   99              ADD       1             ZWk2
      *
      **   Format Date
     C                   EVAL      ZDate = ZDate + ZLYr
     C                   MOVEL     ZWk2          ZDate
      *
     C     ZEND          TAG
     C                   RETURN
      *
      *****************************************************************
** ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
** ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
