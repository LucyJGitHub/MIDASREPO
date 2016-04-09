     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Initialise PMPCAAPD QSACCU field')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00055  - Initialise QSACCU on PMPCAAPD                    *
      *                                                               *
      *  Function:  This program initialises a blank PMPCCA to QSCNUM *
      *             the Portfolio Customer                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 26Jan10               *
      *  Prev Amend No. CPM004             Date 25MAR96               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CPM00401.                          *
      *  CPM004  - PM Bank Portfolios                                 *
      *                                                               *
      *****************************************************************
      /EJECT
     FPMPCAAPD  UP   E             DISK
      *
      * Initialise Type of Portfolio Supported to C
      *
     C     QSACCU        IFEQ      *BLANKS
     C                   MOVEL     QSCNUM        QSACCU
     C                   EXCEPT    UPDPCA
     C                   ENDIF
      *
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
     OPMPCAAP0  E            UPDPCA
     O                       QSACCU
