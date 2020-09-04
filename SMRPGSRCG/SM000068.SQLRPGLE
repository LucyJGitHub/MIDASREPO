     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Upgrade programs maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation                                       *
      *                                                               *
      *  SM000068 - Upgrade programs maintenance                      *
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
     FSM000068DFCF   E             WORKSTN
     F                                     SFILE(SM000068S0:RdCtr)
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
     D Command         S            300A
     D ReturnCode      S              1A
     D Library         S             10A
     D ObjectType      S             10A
     D RtvData         S            180A
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
     D Object          DS
     D  DFMBNM                 1     10
     D                        11     20    INZ('*LIBL')
      *
     D*RtvVar          DS
     D* BytesRtn               1      4B 0
     D* BytesAva               5      8B 0
     D* Obj                    9     18A
     D* ObjLib                19     28A
     D* ObjTyp                29     38A
     D* RtnLib                39     48A
     D* ASP                   49     52B 0
      *
      /COPY QSYSINC/QRPGLESRC,QUSROBJD
      *
     D SMUPGDS       E DS                  EXTNAME(SMUPGJW0)
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
     C                   READC     SM000068S0                             29
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
     C                   UPDATE    SM000068S0
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
     C                   UPDATE    SM000068S0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank
      *
     C                   UPDATE    SM000068S0
     C                   READC     SM000068S0                             29
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
     C                   WRITE     SM000068F0
     C                   WRITE     SM000068F5
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM000068C1
     C                   ENDIF
      *
     C                   EXFMT     SM000068F2
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
     C+ update SMUPGXTD
     C+ set
     C+   AUDEL  = 'Y'
     C+ where
     C+     AUMBNM = :DFMBNM
     C+ and AUPROJ = :DFPROJ
     C/end-exec
     C                   ELSE
     C/exec SQL
     C+ update SMUPGXTD
     C+ set
     C+   AUDEL  = 'N'
     C+ where
     C+     AUMBNM = :DFMBNM
     C+ and AUPROJ = :DFPROJ
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
     C                   WRITE     SM000068F0
     C                   WRITE     SM000068F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM000068C1
     C                   ENDIF
      *
     C                   EXFMT     SM000068F2
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
     C+    :SMUPGDS
     C+ from SMUPGJW0
     C+ where
     C+     AUMBNM = :DFMBNM
     C+ and AUPROJ = :DFPROJ
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
     C+ update SMUPGBTD set
     C+   AUMBTX = :DFMBTX
     C+ , AUIPTY = :DFIPTY
     C+ , AUDTYP = :DFDTYP
     C+ , AUFMTO = :DFFMTO
     C+ , AULAYR = :DFLAYR
     C+ , AUEXIN = :DFEXIN
     C+ , AUUSTS = :DFUSTS
     C+ where
     C+     AUMBNM = :DFMBNM
     C+ and AUPROJ = :DFPROJ
     C/end-exec
      ** Error on updating bespoke table.
     C                   IF        SQLCODE = 0
     C/exec SQL
     C+ update SMUPGXTD set
     C+   AUUSTS = :DFUSTS
     C+ where
     C+     AUMBNM = :DFMBNM
     C+ and AUPROJ = :DFPROJ
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
     C+ update SMUPGXTD set
     C+   AUUSTS = :DFUSTS
     C+ where
     C+     AUMBNM = :DFMBNM
     C+ and AUPROJ = :DFPROJ
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
     C                   WRITE     SM000068F0
     C                   WRITE     SM000068F4
      *
     C                   EXFMT     SM000068F2
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
     C                   WRITE     SM000068F0
     C                   WRITE     SM000068F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM000068C1
     C                   ENDIF
      *
     C                   EXFMT     SM000068F2
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
     C+ insert into SMUPGBTD
     C+ (
     C+   AUMBNM
     C+ , AUPROJ
     C+ , AUMODE
     C+ , AUMBTX
     C+ , AUIPTY
     C+ , AUDTYP
     C+ , AUFMTO
     C+ , AULAYR
     C+ , AUEXIN
     C+ , AUUSTS
     C+ , AUDEL
     C+ )
     C+ values
     C+ (
     C+   :AUMBNM
     C+ , :AUPROJ
     C+ , :AUMODE
     C+ , :AUMBTX
     C+ , :AUIPTY
     C+ , :AUDTYP
     C+ , :AUFMTO
     C+ , :AULAYR
     C+ , :AUEXIN
     C+ , :AUUSTS
     C+ , :AUDEL
     C+ )
     C/end-exec
      *
     C                   IF        SQLCODE = 0
      * Only write extension record if key does not already exist.
     C/exec SQL
     C+ select count(*)
     C+ into
     C+   :RecCount
     C+ from SMUPGXTD
     C+ where
     C+     AUMBNM = :AUMBNM
     C+ and AUPROJ = :AUPROJ
     C/end-exec
     C                   IF        RecCount = 0
     C/exec SQL
     C+ insert into SMUPGXTD
     C+ (
     C+   AUMBNM
     C+ , AUPROJ
     C+ , AUUSTS
     C+ , AUDEL
     C+ )
     C+ values
     C+ (
     C+   :AUMBNM
     C+ , :AUPROJ
     C+ , :AUUSTS
     C+ , :AUDEL
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
     C+ update SMUPGXTD
     C+ set
     C+   AUUSTS = :AUUSTS
     C+ where
     C+     AUMBNM = :AUMBNM
     C+ and AUPROJ = :AUPROJ
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
      **  - Release
      **  - insert only
     C                   IF        ValidationMode = 'I'
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateMBNM
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidatePROJ
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateKey
     C                   ENDIF
      *
      ** Validation for
      **  - Description
      **  - Priority
      **  - To run or not
      **  - Before or After
      **  - Layer
      **  - Parameters
      **  - To run or not
      **  - bespoke only
     C                   IF        DFDMOD = 'Bespoke'
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateMBTX
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateIPTY
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateDTYP
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateFMTO
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateLAYR
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateEXIN
     C                   ENDIF
      *
      ** Validation for Status.
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateUSTS
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
     C                   WRITE     SM000068C0
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
     C+ declare SMUPGCursor insensitive scroll cursor for
     C+ select * from SMUPGJW0
     C+ where AUMBNM >= :DFSRCH
     C+ order by
     C+   AUMBNM
     C+ , AUPROJ
     C/end-exec
      *
     C/exec SQL
     C+ open SMUPGCursor
     C/end-exec
      *
      ** Get the number of rows of the selected records.
     C/exec SQL
     C+ get diagnostics :TotRow  = db2_number_rows
     C/end-exec
      *
     C/exec SQL
     C+ fetch next from SMUPGCursor into :SMUPGDS
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
     C                   WRITE     SM000068F0
     C                   WRITE     SM000068F1
      *
     C                   WRITE     SM000068C1
     C                   EXFMT     SM000068F3
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
     C                   WRITE     SM000068S0
     C                   EXSR      ClearRecs
     C                   EXSR      ClearFlds
     C/exec SQL
     C+ fetch next from SMUPGCursor into :SMUPGDS
     C/end-exec
     C                   ENDDO
     C                   ENDIF
      *
      ** Load screen.
     C                   WRITE     SM000068F0
     C                   WRITE     SM000068F1
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM000068C1
     C                   ENDIF
      *
     C                   EXFMT     SM000068C0
      *
      ** Reset values.
     C                   IF        *INKE = *ON
     C                             or *INKI = *ON
     C                   READC     SM000068S0                             29
      *
     C                   DOW       *IN29 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank
 
     C                   UPDATE    SM000068S0
     C                   READC     SM000068S0                             29
     C                   ENDDO
     C                   ENDIF
 
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
     C                   ENDIF
     C/exec SQL
     C+ close SMUPGCursor
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
     C                   EVAL      AUMBNM = DFMBNM
     C                   EVAL      AUPROJ = DFPROJ
     C                   IF        DFDMOD = 'Core'
     C                   EVAL      AUMODE = 'C'
     C                   ELSE
     C                   EVAL      AUMODE = 'B'
     C                   ENDIF
     C                   EVAL      AUMBTX = DFMBTX
     C                   EVAL      AUIPTY = DFIPTY
     C                   EVAL      AUDTYP = DFDTYP
     C                   EVAL      AUFMTO = DFFMTO
     C                   EVAL      AULAYR = DFLAYR
     C                   EVAL      AUEXIN = DFEXIN
     C                   EVAL      AUUSTS = DFUSTS
     C                   IF        DFDDEL = 'No '
     C                   EVAL      AUDEL  = 'N'
     C                   ELSE
     C                   EVAL      AUDEL  = 'Y'
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
     C                   EVAL      DFMBNM = AUMBNM
     C                   EVAL      DFPROJ = AUPROJ
     C                   EVAL      DFMODE = AUMODE
     C                   IF        AUMODE = 'C'
     C                   EVAL      DFDMOD = 'Core'
     C                   ELSE
     C                   EVAL      DFDMOD = 'Bespoke'
     C                   ENDIF
     C                   EVAL      DFMBTX = AUMBTX
     C                   EVAL      DFIPTY = AUIPTY
     C                   EVAL      DFDTYP = AUDTYP
     C                   EVAL      DFFMTO = AUFMTO
     C                   EVAL      DFLAYR = AULAYR
     C                   EVAL      DFEXIN = AUEXIN
     C                   EVAL      DFUSTS = AUUSTS
     C                   EVAL      DFDEL  = AUDEL
     C                   IF        AUDEL = 'Y'
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
      *  ValidateMBNM - Validate object                               *
      *                                                               *
      *****************************************************************
     C     ValidateMBNM  BEGSR
      *
      ** This must not be blank and it must exist.
     C                   IF        DFMBNM = *blanks
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
      *
     C                   ELSE
     C                   EXSR      RtvOBjD
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'UPG0005'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN70 = *ON
     C                   ENDIF
      *
     C     ValidateMBNME ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidatePROJ - Validate Release                              *
      *                                                               *
      *****************************************************************
     C     ValidatePROJ  BEGSR
      *
      ** This must not be blank and the release must exist on SMRLS*
     C                   IF        DFPROJ = *blanks
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
      *
     C                   ELSE
     C/exec SQL
     C+ select count(*)
     C+ into
     C+   :RecCount
     C+ from SMRLSLPD
     C+ where
     C+     RLUPMB = :DFPROJ
     C/end-exec
     C                   IF        RecCount = 0
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'UPG0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN71 = *ON
     C                   ENDIF
      *
     C     ValidatePROJE ENDSR
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
     C+ from SMUPGUW0
     C+ where
     C+     AUMBNM = :DFMBNM
     C+ and AUPROJ = :DFPROJ
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
     C                   ENDIF
      *
     C     ValidateKeyE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateMBTX - Validate Description                          *
      *                                                               *
      *****************************************************************
     C     ValidateMBTX  BEGSR
      *
      ** This must not be blank.
     C                   IF        DFMBTX = *blanks
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
     C     ValidateMBTXE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateIPTY - Validate Priority                             *
      *                                                               *
      *****************************************************************
     C     ValidateIPTY  BEGSR
      *
      ** 0-9 is valid so there is no validation.
      *
     C     ValidateIPTYE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateDTYP - Validate To run or not                        *
      *                                                               *
      *****************************************************************
     C     ValidateDTYP  BEGSR
      *
      ** Must not be blank and can only be 'I' or 'O'.
     C                   IF        DFDTYP = *blanks
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
      *
     C                   ELSE
     C                   IF        DFDTYP <> 'I'
     C                             and DFDTYP <> 'O'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'UPG0002'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN74 = *ON
     C                   ENDIF
      *
     C     ValidateDTYPE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateFMTO - Before or after                               *
      *                                                               *
      *****************************************************************
     C     ValidateFMTO  BEGSR
      *
      ** Must not be blank and can only be '*AFTER' or '*BEFORE'.
     C                   IF        DFFMTO = *blanks
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
      *
     C                   ELSE
     C                   IF        DFFMTO <> '*AFTER'
     C                             and DFFMTO <> '*BEFORE'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'UPG0003'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN75 = *ON
     C                   ENDIF
      *
     C     ValidateFMTOE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateLAYR - Layer                                         *
      *                                                               *
      *****************************************************************
     C     ValidateLAYR  BEGSR
      *
      ** Must not be blank and can only be '*ZONE' or '*GLOBAL'.
     C                   IF        DFLAYR = *blanks
     C                   EVAL      ZAMSGF = 'Y2USRMSG'
     C                   EVAL      ZAMSID = 'Y2U0001'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
      *
     C                   ELSE
     C                   IF        DFLAYR <> '*ZONE'
     C                             and DFLAYR <> '*GLOBAL'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0012'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN76 = *ON
     C                   ENDIF
      *
     C     ValidateLAYRE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateEXIN - Parameters                                    *
      *                                                               *
      *****************************************************************
     C     ValidateEXIN  BEGSR
      *
      ** Parameters are only valid if DFDTYP = 'O'...
     C                   IF        DFEXIN <> *blanks
     C                   IF        DFDTYP <> 'O'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'UPG0004'
     C                   EVAL      ErrFlg = 'Y'
     C                   EXSR      ZASNMS
      ** ... and they must be in the correct format.
     C                   ELSE
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
     C                   ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN77 = *ON
     C                   ENDIF
      *
     C     ValidateEXINE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateUSTS - Status                                        *
      *                                                               *
      *****************************************************************
     C     ValidateUSTS  BEGSR
      *
      ** Must be blank, 'C' or 'F'.
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
     C                   EVAL      *IN78 = *ON
     C                   ENDIF
      *
     C     ValidateUSTSE ENDSR
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
     C                   EVAL      AUMBNM = *blanks
     C                   EVAL      AUPROJ = *blanks
     C                   EVAL      AUMODE = *blanks
     C                   EVAL      AUMBTX = *blanks
     C                   EVAL      AUIPTY = 0
     C                   EVAL      AUDTYP = *blanks
     C                   EVAL      AUFMTO = *blanks
     C                   EVAL      AULAYR = *blanks
     C                   EVAL      AUEXIN = *blanks
     C                   EVAL      AUUSTS = *blanks
     C                   EVAL      AUDEL  = *blanks
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
     C                   EVAL      DFPROJ = *blanks
     C                   EVAL      DFMODE = *blanks
     C                   EVAL      DFDMOD = *blanks
     C                   EVAL      DFMBTX = *blanks
     C                   EVAL      DFIPTY = 0
     C                   EVAL      DFDTYP = *blanks
     C                   EVAL      DFFMTO = *blanks
     C                   EVAL      DFLAYR = *blanks
     C                   EVAL      DFEXIN = *blanks
     C                   EVAL      DFUSTS = *blanks
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
     C+ delete from SMUPGBTD b
     C+ where exists
     C+ (
     C+ select * from SMUPGXTD x
     C+ where
     C+     b.AUMBNM = x.AUMBNM
     C+ and b.AUPROJ = x.AUPROJ
     C+ and x.AUDEL  = 'Y'
     C+ )
     C/end-exec
      *
     C/exec SQL
     C+ delete from SMUPGXTD x
     C+ where not exists
     C+ (
     C+ select * from SMUPGUW0 u
     C+ where
     C+     u.AUMBNM = x.AUMBNM
     C+ and u.AUPROJ = x.AUPROJ
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
      *  RtvObjD - Call IBM API to check if object exists and         *
      *            retrieve text.                                     *
      *                                                               *
      *****************************************************************
     C     RtvObjD       BEGSR
      *
     C                   CALL(e)   'UTRTVOBJD'
     C                   PARM                    DFMBNM
     C                   PARM      '*LIBL'       Library
     C                   PARM      '*PGM'        ObjectType
     C                   PARM                    ReturnCode
     C                   PARM                    RtvData
     C                   IF        ReturnCode <> *blank
     C                   EVAL      ErrFlg = 'Y'
     C                   ELSE
     C                   IF        DFMBTX = *blanks
     C                   EVAL      DFMBTX = %SUBST(RtvData:101:50)
     C                   ENDIF
     C                   ENDIF
      *
     C     RtvObjDE      ENDSR
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
