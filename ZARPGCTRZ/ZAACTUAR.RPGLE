     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Actuarial Interpolation of a Rate')
      *****************************************************************
      *                                                               *
      *  Midas - ZAACTUAR ILE Module                                  *
      *                                                               *
      *  ZAACTUAR - Actuarial Interpolation of a Rate                 *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG11193           Date 02May06               *
      *                 BUG11164           Date 06Apr06               *
      *                 BUG9961            Date 19Jan06               *
      *                 237063             Date 20Nov05               *
      *                 236985             Date 11Aug05               *
      *                 236696                 Date 22Jul05           *
      *                 234440      *CREATE    Date 22Jun05           *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG11193 - Purchased Interest not calculated on BackValued   *
      *             Trade. (Recompile)                                *
      *  BUG11164 - A Serious Midas Error on SETRAD insert/amend      *
      *  BUG9961- Parameter mismatch for ZDYYR due to changes made    *
      *           by CSE071 and CAP087.                               *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  236985 - Call ZAINTPL2 for zero-coupon                       *
      *  236696 - Leave program when ZDDAYS is equal to 0 (DYBS equal *
      *           to 4...)                                            *
      *  234440 - Change control                                      *
      *                                                               *
      *****************************************************************
 
      ** Clear outputs
 
     C                   MOVEL     *BLANK        ReturnCode
     C                   Z-ADD     0             FiscalPrice      15 8
 
      ** Bad input
 
     C     IssueDate     IFEQ      *ZERO
     C     IssuePrice    OREQ      *ZERO
     C     MaturityDate  OREQ      *ZERO
     C     MaturityPrice OREQ      *ZERO
     C     IssueDate     ORGE      MaturityDate
     C     ValueDate     OREQ      *ZERO
     C     ValueDate     ORLT      IssueDate
     C     ValueDate     ORGT      MaturityDate
     C     DayBasis      OREQ      *BLANK
     C     DivBasis      OREQ      *BLANK
     C                   MOVEL     '*INPUT'      ReturnCode
     C                   RETURN
     C                   ENDIF
 
      ** No calculation required
 
     C     ValueDate     IFEQ      IssueDate
     C                   Z-ADD     IssuePrice    FiscalPrice
     C                   RETURN
     C                   ENDIF
     C     ValueDate     IFEQ      MaturityDate
     C                   Z-ADD     MaturityPrice FiscalPrice
     C                   RETURN
     C                   ENDIF
 
 
      ** Determine the next coupon date after the issue date
 
     C                   Z-ADD     IssueDate     ZZLCD
     C     IssueDate     ADD       1             ECD               5 0
     C                   EXSR      ZNCD
 
      ** Number of days from Issue Date to Maturity Date
 
     C                   Z-ADD     IssueDate     ZSDATE
     C                   Z-ADD     MaturityDate  ZEDATE
     C                   EXSR      ZDAYS
     C                   Z-ADD     ZDDAYS        NumberOfDays      5 0
                                                                                              236696
     C     ZDDAYS        IFEQ      *ZERO                                                      236696
     C**********         MOVEL     '*INPUT'      ReturnCode                            236696 236985
     C                   CALLB     'ZAINTPL2'                                                 236985
     C                   PARM                    IssueDate                                    236985
     C                   PARM                    ValueDate                                    236985
     C                   PARM                    MaturityDate                                 236985
     C                   PARM                    IssuePrice                                   236985
     C                   PARM                    MaturityPrice                                236985
                                                                                              236985
      ** Fiscal Price                                                                         236985
     C                   PARM                    FiscalPrice                                  236985
                                                                                              236985
     C                   RETURN                                                               236696
     C                   ENDIF                                                                236696
 
      ** Number of days in a year
 
     C                   Z-ADD     IssueDate     ECD
     C                   EXSR      ZDYYR
     C                   Z-ADD     ZINTDD        DaysInAYear       5 0
     C                   IF        DaysInAYear = 0
     C                   Eval      DaysInAYear = 360
     C                   ENDIF
 
      ** DETERMINE EFFECTIVE YIELD
 
     C                   Z-ADD     0             EffYield         15 8
     C                   eval      EffYield = 100 * (((MaturityPrice/IssuePrice)
     C                                        ** (DaysInAYear/NumberOfDays)) -1)
 
      ** Determine the last coupon date prior to the value date
 
     C     ValueDate     SUB       1             ZECD
     C                   EXSR      ZLCD
 
      ** Determine the next coupon date after the last coupon date
 
     C     ZZLCD         ADD       1             ECD               5 0
     C                   EXSR      ZNCD
 
      ** Number of days from Issue Date to Value Date
 
     C                   Z-ADD     IssueDate     ZSDATE
     C                   Z-ADD     ValueDate     ZEDATE
     C                   EXSR      ZDAYS
     C                   Z-ADD     ZDDAYS        NumberOfDays      5 0
 
      ** Number of days in a year
 
     C                   Z-ADD     ValueDate     ECD
     C                   EXSR      ZDYYR
     C                   Z-ADD     ZINTDD        DaysInAYear       5 0
     C                   IF        DaysInAYear = 0
     C                   Eval      DaysInAYear = 360
     C                   ENDIF
 
      ** DETERMINE FISCAL PRICE
 
     C                   Eval      FiscalPrice =  ((1 + (EffYield/100)) **
     C                                             (NumberOfDays/DaysInAYear))
     C                                            * IssuePrice
 
     C                   RETURN
 
      /SPACE 5
      *******************************************************************************
     C     ZLCD          BEGSR
     C                   CALLB     'ZLCD'
 
      * INPUTS
 
      * Security details
     C                   PARM      IssueDate     ISSD              5 0
     C                   PARM      IssueDate     ITLD              5 0
     C                   PARM      IssueDate     FCPN              5 0
     C                   PARM      MaturityDate  MATY              5 0
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    LastCoupDate                               BUG11164
      *
      ** Event Control Date
      ** Date Format
     C                   PARM                    ZECD              5 0
     C                   PARM      'D'           BJDFIN            1
 
      ** Nominal Currency
      ** Security Investment Type
      ** Effect on Holidays on Coupon Dates
     C                   PARM      *BLANK        NMCY              3
     C                   PARM      *BLANK        SITP              3
     C                   PARM      *BLANK        BCNV              1
     C                   PARM                    HCY1              3                          237063
     C                   PARM                    HCY2              3                          237063
     C                   PARM                    HCY3              3                          237063
     C                   PARM                    HCY4              3                          237063
     C                   PARM                    HCY5              3                          237063
     C                   PARM                    HCY6              3                          237063
     C                   PARM                    HCY7              3                          237063
     C                   PARM                    HCY8              3                          237063
     C                   PARM                    HCY9              3                          237063
 
      * OUTPUTS
 
      ** Last Coupon Date before Control Date
     C                   PARM                    ZZLCD             5 0
     C                   ENDSR
      *******************************************************************************
      /SPACE 5
      *******************************************************************************
     C     ZNCD          BEGSR
     C                   CALLB     'ZNCD'
 
      * INPUTS
 
      ** Security details
     C                   PARM      IssueDate     ITLD              5 0
     C                   PARM      IssueDate     FCPN              5 0
     C                   PARM      MaturityDate  MATY              5 0
     C                   PARM                    CDArr
     C                   PARM                    CRArr
      *
      ** Event Control Date
      ** Date Format
     C                   PARM                    ECD               5 0
     C                   PARM      'D'           BJDFIN            1
 
      ** Nominal Currency
      ** Security Investment Type
      ** Effect on Holidays on Coupon Dates
     C                   PARM      *BLANK        NMCY              3
     C                   PARM      *BLANK        SITP              3
     C                   PARM      *BLANK        BCNV              1
 
      ** Last Coupon Date
     C                   PARM      ZZLCD         LCPN              5 0
     C                   PARM                    HCY1              3                          237063
     C                   PARM                    HCY2              3                          237063
     C                   PARM                    HCY3              3                          237063
     C                   PARM                    HCY4              3                          237063
     C                   PARM                    HCY5              3                          237063
     C                   PARM                    HCY6              3                          237063
     C                   PARM                    HCY7              3                          237063
     C                   PARM                    HCY8              3                          237063
     C                   PARM                    HCY9              3                          237063
 
      * OUTPUTS
 
      ** Next Coupon Date
     C                   PARM                    NCD
     C                   ENDSR
      *******************************************************************************
      /SPACE 5
      *******************************************************************************
     C     ZDAYS         BEGSR
     C                   CALLB     'ZDAYS'
 
      * INPUTS
 
      * start date
      * end date
     C                   PARM                    ZSDATE            5 0
     C                   PARM                    ZEDATE            5 0
 
      * Security details
     C                   PARM      DayBasis      DYBS              1
     C                   PARM      IssueDate     ITLD              5 0
     C                   PARM      IssueDate     LCPN              5 0
     C                   PARM      *ZERO         IADJ              3 0
     C                   PARM      *ZERO         CPNR             11 7
     C                   PARM      MaturityDate  MATY              5 0
     C                   PARM                    NCD               5 0
 
      * interest days adjustment
     C                   PARM      *BLANK        DADJN             1
 
      * day number accrued to
      * accrual type (Y=yield, I=interest, D=discount)
      * accrue last day indicator
     C                   PARM      *ZERO         ZIDNAT            2 0
     C                   PARM      *BLANK        ZACLT             1
     C                   PARM      *BLANK        ACLD              1
      *
      ** Date format indicator
     C                   PARM      'D'           BJDFIN            1
 
      * OUTPUTS
 
      * no of days
     C                   PARM                    ZDDAYS            5 0
 
      * day number accrued to
     C                   PARM                    ZODNAT            2 0
     C                   ENDSR
      *******************************************************************************
      /SPACE 5
      *******************************************************************************
     C     ZDYYR         BEGSR
     C                   CALLB     'ZDYYR'
 
      * INPUTS
 
      * Security details
     C                   PARM      DayBasis      DYBS              1
     C                   PARM      DivBasis      DVBS              1
     C                   PARM      IssueDate     ISSD              5 0
     C                   PARM      IssueDate     ITLD              5 0
     C                   PARM      ZZLCD         LCPN              5 0
     C                   PARM      ZZLCD         FCPN              5 0
     C                   PARM      MaturityDate  MATY              5 0
     C                   PARM      *ZERO         IADJ              3 0
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM      *ZERO         CPNR             11 7
 
      * interest days adjustment
     C                   PARM      *BLANK        DADJN             1
 
      * Next coupon date
     C                   PARM                    NCD               5 0
      *
      ** Event Control Date
      ** Date format indicator
     C                   PARM                    ECD               5 0
     C                   PARM      'D'           BJDFIN            1
                                                                                             BUG9961
      ** Holiday Currencies                                                                  BUG9961
                                                                                             BUG9961
     C                   PARM                    HCY1              3                         BUG9961
     C                   PARM                    HCY2              3                         BUG9961
     C                   PARM                    HCY3              3                         BUG9961
     C                   PARM                    HCY4              3                         BUG9961
     C                   PARM                    HCY5              3                         BUG9961
     C                   PARM                    HCY6              3                         BUG9961
     C                   PARM                    HCY7              3                         BUG9961
     C                   PARM                    HCY8              3                         BUG9961
     C                   PARM                    HCY9              3                         BUG9961
 
      * OUTPUTS
 
      ** No. of days in interest year
      ** Last Coupon date for div basis 5
     C                   PARM                    ZINTDD            5 0
     C                   PARM                    LCDD5             5 0
     C                   ENDSR
      *******************************************************************************
      /SPACE 5
      *******************************************************************************
     C     *INZSR        BEGSR
     C     *entry        PLIST
      ** Return Code
     C                   PARM                    ReturnCode       10
 
      ** INPUTS
      ** ======
 
      ** Security Details
     C                   PARM                    IssueDate         5 0
     C                   PARM                    IssuePrice       15 8
     C                   PARM                    MaturityDate      5 0
     C                   PARM                    MaturityPrice    15 8
     C                   PARM                    DayBasis          1
     C                   PARM                    DivBasis          1
     C                   PARM                    CDArr            48
     C                   PARM                    CRArr            12
     C                   PARM                    LastCoupDate      5 0                      BUG11164
      ** Value Date
     C                   PARM                    ValueDate         5 0
 
      ** OUTPUTS
      ** =======
 
      ** Fiscal Price
 
     C                   PARM                    FiscalPrice      15 8
     C                   ENDSR
      *******************************************************************************
      /SPACE 5
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
     C                   MOVEL     '*PSSR'       ReturnCode
     C                   MOVE      'Y'           W#RUN             1
     C                   DUMP
     C                   ENDIF
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
