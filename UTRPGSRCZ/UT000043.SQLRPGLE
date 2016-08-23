      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
     F*****************************************************************
/*STD *  RPGSQLBND
/*EXI *  TEXT('Midas UT Get New Error Fields Name')
      *****************************************************************
      *                                                               *
      *  Midas - UT Module                                            *
      *                                                               *
      *  UT000043 - Get New Error/Warning Field Names                 *
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
 
     D EParmDS         DS
     D EParmPos                       2  0 DIM(50)
 
     D WParmDS         DS
     D WParmPos                       2  0 DIM(50)
 
     D EFPDS           DS
     D EFPos                          2  0 DIM(50)
 
     D WFPDS           DS
     D WFPos                          2  0 DIM(50)
 
     D MFPDS           DS
     D MFPos                          2  0 DIM(5)
 
     D SrcOut          DS
     D  O_SrcSeq                      6  2
     D  O_SrcDat                      6  0
     D  O_SrcDta                    100A
 
     D ParmDS          DS
     D  ParmEnt                      10A   DIM(80)
 
     D ErrDS           DS
     D ErrArr                        10A   DIM(50)
 
     D WERRDS          DS
     D WErrArr                       10A   DIM(50)
 
     D EFNDS           DS
     D EFNArr                        10A   DIM(50)
 
     D WFNDS           DS
     D WFNArr                        10A   DIM(50)
 
     D MFNDS           DS
     D MFNArr                        10A   DIM(5)
 
     D FileName        S             10A
     D LibName         S             10A
     D MemberName      S             10A
     D OutFile         S             10A
 
     D CmdStr          S              4A
     D ResStr          S             14A
     D FacStr          S             14A
     D EqStr           S             45A
     D WkStr           S             45A
     D STMT            S            100A
     D STMT2           S           1500A
     D WKStmt          S           1500A
     D DropStmt        S            100A
 
     D ParmIdx         S              2  0
     D Idx             S              2  0
     D PIdx            S              2  0
     D StrPos          S              3  0
     D FdLen           S              3  0
 
     D PlstStart       S              1A
     D Operr           S              1A
     D Nrfd            S              1A
     D OpenErr         S              1A
     D SrcEnd          S              1A
 
     D CallChar        S              4A   INZ('CALL')
     D ParmChar        S              4A   INZ('PARM')
     D PLSTChar        S              4A   INZ('PLIS')
     D BkChar          S              1A   INZ('(')
     D QuChar          S              1A   INZ('''')
 
     D @UC             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D @LC             C                   'abcdefghijklmnopqrstuvwxyz'
 
      *****************************************************************
      *  M A I N L I N E   P R O C E S S                              *
      *****************************************************************
 
     C                   EXSR      Build_Stmt
     C                   EXSR      Prep_SQLStm
     C                   EXSR      BuildParmList
     C                   EXSR      CheckFdName
 
 
     C                   EXSR      Clean_Up
     C                   EXSR      Close_File
 
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
                  + '(ucase(substr(SRCDTA,12,6)) = ' + '''*ENTRY''' + ' or '
                  +  'ucase(substr(SRCDTA,26,4)) = ' + '''PARM''' +  ' or '
                  +  'ucase(substr(SRCDTA,26,4)) = ''CALL'')) '
                  +  ') with Data';
         Stmt2 = %TRIM(WKStmt);
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
 
     C     ERRP1         TAG
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * BuildParmList - Build program call parameter list             *
      *                                                               *
      *****************************************************************
     C     BuildParmList BEGSR
 
     C                   EXSR      InitFile
 
     C                   EVAL      SrcEnd = 'N'
     C                   EVAL      PlstStart = 'N'
 
     C                   DOW       SrcEnd <> 'Y'
 
     C                   EXSR      ReadSrc
 
     C                   IF        SrcEnd <> 'Y'
     C                   EXSR      CheckStr
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * InitFile - Setup pointer to the work file                     *
      *                                                               *
      *****************************************************************
     C     InitFile      BEGSR
 
     C                   EVAL      Stmt = 'SELECT * from '  +
     C                                    OutFile
     C                   EVAL      SrcOut   = *BLANKS
     C                   EVAL      Operr = 'P'
     C                   EVAL      Nrfd  = 'Y'
 
     C/EXEC SQL WHENEVER SQLERROR GOTO ERROP2
     C/END-EXEC
 
     C                   EVAL      Operr = 'O'
 
     C/EXEC SQL WHENEVER NOT FOUND GOTO NRECF2
     C/END-EXEC
 
     C/EXEC SQL
     C+ PREPARE S2 FROM :STMT
     C/END-EXEC
 
     C/EXEC SQL
     C+ DECLARE C2 CURSOR FOR S2
     C/END-EXEC
     C/EXEC SQL
     C+ OPEN C2
     C/END-EXEC
 
     C                   EVAL      Nrfd  = 'N'
 
     C     NRECF2        TAG
     C     ERROP2        TAG
 
     C                   EVAL      Stmt = Stmt
 
     C                   IF        Nrfd = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * ReadSrc - Read Source File                                    *
      *                                                               *
      *****************************************************************
     C     ReadSrc       BEGSR
 
     C                   EVAL      Operr = 'P'
     C                   EVAL      Nrfd = 'Y'
 
     C/EXEC SQL WHENEVER SQLERROR GOTO ERROP3
     C/END-EXEC
 
     C                   EVAL      Operr = 'O'
 
     C/EXEC SQL WHENEVER NOT FOUND GOTO NRECF3
     C/END-EXEC
 
     C/EXEC SQL
     C+  FETCH C2 INTO :SrcOut
     C/END-EXEC
 
     C                   EVAL      Nrfd  = 'N'
 
     C     NRECF3        TAG
     C     ERROP3        TAG
 
     C                   IF        Nrfd = 'Y' OR
     C                             SQLSTT = '02000'
     C                   EVAL      SrcEnd = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * CheckStr - Check for required Source String                   *
      *                                                               *
      *****************************************************************
     C     CheckStr      BEGSR
 
     C                   EVAL      CmdStr = %SubSt(O_SrcDta:26:4)
     C                   EVAL      CmdStr = %XLATE(@LC:@UC:CmdStr)
 
     C                   IF        PlstStart = 'Y' AND
     C                             CmdStr <> ParmChar
     C                   EVAL      PlstStart = 'N'
     C                   ENDIF
 
     C                   IF        PlstStart = 'Y' AND
     C                             CmdStr = ParmChar
     C                   EXSR      Store_Parm
     C                   ENDIF
 
     C                   IF        CmdStr = PlstChar
     C                   EVAL      PlstStart = 'Y'
     C                   EXSR      Start_Store
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * Start_Store - Start of the collection process                 *
      *                                                               *
      *****************************************************************
     C     Start_Store   BEGSR
 
     C                   EVAL      ParmDS = *BLANKS
     C                   EVAL      FacStr = %SubSt(O_SrcDta:36:14)
     C                   EVAL      FdLen = %Len(%TRIM(FacStr))
     C                   EVAL      StrPos = %SCAN(QuChar:FacStr)
 
     C                   IF        StrPos > 0
     C                   EVAL      FacStr= %Subst(FacStr:StrPos+1:FdLen-2)
     C                   ENDIF
 
     C                   EVAL      ParmIdx = 0
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * Store_Parm - Store Parameter List                             *
      *                                                               *
      *****************************************************************
     C     Store_Parm    BEGSR
 
     C                   EVAL      ResStr = %SubSt(O_SrcDta:50:14)
     C                   EVAL      FdLen = %Len(%TRIM(ResStr))
     C                   EVAL      StrPos = %SCAN(BkChar:ResStr)
 
     C                   IF        StrPos > 0
     C                   EVAL      ResStr= %Subst(ResStr:1:StrPos-1)
     C                   ENDIF
 
     C                   EVAL      ParmIdx = ParmIdx + 1
     C                   EVAL      ParmEnt(ParmIdx) = %TRIM(ResStr)
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * CheckFdName - Check fields position in the parameter list     *
      *                                                               *
      *****************************************************************
     C     CheckFdName   BEGSR
 
      ** Get new Error Field Name from Calling parameter list
 
     C                   EVAL      Idx = 0
     C                   DOW       Idx < 50
     C                   EVAL      Idx = Idx + 1
     C                   IF        EParmPos(Idx) > 0
     C                   EVAL      PIdx = EParmPos(Idx)
     C                   EVAL      ErrArr(Idx) = ParmEnt(PIdx)
     C                   ELSE
     C                   EVAL      Idx = 90
     C                   ENDIF
     C                   ENDDO
 
      ** Get new Warning Field Name from Calling parameter list
 
     C                   EVAL      Idx = 0
     C                   DOW       Idx < 50
     C                   EVAL      Idx = Idx + 1
     C                   IF        WParmPos(Idx) > 0
     C                   EVAL      PIdx = WParmPos(Idx)
     C                   EVAL      WErrArr(Idx) = ParmEnt(PIdx)
     C                   ELSE
     C                   EVAL      Idx = 90
     C                   ENDIF
     C                   ENDDO
 
      ** Get new 'Error Field' Field Name from Calling parameter list
 
     C                   EVAL      Idx = 0
     C                   DOW       Idx < 50
     C                   EVAL      Idx = Idx + 1
     C                   IF        EFPos(Idx) > 0
     C                   EVAL      PIdx = EFPos(Idx)
     C                   EVAL      EFNArr(Idx) = ParmEnt(PIdx)
     C                   ELSE
     C                   EVAL      Idx = 90
     C                   ENDIF
     C                   ENDDO
 
      ** Get new 'Warning Error Field' Field Name from Calling parameter list
 
     C                   EVAL      Idx = 0
     C                   DOW       Idx < 50
     C                   EVAL      Idx = Idx + 1
     C                   IF        WFPos(Idx) > 0
     C                   EVAL      PIdx = WFPos(Idx)
     C                   EVAL      WFNArr(Idx) = ParmEnt(PIdx)
     C                   ELSE
     C                   EVAL      Idx = 90
     C                   ENDIF
     C                   ENDDO
 
      ** Get new Message file field Name from Calling parameter list
 
     C                   EVAL      Idx = 0
     C                   DOW       Idx < 50
     C                   EVAL      Idx = Idx + 1
     C                   IF        MFPos(Idx) > 0
     C                   EVAL      PIdx = MFPos(Idx)
     C                   EVAL      MFNArr(Idx) = ParmEnt(PIdx)
     C                   ELSE
     C                   EVAL      Idx = 90
     C                   ENDIF
     C                   ENDDO
 
     C                   EVAL      P_PCERRN = ErrDS
     C                   EVAL      P_PCWERR = WErrDS
     C                   EVAL      P_PCERRF = EFNDS
     C                   EVAL      P_PCWERF = WFNDS
 
     C                   IF        MFNDS <> *BLANKS
     C                   EVAL      P_PCMSGF = MFNDS
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * Dlt_Table - Delete work Table                                 *
      *                                                               *
      *****************************************************************
     C     Dlt_Table     BEGSR
 
     C/EXEC SQL WHENEVER SQLERROR GOTO DltErr
     C/END-EXEC
 
     C/EXEC SQL WHENEVER NOT FOUND GOTO DltErr
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
 
     C/EXEC SQL WHENEVER NOT FOUND GOTO MonErr
     C/END-EXEC
 
     C/EXEC SQL
     C+  Drop ALIAS QTEMP/WorkLink
     C/END-EXEC
 
     C     MonErr        ENDSR
 
      *****************************************************************
      *                                                               *
      * Close file - Close  work filee                                *
      *                                                               *
      *****************************************************************
     C     Close_File    BEGSR
 
     C/EXEC SQL WHENEVER SQLERROR GOTO CloseErr
     C/END-EXEC
 
     C/EXEC SQL WHENEVER NOT FOUND GOTO CloseErr
     C/END-EXEC
 
     C/EXEC SQL
     C+  CLOSE C2
     C/END-EXEC
 
     C     CloseErr      TAG
 
     C                   ENDSR
 
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
     C                   PARM                    SQLOut
 
     C                   EVAL      OutFile = 'WorkPlistF'
 
     C                   MOVE      P_PCERRP      EParmDS
     C                   MOVE      P_PCWERP      WParmDS
     C                   MOVE      P_PCERFP      EFPDS
     C                   MOVE      P_PCWRFP      WFPDS
     C                   MOVE      P_PCMSGP      MFPDS
 
     C                   EVAL      ErrDS = *BLANKS
     C                   EVAL      WErrDS = *BLANKS
     C                   EVAL      EFNDS = *BLANKS
     C                   EVAL      WFNDS = *BLANKS
     C                   EVAL      MFNDS = *BLANKS
 
     C                   ENDSR
 
