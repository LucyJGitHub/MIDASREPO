     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access GL RWA balances')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSGLRWA - Access GL RWA Balance                           *
      *                                                               *
      *  Function:  This module accesses GL RWA balance records       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 3.05------------- Base -------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL018 - Risk Weighted Assets                                *
      *                                                               *
      *****************************************************************
 
     FGLRWABL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * GL Risk Weighted Asset balances
     D GLEXT1        E DS                  EXTNAME(GLRWABPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
     C     KEY           KLIST
     C                   KFLD                    RBBRCA            3
     C**********         KFLD                    RBCUST            6 0                        CSD027
     C                   KFLD                    RBCUST            6                          CSD027
     C                   KFLD                    RBCCY             3
     C**********         KFLD                    RBACOD            4 0                        CGL029
     C                   KFLD                    RBACOD                                       CGL029
     C                   KFLD                    RBACSQ            2 0
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        RBBRCA
     C                   MOVEL     I#LFD2        RBCUST
     C                   MOVEL     I#LFD3        RBCCY
     C                   MOVEL     I#LFD4        RBACOD
     C                   MOVEL     I#LFD5        RBACSQ
     C
      * If key is blank
      * pass back a blank format
 
     C     RBBRCA        IFEQ      *BLANK
     C     RBBRCA        OREQ      '000'
     C*****RBCUST        OREQ      0                                                          CSD027
     C     RBCUST        OREQ      *BLANKS                                                    CSD027
     C     RBCCY         OREQ      *BLANK
     C     RBCCY         OREQ      '000'
     C     RBACOD        OREQ      0
     C     RBACSQ        OREQ      0
     C                   CLEAR                   GLEXT1
     C                   ELSE
 
      * Access the GL RWA baalnces details
 
     C     KEY           CHAIN     GLRWABP0                           99        *
 
      * If the GL RWA balance record was not found for the account
      * pass back a blank format
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   GLEXT1
     C                   ENDIF
 
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = GLEXT1
 
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
