     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*OVR *: OVRDBF FILE(DETRANL2) TOFILE(DEPTRANL2) SHARE(*NO)         : *
/*OVR *: OVRDBF FILE(DEPOSNL0) TOFILE(DEPPOSNL0) SHARE(*NO)         : *
/*OVR *: OVRDBF FILE(DEEVNTL0) TOFILE(DEPEVNTL0) SHARE(*NO)         : *
/*OVR *: OVRDBF FILE(DECASHL0) TOFILE(DEPCASHL0) SHARE(*NO)         : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Report transaction - details')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEREPTRND - Report Transaction Details                       *
      *                                                               *
      *  Function:  This module produces a detailed report of all the *
      *             records on the projected transactions extract     *
      *             files DEPTRANPD, DEPPOSNPD, DEPEVNTPD and         *
      *             DEPCASHPD.                                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CLE034             Date 16Sep03               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  208221 - Changes identified during alpha site                *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FDETRANL2  IP  AE           K DISK
     FDEPOSNL0  IF   E           K DISK
     FDEEVNTL0  IF   E           K DISK
     FDECASHL0  IF   E           K DISK
     FDEGVALUL0 IF   E           K DISK                                                       CDE002
     FSDBANKPD  IF   E             DISK
     FDEREPTDP1 O    E             PRINTER USROPN INFDS(SPOOL)
 
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
 
     D*TABTYP****      S              2    DIM(21) CTDATA PERRCD(1)                           CDE002
     D*TABNAR****      S             20    DIM(21) ALT(TABTYP)                                CDE002
     D*NAR*******      S             12    DIM(5) CTDATA PERRCD(1)                            CDE002
     D TABTYP          S              2    DIM(22) CTDATA PERRCD(1)                           CDE002
     D TABNAR          S             20    DIM(22) ALT(TABTYP)                                CDE002
     D NAR             S             12    DIM(6) CTDATA PERRCD(1)                            CDE002
 
      * Start of Printer File DS fields
     D                 DS
     D T#TCAT1                 1      4
     D T#TCAT2                 1      4
 
     D                 DS
     D P#CCY1                  1      3
     D P#CCY2                  1      3
 
     D                 DS
     D C#CCY1                  1      3
     D C#CCY2                  1      3
 
     D                 DS
     D C#SIGA1                 1      1
     D C#SIGA2                 1      1
 
     D                 DS
     D C#SIGN1                 1      1
     D C#SIGN2                 1      1
 
     D                 DS
     D T#MKVL1                 1     15S 0
     D T#MKVL2                 1     15S 0
     D T#MKVL3                 1     15S 0
     D T#MKVL4                 1     15S 0
 
     D                 DS
     D P#NOML1                 1     15S 0
     D P#NOML2                 1     15S 0
     D P#NOML3                 1     15S 0
     D P#NOML4                 1     15S 0
     D P#NOML5                 1     15S 0
     D P#NOML6                 1     15S 0
     D P#NOML7                 1     15S 0
     D P#NOML8                 1     15S 0
 
     D                 DS
     D P#RLAC1                 1     15S 0
     D P#RLAC2                 1     15S 0
     D P#RLAC3                 1     15S 0
     D P#RLAC4                 1     15S 0
 
     D                 DS
     D P#RLPL1                 1     15S 0
     D P#RLPL2                 1     15S 0
     D P#RLPL3                 1     15S 0
     D P#RLPL4                 1     15S 0
 
     D                 DS
     D P#FEAC1                 1     15S 0
     D P#FEAC2                 1     15S 0
     D P#FEAC3                 1     15S 0
     D P#FEAC4                 1     15S 0
     D P#FEAC5                 1     15S 0
     D P#FEAC6                 1     15S 0
     D P#FEAC7                 1     15S 0
     D P#FEAC8                 1     15S 0
 
     D                 DS
     D P#FEE1                  1     15S 0
     D P#FEE2                  1     15S 0
     D P#FEE3                  1     15S 0
     D P#FEE4                  1     15S 0
     D P#FEE5                  1     15S 0
     D P#FEE6                  1     15S 0
     D P#FEE7                  1     15S 0
     D P#FEE8                  1     15S 0
 
     D                 DS
     D P#DPAC1                 1     15S 0
     D P#DPAC2                 1     15S 0
     D P#DPAC3                 1     15S 0
     D P#DPAC4                 1     15S 0
 
     D                 DS
     D P#DIPR1                 1     15S 0
     D P#DIPR2                 1     15S 0
     D P#DIPR3                 1     15S 0
     D P#DIPR4                 1     15S 0
 
     D                 DS
     D P#CFAC1                 1     15S 0
     D P#CFAC2                 1     15S 0
     D P#CFAC3                 1     15S 0
     D P#CFAC4                 1     15S 0
     D P#CFAC5                 1     15S 0
     D P#CFAC6                 1     15S 0
     D P#CFAC7                 1     15S 0
     D P#CFAC8                 1     15S 0
 
     D                 DS
     D P#INAC1                 1     15S 0
     D P#INAC2                 1     15S 0
     D P#INAC3                 1     15S 0
     D P#INAC4                 1     15S 0
 
     D                 DS
     D P#CONS1                 1     15S 0
     D P#CONS2                 1     15S 0
     D P#CONS3                 1     15S 0
     D P#CONS4                 1     15S 0
 
     D                 DS
     D P#RLAC_T1               1     15S 0
     D P#RLAC_T2               1     15S 0
     D P#RLAC_T3               1     15S 0
     D P#RLAC_T4               1     15S 0
 
     D                 DS
     D P#FEAC_T1               1     15S 0
     D P#FEAC_T2               1     15S 0
     D P#FEAC_T3               1     15S 0
     D P#FEAC_T4               1     15S 0
     D P#FEAC_T5               1     15S 0
     D P#FEAC_T6               1     15S 0
     D P#FEAC_T7               1     15S 0
     D P#FEAC_T8               1     15S 0
 
     D                 DS
     D P#DPAC_T1               1     15S 0
     D P#DPAC_T2               1     15S 0
     D P#DPAC_T3               1     15S 0
     D P#DPAC_T4               1     15S 0
 
     D                 DS
     D P#CFAC_T1               1     15S 0
     D P#CFAC_T2               1     15S 0
     D P#CFAC_T3               1     15S 0
     D P#CFAC_T4               1     15S 0
     D P#CFAC_T5               1     15S 0
     D P#CFAC_T6               1     15S 0
     D P#CFAC_T7               1     15S 0
     D P#CFAC_T8               1     15S 0
 
     D                 DS
     D P#INAC_T1               1     15S 0
     D P#INAC_T2               1     15S 0
     D P#INAC_T3               1     15S 0
     D P#INAC_T4               1     15S 0
 
     D                 DS
     D E#TAMT1                 1     15S 0
     D E#TAMT2                 1     15S 0
     D E#TAMT3                 1     15S 0
     D E#TAMT4                 1     15S 0
     D E#TAMT5                 1     15S 0
     D E#TAMT6                 1     15S 0
     D E#TAMT7                 1     15S 0
     D E#TAMT8                 1     15S 0
 
     D                 DS
     D E#COMM1                 1     15S 0
     D E#COMM2                 1     15S 0
     D E#COMM3                 1     15S 0
     D E#COMM4                 1     15S 0
     D E#COMM5                 1     15S 0
     D E#COMM6                 1     15S 0
     D E#COMM7                 1     15S 0
     D E#COMM8                 1     15S 0
 
     D                 DS
     D E#INTA1                 1     15S 0
     D E#INTA2                 1     15S 0
     D E#INTA3                 1     15S 0
     D E#INTA4                 1     15S 0
     D E#INTA5                 1     15S 0
     D E#INTA6                 1     15S 0
     D E#INTA7                 1     15S 0
     D E#INTA8                 1     15S 0
 
     D                 DS
     D E#PRAM1                 1     15S 0
     D E#PRAM2                 1     15S 0
     D E#PRAM3                 1     15S 0
     D E#PRAM4                 1     15S 0
     D E#PRAM5                 1     15S 0
     D E#PRAM6                 1     15S 0
     D E#PRAM7                 1     15S 0
     D E#PRAM8                 1     15S 0
 
     D                 DS
     D E#NOML1                 1     15S 0
     D E#NOML2                 1     15S 0
     D E#NOML3                 1     15S 0
     D E#NOML4                 1     15S 0
     D E#NOML5                 1     15S 0
     D E#NOML6                 1     15S 0
     D E#NOML7                 1     15S 0
     D E#NOML8                 1     15S 0
 
     D                 DS
     D C#NPVL1                 1     15S 0
     D C#NPVL2                 1     15S 0
     D C#NPVL3                 1     15S 0
     D C#NPVL4                 1     15S 0
     D C#NPVL5                 1     15S 0
     D C#NPVL6                 1     15S 0
     D C#NPVL7                 1     15S 0
     D C#NPVL8                 1     15S 0
 
     D                 DS
     D C#AMNT1                 1     15S 0
     D C#AMNT2                 1     15S 0
     D C#AMNT3                 1     15S 0
     D C#AMNT4                 1     15S 0
     D C#AMNT5                 1     15S 0
     D C#AMNT6                 1     15S 0
     D C#AMNT7                 1     15S 0
     D C#AMNT8                 1     15S 0
 
     D                 DS
     D TOTNPVL1                1     15S 0
     D TOTNPVL2                1     15S 0
     D TOTNPVL3                1     15S 0
     D TOTNPVL4                1     15S 0
 
     D                 DS                                                                     CDE002
     D NETVALU1                1     15S 0                                                    CDE002
     D NETVALU2                1     15S 0                                                    CDE002
     D NETVALU3                1     15S 0                                                    CDE002
     D NETVALU4                1     15S 0                                                    CDE002
     D NETVALU5                1     15S 0                                                    CDE002
     D NETVALU6                1     15S 0                                                    CDE002
     D NETVALU7                1     15S 0                                                    CDE002
     D NETVALU8                1     15S 0                                                    CDE002
                                                                                              CDE002
     D                 DS                                                                     CDE002
     D V#MKVL1                 1     15S 0                                                    CDE002
     D V#MKVL2                 1     15S 0                                                    CDE002
     D V#MKVL3                 1     15S 0                                                    CDE002
     D V#MKVL4                 1     15S 0                                                    CDE002
     D V#MKVL5                 1     15S 0                                                    CDE002
     D V#MKVL6                 1     15S 0                                                    CDE002
     D V#MKVL7                 1     15S 0                                                    CDE002
     D V#MKVL8                 1     15S 0                                                    CDE002
                                                                                              CDE002
     D                 DS                                                                     CDE002
     D TOTVALU1                1     15S 0                                                    CDE002
     D TOTVALU2                1     15S 0                                                    CDE002
     D TOTVALU3                1     15S 0                                                    CDE002
     D TOTVALU4                1     15S 0                                                    CDE002
                                                                                              CDE002
      * End of Printer file DS fields
 
     D SEVENZEROS      S              7    INZ('0000000')
 
     DSPOOL          E DS                  EXTNAME(Y2I$DSP)
     DSFILE                   83     92
     DSFNUM                  123    124B 0
      * File Information Date Structure
 
     IDETRANP0      01
     I                                          T#MOD         L2
     I                                          T#TREF        L1
     I                                          T#BRCA        L3
 
     C                   MOVEL     'Y'           Tran_read         1
 
     C   L3              EXSR      BRCACHG
 
     CL1 88              EXSR      TRANCHG
     CLR                 EXSR      BRCAEND
 
 
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     BRCACHG       BEGSR
 
      * Process all branches or specific branch requested
 
     C                   EVAL      *IN88 = *ON
     C                   IF        P_ENTITY <> 'ALL' AND P_ENTITY <> *BLANKS
     C                             AND T#BRCA <> P_ENTITY
     C                   EVAL      *IN88 = *OFF
     C                   GOTO      BRCACHGESR
     C                   ENDIF
 
      * On change of branch close and open print file
 
     C     PRTOpen       IFEQ      'Y'
     C                   EXSR      BRCAEND
     C                   CLOSE     DEREPTDP1                                    *
     C                   ENDIF
 
     C                   EVAL      PAGNUM = 0
     C                   OPEN      DEREPTDP1
     C                   MOVE      'Y'           PRTOpen           1
     C                   MOVE      T#BRCA        P@T#BRCA          3
 
      * Ensure report spool file recorded by RCF
 
     C                   Z-ADD     SFNUM         ZSNUM             6 0
     C                   CALL      'ZSFILE'
     C                   PARM      P_SEQNCE      ZSSEQ             5
     C                   PARM      P_ENTITY      ZSENT             3
     C                   PARM                    SFILE
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
     C     ZSERR         IFEQ      'Y'
      * Error during ZSFILE processing, return to calling program
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   END
 
      * Initialize line number to force page headings
     C                   Z-ADD     99            LINENO
 
     C     BRCACHGESR    ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     BRCAEND       BEGSR
 
      * If print file not open, open it
 
     C     PRTOpen       IFNE      'Y'
     C                   OPEN      DEREPTDP1
     C                   ENDIF
 
      * Output end of report
 
     C                   Z-ADD     2             CHLINE
     C                   EXSR      PAGECHG
     C                   WRITE     REPORTEND
      *
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     TRANCHG       BEGSR
 
      * BYPASS IF NO TRANSACTIONS READ
 
     C     Tran_read     CABNE     'Y'           ETRANCHG
 
      *
      * CHECK IF ANY DATA. (IF NOT, BYPASS)
      *
     C                   MOVEL     'N'           #DATA             1
     C                   MOVEL     'Y'           #CHECK            1
      *
      * REPORT POSITIONS/EVENTS/CASFLOWS
      *
     C                   MOVEL     'A'           XXASLI            1
     C                   EXSR      REP_POSN
     C                   EXSR      REP_EVNT
     C                   EXSR      REP_CASH
      *
     C                   MOVEL     'L'           XXASLI
     C                   EXSR      REP_POSN
     C                   EXSR      REP_EVNT
     C                   EXSR      REP_CASH
      *                                                                                       CDE002
      * REPORT VALUATIONS                                                                     CDE002
      *                                                                                       CDE002
     C   U5              EXSR      REP_VALU                                                   CDE002
      *
      * NO DATA, SO BYPASS
      *
     C     #DATA         IFNE      'Y'
     C                   GOTO      ETRANCHG
     C                   ENDIF
      *
     C                   MOVEL     'N'           #CHECK
      *
      * PROCESS TRANSACTION DETAILS
      *
     C     T#MOD         COMP      'SE'                                   65    *
 
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
 
      * Output transaction headings
 
     C                   Z-ADD     3             CHLINE            3 0
     C                   EXSR      PAGECHG
     C                   EVAL      T#MKVL1 = T#MKVL
     C                   WRITE     TRANHEAD
      *
      * REPORT POSITIONS/EVENTS/CASFLOWS
      *
     C                   MOVEL     'A'           XXASLI            1
     C                   EXSR      REP_POSN
     C                   EXSR      REP_EVNT
     C                   EXSR      REP_CASH
      *
     C                   MOVEL     'L'           XXASLI
     C                   EXSR      REP_POSN
     C                   EXSR      REP_EVNT
     C                   EXSR      REP_CASH
      *                                                                                       CDE002
      * REPORT VALUATIONS                                                                     CDE002
      *                                                                                       CDE002
     C   U5              EXSR      REP_VALU                                                   CDE002
 
      * Output end of transaction
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAGECHG
     C                   WRITE     TRANEND
      *
     C     ETRANCHG      ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     REP_POSN      BEGSR
 
      * Reset position totals
     C                   Z-ADD     0             P#INAC_T
     C                   Z-ADD     0             P#CFAC_T
     C                   Z-ADD     0             P#DPAC_T
     C                   Z-ADD     0             P#FEAC_T
     C                   Z-ADD     0             P#RLAC_T
      *
     C     POSNKEY       SETLL     DEPOSNP0
     C     POSNKEY       READE     DEPOSNP0                               99    *
 
     C     *IN99         IFEQ      '0'
 
      * Bypass if no details
 
     C     #CHECK        IFEQ      'Y'
     C                   MOVEL     'Y'           #DATA
     C                   GOTO      EREP_POSN
     C                   ENDIF
 
      * heading text
     C                   MOVEL     NAR(1)        HTEXT            10
     C                   MOVEL     *BLANK        HTEXTX           12
     C     XXASLI        IFEQ      'A'
     C                   MOVEL     NAR(4)        HTEXTX
     C                   ENDIF
     C     XXASLI        IFEQ      'L'
     C                   MOVEL     NAR(5)        HTEXTX
     C                   ENDIF
 
      * Output position headings
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAGECHG
     C                   WRITE     GENHEAD
     C                   Z-ADD     2             CHLINE
     C                   EXSR      PAGECHG
     C                   WRITE     POSNHEAD
 
     C                   ENDIF
      *
     C     *IN99         DOWEQ     '0'
 
      * decimal places
     C                   SETOFF                                       53
     C     P#NCDP        COMP      1                                  525051
     C   52P#NCDP        COMP      2                                  53  52
 
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
     C     STRDATE       IFNE      *BLANK
     C     ENDDATE       ORNE      *BLANK
     C                   SETON                                        40
     C                   ELSE
     C                   SETOFF                                       40
     C                   END
 
      * position type
     C     P#PSTP        IFEQ      'C '
     C                   MOVEL     '>'           POS               1
     C                   ELSE
     C                   MOVEL     *BLANK        POS
     C                   ENDIF
 
      *
     C     P#ACDP        COMP      'Y'                                    61    *
     C     P#ACFE        COMP      'Y'                                    62    *
     C     P#ACRL        COMP      'Y'                                    63    *
 
      *
      * Use cash instead of interest if cash accrual
      *
     C     P#ACCS        IFEQ      'Y'
     C                   Z-ADD     P#CSAC        P#INAC
     C                   ENDIF
      *
      * Add commissions to fees
      *
     C   62              ADD       P#COMM        P#FEAC
     C  N62              ADD       P#COMM        P#FEE
 
      * update position totals
     C                   ADD       P#INAC        P#INAC_T         15 0
     C                   ADD       P#CFAC        P#CFAC_T         15 0
     C   61              ADD       P#DPAC        P#DPAC_T         15 0
     C  N61              ADD       P#DIPR        P#DPAC_T         15 0
     C   62              ADD       P#FEAC        P#FEAC_T         15 0
     C  N62              ADD       P#FEE         P#FEAC_T         15 0
     C   63              ADD       P#RLAC        P#RLAC_T         15 0
     C  N63              ADD       P#RLPL        P#RLAC_T         15 0
 
      * output position details
 
      * set printer file fields, determine whether 1 or 2 lines output
     C                   EXSR      POSNDETPR
     C                   IF        *IN87 = *OFF
     C                   Z-ADD     1             CHLINE
     C                   ELSE
     C                   Z-ADD     2             CHLINE
     C                   ENDIF
 
     C                   EXSR      PAGECHG
     C                   WRITE     POSNDET
 
      * output position details for SE
 
     C     P#MOD         IFEQ      'SE'
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAGECHG
     C                   EVAL      P#CONS1 = P#CONS
     C                   WRITE     POSNDET_SE
     C                   ELSE
 
      * output position details for cost of funds rate
 
     C     P#ACCF        IFEQ      'Y'
     C     P#CRAT        ANDNE     0
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAGECHG
     C                   WRITE     POSNDET_CR
     C                   ENDIF
     C                   ENDIF
 
      * output position details for ceiling & floor rate
 
     C     P#CLRT        IFNE      *ZERO
     C     P#FLRT        ORNE      *ZERO
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAGECHG
     C                   WRITE     POSNDET_CF
     C                   ENDIF
 
     C     POSNKEY       READE     DEPOSNP0                               99    *
     C                   ENDDO
 
      * output position totals
 
     C     P#INAC_T      IFNE      *ZERO
     C     P#CFAC_T      ORNE      *ZERO
     C     P#DPAC_T      ORNE      *ZERO
     C     P#FEAC_T      ORNE      *ZERO
     C     P#RLAC_T      ORNE      *ZERO
 
      * set printer file fields, determine whether 1 or 2 lines output
 
     C                   EXSR      POSN_TOTPR
     C                   IF        *IN87 = *OFF
     C                   Z-ADD     1             CHLINE
     C                   ELSE
     C                   Z-ADD     2             CHLINE
     C                   ENDIF
 
     C                   EXSR      PAGECHG
     C                   WRITE     POSN_TOT
 
      * clear total fields
 
     C                   EVAL      P#RLAC_T = 0
     C                   EVAL      P#FEAC_T = 0
     C                   EVAL      P#DPAC_T = 0
     C                   EVAL      P#CFAC_T = 0
     C                   EVAL      P#INAC_T = 0
 
     C                   ENDIF
 
     C     EREP_POSN     ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     REP_EVNT      BEGSR
      *
     C     EVNTKEY       SETLL     DEEVNTP0
     C     EVNTKEY       READE     DEEVNTP0                               99    *
      *
     C     *IN99         IFEQ      '0'
 
      * Bypass if no details
 
     C     #CHECK        IFEQ      'Y'
     C                   MOVEL     'Y'           #DATA
     C                   GOTO      EREP_EVNT
     C                   ENDIF
 
      * heading text
     C                   MOVEL     NAR(2)        HTEXT
     C                   MOVEL     *BLANK        HTEXTX
     C     XXASLI        IFEQ      'A'
     C                   MOVEL     NAR(4)        HTEXTX
     C                   ENDIF
     C     XXASLI        IFEQ      'L'
     C                   MOVEL     NAR(5)        HTEXTX
     C                   ENDIF
 
      * output event headings
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAGECHG
     C                   WRITE     GENHEAD
 
     C                   ENDIF
      *
     C     *IN99         DOWEQ     '0'
 
      * decimal places
     C                   SETOFF                                       53
     C     E#NCDP        COMP      1                                  525051
     C   52E#NCDP        COMP      2                                  53  52
 
      * event date
     C                   Z-ADD     E#PRDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        EVTDATE           7
 
      * event type
     C     E#EVTP        LOOKUP    TABTYP        TABNAR                   99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     TABNAR        EVNARR           18
     C                   ELSE
     C                   MOVEL     '*ERROR  '    EVNARR
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
 
      * Output event details
 
      * set printer file fields, determine whether 1 or 2 lines output
 
     C                   EXSR      EVNTDETPR
     C                   IF        *IN87 = *OFF
     C                   Z-ADD     1             CHLINE
     C                   ELSE
     C                   Z-ADD     2             CHLINE
     C                   ENDIF
 
     C                   EXSR      PAGECHG
     C                   WRITE     EVNTDET
 
     C     EVNTKEY       READE     DEEVNTP0                               99    *
     C                   ENDDO
     C     EREP_EVNT     ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     REP_CASH      BEGSR
      *
     C     CASHKEY       SETLL     DECASHP0
     C     CASHKEY       READE     DECASHP0                               99    *
 
      * Reset NPV total
     C                   Z-ADD     *ZERO         TOTNPVL
      *
     C     *IN99         IFEQ      '0'
 
      * Bypass if no details
 
     C     #CHECK        IFEQ      'Y'
     C                   MOVEL     'Y'           #DATA
     C                   GOTO      EREP_CASH
     C                   ENDIF
 
      * heading text
     C                   MOVEL     NAR(3)        HTEXT
     C                   MOVEL     *BLANK        HTEXTX
     C     XXASLI        IFEQ      'A'
     C                   MOVEL     NAR(4)        HTEXTX
     C                   ENDIF
     C     XXASLI        IFEQ      'L'
     C                   MOVEL     NAR(5)        HTEXTX
     C                   ENDIF
 
      * output cashflow headings
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAGECHG
     C                   WRITE     GENHEAD
 
     C                   ENDIF
      *
     C     *IN99         DOWEQ     '0'
 
      * decimal places
     C                   SETOFF                                       53
     C     C#CDP         COMP      1                                  525051
     C   52C#CDP         COMP      2                                  53  52
 
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
 
      * NPV total
     C     C#IO          IFEQ      'O'
     C                   SUB       C#NPVL        TOTNPVL          15 0
     C                   ELSE
     C                   ADD       C#NPVL        TOTNPVL
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
 
      * Output cashflow details
 
      * set printer file fields, determine whether 1 or 2 lines output
 
     C                   EXSR      CASHDETPR
     C                   IF        *IN87 = *OFF
     C                   Z-ADD     1             CHLINE
     C                   ELSE
     C                   Z-ADD     2             CHLINE
     C                   ENDIF
 
     C                   EXSR      PAGECHG
     C                   EVAL      *IN80 = *INU5
     C                   WRITE     CASHDET
     C     CASHKEY       READE     DECASHP0                               99    *
     C                   ENDDO
 
      * Output cashflow NPV totals
 
     C     *INU5         IFEQ      '0'
     C     TOTNPVL       ANDNE     *ZERO
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAGECHG
     C                   EVAL      TOTNPVL1 = TOTNPVL
     C                   WRITE     NPVTOTAL
     C                   ENDIF
 
     C     EREP_CASH     ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************                    CDE002
     C     REP_VALU      BEGSR                                                                CDE002
                                                                                              CDE002
      * decimal places                                                                        CDE002
     C                   SETOFF                                       53                      CDE002
     C     T#VCDP        COMP      1                                  525051                  CDE002
     C   52T#VCDP        COMP      2                                  53  52                  CDE002
                                                                                              CDE002
      *                                                                                       CDE002
     C     VALUKEY       SETLL     DEVALUP0                                                   CDE002
     C     VALUKEY       READE     DEVALUP0                               99                  CDE002
                                                                                              CDE002
      * Reset valuation total                                                                 CDE002
     C                   Z-ADD     *ZERO         TOTVALU                                      CDE002
      *                                                                                       CDE002
     C     *IN99         IFEQ      '0'                                                        CDE002
                                                                                              CDE002
      * Bypass if no details                                                                  CDE002
                                                                                              CDE002
     C     #CHECK        IFEQ      'Y'                                                        CDE002
     C                   MOVEL     'Y'           #DATA                                        CDE002
     C                   GOTO      EREP_VALU                                                  CDE002
     C                   ENDIF                                                                CDE002
                                                                                              CDE002
      * heading text                                                                          CDE002
     C                   MOVEL     NAR(6)        HTEXT                                        CDE002
     C                   MOVEL     *BLANK        HTEXTX                                       CDE002
                                                                                              CDE002
      * output valuation headings                                                             CDE002
                                                                                              CDE002
     C                   Z-ADD     1             CHLINE                                       CDE002
     C                   EXSR      PAGECHG                                                    CDE002
     C                   WRITE     GENHEAD                                                    CDE002
                                                                                              CDE002
     C                   ENDIF                                                                CDE002
      *                                                                                       CDE002
     C     *IN99         DOWEQ     '0'                                                        CDE002
                                                                                              CDE002
      * valuation date                                                                        CDE002
     C                   Z-ADD     V#VLDT        ZDAYNO                                       CDE002
     C                   EXSR      ZDATE2                                                     CDE002
     C                   MOVEL     ZADATE        VALDATE           7                          CDE002
                                                                                              CDE002
      * net valuation                                                                         CDE002
     C     V#PROF        ADD       V#LOSS        NETVALU          15 0                        CDE002
                                                                                              CDE002
      * valuation total                                                                       CDE002
     C                   ADD       NETVALU       TOTVALU          15 0                        CDE002
                                                                                              CDE002
                                                                                              CDE002
      * Output valuation details                                                              CDE002
                                                                                              CDE002
      * set printer file fields, determine whether 1 or 2 lines output                        CDE002
                                                                                              CDE002
     C                   EXSR      VALUDETPR                                                  CDE002
     C                   IF        *IN87 = *OFF                                               CDE002
     C                   Z-ADD     1             CHLINE                                       CDE002
     C                   ELSE                                                                 CDE002
     C                   Z-ADD     2             CHLINE                                       CDE002
     C                   ENDIF                                                                CDE002
                                                                                              CDE002
     C                   EXSR      PAGECHG                                                    CDE002
     C                   WRITE     VALUDET                                                    CDE002
     C     VALUKEY       READE     DEVALUP0                               99                  CDE002
     C                   ENDDO                                                                CDE002
                                                                                              CDE002
      * Output valuation totals                                                               CDE002
                                                                                              CDE002
     C     #CHECK        IFNE      'Y'                                                        CDE002
     C                   Z-ADD     1             CHLINE                                       CDE002
     C                   EXSR      PAGECHG                                                    CDE002
     C                   EVAL      TOTVALU1 = TOTVALU                                         CDE002
     C                   WRITE     VALUTOT                                                    CDE002
     C                   ENDIF                                                                CDE002
                                                                                              CDE002
     C     EREP_VALU     ENDSR                                                                CDE002
     C********************************************************************                    CDE002
      /SPACE 5                                                                                CDE002
     C********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      BJDFIN        ZDATFM            1            Date format ind
     C                   PARM      *ZERO         ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     PAGECHG       BEGSR
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM            3 0
     C                   EVAL      *IN80 = *INU5
     C                   EVAL      T#TCAT1 = T#TCAT
     C                   WRITE     PAGEHEAD
     C     4             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     POSNDETPR     BEGSR
 
      * Trigger print on 2 lines if any value large enough to lose data
 
     C                   EVAL      P#CCY1 = P#CCY
     C                   MOVEA     SEVENZEROS    *IN(81)
     C                   EVAL      P#NOML1 = P#NOML
     C                   EVAL      *IN81 = P#NOML > 9999999999
     C                   EVAL      P#RLAC1 = P#RLAC
     C                   EVAL      P#RLPL1 = P#RLPL
     C                   IF        *IN63 = *ON
     C                   EVAL      *IN82 = P#RLAC > 999999999
     C                   ELSE
     C                   EVAL      *IN82 = P#RLPL > 999999999
     C                   ENDIF
     C                   EVAL      P#FEAC1 = P#FEAC
     C                   EVAL      P#FEE1  = P#FEE
     C                   IF        *IN62 = *ON
     C                   EVAL      *IN83 = P#FEAC > 999999999
     C                   ELSE
     C                   EVAL      *IN83 = P#FEE  > 999999999
     C                   ENDIF
     C                   EVAL      P#DPAC1 = P#DPAC
     C                   EVAL      P#DIPR1 = P#DIPR
     C                   IF        *IN61 = *ON
     C                   EVAL      *IN84 = P#DPAC > 999999999
     C                   ELSE
     C                   EVAL      *IN84 = P#DIPR > 999999999
     C                   ENDIF
     C                   EVAL      P#CFAC1 = P#CFAC
     C                   EVAL      *IN85 = P#CFAC > 999999999
     C                   EVAL      P#INAC1 = P#INAC
     C                   EVAL      *IN86 = P#INAC > 999999999
     C                   IF        *IN81 = '1' OR *IN82 = '1' OR
     C                             *IN83 = '1' OR *IN84 = '1' OR
     C                             *IN85 = '1' OR *IN86 = '1'
     C                   EVAL      *IN87 = '1'
     C                   ENDIF
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     POSN_TOTPR    BEGSR
 
      * Trigger print on 2 lines if any value large enough to lose data
 
     C                   EVAL      P#RLAC_T1 = P#RLAC_T
     C                   EVAL      P#FEAC_T1 = P#FEAC_T
     C                   EVAL      P#DPAC_T1 = P#DPAC_T
     C                   EVAL      P#CFAC_T1 = P#CFAC_T
     C                   EVAL      P#INAC_T1 = P#INAC_T
     C                   MOVEA     SEVENZEROS    *IN(81)
     C                   EVAL      *IN81 = P#RLAC_T > 999999999
     C                   EVAL      *IN82 = P#FEAC_T > 999999999
     C                   EVAL      *IN83 = P#DPAC_T > 999999999
     C                   EVAL      *IN84 = P#CFAC_T > 999999999
     C                   EVAL      *IN85 = P#INAC_T > 999999999
     C                   IF        *IN81 = '1' OR *IN82 = '1' OR
     C                             *IN83 = '1' OR *IN84 = '1' OR
     C                             *IN85 = '1'
     C                   EVAL      *IN87 = '1'
     C                   ENDIF
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     EVNTDETPR     BEGSR
 
      * Trigger print on 2 lines if any value large enough to lose data
 
     C                   EVAL      E#TAMT1 = E#TAMT
     C                   EVAL      E#COMM1 = E#COMM
     C                   EVAL      E#INTA1 = E#INTA
     C                   EVAL      E#PRAM1 = E#PRAM
     C                   EVAL      E#NOML1 = E#NOML
     C                   MOVEA     SEVENZEROS    *IN(81)
     C                   EVAL      *IN81 = E#TAMT > 9999999999
     C                   EVAL      *IN82 = E#COMM > 9999999999
     C                   EVAL      *IN83 = E#INTA > 9999999999
     C                   EVAL      *IN84 = E#PRAM > 9999999999
     C                   EVAL      *IN85 = E#NOML > 9999999999
     C                   IF        *IN81 = '1' OR *IN82 = '1' OR
     C                             *IN83 = '1' OR *IN84 = '1' OR
     C                             *IN85 = '1'
     C                   EVAL      *IN87 = '1'
     C                   ENDIF
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     CASHDETPR     BEGSR
 
      * Trigger print on 2 lines if any value large enough to lose data
 
     C                   EVAL      C#CCY1 = C#CCY
     C                   EVAL      C#SIGA1 = C#SIGA
     C                   EVAL      C#SIGN1 = C#SIGN
     C                   EVAL      C#NPVL1 = C#NPVL
     C                   EVAL      C#AMNT1 = C#AMNT
     C                   MOVEA     SEVENZEROS    *IN(81)
     C                   EVAL      *IN81 = C#NPVL > 99999999999
     C                   EVAL      *IN82 = C#AMNT > 9999999999999
     C                   IF        *IN81 = '1' OR *IN82 = '1'
     C                   EVAL      *IN87 = '1'
     C                   ENDIF
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************                    CDE002
     C     VALUDETPR     BEGSR                                                                CDE002
                                                                                              CDE002
      * Trigger print on 2 lines if any value large enough to lose data                       CDE002
                                                                                              CDE002
     C                   EVAL      NETVALU1= NETVALU                                          CDE002
     C                   EVAL      V#MKVL1 = V#MKVL                                           CDE002
     C                   MOVEA     SEVENZEROS    *IN(81)                                      CDE002
     C                   EVAL      *IN81 = NETVALU > 99999999999                              CDE002
     C                   EVAL      *IN82 = V#MKVL  > 99999999999                              CDE002
     C                   IF        *IN81 = '1' OR *IN82 = '1'                                 CDE002
     C                   EVAL      *IN87 = '1'                                                CDE002
     C                   ENDIF                                                                CDE002
     C                   ENDSR                                                                CDE002
     C********************************************************************                    CDE002
      /SPACE 5                                                                                CDE002
     C********************************************************************
     C     *INZSR        BEGSR
      *
      * ENTRY PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    T#TCAT            4
     C                   PARM                    P_SEQNCE          5
     C                   PARM                    P_ENTITY          3
 
      * Initialize line number to force page headings
     C                   Z-ADD     99            LINENO
 
      * Get bank details
     C     1             CHAIN     SDBANKPD                           99
 
      * Set indicator to control page headings
     C     T#TCAT        COMP      *BLANK                             1010      *
 
      * Key lists
     C     POSNKEY       KLIST
     C                   KFLD                    T#MOD
     C                   KFLD                    T#TREF
     C                   KFLD                    XXASLI
 
     C     EVNTKEY       KLIST
     C                   KFLD                    T#MOD
     C                   KFLD                    T#TREF
     C                   KFLD                    XXASLI
 
     C     CASHKEY       KLIST
     C                   KFLD                    T#MOD
     C                   KFLD                    T#TREF
     C                   KFLD                    XXASLI
 
     C     VALUKEY       KLIST                                                                CDE002
     C                   KFLD                    T#MOD                                        CDE002
     C                   KFLD                    T#TREF                                       CDE002
                                                                                              CDE002
     C                   ENDSR
     C********************************************************************
      /SPACE 5
**  CPY@
(c) Finastra International Limited 2001
** TAB
DDDEAL DATE
VDVALUE DATE
FEFEE (OR PREMIUM)
XMFOREX MARGIN                                                                                CDE002
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
** NAR
Positions
Events
Cashflows
- asset
- liability
Valuation
