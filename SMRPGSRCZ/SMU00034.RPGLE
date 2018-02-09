     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Private Banking migration - SEDPTRPP')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00034 - Migrate SEDPTRPP                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 27Jan10               *
      *                 CSM001 *C *CREATE  Date 14Oct02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CPBMIG17.                          *
      *  CSM001  - Upgrade of Private Banking layer.                  *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       69      Read, write or chain fail
      *
     FSMPBDTPD  IF   E             DISK    INFSR(*PSSR)
     FSEDPTRPD  O    E             DISK    INFSR(*PSSR)
      *
      /EJECT
     D File            S             10    INZ('SEDPTRPD')
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
     C     1             SETLL     SMPBDTPD
     C                   READ      SMPBDTPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      *
     C                   MOVEL     RECI          DTRECI
     C                   MOVEL     DTBR          DTDPBA
     C                   MOVEL     DTSS          DTDPSS
     C                   MOVEL     DTRN          DTDPRN
     C                   MOVEL     DTCN          DTCUBK
     C                   MOVEL     DTMK          DTDPMK
     C                   MOVEL     DTPT          DTPTFR
     C                   MOVE      DTID          DTDPID
     C                   Z-ADD     DTDI          DTDPMD
     C                   MOVE      DTOD          DTDPOD
     C                   Z-ADD     DTDO          DTDPDO
     C                   Z-ADD     DTNA          DTDPNA
     C                   MOVEL     DTNR          DTDPNR
     C                   Z-ADD     ORED          DTORED
     C                   Z-ADD     BJRDNB        DTLCD
     C                   MOVEL     'I'           DTCHTP
     C                   Z-ADD     TNLU          DTTNLU
     C                   WRITE     SEDPTRD0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     READ_NEXT     TAG
      *
     C                   READ      SMPBDTPD                             6920
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
