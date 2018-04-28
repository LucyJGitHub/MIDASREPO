     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Init. the Modulus 10 field on SDBANKPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00105 - Upgrade Bank ICD File with Modulus 10 Value.      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 26Jan10               *
      *  Prev Amend No. R10.6/xx           Date 29Feb96               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG26993  - Delivery of upgrade programs to core.             *
      *           - Renamed program X.6P0701.                         *
      *  R10.6/xx - Initialise the Modulus 10 field on SDBANKPD       *
      *                                                               *
      *****************************************************************
     FSDBANKPD  UF   E             DISK
      *
     C                   READ      SDBANKPD                               01
     C                   MOVE      'Y'           BJMODT
     C                   UPDATE    SDBANKD0
      *
     C                   SETON                                        LR
     C                   RETURN
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
