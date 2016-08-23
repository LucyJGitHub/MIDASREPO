     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Journal Receiver Chain Retrieval')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUJCRTL - Journal Receiver Chain Retrieval                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPAUJCL0  IF   E           K DISK    INFSR(*PSSR)
 
 
     C     GPAUJCK       SETLL     GPAUJCD0                                     *
     C     GPAUJCK       READE     GPAUJCD0                               99    *
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     JCRCV         O#RCV
     C                   MOVEL     JCCDAT        O#CDAT
     C                   Z-ADD     JCFENT        O#FENT
     C                   Z-ADD     JCTENT        O#TENT
     C                   Z-ADD     JCLENT        O#LENT
     C                   ELSE
     C                   MOVEL     *BLANK        O#RCV
     C                   MOVEL     *BLANK        O#CDAT
     C                   Z-ADD     *ZERO         O#FENT
     C                   Z-ADD     *ZERO         O#TENT
     C                   Z-ADD     *ZERO         O#LENT
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
      * INPUT
     C                   PARM                    I#ZONE           10
      * OUTPUT
     C                   PARM                    O#RCV            10
     C                   PARM                    O#CDAT            6
     C                   PARM                    O#FENT           10 0
     C                   PARM                    O#TENT           10 0
     C                   PARM                    O#LENT           10 0
 
     C* KEY LIST
 
     C     GPAUJCK       KLIST
     C                   KFLD                    I#ZONE
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
