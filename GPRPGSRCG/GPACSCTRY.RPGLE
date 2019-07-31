     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Access Global Country Details')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPACSCTRY -  Access Global Country Details                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGPICTRYL0 IF   E           K DISK    INFSR(*PSSR)
 
      * Maximum number of countries
     D MaxNoCtys       C                   CONST(250)
 
      * Countries
     D #_CTRY          S              2    DIM(MaxNoCtys)
      * Country Details
     D #_CTRYDT        S             60    DIM(MaxNoCtys)
 
      * Country Details
     D GPICTRY       E DS                  EXTNAME(GPICTRYPD)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * country
     C                   PARM                    I#CTRY            2
     C                   PARM                    GPICTRY
 
      * Use input field
 
     C                   MOVEL     I#CTRY        CNCNCD
 
      * If no country code is supplied
      * pass back a blank format
 
     C     CNCNCD        IFEQ      *BLANK
     C                   CLEAR                   GPICTRY
     C                   ELSE
 
      * If the country code was previously accessed,
      * use that country code's details
 
     C                   Z-ADD     1             @IX               6 0
     C     CNCNCD        LOOKUP    #_CTRY(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_CTRYDT(@IX) GPICTRY
     C                   ELSE
 
      * Access the country code
 
     C     CNCNCD        CHAIN     GPICTRYD0                          99        *
 
      * If the country code was not found pass back blank details
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   GPICTRY
     C                   MOVEL     I#CTRY        CNCNCD
     C                   ENDIF
 
      * Save the country code's details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_CTRY(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     CNCNCD        #_CTRY(@IX)
     C                   MOVEL     GPICTRY       #_CTRYDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     CNCNCD        #_CTRY(@CIX)
     C                   MOVEL     GPICTRY       #_CTRYDT(@CIX)
     C     @CIX          IFEQ      MaxNoCtys
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
