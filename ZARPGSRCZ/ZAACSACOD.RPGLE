     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Access Account Codes')
      *****************************************************************
      *                                                               *
      *  Midas - Common Applications Module                           *
      *                                                               *
      *  ZAACSACOD - Access Account Codes                             *
      *                                                               *
      *  Function:  This module accesses account codes.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                          *CREATE   Date                       *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FSDACODL1  IF   E           K DISK
 
 
      * Number of account codes stored
     D NoAccds         C                   CONST(50)
 
      * A/C Codes
     D***S_ACOD*         S              4    DIM(NoAccds)                                     CGL029
     D S_ACOD          S             10    DIM(NoAccds)                                       CGL029
      * A/C Code Details
     D S_ACODDT        S            300    DIM(NoAccds)
 
      * A/C Code Details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
 
 
     C     *ENTRY        PLIST
     C**********         PARM                    I_ACCD            4                          CGL029
     C                   PARM                    I_ACCD           10                          CGL029
     C                   PARM                    SDACOD
 
      * If the a/c code was previously accessed,
      * use that a/c code's details
 
     C                   Z-ADD     1             IX                6 0
     C     I_ACCD        LOOKUP    S_ACOD(IX)                             99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     S_ACODDT(IX)  SDACOD
     C                   ELSE
 
      * Access the a/c code
 
     C     I_ACCD        CHAIN     @A5REA6                            99        *
 
      * If the a/c code is not found
      * pass back a blank format
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   SDACOD
     C                   ENDIF
 
      * Save the a/c code's details
 
     C                   Z-ADD     1             IX
     C     *BLANK        LOOKUP    S_ACOD(IX)                             99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     I_ACCD        S_ACOD(IX)
     C                   MOVEL     SDACOD        S_ACODDT(IX)
     C                   ELSE
     C                   ADD       1             CIX
     C                   MOVEL     I_ACCD        S_ACOD(CIX)
     C                   MOVEL     SDACOD        S_ACODDT(CIX)
     C     CIX           IFEQ      NoAccds
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
