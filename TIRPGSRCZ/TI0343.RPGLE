     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI COB accrual suspense postings reporting')     *
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Interface Module                    *
      *                                                               *
      *  TI0343  - TI COB accrual suspense postings report generation *
      *                                                               *
      *  Function:  This program is responsible for generating the    *
      *             reports for all the suspense postings and for     *
      *             all currencies with unbalanced suspense postings. *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP207             Date 10Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CTI003  *CREATE    Date 06Feb01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *           (Recompile)                                         *
      *  CTI003 - Accrual postings enhancements.                      *
      *           Report on suspense accounts for accrual postings.   *
      *                                                               *
      *****************************************************************
     FTI0343P1  O    E             PRINTER OFLIND(*IN87)
     F                                     USROPN
     FTI0343P2  O    E             PRINTER OFLIND(*IN88)
     F                                     USROPN
     FGLJENPPD  IF   E             DISK    INFSR(*PSSR)
      * GL Journal Entry Posting
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  89    - Read GLJENPPD                                        *
      *  U7+U8 - Database Error                                       *
      *                                                               *
      *****************************************************************
      *
     D PSDS           SDS
      **  Program status data structure.
     D  ##JOB                244    253
     D  ##USER               254    263
     D  ##JBNO               264    269  0
     D  ##PGM            *PROC
      *
     D DBERR         E DS                  EXTNAME(LDA)
      * Data structure for data-base error processing.
      *
     D RUNDAT        E DS
      ** DS for report dates
      *
     D TotCredit       S             13  0 INZ(0)
     D TotDebit        S             13  0 INZ(0)
     D GOODR           S              1    INZ('0')
     D BADR            S              1    INZ('0')
      *
      *****************************************************************
      *  P R O G R A M     S T A R T                                  *
      *****************************************************************
      *
      ** Open all suspense accounts report
      *
     C                   OPEN      TI0343P1
     C                   OPEN      TI0343P2
      *
      * Read in Date
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      * Read the first posting
     C                   READ      GLJENPPD                               89
      *
      * If there are postings
     C     *IN89         IFEQ      *OFF
      *
      * Set working currency value
     C                   EVAL      W#CYCD = BTCYCD
     C     *IN89         DOWEQ     *OFF
      *
      * Work out total debit and total credit for each currency.
     C                   IF        BTCYCD = W#CYCD
      *
     C                   IF        BTDCIN = 'C'
     C                   EVAL      TotCredit = TotCredit + BTPTAM
     C                   ENDIF
      *
     C                   IF        BTDCIN = 'D'
     C                   EVAL      TotDebit = TotDebit + BTPTAM
     C                   ENDIF
      *
     C                   ELSE
      *
      * Work out discrepancy for unbalanced currencies.
     C                   IF        TotCredit <> TotDebit
     C                   EVAL      W#PTAM = TotCredit - TotDebit
      *
     C                   IF        W#PTAM < 0
     C                   EVAL      W#PTAM = W#PTAM * -1
     C                   ENDIF
      *
      * Write headers for unbalanced currencies report.
     C                   IF        BADR = '0'
     C                   WRITE     HEAD2
     C                   WRITE     SUBHED2
     C                   EVAL      BADR = '1'
     C                   ENDIF
      *
      * Write unbalanced currencies report.
     C                   WRITE     DETAIL2
     C                   ENDIF
      *
      * All suspense account report processing.
     C                   IF        BTDCIN = 'C'
     C                   EVAL      TotCredit = BTPTAM
     C                   EVAL      TotDebit = 0
     C                   ENDIF
      *
     C                   IF        BTDCIN = 'D'
     C                   EVAL      TotDebit =  BTPTAM
     C                   EVAL      TotCredit = 0
     C                   ENDIF
     C                   EVAL      W#PTAM = 0
     C                   ENDIF
      *
      * Write headers for all suspense accounts report.
     C
     C                   IF        GOODR = '0'
     C                   WRITE     HEAD
     C                   WRITE     SUBHED
     C                   EVAL      GOODR = '1'
     C                   ENDIF
      *
      * Write all suspense accounts report.
     C                   WRITE     DETAIL
     C                   EVAL      W#CYCD = BTCYCD
      *
      * Read the next posting
     C                   READ      GLJENPPD                               89
     C                   ENDDO
      *
      * Work out discrepancy for unbalanced currencies.
     C                   IF        TotCredit <> TotDebit
     C                   EVAL      W#PTAM = TotCredit - TotDebit
      *
      * Write headers for unbalanced currencies report.
     C                   IF        BADR = '0'
     C                   WRITE     HEAD2
     C                   WRITE     SUBHED2
     C                   EVAL      BADR = '1'
     C                   ENDIF
      *
      * Write unbalanced currencies report.
     C                   WRITE     DETAIL2
     C                   ENDIF
     C                   ENDIF
     C                   WRITE     TRAIL
     C                   WRITE     TRAIL2
     C                   CLOSE     TI0343P1
     C                   CLOSE     TI0343P2
      *
      * If there are unbalanced suspense accounts halt COB
     C                   IF        BADR = '1'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   SETON                                            LR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR                                                  *** *PSSR  ***
      *
     C                   SETON                                        U7U8LR
      *
      *  Check to see that *PSSR has not already been called.
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
      *
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LOCK         IN        WLDA
     C                   MOVEL     DBERR         WLDA
     C                   OUT       WLDA
      *
     C                   DUMP
     C                   ENDIF
      *
      * Exit program
     C                   RETURN
      *
     C                   ENDSR
