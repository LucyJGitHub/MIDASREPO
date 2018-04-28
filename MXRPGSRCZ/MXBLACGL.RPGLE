     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Balance Accumulation - GEN.LED. module')      *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXBLACGL - Balance Accumulation - GENERAL LEDGER module      *
      *                                                               *
      *  Function:  This module accumulates the monthly events for    *
      *             principal changes into the general ledger balances*
      *             file.                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR1097467B         Date 17Apr13               *
      *  Prev Amend No. AR1097467          Date 08Apr13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CCB016             Date 24Apr07               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242925             Date 10Oct06               *
      *                 242239             Date 18Sep06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1097467B - Expected 15% COB run optimization not met       *
      *  AR1097467 - Expected 15% COB run optimization not met        *
      *  CCB016 - CoB Performance Enhancements                        *
      *           Retail indicator should be checked on change of     *
      *           account code and processing conditioned upon        *
      *           that, not for every record.                         *
      *  242925 - Increase Account Code to 10 digits Signed (not P)   *
      *           Amend hook MXCPYSRC/MXFLTACOD                       *
      *  242239 - Recompile over changed MXBLGLPD. Upgrade 222619.    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *           (RE-COMPILE OVER CHANGED /COPY)                     *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     F***MXMEGLL2  IP A E           K DISK    RENAME(MXDEGLP0: MXMEGLP0)                   AR1097467
     F***MXMEGLL3  IP A E           K DISK    RENAME(MXDEGLP0: MXMEGLP0)        AR1097467 AR1097467B
     FMXMEGLL2  IP A E           K DISK    RENAME(MXDEGLP0: MXMEGLP0)                     AR1097467B
     F                                     INFSR(*PSSR)
      * Monthly Events - General Ledger module
 
     F***MXMEGLPL2 IS A E           K DISK    RENAME(MXDEGLP0: MXMEGLP1)                   AR1097467
     F***MXMEGLPL3 IS A E           K DISK    RENAME(MXDEGLP0: MXMEGLP1)        AR1097467 AR1097467B
     FMXMEGLPL2 IS A E           K DISK    RENAME(MXDEGLP0: MXMEGLP1)                     AR1097467B
     F                                     INFSR(*PSSR)
      * Monthly Events - General Ledger module (PREVIOUS MONTH)
 
     FMXBLGLPD  O    E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(P_)
      * Balances - General Ledger module
 
     FMXDGDTPD  IF   E           K DISK    INFSR(*PSSR)
     FMXDGECPD  IF   E           K DISK    INFSR(*PSSR)
 
     FMXBLACAU  O    E             PRINTER INFSR(*PSSR)  USROPN
      * Balance Accumulation Audit Report
 
     FSDACODL0  IF   E           K DISK    INFSR(*PSSR)                                   AR1097467B
      ** Midas SD Account codes file                                                      AR1097467B
                                                                                          AR1097467B
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
 
     D CC              S              2    DIM(99)
     D CP              S              1    DIM(99)
 
     D ACODR           S             10    DIM(7000)                                      AR1097467B
     D ACODTP          S              1    DIM(7000)                                      AR1097467B
 
     D BV_AMT          S             13  0 DIM(12)
 
     D I#ACOD          S             10S 0                                                    242925
     D SDACOD        E DS                  EXTNAME(SDACODPD)                               AR1097467
 
      ** External DS for BANK details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D DSSDY         E DS                  EXTNAME(DSSDY)                                  AR1097467
      ** Second DS for Access Programs, Long Data Structure                                AR1097467
 
 
     IMXMEGLP0      01
     I**********                                ACOD            M6              AR1097467 AR1097467B
     I**********                                BRCA            M6                         AR1097467
     I**********                                BRCA            M5              AR1097467 AR1097467B
     I**********                                CNUM            M5                         AR1097467
     I**********                                CNUM            M4              AR1097467 AR1097467B
     I**********                                CCY             M4                         AR1097467
     I**********                                CCY             M3              AR1097467 AR1097467B
     I**********                                ACOD            M3                         AR1097467
     I                                          BRCA            M6                        AR1097467B
     I                                          CNUM            M5                        AR1097467B
     I                                          CCY             M4                        AR1097467B
     I                                          ACOD            M3                        AR1097467B
     I                                          ACSQ            M2
     I                                          PSTD            M1
     IMXMEGLP1      02
     I**********                                ACOD            M6              AR1097467 AR1097467B
     I**********                                BRCA            M6                         AR1097467
     I**********                                BRCA            M5              AR1097467 AR1097467B
     I**********                                CNUM            M5                         AR1097467
     I**********                                CNUM            M4              AR1097467 AR1097467B
     I**********                                CCY             M4                         AR1097467
     I**********                                CCY             M3              AR1097467 AR1097467B
     I**********                                ACOD            M3                         AR1097467
     I                                          BRCA            M6                        AR1097467B
     I                                          CNUM            M5                        AR1097467B
     I                                          CCY             M4                        AR1097467B
     I                                          ACOD            M3                        AR1097467B
     I                                          ACSQ            M2
     I                                          PSTD            M1
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    I#DTAG            4
 
      * On change of account ID
      * -----------------------
 
     C     BRCA          IFNE      P_BRCA
     C     CNUM          ORNE      P_CNUM
     C     CCY           ORNE      P_CCY
     C     ACOD          ORNE      P_ACOD
     C     ACSQ          ORNE      P_ACSQ
 
      * If any principal increases or decreases were read
      * Write a balance record for the last account
 
     C     Inc_Dec       IFEQ      'Y'
     C                   WRITE     MXBLGLP0
     C                   ADD       1             WBal_cnt
     C                   MOVEL     *BLANK        Inc_Dec
     C                   ENDIF
 
     C                   MOVEL     BRCA          P_BRCA
     C                   MOVEL     CNUM          P_CNUM
     C                   MOVEL     CCY           P_CCY
     C                   MOVEL     ACOD          P_ACOD
     C                   MOVEL     ACSQ          P_ACSQ
     C                   Z-ADD     *ZERO         P_BAL
     C                   Z-ADD     *ZERO         BV_AMT
     C                   ENDIF
 
      * On change of account code                                                             CCB016
                                                                                              CCB016
     C     ACOD          IFNE      I#ACOD                                                     CCB016
     C**********         MOVE      'D'           I#LD                               CCB016 AR1097467
     C                   MOVEL     ACOD          I#ACOD                                       CCB016
     C**********         EXSR      ACOD_FLT                                         CCB016 AR1097467
      *                                                                                    AR1097467
     C                   MOVE      ACOD          @ACOD            10                       AR1097467
     C                   Z-ADD     ARINDX        X                                        AR1097467B
     C     @ACOD         LOOKUP    ACODR(X)                               08              AR1097467B
     C     *IN08         IFEQ      '1'                                                    AR1097467B
     C                   MOVE      ACODTP(X)     Acc_Type                                 AR1097467B
     C                   ELSE                                                             AR1097467B
     C                   CALLB     'AOACODR0'                                              AR1097467
     C                   PARM      *BLANKS       @RTCD                                     AR1097467
     C                   PARM      '*KEY'        @OPTN                                     AR1097467
     C                   PARM                    @ACOD                                     AR1097467
     C     SDACOD        PARM      SDACOD        DSSDY                                     AR1097467
      *                                                                                    AR1097467
     C     @RTCD         IFEQ      *BLANKS                                                 AR1097467
     C                   MOVE      A5ACTY        Acc_Type          1                       AR1097467
     C                   ELSE                                                              AR1097467
     C**********         EVAL      I#ERMS = 'ERROR IN CALL TO MXACODFLT'        AR1097467 AR1097467B
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO AOACODR0'                   AR1097467B
     C                   EXSR      *PSSR                                                   AR1097467
     C                   ENDIF                                                             AR1097467
     C                   ENDIF                                                            AR1097467B
      *                                                                                    AR1097467
     C                   ENDIF                                                                CCB016
                                                                                              CCB016
      * Only process account codes whose account type is NOT retail                           CCB016
                                                                                              CCB016
     C     Acc_Type      IFNE      'R'                                                        CCB016
                                                                                              CCB016
      * On change of date
      * -----------------
      * If any principal increases or decreases were read
      * Write a balance record for the last account
 
     C     PSTD          IFNE      P_DATE
     C     Inc_Dec       ANDEQ     'Y'
     C                   WRITE     MXBLGLP0
     C                   ADD       1             WBal_cnt
     C                   MOVEL     *BLANK        Inc_Dec
     C                   ENDIF
 
      * Set balance fields
      * ------------------
 
     C                   Z-ADD     PSTD          P_DATE
     C     DRCR          IFEQ      1
     C                   Z-SUB     SPSTA         CHG_P_BAL        15 0
     C                   ELSE
     C                   Z-ADD     SPSTA         CHG_P_BAL
     C                   ENDIF
 
      * Look up the category code
      * If the category code is a principal increase or decrease
      * Update the running balance
      * --------------------------
 
     C                   Z-ADD     1             @X                3 0
     C     DECATC        LOOKUP    CC(@X)                                 99    *
 
     C     *in99         IFEQ      '1'
      ************                                                                            CCB016
      **Only*process account codes whose account type is NOT retail                           CCB016
      ************                                                                            CCB016
     C************       MOVE      'D'           I#LD                                         CCB016
     C************       MOVEL     ACOD          I#ACOD                                       CCB016
     C************       EXSR      ACOD_FLT                                                   CCB016
      ************                                                                            CCB016
     C*****Acc_Type      IFNE      'R'                                                        CCB016
     C                   MOVEL     'Y'           Inc_Dec           1
     C                   EXSR      UPD_BL
     C************       ENDIF                                                                CCB016
     C                   ENDIF
                                                                                              CCB016
     C                   ENDIF                                                                CCB016
 
      * Final Processing
 
     CLR                 EXSR      FINAL
 
     C/SPACE 5
      *********************************************************************
      * Final Processing
      *********************************************************************
     C     FINAL         BEGSR
 
      * If any principal increases or decreases were read
      * Write a balance record for the previous account
 
     C     Inc_Dec       IFEQ      'Y'
     C                   WRITE     MXBLGLP0
     C                   ADD       1             WBal_cnt
     C                   ENDIF
 
      * Output audit report totals
 
     C                   WRITE     TOTALS
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *********************************************************************
      * Update the running balance
      *********************************************************************
     C     UPD_BL        BEGSR
 
      * Increment count of input events
 
     C                   ADD       1             IEvt_cnt
 
      * If this is a start of month event
 
     C     DECATC        IFEQ      '01'
 
      * Initialize the balance
 
     C                   Z-ADD     CHG_P_BAL     P_BAL
 
      * Adjust the balance with the back-valued amounts
      * for the month
 
     C                   Z-ADD     PSTD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATEN        MM                2 0
 
     C                   ADD       BV_AMT(MM)    P_BAL
     C                   Z-ADD     *ZERO         BV_AMT(MM)
 
      * Otherwise
      * Do balance accumulation
 
     C                   ELSE
 
     C                   ADD       CHG_P_BAL     P_BAL
 
      * If the posting date is less than the event generation date
      * Check for back-valuation into a previous month
 
     C     PSTD          IFLT      EAEVGD
     C                   EXSR      CHK_BV
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Check for back-valuation into a previous month
      ********************************************************************
     C     CHK_BV        BEGSR
 
      * A back-valuation into a previous month has occurred
      * if the posting date month is not equal
      * to the event generation date month.
 
     C                   Z-ADD     PSTD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATEN        MMPD              2 0
 
     C                   Z-ADD     EAEVGD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATEN        MMEG              2 0
 
      * If so, add to the total of back-valued amounts
 
     C     MMPD          IFNE      MMEG
     C                   ADD       CHG_P_BAL     BV_AMT(MMEG)
     C                   ENDIF
     C
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert a day number into a date
      ********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      'M'           ZDFIN             1
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Throw page headings (if required)
      ********************************************************************
     C     PAG           BEGSR
 
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   WRITE     PAGEHEAD
     C     4             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     'C'           I#EXTT            1
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
 
      * Load account codes for export
 
     C**********         MOVE      'L'           I#LD                                      AR1097467
     C**********         Z-ADD     *ZERO         I#ACOD                                    AR1097467
     C**********         EXSR      ACOD_FLT                                                AR1097467
 
                                                                                          AR1097467B
      ** Cache Account Codes                                                              AR1097467B
                                                                                          AR1097467B
     C                   Z-ADD     7000          X                 4 0                    AR1097467B
     C                   READ      SDACODL0                               09              AR1097467B
     C     *IN09         DOWEQ     '0'                                                    AR1097467B
     C     X             ANDGT     0                                                      AR1097467B
     C                   MOVEL     A5ACCD        ACODR(X)                                 AR1097467B
     C                   MOVEL     A5ACTY        ACODTP(X)                                AR1097467B
     C                   SUB       1             X                                        AR1097467B
     C                   READ      SDACODL0                               09              AR1097467B
     C                   ENDDO                                                            AR1097467B
                                                                                          AR1097467B
     C                   Z-ADD     X             ARINDX            3 0                    AR1097467B
     C                   ADD       1             ARINDX                                   AR1097467B
     C                   SETOFF                                       09                  AR1097467B
 
      * Get Data Group Details
 
     C     I#DTAG        CHAIN     MXDGDTP0                           99        *
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'NO RECORD ON MXDGDTPD FOR ' +
     C                                      I#DTAG
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Get data group event categories
      * for principal increases and decreases
 
     C                   Z-ADD     0             @X                3 0
     C     I#DTAG        SETLL     MXDGECP0
     C     I#DTAG        READE     MXDGECP0                               99    *
     C     *in99         DOWEQ     '0'
     C     DECAPI        IFEQ      'I'
     C     DECAPI        OREQ      'D'
     C                   ADD       1             @X
     C                   MOVEL     DECATC        CC(@X)
     C                   MOVEL     DECAPI        CP(@X)
     C                   ENDIF
     C     I#DTAG        READE     MXDGECP0                               99    *
     C                   ENDDO
 
 
 
      * Set the report description
 
     C                   MOVEL     DGDESC        ZZDESC
 
 
      * Open the printer file
 
     C                   OPEN      MXBLACAU
 
      * Initialize time
 
     C                   TIME                    #TIME
 
      * Output audit report page headings
 
     C                   Z-ADD     *ZERO         CHLINE            3 0
     C                   Z-ADD     99            LINENO
     C                   EXSR      PAG
 
      * Zeroize counts of events
 
     C                   Z-ADD     *ZERO         IEvt_cnt          6 0
     C                   Z-ADD     *ZERO         WBal_cnt          6 0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * A C C O U N T   C O D E   F I L T E R
      ***/COPY*MXCPYSRC,MXFLTACOD                                                          AR1097467
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
