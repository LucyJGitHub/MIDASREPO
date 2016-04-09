     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Calculate Next Fixing Rate')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE009500 - Midas RE Calculate Next Fixing Rate               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD032905           Date 19Feb15               *
      *  Prev Amend No. CRE095   *CREATE   Date 25Apr14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD032905 - Array index error due to month gt 12              *
      *  CRE095 - Rate Fixing on Retail Accounts                      *
      *                                                               *
      *****************************************************************
      *                                                               *
     D PFreq           S              1
     D PDayInMonth     S              2S 0
     D PRateConv       S              2
     D PFromDate       S              5S 0
     D PLocalCcy       S              3
     D PLocCode        S              3
     D PRtCd           S              7
     D POptn           S              7
      *
     D ZWrk2           S              2  0
     D ZWrk4           S              4  0
     D ZFreq           S              1
     D ZMDay           S              2  0
     D WDayNo          S              5S 0
     D WMonth          S              2  0
     D ZRateConv       S              2
     D DBFile          S             10
     D DBase           S              3
     D DBOptn          S              7
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short Data Structure

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long Data Structure

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** Data structure for general ledger details

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for bank details

     D ZFMD            S              2  0 DIM(12) CTDATA PERRCD(12)
      *
     D/COPY ZSRSRC,ZDATE2Z1LE
     D/COPY ZSRSRC,ZHOLILE
     D/COPY ZSRSRC,ZHOLELE
      *
     C/EJECT
     C*===================================================================
      *
      ** Convert day number to date format
      *
     C                   EXSR      ZDATE2
      *
      ** If the day number input (ZMDay) is zero set it equal to the
      ** day number of the start date.
      *
     C     ZMDay         IFEQ      0
     C                   EVAL      ZMDay = ZDay
     C                   END
      *
     C                   SELECT
      *
      ** D - Daily working day
      *
     C     ZFreq         WHENEQ    'D'
     C                   ADD       1             ZDay
      *
      ** W - Weekly
      *
     C     ZFreq         WHENEQ    'W'
     C                   ADD       7             ZDay
      *
      ** F - Fortnightly
      *
     C     ZFreq         WHENEQ    'F'
     C                   ADD       14            ZDay
      *
      ** S - Semi-Monthly
      *
     C     ZFreq         WHENEQ    'S'
     C     ZDay          IFLE      15
     C                   Z-ADD     31            ZDay
     C                   ELSE
     C                   Z-ADD     15            ZDay
     C     ZMth          ADD       1             ZMth
     C                   ENDIF
      *
      ** M - Monthly
      *
     C     ZFreq         WHENEQ    'M'
     C                   Z-ADD     ZMDay         ZDay
     C     ZMth          ADD       1             ZMth
      *
      ** R - Six days before end of month
      *
     C     ZFreq         WHENEQ    'R'
     C                   Z-ADD     31            ZDay
     C     ZMth          ADD       1             ZMth
      *
      ** T - Bimonthly
      *
     C     ZFreq         WHENEQ    'T'
     C                   Z-ADD     ZMDay         ZDay
     C     ZMth          ADD       2             ZMth
      *
      ** Q - Quarterly
      *
     C     ZFreq         WHENEQ    'Q'
     C                   Z-ADD     ZMDay         ZDay
     C     ZMth          ADD       3             ZMth
      *
      ** X - Six Monthly
      *
     C     ZFreq         WHENEQ    'X'
     C                   Z-ADD     ZMDay         ZDay
     C     ZMth          ADD       6             ZMth
      *
      ** Y - Yearly
      *
     C     ZFreq         WHENEQ    'Y'
     C                   Z-ADD     ZMDay         ZDay
     C     ZYear         ADD       1             ZYear
      *
      ** L - Last calendar day of month
      *
     C     ZFreq         WHENEQ    'L'
     C                   Z-ADD     31            ZDay
     C     ZMth          ADD       1             ZMth
      *
      ** B - Last working day of the month
      *
     C     ZFreq         WHENEQ    'B'
     C                   Z-ADD     31            ZDay
     C     ZMth          ADD       1             ZMth
      *
      ** If frequency = '4' for 4-monthly.
      *
     C     ZFreq         WHENEQ    '4'
     C                   Z-ADD     ZMDay         ZDay
     C     ZMth          ADD       4             ZMth
      *
      ** If frequency = '5' for 5-monthly.
      *
     C     ZFreq         WHENEQ    '5'
     C                   Z-ADD     ZMDay         ZDay
     C     ZMth          ADD       5             ZMth
      *
      ** If frequency = '7' for 7-monthly.
      *
     C     ZFreq         WHENEQ    '7'
     C                   Z-ADD     ZMDay         ZDay
     C     ZMth          ADD       7             ZMth
      *
      ** If frequency = '8' for 8-monthly.
      *
     C     ZFreq         WHENEQ    '8'
     C                   Z-ADD     ZMDay         ZDay
     C     ZMth          ADD       8             ZMth
      *
      ** If frequency = '9' for 9-monthly.
      *
     C     ZFreq         WHENEQ    '9'
     C                   Z-ADD     ZMDay         ZDay
     C     ZMth          ADD       9             ZMth
      *
      ** If frequency = 'V' for 10-monthly.
      *
     C     ZFreq         WHENEQ    'V'
     C                   Z-ADD     ZMDay         ZDay
     C     ZMth          ADD       10            ZMth
      *
      ** If frequency = 'E' for 11-monthly.
      *
     C     ZFreq         WHENEQ    'E'
     C                   Z-ADD     ZMDay         ZDay
     C     ZMth          ADD       11            ZMth
      *
      ** If frequency = 'C' for two-yearly.
      *
     C     ZFreq         WHENEQ    'C'
     C                   Z-ADD     ZMDay         ZDay
     C     ZYear         ADD       2             ZYear
      *
      ** If frequency = 'I' for three-yearly.
      *
     C     ZFreq         WHENEQ    'I'
     C                   Z-ADD     ZMDay         ZDay
     C     ZYear         ADD       3             ZYear
      *
      ** If frequency = 'J' for four-yearly.
      *
     C     ZFreq         WHENEQ    'J'
     C                   Z-ADD     ZMDay         ZDay
     C     ZYear         ADD       4             ZYear
      *
      ** If frequency = 'N' for five-yearly.
      *
     C     ZFreq         WHENEQ    'N'
     C                   Z-ADD     ZMDay         ZDay
     C     ZYear         ADD       5             ZYear
      *
      ** If frequency = 'U' for ten-yearly.
      *
     C     ZFreq         WHENEQ    'U'
     C                   Z-ADD     ZMDay         ZDay
     C     ZYear         ADD       10            ZYear
      *
      ** A - Monthly accrual/profit date
      *
     C     ZFreq         WHENEQ    'A'
     C                   CALL      'AOGELRR0'
     C                   PARM      *BLANK        PRtCd
     C                   PARM      '*FIRST'      POptn
     C     SDGELR        PARM      *BLANK        DSFDY
      *
     C     PRtCd         IFEQ      *BLANK
     C                   Z-ADD     BKAPDT        ZDayNo
     C                   EXSR      ZDATE2
     C                   ELSE
     C                   MOVEL     'SDGELRPD'    DBFile                          *************
     C                   MOVEL     '002'         DBase                           *DBERROR 002*
     C                   MOVEL     POptn         DBOptn                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSL
      *
      ** Validate month                                                          MD032905
      *                                                                          MD032095
     C     ZMth          IFGT      12                                            MD032095
     C                   SUB       12            ZMth                            MD032905
     C                   ADD       1             ZYear                           MD032905
     C                   ENDIF                                                   MD032905
      *
      ** Check for leap year
      *
     C     ZYear         DIV       4             ZLYR
     C                   MVR                     ZLY               1 0
      *
      ** Validate day number
      *
     C                   MOVE      ZFMD(ZMth)    ZWRK2
     C     ZMth          IFEQ      2
     C     ZLY           ANDEQ     0
     C                   Z-ADD     29            ZWRK2
     C                   ENDIF
      *
      ** Reformat date and ensure valid
      *
     C     ZDay          IFGT      ZWRK2
      *
     C     ZFreq         IFEQ      'D'
     C     ZFreq         OREQ      'W'
     C     ZFreq         OREQ      'F'
     C                   SUB       ZWRK2         ZDay
     C                   ADD       1             ZMth
     C                   ELSE
     C                   Z-ADD     ZWRK2         ZDay
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ZMth          IFGT      12
     C                   SUB       12            ZMth
     C                   ADD       1             ZYear
     C                   ENDIF
      *
      ** Check if code R, to subtract 6 days
      *
     C     ZFreq         IFEQ      'R'
     C     ZDay          SUB       6             ZDay
     C                   ENDIF
      *
      ** Reformat date, DDMMYY or MMDDYY, and convert to day number
      *
     C                   MOVEL     ZDay          ZWRK4
     C                   MOVE      ZMth          ZWRK4
     C     *IN98         IFEQ      '1'
     C                   MOVEL     ZMth          ZWRK4
     C                   MOVE      ZDay          ZWRK4
     C                   ENDIF
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYear         ZDATE
     C                   EXSR      ZDATE1
      *
      ** All frequencies to be checked for holiday if rate change
      ** convention is not BLANK, or frequency = 'B' or 'D' and
      ** rate change convention is BLANK
      *
     C     *IN99         IFEQ      '0'                                          - B1
     C     ZRateConv     ANDNE     *BLANKS
     C     *IN99         OREQ      '0'
     C     ZFreq         ANDEQ     'B'
     C     *IN99         OREQ      '0'
     C     ZFreq         ANDEQ     'D'
      *
     C                   EVAL      WMonth = ZMth
     C                   EVAL      WDayNo = ZDayno
      *
     C     ZInd          DOUEQ     'W'                                          - B2
      *
      ** Check if holiday on currency
      *
     C                   EXSR      ZCHKH
      *
      ** If a holiday, increment/decrement day number as required
      *
     C     ZInd          IFEQ      'H'                                          - B3
      *
     C     ZRateConv     IFEQ      *BLANKS                                      - B4
      *
     C     ZFreq         IFEQ      'D'
     C                   ADD       1             ZDayNo
     C                   ELSE
     C                   SUB       1             ZDayNo
     C                   ENDIF
      *
     C                   ELSE                                                   - X4
      *
     C                   SELECT
      *
     C     ZRateConv     WHENEQ    'P'
     C                   SUB       1             ZDayNo
      *
     C     ZRateConv     WHENEQ    'F'
     C                   ADD       1             ZDayNo
      *
     C     ZRateConv     WHENEQ    'MP'
     C                   SUB       1             ZDayNo
     C                   EXSR      ZDATE2
     C     ZMth          IFNE      WMonth
     C                   EVAL      ZRateConv = 'F'
     C                   EVAL      ZDayNo = WDayNo
     C                   ADD       1             ZDayNo
     C                   ENDIF
      *
     C     ZRateConv     WHENEQ    'MF'
     C                   ADD       1             ZDayNo
     C                   EXSR      ZDATE2
     C     ZMth          IFNE      WMonth
     C                   EVAL      ZRateConv = 'P'
     C                   EVAL      ZDayNo = WDayNo
     C                   SUB       1             ZDayNo
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDIF                                                  - E4
      *
     C                   ENDIF                                                  - E3
      *
     C                   ENDDO                                                  - E2
      *
     C                   ENDIF                                                  - E1
      *
      ** Return new date
      *
     C                   EVAL      PFromDate = ZDayNo
      *
     C                   SETON                                        LR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFreq
     C                   PARM                    PDayInMonth
     C                   PARM                    PRateConv
     C                   PARM                    PFromDate
     C                   PARM                    PLocalCcy
     C                   PARM                    PLocCode
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    PRtCd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRtCd         IFEQ      *BLANKS
     C     BJDFIN        COMP      'M'                                    98
     C                   ELSE
     C                   MOVEL     'SDBANKPD'    DBFile                          *************
     C                   MOVEL     '001'         DBase                           *DBERROR 001*
     C                   MOVEL     POptn         DBOptn                          *************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      ZFreq = PFreq
     C                   EVAL      ZMDay = PDayInMonth
     C                   EVAL      ZRateConv = PRateConv
     C                   EVAL      ZDayNo = PFromDate
     C                   EVAL      ZCCY = PLocalCcy
     C                   EVAL      ZLOC = PLocCode
      *
     C                   ENDSR
      *
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *                                                                   *
      * Called by:                                                        *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
      *
     C/COPY ZSRSRC,ZDATE2Z2LE
     C/COPY ZSRSRC,ZDATE1Z2LE
     C/COPY ZSRSRC,ZCHKHLE
     C/COPY ZSRSRC,ZACCHLE
      *
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
