     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Extract General Ledger Statement Details')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXEXTGLSD - Extract General Ledger Statement Details         *
      *                                                               *
      *  Function:  This module extracts general ledger statements    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *                                                               *
      *****************************************************************
 
     FSTMTAH    IF   E             DISK    INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(ACCNTABF)
     FMXGLSDPD  O    E             DISK    INFSR(*PSSR)
 
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
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D GLSDX         E DS                  EXTNAME(MXGLSDPD)
 
     D P_ACOD          S             10S 0                                                    CGL029
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#MODE            1
 
     C     I#MODE        IFEQ      'R'
     C                   EXSR      REQUEST
     C                   ELSE
     C                   EXSR      DUETODAY
     C                   ENDIF
 
     C                   SETON                                        LR
     C                   RETURN
 
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     REQUEST       BEGSR
 
      * Request statements as at today
 
     C                   READ      ACCNTABF                               99    *
 
     C     *in99         DOWEQ     '0'
 
     C     RECI          IFEQ      'D'
     C                   Z-ADD     CFSB          P_CFSB
     C                   Z-ADD     LSTD          P_LSTD
     C                   Z-ADD     BJRDNB        P_NSTD
 
     C                   EXSR      EXT_LINES
     C                   EXSR      EXT_DETAIL
     C                   ENDIF
 
     C                   READ      ACCNTABF                               99    *
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     DUETODAY      BEGSR
 
      * Get today's statements
 
     C                   READ      STMTAHF                                99    *
 
     C     *in99         DOWEQ     '0'
 
     C                   Z-ADD     CFSB          P_CFSB
     C                   Z-ADD     LSTD          P_LSTD
     C                   Z-ADD     NSTD          P_NSTD
 
     C                   EXSR      EXT_LINES
     C                   EXSR      EXT_DETAIL
 
     C                   READ      STMTAHF                                99    *
     C                   ENDDO
 
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     EXT_LINES     BEGSR
 
     C                   CALLB     'MXEXTGLSL'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
 
     C                   PARM      BRCA          P_BRCA            3
     C**********         PARM      CNUM          P_CNUM            6 0                        CSD027
     C                   PARM      CNUM          P_CNUM            6                          CSD027
     C                   PARM      CCY           P_CCY             3
     C**********         PARM      ACOD          P_ACOD            4 0                        CGL029
     C                   PARM      ACOD          P_ACOD                                       CGL029
     C                   PARM      ACSQ          P_ACSQ            2 0
 
     C                   PARM                    P_CFSB           15 0
     C                   PARM                    P_LSTD            5 0
     C                   PARM                    P_NSTD            5 0
 
     C                   PARM      *ZERO         P_SEQN            5 0
 
      * Error
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO MXEXTGLSL'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     EXT_DETAIL    BEGSR
 
     C                   Z-ADD     P_LSTD        PSTMDT
     C                   Z-ADD     P_NSTD        LSTMDT
 
     C                   Z-SUB     199           S_SEQN            5 0
     C                   Z-ADD     *ZERO         E_SEQN            5 0
     C     E_SEQN        DOWLT     P_SEQN
     C                   ADD       200           S_SEQN
     C                   ADD       200           E_SEQN
     C     E_SEQN        IFGT      P_SEQN
     C                   Z-ADD     P_SEQN        E_SEQN
     C                   ENDIF
     C                   MOVE      S_SEQN        SEQN
     C                   WRITE     MXGLSDP0
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
     C     *INZSR        BEGSR
 
 
      ** GET BANK DETAILS
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
