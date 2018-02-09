     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Access Global Customer Report Name')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPACSCRNM -  Access Global Customer Report Name              *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
     FGZSDCUSTL1IF   E           K DISK    INFSR(*PSSR)
 
      * Maximum number of customers
     D MaxNoCsts       C                   CONST(2000)
 
      * Customers
     D #_CUST          S             13    DIM(MaxNoCsts)
      * Customer Details
     D #_CUSTDT        S             20    DIM(MaxNoCsts)
 
      * Customer Details
     D GZSDCUST      E DS                  EXTNAME(GZSDCUSTPD)
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * branch of customer
      * customer
     C                   PARM                    I#BRCD            3
     C                   PARM                    I#CUST           10
 
     C                   PARM                    CustRepName      20
 
      * Use input fields
 
     C                   MOVEL     I#BRCD        BBBRCD
     C                   MOVEL     I#CUST        BBCUST
 
     C                   MOVEL     I#BRCD        BrcdCustomer     13
     C                   MOVE      I#CUST        BrcdCustomer
 
      * If no customer is supplied
      * pass back a blank customer report name
 
     C     BBCUST        IFEQ      *BLANK
     C                   MOVEL     *BLANK        CustRepName
     C                   ELSE
 
      * If the customer was previously accessed,
      * use that customer's details
 
     C                   Z-ADD     1             @IX               6 0
     C     BrcdCustomer  LOOKUP    #_CUST(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     #_CUSTDT(@IX) CustRepName
     C                   ELSE
 
      * Access the customer
 
     C     CUSTK         CHAIN     SDCUSTD0                           99        *
 
      * If the customer was not found pass back blank details
 
     C     *in99         IFEQ      '1'
     C                   MOVEL     *BLANK        BBCRNM
     C                   ENDIF
 
     C                   MOVEL     BBCRNM        CustRepName
 
      * Save the customer's details
 
     C                   Z-ADD     1             @IX
     C     *BLANK        LOOKUP    #_CUST(@IX)                            99    *
     C     *in99         IFEQ      '1'
     C                   MOVEL     BrcdCustomer  #_CUST(@IX)
     C                   MOVEL     CustRepName   #_CUSTDT(@IX)
     C                   ELSE
     C                   ADD       1             @CIX
     C                   MOVEL     BrcdCustomer  #_CUST(@CIX)
     C                   MOVEL     CustRepName   #_CUSTDT(@CIX)
     C     @CIX          IFEQ      MaxNoCsts
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
 
     C     CUSTK         KLIST
     C                   KFLD                    BBBRCD
     C                   KFLD                    BBCUST
 
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
