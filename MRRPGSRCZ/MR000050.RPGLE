/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MR Update Period Numbers File')
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR000050 -  Update Period Numbers File                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CMR001             Date 01Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     FMRPERDL1  IF A E           K DISK
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D MON             S              3    DIM(12) CTDATA PERRCD(12)
 
 
     D                 DS
     D DayMonthYear            1      6  0
     D Day                     1      2  0
     D Month                   3      4  0
     D Year                    5      6  0
 
     D                 DS
     D YR                      1      2  0
     D YRA                     1      2
     D PR                      3      4  0
     D PRA                     3      4
 
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
     C**********************************************************************************
     C     REDUCEBY1MONTHBEGSR
     C                   SUB       1             Month
     C     Month         IFEQ      0
     C                   Z-ADD     12            Month
     C                   SUB       1             Year
     C                   ENDIF
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CAL_M         BEGSR
     C     PeriodNumber  IFEQ      0
     C                   Z-ADD     Year          CurrentYear       2 0
     C                   ENDIF
      * If a year has been crossed
      * Start advancing the period number
     C     Year          IFNE      CurrentYear
     C     PeriodNumber  CABGT     0             E_CAL_M
     C                   EVAL      PeriodNumber = 62 + PeriodNumber
     C                   Z-ADD     Year          CurrentYear
     C                   ENDIF
 
     C                   Z-ADD     Year          YR
     C                   Z-ADD     Month         PR
     C                   Z-ADD     PeriodNumber  PERDNO
     C                   EVAL      PERDDS = 'Calendar Month:'+YRA+'-'+PRA
     C                                      +' ('+Mon(PR)+YRA+')'
     C                   WRITE     MRPERDD0
     C                   SUB       1             PeriodNumber
     C                   EXSR      REDUCEBY1MONTH
     C     E_CAL_M       ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CAL_Q         BEGSR
     C     PeriodNumber  IFEQ      0
     C                   Z-ADD     Year          CurrentYear
     C                   ENDIF
      * If a year has been crossed
      * Start advancing the period number
     C     Year          IFNE      CurrentYear
     C     PeriodNumber  CABGT     0             E_CAL_Q
     C                   EVAL      PeriodNumber = 54 + PeriodNumber
     C                   Z-ADD     Year          CurrentYear
     C                   ENDIF
 
     C                   Z-ADD     Month         BaseMonth         2 0
     C                   EXSR      DET_Quarter
     C                   Z-ADD     Year          YR
     C                   Z-ADD     Quarter       PR
     C     MRPERDK       CHAIN     MRPERDD0                           99
     C   99              Z-ADD     PeriodNumber  PERDNO
     C   99              EVAL      PERDDS = 'Calendar Quarter:'+YRA+'-'+PRA
     C   99              WRITE     MRPERDD0
     C   99              SUB       1             PeriodNumber
     C                   EXSR      REDUCEBY1MONTH
     C     E_CAL_Q       ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CAL_H         BEGSR
     C     PeriodNumber  IFEQ      0
     C                   Z-ADD     Year          CurrentYear
     C                   ENDIF
      * If a year has been crossed
      * Start advancing the period number
     C     Year          IFNE      CurrentYear
     C     PeriodNumber  CABGT     0             E_CAL_H
     C                   EVAL      PeriodNumber = 52 + PeriodNumber
     C                   Z-ADD     Year          CurrentYear
     C                   ENDIF
 
     C                   Z-ADD     Month         BaseMonth         2 0
     C                   EXSR      DET_HalfYear
     C                   Z-ADD     Year          YR
     C                   Z-ADD     HalfYear      PR
     C     MRPERDK       CHAIN     MRPERDD0                           99
     C   99              Z-ADD     PeriodNumber  PERDNO
     C   99              EVAL      PERDDS = 'Calendar Half Year:'+YRA+'-'+PRA
     C   99              WRITE     MRPERDD0
     C   99              SUB       1             PeriodNumber
     C                   EXSR      REDUCEBY1MONTH
     C     E_CAL_H       ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CAL_Y         BEGSR
     C     PeriodNumber  IFEQ      0
     C                   Z-ADD     Year          CurrentYear
     C                   ENDIF
      * If a year has been crossed
      * Start advancing the period number
     C     Year          IFNE      CurrentYear
     C     PeriodNumber  CABGT     0             E_CAL_Y
     C                   EVAL      PeriodNumber = 51 + PeriodNumber
     C                   Z-ADD     Year          CurrentYear
     C                   ENDIF
 
     C                   Z-ADD     Year          YR
     C                   Z-ADD     0             PR
     C     MRPERDK       CHAIN     MRPERDD0                           99
     C   99              Z-ADD     PeriodNumber  PERDNO
     C   99              EVAL      PERDDS = 'Calendar Year:'+YRA
     C   99              WRITE     MRPERDD0
     C   99              SUB       1             PeriodNumber
     C                   EXSR      REDUCEBY1MONTH
     C     E_CAL_Y       ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     FIN_M         BEGSR
 
      * Determine Financial Year & Financial Month
 
     C                   EXSR      DET_FYFM
     C     PeriodNumber  IFEQ      0
     C                   Z-ADD     FY            CurrentYear
     C                   ENDIF
      * If a year has been crossed
      * Start advancing the period number
     C     FY            IFNE      CurrentYear
     C     PeriodNumber  CABGT     0             E_FIN_M
     C                   EVAL      PeriodNumber = 62 + PeriodNumber
     C                   Z-ADD     FY            CurrentYear
     C                   ENDIF
 
     C                   Z-ADD     FY            YR
     C                   Z-ADD     FM            PR
     C                   Z-ADD     PeriodNumber  PERDNO
     C                   EVAL      PERDDS = 'Financial Month:'+YRA+'-'+PRA
     C                   WRITE     MRPERDD0
     C                   SUB       1             PeriodNumber
     C                   EXSR      REDUCEBY1MONTH
     C     E_FIN_M       ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     FIN_Q         BEGSR
 
      * Determine Financial Year & Financial Month
 
     C                   EXSR      DET_FYFM
     C     PeriodNumber  IFEQ      0
     C                   Z-ADD     FY            CurrentYear
     C                   ENDIF
      * If a year has been crossed
      * Start advancing the period number
     C     FY            IFNE      CurrentYear
     C     PeriodNumber  CABGT     0             E_FIN_Q
     C                   EVAL      PeriodNumber = 54 + PeriodNumber
     C                   Z-ADD     FY            CurrentYear
     C                   ENDIF
 
     C                   Z-ADD     FM            BaseMonth         2 0
     C                   EXSR      DET_Quarter
     C                   Z-ADD     FY            YR
     C                   Z-ADD     Quarter       PR
     C     MRPERDK       CHAIN     MRPERDD0                           99
     C   99              Z-ADD     PeriodNumber  PERDNO
     C   99              EVAL      PERDDS = 'Financial Quarter:'+YRA+'-'+PRA
     C   99              WRITE     MRPERDD0
     C   99              SUB       1             PeriodNumber
     C                   EXSR      REDUCEBY1MONTH
     C     E_FIN_Q       ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     FIN_H         BEGSR
 
      * Determine Financial Year & Financial Month
 
     C                   EXSR      DET_FYFM
     C     PeriodNumber  IFEQ      0
     C                   Z-ADD     FY            CurrentYear
     C                   ENDIF
      * If a year has been crossed
      * Start advancing the period number
     C     FY            IFNE      CurrentYear
     C     PeriodNumber  CABGT     0             E_FIN_H
     C                   EVAL      PeriodNumber = 52 + PeriodNumber
     C                   Z-ADD     FY            CurrentYear
     C                   ENDIF
 
     C                   Z-ADD     FM            BaseMonth         2 0
     C                   EXSR      DET_HalfYear
     C                   Z-ADD     FY            YR
     C                   Z-ADD     HalfYear      PR
     C     MRPERDK       CHAIN     MRPERDD0                           99
     C   99              Z-ADD     PeriodNumber  PERDNO
     C   99              EVAL      PERDDS = 'Financial Half Year:'+YRA+'-'+PRA
     C   99              WRITE     MRPERDD0
     C   99              SUB       1             PeriodNumber
     C                   EXSR      REDUCEBY1MONTH
     C     E_FIN_H       ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     FIN_Y         BEGSR
 
      * Determine Financial Year & Financial Month
 
     C                   EXSR      DET_FYFM
     C     PeriodNumber  IFEQ      0
     C                   Z-ADD     FY            CurrentYear
     C                   ENDIF
      * If a year has been crossed
      * Start advancing the period number
     C     FY            IFNE      CurrentYear
     C     PeriodNumber  CABGT     0             E_FIN_Y
     C                   EVAL      PeriodNumber = 51 + PeriodNumber
     C                   Z-ADD     FY            CurrentYear
     C                   ENDIF
 
     C                   Z-ADD     FY            YR
     C                   Z-ADD     0             PR
     C     MRPERDK       CHAIN     MRPERDD0                           99
     C   99              Z-ADD     PeriodNumber  PERDNO
     C   99              EVAL      PERDDS = 'Financial Year:'+YRA
     C   99              WRITE     MRPERDD0
     C   99              SUB       1             PeriodNumber
     C                   EXSR      REDUCEBY1MONTH
     C     E_FIN_Y       ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     DET_FYFM      BEGSR
 
      * Financial year/month  is 3 months prior to calendar year/month
 
     C                   Z-ADD     Year          FY                2 0
     C                   Z-ADD     Month         FM                2 0
     C                   SUB       3             FM                     9999
     C   99              SUB       1             FY
     C   99              ADD       12            FM
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDATE             6 0          Value date
     C                   PARM      *blank        ZADATE            7            Run-date in DDM
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     DET_Quarter   BEGSR
     C                   SELECT
     C     BaseMonth     WHENGT    9
     C                   Z-ADD     4             Quarter           2 0
     C     BaseMonth     WHENGT    6
     C                   Z-ADD     3             Quarter
     C     BaseMonth     WHENGT    3
     C                   Z-ADD     2             Quarter
     C                   OTHER
     C                   Z-ADD     1             Quarter
     C                   ENDSL
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     DET_HalfYear  BEGSR
     C                   SELECT
     C     BaseMonth     WHENGT    6
     C                   Z-ADD     2             HalfYear          2 0
     C                   OTHER
     C                   Z-ADD     1             HalfYear
     C                   ENDSL
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         RunDMY            6
 
      * CALENDAR Months
 
     C                   MOVEL     'C'           CAFI
     C                   MOVEL     'M'           PERTYP
     C                   Z-ADD     0             PeriodNumber      2 0
     C                   MOVEL     RunDMY        DayMonthYear
     C                   DO        24
     C                   EXSR      CAL_M
     C                   ENDDO
 
      * CALENDAR Quarters
 
     C                   MOVEL     'C'           CAFI
     C                   MOVEL     'Q'           PERTYP
     C                   Z-ADD     0             PeriodNumber
     C                   MOVEL     RunDMY        DayMonthYear
     C                   DO        24
     C                   EXSR      CAL_Q
     C                   ENDDO
 
      * CALENDAR Half-Years
 
     C                   MOVEL     'C'           CAFI
     C                   MOVEL     'H'           PERTYP
     C                   Z-ADD     0             PeriodNumber
     C                   MOVEL     RunDMY        DayMonthYear
     C                   DO        24
     C                   EXSR      CAL_H
     C                   ENDDO
 
      * CALENDAR Years
 
     C                   MOVEL     'C'           CAFI
     C                   MOVEL     'Y'           PERTYP
     C                   Z-ADD     0             PeriodNumber
     C                   MOVEL     RunDMY        DayMonthYear
     C                   DO        24
     C                   EXSR      CAL_Y
     C                   ENDDO
 
      * FINANCIAL Months
 
     C                   MOVEL     'F'           CAFI
     C                   MOVEL     'M'           PERTYP
     C                   Z-ADD     0             PeriodNumber      2 0
     C                   MOVEL     RunDMY        DayMonthYear
     C                   DO        24
     C                   EXSR      FIN_M
     C                   ENDDO
 
      * FINANCIAL Quarters
 
     C                   MOVEL     'F'           CAFI
     C                   MOVEL     'Q'           PERTYP
     C                   Z-ADD     0             PeriodNumber
     C                   MOVEL     RunDMY        DayMonthYear
     C                   DO        24
     C                   EXSR      FIN_Q
     C                   ENDDO
 
      * FINANCIAL Half-Years
 
     C                   MOVEL     'F'           CAFI
     C                   MOVEL     'H'           PERTYP
     C                   Z-ADD     0             PeriodNumber
     C                   MOVEL     RunDMY        DayMonthYear
     C                   DO        24
     C                   EXSR      FIN_H
     C                   ENDDO
 
      * FINANCIAL Years
 
     C                   MOVEL     'F'           CAFI
     C                   MOVEL     'Y'           PERTYP
     C                   Z-ADD     0             PeriodNumber
     C                   MOVEL     RunDMY        DayMonthYear
     C                   DO        24
     C                   EXSR      FIN_Y
     C                   ENDDO
 
     C     MRPERDK       KLIST
     C                   KFLD                    CAFI
     C                   KFLD                    PERTYP
     C                   KFLD                    YR
     C                   KFLD                    PR
 
     C                   ENDSR
     C**********************************************************************************
** MON
JanFebMarAprMayJunJulAugSepOctNovDec
