     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Reconcile Balances - CLOANCL')                *
/*XBIA*  OVRDBF FILE(MXBLLELPDA) TOFILE(MXBLLELPD) SHARE(*NO)         *
/*XBIB*  OVRDBF FILE(MXMELELPDA) TOFILE(MXMELELPD) SHARE(*NO)         *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXMATEBLE - Match Events against Balances - CLOANCL          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 185351  *CREATE    Date 23Oct00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  185351 - Mismatch between events and balances sent to CS4++  *
      *                                                               *
      *****************************************************************
 
     FMXBLLELL0 IP A E           K DISK
      * Balances - CLOANCL (OVRDBF TO xxxx)
 
     FMXMELELL0 IS A E           K DISK
      * Monthly Events - CLOANCL (OVRDBF TO xxxx)
 
     FMXSLECLPD IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF: MXSLECLP0)
      * Saved Loans
 
     FMXBLLELPDAO    E           K DISK
     F                                     RENAME(MXBLLELP0: MXBLLELPA)
      * Balances - xxxx ADJUSTMNT (OVRDBF TO xxxx)
 
     FMXMELELPDAO    E           K DISK
     F                                     RENAME(MXDELELP0: MXMELELPA)
      * Monthly Events - xxxx ADJUSTMENT (OVRDBF TO xxxx)
 
     FQSYSPRT   O    F  132        PRINTER
      * Audit Report
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
 
     IMXBLLELP0     01
     I                                          LNNO          L1M1
     IMXDELELP0     02
     I                                          LNNO          L1M1
 
     C   L1              SETOFF                                       1112
 
     C   01              SETON                                        11
     C   02              SETON                                        12
 
      * Change of loan number
 
     CL1NMR              EXSR      CHGLNNO
 
     C/SPACE 5
      *********************************************************************
      * Change of loan number
      *********************************************************************
     C     CHGLNNO       BEGSR
 
     C     LNNO          CHAIN     MXSLECLP0                          99        *
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     VDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        P_VDAT            7
     C                   Z-ADD     MDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        P_MDAT            7
     C                   Z-ADD     ORED          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        P_ORED            7
     C  N11              EXSR      GEN_BL
     C  N12              EXSR      GEN_ME
     C                   ENDIF
 
     C                   EXCEPT    NOMATCH
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *********************************************************************
      * Generate a balance
      *********************************************************************
     C     GEN_BL        BEGSR
 
     C**********         Z-ADD     LNNO          LNNO                                         CLE148
     C                   MOVEL     LNNO          LNNO                                         CLE148
     C                   Z-ADD     CURSOM        DATE
     C                   Z-ADD     *ZERO         BAL
     C                   MOVEL     CCY           CCY
     C                   Z-SUB     1             CNTM
     C                   WRITE     MXBLLELPA
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *********************************************************************
      * Generate a monthly event
      *********************************************************************
     C     GEN_ME        BEGSR
 
     C                   MOVEL     '01'          DECATC
     C                   MOVEL     'SOM '        DESNM1
     C                   MOVEL     *BLANK        DESNM2
     C                   Z-ADD     CURSOM        EDAT
     C                   Z-ADD     *ZERO         EAMT
     C                   MOVEL     CCY           ECCY
     C                   Z-ADD     0             ECDP
     C                   Z-ADD     *ZERO         BCEQ
     C                   MOVEL     BJCYCD        BCCY
     C                   Z-ADD     0             BCDP
     C                   Z-ADD     *ZERO         REVI
     C**********         Z-ADD     LNNO          LNNO                                         CLE148
     C                   MOVEL     LNNO          LNNO                                         CLE148
     C                   Z-ADD     *ZERO         FEFSEQ
     C                   MOVEL     BRCA          BRCA
     C                   Z-ADD     *ZERO         EAEVTC
     C                   Z-ADD     BJRDNB        EAEVGD
     C                   Z-SUB     1             EAEVID
     C                   Z-ADD     *ZERO         EADAC1
     C                   Z-ADD     *ZERO         EADAC2
     C                   Z-ADD     *ZERO         EADAC3
     C                   Z-ADD     *ZERO         EACAC1
     C                   Z-ADD     *ZERO         EACAC2
     C                   Z-ADD     *ZERO         EACAC3
     C                   WRITE     MXMELELPA
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      *********************************************************************
      * Convert day number to date
      *********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * INPUTS
     C                   PARM                    I#DTAG            4
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           30
 
 
      **  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
 
      * Get extract control data
 
     C     *DTAARA       DEFINE                  MXEXPCTL
     C     *LOCK         IN        MXEXPCTL
     C                   OUT       MXEXPCTL
 
     C                   EXCEPT    TITLE
 
      * Terminate if current end of month date
      * is not prior to next working day
 
     C     CUREOM        IFGE      BJDNWD
     C                   SETON                                        LR
     C                   EXCEPT    NORUN
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   RETURN
     C                   ENDSR
      ********************************************************************
     OQSYSPRT   E            TITLE           001
     O                                           14 'REF. MXMATEBDC'
     O                                           50 'MATCH FOR CLOANCL:'
     O                       I#DTAG              55
     O                                          102 'DATE:'
     O                       BJMRDT             110
     O          E            NORUN      01
     O                                           48 '* NOT RUN *'
     O          E            NOMATCH    01
     O                       LNNO                 6
     O                                           20 ' MISSING FROM '
     O              N11                          26 ' BLLEL'
     O              N12                          26 ' MELEL'
     O               99                          40 ' * NO HISTORY *'
     O              N99      CPAM                42 '           0 -'
     O              N99      RECI                44
     O              N99      P_VDAT              52
     O              N99      P_MDAT              60
     O              N99      P_ORED              68
