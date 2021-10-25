     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Retrieve System Values All')
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UPSVALR0 - This program retireves System Values from either  *
      *             Global or Zone layer from old SDSVALPD/GPSVALPD   *
      *             if still existing, else from DDS files.           *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************


     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )
     D SQLDynBase      S             50A
     D SQLDynStmt      S            500A

     D/COPY ZACPYSRC,PSDS
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************
      **  Program Parameters

      *  These comprise:
      *  - layer
      *  - a general return code, if any errors found
      *  - 10 sets of paired option and value fields

     C     *ENTRY        PLIST
     C                   PARM                    Layer             7
     C                   PARM                    Return            7
     C                   PARM                    P@OP01           20
     C                   PARM                    P@VL01          200
     C                   PARM                    P@OP02           20
     C                   PARM                    P@VL02          200
     C                   PARM                    P@OP03           20
     C                   PARM                    P@VL03          200
     C                   PARM                    P@OP04           20
     C                   PARM                    P@VL04          200
     C                   PARM                    P@OP05           20
     C                   PARM                    P@VL05          200
     C                   PARM                    P@OP06           20
     C                   PARM                    P@VL06          200
     C                   PARM                    P@OP07           20
     C                   PARM                    P@VL07          200
     C                   PARM                    P@OP08           20
     C                   PARM                    P@VL08          200
     C                   PARM                    P@OP09           20
     C                   PARM                    P@VL09          200
     C                   PARM                    P@OP10           20
     C                   PARM                    P@VL10          200

      * Reset return fields

     C                   CLEAR                   Return
     C                   CLEAR                   P@VL01          200
     C                   CLEAR                   P@VL02          200
     C                   CLEAR                   P@VL03          200
     C                   CLEAR                   P@VL04          200
     C                   CLEAR                   P@VL05          200
     C                   CLEAR                   P@VL06          200
     C                   CLEAR                   P@VL07          200
     C                   CLEAR                   P@VL08          200
     C                   CLEAR                   P@VL09          200
     C                   CLEAR                   P@VL10          200

      * check what file should be used
     C                   If        Layer = '*GLOBAL'
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RtnCode          10
     C                   PARM      'GPSVALL0'    ObjName          10
     C                   PARM      '*LIBL'       ObjLib           10
     C                   PARM      '*FILE'       ObjType           8
     C                   PARM                    ChkMbr           10

     C                   IF        RtnCode = 'Exist     '
     C                   eval      SQLDynBase = 'select GIVAL    from ' +
     C                             ' GPSVALL0 where GISVAL = '
     C                   else
     C                   eval      SQLDynBase = 'select GIVAL    from ' +
     C                             ' GPSVLXTD where GISVAL = '
     C                   endif

     C                   else
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RtnCode          10
     C                   PARM      'SDSVALL0'    ObjName          10
     C                   PARM      '*LIBL'       ObjLib           10
     C                   PARM      '*FILE'       ObjType           8
     C                   PARM                    ChkMbr           10

     C                   IF        RtnCode = 'Exist     '
     C                   eval      SQLDynBase = 'select GIVAL    from ' +
     C                             ' SDSVALL0 where GISVAL = '
     C                   else
     C                   eval      SQLDynBase = 'select GIVAL    from ' +
     C                             ' SDSVLXTD where GISVAL = '
     C                   endif

     C                   endif

     C                   If        P@OP01 <> *blanks
     C                   eval      SQLDynStmt = %trimr(SQLDynBase) +
     C                             '''' + %trimr(P@OP01) + ''''
     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ declare C1 cursor with return to client for DynSQLStmnt
     C/end-exec

     C/EXEC SQL
     C+ open C1
     C/END-EXEC

     C/EXEC SQL
     C+ fetch C1 into :P@VL01
     C/END-EXEC

     C                   If        SQLCODE = 100
     C                   Eval      P@VL01 = '*NRF'
     C                   Eval      Return = '*NRF'
     C                   ENDIF

     C/EXEC SQL
     C+ Close C1
     C/END-EXEC
     C                   endif

     C                   If        P@OP02 <> *blanks
     C                   eval      SQLDynStmt = %trimr(SQLDynBase) +
     C                             '''' + %trimr(P@OP02) + ''''
     C/EXEC SQL
     C+ prepare DynSQLStmnt2
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ declare C2 cursor with return to client for DynSQLStmnt2
     C/end-exec

     C/EXEC SQL
     C+ open C2
     C/END-EXEC

     C/EXEC SQL
     C+ fetch C2 into :P@VL02
     C/END-EXEC

     C                   If        SQLCODE = 100
     C                   Eval      P@VL02 = '*NRF'
     C                   Eval      Return = '*NRF'
     C                   ENDIF

     C/EXEC SQL
     C+ Close C2
     C/END-EXEC
     C                   endif

     C                   If        P@OP03 <> *blanks
     C                   eval      SQLDynStmt = %trimr(SQLDynBase) +
     C                             '''' + %trimr(P@OP03) + ''''
     C/EXEC SQL
     C+ prepare DynSQLStmnt3
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ declare C3 cursor with return to client for DynSQLStmnt3
     C/end-exec

     C/EXEC SQL
     C+ open C3
     C/END-EXEC

     C/EXEC SQL
     C+ fetch C3 into :P@VL03
     C/END-EXEC

     C                   If        SQLCODE = 100
     C                   Eval      P@VL03 = '*NRF'
     C                   Eval      Return = '*NRF'
     C                   ENDIF

     C/EXEC SQL
     C+ Close C3
     C/END-EXEC
     C                   endif

     C                   If        P@OP04 <> *blanks
     C                   eval      SQLDynStmt = %trimr(SQLDynBase) +
     C                             '''' + %trimr(P@OP04) + ''''
     C/EXEC SQL
     C+ prepare DynSQLStmnt4
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ declare C4 cursor with return to client for DynSQLStmnt4
     C/end-exec

     C/EXEC SQL
     C+ open C4
     C/END-EXEC

     C/EXEC SQL
     C+ fetch C4 into :P@VL04
     C/END-EXEC

     C                   If        SQLCODE = 100
     C                   Eval      P@VL04 = '*NRF'
     C                   Eval      Return = '*NRF'
     C                   ENDIF

     C/EXEC SQL
     C+ Close C4
     C/END-EXEC
     C                   endif

     C                   If        P@OP05 <> *blanks
     C                   eval      SQLDynStmt = %trimr(SQLDynBase) +
     C                             '''' + %trimr(P@OP05) + ''''
     C/EXEC SQL
     C+ prepare DynSQLStmnt5
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ declare C5 cursor with return to client for DynSQLStmnt5
     C/end-exec

     C/EXEC SQL
     C+ open C5
     C/END-EXEC

     C/EXEC SQL
     C+ fetch C5 into :P@VL05
     C/END-EXEC

     C                   If        SQLCODE = 100
     C                   Eval      P@VL05 = '*NRF'
     C                   Eval      Return = '*NRF'
     C                   ENDIF

     C/EXEC SQL
     C+ Close C5
     C/END-EXEC
     C                   endif

     C                   Seton                                        LR
     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program Exception Error Routine                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      Return = '*ERROR'
     C                   RETURN

     C                   ENDSR

      ********************************************************************
