     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Increment day number by a period value')      *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  ZFRQB3 - Increments a Day Number by a Period Value           *
      *           Determined by a Code                                *
      *                                                               *
      *  Function:  This module is created to have exactly the same   *
      *             function as ZFRQB2, except that tags are removed  *
      *             so this and ZFREQ can be used at the same time.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE064             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005  *CREATE    Date 21Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE064 - Enhancement of Lending Frequencies                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *                                                               *
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D ZFMD            S              2    DIM(12) CTDATA PERRCD(12)
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for GENERAL LEDGER details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ** Data Structure for Access Programs
      *
      /EJECT
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    ZFREQ             1
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZMDAY             2 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM                    ZZERR@            7
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     '*ERROR'      ZZERR@
     C                   ELSE
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   ELSE
     C                   MOVE      '0'           *IN98
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EXSR      ZFRQB3
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZFRQB3        BEGSR
      *
      ** Calculations to define/clear fields.
      *
     C                   MOVE      ZFREQ         ZFREQ
     C                   Z-ADD     ZDAYNO        ZDAYNO
     C                   Z-ADD     ZMDAY         ZMDAY
     C                   MOVE      ZCCY          ZCCY
     C                   MOVE      ZLOC          ZLOC
     C                   MOVE      *BLANK        ZZERR@
      *
      ** Convert day number to date
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
     C     *IN98         IFEQ      '1'
     C                   MOVEL     ZDATE         ZMTH
     C                   MOVE      ZDATE         ZZWRK4            4 0
     C                   MOVEL     ZZWRK4        ZDAY
     C                   ELSE
     C                   MOVEL     ZDATE         ZDAY
     C                   MOVE      ZDATE         ZZWRK4
     C                   MOVEL     ZZWRK4        ZMTH
     C                   ENDIF
      *
     C                   MOVE      ZDATE         ZYEAR
      *
      ** If the day number input (zmday) is zero set it equal to the
      ** day number of the start date.
      *
     C     ZMDAY         IFEQ      0
     C                   MOVEL     ZADATE        ZZWRK2            2
     C                   MOVE      ZZWRK2        ZMDAY
     C                   ENDIF
      *
     C                   MOVE      '0'           *IN90
     C                   DO
     C                   SELECT
      *
      ** D - daily wokring day
      *
     C     ZFREQ         WHENEQ    'D'
     C     ZDAYNO        ADD       1             ZDAYNO
      *
      ** W - weekly
      *
     C     ZFREQ         WHENEQ    'W'
     C     ZDAYNO        ADD       7             ZDAYNO
     C                   LEAVE
      *
      ** F - fortnightly
      *
     C     ZFREQ         WHENEQ    'F'
     C     ZDAYNO        ADD       14            ZDAYNO
     C                   LEAVE
      *
      ** S - semi-monthly
      *
     C     ZFREQ         WHENEQ    'S'
     C     ZDAY          IFLE      15
     C                   Z-ADD     31            ZDAY              2 0
     C                   ELSE
     C                   Z-ADD     15            ZDAY
     C     ZMTH          ADD       1             ZMTH              2 0
     C                   ENDIF
      *
      ** M - monthly
      *
     C     ZFREQ         WHENEQ    'M'
     C                   Z-ADD     ZMDAY         ZDAY
     C     ZMTH          ADD       1             ZMTH
      *
      ** R - six days before end of month
      *
     C     ZFREQ         WHENEQ    'R'
     C                   Z-ADD     31            ZDAY
     C     ZMTH          ADD       1             ZMTH
      *
      ** T - bimonthly
      *
     C     ZFREQ         WHENEQ    'T'
     C                   Z-ADD     ZMDAY         ZDAY
     C     ZMTH          ADD       2             ZMTH
      *
      ** Q - quarterly
      *
     C     ZFREQ         WHENEQ    'Q'
     C                   Z-ADD     ZMDAY         ZDAY
     C     ZMTH          ADD       3             ZMTH
      *
      ** X - six monthly
      *
     C     ZFREQ         WHENEQ    'X'
     C                   Z-ADD     ZMDAY         ZDAY
     C     ZMTH          ADD       6             ZMTH
      *
      ** Y - yearly
      *
     C     ZFREQ         WHENEQ    'Y'
     C                   Z-ADD     ZMDAY         ZDAY
     C     ZYEAR         ADD       1             ZYEAR             2 0
      *
      ** L - last calendar day of month
      *
     C     ZFREQ         WHENEQ    'L'
     C                   Z-ADD     31            ZDAY
     C     ZMTH          ADD       1             ZMTH
      *
      ** B - last working day of the month
      *
     C     ZFREQ         WHENEQ    'B'
     C                   Z-ADD     31            ZDAY
     C     ZMTH          ADD       1             ZMTH
      *                                                                                       CLE064
      ** If frequency = '4' for 4-monthly.                                                    CLE064
      *                                                                                       CLE064
     C     ZFREQ         WHENEQ    '4'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       4             ZMTH                                         CLE064
      *                                                                                       CLE064
      ** If frequency = '5' for 5-monthly.                                                    CLE064
      *                                                                                       CLE064
     C     ZFREQ         WHENEQ    '5'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       5             ZMTH                                         CLE064
      *                                                                                       CLE064
      ** If frequency = '7' for 7-monthly.                                                    CLE064
      *                                                                                       CLE064
     C     ZFREQ         WHENEQ    '7'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       7             ZMTH                                         CLE064
      *                                                                                       CLE064
      ** If frequency = '8' for 8-monthly.                                                    CLE064
      *                                                                                       CLE064
     C     ZFREQ         WHENEQ    '8'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       8             ZMTH                                         CLE064
      *                                                                                       CLE064
      ** If frequency = '9' for 9-monthly.                                                    CLE064
      *                                                                                       CLE064
     C     ZFREQ         WHENEQ    '9'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       9             ZMTH                                         CLE064
      *                                                                                       CLE064
      ** If frequency = 'V' for 10-monthly.                                                   CLE064
      *                                                                                       CLE064
     C     ZFREQ         WHENEQ    'V'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       10            ZMTH                                         CLE064
      *                                                                                       CLE064
      ** If frequency = 'E' for 11-monthly.                                                   CLE064
      *                                                                                       CLE064
     C     ZFREQ         WHENEQ    'E'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       11            ZMTH                                         CLE064
      *                                                                                       CLE064
      ** If frequency = 'C' for two-yearly.                                                   CLE064
      *                                                                                       CLE064
     C     ZFREQ         WHENEQ    'C'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZYEAR         ADD       2             ZYEAR                                        CLE064
      *                                                                                       CLE064
      ** If frequency = 'I' for three-yearly.                                                 CLE064
      *                                                                                       CLE064
     C     ZFREQ         WHENEQ    'I'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZYEAR         ADD       3             ZYEAR                                        CLE064
      *                                                                                       CLE064
      ** If frequency = 'J' for four-yearly.                                                  CLE064
      *                                                                                       CLE064
     C     ZFREQ         WHENEQ    'J'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZYEAR         ADD       4             ZYEAR                                        CLE064
      *                                                                                       CLE064
      ** If frequency = 'N' for five-yearly.                                                  CLE064
      *                                                                                       CLE064
     C     ZFREQ         WHENEQ    'N'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZYEAR         ADD       5             ZYEAR                                        CLE064
      *                                                                                       CLE064
      ** If frequency = 'U' for ten-yearly.                                                   CLE064
      *                                                                                       CLE064
     C     ZFREQ         WHENEQ    'U'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZYEAR         ADD       10            ZYEAR                                        CLE064
      *
      ** A - monthly accrual/profit date
      *
     C     ZFREQ         WHENEQ    'A'
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C*****SDGELR        PARM      *BLANK        DSFDY                                        CGL029
     C     SDGELR        PARM      *BLANK        DSSDY                                        CGL029
      *
     C     @RTCD         IFEQ      *BLANK
     C                   Z-ADD     BKAPDT        ZDAYNO
     C                   ELSE
     C                   MOVEL     '*ERROR'      ZZERR@
     C                   ENDIF
     C                   LEAVE
      *
     C                   ENDSL
      *
      ** Reformat date and ensure valid for non-daily frequency
      *
     C     ZFREQ         IFNE      'D'
      *
      ** Validate month
      *
     C     ZMTH          IFGT      12
     C     ZMTH          SUB       12            ZMTH
     C     ZYEAR         ADD       1             ZYEAR
     C                   ENDIF
      *
      ** Check for leap year
      *
     C     ZYEAR         DIV       4             ZLYR              2 0
     C                   MVR                     ZLY               1 0
      *
      ** Validate day number
      *
     C                   MOVE      ZFMD(ZMTH)    ZWRK2             2 0
     C     ZMTH          IFEQ      2
     C     ZLY           ANDEQ     0
     C                   Z-ADD     29            ZWRK2
     C                   ENDIF
      *
     C     ZDAY          IFGT      ZWRK2
     C                   Z-ADD     ZWRK2         ZDAY
     C                   ENDIF
      *
      ** Check if code R, to subtract 6 days
      *
     C     ZFREQ         IFEQ      'R'
     C     ZDAY          SUB       6             ZDAY
     C                   ENDIF
      *
      ** Reformat date, DDMMYY or MMDDYY, and convert to day number
      *
     C                   MOVEL     ZDAY          ZWRK4             4 0
     C                   MOVE      ZMTH          ZWRK4
     C     *IN98         IFEQ      '1'
     C                   MOVEL     ZMTH          ZWRK4
     C                   MOVE      ZDAY          ZWRK4
     C                   ENDIF
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYEAR         ZDATE
     C                   MOVE      ZDATE         ZDATIN            6
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATIN
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZERR              1
      *
     C                   ENDIF
      *
      ** Codes 'B' and 'D' to be checked for holiday
      *
     C     ZERR          IFEQ      '1'
     C     ZFREQ         ORNE      'B'
     C     ZFREQ         ANDNE     'D'
     C                   LEAVE
     C                   ENDIF
      *
     C     ZIND          DOUEQ     'W'
      *
      ** Check if holiday on currency
      *
     C                   MOVE      '0'           *IN94
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND              1
      *
      ** If a holiday, increment/decrement day number as required
      *
     C     ZIND          IFEQ      'H'
     C     ZFREQ         IFEQ      'D'
     C                   ADD       1             ZDAYNO
     C                   ELSE
     C                   SUB       1             ZDAYNO
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
