     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Calculate number of days in a period')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DECALNDYS - Calculate Number of Days in a Period             *
      *                                                               *
      *  Function:  This module calculates the number of days in an   *
      *             interest period.                                  *
      *                                                               *
      *  Component of: DECALFWRT, DECALINTM, DECALYBAS, DEWRKEDTA     *
      *                DEWRKEDTS.                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Last Amend No. CDE002             Date 05Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
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
 
 
     D ZF29            S              5  0 DIM(32) CTDATA PERRCD(14)            29TH FEB ARRAY
 
      *
      * INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           30            * ERROR MESSAGE
      * INPUTS
      * int.calc method
     C                   PARM                    I#ICMT            7            * INT CAL MTHD
      * start & end date
     C                   PARM                    I#SDAT            5 0          * START DATE
     C                   PARM                    I#EDAT            5 0          * END DATE
      * OUTPUTS
      * no of days
     C                   PARM                    O#NDYS            5 0          * NO. OF DAYS
      *
      * INITIALIZE OUTGOING NUMBER OF DAYS
      *
     C                   Z-ADD     0             O#NDYS               98        *
      *
      * EARLY EXIT CONDITIONS
      *
     C                   EXSR      EARLYEXIT
      *
      * IF START DATE IS GREATER THAN END DATE
      *   OUTPUT DAY DIFFERENCE AS 0
      *
     C     I#SDAT        IFGT      I#EDAT
     C                   Z-ADD     0             O#NDYS
     C                   RETURN
     C                   END
      *
      * CALCULATE NUMBER OF DAYS
      *
     C                   EXSR      CALDYS
      *
      * RETURN FROM PROGRAM
      *
     C                   RETURN
      *
      **********************************************************************
      * CALDYS - CALCULATE NUMBER OF DAYS
      **********************************************************************
     C     CALDYS        BEGSR
      *
      ** If calculation method is 30 day months
      *
     C     I#ICMT        IFEQ      '30/360 '
     C     I#ICMT        OREQ      '30E/360'
     C                   EXSR      CAL30D
     C                   END
      *
      * IF ACTUAL DAYS
      * SUBTRACT START DATE FROM END DATE
      *
     C     I#ICMT        IFEQ      'ACT/360'
     C     I#ICMT        OREQ      'ACX/360'
     C     I#ICMT        OREQ      'ACT/365'
     C     I#ICMT        OREQ      'ACX/365'
     C     I#ICMT        OREQ      'ACT/366'
     C     I#ICMT        OREQ      'ACX/366'
     C     I#ICMT        OREQ      'ACT/ACT'
     C     I#ICMT        OREQ      'ACX/ACX'
     C     I#EDAT        SUB       I#SDAT        O#NDYS
     C                   END
      *
      * IF ACTUAL EXCLUDING 29TH FEB
      *     SUBTRACT NUMBER OF 29TH FEB DAYS
      *
     C     I#ICMT        IFEQ      'ACX/360'
     C     I#ICMT        OREQ      'ACX/365'
     C     I#ICMT        OREQ      'ACX/366'
     C     I#ICMT        OREQ      'ACX/ACX'
     C                   EXSR      SUB29F
     C                   END
      *
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      **********************************************************************
      * CAL30D - CALCULATE 30 DAY MONTH DAYS
      **********************************************************************
     C     CAL30D        BEGSR
      *
      ** CONVERT INPUT DATES TO DD/MM/YY OR MM/DD/YY FORMAT
      *
     C                   Z-ADD     I#SDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         W#SYER            2 0
     C                   MOVEL     ZDATE         W#SDAY            2 0
     C                   MOVE      ZDATE         ZWRK4             4 0
     C                   MOVEL     ZWRK4         W#SMTH            2 0
      *
     C                   Z-ADD     I#EDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         W#EYER            2 0
     C                   MOVEL     ZDATE         W#EDAY            2 0
     C                   MOVE      ZDATE         ZWRK4             4 0
     C                   MOVEL     ZWRK4         W#EMTH            2 0
      *
      **  If Start Day is 31, change it to 30.
      *
     C     W#SDAY        IFEQ      31
     C                   MOVE      30            W#SDAY
     C                   END
      *
      ***  If 30E/360 method: if End Day is 31, change it to 30.
      *
     C     I#ICMT        IFEQ      '30E/360'
     C     W#EDAY        IFEQ      31
     C                   MOVE      30            W#EDAY
     C                   END
     C                   END
      *
      ***  If 30/360 method: first process a February Start Date.
      ***                    and a February End Date.                           CDE002
      *
     C     I#ICMT        IFEQ      '30/360'
      *
     C     W#SMTH        IFEQ      2
     C     W#SDAY        ANDGE     28
      *
      ***  If Start Date is LAST Day of February, change it to 30.
      ***  Note: for the 28th, must check that the 29th is not in ZF29.
      *
     C     W#SDAY        IFEQ      29
     C                   MOVE      30            W#SDAY
     C                   ELSE
     C                   ADD       1             I#SDAT
     C     I#SDAT        LOOKUP    ZF29                                   99
     C                   SUB       1             I#SDAT
     C     *IN99         IFEQ      '0'
     C                   MOVE      30            W#SDAY
     C                   END
     C                   END
      *
     C                   END
      *                                                                         CDE002
     C     W#EMTH        IFEQ      2                                            CDE002
     C     W#EDAY        ANDGE     28                                           CDE002
      *                                                                         CDE002
      ***  If End Date is LAST Day of February, change it to 30.                CDE002
      ***  Note: for the 28th, must check that the 29th is not in ZF29.         CDE002
      *                                                                         CDE002
     C     W#EDAY        IFEQ      29                                           CDE002
     C                   MOVE      30            W#EDAY                         CDE002
     C                   ELSE                                                   CDE002
     C                   ADD       1             I#EDAT                         CDE002
     C     I#EDAT        LOOKUP    ZF29                                   99    CDE002
     C                   SUB       1             I#EDAT                         CDE002
     C     *IN99         IFEQ      '0'                                          CDE002
     C                   MOVE      30            W#EDAY                         CDE002
     C                   END                                                    CDE002
     C                   END                                                    CDE002
      *                                                                         CDE002
     C                   END                                                    CDE002
      *
      ***  If the Start Day is 30 and the End Day is 31, then move 30
      ***  to the End Day
      *
     C     W#SDAY        IFEQ      30
     C     W#EDAY        ANDEQ     31
     C                   MOVE      30            W#EDAY
     C                   END
      *                                                                         CDE002
      ** IF START AND END DAY IN SAME MONTH/YEAR                                CDE002
      ** AND END DAY IS THE 31ST USE END DAY OF THE 30TH (095244 IN ZINTDY)     CDE002
      *                                                                         CDE002
     C     W#EYER        IFEQ      W#SYER                                       CDE002
     C     W#EMTH        ANDEQ     W#SMTH                                       CDE002
     C     W#EDAY        ANDGT     W#SDAY                                       CDE002
     C     W#EDAY        ANDEQ     31                                           CDE002
     C                   MOVE      30            W#EDAY                         CDE002
     C                   ENDIF                                                  CDE002
      *
     C                   END
      *
      ** IF END DAY IS LESS THAN START DAY - ADD 30 TO END DAY AND
      **   REDUCE END MONTH BY 1
      *
     C     W#EDAY        IFLT      W#SDAY
     C                   ADD       30            W#EDAY
     C     W#EMTH        SUB       1             W#EMTH
     C                   END
      *
      ** CALCULATE DAY DIFFERENCE
      *
     C     W#EDAY        SUB       W#SDAY        W#DYDF            5 0
      *
      ** IF START MONTH GREATER THAN END MONTH - ADD 12 TO END MONTH
      ** AND REDUCE END YEAR BY 1
      *
     C     W#SMTH        IFGT      W#EMTH
     C                   ADD       12            W#EMTH
     C     W#EYER        IFEQ      00
     C                   Z-ADD     99            W#EYER
     C                   ELSE
     C     W#EYER        SUB       1             W#EYER
     C                   END
     C                   END
      *
      ** CALCULATE MONTH DIFFERENCE IN DAYS
      *
     C     W#EMTH        SUB       W#SMTH        W#MTDF            5 0
     C     W#MTDF        MULT      30            W#MTDF
      *
      ** SUBTRACT START YEAR FROM END YEAR - IF RESULT LESS THAN 0
      ** THEN ADD 100 FOR CHANGE IN CENTURY
      *
     C     W#EYER        SUB       W#SYER        W#YRDF            5 0
     C     W#YRDF        IFLT      0
     C                   ADD       100           W#YRDF
     C                   END
      *
      ** CALCULATE YEAR DIFFERENCE IN DAYS
      *
     C                   MULT      360           W#YRDF
      *
      ** TOTAL DAYS = DAY + MONTH + YEAR DIFFERENCE
      *
     C     W#DYDF        ADD       W#MTDF        O#NDYS
     C                   ADD       W#YRDF        O#NDYS
      *
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      **********************************************************************
      * SUB29F - SUBTRACT 29FEB DAYS
      **********************************************************************
     C     SUB29F        BEGSR
      *
     C                   Z-ADD     1             W#CNT             2 0
     C                   Z-ADD     0             W#SCNT            2 0
     C                   Z-ADD     0             W#ECNT            2 0
      *
     C     W#SCNT        DOUNE     0
     C     ZF29(W#CNT)   IFGT      I#SDAT
     C                   Z-ADD     W#CNT         W#SCNT
     C                   ELSE
     C                   ADD       1             W#CNT
     C                   END
     C                   END
      *
     C     W#ECNT        DOUNE     0
     C     ZF29(W#CNT)   IFGT      I#EDAT
     C                   Z-ADD     W#CNT         W#ECNT
     C                   ELSE
     C                   ADD       1             W#CNT
     C                   END
     C                   END
      *
     C     W#ECNT        SUB       W#SCNT        W#CNT
     C                   SUB       W#CNT         O#NDYS
      *
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      **********************************************************************
     C     EARLYEXIT     BEGSR
      *
      * EXIT IN ERROR IF INTEREST CALCULATION METHOD IS INVALID
      *
     C     I#ICMT        IFNE      '30/360 '
     C     I#ICMT        ANDNE     '30E/360'
     C     I#ICMT        ANDNE     'ACT/360'
     C     I#ICMT        ANDNE     'ACX/360'
     C     I#ICMT        ANDNE     'ACT/365'
     C     I#ICMT        ANDNE     'ACX/365'
     C     I#ICMT        ANDNE     'ACT/366'
     C     I#ICMT        ANDNE     'ACX/366'
     C     I#ICMT        ANDNE     'ACT/ACT'
     C     I#ICMT        ANDNE     'ACX/ACX'
     C                   EVAL      I#ERMS = 'INT. CALC. METHOD IS INVALID'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      **********************************************************************
     C/SPACE 5
      **********************************************************************
      * CONVERT DATE TO DAY NUMBER
      **********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *ZERO         ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   ENDSR
      **********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**   ZF29 DAY NOS OF FEB 29 TO 2096 (INCLUDING 2000)
0006001521029820444305904073650882610287117481320914670161311759219053
2051421975234362489726358278192928030741322023366335124365853804639507
40968424294389045351
