     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA: Calc number of days between two dates')
      *****************************************************************
      *                                                               *
      *  Midas - Copy Source converted into ILE procedures            *
      *                                                               *
      *  ZDAYS   -   Calculate number of days between two dates       *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the ZDAYS         *
      *  subroutine.  The subroutine consists of three /COPY members. *
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
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. 149162             Date 14Oct98               *
      *                 CAP002  *CREATE    Date 21Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  149162 - Int. calc. incorrect at end of Feb for 30 day method*
      *           (core fix 102506 changes ZDAYS and ZDYYR)           *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      ** +-----------------------------------------------------------------+
      ** Declares for variables that were defined externally for the
      ** original copy members
      ** +-----------------------------------------------------------------+
 
 
      ** +-----------------------------------------------------------------+
 
      ** +--- The converted ZDAYSZ1 starts here --------------------------+
     D ZF29            S              5  0 DIM(32) CTDATA PERRCD(14)            29TH FEB ARRAY
      ** +--- The converted ZDAYSZ1 ends here ----------------------------+
 
      * day basis from sectyd
     D  DYBS           S              1A
      * initial date from sectyd
     D  ITLD           S              5P 0
      * last coupon date from sectyd
     D  LCPN           S              5P 0
      * interest adjustment days from sectyd
     D  IADJ           S              3P 0
      * Coupon rate from sectyd                                                 149162
     D  CPNR           S             11P 7                                      149162
      * Maturity date from sectyd                                               149162
     D  MATY           S              5P 0                                      149162
      * Next coupon date passed as a parameter from calling program.            149162
     D  NCD            S              5P 0                                      149162
      ** Date format indicator passed as a parameter from calling program.
     D  BJDFIN         S              1A
 
      **Internal work variables**
      * start date (before call module ZDATE2)
     D  ZDAYNO         S              5P 0
      **  Date field returned from ZDATE2 after conversion from MIDAS day number.
     D  ZADATE         S              7A
      ** Numerical date format after conversion from MIDAS day number from ZDATE2
     D  ZDATE          S              6P 0
 
      * Set indicator 98 from BJDFIN
 
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ELSE
     C                   SETOFF                                       98
     C                   END
 
      ** Execute the standard subroutine
     C                   EXSR      ZDAYS
 
 
     C                   RETURN
      /EJECT
      ** +--- The converted ZDAYSZ2 starts here --------------------------+
     C**********************************************************************
     C**
     C**  ZDAYS  SUBROUTINE TO CALCULATE NO. OF DAYS BETWEEN TWO DATES
     C**            FOR INTEREST CALCULATIONS
     C**
     C**  INPUT - ZSDATE (5,0) START DATE
     C**          ZEDATE (5,0) END DATE
     C**          DYBS   (1)   DAY BASIS FROM SECTYD
     C**          LCPN   (5,0) LAST COUPON DATE FROM SECTYD
     C**          ITLD   (5,0) INITIAL DATE FROM SECTYD
     C**          IADJ   (3,0) INTEREST ADJUSTMENT DAYS FROM SECTYD
     C**          ARRAY 'ZF29' 29TH FEB DAYS
     C**
     C**  OUTPUT - ZDDAYS (5,0) NO OF DAYS
     C**
     C**  CALLS ZDATE2
     C**
     C********************************************************************
     C*
     C     ZDAYS         BEGSR                                                  ** ZDAYS BEGSR **
     C*
     C* DEFINE INPUT FIELDS
     C*
     C                   Z-ADD     ZSDATE        ZSDATE            5 0
     C                   Z-ADD     ZEDATE        ZEDATE            5 0
     C                   MOVE      DADJN         DADJN             1                           10001
     C                   Z-ADD     ZIDNAT        ZIDNAT            2 0                        149162
     C                   MOVE      ZACLT         ZACLT             1                          149162
     C                   MOVE      ACLD          ACLD              1                          149162
     C* OUTPUT FIELDS                                                     149162
     C                   Z-ADD     *ZERO         ZODNAT            2 0                        149162
     C*
     C* IF START DATE IS GREATER THAN END DATE
     C*       OUTPUT DAY DIFFERENCE AS 0
     C*
     C     ZSDATE        IFGT      ZEDATE
     C                   Z-ADD     0             ZDDAYS
     C                   GOTO      EZDAYS
     C                   END
     C*
     C* IF DAY BASIS IS 4 (FLAT - NO INTEREST TO BE ACCRUED)
     C*
     C     DYBS          IFEQ      '4'
     C                   Z-ADD     0             ZDDAYS            5 0
     C                   GOTO      EZDAYS
     C                   END
     C*
     C*****IF*DAY*BASIS*IS*1*-*(30*DAY*MONTHS*INCLUDING*'30TH FEB')**     E20085
     C***  If Day Basis = 1 or 5, (30 Day months incl. '30th Feb.').      E20085
     C*
     C** CONVERT INPUT DATES TO DD/MM/YY OR MM/DD/YY FORMAT
     C*
     C     DYBS          IFEQ      '1'
     C     DYBS          OREQ      '5'                                                         E2008
     C                   Z-ADD     ZSDATE        ZDAYNO
     C                   EXSR      ZDATE2
     C*
     C                   MOVE      ZDATE         ZYR1              2 0
     C     *IN98         IFEQ      '0'
     C                   MOVEL     ZDATE         ZDY1              2 0
     C                   MOVE      ZDATE         ZWRK4             4 0
     C                   MOVEL     ZWRK4         ZMT1              2 0
     C                   ELSE
     C                   MOVEL     ZDATE         ZMT1
     C                   MOVEL     ZDATE         ZWRK4
     C                   MOVE      ZWRK4         ZDY1
     C                   END
     C*
     C                   Z-ADD     ZEDATE        ZDAYNO
     C                   EXSR      ZDATE2
     C*
     C                   MOVE      ZDATE         ZYR2              2 0
     C     *IN98         IFEQ      '0'
     C                   MOVEL     ZDATE         ZDY2              2 0
     C                   MOVE      ZDATE         ZWRK4             4 0
     C                   MOVEL     ZWRK4         ZMT2              2 0
     C                   ELSE
     C                   MOVEL     ZDATE         ZMT2
     C                   MOVEL     ZDATE         ZWRK4
     C                   MOVE      ZWRK4         ZDY2
     C                   END
     C*                                                                   149162
     C** Use day number accrued to (if defined) as start day              149162
     C*                                                                   149162
     C     ZIDNAT        IFNE      *ZERO                                                      149162
     C                   Z-ADD     ZIDNAT        ZDY1                                         149162
     C                   END                                                                  149162
     C*
     C******CHANGE*DAYS*TO*30*IF*31********                               E20085
     C**  If Start Day is 31, change it to 30.                            E20085
     C*
     C     ZDY1          IFEQ      31
     C                   MOVE      30            ZDY1
     C                   END
     C*                                                                   E20085
     C***  If Day Basis = '1', then if End Day is 31, change it to 30.    E20085
     C*                                                                   E20085
     C     DYBS          IFEQ      '1'                                                         E2008
     C     ZDY2          IFEQ      31
     C                   MOVE      30            ZDY2
     C                   END
     C                   END                                                                   E2008
     C***********                                                  086491 149162
     C*****If*day*basis*=*'1'                                      086491 149162
     C*****Check*if*start*day*is*last*day*of*february              086491 149162
     C***********DYBS      IFEQ '1'                        B2      086491 149162
     C***********ZDY1      IFGE 28                         B3      086491 149162
     C***********ZMT1      ANDEQ2                                  086491 149162
     C***********ZYR1      DIV  4         LEAP    30               086491 149162
     C***********          MVR            LEAP                     086491 149162
     C***********LEAP      IFEQ 0                          B4 LEAP 086491 149162
     C***********ZDY1      IFEQ 29                         B5      086491 149162
     C***********          Z-ADD30        ZDY1                     086491 149162
     C***********          END                             E5      086491 149162
     C***********          ELSE                            X4 NOT  086491 149162
     C***********ZDY1      IFEQ 28                         B5      086491 149162
     C***********          Z-ADD30        ZDY1                     086491 149162
     C***********          END                             E5      086491 149162
     C***********          END                             E4      086491 149162
     C***********          END                             E3      086491 149162
     C*****Check*if*end*day*is*last*day*of*february                086491 149162
     C***********ZDY2      IFGE 28                         B3      086491 149162
     C***********ZMT2      ANDEQ2                                  086491 149162
     C***********ZYR2      DIV  4         LEAP                     086491 149162
     C***********          MVR            LEAP                     086491 149162
     C***********LEAP      IFEQ 0                          B4 LEAP 086491 149162
     C***********ZDY2      IFEQ 29                         B5      086491 149162
     C***********          Z-ADD30        ZDY2                     086491 149162
     C***********          END                             E5      086491 149162
     C***********          ELSE                            X4 NOT  086491 149162
     C***********ZDY2      IFEQ 28                         B5      086491 149162
     C***********          Z-ADD30        ZDY2                     086491 149162
     C***********          END                             E5      086491 149162
     C***********          END                             E4      086491 149162
     C***********          END                             E3      086491 149162
     C***********          END                             E2      086491 149162
     C*                                                                   149162
     C***  If Day Basis = '5', if Start Day is 30 or 31,                  149162
     C***  and End Day is 31, change it to 30.                            149162
     C*                                                                   149162
     C     DYBS          IFEQ      '5'                                                        149162
     C     ZDY1          IFEQ      30                                                         149162
     C     ZDY1          OREQ      31                                                         149162
     C     ZDY2          IFEQ      31                                                         149162
     C                   MOVE      30            ZDY2                                         149162
     C                   END                                                                  149162
     C                   END                                                                  149162
     C                   END                                                                  149162
     C*                                                                   149162
     C***  If Last Day Accruals                                           149162
     C*                                                                   149162
     C     ACLD          IFEQ      'Y'                                                        149162
     C*                                                                   149162
     C***  If Start Date is not maturity date (just for yield accrual)    149162
     C***   Allow for accrual from the start of February                  149162
     C*                                                                   149162
     C     ZACLT         IFEQ      'Y'                                                        149162
     C     ZSDATE        ANDNE     MATY                                                       149162
     C     CPNR          ANDEQ     *ZERO                                                      149162
     C*                                                                   149162
     C***  If Start Date is last day of February                          149162
     C*                                                                   149162
     C     ZMT1          IFEQ      2                                                          149162
     C** 28th?                                                            149162
     C     ZDY1          IFEQ      28                                                         149162
     C     ZSDATE        ADD       1             DAY29             5 0                        149162
     C     DAY29         LOOKUP    ZF29                                   95                  149162
     C     *IN95         IFEQ      '0'                                                        149162
     C                   MOVE      30            ZDY1                                         149162
     C                   MOVE      30            ZODNAT                                       149162
     C                   END                                                                  149162
     C                   END                                                                  149162
     C** 29th?                                                            149162
     C     ZDY1          IFEQ      29                                                         149162
     C                   MOVE      30            ZDY1                                         149162
     C                   MOVE      30            ZODNAT                                       149162
     C                   END                                                                  149162
     C*                                                                   149162
     C                   END                                                                  149162
     C                   END                                                                  149162
     C*                                                                   149162
     C***  If End Date is not a coupon date (just for interest accrual)   149162
     C***  or End Date is not maturity date (just for discount accrual)   149162
     C***   Allow for accrual to the end of February                      149162
     C*                                                                   149162
     C     ZACLT         IFEQ      'I'                                                        149162
     C     ZEDATE        ANDNE     NCD                                                        149162
     C     ZACLT         OREQ      'D'                                                        149162
     C     ZEDATE        ANDNE     MATY                                                       149162
     C*                                                                   149162
     C***  If End Date is last day of February                            149162
     C*                                                                   149162
     C     ZMT2          IFEQ      2                                                          149162
     C** 28th?                                                            149162
     C     ZDY2          IFEQ      28                                                         149162
     C     ZEDATE        ADD       1             DAY29             5 0                        149162
     C     DAY29         LOOKUP    ZF29                                   95                  149162
     C     *IN95         IFEQ      '0'                                                        149162
     C                   MOVE      30            ZDY2                                         149162
     C                   MOVE      30            ZODNAT                                       149162
     C                   END                                                                  149162
     C                   END                                                                  149162
     C** 29th?                                                            149162
     C     ZDY2          IFEQ      29                                                         149162
     C                   MOVE      30            ZDY2                                         149162
     C                   MOVE      30            ZODNAT                                       149162
     C                   END                                                                  149162
     C*                                                                   149162
     C                   END                                                                  149162
     C                   END                                                                  149162
     C                   END                                                                  149162
     C***********                                                  E20085 149162
     C*****If*the*Day*Basis*=*'5';*first*process*a*February*Start* E20085 149162
     C***********                                                  E20085 149162
     C***********DYBS      IFEQ '5'                                E20085 149162
     C***********                                                  E20085 149162
     C***********ZMT1      IFEQ 2                                  E20085 149162
     C***********ZDY1      ANDGE28                                 E20085 149162
     C***********                                                  E20085 149162
     C*****If*Start*Date*is*LAST*Day*of*February,*change*it*to*30. E20085 149162
     C*****Note:*for*the*28th,*must*check*that*the*29th*is*not*in* E20085 149162
     C***********                                                  E20085 149162
     C***********ZDY1      IFEQ 29                                 E20085 149162
     C***********          MOVE 30        ZDY1                     E20085 149162
     C***********          ELSE                                    E20085 149162
     C***********ZSDATE    ADD  1         DAY29   50               E20085 149162
     C***********DAY29     LOKUPZF29                     95        E20085 149162
     C************IN95     IFEQ '0'                                E20085 149162
     C***********          MOVE 30        ZDY1                     E20085 149162
     C***********          END                                     E20085 149162
     C***********          END                                     E20085 149162
     C***********                                                  E20085 149162
     C***********          END                                     E20085 149162
     C***********                                                  E20085 149162
     C*****If*the*Start*Day*is*30*and*the*End*Day*is*31,*then*move E20085 149162
     C*****to*the*End*Day,*Else*for*DYBS*5,*we*just*leave*it*alone E20085 149162
     C***********                                                  E20085 149162
     C***********ZDY1      IFEQ 30                                 E20085 149162
     C***********ZDY2      ANDEQ31                                 E20085 149162
     C***********          MOVE 30        ZDY2                     E20085 149162
     C***********          END                                     E20085 149162
     C***********                                                  E20085 149162
     C***********          END                                     E20085 149162
     C*
     C** IF END DAY IS LESS THAN START DAY - ADD 30 TO END DAY AND
     C**   REDUCE END MONTH BY 1
     C*
     C     ZDY2          IFLT      ZDY1
     C                   ADD       30            ZDY2
     C     ZMT2          SUB       1             ZMT2
     C                   END
     C*
     C** CALCULATE DAY DIFFERENCE
     C*
     C     ZDY2          SUB       ZDY1          ZDYDF             5 0
     C*
     C** IF START MONTH GREATER THAN END MONTH - ADD 12 TO END MONTH
     C** AND REDUCE END YEAR BY 1
     C*
     C     ZMT1          IFGT      ZMT2
     C                   ADD       12            ZMT2
     C     ZYR2          IFEQ      00
     C                   Z-ADD     99            ZYR2
     C                   ELSE
     C     ZYR2          SUB       1             ZYR2
     C                   END
     C                   END
     C*
     C** CALCULATE MONTH DIFFERENCE IN DAYS
     C*
     C     ZMT2          SUB       ZMT1          ZMTDF             5 0
     C*
     C     ZMTDF         MULT      30            ZMTDF
     C     ZDYDF         ADD       ZMTDF         ZDDAYS            5 0
     C*
     C** SUBTRACT START YEAR FROM END YEAR - IF RESULT LESS THAN 0
     C** THEN ADD 100 FOR CHANGE IN CENTURY
     C*
     C     ZYR2          SUB       ZYR1          ZYRDF             5 0
     C     ZYRDF         IFLT      0
     C                   ADD       100           ZYRDF
     C                   END
     C*
     C** CALCULATE YEAR DIFFERENCE IN DAYS
     C*
     C     360           MULT      ZYRDF         ZYRDF
     C*
     C     ZDDAYS        ADD       ZYRDF         ZDDAYS
     C*
     C                   END
     C*
     C* IF DAY BASIS IS '2' (ACTUAL DAYS EXCLUDING 29TH FEB)
     C*              OR '3' (ACTUAL DAYS INCLUDING 29TH FEB)
     C*              OR '6' (FIRST AND LAST DAY ACCRUALS)
     C*               SUBTRACT START DATE FROM END DATE
     C*
     C     DYBS          IFEQ      '2'
     C     DYBS          OREQ      '3'
     C     DYBS          OREQ      '6'
     C     ZEDATE        SUB       ZSDATE        ZDDAYS
     C                   END
     C*
     C* IF DAY BASIS IS 2 - (ACTUAL DAYS EXCLUDING 29TH FEB)
     C*               SUBTRACT NUMBER OF 29TH FEB DAYS
     C*
     C     DYBS          IFEQ      '2'
     C                   Z-ADD     1             ZS                2 0
     C                   Z-ADD     0             ZI1               2 0
     C                   Z-ADD     0             ZI2               2 0
     C*
     C     ZI1           DOUNE     0
     C     ZF29(ZS)      IFGT      ZSDATE
     C                   Z-ADD     ZS            ZI1
     C                   ELSE
     C                   ADD       1             ZS
     C                   END
     C                   END
     C*
     C     ZI2           DOUNE     0
     C     ZF29(ZS)      IFGT      ZEDATE
     C                   Z-ADD     ZS            ZI2
     C                   ELSE
     C                   ADD       1             ZS
     C                   END
     C                   END
     C*
     C     ZI2           SUB       ZI1           ZS
     C     ZDDAYS        SUB       ZS            ZDDAYS
     C                   END
     C*
     C* CALCULATE LATER OF LAST COUPON DATE AND INITIAL DATE
     C*
     C     LCPN          IFGT      ITLD
     C                   Z-ADD     LCPN          ZWDATE            5 0
     C                   ELSE
     C                   Z-ADD     ITLD          ZWDATE
     C                   END
     C*
     C* IF DAY BASIS IS 6 (FIRST AND LAST DAY ACCRUALS)
     C*               IF START DATE EQUALS LATER OF LAST COUPON DATE AND
     C*               INITIAL DATE ADD 1 TO NO OF DAYS
     C*
     C     DYBS          IFEQ      '6'
     C     ZSDATE        ANDEQ     ZWDATE
     C                   ADD       1             ZDDAYS
     C                   END
     C*
     C* IF INTEREST ADJUSTMENT DAYS ARE NOT ZERO AND START DATE IS EQUAL TO
     C* LATER OF LAST COUPON DATE AND INITIAL DATE - ADD ADJUSTMENT DAYS TO
     C* NUMBER OF DAYS ALREADY CALCULATED
     C*
     C     DYBS          IFNE      '4'
     C     IADJ          ANDNE     0
     C     DADJN         ANDNE     'N'                                                         10001
     C                   ADD       IADJ          ZDDAYS
     C                   END
     C*
     C     EZDAYS        ENDSR                                                  ** EZDAYS **
     C**********************************************************************
      ** +--- The converted ZDAYSZ2 ends here ----------------------------+
 
      /EJECT
      **********************************************************************
      *                                                                    *
      *  This subroutine is to cater for the fact that standard subroutine *
      *   ZDAYS in this module executes another standard subroutine,       *
      *   ZDATE2, which has also been converted to a module.               *
      *  This subroutine is also called ZDATE2 and simply does a CALLB to  *
      *   the module that contains subroutine ZDATE2                       *
      *                                                                    *
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
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
 
      * INPUTS
 
      * start date
      * end date
     C                   PARM                    ZSDATE
     C                   PARM                    ZEDATE
 
      * Security details
     C                   PARM                    DYBS
     C                   PARM                    ITLD
     C                   PARM                    LCPN
     C                   PARM                    IADJ
     C                   PARM                    CPNR                           149162
     C                   PARM                    MATY                           149162
     C                   PARM                    NCD                            149162
 
      * interest days adjustment
     C                   PARM                    DADJN
                                                                                149162
      * day number accrued to                                                   149162
      * accrual type (Y=yield, I=interest, D=discount)                          149162
      * accrue last day indicator                                               149162
     C                   PARM                    ZIDNAT            2 0          149162
     C                   PARM                    ZACLT             1            149162
     C                   PARM                    ACLD              1            149162
      *
      ** Date format indicator
     C                   PARM                    BJDFIN
 
      * OUTPUTS
 
      * no of days
     C                   PARM                    ZDDAYS
                                                                                149162
      * day number accrued to                                                   149162
     C                   PARM                    ZODNAT            2 0          149162
 
     C                   ENDSR
 
      *****************************************************************
 
 
      ** +--- From here to the end is the converted ZDAYSZ3 --------------+
**   ZF29 DAY NOS OF FEB 29 TO 2096 (INCLUDING 2000)
0006001521029820444305904073650882610287117481320914670161311759219053
2051421975234362489726358278192928030741322023366335124365853804639507
40968424294389045351
