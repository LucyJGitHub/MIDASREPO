     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Balance Accumulation - DEALING module')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXBLACDL - Balance Accumulation - DEALING module             *
      *                                                               *
      *  Function:  This module accumulates the monthly events for    *
      *             principal changes into the dealing balances file. *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 242239             Date 18Sep06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  242239 - Recompile over changed MXBLDLPD. Upgrade 222619.    *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXMEDLL2  IP A E           K DISK    RENAME(MXDEDLP0: MXMEDLP0)
     F                                     INFSR(*PSSR)
      * Monthly Events - Dealing module
 
     FMXMEDLPL2 IS A E           K DISK    RENAME(MXDEDLP0: MXMEDLP1)
     F                                     INFSR(*PSSR)
      * Monthly Events - Dealing module (PREVIOUS MONTH)
 
     FMXBLDLPD  O    E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(P_)
      * Balances - Dealing module
 
     FMXDGDTPD  IF   E           K DISK    INFSR(*PSSR)
     FMXDGECPD  IF   E           K DISK    INFSR(*PSSR)
 
     FMXBLACAU  O    E             PRINTER INFSR(*PSSR)  USROPN
      * Balance Accumulation Audit Report
 
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
 
 
     D BV_AMT          S             13  0 DIM(12)
 
 
      ** External DS for BANK details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
 
     IMXMEDLP0      01
     I                                          DLNO            M3
     I                                          ECCY            M2
     I                                          EDAT            M1
     IMXMEDLP1      02
     I                                          DLNO            M3
     I                                          ECCY            M2
     I                                          EDAT            M1
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    I#DTAG            4
 
      * On change of deal number or change of currency
      * ----------------------------------------------
 
     C     DLNO          IFNE      P_DLNO
     C     ECCY          ORNE      P_CCY
 
      * If any principal increases or decreases were read
      * Write a balance record for the last deal number
 
     C     Inc_Dec       IFEQ      'Y'
     C                   WRITE     MXBLDLP0
     C                   ADD       1             WBal_cnt
     C                   MOVEL     *BLANK        Inc_Dec
     C                   ENDIF
 
     C                   Z-ADD     DLNO          P_DLNO
     C                   MOVEL     ECCY          P_CCY
     C                   Z-ADD     *ZERO         P_BAL
     C                   Z-ADD     *ZERO         BV_AMT
     C                   ENDIF
 
      * On change of date
      * -----------------
      * If any principal increases or decreases were read
      * Write a balance record for the last deal number
 
     C     EDAT          IFNE      P_DATE
     C     Inc_Dec       ANDEQ     'Y'
     C                   WRITE     MXBLDLP0
     C                   ADD       1             WBal_cnt
     C                   MOVEL     *BLANK        Inc_Dec
     C                   ENDIF
 
      * Set balance fields
      * ------------------
 
     C                   Z-ADD     EDAT          P_DATE
     C     REVI          IFEQ      0
     C                   Z-ADD     EAMT          CHG_P_BAL        13 0
     C                   ELSE
     C                   Z-SUB     EAMT          CHG_P_BAL
     C                   ENDIF
 
      * Look up the category code
      * If the category code is a principal increase or decrease
      * Update the running balance
      * --------------------------
 
     C                   Z-ADD     1             @X                3 0
     C     DECATC        LOOKUP    CC(@X)                                 99    *
 
     C     *in99         IFEQ      '1'
     C                   MOVEL     'Y'           Inc_Dec           1
     C                   EXSR      UPD_BL
     C                   ENDIF
 
      * Final Processing
 
     CLR                 EXSR      FINAL
 
     C/SPACE 5
      *********************************************************************
      * Final Processing
      *********************************************************************
     C     FINAL         BEGSR
 
      * If any principal increases or decreases were read
      * Write a balance record for the previous deal number
 
     C     Inc_Dec       IFEQ      'Y'
     C                   WRITE     MXBLDLP0
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
 
     C                   Z-ADD     EDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATEN        MM                2 0
 
     C                   ADD       BV_AMT(MM)    P_BAL
     C                   Z-ADD     *ZERO         BV_AMT(MM)
 
      * Otherwise
      * Do balance accumulation
 
     C                   ELSE
 
     C                   MOVEL     CP(@X)        DECAPI
 
     C     DECAPI        IFEQ      'I'
     C                   ADD       CHG_P_BAL     P_BAL
     C                   ELSE
     C                   SUB       CHG_P_BAL     P_BAL
     C                   ENDIF
 
      * If the event date is less than the event generation date
      * Check for back-valuation into a previous month
 
     C     EDAT          IFLT      EAEVGD
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
      * if the event date month is not equal
      * to the event generation date month.
 
     C                   Z-ADD     EDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATEN        MMED              2 0
 
     C                   Z-ADD     EAEVGD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATEN        MMEG              2 0
 
      * If so, add to the total of back-valued amounts
 
     C     MMED          IFNE      MMEG
     C     DECAPI        IFEQ      'I'
     C                   ADD       CHG_P_BAL     BV_AMT(MMEG)
     C                   ELSE
     C                   SUB       CHG_P_BAL     BV_AMT(MMEG)
     C                   ENDIF
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
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
 
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
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
