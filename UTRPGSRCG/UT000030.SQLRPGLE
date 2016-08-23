      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*XBI *  OVRDBF FILE(UTC000030F) TOFILE(UPOBJDTPD)                    *
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT Validation List objects maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000030 - Midas UT Validation List Objects Maintenance      *
      *                                                               *
      *  Function:  This program display the list of all validation   *
      *             list objects for a particular library             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CUT007  *REWRITE   Date 15Dec10               *
      *  Prev Amend No. BUG28082           Date 31Aug10               *
      *                 BUG27989A          Date 12Aug10               *
      *                 BUG27989*CREATE    Date 08Aug10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUT007 - Rewrite of UTWRKDLVL.                               *
      *  BUG28082 - Unable to display the correct information in the  *
      *             screen. (Recompile)                               *
      *  BUG27989A - Include validity checker and panel group         *
      *  BUG27989 - HATS should run with/without LDAP                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
      *                                                               *
      *  SRBldSfl - Build the Subfile                                 *
      *  SRClrSfl - Clear the Subfile                                 *
      *  SRDspSfl - Display the Subfile                               *
      *  SRErrDta - Output Error Message With Data                    *
      *  SRloadSfl - Load the Subfile                                 *
      *  SRProcess - Process the Subfile                              *
      *  SRPrSfl - Process the Subfile                                *
      *  SRReset - Reset the Fields                                   *
      *  SrView - Calls valivation list entry maintenance program     *
      *  SrEnq  - Enquire validation list field information           *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Validation List Objects Maintenance File
     FUT000030DFCF   E             WORKSTN SFILE(UT000030S0:RRN0)
 
      * Validation List Objects Output File (DSPOBJ)
     FUTC000030FIF   E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     DPSDS            SDS
      * Job name.
     D PSJobName             244    253
      * User name.
     D PSUser                254    263
 
     D VLDL          E DS                  EXTNAME(UTVLDJW0)
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Action Codes
     D ACT_ENQ         C                   CONST('E')
     D ACT_VIEW        C                   CONST('12')
     D SflPag          C                   CONST(14)
 
      ** Logical conditions
     D True            C                   *ON
     D False           C                   *OFF
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Indicator Data Structure
     D Indicators      DS                  BASED(IndPointer)
     D  Exit                  03     03
     D  Previous              12     12
     D  RollUp                27     27
     D  SflDsp                30     30
     D  SflClr                31     31
     D  SflEnd                33     33
     D  NoData                20     20
     D  ActnErr               35     35
     D  ErrOptn               48     48
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D IndPointer      S               *   Inz(%Addr(*in))
      *
     D EndPGMFlag      S              1A
     D RRN0            S              4  0
     D UpdateOptn      S              1N
     D WCtr            S              2  0
     D WLstRrn         S              4  0
     D WRun            S              1A
      *
      * Parameters for ZA0350.
     D PZMsgFile       S             10A   INZ('UTMSGF')
     D PZMsgId         S             10A
     D PZMsgData       S             45A
      *
     D TmStamp         S             14  0
      *
     D InitLibl        S             10A
      *
      /EJECT
      *****************************************************************
      * MAIN - Processing
      *
      * Build the subfile.
     C                   EVAL      D0OBNM = *BLANKS
     C                   EVAL      D0OBTX = *BLANKS
     C                   EVAL      D0LBNM = *BLANKS
     C                   EXSR      SRBldSfl
      *
      * Display the screen until F3 is pressed.
     C                   DOW       (Exit = False) AND
     C                             (EndPGMFlag = False)
      *
     C                   EVAL      D0OPTN = *BLANKS
      *
      * Display and process the subfile.
     C                   EXSR      SRDspSfl
      *
      * Process the subfile.
     C                   EXSR      SRProcess
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl - Build the Subfile                                 *
      *                                                               *
      *  Called by: Main Processing, SrProcess                        *
      *                                                               *
      *  Calls: SRClrSfl, SRLoadSfl                                   *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR
      *
      * Clear the subfile.
     C                   EXSR      SRClrSfl
      *
      * Load the subfile.
     C                   EXSR      SRLoadSfl
      *
     C     SRBldSflE     ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrSfl - Clear the Subfile                                 *
      *                                                               *
      *  Called by: SRBldSfl                                          *
      *                                                               *
      *  Calls: SrReset                                               *
      *                                                               *
      *****************************************************************
     C     SRClrSfl      BEGSR
      *
     C     *LOVAL        SETLL     UTC000030F
      *
      * Reset the fields and the program message queue.
     C                   EXSR      SRReset
      *
      * Intialise fields.
     C                   EVAL      RRN0  = *ZEROS
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      *IN20  = *OFF
     C                   EVAL      ActnErr = *OFF
     C                   EVAL      SflEnd = *OFF
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      SflClr = *ON
      *
     C                   WRITE     UT000030C0
      *
     C                   EVAL      SflClr = *OFF
      *
     C     SRClrSflE     ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspSfl - Display the Subfile                               *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRDspSfl      BEGSR
      *
     C*                  TIME                    D0TIME
      *
      * Write the footer.
     C                   WRITE     UT000030F0
      *
      * Write the message subfile control format.
     C                   WRITE     UT000030C1
      *
      * Display the subfile.
     C                   IF        NoData = False
     C                   EXFMT     UT000030C0
     C                   ELSE
     C                   EXFMT     UT000030C2
     C                   ENDIF
      *
     C     SRDspSflE     ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrDta - Output Error Message With Data                    *
      *                                                               *
      *  Called by:  Various subroutines                              *
      *                                                               *
      *  Calls: None: EXTERNAL/ZA0350                                 *
      *                                                               *
      *****************************************************************
     C     SRErrDta      BEGSR
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgId
     C                   PARM      *BLANKS       PZMsgData
      *
     C     SRErrDtaE     ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRloadSfl - Load the Subfile                                 *
      *                                                               *
      *  Called by: SRBldSfl, SRProcess                               *
      *                                                               *
      *  Calls: SRErrDta                                              *
      *                                                               *
      *****************************************************************
     C     SRloadSfl     BEGSR
      *
      * Intialise filter flags - no search criteria.
      * If RRN of the last record loaded in the subfile is greater than zero.
     C                   IF        WLstRrn > *ZEROS
      *
     C                   EVAL      RRN0  = WLstRrn
     C                   EVAL      WLstRrn = D0SFRN
      *
     C                   ENDIF
      *
      * Reset counter.
     C                   EVAL      WCtr = 0
      *
      * Loading records to subfile.
     C                   DOW       WCtr < SflPag AND
     C                             NOT %EOF(UTC000030F)
      *
      * Read the database file.
     C                   READ      UTC000030F
      *
     C                   IF        %EOF(UTC000030F)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        NOT %EOF(UTC000030F)
      *
     C                   EVAL      D0OBNM = ODOBNM
     C                   EVAL      D0OBTX = ODOBTX
     C                   EVAL      D0LBNM = ODLBNM
      *
      * Write the selected records.
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      *IN35 = *OFF
      *
     C                   WRITE     UT000030S0
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      * If last record, turn on the 'SFLEND' indicator.
     C                   READ      UTC000030F
     C                   IF        %EOF(UTC000030F)
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   READP     UTC000030F
     C                   EVAL      SflEnd = *OFF
     C                   ENDIF
     C                   EVAL      WLstRrn = D0SFRN
      *
      * Check if records were written into the subfile.
     C                   IF        WLstRrn <> *ZEROS
     C                   EVAL      SflDsp = *ON
     C                   ELSE
      *
      * If no records exists, then show 'No Data to Display' message.
     C                   EVAL      SflDsp = *OFF
     C                   EVAL      NoData = *ON
     C                   ENDIF
      *
     C     SRloadSflE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SrReset, SrBldSfl, SrLoadSfl, SrPrSfl, SrErrData      *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
      *
      * Reset the fields and the program message queue.
     C                   EXSR      SRReset
      *
     C                   SELECT
      *
      * When F3 is pressed (Exit).
     C                   WHEN      Exit = True
     C                   EVAL      EndPGMFlag = True
      *
     C                   LEAVESR
      *
      * When page down is pressed.
     C                   WHEN      Rollup = True
     C                   OTHER
      *
      * Process the subfile.
     C                   EXSR      SRPrSfl
      *
     C                   ENDSL
      *
     C     SRProcessE    ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrSfl - Process the Subfile                                *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: SRErrDta, SrView                                      *
      *                                                               *
      *****************************************************************
     C     SRPrSfl       BEGSR
      *
      * Check for last relative record number.
     C                   IF        WLstRrn > *ZEROS
      *
      * Reset error flag.
     C                   READC     UT000030S0
     C                   DOW       NOT %EOF
      *
     C                   SELECT
     C                   WHEN      D0OPTN = ACT_ENQ
     C                   EXSR      SrEnq
     C                   EVAL      UpdateOptn = True
      *
     C                   WHEN      D0OPTN = ACT_VIEW
     C                   EXSR      SrView
     C                   EVAL      UpdateOptn = True
      *
     C                   OTHER
     C                   IF        D0OPTN <> *BLANKS
     C                   EVAL      UpdateOptn = False
     C                   ELSE
     C                   EVAL      UpdateOptn = True
     C                   ENDIF
     C                   ENDSL
      *
     C                   IF        (UpdateOptn = True)
     C                   EVAL      ErrOptn = False
     C                   EVAL      D0OPTN = *BLANKS
     C                   WRITE     UT000030C1
     C                   UPDATE    UT000030S0
     C                   EXSR      SRReset
     C                   ELSE
     C                   EVAL      ErrOptn = True
     C                   EVAL      PZMsgId= 'USR9011'
     C                   EXSR      SRErrDta
     C                   WRITE     UT000030C1
     C                   UPDATE    UT000030S0
     C                   ENDIF
      *
     C                   READC     UT000030S0
      *
     C                   ENDDO
     C                   ENDIF
      *
     C     SRPrSflE      ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReset - Reset the Fields                                   *
      *                                                               *
      *  Called by: Various subroutines                               *
      *                                                               *
      *  Calls: EXTERNAL/ZA0250                                       *
      *                                                               *
      *****************************************************************
     C     SRReset       BEGSR
      *
      * Clear program queue and message file.
     C                   CALL      'ZA0250'
      *
     C                   EVAL      PZMsgId = *BLANKS
     C                   EVAL      PZMsgData = *BLANKS
      *
     C     SRResetE      ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrView - Calls valivation list entry maintenance program     *
      *                                                               *
      *  Called by: SRPrSfl                                           *
      *                                                               *
      *  Calls: EXTERNAL/UT000031                                     *
      *                                                               *
      *****************************************************************
     C     SRView        BEGSR
      *
     C                   CALL      'UT000031'
     C                   PARM                    D0OBNM
     C                   PARM                    D0LBNM
      *
     C     SRViewE       ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on Program Activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    InitLibl
      *
      * Populate workstation ID.
     C                   EVAL      Exit       = False
     C                   EVAL      EndPGMFlag = False
     C                   EVAL      D0WID = PSJobName
      *
      * Populate user.
     C                   EVAL      D0USER = PSUser
      *
      * Initialise subfile program queue and message file.
     C                   EVAL      D1PGMQ = '*'
      *
     C                   EVAL      D0LIBL = InitLibl
      * Message subfile indicator.
     C                   EVAL      *IN32 = *ON
      *
     C                   TIME                    TmStamp
     C                   MOVE      TmStamp       D0MRDT
      *
     C     INZSRE        ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically If a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
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
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrEnq - Enquire validation list field information.           *
      *                                                               *
      *  Called by: SRPrSfl                                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SREnq         BegSR
      *
     C/exec SQL
     C+ select
     C+   *
     C+ into
     C+   :VLDL
     C+ from UTVLDJW0
     C+ where
     C+     VLVLDL =  :D0OBNM
     C+ and VLDEL  <> 'Y'
     C/end-exec
     C                   If        SQLCODE = 0
     C                   Eval      D1OBNM = D0OBNM
     C                   Eval      D1IDTX = VLIDTX
     C                   Eval      D1IDLN = VLIDLE
     C                   Eval      D1ENLN = VLENLE
     C                   Eval      D1DSLN = VLDTLE
      *
     C                   Dow       Previous = False
     C                   Exfmt     UT000030W0
     C                   EndDo
     C                   Eval      Previous = False
     C                   EndIf
     C                   EndSr
      *****************************************************************
