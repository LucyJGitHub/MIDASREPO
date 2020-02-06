     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Access Global Historic Spot Rates')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPACSCUHS -  Access Global Historic Spot Rates               *
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
 
     FGZSDCUHSL2IF   E           K DISK    INFSR(*PSSR)
 
 
      * Maximum number of rates
     D MaxNoRats       C                   CONST(1000)
 
      * Currency/Date
     D #_CYDT          S              8    DIM(MaxNoRats)
      * Rate Details
     D #_RATEDT        S             14    DIM(MaxNoRats)
 
      * Historic Rate Details
     D GZSDCUHS      E DS                  EXTNAME(GZSDCUHSPD)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * zone
      * currency
      * date
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
      * zone base currency
     C                   PARM                    I#ZBC             3
      * Current Index
      * Currency/Date
      * Rate Details
     C                   PARM                    @CIX              6 0
     C                   PARM                    ##_CYDT        8000
     C                   PARM                    ##_RATEDT     14000
 
     C                   PARM                    GZSDCUHS
 
      * Use input fields
 
     C                   MOVEL     I#ZONE        G2ZONE
     C                   MOVEL     I#CCY         G2CYCD
     C                   Z-ADD     I#DATE        G2HIDT
 
     C                   MOVEL     G2CYCD        CYDT              8
     C                   MOVE      G2HIDT        CYDT
 
     C                   MOVEA     ##_CYDT       #_CYDT
     C                   MOVEA     ##_RATEDT     #_RATEDT
 
      * If currency is base currency
      *  pass back a rate of 1
 
     C     G2CYCD        IFEQ      I#ZBC
     C                   Z-ADD     1             G2SPRT
     C                   MOVE      'M'           G2MDIN
     C                   ELSE
 
      * If the rate was previously accessed,
      * use that rate details
 
     C                   Z-ADD     1             @IX               6 0
     C     CYDT          LOOKUP    #_CYDT(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_RATEDT(@IX) GZSDCUHS
     C                   ELSE
 
      * Access the rate
 
     C                   Z-ADD     0             G2SPRT
     C                   MOVE      'M'           G2MDIN
 
     C     CUHSK         CHAIN     GZSDCUHSL2                         99
 
      * If not found, get the rate prior to this date
 
     C     *in99         IFEQ      '1'
     C     CUHSK         SETLL     GZSDCUHSL2
     C     CUHSKP        READE     GZSDCUHSL2                             99
     C                   ENDIF
 
      * Save the rate details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_CYDT(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     CYDT          #_CYDT(@IX)
     C                   MOVEL     GZSDCUHS      #_RATEDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     CYDT          #_CYDT(@CIX)
     C                   MOVEL     GZSDCUHS      #_RATEDT(@CIX)
     C     @CIX          IFEQ      MaxNoRats
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEA     #_CYDT        ##_CYDT
     C                   MOVEA     #_RATEDT      ##_RATEDT
 
      * Return
 
     C                   RETURN
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     CUHSKP        KLIST
     C                   KFLD                    G2ZONE
     C                   KFLD                    G2CYCD
     C     CUHSK         KLIST
     C                   KFLD                    G2ZONE
     C                   KFLD                    G2CYCD
     C                   KFLD                    G2HIDT
 
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
