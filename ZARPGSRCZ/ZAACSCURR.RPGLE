     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Access Currencies')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Common Applications Module                           *
      *                                                               *
      *  ZAACSCURR - Access Currencies                                *
      *                                                               *
      *  Function:  This module accesses currencies.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CRE008  *CREATE    Data 19Feb02               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FSDCURRL1  IF   E           K DISK
 
 
      * Number of currencies stored
     D NoCcys          C                   CONST(20)
 
      * Currencies
     D S_CURR          S              3    DIM(NoCcys)
      * Currency Details
     D S_CURRDT        S            600    DIM(NoCcys)
 
      * Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I_CYCD            3
     C                   PARM                    SDCURR
 
      * If the currency code was previously accessed,
      * use that currency code's details
 
     C                   Z-ADD     1             IX                6 0
     C     I_CYCD        LOOKUP    S_CURR(IX)                             99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     S_CURRDT(IX)  SDCURR
     C                   ELSE
 
      * Access the currency code
 
     C     I_CYCD        CHAIN     @A6REA3                            99        *
 
      * If the currency code was not found
      * pass back a blank format
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   SDCURR
     C                   ENDIF
 
      * Save the currency code's details
 
     C                   Z-ADD     1             IX
     C     *BLANK        LOOKUP    S_CURR(IX)                             99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     I_CYCD        S_CURR(IX)
     C                   MOVEL     SDCURR        S_CURRDT(IX)
     C                   ELSE
     C                   ADD       1             CIX
     C                   MOVEL     I_CYCD        S_CURR(CIX)
     C                   MOVEL     SDCURR        S_CURRDT(CIX)
     C     CIX           IFEQ      NoCcys
     C                   Z-ADD     *ZERO         CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   Z-ADD     *ZERO         CIX               6 0
 
     C                   ENDSR
      ********************************************************************
