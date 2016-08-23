     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA: Convert day number to YYYYMMDD format')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZDATE9 - Convert day number to YYYYMMDD format               *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZDATE9        *
      *  subroutine.  The subroutine consists of four /COPY members.  *
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
 
      ** Midas Day number
     D @@DAYN          S              5P 0
 
      ** Formatted date field for use in the parameter list
     D DateOut         S              8S 0
 
      ** +-----------------------------------------------------------------+
 
      ** +--- The original ZDATE9Z1 starts here ---------------------------+
 
     D**  ARRAY FOR SR. ZDATE9 - CUMULATIVE DAYS IN YEAR FOR 4 YEAR PERIOD
     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND
     D*
     D**  ARRAY FOR SR. ZDATE9 - CUMULATIVE DAYS IN YEAR PER MONTH
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND
 
      ** +--- The original ZDATE9Z1 ends here -----------------------------+
 
      ** +--- The original ZDATE9Z2 starts here ---------------------------+
 
     D**  DATA STRUCTURE FOR SR. ZDATE9 - FIELD IS @@Z71Y
     D                 DS
     D  @@Z71Y                 1      4  0
     D  @@SSY1                 1      1  0
     D  @@SSY2                 2      2  0
     D  @@SSY3                 3      3  0
     D  @@SSY4                 4      4  0
     D**  DATA STRUCTURE FOR SR. ZDATE9 - FIELD IS @@VDT
     D                 DS
     D  @@VDT                  1      8  0
     D  @@YR                   1      4  0
     D  @@Z71M                 5      6  0
     D  @@Z71D                 7      8  0
 
      ** +--- The original ZDATE9Z2 ends here -----------------------------+
 
     C     *entry        PLIST
     C                   PARM                    @@DAYN
     C                   PARM                    DateOut
     C                   PARM                    @@RTN
 
      ** Convert the date and put the result into the parameter field
     C                   EXSR      ZDATE9
     C                   EVAL      DateOut = @@VDT
 
     C                   RETURN
 
      ** +--- The original ZDATE9Z3 starts here ---------------------------+
 
     C*
     C     ZDATE9        BEGSR
     C*
     C                   SETOFF                                       9091                     06142
     C                   MOVE      '0'           @@RTN             1
     C                   Z-ADD     0             @@VDT
     C                   Z-ADD     1             @@I               2 0
     C                   Z-ADD     1             @@J               2 0
     C                   Z-ADD     1             @@LEAP            1 0
     C*
     C     @@DAYN        IFLT      1
     C                   MOVE      '1'           @@RTN
     C                   GOTO      ZDAT79
     C                   END
     C*
     C* DIVISION TO DETERMINE WETHER LEAP YEAR.
     C*
     C     @@DAYN        DIV       1461          @@Z71Y
     C                   MVR                     @@RDAY            5 0
     C*
     C* CALCULATING YEAR.
     C*
     C     @@Z71Y        MULT      4             @@Z71Y
     C                   ADD       1972          @@Z71Y
     C*
     C* CHECKING IF YEAR IS GREATER THAN OR EQUAL TO 2100
     C*
     C     @@Z71Y        IFGE      2100
     C                   ADD       @@SSY2        @@RDAY
     C                   END
     C*
     C* LOKUP ARRAY @YD TO SEE HOW MANY YEARS OF A FOUR YEAR CYCLE
     C* HAVE PASSED.
     C*
     C     @@RDAY        LOOKUP    @YD(@@I)                             9090
     C*
     C* IF YEAR IS A LEAP YEAR SSLEAP IS SET TO ZERO.
     C*
     C     *IN90         IFEQ      '0'
     C                   Z-ADD     0             @@LEAP
     C                   END
     C*
     C* ADD INDEX TO YEAR TO GIVE CORRECT YEAR AND ADJUST '@@RDAY'.
     C*
     C     @@LEAP        IFEQ      1
     C     @@RDAY        SUB       @YD(@@I)      @@RDAY
     C                   ADD       @@I           @@Z71Y
     C                   END
     C*
     C* PROCESSING FOR A LEAP YEAR.
     C*
     C     @@LEAP        IFEQ      0
     C*
     C* IF '@@RDAY' = 60 DATE MUST BE 29TH OF FEBRUARY.
     C*
     C     @@RDAY        IFEQ      60
     C                   Z-ADD     29            @@Z71D
     C                   Z-ADD     2             @@Z71M
     C                   GOTO      ZA0711
     C                   END
     C*
     C* IF '@@RDAY' > 60 DATE IS AFTER 29TH OF FEBRUARY,CONVERSION CAN
     C* PROCEED AS USUAL AFTER SUBTRACTING THE EXTRA DAY FOR THE LEAP
     C* YEAR. NOTE : '@@RDAY' < 60 CONVERSION PROCEEDS AS USUAL.
     C*
     C     @@RDAY        IFGT      60
     C     @@RDAY        SUB       1             @@RDAY
     C                   END
     C*
     C                   END
     C*
     C* IF DAY '@@DAYN' IS EXACTLY DIVISIBLE BY 1461 (NUMBER OF DAYS
     C* IN 4 YEARS) THEN DATE MUST BE LAST DAY OF PREVIOUS FOUR YEAR
     C* GROUP.
     C*
     C     @@RDAY        IFEQ      0
     C                   Z-ADD     31            @@Z71D
     C                   Z-ADD     12            @@Z71M
     C                   SUB       1             @@Z71Y
     C                   GOTO      ZA0711
     C                   END
     C*
     C* LOOK UP ARRAY ARRAY @MD TO DETERMINE WHICH MONTH '@@RDAY'
     C* OCCURS IN
     C*
     C     @@RDAY        LOOKUP    @MD(@@J)                             91
     C                   Z-ADD     @@J           @@Z71M
     C     @@RDAY        SUB       @MD(@@J)      @@Z71D
     C*
     C* DS @@VDT  IS RETURNED IN YYYYMMDD FORMAT
     C*
     C     ZA0711        TAG
     C*
     C                   MOVE      @@Z71Y        @@YR
     C
     C     ZDAT79        ENDSR
     C*****************************************************************
 
      ** +--- The original ZDATE9Z3 ends here -----------------------------+
 
      ** +--- From here to the end is the original ZDATE9Z4 ---------------+
 
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
