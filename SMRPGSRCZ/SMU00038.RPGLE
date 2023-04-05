     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Private Banking migration - SDACODPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00038 - Migrate SDACODPD                                  *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD061007           Date 31Dec21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 27Jan10               *
      *                 CSM001 *C *CREATE  Date 14Oct02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD061007 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CPBMIG24.                          *
      *  CSM001  - Upgrade of Private Banking layer.                  *
      *                                                               *
      *****************************************************************
      * Function of indicators
      *
      *       20      End of file
      *       30      Chain SMPBAC2 - record not found
      *       40      Chain to SDFCTL failed
      *       69      Read, write or chain fail
      *
     FSMPBACPD  IF   E             DISK    INFSR(*PSSR)
     FSMPBAC2PD UF   E           K DISK    INFSR(*PSSR) PREFIX(X)
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
     C     1             SETLL     SMPBACPD
     C                   READ      SMPBACPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN20         DOWEQ     '0'
      *
      * Update 'to' file, if record found.
     C     A5ACCD        CHAIN     SMPBAC2D0                          3069
     C     *IN30         IFEQ      *OFF
     C     XA5TRAN       IFEQ      ' '
     C     A5TRAN        ANDNE     ' '
     C                   MOVEL     A5TRAN        XA5TRAN
     C                   Z-ADD     BJRDNB        XA5LCD
     C                   MOVEL     'A'           XA5TYLC
     C                   UPDATE    SMPBAC2D0                            69
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ADD       1             Amends
     C                   ENDIF
      *
     C                   ELSE
     C                   SETOFF                                       30
     C                   ENDIF
      *
     C     READ_NEXT     TAG
      *
     C                   READ      SMPBACPD                             6920
     C     *IN69         IFEQ      *ON
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Update trailer
     C*****'SDACODPD  '  CHAIN     @AHREAU                            4069                  MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM      'SDACODPD'    AHFLNM           10                        MD061007
     C                   PARM      0             AHNORC            5 0                      MD061007
     C                   PARM      0             AHNOIN            5 0                      MD061007
     C                   PARM      0             AHNOAM            5 0                      MD061007
     C                   PARM      0             AHNODL            5 0                      MD061007
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
