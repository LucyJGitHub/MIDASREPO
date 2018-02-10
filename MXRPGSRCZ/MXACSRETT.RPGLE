     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access retail transaction types')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSRETT - Access Retail Transaction Types                  *
      *                                                               *
      *  Function:  This module accesses retail transaction           *
      *             types from file SDRETRPD                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL154             Date 13Oct14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX003  *CREATE    Date 05Nov00               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *                                                               *
      *****************************************************************
 
     FSDRETRL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Maximum number of transaction types
     D MaxNoTrts       C                   CONST(1000)
 
      * Transaction Types
     D #_TRTY          S              5    DIM(MaxNoTrts)
      * Transaction Type Details
     D #_TRTYDT        S            200    DIM(MaxNoTrts)
 
      * Transaction Type Details
     D SDRETR        E DS                  EXTNAME(SDRETRPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        A1RTTY
 
      * If no transaction type is supplied
      * pass back a blank format
 
     C     A1RTTY        IFEQ      *BLANK
     C     A1RTTY        OREQ      '00000'
     C                   CLEAR                   SDRETR
     C                   ELSE
 
 
      * If the transaction type was previously accessed,
      * use that transaction type's details
 
     C                   Z-ADD     1             @IX               6 0
     C     A1RTTY        LOOKUP    #_TRTY(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_TRTYDT(@IX) SDRETR
     C                   ELSE
 
      * Access the transaction type
 
     C     A1RTTY        CHAIN     @A1RECX                            99        *
 
      * Error if the transaction type was not found
 
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'INVALID TRANS TYPE:' + A1RTTY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Save the transaction type's details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_TRTY(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     A1RTTY        #_TRTY(@IX)
     C                   MOVEL     SDRETR        #_TRTYDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     A1RTTY        #_TRTY(@CIX)
     C                   MOVEL     SDRETR        #_TRTYDT(@CIX)
     C     @CIX          IFEQ      MaxNoTrts
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = SDRETR
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   Z-ADD     *ZERO         @CIX              6 0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
