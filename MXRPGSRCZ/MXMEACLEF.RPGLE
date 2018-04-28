     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Monthly Evts Acc. - LENDING facilities')      *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXMEACLEF - Monthly Events Accumulation - LENDING facilities *
      *                                                               *
      *  Function:  This module accumulates today's daily events      *
      *             into the monthly events file.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Date 01Jan00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXDELEFL1 IF   E           K DISK    INFSR(*PSSR)  USROPN
      * Daily Events - Lending facilities
 
     FMXMELEFL0 UF A E           K DISK    RENAME(MXDELEFP0: MXMELEFP0)
     F                                     INFSR(*PSSR)
      * Monthly Events - Lending facilities
 
     FMXDGDTPD  IF   E           K DISK    INFSR(*PSSR)
     FMXDGECPD  IF   E           K DISK    INFSR(*PSSR)
 
     FMXMEACAU  O    E             PRINTER INFSR(*PSSR)  USROPN
      * Monthly Events Accumulation Audit Report
 
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
     D AC              S              1    DIM(99)
 
 
      ** External DS for BANK details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    I#DTAG            4
 
      * Read each event on the daily events file
 
     C                   OPEN      MXDELEFL1
     C                   READ      MXDELEFP0                              99    *
 
      * Whilst daily events can be found
 
     C     *IN99         DOWEQ     '0'
 
      * Update the monthly events file
 
     C                   EXSR      UPD_ME
 
      * Read the next daily event
 
     C                   READ      MXDELEFP0                              99    *
     C                   ENDDO
 
      * Output audit report totals
 
     C                   WRITE     TOTALS
 
     C                   SETON                                        LR
     C                   RETURN
 
      ********************************************************************
     C/SPACE 5
      *********************************************************************
      * Update the monthly events file
      *********************************************************************
     C     UPD_ME        BEGSR
 
      * Increment count of input events
 
     C                   ADD       1             IEvt_cnt
 
      * Look up category code
 
     C                   Z-ADD     1             @X                3 0
     C     DECATC        LOOKUP    CC(@X)                                 99    *
 
      * If category code is not found it is an error
 
     C     *in99         IFEQ      '0'
     C                   EVAL      I#ERMS = 'NO CATEGORY CODE FOR ' + I#DTAG
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Do addition or totalling
 
     C                   MOVEL     AC(@X)        DEACUM
     C     DEACUM        IFEQ      'A'
     C                   WRITE     MXMELEFP0
     C                   ADD       1             WEvt_cnt
     C                   ELSE
     C                   Z-ADD     EAMT          CHG_EAMT         13 0
     C                   Z-ADD     BCEQ          CHG_BCEQ         13 0
     C     MEKY          CHAIN     MXMELEFP0                          99        *
     C     *in99         ifeq      '1'
     C                   WRITE     MXMELEFP0
     C                   ADD       1             WEvt_cnt
     C                   else
     C                   ADD       CHG_EAMT      EAMT
     C                   ADD       CHG_BCEQ      BCEQ
     C                   UPDATE    MXMELEFP0
     C                   ADD       1             UEvt_cnt
     C                   endif
     C                   ENDIF
 
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
 
     C                   Z-ADD     0             @X                3 0
     C     I#DTAG        SETLL     MXDGECP0
     C     I#DTAG        READE     MXDGECP0                               99    *
     C     *in99         DOWEQ     '0'
     C                   ADD       1             @X
     C                   MOVEL     DECATC        CC(@X)
     C                   MOVEL     DEACUM        AC(@X)
     C     I#DTAG        READE     MXDGECP0                               99    *
     C                   ENDDO
 
 
 
      * Set the report description
 
     C                   MOVEL     DGDESC        ZZDESC
 
 
      * Open the printer file
 
     C                   OPEN      MXMEACAU
 
      * Initialize time
 
     C                   TIME                    #TIME
 
      * Output audit report page headings
 
     C                   Z-ADD     *ZERO         CHLINE            3 0
     C                   Z-ADD     99            LINENO
     C                   EXSR      PAG
 
      * Zeroize counts of events
 
     C                   Z-ADD     *ZERO         IEvt_cnt          6 0
     C                   Z-ADD     *ZERO         WEvt_cnt          6 0
     C                   Z-ADD     *ZERO         UEvt_cnt          6 0
 
      * Key lists
 
     C     MEKY          KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    FACT
     C                   KFLD                    FCNO
     C                   KFLD                    FEFSEQ
     C                   KFLD                    ECCY
     C                   KFLD                    REVI
     C                   KFLD                    DECATC
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
