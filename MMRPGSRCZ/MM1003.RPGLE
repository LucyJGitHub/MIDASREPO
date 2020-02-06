     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Calculate a period date')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MM1003 - Calculate a period date                             *
      *                                                               *
      *  Function:  This module calculates the period date for a      *
      *             given currency, period type, and period number.   *
      *             The spot date is the starting point of the        *
      *             calculation.                                      *
      *             It is a converted version of the subroutine       *
      *             MM1003, which was hard coded in FD0550 and FD0551.*
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP005  *CREATE    Date 20Nov98               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP005 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D                 DS
     D  @@VDT                  1      8  0
     D  @@Z71M                 5      6  0
 
     D  @@DTIN         S              8S 0
     D  @@DTOU         S              6P 0
      *
      ** DATA STRUCTURE HOLDING STARTING POINT DATE
      *
     D                 DS
     D  @@STRT                 1      8  0
     D  @@STYR                 1      4  0
     D  @@STMT                 5      6  0
     D  @@STDY                 7      8  0
      *
      ** DATA STRUCTURE HOLDING SPOT DATE
      *
     D                 DS
     D  @@SPDD                 1      8  0
     D  @@SPMT                 5      6  0
      *
      ** DATA STRUCTURE DAYS FOR DATE FORMAT DDMMYY
      *
     D                 DS
     D  @@DATE                 1      6  0
     D  @@DAY2                 1      2  0
     D  @@DAY4                 3      4  0
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   EXSR      MM1003
 
     C                   RETURN
 
      *****************************************************************
     C/EJECT
      *****************************************************************
      *   MM1003 - CALCULATE A PERIOD DATE                            *
      *                                                               *
      *   PERIOD DATES ARE CALCULATED FOR THE FOLLOWING PERIODS       *
      *      PERIOD TYPE       PERIOD NUMBER     PERIOD SHORTNAME     *
      *           D                 -1             OVERNIGHT          *
      *           D                  0             TOMORROW / NEXT    *
      *           D                  1             SPOT / NEXT        *
      *           W                  1             1 WEEK             *
      *           W                  2             2 WEEK             *
      *           W                  3             3 WEEK             *
      *           M                  1             1 MONTH            *
      *           M                  2             2 MONTH            *
      *           M                  3             3 MONTH            *
      *           M                  6             6 MONTH            *
      *           M                  9             9 MONTH            *
      *           Y                  1             1 YEAR             *
      *           Y                  2             2 YEARS            *
      *           Y                  3             3 YEARS            *
      *           Y                  4             4 YEARS            *
      *           Y                  5             5 YEARS            *
      *           Y                  6             6 YEARS            *
      *           Y                  7             7 YEARS            *
      *           Y                  8             8 YEARS            *
      *           Y                  9             9 YEARS            *
      *           Y                 10            10 YEARS            *
      *                                                               *
      *  FIELDS INPUT -                                               *
      *                                                               *
      *  @@CCY   3    - CURRENCY                                      *
      *  @@SPOT  8,0  - MONEY MARKET SPOT DATE                        *
      *  @@PNUM  2,0  - PERIOD NUMBER                                 *
      *  @@PTYP  1    - PERIOD TYPE                                   *
      *                                                               *
      *  FIELDS OUTPUT                                                *
      *                                                               *
      *  @@PDAT  8,0  - PERIOD DATE                                   *
      *                                                               *
      *****************************************************************
     C     MM1003        BEGSR
      *
      ** SET UP STARTING POINT DATE AS SPOT DATE
      *
     C                   Z-ADD     @@SPOT        @@SPDD
     C                   Z-ADD     @@SPOT        @@STRT
      *
      ** ADD PERIOD NUMBERS TO DATE
      *
     C     @@PTYP        IFEQ      'M'
     C                   ADD       @@PNUM        @@STMT
     C     @@STMT        IFGT      12
     C                   SUB       12            @@STMT
     C                   ADD       1             @@STYR
     C                   END
     C                   END
      *
     C     @@PTYP        IFEQ      'Y'
     C                   ADD       @@PNUM        @@STYR
     C                   END
      *
      ** CONVERT DATE FORMAT FROM YYYYMMDD TO DDMMYY
      *
     C                   Z-ADD     @@STRT        @@DTIN
     C                   EXSR      ZA0770
     C                   Z-ADD     @@DTOU        @@DATE
      *
     C                   MOVE      @@DATE        @@DATC            6 0
      *
      ** CONVERT STARTING DATE TO MIDAS DAY NUMBER FORMAT
      *
     C     @@RTNC        DOUEQ     '0'
     C                   CALL      'ZA0270'
     C                   PARM                    @@DATC
     C                   PARM                    BJDFIN
     C                   PARM                    @@RTNC            1
     C                   PARM                    @@DAYN            5 0
      *
     C     BJDFIN        IFEQ      'D'
     C                   SUB       1             @@DAY2
     C                   ELSE
     C                   SUB       1             @@DAY4
     C                   END
     C                   MOVE      @@DATE        @@DATC
      *
     C                   END
      *
     C                   Z-ADD     @@DAYN        ZDAYNO
      *
      ** RESET STARTING POINT
      *
     C                   EXSR      ZA0710
     C                   Z-ADD     @@VDT         @@STRT
      *
      ** PROCESS PERIOD TYPE 'D'
      *
     C     @@PTYP        IFEQ      'D'
      *
      ** IF PERIOD NUMBER = 1 FIND NEXT WORKING DAY
      *
     C     @@PNUM        IFEQ      1
     C     ZIND          DOUEQ     'W'
     C                   ADD       1             ZDAYNO
     C                   EXSR      ZCHKH
     C                   END
     C                   END
      *
      ** IF PERIOD NUMBER NE 1 FIND TOMORROW/NEXT DAY (AND OVERNIGHT)
      ** IE FIND NEXT WORKING DAY BEYOND RUND
      *
     C     @@PNUM        IFLT      1
     C                   Z-ADD     BJRDNB        ZDAYNO
     C     ZIND          DOUEQ     'W'
     C                   ADD       1             ZDAYNO
     C                   EXSR      ZCHKH
     C                   END
     C                   END
      *
      ** IF PERIOD NUMBER IS -1 FIND NEXT WORKING DAY TOMM/NEXT.
      ** IE FIND NEXT WORKING DAY BEYOND RUND
      *
     C     @@PNUM        IFEQ      0
     C     ZIND          DOUEQ     'W'
     C                   ADD       1             ZDAYNO
     C                   EXSR      ZCHKH
     C                   END
     C                   END
      *
     C                   END
      *
      ** PROCESS PERIOD TYPE 'W'
      *
     C     @@PTYP        IFEQ      'W'
      *
      ** INCREMENT DAY NUMBER
      *
     C     @@PNUM        MULT      7             @@ADD             3 0
     C                   ADD       @@ADD         ZDAYNO
      *
      ** FIND NEXT WORKING DAY
      *
     C                   EXSR      ZCHKH
     C     ZIND          DOWEQ     'H'
     C                   ADD       1             ZDAYNO
     C                   EXSR      ZCHKH
     C                   END
     C                   END
      *
      ** PROCESS PERIOD TYPE 'M' OR 'Y'
      *
     C     @@PTYP        IFEQ      'M'
     C     @@PTYP        OREQ      'Y'
      *
      ** IS SPOT LAST WORKING DAY IN MONTH
      *
     C                   Z-ADD     @@SPDD        @@DTIN
     C                   EXSR      ZA073C
     C     @@SPMT        IFNE      @@Z71M
     C                   Z-ADD     1             @@STDY
     C     @@STMT        IFEQ      12
     C                   Z-ADD     1             @@STMT
     C                   ADD       1             @@STYR
     C                   ELSE
     C                   ADD       1             @@STMT
     C                   END
      *
      ** CONVERT STARTING DATE TO MIDAS DAY NUMBER FORMAT
      *
     C                   Z-ADD     @@STRT        @@DTIN
     C                   EXSR      ZA0680
     C                   Z-ADD     @@MDNO        ZDAYNO
     C     ZIND          DOUEQ     'W'
     C                   SUB       1             ZDAYNO
     C                   EXSR      ZCHKH
     C                   END
     C                   GOTO      M10038
     C                   END
      *
      ** IF THE STARTING POINT DAY IS A NON WORKING DAY AND THE NEXT
      ** WORKING DAY FALLS IN THE NEXT MONTH  FIND LAST WORKING DAY
      ** IN STARTING MONTH.
      *
     C                   Z-ADD     @@STRT        @@DTIN
     C                   EXSR      ZA0680
     C                   Z-ADD     @@MDNO        ZDAYNO
     C                   EXSR      ZCHKH
     C     ZIND          IFEQ      'H'
     C                   Z-ADD     @@STRT        @@DTIN
     C                   EXSR      ZA073C
      *
     C     @@STMT        IFNE      @@Z71M
     C     ZIND          DOUEQ     'W'
     C                   SUB       1             ZDAYNO
     C                   EXSR      ZCHKH
     C                   END
     C                   END
     C                   GOTO      M10038
     C                   END
      *
      ** IF STARTING DATE IS A WORKING DAY IN CURRENCY & SPOT DATE
      ** IS NOT LAST WORKING DAY IN MONTH PERIOD DATE IS STARTING DAY
      *
     C                   Z-ADD     @@STRT        @@PDAT
     C                   GOTO      M10039
      *
     C                   END
      *
     C     M10038        TAG
      *
      ** CONVERT DATE TO YYYYMMDD FORMAT
      *
     C                   Z-ADD     ZDAYNO        @@DAYN
     C                   EXSR      ZA0710
     C                   Z-ADD     @@VDT         @@PDAT            8 0
      *
     C     M10039        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZA073C - DETERMINE NEXT WORKING DAY.                          *
      *                                                               *
      *****************************************************************
     C     ZA073C        BEGSR
      *
      ** CONVERT YYYYMMDD FORMAT TO MIDAS DAY NO.
      *
     C                   EXSR      ZA0680
      *
     C     ZA0731        TAG
      *
     C                   ADD       1             @@MDNO            5 0
      *
      ** CHECK IF DAY NO. IS A HOLIDAY
      *
     C                   Z-ADD     @@MDNO        ZDAYNO            5 0
      *
     C                   EXSR      ZCHKH
      *
     C     ZIND          IFEQ      'H'
     C                   GOTO      ZA0731
     C                   END
      *
      ** CONVERT MIDAS DAY NO. TO YYYYMMDD FORMAT.
      *
     C                   Z-ADD     @@MDNO        @@DAYN            5 0
      *
     C                   EXSR      ZA0710
      *
     C     ZA0739        ENDSR                                                              **
      *****************************************************************
     C/EJECT
      *******************************************************************
      *
      * ZA0680 - THIS SUBROUTINE CONVERTS YYYYMMDD FORMAT DATE TO
      *          MIDAS DAY NUMBER FORMAT (NO. DAYS FROM 31/12/71)
      *
      *******************************************************************
     C     ZA0680        BEGSR
 
     C                   CALLB     'ZDATE10'
     C                   PARM                    @@DTIN
     C                   PARM      *ZERO         @@MDNO
      *
     C                   ENDSR                                                  **ZA0689 TAG**
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *       TITLE:CALCULATE MIDAS DAY NO. TO DRS (YYYYMMDD) FORMAT. *
      *                                                               *
      *****************************************************************
     C     ZA0710        BEGSR
 
     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DAYN
     C                   PARM      *ZERO         @@VDT
     C                   PARM                    @@RTN             1 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     ZCHKH         BEGSR
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      @@CCY         ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM                    ZIND              1
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     ZA0770        BEGSR
 
     C                   CALLB     'ZA0770'
     C                   PARM                    RetCodeOut
     C                   PARM                    @@DTIN
     C                   PARM                    BJDFIN
     C                   PARM                    @@DTOU
      *
     C                   ENDSR                                                  ***ZA0779***
      *****************************************************************
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
 
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
 
      ** Spot date, currency, period number and period type
     C                   PARM                    @@SPOT            8 0
     C                   PARM                    @@CCY             3
     C                   PARM                    @@PNUM            2 0
     C                   PARM                    @@PTYP            1
 
      * ICD
 
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BJDFIN            1
 
      * Period date (output)
 
     C                   PARM                    @@PDAT            8 0
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
