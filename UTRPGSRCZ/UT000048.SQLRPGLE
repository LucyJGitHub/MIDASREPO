     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
     F*****************************************************************
/*STD *  RPGSQLBND
/*EXI *  TEXT('Midas UT Build Parameter List')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000048 - Build Parameter List                              *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Last Amend No. CBF011   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
     F*****************************************************************

     D EndErr          S              1A
     D EndWErr         S              1A
     D ErrFLen         S              2  0
     D ErrID           S             10A
     D WErrFLen        S              2  0
     D WErrID          S             10A
     D LenChar         S              2A

     D FileName        S             10A
     D LibName         S             10A
     D MemberName      S             10A
     D OutFile         S             10A
     D OpenErr         S              1A
     D STMT            S            100A
     D STMT2           S           1500A
     D WKStmt          S           1500A
     D DropStmt        S            100A
     D Idx             S              2  0

     D ErrDS           DS
     D ErrArr                        10A   DIM(50)

     D WERRDS          DS
     D WErrArr                       10A   DIM(50)

      *****************************************************************
      *  M A I N L I N E   P R O C E S S                              *
      *****************************************************************

     C                   EXSR      Build_Stmt

     C                   EXSR      Prep_SQLStm

     C                   EXSR      Clean_Up

     C                   SETON                                            LR

      *****************************************************************
      *                                                               *
      * Build_Stmt - Build Statement                                  *
      *                                                               *
      *****************************************************************
     C     Build_Stmt    BEGSR

      /free
        Stmt = 'CREATE ALIAS QTEMP/WorkLink FOR ' + %trim(LibName)
                + '/' + %trim(FileName) + '  (' + %trim(MemberName) + ')';
        DropStmt = 'Drop Table QTEMP/' + %trim(OutFile);
        WkStmt = 'Create Table qtemp/' + %trim(Outfile)
                  + ' (SRCSEQ, SRCDAT, SRCDTA) as'
                  +  ' (SELECT   SRCSEQ, SRCDAT, SRCDTA from '
                  +  '  QTEMP/WorkLink WHERE (SUBSTR(SRCDTA,6,3) = '
                  + '''' + 'C  '+ '''' + ' and '
                  + '(ucase(substr(SRCDTA,26,5)) = ' + '''PLIST''' + ' or '
                  +  'ucase(substr(SRCDTA,26,4)) = ' + '''PARM''' +  ' or '
                  +  'ucase(substr(SRCDTA,26,4)) = ''CALL'')) ';
      /end-free

      /free
         WKStmt = %TRIM(WkStmt) + ') with Data';
         Stmt2 = %TRIM(WKStmt);
      /end-free

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Prep_SQLStm - Prepare SQL Statement                           *
      *                                                               *
      *****************************************************************
     C     Prep_SQLStm   BEGSR

     C                   EVAL      OpenErr = 'Y'

     C/EXEC SQL WHENEVER SQLERROR GOTO ERRP1
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :Stmt
     C/END-EXEC

     C                   EXSR      Dlt_Table

     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :Stmt2
     C/END-EXEC

     C                   EVAL      OpenErr = 'N'
     C                   EVAL      SQLSTT = '00000'

     C     ERRP1         TAG

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Dlt_Table - Delete Table                                      *
      *                                                               *
      *****************************************************************
     C     Dlt_Table     BEGSR

     C/EXEC SQL WHENEVER SQLERROR GOTO DltErr
     C/END-EXEC

     C/EXEC SQL
     C+ EXECUTE IMMEDIATE :DropStmt
     C/END-EXEC

     C     DltErr        ENDSR

      *****************************************************************
      *                                                               *
      * Clean_Up - Clean Up                                           *
      *                                                               *
      *****************************************************************
     C     Clean_Up      BEGSR

     C/EXEC SQL WHENEVER SQLERROR GOTO MonErr
     C/END-EXEC

     C/EXEC SQL
     C+  Drop ALIAS QTEMP/WorkLink
     C/END-EXEC

     C     MonErr        ENDSR

      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    LibName
     C                   PARM                    FileName
     C                   PARM                    MemberName
     C                   PARM                    OutFile

     C                   ENDSR

