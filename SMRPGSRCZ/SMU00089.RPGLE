     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Program to add release levels to SCARDPD')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00089 - Upgrade release info. for Switch. Features        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BG26993            Date 26Jan10               *
      *                 159708  *CREATE    Date 20Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S15970801.                         *
      *  159708  - Update Release Levels                              *
      *                                                               *
      *****************************************************************
      /EJECT
     FSCSARDPD  UF A E             DISK
      *                                                               *
     FSDBANKPD  IF   E             DISK
      *                                                               *
     D DESCR4          S             50    DIM(1) CTDATA PERRCD(1)
     D DESCR5          S             50    DIM(1) CTDATA PERRCD(1)
     D DESCD1          S             50    DIM(1) CTDATA PERRCD(1)
     D DESCD2          S             50    DIM(1) CTDATA PERRCD(1)
      *
      ** Access DTAARA/RUNDAT for current run date.
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Array containing Description Text
      *
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      ** Read in Installation Data
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
     C                   EXSR      INIT
     C                   EXSR      MAIN
     C                   EXSR      END
      *
      *******************************************************************
      *   INITIALISATION SUBROUTINE
      *******************************************************************
      *
     C     INIT          BEGSR
     C                   MOVE      '0000'        *IN(30)
     C                   MOVE      '0'           *IN90
      *
     C                   READ      SDBANKPD                               89
     C                   MOVE      BJRDNB        DATE              5
     C                   MOVE      DATE          LCDR4             7
     C                   MOVE      DATE          LCDR5             7
     C                   MOVE      DATE          LCDD1             7
     C                   MOVE      DATE          LCDD2             7
     C                   ENDSR
      *
      *******************************************************************
      *   MAIN SUBROUTINE
      *******************************************************************
      *
     C     MAIN          BEGSR
     C                   READ      SCSARDD0                               90
     C     *IN90         IFEQ      '1'
      ** Data base error in file (file)
      *
     C     *LOCK         IN        LDA
     C                   SETON                                          U7U8
     C                   Z-ADD     001           DBASE                          ***************
     C                   MOVEL     '(file)'      DBFILE                         *DB ERROR 001 *
     C                   MOVEL     '(key)'       DBKEY                          ***************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN90         DOWEQ     '0'
     C     SARN          IFEQ      'R10.4 '
     C                   MOVE      '1'           *IN30
     C                   MOVE      LCD           LCDR4
     C                   DELETE    SCSARDD0
     C                   ENDIF
     C     SARN          IFEQ      'R10.5 '
     C                   MOVE      '1'           *IN31
     C                   MOVE      LCD           LCDR5
     C                   DELETE    SCSARDD0
     C                   ENDIF
     C     SARN          IFEQ      'DBAR1 '
     C                   MOVE      '1'           *IN32
     C                   MOVE      LCD           LCDD1
     C                   DELETE    SCSARDD0
     C                   ENDIF
     C     SARN          IFEQ      'DBAR2 '
     C                   MOVE      '1'           *IN33
     C                   MOVE      LCD           LCDD2
     C                   DELETE    SCSARDD0
     C                   ENDIF
     C                   READ      SCSARDD0                               90
     C                   ENDDO
      *
     C                   MOVEL     'R10.4 '      SARN
     C                   MOVEL     DESCR4(1)     SARD             50
     C                   MOVE      LCDR4         LCD
     C                   WRITE     SCSARDD0
      *
     C                   MOVEL     'R10.5 '      SARN
     C                   MOVEL     DESCR5(1)     SARD             50
     C                   MOVE      LCDR5         LCD
     C                   WRITE     SCSARDD0
      *
     C                   MOVEL     'DBAR1 '      SARN
     C                   MOVEL     DESCD1(1)     SARD             50
     C                   MOVE      LCDD1         LCD
     C                   WRITE     SCSARDD0
      *
     C                   MOVEL     'DBAR2 '      SARN
     C                   MOVEL     DESCD2(1)     SARD             50
     C                   MOVE      LCDD2         LCD
     C                   WRITE     SCSARDD0
      *
     C                   ENDSR
      *
      *******************************************************************
      *   MAIN SUBROUTINE
      *******************************************************************
      *
     C     END           BEGSR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
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
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
**  DESCR4
Release Licence Indicator ABS Release 10.4
**  DESCR5
Release Licence Indicator ABS Release 10.5
**  DESCD1
Release Licence Indicator DBA Release 1
**  DESCD2
Release Licence Indicator DBA Release 2
