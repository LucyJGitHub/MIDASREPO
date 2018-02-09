     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Access Global Branch Details')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPACSBRCH -  Access Global Branch Details                    *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGZSDBRCHL0IF   E           K DISK    INFSR(*PSSR)
 
      * Maximum number of branches
     D MaxNoBrns       C                   CONST(100)
 
      * Branches
     D #_BRCH          S              3    DIM(MaxNoBrns)
      * Branch Details
     D #_BRCHDT        S            501    DIM(MaxNoBrns)
 
      * Branch Details
     D GZSDBRCH      E DS                  EXTNAME(GZSDBRCHPD)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * Branch
     C                   PARM                    I#BRCD            3
     C                   PARM                    GZSDBRCH
 
      * Use input field
 
     C                   MOVEL     I#BRCD        A8BRCD
 
      * If no branch is supplied
      * pass back a blank format
 
     C     A8BRCD        IFEQ      *BLANK
     C                   CLEAR                   GZSDBRCH
     C                   ELSE
 
      * If the branch was previously accessed,
      * use that branch's details
 
     C                   Z-ADD     1             @IX               6 0
     C     A8BRCD        LOOKUP    #_BRCH(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_BRCHDT(@IX) GZSDBRCH
     C                   ELSE
 
      * Access the branch
 
     C     A8BRCD        CHAIN     SDBRCHD0                             99        *
 
      * If the branch was not found pass back blank details
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   GZSDBRCH
     C                   MOVEL     I#BRCD        A8BRCD
     C                   ENDIF
 
      * Save the branch's details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_BRCH(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     A8BRCD        #_BRCH(@IX)
     C                   MOVEL     GZSDBRCH      #_BRCHDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     A8BRCD        #_BRCH(@CIX)
     C                   MOVEL     GZSDBRCH      #_BRCHDT(@CIX)
     C     @CIX          IFEQ      MaxNoBrns
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
      *********************************************************************
      * *PSSR  --- ABNORMAL ERROR CONDITIONS
      *********************************************************************
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           W#RUN             1
 
     C                   MOVEL     '*ERROR'      I#RTCD
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
      *
      * If no identified cause of error
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
      *
      * Log an error on the error log
      *
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
 
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
