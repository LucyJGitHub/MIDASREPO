      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
     F*****************************************************************
/*STD *  RPGSQLBND
/*EXI *  TEXT('Midas UT Extract Error Fields Information')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000041 - Exract Error Fields Information                   *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. CBF011   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF011 - BF Infrastructure: Error Message Handling           *
      *                                                               *
     F*****************************************************************

     D SQLOut        E DS                  EXTNAME(UTPGMLPD)
     D                                     Prefix(P_)

     D OutProg       E DS                  EXTNAME(UTPGMLPD)
     D                                     Prefix(O_)

     D OutTable      E DS                  EXTNAME(UTFINFPD)
     D                                     Prefix(O_)

     D SrcOut          DS
     D  O_SrcSeq                      6  2
     D  O_SrcDat                      6  0
     D  O_SrcDta                    100A

     D ErrDS           DS
     D ErrArr                        10A   DIM(50)

     D WERRDS          DS
     D WErrArr                       10A   DIM(50)

     D ErrFDS          DS
     D ErrFArr                       10A   DIM(50)

     D WERRFDS         DS
     D WErrFArr                      10A   DIM(50)

     D MsgFDS          DS
     D MsgFArr                       10A   DIM(5)

     D MsgFNDS         DS
     D MsgFNArr                      10A   DIM(5)

     D OWkArrDS        DS
     D OWkArr                        10A   DIM(50)

     D WkArrDS         DS
     D WkArr                         10A   DIM(50)

     D OErrDS          DS
     D OErrArr                       10A   DIM(50)

     D OWErrDS         DS
     D OWErrArr                      10A   DIM(50)

     D OErFDS          DS
     D OErFArr                       10A   DIM(50)

     D OWErFDS         DS
     D OWErFArr                      10A   DIM(50)

     D OMFFDS          DS
     D OMFFArr                       10A   DIM(5)

     D OMFFNDS         DS
     D OMFFNArr                      10A   DIM(5)

     D ParmDS          DS
     D  ParmEnt                      10A   DIM(80)

     D NwErrDs         DS
     D NwErrArr                      10A   DIM(50)

     D NwWERRDS        DS
     D NwWErrAr                      10A   DIM(50)

     D WkPosDs         DS
     D WkPos                          2  0 DIM(50)

     D EParmDs         DS
     D EParmPos                       2  0 DIM(50)

     D WParmDs         DS
     D WParmPos                       2  0 DIM(50)

     D EFFnDS          DS
     D EFFnPos                        2  0 DIM(50)

     D WFFnDS          DS
     D WFFnPos                        2  0 DIM(50)

     D MFFPDS          DS
     D MsgFPos                        2  0 DIM(5)

     D ParmFldDS       DS
     D PFldArr                       10A   DIM(10)

     D ParmStrDS       DS
     D ParmStr                      800A   DIM(10)

     D DriverFile      S             10A
     D FileName        S             10A
     D APIName         S             10A
     D MsgFileName     S             10A
     D PLstName        S             10A
     D MsgFNStr        S             50A
     D NewAPI          S              1A
     D NewMsgf         S              1A
     D PgmType         S              2A
     D WkFld           S             10A
     D WkParmFld       S             10A
     D ScanEnd         S              1A
     D Nrfd            S              1A
     D Stmt            S            500A
     D Operr           S              1A
     D ErrType         S              1A
     D FileEnd         S              1A
     D NameInVar       S              1A

     D CFile           S             10A
     D LibName         S             10A
     D CMember         S             10A
     D OutFile         S             10A   INZ('FIELDSRC')
     D OutFile2        S             10A   INZ('PLISTSRC')

     D CallStart       S              1A
     D CallWait        S              1A
     D StartIgnr       S              1A
     D SrcEnd          S              1A
     D EvalChar        S              4A   INZ('EVAL')
     D MoveChar        S              4A   INZ('MOVE')
     D CallChar        S              4A   INZ('CALL')
     D ParmChar        S              4A   INZ('PARM')
     D PLSTChar        S              4A   INZ('PLIS')
     D WhenChar        S              4A   INZ('WHEN')
     D EQChar          S              1A   INZ('=')
     D SpChar          S              1A   INZ(' ')
     D BkChar          S              1A   INZ('(')
     D QuChar          S              1A   INZ('''')

     D LkUp            S              2  0
     D Idx             S              2  0
     D StrPos          S              3  0
     D FdLen           S              3  0
     D NxPos           S              3  0
     D DupCount        S              2  0

     D ErrIdx          S              2  0
     D WErrIdx         S              2  0
     D ParmIdx         S              2  0
     D EPIdx           S              2  0
     D WPIdx           S              2  0

     D RefIdx          S              2  0

     D P_EIdx          S              2  0
     D P_WIdx          S              2  0
     D P_EFIdx         S              2  0
     D P_WFIdx         S              2  0
     D P_MFIdx         S              2  0

     D Res5Char        S              5A
     D Arr5Char        S              5A
     D LkUpF           S              1A
     D Needed          S              1A
     D Upfile          S             10A
     D ErrFldName      S             10A
     D WErFldName      S             10A
     D MsgInd          S              1A
     D CmdStr          S              4A
     D ResStr          S             14A
     D FacStr          S             14A
     D EqStr           S             45A
     D WkStr           S             45A

     D @UC             C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D @LC             C                   'abcdefghijklmnopqrstuvwxyz'

      *****************************************************************
      *  M A I N L I N E   P R O C E S S                              *
      *****************************************************************

     C                   EVAL      FileEnd = 'N'
     C                   EXSR      Init_Driver

      ** Do until end of driving file UTPGMLPD

     C                   DOW       FileEnd = 'N'

      ** Read UTPGMLPD

     C                   EXSR      Fetch_SQLRec

     C                   IF        FileEnd = 'N'

     C                   IF        P_PCDPGM = *BLANK
     C                   EVAL      CMEMBER = P_PCGPGM
     C                   ELSE
     C                   EVAL      CMember = P_PCDPGM
     C                   ENDIF

      ** Get the latest source

     C                   CALL      'UT000042'
     C                   PARM                    CMember
     C                   PARM                    LibName
     C                   PARM                    CFile

      ** Unable to get source make record is no being processed

     C                   IF        CFILE = 'CLP' or CFILE = ' '
     C                   EVAL      CFILE = 'CLP'
     C                   EXSR      UpdateErrIndr
     C                   ENDIF

     C                   IF        CFile <> 'CLP'

      ** If not the top level call program, get the fields name from program call
      **    parameter

     C                   IF        P_PCDPGM <> *BLANKS
     C                   CALL      'UT000043'
     C                   PARM                    LibName
     C                   PARM                    CFile
     C                   PARM                    CMember
     C                   PARM                    SQLOut
     C                   ENDIF

      ** Build SQL Source File

     C                   EVAL      NwErrDS = *BLANKS
     C                   EVAL      NwWErrDS = *BLANKS
     C                   CALL      'UT000044'
     C                   PARM                    LibName
     C                   PARM                    CFile
     C                   PARM                    CMember
     C                   PARM                    OutFile
     C                   PARM                    SQLOut
     C                   PARM                    NwErrDS
     C                   PARM                    NwWErrds

      ** Build the calling parameter variable from source

     C                   CALL      'UT000048'
     C                   PARM                    LIBName
     C                   PARM                    CFile
     C                   PARM                    CMember
     C                   PARM                    OutFile2

     C                   EXSR      InitWrkFields

      ** First parse the source check for new error field used

     C                   CALL      'UT000049'
     C                   PARM                    Outfile
     C                   PARM                    ErrDS
     C                   PARM                    WErrDS
     C                   PARM                    NwErrDS
     C                   PARM                    NwWErrds

      ** Build SQL Source File again including all the new fields found

     C                   CALL      'UT000044'
     C                   PARM                    LibName
     C                   PARM                    CFile
     C                   PARM                    CMember
     C                   PARM                    OutFile
     C                   PARM                    SQLOut
     C                   PARM                    NwErrDS
     C                   PARM                    NwWErrds

     C                   EXSR      Scan_Src
     C                   EXSR      Close_Src
     C                   EXSR      Upd_Msgf_Info
     C                   ENDIF

     C                   ENDIF
     C                   ENDDO

     C                   EXSR      Close_Driver

      ** Print program all stack

     C                   CALL      'UT000045'

     C                   CALL      'UT000046'

     C                   SETON                                        LR

      *****************************************************************
      *                                                               *
      * Init_Driver - Setup pointer to the driving file               *
      *                                                               *
      *****************************************************************
     C     Init_Driver   BEGSR

     C                   EVAL      DriverFile  = 'UTPGMLPD'
     C                   EVAL      Stmt = 'SELECT * from '  +
     C                                    DriverFile
     C                   EVAL      Nrfd  = 'Y'

     C/EXEC SQL WHENEVER SQLERROR GOTO ErrOpr
     C/END-EXEC

     C/EXEC SQL WHENEVER NOT FOUND GOTO NoRec
     C/END-EXEC

     C/EXEC SQL
     C+ PREPARE S1 FROM :STMT
     C/END-EXEC

     C/EXEC SQL
     C+ DECLARE C1 CURSOR FOR S1
     C/END-EXEC
     C/EXEC SQL
     C+ OPEN C1
     C/END-EXEC

     C                   EVAL      Nrfd = 'N'

     C     NoRec         TAG
     C     ErrOpr        TAG
     C                   IF        Nrfd = 'Y'
     C                   EVAL      FileEnd = 'Y'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Fetch_SQLRec - Read driving file                              *
      *                                                               *
      *****************************************************************
     C     Fetch_SQLRec  BEGSR

     C                   EVAL      SQLOut   = *BLANKS
     C                   EVAL      Operr = 'P'
     C                   EVAL      Nrfd  = 'Y'

     C/EXEC SQL WHENEVER SQLERROR GOTO ERROP
     C/END-EXEC
     C                   EVAL      Operr = 'O'

     C/EXEC SQL WHENEVER NOT FOUND GOTO NRECF
     C/END-EXEC

     C/EXEC SQL
     C+  FETCH C1 INTO :SQLOut
     C/END-EXEC
     C                   EVAL      Nrfd  = 'N'
     C     NRECF         TAG
     C     ERROP         TAG
     C                   IF        Nrfd = 'Y'
     C                   EVAL      FileEnd = 'Y'
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * InitWrkFields - Initialise work fields for each program       *
      *                                                               *
      *****************************************************************
     C     InitWrkFields BEGSR

     C                   EVAL      ErrDS  = *BLANKS
     C                   EVAL      WErrDS = *BLANKS
     C                   EVAL      ErrFDS = *BLANKS
     C                   EVAL      WErrFDS = *BLANKS
     C                   EVAL      MsgFDS = *BLANKS
     C                   EVAL      MsgFNDS = *BLANKS
     C                   EVAL      ErrFldName = *BLANKS
     C                   EVAL      WErFldName = *BLANKS
     C                   EVAL      NwErrDS = *BLANKS
     C                   EVAL      NwWErrDS = *BLANKS
     C                   EVAL      ParmFldDS = *BLANKS
     C                   EVAL      ParmStrDS = *BLANKS

     C                   EVAL      P_EIdx = 0
     C                   EVAL      P_WIdx = 0
     C                   EVAL      P_EFIdx = 0
     C                   EVAL      P_WFIdx = 0
     C                   EVAL      P_MFIdx = 0
     C                   EVAL      NewMsgf = 'N'

     C                   EVAL      ErrDS = P_PCERRN
     C                   EVAL      WERRDS = P_PCWERR
     C                   EVAL      ErrFDS = P_PCERRF
     C                   EVAL      WErrFDS = P_PCWERF
     C                   EVAL      MsgFDS = P_PCMSGF
     C                   EVAL      MsgFNDS = P_PCMSGN

     C                   EVAL      APINAME = *BLANKS
     C                   EVAL      NewAPI = 'N'
     C                   IF        P_PCDPGM <> *BLANK
     C                   EVAL      APIName = P_PCAPIN
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Scan_Src - Scanning for Required String                       *
      *                                                               *
      *****************************************************************
     C     Scan_Src      BEGSR

     C                   EXSR      InitSrcFile

     C                   EVAL      SrcEnd = 'N'
     C                   EVAL      CallStart = 'N'
     C                   EVAL      CallWait = 'N'
     C                   EVAL      StartIgnr = 'N'

     C                   DOW       SrcEnd <> 'Y'

     C                   EXSR      FetchSrc
     C                   IF        SrcEnd <> 'Y'
     C                   EXSR      CheckStr
     C                   ELSE
     C                   IF        CallWait = 'Y'  or
     C                             CallStart = 'Y'
     C                   EXSR      Check_Out
     C                   EVAL      CallWait = 'N'
     C                   EVAL      CallStart = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * InitSrcFile - Setup pointer to the work file                  *
      *                                                               *
      *****************************************************************
     C     InitSrcFile   BEGSR

     C                   EVAL      FileName  = OutFile
     C                   EVAL      Stmt = 'SELECT * from '  +
     C                                    FileName
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
      * CheckStr - Check for required String                          *
      *                                                               *
      *****************************************************************
     C     CheckStr      BEGSR

     C                   EVAL      CmdStr = %SubSt(O_SrcDta:26:4)
     C                   EVAL      CmdStr = %XLATE(@LC:@UC:CmdStr)

     C                   IF        CmdStr = WhenChar
     C                   EVAL      APIName  = %TRIM(%SUBST(O_SrcDta:37:4))
     C                   EVAL      NewAPI = 'Y'
     C                   ENDIF

     C                   IF        StartIgnr = 'Y' and
     C                             CmdStr <> ParmChar
     C                   EVAL      StartIgnr = 'N'
     C                   ENDIF

     C                   IF        CallWait = 'Y'  or
     C                             CallStart = 'Y'
     C                   IF        CmdStr = CallChar or
     C                             CmdStr = PlstChar
     C                   EXSR      Check_Out
     C                   EVAL      CallWait = 'N'
     C                   EVAL      CallStart = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   IF        CallStart = 'Y' and
     C                             CmdStr = ParmChar
     C                   EXSR      Store_Parm
     C                   ENDIF

     C                   IF        CallStart = 'Y'
     C                   IF        CmdStr <> CallChar and
     C                             CmdStr <> PlstChar and
     C                             CmdStr <> ParmChar
     C                   EVAL      CallWait = 'Y'
     C                   EVAL      CallStart = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   IF        CmdStr = CallChar
     C                   EVAL      CallStart = 'Y'
     C                   EXSR      Start_Store
     C                   ENDIF

     C                   IF        CmdStr = PlstChar
     C                   EVal      StartIgnr = 'Y'
     C                   ENDIF


     C                   IF        CmdStr = MoveChar  or
     C                             CmdStr = EvalChar
     C                   EXSR      Out_Field
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Out_Field - Ouput error fields information to file            *
      *                                                               *
      *****************************************************************
     C     Out_Field     BEGSR

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

     C                   EXSR      CheckFldType

     C                   EXSR      InsRec

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * CheckFldType - Check if the message is error/warning ,        *
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

     C                   IF        ErrType = ' '
     C                   EVAL      LkUp = 1
     C                   DOW       LkUp  < 51
     C                   IF        NwErrArr(LkUp) <> *BLANKS
     C                   EVAL      Arr5Char = %SubSt(NwErrArr(LkUp):1:5)
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
     C                   ENDIF

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

     C                   IF        ErrType = ' '
     C                   EVAL      LkUp = 1
     C                   DOW       LkUp  < 51
     C                   IF        NwWErrAr(LkUp) <> *BLANKS
     C                   EVAL      Arr5Char = %SubSt(NwWErrAr(LkUp):1:5)
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

      ** Check if it is Field got Error

     C                   IF        ErrType = ' '
     C                   EVAL      LkUp = 1
     C                   DOW       LkUp  < 51
     C                   IF        ErrFArr(LkUp) <> *BLANKS
     C                   EVAL      Arr5Char = %SubSt(ErrFArr(LkUp):1:5)
     C                   EVAL      Arr5Char = %XLATE(@LC:@UC:Arr5Char)
     C                   IF        %TRIM(Res5Char) = %TRIM(Arr5Char)
     C                   EVAL      ErrType = 'A'
     C                   EVAL      LkUp = 90
     C                   ENDIF
     C                   ELSE
     C                   EVAL      LkUp = 90
     C                   ENDIF
     C                   EVAL      LkUp = LkUp + 1

     C                   ENDDO
     C                   ENDIF

      ** Check if it is Field got Warning

     C                   IF        ErrType = ' '
     C                   EVAL      LkUp = 1
     C                   DOW       LkUp  < 51
     C                   IF        WErrFArr(LkUp) <> *BLANKS
     C                   EVAL      Arr5Char = %SubSt(WErrFArr(LkUp):1:5)
     C                   EVAL      Arr5Char = %XLATE(@LC:@UC:Arr5Char)
     C                   IF        %TRIM(Res5Char) = %TRIM(Arr5Char)
     C                   EVAL      ErrType = 'B'
     C                   EVAL      LkUp = 90
     C                   ENDIF
     C                   ELSE
     C                   EVAL      LkUp = 90
     C                   ENDIF
     C                   EVAL      LkUp = LkUp + 1

     C                   ENDDO
     C                   ENDIF

      ** Check if it is Message file Name

     C                   IF        ErrType = ' '
     C                   EVAL      LkUp = 1
     C                   DOW       LkUp  < 51
     C                   IF        MsgFArr(LkUp) <> *BLANKS
     C                   EVAL      Arr5Char = %SubSt(MsgFArr(LkUp):1:5)
     C                   EVAL      Arr5Char = %XLATE(@LC:@UC:Arr5Char)
     C                   IF        %TRIM(Res5Char) = %TRIM(Arr5Char)
     C                   EVAL      ErrType = 'M'
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
      * InsRec - Output new record to Field Information               *
      *                                                               *
      *****************************************************************
     C     InsRec        BEGSR

     C                   EVAL      O_FDELED = ' '
     C                   EVAL      O_FCGPGM = CMember
     C                   EVAL      O_FETYPE = ErrType
     C                   EVAL      O_FCDPGM = APIName
     C                   EVAL      O_FMSGID = ''
     C                   EVAL      O_FFVALE = ''
     C                   EVAL      O_FMSGFU = ''

     C                   IF        ErrType = 'A' or ErrType = 'B'
     C                                           or ErrType = 'M'
     C                   IF        MsgInd = 'Y'
     C                   EVAL      MsgInd = 'N'
     C                   EVAL      NameInVar = 'N'
     C                   ELSE
     C                   EVAL      NameInVar = 'Y'
     C                   ENDIF

     C                   IF        ErrType = 'A'
     C                   EVAL      ErrFldName = %Trim(FacStr)

      ** If the field name is embedded within program variable, then it is Blank

     C                   IF        NameInVar = 'Y'
     C                   EVAL      ErrFldName = *BLANKS
     C                   ENDIF
     C                   ENDIF

     C                   IF        ErrType = 'B'
     C                   EVAL      WErFldName = %Trim(FacStr)

      ** If the field name is embedded within program variable, then it is Blank

     C                   IF        NameInVar = 'Y'
     C                   EVAL      WErFldName = *BLANKS
     C                   ENDIF
     C                   ENDIF

      ** Setup Message file detail

     C                   IF        ErrType = 'M'
     C                   EVAL      NewMsgf = 'Y'
     C                   IF        P_MFIdx < 1
     C                   EVAL      MsgFNDS = *BLANKS
     C                   ENDIF
     C                   EVAL      LkUp = 1
     C                   EVAL      MsgFileName = %TRIM(FacStr)
     C     MsgFileName   LOOKUP    MsgFNArr(LkUp)                         88
     C                   IF        *IN88 = '0'
     C                   EVAL      P_MFIdx = P_MFIdx + 1
     C                   EVAL      MsgFNArr(P_MFIDX) = MsgFileName
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      O_FMSGFN = MsgFNDS

      ** Setup Field in Error

     C                   EVAL      O_FINERD = ' '
     C                   IF        ErrType = 'E'
     C                   EVAL      O_FINERD = ErrFldName
     C                   ENDIF
     C                   IF        ErrType = 'W'
     C                   EVAL      O_FINERD = WErFldName
     C                   ENDIF

      ** Setup Message ID

     C                   IF        MsgInd = 'Y'
     C                   EVAL      O_FMSGID = %Trim(FacStr)
     C                   ELSE
     C                   EVAL      O_FFVALE = %Trim(FacStr)
     C                   ENDIF

     C/EXEC SQL WHENEVER SQLERROR GOTO ERR_TAG_I
     C/END-EXEC
     C/EXEC SQL WHENEVER NOT FOUND GOTO ERR_TAG_I
     C/END-EXEC

     C/EXEC SQL
     C+ Select COUNT(*) into :DupCount
     C+        from UTFINFPD
     C+        Where  FCGPGM = :O_FCGPGM and
     C+               FCDPGM = :O_FCDPGM and
     C+               FINERD  = :O_FINERD  and
     C+               FMSGID = :O_FMSGID and
     C+               FFVALE = :O_FFVALE
     C/END-EXEC

     C                   IF        DupCount < 1

     C                   IF        MsgInd <> 'Y'

      ** Store Error field name to be ckecked with the calling parameter later

     C                   IF        ErrType = 'E'
     C                   EVAL      LkUp = 1
     C     O_FFVALE      LOOKUP    NwErrArr(LkUp)                         88
     C                   IF        *IN88 = '0'
     C                   EVAL      P_EIdx = P_EIdx + 1
     C                   EVAL      NwErrArr(P_EIdx) = O_FFVALE
     C                   ENDIF
     C                   ELSE
     C                   IF        ErrType = 'W'
     C                   EVAL      LkUp = 1
     C     O_FFVALE      LOOKUP    NwWErrAr(LkUp)                         88
     C                   IF        *IN88 = '0'
     C                   EVAL      P_WIdx  = P_WIdx + 1
     C                   EVAL      NwWErrAr(P_WIdx) = O_FFVALE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF

     C/EXEC SQL
     C+ Insert into UTFINFPD values :OutTable
     C/END-EXEC

     C                   ENDIF

     C     ERR_TAG_I     TAG

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Start_Store - Start of the collection process                 *
      *                                                               *
      *****************************************************************
     C     Start_Store   BEGSR

     C                   EVAL      OutProg = *BLANKS
     C                   EVAL      ParmDS = *BLANKS
     C                   EVAL      O_PCGPGM = CMember
     C                   EVAL      FacStr = %SubSt(O_SrcDta:36:14)
     C                   EVAL      FdLen = %Len(%TRIM(FacStr))
     C                   EVAL      StrPos = %SCAN(QuChar:FacStr)
     C                   IF        StrPos > 0
     C                   EVAL      FacStr= %Subst(FacStr:StrPos+1:FdLen-2)
     C                   ENDIF

     C                   EVAL      O_PCDPGM = %TRIM(FacStr)
     C                   EVAL      ParmIdx = 0
     C                   EVAL      ErrIdx = 0
     C                   EVAL      WErrIdx = 0

     C                   IF        NewAPI = 'N'
     C                   EVAL      FdLen = %Len(%TRIM(O_PCDPGM))
     C                   EVAL      PgmType = %Subst(O_PCDPGM:FdLen-1:2)
     C                   IF        PgmType = 'VU'
     C                   EVAL      APIName = %Subst(O_PCDPGM:3:4)
     C                   ELSE
     C                   EVAL      PgmType = %Subst(O_PCDPGM:FdLen:1)
     C                   IF        PgmType = 'R'
     C                   EVAL      APIName = %Subst(O_PCDPGM:3:4)
     C                   ELSE
     C                   EVAL      APINAME = P_PCAPIN
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   EVAL      NewAPI = 'N'
     C                   ENDIF

     C                   EVAL      O_PCAPIN = APIName

      ** Check if PLIST is specify in the CALL statment

     C                   EVAL      PLstName = %Subst(O_SrcDta:50:10)
     C                   IF        PLstName <> *BLANKS
     C                   IF        ParmFldDs = *blanks
     C                   CALL      'UT000047'
     C                   PARM                    OutFile2
     C                   PARM                    ParmFldDS
     C                   PARM                    ParmStrDS
     C                   ENDIF
     C                   EVAL      LkUp = 1
     C     PLstName      LOOKUP    PFldArr(LkUp)                          88
     C                   IF        *IN88 = '1'
     C                   EVAL      ParmDs = ParmStr(LkUP)
     C                   ENDIF
     C                   ENDIF

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
      * Check_out - Check if the called program required for lookup   *
      *             Error Messages ID                                 *
      *                                                               *
      *****************************************************************
     C     Check_Out     BEGSR

     C                   EVAL      Needed = 'N'
     C                   EVAL      OErrDS = *BLANKS
     C                   EVAL      OWErrDS = *BLANKS
     C                   EVAL      EParmDS = *ZERO
     C                   EVAL      WParmDS = *ZERO
     C                   EVAL      EFFNDS = *ZERO
     C                   EVAL      WFFNDS = *ZERO
     C                   EVAL      MFFPDS = *ZERO
     C                   EVAL      ErrIdx = 0
     C                   EVAL      WErrIdx = 0
     C                   EVAL      EPIdx = 0
     C                   EVAL      WPIdx = 0

      ** First Check with new Error field found then follow to check with existing

     C                   EVAL      RefIdx = 0
     C                   EVAL      OWkArrDS = *BLANK
     C                   EVAL      WkPosDS = *ZERO
     C                   EVAL      WkArrDS = NwErrDS
     C                   EXSR      Check_Parr
     C                   EVAL      WkArrDS = ErrDS
     C                   EXSR      Check_Parr
     C                   EVAL      OErrDS  = OWkArrDS
     C                   EVAL      EParmDS = WkPosDS
     C                   EVAL      ErrIdx = RefIdx

      ** First Check with new Warning field found then follow to check with existing

     C                   EVAL      RefIdx = WErrIdx
     C                   EVAL      OWkArrDS = *BLANK
     C                   EVAL      WkPosDS = *ZERO
     C                   EVAL      WkArrDS = NwWErrDS
     C                   EXSR      Check_Parr
     C                   EVAL      WkArrDS = WErrDS
     C                   EXSR      Check_Parr
     C                   EVAL      OWErrDS  = OWkArrDS
     C                   EVAL      WParmDS = WkPosDS
     C                   EVAL      WErrIdx = RefIdx

      ** First Check with Existing field name being use for called program

     C                   EVAL      RefIdx = 0
     C                   EVAL      OWkArrDS = *BLANK
     C                   EVAL      WkPosDS = *ZERO
     C                   EVAL      WkArrDS = ErrFDS
     C                   EXSR      Check_Parr
     C                   EVAL      OErFDS = OWkArrDS
     C                   EVAL      EFFNDS = WkPosDS

      ** First Check with Existing Message file field for called program

     C                   EVAL      RefIdx = 0
     C                   EVAL      OWkArrDS = *BLANK
     C                   EVAL      WkPosDS = *ZERO
     C                   EVAL      WkArrDS = WErrFDS
     C                   EXSR      Check_Parr
     C                   EVAL      OWErFDS = OWkArrDS
     C                   EVAL      WFFNDS = WkPosDS

     C                   EVAL      OMFFDS = MsgFDS
     C                   EVAL      OMFFNDS = MsgFNDS

     C                   IF        Needed = 'Y'
     C                   EXSR      Out_Program
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Check_Parr - Check if field used in Call Parameter            *
      *                                                               *
      *****************************************************************
     C     Check_Parr    BEGSR

     C                   EVAL      Idx = 0
     C                   DOW       Idx < 50
     C                   EVAL      Idx = Idx + 1
     C                   IF        WkArr(Idx) = *BLANK
     C                   EVAL      Idx = 90
     C                   ELSE
     C                   EVAL      LkUp = 0
     C                   EVAL      WkFld = %TRIM(WkArr(Idx))
     C                   EVAL      WkFld = %XLATE(@LC:@UC:WkFld)
     C                   EVAL      ScanEnd = 'N'
     C                   DOW       LkUp < 51 and ScanEnd = 'N'
     C                   EVAL      LkUp = LkUp + 1
     C                   IF        ParmEnt(LkUp) <> *BLANKS
     C                   EVAL      WkParmFld = %TRIM(ParmEnt(LkUp))
     C                   EVAL      WkParmFld = %XLATE(@LC:@UC:WkParmFld)
     C                   IF        WkFld = WkParmFld
     C                   EVAL      ScanEnd = 'Y'
     C                   ENDIF
     C                   ELSE
     C                   EVAL      ScanEnd = 'Y'
     C                   EVAL      LkUp = 60
     C                   ENDIF
     C                   ENDDO
     C                   IF        LkUp < 51
     C                   EVAL      RefIdx = RefIdx + 1
     C                   EVAL      WkPos(RefIdx) = LkUp
     C                   EVAL      OWkArr(RefIdx) = WkArr(Idx)
     C                   EVAL      Needed = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C
     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Out_Program - Write record to file                            *
      *                                                               *
      *****************************************************************
     C     Out_Program   BEGSR

     C                   EVAL      O_PCPARM = ParmDS
     C                   EVAL      O_PCERRN = OErrDS
     C                   EVAL      O_PCWERR = OWErrDS
     C                   EVAL      O_PCERRF = OErFDS
     C                   EVAL      O_PCWERF = OWErFDS
     C                   EVAL      O_PCMSGF = OMFFDS
     C                   EVAL      O_PCMSGN = MsgFNDS
     C                   MOVE      EParmDS       O_PCERRP
     C                   MOVE      WParmDS       O_PCWERP
     C                   MOVE      EFFNDS        O_PCERFP
     C                   MOVE      WFFNDS        O_PCWRFP
     C                   MOVE      MFFPDS        O_PCMSGP

     C/EXEC SQL WHENEVER SQLERROR GOTO ERR_TAG_P
     C/END-EXEC

     C/EXEC SQL WHENEVER NOT FOUND GOTO ERR_TAG_P
     C/END-EXEC

     C/EXEC SQL
     C+ Select COUNT(*) into :DupCount
     C+        from UTPGMLPD
     C+        Where  PCGPGM = :O_PCGPGM and
     C+               PCDPGM = :O_PCDPGM
     C/END-EXEC

     C                   IF        DupCount < 1

     C/EXEC SQL
     C+ Insert into UTPGMLPD values :OutProg
     C/END-EXEC

     C                   ENDIF

     C     ERR_TAG_P     TAG
     C
     C                   ENDSR

      *****************************************************************
      *                                                               *
      * UpdateErrIndr - Output rexcord not processed                  *
      *                                                               *
      *****************************************************************
     C     UpdateErrIndr BEGSR

     C/EXEC SQL WHENEVER SQLERROR GOTO UpdateErr
     C/END-EXEC
     C/EXEC SQL WHENEVER NOT FOUND GOTO UpdateErr
     C/END-EXEC
     C/EXEC SQL
     C+  Update UTPGMLPD SET PCINDR = '*'
     C+         Where PCGPGM = :P_PCGPGM and
     C+               PCDPGM = :P_PCDPGM
     C/END-EXEC

     C     UpdateErr     TAG

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
      * Close_Driver - Close driving file                             *
      *                                                               *
      *****************************************************************
     C     Close_Driver  BEGSR

     C/EXEC SQL WHENEVER SQLERROR GOTO CloseErr
     C/END-EXEC
     C/EXEC SQL WHENEVER NOT FOUND GOTO CloseErr
     C/END-EXEC
     C/EXEC SQL
     C+  CLOSE C1
     C/END-EXEC

     C     CloseErr      TAG

     C                   ENDSR

      *****************************************************************
      *                                                               *
      * Upd_Msgf_Info - Update both program and field information     *
      *                 files to ensure both programs and fields are  *
      *                 associated with message file information      *
      *                                                               *
      *****************************************************************
     C     Upd_Msgf_Info BEGSR

     C                   EVAL      MsgFNStr = MsgFNDS

     C/EXEC SQL WHENEVER SQLERROR GOTO UpdMsgErr
     C/END-EXEC
     C/EXEC SQL WHENEVER NOT FOUND GOTO UpdMsgErr
     C/END-EXEC
     C/EXEC SQL
     C+  Update UTFINFPD  SET FMSGFN = :MsgFNStr
     C+              Where FCGPGM = :CMember
     C+                    and FMSGFN = ' '
     C/END-EXEC

     C/EXEC SQL
     C+  Update UTPGMLPD  SET PCMSGN = :MsgFNStr
     C+              Where PCGPGM = :O_FCGPGM
     C+                    and PCMSGN = ' '
     C/END-EXEC

     C     UpdMsgErr     TAG

     C                   ENDSR

