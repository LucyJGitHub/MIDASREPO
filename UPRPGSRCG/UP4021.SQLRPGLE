     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Driver Program Maintenance Global')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP4021 - ADBU Driver Program Maintenance Global              *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD060709           Date 08Nov22               *
      *  Prev Amend No. CUT017 *CREATE     Date 17Mar20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060709 - Change in LF dynamic selection is omitted         *
      *             File is not deleted when both DTAARA and file     *
      *             have the same name.                               *
      *             Change in PF key is omitted                       *
      *  CUT017 - Adaptive Database Upgrade                           *
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
     FUP4020GF  CF   E             WORKSTN
     F                                     SFILE(UP4020S0:RdCtr)
      ** Program data structure
     D MyPSDS         SDS
     D DFPGMQ                  1     10
     D DFJOBN                244    253
     D DFDUSR                254    263
     D DFJBNO                264    269S 0
     D DFJBNC                264    269
      ** Declared Variables
     D WRun            S              1A
     D RdCtr           S             10  0
     D TotRow          S             13  0
     D TotRow2         S             13  0
     D ValidationMode  S              1A
     D RecCount        S              5  0
     D ExistYN         S             10A
     D Library         S             10A
     D RefLib          S             10A
     D ObjectType      S              7A
     D Member          S             10A
     D sqlStat         S           5000A
     D DFSRCHAL        S             40A
     D Dep_Fil         S             10    DIM(999)
     D DepF            S             10
     D S_DepF          S             10
     D Ix              S              5  0
     D Cnt             S              5  0
     D pos             S              5  0
     D SavInKK         S              1
     D RcdCount        S              5  0
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
     D etc             S              3

     D Command         S             80
     D CommandLen      S             15  5 INZ(80)

     D UPGDRV        E DS                  EXTNAME(UPGDRVTD)
       /EJECT
      *****************************************************************

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
     C                   EXSR      ClearFlds
      *
     C                   EXSR      InsertRecord
     C                   DOW       ErrInd = 'Y'
     C                             and *INKL = *OFF
     C                             or *INKE = *ON
     C                   ROLBK
     C                   EXSR      InsertRecord
     C                   ENDDO
     C**                 COMMIT
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

      ** Read changed record and process it
     C                   READC     UP4020S0                               29
     C                   DOW       *IN29 = *OFF

     C                   IF        DFACTC = 'A'
     C                             or DFACTC = 'E'
     C                   EVAL      ValidationMode = DFACTC
     C                   ENDIF

      ** If Amend.
     C                   IF        DFACTC = 'A'
     C                   EVAL      *IN35 = *OFF
     C                   IF        DFALLC = 'Y'
     C                   EVAL      *IN36 = *ON
     C                   ENDIF
      ** Record can not be amended if change not allowed
     C                   IF        DFALLC = 'N'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'ADB0001'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN27 = *ON
      *
     C                   UPDATE    UP4020S0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   EXSR      AmendRecord
      *
     C                   DOW       ErrInd = 'Y'
     C                             and *INKL = *OFF
     C                             or *INKE = *ON
     C**********         ROLBK
     C                   EXSR      AmendRecord
     C                   ENDDO
     C***                COMMIT
     C                   ENDIF
      *
      ** If Enquire.
     C                   IF        DFACTC = 'E'
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
     C                   IF        DFACTC <> 'A'
     C                             and DFACTC <> 'E'
     C                             and DFACTC <> *blank
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'ADB0003'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN27 = *ON
      *
     C                   UPDATE    UP4020S0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFACTC = *blank
      *
     C                   UPDATE    UP4020S0
     C                   READC     UP4020S0                               29
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
     C                   WRITE     UP4020F0
     C                   WRITE     UP4020F5
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UP4020C1
     C                   ENDIF
      *
     C                   EXFMT     UP4020F2
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
     C+ update UPGDRVTD
     C+ set
     C+   DRALLC  = 'Y'
     C+ where
     C+     DRFILE  = :DFFILE
     C/end-exec
     C                   ELSE
     C/exec SQL
     C+ update UPGDRVTD
     C+ set
     C+   DRALLC  = 'N'
     C+ where
     C+     DRFILE  = :DFFILE
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
     C                   IF        DFALLC = 'N'
     C                   EVAL      *IN36 = *ON
     C                   ENDIF
      *
     C                   WRITE     UP4020F0
     C                   WRITE     UP4020F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UP4020C1
     C                   ENDIF
      *
     C                   EXFMT     UP4020F2
      *
      ** Reset Values.
     C                   EXSR      CLEAR
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
     C                   eval      *INKK = SavInKK
      *
     C                   SELECT
      *
      ** If F5 is pressed then refresh.
     C                   WHEN      *INKE = *ON
     C/exec SQL
     C+ select * into
     C+    :UPGDRV
     C+ from UPGDRVTD
     C+ where
     C+     DRFILE = :DFFILE
     C/end-exec
     C                   EXSR      MoveData
     C                   EVAL      DFACTC = 'A'
      *
      ** If F12 is pressed go back to the main screen.
     C                   WHEN      *INKL = *ON
     C                   EVAL      DFACTC = *blank
      *
      *
      ** Validation For Core records.
     C                   WHEN      DFALLC = 'Y'
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
     C+ update UPGDRVTD set
     C+   DRACTN = :DRACTN
     C+ where
     C+     DRFILE  = :DFFILE
     C+ and DRLIB   = :DFLIBR                                                               MD060709
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
     C                   WRITE     UP4020F0
     C                   WRITE     UP4020F4
      *
      * show affected LF
     C                   eval      DFNAR1 = 'Current System dependent ' +
     C                             'files:'
     C                   exsr      SR_DepC
     C                   eval      DFNAR1 = 'Current System dependent ' +
     C                             'files (' + %trim(%char(Ix)) + '):'
     C                   eval      DFNAR7 = 'Reference System dependent ' +
     C                             'files:'
     C                   exsr      SR_DepR
     C                   eval      DFNAR7 = 'Reference System dependent ' +
     C                             'files (' + %trim(%char(Ix)) + '):'
     C                   exsr      SR_DetLog

     C                   WRITE     UP4020F6

     C                   EXFMT     UP4020F2
      *
      ** Reset indicators.
     C                   EXSR      ResetInds
     C                   eval      *INKK = SavInKK

      * If F8 is pressed, display details
     C                   IF        *INKH = *ON

     C                   CALL      'UP4006'
     C                   PARM                    CurSys            2
     C                   PARM                    RefSys            2
     C                   PARM      '*GLOBAL'     Layer             7
     C                   PARM                    DFFILE
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'DSPSPLF FILE(UP4006P1' +
     C                             ') JOB(' + %trim(DFJBNC) + '/' +
     C                             %trimr(DFDUSR) + '/' + %trimr(DFJOBN) + ')' +
     C                             ' SPLNBR(*LAST)'

     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   eval      *INKE = *ON
     C                   ENDIF

      * If F11 is pressed, display script details
     C                   IF        *INKJ = *ON

      * call script generator program
     C                   CALL      'UP000086'
     C                   PARM                    DFLIBR
     C                   PARM                    CurSys            2
     C                   PARM                    RefSys            2
     C                   PARM      0             #SEQ             15 5
     C                   PARM                    BRIDGELIB
     C                   PARM                    Return           10
     C                   PARM                    DFFILE

      * call report program
     C                   CALL      'UP000092'
     C                   PARM                    DFLIBR
     C                   PARM                    DFFILE
     C                   PARM      '*GLOBAL'     Layer

      * display report
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'DSPSPLF FILE(UP000092P1' +
     C                             ') JOB(' + %trim(DFJBNC) + '/' +
     C                             %trimr(DFDUSR) + '/' + %trimr(DFJOBN) + ')' +
     C                             ' SPLNBR(*LAST)'

     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   eval      *INKE = *ON
     C                   ENDIF

      ** If F12 is pressed go back to the main screen.
     C                   IF        *INKL = *ON
     C                   EVAL      DFACTC = *blank
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
     C*                  EVAL      DFDMOD = 'Bespoke'
     C*                  EVAL      DFDDEL = 'No '
      *
     C                   WRITE     UP4020F0
     C                   WRITE     UP4020F4
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UP4020C1
     C                   ENDIF
      *
     C                   EXFMT     UP4020F2
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
     C+ insert into UPGDRVTD
     C+ (
     C+   DRPRFX
     C+ , DRFILE
     C+ , DRLIB
     C+ , DRACTN
     C+ , DRALLC
     C+ , DRSCRP
     C+ , DRUPDD
     C+ )
     C+ values
     C+ (
     C+   'XX'
     C+ , :DRFILE
     C+ , :DRLIB
     C+ , :DRACTN
     C+ , :DRALLC
     C+ ,  ' '
     C+ ,  ' '
     C+ )
     C/end-exec
      *
     C                   IF        SQLCODE = 0
      * Only write extension record if key does not already exist.
     C/exec SQL
     C+ select count(*)
     C+ into
     C+   :RecCount
     C+ from UPGDRVTD
     C+ where
     C+     DRFILE  = :DRFILE
     C/end-exec
     C                   IF        RecCount = 0
     C/exec SQL
     C+ insert into UPGDRVTD
     C+ (
     C+   DRPRFX
     C+ , DRFILE
     C+ , DRLIB
     C+ , DRACTN
     C+ , DRALLC
     C+ , DRSCRP
     C+ , DRUPDD
     C+ )
     C+ values
     C+ (
     C+   'XX'
     C+ , :DRFILE
     C+ , :DRLIB
     C+ , :DRACTN
     C+ , :DRALLC
     C+ ,  ' '
     C+ ,  ' '
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
     C+ update UPGDRVTD
     C+ set
     C+   DRACTN = :DRACTN
     C+ where
     C+     DRFILE  = :DRFILE
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

      ** Validation for Action
     C                   EVAL      ErrFlg = 'N'
     C                   EXSR      ValidateACTN

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
     C                   WRITE     UP4020C0
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
     C                   eval      sqlStat = *BLANKS
     C                   eval      sqlStat = 'select ' +
     C                             ' * from UPGDRVTD' +
     C                             ' where DRFILE >= ' + '''' + DFSRCH +
     C                             '''' + ' order by DRFILE'

     C                   select
     C                   when      DFSRCHA <> *BLANKS
     C                   eval      sqlStat = 'select ' +
     C                             ' * from UPGDRVTD' +
     C                             ' where DRFILE >= ' + '''' + DFSRCH +
     C                             '''' + ' and DRLIB >= ' + '''' + DFSRCHL +
     C                             '''' + ' and DRACTN like ' + '''' + '%' +
     C                             %trimr(DFSRCHA) + '%' + ''''

     C                   when      DFSRCHA = *BLANKS
     C                   eval      sqlStat = 'select ' +
     C                             ' * from UPGDRVTD' +
     C                             ' where DRFILE >= ' + '''' + DFSRCH +
     C                             '''' + ' and DRLIB >= ' + '''' + DFSRCHL +
     C                             ''''

     C                   endsl

      * File change Y/N
     C                   if        DFSRCHB <> *BLANKS
     C                   eval      sqlStat = %trimr(sqlStat) + ' and ' +
     C                             ' DRFLCH = ' + '''' + DFSRCHB + ''''
     C                   ENDIF

      * Allow change Y/N
     C                   if        DFSRCHC <> *BLANKS
     C                   eval      sqlStat = %trimr(sqlStat) + ' and '  +
     C                             ' DRALLC = ' + '''' + DFSRCHC + ''''
     C                   ENDIF

      * Exception Y/N
     C                   if        DFSRCHE <> *BLANKS
     C                   eval      sqlStat = %trimr(sqlStat) + ' and '  +
     C                             ' DREXCP = ' + '''' + DFSRCHE + ''''
     C                   ENDIF

     C                   eval      sqlStat = %trimr(sqlStat) +
     C                             ' order by DRFILE'

      * If F11 has not been selected (which is the default), files whose action are IGNORE
      * should not be displayed
     C                   If        *INKK = *off
     C                   eval      pos = %scan('where':sqlStat:1)
     C                   eval      sqlStat = %subst(sqlStat:1:pos+5) +
     C                             ' DRACTN <> '+ '''' + 'IGNORE' + '''' +
     C                             ' and ' + %subst(sqlStat:pos+6:1000)
     C                   ENDIF
     C/EXEC SQL
     C+ prepare sqlStat
     C+ from :sqlStat
     C/END-EXEC

     C/exec SQL
     C+ declare UPGDRCursor insensitive scroll cursor for
     C+ sqlStat
     C/end-exec

     C/exec SQL
     C+ open UPGDRCursor
     C/end-exec
      *
      ** Get the number of rows of the selected records.
     C/exec SQL
     C+ get diagnostics :TotRow  = db2_number_rows
     C/end-exec
      *
     C/exec SQL
     C+ fetch next from UPGDRCursor into :UPGDRV
     C/end-exec
      *
      *
      ** Process if no record on file.
     C                   IF        SQLCODE = 100
     C                             and DFSRCH = *blanks
     C                   EVAL      DFSRCH = *blanks
     C                   EVAL      DFSRCHL = *blanks
     C                   EVAL      DFSRCHA = *blanks
     C                   EVAL      DFSRCHAL = *blanks
     C                   EVAL      DFSRCHC = *blanks
     C                   EVAL      DFSRCHE = *blanks
      *
     C                   DOW       *INKC = *OFF
     C                             and *INKI = *OFF
     C                             and *INKE = *OFF
     C**                           and *INKK = *OFF
     C                   EXSR      ClearFlds
     C                   EVAL      *IN28 = *ON
      *
     C                   WRITE     UP4020F0
     C                   WRITE     UP4020F1
      *
     C                   WRITE     UP4020C1
     C                   EXFMT     UP4020F3
     C                   EVAL      ErrInd = 'N'
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   ENDDO
      *
     C                   ELSE
     C                   EVAL      DFSRCH = *blanks
     C                   EVAL      DFSRCHL = *blanks
     C                   EVAL      DFSRCHA = *blanks
     C*                  EVAL      DFSRCHAL = *blanks
     C                   EVAL      DFSRCHC = *blanks
     C                   EVAL      DFSRCHE = *blanks
      *
      ** Load records to subfile
     C                   IF        ErrInd <> 'Y'
     C                             and *IN31 = *OFF
     C                             or *INKE = *ON
     C                   DOW       TotRow > RdCtr
     C                             and 9999   > RdCtr
     C                   EVAL      RdCtr = RdCtr + 1
     C                   EXSR      MoveData
     C                   WRITE     UP4020S0
     C                   EXSR      ClearRecs
     C                   EXSR      ClearFlds
     C/exec SQL
     C+ fetch next from UPGDRCursor into :UPGDRV
     C/end-exec
      *
     C                   ENDDO
     C                   ENDIF
      *
      ** Load screen.
     C                   WRITE     UP4020F0
     C                   WRITE     UP4020F1
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     UP4020C1
     C                   ENDIF
      *
      * Save F11 toggle indicator
     C                   eval      SavInKK = *INKK

     C                   EXFMT     UP4020C0
      *
      * If F11 toggle indicator has been changed
     C                   if        *INKK = '1'
     C                   if        SavInKK = '1'
     C                   eval      *INKK = '0'
     C                   else
     C                   eval      *INKK = '1'
     C                   ENDIF
     C                   else
      * Restore F11 value
     C                   eval      *INKK = SavInKK
     C                   ENDIF

      ** Reset values.
     C                   IF        *INKE = *ON
     C                             or *INKI = *ON
     C                   READC     UP4020S0                               29
      *
     C                   DOW       *IN29 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFACTC = *blank

     C                   UPDATE    UP4020S0
     C                   READC     UP4020S0                               29
     C                   ENDDO
     C                   ENDIF

     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
     C                   ENDIF
     C/exec SQL
     C+ close UPGDRCursor
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
     C                   EVAL      DRFILE  = DFFILE
     C*                  IF        DFDMOD = 'Core'
     C*                  EVAL      AAMODE = 'C'
     C*                  ELSE
     C*                  EVAL      AAMODE = 'B'
     C*                  ENDIF
     C                   EVAL      DRLIB = DFLIBR
     C                   EVAL      DRACTN = DFACTN
     C*                  EVAL      AAUSER = DFUSER
     C*                  IF        DFDDEL = 'No '
     C*                  EVAL      DRALLC  = 'N'
     C*                  ELSE
     C*                  EVAL      DRALLC  = 'Y'
     C*                  ENDIF
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

     C                   EVAL      DFACTC = *blank
     C                   EVAL      DFFILE  = DRFILE
     C                   EVAL      DFALLC = DRALLC
     C                   EVAL      DFEXCP = DREXCP
     C                   EVAL      DFLIBR = DRLIB
     C                   EVAL      DFACTN = DRACTN
     C                   EVAL      DFFLCH = DRFLCH

     C     MoveDataE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidatePGM  - Validate Adoption Program                     *
      *                                                               *
      *****************************************************************
     C     ValidatePGM   BEGSR
      *
      ** Check that program exists.
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *blanks       ExistYN
     C                   PARM                    DFFILE
     C                   PARM      '*LIBL'       Library
     C                   PARM      '*PGM'        ObjectType
     C                   PARM      *blanks       Member
     C                   IF        ExistYN = 'Exist     '
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
     C     ValidatePGME  ENDSR
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
     C+ from UPGDRVTD
     C+ where
     C+     DRFILE  = :DFFILE
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
     C                   ENDIF
      *
     C     ValidateKeyE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateLIBR - Validate Library                              *
      *                                                               *
      *****************************************************************
     C     ValidateLAYR  BEGSR
      *
      ** Must be '*ZONE' or '*GLOBAL'.
     C*                  IF        DFLIBR <> '*ZONE'
     C*                            and DFLIBR <> '*GLOBAL'
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0012'
     C                   EXSR      ZASNMS
     C*                  ENDIF
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
      *  ValidateACTN - Validate Use Adoption Authority?              *
      *                                                               *
      *****************************************************************
     C     ValidateACTN  BEGSR

      * Must be 'IGNORE' or ...
     C                   IF        DFACTN <> 'IGNORE'
     C                             and DFACTN <> 'SQL Update KEEP'
     C                             and DFACTN <> 'SQL Update'
     C                             and DFACTN <> 'File will be deleted'
     C                             and DFACTN <> 'DTAARA will be deleted'                   MD060709
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'ADB0002'
     C                   EXSR      ZASNMS
     C                   ENDIF

     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN72 = *ON
     C                   ENDIF

     C     ValidateACTNE ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateUSER - Validate Adoption Setting                     *
      *                                                               *
      *****************************************************************
     C     ValidateUSER  BEGSR
      *
      ** Must be '*USER' or '*OWNER'.
     C*                  IF        DFUSER <> '*USER'
     C*                            and DFUSER <> '*OWNER'
     C                   EVAL      ErrFlg = 'Y'
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0011'
     C                   EXSR      ZASNMS
     C*                  ENDIF
      *
     C                   IF        ErrFlg = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      *IN73 = *ON
     C                   ENDIF
      *
     C     ValidateUSERE ENDSR
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
     C                   EVAL      DRFILE  = *blanks
     C                   EVAL      DRLIB  = *blanks
     C                   EVAL      DRACTN = *blanks
     C                   EVAL      DRALLC = *blanks
     C                   EVAL      DREXCP = *blanks
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
     C                   EVAL      DFFILE  = *blanks
     C                   EVAL      DFLIBR  = *blanks
     C                   EVAL      DFACTN = *blanks
     C                   EVAL      DFALLC = *blanks
     C                   EVAL      DFEXCP = *blanks
     C                   EVAL      DFFLCH = *blanks
     C                   EVAL      DFNAR1 = *blanks
     C                   EVAL      DFNAR2 = *blanks
     C                   EVAL      DFNAR3 = *blanks
     C                   EVAL      DFNAR4 = *blanks
     C                   EVAL      DFNAR5 = *blanks
     C                   EVAL      DFNAR6 = *blanks
     C                   EVAL      DFNAR7 = *blanks
     C                   EVAL      DFNAR8 = *blanks
     C                   EVAL      DFNAR9 = *blanks
     C                   EVAL      DFNA10 = *blanks
     C                   EVAL      DFNA11 = *blanks
     C                   EVAL      DFNA12 = *blanks
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
     C     *ENTRY        PLIST
     C                   PARM                    CurSys            2
     C                   PARM                    RefSys            2
     C                   PARM                    BRIDGELIB        10

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
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     ExitE         ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_DepC - Retrieve dependent files in Current System         *
      *                                                               *
      *****************************************************************
     C     SR_DepC       BEGSR
     C/exec SQL
     C+ declare DepFileZ cursor for
     C+ select
     C+   PDEPF
     C+ from UPGXRFPD
     C+ where PMFILE = :DFFILE and PMLIB = :DFLIBR
     C/end-exec
      *
     C/exec SQL
     C+ open DepFileZ
     C/end-exec

     C/exec SQL
     C+ get diagnostics :TotRow2  = db2_number_rows
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from DepFileZ
     C+ into
     C+   :DepF
     C/end-exec

     C                   eval      Ix = 0
     C                   clear                   Dep_Fil

     C                   DOW       SQLCODE = 0

      * Fill array if not yet in
     C     DepF          LOOKUP    Dep_Fil                                99
     C     *IN99         IFEQ      '0'
     C                   eval      Ix = Ix + 1
     C                   eval      Dep_Fil(Ix) = DepF
     C                   ENDIF

      * Get next
     C/exec SQL
     C+ fetch next
     C+ from DepFileZ
     C+ into
     C+   :DepF
     C/end-exec

     C                   END

     C/exec SQL
     C+ close DepFileZ
     C/end-exec

     C                   if        Ix > 0
     C                   eval      Cnt = 1
     C                   eval      DFNAR2 = Dep_Fil(Cnt) + ' ' +
     C                             Dep_Fil(Cnt+1) + ' ' +
     C                             Dep_Fil(Cnt+2) + ' ' + Dep_Fil(Cnt+3) + ' ' +
     C                             Dep_Fil(Cnt+4) + ' ' + Dep_Fil(Cnt+5) + ' ' +
     C                             Dep_Fil(Cnt+6) + ' ' + Dep_Fil(Cnt+7) + ' ' +
     C                             Dep_Fil(Cnt+8) + ' ' + Dep_Fil(Cnt+9) + ' ' +
     C                             Dep_Fil(Cnt+10)
     C                   eval      Cnt = Cnt + 11
     C                   eval      DFNAR3 = Dep_Fil(Cnt) + ' ' +
     C                             Dep_Fil(Cnt+1) + ' ' +
     C                             Dep_Fil(Cnt+2) + ' ' + Dep_Fil(Cnt+3) + ' ' +
     C                             Dep_Fil(Cnt+4) + ' ' + Dep_Fil(Cnt+5) + ' ' +
     C                             Dep_Fil(Cnt+6) + ' ' + Dep_Fil(Cnt+7) + ' ' +
     C                             Dep_Fil(Cnt+8) + ' ' + Dep_Fil(Cnt+9) + ' ' +
     C                             Dep_Fil(Cnt+10)
     C                   eval      Cnt = Cnt + 11
     C                   eval      DFNAR4 = Dep_Fil(Cnt) + ' ' +
     C                             Dep_Fil(Cnt+1) + ' ' +
     C                             Dep_Fil(Cnt+2) + ' ' + Dep_Fil(Cnt+3) + ' ' +
     C                             Dep_Fil(Cnt+4) + ' ' + Dep_Fil(Cnt+5) + ' ' +
     C                             Dep_Fil(Cnt+6) + ' ' + Dep_Fil(Cnt+7) + ' ' +
     C                             Dep_Fil(Cnt+8) + ' ' + Dep_Fil(Cnt+9) + ' ' +
     C                             Dep_Fil(Cnt+10)
     C                   eval      Cnt = Cnt + 11
     C                   eval      DFNAR5 = Dep_Fil(Cnt) + ' ' +
     C                             Dep_Fil(Cnt+1) + ' ' +
     C                             Dep_Fil(Cnt+2) + ' ' + Dep_Fil(Cnt+3) + ' ' +
     C                             Dep_Fil(Cnt+4) + ' ' + Dep_Fil(Cnt+5) + ' ' +
     C                             Dep_Fil(Cnt+6) + ' ' + Dep_Fil(Cnt+7) + ' ' +
     C                             Dep_Fil(Cnt+8) + ' ' + Dep_Fil(Cnt+9) + ' ' +
     C                             Dep_Fil(Cnt+10)
     C                   eval      Cnt = Cnt + 11
     C                   eval      etc = *blanks
     C                   if        Dep_Fil(Cnt+10) <> ' '
     C                   eval      etc = '...'
     C                   ENDIF
     C                   eval      DFNAR6 = Dep_Fil(Cnt) + ' ' +
     C                             Dep_Fil(Cnt+1) + ' ' +
     C                             Dep_Fil(Cnt+2) + ' ' + Dep_Fil(Cnt+3) + ' ' +
     C                             Dep_Fil(Cnt+4) + ' ' + Dep_Fil(Cnt+5) + ' ' +
     C                             Dep_Fil(Cnt+6) + ' ' + Dep_Fil(Cnt+7) + ' ' +
     C                             Dep_Fil(Cnt+8) + ' ' + Dep_Fil(Cnt+9) + ' ' +
     C                             Dep_Fil(Cnt+10) + etc
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_DepR - Retrieve dependent files in Reference System       *
      *                                                               *
      *****************************************************************
     C     SR_DepR       BEGSR

     C                   eval      RefLib = RefSys + %subst(DFLIBR:3:8)
     C/exec SQL
     C+ declare DepFileR cursor for
     C+ select
     C+   PDEPF
     C+ from UPGXRRPD
     C+ where PMFILE = :DFFILE and PMLIB = :RefLib
     C/end-exec
      *
     C/exec SQL
     C+ open DepFileR
     C/end-exec

     C/exec SQL
     C+ get diagnostics :TotRow2  = db2_number_rows
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from DepFileR
     C+ into
     C+   :DepF
     C/end-exec

     C                   eval      Ix = 0
     C                   clear                   Dep_Fil

     C                   DOW       SQLCODE = 0

      * Fill array if not yet in
     C     DepF          LOOKUP    Dep_Fil                                99
     C     *IN99         IFEQ      '0'
     C                   eval      Ix = Ix + 1
     C                   eval      Dep_Fil(Ix) = DepF
     C                   ENDIF

      * Get next
     C/exec SQL
     C+ fetch next
     C+ from DepFileR
     C+ into
     C+   :DepF
     C/end-exec

     C                   END

     C/exec SQL
     C+ close DepFileR
     C/end-exec

     C                   if        Ix > 0
     C                   eval      Cnt = 1
     C                   eval      DFNAR8 = Dep_Fil(Cnt) + ' ' +
     C                             Dep_Fil(Cnt+1) + ' ' +
     C                             Dep_Fil(Cnt+2) + ' ' + Dep_Fil(Cnt+3) + ' ' +
     C                             Dep_Fil(Cnt+4) + ' ' + Dep_Fil(Cnt+5) + ' ' +
     C                             Dep_Fil(Cnt+6) + ' ' + Dep_Fil(Cnt+7) + ' ' +
     C                             Dep_Fil(Cnt+8) + ' ' + Dep_Fil(Cnt+9) + ' ' +
     C                             Dep_Fil(Cnt+10)
     C                   eval      Cnt = Cnt + 11
     C                   eval      DFNAR9 = Dep_Fil(Cnt) + ' ' +
     C                             Dep_Fil(Cnt+1) + ' ' +
     C                             Dep_Fil(Cnt+2) + ' ' + Dep_Fil(Cnt+3) + ' ' +
     C                             Dep_Fil(Cnt+4) + ' ' + Dep_Fil(Cnt+5) + ' ' +
     C                             Dep_Fil(Cnt+6) + ' ' + Dep_Fil(Cnt+7) + ' ' +
     C                             Dep_Fil(Cnt+8) + ' ' + Dep_Fil(Cnt+9) + ' ' +
     C                             Dep_Fil(Cnt+10)
     C                   eval      Cnt = Cnt + 11
     C                   eval      DFNA10 = Dep_Fil(Cnt) + ' ' +
     C                             Dep_Fil(Cnt+1) + ' ' +
     C                             Dep_Fil(Cnt+2) + ' ' + Dep_Fil(Cnt+3) + ' ' +
     C                             Dep_Fil(Cnt+4) + ' ' + Dep_Fil(Cnt+5) + ' ' +
     C                             Dep_Fil(Cnt+6) + ' ' + Dep_Fil(Cnt+7) + ' ' +
     C                             Dep_Fil(Cnt+8) + ' ' + Dep_Fil(Cnt+9) + ' ' +
     C                             Dep_Fil(Cnt+10)
     C                   eval      Cnt = Cnt + 11
     C                   eval      DFNA11 = Dep_Fil(Cnt) + ' ' +
     C                             Dep_Fil(Cnt+1) + ' ' +
     C                             Dep_Fil(Cnt+2) + ' ' + Dep_Fil(Cnt+3) + ' ' +
     C                             Dep_Fil(Cnt+4) + ' ' + Dep_Fil(Cnt+5) + ' ' +
     C                             Dep_Fil(Cnt+6) + ' ' + Dep_Fil(Cnt+7) + ' ' +
     C                             Dep_Fil(Cnt+8) + ' ' + Dep_Fil(Cnt+9) + ' ' +
     C                             Dep_Fil(Cnt+10)
     C                   eval      Cnt = Cnt + 11
     C                   eval      etc = *blanks
     C                   if        Dep_Fil(Cnt+10) <> ' '
     C                   eval      etc = '...'
     C                   ENDIF
     C                   eval      DFNA12 = Dep_Fil(Cnt) + ' ' +
     C                             Dep_Fil(Cnt+1) + ' ' +
     C                             Dep_Fil(Cnt+2) + ' ' + Dep_Fil(Cnt+3) + ' ' +
     C                             Dep_Fil(Cnt+4) + ' ' + Dep_Fil(Cnt+5) + ' ' +
     C                             Dep_Fil(Cnt+6) + ' ' + Dep_Fil(Cnt+7) + ' ' +
     C                             Dep_Fil(Cnt+8) + ' ' + Dep_Fil(Cnt+9) + ' ' +
     C                             Dep_Fil(Cnt+10) + etc
     C                   ENDIF

     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_DetLog - Retrieve summary details from log file           *
      *                                                               *
      *****************************************************************
     C     SR_DetLog     BEGSR

     C                   eval      D_NF = *blanks
     C                   eval      D_MF = *blanks
     C                   eval      D_AF = *blanks
     C                   eval      D_FA = *blanks
     C                   eval      D_FR = *blanks
     C                   eval      D_FC = *blanks

      * New file?
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :DFLIBR and WFile = :DFFILE and WDESC = 'New file'
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   eval      D_NF = 'X'
     C                   Endif

      * Missing file?
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :DFLIBR and WFile = :DFFILE and WDESC = 'File missing'
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   eval      D_MF = 'X'
     C                   Endif

      * Amended file?
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :DFLIBR and WFile = :DFFILE and WFLD1 = '          '
     C+ and WFLD2 = '          ' and WDSP <> '           '
     C+ and WFLDA <> 'RFFLDN'  and WFLDA <> 'RFID' and WFLDA <> 'RFLEN'
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   eval      D_AF = 'X'
     C                   Endif

      * Field added?
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+      WJOB = :DFLIBR and WFile = :DFFILE and WDESC = 'New field'
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   eval      D_FA = 'X'
     C                   Endif

      * Field removed?
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+      WJOB = :DFLIBR and WFile = :DFFILE and WDESC = 'Rmv field'
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   evalr     D_FR = 'X'
     C                   Endif

      * Field attributes changed
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :DFLIBR and WFile = :DFFILE and WFLDA <> '      '
     C+ and WFLD1 <> '          '
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   evalr     D_FC = 'X'
     C                   Endif

     C                   ENDSR
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
