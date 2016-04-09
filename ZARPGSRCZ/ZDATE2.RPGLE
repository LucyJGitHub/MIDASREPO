     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZS Cvt Midas Day number to DDMMYY   MODULE')
      *****************************************************************
      *                                                               *
      *   Module ZDATE2 - Convert Midas Date into DDMMYY              *
      *                                                               *
      *  Function:    This module converts Midas Date into            *
      *               DDMMYY or MMDDYY format                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  LAST AMEND NO. CTI001    Create   DATE 03Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CTI001 - Midas/TI Interface (Phase 1)                        *
      *                                                               *
      ****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D***********    The converted ZDATE2Z1 starts here  *************
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)              ZDATE1/2 SR.ARRAY
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)            ZDATE1/2 SR.ARRAY
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)            ZDATE2 SR. ARRAY
     D***********    The converted ZDATE2Z1 ends here  ***************
     D*
      ****************************************************************
     C*
     C     *ENTRY        PLIST                                                  Entry parameter
     C     ZDAYNO        PARM                    WQ0001            5 0          Value date
     C                   PARM                    ZDATFM            1            Date format ind
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM      ZADATE        WQ0004            7            Run-date in DDM
     C**
     C********************************************************************
     C**
     C     ZDATFM        IFEQ      'M'
     C                   SETON                                        98
     C                   ELSE
     C                   SETOFF                                       98
     C                   END
     C**
     C                   EXSR      ZDATE2
     C**
     C                   RETURN
     C*
     C***********    The converted ZDATE2Z2 starts here  *************
     C********************************************************************
     C**
     C**   ZDATE2 SR. TO CONVERT A DAY NUMBER TO DATE FORMATS.
     C**
     C**   THE YEAR 2000, BEING DIVISIBLE BY 400, IS A LEAP YEAR.
     C**
     C     ZDATE2        BEGSR                                                  *** ZDATE2 ***
     C**
     C**   CLEAR LEAP YEAR WORK FIELD.
     C                   MOVE      'N'           ZLEAP             1
     C**
     C**   CLEAR DATE FIELDS.
     C                   Z-ADD     0             ZDATE             6 0
     C                   MOVEL     '       '     ZADATE            7
     C**
     C**   CALCULATION TO DEFINE INPUT DAY NUMBER.
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C**
     C**   DETERMINE YEAR NUMBER.
     C**
     C**   ADJUST DAY NUMBER IN CASE LAST DAY OF YEAR.
     C     ZDAYNO        SUB       1             ZDAYN1            5 0
     C     ZDAYN1        IFLT      0
     C                   GOTO      ZDEND2
     C                   END
     C**
     C**   CALCULATE NUMBER OF 4 YEAR SPANS SINCE 31/12/1971.
     C     ZDAYN1        DIV       1461          ZLYR              2 0
     C                   MVR                     ZDAYN1                         SAVE REMAINING
     C**                                                   DAYS
     C**   CALCULATE NUMBER OF REMAINING YEARS.
     C                   Z-ADD     1             ZWRK2             2 0
     C     ZDTAG1        TAG                                                    ** ZDTAG1 TAG *
     C     ZDAYN1        IFGE      ZYDY(ZWRK2)
     C     ZWRK2         ADD       1             ZWRK2
     C                   GOTO      ZDTAG1
     C                   END
     C*
     C     ZWRK2         SUB       1             ZWRK2
     C**
     C**   DECREMENT DAY NO. BY DAYS IN REMAINING YEARS.
     C     ZWRK2         IFNE      0
     C     ZDAYN1        SUB       ZYDY(ZWRK2)   ZDAYN1
     C                   END
     C**
     C**   CALCULATE ACTUAL YEAR NUMBER.
     C     ZLYR          MULT      4             ZWRK3             3 0
     C     ZWRK3         ADD       72            ZWRK3                          BASE IS 1972
     C                   Z-ADD     ZWRK3         ZYEAR             2 0
     C     ZYEAR         ADD       ZWRK2         ZYEAR                          YEAR
     C**
     C**   DETERMINE MONTH NUMBER.
     C**
     C**   ADJUST DAY NO. IN CASE LAST DAY OF LEAP YEAR FEBRUARY.
     C     ZWRK2         IFEQ      0
     C     ZDAYN1        IFEQ      59
     C                   MOVE      'Y'           ZLEAP
     C                   END
     C     ZDAYN1        IFGE      59
     C     ZDAYN1        SUB       1             ZDAYN1
     C                   END
     C                   END
     C**
     C**   CALCULATE MONTH NUMBER.
     C                   Z-ADD     2             ZWRK2
     C     ZDTAG2        TAG                                                    ** ZDTAG2 TAG *
     C     ZDAYN1        IFGE      ZMDY(ZWRK2)
     C     ZWRK2         ADD       1             ZWRK2
     C                   GOTO      ZDTAG2
     C                   END
     C*
     C     ZWRK2         SUB       1             ZWRK2
     C**
     C                   Z-ADD     ZWRK2         ZMTH              2 0          MONTH
     C**
     C**   DETERMINE DAY OF MONTH.
     C**
     C**   ADD BACK LAST DAY OF YEAR ADJUSTMENT.
     C     ZDAYN1        ADD       1             ZDAYN1
     C**
     C**   CALCULATE DAY OF MONTH.
     C     ZDAYN1        SUB       ZMDY(ZWRK2)   ZDAY              2 0          DAY
     C**
     C**   ADD BACK LEAP YEAR 29TH FEBUARY ADJUSTMENT, IF REQUIRED.
     C     ZLEAP         IFEQ      'Y'
     C     ZDAY          ADD       1             ZDAY
     C                   END
     C**
     C**   FORMAT DATE, DDMMYY OR MMDDYY.
     C  N98              MOVEL     ZDAY          ZWRK4             4 0
     C   98              MOVE      ZDAY          ZWRK4
     C  N98              MOVE      ZMTH          ZWRK4
     C   98              MOVEL     ZMTH          ZWRK4
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYEAR         ZDATE
     C**
     C**   FORMAT ALPHA DATE, DDMMMYY.
     C                   MOVEL     ZDAY          ZWRK5             5
     C     ZDAY          IFLT      10
     C                   MOVEL     ' '           ZWRK5
     C                   END
     C                   MOVE      ZMNM(ZMTH)    ZWRK5
     C                   MOVEL     ZWRK5         ZADATE
     C                   MOVE      ZYEAR         ZADATE
     C**
     C     ZDEND2        ENDSR                                                  * ZDEND2 ENDSR*
     C**
     C********************************************************************
     C***********    The converted ZDATE2Z2 ends here  ***************
     C*
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
