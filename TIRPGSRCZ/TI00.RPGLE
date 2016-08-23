     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Module setup')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Module                              *
      *                                                               *
      *  TI00 - Midas TI Module Setup                                 *
      *                                                               *
      *  Function:  This program writes a TI record to SDSYTMPD       *
      *             and SDMEMOPD.                                     *
      *                                                               *
      *  Next Day Setup                                               *
      *                                                               *
      *  Called By: TIC00   - Midas TI Module Setup                   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CRT004             Date 04May00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI001  *CREATE    Date 19SEP97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRT004 - Cashier Midas TCP/IP interface.                     *
      *             Recompiled over SDBRCHPD Changes                  *
      *  CDL008 - Continuous Linked Settlement (recompile SDBRCHPD)   *
      *  CTI001 - Midas / Trade Innovation Interface Phase 1          *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     FSDBRCHL0  UF   E             DISK
     FSDSYTMPD  O    E             DISK
     FSDMEMOPD  O    E             DISK
      *
      ********************************************************************
      *
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *
      *       96         EOF SDBRCHL0
      *       97         Error writing to SDSYTMPD
      *       98         Date format MMDDYY
      *       99         Error writing to SDMEMOPD
      *
      ********************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Array containing Copyright statement
      *
      /SPACE 3
      *
     D DESC            C                   CONST('Trade Innovation')
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    S01486
      * Midas SD Bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01117
     I*  short Data Structure for access programs                         S01117
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   END
      *
      ** Access SDBANKPD for run date
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
     C*
     C     P@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     001           DBASE                          ***************
     C                   MOVEL     'SDBANKPD'    DBFILE                         *DB ERROR 001 *
     C                   MOVEL     '*FIRST  '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Write a new record to SDSYTMPD
      *
     C                   MOVEL     'TI    '      ECSYTM
     C                   MOVEL     DESC          ECSYSD
     C                   Z-ADD     BJRDNB        ECLCD
     C                   MOVE      'I'           ECTYLC
     C                   MOVE      'CRTD'        ECDFST
      *
     C                   WRITE     SDSYTMD0                             97
      *
     C     *IN97         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     002           DBASE                          ***************
     C                   MOVEL     'SDSYTMPD'    DBFILE                         *DB ERROR 002 *
     C                   MOVEL     '        '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Write a new record to SDMEMOPD
      *
     C                   MOVE      'TI'          EBMODI
     C                   MOVEL     DESC          EBMODD
     C                   Z-ADD     BJRDNB        EBLCD
     C                   MOVE      'I'           EBTYLC
      *
     C                   WRITE     SDMEMOD0                             99
      *
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     003           DBASE                          ***************
     C                   MOVEL     'SDMEMOPD'    DBFILE                         *DB ERROR 003 *
     C                   MOVEL     '        '    DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Update all blank TI Branch Numbers to '0000'
      *
     C                   READ      SDBRCHL0                               96
     C     *IN96         DOWEQ     *OFF
     C     A8TIBR        IFEQ      *BLANKS
     C                   MOVE      '0000'        A8TIBR
     C                   UPDATE    @A8REB1
     C                   ENDIF
     C                   READ      SDBRCHL0                               96
     C                   ENDDO
      *
      * End of program
      *
     C                   SETON                                            LR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: DBERRCTL                                               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   ENDSR
      *
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
