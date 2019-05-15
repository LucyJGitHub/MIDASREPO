     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CB Set status to blank')
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business module                             *
      *                                                               *
      *  CB000028 - Set status to blank                               *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK018 *CREATE     Date 21Feb04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK018 - MidasPlus packaging.  Additional CoB validation.    *
      *                                                               *
      *****************************************************************
      *  Function of indicators
      *
      *       69      Error on file access
      *       80      End of file indicator
      *****************************************************************
     FCBCMPNPD  UF   E             DISK    INFSR(*PSSR)
      *
      *
     C     1             SETLL     CBCMPNPD
     C                   READ      CBCMPNPD                             6980
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN80         DOWNE     *ON
      *
      * Set status to blank unless component is COBBEGIN.
     C     DHCOTT        IFNE      'COBBEGIN'
     C                   EVAL      DHCSTS = ' '
     C                   ENDIF
      *
     C                   UPDATE    CBCMPND0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      CBCMPNPD                             6980
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDDO
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
