     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Access Historic HeadOffice Exchange Rates')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPACSHHOX -  Access Historic Head-Office Exchange Rates      *
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
 
     FGPICDTPD  IF   E             DISK    INFSR(*PSSR)
     FGPHHOXL2  IF   E           K DISK    INFSR(*PSSR)
 
      * Maximum number of rates
     D MaxNoRats       C                   CONST(1000)
 
      * Currency/Date
     D #_CYDT          S              7    DIM(MaxNoRats)
      * Rate Details
     D #_RATEDT        S             19    DIM(MaxNoRats)
 
      * Historic Rate Details
     D GPHHOX        E DS                  EXTNAME(GPHHOXPD)
     D CYDT                    1      7
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * currency
      * year
      * period
      * date
     C                   PARM                    I#CCY             3
     C                   PARM                    I#YR              2 0
     C                   PARM                    I#PR              2 0
     C                   PARM                    I#DATE            5 0
     C                   PARM                    GPHHOX
 
      * Use input fields
 
     C                   MOVEL     I#CCY         GCCYCD
     C     I#DATE        IFNE      *ZERO
     C                   EXSR      CONVERT_DATE
     C                   Z-ADD     Year          GCYR
     C                   Z-ADD     Period        GCMTH
     C                   ELSE
     C                   Z-ADD     I#YR          GCYR
     C                   Z-ADD     I#PR          GCMTH
     C                   ENDIF
 
      * If currency is head-office currency
      *  pass back a rate of 1
 
     C     GCCYCD        IFEQ      GLHOCY
     C                   Z-ADD     1             GCSPRT
     C                   MOVE      'M'           GCMDIN
     C                   ELSE
 
      * If the rate was previously accessed,
      * use that rate details
 
     C                   Z-ADD     1             @IX               6 0
     C     CYDT          LOOKUP    #_CYDT(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_RATEDT(@IX) GPHHOX
     C                   ELSE
 
      * Access the rate
 
     C                   Z-ADD     0             GCSPRT
     C                   MOVE      'M'           GCMDIN
 
     C     HHOXK         CHAIN     GPHHOXL2                           99
 
      * If not found, get the rate prior to this date
 
     C     *in99         IFEQ      '1'
     C     HHOXK         SETLL     GPHHOXL2
     C     HHOXKP        READE     GPHHOXL2                               99
     C                   ENDIF
 
      * Save the rate details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_CYDT(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     CYDT          #_CYDT(@IX)
     C                   MOVEL     GPHHOX        #_RATEDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     CYDT          #_CYDT(@CIX)
     C                   MOVEL     GPHHOX        #_RATEDT(@CIX)
     C     @CIX          IFEQ      MaxNoRats
     C                   Z-ADD     *ZERO         @CIX
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      * Return
 
     C                   RETURN
     C/SPACE 5
      ********************************************************************
     C     CONVERT_DATE  BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM      I#DATE        ZDAYNO            5 0
     C                   PARM      'M'           ZDATFM            1
     C                   PARM      *ZERO         ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   MOVEL     ZDATE         Period            2 0
     C                   MOVE      ZDATE         Year              2 0
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   Z-ADD     *ZERO         @CIX              6 0
      *
     C     HHOXKP        KLIST
     C                   KFLD                    GCCYCD
     C     HHOXK         KLIST
     C                   KFLD                    GCCYCD
     C                   KFLD                    GCYR
     C                   KFLD                    GCMTH
      *
 
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
