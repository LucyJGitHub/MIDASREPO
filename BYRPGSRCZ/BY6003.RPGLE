     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Monthly Evts Acc. - FUT/OPT. trades')         *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  BY6003    - Monthly Events Accumulation - FUT/OPT. Trades    *
      *                                                               *
      *  Function:  This module accumulates today's daily events      *
      *             into the monthly events file.                     *
      *             Program based on MXMEACSET                        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. LLN021             Data 15Dec03               *
      *                 CMX003  *CREATE    Date 05Nov00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN021 - BoE PL Reporting                                    *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *                                                               *
      *****************************************************************
 
     FMXDEFFTL1 IF   E           K DISK    INFSR(*PSSR)  USROPN
      * Daily Events - Securities trades
 
     FMXMEFFTL0 UF A E           K DISK    RENAME(MXDEFFTP0: MXMEFFTP0)
     F                                     INFSR(*PSSR)
      * Monthly Events - Securities trades
 
     FMXDGDTPD  IF   E           K DISK    INFSR(*PSSR)
     FMXDGECPD  IF   E           K DISK    INFSR(*PSSR)
 
     FBY6003AU  O    E             PRINTER INFSR(*PSSR)  USROPN
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
 
     C                   OPEN      MXDEFFTL1
     C                   READ      MXDEFFTP0                              99    *
 
      * Whilst daily events can be found
 
     C     *IN99         DOWEQ     '0'
 
      * Update the monthly events file
 
     C                   EXSR      UPD_ME
 
      * Read the next daily event
 
     C                   READ      MXDEFFTP0                              99    *
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
     C                   WRITE     MXMEFFTP0
     C                   ADD       1             WEvt_cnt
     C                   ELSE
     C                   Z-ADD     EVAM          CHG_EVAM         13 0
     C                   Z-ADD     BCEQ          CHG_BCEQ         13 0
     C     MEKY          CHAIN     MXMEFFTP0                          99        *
     C     *in99         ifeq      '1'
     C                   WRITE     MXMEFFTP0
     C                   ADD       1             WEvt_cnt
     C                   else
     C                   ADD       CHG_EVAM      EVAM
     C                   ADD       CHG_BCEQ      BCEQ
     C                   UPDATE    MXMEFFTP0
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
 
     C                   OPEN      BY6003AU
 
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
     C                   KFLD                    TRFR
     C                   KFLD                    EVCY
     C                   KFLD                    RVRS
     C                   KFLD                    DECATC
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
