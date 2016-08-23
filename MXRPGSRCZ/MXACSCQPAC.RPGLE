     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Cheques for Py/Cr details')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSCQPAC - Access Cheques To Be Paid credit details        *
      *                                                               *
      *  Function:  This module accesses cheques to be paid           *
      *             credit details                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CDL049             Date 11Jul06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CMX002             Data 26Sep00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CMX002 - Meridian Export Enhancements - Phase 1              *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FCQPAC     IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Cheques To Be Paid credit details
     D CQPACX        E DS                  EXTNAME(CQPACDD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to fields
 
     C                   MOVEL     I#LFD1        A_PREF           20
 
      * If no payment reference is supplied
      * pass back a blank format
 
     C     A_PREF        IFEQ      *BLANK
     C                   CLEAR                   CQPACX
     C                   ELSE
 
      * Access the payment reference
 
     C                   MOVEL     A_PREF        PREF
     C     CQPACK        CHAIN     CQPACDDF                           99        *
 
      * Pass back a blank format if no record was found
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   CQPACX
     C                   ENDIF
     C                   ENDIF
 
 
 
      * Set up output data
 
     C                   EVAL      InData = CQPACX
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Key list
 
     C     CQPACK        KLIST
     C                   KFLD                    PREF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
