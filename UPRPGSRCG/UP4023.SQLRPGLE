     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - aDBU List key difference')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP4023 - aDBU List difference in key                         *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD058585 *CREATE     Date 17Aug21             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058585 - aDBU does not detect if LF has different keys     *
      *                                                               *
      *****************************************************************
      /EJECT
     FUPCLOGPD  O  A E             DISK

     D S_JOB           S             10
     D S_FILE          S             10
     D X_DATA          S             30
      *
     D G1VLIB          S             10
     D G2VLIB          S             10
     D CLIB            S             10
     D CFIL            S             10
     D CFLD            S             10
     D CPOS            S              5  0
     D CORD            S              1
     D                 DS
     D  DateStamp              1     12
     D  yy                     1      2
     D  mm                     3      4
     D  dd                     5      6
      *
      /SPACE 3
      *
     D SQLDynStmt      S            500A
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  R_JOB                244    253
     D  R_USER               254    263


     C     *ENTRY        PLIST
     C                   PARM                    Lib1             10
     C                   PARM                    Lib2             10
     C                   PARM                    LAYER             7

     C                   eval      G1VLIB = Lib1
     C                   eval      G2VLIB = Lib2

     C                   eval      SQLDynStmt = 'select ' +
     C                             'dbklib, dbkfil, dbkfld ,dbkpos, dbkord ' +
     C                             ' FROM QADBKATR a WHERE not exists ' +
     C                             '(select * FROM QADBKATR b whERE b.DBKLIB ' +
     C                             ' = ' + '''' + G1VLIB + '''' + ' and ' +
     C                             'a.DBKFIL concat a.DBKFLD concat ' +
     C                             'char(a.DBKPOS) concat(a.DBKORD) ' +
     C                             ' = b.DBKFIL concat b.DBKFLD concat ' +
     C                             'char(b.DBKPOS) concat(b.DBKORD))' +
     C                             ' and a.DBKLIB ' +
     C                             ' = ' + '''' + G2VLIB + '''' + ' and ' +
     C                             'exists (select * FROM QADBKATR b whERE ' +
     C                             'b.DBKLIB =' + '''' + G1VLIB + '''' +
     C                             ' and a.DBKFIL = b.DBKFIL)'

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
     C+ fetch C1 into :CLIB, :CFIL, :CFLD, :CPOS, :CORD
     C/END-EXEC
     C                   Dow       SQLCODE = 0
     C                   eval      X_DATA = %trim(CFLD) + ' / ' + %char(CPOS) +
     C                             ' / ' + CORD

     C                   EVAL      WJOB  = G1VLIB
     C                   EVAL      WFILE = CFIL
     C                   EVAL      WDSP  = 'DSPFD_K'
     C                   EVAL      WTYPE = *blanks
     C                   EVAL      WLIB1 = G1VLIB
     C                   EVAL      WLIB2 = G2VLIB
     C                   EVAL      WFLD1 = *BLANKS
     C                   EVAL      WFLD2 = CFLD
     C                   EVAL      WFLDA = 'Key'
     C                   EVAL      WDESC = 'Key changed'
     C                   EVAL      WFDEC = *BLANKS
     C                   EVAL      WDATA = X_DATA
     C                   EVAL      WWHDS = *BLANKS
     C                   WRITE     UPCLOGD0
     C/EXEC SQL
     C+ fetch C1 into :CLIB, :CFIL, :CFLD, :CPOS, :CORD
     C/END-EXEC
     C                   enddo

     C/EXEC SQL
     C+ close C1
     C/END-EXEC

     C                   seton                                        LR
     C                   return
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
