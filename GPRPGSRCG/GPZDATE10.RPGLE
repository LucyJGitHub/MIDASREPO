     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Convert YYYYMMDD format to day number')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  GPZDATE10 - Convert YYYYMMDD format to day number            *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZDAT10        *
      *  subroutine.  The subroutine consists of four /COPY members.  *
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
      *    This is based on ZDATE10.                                  *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP003  *CREATE    Date 09Mar04               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP003 - Management Limits                                   *
      *           Required to move details of manual transactions     *
      *           to the Global Transactions file.                    *
      *                                                               *
      *****************************************************************
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
      ** Date field for use in the parameter list
     D DateIn          S                   LIKE(ZZDTIN)
 
      ** +-----------------------------------------------------------------+
 
      ** +--- The converted ZDAT10Z1 starts here --------------------------+
 
     D**  ARRAY FOR SR. ZDATE9 - CUMULATIVE DAYS IN YEAR FOR 4 YEAR PERIOD
     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND
     D*
     D**  ARRAY FOR SR. ZDATE9 - CUMULATIVE DAYS IN YEAR PER MONTH
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND
 
      ** +--- The converted ZDAT10Z1 ends here ----------------------------+
 
      ** +--- The converted ZDAT10Z1 starts here --------------------------+
 
     D                 DS
     D**  DATA STRUCTURE FOR SR. ZDAT10 - DATE INPUT TO SUBROUTINE
     D  ZZDTIN                 1      8  0
     D  ZWYYYY                 1      4  0
     D  ZWCC                   1      2  0
     D  ZWMTH                  5      6  0
     D  ZWDAY                  7      8  0
 
      ** +--- The converted ZDAT10Z1 ends here ----------------------------+
 
     C     *entry        PLIST
     C                   PARM                    DateIn
     C                   PARM                    ZZMDNO
 
      ** Put the received date parameter into the subroutine's field
     C                   EVAL      ZZDTIN = DateIn
 
      ** Convert the date and put the result into the parameter field
     C                   EXSR      ZDAT10
 
     C                   RETURN
 
      ** +--- The converted ZDAT10Z2 starts here --------------------------+
 
     C*******************************************************************
     C*
     C* ZDAT10 - THIS SUBROUTINE CONVERTS YYYYMMDD FORMAT DATE TO
     C*          MIDAS DAY NUMBER FORMAT (NO. DAYS FROM 31/12/71)
     C*
     C* INPUT  : ZZDTIN DATE (YYYYMMDD) - IN DATA STRUCTURE (SIZE : 8N)
     C*
     C* OUTPUT : ZZMDNO MIDAS DAY NUMBER  (SIZE : 5N)
     C*
     C* USES :   @MD    COMPILATION TIME ARRAY FOR CUMULATIVE DAYS IN
     C*                 MONTH
     C*          @YD    COMPILATION TIME ARRAY FOR CUMULATIVE DAYS IN
     C*                 A FOUR YEAR PERIOD
     C*          ZWYYYY YEAR (4 CHARACTER)
     C*          ZWYY   YEAR (2 CHARACTER)
     C*          ZWCC   NUMBER OF CENTURIES IN DATE
     C*          ZWMTH  MONTH NUMBER
     C*          ZWDAY  DAY NUMBER
     C*          ZWREM  REMAINDER FROM DIVIDE
     C*          ZWWK2  WORK FIELD (2,0)
     C*          ZWWK5  WORK FIELD (5,0)
     C*
     C*******************************************************************
     C*
     C     ZDAT10        BEGSR
     C*
     C** INITIALISE OUTPUT FIELD
     C                   Z-ADD     0             ZZMDNO            5 0
     C*
     C** IF INPUT FIELD IS ZERO THEN TERMINATE SUBROUTINE
     C     ZZDTIN        CABEQ     0             ZDAT19
     C*
     C** IF DATE GREATER THAN 31/12/2071 THEN CALCUALTE NUMBER OF
     C** CENTURIES PASSED SINCE 1971, BY SUBTRACTING 1972 FROM THE
     C** THE YEAR FIELD.
     C     ZWYYYY        IFGE      2072
     C     ZWYYYY        SUB       1972          ZWYYYY
     C*
     C** MULTIPLY BY NUMBER OF DAYS IN CENTURY (SINCE 1971)
     C** THEN RESTORE THE YEAR WHICH WAS INPUT BACK TO THE
     C** ORIGINAL VALUE BEFORE CONTINUING WITH NORMAL CALCULATIONS.
     C     ZWCC          MULT      36525         ZZMDNO
     C     ZWYYYY        ADD       1972          ZWYYYY
     C                   END
     C*
     C** ADD 28 TO THE YEAR - THE RIGHT TWO DIGITS OF THE RESULT WILL
     C** GIVE THE NUMBER OF YEARS FROM 1971 - DISREGARDING CENTURIES
     C     ZWYYYY        ADD       28            ZWWK2             2 0
     C*
     C** CALCULATE HOW MANY GROUPS OF FOUR YEARS THERE ARE
     C     ZWWK2         DIV       4             ZWWK2
     C                   MVR                     ZWREM             1 0
     C*
     C** AND MULTIPLY BY NUMBER OF DAYS IN FOUR YEAR PERIOD
     C     ZWWK2         MULT      1461          ZWWK5             5 0
     C                   ADD       ZWWK5         ZZMDNO
     C*
     C** IF A LEAP YEAR AND PAST FEBRUARY THEN ADD AN EXTRA DAY
     C     ZWREM         IFEQ      0
     C     ZWMTH         ANDGT     2
     C                   ADD       1             ZZMDNO
     C                   END
     C*
     C** YEAR NOT LEAP YEAR,  ADD CUMULATIVE DAYS FOR YEAR
     C     ZWREM         IFNE      0
     C                   ADD       @YD(ZWREM)    ZZMDNO
     C                   END
     C*
     C** ADD MONTHS THIS YEAR
     C                   ADD       @MD(ZWMTH)    ZZMDNO
     C*
     C** ADD DAYS THIS MONTH
     C                   ADD       ZWDAY         ZZMDNO
     C*
     C     ZDAT19        ENDSR                                                  **ZDAT19 TAG**
      *****************************************************************
 
      ** +--- The converted ZDAT10Z2 ends here ----------------------------+
 
 
      ** +--- From here to the end, apart from the copyright array, -----+
      ** +---  is the converted ZDATE9Z4   ------------------------------+
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
