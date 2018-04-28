     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Private Banking migration - TOCYGRPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00020 - Migrate TOCYGRPD                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 24Jan10               *
      *  Prev Amend No. CSM001 *CREATE     Date 14Oct02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CPBMIG03.                          *
      *  CSM001  - Upgrade of Private Banking layer.                  *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       30      Chain to SDFCTL failed
      *       69      Read, write or chain fail
      *
     FSMPBCGPD  IF   E             DISK    INFSR(*PSSR)
     FPBCYGRPD  O    E             DISK    INFSR(*PSSR)
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
      *
      /EJECT
     D File            S             10    INZ('PBCYGRPD')
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
      * Check if 'to' file already has records.
     C                   CALL      'SMUC00013'
     C                   PARM      'PBCYGRPD'    File
     C                   PARM      '*FIRST'      Member
     C                   PARM                    Records
     C                   IF        Records = 'Y'
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   Z-ADD     0             Total             5 0
      *  Call Access Object for bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     1             SETLL     SMPBCGPD
     C                   READ      SMPBCGPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      *
     C                   MOVEL     'D'           GRRECI
     C                   MOVEL     'I'           GRTYLC
     C                   Z-ADD     BJRDNB        GRLCD
     C                   WRITE     PBCYGRD0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ADD       1             Total
      *
     C     READ_NEXT     TAG
      *
     C                   READ      SMPBCGPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Update trailer
     C     'PBCYGRPD  '  CHAIN     @AHREAU                            3069
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C     *IN30         IFEQ      *OFF
     C                   Z-ADD     Total         AHNORC
     C                   Z-ADD     Total         AHNOIN
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
