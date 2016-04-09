     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GP GPUTCIPD Housekeeping')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GP210020 - GPUTCIPD Housekeeping                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. BUG4926 *CREATE    Date 18Nov04               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG4926 - Global House-Keeping                               *
      *                                                               *
      *****************************************************************
     FGPUTCIPD  IP   E           K DISK    INFSR(*PSSR)
     FGPWTRAPL1 IF   E           K DISK    INFSR(*PSSR)
     FGPUTCIL0  UF   E           K DISK    RENAME(GPUTCID0:GPUTCID1)
     F                                     INFSR(*PSSR)
 
      * Delete records from GPUTCIPD if
      * there are no records on GPWTRAPPD for their commiment id
 
     C     GPWTRAPK      KLIST
     C                   KFLD                    CICCID
     C     GPWTRAPK      SETLL     GOTRAPD0
     C     GPWTRAPK      READE     GOTRAPD0                               99
     C   99              EXSR      DELETE_ID
     C
      ************************************************************************
     C     DELETE_ID     BEGSR
     C     GPUTCIK       KLIST
     C                   KFLD                    CICCID
     C     GPUTCIK       SETLL     GPUTCID1
     C     GPUTCIK       READE     GPUTCID1                               99
     C     *IN99         DOWEQ     *OFF
     C                   DELETE    GPUTCID1
     C     GPUTCIK       READE     GPUTCID1                               99
     C                   ENDDO
     C                   ENDSR
      ***********************************************************************
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
