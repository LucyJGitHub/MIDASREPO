     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM OTB Migr components maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Implemenatation module                               *
      *                                                               *
      *  SM8012 - Midas SM Migration Components Logs Enquiry          *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CUP046   *CREATE   Date 18Jul22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP046 - One Touch Bridge - migration                        *
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
     FSM8012GF  CF   E             WORKSTN
     F                                     SFILE(SM8012S0:RdCtr)
      ** Program data structure
     D/COPY ZACPYSRC,PSDS
     D*MyPSDS         SDS
     D*DFPGMQ                  1     10
     D*DFJOBN                244    253
     D*DFDUSR                254    263
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
     D WkTime          S              5S 0
     DTIME0            S               T   INZ(T'00.00.00')
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

     D Command         S             80
     D CommandLen      S             15  5 INZ(80)

     D SMOTMDS       E DS                  EXTNAME(SMOTMLTD)
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
     C                   EXSR      GetRecord
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
      *  GetRecord - Load the selected record to second screen        *
      *                                                               *
      *****************************************************************
     C     GetRecord     BEGSR
      *
      ** Read changed record and process it
     C                   READC     SM8012S0                               29
     C                   DOW       *IN29 = *OFF
      *
     C                   IF        DFAORD = 'A'
     C                             or DFAORD = 'D'
     C                             or DFAORD = 'E'
     C                   EVAL      ValidationMode = DFAORD
     C                   ENDIF
      *
      ** If Enquire.
     C                   IF        DFAORD = 'V'
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
     C                   IF        DFAORD <> 'V'
     C                             and DFAORD <> *blank
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   EVAL      ZAMSID = 'DDS0001'
     C                   EXSR      ZASNMS
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN27 = *ON
      *
     C                   UPDATE    SM8012S0
     C                   EVAL      ErrInd = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank
      *
     C                   UPDATE    SM8012S0
     C                   READC     SM8012S0                               29
     C                   ENDDO
      *
     C     GetRecordE    ENDSR
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
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'WRKJOB JOB(' + %trim(DDJNB) +
     C                             '/' + %trim(DDJUS) + '/' +
     C                             %trimr(DDJNM) + ')'

     C                   CALL      'QCMDEXC'                            99
     C                   PARM                    Command
     C                   PARM                    CommandLen

      * monitor error
     C                   if        *IN99 = *on
     C                             and PSEXCPNO <> '1070'
     C                   exsr      *pssr
     C                   endif

      *
     C     EnquireRecordEENDSR
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
     C                   WRITE     SM8012C0
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
     C+ declare SMOTMCursor insensitive scroll cursor for
     C+ select * from SMOTMLTD
     C+ order by LOGINC
     C/end-exec
      *
     C/exec SQL
     C+ open SMOTMCursor
     C/end-exec
      *
      ** Get the number of rows of the selected records.
     C/exec SQL
     C+ get diagnostics :TotRow  = db2_number_rows
     C/end-exec
      *
     C/exec SQL
     C+ fetch next from SMOTMCursor into :SMOTMDS
     C/end-exec
      *
      ** Process if no record on file.
     C                   IF        SQLCODE = 100
      *
     C                   DOW       *INKC = *OFF
     C                             and *INKI = *OFF
     C                   EXSR      ClearFlds
     C                   EVAL      *IN28 = *ON
      *
     C                   WRITE     SM8012F0
     C                   WRITE     SM8012F1
      *
     C                   WRITE     SM8012C1
     C                   EXFMT     SM8012F3
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
     C                   DOW       TotRow > RdCtr
     C                             and SQLCODE = 0
     C                   EXSR      MoveData
      ** write only if matching
     C                   exsr      SR_Match
     C                   If        Match = 'Y'
     C                   EVAL      RdCtr = RdCtr + 1
     C                   WRITE     SM8012S0
     C                   Endif
     C                   EXSR      ClearRecs
     C                   EXSR      ClearFlds
     C/exec SQL
     C+ fetch next from SMOTMCursor into :SMOTMDS
     C/end-exec
     C                   ENDDO
     C                   ENDIF
      *
      ** Load screen.
     C                   WRITE     SM8012F0
     C                   WRITE     SM8012F1
      *
      ** Display error message if ErrInd = 'Y'.
     C                   IF        ErrInd = 'Y'
     C                   EVAL      *IN28 = *ON
     C                   WRITE     SM8012C1
     C                   ENDIF
      *
     C                   EXFMT     SM8012C0
      *
      ** Reset values.
     C                   IF        *INKE = *ON
     C                             or *INKI = *ON
     C                   READC     SM8012S0                               29
      *
     C                   DOW       *IN29 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN27 = *OFF
     C                   EVAL      DFAORD = *blank

     C                   UPDATE    SM8012S0
     C                   READC     SM8012S0                               29
     C                   ENDDO
     C                   ENDIF

     C                   EXSR      Clear
     C                   EXSR      ResetInds
     C                   EVAL      ErrInd = 'N'
     C                   ENDIF
     C/exec SQL
     C+ close SMOTMCursor
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

     C*                  EVAL      LTMCMP = DDCMP
     C*                  EVAL      OTMSEQ = DDSEQ
     C*                  EVAL      OTMDES = DDDES
     C*                  EVAL      OTMPGM = DDPGM
     C*                  EVAL      OTMPAR = DDPAR
     C*                  EVAL      OTMRUN = DDRUN
     C*                  EVAL      OTMBYP = DDBYP
     C*                  EVAL      OTMLYR = DDLYR
     C*                  IF        DDCRBS = 'Core'
     C*                  EVAL      OTMODE = 'C'
     C*                  else
     C*                  EVAL      OTMODE = 'B'
     C*                  Endif

     C     MoveDisplayE  ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      *  MoveData - Move data fields to display file                  *
      *                                                               *
      *****************************************************************
     C     MoveData      BEGSR

     C                   EVAL      DFDES  = LOGDES
     C                   EVAL      DDCMP  = LOGCMP
     C                   EVAL      DDSEQ  = LOGSEQ
     C                   EVAL      DDDES  = LOGDES
     C                   EVAL      DDLYR  = LOGLYR
     C                   EVAL      DFLYR  = LOGLYR
     C                   eval      DFSTRD = %subst(LOGSTD:1:2) + '/' +
     C                             %subst(LOGSTD:3:2)
     C                   eval      DFSTRT = %subst(LOGSTT:1:2) + ':' +
     C                             %subst(LOGSTT:3:2) + ':' +
     C                             %subst(LOGSTT:5:2)
     C                   eval      DFENDD = %subst(LOGEND:1:2) + '/' +
     C                             %subst(LOGEND:3:2)
     C                   eval      DFENDT = %subst(LOGENT:1:2) + ':' +
     C                             %subst(LOGENT:3:2) + ':' +
     C                             %subst(LOGENT:5:2)
     C                   eval      ##HST = %TIME(DFSTRT:*HMS)
     C                   eval      ##HET = %TIME(DFENDT:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      DFRUNT = TIME0 + %SECONDS(WkTime)
     C
     C                   EVAL      DDJNM  = LOGJNM
     C                   EVAL      DDJUS  = LOGUSR
     C                   EVAL      DDJNB  = LOGJBN

     C                   EVAL      DFBYP = ' '
     C                   If        LOGSTS = 'B'
     C                   EVAL      DFBYP = 'B'
     C                   ENDIF

     C     MoveDataE     ENDSR

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
     C                   PARM      PSProcMod     ZAPGMQ
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
     C                   EVAL      DDLYR  = *blanks
     C                   EVAL      DDCRBS = *blanks

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

     C*                  if        X_CMP <> *blanks
     C*                  eval      pos = %scan(%trim(X_CMP):DFCMP)
     C*                  if        pos = 0
     C*                  eval      Match = 'N'
     C*                  leaveSR
     C*                  endif
     C*                  endif

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

     C*                  if        X_MOD <> *blanks and DFMODE <> X_MOD
     C*                  eval      Match = 'N'
     C*                  leaveSR
     C*                  endif

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
