     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/***********BASEMOD                                                   *                       260324
/*CRT*******CRTRPGMOD                                                 *              260324 MD034876
/*CRT*******MODULE(**********/**********)                             *              260324 MD034876
/*CRT*******SRCFILE(**********/**********)                            *              260324 MD034876
/*CRT*******SRCMBR(*MODULE) OUTPUT(*PRINT)                            *              260324 MD034876
/*CRT*******INDENT(*NONE) TGTRLS(V5R3M0)                              *              260324 MD034876
/*STD *  RPGBASEMO2                                                   *                     MD034876
/*CRT *  TEXT('Midas MX Generated Entries Reconciliation')            *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXGENTREC - Generated Entries Reconciliation Report          *
      *                                                               *
      *  Function:  This module reconciles generated entries against  *
      *             generated entries produced for events.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD034876           Date 23Jul15               *
      *  Prev Amend No. LLN022             Date 03Jun15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260324             Date 27May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD034876 - BOE Upgrade to FBM2.1 Compatibility Amendments    *
      *           - Created new standard parameter RPGBASEMO2 to cater*
      *             to fix 260324                                     *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  260324 - Recompile with FIXNBR(*NONE) to prevent endless     *
      *           joblogs ni MXC0500. Internalised Create Parameters. *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXGERCPD  IP A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF: MXGERCP0)
      * Generated Entries For Reconciliation
 
     FMXGEEVPD  IS A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF: MXGEEVP0)
      * Generated Entries For Events
 
     FMXGENTRP1 O    E             PRINTER INFSR(*PSSR)
      * Generated Entry Reconciliation Report
 
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
 
 
     D                 DS
     D drPSTA0                 1     15S 0
     D drPSTA1                 1     15S 0
     D drPSTA2                 1     15S 0
     D drPSTA3                 1     15S 0
     D                 DS
     D crPSTA0                 1     15S 0
     D crPSTA1                 1     15S 0
     D crPSTA2                 1     15S 0
     D crPSTA3                 1     15S 0
 
     D                 DS
     D drPSGE0                 1     15S 0
     D drPSGE1                 1     15S 0
     D drPSGE2                 1     15S 0
     D drPSGE3                 1     15S 0
     D                 DS
     D crPSGE0                 1     15S 0
     D crPSGE1                 1     15S 0
     D crPSGE2                 1     15S 0
     D crPSGE3                 1     15S 0
     D                 DS
     D drPSEV0                 1     15S 0
     D drPSEV1                 1     15S 0
     D drPSEV2                 1     15S 0
     D drPSEV3                 1     15S 0
     D                 DS
     D crPSEV0                 1     15S 0
     D crPSEV1                 1     15S 0
     D crPSEV2                 1     15S 0
     D crPSEV3                 1     15S 0
 
 
     D***#_GE***         S              3    DIM(4)  CTDATA PERRCD(1)                         LLN022
     D***#_GENM*         S             42    DIM(4)  CTDATA PERRCD(1)                         LLN022
     D #_GE            S              3    DIM(5)  CTDATA PERRCD(1)                           LLN022
     D #_GENM          S             42    DIM(5)  CTDATA PERRCD(1)                           LLN022
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for BRANCH details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** External DS for ACCOUNT CODE details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D @ACCD           S             10A                                                      CGL029
 
 
     IMXGERCP0      01
     I                                          BRCA          L3M4
     I                                          CCY           L2M3
     I                                          ACOD          L1M2
     I                                          OTRF            M1
     IMXGEEVP0      02
     I                                          BRCA          L3M4
     I                                          CCY           L2M3
     I                                          ACOD          L1M2
     I                                          OTRF            M1
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
      * Entry Type
     C                   PARM                    I#ENTT            3
 
      * On change of branch, access the branch details
 
     C   L3              EXSR      ACS_BRCA
 
      * On change of currency, access the currency details
 
     C   L2              EXSR      ACS_CCY
 
      * On change of account code, access the acount code details
 
     C   L1              EXSR      ACS_ACOD
 
      * Report a generated entry
 
     C                   EXSR      REP_GENT
 
      * On change of account code, reconcile totals
 
     CL1                 EXSR      REC_TOT
 
      * End of Report
 
     CLR                 EXSR      END_REP
     C/SPACE 5
      ********************************************************************
      * Report a generated entry
      ********************************************************************
     C     REP_GENT      BEGSR
 
      * If the posting amount is negative
      * Switch its sign and reverse the CR/CR indicator
 
     C     PSTA          IFLT      *ZERO
     C                   Z-SUB     PSTA          PSTA
     C     DRCR          IFEQ      0
     C                   Z-ADD     1             DRCR
     C                   ELSE
     C                   Z-ADD     0             DRCR
     C                   ENDIF
     C                   ENDIF
 
      * Set up the output DR and CR posting amounts
 
     C     DRCR          IFEQ      0
     C                   Z-ADD     PSTA          drPSTA0
     C                   Z-ADD     *ZERO         crPSTA0
     C                   MOVE      '1'           *in55
     C                   ELSE
     C                   Z-ADD     *ZERO         drPSTA0
     C                   Z-ADD     PSTA          crPSTA0
     C                   MOVE      '0'           *in55
     C                   ENDIF
 
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     POSTING
 
      * Update account code totals
 
     C     DRCR          IFEQ      0
     C   01              ADD       PSTA          drPSTA_GE
     C   01              ADD       PSTA          NtPSTA_GE
     C   02              ADD       PSTA          drPSTA_EV
     C   02              ADD       PSTA          NtPSTA_EV
     C                   ELSE
     C   01              ADD       PSTA          crPSTA_GE
     C   01              SUB       PSTA          NtPSTA_GE
     C   02              ADD       PSTA          crPSTA_EV
     C   02              SUB       PSTA          NtPSTA_EV
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * Reconcile totals
      ********************************************************************
     C     REC_TOT       BEGSR
 
      * If a difference is identified
      * Output an error narrative
 
     C     NtPSTA_GE     IFNE      NtPSTA_EV
     C                   MOVEL     '*ERROR '     ERR_NAR           7
     C                   ADD       1             CNT_IMB           5 0
     C                   ELSE
     C                   MOVEL     *BLANK        ERR_NAR
     C                   ENDIF
 
      * Set up the output DR and CR posting amounts
 
     C                   Z-ADD     drPSTA_GE     drPSGE0
     C                   Z-ADD     crPSTA_GE     crPSGE0
     C                   Z-ADD     drPSTA_EV     drPSEV0
     C                   Z-ADD     crPSTA_EV     crPSEV0
 
      * Output account code totals
 
     C                   Z-ADD     2             CHLINE
     C                   EXSR      PAG
     C                   WRITE     ACODTOT
 
      * Zeroize account code totals
 
     C                   Z-ADD     *ZERO         drPSTA_GE        15 0
     C                   Z-ADD     *ZERO         drPSTA_EV        15 0
     C                   Z-ADD     *ZERO         crPSTA_GE        15 0
     C                   Z-ADD     *ZERO         crPSTA_EV        15 0
     C                   Z-ADD     *ZERO         NtPSTA_GE        15 0
     C                   Z-ADD     *ZERO         NtPSTA_EV        15 0
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * End of Report
      ********************************************************************
     C     END_REP       BEGSR
 
      * Output count of imbalances and 'end of report'
 
     C                   Z-ADD     3             CHLINE
     C                   EXSR      PAG
     C                   WRITE     ENDOFREP
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * Access the branch details
      ********************************************************************
     C     ACS_BRCA      BEGSR
 
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BRCA          @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      I#ERMS = 'INVALID BRANCH CODE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * Access the currency details
      ********************************************************************
     C     ACS_CCY       BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      CCY           @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      I#ERMS = 'INVALID CURRENCY CODE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set up decimal places for output
 
     C                   SETOFF                                       53
     C     A6NBDP        COMP      1                                  525051
     C   52A6NBDP        COMP      2                                  53  52
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * Access the acount code details
      ********************************************************************
     C     ACS_ACOD      BEGSR
 
     C                   MOVEL     ACOD          @ACCD
 
     C                   CALL      'AOACODR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C**********         PARM                    @ACCD             4                          CGL029
     C*****SDACOD        PARM      SDACOD        DSFDY                                        CGL029
     C                   PARM                    @ACCD                                        CGL029
     C     SDACOD        PARM      SDACOD        DSSDY                                        CGL029
 
     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      I#ERMS = 'INVALID ACCOUNT CODE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Output account code headings
 
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   WRITE     ACODHEAD
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Throw page headings (if required)
      ********************************************************************
     C     PAG           BEGSR
 
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   WRITE     PAGEHEAD
     C     6             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Get entry description
 
     C                   Z-ADD     1             @X                3 0
     C     I#ENTT        LOOKUP    #_GE(@X)                               99
     C                   MOVEL     #_GENM(@X)    ZZDESC
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** #_GE
DL
LE
SE
IER
** #_GENM
DEALING MODULE
LENDING MODULE
SECURITIES TRADING MODULE
RETAIL INCOME AND EXPENSE
