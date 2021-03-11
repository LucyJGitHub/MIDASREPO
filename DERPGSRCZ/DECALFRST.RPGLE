     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Calculate FRA settlement amount')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DECALFRST - Calculate Discounted Settled Amount for FRAS     *
      *                                                               *
      *  Function:  This module calculates discounted settled amounts *
      *             for Forward Rate Agreement deal types.            *
      *             Note that this module must match the calculation  *
      *             in DL0410 and DL0411 thus when applying fixes,    *
      *             the same changes are required to both programs.   *
      *                                                               *
      *  Component of: DEPXTFRAS                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188050             Date 27Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  208221 - Changes identified during alpha site                *
      *  CDE002 - Revenue Analysis                                    *
      *  188050 - Int. calc. basis 7 not processed                    *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  188050
      ** External DS for SAR Details                                                          188050
                                                                                              188050
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     188050
      ** Second DS for Access Programs, Long Data Structure                                   188050
                                                                                              188050

     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
      * FRA buy/sell ind
     C                   PARM                    I#BYSL            1
      * settlement formula
     C                   PARM                    I#SETF            1
      * value date
     C                   PARM                    I#VDAT            5 0
      * maturity date
     C                   PARM                    I#MDAT            5 0
      * principal amount
     C                   PARM                    I#PAMT           13 0
      * fixed rate
     C                   PARM                    I#FIX            11 7
      * floating rate
     C                   PARM                    I#FLT            11 7
      * int.calc basis
     C                   PARM                    I#ICBS            1 0
      * adj to accrd int
     C                   PARM                    I#IANP           13 0
      * OUTPUTS
      * settlement amount (adjusted & not adjusted)
     C                   PARM                    O#RDS            13 0
     C                   PARM                    O#DSA            15 0

      ** Access Switchable Features File                                                      188050
                                                                                              188050
     C                   CALLB     'AOSARDR0'                                                 188050
     C                   PARM      *Blanks       PRtcd             7                          188050
     C                   PARM      '*VERIFY '    POptn             7                          188050
     C                   PARM      'CIR004'      PSard             6                          188050
     C     SCSARD        PARM      SCSARD        DSFDY                                        188050
                                                                                              188050
     C                   MOVE      'N'           CIR004            1                          188050
     C                   IF        PRtcd = *Blanks                                            188050
     C                   EVAL      CIR004 = 'Y'                                               188050
     C                   ENDIF                                                                188050
                                                                                              188050
      * initialize output fields

     C                   Z-ADD     0             O#RDS
     C                   Z-ADD     0             O#DSA

      * initialize work fields

     C                   Z-ADD     0             SZICVL            3 0
     C                   Z-ADD     0             SZSDAT            5 0
     C                   Z-ADD     0             SZEDAT            5 0
     C                   Z-ADD     0             SZPER             5 0
     C                   Z-ADD     0             SZWRK1           11 7
     C                   Z-ADD     0             SZWRK2           20 7
     C                   Z-ADD     0             SZWRK3            5 0
     C                   Z-ADD     0             SZWRK4           14 7
     C                   Z-ADD     0             SZWRK5           14 7
     C                   Z-ADD     0             SZWRK6           15 0
     C                   Z-ADD     0             SZWRK7           12 9
     C                   Z-ADD     0             SZWRK8           15 0
     C                   Z-ADD     0             SZWRK9           15 7
     C                   Z-ADD     0             SZSETL           18 0
     C                   Z-ADD     0             SZRDF            11 7
     C                   Z-ADD     0             SZRSA            15 0
     C                   Z-ADD     0             SZDISC           11 7

     C                   Z-ADD     0             Start_CYr         4 0
     C                   Z-ADD     0             Start_Date        6 0
     C                   Z-ADD     0             Start_LpYr        5 0
     C                   Z-ADD     0             Start_Year        2 0
     C                   Z-ADD     0             Start_Day         2 0
     C                   Z-ADD     0             Start_Mth         2 0
     C                   Z-ADD     0             Start_REM         1 0

     C                   Z-ADD     0             End_CYr           4 0
     C                   Z-ADD     0             End_Date          6 0
     C                   Z-ADD     0             End_LpYr          5 0
     C                   Z-ADD     0             End_Year          2 0
     C                   Z-ADD     0             End_Day           2 0
     C                   Z-ADD     0             End_Mth           2 0
     C                   Z-ADD     0             End_REM           1 0

     C                   Z-ADD     0             Num_Mths          4 0
     C                   Z-ADD     0             W#04              4 0

     C                   SELECT

      **  IF AUSTRALIA FORMULA REQUIRED

     C     I#SETF        WHENEQ    'A'

     C                   EXSR      FORMULA_A

      **  IF U.S.A FORMULA REQUIRED

     C     I#SETF        WHENEQ    'U'

     C                   EXSR      FORMULA_U

     C                   OTHER

      **  IF U.K. FORMULA REQUIRED

     C                   EXSR      FORMULA_G
      *
     C                   ENDSL

      **  ADD THE NET ACCRUED INTEREST ADJUSTMENTS NOT POSTED TO THE
      **  RUNNING DISCOUNTED SETTLEMENT TOTAL TO GIVE THE DISCOUNTED
      **  SETTLEMENT AMOUNT TOTAL

     C     I#IANP        ADD       O#RDS         O#DSA

      **  SIGN A NET SETTLEMENT PROFIT AS + AND A NET SETTLEMENT LOSS AS -
      **
      **  FRA BUY/SELL      FIX RATE /FLT RATE       PROFIT/LOSS
      **     BUY                 FIX<FLT                 +
      **     BUY                 FIX>FLT                 -
      **     SELL                FIX<FLT                 -
      **     SELL                FIX>FLT                 +

     C     I#BYSL        IFEQ      'B'
     C     I#FIX         ANDGT     I#FLT
     C     I#BYSL        OREQ      'S'
     C     I#FIX         ANDLT     I#FLT
     C                   Z-SUB     O#RDS         O#RDS
     C                   Z-SUB     O#DSA         O#DSA
     C                   ENDIF

     C                   RETURN

      ********************************************************************
      /SPACE 5
      ********************************************************************
      **  CALCULATE DISCOUNTED SETTLEMENT AMOUNT USING AUSTRALIAN FORMULA
      ********************************************************************
     C     FORMULA_A     BEGSR
      *
      **  CALCULATE DAYS TO MATURITY
      *
     C     I#MDAT        SUB       I#VDAT        SZWRK3
      *
      **  MULTIPLY FACE VALUE BY (DAYS IN YEAR x 100)
      *
     C     I#PAMT        MULT      36500         SZSETL
      *
      **  CALCULATE PROCEEDS FROM FLOATING RATE
      *
     C     SZWRK3        MULT      I#FLT         SZWRK2
     C                   ADD       36500         SZWRK2
     C     SZWRK2        IFNE      *ZEROS
     C     SZSETL        DIV(H)    SZWRK2        SZRSA
     C                   ELSE
     C                   Z-ADD     *ZEROS        SZRSA
     C                   END
      *
      **  CALCULATE PROCEEDS FROM FIXED AMOUNT
      *
     C     SZWRK3        MULT      I#FIX         SZWRK2
     C                   ADD       36500         SZWRK2
     C     SZWRK2        IFNE      *ZEROS
     C     SZSETL        DIV(H)    SZWRK2        SZWRK8
     C                   ELSE
     C                   Z-ADD     *ZEROS        SZWRK8
     C                   END
      *
      **  CALCULATE DISCOUNTED SETTLEMENT AMOUNT
      *
     C     SZRSA         IFGT      SZWRK8
     C     SZRSA         SUB       SZWRK8        O#RDS
     C                   ELSE
     C     SZWRK8        SUB       SZRSA         O#RDS
     C                   END

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      **  CALCULATE DISCOUNTED SETTLEMENT AMOUNT USING U.S. FORMULA
      ********************************************************************
     C     FORMULA_U     BEGSR
      *
      **  CALCULATE DAYS TO MATURITY
      *
     C     I#MDAT        SUB       I#VDAT        SZWRK3
      *
      **  MULTIPLY INTEREST SETTLEMENT RATE BY DAYS TO MATURITY
      **  AND ADD (DAYS IN YEAR x 100)
      *
     C                   Z-ADD     I#FLT         I#FLT_TRUN        7 4
     C     I#FLT_TRUN    MULT      SZWRK3        SZWRK9
     C                   ADD       36000         SZWRK9
      *
      **  CALCULATE DIFFERENCE in RATES
      *
     C     I#FLT_TRUN    IFGT      I#FIX
     C     I#FLT_TRUN    SUB       I#FIX         SZWRK1
     C                   ELSE
     C     I#FIX         SUB       I#FLT_TRUN    SZWRK1
     C                   END
      *
      **  MULTIPLY DIFFERENCE IN RATES BY DAYS TO MATURITY AND
      **  CONTRACT AMOUNT
      *
     C     SZWRK1        MULT      SZWRK3        SZWRK2
     C     SZWRK2        MULT      I#PAMT        SZWRK2
      *
      **  CALCULATE DISCOUNTED SETTLEMENT AMOUNT
      *
     C     SZWRK9        IFNE      *ZEROS
     C     SZWRK2        DIV(H)    SZWRK9        O#RDS
     C                   ELSE
     C                   Z-ADD     *ZEROS        O#RDS
     C                   END

     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      **  CALCULATE DISCOUNTED SETTLEMENT AMOUNT USING U.K. FORMULA
      ********************************************************************
     C     FORMULA_G     BEGSR
      *
      **  DETERMINE VALUE ASSOCIATED WITH INTEREST CALCULATION BASIS
      *
     C     I#ICBS        IFEQ      2
     C     I#ICBS        OREQ      3
     C     I#ICBS        OREQ      5
     C     I#ICBS        OREQ      7                                                          188050
     C     CIR004        ANDEQ     'Y'                                                        188050
     C                   Z-ADD     360           SZICVL
     C                   END
      *
     C     I#ICBS        IFEQ      1
     C     I#ICBS        OREQ      4
     C                   Z-ADD     365           SZICVL
     C                   END
      *
     C     I#ICBS        IFEQ      6
     C                   Z-ADD     366           SZICVL
     C                   END
      *
      **  SET START DATE EQUAL TO VALUE DATE
      *
     C                   Z-ADD     I#VDAT        SZSDAT
      *
      **  PROCESS UNTIL END DATE IS GREATER THAN MATURITY DATE
      *
     C                   SETOFF                                       89
     C     *IN89         DOUEQ     '1'
      *
      **  EXECUTE SUB-ROUTINE ZDATE2
      *
     C                   Z-ADD     SZSDAT        ZDAYNO
      *
     C                   EXSR      ZDATE2
      *
      **  INCREMENT YEAR BY 1
      *
     C                   ADD       1             ZYEAR
     C                   MOVE      ZYEAR         ZDATE
      *
      * 29th February does not exist in a non-leap year.
      *
     C     ZMTH          IFEQ      02
     C     ZDAY          ANDEQ     29
     C                   Z-ADD     28            ZDAY
     C                   MOVEL     ZDAY          ZDATE
     C                   END
      *
      **  EXECUTE SUB-ROUTINE ZDATE1
      *
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        SZEDAT
      *
      **  CHECK TO SEE IF MATURITY DATE FALLS BETWEEN PERIOD END DATE
      **  AND PERIOD END DATE + 10 (THIS WILL ONLY HAPPEN IF AN FRA
      **  WAS ENTERED WITH AN INCREASED MATURITY DATE DUE TO THE
      **  ACTUAL MATURITY DATE FALLING ON A NON-WORKING DAY).
      **  IF IT DOES DO THE LATER DISCOUNTED SETTLEMENT AMOUNT
      **  CALCULATION UPTO MATURITY DATE OTHERWISE UPTO THE PERIOD
      **  END DATE. THE NUMBER 5 WAS CHOSEN AS THIS IS THE WORST
      **  POSIBLE CASE OF NON-WORKING DAYS IN A ROW (EASTER).
      *
     C     SZEDAT        ADD       10            #EDAT             5 0
      *
      **  IF END DATE IS GREATER THAN THE MATURITY DATE
      **  THEN REPLACE END DATE  BY MATURITY DATE
      *
     C     SZEDAT        IFGE      I#MDAT
     C     SZEDAT        ORLT      I#MDAT
     C     #EDAT         ANDGE     I#MDAT
     C                   SETON                                        89
     C                   Z-ADD     I#MDAT        SZEDAT
     C                   END
      *
      **  CALCULATE THE PERIOD BETWEEN START DATE AND END DATE
      *
     C     I#ICBS        IFEQ      1
     C     I#ICBS        OREQ      2
     C     I#ICBS        OREQ      6
     C     SZEDAT        SUB       SZSDAT        SZPER
     C                   END
      *
      **  IF THE END DATE IS LESS THAN OR EQUAL TO THE MATURITY DATE
      *
     C     *IN89         IFEQ      '0'
      *
     C     I#ICBS        IFEQ      3
     C     I#ICBS        OREQ      4
     C     I#ICBS        OREQ      7                                                          188050
     C     CIR004        ANDEQ     'Y'                                                        188050
     C                   Z-ADD     SZICVL        SZPER
     C                   END
      *
     C     I#ICBS        IFEQ      5
     C                   Z-ADD     365           SZPER
     C                   END
      *
     C                   ELSE
      *
      **  THE END DATE WAS REPLACED BY THE MATURITY DATE
      *
     C     I#ICBS        IFEQ      4
     C     I#ICBS        OREQ      5
     C     SZEDAT        SUB       SZSDAT        SZPER
      *
      **  CONVERT BOTH START AND END DAY NUMBERS TO DATES
      *
     C                   Z-ADD     SZSDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         Start_Date
      *
     C                   Z-ADD     SZEDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         End_Date
      *
      **  CALCULATE THE DAY NUMBER FOR 29 FEB IN THE START YEAR
      *
     C                   MOVEL     '2902'        Start_Date
     C                   Z-ADD     Start_Date    ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        Start_LpYr
      *
      **  IF A DAY NUMBER IS FOUND CHECK IF IT LIES BETWEEN START DATE
      **  AND END DATE
      *
     C     ErrorFlag     IFNE      'Y'
     C     Start_LpYr    IFGE      SZSDAT
     C     Start_LpYr    ANDLE     SZEDAT
     C     SZPER         SUB       1             SZPER
     C                   END
     C                   END
      *
      **  CALCULATE THE DAY NUMBER FOR 29 FEB IN THE END YEAR
      *
     C                   MOVEL     '2902'        End_Date
     C                   Z-ADD     End_Date      ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        End_LpYr
      *
     C     ErrorFlag     IFNE      'Y'
     C     End_LpYr      IFGE      SZSDAT
     C     End_LpYr      ANDLE     SZEDAT
     C     SZPER         SUB       1             SZPER
     C                   END
     C                   END
      *
     C                   END
      *
      **  FOR METHOD 3 SPLIT BOTH START AND END DATES INTO THEIR
      **  RESPECTIVE DAY,MONTH AND YEAR PORTIONS
      *
     C     I#ICBS        IFEQ      3
     C     I#ICBS        OREQ      7                                                          188050
     C     CIR004        ANDEQ     'Y'                                                        188050
      *
     C                   Z-ADD     0             SZPER

      * Start date, year, month, day

     C                   Z-ADD     SZSDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         Start_Date

     C                   MOVE      Start_Date    Start_Year
     C                   MOVE      Start_Date    W#04
     C                   MOVEL     W#04          Start_Mth
     C                   MOVEL     Start_Date    Start_Day

      * End date, year, month, day

     C                   Z-ADD     SZEDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         End_Date

     C                   MOVE      End_Date      End_Year
     C                   MOVE      End_Date      W#04
     C                   MOVEL     W#04          End_Mth
     C                   MOVEL     End_Date      End_Day
      *
      **  CHECK START DATE FOR LEAP YEAR
      *
     C     Start_Year    ADD       1900          Start_CYr
     C     Start_CYr     DIV       4             W#04
     C                   MVR                     Start_REM
      *
      **  CHECK END DATE FOR LEAP YEAR ALLOWING FOR CHANGE IN CENTURY
      *
     C     End_Year      ADD       1900          End_CYr
     C     End_CYr       IFLT      Start_CYr
     C                   ADD       100           End_CYr
     C                   END
     C     End_CYr       DIV       4             W#04
     C                   MVR                     End_REM
      *
      **  IF START MONTH DOES NOT EQUAL 2 SUBTRACT DAY PORTION FROM 30
      **  SETTING NEGATIVE RESULT TO ZERO FOR ACTUAL DAYS IN MONTH
      *
     C     Start_Mth     IFNE      2
     C     30            SUB       Start_Day     SZPER
     C     SZPER         IFLT      0
     C                   Z-ADD     0             SZPER
     C                   END
     C                   END
      *
      **  IF MONTH DOES EQUAL 2
      *
     C     Start_Mth     IFEQ      2
      *
      **  IF IT IS NOT A LEAP YEAR SUBTRACT DAY PORTION FROM 28
      *
     C     Start_REM     IFNE      0
     C     28            SUB       Start_Day     SZPER
     C                   ELSE
      *
      **  IF IT IS A LEAP YEAR SUBTRACT DAY PORTION FROM 29
      *
     C     29            SUB       Start_Day     SZPER
     C                   END
     C                   END
      *
      **  ADJUST START MONTH & YEAR TO CATER FOR YEAR END
      *
     C     Start_Mth     IFEQ      12
     C                   Z-ADD     0             Start_Mth
     C                   ADD       1             Start_CYr
     C                   END
      *
      **  IF END MONTH IS NOT EQUAL TO 2 AND END DAY IS 31; OR MONTH
      **  EQUALS 2 AND IT IS NOT A LEAP YEAR AND END DAY EQUALS 28;
      **  OR MONTH EQUALS 2 AND IT IS A LEAP YEAR AND END DAY
      **  EQUALS 29 THEN ADD 30 TO PERIOD COUNT
      *
     C     End_Mth       IFNE      2
     C     End_Day       ANDEQ     31
     C     End_Mth       OREQ      2
     C     End_REM       ANDNE     0
     C     End_Day       ANDEQ     28
     C     I#ICBS        ANDEQ     3                                                          188050
     C     End_Mth       OREQ      2
     C     End_REM       ANDEQ     0
     C     End_Day       ANDEQ     29
     C     I#ICBS        ANDEQ     3                                                          188050
      *
     C                   ADD       30            SZPER
      *
     C                   ELSE
      *
      **  ADD DAY NUMBER PORTION TO PERIOD COUNT
      *
     C                   ADD       End_Day       SZPER
      *
     C                   END
      *
      **  SUBTRACT 1 FROM END MONTH
      *
     C                   SUB       1             End_Mth
      *
      **  IF START YEAR AND END YEAR ARE THE SAME SUBTRACT START
      **  MONTH FROM END MONTH
      *
     C     Start_CYr     IFEQ      End_CYr
     C     End_Mth       SUB       Start_Mth     Num_Mths
     C                   ELSE
      *
      **  ADD END MTH TO THE RESULT OF SUBTRACTING START MONTH FROM 12
      *
     C     12            SUB       Start_Mth     Num_Mths
     C                   ADD       End_Mth       Num_Mths
     C                   END
      *
      **  MULTIPLY THE NUMBER OF MONTHS BY 30 AND ADD TO THE PERIOD
      *
     C                   MULT      30            Num_Mths
     C                   ADD       Num_Mths      SZPER
      *
     C                   END
      *
     C                   END
      *
      **  CALCULATE THIS PERIOD'S DISCOUNTED SETTLEMENT AMOUNT USING
      **  THIS EQUATION WHERE SS = SETTLEMENT AMOUNT
      **                       D = PERIOD
      **
      **        SS = (BASE RATE - FIXED RATE) x D x PRINCIPAL
      **             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      **             (INTEREST CALC BASIS x 100) + (BASE RATE x D)
      *
     C     I#FLT         IFGE      I#FIX
      *
     C     I#FLT         SUB       I#FIX         SZWRK1
      *
     C                   ELSE
      *
     C     I#FIX         SUB       I#FLT         SZWRK1
      *
     C                   END
      *
     C     SZWRK1        MULT      SZPER         SZWRK2
      *
      * Multiply now by principal to get larger value for dividing
      * and avoid errors due to half-adjusting small numbers later
      *
     C     SZWRK2        MULT      I#PAMT        SZWRK6
      *
     C     SZICVL        MULT      100           SZWRK3
     C     I#FLT         MULT      SZPER         SZWRK4
     C     SZWRK3        ADD       SZWRK4        SZWRK5
     C     SZWRK6        DIV(H)    SZWRK5        SZSETL
      *
      **  IF VALUE DATE = START DATE THEN FIRST PERIOD SO INITIALISE
      **  RUNNING DISCOUNT FACTOR TO 1
      *
     C     I#VDAT        IFEQ      SZSDAT
      *
     C                   Z-ADD     1             SZRDF
     C                   Z-ADD     SZSETL        O#RDS
     C                   ELSE
      **  DIVIDE THE DISCOUNTED SETTLEMENT AMOUNT BY THE RUNNING
      **  DISCOUNT FACTOR TO REDISCOUNT THIS PERIOD'S SETTLEMENT AMOUNT
      **  BACK TO START DATE
      *
     C     SZSETL        DIV(H)    SZRDF         SZRSA
      *
      **  ADD THE REDISCOUNTED SETTLEMENT AMOUNT TO THE RUNNING
      **  DISCOUNTED  SETTLEMENT TOTAL
      *
     C     SZRSA         ADD       O#RDS         O#RDS
      *
     C                   END
      *
      **  CALCULATE THIS PERIOD'S DISCOUNT FACTOR USING THE EQUATION
      **
      **    FACTOR = 1 +     (D x BASE RATE)
      **                 ~~~~~~~~~~~~~~~~~~~~~~~~~~
      **                 (INTEREST CALC BASIS x 100)
      *
     C     SZWRK4        DIV(H)    SZWRK3        SZWRK7
     C     1             ADD(H)    SZWRK7        SZDISC
      *
      **  MULTIPLY THE DISCOUNT FACTOR BY THE RUNNING DISCOUNT FACTOR
      **  TO OBTAIN THE NEW RUNNING DISCOUNT FACTOR FOR REDISCOUNTING
      **  SETTLEMENT AMOUNTS BACK TO START DATE
      *
     C     SZDISC        MULT(H)   SZRDF         SZRDF
      *
      *
      **  SET THE START DATE TO THE END DATE
      *
     C                   Z-ADD     SZEDAT        SZSDAT

     C                   ENDDO

     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      **********************************************************************
      * CONVERT DATE TO DAY NUMBER
      **********************************************************************
     C     ZDATE1        BEGSR
     C                   MOVEL     ZDATE         ZDATEI
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM      'D'           ZDATFM            1
     C                   PARM      *BLANK        ErrorFlag         1
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      **********************************************************************
      * CONVERT DAY NUMBER TO DATE
      **********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *ZERO         ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM

     C                   MOVE      ZDATE         ZYEAR             2 0
     C                   MOVE      ZDATE         W#04
     C                   MOVEL     W#04          ZMTH              2 0
     C                   MOVEL     ZDATE         ZDAY              2 0

     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
