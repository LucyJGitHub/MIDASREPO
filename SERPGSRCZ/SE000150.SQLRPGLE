     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SE Merge Gen. Entries of Trailer')               *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE000150 - Midas SE Merge Gen. Entries of Trailer            *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD021383A *CREATE  Date 16Jun23               *
      *  Prev Amend No. xxxxxxxx           Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021383A - Credit Lines (CLE025) Shadow Posting Correction. *
      *            - MD061267 - Credit Lines (CLE025) fixes           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
      *                                                               *
      * *INZSR - Initialise                                           *
      * *PSSR  - Error processing                                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     D WRun            S              1A
     D FilNam          S             10A
     D Mode            S             10A
     D WWNORE1         S             10S 0
     D FNORE1          S              5S 0

     D SKEYDS        E DS                  EXTNAME(SEKEYA)
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Main Process
      *
     C                   Z-ADD     0             WWNORE1
     C                   Z-ADD     0             FNORE1
      *
     C                   SELECT
      *
      ** Update GESTZZ when File name is GEST3ZZ
      *
     C                   WHEN      FilNam = 'GEST3ZZ' and Mode = 'Update'
      *
     C/EXEC SQL
     C+ select (a.NORE1 + b.NORE1) - 2 into :WWNORE1
     C+ from GESTZZ a, GEST3ZZ b
     C/END-EXEC
      *
     C                   MOVE      WWNORE1       FNORE1
      *
     C/EXEC SQL
     C+ update GESTZZ set
     C+ NORE1 = :FNORE1,
     C+ HRWN = (select cast(
     C+           ( a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+           ( b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+                        as numeric (15,0) )
     C+           from GESTZZ a, GEST3ZZ b ),
     C+ HRDC = (select cast( ( mod( cast(
     C+           ( a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+           ( b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+                        as numeric (18,3) )
     C+                               , 1 ) * 1000 )
     C+                                    as numeric(3,0) )
     C+           from GESTZZ a, GEST3ZZ b )
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Update GEST1ZZ when File name is GEST4ZZ
      *
     C                   WHEN      FilNam = 'GEST4ZZ' and Mode = 'Update'
      *
     C/EXEC SQL
     C+ select (a.NORE1 + b.NORE1) - 2 into :WWNORE1
     C+ from GEST1ZZ a, GEST4ZZ b
     C/END-EXEC
      *
     C                   MOVE      WWNORE1       FNORE1
      *
     C/EXEC SQL
     C+ update GEST1ZZ set
     C+ NORE1 = :FNORE1,
     C+ HRWN = (select cast(
     C+           ( a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+           ( b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+                        as numeric (15,0) )
     C+           from GEST1ZZ a, GEST4ZZ b ),
     C+ HRDC = (select cast( ( mod( cast(
     C+           ( a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+           ( b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+                        as numeric (18,3) )
     C+                               , 1 ) * 1000 )
     C+                                    as numeric(3,0) )
     C+           from GEST1ZZ a, GEST4ZZ b )
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   WHEN      FilNam = 'SEKEYA' and Mode = 'Write'
      *
     C/EXEC SQL
     C+ select * into :SKEYDS from SEKEYA
     C/END-EXEC
      *
     C                   IF        SQLCODE <> 0 and SQLCODE = 100
      *
     C/EXEC SQL
     C+ insert into SEKEYA (NORE, HRWN, HRDC) values ( 0, 0, 0)
     C/END-EXEC
      *
     C                   ENDIF
      *
     C                   IF        SQLCODE <> 0 and SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    FilNam
     C                   PARM                    Mode
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Program exception error routine                       *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
