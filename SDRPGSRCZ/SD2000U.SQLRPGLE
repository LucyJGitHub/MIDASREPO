     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058830
/*STD *  RPGSQLBND                                                    *                     MD058830
/*EXI *  TEXT('Midas SD Update Network file')                         *
      *****************************************************************
      *                                                               *
      *  Midas                                              *
      *                                                               *
      *    SD2000U - UPDAT NETWORK FILE                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Last Amend No. MD061007           Date 31Dec21               *
      *  Prev Amend No. MD058830           Date 01Oct21               *
      *                 CMG008             Date 20Feb20               *
      *                 CSD101             Date 07Dec18               *
      *                 MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL013             Date 29Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 E31858             Date 13Nov91               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD061007 - Deliverable Data Split for SDFCTLPA and GPFCTLPA  *
      *  MD058830 - Deliverable Data Split for SDNWRKPD               *
      *  CMG008 - SWIFT Character Translation Table (Recompile)       *
      *  CSD101 - Password Encryption (Recompile)                     *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL013 - MT94x Messages Generation (Recompile over new layout*
      *                                      of SDNWRKPD)             *
      *    E31858 - CHANGE FILE DESCRIPTION OF SDFCTLL0 TO COMIT      *
      *                                                               *
      *****************************************************************
     FSDMMODPD  IF   E             DISK
     F*SDNWRKL0* UF A E           K DISK                                                    MD058830
     F*SDFCTLL0* UF   E           K DISK                                                    MD061007
     F**********                           COMMIT                               E31858      MD061007
      *
      * ID C  F  H  L    Function of indicators
      *    99            EOF SDMMODPD
      *    98            RECORD FOUND/NOT FOUND ON SDNWRKPD
      *    97            EOF SDFCTLL0
      *    20            INSERTED RECORD ON SDNWRKPD
      *    21            DELETED RECORD ON SDNWRKPD
      *    U7,U8         DB Error
      *    LR            END PROGRAM
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
      **  Local data area data structure
      *
     D                 DS
     D  SWIFT                  1     20    INZ('S.W.I.F.T.')
      *
      **  Initialization of the SWIFT variable
      *
     D                 DS
     D  SDNWRK                 1     10    INZ('SDNWRKPD')
      *
      **  Initialization of the SDNWRK variable
      *
     D YMD             DS
     D  YY                     1      2
     D  MD                     3      6
      *
      **  RUNDAT in YYMMDD format
      *
     D XXY             DS             6
     D  XX                     1      2
      *
      **  Used to convert YMD into MMDDYY or DDMMYY depending on the
      **  date format ie. D or M
     D QSDFC1          DS                                                                   MD061007
     D  AHFLNM                 1     10                                                     MD061007
     D  AHNORC                11     13P 0                                                  MD061007
     D  AHNOIN                14     16P 0                                                  MD061007
     D  AHNOAM                17     19P 0                                                  MD061007
     D  AHNODL                20     22P 0                                                  MD061007
                                                                                            MD061007
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Set up copyright statement
      *
     C                   MOVEA     CPY@          BIS@             80
      *
     C     *DTAARA       DEFINE                  LDA
      *
      **  Obtain Rundat & date format
      *
     C                   CALL      'ZM0080'
     C     XXY           PARM                    YMD
     C                   PARM                    DFMT              1
      *
      **  Reformat Rundat into correct date format :- D DDMMYY or
      **  M MMDDYY
      *
     C                   MOVE      YY            XXY
     C     DFMT          IFEQ      'D'
     C                   MOVE      MD            XX
     C                   ELSE
     C                   MOVEL     MD            XXY
     C                   END
      *
     C                   MOVE      XXY           @@DATE
      *
      **  Convert Rundat from DDMMYY/MMDDYY into Run Day no.
      *
     C                   CALL      'ZA0270'
     C                   PARM                    @@DATE            6 0
     C                   PARM      DFMT          @@DFMT            1
     C                   PARM                    @@RTN             1
     C                   PARM                    @@DAYN            5 0
      *
      **  Access SDMMODPD for active networks
      *
     C     1             CHAIN     SDMMODPD                           9999
      *
     C     *IN99         IFEQ      '1'                                                     1
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE                          ***************
     C                   MOVEL     'FIRST'       DBKEY                          * DB ERROR 01 *
     C                   MOVEL     'SDMMODPD'    DBFILE                         ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END                                                              E1
      *
      ** Assume SWIFT and TELEX are core Networks                                           MD058830
      *                                                                                     MD058830
      **    Access SDNWRKPD using the key 'SWIFT'. Check if the SWIFT
      **  network is ON or OFF. If ON & SWIFT details are not already
      **  on the Network file (SDNWRKPD) insert the details on the file
      **  (*IN20).
      **    However if the SWIFT network is OFF & details are on the
      **  Network file delete them (*IN21).
      *
     C*****'SWIFT '      CHAIN     SDNWRKL0                           98                    MD058830
      **********                                                                            MD058830
     C*****BGMSDL        IFEQ      'Y'                                                     1MD058830
      **********                                                                            MD058830
     C******IN98         IFEQ      '1'                                                     2MD058830
     C**********         MOVEL     'SWIFT   '    EDNWRK                                     MD058830
     C**********         MOVE      'I'           EDTYLC                                     MD058830
     C**********         MOVE      *BLANKS       EDNETD                                     MD058830
     C**********         MOVE      SWIFT         EDNETD                                     MD058830
     C**********         MOVE      @@DAYN        EDLCD                                      MD058830
     C**********         WRITE     @EDREJY                                                  MD058830
     C**********         SETON                                        20                    MD058830
     C**********         EXSR      FCTL                                                     MD058830
     C**********         END                                                              E2MD058830
      **********                                                                            MD058830
     C**********         ELSE                                                             X1MD058830
      **********                                                                            MD058830
     C******IN98         IFEQ      '0'                                                     2MD058830
     C**********         DELETE    @EDREJY                                                  MD058830
     C**********         SETON                                        21                    MD058830
     C**********         EXSR      FCTL                                                     MD058830
     C**********         END                                                              E2MD058830
      **********                                                                            MD058830
     C**********         END                                                              E1MD058830
      *
      **    Access SDNWRKPD using the key 'TELEX'. Check if the TELEX
      **  network is ON or OFF. If ON & TELEX details are not already
      **  on the Network file (SDNWRKPD) insert the details on the file
      **  (*IN20).
      **    However if the TELEX network is OFF & details are on the
      **  Network file delete them (*IN21).
      *
      *
     C*****'TELEX '      CHAIN     SDNWRKL0                           98                    MD058830
      **********                                                                            MD058830
     C*****BGMTMI        IFEQ      'Y'                                                     1MD058830
      **********                                                                            MD058830
     C******IN98         IFEQ      '1'                                                     2MD058830
     C**********         MOVEL     'TELEX   '    EDNWRK                                     MD058830
     C**********         MOVE      *BLANKS       EDNETD                                     MD058830
     C**********         MOVE      'Telex   '    EDNETD                                     MD058830
     C**********         MOVE      'I'           EDTYLC                                     MD058830
     C**********         MOVE      @@DAYN        EDLCD                                      MD058830
     C**********         WRITE     @EDREJY                                                  MD058830
     C**********         SETON                                        20                    MD058830
     C**********         EXSR      FCTL                                                     MD058830
     C**********         END                                                              E2MD058830
      **********                                                                            MD058830
     C**********         ELSE                                                             X1MD058830
      **********                                                                            MD058830
     C******IN98         IFEQ      '0'                                                     2MD058830
     C**********         DELETE    @EDREJY                                                  MD058830
     C**********         SETON                                        21                    MD058830
     C**********         EXSR      FCTL                                                     MD058830
     C**********         END                                                              E2MD058830
      **********                                                                            MD058830
     C**********         END                                                              E1MD058830
      *
     C                   SETON                                        LR
     C/EJECT
      *****************************************************************
      *   FCTL  - Update file control subroutine                      *
      *****************************************************************
      *
     C     FCTL          BEGSR
      *
      **  Access SDFCTLPA using the key 'SDNWRKPD'
      *
     C*****SDNWRK        CHAIN     SDFCTLL0                           97                    MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*RTV'        ZMODE             4                        MD061007
     C                   PARM      SDNWRK        AHFLNM                                     MD061007
     C                   PARM      0             AHNORC                                     MD061007
     C                   PARM      0             AHNOIN                                     MD061007
     C                   PARM      0             AHNOAM                                     MD061007
     C                   PARM      0             AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN           10                        MD061007
      *                                                                                     MD061007
     C                   SETOFF                                       97                    MD061007
     C     ZRETRN        IFNE      *BLANKS                                                  MD061007
     C                   SETON                                        97                    MD061007
     C                   ENDIF                                                              MD061007
      *                                                                                     MD061007
     C     *IN97         IFEQ      '1'                                                     1
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE                          ***************
     C                   MOVEL     'SDNWRKPD'    DBKEY                          * DB ERROR 02 *
     C                   MOVEL     'SDFCTLL0'    DBFILE                         ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END                                                              E1
      *
      **  Inserted records
      *
     C     *IN20         IFEQ      '1'
     C     AHNORC        ADD       1             AHNORC
     C     AHNOIN        ADD       1             AHNOIN
     C                   END
      *
      **  Deleted records
      *
     C     *IN21         IFEQ      '1'
     C     AHNORC        SUB       1             AHNORC
     C     AHNODL        ADD       1             AHNODL
     C                   END
      *
      **  Set off indicators *IN20 & *IN21
      *
     C                   MOVEA     '00'          *IN(20)
      *
      **  Update file control file SDFCTLPA
      *
     C**********         UPDATE    @AHREAU                                                  MD061007
     C                   CALL      'SD000119'                                               MD061007
     C                   PARM      '*UPD'        ZMODE                                      MD061007
     C                   PARM                    AHFLNM                                     MD061007
     C                   PARM                    AHNORC                                     MD061007
     C                   PARM                    AHNOIN                                     MD061007
     C                   PARM                    AHNOAM                                     MD061007
     C                   PARM                    AHNODL                                     MD061007
     C                   PARM      *BLANKS       ZRETRN                                     MD061007
                                                                                            MD061007
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   *PSSR - Error handling                                      *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
** CPY@   **      Object copyright
(c) Finastra International Limited 2001
