     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Retail Interest Sub-Types')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSRINT - Access Retail Interest Sub-Types                 *
      *                                                               *
      *  Function:  This module accesses retail interest sub-types    *
      *             extension data.                                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CMX002  *CREATE    Data 26Sep00               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMX002 - Meridian Export Enhancements - Phase 1              *
      *                                                               *
      *****************************************************************
 
     FREINT     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(REINTDF)
     F                                     PREFIX(R_)
 
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
 
 
      * Retail Interest Sub-Types
     D REINTDX       E DS                  EXTNAME(REINTD)
     D                                     PREFIX(R_)
 
 
     D                 DS
     D  REINTK                 1     12
     D  ITYPE                  2      3
     D  ISTYP                  4      8
     D  ICCY                   9     11
     D  I_D                   12     12
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_TYPE            2
     C                   MOVEL     I#LFD2        A_STYP            5
     C                   MOVEL     I#LFD3        A_CCY             3
 
      * If no type, sub-type or currency is supplied
      * pass back a blank format
 
     C     A_TYPE        IFEQ      *BLANK
     C     A_TYPE        OREQ      '00'
     C     A_STYP        OREQ      *BLANK
     C     A_STYP        OREQ      '00000'
     C     A_CCY         OREQ      *BLANK
     C                   CLEAR                   REINTDX
     C                   ELSE
 
      * Access the retail interest sub-type
 
     C                   MOVEL     A_TYPE        ITYPE
     C                   MOVEL     A_STYP        ISTYP
     C                   MOVEL     A_CCY         ICCY
     C     REINTK        CHAIN     REINTDF                            99        *
 
      * Pass back a blank format if no record was found
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   REINTDX
     C                   ENDIF
     C                   ENDIF
 
 
 
      * Set up output data
 
     C                   EVAL      InData = REINTDX
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEL     'D'           I_D
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
