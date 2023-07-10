     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Merge Gen. Entries of Trailer')               *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000474 - Midas LE Merge Gen. Entries of Trailer            *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD021383C          Date 16Jun23               *
      *  Prev Amend No. MD021383A *CREATE  Date 16Jun23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021383C - GLC63 00001 FOOB. Update FNORE1 for GELE4ZZ file *
      *              with total NORE1 of GELE2ZZ and GELE4ZZ.         *
      *            - MD061267 - Credit Lines (CLE025) fixes           *
      *  MD021383A - Credit Lines (CLE025) Shadow Posting Correction. *
      *            - MD061267 - Credit Lines (CLE025) fixes           *
      *                                                               *
      *****************************************************************
      *                                                               *
     DWFile            S             10
     DWmode            S             10
     D WWNORE1         S             10S 0
     D FNORE1          S              5S 0
      *
     C     *ENTRY        PLIST
     C                   PARM                    WFile
     C                   PARM                    WMode
      *
     C                   Z-ADD     0             WWNORE1
     C                   Z-ADD     0             FNORE1
      *
     C                   SELECT
      *
      * Update trailer file GELE3ZZ
      *
     C
     C                   WHEN      WFile = 'GELE3ZZ'
     C                             AND WMode = 'Update'
      *
     C/EXEC SQL
     C+ select (a.NORE1 + b.NORE1) - 2 into :WWNORE1
     C+ from GELEZZ a, GELE3ZZ b
     C/END-EXEC
      *
     C                   MOVE      WWNORE1       FNORE1
      *
     C/EXEC SQL
     C+ UPDATE GELEZZ SET
     C+ NORE1 = :FNORE1,
     C+ HRWN = ( select cast(
     C+ ( a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+ ( b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+ as numeric (15,0) )
     C+ FROM GELEZZ a, GELE3ZZ b ),
     C+ HRDC = ( select cast( ( mod( cast(
     C+ ( a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+ ( b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+ AS numeric (18,3) )
     C+ , 1 ) * 1000 )
     C+ AS numeric(3,0) )
     C+ FROM GELEZZ a, GELE3ZZ b )
     C/END-EXEC
      *
      ** Update trailer file GELE4ZZ
      *
     C                   WHEN      WFile = 'GELE4ZZ'
     C                             AND WMode = 'Update'
      *                                                                                    MD021383C
     C/EXEC SQL                                                                            MD021383C
     C+ select (a.NORE1 + b.NORE1) - 2 into :WWNORE1                                       MD021383C
     C+ from GELE2ZZ a, GELE4ZZ b                                                          MD021383C
     C/END-EXEC                                                                            MD021383C
      *                                                                                    MD021383C
     C                   MOVE      WWNORE1       FNORE1                                    MD021383C
      *
     C/EXEC SQL
     C+ UPDATE GELE2ZZ SET
     C+ NORE1 = :FNORE1,
     C+ HRWN = ( select cast(
     C+ ( a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+ ( b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+ as numeric (15,0) )
     C+ FROM GELE2ZZ a, GELE4ZZ b ),
     C+ HRDC = ( select cast( ( mod( cast(
     C+ ( a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+ ( b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+ AS numeric (18,3) )
     C+ , 1 ) * 1000 )
     C+ AS numeric(3,0) )
     C+ FROM GELE2ZZ a, GELE4ZZ b )
     C/END-EXEC
     C
      *
      ** Update trailer file LKEY1ZZ
      *
     C                   WHEN      WFile = 'LKEY1ZZ'
     C                             AND WMode = 'Update'
      *
     C/EXEC SQL
     C+ select (a.NORE + b.NORE) - 2 into :WWNORE1
     C+ from LKEY1ZZ a, LKEY1SZZ b
     C/END-EXEC
     C                   MOVE      WWNORE1       FNORE1
      *
     C/EXEC SQL
     C+ UPDATE LKEY1ZZ SET
     C+ NORE = :FNORE1,
     C+ VLRF = ( select cast(
     C+ ( a.VLRF + cast( (a.VLRL /1000) as numeric (3,3) ) ) +
     C+ ( b.VLRF + cast( (b.VLRL /1000) as numeric (3,3) ) )
     C+ as numeric (15,0) )
     C+ FROM LKEY1ZZ a, LKEY1SZZ b ),
     C+ VLRL = ( select cast( ( mod( cast(
     C+ ( a.VLRF + cast( (a.VLRL /1000) as numeric (3,3) ) ) +
     C+ ( b.VLRF + cast( (b.VLRL /1000) as numeric (3,3) ) )
     C+ AS numeric (18,3) )
     C+ , 1 ) * 1000 )
     C+ AS numeric(3,0) )
     C+ FROM LKEY1ZZ a, LKEY1SZZ b )
     C/END-EXEC
      *
      ** Update trailer file LKEY1ZZ
      *
     C                   WHEN      WFile = 'LKEYFEZ'
     C                             AND WMode = 'Update'
      *
     C/EXEC SQL
     C+ select (a.LKNORE + b.LKNORE) - 2 into :WWNORE1
     C+ from LKEYFEZ a, LKEYFESZ b
     C/END-EXEC
      *
     C                   MOVE      WWNORE1       FNORE1
      *
     C/EXEC SQL
     C+ UPDATE LKEYFEZ SET
     C+ LKNORE = :FNORE1,
     C+ LKVLRF = ( select cast(
     C+ ( a.LKVLRF + cast( (a.LKVLRL /1000) as numeric (3,3) ) ) +
     C+ ( b.LKVLRF + cast( (b.LKVLRL /1000) as numeric (3,3) ) )
     C+ as numeric (15,0) )
     C+ FROM LKEYFEZ a, LKEYFESZ b ),
     C+ LKVLRL = ( select cast( ( mod( cast(
     C+ ( a.LKVLRF + cast( (a.LKVLRL /1000) as numeric (3,3) ) ) +
     C+ ( b.LKVLRF + cast( (b.LKVLRL /1000) as numeric (3,3) ) )
     C+ AS numeric (18,3) )
     C+ , 1 ) * 1000 )
     C+ AS numeric(3,0) )
     C+ FROM LKEYFEZ a, LKEYFESZ b )
     C/END-EXEC
      *
      ** Reset trailer file LKEY1ZZ
      *
     C                   WHEN      WFile = 'LKEY1ZZ'
     C                             AND WMode = 'Reset'
      *
     C/EXEC SQL
     C+ update LKEY1ZZ set
     C+ NORE = 2,
     C+ VLRF = 0,
     C+ VLRL = 0
     C/END-EXEC
     C
      *
      ** Reset trailer file LKEYFEZ
      *
     C                   WHEN      WFile = 'LKEYFEZ'
     C                             AND WMode = 'Reset'
      *
     C/EXEC SQL
     C+ update LKEYFEZ set
     C+ LKNORE = 2,
     C+ LKVLRF = 0,
     C+ LKVLRL = 0
     C/END-EXEC
     C                   ENDSL
      *
     C                   RETURN
      *
