     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Private Banking migration - SDPBDSPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00018 - Migrate SDPBDSPD                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD061007           Date 31Dec21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 CSM001 *C *CREATE  Date 14Oct02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD061007 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CPBMIG01.                          *
      *  CSM001  - Upgrade of Private Banking layer.                  *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       30      Chain - record not found
      *       40      Chain to SDFCTL failed
      *       69      Read, write or chain fail
      *
     FSMPBPDPD  IF   E             DISK    INFSR(*PSSR)
     FSDCUSTL0  UF   E           K DISK    INFSR(*PSSR)
     F*SDFCTLL0* UF   E           K DISK    INFSR(*PSSR)                                    MD061007
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
     D QSDFC1          DS                                                                   MD061007
     D  AHFLNM                 1     10                                                     MD061007
     D  AHNORC                11     13P 0                                                  MD061007
     D  AHNOIN                14     16P 0                                                  MD061007
     D  AHNOAM                17     19P 0                                                  MD061007
     D  AHNODL                20     22P 0                                                  MD061007
                                                                                            MD061007
      *
     C                   Z-ADD     0             Amends            5 0
      *
     C     1             SETLL     SMPBPDPD
     C                   READ      SMPBPDPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      * Check if fields have value to be migrated
     C     PBCLST        IFEQ      ' '
     C     PBCLDT        ANDEQ     0
     C                   GOTO      READ_NEXT
     C                   ENDIF
      *
     C                   MOVEL     PBCNUM        CNUM_A            6
     C     CNUM_A        CHAIN     @BBREBG                            3069
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * If record found then update fields if they do not already have value
     C     *IN30         IFEQ      *OFF
     C     BBCLST        IFEQ      ' '
     C                   MOVEL     PBCLST        BBCLST
     C                   MOVEL     'Y'           UPDATE            1
     C                   ENDIF
     C     BBCLDT        IFEQ      0
     C                   Z-ADD     PBCLDT        BBCLDT
     C                   MOVEL     'Y'           UPDATE
     C                   ENDIF
     C     UPDATE        IFEQ      'Y'
     C                   UPDATE    @BBREBG                              69
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
     C                   READ      SMPBPDPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Update trailer
     C*****'SDCUSTPD  '  CHAIN     @AHREAU                            4069                  MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM      'SDCUSTPD'    AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       4069                  MD061007
     C     ZRETRN        IFEQ      '*NRF'                                                   MD061007
     C                   SETON                                        40                    MD061007
     C                   ENDIF                                                              MD061007
     C     ZRETRN        IFEQ      '*ERROR'                                                 MD061007
     C                   SETON                                        69                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C     *IN40         IFEQ      *OFF
     C                   ADD       Amends        AHNOAM
     C**********         UPDATE    @AHREAU                              69                  MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*UPD'        ZMODE                                      MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM                    AHNORC                                     MD061007
     C                   PARM                    AHNOIN                                     MD061007
     C                   PARM                    AHNOAM                                     MD061007
     C                   PARM                    AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN                                     MD061007
                                                                                            MD061007
     C                   SETOFF                                       69                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        69                    MD061007
     C                   ENDIF                                                              MD061007
                                                                                            MD061007
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
