     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
     F*****************************************************************
/*STD *  RPGSQLBND
/*EXI *  TEXT('Midas UT Build New Error Fields List')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000049 - Build New Error Fields List                       *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. AR871874C          Date 13Jan12               *
      *  Prev Amend No. CBF011   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR871874C - Screens only display error message id and fields *
      *              and error message description is missing         *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
     F*****************************************************************

     D OutFile         S             10A
     D SrcEnd          S              1A
     D STMT            S            100A
     D P_EIdx          S              2  0
     D P_WIdx          S              2  0
     D Res5Char        S              5A
     D Arr5Char        S              5A
     D LkUp            S              2  0
     D Nrfd            S              1A
     D MsgInd          S              1A
     D PCalInd         S              1A                                                   AR871874C
     D PPrmCtr         S              2  0                                                 AR871874C
     D PWrkCtr         S              2  0                                                 AR871874C
     D CmdStr          S              4A
     D ResStr          S             14A
     D FacStr          S             14A
     D EqStr           S             45A
     D WkStr           S             10A
     D Operr           S              1A
     D StrPos          S              3  0
     D FdLen           S              3  0
     D ErrType         S              1A

     D SrcOut          DS
     D  O_SrcSeq                      6  2
     D  O_SrcDat                      6  0
     D  O_SrcDta                    100A

     D ErrDS           DS
     D ErrArr                        10A   DIM(50)

     D WERRDS          DS
     D WErrArr                       10A   DIM(50)

     D NwErrDs         DS
     D NwErrArr                      10A   DIM(50)

     D NwWERRDS        DS
     D NwWErrAr                      10A   DIM(50)
                                                                                           AR871874C
     D PIPrmArr                      10A   DIM(6)                                          AR871874C
     D POPrmArr                      10A   DIM(6)                                          AR871874C

     D EvalChar        S              4A   INZ('EVAL')
     D MoveChar        S              4A   INZ('MOVE')
     D CallChar        S              4A   INZ('CALL')                                     AR871874C
     D ParmChar        S              4A   INZ('PARM')                                     AR871874C
     D EQChar          S              1A   INZ('=')
     D SpChar          S              1A   INZ(' ')
     D BkChar          S              1A   INZ('(')
     D QuChar          S              1A   INZ('''')

     D @UC             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D @LC             C                   'abcdefghijklmnopqrstuvwxyz'

      *****************************************************************
      *  M A I N L I N E   P R O C E S S                              *
      *****************************************************************

     C                   EXSR      InitSrcFile

     C                   EVAL      SrcEnd = 'N'

     C                   DOW       SrcEnd = 'N'
     C                   EXSR      FetchSrc

     C                   IF        SrcEnd = 'N'
     C                   EVAL      CmdStr = %SubSt(O_SrcDta:26:4)
     C                   EVAL      CmdStr = %XLATE(@LC:@UC:CmdStr)

      ** Only process 'MOVE' or 'EVAL' Statement

     C                   IF        CmdStr = MoveChar  or
     C                             CmdStr = EvalChar
     C                   EXSR      ScanSrc
     C                   ENDIF
                                                                                           AR871874C
      ** Process 'PARM' of call program APAPNDARRS statement                               AR871874C
                                                                                           AR871874C
     C                   IF        PCalInd = 'Y'                                           AR871874C
     C                   EXSR      PrcPPrm                                                 AR871874C
     C                   ENDIF                                                             AR871874C
                                                                                           AR871874C
      ** Flag 'CALL' process as On                                                         AR871874C
                                                                                           AR871874C
     C                   IF        CmdStr = CallChar                                       AR871874C
     C                   EVAL      FacStr = %SubSt(O_SrcDta:36:14)                         AR871874C
     C                   IF        FacStr = '''APAPNDARRS'''                               AR871874C
     C                   EVAL      PCalInd = 'Y'                                           AR871874C
     C                   EVAL      PPrmCtr = 0                                             AR871874C
     C                   ENDIF                                                             AR871874C
     C                   ENDIF                                                             AR871874C
     C                   ENDIF

     C                   ENDDO

     C                   EXSR      Close_Src

     C                   SETON                                            LR

      *****************************************************************
      *                                                               *
      * InitSrcFile - Setup pointer to the work file                  *
      *                                                               *
      *****************************************************************
     C     InitSrcFile   BEGSR

     C                   EVAL      Stmt = 'SELECT * from '  + OutFile
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
      *****************************************************************                    AR871874C
      *                                                               *                    AR871874C
      * PrcPPrm - Process Program Parameters for APAPNDARRS           *                    AR871874C
      *                                                               *                    AR871874C
      *****************************************************************                    AR871874C
     C     PrcPPrm       BEGSR                                                             AR871874C
                                                                                           AR871874C
     C                   IF        CmdStr = ParmChar                                       AR871874C
     C                   EVAL      PPrmCtr = PPrmCtr + 1                                   AR871874C
     C                   EVAL      ResStr = %SubSt(O_SrcDta:50:14)                         AR871874C
                                                                                           AR871874C
      ** Process Output Parameters                                                         AR871874C
                                                                                           AR871874C
     C                   IF        PPrmCtr <= 9                                            AR871874C
     C                   IF        PPrmCtr >= 3 and PPrmCtr <= 5                           AR871874C
     C                   EVAL      PWrkCtr = PPrmCtr - 2                                   AR871874C
     C                   EVAL      POPrmArr(PWrkCtr) = ResStr                              AR871874C
     C                   ENDIF                                                             AR871874C
                                                                                           AR871874C
     C                   IF        PPrmCtr >= 7 and PPrmCtr <= 9                           AR871874C
     C                   EVAL      PWrkCtr = PPrmCtr - 3                                   AR871874C
     C                   EVAL      POPrmArr(PWrkCtr) = ResStr                              AR871874C
     C                   ENDIF                                                             AR871874C
                                                                                           AR871874C
      ** Process Input Parameters                                                          AR871874C
                                                                                           AR871874C
     C                   ELSE                                                              AR871874C
     C                   EVAL      PWrkCtr = PPrmCtr - 9                                   AR871874C
     C                   EVAL      PIPrmArr(PWrkCtr) = ResStr                              AR871874C
     C                   ENDIF                                                             AR871874C
                                                                                           AR871874C
     C                   ELSE                                                              AR871874C
                                                                                           AR871874C
      ** Process All parameters                                                            AR871874C
                                                                                           AR871874C
     C                   EVAL      PPrmCtr = 1                                             AR871874C
     C                   DOW       PPrmCtr <= 6                                            AR871874C
     C                   EVAL      FacStr = PIPrmArr(PPrmCtr)                              AR871874C
     C                   EVAL      ResStr = POPrmArr(PPrmCtr)                              AR871874C
     C                   EXSR      ScanSrc2                                                AR871874C
     C                   EVAL      PPrmCtr = PPrmCtr + 1                                   AR871874C
     C                   ENDDO                                                             AR871874C
     C                   EVAL      PCalInd = 'N'                                           AR871874C
                                                                                           AR871874C
     C                   ENDIF                                                             AR871874C
                                                                                           AR871874C
     C                   ENDSR                                                             AR871874C
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
      * ScanSrc  - Scanning for Required String                       *
      *                                                               *
      *****************************************************************
     C     ScanSrc       BEGSR

     C                   IF        CmdStr = MoveChar
     C                   EVAL      ResStr = %SubSt(O_SrcDta:50:14)
     C                   EVAL      FacStr = %SubSt(O_SrcDta:36:14)
     C                   ENDIF

     C                   IF        CmdStr = EvalChar
     C                   EVAL      EqStr = %SubSt(O_SrcDta:36:45)
     C                   EVAL      StrPos = %SCAN(EqChar:EqStr)
     C                   EVAL      FdLen  = %Len(%TRIM(EqStr))
     C                   EVAL      WkStr = %SUBST(EqStr:StrPos+1:FdLen - StrPos)
     C                   EVAL      FacStr = %TRIM(WkStr)
     C                   EVAL      ResStr = %Subst(EqStr:1:StrPos-1)
     C                   ENDIF
                                                                                           AR871874C
     C                   EXSR      ScanSrc2                                                AR871874C
                                                                                           AR871874C
     C                   ENDSR                                                             AR871874C
      *****************************************************************                    AR871874C
      *                                                               *                    AR871874C
      *  ScanSrc2 - Scanning for Required String 2                    *                    AR871874C
      *                                                               *                    AR871874C
      *****************************************************************                    AR871874C
     C     ScanSrc2      BEGSR                                                             AR871874C
                                                                                           AR871874C
     C                   EVAL      FdLen = %Len(%TRIM(FacStr))
     C                   EVAL      StrPos = %SCAN(BkChar:FacStr)
     C                   IF        StrPos > 0
     C                   EVAL      FacStr= %Subst(FacStr:1:StrPos-1)
     C                   ENDIF

     C                   EVAL      FdLen = %Len(%TRIM(ResStr))
     C                   EVAL      StrPos = %SCAN(BkChar:ResStr)
     C                   IF        StrPos > 0
     C                   EVAL      ResStr= %Subst(ResStr:1:StrPos-1)
     C                   ENDIF

     C                   EVAL      FdLen = %Len(%TRIM(FacStr))
     C                   EVAL      StrPos = %SCAN(QuChar:FacStr)
     C                   EVAL      MsgInd = 'N'
     C                   IF        StrPos > 0
     C                   EVAL      FacStr= %Subst(FacStr:StrPos+1:FdLen-2)
     C                   EVAL      MsgInd = 'Y'
     C                   ENDIF

     C                   IF        MsgInd = 'N'
     C                   EXSR      CheckFldType
     C                   IF        ErrType = 'W' or ErrType = 'E'
     C                   EXSR      BuildNwList
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * CheckFldType - Check if the message is error/warning,         *
      *                Message file, or API field in Error            *
      *                                                               *
      *****************************************************************
     C     CheckFldType  BEGSR

      ** Check if the error is a 'Error'

     C                   EVAL      Res5Char = %Subst(ResStr:1:5)
     C                   EVAL      Res5Char = %XLATE(@LC:@UC:Res5Char)
     C                   EVAL      LkUp = 1
     C                   EVAL      ErrType = ' '

     C                   DOW       LkUp  < 51
     C                   IF        ErrArr(LkUp) <> *BLANKS
     C                   EVAL      Arr5Char = %SubSt(ErrArr(LkUp):1:5)
     C                   EVAL      Arr5Char = %XLATE(@LC:@UC:Arr5Char)
     C                   IF        %TRIM(Res5Char) = %TRIM(Arr5Char)
     C                   EVAL      ErrType = 'E'
     C                   EVAL      LkUp = 90
     C                   ENDIF
     C                   ELSE
     C                   EVAL      LkUp = 90
     C                   ENDIF
     C                   EVAL      LkUp = LkUp + 1
     C                   ENDDO

      ** Check if the error is a 'Warning'

     C                   IF        ErrType = ' '
     C                   EVAL      LkUp = 1

     C                   DOW       LkUp  < 51
     C                   IF        WErrArr(LkUp) <> *BLANKS
     C                   EVAL      Arr5Char = %SubSt(WErrArr(LkUp):1:5)
     C                   EVAL      Arr5Char = %XLATE(@LC:@UC:Arr5Char)
     C                   IF        %TRIM(Res5Char) = %TRIM(Arr5Char)
     C                   EVAL      ErrType = 'W'
     C                   EVAL      LkUp = 90
     C                   ENDIF
     C                   ELSE
     C                   EVAL      LkUp = 90
     C                   ENDIF
     C                   EVAL      LkUp = LkUp + 1
     C                   ENDDO
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * BuildnwList - Insert Error field to New Error List            *
      *                                                               *
      *****************************************************************
     C     BuildNwList   BEGSR

     C                   EVAL      WkStr = %Trim(FacStr)

      ** Store Error field name to be ckecked with the calling parameter later

     C                   IF        ErrType = 'E'
     C                   EVAL      LkUp = 1
     C     WkStr         LOOKUP    NwErrArr(LkUp)                         88
     C                   IF        *IN88 = '0'
     C                   EVAL      P_EIdx = P_EIdx + 1
     C                   EVAL      NwErrArr(P_EIdx) =  WkStr
     C                   ENDIF
     C                   ELSE
     C                   IF        ErrType = 'W'
     C                   EVAL      LkUp = 1
     C     WkStr         LOOKUP    NwWErrAr(LkUp)                         88
     C                   IF        *IN88 = '0'
     C                   EVAL      P_WIdx  = P_WIdx + 1
     C                   EVAL      NwWErrAr(P_WIdx) = WkStr
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

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
     C                   PARM                    Outfile
     C                   PARM                    ErrDS
     C                   PARM                    WErrDS
     C                   PARM                    NwErrDS
     C                   PARM                    NwWErrds

     C                   ENDSR

