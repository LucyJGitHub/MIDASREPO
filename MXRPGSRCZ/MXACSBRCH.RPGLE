     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Branches')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSBRCH - Access Branches.                                 *
      *                                                               *
      *  Function:  This module accesses branches.                    *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD055146           Date 04Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE040   *CREATE   Date 04Feb03               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055146 - Failed MXC004802 seq. 00001 and others            *
      *             Increase Branches to 900.                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
 
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Maximum number of branch codes
     D***MaxNoBrch       C                   CONST(100)                                     MD055146
     D MaxNoBrch       C                   CONST(999)                                       MD055146
 
      * Branch
     D #_BRCD          S              3    DIM(MaxNoBrch)
      * Branch Details
     D #_BRCDDT        S            500    DIM(MaxNoBrch)
 
      * Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        A8BRCD
 
      * If no branch code is supplied
      * pass back a blank format
 
     C     A8BRCD        IFEQ      *BLANK
     C                   CLEAR                   SDBRCH
     C                   ELSE
 
 
      * If the branch code was previously accessed,
      * use that branch's details
 
     C                   Z-ADD     1             @IX               6 0
     C     A8BRCD        LOOKUP    #_BRCD(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_BRCDDT(@IX) SDBRCH
     C                   ELSE
 
      * Access the branch
 
     C     A8BRCD        CHAIN     @A8REB0                            99        *
 
      * Error if the branch code was not found
 
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'INVALID BRANCH:' + A8BRCD
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Save the branch's details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_BRCD(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     A8BRCD        #_BRCD(@IX)
     C                   MOVEL     SDBRCH        #_BRCDDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     A8BRCD        #_BRCD(@CIX)
     C                   MOVEL     SDBRCH        #_BRCDDT(@CIX)
     C     @CIX          IFEQ      MaxNoBrch
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = SDBRCH
 
 
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
(c) Finastra International Limited 2003