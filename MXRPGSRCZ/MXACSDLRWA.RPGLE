     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access DL RWA balances')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSDLRWA - Access DL RWA Balance                           *
      *                                                               *
      *  Function:  This module accesses DL RWA balance records       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Midas Release 3.05------------- Base -------------------------*
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL018  *CREATE    Data 01OCT02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
 
     FDLRWABL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * DL Risk Weighted Asset balances
     D DLEXT1        E DS                  EXTNAME(DLRWABPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        DBDLNO
     C
      * If key is blank
      * pass back a blank format
 
     C     DBDLNO        IFEQ      *BLANK
     C     DBDLNO        OREQ      '000000'
     C                   CLEAR                   DLEXT1
     C                   ELSE
 
      * Access the DL RWA balances details
 
     C     DBDLNO        CHAIN     DLRWABP0                           99        *
 
      * If the DL RWA balance record was not found for the account
      * pass back a blank format
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   DLEXT1
     C                   ENDIF
 
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = DLEXT1
 
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
