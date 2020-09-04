     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Auto-generated fields maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000103 - Auto-generated fields maintenance                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. CUP041   *CREATE   Date 02Jun14               *
      *  Prev Amend No. xxxxxxxx           Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
     FUP000103DFCF   E             WORKSTN
     F                                     SFILE(UP000103S0:RdCtr)
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
     D Library         S             10A
     D ObjectType      S              7A
     D Member          S             10A
     D MemberOpt       S              8A
     D OFile           S             10A
     D OField01        S             10A
     D OField02        S             10A
     D IReturnValue    S             20A
     D FldHeader       S             35A   INZ('List of Fields')
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
     D Num             C                   '0123456789'
      *
     D                 DS
     D OptCheckA               1      7
     D OptCheckN               1      7  0
      *
     D UPAGFDS       E DS                  EXTNAME(UPAGFJW0)
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
     C                   READC     UP000103S0                             29
     C                   DOW       *IN29 = *OFF
      *
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
     C                   UPDATE    UP000103S0
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
     C                   UPDATE    UP000103S0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank
      *
     C                   UPDATE    UP000103S0
     C                   READC     UP000103S0                             29
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
     C                   WRITE     UP000103F0
     C                   WRITE     UP000103F5
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UP000103C1
     C                   ENDIF
      *
     C                   EXFMT     UP000103F2
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
     C+ update UPAGFXTD
     C+ set
     C+   IDDEL  = 'Y'
     C+ where
     C+     IDTBL  = :DFTBL
     C+ and IDFLD  = :DFFLD
     C/end-exec
     C                   ELSE
     C/exec SQL
     C+ update UPAGFXTD
     C+ set
     C+   IDDEL  = 'N'
     C+ where
     C+     IDTBL  = :DFTBL
     C+ and IDFLD  = :DFFLD
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
     C                   WRITE     UP000103F0
     C                   WRITE     UP000103F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UP000103C1
     C                   ENDIF
      *
     C                   EXFMT     UP000103F2
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
     C+    :UPAGFDS
     C+ from UPAGFJW0
     C+ where
     C+     IDTBL  = :IDTBL
     C+ and IDFLD  = :IDFLD
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
     C+ update UPAGFBTD set
     C+   IDLAYR = :IDLAYR
     C+ , IDPACK = :IDPACK
     C+ , IDMIG  = :IDMIG
     C+ , IDUPG  = :IDUPG
     C+ where
     C+     IDTBL  = :DFTBL
     C+ and IDFLD  = :DFFLD
     C/end-exec
     C                   IF        SQLCODE = 0
      *
     C/exec SQL
     C+ update UPAGFXTD set
     C+   IDPACK = :IDPACK
     C+ , IDMIG  = :IDMIG
     C+ , IDUPG  = :IDUPG
     C+ where
     C+     IDTBL  = :DFTBL
     C+ and IDFLD  = :DFFLD
     C/end-exec
      *
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
     C+ update UPAGFXTD set
     C+   IDPACK = :IDPACK
     C+ , IDMIG  = :IDMIG
     C+ , IDUPG  = :IDUPG
     C+ where
     C+     IDTBL  = :IDTBL
     C+ and IDFLD  = :IDFLD
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
     C                   WRITE     UP000103F0
     C                   WRITE     UP000103F4
      *
     C                   EXFMT     UP000103F2
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
     C                   WRITE     UP000103F0
     C                   WRITE     UP000103F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UP000103C1
     C                   ENDIF
      *
     C                   EXFMT     UP000103F2
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
     C+ insert into UPAGFBTD
     C+ (
     C+   IDTBL
     C+ , IDFLD
     C+ , IDMODE
     C+ , IDLAYR
     C+ , IDPACK
     C+ , IDMIG
     C+ , IDUPG
     C+ , IDDEL
     C+ )
     C+ values
     C+ (
     C+   :IDTBL
     C+ , :IDFLD
     C+ , :IDMODE
     C+ , :IDLAYR
     C+ , :IDPACK
     C+ , :IDMIG
     C+ , :IDUPG
     C+ , :IDDEL
     C+ )
     C/end-exec
      *
     C                   IF        SQLCODE = 0
      * Only write extension record if key does not already exist.
     C/exec SQL
     C+ select count(*)
     C+ into
     C+   :RecCount
     C+ from UPAGFXTD
     C+ where
     C+     IDTBL  = :IDTBL
     C+ and IDFLD  = :IDFLD
     C/end-exec
     C                   IF        RecCount = 0
     C/exec SQL
     C+ insert into UPAGFXTD
     C+ (
     C+   IDTBL
     C+ , IDFLD
     C+ , IDPACK
     C+ , IDMIG
     C+ , IDUPG
     C+ , IDDEL
     C+ )
     C+ values
     C+ (
     C+   :IDTBL
     C+ , :IDFLD
     C+ , :IDPACK
     C+ , :IDMIG
     C+ , :IDUPG
     C+ , :IDDEL
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
      * If record already exists then just update fields.
     C                   ELSE
     C/exec SQL
     C+ update UPAGFXTD
     C+ set
     C+   IDPACK = :IDPACK
     C+ , IDMIG  = :IDMIG
     C+ , IDUPG  = :IDUPG
     C+ where
     C+     IDTBL  = :IDTBL
     C+ and IDFLD  = :IDFLD
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
      **  - Table
      **  - Column
      **  - insert only
     C                   IF        ValidationMode = 'I'
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateTBL
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateFLD
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateKey
     C                   ENDIF
      *
      ** Validation for
      **  - Layer
      **  - bespoke only
     C                   IF        DFDMOD = 'Bespoke'
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateLAYR
     C                   ENDIF
      *
      ** Validation for Package Option
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidatePACK
      *
      ** Validation for Migrate Option
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateMIG
      *
      ** Validation for Upgrade Option
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateUPG
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
     C                   WRITE     UP000103C0
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
     C+ declare UPAGFCursor insensitive scroll cursor for
     C+ select * from UPAGFJW0
     C+ where IDTBL  >= :DFSRCH
     C+ order by
     C+   IDTBL
     C+ , IDFLD
     C/end-exec
      *
     C/exec SQL
     C+ open UPAGFCursor
     C/end-exec
      *
      ** Get the number of rows of the selected records.
     C/exec SQL
     C+ get diagnostics :TotRow  = db2_number_rows
     C/end-exec
      *
     C/exec SQL
     C+ fetch next from UPAGFCursor into :UPAGFDS
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
     C                   WRITE     UP000103F0
     C                   WRITE     UP000103F1
      *
     C                   WRITE     UP000103C1
     C                   EXFMT     UP000103F3
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
     C                   WRITE     UP000103S0
     C                   EXSR      ClearRecs
     C                   EXSR      ClearFlds
     C/exec SQL
     C+ fetch next from UPAGFCursor into :UPAGFDS
     C/end-exec
     C                   ENDDO
     C                   ENDIF
      *
      ** Load screen.
     C                   WRITE     UP000103F0
     C                   WRITE     UP000103F1
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UP000103C1
     C                   ENDIF
      *
     C                   EXFMT     UP000103C0
      *
      ** Reset values.
     C                   IF        *INKE = *ON
     C                             or *INKI = *ON
     C                   READC     UP000103S0                             29
      *
     C                   DOW       *IN29 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank
 
     C                   UPDATE    UP000103S0
     C                   READC     UP000103S0                             29
     C                   ENDDO
     C                   ENDIF
 
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
     C                   ENDIF
     C/exec SQL
     C+ close UPAGFCursor
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
     C                   EVAL      IDTBL  = DFTBL
     C                   EVAL      IDFLD  = DFFLD
     C                   IF        DFDMOD = 'Core'
     C                   EVAL      IDMODE = 'C'
     C                   ELSE
     C                   EVAL      IDMODE = 'B'
     C                   ENDIF
     C                   EVAL      IDLAYR = DFLAYR
     C                   EVAL      IDPACK = DFPACK
     C                   EVAL      IDMIG  = DFMIG
     C                   EVAL      IDUPG  = DFUPG
     C                   IF        DFDDEL = 'No '
     C                   EVAL      IDDEL  = 'N'
     C                   ELSE
     C                   EVAL      IDDEL  = 'Y'
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
     C                   EVAL      DFTBL  = IDTBL
     C                   EVAL      DFFLD  = IDFLD
     C                   EVAL      DFMODE = IDMODE
     C                   IF        IDMODE = 'C'
     C                   EVAL      DFDMOD = 'Core'
     C                   ELSE
     C                   EVAL      DFDMOD = 'Bespoke'
     C                   ENDIF
     C                   EVAL      DFLAYR = IDLAYR
     C                   EVAL      DFPACK = IDPACK
     C                   EVAL      DFMIG  = IDMIG
     C                   EVAL      DFUPG  = IDUPG
     C                   EVAL      DFDEL  = IDDEL
     C                   IF        IDDEL = 'Y'
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
      *  ValidateTBL  - Validate Table                                *
      *                                                               *
      *****************************************************************
     C     ValidateTBL   BEGSR
      *
      ** Check that the table exists.
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN
     C                   PARM                    DFTBL
     C                   PARM      '*LIBL'       Library
     C                   PARM      '*FILE'       ObjectType
     C                   PARM      *blanks       Member
     C                   IF        ExistYN = 'Exist'
     C                   ELSE
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
     C     ValidateTBLE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateFLD - Validate column                                *
      *                                                               *
      *****************************************************************
     C     ValidateFLD   BEGSR
      *
      ** Must exist on the file and must be auto-generated.
     C                   IF        *IN70 = *ON
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0013'
     C                   EXSR      ZASNMS
      *
     C                   ELSE
      ** Create list of available fields.
     C                   EXSR      CrtFldList
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0013'
     C                   EXSR      ZASNMS
      *
     C                   ELSE
      ** Check for '?' processing.
     C                   EVAL      FoundPos = %SCAN('?':DFFLD)
     C                   IF        FoundPos > 0
     C                   CALL      'ZA000000'
     C                   PARM                    FldHeader
     C                   PARM      'UP000103F'   OFile
     C                   PARM      'WHFLDI'      OField01
     C                   PARM      'WHFTXT'      OField02
     C                   PARM                    IReturnValue
     C                   EVAL      DFFLD = IReturnValue
     C                   ELSE
      ** Check that the value is not blank.
     C                   IF        DFFLD = *blank
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0014'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If there is no error at this point then make sure that the field exists
      **  and that it is auto-generated.
     C                   IF        ErrFlg <> 'Y'
     C/exec SQL
     C+ select count(*)
     C+ into
     C+   :RecCount
     C+ from UP000103F
     C+ where
     C+     WHFLDI = :DFFLD
     C+ and WHIDC  = 'Y'
     C/end-exec
     C                   IF        RecCount = 0
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0014'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN71 = *ON
     C                   ENDIF
      *
     C     ValidateFLDE  ENDSR
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
     C+ select count(*)
     C+ into
     C+   :RecCount
     C+ from UPAGFUW0
     C+ where
     C+     IDTBL  = :DFTBL
     C+ and IDFLD  = :DFFLD
     C/end-exec
     C                   IF        RecCount > 0
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0003'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN70 = *ON
     C                   EVAL      *IN71 = *ON
     C                   ENDIF
      *
     C     ValidateKeyE  ENDSR
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
     C                   IF        DFLAYR <> '*ZONE'
     C                             and DFLAYR <> '*GLOBAL'
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0012'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN72 = *ON
     C                   ENDIF
      *
     C     ValidateLAYRE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidatePACK - Validate Packaging Option                     *
      *                                                               *
      *****************************************************************
     C     ValidatePACK  BEGSR
      *
      ** Must be '*RSTMAX', '*RSTALL' or between 1 - 9,999,999.
     C                   EVAL      OptCheckA = DFPACK
     C                   EXSR      ValidateOpt
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN73 = *ON
     C                   ENDIF
      *
     C     ValidatePACKE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateMIG - Validate Migrate Option                        *
      *                                                               *
      *****************************************************************
     C     ValidateMIG   BEGSR
      *
      ** Must be '*RSTMAX', '*RSTALL' or between 1 - 9,999,999.
     C                   EVAL      OptCheckA = DFMIG
     C                   EXSR      ValidateOpt
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN74 = *ON
     C                   ENDIF
      *
     C     ValidateMIGE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateUPG - Validate Upgrade Option                        *
      *                                                               *
      *****************************************************************
     C     ValidateUPG   BEGSR
      *
      ** Must be '*RSTMAX', '*RSTALL' or between 1 - 9,999,999.
     C                   EVAL      OptCheckA = DFUPG
     C                   EXSR      ValidateOpt
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN75 = *ON
     C                   ENDIF
      *
     C     ValidateUPGE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateOpt - Validate generic option field                  *
      *                                                               *
      *****************************************************************
     C     ValidateOpt   BEGSR
      *
      ** Must be '*RSTMAX', '*RSTALL' or between 1 - 9,999,999.
     C                   IF        OptCheckA <> '*RSTMAX'
     C                             and OptCheckA <> '*RSTALL'
     C                   EVAL      FoundPos = %CHECK(Num:OptCheckA)
     C                   IF        FoundPos <> 0
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'AGF0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ELSE
     C                   IF        OptCheckN < 0000001
     C                             or OptCheckN > 9999999
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'AGF0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     ValidateOptE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  CrtFldList - Create list of fields for table                 *
      *                                                               *
      *****************************************************************
     C     CrtFldList    BEGSR
      *
      ** Call program to create DSPFFD outfile.
     C                   CALL      'UTC000004'
     C                   PARM                    DFTBL
     C                   PARM      '*LIBL'       Library
     C                   PARM      'UP000103F'   OFile
     C                   PARM      '*FIRST'      Member
     C                   PARM      '*REPLACE'    MemberOpt
     C                   IF        *INU8 = *ON
     C                   EVAL      ErrFlg = 'Y'
     C                   ENDIF
      *
     C     CrtFldListE   ENDSR
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
     C                   EVAL      IDTBL  = *blanks
     C                   EVAL      IDFLD  = *blanks
     C                   EVAL      IDMODE = *blanks
     C                   EVAL      IDLAYR = *blanks
     C                   EVAL      IDPACK = *blanks
     C                   EVAL      IDMIG  = *blanks
     C                   EVAL      IDUPG  = *blanks
     C                   EVAL      IDDEL  = *blanks
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
     C                   EVAL      DFTBL  = *blanks
     C                   EVAL      DFFLD  = *blanks
     C                   EVAL      DFMODE = *blanks
     C                   EVAL      DFDMOD = *blanks
     C                   EVAL      DFLAYR = *blanks
     C                   EVAL      DFPACK = *blanks
     C                   EVAL      DFMIG  = *blanks
     C                   EVAL      DFUPG  = *blanks
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
     C+ delete from UPAGFBTD b
     C+ where exists
     C+ (
     C+ select * from UPAGFXTD x
     C+ where
     C+     b.IDTBL  = x.IDTBL
     C+ and b.IDFLD  = x.IDFLD
     C+ and x.IDDEL  = 'Y'
     C+ )
     C/end-exec
      *
     C/exec SQL
     C+ delete from UPAGFXTD x
     C+ where not exists
     C+ (
     C+ select * from UPAGFUW0 u
     C+ where
     C+     u.IDTBL  = x.IDTBL
     C+ and u.IDFLD  = x.IDFLD
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
