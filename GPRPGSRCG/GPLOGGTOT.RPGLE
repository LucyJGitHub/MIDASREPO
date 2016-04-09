     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Log global totals')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPLOGGTOT - Log Global Totals                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPSBLOGL0 UF A E           K DISK    INFSR(*PSSR)
 
 
      * Program Status Data Structure
     D/COPY GPCPYSRCG,PSDS
 
 
      * Write overall totals
     C                   MOVEL     '***'         BSBRCA
     C                   Z-SUB     I#NRCD        BSCNTW
     C                   Z-ADD     0             BSCNTD
     C                   Z-ADD     0             BSCNTU
      *
     C                   EVAL      BSDATE = PSRunDateA
     C                   EVAL      BSJOB  = PSJobName
     C                   EVAL      BSUSER = PSUser
     C                   EVAL      BSJOBN = PSJobNoA
 
     C                   WRITE     GPSBLOGD0
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#FILE           10
     C                   PARM                    I#NRCD           10 0
 
     C                   MOVE      *BLANK        I#RTCD            7
     C                   MOVE      *BLANK        I#ERMS           50
 
      * Delete existing log records
 
     C                   EVAL      BSFILE = I#FILE
     C                   EVAL      BSZONE = '**GLOBAL**'
     C     GPSBLOGK      SETLL     GPSBLOGD0
     C     GPSBLOGK      READE     GPSBLOGD0                              99
     C     *IN99         DOWEQ     *OFF
     C                   DELETE    GPSBLOGD0
     C     GPSBLOGK      READE     GPSBLOGD0                              99
     C                   ENDDO
 
     C                   MOVEL     PSRunDate     PSRunDateA        6
     C                   MOVEL     PSJobNo       PSJobNoA          6
 
      * Key lists
 
     C     GPSBLOGK      KLIST
     C                   KFLD                    BSFILE
     C                   KFLD                    BSZONE
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
