     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP GPULOGPD Housekeeping')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GP210050 - GPULOGPD Housekeeping                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG4926  *CREATE   Date 18Nov04               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG4926 - Global House-Keeping                               *
      *                                                               *
      *****************************************************************
     FGPULOGPD  UP   E             DISK    INFSR(*PSSR)
 
      * Delete all records from GPULOGPD
 
     C                   DELETE    GPULOGD0
 
      ************************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
