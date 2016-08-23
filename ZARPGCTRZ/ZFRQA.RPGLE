     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Increment day number by a set period')        *
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZFRQA   -   Increment day number by a set period             *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZFRQA         *
      *  subroutine.  The subroutine consists of one /COPY member.    *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).  The   *
      *  existing code has not been changed except to remove dead     *
      *  lines, and the boundaries of the original /COPY members have *
      *  been marked, to facilitate future maintenance of both the    *
      *  old members and this one.  If this member has to change, the *
      *  change should ALMOST CERTAINLY be implemented by changing    *
      *  the old /COPY member, reconverting it using CVTRPGSRC, and   *
      *  copying it into this member, replacing the existing section. *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CLE064             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004  *CREATE    Date 13Oct98               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE064 - Enhancement of Lending Frequencies                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP004 - APIs phase 3.                                       *
      *                                                               *
      *****************************************************************
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
 
      ** +--- The converted ZFRQAZ1 starts here -------------------------+
     D ZFMD            S              2    DIM(12) CTDATA PERRCD(12)            ZFREQ SR. ARRAY
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ** +--- The converted ZFRQAZ1 ends here ---------------------------+
 
      * Set indicator 98 from BJDFIN
 
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ELSE
     C                   SETOFF                                       98
     C                   END
 
      ** Execute the standard subroutine
     C                   EXSR      ZFRQA
 
     C                   RETURN
      /EJECT
 
      ** +--- The converted ZFRQAZ2 starts here --------------------------+
     C********************************************************************
     C**
     C**   ZFRQA-SR. TO INCREMENT A DAY NUMBER DATE BY A
     C**             PERIOD VALUE DETERMINED BY A CODE.
     C**                                                                  S01194
     C**
     C     ZFRQA         BEGSR                                                  *** ZFRQA ****
     C**
     C**   CALCULATIONS TO DEFINE/CLEAR FIELDS.
     C                   MOVE      ZFREQ         ZFREQ             1
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C                   Z-ADD     ZMDAY         ZMDAY             2 0
     C                   MOVE      ZCCY          ZCCY              3
     C                   MOVE      ZLOC          ZLOC              3                           S0119
     C                   MOVE      *BLANK        ZZERR@            7
     C**
     C**
     C**   CONVERT DAY NUMBER TO DATE.
     C                   EXSR      ZDATE2
      *                                                                   S01117
      ** If the day number input (zmday ) is zero set it equal to the     S01117
      ** day number of the start date.                                    S01117
      *                                                                   S01117
     C     ZMDAY         IFEQ      0                                                           S0111
     C*                                                                   S01117
     C                   MOVEL     ZADATE        ZZWRK2            2                           S0111
     C                   MOVE      ZZWRK2        ZMDAY                                         S0111
     C*                                                                   S01117
     C                   END                                                                   S0111
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE D-DAILY-WORKING DAY.
     C     ZFREQ         IFEQ      'D'
     C     ZDAYNO        ADD       1             ZDAYNO
     C                   GOTO      ZFHCHK
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE W-WEEKLY.
     C     ZFREQ         IFEQ      'W'
     C     ZDAYNO        ADD       7             ZDAYNO
     C                   GOTO      ZFEND
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE F-FORTNIGHTLY.
     C     ZFREQ         IFEQ      'F'
     C     ZDAYNO        ADD       14            ZDAYNO
     C                   GOTO      ZFEND
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE S-SEMI-MONTHLY.
     C     ZFREQ         IFEQ      'S'
     C     ZDAY          IFLE      15
     C                   Z-ADD     31            ZDAY
     C                   ELSE
     C                   Z-ADD     15            ZDAY
     C     ZMTH          ADD       1             ZMTH
     C                   END
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE M-MONTHLY.
     C     ZFREQ         IFEQ      'M'
     C                   Z-ADD     ZMDAY         ZDAY
     C     ZMTH          ADD       1             ZMTH
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE R-SIX DAYS BEFORE END OF MONTH
     C     ZFREQ         IFEQ      'R'
     C                   Z-ADD     31            ZDAY
     C     ZMTH          ADD       1             ZMTH
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE T-BIMONTHLY.
     C     ZFREQ         IFEQ      'T'
     C                   Z-ADD     ZMDAY         ZDAY
     C     ZMTH          ADD       2             ZMTH
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE Q-QUARTERLY.
     C     ZFREQ         IFEQ      'Q'
     C                   Z-ADD     ZMDAY         ZDAY
     C     ZMTH          ADD       3             ZMTH
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE X-SIX MONTHLY.
     C     ZFREQ         IFEQ      'X'
     C                   Z-ADD     ZMDAY         ZDAY
     C     ZMTH          ADD       6             ZMTH
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE Y-YEARLY.
     C     ZFREQ         IFEQ      'Y'
     C                   Z-ADD     ZMDAY         ZDAY
     C     ZYEAR         ADD       1             ZYEAR
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE L-LAST CALENDAR DAY OF MONTH.
     C     ZFREQ         IFEQ      'L'
     C                   Z-ADD     31            ZDAY
     C     ZMTH          ADD       1             ZMTH
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE B-LAST WORKING DAY OF MONTH.
     C     ZFREQ         IFEQ      'B'
     C                   Z-ADD     31            ZDAY
     C     ZMTH          ADD       1             ZMTH
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE P-PENULT. WORK/DAY OF MONTH
     C     ZFREQ         IFEQ      'P'
     C                   Z-ADD     31            ZDAY
     C     ZMTH          ADD       1             ZMTH
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE K-PENULT. WORK/DAY OF QUARTER
     C     ZFREQ         IFEQ      'K'
     C                   Z-ADD     31            ZDAY
     C     ZMTH          ADD       3             ZMTH
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE H-PENULT. WORK/DAY OF HLF YR.
     C     ZFREQ         IFEQ      'H'
     C                   Z-ADD     31            ZDAY
     C     ZMTH          ADD       6             ZMTH
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE G-PENULT. WORK/DAY OF YEAR
     C     ZFREQ         IFEQ      'G'
     C                   Z-ADD     31            ZDAY
     C     ZYEAR         ADD       1             ZYEAR
     C                   END
      *                                                                                       CLE064
      ** If frequency = '4' for 4-monthly.                                                    CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      '4'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       4             ZMTH                                         CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = '5' for 5-monthly.                                                    CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      '5'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       5             ZMTH                                         CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = '7' for 7-monthly.                                                    CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      '7'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       7             ZMTH                                         CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = '8' for 8-monthly.                                                    CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      '8'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       8             ZMTH                                         CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = '9' for 9-monthly.                                                    CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      '9'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       9             ZMTH                                         CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = 'V' for 10-monthly.                                                   CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      'V'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       10            ZMTH                                         CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = 'E' for 11-monthly.                                                   CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      'E'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZMTH          ADD       11            ZMTH                                         CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = 'C' for two-yearly.                                                   CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      'C'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZYEAR         ADD       2             ZYEAR                                        CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = 'I' for three-yearly.                                                 CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      'I'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZYEAR         ADD       3             ZYEAR                                        CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = 'J' for four-yearly.                                                  CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      'J'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZYEAR         ADD       4             ZYEAR                                        CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = 'N' for five-yearly.                                                  CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      'N'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZYEAR         ADD       5             ZYEAR                                        CLE064
     C                   ENDIF                                                                CLE064
      *                                                                                       CLE064
      ** If frequency = 'U' for ten-yearly.                                                   CLE064
      *                                                                                       CLE064
     C     ZFREQ         IFEQ      'U'                                                        CLE064
     C                   Z-ADD     ZMDAY         ZDAY                                         CLE064
     C     ZYEAR         ADD       10            ZYEAR                                        CLE064
     C                   ENDIF                                                                CLE064
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE A-MONTHLY ACCRUAL/PROFIT DATE.
     C     ZFREQ         IFEQ      'A'
     C**********         CALL      'AOGELRR0'                                     <G/LD S0119 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANK        P@AORC            7              B:Return codeS0119
     C                   PARM      '*FIRST'      P@OPTN            7              I:Option     S0119
     C*****SDGELR        PARM      *BLANK        DSFDY                            O:Rec S0119 CGL029
     C     SDGELR        PARM      *BLANK        DSSDY                                        CGL029
     C     P@AORC        IFEQ      *BLANK                                                      S0119
     C                   Z-ADD     BKAPDT        ZDAYNO                                        S0119
     C                   ELSE
     C                   MOVEL     '*ERROR'      ZZERR@
     C                   END                                                                   S0119
     C                   GOTO      ZFEND
     C                   END
     C**
     C**   REFORMAT DATE AND ENSURE VALID.
     C**
     C**   VALIDATE MONTH.
     C     ZMTH          IFGT      12
     C     ZMTH          SUB       12            ZMTH
     C     ZYEAR         ADD       1             ZYEAR
     C                   END
     C**
     C**   CHECK FOR LEAP YEAR.
     C     ZYEAR         DIV       4             ZLYR              2 0
     C                   MVR                     ZLY               1 0
     C**
     C**   VALIDATE DAY NUMBER.
     C                   MOVE      ZFMD(ZMTH)    ZWRK2             2 0
     C     ZMTH          IFEQ      2
     C     ZLY           ANDEQ     0
     C                   Z-ADD     29            ZWRK2
     C                   END
     C**
     C     ZDAY          IFGT      ZWRK2
     C                   Z-ADD     ZWRK2         ZDAY
     C                   END
     C**
     C**   CHECK IF CODE R, TO SUBTRACT 6 DAYS.
     C     ZFREQ         IFEQ      'R'
     C     ZDAY          SUB       6             ZDAY
     C                   END
     C**
     C**   REFORMAT DATE, DDMMYY OR MMDDYY, AND CONVERT TO DAY NUMBER.
     C                   MOVEL     ZDAY          ZWRK4             4 0
     C                   MOVE      ZMTH          ZWRK4
     C   98              MOVEL     ZMTH          ZWRK4
     C   98              MOVE      ZDAY          ZWRK4
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYEAR         ZDATE
     C                   EXSR      ZDATE1
     C**   RESET IND. 90 - USED TO ENSURE SUBTRACTION FOR CODES P,K,H,G,
     C**   IS ONLY DONE ONCE.
     C                   SETOFF                                       90
     C**
     C**   CHECK IF CODE B,TO BE CHECKED FOR HOLIDAY.
     C     ZFREQ         COMP      'B'                                    91
     C**   CODES P,K,H,G, ALSO TO BE CHECKED FOR HOLIDAY
     C  N91ZFREQ         COMP      'P'                                    91
     C  N91ZFREQ         COMP      'K'                                    91
     C  N91ZFREQ         COMP      'H'                                    91
     C  N91ZFREQ         COMP      'G'                                    91
     C   91
     CANN99              GOTO      ZFHCHK
     C**
     C                   GOTO      ZFEND
     C**
     C**   CHECK IF DAY NUMBER IS A HOLIDAY.
     C     ZFHCHK        TAG                                                    ** ZFHCHK TAG *
     C                   SETOFF                                       94
     C**
     C**   DETERMINE CODE.
     C     ZFREQ         COMP      'D'                                    91
     C     ZFREQ         COMP      'B'                                    92
     C  N92ZFREQ         COMP      'P'                                    92
     C  N92ZFREQ         COMP      'K'                                    92
     C  N92ZFREQ         COMP      'H'                                    92
     C  N92ZFREQ         COMP      'G'                                    92
     C**
     C**   CHECK IF CURRENCY ON HOLIDAY.
     C                   EXSR      ZCHKH                                                       S0119
     C**
     C**   BYPASS IF NOT HOLIDAY FOR CURRENCY.
     C     ZIND          CABEQ     'W'           ZPNCHK                                        S0119
     C**
     C**   INCREMENT OR DECREMENT DAY NUMBER AS REQUIRED.
     C   91ZDAYNO        ADD       1             ZDAYNO                         INCREMENT      S0119
     C**
     C   92ZDAYNO        SUB       1             ZDAYNO                         DECREMENT      S0119
     C                   GOTO      ZFHCHK
     C**
     C     ZPNCHK        TAG                                                    ** ZPNCHK TAG*
     C**   FOR CODES REQUIRING PENULTIMATE WORKING DAY (P,K,H,G) SUBTRACT
     C**   ONE AND CHECK THIS FOR HOLIDAY.
     C   90              GOTO      ZFEND                                        ALREADY DONE
     C**
     C     ZFREQ         COMP      'P'                                    92
     C  N92ZFREQ         COMP      'K'                                    92
     C  N92ZFREQ         COMP      'H'                                    92
     C  N92ZFREQ         COMP      'G'                                    92
     C  N92              GOTO      ZFEND
     C     ZDAYNO        SUB       1             ZDAYNO
     C                   SETON                                        90
     C                   GOTO      ZFHCHK
     C     ZFEND         ENDSR
     C**
     C********************************************************************
      ** +--- The converted ZFRQAZ2 ends here ----------------------------+
 
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZFRQA in this module executes another standard subroutine,       *
      *   ZDATE1, which has also been converted to a module.               *
      *  This subroutine is also called ZDATE1 and simply does a CALLB to  *
      *   the module that contains subroutine ZDATE1                       *
      *                                                                    *
      **********************************************************************
     C     ZDATE1        BEGSR
      *
     C                   MOVE      ZDATE         ZDATEA
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEA            6
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
 
     C     ErrorFlag     IFEQ      'Y'
     C                   SETON                                        99
     C                   ELSE
     C                   SETOFF                                       99
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZFRQA in this module executes another standard subroutine,       *
      *   ZDATE2, which has also been converted to a module.               *
      *  This subroutine is also called ZDATE2 and simply does a CALLB to  *
      *   the module that contains subroutine ZDATE2                       *
      *                                                                    *
      **********************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
      **
      **   GET INDIVIDUAL DAY, MONTH AND YEAR FIELDS.
     C                   MOVE      ZDATE         ZYEAR             2 0
     C  N98              MOVEL     ZDATE         ZDAY              2 0
     C   98              MOVEL     ZDATE         ZMTH              2 0
     C                   MOVE      ZDATE         ZWRK4             4 0
     C  N98              MOVEL     ZWRK4         ZMTH
     C   98              MOVEL     ZWRK4         ZDAY
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZFRQA in this module executes another standard subroutine,       *
      *   ZCHKH, which has also been converted to a module.               *
      *  This subroutine is also called ZCHKH and simply does a CALLB to  *
      *   the module that contains subroutine ZCHKH                        *
      *                                                                    *
      **********************************************************************
     C     ZCHKH         BEGSR
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND              1
 
     C                   ENDSR
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
 
     C     *entry        PLIST
 
      * INPUTS (ZDAYNO is input and output)
 
     C                   PARM                    ZFREQ             1
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZMDAY             2 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
      *
      ** Date Format
     C                   PARM                    BJDFIN            1
 
     C                   ENDSR
      *****************************************************************
      ** +--- The converted ZFRQAZ3 starts here -------------------------+
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
