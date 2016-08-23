     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Initialise SDPORTPD FCPORS field')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00056  - Initialise FCPORS on SDPORTPD                    *
      *                                                               *
      *  Function:  This program initialises a blank FCPORS to "C"    *
      *             to indicate Private Customer Portfoios            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 26Jan10               *
      *  Last Amend No. CPM004             Date 25Mar96               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Rename program CPM00402.                           *
      *  CPM004  - PM Bank Portfolios                                 *
      *                                                               *
      *****************************************************************
      /EJECT
     FSDPORTPD  UP   E             DISK
      *
      * Initialise Type of Portfolio Supported to C
      *
     C     FCPORS        IFEQ      *BLANKS
     C                   MOVEL     'C'           FCPORS
     C                   EXCEPT    UPDPRT
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
     OSDPORTD0  E            UPDPRT
     O                       FCPORS
