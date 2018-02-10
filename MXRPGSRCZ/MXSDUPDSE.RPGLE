     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Saved data update - securities module')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXSDUPDSE - Saved Data Update - SECURITIES Module            *
      *                                                               *
      *  Function: This module updates the securities saved data files*
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 215959             Date 21Mar16               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE036             Date 22Apr02               *
      *                 CAS006             Date 21Jan03               *
      *                 CGL020             Date 12Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  215959 - Truncation error on event amount in SE2450P3.       *
      *           Recompiled due to changes in PF/SEKEYD.             *
      *         - Applied for MD-37439.                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE036 - Unrealised Profit and Loss Report by Trade          *
      *           (Recompile)                                         *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
      *           Information (Recompile)                             *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *           (ALSO RE-COMPILE OVER CHANGED /COPY)                *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FTRADSD    IP   E             DISK    INFSR(*PSSR) PREFIX(T_)
     FBKPHDD    IS   E             DISK    INFSR(*PSSR) PREFIX(B_)              CMX003
     FMXSSETDPD UF A E           K DISK    RENAME(TRADSDF:MXSSETDP0)
     F                                     INFSR(*PSSR) PREFIX(PT_)
     FMXAKSEPD  O    E             DISK    INFSR(*PSSR)
 
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
 
 
      * TRADSD
     D SETD          E DS                  EXTNAME(TRADSD)
     D                                     PREFIX(T_)
     D P_SETD        E DS                  EXTNAME(MXSSETDPD)
     D                                     PREFIX(PT_)
 
 
     D                 DS
     D ACKY                    1     20
     D AK_TV                   4      4                                         CMX003
     D AK_BK                   7      8                                         CMX003
     D AK_MK                  13     13                                         CMX003
     D AK_AMTC                19     20
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
 
 
     ITRADSDF       01
     IBKPHDDF       02                                                          CMX003
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUT
      * Start of Month (Y/N)
     C                   PARM                    S_O_Month         1
 
     C                   MOVEL     *BLANK        ACKY
 
      * If a trade
 
     C     *in01         IFEQ      '1'
     C     T_RECI        ANDNE     '*'
     C                   MOVEL     T_TDBA        I#BRCA
     C                   EXSR      FILTER
 
      * If trade is for export
      * Update Saved TRADSD details
      * Write Start of Month 'Dummy' A/C Key For TRADSD
 
     C     Exp_BRCA      IFEQ      'Y'
     C                   EXSR      UPD_TD
     C     S_O_Month     IFEQ      'Y'
     C                   EXSR      WRTSOM_TD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
                                                                                CMX003
      * If a book position                                                      CMX003
                                                                                CMX003
     C     *in02         IFEQ      '1'                                          CMX003
     C     B_RECI        ANDNE     'M'                                          CMX003
     C     B_RECI        ANDNE     '*'                                          CMX003
     C                   MOVEL     B_BHBA        I#BRCA                         CMX003
     C                   EXSR      FILTER                                       CMX003
                                                                                CMX003
      * If book position is for export                                          CMX003
      * Write Start of Month 'Dummy' A/C Key For BKPHDD                         CMX003
                                                                                CMX003
     C     Exp_BRCA      IFEQ      'Y'                                          CMX003
     C     S_O_Month     ANDEQ     'Y'                                          CMX003
     C                   EXSR      WRTSOM_BK                                    CMX003
     C                   ENDIF                                                  CMX003
     C                   ENDIF                                                  CMX003
 
      *
      /SPACE 5
      ********************************************************************
      * Filter Trades
      ********************************************************************
     C     FILTER        BEGSR
 
      * On change of branch
      * Determine if branch is to be included in the export
 
     C     I#BRCA        IFNE      Prev_BRCA
     C                   MOVE      'D'           I#LD
     C                   EXSR      BRCA_FLT
     C                   MOVEL     I#BRCA        Prev_BRCA         3
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Update Saved TRADSD details
      ********************************************************************
     C     UPD_TD        BEGSR
 
     C     T_TDRF        CHAIN     MXSSETDP0                          99        *
     C                   EVAL      P_SETD = SETD
     C                   EVAL      PT_LCD = CURSOM
     C     *IN99         IFEQ      '1'
     C                   WRITE     MXSSETDP0
     C                   ELSE
     C                   UPDATE    MXSSETDP0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Write Start of Month 'Dummy' A/C Key For TRADSD
      ********************************************************************
     C     WRTSOM_TD     BEGSR
 
     C     T_TOED        IFLT      CURSOM
 
     C                   MOVEL     T_TDRF        TRFR
     C                   MOVEL     T_TDBA        BRHA
     C                   Z-ADD     CURSOM        EVDT
      * Countervalue in Nominal Currency
     C                   MOVE      ' A'          AK_AMTC
     C                   Z-ADD     T_TCTR        EVAM
     C                   MOVEL     T_TNMC        EVCY
     C                   WRITE     SEKEYDF
      * Countervalue in Settlement Currency
     C                   MOVE      ' A'          AK_AMTC
     C     T_TVSN        ADD       T_TVSP        EVAM
     C                   ADD       T_TOSV        EVAM
     C                   MOVEL     T_SETC        EVCY
     C                   WRITE     SEKEYDF
 
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5                                                                  CMX003
      ********************************************************************      CMX003
      * Write Start of Month 'Dummy' A/C Key For BKPHDD                         CMX003
      ********************************************************************      CMX003
     C     WRTSOM_BK     BEGSR                                                  CMX003
                                                                                CMX003
     C                   MOVEL     B_BHBA        BRHA                           CMX003
     C                   MOVEL     B_BHSC        SESH                           CMX003
     C                   MOVEL     B_BHBK        AK_BK                          CMX003
     C                   MOVEL     B_BHMK        AK_MK                          CMX003
     C                   MOVEL     B_BHTV        AK_TV                          CMX003
     C                   Z-ADD     CURSOM        EVDT                           CMX003
                                                                                CMX003
     C                   MOVE      ' A'          AK_AMTC                        CMX003
     C                   Z-ADD     *ZERO         EVAM                           CMX003
     C                   MOVEL     B_NCRY        EVCY                           CMX003
     C                   WRITE     SEKEYDF                                      CMX003
                                                                                CMX003
     C                   ENDSR                                                  CMX003
     C********************************************************************      CMX003
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Set up constants
 
     C                   MOVEL     'A'           I#EXTT            1
 
 
      **  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
 
      * Get extract control data
 
     C     *DTAARA       DEFINE                  MXEXPCTL
     C     *LOCK         IN        MXEXPCTL
     C                   OUT       MXEXPCTL
 
 
      * If no save data is required then end
      * (If frequency is 'NEVER'  or
      *  if frequency is 'MONTHLY' but it is not the start of the month)
 
     C     SDFQSE        IFEQ      'N'
     C     SDFQSE        OREQ      'M'
     C     S_O_Month     ANDNE     'Y'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
 
      * Load branches for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      BRCA_FLT
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * B R A N C H   F I L T E R
      /COPY MXCPYSRC,MXFLTBRCA
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
