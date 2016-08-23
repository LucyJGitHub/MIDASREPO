     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Access Global Currency Details')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPACSCURR -  Access Global Currency Details                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CGP010   *CREATE   Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGPCURRL0  IF   E           K DISK    INFSR(*PSSR)
 
      * Maximum number of currencies
     D MaxNoCcys       C                   CONST(500)
 
      * Currencies
     D #_CURR          S              3    DIM(MaxNoCcys)
      * Currency Details
     D #_CURRDT        S             60    DIM(MaxNoCcys)
 
      * Currency Details
     D GPCURR        E DS                  EXTNAME(GPCURRPD)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * currency
     C                   PARM                    I#CCY             3
     C                   PARM                    GPCURR
 
      * Use input field
 
     C                   MOVEL     I#CCY         GCCYCD
 
      * If no currency code is supplied
      * pass back a blank format
 
     C     GCCYCD        IFEQ      *BLANK
     C                   CLEAR                   GPCURR
     C                   ELSE
 
      * If the currency code was previously accessed,
      * use that currency code's details
 
     C                   Z-ADD     1             @IX               6 0
     C     GCCYCD        LOOKUP    #_CURR(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_CURRDT(@IX) GPCURR
     C                   ELSE
 
      * Access the currency code
 
     C     GCCYCD        CHAIN     GPCURRD0                           99        *
 
      * If the currency code was not found pass back blank details
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   GPCURR
     C                   MOVEL     I#CCY         GCCYCD
     C                   ENDIF
 
      * Save the currency code's details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_CURR(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     GCCYCD        #_CURR(@IX)
     C                   MOVEL     GPCURR        #_CURRDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     GCCYCD        #_CURR(@CIX)
     C                   MOVEL     GPCURR        #_CURRDT(@CIX)
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
