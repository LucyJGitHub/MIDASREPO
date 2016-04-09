     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Securities Customers')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSSECS - Access Securities Customers                      *
      *                                                               *
      *  Function:  This module accesses securities customers.        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Last Amend No. CMX001  *CREATE    Data 01Jan00               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FSDSECSL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Maximum number of securities customer numbers
     D MaxNoCsts       C                   CONST(100)
 
      * Securities Customers
     D #_SECS          S              6    DIM(MaxNoCsts)
      * Securities Customer Details
     D #_SECSDT        S           1300    DIM(MaxNoCsts)
 
      * Securities Customer Details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        BFCUST
 
      * If no customer number is supplied
      * pass back a blank format
 
     C     BFCUST        IFEQ      *BLANK
     C     BFCUST        OREQ      '000000'
     C                   CLEAR                   SDSECS
     C                   ELSE
 
 
      * If the customer number was previously accessed,
      * use that customer's details
 
     C                   Z-ADD     1             @IX               6 0
     C     BFCUST        LOOKUP    #_SECS(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_SECSDT(@IX) SDSECS
     C                   ELSE
 
      * Access the securities customer
 
     C     BFCUST        CHAIN     @BFREDQ                            99        *
 
      * If the customer number was not found
      * pass back a blank format
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   SDSECS
     C                   ELSE
 
      * Save the securities customer's details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_SECS(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     BFCUST        #_SECS(@IX)
     C                   MOVEL     SDSECS        #_SECSDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     BFCUST        #_SECS(@CIX)
     C                   MOVEL     SDSECS        #_SECSDT(@CIX)
     C     @CIX          IFEQ      MaxNoCsts
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = SDSECS
 
 
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
