     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Implementation steps maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation                                       *
      *                                                               *
      *  SM000066 - Implementation steps maintenance                  *
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
     FSM000066DFCF   E             WORKSTN
     F                                     SFILE(SM000066S0:RdCtr)
      ** Program data structure
     D MyPSDS         SDS
     D GFPGMQ                  1     10
     D PSExcpNo               43     46
     D GFJOBN                244    253
     D GFUSER                254    263
      ** Declared Variables
     D WRun            S              1A
     D RdCtr           S             10  0
     D TotRow          S             13  0
     D ValidationMode  S              1A
     D RecCount        S              5  0
     D ArrayNo         S              5  0
     D FoundPos        S              3  0
     D Idx             S              3  0
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
     D ComboA          S             30A   DIM(20)
     D                                     CTDATA
     D                                     PERRCD(1)
      *
     D Combo           DS
     D  SMNUCombo              1     20
     D  TYPECombo             21     30
      *
     D SMIMPDS       E DS                  EXTNAME(SMIMPJW0)
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
     C                   READC     SM000066S0                             29
     C                   DOW       *IN29 = *OFF
      *
      ** Check that the user is authorised to the action.
     C                   IF        GFAORD = 'A'
     C                             or GFAORD = 'D'
     C                             or GFAORD = 'E'
     C                   EVAL      ValidationMode = GFAORD
     C                   ENDIF
      *
      ** If Delete.
     C                   IF        GFAORD = 'D'
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
     C                   IF        GFAORD = 'A'
     C                   EVAL      *IN35 = *OFF
     C                   IF        GFMODE = 'C'
     C                   EVAL      *IN36 = *OFF
     C                   ELSE
     C                   EVAL      *IN36 = *ON
     C                   ENDIF
      ** A logically deleted record can not be amended.
     C                   IF        GFDEL = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0002'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN27 = *ON
      *
     C                   UPDATE    SM000066S0
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
     C                   IF        GFAORD = 'E'
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
     C                   IF        GFAORD <> 'A'
     C                             and GFAORD <> 'D'
     C                             and GFAORD <> 'E'
     C                             and GFAORD <> *blank
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0001'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN27 = *ON
      *
     C                   UPDATE    SM000066S0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      GFAORD = *blank
      *
     C                   UPDATE    SM000066S0
     C                   READC     SM000066S0                             29
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
     C                   WRITE     SM000066F0
     C                   WRITE     SM000066F5
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM000066C1
     C                   ENDIF
      *
     C                   EXFMT     SM000066F2
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
     C                   IF        GFDEL = 'N'
     C/exec SQL
     C+ update SMIMPXTD
     C+ set
     C+   DFDEL  = 'Y'
     C+ where
     C+     DFSMNU = :GFSMNU
     C+ and DFLAYR = :GFLAYR
     C+ and DFNAME = :GFNAME
     C+ and DFTYPE = :GFTYPE
     C/end-exec
     C                   ELSE
     C/exec SQL
     C+ update SMIMPXTD
     C+ set
     C+   DFDEL  = 'N'
     C+ where
     C+     DFSMNU = :GFSMNU
     C+ and DFLAYR = :GFLAYR
     C+ and DFNAME = :GFNAME
     C+ and DFTYPE = :GFTYPE
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
     C                   IF        GFMODE = 'B'
     C                   EVAL      *IN36 = *ON
     C                   ENDIF
      *
     C                   WRITE     SM000066F0
     C                   WRITE     SM000066F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM000066C1
     C                   ENDIF
      *
     C                   EXFMT     SM000066F2
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
     C+    :SMIMPDS
     C+ from SMIMPJW0
     C+ where
     C+     DFSMNU = :GFSMNU
     C+ and DFLAYR = :GFLAYR
     C+ and DFNAME = :GFNAME
     C+ and DFTYPE = :GFTYPE
     C/end-exec
     C                   EXSR      MoveData
     C                   EVAL      GFAORD = 'A'
      *
      ** If F12 is pressed go back to the main screen.
     C                   WHEN      *INKL = *ON
     C                   EVAL      GFAORD = *blank
      *
      ** Validation for Bespoke records.
     C                   WHEN      GFMODE = 'B'
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
     C+ update SMIMPBTD set
     C+   DFSEQN = :DFSEQN
     C+ , DFCMD  = :DFCMD
     C+ , DFSTS  = :DFSTS
     C+ where
     C+     DFSMNU = :GFSMNU
     C+ and DFLAYR = :GFLAYR
     C+ and DFNAME = :GFNAME
     C+ and DFTYPE = :GFTYPE
     C/end-exec
     C                   IF        SQLCODE = 0
     C/exec SQL
     C+ update SMIMPXTD set
     C+   DFSTS  = :GFSTS
     C+ where
     C+     DFSMNU = :GFSMNU
     C+ and DFLAYR = :GFLAYR
     C+ and DFNAME = :GFNAME
     C+ and DFTYPE = :GFTYPE
     C/end-exec
      ** Error if updating extension table.
     C                   IF        SQLCODE <> 0
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0005'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
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
     C                   WHEN      GFMODE = 'C'
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
     C+ update SMIMPXTD set
     C+   DFSTS  = :GFSTS
     C+ where
     C+     DFSMNU = :GFSMNU
     C+ and DFLAYR = :GFLAYR
     C+ and DFNAME = :GFNAME
     C+ and DFTYPE = :GFTYPE
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
     C                   WRITE     SM000066F0
     C                   WRITE     SM000066F4
      *
     C                   EXFMT     SM000066F2
      *
      ** Reset indicators.
     C                   EXSR      ResetInds
      *
      ** If F12 is pressed go back to the main screen.
     C                   IF        *INKL = *ON
     C                   EVAL      GFAORD = *blank
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
     C                   EVAL      GFDMOD = 'Bespoke'
     C                   EVAL      GFDDEL = 'No '
      *
     C                   WRITE     SM000066F0
     C                   WRITE     SM000066F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM000066C1
     C                   ENDIF
      *
     C                   EXFMT     SM000066F2
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
     C+ insert into SMIMPBTD
     C+ (
     C+   DFSMNU
     C+ , DFLAYR
     C+ , DFNAME
     C+ , DFTYPE
     C+ , DFMODE
     C+ , DFSEQN
     C+ , DFCMD
     C+ , DFSTS
     C+ , DFDEL
     C+ )
     C+ values
     C+ (
     C+   :DFSMNU
     C+ , :DFLAYR
     C+ , :DFNAME
     C+ , :DFTYPE
     C+ , :DFMODE
     C+ , :DFSEQN
     C+ , :DFCMD
     C+ , :DFSTS
     C+ , :DFDEL
     C+ )
     C/end-exec
      *
     C                   IF        SQLCODE = 0
      * Only write extension record if key does not already exist.
     C/exec SQL
     C+ select count(*)
     C+ into
     C+   :RecCount
     C+ from SMIMPXTD
     C+ where
     C+     DFSMNU = :DFSMNU
     C+ and DFLAYR = :DFLAYR
     C+ and DFNAME = :DFNAME
     C+ and DFTYPE = :DFTYPE
     C/end-exec
     C                   IF        RecCount = 0
     C/exec SQL
     C+ insert into SMIMPXTD
     C+ (
     C+   DFSMNU
     C+ , DFLAYR
     C+ , DFNAME
     C+ , DFTYPE
     C+ , DFDEL
     C+ )
     C+ values
     C+ (
     C+   :DFSMNU
     C+ , :DFLAYR
     C+ , :DFNAME
     C+ , :DFTYPE
     C+ , :DFDEL
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
     C+ update SMIMPXTD set
     C+   DFSTS  = :GFSTS
     C+ where
     C+     DFSMNU = :GFSMNU
     C+ and DFLAYR = :GFLAYR
     C+ and DFNAME = :GFNAME
     C+ and DFTYPE = :GFTYPE
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
      **  - Menu Sub-task
      **  - Layer
      **  - Name
      **  - Type
      **  - insert only
     C                   IF        ValidationMode = 'I'
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateSMNU
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateLAYR
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateNAME
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateTYPE
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateCombo
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateKey
     C                   ENDIF
      *
      ** Validation for
      **  - Sequence
      **  - Command
      **  - bespoke only
     C                   IF        GFDMOD = 'Bespoke'
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateSEQN
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateCMD
     C                   ENDIF
      *
      ** Validation for Status.
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateSTS
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
     C                   WRITE     SM000066C0
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
     C+ declare SMIMPCursor insensitive scroll cursor for
     C+ select * from SMIMPJW0
     C+ where DFSMNU >= :GFSRCH
     C+ order by
     C+   DFSMNU
     C+ , DFLAYR
     C+ , DFNAME
     C+ , DFTYPE
     C/end-exec
      *
     C/exec SQL
     C+ open SMIMPCursor
     C/end-exec
      *
      ** Get the number of rows of the selected records.
     C/exec SQL
     C+ get diagnostics :TotRow  = db2_number_rows
     C/end-exec
      *
     C/exec SQL
     C+ fetch next from SMIMPCursor into :SMIMPDS
     C/end-exec
      *
      ** Process if no record on file.
     C                   IF        SQLCODE = 100
     C                             and GFSRCH = *blanks
     C                   EVAL      GFSRCH = *blanks
      *
     C                   DOW       *INKC = *OFF
     C                             and *INKI = *OFF
     C                   EXSR      ClearFlds
     C                   EVAL      *IN28 = *ON
      *
     C                   WRITE     SM000066F0
     C                   WRITE     SM000066F1
      *
     C                   WRITE     SM000066C1
     C                   EXFMT     SM000066F3
     C                   EVAL      ErrInd = 'N'
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   ENDDO
      *
     C                   ELSE
     C                   EVAL      GFSRCH = *blanks
      *
      ** Load records to subfile
     C                   IF        ErrInd <> 'Y'
     C                             and *IN31 = *OFF
     C                             or *INKE = *ON
     C                   DOW       TotRow > RdCtr
     C                   EVAL      RdCtr = RdCtr + 1
     C                   EXSR      MoveData
     C                   WRITE     SM000066S0
     C                   EXSR      ClearRecs
     C                   EXSR      ClearFlds
     C/exec SQL
     C+ fetch next from SMIMPCursor into :SMIMPDS
     C/end-exec
     C                   ENDDO
     C                   ENDIF
      *
      ** Load screen.
     C                   WRITE     SM000066F0
     C                   WRITE     SM000066F1
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM000066C1
     C                   ENDIF
      *
     C                   EXFMT     SM000066C0
      *
      ** Reset values.
     C                   IF        *INKE = *ON
     C                             or *INKI = *ON
     C                   READC     SM000066S0                             29
      *
     C                   DOW       *IN29 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      GFAORD = *blank
 
     C                   UPDATE    SM000066S0
     C                   READC     SM000066S0                             29
     C                   ENDDO
     C                   ENDIF
 
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
     C                   ENDIF
     C/exec SQL
     C+ close SMIMPCursor
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
     C                   EVAL      DFSMNU = GFSMNU
     C                   EVAL      DFLAYR = GFLAYR
     C                   EVAL      DFNAME = GFNAME
     C                   EVAL      DFTYPE = GFTYPE
     C                   IF        GFDMOD = 'Core'
     C                   EVAL      DFMODE = 'C'
     C                   ELSE
     C                   EVAL      DFMODE = 'B'
     C                   ENDIF
     C                   EVAL      DFSEQN = GFSEQN
     C                   EVAL      DFCMD  = GFCMD1 + GFCMD2 + GFCMD3
     C                                    + GFCMD4 + GFCMD5 + GFCMD6
     C                   EVAL      DFSTS  = GFSTS
     C                   IF        GFDDEL = 'No '
     C                   EVAL      DFDEL  = 'N'
     C                   ELSE
     C                   EVAL      DFDEL  = 'Y'
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
     C                   EVAL      GFAORD = *blank
     C                   EVAL      GFSMNU = DFSMNU
     C                   EVAL      GFLAYR = DFLAYR
     C                   EVAL      GFNAME = DFNAME
     C                   EVAL      GFTYPE = DFTYPE
     C                   EVAL      GFMODE = DFMODE
     C                   IF        DFMODE = 'C'
     C                   EVAL      GFDMOD = 'Core'
     C                   ELSE
     C                   EVAL      GFDMOD = 'Bespoke'
     C                   ENDIF
     C                   EVAL      GFSEQN = DFSEQN
     C                   EVAL      GFCMD1 = %SUBST(DFCMD:1:50)
     C                   EVAL      GFCMD2 = %SUBST(DFCMD:51:50)
     C                   EVAL      GFCMD3 = %SUBST(DFCMD:101:50)
     C                   EVAL      GFCMD4 = %SUBST(DFCMD:151:50)
     C                   EVAL      GFCMD5 = %SUBST(DFCMD:201:50)
     C                   EVAL      GFCMD6 = %SUBST(DFCMD:251:50)
     C                   EVAL      GFSTS  = DFSTS
     C                   EVAL      GFDEL  = DFDEL
     C                   IF        DFDEL = 'Y'
     C                   EVAL      GFDDEL = 'Yes'
     C                   ELSE
     C                   EVAL      GFDDEL = 'No'
     C                   ENDIF
      *
     C     MoveDataE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateSMNU - Validate menu sub-task                        *
      *                                                               *
      *****************************************************************
     C     ValidateSMNU  BEGSR
      *
      ** This field must not be blank or contain blanks apart from trailing ...
     C                   IF        GFSMNU = *blanks
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'MNU0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   EVAL      ChkFld20 = GFSMNU
     C                   EXSR      ValidateGen01
     C                   ENDIF
      *
      ** ... and the field must exist on the Bridge menu file.
     C                   IF        ErrFlg <> 'Y'
     C/exec SQL
     C+ select count(*)
     C+ into
     C+   :RecCount
     C+ from UPMNUJW0
     C+ where
     C+     MUSUB  = :GFSMNU
     C/end-exec
     C                   IF        RecCount = 0
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'IMP0001'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
      *
     C     ValidateSMNUE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateLAYR - Validate Layer                                *
      *                                                               *
      *****************************************************************
     C     ValidateLAYR  BEGSR
      *
      ** Must be '*ZONE' or '*GLOBAL'.
     C                   IF        GFLAYR <> '*ZONE'
     C                             and GFLAYR <> '*GLOBAL'
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0012'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN71 = *ON
     C                   ENDIF
      *
     C     ValidateLAYRE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateNAME - Validate name                                 *
      *                                                               *
      *****************************************************************
     C     ValidateNAME  BEGSR
      *
      ** This field must not be blank.
     C                   IF        GFNAME = *blanks
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
     C     ValidateNAMEE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateTYPE - Validate type                                 *
      *                                                               *
      *****************************************************************
     C     ValidateTYPE  BEGSR
      *
      ** This field must not be blank.
     C                   IF        GFTYPE = *blanks
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN73 = *ON
     C                   ENDIF
      *
     C     ValidateTYPEE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateCombo - Certain combinations of sub-menu and type    *
      *                  can be checked.                              *
      *                                                               *
      *****************************************************************
     C     ValidateCombo BEGSR
      *
     C                   EVAL      ArrayNo = %ELEM(ComboA)
     C                   DO        ArrayNo       Idx
     C                   EVAL      Combo = ComboA(Idx)
     C                   IF        GFSMNU = SMNUCombo and GFTYPE <> TYPECombo
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'IMP0004'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN70 = *ON
     C                   EVAL      *IN73 = *ON
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
     C+ from SMIMPUW0
     C+ where
     C+     DFSMNU = :GFSMNU
     C+ and DFLAYR = :GFLAYR
     C+ and DFNAME = :GFNAME
     C+ and DFTYPE = :GFTYPE
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
     C                   EVAL      *IN73 = *ON
     C                   ENDIF
      *
     C     ValidateKeyE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateSEQN - Validate sequence                             *
      *                                                               *
      *****************************************************************
     C     ValidateSEQN  BEGSR
      *
      * Value must be greater than zero.
     C                   IF        GFSEQN = 0
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0015'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN74 = *ON
     C                   ENDIF
      *
     C     ValidateSEQNE ENDSR
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
     C                   EVAL      ImpCommand = GFCMD1 + GFCMD2 + GFCMD3
     C                                        + GFCMD4 + GFCMD5 + GFCMD6
      ** Command must be executable unless value is '*NORUN'.
     C                   IF        ImpCommand = *blanks
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   IF        ImpCommand <> '*NORUN'
     C                   CALL      'ZAC000002'
     C                   PARM                    ImpCommand
     C                   PARM                    ReturnCode
     C                   IF        ReturnCode = 'E'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'IMP0003'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN75 = *ON
     C                   ENDIF
      *
     C     ValidateCMDE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateSTS - Status                                         *
      *                                                               *
      *****************************************************************
     C     ValidateSTS   BEGSR
      *
      ** This field can be anything so there is no validation.
      *
     C     ValidateSTSE  ENDSR
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
     C                   PARM      GFPGMQ        ZAPGMQ
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
     C                   EVAL      DFSMNU = *blanks
     C                   EVAL      DFLAYR = *blanks
     C                   EVAL      DFNAME = *blanks
     C                   EVAL      DFTYPE = *blanks
     C                   EVAL      DFMODE = *blanks
     C                   EVAL      DFSEQN = 0
     C                   EVAL      DFCMD  = *blanks
     C                   EVAL      DFSTS  = *blanks
     C                   EVAL      DFDEL  = *blanks
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
     C                   EVAL      GFSMNU = *blanks
     C                   EVAL      GFLAYR = *blanks
     C                   EVAL      GFNAME = *blanks
     C                   EVAL      GFTYPE = *blanks
     C                   EVAL      GFMODE = *blanks
     C                   EVAL      GFDMOD = *blanks
     C                   EVAL      GFSEQN = 0
     C                   EVAL      GFCMD1 = *blanks
     C                   EVAL      GFCMD2 = *blanks
     C                   EVAL      GFCMD3 = *blanks
     C                   EVAL      GFCMD4 = *blanks
     C                   EVAL      GFCMD5 = *blanks
     C                   EVAL      GFCMD6 = *blanks
     C                   EVAL      GFSTS  = *blanks
     C                   EVAL      GFDEL  = *blanks
     C                   EVAL      GFDDEL = *blanks
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
     C                   EVAL      ZAPGMQ = GFPGMQ
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
 
     C                   EVAL      GFDATE = ZDate
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
     C+ delete from SMIMPBTD b
     C+ where exists
     C+ (
     C+ select * from SMIMPXTD x
     C+ where
     C+     b.DFSMNU = x.DFSMNU
     C+ and b.DFLAYR = x.DFLAYR
     C+ and b.DFNAME = x.DFNAME
     C+ and b.DFTYPE = x.DFTYPE
     C+ and x.DFDEL  = 'Y'
     C+ )
     C/end-exec
      *
     C/exec SQL
     C+ delete from SMIMPXTD x
     C+ where not exists
     C+ (
     C+ select * from SMIMPUW0 u
     C+ where
     C+     u.DFSMNU = x.DFSMNU
     C+ and u.DFLAYR = x.DFLAYR
     C+ and u.DFNAME = x.DFNAME
     C+ and u.DFTYPE = x.DFTYPE
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
** ComboA
ChgPJE              PJE
CreateLibrary       *LIB
AddDirectoryEntry   DIRE
CreateUserProfile   *USRPRF
CreateAuthList      *AUTL
CreateSaveFile      *SAVF
CreateJobQueue      *JOBQ
CreateMessageQueue  *MSGQ
CreateJobDesc       *JOBD
CreateClass         *CLS
CreateSubSysDesc    *SBSD
RmvAutoStartJobEnt  AJE
AddAutoStartJobEnt  AJE
RmvJobQueueEntry    JOBQE
AddJobQueueEntry    JOBQE
RmvRoutingEntry     RTGE
AddRoutingEntry     RTGE
CreateOutputQueue   *OUTQ
RmvWorkStationEnt   WSE
AddWorkStationEnt   WSE
