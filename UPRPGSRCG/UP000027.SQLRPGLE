     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Report on files with triggers')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000027 - Check files/tables for which trigger must be      *
      *             removed                                           *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD060557 *CREATE   Date 22Sep22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060557 - Improvement in triggering process                 *
      *                                                               *
      *****************************************************************
      *
     D SQLDynStmt      S           1000A

     D PReturnCode     S              1
     D Recursive       S              1
     D MLIB            S             10
     D TLIB            S             10
     D Prfx            S              2
     D Layer           S              7

     C     *ENTRY        PLIST
     C                   PARM                    PReturnCode
     C                   PARM                    Prfx
     C                   PARM                    Layer

     C                   if        Layer = '*GLOBAL'
     C                   eval      MLIB = Prfx + 'GMLIB'
     C                   eval      TLIB = Prfx + 'GTALIB'
     C                   else
     C                   eval      MLIB = Prfx + 'DMLIB'
     C                   eval      TLIB = Prfx + 'DTALIB'
     C                   endif

     C                   eval      SQLDynStmt = 'insert into UPSFMTQF (' +
     C                             'SFSRCF, SFLIB1, SFNAME, SFFILE, SFLIB2,' +
     C                             'SFMBNM) select '' '', '' '', '' '',' +
     C                             ''' '',  s.SYS_DNAME ,  c.AUMBNM' +
     C                             ' from UPDLVCPD c join QSYS2.SYSTRIGGER s' +
     C                             ' on c.AUMBNM = s.SYS_TNAME where ' +
     C                             ' (s.SYS_DNAME = ''' + MLIB + ''' or ' +
     C                             ' s.SYS_DNAME = ''' + TLIB + ''')'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   IF        SQLCODE <> 0 and SQLCODE <> 100
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   EVAL      PReturnCode = 'E'
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      ********************************************************************
