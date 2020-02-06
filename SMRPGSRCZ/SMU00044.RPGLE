     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Private Banking migration - MUSERX0')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00044 - Migrate MUSERX0                                   *
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
      *          - Renamed program CPBMIG32.                          *
      *  CSM001  - Upgrade of Private Banking layer.                  *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       30      Chain MUSER - record not found
      *       69      Read, write or chain fail
      *
     FSMPBMUPD  IF   E             DISK    INFSR(*PSSR)
     FMUSER     UF   E           K DISK    INFSR(*PSSR)
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
     ISMPBMUD0
     I              ALACOD                      XALACOD
     I              USRLVL                      XUSRLVL
     I              REFUSR                      XREFUSR
      *  Call Access Object for bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     1             SETLL     SMPBMUPD
     C                   READ      SMPBMUPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      *
      * Update MUSER, if record found.
     C     USRP          CHAIN     MUSERDDF                           3069
     C     *IN30         IFEQ      *OFF
     C     ALACOD        IFEQ      ' '
     C     ALACOD        OREQ      'N'
     C     XALACOD       ANDNE     ' '
     C                   MOVEL     XALACOD       XALACOD
     C                   MOVEL     'Y'           UPDATE            1
     C                   ENDIF
      *
     C     USRLVL        IFEQ      ' '
     C     USRLVL        OREQ      'N'
     C     XUSRLVL       ANDNE     ' '
     C     XUSRLVL       IFEQ      'Z'
     C                   MOVEL     'V'           USRLVL
     C                   ELSE
     C                   MOVE      XUSRLVL       USRLVL
     C                   ENDIF
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
      *
     C     REFUSR        IFEQ      ' '
     C     XREFUSR       ANDNE     ' '
     C                   MOVEL     XREFUSR       REFUSR
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
      *
     C     UPDATE        IFEQ      'Y'
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVEL     'A'           CHTP
     C                   TIME                    LCTN              6 0
     C                   Z-ADD     LCTN          LCT
     C                   UPDATE    MUSERDDF                             69
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
     C                   READ      SMPBMUPD                             6920
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
