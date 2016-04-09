     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA: Validate & convert date to a day number')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZDATE1 - Validate & convert date to a day number             *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZDATE1        *
      *  subroutine.  The subroutine consists of three /COPY members. *
      *  Each of these has been converted to ILE RPG and copied into  *
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).  The   *
      *  existing code has not been changed except to remove dead     *
      *  lines, and the boundaries of the original /COPY members have *
      *  been marked, to facilitated future maintenance of both the   *
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
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CAP002  *CREATE    Date 01Aug97               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defned externally for the original
      ** copy members
      ** +-----------------------------------------------------------------+
 
 
      ** +-----------------------------------------------------------------+
 
      ** +--- The converted ZDATE1Z1 starts here --------------------------+
 
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE1 YEAR
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE1 MONTH
 
      ** +--- The converted ZDATE1Z1 ends here ----------------------------+
 
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D BJDFIN          S              1A
     D ErrorFlag       S              1A
 
     C     *entry        PLIST
     C                   PARM                    DateIn
     C                   PARM                    DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
      ** Put the received date parameter into the subroutine's field
     C                   MOVEL     DateIn        ZDATE
 
      ** Reset the error flag
     C                   EVAL      ErrorFlag = 'N'
 
      ** Set *IN98 to reflect the System Date Format Indicator
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      '0'           *IN98
     C                   ELSE
     C                   MOVE      '1'           *IN98
     C                   ENDIF
 
      ** Convert the date and put the result into the parameter field
     C                   EXSR      ZDATE1
 
      ** Put the the subroutine's day number field into the dayno parameter
     C                   EVAL      DaynoOut = ZDAYNO
 
      ** Pass the internal error flag back as a parameter
     C     *IN99         IFEQ      '1'
     C                   EVAL      ErrorFlag = 'Y'
     C                   ENDIF
 
     C                   RETURN
 
      ** +--- The converted ZDATE1Z1 starts here --------------------------+
 
     C********************************************************************
     C**
     C**   ZDATE1 SR. TO VALIDATE DATES SUBMITTED AND
     C**              CONVERT TO A NUMBER OF DAYS.
     C**
     C**   THE YEAR 2000, BEING DIVISIBLE BY 400, IS A LEAP YEAR.
     C**
     C     ZDATE1        BEGSR                                                  *** ZDATE1 ***
     C**
     C**   CLEAR DAY NUMBER. RESET ERROR INDICATOR
     C                   Z-ADD     0             ZDAYNO            5 0
     C                   SETOFF                                       99
     C**
     C**   CALCULATION TO DEFINE INPUT DATE FIELD.
     C                   Z-ADD     ZDATE         ZDATE             6 0
     C**
     C**   GET INDIVIDUAL DAY, MONTH AND YEAR FIELDS.
     C                   MOVE      ZDATE         ZYEAR             2 0
     C  N98              MOVEL     ZDATE         ZDAY              2 0
     C   98              MOVEL     ZDATE         ZMTH              2 0
     C                   MOVE      ZDATE         ZWRK4             4 0
     C  N98              MOVEL     ZWRK4         ZMTH
     C   98              MOVEL     ZWRK4         ZDAY
     C**
     C**   ENSURE MONTH IS VALID. BYPASS IF ERROR
     C     ZMTH          IFLE      0
     C     ZMTH          ORGT      12
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
     C**
     C**   ENSURE DAY IS VALID. BYPASS IF ERROR
     C     ZDAY          IFLE      0
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
     C**
     C**   CHECK FOR 30 DAY MONTHS. BYPASS IF ERROR
     C     ZMTH          IFEQ      4
     C     ZMTH          OREQ      6
     C     ZMTH          OREQ      9
     C     ZMTH          OREQ      11
     C**
     C     ZDAY          IFGT      30
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
     C**
     C                   ELSE
     C**
     C**   CHECK FOR 31 DAY MONTHS (ALL OTHERS BUT FEB). BYPASS IF ERROR
     C     ZDAY          IFGT      31
     C     ZMTH          ANDNE     2
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
     C**
     C                   END
     C**
     C**   CHECK FOR LEAP YEAR: REMAINDER WILL BE ZERO IF IT IS A LEAP YR
     C     ZYEAR         ADD       28            ZYEAR
     C     ZYEAR         DIV       4             ZLYR              2 0
     C                   MVR                     ZLY               1 0
     C**
     C**   IF FEBUARY FURTHER VALIDATE DAY.
     C     ZMTH          IFEQ      2
     C**
     C**   INVALID IF GREATER THAN 28 AND NOT A LEAP YEAR
     C     ZLY           IFGT      0
     C     ZDAY          ANDGT     28
     C                   SETON                                        99
     C                   GOTO      ZDEND1                                       BYPASS IF ERROR
     C                   END
     C**
     C**   INVALID IF GREATER THAN 29 AND A LEAP YEAR - BYPASS IF ERROR
     C     ZLY           IFEQ      0
     C     ZDAY          ANDGT     29
     C                   SETON                                        99
     C                   GOTO      ZDEND1
     C                   END
     C**
     C                   END
     C**
     C**   DETERMINE NUMBER OF DAYS FROM 31/12/1971.
     C**
     C**   MULTIPLY NO. OF FOUR-YEAR SPANS, BY NO. OF DAYS IN SPAN
     C     ZLYR          MULT      1461          ZDAYNO
     C**
     C**   IF NOT A LEAP YEAR, ADD APPROPRIATE NO. OF DAYS FOR EXTRA
     C**   YEARS USING REMAINDER FIELD (IE. 1, 2 OR 3 X 356)
     C     ZLY           IFGT      0
     C     ZDAYNO        ADD       ZYDY(ZLY)     ZDAYNO
     C                   END
     C**
     C**   IF IT IS A LEAP YEAR, AND LATER THAN FEBRUARY, ADD ONE FOR
     C**   29TH OF FEB
     C     ZLY           IFEQ      0
     C     ZMTH          ANDGT     2
     C     ZDAYNO        ADD       1             ZDAYNO
     C                   END
     C**
     C**   ADD APPROPRIATE NUMBER OF DAYS FOR THE MONTH NUMBER
     C     ZDAYNO        ADD       ZMDY(ZMTH)    ZDAYNO
     C**
     C**   ADD NUMBER OF DAYS IN MONTH
     C     ZDAYNO        ADD       ZDAY          ZDAYNO
     C**
     C     ZDEND1        ENDSR                                                  * ZDEND1 ENDSR*
     C**
     C**
     C********************************************************************
 
      ** +--- The converted ZDATE1Z2 ends here ----------------------------+
 
      ** +--- From here to the end is the converted ZDATE1Z3 --------------+
 
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
