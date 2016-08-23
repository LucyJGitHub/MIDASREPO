     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Countries')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSCTRY - Access Countries                                 *
      *                                                               *
      *  Function:  This module accesses countries.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER045             Date 20Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG3644            Date 12Jul04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                          *CREATE   Date                       *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  CRE026 - Consumer Banking                                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG3644 - Serious Error in Collateralised Lending (Recompile)*
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FSDCTRYL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Maximum number of countries
     D MaxNoCtys       C                   CONST(100)
 
      * Countries
     D #_CTRY          S              2    DIM(MaxNoCtys)
      * Country Details
     D #_CTRYDT        S            100    DIM(MaxNoCtys)
 
      * Country Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        A4CNCD
 
      * If no country code is supplied
      * pass back a blank format
 
     C     A4CNCD        IFEQ      *BLANK
     C                   CLEAR                   SDCTRY
     C                   ELSE
 
 
      * If the country code was previously accessed,
      * use that country's details
 
     C                   Z-ADD     1             @IX               6 0
     C     A4CNCD        LOOKUP    #_CTRY(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_CTRYDT(@IX) SDCTRY
     C                   ELSE
 
      * Access the country
 
     C     A4CNCD        CHAIN     @A4REBR                            99        *
 
      * Error if the country code was not found
 
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'INVALID COUNTRY:' + A4CNCD
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Save the country's details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_CTRY(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     A4CNCD        #_CTRY(@IX)
     C                   MOVEL     SDCTRY        #_CTRYDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     A4CNCD        #_CTRY(@CIX)
     C                   MOVEL     SDCTRY        #_CTRYDT(@CIX)
     C     @CIX          IFEQ      MaxNoCtys
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = SDCTRY
 
 
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
