     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas Switchable features by init pgms')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP3090M - Midas GP Switchable features by init pgms          *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD058642           Date 21Aug21               *
      *  Prev Amend No. MD056555 *CREATE   Date 31Aug20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058642- Compilation error                                  *
      *  MD056555 - Deliverable Data Split for SAR group              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
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
     FGP3090DF  CF   E             WORKSTN
     F                                     SFILE(GP3090MS0:RdCtr)
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
     D WrnInd          S              1    INZ('N')
     D CallIn          S              1    INZ(' ')
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
     D*GPSARP***     E DS                  EXTNAME(GPSARPPD)                                MD058642
     D GPSARP        E DS                  EXTNAME(GPSRPJW0)                                MD058642
      *
     C*exec SQL
     C* set option
     C* commit = *CHG
     C*end-exec
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

      ** Read changed record and process it
     C                   READC     GP3090MS0                              29
     C                   DOW       *IN29 = *OFF
     C                             or CallIn = 'Y'
     C                   IF        *IN29 = *OFF

      ** If invalid code
     C                   IF        DKPNOW <> 'Y' and
     C                             DKPNOW <> 'N'
     C                   EVAL      ZAMSGF = 'CBUSRMSG'
     C                   EVAL      ZAMSID = 'CBM0059'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN27 = *ON

     C                   UPDATE    GP3090MS0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   Endif

      ** If program has to be called now
     C                   IF        DKPNOW = 'Y'

      ** check that program exists
      * Validate program existence
     C                   MOVEL     DKPNAM        WUPNAM           10            Program Name
     C                   MOVEL     *BLANK        WUPDSC           50            Program Descrip
     C                   MOVEL     *BLANK        WURTCD            7            Access Obj Retu

     C                   CALL      'SCC3091'                            90      Check Init Pgm
     C                   PARM      WUPNAM        WQ0006           10            Program Name
     C     WUPDSC        PARM      WUPDSC        WQ0007           50            Program Descrip
     C     WURTCD        PARM      WURTCD        WQ0008            7            Access Obj Retu

     C     WURTCD        IFNE      *BLANK                                       *IF

     C                   EVAL      ZAMSGF = 'CBUSRMSG'
     C                   EVAL      ZAMSID = 'CBM0058'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN27 = *ON

     C                   UPDATE    GP3090MS0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF

      * send warning if program has been previously called
     C                   IF        DKPNOW = 'Y' and DKPRVC = 'Y'
     C                             and WrnInd = 'N'
     C                   EVAL      ZAMSGF = 'CBUSRMSG'
     C                   EVAL      ZAMSID = 'CBM0060'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN27 = *ON
     C                   EVAL      WrnInd = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   UPDATE    GP3090MS0
     C                   LEAVE
     C                   endif

      * send warning if program has not been previously called
     C                   IF        DKPNOW = 'Y' and DKPRVC = 'N'
     C                             and WrnInd = 'N'
     C                   EVAL      ZAMSGF = 'CBUSRMSG'
     C                   EVAL      ZAMSID = 'CBM0064'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN27 = *ON
     C                   EVAL      WrnInd = 'Y'
     C                   EVAL      ErrInd = 'Y'
     C                   EVAL      CallIn = 'Y'
     C                   EVAL      DKHCAL = 'Y'
     C                   UPDATE    GP3090MS0
     C                   LEAVE
     C                   endif

     C                   else
     C                   If        DKHCAL = 'Y'
     C                   EVAL      CallIn = ' '
     C                   EVAL      WrnInd = 'N'
     C                   CALL      'SCC3090'                            90      Call Initialisa
     C                   PARM      DKPNAM        WQ0009           10            Program Name
     C     WURTCD        PARM      WURTCD        WQ0010            7            Access Obj Retu
     C                   PARM      '2'           WQ0011            1            Initialisation
     C                   UPDATE    GP3090MS0
     C                   If        WURTCD = *blank
     C/EXEC SQL
     C**update*GPSARPPD                                                                     MD058642
     C+ update GPSRPXTD                                                                     MD058642
     C+ set AKPRVC = 'Y'
     C+ where AKSARN = :AKSARN and AKPNAM = :AKPNAM
     C/END-EXEC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank

     C                   READC     GP3090MS0                              29
     C                   ENDDO

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

     C     InsertRecordE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateFlds - Validate input                                *
      *                                                               *
      *****************************************************************
     C     ValidateFlds  BEGSR

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
     C                   WRITE     GP3090MC0
     C                   EVAL      *IN26 = *OFF
     C                   EVAL      RdCtr = 0
     C                   ENDIF
      *
      ** Set on control.
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      *IN22 = *ON
     C                   EVAL      *IN23 = *ON
     C                   EVAL      DFSAR2 = SARN
     C                   EVAL      DFSARD = SARD
      *
      ** The declaration selects all records that are greater than or equal to
      **  the 'Go to' field; if it is blank all records are selected.
     C/exec SQL
     C+ declare GCursor insensitive scroll cursor for
     C**select** from GPSARPPD                                                              MD058642
     C+ select * from GPSRPJW0                                                              MD058642
     C+ where AKSARN = :SARN
     C+ order by AKPNAM
     C/end-exec
      *
     C/exec SQL
     C+ open GCursor
     C/end-exec
      *
      ** Get the number of rows of the selected records.
     C/exec SQL
     C+ get diagnostics :TotRow  = db2_number_rows
     C/end-exec
      *
     C/exec SQL
     C+ fetch next from GCursor into :GPSARP
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
     C                   WRITE     GP3090MF0
     C                   WRITE     GP3090MF1
      *
     C                   WRITE     GP3090MC1
     C                   EXFMT     GP3090MF3
     C                   EVAL      ErrInd = 'N'
     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   ENDDO
      *
     C                   ELSE
     C**********         EVAL      DFSRCH = *blanks
      *
      ** Load records to subfile
     C                   IF        ErrInd <> 'Y'
     C                             and *IN31 = *OFF
     C                             or *INKE = *ON
     C                   DOW       TotRow > RdCtr
     C                             and SQLCODE = 0
     C                   if        DFSRCH <> *BLANKS
     C                             and AKPNAM >= DFSRCH
     C                             or DFSRCH = *BLANKS
     C                   EVAL      RdCtr = RdCtr + 1
     C                   EXSR      MoveData
     C                   seton                                        878851
     C                   WRITE     GP3090MS0
     C                   EXSR      ClearRecs
     C                   EXSR      ClearFlds
     C                   ENDIF
     C/exec SQL
     C+ fetch next from GCursor into :GPSARP
     C/end-exec
     C                   ENDDO
     C                   ENDIF
      *
      ** Load screen.
     C                   WRITE     GP3090MF0
     C                   WRITE     GP3090MF1
     C*                  WRITE     GP3090MF5
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     GP3090MC1
     C                   ENDIF
      *
     C                   EXFMT     GP3090MC0
      *
      ** Reset values.
     C                   IF        *INKE = *ON
     C                             or *INKI = *ON
     C                   READC     GP3090MS0                              29
      *
     C                   DOW       *IN29 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank

     C                   UPDATE    GP3090MS0
     C                   READC     GP3090MS0                              29
     C                   ENDDO
     C                   ENDIF

     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
     C                   ENDIF
     C/exec SQL
     C+ close GCursor
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

     C                   EVAL      DKPNAM = AKPNAM
     C                   EVAL      DKPRVC = AKPRVC
     C                   EVAL      DKPNOW = 'N'

     C     MoveDataE     ENDSR
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
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN35 = *OFF
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
     C*                  EVAL      DFPGM  = *blanks
     C*                  EVAL      DFMODE = *blanks
     C*                  EVAL      DFDMOD = *blanks
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

     C     *ENTRY        PLIST
     C                   PARM                    RETURN            7
     C                   PARM                    SARN              6
     C                   PARM                    SARD             50

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
      *  DeletePhyRec - Delete bespoke records that are logically     *
      *                 deleted                                       *
      *                                                               *
      *****************************************************************
     C     DeletePhyRec  BEGSR
      *
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
