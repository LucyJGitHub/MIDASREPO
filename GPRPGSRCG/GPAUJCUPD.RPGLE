     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Journal Receiver Chain Update')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUJCUPD - Journal Receiver Chain Update                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BG6098             Date 08Mar05               *
      *  Prev Amend No. CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG6098 - Job on message wait - should end instead            *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGZSDBANKL1IF   E           K DISK    INFSR(*PSSR)
     FGPAUJCPD  UF A E           K DISK    INFSR(*PSSR)
 
 
     C*****GPAUJCK       CHAIN     GPAUJCD0                           99        *             BG6098
     C     GPAUJCK       CHAIN     GPAUJCD0                           9998      *             BG6098
     C                   If        *IN98                                                      BG6098
     C                   ExSr      *PSSR                                                      BG6098
     C                   EndIf                                                                BG6098
     C     *IN99         IFEQ      *ON
     C                   MOVEL     I#ZONE        JCZONE
     C                   MOVEL     I#RCV         JCRCV
     C                   MOVEL     I#CDAT        JCCDAT
     C                   Z-ADD     I#FENT        JCFENT
     C                   Z-ADD     I#TENT        JCTENT
     C                   Z-ADD     I#LENT        JCLENT
     C                   Z-ADD     BJRDNB        JCRDNB
     C                   TIME                    TimeDate         12 0
     C                   MOVE      TimeDate      JCDATE
     C                   MOVEL     TimeDate      JCTIME
     C                   WRITE     GPAUJCD0
     C                   ELSE
     C                   Z-ADD     I#TENT        JCTENT
     C     I#UPDATL      IFEQ      'Y'
     C                   Z-ADD     I#LENT        JCLENT
     C                   ENDIF
     C                   TIME                    TimeDate
     C                   MOVE      TimeDate      JCDATE
     C                   MOVEL     TimeDate      JCTIME
     C                   UPDATE    GPAUJCD0
     C                   ENDIF
 
 
     C                   SETON                                        LR
     C                   RETURN
 
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * PARAMETER LIST
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#UPDATL          1
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#RCV            10
     C                   PARM                    I#CDAT            6
     C                   PARM                    I#FENT           10 0
     C                   PARM                    I#TENT           10 0
     C                   PARM                    I#LENT           10 0
 
 
     C* GET BANK DETAILS
 
     C     I#ZONE        CHAIN     SDBANKD0                           99        *
 
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'BAD ZONE:' + I#ZONE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C* KEY LIST
 
     C     GPAUJCK       KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    I#RCV
     C                   KFLD                    I#CDAT
     C                   KFLD                    I#FENT
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
