     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Setup PM Instrument Type on PF/INTYPD')       *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00052 - Installation of FF/PM Interface R10               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 S71062             Date 05Mar96               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CPM00301.                          *
      *  S71062  - FF/PM Interface R10                                *
      *                                                               *
      *****************************************************************
     FINTYP     UF   E           K DISK
      /EJECT
      *****************************************************************
      **
      **  Local Data Area for database errors
      **
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      **
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      ** Portfolio Management ICD
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for modules
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     C                   EXSR      INZSR
      **
     C** First read
     C     BGPFMG        IFEQ      'Y'
     C                   READ      INTYP                                  LR
      **
     C     *INLR         DOWEQ     '0'                                          - B1
      **
     C     INNR          IFEQ      *BLANKS                                      - B2
     C                   MOVEL     FCDINR        INNR
     C                   UPDATE    INTYPDF
     C                   END                                                    - E1
      **
      ** Main file read
     C                   READ      INTYP                                  LR
     C                   END                                                    - E1
     C                   END
      **
      ** End of processing
     C                   RETURN
      **
      /EJECT
     C*****************************************************************
      **                                                   ***************
     C     INZSR         BEGSR                                                  * INZSR BEGSR *
      **                                                   ***************
      ** Prepare LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANK        DBFILE
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     'FFINTYPD'    DBPGM
     C                   Z-ADD     *ZEROS        DBASE
     C                   OUT       LDA
      **
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       WWRTCD            7
     C                   PARM      '*FIRST '     WWOPTN            7
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C     WWRTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA                                          ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   MOVE      'SDMMODPD'    DBFILE                         ***************
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      **
     C     BGPFMG        IFEQ      'Y'
     C                   CALL      'AOPORTR0'
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM      '*FIRST '     WWOPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C     WWRTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   SETON                                        U7U8      ***************
     C                   Z-ADD     2             DBASE                          * DB ERROR 02 *
     C                   MOVE      'SDPORTPD'    DBFILE                         ***************
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   END
      **                                                   ***************
     C                   ENDSR                                                  * INZSR ENDSR *
      **                                                   ***************
      /EJECT
     C*****************************************************************
      **                                                   ***************
     C     *PSSR         BEGSR                                                  * *PSSR BEGSR *
      **                                                   ***************
     C                   DUMP
      **
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
      **
     C                   RETURN
      **                                                   ***************
     C                   ENDSR                                                  * *PSSR ENDSR *
      **                                                   ***************
     C*****************************************************************
