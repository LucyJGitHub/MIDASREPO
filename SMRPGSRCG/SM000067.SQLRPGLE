     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Object initialisation maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation                                       *
      *                                                               *
      *  SM000067 - Object initialisation maintenance                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CUP042   *CREATE   Date 24Nov14               *
      *  Prev Amend No. xxxxxxxx           Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - Restructure of deliverable data files.              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *    Subfile control          20 - 29                           *
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
      *    General                  60 - 69                           *
      *    Individual validation    70 - 89                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index.                                            *
      *                                                               *
      *  AddRecord - Process the insert screen                        *
      *  GetRecord - Load the selected record to second screen        *
      *  DeleteRecord - Delete selected record                        *
      *  AmendRecord - Amend selected record                          *
      *  EnquireRecord - Enquire selected record                      *
      *  InsertRecord - Process inserted record                       *
      *  ValidateFlds - Validate input                                *
      *  AddRecProc - Additional processing for a record              *
      *  LoadSubfile - Display all records to subfile                 *
      *  MoveDisplay - Move display fields to data file               *
      *  MoveData - Move data fields to display file                  *
      *  Validatexxxx - Individual field validation                   *
      *  ResetInds - Reset error indicators                           *
      *  Clear  - Clear the error messages on the subfile             *
      *  ClearRecs - Clear records                                    *
      *  ClearFlds - Clear display file fields                        *
      *  ZASNMS - Send message to program's message queue             *
      *  *INZSR - Initial processing                                  *
      *  NonDisplay - Set on indicators to not display fields         *
      *  Exit - Exit program                                          *
      *  DeletePhyRec - Delete bespoke records that are logically     *
      *                 deleted                                       *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Display File
     FSM000067DFCF   E             WORKSTN
     F                                     SFILE(SM000067S0:RdCtr)
      ** Program data structure
     D MyPSDS         SDS
     D DFPGMQ                  1     10
     D PSExcpNo               43     46
     D DFJOBN                244    253
     D DFUSER                254    263
      ** Declared Variables
     D WRun            S              1A
     D RdCtr           S             10  0
     D TotRow          S             13  0
     D ValidationMode  S              1A
     D RecCount        S              5  0
     D FoundPos        S              3  0
     D ChkFld20        S             20A
     D ImpCommand      S            300A
     D ReturnCode      S              1A
     D Library         S             10A
     D Member          S             10A
     D ExistYN         S             10A
      ** ZASNMS Variables
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10
     D ZAMSDA          S            132
     D ZAMSTP          S              7
      ** Error Indicators
     D ErIOff          S             15
     D ErrInd          S              1
     D ErrFlg          S              1
      ** CBTIME Parameters
     D DayNoa          S              5
     D STime           S              6
     D DFmt            S              1
      ** ZDATE2 Parameters
     D CurrDt          S              5  0
     D WQ0003          S              6  0
     D ZDate           S              7
      *
     D SMINZDS       E DS                  EXTNAME(SMINZJW0)
      *
     C/exec SQL
     C+ set option
     C+ commit = *CHG
     C/end-exec
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
      ** Execute insert screen when F9 is pressed.
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
     C                   ROLBK
     C                   EXSR      InsertRecord
     C                   ENDDO
     C                   COMMIT
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
     C                   READC     SM000067S0                             29
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
     C                   ROLBK
     C                   EXSR      DeleteRecord
     C                   ENDDO
     C                   COMMIT
      *
     C                   ENDIF
      *
      ** If Amend.
     C                   IF        DFAORD = 'A'
     C                   EVAL      *IN35 = *OFF
     C                   IF        DFMODE = 'C'
     C                   EVAL      *IN36 = *OFF
     C                   ELSE
     C                   EVAL      *IN36 = *ON
     C                   ENDIF
      ** A logically deleted record can not be amended.
     C                   IF        DFDEL = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0002'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN27 = *ON
      *
     C                   UPDATE    SM000067S0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   EXSR      AmendRecord
      *
     C                   DOW       ErrInd = 'Y'
     C                             and *INKL = *OFF
     C                             or *INKE = *ON
     C                   ROLBK
     C                   EXSR      AmendRecord
     C                   ENDDO
     C                   COMMIT
     C                   ENDIF
      *
      ** If Enquire.
     C                   IF        DFAORD = 'E'
     C                   EXSR      EnquireRecord
      *
     C                   DOW       (ErrInd = 'Y'
     C                             and *INKL = *OFF)
     C                             or *INKE = *ON
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
     C                   UPDATE    SM000067S0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank
      *
     C                   UPDATE    SM000067S0
     C                   READC     SM000067S0                             29
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
     C                   WRITE     SM000067F0
     C                   WRITE     SM000067F5
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM000067C1
     C                   ENDIF
      *
     C                   EXFMT     SM000067F2
      *
      ** Reset values.
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
      *
      ** If F10 is pressed update Logically Deleted to opposite value.
     C                   IF        *INKJ = *ON
     C                   EXSR      AddRecProc
     C                   IF        ERRIND <> 'Y'
     C                   IF        DFDEL = 'N'
     C/exec SQL
     C+ update SMINZXTD
     C+ set
     C+   IFDEL  = 'Y'
     C+ where
     C+     IFOBJ  = :DFOBJ
     C+ and IFTYPE = :DFTYPE
     C+ and IFSEQ  = :DFSEQ
     C/end-exec
     C                   ELSE
     C/exec SQL
     C+ update SMINZXTD
     C+ set
     C+   IFDEL  = 'N'
     C+ where
     C+     IFOBJ  = :DFOBJ
     C+ and IFTYPE = :DFTYPE
     C+ and IFSEQ  = :DFSEQ
     C/end-exec
     C                   ENDIF
     C                   IF        SQLCODE <> 0
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0005'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
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
      ** Set up display for Amend screen.
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN44 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
      *
      ** Set indicators on or off depending upon requirements.
     C                   EVAL      *IN37 = *ON
      *
     C                   IF        DFMODE = 'B'
     C                   EVAL      *IN36 = *ON
     C                   ENDIF
      *
     C                   WRITE     SM000067F0
     C                   WRITE     SM000067F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM000067C1
     C                   ENDIF
      *
     C                   EXFMT     SM000067F2
      *
      ** Reset Values.
     C                   EXSR      CLEAR
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
      *
     C                   SELECT
      *
      ** If F5 is pressed then refresh.
     C                   WHEN      *INKE = *ON
     C/exec SQL
     C+ select * into
     C+    :SMINZDS
     C+ from SMINZJW0
     C+ where
     C+     IFOBJ  = :DFOBJ
     C+ and IFTYPE = :DFTYPE
     C+ and IFSEQ  = :DFSEQ
     C/end-exec
     C                   EXSR      MoveData
     C                   EVAL      DFAORD = 'A'
      *
      ** If F12 is pressed go back to the main screen.
     C                   WHEN      *INKL = *ON
     C                   EVAL      DFAORD = *blank
      *
      ** Validation for Bespoke records.
     C                   WHEN      DFMODE = 'B'
     C                   EXSR      ValidateFlds
     C                   IF        ErrInd <> 'Y'
      ** Perform additional processing for record.
     C                   EXSR      AddRecProc
     C                   ENDIF
      *
     C                   IF        ErrInd <> 'Y'
      ** If there are no errors then update tables.
     C                   EXSR      MoveDisplay
      *
     C/exec SQL
     C+ update SMINZBTD set
     C+   IFCMD  = :IFCMD
     C+ where
     C+     IFOBJ  = :DFOBJ
     C+ and IFTYPE = :DFTYPE
     C+ and IFSEQ  = :DFSEQ
     C/end-exec
      ** Error on updating bespoke table.
     C                   IF        SQLCODE = 0
     C/exec SQL
     C+ update SMINZXTD set
     C+   IFCMD  = :IFCMD
     C+ where
     C+     IFOBJ  = :DFOBJ
     C+ and IFTYPE = :DFTYPE
     C+ and IFSEQ  = :DFSEQ
     C/end-exec
      ** Error if updating extension table.
     C                   IF        SQLCODE <> 0
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0005'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ELSE
      ** Error if updating bespoke table.
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0004'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validation For Core records.
     C                   WHEN      DFMODE = 'C'
     C                   EXSR      ValidateFlds
     C                   IF        ErrInd <> 'Y'
      ** Perform additional processing for record.
     C                   EXSR      AddRecProc
     C                   ENDIF
      *
     C                   IF        ErrInd <> 'Y'
      ** If there are no errors then update tables.
     C                   EXSR      MoveDisplay
     C/exec SQL
     C+ update SMINZXTD set
     C+   IFCMD = :IFCMD
     C+ where
     C+     IFOBJ  = :DFOBJ
     C+ and IFTYPE = :DFTYPE
     C+ and IFSEQ  = :DFSEQ
     C/end-exec
     C                   IF        SQLCODE <> 0
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0005'
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
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN44 = *ON
      *
     C                   WRITE     SM000067F0
     C                   WRITE     SM000067F4
      *
     C                   EXFMT     SM000067F2
      *
      ** Reset indicators.
     C                   EXSR      ResetInds
      *
      ** If F12 is pressed go back to the main screen.
     C                   IF        *INKL = *ON
     C                   EVAL      DFAORD = *blank
     C                   ENDIF
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
      ** Set up Display for Insert screen.
     C                   EVAL      *IN30 = *OFF
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN37 = *ON
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      *IN44 = *ON
     C                   EVAL      DFDMOD = 'Bespoke'
     C                   EVAL      DFDDEL = 'No '
      *
     C                   WRITE     SM000067F0
     C                   WRITE     SM000067F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM000067C1
     C                   ENDIF
      *
     C                   EXFMT     SM000067F2
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
      ** Perform additional processing for record.
     C                   EXSR      AddRecProc
     C                   ENDIF
      *
     C                   IF        ErrInd <> 'Y'
      ** Insert the record if there is no error.
     C                   EXSR      MoveDisplay
      *
     C/exec SQL
     C+ insert into SMINZBTD
     C+ (
     C+   IFOBJ
     C+ , IFTYPE
     C+ , IFSEQ
     C+ , IFMODE
     C+ , IFCMD
     C+ , IFDEL
     C+ )
     C+ values
     C+ (
     C+   :IFOBJ
     C+ , :IFTYPE
     C+ , :IFSEQ
     C+ , :IFMODE
     C+ , :IFCMD
     C+ , :IFDEL
     C+ )
     C/end-exec
      *
     C                   IF        SQLCODE = 0
      * Only write extension record if key does not already exist.
     C/exec SQL
     C+ select count(*)
     C+ into
     C+   :RecCount
     C+ from SMINZXTD
     C+ where
     C+     IFOBJ  = :IFOBJ
     C+ and IFTYPE = :IFTYPE
     C+ and IFSEQ  = :IFSEQ
     C/end-exec
     C                   IF        RecCount = 0
     C/exec SQL
     C+ insert into SMINZXTD
     C+ (
     C+   IFOBJ
     C+ , IFTYPE
     C+ , IFSEQ
     C+ , IFCMD
     C+ , IFDEL
     C+ )
     C+ values
     C+ (
     C+   :IFOBJ
     C+ , :IFTYPE
     C+ , :IFSEQ
     C+ , :IFCMD
     C+ , :IFDEL
     C+ )
     C/end-exec
      *
      ** Error writing to Extension table.
     C                   IF        SQLCODE <> 0
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0005'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ELSE
     C/exec SQL
     C+ update SMINZXTD
     C+ set
     C+   IFCMD  = :IFCMD
     C+ where
     C+     IFOBJ  = :IFOBJ
     C+ and IFTYPE = :IFTYPE
     C+ and IFSEQ  = :IFSEQ
     C/end-exec
     C                   IF        SQLCODE <> 0
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0005'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      ** Error writing to Bespoke table.
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0004'
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
      ** Validation for
      **  - Object
      **  - Type
      **  - Sequence
      **  - insert only
     C                   IF        ValidationMode = 'I'
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateOBJ
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateTYPE
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateSEQ
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateCombo
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateKey
     C                   ENDIF
      *
      ** Validation for Command.
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateCMD
      *
     C     ValidateFldsE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  AddRecProc - Additional processing for a record              *
      *                                                               *
      *****************************************************************
     C     AddRecProc    BEGSR
      *
     C     AddRecProcE   ENDSR
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
     C                   WRITE     SM000067C0
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      RdCtr = 0
     C                   ENDIF
      *
      ** Set on control.
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN23 = *ON
      *
      ** The declaration selects all records that are greater than or equal to
      **  the 'Go to' field; if it is blank all records are selected.
     C/exec SQL
     C+ declare SMINZCursor insensitive scroll cursor for
     C+ select * from SMINZJW0
     C+ where IFOBJ  >= :DFSRCH
     C+ order by
     C+   IFOBJ
     C+ , IFTYPE
     C+ , IFSEQ
     C/end-exec
      *
     C/exec SQL
     C+ open SMINZCursor
     C/end-exec
      *
      ** Get the number of rows of the selected records.
     C/exec SQL
     C+ get diagnostics :TotRow  = db2_number_rows
     C/end-exec
      *
     C/exec SQL
     C+ fetch next from SMINZCursor into :SMINZDS
     C/end-exec
      *
      ** Process if no record on file.
     C                   IF        SQLCODE = 100
     C                             and DFSRCH = *blanks
     C                   EVAL      DFSRCH = *blanks
      *
     C                   DOW       *INKC = *OFF
     C                             and *INKI = *OFF
     C                   EXSR      ClearFlds
     C                   EVAL      *IN28 = *ON
      *
     C                   WRITE     SM000067F0
     C                   WRITE     SM000067F1
      *
     C                   WRITE     SM000067C1
     C                   EXFMT     SM000067F3
     C                   EVAL      ErrInd = 'N'
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   ENDDO
      *
     C                   ELSE
     C                   EVAL      DFSRCH = *blanks
      *
      ** Load records to subfile
     C                   IF        ErrInd <> 'Y'
     C                             and *IN31 = *OFF
     C                             or *INKE = *ON
     C                   DOW       TotRow > RdCtr
     C                   EVAL      RdCtr = RdCtr + 1
     C                   EXSR      MoveData
     C                   WRITE     SM000067S0
     C                   EXSR      ClearRecs
     C                   EXSR      ClearFlds
     C/exec SQL
     C+ fetch next from SMINZCursor into :SMINZDS
     C/end-exec
     C                   ENDDO
     C                   ENDIF
      *
      ** Load screen.
     C                   WRITE     SM000067F0
     C                   WRITE     SM000067F1
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM000067C1
     C                   ENDIF
      *
     C                   EXFMT     SM000067C0
      *
      ** Reset values.
     C                   IF        *INKE = *ON
     C                             or *INKI = *ON
     C                   READC     SM000067S0                             29
      *
     C                   DOW       *IN29 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank
 
     C                   UPDATE    SM000067S0
     C                   READC     SM000067S0                             29
     C                   ENDDO
     C                   ENDIF
 
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
     C                   ENDIF
     C/exec SQL
     C+ close SMINZCursor
     C/end-exec
      *
     C     LoadSubfileE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  MoveDisplay - Move display fields to data file               *
      *                                                               *
      *****************************************************************
     C     MoveDisplay   BEGSR
      *
     C                   EVAL      IFOBJ  = DFOBJ
     C                   EVAL      IFTYPE = DFTYPE
     C                   EVAL      IFSEQ  = DFSEQ
     C                   IF        DFDMOD = 'Core'
     C                   EVAL      IFMODE = 'C'
     C                   ELSE
     C                   EVAL      IFMODE = 'B'
     C                   ENDIF
     C                   EVAL      IFCMD  = DFCMD1 + DFCMD2
     C                   IF        DFDDEL = 'No '
     C                   EVAL      IFDEL  = 'N'
     C                   ELSE
     C                   EVAL      IFDEL  = 'Y'
     C                   ENDIF
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
     C                   EVAL      DFAORD = *blank
     C                   EVAL      DFOBJ  = IFOBJ
     C                   EVAL      DFTYPE = IFTYPE
     C                   EVAL      DFSEQ  = IFSEQ
     C                   EVAL      DFMODE = IFMODE
     C                   IF        IFMODE = 'C'
     C                   EVAL      DFDMOD = 'Core'
     C                   ELSE
     C                   EVAL      DFDMOD = 'Bespoke'
     C                   ENDIF
     C                   EVAL      DFCMD1 = %SUBST(IFCMD:1:40)
     C                   EVAL      DFCMD2 = %SUBST(IFCMD:41:40)
     C                   EVAL      DFDEL  = IFDEL
     C                   IF        IFDEL = 'Y'
     C                   EVAL      DFDDEL = 'Yes'
     C                   ELSE
     C                   EVAL      DFDDEL = 'No'
     C                   ENDIF
      *
     C     MoveDataE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateOBJ  - Validate object                               *
      *                                                               *
      *****************************************************************
     C     ValidateOBJ   BEGSR
      *
      ** This must not be blank.
     C                   IF        DFOBJ  = *blanks
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
      *
     C     ValidateOBJE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateTYPE - Validate Type                                 *
      *                                                               *
      *****************************************************************
     C     ValidateTYPE  BEGSR
      *
      ** This must not be blank.
     C                   IF        DFTYPE = *blanks
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN71 = *ON
     C                   ENDIF
      *
     C     ValidateTYPEE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateSEQ  - Validate sequence                             *
      *                                                               *
      *****************************************************************
     C     ValidateSEQ   BEGSR
      *
      ** This must not equal 0.
     C                   IF        DFSEQ  = 0
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0015'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN72 = *ON
     C                   ENDIF
      *
     C     ValidateSEQE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateCombo - The combination of object and type must      *
      *                  exist.                                       *
      *                                                               *
      *****************************************************************
     C     ValidateCombo BEGSR
      *
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN
     C                   PARM                    DFOBJ
     C                   PARM      '*LIBL'       Library
     C                   PARM                    DFTYPE
     C                   PARM      *blanks       Member
     C                   IF        ExistYN <> 'Exist'
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0016'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN70 = *ON
     C                   EVAL      *IN71 = *ON
     C                   ENDIF
      *
     C     ValidateComboEENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateKey - Validate the key                               *
      *                                                               *
      *****************************************************************
     C     ValidateKey   BEGSR
      *
     C/exec SQL
     C+ select count(*) into :RecCount
     C+ from SMINZUW0
     C+ where
     C+     IFOBJ  = :DFOBJ
     C+ and IFTYPE = :DFTYPE
     C+ and IFSEQ  = :DFSEQ
     C/end-exec
     C                   IF        RecCount > 0
      ** Record already exists.
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
      *  ValidateCMD - Validate command                               *
      *                                                               *
      *****************************************************************
     C     ValidateCMD   BEGSR
      *
     C                   EVAL      PSExcpNo = *blank
     C                   EVAL      ImpCommand = DFCMD1 + DFCMD2
      ** Command must be executable unless value is '*NORUN'.
     C                   IF        ImpCommand = *blanks
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   CALL      'ZAC000002'
     C                   PARM                    ImpCommand
     C                   PARM                    ReturnCode
     C                   IF        ReturnCode = 'E'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'INZ0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN73 = *ON
     C                   ENDIF
      *
     C     ValidateCMDE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateGen01 - Check field for blanks                       *
      *                                                               *
      *****************************************************************
     C     ValidateGen01 BEGSR
      *
      ** Check string for position of first blank.
     C                   EVAL      FoundPos = %SCAN(' ':ChkFld20)
      ** If the first character is blank then this is an error.
     C                   IF        FoundPos = 1
     C                   EVAL      ErrFlg = 'Y'
     C                   ELSE
      ** Ignore if there are no blanks.
     C                   IF        FoundPos <> 0
     C                   EVAL      FoundPos = %CHECK(' ':ChkFld20:FoundPos)
     C                   IF        FoundPos <> 0
     C                   EVAL      ErrFlg = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'MNU0001'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C     ValidateGen01EENDSR
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
     C                   EVAL      *INU7 = *OFF
     C                   EVAL      *INU8 = *OFF
      *
     C     ResetIndsE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Clear - Clear the error messages on the subfile               *
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
     C                   EVAL      IFOBJ  = *blanks
     C                   EVAL      IFTYPE = *blanks
     C                   EVAL      IFSEQ  = 0
     C                   EVAL      IFMODE = *blanks
     C                   EVAL      IFCMD  = *blanks
     C                   EVAL      IFDEL  = *blanks
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
     C                   EVAL      DFOBJ  = *blanks
     C                   EVAL      DFTYPE = *blanks
     C                   EVAL      DFSEQ  = 0
     C                   EVAL      DFMODE = *blanks
     C                   EVAL      DFDMOD = *blanks
     C                   EVAL      DFCMD1 = *blanks
     C                   EVAL      DFCMD2 = *blanks
     C                   EVAL      DFDEL  = *blanks
     C                   EVAL      DFDDEL = *blanks
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
      *  *INZSR - Initial processing                                  *
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
 
     C                   EVAL      DFDATE = ZDate
      *
      ** Perform checks as to whether fields are displayed or not.
     C                   EXSR      NonDisplay
      *
     C                   EVAL      RdCtr = 0
     C                   EVAL      ErrInd = 'N'
     C                   EVAL      ErIOff = '000000000000000'
      *
     C     INZSRE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  NonDisplay - Set on indicators to not display fields         *
      *                                                               *
      *****************************************************************
      *
     C     NonDisplay    BEGSR
      *
     C     NonDisplayE   ENDSR
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
     C                   EXSR      DeletePhyRec
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
      *  DeletePhyRec - Delete bespoke records that are logically     *
      *                 deleted                                       *
      *                                                               *
      *****************************************************************
     C     DeletePhyRec  BEGSR
      *
     C/exec SQL
     C+ delete from SMINZBTD b
     C+ where exists
     C+ (
     C+ select * from SMINZXTD x
     C+ where
     C+     b.IFOBJ  = x.IFOBJ
     C+ and b.IFTYPE = x.IFTYPE
     C+ and b.IFSEQ  = x.IFSEQ
     C+ and x.IFDEL  = 'Y'
     C+ )
     C/end-exec
      *
     C/exec SQL
     C+ delete from SMINZXTD x
     C+ where not exists
     C+ (
     C+ select * from SMINZUW0 u
     C+ where
     C+     u.IFOBJ  = x.IFOBJ
     C+ and u.IFTYPE = x.IFTYPE
     C+ and u.IFSEQ  = x.IFSEQ
     C+ )
     C/end-exec
      *
     C                   COMMIT
      *
     C     DeletePhyRecE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
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
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
