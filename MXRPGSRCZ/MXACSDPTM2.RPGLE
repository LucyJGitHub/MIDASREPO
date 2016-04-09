     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Depot Movement Extended Settlemnts')   *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSDPTM2 - Access Depot Movement Extended Settlements      *
      *                                                               *
      *  Function:  This module accesses depot movement extended      *
      *             settlements                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 222727             Date 05Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 200292             Data 10Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE029  *CREATE    Data 26Jul01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  200292 - Need to pick up the extention file at start         *
      *  CSE029 - ISO15022 Message Generation                         *
      *                                                               *
      *****************************************************************
 
     FDPTMVDY2  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Depot Movement Extentions
     D DPEXT2        E DS                  EXTNAME(DPTMVDY2)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
     C     KEY           KLIST
     C                   KFLD                    #DPSS            10
     C                   KFLD                    #DPRN             6
     C                   KFLD                    #WHEN             1                          200292
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        #DPSS
     C                   MOVEL     I#LFD2        #DPRN
     C                   MOVEL     I#LFD3        #WHEN                                        200292
     C
      * If key is blank
      * pass back a blank format
 
     C     #DPSS         IFEQ      *BLANK
     C     #DPSS         OREQ      '0000000000'
     C     #DPRN         OREQ      *BLANK
     C     #DPRN         OREQ      '000000'
     C                   CLEAR                   DPEXT2
     C                   ELSE
 
      * Access the depot movement extented settlements
 
     C     KEY           CHAIN     DPTMVDY2                           99        *
 
      * If the depot movement extented settlements was not found
      * pass back a blank format
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   DPEXT2
     C                   ENDIF
 
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = DPEXT2
 
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
