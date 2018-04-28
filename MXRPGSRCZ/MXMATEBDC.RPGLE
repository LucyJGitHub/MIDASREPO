     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Reconcile Balances - DEALSDC')                *
/*XBIA*  OVRDBF FILE(MXBLDLPDA) TOFILE(MXBLDLPD) SHARE(*NO)           *
/*XBIB*  OVRDBF FILE(MXMEDLPDA) TOFILE(MXMEDLPD) SHARE(*NO)           *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXMATEBDC - Match Events against Balances - DEALSDC          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 185351  *CREATE    Date 23Oct00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  185351 - Mismatch between events and balances sent to CS4++  *
      *                                                               *
      *****************************************************************
 
     FMXBLDLL0  IP A E           K DISK
      * Balances - DEALSDC (OVRDBF TO LDNI)
 
     FMXMEDLL0  IS A E           K DISK
      * Monthly Events - DEALSDC (OVRDBF TO LDNI)
 
     FMXSDLDCPD IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDCF: MXSDLDCP0)
      * Saved Deals
 
     FMXBLDLPDA O    E           K DISK
     F                                     RENAME(MXBLDLP0: MXBLDLPA)
      * Balances - LDNI ADJUSTMNT (OVRDBF TO LDNI)
 
     FMXMEDLPDA O    E           K DISK
     F                                     RENAME(MXDEDLP0: MXMEDLPA)
      * Monthly Events - LDNI ADJUSTMENT (OVRDBF TO LDNI)
 
     FQSYSPRT   O    F  132        PRINTER
      * Audit Report
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
 
     IMXBLDLP0      01
     I                                          DLNO          L1M1
     IMXDEDLP0      02
     I                                          DLNO          L1M1
 
     C   L1              SETOFF                                       1112
 
     C   01              SETON                                        11
     C   02              SETON                                        12
 
      * Change of deal number
 
     CL1NMR              EXSR      CHGDLNO
 
     C/SPACE 5
      *********************************************************************
      * Change of deal number
      *********************************************************************
     C     CHGDLNO       BEGSR
 
     C     DLNO          CHAIN     MXSDLDCP0                          99        *
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
 
     C                   Z-ADD     DLNO          DLNO
     C                   Z-ADD     CURSOM        DATE
     C                   Z-ADD     *ZERO         BAL
     C                   MOVEL     CCY           CCY
     C                   Z-SUB     1             CNTM
     C                   WRITE     MXBLDLPA
 
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
     C                   Z-ADD     DLNO          DLNO
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
     C                   WRITE     MXMEDLPA
 
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
     O                                           50 'MATCH FOR DEALSDC'
     O                                          102 'DATE:'
     O                       BJMRDT             110
     O          E            NORUN      01
     O                                           48 '* NOT RUN *'
     O          E            NOMATCH    01
     O                       DLNO                 6
     O                                           20 ' MISSING FROM '
     O              N11                          25 ' BLDL'
     O              N12                          25 ' MEDL'
     O               99                          40 ' * NO HISTORY *'
     O              N99      PCPL                42 '             0 -'
     O              N99      RECI                44
     O              N99      P_VDAT              52
     O              N99      P_MDAT              60
     O              N99      P_ORED              68
