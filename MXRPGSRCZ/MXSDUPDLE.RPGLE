     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Saved data update - lending module')          *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXSDUPDLE - Saved Data Update - LENDING Module               *
      *                                                               *
      *  Function:  This module updates the lending saved data files. *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. AR1097467          Date 01Apr13               *
      *  Prev Amend No. AR1056323          Date 14Nov12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE042             Date 06Sep05               *
      *                 CSD027             Date 09Dec05               *
      *                 CAS009             Date 16May05               *
      *                 CAP074             Date 08Aug02               *
      *                 CAS005             Date 16Dec02               *
      *                 CGL020             Date 12Dec02               *
      *                 CLE028             Date 27Jun02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1097467 - Expected 15% COB run optimization not met        *
      *  AR1056323 - Revert back changes of CLE134 for LKEY1DP and    *
      *              LKEYFED (Recompile)                              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *           (Recompile)                                         *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
      *           Information (Recompile)                             *
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *           (Recompile)                                         *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *           (RE-COMPILE OVER CHANGED /COPY)                     *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     F***CLOANCL   IP   E             DISK    INFSR(*PSSR) PREFIX(L_)                      AR1097467
     F***CLOANCK   IS   E             DISK    INFSR(*PSSR) PREFIX(K_)                      AR1097467
     FCLOANCL   IF   E             DISK    INFSR(*PSSR) PREFIX(L_)                         AR1097467
     FCLOANCK   IF   E             DISK    INFSR(*PSSR) PREFIX(K_)                         AR1097467
     FMXSLECLPD UF A E           K DISK    RENAME(CLOANCLF:MXSLECLP0)
     F                                     INFSR(*PSSR) PREFIX(PL_)
     FMXSLECKPD UF A E           K DISK    RENAME(CLOANCKF:MXSLECKP0)
     F                                     INFSR(*PSSR) PREFIX(PK_)
     FMXAKLNPD  O    E             DISK    INFSR(*PSSR)
 
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
 
      ** Entry Parameter                                                                   AR1097467
                                                                                           AR1097467
     D I#FILE          S             10A                                                   AR1097467
 
      * CLOANCL
     D LECL          E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(L_)
     D P_LECL        E DS                  EXTNAME(MXSLECLPD)
     D                                     PREFIX(PL_)
      * CLOANCK
     D LECK          E DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(K_)
     D P_LECK        E DS                  EXTNAME(MXSLECKPD)
     D                                     PREFIX(PK_)
 
 
     D                 DS
     D*AKEY********************1*****10                                                       CLE042
     D AKEY                    1     14                                                       CLE042
     D AK_LTYP                 1      2
     D AK_SUTP                 4      5
     D AK_AMTC                 9     10
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
 
 
     I***CLOANCLF      01                                                                  AR1097467
     I***CLOANCKF      02                                                                  AR1097467
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUT
      * Start of Month (Y/N)
     C                   PARM                    S_O_Month         1
     C                   PARM                    I#FILE                                    AR1097467
 
     C                   MOVEL     *BLANK        AKEY
 
      * If a loan from CLOANCL
 
     C******in01         IFEQ      '1'                                                     AR1097467
     C                   IF        I#FILE = 'CLOANCL'                                      AR1097467
     C     1             SETLL     CLOANCL                                                 AR1097467
     C                   READ      CLOANCL                                                 AR1097467
     C                   DOW       NOT %EOF(CLOANCL)                                       AR1097467
     C     L_RECI        IFEQ      'D'
     C     L_RECI        OREQ      'R'
     C                   MOVEL     L_BRCA        I#BRCA
     C                   MOVEL     L_LTYP        I#LTYP
     C                   MOVEL     L_SUTP        I#SUTP
     C                   EXSR      FILTER
 
      * If loan is for export
      * Update Saved CLOANCL details
      * Write Start of Month 'Dummy' A/C Key For CLOANCL
 
     C     Exp_BRCA      IFEQ      'Y'
     C     Exp_LTST      ANDEQ     'Y'
     C                   EXSR      UPD_CL
     C     S_O_Month     IFEQ      'Y'
     C                   EXSR      WRTSOM_CL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
                                                                                           AR1097467
     C                   READ      CLOANCL                                                 AR1097467
     C                   ENDDO                                                             AR1097467
     C                   ENDIF
 
      * If a loan from CLOANCK
      * Update Saved CLOANCK details
 
     C******in02         IFEQ      '1'                                                     AR1097467
     C                   IF        I#FILE = 'CLOANCK'                                      AR1097467
     C     1             SETLL     CLOANCK                                                 AR1097467
     C                   READ      CLOANCK                                                 AR1097467
     C                   DOW       NOT %EOF(CLOANCK)                                       AR1097467
     C     K_RECI        IFEQ      'D'
     C     K_RECI        OREQ      'R'
     C                   EXSR      UPD_CK
     C                   ENDIF
                                                                                           AR1097467
     C                   READ      CLOANCK                                                 AR1097467
     C                   ENDDO                                                             AR1097467
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON                                             AR1097467
     C                   RETURN                                                            AR1097467
      *
      /SPACE 5
      ********************************************************************
      * Filter Loans
      ********************************************************************
     C     FILTER        BEGSR
 
      * On change of branch
      * Determine if branch is to be included in the export
 
     C     I#BRCA        IFNE      Prev_BRCA
     C                   MOVE      'D'           I#LD
     C                   EXSR      BRCA_FLT
     C                   MOVEL     I#BRCA        Prev_BRCA         3
     C                   ENDIF
 
      * On change of loan type/sub type
      * Determine if loan type/sub type is to be included in the export
 
     C     I#LTYP        IFNE      Prev_LTYP
     C     I#SUTP        ORNE      Prev_SUTP
     C                   MOVE      'D'           I#LD
     C                   EXSR      LTST_FLT
     C                   MOVEL     I#LTYP        Prev_LTYP         2
     C                   MOVEL     I#SUTP        Prev_SUTP         2
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Update Saved CLOANCL details
      ********************************************************************
     C     UPD_CL        BEGSR
 
     C     L_LNRF        CHAIN     MXSLECLP0                          99        *
     C                   EVAL      P_LECL = LECL
     C                   EVAL      PL_LCD = CURSOM
     C**********         EVAL      PL_RECE = 0                                                CSD027
     C                   EVAL      PL_RECE = *BLANKS                                          CSD027
     C                   EVAL      PL_OMDT = 0
     C                   EVAL      PL_NIPD = 0
     C                   EVAL      PL_NMDT = 0
     C                   EVAL      PL_FCRA = 0
     C                   EVAL      PL_GDPR = 0
     C                   EVAL      PL_GDIN = 0
     C**********         EVAL      PL_TOLN = 0                                                CLE148
     C                   EVAL      PL_TOLN = *BLANK                                           CLE148
     C**********         EVAL      PL_PTFC = 0                                                CSD027
     C                   EVAL      PL_PTFC = *BLANKS                                          CSD027
     C                   EVAL      PL_PTFT = 0
     C                   EVAL      PL_PTFN = 0
     C                   EVAL      PL_LRLD = 0
     C                   EVAL      PL_LMCD = 0
     C     *IN99         IFEQ      '1'
     C                   WRITE     MXSLECLP0
     C                   ELSE
     C                   UPDATE    MXSLECLP0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Update Saved CLOANCK details
      ********************************************************************
     C     UPD_CK        BEGSR
 
     C     K_LNRF        CHAIN     MXSLECKP0                          99        *
     C                   EVAL      P_LECK = LECK
     C                   EVAL      PK_LCD = CURSOM
     C                   EVAL      PK_NPRAM = 0
     C                   EVAL      PK_NDAM  = 0
     C                   EVAL      PK_RRST = 0
     C**********         EVAL      PK_RROB = 0                                                CSD027
     C**********         EVAL      PK_RROC = 0                                                CSD027
     C                   EVAL      PK_RROB = *BLANKS                                          CSD027
     C                   EVAL      PK_RROC = *BLANKS                                          CSD027
     C                   EVAL      PK_NCPA = 0
     C                   EVAL      PK_NFCE = 0
     C                   EVAL      PK_NLRA = 0
     C                   EVAL      PK_RPST = 0
     C**********         EVAL      PK_RPOB = 0                                                CSD027
     C**********         EVAL      PK_RPOC = 0                                                CSD027
     C                   EVAL      PK_RPOB = *BLANKS                                          CSD027
     C                   EVAL      PK_RPOC = *BLANKS                                          CSD027
     C                   EVAL      PK_NBCE = 0
     C                   EVAL      PK_RPSM = 0
     C     *IN99         IFEQ      '1'
     C                   WRITE     MXSLECKP0
     C                   ELSE
     C                   UPDATE    MXSLECKP0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Write Start of Month 'Dummy' A/C Key For CLOANCL
      ********************************************************************
     C     WRTSOM_CL     BEGSR
 
     C     L_ORED        IFLT      CURSOM
     C     L_VDAT        ANDLT     CURSOM
 
     C                   MOVEL     L_LTYP        AK_LTYP
     C                   MOVEL     L_SUTP        AK_SUTP
     C**********         Z-ADD     L_LNRF        LNNO                                         CLE148
     C                   MOVEL     L_LNRF        LNNO                                         CLE148
     C                   MOVEL     L_BRCA        BRCA
     C                   Z-ADD     CURSOM        EDAT
      * Principal
     C                   MOVE      ' A'          AK_AMTC
     C                   Z-ADD     L_CPAM        EAMT
      *                                                                                       CLE028
      ** If flat rate personal loan, add charge amount to event amount if                     CLE028
      ** add on charges is 'Y'.  Also, if add on interest flag is 'Y', Add                    CLE028
      ** interest amount to event amount                                                      CLE028
      *                                                                                       CLE028
     C     L_PTYP        IFEQ      80                                                         CLE028
     C     L_ADCF        IFEQ      'Y'                                                        CLE028
     C                   ADD       L_CHGA        EAMT                                         CLE028
     c                   ENDIF                                                                CLE028
     C     L_ADIF        IFEQ      'Y'                                                        CLE028
     C                   ADD       L_FLTI        EAMT                                         CLE028
     c                   ENDIF                                                                CLE028
     C                   ENDIF                                                                CLE028
      *                                                                                       CLE028
     C     L_PTYP        IFEQ      63
     C     L_PTYP        OREQ      65
     C                   SUB       L_TOTI        EAMT
     C                   ENDIF
     C                   MOVEL     L_CCY         ECCY
     C                   WRITE     LKEY1DPF
 
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
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
 
     C     SDFQLE        IFEQ      'N'
     C     SDFQLE        OREQ      'M'
     C     S_O_Month     ANDNE     'Y'
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
      * Load branches for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      BRCA_FLT
 
      * Load loan type/sub types for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      LTST_FLT
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * B R A N C H   F I L T E R
      /COPY MXCPYSRC,MXFLTBRCA
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * L O A N  T Y P E  / S U B   T Y P E   F I L T E R
      /COPY MXCPYSRC,MXFLTLTST
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
