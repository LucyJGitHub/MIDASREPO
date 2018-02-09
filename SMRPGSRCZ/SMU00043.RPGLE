     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Private Banking migration - SEVATCPP')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00043 - Migrate SEVATCPP                                  *
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
      *          - Renamed program CPBMIG31.                          *
      *  CSM001  - Upgrade of Private Banking layer.                  *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       40      Chain to SDFCTL failed
      *       69      Read, write or chain fail
      *
     FSMPBVCPD  IF   E             DISK    INFSR(*PSSR)
     FSDVATCPD  O    E             DISK    INFSR(*PSSR)
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
      *
      /EJECT
     D File            S             10    INZ('SDVATCPD')
     D Member          S             10    INZ('*FIRST')
     D Records         S              1
      *
     D PSDS           SDS
      *
      * Program Status Data Structure.
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * Access to bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     ISMPBVCD0
     I              F9VATC                      VATC
      *
      * Check if 'to' file already has records.
     C                   CALL      'SMUC00013'
     C                   PARM                    File
     C                   PARM                    Member
     C                   PARM                    Records
     C                   IF        Records = 'Y'
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   Z-ADD     0             Inserts           5 0
      *  Call Access Object for bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     1             SETLL     SMPBVCPD
     C                   READ      SMPBVCPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      *
     C                   Z-ADD     VATC          VATCN             2 0
     C                   MOVEL     VATCN         F9VATC
     C                   Z-ADD     BJRDNB        F9LCD
     C                   MOVEL     'I'           F9CHTP
     C                   TIME                    F9LCTM
     C                   WRITE     SDVATCD0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ADD       1             Inserts
      *
     C     READ_NEXT     TAG
      *
     C                   READ      SMPBVCPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Update trailer
     C     'SDVATCPD  '  CHAIN     @AHREAU                            4069
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C     *IN40         IFEQ      *OFF
     C                   ADD       Inserts       AHNORC
     C                   ADD       Inserts       AHNOIN
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
