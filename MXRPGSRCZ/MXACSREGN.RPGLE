     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Region Codes')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSREGN - Access Region Codes                              *
      *                                                               *
      *  Function:  This module accesses region codes.                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Date 01Jan00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FSDREGNL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Maximum number of regions
     D MaxNoRgns       C                   CONST(100)
 
      * Regions
     D #_REGN          S              2    DIM(MaxNoRgns)
      * Region Details
     D #_REGNDT        S            100    DIM(MaxNoRgns)
 
      * Region Details
     D SDREGN        E DS                  EXTNAME(SDREGNPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        A3RGCD
 
      * If no region code is supplied
      * pass back a blank format
 
     C     A3RGCD        IFEQ      *BLANK
     C                   CLEAR                   SDREGN
     C                   ELSE
 
 
      * If the region code was previously accessed,
      * use that region's details
 
     C                   Z-ADD     1             @IX               6 0
     C     A3RGCD        LOOKUP    #_REGN(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_REGNDT(@IX) SDREGN
     C                   ELSE
 
      * Access the region
 
     C     A3RGCD        CHAIN     @A3REBX                            99        *
 
      * Error if the region code was not found
 
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'INVALID REGION:' + A3RGCD
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Save the region's details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_REGN(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     A3RGCD        #_REGN(@IX)
     C                   MOVEL     SDREGN        #_REGNDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     A3RGCD        #_REGN(@CIX)
     C                   MOVEL     SDREGN        #_REGNDT(@CIX)
     C     @CIX          IFEQ      MaxNoRgns
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = SDREGN
 
 
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
