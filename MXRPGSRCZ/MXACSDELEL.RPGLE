     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access daily events - lending loans')         *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSDELEL - Access Daily Events - LENDING loans             *
      *                                                               *
      *  Function:  This module accesses daily events from MXDELELPD  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CLE139             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE042             Date 06Sep05               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 204452             Date 03May02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX005             Date 15Jan01               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  204452 - Recompiled due to changed PF/LEFEED.                *
      *  CMX005 - Meridian Export Enhancements - Phase 4              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXDELELL1 IF   E           K DISK    INFSR(*PSSR)
      * Daily Events - LENDING loans
 
     FLEFEEDL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(F_)
 
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
 
 
      * Daily Events - LENDING loans
     D DELEL         E DS                  EXTNAME(MXDELELPD)
 
      * Fee Details - Loans
     D FEEL          E DS                  EXTNAME(LEFEED)
     D                                     PREFIX(F_)
 
     D P_LNNO          S              6A                                                      CLE148
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_LNNO            6
     C                   MOVEL     I#LFD2        A_CNUM            6
 
      * Error if no loan number is supplied
 
     C     A_LNNO        IFEQ      *BLANK
     C*****A_LNNO        OREQ      '000000'                                                   CLE148
     C                   EVAL      I#ERMS = 'BLANK LOAN NUMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no customer number is supplied
 
     C     A_CNUM        IFEQ      *BLANK
     C     A_CNUM        OREQ      '000000'
     C                   EVAL      I#ERMS = 'BLANK CUSTOMER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If a new loan number, re-position the file pointer
 
     C                   MOVEL     A_LNNO        LNNO
     C     LNNO          IFNE      P_LNNO
     C**********         Z-ADD     LNNO          P_LNNO                                       CLE148
     C                   MOVEL     LNNO          P_LNNO                                       CLE148
     C                   CLEAR                   DELEL
     C                   Z-ADD     *ZERO         Num_Events        5 0
     C     P_LNNO        SETLL     MXDELELP0
     C                   ENDIF
 
      * Get a daily event for the loan
 
     C     P_LNNO        READE     MXDELELP0                              99     *
 
      * No more events
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   ELSE
     C                   ADD       1             Num_Events
     C                   Z-ADD     Num_Events    EAEVTC
     C                   MOVEL     A_CNUM        F_FECNUM
     C                   Z-ADD     *ZERO         F_FEFACL
     C     LEFEEK        CHAIN     LEFEEDF                            98         *
     C  N98              Z-ADD     F_FEPEND      EAEVGD
     C   98              Z-ADD     *ZERO         EAEVGD
     C                   ENDIF
 
 
      * Set up output data
 
     C                   EVAL      InData = DELEL
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C**********         Z-ADD     *ZERO         P_LNNO            6 0                        CLE148
     C                   MOVE      *BLANKS       P_LNNO                                       CLE148
      * Key lists
 
     C     LEFEEK        KLIST
     C                   KFLD                    F_FECNUM
     C                   KFLD                    F_FEFACL
     C                   KFLD                    P_LNNO
     C                   KFLD                    FEFSEQ
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
