     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Access Global Account Code')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPACSGACD -  Access Global Account Code                      *
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
 
     FGPACODXL0 IF   E           K DISK    INFSR(*PSSR)
 
 
      * Maximum number of account codes
     D MaxNoAcds       C                   CONST(1000)
 
      * Zone Account Codes
     D #_ZACOD         S             10    DIM(MaxNoAcds)
      * Global Account Codes
     D #_GACOD         S             10    DIM(MaxNoAcds)
 
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * account code
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#ACOD           10
      * Current Index
      * Zone Account Codes
      * Global Account Codes
     C                   PARM                    @CIX              6 0
     C                   PARM                    ##_ZACOD      10000
     C                   PARM                    ##_GACOD      10000
 
     C                   PARM                    ACGACD
 
      * Use input fields
 
     C                   MOVEL     I#ZONE        ACZONE
     C                   MOVEL     I#ACOD        ACACCD
 
     C                   MOVEA     ##_ZACOD      #_ZACOD
     C                   MOVEA     ##_GACOD      #_GACOD
 
      * If the account code was previously accessed,
      * use that account code's details
 
     C                   Z-ADD     1             @IX               6 0
     C     I#ACOD        LOOKUP    #_ZACOD(@IX)                           99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_GACOD(@IX)  ACGACD
     C                   ELSE
 
      * Access the account code extension record
 
     C                   MOVEL     *BLANK        ACGACD
 
     C     GPACODXK      CHAIN     GPACODXL0                          99
 
      * Save the account code extension details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_ZACOD(@IX)                           99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     I#ACOD        #_ZACOD(@IX)
     C                   MOVEL     ACGACD        #_GACOD(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     I#ACOD        #_ZACOD(@CIX)
     C                   MOVEL     ACGACD        #_GACOD(@CIX)
     C     @CIX          IFEQ      MaxNoAcds
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVEA     #_ZACOD       ##_ZACOD
     C                   MOVEA     #_GACOD       ##_GACOD
 
      * Return
 
     C                   RETURN
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     GPACODXK      KLIST
     C                   KFLD                    ACZONE
     C                   KFLD                    ACACCD
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
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
