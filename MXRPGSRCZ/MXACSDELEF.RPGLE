     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access daily events - lending facils')        *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSDELEF - Access Daily Events - LENDING facilities        *
      *                                                               *
      *  Function:  This module accesses daily events from MXDELEFPD  *
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
 
     FMXDELEFL1 IF   E           K DISK    INFSR(*PSSR)
      * Daily Events - LENDING facilities
 
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
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
 
 
      * Daily Events - LENDING facilities
     D DELEF         E DS                  EXTNAME(MXDELEFPD)
 
      * Fee Details - Facilities
     D FEEF          E DS                  EXTNAME(LEFEED)
     D                                     PREFIX(F_)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_CNUM            6
     C                   MOVEL     I#LFD2        A_FACT            3
     C                   MOVEL     I#LFD3        A_FCNO            2
 
      * Error if no customer number is supplied
 
     C     A_CNUM        IFEQ      *BLANK
     C     A_CNUM        OREQ      '000000'
     C                   EVAL      I#ERMS = 'BLANK CUSTOMER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no facility type is supplied
 
     C     A_FACT        IFEQ      *BLANK
     C     A_FACT        OREQ      '000'
     C                   EVAL      I#ERMS = 'BLANK FACILITY TYPE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Error if no facility number is supplied
 
     C     A_FCNO        IFEQ      *BLANK
     C     A_FCNO        OREQ      '00'
     C                   EVAL      I#ERMS = 'BLANK FACILITY NUMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If a new facility ID, re-position the file pointer
 
     C                   MOVEL     A_CNUM        CNUM
     C                   MOVEL     A_FACT        FACT
     C                   MOVEL     A_FCNO        FCNO
     C     CNUM          IFNE      P_CNUM
     C     FACT          ORNE      P_FACT
     C     FCNO          ORNE      P_FCNO
     C**********         Z-ADD     CNUM          P_CNUM                                       CSD027
     C                   EVAL      P_CNUM = CNUM                                              CSD027
     C                   Z-ADD     FACT          P_FACT
     C                   Z-ADD     FCNO          P_FCNO
     C                   CLEAR                   DELEF
     C                   Z-ADD     *ZERO         Num_Events        5 0
     C     FACLKY        SETLL     MXDELEFP0
     C                   ENDIF
 
      * Get a daily event for the facility
 
     C     FACLKY        READE     MXDELEFP0                              99     *
 
      * No more events
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   ELSE
     C                   ADD       1             Num_Events
     C                   Z-ADD     Num_Events    EAEVTC
     C                   Z-ADD     *ZERO         F_FEFACL
     C                   MOVEL     P_FACT        F_FEFACL
     C                   MOVE      P_FCNO        F_FEFACL
     C**********         Z-ADD     *ZERO         F_FELOAN                                     CLE148
     C                   MOVEL     *BLANKS       F_FELOAN                                     CLE148
     C     LEFEEK        CHAIN     LEFEEDF                            98         *
     C  N98              Z-ADD     F_FEPEND      EAEVGD
     C   98              Z-ADD     *ZERO         EAEVGD
     C                   ENDIF
 
 
      * Set up output data
 
     C                   EVAL      InData = DELEF
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C**********         Z-ADD     *ZERO         P_CNUM            6 0                        CSD027
     C                   MOVE      *BLANKS       P_CNUM            6                          CSD027
     C                   Z-ADD     *ZERO         P_FACT            3 0
     C                   Z-ADD     *ZERO         P_FCNO            2 0
      * Key lists
 
     C     FACLKY        KLIST
     C                   KFLD                    P_CNUM
     C                   KFLD                    P_FACT
     C                   KFLD                    P_FCNO
     C     LEFEEK        KLIST
     C                   KFLD                    P_CNUM
     C                   KFLD                    F_FEFACL
     C                   KFLD                    F_FELOAN
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
