     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - aDBU List SQL statement views')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP4024 - aDBU List SQL statement views                       *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD059751 *CREATE   Date 25Mar22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059751 - SQL view statement change is not detected by aDBU *
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

     C                   eval      SQLDynStmt = 'insert into SQLSTM_C1 ' +
     C                             'SELECT SYS_VNAME, ' +
     C                             ' cast (text as varchar(5000)) FROM ' +
     C                             'sysviews WHERE SYS_VDNAME = ' + '''' +
     C                             %trim(G1VLIB) + '''' +
     C                             ' and text is not null'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   eval      SQLDynStmt = 'insert into SQLSTM_C2 ' +
     C                             'SELECT SYS_VNAME, ' +
     C                             ' cast (text as varchar(5000)) FROM ' +
     C                             'sysviews WHERE SYS_VDNAME = ' + '''' +
     C                             %trim(G2VLIB) + '''' +
     C                             ' and text is not null' +
     C                             ' and SYS_VNAME in (select SVIEW ' +
     C                             'from SQLSTM_C1)'

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec


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
