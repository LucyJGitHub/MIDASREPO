     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas GL Daily Reporting Merge - Audit')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL41T4 - Daily Reporting Merge - Audit                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD022412 *CREATE   Date 16Sep13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD022412 - Record locking in trailer file EODPOZZ            *
      *                                                               *
      *****************************************************************
      *                                                               *
     FEODPOZZ   IF A E             DISK    USROPN INFSR(*PSSR)
     F                                     COMMIT
      ** CoB Postings Trailer File
 
     FGL0400AU  O    F  132        PRINTER USROPN
 
      ** Variables/Constants
 
     D DecSum          S                   INZ LIKE(HRDC)
     D IntSum          S                   INZ LIKE(HRWN)
     D RecCount        S                   INZ LIKE(NORE1)
 
     D PSSRNotDone     S               N   INZ(True)
     D True            C                   CONST(*ON)
     D False           C                   CONST(*OFF)
 
      ** AO Program parameters
 
     D PRTCD           S              7A   INZ
     D POPTN           S              7A   INZ
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Midas Data Structures
 
     D LDA           E DS                  EXTNAME(LDA)
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
     D                                     DTAARA(RUNDAT)
 
      *****************************************************************
      *                                                               *
      * MAIN PROCESSING                                               *
      *                                                               *
      *****************************************************************
 
     C                   IF        NOT %OPEN(EODPOZZ)
     C                   OPEN      EODPOZZ
     C                   ENDIF
 
     C                   READ      EODPOZZ
     C                   DOW       NOT %EOF(EODPOZZ)
 
     C                   IF        HRDC + DecSum >= 1000
     C                   ADD       1             IntSum
     C                   ENDIF
 
     C                   ADD       HRWN          IntSum
     C                   ADD       HRDC          DecSum
     C                   ADD       NORE1         RecCount
 
     C                   READ      EODPOZZ
     C                   ENDDO
 
      ** Clear trailer file
 
     C/EXEC SQL
     C+ delete from EODPOZZ
     C/END-EXEC
 
     C                   IF        SQLCODE < 0
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'EODPOZZ'
     C                   EVAL      DBKEY = 'SQL Del'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Write merged totals and audit report
 
     C                   EVAL      RECI = 'T'
     C                   EVAL      NORE1 = RecCount
     C                   EVAL      HRWN = IntSum
     C                   EVAL      HRDC = DecSum
 
     C                   WRITE     APOSTZZF
     C                   EXCEPT
 
     C                   IF        NOT (*INU7 AND *INU8)
     C                   COMMIT
     C                   ENDIF
 
      ** End Program
 
     C                   CLOSE     EODPOZZ
     C                   CLOSE     GL0400AU
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial Subroutine                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   IN        RUNDAT
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     PRTCD         IFNE      *BLANKS
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   END
 
     C                   IF        NOT %OPEN(GL0400AU)
     C                   OPEN      GL0400AU
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Program Exception Error Routine                       *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        PSSRNotDone
     C                   DUMP
     C                   EVAL      PSSRNotDone = False
     C                   ENDIF
 
     C                   IF        NOT %OPEN(GL0400AU)
     C                   OPEN      GL0400AU
     C                   ENDIF
 
     C                   EXCEPT    EXCPTDBASE
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     OGL0400AU  E                           2 03
0438 O                                           24 'REFERENCE GL0400AU'
0439 O                       BJURPT              89
0440 O                                          104 'DATE'
0441 O                       AGMRDT             113
0442 O                                          122 'PAGE'
0443 O                       PAGE          Z    127
 
     O          E                           1
0445 O                                           69 'ACCOUNTS POSTING MERGE'
     O                                           85 '    RUN CONTROLS'
 
     O          E                           2
     O                                           69 '----------------------'
 
0450 O          E                           1
0451 O                                           50 'INPUT'
0452 O                                           96 'CALCULATED'
 
0453 O          E                           2
0454 O                                           41 'READ'
0455 O                                           63 'VALUE'
0456 O                                           84 'READ'
0457 O                                          106 'VALUE'
 
     O          E                        2  2
0482 O                                           29 'NUMBER OF ACCOUNT PO'
0483 O                                           43 'STINGS WRITTEN'
0484 O                       NORE1         3     67
 
     O          E                           2
0486 O                                           29 'VALUE OF ACCOUNT PO'
0487 O                                           43 'STINGS WRITTEN'
0488 O                       HRWN          Z     64
0489 O                       HRDC                67
 
     O          E            EXCPTDBASE  2  1
0376 O                                           42 '*** REFERENCE'
0377 O                       DBPGM               53
0378 O                                           73 '-DATABASE ERROR AT'
0379 O                       DBASE               77
 
     O          E            EXCPTDBASE     1
0381 O                                           37 'FILE NAME'
0382 O                       DBFILE              48
0383 O                                           53 'KEY'
0384 O                       DBKEY               83
      *****************************************************************
