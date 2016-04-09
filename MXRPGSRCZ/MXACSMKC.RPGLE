     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Market Centre Details')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSMKC - Access Market Centre Details                      *
      *                                                               *
      *  Function:  This module accesses market centre details        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Last Amend No. CSE029  *CREATE    Data 17Jul01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSE029 - ISO15022 Message Generation                         *
      *                                                               *
      *****************************************************************
 
     FSEMKC     IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Market Details
     D MKC           E DS                  EXTNAME(SEMKC)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        #MRKT             2
 
      * If no market centre is supplied
      * pass back a blank format
 
     C     #MRKT         IFEQ      *BLANK
     C     #MRKT         OREQ      '00'
     C                   CLEAR                   MKC
     C                   ELSE
 
      * Access the market centre details
 
     C     #MRKT         CHAIN     SEMKCDF                            99        *
 
      * If the customer number was not found
      * pass back a blank format
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   MKC
     C                   ENDIF
 
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = MKC
 
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
