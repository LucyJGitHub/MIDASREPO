     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Private Banking migration - SDTOBSPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00022 - Migrate SDTOBSPD                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD061008           Date 31Dec21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 CSM001 *C *CREATE  Date 14Oct02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD061008 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Deliveru of upgrade programs to core.              *
      *          - Renamed program CPBMIG05.                          *
      *  CSM001  - Upgrade of Private Banking layer.                  *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       30      Chain to SDFCTL failed
      *       69      Read, write or chain fail
      *
     FSMPBBRPD  IF   E             DISK    INFSR(*PSSR)
     FPBTOBSPD  O    E             DISK    INFSR(*PSSR)
     F*SDFCTLL0* UF   E           K DISK    INFSR(*PSSR)                                    MD061008
      *
      /EJECT
     D File            S             10    INZ('PBTOBSPD')
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
     C                   Z-ADD     0             Total             5 0
      *  Call Access Object for bank details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     1             SETLL     SMPBBRPD
     C                   READ      SMPBBRPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      *
     C                   MOVEL     'I'           AOTYLC
     C                   Z-ADD     BJRDNB        AOLCD
     C                   WRITE     PBTOBSD0                             69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ADD       1             Total
      *
     C     READ_NEXT     TAG
      *
     C                   READ      SMPBBRPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Update trailer
     C*****'PBTOBSPD  '  CHAIN     @AHREAU                            3069                  MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*RTV'        ZMODE             4                        MD061008
     C                   PARM      'PBTOBSPD'    AHFLNM           10                        MD061008
     C                   PARM      0             AHNORC            5 0                      MD061008
     C                   PARM      0             AHNOIN            5 0                      MD061008
     C                   PARM      0             AHNOAM            5 0                      MD061008
     C                   PARM      0             AHNODL            5 0                      MD061008
     C                   PARM      *BLANKS       ZRETRN           10                        MD061008
      *                                                                                     MD061008
     C                   SETOFF                                       3069                  MD061008
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061008
     C                   SETON                                        30                    MD061008
     C                   ENDIF                                                              MD061008
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061008
     C                   SETON                                        69                    MD061008
     C                   ENDIF                                                              MD061008
      *                                                                                     MD061008
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C     *IN30         IFEQ      *OFF
     C                   Z-ADD     Total         AHNORC
     C                   Z-ADD     Total         AHNOIN
     C**********         UPDATE    @AHREAU                              69                  MD061008
     C                   CALL      'SD000119'                                               MD061008
     C                   PARM      '*UPD'        ZMODE                                      MD061008
     C                   PARM                    AHFLNM                                     MD061008
     C                   PARM                    AHNORC                                     MD061008
     C                   PARM                    AHNOIN                                     MD061008
     C                   PARM                    AHNOAM                                     MD061008
     C                   PARM                    AHNODL                                     MD061008
     C                   PARM      *BLANKS       ZRETRN                                     MD061008
                                                                                            MD061008
     C                   SETOFF                                       69                    MD061008
     C     ZRETRN        IFNE      *BLANKS                                                  MD061008
     C                   SETON                                        69                    MD061008
     C                   ENDIF                                                              MD061008
                                                                                            MD061008
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
