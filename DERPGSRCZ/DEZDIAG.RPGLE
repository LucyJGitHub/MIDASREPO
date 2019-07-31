     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Diagnostics')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEZDIAG - Diagnostics                                        *
      *                                                               *
      *  Function:  This module diagnoses the data export functions   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 CLE034             Date 16Sep03               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  208221 - Changes identified during alpha site                *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
 
     FDEZDIAGP1 O    F  132        PRINTER
      * Audit Report
 
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
 
      * P E R I O D   D E T A I L S
     D/COPY DECPYSRC,DEXTPERDD
 
 
     D/COPY DECPYSRC,DEXTFILS
 
 
     D TABTYP          S              2    DIM(22) CTDATA PERRCD(1)
     D TABNAR          S             20    DIM(22) ALT(TABTYP)
 
     D DEDIAG          S              1                                                       208221
 
     C     Diag_fmt      CASEQ     'EXP_TRAN'    REP_TRAN
     C     Diag_fmt      CASEQ     'EXP_POSN'    REP_POSN
     C     Diag_fmt      CASEQ     'EXP_EVNT'    REP_EVNT
     C     Diag_fmt      CASEQ     'EXP_CASH'    REP_CASH
     C                   ENDCS
 
     C                   RETURN
 
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     REP_TRAN      BEGSR
 
      * REPORT TRANSACTION DETAILS
 
      * deal date
     C                   Z-ADD     T#DDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        DELDATE           7
 
      * value date
     C                   Z-ADD     T#VDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        VALDATE           7
 
      * maturity date
     C                   Z-ADD     T#MDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        MATDATE           7
 
      * decimal places
     C                   SETOFF                                       53
     C     T#VCDP        COMP      1                                  525051
     C   52T#VCDP        COMP      2                                  53  52
 
     C                   EXCEPT    TRAN
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     REP_POSN      BEGSR
 
      * REPORT POSITION DETAILS
 
      * position date
     C                   Z-ADD     P#IACD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        POSDATE           7
 
      * start date
     C                   Z-ADD     P#SDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        STRDATE           7
 
      * end date
     C                   Z-ADD     P#EDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        ENDDATE           7
 
      * decimal places
     C                   SETOFF                                       53
     C     P#NCDP        COMP      1                                  525051
     C   52P#NCDP        COMP      2                                  53  52
 
     C                   EXCEPT    POSN
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     REP_EVNT      BEGSR
 
      * REPORT EVENT DETAILS
 
      * event date
     C                   Z-ADD     E#PRDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        EVTDATE           7
 
      * event type
     C     E#EVTP        LOOKUP    TABTYP        TABNAR                   99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     TABNAR        EVNARR           18
     C                   ELSE
     C                   MOVEL     '*ERROR      'EVNARR
     C                   ENDIF
 
      * event details
     C     E#RTSP        COMP      *ZERO                              2121      *
     C     E#CFCT        COMP      *ZERO                              2222      *
     C     E#CPDP        COMP      *ZERO                              2323      *
     C     E#IRAT        COMP      *ZERO                              2424      *
     C     E#NOML        COMP      *ZERO                              2525      *
     C     E#PRAM        COMP      *ZERO                              2626      *
     C     E#INTA        COMP      *ZERO                              2727      *
     C     E#COMM        COMP      *ZERO                              2828      *
     C     E#TAMT        COMP      *ZERO                              2929      *
     C                   SETOFF                                       30
     C     E#EVTP        IFEQ      'TP'
     C     E#EVTP        OREQ      'TS'
     C                   SETOFF                                       29
     C                   SETON                                        30
     C                   ENDIF
 
      * decimal places
     C                   SETOFF                                       53
     C     E#NCDP        COMP      1                                  525051
     C   52E#NCDP        COMP      2                                  53  52
 
     C                   EXCEPT    EVNT
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     REP_CASH      BEGSR
 
      * REPORT CASHFLOW DETAILS
 
      * cashflow date
     C                   Z-ADD     C#DATE        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        CSHDATE           7
 
      * cashflow event type
     C     C#EVTP        LOOKUP    TABTYP        TABNAR                   99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     TABNAR        EVNARR
     C                   ELSE
     C                   MOVEL     '*ERROR  '    EVNARR
     C                   ENDIF
 
      * in/out
     C     C#IO          IFEQ      'O'
     C                   MOVEL     '-'           C#SIGN            1
     C                   ELSE
     C                   MOVEL     '+'           C#SIGN
     C                   ENDIF
     C     C#NPVL        IFEQ      *ZERO
     C                   MOVEL     ' '           C#SIGA            1
     C                   ELSE
     C                   MOVEL     C#SIGN        C#SIGA
     C                   ENDIF
 
      * cashflow category
     C                   SETOFF                                       707172
     C                   SETOFF                                       73
     C     C#CATG        IFEQ      'P'
     C                   SETON                                        70
     C                   ELSE
     C     C#CATG        IFEQ      'I'
     C                   SETON                                        71
     C                   ELSE
     C     C#CATG        IFEQ      'C'
     C                   SETON                                        72
     C                   ELSE
     C                   SETON                                        73
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * decimal places
     C                   SETOFF                                       53
     C     C#CDP         COMP      1                                  525051
     C   52C#CDP         COMP      2                                  53  52
 
     C                   EXCEPT    CASH
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *ZERO         ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     *INZSR        BEGSR
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    Diag_Fmt          8
     C                   PARM                    Ret_Code          7
     C                   PARM                    Proj_Hist         1
     C                   PARM                    EndofBook         1
     C                   PARM                    T#TRAN
     C                   PARM                    P#POSN
     C                   PARM                    E#EVNT
     C                   PARM                    C#CASH
 
      * Headings
 
     C     Proj_Hist     IFEQ      'P'
     C     EndofBook     ANDEQ     'Y'
     C                   MOVEL     'PROJECT2EOB 'HEADING          20
     C                   ELSE
     C     Proj_Hist     IFEQ      'P'
     C     EndofBook     ANDEQ     'N'
     C                   MOVEL     'PROJECT/2EOB'HEADING
     C                   ELSE
     C                   MOVEL     'HISTORIC    'HEADING
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           30
     C                   MOVEL     Proj_Hist     I#PH
 
      * Get Extract control information
 
      /COPY DECPYSRC,DEXTGTCT
 
     C                   MOVEL     I#EVCD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        EVCDATE           7
 
     C                   EXCEPT    TITLE
                                                                                              208221
     C                   EVAL      DEDIAG = %SUBST(dataarea:74:1)                             208221
     C     DEDIAG        IFNE      'Y'                                                        208221
     C                   EXCEPT    NOTREQD                                                    208221
     C                   RETURN                                                               208221
     C                   ENDIF                                                                208221
 
     C                   MOVEA     PeriodEDT     PER
      *
     C                   Z-ADD     1             #PP               3 0
      *
     C     PER(#PP)      DOWNE     *BLANK
     C     PER(#PP)      ANDNE     '00000'
      *
      * Processing Date
     C                   MOVEL     PER(#PP)      ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        PERDATE           7
     C                   EXCEPT    TITLEPD
      *
     C                   ADD       1             #PP
      *
     C                   ENDDO
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
     ODEZDIAGP1 E            TITLE
     O                                           40 'DIAGNOSTICS'
     O                       HEADING             61
     O                       EVCDATE             68
     O          E            NOTREQD                                                          208221
     O                                           60 'Not Selected on data area'               208221
     O          E            TITLEPD
     O                                           60 'Period Date -'
     O                       PERDATE             68
     O          E            TRAN
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                           84 '------'                                  CGL029
     O          E            TRAN
     O                                            2 'TR'
     O**********             T#TREF              23                                           CGL029
     O**********             DELDATE             33                                           CGL029
     O**********             VALDATE             41                                           CGL029
     O**********             MATDATE             49                                           CGL029
     O**********             T#TDES              70                                           CGL029
     O                       T#TREF              29                                           CGL029
     O                       DELDATE             39                                           CGL029
     O                       VALDATE             47                                           CGL029
     O                       MATDATE             55                                           CGL029
     O                       T#TDES              76                                           CGL029
     O          E            POSN
     O                                            2 'PS'
     O**********             P#TREF              23                                           CGL029
     O**********             P#ASLI              25                                           CGL029
     O**********             POSDATE             33                                           CGL029
     O**********             STRDATE             41                                           CGL029
     O**********                                 42 '-'                                       CGL029
     O**********             ENDDATE             49                                           CGL029
     O**********     50      P#NOML              66 '             0 -'                        CGL029
     O**********     51      P#NOML              67 '             0. -'                       CGL029
     O**********     52      P#NOML              67 '            0.  -'                       CGL029
     O**********     53      P#NOML              67 '           0.   -'                       CGL029
     O**********             Ret_Code            76                                           CGL029
     O**********                                 78 'PS'                                      CGL029
     O                       P#TREF              29                                           CGL029
     O                       P#ASLI              31                                           CGL029
     O                       POSDATE             39                                           CGL029
     O                       STRDATE             47                                           CGL029
     O                                           48 '-'                                       CGL029
     O                       ENDDATE             55                                           CGL029
     O               50      P#NOML              72 '             0 -'                        CGL029
     O               51      P#NOML              73 '             0. -'                       CGL029
     O               52      P#NOML              73 '            0.  -'                       CGL029
     O               53      P#NOML              73 '           0.   -'                       CGL029
     O                       Ret_Code            82                                           CGL029
     O                                           84 'PS'                                      CGL029
     O          E            EVNT
     O                                            2 'EV'
     O**********             E#TREF              23                                           CGL029
     O**********             E#ASLI              25                                           CGL029
     O**********             EVTDATE             33                                           CGL029
     O**********             EVNARR              52                                           CGL029
     O**********             Ret_Code            76                                           CGL029
     O**********                                 78 'EV'                                      CGL029
     O                       E#TREF              29                                           CGL029
     O                       E#ASLI              31                                           CGL029
     O                       EVTDATE             39                                           CGL029
     O                       EVNARR              58                                           CGL029
     O                       Ret_Code            82                                           CGL029
     O                                           84 'EV'                                      CGL029
     O          E            CASH
     O                                            2 'CS'
     O**********             C#TREF              23                                           CGL029
     O**********             C#ASLI              25                                           CGL029
     O**********             CSHDATE             33                                           CGL029
     O**********             EVNARR              52                                           CGL029
     O**********             Ret_Code            76                                           CGL029
     O**********                                 78 'CS'                                      CGL029
     O                       C#TREF              29                                           CGL029
     O                       C#ASLI              31                                           CGL029
     O                       CSHDATE             39                                           CGL029
     O                       EVNARR              58                                           CGL029
     O                       Ret_Code            82                                           CGL029
     O                                           84 'CS'                                      CGL029
      /SPACE 5
**  CPY@
(c) Finastra International Limited 2001
** TAB
DDDEAL DATE
VDVALUE DATE
FEFEE (OR PREMIUM)
XMFOREX MARGIN
MIMAN.ADJ.INTEREST
SASTOP ACCRUALS
PIPRINCIPAL INCREASE
PDPRINCIPAL DECREASE
IPINTEREST PAYMENT
ODOVERDUE
REREPAYMENT
MRMANUAL REPAYMENT
SCSPREAD CHANGE
BCBASE RATE CHANGE
ROROLLOVER
PEPERIOD END
MTMATURITY
PPPART PAYMENT
MPMORTGAGE PAYMENT
TPTRADE PURCHASE
TSTRADE SALE
IRRATE CHANGE
