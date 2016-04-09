     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Private Banking migration - SECHRGPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00036 - Migrate SECHRGPD                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 26Jan10               *
      *  Prev Amend No. CSM001 *CREATE     Date 14Oct02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CPBMIG20.                          *
      *  CSM001  - Upgrade of Private Banking layer.                  *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       69      Read, write or chain fail
      *
     FSMPBFCPD  IF   E             DISK    INFSR(*PSSR)
     FGLCHRGPD  UF A E             DISK    INFSR(*PSSR)
      *
      /EJECT
     D File            S             10    INZ('GLCHRGPD')
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
     D OSEAC           DS
     D  O1                     1     12
     D  OACOD                 13     16
     D  O2                    17     18
     D NSEAC           DS
     D  N1                     1     12
     D  NACOD1                13     18
     D  NACOD2                19     22
     D  N2                    23     24
      *
     ISMPBFCD0
     I              CHSEAC                      XCHSEAC
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
      *  Call Access Object for bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     1             SETLL     SMPBFCPD
     C                   READ      SMPBFCPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      *
     C                   MOVEL     CHBRCH        CHBRCA
     C                   Z-ADD     BJRDNB        CHLCD
     C                   MOVEL     'I'           CHCHTP
     C                   IF        XCHSEAC <> *blanks
     C                   EVAL      OSEAC = XCHSEAC
     C                   EVAL      N1 = O1
     C                   EVAL      NACOD1 = '000000'
     C                   EVAL      NACOD2 = OACOD
     C                   EVAL      N2 = O2
     C                   EVAL      CHSEAC = NSEAC
     C                   ENDIF
     C                   WRITE     GLCHRGD0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   READ      SMPBFCPD                             6920
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
