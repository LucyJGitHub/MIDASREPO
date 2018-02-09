     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update previous run date on JNSTAT')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000004 - Update previous run date on JNSTAT                *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CUP037 *CREATE     Date 03Apr07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP037 - Additional change to update of JNSTAT.              *
      *                                                               *
      *****************************************************************
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
      *
     D Recursive       S              1    INZ('N')
      *
      * Data Structure for JNSTAT
     D JNSTAT        E DS                  EXTNAME(JNSTAT) DTAARA(JNSTAT)
      *
     C     *LOCK         IN        JNSTAT
      *
      * Get rundate from SDBANKPD.
     C     1             SETLL     SDBANKPD
     C                   READ      SDBANKPD
     C                   IF        %EOF
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PRUN = BJRDNB - 1
     C                   ENDIF
      *
      * Update JNSTAT.
     C                   OUT       JNSTAT
     C                   UNLOCK    JNSTAT
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = 'N'
     C                   EVAL      Recursive = 'Y'
     C                   SETON                                        U7U8
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
