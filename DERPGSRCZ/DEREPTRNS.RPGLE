     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*OVR *: OVRDBF FILE(DETRANL2) TOFILE(DEPTRANL2) SHARE(*NO)         : *
/*OVR *: OVRDBF FILE(DEPOSNL0) TOFILE(DEPPOSNL0) SHARE(*NO)         : *
/*OVR *: OVRDBF FILE(DEEVNTL0) TOFILE(DEPEVNTL0) SHARE(*NO)         : *
/*OVR *: OVRDBF FILE(DECASHL0) TOFILE(DEPCASHL0) SHARE(*NO)         : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Report transaction - summary')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEREPTRNS - Report Transactions Summary                      *
      *                                                               *
      *  Function:  This module produces a summary report of all the  *
      *             records on the projected transactions extract     *
      *             files DEPTRANPD and DEPPOSNPD.                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FDETRANL2  IP  AE           K DISK
     FDEPOSNL0  IF   E           K DISK
     FSDBANKPD  IF   E             DISK
     FDEREPTSP1 O    E             PRINTER USROPN INFDS(SPOOL)
 
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
 
     D                 DS
     D  POSITDT                1      7
     D  POSITMM                3      5
     D  POSITYY                6      7
     D                 DS
     D  p@POSITDT              1      7
     D  p@POSITMM              3      5
     D  p@POSITYY              6      7
 
      * Start of Printer File DS fields
     D                 DS
     D T#TCAT1                 1      4
     D T#TCAT2                 1      4
 
     D                 DS
     D HTEXTX1                 1      9
     D HTEXTX2                 1      9
 
     D                 DS
     D P#RLAC_M1               1     15S 0
     D P#RLAC_M2               1     15S 0
     D P#RLAC_M3               1     15S 0
     D P#RLAC_M4               1     15S 0
     D P#RLAC_M5               1     15S 0
     D P#RLAC_M6               1     15S 0
     D P#RLAC_M7               1     15S 0
     D P#RLAC_M8               1     15S 0
 
     D                 DS
     D P#FEAC_M1               1     15S 0
     D P#FEAC_M2               1     15S 0
     D P#FEAC_M3               1     15S 0
     D P#FEAC_M4               1     15S 0
 
     D                 DS
     D P#DPAC_M1               1     15S 0
     D P#DPAC_M2               1     15S 0
     D P#DPAC_M3               1     15S 0
     D P#DPAC_M4               1     15S 0
     D P#DPAC_M5               1     15S 0
     D P#DPAC_M6               1     15S 0
     D P#DPAC_M7               1     15S 0
     D P#DPAC_M8               1     15S 0
 
     D                 DS
     D P#CFAC_M1               1     15S 0
     D P#CFAC_M2               1     15S 0
     D P#CFAC_M3               1     15S 0
     D P#CFAC_M4               1     15S 0
 
     D                 DS
     D P#INAC_M1               1     15S 0
     D P#INAC_M2               1     15S 0
     D P#INAC_M3               1     15S 0
     D P#INAC_M4               1     15S 0
     D P#INAC_M5               1     15S 0
     D P#INAC_M6               1     15S 0
     D P#INAC_M7               1     15S 0
     D P#INAC_M8               1     15S 0
 
     D                 DS
     D P#RLAC_T1               1     15S 0
     D P#RLAC_T2               1     15S 0
     D P#RLAC_T3               1     15S 0
     D P#RLAC_T4               1     15S 0
     D P#RLAC_T5               1     15S 0
     D P#RLAC_T6               1     15S 0
     D P#RLAC_T7               1     15S 0
     D P#RLAC_T8               1     15S 0
 
     D                 DS
     D P#FEAC_T1               1     15S 0
     D P#FEAC_T2               1     15S 0
     D P#FEAC_T3               1     15S 0
     D P#FEAC_T4               1     15S 0
 
     D                 DS
     D P#DPAC_T1               1     15S 0
     D P#DPAC_T2               1     15S 0
     D P#DPAC_T3               1     15S 0
     D P#DPAC_T4               1     15S 0
     D P#DPAC_T5               1     15S 0
     D P#DPAC_T6               1     15S 0
     D P#DPAC_T7               1     15S 0
     D P#DPAC_T8               1     15S 0
 
     D                 DS
     D P#CFAC_T1               1     15S 0
     D P#CFAC_T2               1     15S 0
     D P#CFAC_T3               1     15S 0
     D P#CFAC_T4               1     15S 0
 
     D                 DS
     D P#INAC_T1               1     15S 0
     D P#INAC_T2               1     15S 0
     D P#INAC_T3               1     15S 0
     D P#INAC_T4               1     15S 0
     D P#INAC_T5               1     15S 0
     D P#INAC_T6               1     15S 0
     D P#INAC_T7               1     15S 0
     D P#INAC_T8               1     15S 0
      * End of Printer File DS fields
 
     D SIXZEROS        S              6    INZ('000000')
 
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
     C                   CLOSE     DEREPTSP1                                   *
     C                   ENDIF
 
     C                   EVAL      PAGNUM = 0
     C                   OPEN      DEREPTSP1
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
     C* Error during ZSFILE processing, return to calling program
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
     C                   OPEN      DEREPTSP1
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
     C                   MOVEL     'Y'           #CHECK            1
      *
      * REPORT POSITIONS
      *
     C                   MOVEL     'A'           XXASLI            1
     C                   MOVEL     'N'           #DATA             1
     C                   EXSR      REP_POSN
     C                   MOVEL     #DATA         #DATA_A           1
      *
     C                   MOVEL     'L'           XXASLI
     C                   MOVEL     'N'           #DATA             1
     C                   EXSR      REP_POSN
     C                   MOVEL     #DATA         #DATA_L           1
      *
      * NO DATA, SO BYPASS
      *
     C     #DATA_A       IFNE      'Y'
     C     #DATA_L       ANDNE     'Y'
     C                   GOTO      ETRANCHG
     C                   ENDIF
      *
     C                   MOVEL     'N'           #CHECK
      *
      * PROCESS TRANSACTION DETAILS
      *
 
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
 
      * Output transaction headings
 
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAGECHG
     C                   WRITE     TRANHEAD
      *
      * REPORT POSITIONS
      *
     C     #DATA_A       IFEQ      'Y'
     C                   MOVEL     'A'           XXASLI            1
     C                   EXSR      REP_POSN
     C                   ENDIF
      *
     C     #DATA_L       IFEQ      'Y'
     C                   MOVEL     'L'           XXASLI
     C                   EXSR      REP_POSN
     C                   ENDIF
 
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
 
      * Reset month totals
     C                   Z-ADD     0             P#INAC_M
     C                   Z-ADD     0             P#CFAC_M
     C                   Z-ADD     0             P#DPAC_M
     C                   Z-ADD     0             P#FEAC_M
     C                   Z-ADD     0             P#RLAC_M
 
      * Reset position totals
     C                   Z-ADD     0             P#INAC_T
     C                   Z-ADD     0             P#CFAC_T
     C                   Z-ADD     0             P#DPAC_T
     C                   Z-ADD     0             P#FEAC_T
     C                   Z-ADD     0             P#RLAC_T
      *
     C     POSNKEY       SETLL     DEPOSNP0
     C     POSNKEY       READE     DEPOSNP0                               99    *
 
      * Bypass if no details
 
     C     *IN99         IFEQ      '1'
     C                   GOTO      EREP_POSN
     C                   ENDIF
 
      * position date
     C                   Z-ADD     P#IACD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        p@POSITDT
 
      * heading text
     C     XXASLI        IFEQ      'A'
     C                   MOVEL     'ASSET    '   HTEXTX            9
     C                   ENDIF
     C     XXASLI        IFEQ      'L'
     C                   MOVEL     'LIABILITY'   HTEXTX
     C                   ENDIF
      *
     C     *IN99         DOWEQ     '0'
 
      * decimal places
     C                   SETOFF                                       53
     C     P#NCDP        COMP      1                                  525051
     C   52P#NCDP        COMP      2                                  53  52
 
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
 
      * position date
     C                   Z-ADD     P#IACD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        POSITDT
 
      * output month totals
 
     C     p@POSITMM     IFNE      POSITMM
     C     p@POSITYY     ORNE      POSITYY
 
     C     P#INAC_M      IFNE      *ZERO
     C     P#CFAC_M      ORNE      *ZERO
     C     P#DPAC_M      ORNE      *ZERO
     C     P#FEAC_M      ORNE      *ZERO
     C     P#RLAC_M      ORNE      *ZERO
 
     C     #CHECK        IFEQ      'Y'
     C                   MOVEL     'Y'           #DATA
     C                   GOTO      EREP_POSN
     C                   ENDIF
 
      * set printer file fields, determine whether 1 or 2 lines output
     C                   EXSR      POSN_MTHPR
     C                   IF        *IN86 = *OFF
     C                   Z-ADD     1             CHLINE
     C                   ELSE
     C                   Z-ADD     2             CHLINE
     C                   ENDIF
 
     C                   EXSR      PAGECHG
     C                   WRITE     POSN_MTH
     C                   ENDIF
 
     C                   MOVEL     POSITDT       p@POSITDT
     C                   ENDIF
 
      * update month totals
     C                   ADD       P#INAC        P#INAC_M         15 0
     C                   ADD       P#CFAC        P#CFAC_M         15 0
     C   61              ADD       P#DPAC        P#DPAC_M         15 0
     C  N61              ADD       P#DIPR        P#DPAC_M         15 0
     C   62              ADD       P#FEAC        P#FEAC_M         15 0
     C  N62              ADD       P#FEE         P#FEAC_M         15 0
     C   63              ADD       P#RLAC        P#RLAC_M         15 0
     C  N63              ADD       P#RLPL        P#RLAC_M         15 0
 
      * update position totals
     C                   ADD       P#INAC        P#INAC_T         15 0
     C                   ADD       P#CFAC        P#CFAC_T         15 0
     C   61              ADD       P#DPAC        P#DPAC_T         15 0
     C  N61              ADD       P#DIPR        P#DPAC_T         15 0
     C   62              ADD       P#FEAC        P#FEAC_T         15 0
     C  N62              ADD       P#FEE         P#FEAC_T         15 0
     C   63              ADD       P#RLAC        P#RLAC_T         15 0
     C  N63              ADD       P#RLPL        P#RLAC_T         15 0
 
     C     POSNKEY       READE     DEPOSNP0                               99    *
     C                   ENDDO
 
      * output month totals
 
     C     P#INAC_M      IFNE      *ZERO
     C     P#CFAC_M      ORNE      *ZERO
     C     P#DPAC_M      ORNE      *ZERO
     C     P#FEAC_M      ORNE      *ZERO
     C     P#RLAC_M      ORNE      *ZERO
 
     C     #CHECK        IFEQ      'Y'
     C                   MOVEL     'Y'           #DATA
     C                   GOTO      EREP_POSN
     C                   ENDIF
 
      * set printer file fields, determine whether 1 or 2 lines output
     C                   EXSR      POSN_MTHPR
     C                   IF        *IN86 = *OFF
     C                   Z-ADD     1             CHLINE
     C                   ELSE
     C                   Z-ADD     2             CHLINE
     C                   ENDIF
 
     C                   EXSR      PAGECHG
     C                   WRITE     POSN_MTH
     C                   ENDIF
 
      * output position totals
 
     C     #CHECK        IFEQ      'Y'
     C                   GOTO      EREP_POSN
     C                   ENDIF
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAGECHG
     C                   EXSR      POSN_TOTPR
     C                   WRITE     POSN_TOT
     C                   EVAL      P#RLAC_T1 = 0
     C                   EVAL      P#FEAC_T1 = 0
     C                   EVAL      P#DPAC_T1 = 0
     C                   EVAL      P#CFAC_T1 = 0
     C                   EVAL      P#INAC_T1 = 0
 
     C     EREP_POSN     ENDSR
     C********************************************************************
      /SPACE 5
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
     C     LINENO        IFGT      58
     C                   ADD       1             PAGNUM            3 0
     C                   EVAL      T#TCAT1 = T#TCAT
     C                   EVAL      *IN80 = *INU5
     C                   WRITE     PAGEHEAD
     C     7             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     POSN_MTHPR    BEGSR
 
      * Trigger print on 2 lines if any value large enough to lose data
 
     C                   EVAL      HTEXTX1 = HTEXTX
     C                   EVAL      P#RLAC_M1 = P#RLAC_M
     C                   EVAL      P#FEAC_M1 = P#FEAC_M
     C                   EVAL      P#DPAC_M1 = P#DPAC_M
     C                   EVAL      P#CFAC_M1 = P#CFAC_M
     C                   EVAL      P#INAC_M1 = P#INAC_M
     C                   MOVEA     SIXZEROS      *IN(81)
     C                   EVAL      *IN81 = P#RLAC_M > 99999999
     C                   EVAL      *IN82 = P#FEAC_M > 99999999
     C                   EVAL      *IN83 = P#DPAC_M > 99999999
     C                   EVAL      *IN84 = P#CFAC_M > 99999999
     C                   EVAL      *IN85 = P#INAC_M > 99999999
     C                   IF        *IN81 = '1' OR *IN82 = '1' OR
     C                             *IN83 = '1' OR *IN84 = '1' OR
     C                             *IN85 = '1'
     C                   EVAL      *IN86 = '1'
     C                   ENDIF
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     POSN_TOTPR    BEGSR
 
      * Trigger print on 2 lines if any value large enough to lose data
 
     C                   EVAL      HTEXTX1 = HTEXTX
     C                   EVAL      P#RLAC_T1 = P#RLAC_T
     C                   EVAL      P#FEAC_T1 = P#FEAC_T
     C                   EVAL      P#DPAC_T1 = P#DPAC_T
     C                   EVAL      P#CFAC_T1 = P#CFAC_T
     C                   EVAL      P#INAC_T1 = P#INAC_T
     C                   MOVEA     SIXZEROS      *IN(81)
     C                   EVAL      *IN81 = P#RLAC_T > 99999999
     C                   EVAL      *IN82 = P#FEAC_T > 99999999
     C                   EVAL      *IN83 = P#DPAC_T > 99999999
     C                   EVAL      *IN84 = P#CFAC_T > 99999999
     C                   EVAL      *IN85 = P#INAC_T > 99999999
     C                   IF        *IN81 = '1' OR *IN82 = '1' OR
     C                             *IN83 = '1' OR *IN84 = '1' OR
     C                             *IN85 = '1'
     C                   EVAL      *IN86 = '1'
     C                   ENDIF
     C                   ENDSR
     C********************************************************************
      /SPACE 5
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
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
**  CPY@
(c) Finastra International Limited 2001
