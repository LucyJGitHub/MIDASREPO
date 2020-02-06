     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT Validation list data maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000056 - Validation list data maintenance                  *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CUP041   *CREATE   Date 02Jun14               *
      *  Prev Amend No. xxxxxxxx           Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP041 - Restructure of deliverable data files.              *
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
     FUT000056DFCF   E             WORKSTN
     F                                     SFILE(UT000056S0:RdCtr)
      ** Program data structure
     D MyPSDS         SDS
     D DFPGMQ                  1     10
     D DFJOBN                244    253
     D DFDUSR                254    263
      ** Declared Variables
     D WRun            S              1A
     D RdCtr           S             10  0
     D TotRow          S             13  0
     D ValidationMode  S              1A
     D RecCount        S              5  0
     D FoundPos        S              2  0
     D ExistYN         S             10A
     D Member          S             10A
     D Library         S             10A
     D ObjectType      S              7A
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
     D UTVLDDS       E DS                  EXTNAME(UTVLDJW0)
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
     C                   READC     UT000056S0                             29
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
     C                   UPDATE    UT000056S0
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
     C                   UPDATE    UT000056S0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank
      *
     C                   UPDATE    UT000056S0
     C                   READC     UT000056S0                             29
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
     C                   WRITE     UT000056F0
     C                   WRITE     UT000056F5
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UT000056C1
     C                   ENDIF
      *
     C                   EXFMT     UT000056F2
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
     C+ update UTVLDXTD
     C+ set
     C+   VLDEL  = 'Y'
     C+ where
     C+     VLVLDL = :DFVLDL
     C/end-exec
     C                   ELSE
     C/exec SQL
     C+ update UTVLDXTD
     C+ set
     C+   VLDEL  = 'N'
     C+ where
     C+     VLVLDL = :DFVLDL
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
     C                   WRITE     UT000056F0
     C                   WRITE     UT000056F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UT000056C1
     C                   ENDIF
      *
     C                   EXFMT     UT000056F2
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
     C+    :UTVLDDS
     C+ from UTVLDJW0
     C+ where
     C+     VLVLDL = :DFVLDL
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
     C+ update UTVLDBTD set
     C+   VLIDLE = :VLIDLE
     C+ , VLENLE = :VLENLE
     C+ , VLDTLE = :VLDTLE
     C+ , VLIDTX = :VLIDTX
     C+ where
     C+     VLVLDL = :DFVLDL
     C/end-exec
     C                   IF        SQLCODE = 0
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
     C                   WRITE     UT000056F0
     C                   WRITE     UT000056F4
      *
     C                   EXFMT     UT000056F2
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
     C                   WRITE     UT000056F0
     C                   WRITE     UT000056F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UT000056C1
     C                   ENDIF
      *
     C                   EXFMT     UT000056F2
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
     C+ insert into UTVLDBTD
     C+ (
     C+   VLVLDL
     C+ , VLMODE
     C+ , VLIDLE
     C+ , VLENLE
     C+ , VLDTLE
     C+ , VLIDTX
     C+ , VLDEL
     C+ )
     C+ values
     C+ (
     C+   :VLVLDL
     C+ , :VLMODE
     C+ , :VLIDLE
     C+ , :VLENLE
     C+ , :VLDTLE
     C+ , :VLIDTX
     C+ , :VLDEL
     C+ )
     C/end-exec
      *
     C                   IF        SQLCODE = 0
      * Only write extension record if key does not already exist.
     C/exec SQL
     C+ select count(*)
     C+ into
     C+   :RecCount
     C+ from UTVLDXTD
     C+ where
     C+     VLVLDL = :VLVLDL
     C/end-exec
     C                   IF        RecCount = 0
     C/exec SQL
     C+ insert into UTVLDXTD
     C+ (
     C+   VLVLDL
     C+ , VLDEL
     C+ )
     C+ values
     C+ (
     C+   :VLVLDL
     C+ , :VLDEL
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
      **  - Validation list
      **  - insert only
     C                   IF        ValidationMode = 'I'
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateVLDL
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateKey
     C                   ENDIF
      *
      ** Validation for
      **  - ID Data Length
      **  - Encrypt Data Length
      **  - Data Length
      **  - Text for Entry ID
      **  - bespoke only
     C                   IF        DFDMOD = 'Bespoke'
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateIDLE
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateENLE
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateDTLE
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateIDTX
     C                   ENDIF
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
     C                   WRITE     UT000056C0
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
     C+ declare UTVLDCursor insensitive scroll cursor for
     C+ select * from UTVLDJW0
     C+ where VLVLDL  >= :DFSRCH
     C+ order by
     C+   VLVLDL
     C/end-exec
      *
     C/exec SQL
     C+ open UTVLDCursor
     C/end-exec
      *
      ** Get the number of rows of the selected records.
     C/exec SQL
     C+ get diagnostics :TotRow  = db2_number_rows
     C/end-exec
      *
     C/exec SQL
     C+ fetch next from UTVLDCursor into :UTVLDDS
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
     C                   WRITE     UT000056F0
     C                   WRITE     UT000056F1
      *
     C                   WRITE     UT000056C1
     C                   EXFMT     UT000056F3
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
     C                   WRITE     UT000056S0
     C                   EXSR      ClearRecs
     C                   EXSR      ClearFlds
     C/exec SQL
     C+ fetch next from UTVLDCursor into :UTVLDDS
     C/end-exec
     C                   ENDDO
     C                   ENDIF
      *
      ** Load screen.
     C                   WRITE     UT000056F0
     C                   WRITE     UT000056F1
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UT000056C1
     C                   ENDIF
      *
     C                   EXFMT     UT000056C0
      *
      ** Reset values.
     C                   IF        *INKE = *ON
     C                             or *INKI = *ON
     C                   READC     UT000056S0                             29
      *
     C                   DOW       *IN29 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank

     C                   UPDATE    UT000056S0
     C                   READC     UT000056S0                             29
     C                   ENDDO
     C                   ENDIF

     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
     C                   ENDIF
     C/exec SQL
     C+ close UTVLDCursor
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
     C                   EVAL      VLVLDL = DFVLDL
     C                   IF        DFDMOD = 'Core'
     C                   EVAL      VLMODE = 'C'
     C                   ELSE
     C                   EVAL      VLMODE = 'B'
     C                   ENDIF
     C                   EVAL      VLIDLE = DFIDLE
     C                   EVAL      VLENLE = DFENLE
     C                   EVAL      VLDTLE = DFDTLE
     C                   EVAL      VLIDTX = DFIDTX
     C                   IF        DFDDEL = 'No '
     C                   EVAL      VLDEL  = 'N'
     C                   ELSE
     C                   EVAL      VLDEL  = 'Y'
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
     C                   EVAL      DFVLDL = VLVLDL
     C                   EVAL      DFMODE = VLMODE
     C                   IF        VLMODE = 'C'
     C                   EVAL      DFDMOD = 'Core'
     C                   ELSE
     C                   EVAL      DFDMOD = 'Bespoke'
     C                   ENDIF
     C                   EVAL      DFIDLE = VLIDLE
     C                   EVAL      DFENLE = VLENLE
     C                   EVAL      DFDTLE = VLDTLE
     C                   EVAL      DFIDTX = VLIDTX
     C                   EVAL      DFDEL  = VLDEL
     C                   IF        VLDEL = 'Y'
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
      *  ValidateVLDL - Validate Validation List                      *
      *                                                               *
      *****************************************************************
     C     ValidateVLDL  BEGSR
      *
      ** Check that the validation list exists.
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN
     C                   PARM                    DFVLDL
     C                   PARM      '*LIBL'       Library
     C                   PARM      '*VLDL'       ObjectType
     C                   PARM      *blanks       Member
     C                   IF        ExistYN <> 'Exist'
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0009'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
      *
     C     ValidateVLDLE ENDSR
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
     C+ from UTVLDUW0
     C+ where
     C+     VLVLDL = :DFVLDL
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
     C                   ENDIF
      *
     C     ValidateKeyE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateIDLE - Validate ID data length                       *
      *                                                               *
      *****************************************************************
     C     ValidateIDLE  BEGSR
      *
      * Value must be greater than zero.
     C                   IF        DFIDLE = 0
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0015'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN71 = *ON
     C                   ENDIF
      *
     C     ValidateIDLEE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateENLE - Encrypt data length                           *
      *                                                               *
      *****************************************************************
     C     ValidateENLE  BEGSR
      *
      * Value must be greater than zero.
     C                   IF        DFENLE = 0
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
     C     ValidateENLEE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateDTLE - Data length                                   *
      *                                                               *
      *****************************************************************
     C     ValidateDTLE  BEGSR
      *
      * Value must be greater than zero.
     C                   IF        DFDTLE = 0
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0015'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN73 = *ON
     C                   ENDIF
      *
     C     ValidateDTLEE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateIDTX - Text for entry ID                             *
      *                                                               *
      *****************************************************************
     C     ValidateIDTX  BEGSR
      *
      * Text for Entry ID must not be blank.
     C                   IF        DFIDTX = *blank
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN74 = *ON
     C                   ENDIF
      *
     C     ValidateIDTXE ENDSR
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
     C                   EVAL      VLVLDL = *blanks
     C                   EVAL      VLMODE = *blanks
     C                   EVAL      VLIDLE = 0
     C                   EVAL      VLENLE = 0
     C                   EVAL      VLDTLE = 0
     C                   EVAL      VLIDTX = *blanks
     C                   EVAL      VLDEL  = *blanks
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
     C                   EVAL      DFVLDL = *blanks
     C                   EVAL      DFMODE = *blanks
     C                   EVAL      DFDMOD = *blanks
     C                   EVAL      DFIDLE = 0
     C                   EVAL      DFENLE = 0
     C                   EVAL      DFDTLE = 0
     C                   EVAL      DFIDTX = *blanks
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
     C+ delete from UTVLDBTD b
     C+ where exists
     C+ (
     C+ select * from UTVLDXTD x
     C+ where
     C+     b.VLVLDL = x.VLVLDL
     C+ and x.VLDEL  = 'Y'
     C+ )
     C/end-exec
      *
     C/exec SQL
     C+ delete from UTVLDXTD x
     C+ where not exists
     C+ (
     C+ select * from UTVLDUW0 u
     C+ where
     C+     u.VLVLDL = x.VLVLDL
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
