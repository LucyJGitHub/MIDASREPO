     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access A/C Codes')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSACOD - Access Account Codes                             *
      *                                                               *
      *  Function:  This module accesses account codes.               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                          *CREATE   Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FSDACODL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Maximum number of account codes
     D MaxNoAcds       C                   CONST(1000)
 
      * A/C Codes
     D***#_ACOD*         S              4    DIM(MaxNoAcds)                                   CGL029
     D #_ACOD          S             10    DIM(MaxNoAcds)                                     CGL029
      * A/C Code Details
     D***#_ACODDT        S            300    DIM(MaxNoAcds)                                   CGL029
     D #_ACODDT        S            400    DIM(MaxNoAcds)                                     CGL029
 
      * A/C Code Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        A5ACCD
 
      * If no a/c code is supplied
      * pass back a blank format
 
     C     A5ACCD        IFEQ      *BLANK
     C*****A5ACCD        OREQ      '0000'                                                     CGL029
     C     A5ACCD        OREQ      '0000000000'                                               CGL029
     C                   CLEAR                   SDACOD
     C                   ELSE
 
 
      * If the a/c code was previously accessed,
      * use that a/c code's details
 
     C                   Z-ADD     1             @IX               6 0
     C     A5ACCD        LOOKUP    #_ACOD(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_ACODDT(@IX) SDACOD
     C                   ELSE
 
      * Access the a/c code
 
     C     A5ACCD        CHAIN     @A5REA6                            99        *
 
      * Error if the a/c code was not found
 
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'INVALID ACCOUNT CODE:' + A5ACCD
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Save the a/c code's details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_ACOD(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     A5ACCD        #_ACOD(@IX)
     C                   MOVEL     SDACOD        #_ACODDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     A5ACCD        #_ACOD(@CIX)
     C                   MOVEL     SDACOD        #_ACODDT(@CIX)
     C     @CIX          IFEQ      MaxNoAcds
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = SDACOD
 
 
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
