      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SD Interface Passwords Maintenance')             *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000401 - Midas SD Interface Passwords Maintenance          *
      *                                                               *
      *  Function:  This program displays the Interface used by Midas *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. MD053140           Date 03Apr19               *
      *  Prev Amend No. CSD101 *CREATE     Date 07Dec18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053140 - F3 Exit and F12 Previous have the same function   *
      *             which makes it duplicate                          *
      *  CSD101 - Password Encryption                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
      *                                                               *
      *  SrBldSfl - Build the Subfile                                 *
      *  SrClrSfl - Clear the Subfile                                 *
      *  SrDspSfl - Display the Subfile                               *
      *  SrErrDta - Output Error Message With Data                    *
      *  SrLoadSfl - Load the Subfile                                 *
      *  SrProcess - Process the Subfile                              *
      *  SrPrSfl - Process the Subfile Functions                      *
      *  SrRefresh - Refresh Entries                                  *
      *  SrReset - Reset the Fields                                   *
      *  SrCmdStr - Set Up Command String                             *
      *  SrCommand - Execute CL Command                               *
      *  SrView - View a Validation List Entry                        *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Validation list entries maintenance display file.
     FSD000401DFCF   E             WORKSTN SFILE(SD000401S0:RRN0)
      *
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     DPSDS            SDS
     D PSExcpType             40     42
      ** Exception number.
     D PSExcpNo               43     46
      ** Job name.
     D PSJobName             244    253
      ** User name.
     D PSUser                254    263
      *
     D IndPointer      S               *   Inz(%ADDR(*IN))

      ** Indicator data structure.
     D Indicators      DS                  BASED(IndPointer)
     D  Exit                  03     03
     D  Refresh               05     05
     D  RollUp                27     27
     D  SflDsp                30     30
     D  SflClr                31     31
     D  SflEnd                33     33
     D  SflNxtChg             34     34
     D  ErrOptn               48     48
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** Action codes.
     D ACT_View        C                   CONST('1')
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Logical conditions.
     D True            C                   *ON
     D False           C                   *OFF
      *
     D FileFormat    E DS                  EXTNAME(SDFACCTD)
      *
     D UpdateOptn      S              1N
      *
     D WRun            S              1A
     D KID             S             20A
      *
      ** Parameter for ZA0350.
     D PZMsgFile       S             10A   INZ('SDUSRMSG')
     D PZMsgId         S             10A
     D PZMsgData       S             45A
      *
      ** SD000401 parameters.
     D PReturnCode     S              7A
     D PID             S             20A
     D PDesc           S             50A
      *
     D RRN0            S              4  0
     D SflPag          C                   CONST(14)
     D WCtr            S              2  0
     D WLstRrn         S              4  0
     D ReadCFlag       S              1A
     D MIMessageF      S             10A
     D LanguageId      S              2A
     D Count           S              5S 0
     D WSearch         S                   LIKE(D0SIDE)
     D NoSearch        S              1A   INZ(*BLANKS)
     D MarkError       S              1A   INZ(*BLANKS)
      *
     D MessageID       S              7A   INZ(*BLANKS)
     D CommandStr      S            200A   INZ(*BLANKS)
     D CommandLen      S             15  5
     D TmStamp         S             14  0
     D PExit           S              1A   INZ(*BLANKS)                                     MD053140
      *
      /EJECT
      *****************************************************************
      * MAIN - Processing
      *****************************************************************
      *
      ** Build the subfile.
      *
     C                   EXSR      SrBldSfl
      *
      ** Display the screen until F3 is pressed.
     C                   DOW       Exit = False
      *
     C                   EVAL      D0OPTN = *BLANKS
      *
      ** Display and process the subfile.
     C                   EXSR      SrDspSfl
      *
      ** Process the subfile.
     C                   EXSR      SrProcess
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBldSfl - Build the Subfile                                 *
      *                                                               *
      *****************************************************************
     C     SrBldSfl      BEGSR
      *
      ** Clear the subfile.
     C                   EXSR      SrClrSfl
      *
      ** Load the subfile.
     C                   EXSR      SrLoadSfl
      *
     C     SrBldSflE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrClrSfl - Clear the Subfile                                 *
      *                                                               *
      *****************************************************************
     C     SrClrSfl      BEGSR
      *
     C/exec SQL
     C+ close FaceCursor
     C/end-exec
      *
      ** Intialise fields.
     C                   EVAL      RRN0  = *ZEROS
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      SflClr = *ON
     C                   EVAL      SflEnd = *OFF
     C                   EVAL      NoSearch = ' '
      *
     C                   WRITE     SD000401C0
      *
     C                   EVAL      SflClr = *OFF
      *
     C     SrClrSflE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDspSfl - Display the Subfile                               *
      *                                                               *
      *****************************************************************
     C     SrDspSfl      BEGSR
      *
     C                   TIME                    D0TIME
     C                   IF        NoSearch = ' '
      *
      ** Write the message subfile control format.
     C                   WRITE     SD000401C1
     C                   WRITE     SD000401F0
     C                   EXFMT     SD000401C0
     C                   ENDIF
      *
     C     SrDspSflE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrErrDta - Output Error Message With Data                    *
      *                                                               *
      *****************************************************************
     C     SrErrDta      BEGSR
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgId
     C                   PARM      *BLANKS       PZMsgData
      *
     C     SrErrDtaE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrLoadSfl - Load the Subfile                                 *
      *                                                               *
      *****************************************************************
     C     SrLoadSfl     BEGSR
      *
      ** If RRN of the last record loaded in the subfile is greater than zero.
     C                   IF        WLstRrn > *ZEROS
      *
     C                   EVAL      RRN0  = WLstRrn
     C                   EVAL      D0SFRN  = WLstRrn
      *
     C                   ENDIF
      *
      ** If Position field - ID is not blank, set the pointer to the entered ID data.
     C                   IF        RollUp = *OFF
      *
     C                   EVAL      D0HSID = D0SIDE
     C                   IF        D0SIDE <> *BLANKS
     C                   MOVEL     D0SIDE        KID
     C                   ELSE
     C                   MOVEL     *BLANKS       KID
     C                   ENDIF
      *
     C/exec SQL
     C+ declare FaceCursor cursor for
     C+ select * from SDFACUW0
     C+ where
     C+   LEENTI >= :KID
     C+ order by
     C+   LEENTI
     C/end-exec
      *
     C/exec SQL
     C+ open FaceCursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next from FaceCursor into :FileFormat
     C/end-exec
      *
     C                   ENDIF
      *
      ** Reset counter.
     C                   EVAL      WCtr = 0
      *
      ** Load records to subfile.
     C                   DOW       WCtr < SflPag AND
     C                             SQLCODE <> 100
      *
      ** Interface Name
     C                   EVAL      D0ENID = LEENTI
      *
      ** Interface Description
     C                   EVAL      D0DESC = LEENTD
      *
      ** Increment the subfile
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      D0OPTN = *BLANKS
     C                   EVAL      SflNxtChg = False
      *
     C                   WRITE     SD000401S0
      *
      ** Get the next record
     C/exec SQL
     C+ fetch next from FaceCursor into :FileFormat
     C/end-exec
     C                   ENDDO
      *
      ** If last record, turn on the 'SFLEND' indicator.
     C                   IF        SQLCODE = 100
     C                   EVAL      SflEnd = True
     C                   ENDIF
     C                   EVAL      WLstRrn = D0SFRN
      *
      ** Check if records were written into the subfile.
     C                   IF        WLstRrn <> *ZEROS
     C                   EVAL      SflDsp = *ON
      *
      ** If search has no record to display but there is a record on file.
      ** Message - No records found.
     C                   ELSEIF    Count > 0
     C                   EVAL      WSearch = D0SIDE
     C                   DOW       Exit = False
     C                   EVAL      PZMsgId = 'PWD0004'
     C                   EXSR      SrErrDta
     C                   TIME                    D0TIME
     C                   WRITE     SD000401C1
     C                   EXFMT     SD000401R1
     C                   EXSR      SrReset
      *
     C                   SELECT
     C                   WHEN      Exit = True
     C                   EVAL      D0SIDE = *BLANKS
     C
     C                   WHEN      Refresh = True
     C                   EVAL      D0SIDE = *BLANKS
     C                   EVAL      Exit = True
     C                   EVAL      Refresh= False
      *
     C                   WHEN      D0SIDE = *BLANKS
     C                   EVAL      Exit = True
      *
     C                   WHEN      D0SIDE <> WSearch
     C                   EVAL      Exit = True
      *
     C                   ENDSL
      *
     C                   ENDDO
     C                   EVAL      Exit = False
     C                   EVAL      NoSearch = 'Y'
      *
     C                   ELSE
      *
      ** If no records exists, then show 'No Data to Display' in the screen.
      ** Message - No records found.
     C                   DOW       Exit = False
     C                   EVAL      PZMsgId = 'PWD0004'
     C                   EXSR      SrErrDta
     C                   TIME                    D0TIME
     C                   WRITE     SD000401C1
     C                   EXFMT     SD000401R0
     C                   EXSR      SrReset
     C                   ENDDO
     C                   ENDIF
      *
     C     SrLoadSflE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProcess - Process the Subfile                              *
      *                                                               *
      *****************************************************************
     C     SrProcess     BEGSR
      *
      ** Reset the fields and the program message queue.
     C                   EXSR      SrReset
      *
     C                   SELECT
      *
      ** When F5 is pressed (Refresh).
     C                   WHEN      Refresh = True
      *
      ** Reset and build.
     C                   EXSR      SrReset
     C                   EXSR      SrRefresh
      *
      ** When Page Down is pressed.
     C                   WHEN      Rollup = True
      *
      ** Load the next page.
     C                   EXSR      SrLoadSfl
      *
     C                   WHEN      (D0SIDE <> *BLANKS) OR
     C                             (D0SIDE <> D0HSID)
      *
     C                   EXSR      SrPrSfl
     C                   IF        ErrOptn = False AND
     C                             MarkError = ' '
     C                   EXSR      SrBldSfl
     C                   ENDIF
      *
     C                   OTHER
      *
      ** Process the subfile.
     C                   EXSR      SrPrSfl
      *
     C                   ENDSL
      *
     C     SrProcessE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPrSfl - Process the Subfile Functions                      *
      *                                                               *
      *****************************************************************
     C     SrPrSfl       BEGSR
      *
      ** Check for last RRN.
     C                   IF        WLstRrn > *ZEROS
     C                   EVAL      ReadCFlag = ' '
      *
      ** Reset error flag.
     C                   READC     SD000401S0
     C                   DOW       NOT %EOF
      *
     C                   SELECT
     C                   WHEN      D0OPTN = ACT_View
     C                   EVAL      UpdateOptn = True
     C                   EXSR      SrView
      *
      ** Option entry is invalid.
     C                   OTHER
      *
     C                   IF        D0OPTN <> *BLANKS
     C                   EVAL      UpdateOptn = False
     C                   ELSE
     C                   EVAL      UpdateOptn = True
     C                   ENDIF
     C                   ENDSL
      *
      ** When Option is Blank
     C                   IF        (UpdateOptn = True)
     C                   EVAL      ErrOptn = False
     C                   EVAL      SflNxtChg = False
     C                   EVAL      D0OPTN = *BLANKS
     C                   ELSE
      *
      ** When Option is invalid.
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      SflNxtChg = True
     C                   EVAL      ErrOptn = True
     C                   EVAL      MarkError = 'Y'
     C                   EVAL      PZMsgId= 'PWD0005'
     C                   EXSR      SrErrDta
     C                   EVAL      ReadCFlag = 'Y'
     C                   WRITE     SD000401C1
     C                   ENDIF
      *
     C                   UPDATE    SD000401S0
      *
     C                   READC     SD000401S0
      *
     C                   ENDDO
      *
      ** If position to is blank and Rollup is not pressed then set the subfile
      ** to 1st RRN
     C                   IF        Rollup = False AND
     C                             ReadCFlag = *BLANKS AND D0SIDE = *BLANKS
     C                   EVAL      D0SFRN = 1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     SrPrSflE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRefresh - Refresh Subfile                                  *
      *                                                               *
      *****************************************************************
     C     SrRefresh     BEGSR
      *
     C                   EVAL      D0OPTN = *BLANKS
     C                   EVAL      D0SIDE = *BLANKS
     C                   EXSR      SrBldSfl
      *
     C     SrRefreshE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReset - Reset the Fields and Clear message in queue        *
      *                                                               *
      *****************************************************************
     C     SrReset       BEGSR
      *
      ** Clear program queue and message file.
     C                   CALL      'ZA0250'
      *
     C                   EVAL      PZMsgId = *BLANKS
     C                   EVAL      PZMsgData = *BLANKS
      *
     C                   EVAL      ErrOptn = False
     C                   EVAL      MarkError = ' '
      *
     C     SrResetE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrView - View a Validation List Entry                        *
      *                                                               *
      *****************************************************************
     C     SrView        BEGSR
      *
     C                   CALL(E)   'SD000402'
     C                   PARM      *BLANKS       PReturnCode
     C                   PARM      D0ENID        PID
     C                   PARM      D0DESC        PDESC
     C                   PARM      *BLANKS       PExit
      *
     C                   IF        %ERROR
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        PReturnCode <> *BLANKS
     C                   LEAVESR
     C                   ENDIF
      *                                                                                     MD053140
     C                   IF        PExit = 'Y'                                              MD053140
     C                   EVAL      Exit = True                                              MD053140
     C                   ENDIF                                                              MD053140
      *
      ** Get the cursor location for RRN.
     C                   IF        D0HCUR <> 0
     C                   EVAL      D0SFRN = D0HCUR
     C                   ENDIF
      *
     C     SrViewE       ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Populate workstation ID.
     C                   EVAL      D0WID = PsJobName
      *
      ** Populate user.
     C                   EVAL      D0USER = PsUser
      *
     C                   TIME                    TmStamp
     C                   MOVE      TmStamp       D0MRDT
      *
      ** Initialise subfile program queue and message file.
     C                   EVAL      D1PGMQ = '*'
     C                   EVAL      *IN32 = *ON
      *
      ** Get record count of SDFACUW0
     C/exec SQL
     C+ select count(*) into :Count
     C+ from SDFACUW0
     C/end-exec
      *
      ** Get the Multi-Language of the User
     C/exec SQL
     C+ select
     C+   MULT
     C+ into
     C+   :LanguageId
     C+ from MUSERDD
     C+ where
     C+     USRP = 'MIDAS'
     C/end-exec
      *
     C                   IF        SQLCODE = 0
     C                   IF        LanguageId = ' '
     C                   EVAL      MIMessageF = 'GBSDUSRMSG'
     C                   ELSE
     C                   EVAL      MIMessageF = LanguageId + 'SDUSRMSG'
     C                   ENDIF
      *
     C                   EXSR      SrCmdStr
     C                   ENDIF
      *
     C     INZSRE        ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCmdStr - Set Up Command String                             *
      *                                                               *
      *****************************************************************
     C     SrCmdStr      BEGSR
      *
     C                   EVAL      CommandStr = 'OVRMSGF MSGF(SDUSRMSG) ' +
     C                             'TOMSGF(' + MIMessageF +')'
     C                   EVAL      CommandLen = 41
     C                   EXSR      SrCommand
      *
     C     SrCmdStrE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCommand - Execute CL Command                               *
      *                                                               *
      *****************************************************************
     C     SrCommand     BEGSR
      *
     C                   EVAL      MessageID = *BLANKS
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    CommandStr
     C                   PARM                    CommandLen
     C                   IF        %ERROR
     C                   EVAL      MessageID = PSExcpType+
     C                             PSExcpNo
     C                   ENDIF
      *
     C     SrCommandE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically If a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
