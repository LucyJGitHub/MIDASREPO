     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Convert interest calculation methods - DL')   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOCVTICDL - Convert Interest Calculation Methods for Dealing *
      *              and Other modules (Non-securities).              *
      *                                                               *
      *  Function:  This module will convert a Midas Dealing          *
      *             calculation basis to a CCRM calculation method    *
      *             and vice-versa.                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD034630           Date 10Nov15               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER016             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034630 - Multiple calls of UTCHOBJEX inside GOC0020        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016 - German Interest Calculation: Upgrade of FGE059      *
      *           to Midas Plus                                       *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
      *                                                                                       CER016
      ** External DS for SAR details                                                          CER016
      *                                                                                       CER016
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER016
      *                                                                                       CER016
      ** First DS for Access programs - short data structure                                  CER016
      *                                                                                       CER016
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER016
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D W#DI            S              1  0 DIM(12) CTDATA PERRCD(1)
     D W#IC            S              7    DIM(12) CTDATA PERRCD(1)
      *                                                                                       CER016
      ** Declare variables for Interest Calculation Method                                    CER016
      *                                                                                       CER016
     D WMth            C                   'ACR/366'                                          CER016
     D CER016          S              1A                                                      CER016
     D PRtCd           S              7A                                                      CER016
     D POptn           S              7A                                                      CER016
     D PSard           S              6A                                                      CER016
 
      *
      * INPUT PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
      * int.calc.basis
     C                   PARM                    I#ICBS            1 0          * INT CAL BASIS
      * OUTPUTS
      * int.calc.method
     C                   PARM                    O#ICMT            7            * INT CAL MTHD
      *                                                                                       CER016
      ** Access SAR Details File to determine if CER016 is installed                          CER016
      *                                                                                       CER016
     C**********         CALLB     'AOSARDR0'                                        CER016 MD034630
     C**********         PARM      *BLANKS       PRtCd                               CER016 MD034630
     C**********         PARM      '*VERIFY'     POptn                               CER016 MD034630
     C**********         PARM      'CER016'      PSard                               CER016 MD034630
     C*****SCSARD        PARM      SCSARD        DSFDY                               CER016 MD034630
      *                                                                                       CER016
      ** Database error                                                                       CER016
      *                                                                                       CER016
     C**********         IF        (PRtCd <> *BLANKS) and                            CER016 MD034630
     C**********                   (PRtCd <> '*NRF   ')                              CER016 MD034630
     C**********         EVAL      DBKEY = 'CER016'                                  CER016 MD034630
     C**********         EVAL      DBFILE = 'SCSARDPD'                               CER016 MD034630
     C**********         EVAL      DBASE = 001                                       CER016 MD034630
     C**********         EXSR      *PSSR                                             CER016 MD034630
     C**********         ENDIF                                                       CER016 MD034630
      *                                                                              CER016 MD034630
     C**********         IF        PRtCd = *BLANKS                                   CER016 MD034630
     C**********         EVAL      CER016 = 'Y'                                      CER016 MD034630
     C**********         ELSE                                                        CER016 MD034630
     C**********         EVAL      CER016 = 'N'                                      CER016 MD034630
     C**********         ENDIF                                                       CER016 MD034630
      *                                                                                       CER016
     C                   IF        CER016 = 'Y' AND I#ICBS = *ZEROS                           CER016
     C                   EVAL      O#ICMT = WMth                                              CER016
     C                   RETURN                                                               CER016
     C                   ENDIF                                                                CER016
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
      *                                                                                     MD034630
      *****************************************************************                     MD034630
      /EJECT                                                                                MD034630
      *****************************************************************                     MD034630
      *                                                               *                     MD034630
      * *INZSR - Program Initialisation routine                       *                     MD034630
      *                                                               *                     MD034630
      *****************************************************************                     MD034630
      *                                                                                     MD034630
     C     *INZSR        BEGSR                                                              MD034630
      *                                                                                     MD034630
      ** Access SAR Details File to determine if CER016 is installed                        MD034630
      *                                                                                     MD034630
     C                   CALLB     'AOSARDR0'                                               MD034630
     C                   PARM      *BLANKS       PRtCd                                      MD034630
     C                   PARM      '*VERIFY'     POptn                                      MD034630
     C                   PARM      'CER016'      PSard                                      MD034630
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD034630
      *                                                                                     MD034630
      ** Database error                                                                     MD034630
      *                                                                                     MD034630
     C                   IF        (PRtCd <> *BLANKS) and                                   MD034630
     C                             (PRtCd <> '*NRF   ')                                     MD034630
     C                   EVAL      DBKEY = 'CER016'                                         MD034630
     C                   EVAL      DBFILE = 'SCSARDPD'                                      MD034630
     C                   EVAL      DBASE = 001                                              MD034630
     C                   EXSR      *PSSR                                                    MD034630
     C                   ENDIF                                                              MD034630
      *                                                                                     MD034630
     C                   IF        PRtCd = *BLANKS                                          MD034630
     C                   EVAL      CER016 = 'Y'                                             MD034630
     C                   ELSE                                                               MD034630
     C                   EVAL      CER016 = 'N'                                             MD034630
     C                   ENDIF                                                              MD034630
      *                                                                                     MD034630
     C                   ENDSR                                                              MD034630
      *
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
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
7
7
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
30/360
30E/360
