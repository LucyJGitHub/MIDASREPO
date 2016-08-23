     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Convert interest calculation methods - DL')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DECVTICDL - Convert Interest Calculation Methods for Dealing *
      *              and Other modules (Non-securities).              *
      *                                                               *
      *  Function:  This module will convert a Midas Dealing          *
      *             calculation basis to a CCRM calculation method    *
      *             and vice-versa.                                   *
      *                                                               *
      *  Component of: DEPXTCFCO, DEPXTFRAS, DEPXTLDNI, DEPXTLOAN,    *
      *                DEPXTNASP, DEPXTSWAP                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. 188050             Date 27Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *  Prev Amend No. CDE001  *CREATE    Date 16Dec99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  188050 - Lookup failed due to int. calc. basis 7 not found   *
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
 
     D*W#DI****        S              1  0 DIM(10) CTDATA PERRCD(1)
     D*W#IC****        S              7    DIM(10) CTDATA PERRCD(1)
     D W#DI            S              1  0 DIM(12) CTDATA PERRCD(1)
     D W#IC            S              7    DIM(12) CTDATA PERRCD(1)
 
      *
      * INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           30            * ERROR MESSAGE
      * INPUTS
      * int.calc.basis
     C                   PARM                    I#ICBS            1 0          * INT CAL BASIS
      * OUTPUTS
      * int.calc.method
     C                   PARM                    O#ICMT            7            * INT CAL MTHD
      *
     C                   Z-ADD     1             W#I               3 0
      *
      * DETERMINE INTEREST CALCULATION METHOD FROM DEALING INT CAL BASIS
      *
     C     O#ICMT        IFEQ      *BLANK
      *
     C     I#ICBS        LOOKUP    W#DI(W#I)                              99    *
      *
      * INVALID DEALING INT.CALC.BASIS
      *
     C     *IN99         IFEQ      '0'
     C                   EVAL      I#ERMS = 'INVALID DEALING INT.CALC.BASIS'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     W#IC(W#I)     O#ICMT
     C                   END
      *
     C                   ELSE
      *
      * DETERMINE DEALING INT CAL BASIS FROM INTEREST CALCULATION METHOD
      *
     C     O#ICMT        LOOKUP    W#IC(W#I)                              99    *
      *
      * INVALID DEALING INT.CALC.METHD
      *
     C     *IN99         IFEQ      '0'
     C     W#DI(W#I)     OREQ      0
     C                   EVAL      I#ERMS = 'INVALID DEALING INT.CALC.METHD'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     W#DI(W#I)     I#ICBS
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
(c) Misys International Banking Systems Ltd. 2001
** ICBS
3
3
2
5
1
4
6
0
0
0
7                                                                                             188050
7                                                                                             188050
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
30/360                                                                                        188050
30E/360                                                                                       188050
