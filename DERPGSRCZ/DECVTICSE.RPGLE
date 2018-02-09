     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Convert interest calculation methods - SE')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DECVTICSE - Convert Interest Calculation Methods for         *
      *              Securities Trading.                              *
      *                                                               *
      *  Function:  This module will convert a Midas Securities       *
      *             Trading Day and Divisor basis to a CCRM           *
      *             calculation method and vice-versa.                *
      *                                                               *
      *  Component of: DEPXTSBPS                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. CDE001  *CREATE    Date 16Dec99               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
     D W#DD            S              2    DIM(10) CTDATA PERRCD(1)
     D W#IC            S              7    DIM(10) CTDATA PERRCD(1)
 
      *
      * INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           30            * ERROR MESSAGE
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
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** DYBS/DVBS
51
11
31
21
32
22
33
23
35
25
** ICMT
30/360
30E/360
ACT/360
ACX/360
ACT/365
ACX/365
ACT/366
ACX/366
ACT/ACT
ACX/ACX
