     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Setup default a/c sequence on PMPORTPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00054 -  Installation of FF/PM Interface R10              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. BG26993            Date 26Jan10               *
      *  Prev Amend No. S71062             Date 05Mar96               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CPM00303.                          *
      *  S71062  - FF/PM Interface R10                                *
      *                                                               *
      *****************************************************************
     FPMPORTLL  UF   E           K DISK
      /EJECT
      *****************************************************************
      **
      **  Local Data Area for database errors
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      **
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for modules
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
      /EJECT
     C*****************************************************************
      *
     C                   EXSR      INZSR
      **
      ** First read
     C                   READ      PMPORTLL                               LR
      **
      ** Reset work field
     C                   MOVE      *BLANKS       WCNUM             6 0
      **
      ** Do the processing only if FF module is ON
      ** Process until LR indicator not = '1'
     C     BGFUOP        IFEQ      'Y'                                          - B1
     C     *INLR         DOWEQ     '0'                                          - B2
     C     PNACSQ        IFEQ      *ZEROS
     C                   MOVE      '01'          PNACSQ
     C                   UPDATE    PMPORTP0
     C                   END
      **
      ** Main file read
     C                   READ      PMPORTLL                               LR
     C                   END                                                    - E2
     C                   END                                                    - E1
      **
      ** End of processing
     C                   RETURN
      **
      /EJECT
     C*****************************************************************
      **                                                   ***************
     C     INZSR         BEGSR                                                  * INZSR  BEGSR*
      **                                                   ***************
      ** Prepare LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANK        DBFILE
     C                   MOVEL     *BLANK        DBKEY
     C                   MOVEL     'PMPORT  '    DBPGM
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
      **                                                   ***************
     C                   ENDSR                                                  * *INZSR ENDSR*
      **                                                   ***************
      /EJECT
      *****************************************************************
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
