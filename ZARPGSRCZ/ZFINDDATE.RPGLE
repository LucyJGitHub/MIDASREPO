     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('MIDAS ZA Find Date')
      *****************************************************************
      *                                                               *
      *  Midas - Midas ZA Find Date                                   *
      *                                                               *
      *  ZFINDDATE - Midas ZA Find Date                               *
      *                                                               *
      *  Function:  This program will find date as speified from the  *
      *             parameters as the nth day of the nth month.       *
      *                                                               *
      *  Called By: SD001007 - Midas SD Daylight Saving Time          *
      *                        Change Date                            *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BUG20226           Date 15Aug08               *
      *                 CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG20226 - Database error occured during "Copy" mode         *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    17         Correct Date Format                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1A
     D PInWkDay        S              2A
     D PInWkNum        S              1A
     D PInMonth        S              2A
     D PInYear         S              4A
     D PInDateFmt      S              1A
     D POutDate5       S              5S 0
     D POutDate6       S              6A
     D WkMonth         S              2S 0
     D WkDayFound      S              2S 0
     D WkDayFoundC     S              2A
     D DayNoOut        S              5P 0
     D DayNoOutCh      S              5A
     D WkDays          S              2S 0
     D*WkFndDay        S              2S 0                                                  BUG20226
     D WkFndDay        S              3S 0                                                  BUG20226
     D DateIn          S              8S 0
     D DateISO         S               D   DATFMT(*ISO)
     D WDateIn2        S              8S 0
     D WkYear          S              4S 0
     D WkCentNum       S              2S 0
     D WkYear3         S              2S 0
     D WInWkDay        S              2A
     D I               S              1P 0
     D WQ0001          S              5P 0
     D ZDATFM          S              1A
     D ZDATE           S              6P 0
     D ZADATE          S              7A
     D WDatIn          S              8P 0
     D WkInWkNum       S              1P 0
 
     D PDateIn         DS
     D  WkDateDay              1      2S 0
     D  WPInMonth              3      4S 0
     D  WkInYear               5      8S 0
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
     C                   MOVE      PInYear       WkInYear
     C                   MOVE      PInYear       WkYear
      *
      ** Using Zeller formula, month will be adjusted by 2
      ** which makes february as the 12th month
      *
     C                   SELECT
     C                   WHEN      PInMonth = '01'
     C                   Z-ADD     11            WkMonth
     C                   EVAL      WkYear   = WkInYear - 1
     C                   WHEN      PInMonth = '02'
     C                   Z-ADD     12            WkMonth
     C                   EVAL      WkYear   = WkInYear - 1
     C                   WHEN      PInMonth = '03'
     C                   Z-ADD     1             WkMonth
     C                   WHEN      PInMonth = '04'
     C                   Z-ADD     2             WkMonth
     C                   WHEN      PInMonth = '05'
     C                   Z-ADD     3             WkMonth
     C                   WHEN      PInMonth = '06'
     C                   Z-ADD     4             WkMonth
     C                   WHEN      PInMonth = '07'
     C                   Z-ADD     5             WkMonth
     C                   WHEN      PInMonth = '08'
     C                   Z-ADD     6             WkMonth
     C                   WHEN      PInMonth = '09'
     C                   Z-ADD     7             WkMonth
     C                   WHEN      PInMonth = '10'
     C                   Z-ADD     8             WkMonth
     C                   WHEN      PInMonth = '11'
     C                   Z-ADD     9             WkMonth
     C                   WHEN      PInMonth = '12'
     C                   Z-ADD     10            WkMonth
     C                   ENDSL
      *
     C                   Z-ADD     0             I
      *
      ** Break year into Century number and last 2 digits of the year
      *
     C                   MOVE      WkYear        WkYear3
     C                   MOVEL     WkYear        WkCentNum
      *
      ** Sunday is equivalent to 0 in Zeller formula
      *
     C                   EVAL      WInWkDay = PInWkDay
     C                   IF        WInWkDay = '07'
     C                   EVAL      WInWkDay = '00'
     C                   ENDIF
      *
      ** Find the nth day of the week
      *
     C                   DOW       WkDayFoundC <> WInWkDay
     C                   EVAL      I = I + 1
      *
      ** Zeller formula
      *
     C                   EVAL      WkFndDay = I
     C                             + %Div((13 * WkMonth - 1):5)
     C                             + WkYear3 + %Div(WkYear3:4)
     C                             + %Div(WkCentNum:4) - 2 * WkCentNum
      *
     C                   EVAL      WkDayfound = %Rem(WkFndDay:7)
     C                   IF        WkDayfound < 0
     C                   EVAL      WkDayfound = WkDayfound + 7
     C                   ENDIF
     C                   MOVEL     WkDayFound    WkDayFoundC
     C                   ENDDO
      *
      ** Last week of the month is equivalent to 5
      *
     C                   MOVE      PInWkNum      WkInWkNum
     C                   IF        WkInWkNum = 9
     C                   EVAL      WkInWkNum = 5
     C                   ENDIF
     C                   EVAL      WkDays = (WkInWkNum - 1) * 7
     C                   EVAL      WkDateDay = I + WkDays
     C                   MOVE      PInMonth      WPInMonth
     C                   SETON                                        17
      *
      ** Make sure day computed is within the given month
      *
     C                   DOW       *IN17 = *ON
     C                   SETOFF                                       17
     C                   MOVE      PDateIn       WDatIn
     C     *EUR          TEST(D)                 WDatIn                 17
     C                   IF        *IN17 = *ON
     C                   EVAL      WkDateDay = WkDateDay - 7
     C                   ENDIF
     C                   ENDDO
     C     *EUR          MOVE      WDatIn        DateIso
     C     *ISO          MOVE      DateIso       WDateIn2
      *
      ** Convert YYYYMMDD format to day number
      *
     C                   CALLB     'ZDATE10'
     C                   PARM      WDateIn2      DateIn
     C                   PARM      *Zero         DayNoOut
     C                   MOVE      DayNoOut      DayNoOutCh
     C                   MOVE      DayNoOutCh    POutDate5
      *
      ** Format date into DDMMMYY or MMMDDYY depending on date format
      *
     C                   CALL      'ZDATE2'
     C                   PARM      POutDate5     WQ0001
     C                   PARM      PInDateFmt    ZDATFM
     C                   PARM      *Zero         ZDATE
     C                   PARM      *BLANKS       ZADATE
     C                   MOVE      ZDATE         POutDate6
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PInWkDay
     C                   PARM                    PInWkNum
     C                   PARM                    PInMonth
     C                   PARM                    PInYear
     C                   PARM                    PInDateFmt
     C                   PARM                    POutDate5
     C                   PARM                    POutDate6
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALLB     'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
