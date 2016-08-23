     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*XBIA*  CRTPF FILE(QTEMP/CMPSRCOF) RCDLEN(220)                       *
/*XBIB*  OVRDBF FILE(UTC000001R) TOFILE(UPMBRLTPD)                    *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT Write to spool file for CMPSRC')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000002 - Write spool file for CMPSRC                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      *  Last Amend No. CUP007             Date 10Nov10               *
      *  Prev Amend No. BUG27884 *CREATE   Date 08Jul10               *
      *                 CUT010             Date 15May07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP007 - Fix a couple of minor problems.                     *
      *  BUG27884 - Applied CUT010.                                   *
      *  CUT010 - New utility.                                        *
      *                                                               *
      *****************************************************************
      *
     FCMPSRCOF  UF   E             DISK    RENAME(CMPSRCOF:CMPSRCF)
     F                                     PREFIX(Z)
     FUTC000001RIF   E             DISK
     FUTSRCFL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     FUT000002P1O    E             PRINTER INFDS(SpoolData)
      *
      * Constants.
     D HDiff           C                   '|<-------------------------- Conten+
     D                                     ts of member -----------------------+
     D                                     ------------------------------------+
     D                                     ------->|'
     D HMatch          C                   '|<---------------------------------+
     D                                     -------- Code common to both members-
     D                                      -----------------------------------+
     D                                     ------->|'
     D MatchS          C                   '|Seq.   ====+====1====+====2====+==+
     D                                     ==3====+====4====+====5====+====6===+
     D                                     =+====7====+====8====+====9====+===1+
     D                                     0   Date|'
     D MatchE          C                   '|==================================+
     D                                     ====================================+
     D                                     ====================================+
     D                                     ========|'
     D DiffS           C                   '|Seq.   ----+----1----+----2----+--+
     D                                     --3----+----4----+----5----+----6---+
     D                                     -+----7----+----8----+----9----+---1+
     D                                     0   Date|'
     D DiffE           C                   '|----------------------------------+
     D                                     ------------------------------------+
     D                                     ------------------------------------+
     D                                     --------|'
     D Hyphens         C                   '-----------------------------------'
     D MatDspConst     C                   ' matching records not displayed'
     D OVRDBFCommand   C                   'OVRDBF FILE(UTSRCFL0) +
     D                                     TOFILE(QTEMP/UTSRCFL0) MBR('
     D DLTOVRCommand   C                   'DLTOVR FILE(UTSRCFL0)'
      *
      * Parameters.
     D PMatchLines     S              4
      *
      * Program variables.
     D LibFileMbr      S             34
     D LibFile         S             21
     D RLibFile        S                   LIKE(LibFile)
     D CLibFile        S                   LIKE(LibFile)
     D SourceFMbr      S             12
     D RSourceFMbr     S                   LIKE(SourceFMbr)
     D CSourceFMbr     S                   LIKE(SourceFMbr)
     D OBracketPos     S              3S 0
     D CBracketPos     S                   LIKE(OBracketPos)
     D FwdSlshPos      S              2S 0                                                    CUP007
     D StartRead       S              1    INZ('Y')
     D Recursive       S              1    INZ('N')
     D EndFlag         S              1
     D NewAction       S              1
     D NewSection      S              1
     D MatchLineInd    S              1
     D Mode            S              1
     D SMode           S                   LIKE(Mode)
     D FirstRecord     S              1
     D NoToDelete      S              5S 0
     D NoToWrite       S              5S 0
     D NoMiddleLines   S              5S 0
     D Counter         S              5S 0
     D SActionLenN     S              5S 0
     D SCmpLineNoA     S              7
     D SAction         S              4
     D SRefLineNoA     S              7
     D SRcdType        S              4
     D SSpoolLine      S            132
     D Command         S            200
     D CommandLen      S             15  5 INZ(200)
     D KSource         S            100
     D GDate           S              6
     D GSeq            S              6
     D OVRMember       S              3
     D SingleCompare   S              1
     D NewPage         S              1
     D SMLFILE         S             10
      *
      * Report variables.
     D LinesRequired   S              1S 0
     D RemainingLines  S              2S 0
     D EndCompare      S             22    INZ('*** End of compare ***')
     D EndReport       S             22    INZ('*** End of report *** ')
     D MatchReport     S             22    INZ('*** Members match *** ')
      *
     D                 DS
     D DspMatchLinesA          1      4
     D DspMatchLinesN          1      4S 0
      *
     D                 DS
     D DspNoOfRcdsA            1      5
     D DspNoOfRcdsN            1      5S 0
      *
     D                 DS
     D SequenceA               1      6
     D SequenceN               1      6S 0
      *
     D                 DS
     D DateA                   1      6
     D DateN                   1      6S 0
      *
     D                 DS
     D InputRcd                1    220
     D  RcdType                2      4
     D  New                    2      5
     D  Summary                2     16
     D  Source                 5    104
     D  RefLibFileMbr         12     45
     D  Old                   66     69
     D  CmpLibFileMbr         76    109
     D  Action               106    109
     D  ActionLenA           110    114
     D  ActionLenN           110    114  0
     D  RefLineNoA           117    122
     D  CmpLineNoA           125    130
      *
     D                 DS
     D HeaderLine              1    116
     D  HeaderMbr             49     82
      *
     D                 DS
     D SpoolLine               1    132
     D  ActionType             1      3
      *
     D  RefLine                4    119
     D  RefBorderB             4      4
     D  RefSeq                 5     10
     D  RefSrc                12    111
     D  RefDate              113    118
     D  RefBorderE           119    119
      *
     D  MatLine                9    124
     D  MatBorderB             9      9
     D  MatSeq                10     15
     D  MatSrc                17    116
     D  MatDate              118    123
     D  MatBorderE           124    124
      *
     D  CmpLine               14    129
     D  CmpBorderB            14     14
     D  CmpSeq                15     20
     D  CmpSrc                22    121
     D  CmpDate              123    128
     D  CmpBorderE           129    129
      *
     D  MatDsp                49     84
     D  EndLine               56     77
      *
     D SpoolData       DS
     D  SpoolFile             83     92
     D  SpoolFileNo          123    124B 0
     D  OverflowLine         188    189B 0
     D  PrintLine            367    368B 0
      *
      /EJECT
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMatchLines
     C                   PARM                    SingleCompare
      *
     C                   EVAL      DspMatchLinesA = PMatchLines
     C                   EVAL      SPHMAT = HMatch
      *
     C     1             SETLL     CMPSRCF
     C                   READ      CMPSRCF
     C                   DOU       %EOF
      *
      * Put record from outfile into data structure.
     C                   EVAL      InputRcd = ZCMPSRCOF
      *
      * Depending on what sort of line is received then perform actions.
     C                   SELECT
      *
      * If it is designated as a header line.
     C                   WHEN      New = 'NEW:' and Old = 'OLD:'
      * Write end of compare marker.
     C                   IF        StartRead = 'Y'
     C                   EVAL      StartRead = 'N'
     C                   ELSE
     C                   EVAL      SpoolLine = *blanks
     C                   EVAL      MatchLineInd = 'Y'
     C                   EVAL      EndLine = EndCompare
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 2
     C                   EXSR      EndofPage
     C                   WRITE     DETAIL
     C                   ENDIF
     C                   EXSR      IDMember
     C                   EXSR      WriteHeader
      * Reset file pointer.
     C     1             SETLL     CMPSRCF
      *
      * If it is designated as an Action line.
     C                   WHEN      Action = 'MAT=' and ActionLenA <> *blanks or
     C                             Action = 'DEL=' and ActionLenA <> *blanks or
     c                             Action = 'INS=' and ActionLenA <> *blanks or
     C                             Action = 'DMV=' and ActionLenA <> *blanks or
     C                             Action = 'IMV=' and ActionLenA <> *blanks or
     C                             Action = 'RPL=' and ActionLenA <> *blanks or
     C                             Action = 'RFM=' and ActionLenA <> *blanks or
     C                             Action = 'DMR=' and ActionLenA <> *blanks or
     C                             Action = 'IMR=' and ActionLenA <> *blanks
     C                   EVAL      NewSection = 'Y'
     C                   EVAL      LinesRequired = 4
     C                   EXSR      FormatLine
      *
      * Delete records as they are read.
     C                   OTHER
     C                   DELETE    CMPSRCF
      *
     C                   ENDSL
      *
      * Read next record.
     C                   READ      CMPSRCF
     C                   ENDDO
      *
      * For last compare write end of compare line ...
     C                   EVAL      SpoolLine = *blanks
     C                   EVAL      MatchLineInd = 'Y'
     C                   EVAL      EndLine = EndCompare
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 2
     C                   EXSR      EndofPage
     C                   WRITE     DETAIL
      * ... and end of report line.
     C                   EVAL      SpoolLine = *blanks
     C                   EVAL      EndLine = EndReport
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 2
     C                   EXSR      EndofPage
     C                   WRITE     DETAIL
      *
      * If not a single compare then write out summary report.
     C                   IF        SingleCompare <> 'Y'
     C                   EXSR      WriteSummary
     C                   ENDIF
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  FormatLine - Format lines for comparison.                    *
      *                                                               *
      *****************************************************************
      *
     C     FormatLine    BEGSR
      *
      * Save number of lines for Action.
     C                   EVAL      SActionLenN = ActionLenN
      *
     C                   SELECT
      * Matching lines.
     C                   WHEN      Action = 'MAT='
      *
     C                   EVAL      Mode = 'M'
      * If this is the first line for a member then check if members match ...
     C                   IF        FirstRecord = 'Y'                            B01
     C                   EXSR      CheckEnd
      * If the members do match then print out report line and delete all
      *  records from the compare file.
     C                   IF        EndFlag = 'Y'                                B02
     C                   EVAL      NoToDelete = SActionLenN
     C                   EXSR      DeleteMatch
     C                   EVAL      SpoolLine = *blanks
     C                   EVAL      EndLine = MatchReport
     C                   EVAL      SPDTL = SpoolLine
     C                   WRITE     DETAIL
      * If the members do not match then check for number of matching lines and
      *  take copy of file to keyed source file.
     C                   ELSE                                                   X02
     C                   EXSR      CopySource
     C                   IF        SActionLenN > DspMatchLinesN                 B03
     C                   EVAL      NoToDelete = SActionLenN - DspMatchLinesN
     C                   EXSR      DeleteMatch
     C                   EVAL      NoMiddleLines = NoToDelete
     C                   EXSR      WNoOfMatches
     C                   EVAL      NoToWrite = DspMatchLinesN
     C                   EXSR      WMatchLines
     C                   ELSE                                                   X03
     C                   EVAL      NoToWrite = SActionLenN
     C                   EXSR      WMatchLines
     C                   ENDIF                                                  E03
     C                   ENDIF                                                  E02
     C                   EVAL      FirstRecord = 'N'
      *
     C                   ELSE                                                   X01
     C                   EXSR      CheckEnd
     C                   IF        EndFlag = 'Y'                                B04
     C                   IF        SActionLenN > DspMatchLinesN * 2             B05
     C                   EVAL      NoToWrite = DspMatchLinesN
     C                   EXSR      WMatchLines
     C                   EVAL      NoMiddleLines = SActionLenN -
     C                             DspMatchLinesN
     C                   EXSR      WNoOfMatches
     C                   ELSE                                                   X05
     C                   EVAL      NoToWrite = SActionLenN
     C                   EXSR      WMatchLines
     C                   ENDIF                                                  E05
     C                   ELSE                                                   X04
     C                   IF        SActionLenN > DspMatchLinesN * 2             B06
     C                   EVAL      NoToWrite = DspMatchLinesN
     C                   EXSR      WMatchLines
     C                   EVAL      NoMiddleLines = SActionLenN -
     C                             (DspMatchLinesN * 2)
     C                   EXSR      WNoOfMatches
     C                   EVAL      NoToDelete = NoMiddleLines
     C                   EXSR      DeleteMatch
     C                   EXSR      WMatchLines
     C                   ELSE                                                   X06
     C                   EVAL      NoToWrite = SActionLenN
     C                   EXSR      WMatchLines
     C                   ENDIF                                                  E06
     C                   ENDIF                                                  E04
     C                   ENDIF                                                  E01
      *
      * Inserts / Deletes or Moves
     C                   WHEN      Action = 'INS=' or Action = 'DEL=' or
     C                             Action = 'IMV=' or Action = 'DMV=' or
     C                             Action = 'IMR=' or Action = 'DMR='
     C                   EVAL      FirstRecord = 'N'
     C                   EXSR      InsDelMove
      *
      * Shifts
     C                   WHEN      Action = 'RFM='
     C                   EVAL      FirstRecord = 'N'
     C                   EVAL      Mode = 'S'
     C                   EXSR      Shift
      *
      * Replacements
     C                   WHEN      Action = 'RPL='
     C                   EVAL      FirstRecord = 'N'
     C                   EXSR      Replace
      *
     C                   OTHER
      *
     C                   ENDSL
      *
     C     FormatLineE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  IDMember - Identify source member.                           *
      *                                                               *
      *****************************************************************
      *
     C     IDMember      BEGSR
      *
     C                   EVAL      HeaderLine = HDiff
      * Get reference member details.
     C                   EVAL      LibFileMbr = RefLibFileMbr
     C                   EXSR      MbrDetails
     C                   EVAL      RSourceFMbr = SourceFMbr
     C                   EVAL      RLibFile = LibFile
      * Update header record.
     C                   EVAL      HeaderMbr = %TRIMR(LibFile) +
     C                             ' ' + %TRIMR(SourceFMbr) + ' ' + Hyphens
     C                   EVAL      SPHREF = HeaderLine
      *
      * Get comparison member details.
     C                   EVAL      LibFileMbr = CmpLibFileMbr
     C                   EXSR      MbrDetails
     C                   EVAL      CSourceFMbr = SourceFMbr
     C                   EVAL      CLibFile = LibFile
      * Update header record.
     C                   EVAL      HeaderMbr = %TRIMR(LibFile) +
     C                             ' ' + %TRIMR(SourceFMbr) + ' ' + Hyphens
     C                   EVAL      SPHCMP = HeaderLine
      * Remove all other records relating to this member.
     C/EXEC SQL
     C+  delete from CMPSRCOF where CMPSRCOF = :ZCMPSRCOF
     C/END-EXEC
     C                   EVAL      FirstRecord = 'Y'
      *
     C     IDMemberE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  MbrDetails - Get member details.                             *
      *                                                               *
      *****************************************************************
      *
     C     MbrDetails    BEGSR
      *
      * Break down string containing source member details.
      *  Library/File
     C                   EVAL      OBracketPos = %SCAN('(':LibFileMbr:1)
     C                   EVAL      OBracketPos = OBracketPos - 1
     C                   EVAL      LibFile = %SUBST(LibFileMbr:1:OBracketPos)
      *  Member
     C                   EVAL      OBracketPos = OBracketPos + 1
     C                   EVAL      CBracketPos =
     C                             %SCAN(')':LibFileMbr:OBracketPos)
     C                   EVAL      CBracketPos = CBracketPos - OBracketPos + 1
     C                   EVAL      SourceFMbr =
     C                             %SUBST(LibFileMbr:OBracketPos:CBracketPos)
      *
     C     MbrDetailsE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WriteHeader - Write header record.                           *
      *                                                               *
      *****************************************************************
      *
     C     WriteHeader   BEGSR
      *
     C                   WRITE     HEAD01
     C                   WRITE     HEAD02
      *
     C     WriteHeaderE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  DeleteMatch - Delete records for matching members.           *
      *                                                               *
      *****************************************************************
      *
     C     DeleteMatch   BEGSR
      *
      * Ensure file pointer is set to start of file.
     C     1             SETLL     CMPSRCF
     C                   READ      CMPSRCF
     C                   EVAL      InputRcd = ZCMPSRCOF
      *
     C                   EVAL      Counter = 0
      * Read and delete all records until end of number reached.
     C                   DOU       Counter = NoToDelete
     C                   DELETE    CMPSRCOF
     C                   EXSR      GetSourceData
     C                   READ      CMPSRCF
     C                   EVAL      InputRcd = ZCMPSRCOF
     C                   EVAL      Counter = Counter + 1
     C                   ENDDO
      *
     C     DeleteMatchE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  CheckEnd - Check for end of compare                          *
      *                                                               *
      *****************************************************************
     C     CheckEnd      BEGSR
      *
     C                   EVAL      EndFlag = 'N'
     C                   EVAL      NewAction = 'N'
     C                   DOU       EndFlag = 'Y' or
     C                             NewAction = 'Y'
     C                   READ      CMPSRCF
      * If a new Action is found.
     C                   EVAL      InputRcd = ZCMPSRCOF
     C                   IF        Action = 'INS=' or
     C                             Action = 'DEL=' or
     C                             Action = 'RPL=' or
     C                             Action = 'RFM='
     C                   EVAL      NewAction = 'Y'
     C                   ENDIF
      * If summary details are found.
     C                   IF        Summary = 'TOTAL CHANGES ('
     C                   EVAL      EndFlag = 'Y'
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Set file pointer back to start of file.
     C     1             SETLL     CMPSRCF
     C                   READ      CMPSRCF
     C                   EVAL      InputRcd = ZCMPSRCOF
      *
     C     CheckEndE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WMatchLines - Write matching lines.                          *
      *                                                               *
      *****************************************************************
     C     WMatchLines   BEGSR
      *
     C                   EVAL      SpoolLine = *blanks
      * Write matching line header.
     C                   EVAL      MatLine = MatchS
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 4
     C                   EXSR      EndOfPage
     C                   WRITE     DETAIL
     C                   EVAL      SpoolLine = *blanks
     C                   EVAL      NewSection = *blank
      *
     C                   EVAL      Counter = 0
     C                   DOU       Counter = NoToWrite
     C                   EVAL      MatLine = *blanks
     C                   EVAL      ActionType = '='
     C                   EVAL      MatBorderB = '|'
     C                   EVAL      MatSrc = Source
     C                   EXSR      GetSourceData
     C                   EVAL      MatSeq = GSeq
     C                   EVAL      MatDate = GDate
     C                   EVAL      MatBorderE = '|'
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 2
     C                   EXSR      EndOfPage
     C                   WRITE     DETAIL
     C                   EVAL      SpoolLine = *blanks
      *
     C                   DELETE    CMPSRCF
     C                   EVAL      Counter = Counter + 1
     C                   IF        Counter <> NoToWrite
     C                   READ      CMPSRCF
     C                   EVAL      InputRcd = ZCMPSRCOF
     C                   ENDIF
     C                   ENDDO
      *
      * Write matching line trailer.
     C                   EVAL      SpoolLine = *blanks
     C                   EVAL      MatLine = MatchE
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 0
     C                   EXSR      EndOfPage
     C                   WRITE     DETAIL
     C                   EVAL      SpoolLine = *blanks
      *
     C     WMatchLinesE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WNoOfMatches - Write line showing number of matched lines    *
      *                 not displayed.                                *
      *                                                               *
      *****************************************************************
     C     WNoOfMatches  BEGSR
      *
     C                   EVAL      SMode = Mode
     C                   EVAL      Mode = *blank
     C                   EVAL      SpoolLine = *blanks
      *
     C                   EVAL      MatBorderB = *blank
     C                   EVAL      MatBorderE = *blank
     C                   EVAL      MatDsp = %CHAR(NoMiddleLines) +
     C                             MatDspConst
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      MatchLineInd = 'Y'
     C                   EVAL      LinesRequired = 2
     C                   EXSR      EndOfPage
     C                   WRITE     DETAIL
     C                   EVAL      SpoolLine = *blanks
      *
     C                   EVAL      Mode = SMode
     C                   EVAL      MatchLineInd = 'N'
      *
     C     WNoOfMatchesE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  InsDelMove - Handle Inserts, Deletes and Moves               *
      *                                                               *
      *****************************************************************
     C     InsDelMove    BEGSR
      *
     C                   EVAL      SpoolLine = *blanks
      *
      * Write header for differing records.
     C                   IF        %SUBST(Action:1:1) = 'I'
     C                   EVAL      Mode = 'I'
     C                   EVAL      RefLine = DiffS
     C                   ELSE
     C                   EVAL      Mode = 'D'
     C                   EVAL      CmpLine = DiffS
     C                   ENDIF
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 4
     C                   EXSR      EndOfPage
     C                   WRITE     DETAIL
     C                   EVAL      NewSection = *blank
      *
      * Perform the loop for the number of different lines.
     C                   EVAL      Counter = 0
     C                   DOU       Counter = SActionLenN
     C                   IF        Action = *blank
     C                   EVAL      Action = SAction
     C                   ELSE
     C                   EVAL      SAction = Action
     C                   ENDIF
     C                   EVAL      SpoolLine = *blanks
     C                   IF        %SUBST(Action:1:1) = 'I'
     C                   IF        Action = 'INS='
     C                   EVAL      Mode = 'I'
     C                   EVAL      ActionType = 'I-'
     C                   ELSE
     C                   IF        Action = 'IMV='
     C                   EVAL      ActionType = 'MI-'
     C                   ELSE
     C                   EVAL      ActionType = 'SM-'
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      RefBorderB = '|'
     C                   EVAL      RefSrc = Source
     C                   EXSR      GetSourceData
     C                   EVAL      RefSeq = GSeq
     C                   EVAL      RefDate = GDate
     C                   EVAL      RefBorderE = '|'
     C                   ELSE
     C                   IF        Action = 'DEL='
     C                   EVAL      Mode = 'D'
     C                   EVAL      ActionType = 'D-'
     C                   ELSE
     C                   IF        Action = 'DMV='
     C                   EVAL      ActionType = 'MD-'
     C                   ELSE
     C                   EVAL      ActionType = 'SM-'
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      CmpBorderB = '|'
     C                   EVAL      CmpSrc = Source
     C                   EXSR      GetSourceData
     C                   EVAL      CmpSeq = GSeq
     C                   EVAL      CmpDate = GDate
     C                   EVAL      CmpBorderE = '|'
     C                   ENDIF
      *
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 2
     C                   EXSR      EndOfPage
     C                   WRITE     DETAIL
     C                   DELETE    CMPSRCF
     C                   EVAL      Counter = Counter + 1
      * Do not read next record if this is the last loop through as this is done in
      *  the main loop.
     C                   IF        Counter <> SActionLenN
     C                   READ      CMPSRCF
     C                   EVAL      InputRcd = ZCMPSRCOF
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Write trailer for differing records.
     C                   EVAL      SpoolLine = *blanks
     C                   IF        %SUBST(Action:1:1) = 'I'
     C                   EVAL      Mode = 'I'
     C                   EVAL      RefLine = DiffE
     C                   ELSE
     C                   EVAL      Mode = 'D'
     C                   EVAL      CmpLine = DiffE
     C                   ENDIF
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 0
     C                   EXSR      EndOfPage
     C                   WRITE     DETAIL
      *
     C     InsDelMoveE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Shift - Handled shifted records.                             *
      *                                                               *
      *****************************************************************
     C     Shift         BEGSR
      *
      * Because these types of changes always come in pairs multiply by 2.
     C                   EVAL      SActionLenN = ActionLenN * 2
      * Write header for differing records.
     C                   EVAL      SpoolLine = *blanks
     C                   EVAL      MatLine = DiffS
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 4
     C                   EXSR      EndOfPage
     C                   WRITE     DETAIL
     C                   EVAL      NewSection = *blank
      *
      * Perform the loop for the number of differentlines.
     C                   EVAL      Counter = 0
     C                   DOU       Counter = SActionLenN
     C                   EVAL      SpoolLine = *blanks
      *
      * Sequence numbers are only displayed on the first line of the pair.
     C                   EXSR      RefCmpSeq
      *
     C                   IF        RcdType = 'RN-'
     C                   EVAL      ActionType = 'SI-'
     C                   ELSE
     C                   EVAL      ActionType = 'SD-'
     C                   ENDIF
     C                   EVAL      MatBorderB = '|'
     C                   EVAL      MatSrc = Source
     C                   EXSR      GetSourceData
     C                   EVAL      MatSeq = GSeq
     C                   EVAL      MatDate = GDate
     C                   EVAL      MatBorderE = '|'
      *
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 2
     C                   EXSR      EndOfPage
     C                   WRITE     DETAIL
     C                   DELETE    CMPSRCF
     C                   EVAL      Counter = Counter + 1
      * Do not read next record if this is the last loop through as this is done in
      *  the main loop.
     C                   IF        Counter <> SActionLenN
     C                   READ      CMPSRCF
     C                   EVAL      InputRcd = ZCMPSRCOF
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Write trailer for differing records.
     C                   EVAL      SpoolLine = *blanks
     C                   EVAL      MatLine = DiffE
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 0
     C                   EXSR      EndOfPage
     C                   WRITE     DETAIL
      *
     C     ShiftE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Replace - Handle Replacements                                *
      *                                                               *
      *****************************************************************
     C     Replace       BEGSR
      *
      * Because these types of changes always come in pairs multiply by 2.
     C                   EVAL      SActionLenN = ActionLenN * 2
      * Write first header for differing records.
     C                   IF        RcdType = 'I -'
     C                   EVAL      Mode = 'I'
     C                   EVAL      RefLine = DiffS
     C                   ELSE
     C                   EVAL      Mode = 'D'
     C                   EVAL      CmpLine = DiffS
     C                   ENDIF
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 4
     C                   EXSR      EndOfPage
     C                   WRITE     DETAIL
     C                   EVAL      NewSection = *blank
      * Save record type.
     C                   EVAL      SRcdType = RcdType
      *
      * Perform the loop for the number of different lines.
     C                   EVAL      Counter = 0
     C                   DOU       Counter = SActionLenN
     C                   EVAL      SpoolLine = *blanks
      *
      * Sequence numbers are only displayed on the first line of the pair.
     C                   EXSR      RefCmpSeq
      *
     C                   EVAL      SpoolLine = *blanks
     C                   IF        RcdType = 'I -'
     C                   EVAL      Mode = 'I'
     C                   EVAL      ActionType = 'I-'
     C                   EVAL      RefBorderB = '|'
     C                   EVAL      RefSrc = Source
     C                   EXSR      GetSourceData
     C                   EVAL      RefSeq = GSeq
     C                   EVAL      RefDate = GDate
     C                   EVAL      RefBorderE = '|'
     C                   ELSE
     C                   EVAL      Mode = 'D'
     C                   EVAL      ActionType = 'D-'
     C                   EVAL      CmpBorderB = '|'
     C                   EVAL      CmpSrc = Source
     C                   EXSR      GetSourceData
     C                   EVAL      CmpSeq = GSeq
     C                   EVAL      CmpDate = GDate
     C                   EVAL      CmpBorderE = '|'
     C                   ENDIF
      *
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 2
     C                   EXSR      EndOfPage
     C                   WRITE     DETAIL
     C                   DELETE    CMPSRCF
     C                   EVAL      Counter = Counter + 1
      * Do not read next record if this is the last loop through as this is done in
      *  the main loop.
     C                   IF        Counter <> SActionLenN
     C                   READ      CMPSRCF
     C                   EVAL      InputRcd = ZCMPSRCOF
      * If new record type is different then write trailer based on old record type.
     C                   IF        RcdType <> SRcdType
     C                   EVAL      SpoolLine = *blanks
     C                   IF        SRcdType = 'I -'
     C                   EVAL      Mode = 'I'
     C                   EVAL      RefLine = DiffE
     C                   ELSE
     C                   EVAL      Mode = 'D'
     C                   EVAL      CmpLine = DiffE
     C                   ENDIF
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 0
     C                   EXSR      EndOfPage
     C                   WRITE     DETAIL
      * Then write new header.
     C                   EVAL      SpoolLine = *blanks
     C                   IF        RcdType = 'I -'
     C                   EVAL      Mode = 'I'
     C                   EVAL      RefLine = DiffS
     C                   ELSE
     C                   EVAL      Mode = 'D'
     C                   EVAL      CmpLine = DiffS
     C                   ENDIF
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 4
     C                   EXSR      EndOfPage
     C                   WRITE     DETAIL
     C                   ENDIF
     C                   EVAL      SRcdType = RcdType
     C                   ENDIF
      *
     C                   ENDDO
      *
      * Write trailer for last differing records.
     C                   EVAL      SpoolLine = *blanks
     C                   IF        SRcdType = 'I -'
     C                   EVAL      Mode = 'I'
     C                   EVAL      RefLine = DiffE
     C                   ELSE
     C                   EVAL      Mode = 'D'
     C                   EVAL      CmpLine = DiffE
     C                   ENDIF
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      LinesRequired = 0
     C                   EXSR      EndOfPage
     C                   WRITE     DETAIL
      *
     C     ReplaceE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  RefCmpSeq - Store Reference and Comparison sequences         *
      *                                                               *
      *****************************************************************
     C     RefCmpSeq     BEGSR
      *
     C                   IF        RefLineNoA = *blanks
     C                   EVAL      RefLineNoA = SRefLineNoA
     C                   ELSE
     C                   EVAL      SRefLineNoA = RefLineNoA
     C                   ENDIF
     C                   IF        CmpLineNoA = *blanks
     C                   EVAL      CmpLineNoA = SCmpLineNoA
     C                   ELSE
     C                   EVAL      SCmpLineNoA = CmpLineNoA
     C                   ENDIF
      *
     C     RefCmpSeqE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  EndOfPage - Handle end of page processing.                   *
      *                                                               *
      *****************************************************************
     C     EndOfPage     BEGSR
      *
      * Check if there is enough space to print required lines.
     C                   IF        OverflowLine - PrintLine <= LinesRequired
      *
      * If a 'matching records not displayed' or a new section is starting and
      *  there is not enough room then start new page.
     C                   IF        LinesRequired = 4
     C                   EXSR      WriteHeader
     C                   ENDIF
      *
      * If the end of page is reached in hte middle of a section then print an
      *  'end of section' line, start new page and print a 'start of section' line.
     C                   IF        LinesRequired = 2
     C                   IF        MatchLineInd = 'Y'
     C                   EXSR      WriteHeader
     C                   ELSE
     C                   EVAL      SSpoolLine = SpoolLine
     C                   EVAL      SpoolLine = *blanks
      * Print line depending on mode.
     C                   SELECT
      *
     C                   WHEN      Mode = 'I'
     C                   EVAL      RefLine = DiffE
      *
     C                   WHEN      Mode = 'D'
     C                   EVAL      CmpLine = DiffE
      *
     C                   WHEN      Mode = 'S'
     C                   EVAL      MatLine = DiffE
      *
     C                   WHEN      Mode = 'M'
     C                   EVAL      MatLine = MatchE
      *
     C                   OTHER
      *
     C                   ENDSL
      *
     C                   EVAL      SPDTL = SpoolLine
     C                   WRITE     DETAIL
     C                   EXSR      WriteHeader
      *
      * Write first line of continuation
     C                   EVAL      SpoolLine = *blanks
     C                   SELECT
      *
     C                   WHEN      Mode = 'I'
     C                   EVAL      RefLine = DiffS
      *
     C                   WHEN      Mode = 'D'
     C                   EVAL      CmpLine = DiffS
      *
     C                   WHEN      Mode = 'S'
     C                   EVAL      MatLine = DiffS
      *
     C                   WHEN      Mode = 'M'
     C                   EVAL      MatLine = MatchS
      *
     C                   OTHER
      *
     C                   ENDSL
      *
     C                   EVAL      SPDTL = SpoolLine
     C                   WRITE     DETAIL
      *
     C                   EVAL      SPDTL = SSpoolLine
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EndOfPageE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  CopySource - Copy source file member to keyed logical        *
      *                                                               *
      *****************************************************************
      *
     C     CopySource    BEGSR
      *
      * Remove brackets from member name.
     C                   EVAL      Command = *blanks
     C                   EVAL      SourceFMbr = *blanks
      * Build up CPYSRCF string for reference member.
     C                   EVAL      CBracketPos =
     C                             %SCAN(')':RSourceFMbr:1)
     C                   EVAL      SourceFMbr =
     C                             %SUBST(RSourceFMbr:2:(CBracketPos - 2))
     C                   EVAL      Command = 'CPYSRCF FROMFILE(' +
     C                             %TRIM(RLibFile) + ') TOFILE(QTEMP/UTSRCFPD) +
     C                             FROMMBR(' + %TRIM(SourceFMbr) +
     C                             ') TOMBR(REF)'
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      *
     C                   EVAL      Command = *blanks
     C                   EVAL      SourceFMbr = *blanks
      * Build up CPYSRCF string for comparison member.
     C                   EVAL      CBracketPos =
     C                             %SCAN(')':CSourceFMbr:1)
     C                   EVAL      SourceFMbr =
     C                             %SUBST(CSourceFMbr:2:(CBracketPos - 2))
     C                   EVAL      Command = 'CPYSRCF FROMFILE(' +
     C                             %TRIM(CLibFile) + ') TOFILE(QTEMP/UTSRCFPD) +
     C                             FROMMBR(' + %TRIM(SourceFMbr) +
     C                             ') TOMBR(CMP)'
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      *
     C     CopySourceE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetSourceData - Get date and sequence number for source      *
      *                                                               *
      *****************************************************************
      *
     C     GetSourceData BEGSR
      *
     C                   EVAL      KSource = Source
      * If Mode is Match then records will need to be deleted from both copies
      *  of source files.
     C                   IF        Mode = 'M'
     C                   EVAL      OVRMember = 'CMP'
     C                   EVAL      Command = OVRDBFCommand + OVRMember + ')'
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      *
      * Delete record from comparison version of source file.
     C                   OPEN      UTSRCFL0
     C     KSource       CHAIN     UTSRCFPD
     C                   IF        %FOUND
     C                   DELETE    UTSRCFPD
     C                   ENDIF
     C                   CLOSE     UTSRCFL0
      *
      * Delete override.
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = DLTOVRCommand
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   EVAL      Command = *blanks
     C                   ENDIF
      *
      * Override to correct member to retrieve date and sequence.
     C                   IF        Mode = 'D' or
     C                             ActionType = 'SD-'
     C                   EVAL      OVRMember = 'CMP'
     C                   ELSE
     C                   EVAL      OVRMember = 'REF'
     C                   ENDIF
     C                   EVAL      Command = OVRDBFCommand + OVRMember + ')'
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      *
      * Retrieve date and sequence number from appropriate version of source.
     C                   OPEN      UTSRCFL0
     C     KSource       CHAIN     UTSRCFPD
     C                   IF        %FOUND
     C                   EVAL      DateN = SRCDAT
     C                   EVAL      GDate = DateA
     C                   EVAL      SequenceN = SRCSEQ * 100
     C                   EVAL      GSeq  = SequenceA
     C                   DELETE    UTSRCFPD
     C                   ELSE
     C                   EVAL      GDate = '000000'
     C                   EVAL      GSeq = *blanks
     C                   ENDIF
     C                   CLOSE     UTSRCFL0
      *
      * Delete override.
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = DLTOVRCommand
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
      *
      *
     C     GetSourceDataEENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WriteSummary - Write summary pages at the end.               *
      *                                                               *
      *****************************************************************
      *
     C     WriteSummary  BEGSR
      *
      * Set up library names.
     C**********         EVAL      SPSCRL = RLibFile                                          CUP007
     C**********         EVAL      SPSCCL = CLibFile                                          CUP007
     C                   EVAL      SPSCRL = *blanks                                           CUP007
     C                   EVAL      FwdSlshPos = %SCAN('/':RLibFile:1)                         CUP007
     C                   EVAL      SPSCRL = %SUBST(RLibFile:1:(FwdSlshPos - 1))               CUP007
     C                   EVAL      SPSCCL = *blanks                                           CUP007
     C                   EVAL      FwdSlshPos = %SCAN('/':CLibFile:1)                         CUP007
     C                   EVAL      SPSCCL = %SUBST(CLibFile:1:(FwdSlshPos - 1))               CUP007
      *
     C                   WRITE     HEAD01
      *
      *  Read first record and then loop through file.
     C     1             SETLL     UTC000001R
     C                   READ      UTC000001R
     C                   DOW       NOT(%EOF)
      * If a new source file has been found then print new sub-header.
     C                   IF        MLFILE <> SMLFILE
     C                   EVAL      RemainingLines = OverflowLine - PrintLine
     C                   IF        RemainingLines <= 5
     C                   WRITE     HEAD01
     C                   ENDIF
      * Sub-header details.
     C                   EVAL      SPSCRF = MLFILE
     C                   IF        MLRCEN = '*'
     C                   EVAL      SPSCCF = MLSEU2
     C                   ELSE
     C                   EVAL      SPSCCF = MLFILE
     C                   ENDIF
     C                   WRITE     HEAD03
     C                   EVAL      SMLFILE = MLFILE
     C                   ENDIF
      * Write details.
     C                   EVAL      RemainingLines = OverflowLine - PrintLine
     C                   IF        RemainingLines <= 2
     C                   WRITE     HEAD01
     C                   WRITE     HEAD03
     C                   ENDIF
     C                   EVAL      SPMEMB = MLNAME
     C                   IF        MLRDAT = 'REFCMP' or                         B1
     C                             MLRDAT = 'NOTCMP'
     C                   EVAL      DspNoOfRcdsN = MLNRCD
     C                   EVAL      SPRREC = DspNoOfRcdsA
     C                   IF        MLRDAT = 'REFCMP'                            B2
     C                   EVAL      DspNoOfRcdsN = MLSIZE
     C                   EVAL      SPCREC = DspNoOfRcdsA
     C                   ENDIF                                                  E2
     C                   IF        MLRDAT = 'NOTCMP'                            B2
     C                   EVAL      SPCREC = '*****'
     C                   ENDIF                                                  E2
     C                   ELSE                                                   X1
     C                   EVAL      SPRREC = '*****'
     C                   EVAL      DspNoOfRcdsN = MLNRCD
     C                   EVAL      SPCREC = DspNoOfRcdsA
     C                   ENDIF                                                  E1
      *
     C                   WRITE     SUM
      *
     C                   READ      UTC000001R
      *
     C                   ENDDO
      *
      * Write end of report.
     C                   EVAL      SpoolLine = *blanks
     C                   EVAL      EndLine = EndReport
     C                   EVAL      SPDTL = SpoolLine
     C                   EVAL      RemainingLines = OverflowLine - PrintLine
     C                   IF        RemainingLines <= 2
     C                   WRITE     HEAD01
     C                   ENDIF
     C                   WRITE     DETAIL
      *
     C     WriteSummaryE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = 'N'
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   SETON                                        U7U8
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
