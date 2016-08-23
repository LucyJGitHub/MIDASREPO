     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Access Branch Codes')
      *****************************************************************
      *                                                               *
      *  Midas - Common Applications Module                           *
      *                                                               *
      *  ZAACSBRCH - Access Branch codes                              *
      *                                                               *
      *  Function:  This module accesses branch codes.                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CRE008   *CREATE   Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FSDBRCHL1  IF   E           K DISK
 
 
      * Number of branch codes stored
     D NoBrcds         C                   CONST(10)
 
      * Branch Codes
     D S_BRCH          S              3    DIM(NoBrcds)
      * Branch Code Details
     D S_BRCHDT        S            500    DIM(NoBrcds)
 
      * Branch Code Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I_BRCD            3
     C                   PARM                    SDBRCH
 
      * If the branch code was previously accessed,
      * use that branch code's details
 
     C                   Z-ADD     1             IX                6 0
     C     I_BRCD        LOOKUP    S_BRCH(IX)                             99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     S_BRCHDT(IX)  SDBRCH
     C                   ELSE
 
      * Access the branch code
 
     C     I_BRCD        CHAIN     @A8REB0                            99        *
 
      * If the branch code is not found
      * pass back a blank format
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   SDBRCH
     C                   ENDIF
 
      * Save the branch code's details
 
     C                   Z-ADD     1             IX
     C     *BLANK        LOOKUP    S_BRCH(IX)                             99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     I_BRCD        S_BRCH(IX)
     C                   MOVEL     SDBRCH        S_BRCHDT(IX)
     C                   ELSE
     C                   ADD       1             CIX
     C                   MOVEL     I_BRCD        S_BRCH(CIX)
     C                   MOVEL     SDBRCH        S_BRCHDT(CIX)
     C     CIX           IFEQ      NoBrcds
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
