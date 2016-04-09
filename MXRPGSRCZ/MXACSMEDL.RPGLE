     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Monthly Events - Dealing Module')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSMEDL - Access Monthly Events - DEALING module           *
      *                                                               *
      *  Function:  This module accesses monthly events from MXMEDLPD *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CMX001  *CREATE    Data 01Jan00               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXMEDLL1  IF   E           K DISK    RENAME(MXDEDLP0: MXMEDLP0)
     F                                     INFSR(*PSSR)
      * Monthly Events - DEALING module
 
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
 
 
      * Monthly Events - DEALING module
     D MEDL          E DS                  EXTNAME(MXMEDLPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        A_DLNO            6
 
      * Error if no deal number is supplied
 
     C     A_DLNO        IFEQ      *BLANK
     C     A_DLNO        OREQ      '000000'
     C                   EVAL      I#ERMS = 'BLANK DEAL NUMBER'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If a new deal number, re-position the file pointer
 
     C                   MOVEL     A_DLNO        DLNO
     C     DLNO          IFNE      P_DLNO
     C                   Z-ADD     DLNO          P_DLNO
     C                   CLEAR                   MEDL
     C                   Z-ADD     *ZERO         Num_Events        5 0
     C     P_DLNO        SETLL     MXMEDLP0
     C                   ENDIF
 
      * Get a monthly event for the deal
 
     C     P_DLNO        READE     MXMEDLP0                               99    *
 
      * No more events
 
     C     *IN99         IFEQ      '1'
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   ELSE
     C                   ADD       1             Num_Events
     C                   Z-ADD     Num_Events    EAEVTC
     C                   ENDIF
 
 
      * Set up output data
 
     C                   EVAL      InData = MEDL
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   Z-ADD     *ZERO         P_DLNO            6 0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
