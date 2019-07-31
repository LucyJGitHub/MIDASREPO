     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas Bridge Correct invalid data in SDCUSTPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00100 - Find records in SDCUSTPD that have invalid data   *
      *             for fields BBAGNP, BBDFAC and BBDFAS.             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 202195 *C *CREATE  Date 01Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S208962R01.                        *
      *  202195  - Update fields BBAGNP, BBDFAC and  BBDFAS if data   *
      *            is blank.                                          *
      *                                                               *
      *****************************************************************
     FSDCUSTPD  UF   E             DISK    INFSR(*PSSR)
     F/EJECT
      *****************************************************************
      *                                                               *
      *  Indicators                                                   *
      *                                                               *
      *  30      Update required                                      *
      *  40      Last record on SDCUSTPD                              *
      *                                                               *
      *****************************************************************
     D/EJECT
      *
      * Read records in SDCUSTPD
     C     1             SETLL     SDCUSTPD
     C                   READ      SDCUSTPD                             6940
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN40         DOUEQ     '1'
      *
      * Check for zero BBAGNP, BBDFAC and BBDFAS.
     C     BBAGNP        IFEQ      0
     C                   Z-ADD     0             BBAGNP
     C                   SETON                                        30
     C                   ENDIF
      *
     C     BBDFAC        IFEQ      0
     C                   Z-ADD     0             BBDFAC
     C                   SETON                                        30
     C                   ENDIF
      *
     C     BBDFAS        IFEQ      0
     C                   Z-ADD     0             BBDFAS
     C                   SETON                                        30
     C                   ENDIF
      *
     C     *IN30         IFEQ      *ON
     C                   UPDATE    SDCUSTD0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   SETOFF                                       30
     C                   ENDIF
      *
     C                   READ      SDCUSTPD                             6940
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
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
      *
      ********************************************************************
