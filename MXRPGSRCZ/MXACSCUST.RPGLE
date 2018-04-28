     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Access Customers')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXACSCUST - Access Customers                                 *
      *                                                               *
      *  Function:  This module accesses customers.                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Data 11Jan05               *
      *                 CSW037             Data 15Dec04               *
      *                 CSW036             Data 15Dec04               *
      *                 CLE025             Data 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CMX001  *CREATE    Date 01Jan00               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                           *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
      * Maximum number of customer numbers
     D MaxNoCsts       C                   CONST(100)
 
      * Customers
     D #_CUST          S              6    DIM(MaxNoCsts)
      * Customer Details
     D #_CUSTDT        S           1300    DIM(MaxNoCsts)
 
      * Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
 
     C     *ENTRY        PLIST
     C/COPY MXCPYSRC,MXACSPRMI
 
 
      * Use input link-to field
 
     C                   MOVEL     I#LFD1        BBCUST
 
      * If no customer number is supplied
      * pass back a blank format
 
     C     BBCUST        IFEQ      *BLANK
     C     BBCUST        OREQ      '000000'
     C                   CLEAR                   SDCUST
     C                   ELSE
 
 
      * If the customer number was previously accessed,
      * use that customer's details
 
     C                   Z-ADD     1             @IX               6 0
     C     BBCUST        LOOKUP    #_CUST(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_CUSTDT(@IX) SDCUST
     C                   ELSE
 
      * Access the customer
 
     C     BBCUST        CHAIN     @BBREBF                            99        *
 
      * Error if the customer number was not found
 
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'INVALID CUSTOMER:' + BBCUST
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Save the customer's details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_CUST(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     BBCUST        #_CUST(@IX)
     C                   MOVEL     SDCUST        #_CUSTDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     BBCUST        #_CUST(@CIX)
     C                   MOVEL     SDCUST        #_CUSTDT(@CIX)
     C     @CIX          IFEQ      MaxNoCsts
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      * Set up output data
 
     C                   EVAL      InData = SDCUST
 
 
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
