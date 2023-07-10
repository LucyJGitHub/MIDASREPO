     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas DL Merge Gen. Entries of trailer')               *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL000150 - Midas DL Merge Gen. Entries of trailer            *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD021383A *Create  Date 16Jun23               *
      *  Prev Amend No. xxxxxxxx           Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD021383A - Credit lines shadow posting correction.          *
      *              Introduced a new DLC0606C COB component to call  *
      *              DL0295 on rerun in order to process IAS posting. *
      *            - MD061267 - Credit Lines (CLE025) fixes           *
      *                                                               *
      *****************************************************************
      *
     DWFile            S             10
     DWMode            S             10
     D WWNORE1         S             10S 0
     D FNORE1          S              5S 0

     C     *ENTRY        PLIST
     C                   PARM                    WFile
     C                   PARM                    WMode
      *
     C                   Z-ADD     0             WWNORE1
     C                   Z-ADD     0             FNORE1
      *
     C                   SELECT
      *
      * Update trailer file GEDLZZ
      *
     C                   WHEN      WFile = 'GEDL3ZZ'
     C                             AND WMode = 'Update'
      *
     C/EXEC SQL
     C+ select (a.NORE1 + b.NORE1) - 2 into :WWNORE1
     C+ from GEDLZZ a, GEDL3ZZ b
     C/END-EXEC
      *
     C                   MOVE      WWNORE1       FNORE1
      *
     C/EXEC SQL
     C+ update GEDLZZ set
     C+ NORE1 = :FNORE1,
     C+ HRWN = (select cast(
     C+          (a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+          (b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+          as numeric (15,0) ) from GEDLZZ a, GEDL3ZZ b ),
     C+ HRDC = (select cast( ( mod( cast(
     C+          (a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+          (b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+          as numeric (18,3) ) , 1 ) * 1000 ) as numeric(3,0) )
     C+          from GEDLZZ a, GEDL3ZZ b )
     C/END-EXEC
      *
      * Update trailer file GEDL2ZZ
      *
     C                   WHEN      WFile = 'GEDL4ZZ'
     C                             AND WMode = 'Update'
      *
     C/EXEC SQL
     C+ select (a.NORE1 + b.NORE1) - 2 into :WWNORE1
     C+ from GEDL2ZZ a, GEDL4ZZ b
     C/END-EXEC
      *
     C                   MOVE      WWNORE1       FNORE1
      *
     C/EXEC SQL
     C+ update GEDL2ZZ set
     C+ NORE1 = :FNORE1,
     C+ HRWN = (select cast(
     C+          (a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+          (b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+          as numeric (15,0) ) from GEDL2ZZ a, GEDL4ZZ b ),
     C+ HRDC = (select cast( ( mod( cast(
     C+          (a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+          (b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+          as numeric (18,3) ) , 1 ) * 1000 ) as numeric(3,0) )
     C+          from GEDL2ZZ a, GEDL4ZZ b )
     C/END-EXEC
      *
      * Update trailer file DKEYSZZ
      *
     C                   WHEN      WFile = 'DKEYSZZ'
     C                             AND WMode = 'Update'

     C/EXEC SQL
     C+ select (a.NORE + b.NORE) - 2 into :WWNORE1
     C+ from DKEYSZZ a, DKEYS1ZZ b
     C/END-EXEC
      *
     C                   MOVE      WWNORE1       FNORE1
      *
     C/EXEC SQL
     C+ update DKEYSZZ set
     C+ NORE = :FNORE1,
     C+ HRWN = (select cast(
     C+          (a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+          (b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+          as numeric (15,0) ) from DKEYSZZ a, DKEYS1ZZ b ),
     C+ HRDC = (select cast( ( mod( cast(
     C+          (a.HRWN + cast( (a.HRDC /1000) as numeric (3,3) ) ) +
     C+          (b.HRWN + cast( (b.HRDC /1000) as numeric (3,3) ) )
     C+          as numeric (18,3) ) , 1 ) * 1000 ) as numeric(3,0) )
     C+          from DKEYSZZ a, DKEYS1ZZ b )
     C/END-EXEC
      *
      **Reset trailer file DKEYSZZ
      *
     C                   WHEN      WFile = 'DKEYSZZ'
     C                             AND WMode = 'Reset'
      *
     C/EXEC SQL
     C+ update DKEYSZZ set
     C+ NORE = 2,
     C+ HRWN = 0,
     C+ HRDC = 0
     C/END-EXEC
      *
     C                   ENDSL
      *
     C                   RETURN
      *****************************************************************
