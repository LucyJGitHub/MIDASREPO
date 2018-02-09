     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Access Global Industry Details')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPACSINDS -  Access Global Industry Details                  *
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
 
     FGZSDINDSL1IF   E           K DISK    INFSR(*PSSR)
 
      * Maximum number of industries
     D MaxNoInds       C                   CONST(500)
 
      * Industries
     D #_INDS          S             13    DIM(MaxNoInds)
      * Industry Details
     D #_INDSDT        S             60    DIM(MaxNoInds)
 
      * Industry Details
     D GZSDINDS      E DS                  EXTNAME(GZSDINDSPD)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * local industry
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#LICD            3
     C                   PARM                    GZSDINDS
 
      * Use input fields
 
     C                   MOVEL     I#ZONE        AOZONE
     C                   MOVEL     I#LICD        AOLICD
 
     C                   MOVEL     I#ZONE        ZoneIndustry     13
     C                   MOVE      I#LICD        ZoneIndustry
 
      * If no industry code is supplied
      * pass back a blank format
 
     C     AOLICD        IFEQ      *BLANK
     C                   CLEAR                   GZSDINDS
     C                   ELSE
 
      * If the industry code was previously accessed,
      * use that industry code's details
 
     C                   Z-ADD     1             @IX               6 0
     C     ZoneIndustry  LOOKUP    #_INDS(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_INDSDT(@IX) GZSDINDS
     C                   ELSE
 
      * Access the industry code
 
     C     INDSK         CHAIN     SDINDSD0                           99        *
 
      * If the industry code was not found pass back blank details
 
     C     *in99         IFEQ      '1'
     C                   CLEAR                   GZSDINDS
     C                   MOVEL     I#LICD        AOLICD
     C                   ENDIF
 
      * Save the industry code's details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_INDS(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     ZoneIndustry  #_INDS(@IX)
     C                   MOVEL     GZSDINDS      #_INDSDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     ZoneIndustry  #_INDS(@CIX)
     C                   MOVEL     GZSDINDS      #_INDSDT(@CIX)
     C     @CIX          IFEQ      MaxNoInds
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
 
     C     INDSK         KLIST
     C                   KFLD                    AOZONE
     C                   KFLD                    AOLICD
 
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
