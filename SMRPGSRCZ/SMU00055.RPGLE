     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
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
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 CPM004             Date 25Mar96               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
