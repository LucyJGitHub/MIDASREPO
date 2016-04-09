     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*XBIA*: OVRDBF FILE(CLOANX) TOFILE(CLOAN) SHARE(*NO)               : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Projected ext ctlr for customer loans')       *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEPXCLOAN - Projected Extract Controller for Customer        *
      *              Lending Loans                                    *
      *                                                               *
      *  Function:  This module processes all LE Loans and calls the  *
      *             module DEPXTLOAN to write records to the          *
      *             projected extract files.                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 16Sep03               *
      *                 CLE031             Date 16Sep03               *
      *                 CAP074             Date 28Mar02               *
      *                 CDE005             Date 20Aug02               *
      *                 CAS005             Date 16Dec02               *
      *                 CLE028             Date 27Jun02               *
      *                 CAS004             Date 26Jun02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CLE011             Date 07Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (re-compile).                                       *
      *  CLE031 - Lending Enhancements (recompile).                   *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis                 *
      *           (Re-compile)                                        *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *           Recompile                                           *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FCLOANX    IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(CLOANCLF)
     F                                     PREFIX(CL_)
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(CLOANCKF)
     F                                     PREFIX(CK_)
 
     F/COPY WNCPYSRC,DEPXCLOF01
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      * P E R I O D   D E T A I L S
     D/COPY DECPYSRC,DEXCPERDD
 
 
     D LOANCL        E DS                  EXTNAME(CLOANCL) PREFIX(CL_)
     D LOANCK        E DS                  EXTNAME(CLOANCK) PREFIX(CK_)
      *                                                                                       CDE005
     D SCSARD        E DS                  EXTNAME(SCSARDPD) PREFIX(SF_)                      CDE005
      ** External DS for Switchable Features details                                          CDE005
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDE005
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    I#EXTT            4
     C                   PARM                    I#EOB             1
     C**********         PARM                    I#TREF           20                          CGL029
     C                   PARM                    I#TREF           26                          CGL029
     C                   PARM                    I#RSRV           10                          CDE005
     C/COPY WNCPYSRC,DEPXCLOC01
      *
      * EXTRACT ALL LOANS
      * OR EXTRACT A SINGLE LOAN
      *
     C     I#EXTT        IFEQ      '*ALL'
     C                   EXSR      EXTALL
     C                   SETON                                        LR
     C                   ELSE
     C                   EXSR      EXTSIN
     C                   ENDIF
      *
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * EXTRACT ALL LOANS
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      CLOANCLF                               99    *
      *
      * Whilst loans can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      * Extract any live or newly reversed loans
      *
     C     CL_RECI       IFEQ      'D'
     C     CL_RECI       OREQ      'R'
      *
      * Internal Participations Purchased should not affect exposure as this
      * is reported against the Agent loan. Do not extract these, otherwise
      * exposure will be double counted.
      *
     C*****CL_MLNR       IFEQ      0                                                          CLE148
     C     CL_MLNR       IFEQ      *BLANKS                                                    CLE148
     C/COPY WNCPYSRC,DEPXCLOC02
     C                   EXSR      EXTRCT
     C/COPY WNCPYSRC,DEPXCLOC03
     C                   ENDIF
     C                   ENDIF
      *
      * Read the next record
      *
     C                   READ      CLOANCLF                               99    *
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE LOAN
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C**********         MOVEL     I#TREF        W#LNRF            6 0                        CLE148
     C                   MOVEL     I#TREF        W#LNRF            6                          CLE148
     C     W#LNRF        CHAIN     CLOANCLF                           99        *
      *
      * If the loan is found
      * extract it
      *
     C     *IN99         IFEQ      '0'
      *
      * Internal Participations Purchased should not affect exposure as this
      * is reported against the Agent loan. Do not extract these, otherwise
      * exposure will be double counted.
      *
     C*****CL_MLNR       IFEQ      0                                                          CLE148
     C     CL_MLNR       IFEQ      *BLANKS                                                    CLE148
     C/COPY WNCPYSRC,DEPXCLOC04
     C                   EXSR      EXTRCT
     C/COPY WNCPYSRC,DEPXCLOC05
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT
      ********************************************************************
     C     EXTRCT        BEGSR
      *
      * Get further loan details needed from CLOANCK
      *
     C                   CLEAR                   LOANCK
     C     CL_LNRF       CHAIN     CLOANCKF                           99        *
      *
      * Set the action code
      *
     C     CL_RECI       IFEQ      'R'
     C                   MOVEL     'D'           W#ACTN
     C                   ELSE
     C                   MOVEL     'I'           W#ACTN
     C                   ENDIF
      *
     C                   CALLB     'DEPXTLOAN'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM                    W#ACTN            1            * ACTION CODE
     C                   PARM      I#EXTT        W#EXTT            4
     C                   PARM      I#PH          W#PH              1
     C                   PARM      I#EOB         W#EOB             1
     C                   PARM      I#RDNB        W#RDNB            5 0
     C                   PARM      I#DNWD        W#DNWD            5 0
     C                   PARM      I#HCOD        W#HCOD            5 0
     C                   PARM      I#EXTD        W#EXTD            5 0
     C                   PARM      I#EVCD        W#EVCD            5 0
     C                   PARM      I#PCOD        W#PCOD            5 0
     C                   PARM                    PeriodEDT
     C                   PARM                    LOANCL
     C                   PARM                    LOANCK
     C                   PARM                    Dataarea                                     208221
     C                   PARM                    I#RSRV           10                          CDE005
 
      * If data error encountered, log error
 
     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C     CDE005        IFEQ      'Y'                                                        CDE005
     C                   EVAL      BUFFER = I#PH + 'LOAN' + I#EXTT + I#TREF                   CDE005
     C                             + W#RTCD + W#ERMS + LOANCL + I#RSRV                        CDE005
     C                   ELSE                                                                 CDE005
     C                   EVAL      BUFFER = I#PH + 'LOAN' + I#EXTT + I#TREF
     C                             + W#RTCD + W#ERMS + LOANCL
     C                   ENDIF                                                                CDE005
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * This is a projections extract
 
     C                   MOVE      'P'           I#PH
 
      * Get Extract control information
 
      /COPY DECPYSRC,DEXTGTCT
 
      ** Determine if Data Export - Reservation ID is active                                  CDE005
     C                   CALL      'AOSARDR0'                                                 CDE005
     C                   PARM      *BLANKS       @RTCD             7                          CDE005
     C                   PARM      '*VERIFY'     @OPTN             7                          CDE005
     C                   PARM      'CDE005'      @SARD             6                          CDE005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDE005
      *                                                                                       CDE005
     C     @RTCD         IFEQ      *BLANK                                                     CDE005
     C                   MOVEL     'Y'           CDE005            1                          CDE005
     C                   ENDIF                                                                CDE005
      *                                                                                       CDE005
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
