     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Get Next Composite/Fmt For Transmission')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXGETNCFT - Get Next Composite/Format for Transmission       *
      *                                                               *
      *  Function:  This module reads the next composite or format    *
      *             ready for transmission and returns its ID.        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. BUG17937           Date 24Apr08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX002  *CREATE    Data 26Sep00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17937 - SEC3300 is Failing with an error.  Applied fix    *
      *             245268 (Recompile)                                *
      *  CMX002 - Meridian Export Enhancements - Phase 1              *
      *                                                               *
      *****************************************************************
 
     FMXCOMDPD  IF   E           K DISK    INFSR(*PSSR)
      * Composite Message Details
 
     FMXEXFDPD  IF   E           K DISK    INFSR(*PSSR)
      * Export Format Details
 
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
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    I#TYPE            1
      * OUTPUTS
     C                   PARM                    I#COMI            8
     C                   PARM                    I#EXTT            1
     C                   PARM                    I#FMT            10
 
      * Clear outputs
 
     C                   MOVE      *BLANK        I#COMI
     C                   MOVE      *BLANK        I#EXTT
     C                   MOVE      *BLANK        I#FMT
 
      * Read all composites
 
     C     I#TYPE        IFEQ      'C'
 
     C                   READ      MXCOMDP0                               99    *
     C     *in99         DOWEQ     '0'
 
      * If a composite was found ready for transmission
 
     C     CDXCTL        IFEQ      2
     C                   MOVE      CDCOMI        I#COMI
     C                   MOVE      CDEXTT        I#EXTT
     C                   MOVE      '*NONE     '  I#FMT
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
     C                   READ      MXCOMDP0                               99    *
     C                   ENDDO
     C                   ENDIF
 
      * Read all formats
 
     C     I#TYPE        IFEQ      'F'
 
     C                   READ      MXEXFDP0                               99    *
     C     *in99         DOWEQ     '0'
 
      * If a format was found ready for transmission
 
     C     EXXCTL        IFEQ      2
     C                   MOVE      '*NONE   '    I#COMI
     C                   MOVE      'X'           I#EXTT
     C                   MOVE      EXFMT         I#FMT
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
     C                   READ      MXEXFDP0                               99    *
     C                   ENDDO
     C                   ENDIF
 
      * Return
 
     C                   SETON                                        LR
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
