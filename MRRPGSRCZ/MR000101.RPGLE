/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MR Access Currency Details')                     *
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR000101 -  Access Currency Details                          *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CMR001             Date 01Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     FSDCURRL1  IF   E           K DISK    INFSR(*PSSR)
 
      * Maximum number of currencies
     D MaxNoCcys       C                   CONST(500)
 
      * Currencies
     D #_CURR          S              3    DIM(MaxNoCcys)
      * Currency Details
     D #_CURRDT        S            600    DIM(MaxNoCcys)
 
      * Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#CCY             3
     C                   PARM                    SDCURR
 
      * Use input field
 
     C                   MOVEL     I#CCY         A6CYCD
 
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
 
      * If the currency code was not found pass back blank details
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   SDCURR
     C                   MOVEL     I#CCY         A6CYCD
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
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           W#RUN             1
 
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
