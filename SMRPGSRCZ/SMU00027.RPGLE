     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Private Banking migration - SDCURRXT')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00027 - Migrate SDCURRXT                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 CSM001 *C *CREATE  Date 14Oct02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CPBMIG10.                          *
      *  CSM001  - Upgrade of Private Banking layer.                  *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       30      Chain SDCURR - record not found
      *       40      Chain to SDFCTL failed
      *       69      Read, write or chain fail
      *
     FSMPBCYPD  IF   E             DISK    INFSR(*PSSR)
     FSDCURRL0  UF   E           K DISK    INFSR(*PSSR)
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
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
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Access to bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     C                   Z-ADD     0             Amends            5 0
      *  Call Access Object for bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     1             SETLL     SMPBCYPD
     C                   READ      SMPBCYPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      *
      * Update SDCURRPD, if record found.
     C     TACYCD        CHAIN     @A6REA4                            3069
     C     *IN30         IFEQ      *OFF
     C     A6CYPI        IFEQ      ' '
     C     A6CYPI        OREQ      'N'
     C     TACYPI        ANDNE     ' '
     C                   MOVEL     TACYPI        A6CYPI
     C                   MOVEL     'Y'           UPDATE            1
     C                   ENDIF
     C     A6EXWC        IFEQ      0
     C     TACYWC        ANDNE     0
     C                   Z-ADD     TACYWC        A6EXWC
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     A6POWC        IFEQ      0
     C     TACYWC        ANDNE     0
     C                   Z-ADD     TACYWC        A6POWC
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     A6CYD1        IFEQ      0
     C     TACYD1        ANDNE     0
     C                   Z-ADD     TACYD1        A6CYD1
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     A6CYD2        IFEQ      0
     C     TACYD2        ANDNE     0
     C                   Z-ADD     TACYD2        A6CYD2
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     A6CYD3        IFEQ      0
     C     TACYD3        ANDNE     0
     C                   Z-ADD     TACYD3        A6CYD3
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     A6CYLD        IFEQ      ' '
     C     A6CYLD        OREQ      'N'
     C     TACYLD        ANDNE     ' '
     C                   MOVEL     TACYLD        A6CYLD
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     A6CYGR        IFEQ      ' '
     C     TACYGR        ANDNE     ' '
     C                   MOVEL     TACYGR        A6CYGR
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     A6RENO        IFEQ      0
     C     TARENO        ANDNE     0
     C                   Z-ADD     TARENO        A6RENO
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
      *
      * Only update file if any fields have been updated.
     C     UPDATE        IFEQ      'Y'
     C                   Z-ADD     BJRDNB        A6LCD
     C                   MOVEL     'A'           A6TYLC
     C                   UPDATE    @A6REA4                              69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ADD       1             Amends
     C                   MOVEL     ' '           UPDATE
     C                   ENDIF
      *
     C                   ELSE
     C                   SETOFF                                       30
     C                   ENDIF
      *
     C     READ_NEXT     TAG
      *
     C                   READ      SMPBCYPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Update trailer
     C     'SDCURRPD  '  CHAIN     @AHREAU                            4069
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C     *IN40         IFEQ      *OFF
     C                   ADD       Amends        AHNOAM
     C                   UPDATE    @AHREAU                              69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
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
