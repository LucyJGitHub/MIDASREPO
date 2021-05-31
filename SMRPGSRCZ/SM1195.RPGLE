     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Initialise SDFCTLPA and TABLETX details')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM1195 - Initialise file totals in SDFCTLPA / TABLETX        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD051696           Date 12Mar20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CUP016  *CREATE    Date 01Apr03               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051696 - File Out of Balance error on component SDC0602    *
      *             SD1420AU audit report under SDCMRKPD file         *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CUP016 - Add implementation software to core.                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicators                                                   *
      *                                                               *
      *  01 - End of file for SDFCTLPA                                *
      *  03 - API program call fail                                   *
      *  04 - End of file for SDCUSTPD                                *
      *  05 - End of file for SDREPCPD                                *
      *  06 - End of file for SDACRCPD                                *
      *  32 - Chain TABLETX failed                                    *
      *                                                               *
      *****************************************************************
     FSDFCTLPA  UF   E             DISK
     FTABLETXL  UF   E           K DISK
     FSDCUSTPD  IF   E             DISK
     FSDREPCPD  IF   E             DISK
     FSDACRCPD  IF   E             DISK
     FSDCMRKPD  IF   E             DISK                                                     MD051696
      *
      ** User space DS
     D INPUT           DS
     D  USRSPC                 1     20
     D  SPCNAM                 1     10
     D  SPCLIB                11     20
     D  OUTFMT                21     28
     D  FILLII                29     48
     D  FILNAI                29     38
     D  FILLBI                39     48
     D  RCDFMI                49     58
     D  OVRRID                59     59
     D  APIERR                60     63B 0
      *
      * Variable to hold list/entry size
     D                 DS
     D  LENDTA                 1      4B 0
     D  STRPOS                 5      8B 0
     D  LENSPC                 9     12B 0
     D  LENVAR                13     16B 0
     D  RCVLEN                17     20B 0
      *
      ** File details user space DS
     D RCVVAR          DS
     D  BYTRTN                 1      4B 0
     D  BYTVAL                 5      8B 0
     D  FILLIB                 9     28
     D  FILNAM                 9     18
     D  LIBNAM                19     28
     D  MBRNAM                29     38
     D  FILATR                39     48
     D  SRCTYP                49     58
     D  CRTDAT                59     71
     D  SRCCHG                72     84
     D  TEXT                  85    134
     D  SRCF                 135    135
     D  EXTF                 136    136
     D  LF                   137    137
     D  ODPSHR               138    138
     D  RESER1               139    140
     D  NBRRCD               141    144B 0
     D  DLTRCD               145    148B 0
     D  DSSIZ                149    152B 0
     D  ACPSIZ               153    156B 0
     D  NBRMBR               157    160B 0
     D  CHGDAT               161    173
     D  SAVDAT               174    186
     D  RSTDAT               187    199
     D  EXPDAT               200    212
     D  NBRDAY               213    216B 0
     D  LSTUSD               217    223
     D  RESDAT               224    230
      *
     D Recursive       S              1
      *
     C                   Z-ADD     0             APIERR
     C                   Z-ADD     230           RCVLEN
      *
      * Read first record from SDFCTLPA
     C                   READ      SDFCTLPA                               01
      *
      * Do for all records from SDFCTLPA
     C     *IN01         DOWEQ     '0'
      *
      * Get file details for SDFCTLPA
     C                   MOVEL     AHFLNM        FILNAI
     C                   MOVEL     '*LIBL'       FILLBI
     C                   EXSR      FILDTL
      *
      * If record exists
     C     FILNAI        IFEQ      FILNAM
     C     *IN03         ANDEQ     '0'
      *
      * Initialise number of records to actual number on file
      * on file, and set number of inserts, amends and deletes to
      * zero, then update SDFCTLPA record
     C                   Z-ADD     NBRRCD        AHNORC
     C                   Z-ADD     0             AHNOIN
     C                   Z-ADD     0             AHNOAM
     C                   Z-ADD     0             AHNODL
      *
      * If SDCUSTPD
     C     AHFLNM        IFEQ      'SDCUSTPD'
      * Calculate the no. of deleted records for SDCUSTPD
     C     1             SETLL     SDCUSTD0
     C                   READ      SDCUSTPD                               04
     C     *IN04         DOWNE     '1'
     C     BBTYLC        IFEQ      'D'
     C                   ADD       1             AHNODL
     C                   SUB       1             AHNORC
     C                   END
     C                   READ      SDCUSTPD                               04
     C                   END
     C                   END
      *
      * If SDREPCPD
     C     AHFLNM        IFEQ      'SDREPCPD'
      *
      * Calculate the no. of deleted records for SDREPCPD
     C     1             SETLL     SDREPCD0
     C                   READ      SDREPCPD                               05
     C     *IN05         DOWNE     '1'
     C     G4TYLC        IFEQ      'D'
     C                   ADD       1             AHNODL
     C                   END
     C                   READ      SDREPCPD                               05
     C                   END
     C                   END
      *
      * If SDACRCPD
     C     AHFLNM        IFEQ      'SDACRCPD'
      *
      * Calculate the no. of deleted records for SDACRCPD
     C     1             SETLL     SDACRCD0
     C                   READ      SDACRCPD                               06
     C     *IN06         DOWNE     '1'
     C     G6TYLC        IFEQ      'D'
     C                   ADD       1             AHNODL
     C                   END
     C                   READ      SDACRCPD                               06
     C                   END
     C                   END
      *                                                                                     MD051696
      ** If SDCMRKPD                                                                        MD051696
     C     AHFLNM        IFEQ      'SDCMRKPD'                                               MD051696
      *                                                                                     MD051696
      ** Calculate the no. of deleted records for SDCMRKPD                                  MD051696
     C     1             SETLL     SDCMRKD0                                                 MD051696
     C                   READ      SDCMRKD0                               07                MD051696
     C     *IN07         DOWNE     '1'                                                      MD051696
     C     D7TYLC        IFEQ      'D'                                                      MD051696
     C                   ADD       1             AHNODL                                     MD051696
     C                   SUB       1             AHNORC                                     MD051696
     C                   END                                                                MD051696
     C                   READ      SDCMRKD0                               07                MD051696
     C                   END                                                                MD051696
     C                   END                                                                MD051696
      *
      * Update Table files Trailer (TABLETX) for Narrative Codes.
      *
     C     AHFLNM        IFEQ      'SDNARRPD'
     C     '90'          CHAIN     TABLETXF                           32
     C                   Z-ADD     NBRRCD        NREC
     C                   Z-ADD     0             NINS
     C                   Z-ADD     0             NAMD
     C                   Z-ADD     0             NDEL
     C                   UPDATE    TABLETXF                             32
     C                   END
      *
      ** Update Table files Trailer (TABLETX) for Transaction Types.
      *
     C     AHFLNM        IFEQ      'SDRETRPD'
     C     '41'          CHAIN     TABLETXF                           32
     C                   Z-ADD     NBRRCD        NREC
     C                   Z-ADD     0             NINS
     C                   Z-ADD     0             NAMD
     C                   Z-ADD     0             NDEL
     C                   UPDATE    TABLETXF                             32
     C                   END
      *
     C                   UPDATE    SDFCTLA0
     C                   END
      *
     C                   READ      SDFCTLPA                               01
     C                   END
      *
     C                   SETON                                            LR
      *
      /EJECT
      *****************************************************************
      * FILDTL Subroutine - Get file details
      *****************************************************************
     C     FILDTL        BEGSR
      *
      * Generate file details list
     C                   CALL      'QUSRMBRD'                           03
     C                   PARM                    RCVVAR
     C                   PARM                    RCVLEN
     C                   PARM      'MBRD0200'    OUTFMT
     C                   PARM                    FILLII
     C                   PARM      '*FIRST'      MBRNAM
     C                   PARM      '0'           OVRRID
     C                   PARM                    APIERR
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = 'N'
     C                   EVAL      Recursive = 'Y'
     C                   SETON                                        U7U8
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
