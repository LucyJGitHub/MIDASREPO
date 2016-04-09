     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Currencies')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSCURR - Access Currencies                                *
      *                                                               *
      *  Function:  This module accesses currencies.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FSDCURRL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Maximum number of currencies
     D MaxNoCcys       C                   CONST(500)
 
      * Currencies
     D #_CURR          S              3    DIM(MaxNoCcys)
      * Currency Details
     D #_CURRDT        S            600    DIM(MaxNoCcys)
 
      * Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        A6CYCD
 
      * If no currency code is supplied
      * pass back a blank format
 
     C     A6CYCD        IFEQ      *BLANK
     C                   CLEAR                   SDCURR
     C                   ELSE
 
 
      * If the currency code was previously accessed,
      * use that currency code's details
 
     C                   Z-ADD     1             @IX               6 0
     C     A6CYCD        LOOKUP    #_CURR(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_CURRDT(@IX) SDCURR
     C                   ELSE
 
      * Access the currency code
 
     C     A6CYCD        CHAIN     @A6REA3                            99        *
 
      * Error if the currency code was not found
 
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'INVALID CURRENCY:' + A6CYCD
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Save the currency code's details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_CURR(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     A6CYCD        #_CURR(@IX)
     C                   MOVEL     SDCURR        #_CURRDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     A6CYCD        #_CURR(@CIX)
     C                   MOVEL     SDCURR        #_CURRDT(@CIX)
     C     @CIX          IFEQ      MaxNoCcys
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = SDCURR
 
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   Z-ADD     *ZERO         @CIX              6 0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
