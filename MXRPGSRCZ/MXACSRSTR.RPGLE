     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Request SE Statement Repetitive')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSRSTR - Access Request SE Statement - Repetitive data.   *
      *                                                               *
      *  Function:  This module accesses request SE Statement -       *
      *             repetitive date from MGRSTRPD.                    *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSE040  *CREATE    Data 06Feb03               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSE040 - Securities Statement Processing.                    *
      *                                                               *
      *****************************************************************
 
     FMGRSTRPD  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Request of securities statement - repetitive data
     D MGRSTR        E DS                  EXTNAME(MGRSTRPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        MRMREF
 
      * Error if no reference is supplied
 
     C     MRMREF        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'BLANK MESSAGE REFERENCE'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If a new message reference, re-position the file pointer
 
     C     MRMREF        IFNE      PrvMREF
     C                   MOVEL     MRMREF        PrvMREF
     C                   Z-ADD     *ZERO         Num_ExtRcs        5 0
     C     MRMREF        SETLL     MGRSTRD0
     C                   ENDIF
 
      * Get a repetitive data
 
     C     MRMREF        READE     MGRSTRD0                               99     *
 
      * No more repetitive
 
     C     *IN99         IFEQ      '1'
     C     Num_ExtRcs    OREQ      200
     C                   MOVEL     '*EODATA'     I#RTCD
     C                   ELSE
     C                   ADD       1             Num_ExtRcs
     C                   Z-ADD     Num_ExtRcs    MRCPTM
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = MGRSTR
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     *BLANK        PrvMREF          16
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
