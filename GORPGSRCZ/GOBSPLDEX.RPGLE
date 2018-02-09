     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO BSPL Dates To Extract')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSPLDEX - BSPL Dates to Extract                            *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
 
     D #_EOMD          S              5S 0 DIM(24) ASCEND
     D #_EOQD          S              5S 0 DIM(8)  ASCEND
     D #_EOHD          S              5S 0 DIM(4)  ASCEND
     D #_EOYD          S              5S 0 DIM(2)  ASCEND
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     D                 DS
     D DayMonthYear            1      6  0
     D Day                     1      2  0
     D Month                   3      4  0
     D Year                    5      6  0
 
 
      * Get Global Financial Year-End Month
 
     C                   EXSR      GET_FINYEMTH
     C                   MOVEL     P@VL01        FinYearEndMth     2 0
 
      * Determine FINANCIAL End of Month Dates
 
     C                   EXSR      Fin_EOMDates
 
      * Determine CALENDAR period-end date
 
     C                   EXSR      Cal_PerEndDate
 
      * If movements required
      * Determine CALENDAR period start date
 
     C     I#RPTYP       IFEQ      'M'
     C                   EXSR      Cal_PerStrDate
     C                   ENDIF
 
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      **********************************************************************************
      * Get Global Financial Year-End Month
      **********************************************************************************
     C     GET_FINYEMTH  BEGSR
     C                   EVAL      P@OP01 = 'GlobFinancialYEMonth'
     C                   CALL      'GPAOSVALR0'
     C                   PARM      *BLANK        P@RTCD            7
     C                   PARM                    P@OP01           20
     C                   PARM                    P@VL01          200
     C                   PARM                    P@OP02           20
     C                   PARM                    P@VL02          200
     C                   PARM                    P@OP03           20
     C                   PARM                    P@VL03          200
     C                   PARM                    P@OP04           20
     C                   PARM                    P@VL04          200
     C                   PARM                    P@OP05           20
     C                   PARM                    P@VL05          200
     C                   PARM                    P@OP06           20
     C                   PARM                    P@VL06          200
     C                   PARM                    P@OP07           20
     C                   PARM                    P@VL07          200
     C                   PARM                    P@OP08           20
     C                   PARM                    P@VL08          200
     C                   PARM                    P@OP09           20
     C                   PARM                    P@VL09          200
     C                   PARM                    P@OP10           20
     C                   PARM                    P@VL10          200
      * error
     C     P@RTCD        IFNE      *BLANK
     C                   EVAL      I#ERMS = 'MISSING GLOBAL SYSTEM VALUE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Determine FINANCIAL End of Month Dates
      **********************************************************************************
     C     Fin_EOMDates  BEGSR
 
     C                   MOVE      *BLANK        #_EOMD
     C                   MOVE      *BLANK        #_EOQD
     C                   MOVE      *BLANK        #_EOHD
     C                   MOVE      *BLANK        #_EOYD
 
      * Convert current run date to day, month and year
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DayMonthYear
 
      * Last day of current financial year
 
     C     Month         IFGT      FinYearEndMth
     C                   ADD       1             Year
     C                   ENDIF
     C                   Z-ADD     31            Day
     C                   Z-ADD     FinYearEndMth Month
 
      * Determine Day Number
 
     C                   MOVEL     DayMonthYear  ZDATE
     C                   EXSR      ZDATE1
     C     ZERR          DOWNE     *BLANK
     C                   SUB       1             Day
     C                   MOVEL     DayMonthYear  ZDATE
     C                   EXSR      ZDATE1
     C                   ENDDO
 
      * End of Period Dates
      * =====================
 
     C                   Z-ADD     24            MthNum            2 0
     C     MthNum        DOWGT     0
 
      * MONTHLY Periods
 
     C                   Z-ADD     ZDAYNO        #_EOMD(MthNum)
 
      * QUARTERLY Periods
 
     C     MthNum        DIV       3             PerNum            2 0
     C                   MVR                     Rem               2 0    99
     C   99              Z-ADD     ZDAYNO        #_EOQD(PerNum)
 
      * HALF-YEARLY Periods
 
     C     MthNum        DIV       6             PerNum
     C                   MVR                     Rem                      99
     C   99              Z-ADD     ZDAYNO        #_EOHD(PerNum)
 
      * YEARLY Periods
 
     C     MthNum        DIV       12            PerNum
     C                   MVR                     Rem                      99
     C   99              Z-ADD     ZDAYNO        #_EOYD(PerNum)
 
     C                   SUB       1             MthNum
 
      * Go to previous month
 
     C                   Z-ADD     31            Day
     C                   SUB       1             Month
     C     Month         IFEQ      0
     C                   Z-ADD     12            Month
     C                   SUB       1             Year
     C                   ENDIF
 
      * Determine Day Number
 
     C                   MOVEL     DayMonthYear  ZDATE
     C                   EXSR      ZDATE1
     C     ZERR          DOWNE     *BLANK
     C                   SUB       1             Day
     C                   MOVEL     DayMonthYear  ZDATE
     C                   EXSR      ZDATE1
     C                   ENDDO
 
     C                   ENDDO
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Determine CALENDAR period end date
      **********************************************************************************
     C     Cal_PerEndDateBEGSR
 
     C                   Z-ADD     31            Day
     C                   MOVEL     I#CMTH        Month
     C                   MOVEL     I#CYR         Year
 
     C                   MOVEL     DayMonthYear  ZDATE
     C                   EXSR      ZDATE1
     C     ZERR          DOWNE     *BLANK
     C                   SUB       1             Day
     C                   MOVEL     DayMonthYear  ZDATE
     C                   EXSR      ZDATE1
     C     Day           IFEQ      0
     C                   EVAL      I#ERMS = 'INVALID CALENDAR YEAR/MONTH'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO
 
     C                   Z-ADD     ZDAYNO        O#PEDT
 
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Determine CALENDAR period start date
      **********************************************************************************
     C     Cal_PerStrDateBEGSR
     C                   Z-ADD     1             PerNum
 
     C                   SELECT
 
     C     I#RMDUR       WHENEQ    'M'
     C     O#PEDT        LOOKUP    #_EOMD(PerNum)                     99  99
     C                   SUB       1             PerNum                   99
     C  N99              Z-ADD     #_EOMD(PerNum)O#PSDT
 
     C     I#RMDUR       WHENEQ    'Q'
     C     O#PEDT        LOOKUP    #_EOQD(PerNum)                     99  99
     C                   SUB       1             PerNum                   99
     C  N99              Z-ADD     #_EOQD(PerNum)O#PSDT
 
     C     I#RMDUR       WHENEQ    'X'
     C     O#PEDT        LOOKUP    #_EOHD(PerNum)                     99  99
     C                   SUB       1             PerNum                   99
     C  N99              Z-ADD     #_EOHD(PerNum)O#PSDT
 
     C     I#RMDUR       WHENEQ    'Y'
     C     O#PEDT        LOOKUP    #_EOYD(PerNum)                     99  99
     C                   SUB       1             PerNum                   99
     C  N99              Z-ADD     #_EOYD(PerNum)O#PSDT
 
     C                   ENDSL
 
      * If the period start date is NOT in the current financial period end-dates
 
     C     *IN99         IFEQ      *ON
 
      * Return ZERO Period Start Date year and month
 
     C                   MOVEL     '00'          O#PSCMTH
     C                   MOVEL     '00'          O#PSCYR
     C                   ELSE
 
      * Else, Determine Period Start Date year and Month
 
     C                   Z-ADD     O#PSDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DayMonthYear
     C                   MOVEL     Month         O#PSCMTH
     C                   MOVEL     Year          O#PSCYR
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDATE             6 0          Value date
     C                   PARM      *blank        ZADATE            7            Run-date in DDM
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      **********************************************************************************
     C     ZDATE1        BEGSR
     C                   CALL      'ZDATE1'
     C                   PARM      *blank        ZERR              7            error code
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDAYNO            5 0          Value date
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
      **********************************************************************************
      * *INZSR - Initial Processing
      **********************************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * Calendar Year
      * Calendar Month
 
     C                   PARM                    I#CYR             2
     C                   PARM                    I#CMTH            2
      * Report Type
      * Report Movement Duration
     C                   PARM                    I#RPTYP           1
     C                   PARM                    I#RMDUR           1
 
      * OUTPUTS
 
      * Period End Date
     C                   PARM                    O#PEDT            5 0
 
      * Period Start Date
      * Period Start Calendar Year
      * Period Start Calendar Month
     C                   PARM                    O#PSDT            5 0
     C                   PARM                    O#PSCYR           2
     C                   PARM                    O#PSCMTH          2
 
      * Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
