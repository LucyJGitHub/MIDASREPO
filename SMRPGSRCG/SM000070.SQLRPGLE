     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Control restore of libraries')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000070 - New program to restore libraries                  *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CUP042   *CREATE   Date 03Feb12               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - New method to restore libraries.                    *
      *                                                               *
      *****************************************************************
      *
     D PLayer          S              7
     D PSubOpt         S             20
     D PGlbPfx         S              2
     D PZonPfx         S              2
     D PRstPfx         S              2
     D PBridgeLib      S             10
     D PJobDesc        S             10
     D PDevice         S             10
     D PSaveFileLib    S             10
     D PIASP           S             10
     D PReturnCode     S              1
      *
     D ScanRstPfx      S              2    INZ('xx')
     D ScanGlbPfx      S              2    INZ('gg')
     D ScanZonPfx      S              2    INZ('zz')
     D ScanPfx         S              2
     D ChgPfx          S              2
     D Command         S            300
     D CommandLen      S             15  5 INZ(300)
     D FoundPos        S              3  0
     D StartPos        S              3  0
     D ExecuteFlg      S              1
     D Recursive       S              1    INZ(*blank)
      *
     D SMIMP         E DS                  EXTNAME(SMIMPJW0)
      *
     D CHKOBJCmd       DS
     D                         1     11    INZ('CHKOBJ OBJ(')
     D  ChkObj                12     21
     D                        22     70    INZ(') OBJTYPE(*LIB)')
      *
     D RmvLibLECmd     DS
     D                         1     13    INZ('RMVLIBLE LIB(')
     D  RmvLib                14     23
     D                        24     24    INZ(')')
      *
     D PSDS           SDS
     D PSExcpType             40     42
     D PSExcpNo               43     46
      *
     C     *ENTRY        PLIST
     C                   PARM                    PLayer
     C                   PARM                    PSubOpt
     C                   PARM                    PGlbPfx
     C                   PARM                    PZonPfx
     C                   PARM                    PRstPfx
     C                   PARM                    PBridgeLib
     C                   PARM                    PJobDesc
     C                   PARM                    PDevice
     C                   PARM                    PSaveFileLib
     C                   PARM                    PIASP
     C                   PARM                    PReturnCode
      *
      * Declare cursor by selecting records for mode and ordering by sequence.
     C/exec SQL
     C+ declare SetUpDtls cursor for
     C+ select * from SMIMPJW0
     C+ where
     C+     DFSMNU = :PSubOpt
     C+ and DFLAYR = :PLayer
     C+ and DFDEL  = 'N'
     C+ order by DFSEQN
     C/end-exec
      *
     C/exec SQL
     C+ open SetUpDtls
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from SetUpDtls
     C+ into :SMIMP
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
      * Scan the command string to replace special characters for restore
      *  prefix, global prefix or zone prefix.
     C                   EVAL      ScanPfx = ScanGlbPfx
     C                   EVAL      ChgPfx = PGlbPfx
     C                   EXSR      ScanCmd
      *
     C                   EVAL      ScanPfx = ScanZonPfx
     C                   EVAL      ChgPfx = PZonPfx
     C                   EXSR      ScanCmd
      *
     C                   EVAL      ScanPfx = ScanRstPfx
     C                   EVAL      ChgPfx = PRstPfx
     C                   EXSR      ScanCmd
      *
      * Perform command; however each mode may require additional processing.
     C                   IF        PSubOpt = 'RenameLibraries'
     C                   EXSR      CheckObj
     C                   ENDIF
     C                   IF        PSubOpt = 'RestoreLibraries'
     C                   EVAL      ExecuteFlg = 'Y'
     C                   EXSR      EnterParms
     C                   ENDIF
     C                   IF        PSubOpt = 'RenameLibrariesBack'
     C                   EVAL      ExecuteFlg = 'Y'
     C                   EXSR      EnterParms
     C                   EXSR      RmvLibLE
     C                   ENDIF
     C                   IF        PSubOpt = 'ReportOnDBRestore'
     C                   EVAL      ExecuteFlg = 'Y'
     C                   EXSR      EnterParms
     C                   ENDIF
      *
     C                   IF        ExecuteFlg = 'Y'
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = DFCMD
     C                   CALL(e)   'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   IF        PSExcpNo = '2111'
     C                   EVAL      PReturnCode = 'E'
     C                   ENDIF
     C                   ENDIF
      *
     C/exec SQL
     C+ fetch next
     C+ from SetUpDtls
     C+ into :SMIMP
     C/end-exec
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *
     C     ScanCmd       BEGSR
      *
     C                   EVAL      StartPos = 1
     C                   DOU       FoundPos <= 0
     C                   EVAL      FoundPos = %SCAN(ScanPfx:DFCMD:StartPos)
     C                   IF        FoundPos > 0
     C                   EVAL      %SUBST(DFCMD:FoundPos:2) = ChgPfx
     C                   EVAL      StartPos = FoundPos + 2
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     ScanCmdE      ENDSR
      *
      /EJECT
      *****************************************************************
      *
     C     CheckObj      BEGSR
      *
      * First check that the new name of the library does not already exist.
     C                   EVAL      StartPos = %SCAN('NEWOBJ(':DFCMD:1)
     C                   EVAL      StartPos = StartPos + 7
     C                   EVAL      FoundPos = %SCAN(')':DFCMD:StartPos)
     C                   EVAL      ChkObj =
     C                             %SUBST(DFCMD:StartPos:
     C                             (FoundPos - StartPos))
      *
     C                   EVAL      Command = CHKOBJCmd
     C                   CALL(e)   'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   IF        PSExcpNo = '9801'
     C                   EVAL      PSExcpNo = *blanks
     C                   EVAL      ExecuteFlg = 'Y'
      *
      ** Then check that the existing library does actually exist.
     C                   EVAL      StartPos = %SCAN(' OBJ(':DFCMD:1)
     C                   EVAL      StartPos = StartPos + 5
     C                   EVAL      FoundPos = %SCAN(')':DFCMD:StartPos)
     C                   EVAL      ChkObj =
     C                             %SUBST(DFCMD:StartPos:
     C                             (FoundPos - StartPos))
      *
     C                   EVAL      Command = CHKOBJCmd
     C                   CALL(e)   'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   IF        PSExcpNo = '9801'
     C                   EVAL      PReturnCode = 'E'
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      PReturnCode = 'E'
     C                   ENDIF
      *
     C     CheckObjE     ENDSR
      *
      /EJECT
      *****************************************************************
      *
     C     EnterParms    BEGSR
      *
     C                   IF        PSubOpt = 'RestoreLibraries'
     C                   EVAL      %SUBST(DFCMD:62:10) = PDevice
     C                   EVAL      %SUBST(DFCMD:75:10) = PSaveFileLib
     C                   EVAL      %SUBST(DFCMD:88:10) = PIASP
     C                   EVAL      %SUBST(DFCMD:133:10) = PJobDesc
     C                   EVAL      %SUBST(DFCMD:152:10) = PBridgeLib
     C                   ENDIF
      *
     C                   IF        PSubOpt = 'RenameLibrariesBack'
     C                   EVAL      %SUBST(DFCMD:84:10) = PJobDesc
     C                   EVAL      %SUBST(DFCMD:103:10) = PBridgeLib
     C                   ENDIF
      *
     C                   IF        PSubOpt = 'ReportOnDBRestore'
     C                   EVAL      %SUBST(DFCMD:64:10) = PJobDesc
     C                   EVAL      %SUBST(DFCMD:83:10) = PBridgeLib
     C                   ENDIF
      *
     C     EnterParmsE   ENDSR
      *
      /EJECT
      *****************************************************************
      *
     C     RmvLibLE      BEGSR
      *
      * Remove library from list before renaming library.
     C                   IF        %SUBST(DFCMD:58:1) = 'Y'
     C                   IF        PLayer = '*ZONE'
     C                   EVAL      RmvLib = PRstPfx + PRstPfx + DFNAME
     C                   ELSE
     C                   EVAL      RmvLib = PRstPfx + DFNAME
     C                   ENDIF
     C                   ELSE
     C                   EVAL      RmvLib = PRstPfx + DFNAME
     C                   ENDIF
      *
     C                   EVAL      Command = RmvLibLECmd
     C                   CALL(e)   'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      *
     C     RmvLibLEE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
