     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Generated Entries Extract - LENDING loans')   *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXGEEXLEL - Generated Entries Extract - LENDING loans        *
      *                                                               *
      *  Function:  This module generates accounting entries          *
      *             for lending loan events.                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 241970             Data 05Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL020             Date 12Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  241970 - Recompiled due to change in MXACSPRME.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
      *           Information (Recompile)                             *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXDELELL1 IP   E           K DISK    INFSR(*PSSR)
      * Daily Events - Lending loans
 
     FMXGEEVPD  O    E           K DISK    INFSR(*PSSR)
      * Generated Entries For Events
 
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
 
 
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** External DS for ACCOUNT CODE details
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
 
      * Process all 3 DEBIT account codes
 
     C                   MOVEL     'D'           Deb_Crd           1
     C     EADAC1        IFNE      *ZERO
     C                   MOVEL     EADAC1        I#LFD1
     C                   EXSR      PRO_ACOD
     C                   ENDIF
     C     EADAC2        IFNE      *ZERO
     C                   MOVEL     EADAC2        I#LFD1
     C                   EXSR      PRO_ACOD
     C                   ENDIF
     C     EADAC3        IFNE      *ZERO
     C                   MOVEL     EADAC3        I#LFD1
     C                   EXSR      PRO_ACOD
     C                   ENDIF
 
      * Process all 3 CREDIT account codes
 
     C                   MOVEL     'C'           Deb_Crd
     C     EACAC1        IFNE      *ZERO
     C                   MOVEL     EACAC1        I#LFD1
     C                   EXSR      PRO_ACOD
     C                   ENDIF
     C     EACAC2        IFNE      *ZERO
     C                   MOVEL     EACAC2        I#LFD1
     C                   EXSR      PRO_ACOD
     C                   ENDIF
     C     EACAC3        IFNE      *ZERO
     C                   MOVEL     EACAC3        I#LFD1
     C                   EXSR      PRO_ACOD
     C                   ENDIF
 
     C/SPACE 5
      ********************************************************************
      * Process an Account Code
      ********************************************************************
     C     PRO_ACOD      BEGSR
 
      * Get account code details
 
     C                   CALLB     'MXACSACOD'
     C/COPY MXCPYSRC,MXACSPRME
 
      * Error if the account code was not found
 
     C     ACS_RTCD      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'INVALID ACCOUNT CODE ' + I#LFD1
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SDACOD = InData
 
      * If the account section is income or expense
      * Write a generated entry
 
     C     A5ACSC        IFEQ      'IN'
     C     A5ACSC        OREQ      'EX'
     C                   EXSR      WRT_GE
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * Write a generated entry
      ********************************************************************
     C     WRT_GE        BEGSR
 
      * Set up file fields
 
     C                   MOVEL     BRCA          BRCA
     C                   MOVEL     ECCY          CCY
     C                   MOVEL     A5ACCD        ACOD
     C                   Z-ADD     EAMT          PSTA
     C     Deb_Crd       IFEQ      'D'
     C     REVI          IFEQ      0
     C                   Z-ADD     0             DRCR
     C                   ELSE
     C                   Z-ADD     1             DRCR
     C                   ENDIF
     C                   ELSE
     C     REVI          IFEQ      0
     C                   Z-ADD     1             DRCR
     C                   ELSE
     C                   Z-ADD     0             DRCR
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVE      'Event'       SPOS
 
     C                   MOVEL     LNNO          OTRF
 
     C                   WRITE     APOSTPDF
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
