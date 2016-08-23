     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Convert interest calculation methods - SE')   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOCVTICSE - Convert Interest Calculation Methods for         *
      *              Securities Trading.                              *
      *                                                               *
      *  Function:  This module will convert a Midas Securities       *
      *             Trading Day and Divisor basis to a CCRM           *
      *             calculation method and vice-versa.                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. 261324             Date 24Apr13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  261324 - GOC0020 ended in error during COB. Add missing day  *
      *           basis and divisor basis combinations.               *
      *         - Applied for AR1063996 (Child: AR1063998).           *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D*W#DD*****       S              2    DIM(12) CTDATA PERRCD(1)                           261324
     D*W#IC*****       S              7    DIM(12) CTDATA PERRCD(1)                           261324
     D W#DD            S              2    DIM(20) CTDATA PERRCD(1)                           261324
     D W#IC            S              7    DIM(20) CTDATA PERRCD(1)                           261324
 
      *
      * INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
      * day & div basis
     C                   PARM                    I#DYBS            1 0          * DAY BASIS
     C                   PARM                    I#DVBS            1 0          * DIV BASIS
      * OUTPUTS
      * int.calc.method
     C                   PARM                    O#ICMT            7            * INT CAL MTHD
      *
     C                   Z-ADD     1             W#I               3 0
      *
      * DETERMINE INTEREST CALCULATION METHOD FROM DAY & DIVISOR BASIS
      *
     C     O#ICMT        IFEQ      *BLANK
      *
     C                   MOVEL     I#DYBS        W#DYDV
     C                   MOVE      I#DVBS        W#DYDV
     C     W#DYDV        LOOKUP    W#DD(W#I)                              99    *
      *
      * INVALID SECURITY DAY/DIV BASIS
      *
     C     *IN99         IFEQ      '0'
     C                   EVAL      I#ERMS = 'INVALID SECURITY DAY/DIV BASIS'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     W#IC(W#I)     O#ICMT
     C                   END
      *
     C                   ELSE
      *
      * DETERMINE DAY & DIVISOR BASIS FROM INTEREST CALCULATION METHOD
      *
     C     O#ICMT        LOOKUP    W#IC(W#I)                              99    *
      *
      * INVALID SECURITY INT.CALC.METH
      *
     C     *IN99         IFEQ      '0'
     C                   EVAL      I#ERMS = 'INVALID SECURITY INT.CALC.METH'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     W#DD(W#I)     W#DYDV            2
     C                   MOVEL     W#DYDV        I#DYBS
     C                   MOVE      W#DYDV        I#DVBS
     C                   END
      *
     C                   END
      *
      * NORMAL EXIT
      *
     C                   RETURN
      *
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
** DYBS/DVBS
51
11
31
21
32
22
33
23
13
12
35
25
15                                                                                            261324
52                                                                                            261324
53                                                                                            261324
55                                                                                            261324
61                                                                                            261324
62                                                                                            261324
63                                                                                            261324
65                                                                                            261324
** ICMT
30/360
30E/360
ACT/360
ACX/360
ACT/365
ACX/365
ACT/366
ACX/366
30E/366
30E/365
ACT/ACT
ACX/ACX
30E/ACT                                                                                       261324
30/365                                                                                        261324
30/366                                                                                        261324
30/ACT                                                                                        261324
AFL/360                                                                                       261324
AFL/365                                                                                       261324
AFL/366                                                                                       261324
AFL/ACT                                                                                       261324
