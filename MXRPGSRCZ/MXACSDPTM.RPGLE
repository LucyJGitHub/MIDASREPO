     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access depot movements')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSDPTM - Access Depot Movements                           *
      *                                                               *
      *  Function:  This module accesses depot movements              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. 222727             Date 05Nov03               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 207006             Data 18Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE029  *CREATE    Data 26Jul01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  207006 - Add Counterparty & Market Centre to SSI (Recompile) *
      *  CSE029 - ISO15022 Message Generation                         *
      *                                                               *
      *****************************************************************
 
     FDPTMVDL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Depot Movements
     D DEPOT         E DS                  EXTNAME(DPTMVDL1)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        #DPRN             6
 
      * If no depot movement is supplied
      * pass back a blank format
 
     C     #DPRN         IFEQ      *BLANK
     C     #DPRN         OREQ      '000000'
     C                   CLEAR                   DEPOT
     C                   ELSE
 
      * Access the depot movement details
 
     C     #DPRN         CHAIN     DPTMVDL1                           99        *
 
      * If the depot movement was not found
      * pass back a blank format
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   DEPOT
     C                   ENDIF
 
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = DEPOT
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
