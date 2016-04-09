     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP Housekeeping')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GP210000 - Housekeeping                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG4926 *CREATE    Date 18Nov04               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  BUG4926 - Global House-Keeping                               *
      *                                                               *
      *****************************************************************
     FGPHSEKPD  IF A E           K DISK    INFSR(*PSSR)
 
     C                   MOVEL     I#ZONE        HKZONE
     C                   MOVE      I#MRDT        HKMONY
     C                   WRITE     GPHSEKD0
 
      * The first zone to write a record to GPHSEKPD
      * is the zone that is given the job of doing the house-keeping
 
     C     HKMONY        SETLL     GPHSEKD0
     C     HKMONY        READE     GPHSEKD0                               99    *
     C     HKZONE        IFEQ      I#ZONE
     C                   MOVEL     'Y'           O#PROC
     C                   ELSE
     C                   MOVEL     'N'           O#PROC
     C                   ENDIF
 
     C                   SETON                                        LR
     C                   RETURN
 
      ************************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#MRDT            7
 
     C                   PARM                    O#PROC            1
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
