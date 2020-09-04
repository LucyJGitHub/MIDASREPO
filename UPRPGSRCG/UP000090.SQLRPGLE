     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Deliverables list maintenance')               *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000090 - Deliverables list maintenance                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CUP042 *CREATE     Date 13May15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - Simplification of deliverables list.                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *    Subfile control          20 - 29                           *
      *       20  ROLLUP                                              *
      *       21  ROLLDOWN                                            *
      *       22  SFLDSPCTL                                           *
      *       23  SFLDSP                                              *
      *       24  SFLEND                                              *
      *       25  SFLEND message indicator                            *
      *       26  SFLCLR                                              *
      *       27  SFLNXTCHG indicator                                 *
      *       28  OVERLAY PUTOVER indicator on error Messages         *
      *       29  End of changed records                              *
      *    Display controls         30 - 39                           *
      *       30  Headers                                             *
      *       31  Subfile record error                                *
      *       35  Key fields                                          *
      *       36  Bespoke                                             *
      *       37  Core                                                *
      *    Command keys             40 - 49                           *
      *       40  INKJ                                                *
      *       41  INKC                                                *
      *       43  INKL                                                *
      *       44  INKI                                                *
      *    Non-display controls     50 - 59                           *
      *       50  Record details                                      *
      *       51  Do not display if no details                        *
      *    General                  60 - 69                           *
      *    Individual validation    70 - 89                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index.                                            *
      *                                                               *
      *  AddRecord     - Process the insert screen                    *
      *  GetRecord     - Load the selected record to second screen    *
      *  DeleteRecord  - Delete selected record                       *
      *  AmendRecord   - Amend selected record                        *
      *  EnquireRecord - Enquire selected record                      *
      *  InsertRecord  - Process inserted record                      *
      *  UpdateDpndcs  - Update dependencies field from CBCMP*TD      *
      *  CheckAction   - Check user is authorised to action           *
      *  ValidateFlds  - Validate input                               *
      *  AddRecProc    - Additional processing for a record           *
      *  LoadSubfile   - Display all records to subfile               *
      *  CalcDisplay   - Calculate which page to display              *
      *  SelectStmnt   - Select which Statement to use                *
      *  MoveDisplay   - Move display fields to data file             *
      *  MoveData      - Move data fields to display file             *
      *  Validatexxxx  - Individual field validation                  *
      *  ResetInds     - Reset error indicators                       *
      *  Clear         - Clear the error messages on the subfile      *
      *  ClearRecs     - Clear records                                *
      *  ClearFlds     - Clear display file fields                    *
      *  ZASNMS        - Send message to program's message queue      *
      *  *INZSR        - Initial processing                           *
      *  NonDisplay    - Set on indicators to not display fields      *
      *  Exit          - Exit program                                 *
      *  DeletePhyRec  - Delete bespoke records that are logically    *
      *                  deleted                                      *
      *  *PSSR         - Program exception error routine              *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Display File
     FUP000090DFCF   E             WORKSTN
     F                                     SFILE(UP000090S0:RdCtr)
      *
      ** Program data structure
     D MyPSDS         SDS
     D DFPGMQ                  1     10
     D DFJOBN                244    253
     D DFUSER                254    263
      *
      ** Declared Variables
     D WRun            S              1A
     D RdCtr           S             10  0
     D Pos             S              3  0
     D ValidationMode  S              1A
     D RecCount        S              5  0
     D Empty           S              1A
     D FoundPos        S              3  0
     D WFMBNM          S             10A
     D CurFlg          S              1A
     D SrchFl          S              1A
     D TotPag          S              2S 0 INZ(13)
     D PageNo          S              5S 0
     D StrRec          S              6S 0
     D EndRec          S              6S 0
     D SQLStmt         S           1000A
     D Library         S             10A
     D ObjType         S             10A
     D MbrType         S             10A
     D Member          S             10A
     D ExistYN         S             10A
     D Sqnce           S              5A
     D Command         S            300A
     D DltFlg          S              1A
     D ReturnCode      S              1A
     D ActionFile      S              1A
      *
      ** ZASNMS Variables
     D ZAPGMQ          S             10A
     D ZAPGRL          S              5A
     D ZAMSID          S              7A
     D ZAMSGF          S             10A
     D ZAMSDA          S            132A
     D ZAMSTP          S              7A
      *
      ** Error Indicators
     D ErIOff          S             12A
     D ErrInd          S              1A
     D ErrFlg          S              1A
      *
      ** CBTIME Parameters
     D DayNoa          S              5A
     D STime           S              6A
     D DFmt            S              1A
      *
      ** ZDATE2 Parameters
     D CurrDt          S              5  0
     D WQ0003          S              6  0
     D ZDate           S              7A
      *
     D DLVCDS        E DS                  EXTNAME(UPDLVCPD)
      *
      ** Main process.
     C                   DOW       *INKC = *OFF
      *
      ** Display column headings on subfile.
     C                   EVAL      *IN30 = *ON
      *
      ** Process first screen.
     C                   EXSR      LoadSubfile
      *
      ** End program if F3 is pressed.
     C                   IF        *INKC = *ON
     C                   EXSR      Exit
     C                   ENDIF
      *
      ** Execute insert screen when F9 is pressed ...
     C                   IF        *INKI = *ON
     C                   EXSR      AddRecord
     C                   ELSE
     C                   EXSR      GetRecord
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** End of program.
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  AddRecord - Process the insert screen                        *
      *                                                               *
      *****************************************************************
     C     AddRecord     BEGSR
      *
      ** Check user is authorised to action first.
     C                   EVAL      ValidationMode = 'I'
      *
     C                   EXSR      ClearFlds
      *
     C                   EXSR      InsertRecord
     C                   DOW       ErrInd = 'Y'
     C                             and *INKL = *OFF
     C                             or *INKE = *ON
     C                   EXSR      InsertRecord
     C                   ENDDO
      *
     C     AddRecordE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  GetRecord - Load the selected record to second screen        *
      *                                                               *
      *****************************************************************
     C     GetRecord     BEGSR
      *
      ** Read changed record and process it
     C                   READC     UP000090S0                             29
     C                   DOW       *IN29 = *OFF
      *
      ** Check that the user is authorised to the action.
     C                   IF        DFAORD = 'A'
     C                             or DFAORD = 'D'
     C                             or DFAORD = 'E'
     C                   EVAL      ValidationMode = DFAORD
     C                   ENDIF
      *
      ** If Delete.
     C                   IF        DFAORD = 'D'
     C                   EXSR      DeleteRecord
      *
     C                   DOW       (*INKJ = *OFF
     C                             and *INKL = *OFF)
     C                             or ErrInd = 'Y'
     C                   EXSR      DeleteRecord
     C                   ENDDO
      *
      *
     C                   ENDIF
      *
      ** If Amend.
     C                   IF        DFAORD = 'A'
      *
     C                   EXSR      AmendRecord
      *
     C                   DOW       ErrInd = 'Y'
     C                             and *INKL = *OFF
     C                             or *INKE = *ON
     C                   EXSR      AmendRecord
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** If Enquire.
     C                   IF        DFAORD = 'E'
     C                   EXSR      EnquireRecord
      *
     C                   DOW       ErrInd = 'Y'
     C                             and *INKL = *OFF
     C                   EXSR      EnquireRecord
     C                   ENDDO
     C                   ENDIF
      *
      ** If not 'A', 'D' or 'E'.
     C                   IF        DFAORD <> 'A'
     C                             and DFAORD <> 'D'
     C                             and DFAORD <> 'E'
     C                             and DFAORD <> *blank
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0001'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN27 = *ON
      *
     C                   UPDATE    UP000090S0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank
      *
     C                   UPDATE    UP000090S0
     C                   READC     UP000090S0                             29
     C                   ENDDO
      *
     C     GetRecordE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  DeleteRecord - Delete selected record                        *
      *                                                               *
      *****************************************************************
     C     DeleteRecord  BEGSR
      *
      ** Set up display for Delete screen.
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN44 = *ON
      *
     C                   WRITE     UP000090F0
     C                   WRITE     UP000090F5
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UP000090C1
     C                   ENDIF
      *
     C                   EXFMT     UP000090F2
      *
      ** Reset values.
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
      *
      ** If F10 is pressed then delete record.
     C                   IF        *INKJ = *ON
     C                   IF        ERRIND <> 'Y'
      *
     C/exec SQL
     C+ delete from UPDLVCPD
     C+ where
     C+     AUMBNM = :DFMBNM
     C+ and AUMBTP = :DFMBTP
     C+ and AUSRCF = :DFSRCF
     C/end-exec
     C                   ENDIF
      *
     C                   IF        SQLCODE <> 0
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'DLV0008'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        *INKL <> *ON
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0008'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C     DeleteRecordE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  AmendRecord - Amend selected record                          *
      *                                                               *
      *****************************************************************
     C     AmendRecord   BEGSR
      *
      ** Set up display for Amend screen
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN44 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
      *
      ** Set indicators on or off depending upon requirements.
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN37 = *ON
      *
     C                   WRITE     UP000090F0
     C                   WRITE     UP000090F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UP000090C1
     C                   ENDIF
      *
     C                   EXFMT     UP000090F2
      *
      ** Reset Values
     C                   EXSR      CLEAR
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
      *
      ** No processing done since all fields are keyfields.
     C                   SELECT
      *
      ** If F5 is pressed then refresh.
     C                   WHEN      *INKE = *ON
     C/exec SQL
     C+ select * into :DLVCDS
     C+ from UPDLVCPD
     C+ where
     C+     AUMBNM = :DFMBNM
     C+ and AUMBTP = :DFMBTP
     C+ and AUSRCF = :DFSRCF
     C/end-exec
     C                   EXSR      MoveData
     C                   EVAL      DFAORD = 'A'
      *
      ** If F12 is pressed go back to the main screen.
     C                   WHEN      *INKL = *ON
     C                   EVAL      DFAORD = *blank
      *
     C                   OTHER
     C                   EXSR      ValidateFlds
     C                   IF        ErrInd <> 'Y'
      ** If there are no errors then update tables.
     C                   EXSR      MoveDisplay
      *
     C/exec SQL
     C+ update UPDLVCPD set
     C+   AUMBTX = :DFMBTX
     C+ , AUIPTY = :DFIPTY
     C+ , AUDTYP = :DFDTYP
     C+ , AUCPYO = :DFCPYO
     C+ , AUFMTO = :DFFMTO
     C+ , AUDTLB = :DFDTLB
     C+ , AUPROJ = :DFPROJ
     C+ , AUEXIN = :DFEXIN
     C+ , AUUSTS = :DFUSTS
     C+ where
     C+     AUMBNM = :DFMBNM
     C+ and AUMBTP = :DFMBTP
     C+ and AUSRCF = :DFSRCF
     C/end-exec
      *
     C                   IF        SQLCODE <> 0
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'DLV0008'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSL
      *
     C     AmendRecordE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  EnquireRecord - Enquire selected record                      *
      *                                                               *
      *****************************************************************
     C     EnquireRecord BEGSR
      *
      ** Set up display for Enquire screen.
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN44 = *ON
      *
     C                   WRITE     UP000090F0
     C                   WRITE     UP000090F4
      *
     C                   EXFMT     UP000090F2
      *
      * Reset indicators.
     C                   EXSR      ResetInds
      *
     C                   SELECT
      ** If F5 is pressed then refresh.
     C                   WHEN      *INKE = *ON
     C                   EVAL      DFAORD = 'A'
      *
      ** If F12 is pressed go back to the main screen.
     C                   WHEN      *INKL = *ON
     C                   EVAL      DFAORD = *blank
     C                   ENDSL
      *
     C     EnquireRecordEENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  InsertRecord - Process inserted record                       *
      *                                                               *
      *****************************************************************
     C     InsertRecord  BEGSR
      *
      ** Set up display for Insert screen
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN37 = *ON
      *
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN44 = *ON
      *
     C                   WRITE     UP000090F0
     C                   WRITE     UP000090F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UP000090C1
     C                   ENDIF
      *
     C                   EXFMT     UP000090F2
      *
      ** Reset values.
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
      *
      ** Refresh fields.
     C                   IF        *INKE = *ON
     C                   EXSR      ClearFlds
     C                   ENDIF
      *
      ** Process validation if F12 and F5 are not pressed.
     C                   IF        *INKL = *OFF
     C                             and *INKE = *OFF
     C                   EXSR      ValidateFlds
     C                   IF        ErrInd <> 'Y'
      ** Insert the record if there is no error.
     C                   EXSR      MoveDisplay
      *
     C/exec SQL
     C+ insert into UPDLVCPD
     C+ (
     C+   AUMBNM
     C+ , AUMBTP
     C+ , AUSRCF
     C+ , AUMBTX
     C+ , AUCAPR
     C+ , AUIPTY
     C+ , AUDTYP
     C+ , AUCPYO
     C+ , AUFMTO
     C+ , AUDTLB
     C+ , AUPROJ
     C+ , AUEXIN
     C+ , AUUSTS
     C+ )
     C+ values
     C+ (
     C+   :AUMBNM
     C+ , :AUMBTP
     C+ , :AUSRCF
     C+ , :AUMBTX
     C+ , ' '
     C+ , :AUIPTY
     C+ , :AUDTYP
     C+ , :AUCPYO
     C+ , :AUFMTO
     C+ , :AUDTLB
     C+ , :AUPROJ
     C+ , :AUEXIN
     C+ , :AUUSTS
     C+ )
     C/end-exec
     C                   IF        SQLCODE <> 0
      *
      ** Error writing to table.
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'DLV0008'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     InsertRecordE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateFlds - Validate input                                *
      *                                                               *
      *****************************************************************
     C     ValidateFlds  BEGSR
      *
      ** If member type = 'DATA' then check if the file has an Action File.
     C                   IF        DFMBTP = 'DATA'
     C                   EXSR      ChkActF
     C                   ENDIF
      *
      ** Validation for
      **  - Member name
      **  - Member type
      **  - Source file
      **  - insert only
     C                   IF        ValidationMode = 'I'
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateMBNM
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateMBTP
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateSRCF
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateKey
     C                   ENDIF
      *
      ** Validation for Description.
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateMBTX
      *
      ** Validation for Priority.
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateIPTY
      *
      ** Validation for Ignore or Process.
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateDTYP
      *
      ** Validation for Copy Option.
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateCPYO
      *
      ** Validation for Before or After.
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateFMTO
      *
      ** Validation for Layer.
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateDTLB
      *
      ** Validation for Object Type.
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidatePROJ
      *
      ** Validation for Extra Information.
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateEXIN
      *
      ** Validation for Status.
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateUSTS
      *
      ** Perform additional cross validation.
      ** Cross check member type against object type.
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      XChkType
      *
      ** Cross check layer against source file.
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      XChkLayer
      *
     C     ValidateFldsE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  LoadSubfile - Display all records to subfile                 *
      *                                                               *
      *****************************************************************
     C     LoadSubfile   BEGSR
      *
      ** Clear subfile.
     C                   IF        ErrInd <> 'Y'
     C                             and *IN31 = *OFF
     C                             or *INKE = *ON
     C                   EVAL      *IN26 = *ON
     C                   WRITE     UP000090C0
     C                   EVAL      *IN26 = *OFF
     C                   ENDIF
      *
     C                   IF        *INKE = *ON
     C                   EVAL      DFSRCH = *blanks
     C                   ENDIF
      *
      ** Set on control.
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN23 = *ON
      *
      ** Calculate which page to display.
     C                   EXSR      CalcDisplay
      *
      ** Select which Statement to use.
     C                   EXSR      SelectStmnt
      *
      ** The declaration selects all records that are greater than or equal to
      **  the 'Go to' field; if it is blank all records are selected.
     C                   IF        CurFlg = 'N'
     C/exec SQL
     C+ prepare Statement
     C+   from :SQLStmt
     C/end-exec
      *
     C/exec SQL
     C+ declare DLVCCursor insensitive scroll cursor
     C+   for Statement
     C/end-exec
      *
     C/exec SQL
     C+ open DLVCCursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next from DLVCCursor into :DLVCDS
     C/end-exec
     C                   ELSE
      *
     C                   IF        SrchFl = '1'
     C/exec SQL
     C+ prepare Statement1
     C+   from :SQLStmt
     C/end-exec
      *
     C/exec SQL
     C+ declare DLVC1Cursor insensitive scroll cursor
     C+   for Statement1
     C/end-exec
      *
     C/exec SQL
     C+ open DLVC1Cursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next from DLVC1Cursor into :DLVCDS
     C/end-exec
     C                   ENDIF
     C                   ENDIF
      *
      ** Process if no record on file.
     C                   IF        SQLCODE = 100
      *
     C                   EVAL      DFSRCH = *blanks
     C                   EVAL      Empty = 'Y'
      *
     C                   DOW       *INKC = *OFF
     C                             and *INKI = *OFF
     C                   EXSR      ClearFlds
     C                   EVAL      *IN28 = *ON
      *
      ** Reset search fields if F5 is pressed.
     C                   IF        *INKE = *ON
     C                   EXSR      ClearFlds
     C                   LEAVE
     C                   ENDIF
      *
     C                   WRITE     UP000090F0
     C                   WRITE     UP000090F1
      *
     C                   WRITE     UP000090C1
     C                   EXFMT     UP000090F3
     C                   EVAL      ErrInd = 'N'
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   ENDDO
      *
     C                   ELSE
      *
      ** Load records to subfile
     C                   IF        ErrInd <> 'Y'
     C                             and *IN31 = *OFF
     C                             or *INKE = *ON
      *
     C     1             DO        13            RdCtr
      *
     C                   EXSR      MoveData
     C                   WRITE     UP000090S0
     C                   EXSR      ClearRecs
     C                   EXSR      ClearFlds
      *
     C                   IF        CurFlg = 'N'
     C/exec SQL
     C+ fetch next from DLVCCursor into :DLVCDS
     C/end-exec
     C                   ELSE
      *
     C                   IF        SrchFl = '1'
     C/exec SQL
     C+ fetch next from DLVC1Cursor into :DLVCDS
     C/end-exec
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
      *
     C                   IF        *IN21 = *ON
     C                             and StrRec = 1
     C                   EVAL      ZAMSGF = 'GBSTUSRMSG'
     C                   EVAL      ZAMSID = 'IL24020'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN21 = *OFF
     C                   ENDIF
      *
      ** Load screen.
     C                   WRITE     UP000090F0
     C                   WRITE     UP000090F1
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UP000090C1
     C                   ENDIF
      *
     C                   EXFMT     UP000090C0
      *
      ** Reset values.
     C                   IF        *INKE = *ON
     C                             or *INKI = *ON
     C                   READC     UP000090S0                             29
      *
     C                   DOW       *IN29 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank
      *
     C                   UPDATE    UP000090S0
     C                   READC     UP000090S0                             29
     C                   ENDDO
     C                   ENDIF
      *
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
     C                   ENDIF
      *
     C                   IF        CurFlg = 'N'
     C/exec SQL
     C+ close DLVCCursor
     C/end-exec
     C                   ELSE
      *
     C                   IF        SrchFl = '1'
     C/exec SQL
     C+ close DLVC1Cursor
     C/end-exec
     C                   ENDIF
     C                   ENDIF
      *
     C     LoadSubfileE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  CalcDisplay - Calculate which page to display                *
      *                                                               *
      *****************************************************************
     C     CalcDisplay   BEGSR
      *
      ** Check if rollup or rolldown enabled then calculate the page
      ** to display
     C                   IF        *IN20 = *OFF
     C                             and *IN21 = *OFF
     C                   EVAL      PageNo = 1
     C                   EVAL      StrRec = 1
     C                   EVAL      EndRec = TotPag
     C                   ENDIF
      *
     C                   IF        *IN20 = *ON
     C                   EVAL      PageNo = PageNo + 1
     C                   ENDIF
      *
     C                   IF        *IN21 = *ON
     C                             and PageNo > 1
     C                   EVAL      PageNo = PageNo - 1
     C                   ENDIF
      *
     C                   EVAL      StrRec = (PageNo - 1) * TotPag + 1
     C                   EVAL      EndRec = PageNo * TotPag
      *
     C     CalcDisplayE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SelectStmnt - Select which Statement to use                  *
      *                                                               *
      *****************************************************************
     C     SelectStmnt   BEGSR
      *
     C                   EVAL      WFMBNM = DFSRCH
      *
     C                   SELECT
      *
      ** Display records from file if no selection done.
     C                   WHEN      DFSRCH = *blanks
      *
     C                   EVAL      CurFlg = 'N'
     C                   EVAL      SrchFl = '0'
     C                   EVAL      SQLStmt = 'select AUMBNM, AUMBTP, AUMBTX,   +
     C                             AUCAPR, AUIPTY, AUDTYP, AUCPYO, AUFMTO,     +
     C                             AUSRCF, AUDTLB, AUPROJ, AUEXIN, AUUSTS      +
     C                               from (select row_number()                 +
     C                                  over (order by AUMBNM, AUMBTP, AUSRCF) +
     C                                          as row_number, UPDLVCPD.*      +
     C                                  from UPDLVCPD                          +
     C                                  order by AUMBNM, AUMBTP, AUSRCF)      +
     C                                     as DLVCCursor                       +
     C                                  where DLVCCursor.row_number            +
     C                                     between ' +%char(StrRec)+ ' and '   +
     C                                     %char(EndRec)
      *
      ** Check search field, then perform selection from file.
     C                   WHEN      DFSRCH <> *blanks
      *
     C                   EVAL      CurFlg = 'Y'
     C                   EVAL      SrchFl = '1'
      *
     C                   EVAL      SQLStmt = 'select * from (                  +
     C                                        select AUMBNM, AUMBTP, AUMBTX,   +
     C                             AUCAPR, AUIPTY, AUDTYP, AUCPYO, AUFMTO,     +
     C                             AUSRCF, AUDTLB, AUPROJ, AUEXIN, AUUSTS      +
     C                               from (select row_number()                 +
     C                                  over (order by AUMBNM, AUMBTP, AUSRCF) +
     C                                          as row_number, UPDLVCPD.*      +
     C                                  from UPDLVCPD                          +
     C                                  where UPDLVCPD.AUMBNM >= '             +
     C                                     '''' +WFMBNM+ ''''                  +
     C                                 ' order by AUMBNM, AUMBTP, AUSRCF)      +
     C                                                    as QuerySelect       +
     C                                 where QuerySelect.row_number            +
     C                                    between ' +%char(StrRec)+ ' and '    +
     C                                    %char(EndRec)+ ') as DLVC1Cursor '
      *
     C                   ENDSL
      *
     C     SelectStmntE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  MoveDisplay - Move display fields to data file               *
      *                                                               *
      *****************************************************************
     C     MoveDisplay   BEGSR
      *
     C                   EVAL      AUMBNM = DFMBNM
     C                   EVAL      AUMBTP = DFMBTP
     C                   EVAL      AUSRCF = DFSRCF
     C                   EVAL      AUMBTX = DFMBTX
     C                   EVAL      AUIPTY = DFIPTY
     C                   EVAL      AUDTYP = DFDTYP
     C                   EVAL      AUCPYO = DFCPYO
     C                   EVAL      AUFMTO = DFFMTO
     C                   EVAL      AUDTLB = DFDTLB
     C                   EVAL      AUPROJ = DFPROJ
     C                   EVAL      AUEXIN = DFEXIN
     C                   EVAL      AUUSTS = DFUSTS
      *
     C     MoveDisplayE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  MoveData - Move data fields to display file                  *
      *                                                               *
      *****************************************************************
     C     MoveData      BEGSR
      *
     C                   EVAL      DFAORD  = *blank
     C                   EVAL      DFMBNM  = AUMBNM
     C                   EVAL      DFMBTP  = AUMBTP
     C                   EVAL      DFSRCF  = AUSRCF
     C                   EVAL      DFMBTX  = AUMBTX
     C                   EVAL      DFIPTY  = AUIPTY
     C                   EVAL      DFDTYP  = AUDTYP
     C                   EVAL      DFCPYO  = AUCPYO
     C                   EVAL      DFFMTO  = AUFMTO
     C                   EVAL      DFDTLB  = AUDTLB
     C                   EVAL      DFPROJ  = AUPROJ
     C                   EVAL      DFEXIN  = AUEXIN
     C                   EVAL      DFUSTS  = AUUSTS
      *
     C                   EVAL      *IN51 = *OFF
     C                   EVAL      *IN24 = *ON
     C                   IF        DFMBNM <> *blank
     C                   EVAL      *IN51 = *ON
     C                   EVAL      *IN24 = *OFF
     C                   ENDIF
      *
     C     MoveDataE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateMBNM - Member name.                                  *
      *                                                               *
      *****************************************************************
     C     ValidateMBNM  BEGSR
      *
      ** Must not be blank.
     C                   IF        DFMBNM = *blanks
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN70  = *ON
     C                   ENDIF
      *
     C     ValidateMBNME ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateMBTP - Member type.                                  *
      *                                                               *
      *****************************************************************
     C     ValidateMBTP  BEGSR
      *
      ** Must not be blank.
     C                   IF        DFMBTP = *blanks
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ELSE
      ** If the member type begins with 'X' check it is correct.
     C                   IF        %SUBST(DFMBTP:1:1) = 'X'
     C                   IF        %SUBST(DFMBTP:1:2) <> 'XX'
     C                             and %SUBST(DFMBTP:1:2) <> 'XR'
     C                             and %SUBST(DFMBTP:1:2) <> 'XM'
      * Type must be 'XX', XR or XM plus original  type for redudant items.
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'DLV0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   GOTO      MBNMTag
     C                   ELSE
     C                   EVAL      MbrType = %SUBST(DFMBTP:3:8)
     C                   ENDIF
     C                   ELSE
     C                   EVAL      MbrType = DFMBTP
     C                   ENDIF
      *
     C                   EXSR      ChkMbrType
     C                   IF        MbrType = '*NOTF'
      * Member type not valid.
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'DLV0002'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C     MBNMTag       TAG
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN71  = *ON
     C                   ENDIF
      *
     C     ValidateMBTPE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateSRCF - Source file.                                  *
      *                                                               *
      *****************************************************************
     C     ValidateSRCF  BEGSR
      *
      ** Must not be blank unless EXE, DATA or MSGF.
     C                   IF        DFSRCF = *blanks
     C                             and DFMBTP <> 'EXE'
     C                             and DFMBTP <> 'DATA'
     C                             and DFMBTP <> 'MSGF'
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN72 = *ON
     C                   ENDIF
      *
     C     ValidateSRCFE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateKey - Member, type and source file.                  *
      *                                                               *
      *****************************************************************
     C     ValidateKey   BEGSR
      *
     C/exec SQL
     C+ select count(*) into :RecCount
     C+ from UPDLVCPD
     C+ where
     C+     AUMBNM = :DFMBNM
     C+ and AUMBTP = :DFMBTP
     C+ and AUSRCF = :DFSRCF
     C/end-exec
      *
      ** Key already exists.
     C                   IF        RecCount > 0
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0003'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN70 = *ON
     C                   EVAL      *IN71 = *ON
     C                   EVAL      *IN72 = *ON
     C                   ENDIF
      *
     C     ValidateKeyE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateMBTX - Description.                                  *
      *                                                               *
      *****************************************************************
     C     ValidateMBTX  BEGSR
      *
      ** Must not be blank.
     C                   IF        DFMBTX = *blanks
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN73  = *ON
     C                   ENDIF
      *
     C     ValidateMBTXE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateIPTY - Priority.                                     *
      *                                                               *
      *****************************************************************
     C     ValidateIPTY  BEGSR
      *
      ** There is no validation for this field.
      *
     C     ValidateIPTYE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateDTYP - Ignore or Process.                            *
      *                                                               *
      *****************************************************************
     C     ValidateDTYP  BEGSR
      *
      ** Must be 'O' or 'I'.
     C                   IF        DFDTYP <> 'O'
     C                             and DFDTYP <> 'I'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'UPG0002'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
      ** If member type is DATA then check if the file has an Action File; if it
      **  does then value must be I.
     C                   IF        DFMBTP = 'DATA'
     C                   IF        ActionFile = 'Y'
     C                             and DFDTYP <> 'I'
     C                             or ActionFile = 'N'
     C                             and DFDTYP <> 'O'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'DLV0003'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN75  = *ON
     C                   ENDIF
      *
     C     ValidateDTYPE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateCPYO - Copy option.                                  *
      *                                                               *
      *****************************************************************
     C     ValidateCPYO  BEGSR
      *
      ** Must be '*ADD' or '*REPLACE' but only for type 'DATA' where there
      **  is no Action File.
     C                   IF        DFCPYO <> *blank
     C                             and DFMBTP <> 'DATA'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'DLV0004'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   GOTO      CPYOTag
     C                   ENDIF
      *
     C                   IF        DFMBTP = 'DATA'
     C                   IF        ActionFile = 'Y'
     C                   IF        DFCPYO <> *blank
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'DLV0005'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ELSE
     C                   IF        DFCPYO <> '*ADD'
     C                             and DFCPYO <> '*REPLACE'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'DLV0006'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     CPYOTag       TAG
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN76  = *ON
     C                   ENDIF
      *
     C     ValidateCPYOE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateFMTO - Before / after or special copy.               *
      *                                                               *
      *****************************************************************
     C     ValidateFMTO  BEGSR
      *
      ** Must not be blank unless it is a specific member type.
     C                   IF        DFFMTO <> *blank
     C                             and DFMBTP <> 'EXE'
     C                             and DFMBTP <> 'PF'
     C                             and DFMBTP <> 'SQLTBL'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'DLV0007'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   GOTO      FMTOTag
     C                   ENDIF
      *
      ** Must be one of a set values if member type = 'EXE'.
     C                   IF        DFMBTP = 'EXE'
     C                             and DFFMTO <> '*BEFORE'
     C                             and DFFMTO <> '*AFTER'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'UPG0003'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   GOTO      FMTOTag
     C                   ENDIF
      *
      ** For physical files a value can be specified but blank is allowed.
     C                   IF        (DFMBTP = 'PF'
     C                             or DFMBTP = 'SQLTBL')
     C                             and
     C                             (DFFMTO <> 'S*MAP*DROP'
     C                             and DFFMTO <> 'S*NOCHK'
     C                             and DFFMTO <> 'S*NOCOPY'
     C                             and DFFMTO <> *blank)
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DLV0009'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   IF        DFDTYP = 'I'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DLV0009'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     FMTOTag       TAG
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN77  = *ON
     C                   ENDIF
      *
     C     ValidateFMTOE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateDTLB - Layer.                                        *
      *                                                               *
      *****************************************************************
     C     ValidateDTLB  BEGSR
      *
      ** Must be '*ZONE' or '*GLOBAL'.
     C                   IF        DFDTLB <> '*ZONE'
     C                             and DFDTLB <> '*GLOBAL'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0012'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN78  = *ON
     C                   ENDIF
      *
     C     ValidateDTLBE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidatePROJ - Object type.                                  *
      *                                                               *
      *****************************************************************
     C     ValidatePROJ  BEGSR
      *
      ** Must not be blank.
     C                   IF        DFPROJ = *blanks
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EVAL      ObjType = DFPROJ
     C                   EXSR      ChkObjType
     C                   IF        ObjType = '*NOTF'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'DLV0002'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN79  = *ON
     C                   ENDIF
      *
     C     ValidatePROJE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateEXIN - Extra information.                            *
      *                                                               *
      *****************************************************************
     C     ValidateEXIN  BEGSR
      *
      ** Must be blank unless type is 'EXE'.
     C                   IF        DFEXIN <> *blank
     C                             and DFMBTP <> 'EXE'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'DLV0010'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   GOTO      EXINTag
     C                   ENDIF
      *
      ** Check that the parameters are correctly formatted.
     C                   IF        DFMBTP = 'EXE'
     C                             and DFEXIN <> *blank
     C                   EVAL      Command = 'CALL PGM(' + DFMBNM
     C                   EVAL      Command = %TRIMR(Command) + ') PARM(' +
     C                             DFEXIN
     C                   EVAL      Command = %TRIMR(Command) + ')'
     C                   CALL      'ZAC000002'
     C                   PARM                    Command
     C                   PARM                    ReturnCode
     C                   IF        ReturnCode = 'E'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'UPG0004'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C     EXINTag       TAG
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN80  = *ON
     C                   ENDIF
      *
     C     ValidateEXINE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateUSTS - Status.                                       *
      *                                                               *
      *****************************************************************
     C     ValidateUSTS  BEGSR
      *
      ** Status must be blank, 'C' or 'F'.
     C                   IF        DFUSTS <> *blank
     C                             and DFUSTS <> 'C'
     C                             and DFUSTS <> 'F'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'MNU0002'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN81  = *ON
     C                   ENDIF
      *
     C     ValidateUSTSE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ChkActF - Check if a file has an Action file.                *
      *                                                               *
      *****************************************************************
     C     ChkActF       BEGSR
      *
     C/exec SQL
     C+ select count(*) into :RecCount
     C+ from UPACTFPD
     C+ where
     C+    AABONF = :DFMBNM
     C/end-exec
      *
     C                   IF        RecCount <> 0
     C                   EVAL      ActionFile = 'Y'
     C                   ELSE
     C                   EVAL      ActionFile = 'N'
     C                   ENDIF
      *
     C     ChkActFE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ChkMbrType - Check the member type is valid.                 *
      *                                                               *
      *****************************************************************
     C     ChkMbrType    BEGSR
      *
     C                   IF        MbrType <> 'C_INCLUDE'
     C                             and MbrType <> 'CLE'
     C                             and MbrType <> 'CLLE'
     C                             and MbrType <> 'CLP'
     C                             and MbrType <> 'CMD'
     C                             and %SUBST(MbrType:1:4) <> 'COPY'
     C                             and MbrType <> 'DSPF'
     C                             and MbrType <> 'DTAARA'
     C                             and MbrType <> 'DTAQ'
     C                             and MbrType <> 'ICFF'
     C                             and MbrType <> 'LF'
     C                             and MbrType <> 'PF'
     C                             and MbrType <> 'PGM'
     C                             and MbrType <> 'PNLGRP'
     C                             and MbrType <> 'PRTF'
     C                             and MbrType <> 'RPG'
     C                             and MbrType <> 'RPGLE'
     C                             and MbrType <> 'SQLDTAARA'
     C                             and MbrType <> 'SQLPROC'
     C                             and MbrType <> 'SQLRPG'
     C                             and MbrType <> 'SQLRPGLE'
     C                             and MbrType <> 'SQLTBL'
     C                             and MbrType <> 'SQLVIEW'
     C                             and MbrType <> 'SRVPGM'
     C                             and MbrType <> 'TAPF'
     C                             and MbrType <> 'TBL'
     C                             and MbrType <> 'VLDL'
     C                             and MbrType <> 'EXE'
     C                             and MbrType <> 'DATA'
     C                             and MbrType <> 'MSGF'
     C                             and MbrType <> 'SQLDTAAR'
     C                             or MbrType = 'SQLDTAAR'
     C                             and %SUBST(DFMBTP:1:1) <> 'X'
     C                   EVAL      MbrType = '*NOTF'
     C                   ENDIF
      *
     C     ChkMbrTypeE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  CheckObjType - Check the object type is valid.               *
      *                                                               *
      *****************************************************************
     C     ChkObjType    BEGSR
      *
     C                   IF        ObjType <> '*CMD'
     C                             and ObjType <> '*DTAARA'
     C                             and ObjType <> '*DTAQ'
     C                             and ObjType <> '*FILE'
     C                             and ObjType <> '*MODULE'
     C                             and ObjType <> '*PGM'
     C                             and ObjType <> '*PNLGRP'
     C                             and ObjType <> '*SRC'
     C                             and ObjType <> '*SRVPGM'
     C                             and ObjType <> '*TBL'
     C                             and ObjType <> '*VLDL'
     C                   EVAL      ObjType = '*NOTF'
     C                   ENDIF
      *
     C     ChkObjTypeE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  XChkType - Cross check member type against object type.      *
      *                                                               *
      *****************************************************************
     C     XChkType      BEGSR
      *
     C                   IF        DFMBTP = 'DATA'
     C                             and DFPROJ <> '*FILE'
     C                   EVAL      ErrFlg = 'Y'
     C                   GOTO      XChkTypeTag
     C                   ENDIF
     C                   IF        DFMBTP = 'MSGF'
     C                             and DFPROJ <> '*MSGF'
     C                   EVAL      ErrFlg = 'Y'
     C                   GOTO      XChkTypeTag
     C                   ENDIF
     C                   IF        (%SUBST(DFSRCF:3:3) = 'CPY'
     C                             or %SUBST(DFSRCF:1:2) = 'QW'
     C                             or %SUBST(DFSRCF:1:2) = 'ZS'
     C                             or %SUBST(DFSRCF:1:2) = 'SK'
     C                             or %SUBST(DFSRCF:1:3) = 'STD')
     C                             and DFPROJ <> '*SRC'
     C                   EVAL      ErrFlg = 'Y'
     C                   GOTO      XChkTypeTag
     C                   ENDIF
      *
     C                   IF        %SUBST(DFMBTP:1:1) = 'X'
     C                   EVAL      ObjType = '*' + %SUBST(DFMBTP:3:8)
     C                   EVAL      MbrType = %SUBST(DFMBTP:3:8)
     C                   ELSE
     C                   EVAL      ObjType = '*' + DFMBTP
     C                   EVAL      MbrType = DFMBTP
     C                   ENDIF
     C                   IF        ObjType <> DFPROJ
     C                   IF        (MbrType = 'DSPF'
     C                             or MbrType = 'PRTF'
     C                             or MbrType = 'PRTF'
     C                             or MbrType = 'PF'
     C                             or MbrType = 'LF'
     C                             or MbrType = 'SQLTBL'
     C                             or MbrType = 'SQLVIEW'
     C                             or MbrType = 'ICFF'
     C                             or MbrType = 'TAPF')
     C                             and DFPROJ <> '*FILE'
     C                             or
     C                             (MbrType = 'RPGLE'
     C                             or MbrType = 'CLLE'
     C                             or MbrType = 'CLE'
     C                             or MbrType = 'SQLRPGLE')
     C                             and (DFPROJ <> '*PGM'
     C                             and DFPROJ <> '*MODULE')
     C                             or
     C                             (MbrType = 'RPG'
     C                             or MbrType = 'CLP'
     C                             or MbrType = 'SQLRPG')
     C                             and DFPROJ <> '*PGM'
     C                   EVAL      ErrFlg = 'Y'
     C                   ENDIF
     C                   ENDIF
     C
     C     XChkTypeTag   TAG
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'DLV0012'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN79  = *ON
     C                   ENDIF
      *
     C     XChkTypeE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  XChkLayer - Cross check layer against source file.           *
      *                                                               *
      *****************************************************************
     C     XChkLayer     BEGSR
      *
     C                   IF        DFMBTP <> 'DATA'
     C                             and DFMBTP <> 'MSGF'
     C                             and DFMBTP <> 'EXE'
     C                   IF        %SUBST(DFSRCF:9:1) = 'G'
     C                             and DFDTLB <> '*GLOBAL'
     C                             or %SUBST(DFSRCF:9:1) <> 'G'
     C                             and DFDTLB <> '*ZONE'
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'UTMSGF'
     C                   EVAL      ZAMSID = 'DLV0013'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN78  = *ON
     C                   ENDIF
      *
     C     XChkLayerE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ResetInds - Reset error indicators                            *
      *                                                               *
      *****************************************************************
     C     ResetInds     BEGSR
      *
      ** Set off Error Indicators
     C                   MOVEA     ErIOff        *IN(70)
     C                   EVAL      *IN28 = *OFF
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      *IN44 = *OFF
      *
     C     ResetIndsE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Clear - Clears the error messages on the subfile              *
      *                                                               *
      *****************************************************************
     C     Clear         BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DFPGMQ        ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
     C     ClearE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ClearRecs - Clear records                                    *
      *                                                               *
      *****************************************************************
     C     ClearRecs     BEGSR
      *
     C                   EVAL      AUMBNM = *blanks
     C                   EVAL      AUMBTP = *blanks
     C                   EVAL      AUSRCF = *blanks
     C                   EVAL      AUMBTX = *blanks
     C                   EVAL      AUCAPR = *blanks
     C                   EVAL      AUIPTY = 0
     C                   EVAL      AUDTYP = *blanks
     C                   EVAL      AUCPYO = *blanks
     C                   EVAL      AUFMTO = *blanks
     C                   EVAL      AUDTLB = *blanks
     C                   EVAL      AUPROJ = *blanks
     C                   EVAL      AUEXIN = *blanks
     C                   EVAL      AUUSTS = *blanks
      *
     C     ClearRecsE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ClearFlds - Clear display file fields                        *
      *                                                               *
      *****************************************************************
     C     ClearFlds     BEGSR
      *
     C                   EVAL      DFMBNM = *blanks
     C                   EVAL      DFMBTP = *blanks
     C                   EVAL      DFSRCF = *blanks
     C                   EVAL      DFMBTX = *blanks
     C                   EVAL      DFIPTY = 0
     C                   EVAL      DFDTYP = *blanks
     C                   EVAL      DFCPYO = *blanks
     C                   EVAL      DFFMTO = *blanks
     C                   EVAL      DFDTLB = *blanks
     C                   EVAL      DFPROJ = *blanks
     C                   EVAL      DFEXIN = *blanks
     C                   EVAL      DFUSTS = *blanks
      *
     C     ClearFldsE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASNMS - Send message to program's message queue             *
      *                                                               *
      *****************************************************************
      *
     C     ZASNMS        BEGSR
      *
     C                   IF        ZAPGMQ = *BLANK
     C                   EVAL      ZAPGMQ = DFPGMQ
     C                   END
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *
     C     ZAEXIT        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Get the current time.
     C                   CALL      'CBTIME'
     C                   PARM                    DayNoa
     C                   PARM                    STime
     C                   PARM                    DFmt
     C                   MOVE      DayNoa        CurrDt
      *
      ** Convert date to DDMMYY format.
     C                   CALL      'ZDATE2'
     C                   PARM                    CurrDt
     C                   PARM                    DFmt
     C                   PARM                    WQ0003
     C                   PARM      *blanks       ZDate
      *
     C                   EVAL      DFDATE = ZDate
      *
     C                   EVAL      ErrInd = 'N'
     C                   EVAL      ErIOff = '000000000000'
      *
     C     INZSRE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  Exit - Exit program                                          *
      *                                                               *
      *****************************************************************
     C     Exit          BEGSR
      *
     C                   IF        ErrInd <> 'Y'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   EVAL      *INKC = *OFF
     C                   ENDIF
      *
     C     ExitE         ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *blank
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
