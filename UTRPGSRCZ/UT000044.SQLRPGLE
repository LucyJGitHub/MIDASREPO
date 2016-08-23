      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
     F*****************************************************************
/*STD *  RPGSQLBND
/*EXI *  TEXT('Midas UT Build Source for Scan')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000044 - Build Source for Scan                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CBF011   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
     F*****************************************************************
 
     D SQLOut        E DS                  EXTNAME(UTPGMLPD)
     D                                     Prefix(P_)
 
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
     D STMT2           S           9000A
     D WKStmt          S           9000A
     D DropStmt        S            100A
     D Idx             S              2  0
 
     D ErrDS           DS
     D ErrArr                        10A   DIM(50)
 
     D WERRDS          DS
     D WErrArr                       10A   DIM(50)
 
     D ErFDS           DS
     D ErFArr                        10A   DIM(50)
 
     D WErFDS          DS
     D WErFArr                       10A   DIM(50)
 
     D MsgFDS          DS
     D MsgFArr                       10A   DIM(5)
 
     D WorkDS          DS
     D WorkArr                       10A   DIM(50)
 
     D NwErrDs         DS
     D NwErrArr                      10A   DIM(50)
 
     D NwWERRDS        DS
     D NwWErrAr                      10A   DIM(50)
 
      *****************************************************************
      *  M A I N L I N E   P R O C E S S                              *
      *****************************************************************
 
     C                   EXSR      Build_Stmt
 
     C                   EXSR      Prep_SQLStm
 
     C                   EXSR      Clean_Up
 
     C                   SETON                                            LR
 
      *****************************************************************
      *                                                               *
      * Build_Stmt - Build SQL Statment                               *
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
 
     C                   IF        P_PCAPIF <> *BLANKS
     C                   EXSR      AddAPIFld
     C                   ENDIF
 
     C                   EVAL      WorkDS = *BLANKS
     C                   EVAL      WorkDS = ErrDS
     C                   EXSR      AddFields
 
     C                   EVAL      WorkDS = *BLANKS
     C                   EVAL      WorkDS = WErrDS
     C                   EXSR      AddFields
 
     C                   EVAL      WorkDS = *BLANKS
     C                   EVAL      WorkDS = ErFDS
     C                   EXSR      AddFields
 
     C                   EVAL      WorkDS = *BLANKS
     C                   EVAL      WorkDS = WErFDS
     C                   EXSR      AddFields
 
     C                   EVAL      WorkDS = *BLANKS
     C                   EVAL      WorkDS = MsgFDS
     C                   EXSR      AddFields
 
     C                   EVAL      WorkDS = *BLANKS
     C                   EVAL      WorkDS = NwErrDS
     C                   EXSR      AddFields
 
     C                   EVAL      WorkDS = *BLANKS
     C                   EVAL      WorkDS = NwWErrDS
     C                   EXSR      AddFields
 
     C                   IF        P_PCAPIF <> *BLANKS
     C                   EXSR      AddAPIFld
     C                   ENDIF
 
      /free
         WKStmt = %TRIM(WkStmt) + ') with Data';
         Stmt2 = %TRIM(WKStmt);
      /end-free
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * AddFields - Add error fields for Select statement             *
      *                                                               *
      *****************************************************************
     C     AddFields     BEGSR
 
     C                   EVAL      EndErr = 'N'
     C                   EVAL      Idx = 0
     C                   DOW       EndErr <> 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   IF        WorkArr(Idx) = *Blank
     C                   EVAL      EndErr = 'Y'
     C                   ELSE
     C                   EVAL      ErrID = WorkArr(Idx)
     C                   EXSR      AddSelErr
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * AddSelErr - Add error fields for Select statement             *
      *                                                               *
      *****************************************************************
     C     AddSelErr     BEGSR
 
     C                   EVAL      ErrFLen = %Len(%TRIM(ErrID))
     C                   EVAL      LenChar = %CHAR(ErrFLen)
 
      /free
        WkStmt = %TRIM(WKStmt) + ' or '
                  +  '(ucase(SUBSTR(SRCDTA,6,3)) = '
                  + '''' + 'C  '+ '''' + ' and '
                  + '(ucase(substr(SRCDTA,26,4)) = ''MOVE'' and '
                  +  '(ucase(substr(SRCDTA,50,' + %TRIM(LenChar)
                  +  ')) = ucase('
                  +   '''' + %triM(ErrID) + '''' + ')) or '
                  + '(ucase(substr(SRCDTA,26,4)) = ''EVAL'' and '
                  +  '(ucase(substr(SRCDTA,36,' + %TRIM(LenChar)
                  +  ')) = ucase('
                  +   '''' + %triM(ErrID) + '''' + ')))))';
      /end-free
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * AddAPIFld - Add API field to Select Statement                 *
      *                                                               *
      *****************************************************************
     C     AddAPIFld     BEGSR
 
     C                   EVAL      ErrFLen = %Len(%TRIM(P_PCAPIF))
     C                   EVAL      LenChar = %CHAR(ErrFLen)
 
      /free
        WkStmt = %TRIM(WKStmt) + ' or '
                  +  '(ucase(SUBSTR(SRCDTA,6,3)) = '
                  + '''' + 'C  '+ '''' + ' and '
                  + '(ucase(substr(SRCDTA,26,4)) = ''WHEN'' and '
                  +  '(ucase(substr(SRCDTA,12,' + %TRIM(LenChar)
                  +  ')) = ucase('
                  +   '''' + %triM(P_PCAPIF) + '''' + '))))';
      /end-free
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * Prep_SQLStm - Process SQL Statment                            *
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
      * Dlt_Table - Delete work Table                                 *
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
      * Clean_Up - Clean up work space                                *
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
     C                   PARM                    SQLOut
     C                   PARM                    NwErrDS
     C                   PARM                    NwWErrds
 
     C                   EVAL      ErrDS = P_PCERRN
     C                   EVAL      WErrDS = P_PCWERR
     C                   EVAL      ErFDS = P_PCERRF
     C                   EVAL      WErFDS = P_PCWERF
     C                   EVAL      MsgFDS  = P_PCMSGF
 
     C                   ENDSR
 
