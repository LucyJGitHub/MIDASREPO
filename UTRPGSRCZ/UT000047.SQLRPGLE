      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
     F*****************************************************************
/*STD *  RPGSQLBND
/*EXI *  TEXT('Midas UT Build Calling Parameter List Arrary')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000047 - Build Calling Parameter List array                *
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
 
     D SrcOut          DS
     D  O_SrcSeq                      6  2
     D  O_SrcDat                      6  0
     D  O_SrcDta                    100A
 
     D ParmFldDS       DS
     D PFldArr                       10A   DIM(10)
 
     D ParmDS          DS
     D ParmEnt                       10A   DIM(80)
 
     D ParmStrDS       DS
     D ParmStr                      800A   DIM(10)
 
     D Nrfd            S              1A
     D Stmt            S            500A
     D Operr           S              1A
     D PlstStart       S              1A
 
     D OutFile2        S             10A
 
     D SrcEnd          S              1A
     D ParmChar        S              4A   INZ('PARM')
     D PLSTChar        S              4A   INZ('PLIS')
     D EQChar          S              1A   INZ('=')
     D SpChar          S              1A   INZ(' ')
     D BkChar          S              1A   INZ('(')
     D QuChar          S              1A   INZ('''')
 
     D ParmIdx         S              2  0
     D ParmNo          S              2  0
     D LkUp            S              2  0
     D StrPos          S              3  0
     D FdLen           S              3  0
 
     D CmdStr          S              4A
     D ResStr          S             14A
     D FacStr          S             14A
 
     D @UC             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D @LC             C                   'abcdefghijklmnopqrstuvwxyz'
 
      *****************************************************************
      *  M A I N L I N E   P R O C E S S                              *
      *****************************************************************
 
     C                   EVAL      SrcEnd  = 'N'
     C                   EVAL      PLstStart = 'N'
     C                   EVAL      ParmFldDS = *BLANKS
     C                   EVAL      ParmDS = *BLANKS
     C                   EVAL      ParmStrDS = *BLANKS
     C                   EVAL      ParmNo = 0
     C                   EXSR      InitSrcFile
 
      ** Do until end of driving file UTPGMLPD
 
     C                   DOW       SrcEnd  = 'N'
     C                   EXSR      FetchSrc
     C                   IF        SrcEnd = 'N'
     C                   EXSR      Scan_Src
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        PlstStart = 'Y'
     C                   EVAL      PlstStart = 'N'
     C                   EVAL      ParmStr(ParmNo) = ParmDS
     C                   EVAL      ParmDS = *BLANKS
     C                   ENDIF
 
     C                   EXSR      Close_Src
 
     C                   SETON                                        LR
 
 
      *****************************************************************
      *                                                               *
      * InitSrcFile - Setup pointer to the work file                  *
      *                                                               *
      *****************************************************************
     C     InitSrcFile   BEGSR
 
     C                   EVAL      Stmt = 'SELECT * from '  +  OutFile2
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
 
     C                   IF        Nrfd = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * FetchSrc  - Read Source File                                  *
      *                                                               *
      *****************************************************************
     C     FetchSrc      BEGSR
 
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
 
     C                   IF        Nrfd = 'Y' or  SQLSTT = '02000'
     C                   EVAL      SrcEnd = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * Scan_Src - Scanning for Required String                       *
      *                                                               *
      *****************************************************************
     C     Scan_Src      BEGSR
 
     C                   EVAL      CmdStr = %SubSt(O_SrcDta:26:4)
     C                   EVAL      CmdStr = %XLATE(@LC:@UC:CmdStr)
 
     C                   IF        PlstStart = 'Y' and
     C                             CmdStr <> ParmChar
     C                   EVAL      PlstStart = 'N'
     C                   EVAL      ParmStr(ParmNo) = ParmDS
     C                   EVAL      ParmDS = *BLANKS
     C                   ENDIF
 
     C                   IF        PlstStart = 'Y' and
     C                             CmdStr = ParmChar
     C                   EXSR      Store_Parm
     C                   ENDIF
 
     C                   IF        CmdStr = PLSTChar
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
 
     C                   EVAL      FacStr = %SubSt(O_SrcDta:12:12)
     C                   EVAL      FdLen = %Len(%TRIM(FacStr))
     C                   EVAL      StrPos = %SCAN(QuChar:FacStr)
 
     C                   IF        StrPos > 0
     C                   EVAL      FacStr= %Subst(FacStr:StrPos+1:FdLen-2)
     C                   ENDIF
 
     C                   EVAL      ParmNo = ParmNo + 1
     C                   EVAL      ParmIdx = 0
 
     C                   EVAL      PFldArr(ParmNo) = %TRIM(FacStr)
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * Store_Parm - Store Parameter List                             *
      *                                                               *
      *****************************************************************
     C     Store_Parm    BEGSR
 
     C                   EVAL      ResStr = %SubSt(O_SrcDta:50:12)
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
      * Close_Src - Close Source file                                 *
      *                                                               *
      *****************************************************************
     C     Close_Src     BEGSR
 
     C/EXEC SQL WHENEVER SQLERROR GOTO CloseErrS
     C/END-EXEC
 
     C/EXEC SQL WHENEVER NOT FOUND GOTO CloseErrS
     C/END-EXEC
 
     C/EXEC SQL
     C+  CLOSE C2
     C/END-EXEC
 
     C     CloseErrS     TAG
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    OutFile2
     C                   PARM                    ParmFldDS
     C                   PARM                    ParmStrDS
 
     C                   ENDSR
 
