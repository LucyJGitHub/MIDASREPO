     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Utility to update invalid data')              *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  UTMQ2410   - Utility to delete records from LEPDUEPD and     *
      *               LEPDUFPD which don't have a related record on   *
      *               LEFEED/CLOANCL.                                 *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR574425 *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR574425 - Housekeeping of uncessary records from LEPDUEPD   *
      *             and LEPDUFPD. (Child:AR574426)                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *
     FLEPDUFLB  UF   E           K DISK    RENAME(LEPDUFD0:LEPDUFDB)
     FLEPDUELB  UF   E           K DISK    RENAME(LEPDUED0:LEPDUEDB)
     FUTPDUEPD  O    E           K DISK
     FUTPDUFPD  O    E           K DISK
     FCLOAN     IF   E           K DISK    IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
     FMLOAN     IF   E           K DISK    IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
     F                                     RENAME(CLOANCLF:MCLONCLF)
     FLEFEED    UF   E           K DISK
      *
      *****************************************************************
      /EJECT
      *****************************************************************
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
     D KPORG           S                   LIKE(YPORG)
     D KECNUM          S                   LIKE(YECNUM)
     D KEFACL          S                   LIKE(YEFACL)
     D KESEQ           S                   LIKE(YESEQ)
     D KYBRCA          S                   LIKE(YBRCA)
      *
     D WKEEP           S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     C     *LOVAL        SETLL     LEPDUELB
     C                   READ      LEPDUELB
      *
      ** Loop process to read LEPDUELB
      *
     C                   DOW       NOT %EOF(LEPDUELB)
      *
     C                   MOVE      'N'           WKEEP
      *
      ** Check if Original Loan is on CLOANCL, if it is then
      ** keep LEPDUEPD record
      *
     C     YPORG         CHAIN     CLOAN
     C                   IF        %FOUND(CLOAN)
     C                   MOVE      'Y'           WKEEP
     C                   ENDIF
      *
      ** If record not found, check if it is on MCLONCL, if it is,
      ** then keep LEPDUEPD record
      *
     C                   IF        WKEEP = 'N'
     C     YPORG         CHAIN     MLOAN
     C                   IF        %FOUND(MLOAN)
     C                   MOVE      'Y'           WKEEP
     C                   ENDIF
     C                   ENDIF
      *
      ** If record not found, delete it from MCLONCL
      *
     C                   IF        WKEEP = 'N'
     C                   WRITE     LEPDUED0
     C                   DELETE    LEPDUEDB
     C                   ENDIF
      *
     C                   READ      LEPDUELB
     C                   ENDDO
      *
      ** Loop to read LEPDUFPD
      *
      ** Key list for LEPDUFLB
      *
     C     ZLEPD         KLIST
     C                   KFLD                    KYBRCA
     C                   KFLD                    KECNUM
     C                   KFLD                    KEFACL
     C                   KFLD                    KPORG
     C                   KFLD                    KESEQ
      *
     C     *LOVAL        SETLL     LEPDUFLB
     C                   READ      LEPDUFLB
      *
      ** Loop process to read LEPDUELB
      *
     C                   DOW       NOT %EOF(LEPDUFLB)
     C                   EVAL      KPORG = YPORG
     C                   EVAL      KECNUM = YECNUM
     C                   EVAL      KEFACL = YEFACL
     C                   EVAL      KESEQ  = YESEQ
     C                   EVAL      KYBRCA = YBRCA
      *
      ** Check if Original Loan is on CLOANCL, if it is then
      ** keep LEPDUEPD record
      *
     C     ZLEPD         CHAIN     LEFEED
     C                   IF        NOT %FOUND(LEFEED)
     C                   WRITE     LEPDUFD0
     C                   DELETE    LEPDUFDB
     C                   ENDIF
      *
     C                   READ      LEPDUFLB
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
 
