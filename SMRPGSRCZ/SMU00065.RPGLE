     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Populate SESECSQD file from SDCUSTPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00065 - Populate SESECSQD file from SDCUSTPD              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No.BG26993             Date 26Jan10               *
      *  Prev Amend No.BUG16570*CREATE     Date 06Mar08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG26993  - Delivery of upgrade programs to core.             *
      *           - Renamed program S016570R01.                       *
      *  BUG16570 - Could not find record where SECUSN=Customer       *
      *             number is a primary key                           *
      *****************************************************************
     FSDCUSTL1  IF   E           K DISK
     FSMU003L0  UF A E           K DISK
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   90  - Access SDCUSTL1                                       *
      *   91  - Check record in SMU003L0                              *
      *                                                               *
      *****************************************************************
      *
     C     *LOVAL        SETLL     @BBREBF
     C                   READ      @BBREBF                                90
     C     *IN90         DOWEQ     *OFF
     C     BBCUST        CHAIN     SESECSD0                           91
     C     *IN91         IFEQ      *ON
     C                   MOVE      BBCUST        SECUSN
     C                   MOVE      *BLANK        SEFRID
     C                   WRITE     SESECSD0
     C                   ENDIF
      *
     C                   READ      @BBREBF                                90
     C                   ENDDO
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      * Check to see that *PSSR has not already been called.
     C     *INLR         IFNE      *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
