     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM OTB Migr components maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SM8000 - Midas SM OTM Migration components maintenance       *
      *                                                               *
      *  Function: This program is used for the maintenance of        *
      *            One Touch Bridge migration components              *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD061596           Date 18Jul23               *
      *  Prev Amend No. CUP046 *CREATE     Date 18Jul22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061596 - Add field for mandatory components                *
      *  CUP046 - One Touch Bridge Automation Changes - Version Upg   *
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
     FSM8000GF  CF   E             WORKSTN
     F                                     SFILE(SM8000S0:RdCtr)
      ** Program data structure
     D MyPSDS         SDS
     D DFPGMQ                  1     10
     D DFJOBN                244    253
     D DFDUSR                254    263
      ** Declared Variables

     D DDS             DS
     D DDSEQN                  1      5  0
     D DDSEQA                  1      5

     D X_PARM          S            100A
     D X_MODE          S              1A
     D Match           S              1A
     D WRun            S              1A
     D RdCtr           S             10  0
     D pos             S              3  0
     D TotRow          S             13  0
     D ValidationMode  S              1A
     D RecCount        S              5  0
     D ExistYN         S             10A
     D Library         S             10A
     D ObjectType      S              7A
     D Member          S             10A
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
     D SMOTCDS       E DS                  EXTNAME(SMOTCJW0)
      *
     C/exec SQL
     C+ set option
     C+ commit = *NONE
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
      ** As program is called from UTMENU, commitment is not started                       MD061596
     C**********         ROLBK                                                             MD061596
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
     C                   READC     SM8000S0                               29
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
      ** deletion is not allowed for core
     C                   IF        DFMODE = 'Core'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0022'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN27 = *ON
     C                   UPDATE    SM8000S0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   ENDIF

     C                   EXSR      DeleteRecord

     C                   DOW       (*INKJ = *OFF
     C                             and *INKL = *OFF)
     C                             or ErrInd = 'Y'
      ** As program is called from UTMENU, commitment is not started                       MD061596
     C**********         ROLBK                                                             MD061596
     C                   EXSR      DeleteRecord
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** If Amend.
     C                   IF        DFAORD = 'A'
     C                   EVAL      *IN35 = *OFF
     C                   IF        DFMODE = 'Core   '
     C                   EVAL      *IN36 = *OFF
     C                   ELSE
     C                   EVAL      *IN36 = *ON
     C                   ENDIF
     C                   EXSR      AmendRecord
      *
     C                   DOW       ErrInd = 'Y'
     C                             and *INKL = *OFF
     C                             or *INKE = *ON
      ** As program is called from UTMENU, commitment is not started                       MD061596
     C**********         ROLBK                                                             MD061596
     C                   EXSR      AmendRecord
     C                   ENDDO
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
     C                   UPDATE    SM8000S0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank
      *
     C                   UPDATE    SM8000S0
     C                   READC     SM8000S0                               29
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
     C                   WRITE     SM8000F0
     C                   WRITE     SM8000F5
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM8000C1
     C                   ENDIF
      *
     C                   EXFMT     SM8000F2
      *
      ** Reset values.
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'

      ** If F10 is pressed update Logically Deleted to opposite value.
     C                   IF        *INKJ = *ON
     C/exec SQL
     C+ delete SMOTCXTD
     C+ where OTMSEQ = :DFSEQ
     C/end-exec
     C                   IF        SQLCODE <> 0
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0005'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

     C/exec SQL
     C+ delete SMOTCBTD
     C+ where OTMSEQ = :DFSEQ
     C/end-exec
     C                   IF        SQLCODE <> 0
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0005'
     C                   EVAL      ErrInd = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF

     C                   ENDIF

     C     DeleteRecordE ENDSR

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
     C                   IF        DFMODE = 'Bespoke'
     C                   EVAL      *IN36 = *ON
     C                   ENDIF
      *
     C                   WRITE     SM8000F0
     C                   WRITE     SM8000F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM8000C1
     C                   ENDIF
      *
     C                   EXFMT     SM8000F2
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
     C+    :SMOTCDS
     C+ from SMOTCJW0
     C+ where
     C+     OTMCMP  = :DFCMP and OTMSEQ = :DFSEQ
     C/end-exec
     C                   EXSR      MoveData
     C                   EVAL      DFAORD = 'A'
      *
      ** If F12 is pressed go back to the main screen.
     C                   WHEN      *INKL = *ON
     C                   EVAL      DFAORD = *blank
      *
      ** Validation for Bespoke records.
     C                   WHEN      DFMODE = 'Bespoke'
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
     C+ update SMOTCBTD set
     C+   OTMDES = :DDDES
     C+ , OTMPAR = :DDPAR
     C+ , OTMPGM = :DDPGM
     C+ , OTMRUN = :DDRUN
     C+ , OTMBYP = :DDBYP
     C+ , OTMLYR = :DDLYR
     C+ where
     C+     OTMCMP  = :DFCMP and OTMSEQ = :DFSEQ
     C/end-exec
     C                   IF        SQLCODE = 0
      *
     C/exec SQL
     C+ update SMOTCXTD set
     C+   OTMRUN = :DDRUN
     C+ , OTMBYP = :DDBYP
     C+ where
     C+     OTMCMP  = :DFCMP and OTMSEQ = :DFSEQ
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
     C                   WHEN      DFMODE = 'Core'
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
     C+ update SMOTCXTD
     C+ set
     C+   OTMRUN = :DDRUN
     C+ , OTMBYP = :DDBYP
     C+ where
     C+     OTMCMP = :DDCMP and OTMSEQ = :DDSEQ
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
     C                   WRITE     SM8000F0
     C                   WRITE     SM8000F4
      *
     C                   EXFMT     SM8000F2
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
     C                   EVAL      DDCRBS = 'Bespoke'
     C                   EVAL      DFMODE = 'Bespoke'
      *
     C                   WRITE     SM8000F0
     C                   WRITE     SM8000F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM8000C1
     C                   ENDIF
      *
     C                   EXFMT     SM8000F2
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

     C                   IF        DDCRBS = 'Core'
     C                   EVAL      X_MODE = 'C'
     C                   else
     C                   EVAL      X_MODE = 'B'
     C                   Endif
     C/exec SQL
     C+ insert into SMOTCBTD
     C+ (
     C+   OTMCMP
     C+ , OTMSEQ
     C+ , OTMDES
     C+ , OTMPGM
     C+ , OTMPAR
     C+ , OTMRUN
     C+ , OTMBYP
     C+ , OTMLYR
     C+ , OTMODE
     C+ )
     C+ values
     C+ (
     C+   :DDCMP
     C+ , :DDSEQ
     C+ , :DDDES
     C+ , :DDPGM
     C+ , :DDPAR
     C+ , :DDRUN
     C+ , :DDBYP
     C+ , :DDLYR
     C+ , :X_MODE
     C+ )
     C/end-exec
      *
     C                   IF        SQLCODE = 0
      * Only write extension record if key does not already exist.
     C/exec SQL
     C+ select count(*)
     C+ into
     C+   :RecCount
     C+ from SMOTCXTD
     C+ where
     C+     OTMCMP = :DDCMP and OTMSEQ = :DDSEQ
     C/end-exec
     C                   IF        RecCount = 0
     C                   IF        DDCRBS = 'Core'
     C                   EVAL      X_MODE = 'C'
     C                   else
     C                   EVAL      X_MODE = 'B'
     C                   Endif
     C/exec SQL
     C+ insert into SMOTCXTD
     C+ (
     C+   OTMCMP
     C+ , OTMSEQ
     C+ , OTMRUN
     C+ , OTMBYP
     C+ , OTMODE
     C+ )
     C+ values
     C+ (
     C+   :DDCMP
     C+ , :DDSEQ
     C+ , :DDRUN
     C+ , :DDBYP
     C+ , :X_MODE
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
     C+ update SMOTCXTD
     C+ set
     C+   OTMRUN = :DDRUN
     C+ , OTMBYP = :DDBYP
     C+ where
     C+     OTMCMP = :DDCMP and OTMSEQ = :DDSEQ
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
      **  - Component
      **  - insert only
     C                   IF        ValidationMode = 'I'
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateCOM
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateKey
     C                   ENDIF
      *
      ** Validation for sequence
     C                   IF        DFMODE = 'Bespoke'
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateSEQ
     C                   ENDIF

      ** Validation for
      **  - Layer
      **  - bespoke only
     C*                  IF        DFMODE = 'Bespoke'
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateLAYR
     C*                  ENDIF

      ** Validation for Run Y/N
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateRUN

      ** Validation for Bypass Y/N
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateBYP

      ** Validation for Description
     C                   IF        DFMODE = 'Bespoke'
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateDES
     C                   ENDIF

      ** Validation for Parameters
     C                   IF        DFMODE = 'Bespoke'
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidatePAR
     C                   ENDIF

      ** Validation for Program
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidatePGM

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
     C                   WRITE     SM8000C0
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
     C+ declare SMOTCCursor insensitive scroll cursor for
     C+ select * from SMOTCJW0
     C+ where OTMSEQ  >= :X_SEQ
     C+ order by OTMSEQ
     C/end-exec
      *
     C/exec SQL
     C+ open SMOTCCursor
     C/end-exec
      *
      ** Get the number of rows of the selected records.
     C/exec SQL
     C+ get diagnostics :TotRow  = db2_number_rows
     C/end-exec
      *
     C/exec SQL
     C+ fetch next from SMOTCCursor into :SMOTCDS
     C/end-exec
      *
      ** Process if no record on file.
     C                   IF        SQLCODE = 100
     C                             and X_SEQ = 0
     C                   EVAL      X_SEQ = 0
      *
     C                   DOW       *INKC = *OFF
     C                             and *INKI = *OFF
     C                   EXSR      ClearFlds
     C                   EVAL      *IN28 = *ON
      *
     C                   WRITE     SM8000F0
     C                   WRITE     SM8000F1
      *
     C                   WRITE     SM8000C1
     C                   EXFMT     SM8000F3
     C                   EVAL      ErrInd = 'N'
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   ENDDO
      *
     C                   ELSE
     C                   EVAL      X_SEQ = 0
      *
      ** Load records to subfile
     C                   IF        ErrInd <> 'Y'
     C                             and *IN31 = *OFF
     C                             or *INKE = *ON
     C                   DOW       TotRow > RdCtr
     C                             and SQLCODE = 0
     C                   EXSR      MoveData
      ** write only if matching
     C                   exsr      SR_Match
     C                   If        Match = 'Y'
     C                   EVAL      RdCtr = RdCtr + 1
     C                   WRITE     SM8000S0
     C                   Endif
     C                   EXSR      ClearRecs
     C                   EXSR      ClearFlds
     C/exec SQL
     C+ fetch next from SMOTCCursor into :SMOTCDS
     C/end-exec
     C                   ENDDO
     C                   ENDIF
      *
      ** Load screen.
     C                   WRITE     SM8000F0
     C                   WRITE     SM8000F1
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM8000C1
     C                   ENDIF
      *
     C                   EXFMT     SM8000C0
      *
      ** Reset values.
     C                   IF        *INKE = *ON
     C                             or *INKI = *ON
     C                   READC     SM8000S0                               29
      *
     C                   DOW       *IN29 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank

     C                   UPDATE    SM8000S0
     C                   READC     SM8000S0                               29
     C                   ENDDO
     C                   ENDIF

     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
     C                   ENDIF
     C/exec SQL
     C+ close SMOTCCursor
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

     C                   EVAL      OTMCMP = DDCMP
     C                   EVAL      OTMSEQ = DDSEQ
     C                   EVAL      OTMDES = DDDES
     C                   EVAL      OTMPGM = DDPGM
     C                   EVAL      OTMPAR = DDPAR
     C                   EVAL      OTMRUN = DDRUN
     C                   EVAL      OTMBYP = DDBYP
     C                   EVAL      OTMLYR = DDLYR
     C                   IF        DDCRBS = 'Core'
     C                   EVAL      OTMODE = 'C'
     C                   else
     C                   EVAL      OTMODE = 'B'
     C                   Endif

     C     MoveDisplayE  ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  MoveData - Move data fields to display file                  *
      *                                                               *
      *****************************************************************
     C     MoveData      BEGSR

     C                   EVAL      DFCMP  = OTMCMP
     C*                  EVAL      DFSEQ  = %CHAR(OTMSEQ)
     C                   EVAL      DFSEQ  = %EDITC(OTMSEQ:'X')
     C                   EVAL      DFDES  = OTMDES
     C                   EVAL      DDCMP  = OTMCMP
     C                   EVAL      DDSEQ  = OTMSEQ
     C                   EVAL      DDDES  = OTMDES
     C                   EVAL      DDPGM  = OTMPGM
     C                   EVAL      DDPAR  = OTMPAR
     C                   EVAL      DDRUN  = OTMRUN
     C                   EVAL      DDBYP  = OTMBYP
     C                   EVAL      DDLYR  = OTMLYR
     C                   EVAL      DFLYR  = OTMLYR
     C                   IF        OTMODE = 'C'
     C                   EVAL      DDCRBS = 'Core'
     C                   else
     C                   EVAL      DDCRBS = 'Bespoke'
     C                   Endif
     C                   EVAL      DFMODE = DDCRBS
     C                   EVAL      DDMAND = OTMAND                                          MD061596

     C     MoveDataE     ENDSR

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
     C+ from SMOTCUW0
     C+ where
     C+     OTMCMP = :DDCMP  and OTMSEQ = :DDSEQ
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
     C                   IF        DDLYR <> '*ZONE'
     C                             and DDLYR  <> '*GLOBAL'
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0012'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN73 = *ON
     C                   ENDIF
      *
     C     ValidateLAYRE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateRUN - Validate Run Y/N                               *
      *                                                               *
      *****************************************************************
     C     ValidateRUN   BEGSR

      ** Must be '*YES' or '*NO'.
     C                   IF        DDRUN <> 'N'
     C                             and DDRUN  <> 'Y'
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DRM0015'
     C                   EXSR      ZASNMS
     C                   ENDIF

      ** Cannot be 'N' if component is mandatory                                            MD061596
     C                   IF        DDRUN = 'N'                                              MD061596
     C                             and DDMAND = 'Y'                                         MD061596
     C                   EVAL      ErrFlg = 'Y'                                             MD061596
     C                   EVAL      ZAMSGF = 'SDUSRMSG'                                      MD061596
     C                   EVAL      ZAMSID = 'DDS0025'                                       MD061596
     C                   EXSR      ZASNMS                                                   MD061596
     C                   ENDIF                                                              MD061596
                                                                                            MD061596
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN75 = *ON
     C                   ENDIF

     C     ValidateRUNE  ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateBYP - Validate Bypass Y/N                            *
      *                                                               *
      *****************************************************************
     C     ValidateBYP   BEGSR

      ** Must be '*YES' or '*NO'.
     C                   IF        DDBYP <> 'N'
     C                             and DDBYP  <> 'Y'
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DRM0015'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN74 = *ON
     C                   ENDIF

     C     ValidateBYPE  ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidatePARM - Validate Parameters                           *
      *                                                               *
      *****************************************************************
     C     ValidatePAR   BEGSR


     C     ValidatePARE  ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidatePGM  - Validate Program                              *
      *                                                               *
      *****************************************************************
     C     ValidatePGM   BEGSR

      ** Must not be blank
     C                   IF        DDPGM = *blanks
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0023'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN77 = *ON
     C                   ENDIF

     C     ValidatePGME  ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateDES - Validate Description                           *
      *                                                               *
      *****************************************************************
     C     ValidateDES   BEGSR

      ** Must not be blank
     C                   IF        DDDES = *blanks
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0023'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN76 = *ON
     C                   ENDIF

     C     ValidateDESE  ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateCOM - Validate Component                             *
      *                                                               *
      *****************************************************************
     C     ValidateCOM   BEGSR

      ** Must not be blank
     C                   IF        DDCMP = *blanks
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0023'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN70 = *ON
     C                   ENDIF

     C     ValidateCOME  ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateSEQ - Validate Sequence                              *
      *                                                               *
      *****************************************************************
     C     ValidateSEQ   BEGSR

      ** Must not be 0
     C                   IF        DDSEQ = 0
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0024'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN71 = *ON
     C                   ENDIF

     C                   MOVEL     DDSEQ         DDSEQN
     C                   If        %subst(DDSEQA:4:1) = '0'
     C                             and %subst(DDSEQA:5:1) = '0'
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0024'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN71 = *ON
     C                   ENDIF

     C     ValidateSEQE  ENDSR

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

     C                   EVAL      OTMCMP = *blanks
     C                   EVAL      OTMSEQ = *zero
     C                   EVAL      OTMDES = *blanks
     C                   EVAL      OTMPGM = *blanks
     C                   EVAL      OTMPAR = *blanks
     C                   EVAL      OTMRUN = *blanks
     C                   EVAL      OTMBYP = *blanks
     C                   EVAL      OTMLYR = *blanks
     C                   EVAL      OTMODE = *blanks

     C     ClearRecsE    ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  ClearFlds - Clear display file fields                        *
      *                                                               *
      *****************************************************************
     C     ClearFlds     BEGSR

     C                   EVAL      DDCMP  = *blanks
     C                   EVAL      DDSEQ  = *zero
     C                   EVAL      DDDES  = *blanks
     C                   EVAL      DDPGM  = *blanks
     C                   EVAL      DDPAR  = *blanks
     C                   EVAL      DDRUN  = *blanks
     C                   EVAL      DDBYP  = *blanks
     C                   EVAL      DDLYR  = *blanks
     C                   EVAL      OTMODE = *blanks
     C                   EVAL      DDCRBS = *blanks
     C                   EVAL      DDMAND = *blanks                                         MD061596

     C     ClearFldsE    ENDSR

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
      *  SR_Match - Check if record is to be displayed                *
      *                                                               *
      *****************************************************************

     C     SR_Match      BEGSR

     C                   eval      Match = 'Y'

     C                   if        X_CMP <> *blanks
     C                   eval      pos = %scan(%trim(X_CMP):DFCMP)
     C                   if        pos = 0
     C                   eval      Match = 'N'
     C                   leaveSR
     C                   endif
     C                   endif

     C                   if        X_DES <> *blanks
     C                   eval      pos = %scan(%trim(X_DES):DFDES)
     C                   if        pos = 0
     C                   eval      Match = 'N'
     C                   leaveSR
     C                   endif
     C                   endif

     C                   if        X_LAY <> *blanks and DFLYR <> X_LAY
     C                   eval      Match = 'N'
     C                   leaveSR
     C                   endif

     C                   if        X_MOD <> *blanks and DFMODE <> X_MOD
     C                   eval      Match = 'N'
     C                   leaveSR
     C                   endif

     C                   ENDSR
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
