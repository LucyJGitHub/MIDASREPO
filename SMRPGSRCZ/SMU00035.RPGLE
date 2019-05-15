     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Private Banking migration - FFIOTCPPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00035 - Migrate FFIOTCPPD                                 *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 27Jan10               *
      *                 CSM001 *C *CREATE  Date 14Oct02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CPBMIG19.                          *
      *  CSM001  - Upgrade of Private Banking layer.                  *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       30      Chain FFIOTC - record not found
      *       69      Read, write or chain fail
      *
     FSMPBIOPD  IF   E             DISK    INFSR(*PSSR)
     FFFIOTCCL1 UF   E           K DISK    INFSR(*PSSR)  PREFIX(X)
      *
      /EJECT
      *
     D PSDS           SDS
      *
      * Program Status Data Structure.
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      *
     C     1             SETLL     SMPBIOPD
     C                   READ      SMPBIOPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      *
      * Update FFIOTCCPD, if record found.
     C     SPFOTRANID    CHAIN     FFIOTCCL1                          3069
     C     *IN30         IFEQ      *OFF
     C     XSCOVE        IFEQ      ' '
     C     SCOVE         ANDNE     ' '
     C                   MOVEL     SCOVE         XSCOVE
     C                   MOVEL     'Y'           UPDATE            1
     C                   ENDIF
     C     XSHETR        IFEQ      ' '
     C     SHETR         ANDNE     ' '
     C                   MOVEL     SHETR         XSHETR
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     XSBLUP        IFEQ      ' '
     C     SBLUP         ANDNE     ' '
     C                   MOVEL     SBLUP         XSBLUP
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     XSUNSE        IFEQ      ' '
     C     SUNSE         ANDNE     ' '
     C                   MOVEL     SUNSE         XSUNSE
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     XSTECO        IFEQ      ' '
     C     SECOS         ANDNE     ' '
     C                   MOVEL     SECOS         XSTECO
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     XSTNAT        IFEQ      ' '
     C     SNATU         ANDNE     ' '
     C                   MOVEL     SNATU         XSTNAT
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     XSCRIK        IFEQ      ' '
     C     SCRIK         ANDNE     ' '
     C                   MOVEL     SCRIK         XSCRIK
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     XSCCYR        IFEQ      ' '
     C     SCCYR         ANDNE     ' '
     C                   MOVEL     SCCYR         XSCCYR
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     XSTWEI        IFEQ      ' '
     C     SWEIG         ANDNE     ' '
     C                   MOVEL     SWEIG         XSTWEI
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
      *
      * Only update file if any fields have been updated.
     C     UPDATE        IFEQ      'Y'
     C                   UPDATE    FFIOTCCD0                            69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     ' '           UPDATE
     C                   ENDIF
      *
     C                   ELSE
     C                   SETOFF                                       30
     C                   ENDIF
      *
     C     READ_NEXT     TAG
      *
     C                   READ      SMPBIOPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
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
      *
      ********************************************************************
