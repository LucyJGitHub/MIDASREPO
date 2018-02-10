     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access DL RWA balances')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSSERWA - Access SE RWA Balance                           *
      *                                                               *
      *  Function:  This module accesses SE RWA balance records       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Midas Release 3.05------------- Base -------------------------*
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL018  *CREATE    Data 01OCT02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
 
     FSERWABL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * SE Risk Weighted Asset balances
     D SEEXT1        E DS                  EXTNAME(SERWABPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
     C     KEY           KLIST
     C                   KFLD                    SBBPBA            3
     C                   KFLD                    SBBPBK            2
     C                   KFLD                    SBBPSC           10
     C                   KFLD                    SBBPMK            1
     C                   KFLD                    SBBPTV            1
     C                   KFLD                    SBBPPD
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        SBBPBA
     C                   MOVEL     I#LFD2        SBBPBK
     C                   MOVEL     I#LFD3        SBBPSC
     C                   MOVEL     I#LFD4        SBBPMK
     C                   MOVEL     I#LFD5        SBBPTV
     C                   MOVEL     I#LFD6        SBBPPD
     C
      * If key is blank
      * pass back a blank format
 
     C     SBBPBA        IFEQ      *BLANK
     C     SBBPBA        OREQ      '000'
     C     SBBPBK        OREQ      *BLANK
     C     SBBPBK        OREQ      '00'
     C     SBBPSC        OREQ      *BLANK
     C     SBBPSC        OREQ      '0000000000'
     C     SBBPMK        OREQ      *BLANK
     C     SBBPMK        OREQ      '0'
     C     SBBPTV        OREQ      *BLANK
     C     SBBPTV        OREQ      '0'
     C     SBBPPD        OREQ      0
     C                   CLEAR                   SEEXT1
     C                   ELSE
 
      * Access the DL RWA balances details
 
     C     KEY           CHAIN     SERWABP0                           99        *
 
      * If the SE RWA balance record was not found for the account
      * pass back a blank format
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   SEEXT1
     C                   ENDIF
 
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = SEEXT1
 
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
(c) Finastra International Limited 2001
