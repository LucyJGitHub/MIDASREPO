     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Depot Movement File update')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00058 - Depot movements Trade Date initialisation         *
      *                                                               *
      *  Function: This program initialise trade date field for       *
      *            Depots movement file.                              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 CSE015  *CREATE    Date 17Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CSE01501.                          *
      *  CSE015  - Forward Valued Depot Movements                     *
      *                                                               *
      *****************************************************************
      *
     FDPTMVD    UF   E             DISK
      *
      /EJECT
      *****************************************************************
      *
     C                   MOVE      '0'           *IN21
     C     *IN21         DOWEQ     '0'
     C                   READ      DPTMVD                                 21
      *
     C     *IN21         IFEQ      '0'
     C                   Z-ADD     DPMD          DMTD
      *
     C     DMTD          IFEQ      0
     C     DMTD          ORGT      DPDO
     C     DPDO          ANDNE     0
     C                   Z-ADD     DPDO          DMTD
     C                   ENDIF
      *
     C                   UPDATE    DPTMVDF
     C                   ENDIF
      *
     C                   ENDDO
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
