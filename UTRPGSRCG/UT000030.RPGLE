      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Validation List Objects Maintenance')         *
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
      *  Last Amend No. BUG28082           Date 31Aug10               *
      *  Prev Amend No. BUG27989A          Date 12Aug10               *
      *                 BUG27989*CREATE    Date 08Aug10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG28082 - Unable to display the correct information in the  *
      *             screen. (Recompile)                               *
      *  BUG27989A - Include validity checker and panel group         *
      *  BUG27989 - HATS should run with/without LDAP                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRBldSfl - Build the Subfile                                 *
      *  SRCheckLIB - Verify if a library exist                       *
      *  SRClrSfl - Clear the Subfile                                 *
      *  SrCommand - Execute CL Command                               *
      *  SRDspSfl - Display the Subfile                               *
      *  SRErrDta - Output Error Message With Data                    *
      *  SRloadSfl - Load the Subfile                                 *
      *  SRPopulate - Populate UTVLLOPD table with validation list    *
      *               objects                                         *
      *  SRProcess - Process the Subfile                              *
      *  SRPrSfl - Process the Subfile                                *
      *  SRRefresh - Refresh subfile entries                          *
      *  SRReset - Reset the Fields                                   *
      *  SrView - Calls valivation list entry maintenance program     *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Validation List Objects Maintenance File
     FUT000030DFCF   E             WORKSTN SFILE(UT000030S0:RRN0)
 
      ** Validation List Objects Output File (DSPOBJ)
     FUTVLLOL0  IF   E           K DISK
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     DPSDS            SDS
     D PSExcpType             40     42
      **  Exception number
     D PSExcpNo               43     46
      **  Program library
      ** Job name
     D PSJobName             244    253
      ** User name
     D PSUser                254    263
 
      ** Source file library
     D PSSrcLib              314    323
 
      ** Source file member
     D PSSrcMbr              324    333
 
      ** Program containing procedure
     D PSProcPgm             334    343
 
      ** Module containing procedure
     D PSProcMod             344    353
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Action Codes
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
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Indicator Data Structure
     D Indicators      DS                  BASED(IndPointer)
     D  Exit                  03     03
     D  Refresh               05     05
     D  F12                   12     12
     D  RollUp                27     27
     D  SflDsp                30     30
     D  SflClr                31     31
     D  SflEnd                33     33
     D  NoData                20     20
     D  ActnErr               35     35
     D  ErrLibl               47     47
     D  ErrOptn               48     48
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D IndPointer      S               *   Inz(%Addr(*in))
 
     D EndPGMFlag      S              1A
     D RRN0            S              4  0
     D UpdateOptn      S              1N
     D WCtr            S              2  0
     D WLstRrn         S              4  0
     D WRun            S              1A
      *
      ** Parameter for ZA0350
     D PZMsgFile       S             10A   INZ('UTMSGF')
     D PZMsgId         S             10A
     D PZMsgData       S             45A
      *
     D   MessageID     S              7A   INZ(*BLANKS)
     D   CommandStr    S            200A   INZ(*BLANKS)
      *
     D CommandLen      S             15  5
     D TmStamp         S             14  0
 
     D InitLibl        S             10A                                                   BUG27989A
                                                                                           BUG27989A
      *****************************************************************
      /EJECT
      *****************************************************************
      ** MAIN - Processing
      *****************************************************************
      *
      ** Build The Subfile
      *
     C                   EVAL      ##OBNM = *BLANKS
     C                   EVAL      ##OBTX = *BLANKS
     C                   EVAL      ##LBNM = *BLANKS
     C                   EXSR      SRBldSfl
      *
      ** Display the Screen Until F12 or F3 Is Pressed
      *
     C                   DOW       (Exit = False) AND
     C                             (EndPGMFlag = False)
 
     C                   EVAL      ##OPTN = *BLANKS
      *
      ** Display And Process the Subfile
      *
     C                   EXSR      SRDspSfl
      *
      ** Process the Subfile
      *
     C                   EXSR      SRProcess
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl - Build the Subfile                                 *
      *                                                               *
      *  Called by: Main Processing, SrRefresh, SrProcess             *
      *                                                               *
      *  Calls: SRClrSfl, SRLoadSfl                                   *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR
      *
      ** Clear the Subfile
      *
     C                   EXSR      SRClrSfl
      *
      ** Load the Subfile
      *
     C                   EXSR      SRLoadSfl
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCheckLib - Verify if a library exist                       *
      *                                                               *
      *  Called by: SrProcess                                         *
      *                                                               *
      *  Calls: QCMD/CHKOBJ                                           *
      *                                                               *
      *****************************************************************
     C     SRCheckLib    BEGSR
      *                                                                                    BUG27989A
     C                   EVAL      MessageID = *BLANKS                                     BUG27989A
     C                   IF        #1LIBL = '*LIBL' OR                                     BUG27989A
     C                             #1LIBL = '*USRLIBL' OR                                  BUG27989A
     C                             #1LIBL = '*CURLIB'                                      BUG27989A
     C                   LEAVESR                                                           BUG27989A
     C                   ENDIF                                                             BUG27989A
      *                                                                                    BUG27989A
     C                   EVAL      CommandStr = 'CHKOBJ OBJ('+
     C                             %TRIM(#1LIBL)  + ')'  +
     C                             ' OBJTYPE(*LIB)'
     C                   EXSR      SrCommand
     C                   ENDSR
      *****************************************************************
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
     C     *LOVAL        SETLL     UTVLLOL0
      *
      ** Reset the Fields and the Program Message Queue
      *
     C                   EXSR      SRReset
      *
      ** Intialise Fields
      *
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
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCommand - Execute CL Command                               *
      *                                                               *
      *  Called by: SrCheckLib, SrPopulate                            *
      *                                                               *
      *  Calls: QCMDEXC                                               *
      *                                                               *
      *****************************************************************
     C     SrCommand     BEGSR
     C                   EVAL      MessageID = *BLANKS
     C                   EVAL      CommandLen = 200
     C                   CALL  (E) 'QCMDEXC'
     C                   PARM                    CommandStr
     C                   PARM                    CommandLen
     C                   IF        %ERROR
     C                   EVAL      MessageID = PSExcpType +
     C                             PSExcpNo
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
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
     C                   TIME                    D0TIME
      *
      ** Write the Footer
      *
     C                   WRITE     UT000030F0
      *
      ** Write the Message Subfile Control Format
      *
     C                   WRITE     UT000030C1
      *
      ** Display the Subfile
      *
     C                   IF        NoData = False
     C                   EXFMT     UT000030C0
     C                   ELSE
     C                   EXFMT     UT000030C2
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
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
     C                   ENDSR
      *****************************************************************
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
      ** Intialise Filter Flags - No Search Criteria
      ** If Relative Record Number of the Last Record Loaded in the
      ** Subfile is Greater than Zero
      *
     C                   IF        WLstRrn > *ZEROS
      *
     C                   EVAL      RRN0  = WLstRrn
     C                   EVAL      WLstRrn = D0SFRN
      *
     C                   ENDIF
      *
      ** Reset Counter
      *
     C                   EVAL      WCtr = 0
      *
      ** Loading Records to Subfile
      *
     C                   DoW       WCtr < SflPag AND
     C                             NOT %EOF(UTVLLOL0)
      *
      ** Read the Database File
      *
     C                   READ      UTVLLOL0
      *
     C                   IF        %EOF(UTVLLOL0)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        NOT %EOF(UTVLLOL0)
      *
     C                   EVAL      ##OBNM = ODOBNM
     C                   EVAL      ##OBTX = ODOBTX
     C                   EVAL      ##LBNM = ODLBNM
      *
      ** WRITE the SELECTed Records
      *
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
      ** If Last Record, Turn on the 'SFLEND' indicator
      *
     C                   READ      UTVLLOL0
     C                   IF        %EOF(UTVLLOL0)
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   READP     UTVLLOL0
     C                   EVAL      SflEnd = *OFF
     C                   ENDIF
     C                   EVAL      WLstRrn = D0SFRN
      *
      ** Check If Records Were Written into the Subfile
      *
     C                   IF        WLstRrn <> *ZEROS
     C                   EVAL      SflDsp = *ON
     C                   ELSE
      *
      ** If No Records Exists, then show 'No Data to Display' Message
      *
     C                   EVAL      SflDsp = *OFF
     C                   EVAL      NoData = *ON
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C     SRPopulate    BEGSR
      *
     C                   CLOSE     UTVLLOL0
     C                   EVAL      CommandStr = 'CLRPFM UTVLLOPD'
     C                   EXSR      SrCommand
      *
     C                   IF        MessageId = *BLANKS
     C                   EVAL      CommandStr = 'QSYS/DSPOBJD OBJ('+
     C                             %TRIM(#1LIBL)+'/*ALL) ' +
     C                             'OBJTYPE(*VLDL) OUTPUT(*OUTFILE) ' +
     C                             'OUTFILE(QTEMP/VLDLPF)'
     C                   EXSR      SrCommand
     C                   ENDIF
      *
     C                   IF        MessageId = *BLANKS
     C                   EVAL      CommandStr = 'CPYF FROMFILE(QTEMP/VLDLPF) ' +
     C                             'TOFILE(*LIBL/UTVLLOPD) MBROPT(*REPLACE) ' +
     C                             'FMTOPT(*MAP *DROP) '
     C                   EXSR      SrCommand
     C                   ENDIF
     C                   OPEN      UTVLLOL0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SrReset, SrBldSfl, SrLoadSfl, SrPrSfl, SrPopulate,    *
      *         SrErrData                                             *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
      *
      ** Reset the Fields and the Program Message Queue
      *
     C                   EXSR      SRReset
      *
     C                   IF        #1LIBL = *BLANKS
     C                   EVAL      #1LIBL = #1HLIBL
     C                   EVAL      ErrLibl = False
     C                   ENDIF
      *
     C                   IF        (#1HLIBL <> #1LIBL)
     C**********         IF        #1LIBL <> '*LIBL'                                       BUG27989A
     C                   EXSR      SrCheckLIB
     C**********         ENDIF                                                             BUG27989A
     C                   IF        MessageID = *BLANKS
     C                   EXSR      SrReset
     C                   EVAL      #1HLIBL = #1LIBL
     C                   EXSR      SrPopulate
     C                   EXSR      SrRefresh
     C                   EVAL      ErrLibl = False
     C                   ELSE
     C                   EVAL      ErrLibl = True
     C                   EVAL      PZMsgId= 'USR9012'
     C                   EXSR      SRErrDta
     C                   WRITE     UT000030C1
     C                   ENDIF
     C                   ENDIF
      *
     C                   SELECT
      *
      ** When F3 Is Pressed (Exit)
      *
     C                   WHEN      Exit = True
     C                   EVAL      EndPGMFlag = True
      *
     C                   LEAVESR
      *
      ** When F5 Is Pressed (Refresh)
      ** Reset and Build
      *
     C                   WHEN      Refresh = True
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
      *
      ** When Page Down Is Pressed
      *
     C                   WHEN      Rollup = True
     C                   OTHER
      *
      ** Process the Subfile
      *
     C                   EXSR      SRPrSfl
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
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
     C                   IF        ErrLibl = True
     C                   LEAVESR
     C                   ENDIF
      *
      ** Check For Last Relative Record Number
      *
     C                   IF        WLstRrn > *ZEROS
      *
      ** Reset Error Flag
      *
     C                   READC     UT000030S0
     C                   DOW       NOT %EOF
      *
     C                   SELECT
     C                   WHEN      ##OPTN = ACT_VIEW
     C                   EXSR      SrView
     C                   EVAL      UpdateOptn = True
      *
     C                   OTHER
     C                   IF        ##OPTN <> *BLANKS
     C                   EVAL      UpdateOptn = False
     C                   ELSE
     C                   EVAL      UpdateOptn = True
     C                   ENDIF
     C                   ENDSL
      *
     C                   IF        (UpdateOptn = True)
     C                   EVAL      ErrOptn = False
     C                   EVAL      ##OPTN = *BLANKS
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
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRefresh - Refresh subfile entries                          *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: SrReset, SrBldSfl                                     *
      *                                                               *
      *****************************************************************
     C     SRRefresh     BEGSR
     C                   EVAL      ##OPTN = *BLANKS
     C                   EXSR      SrReset
     C                   EXSR      SrBldSfl
     C                   ENDSR
      *****************************************************************
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
      ** Clear Program Queue And Message File
      *
     C                   CALL      'ZA0250'
      *
     C                   EVAL      PZMsgId = *BLANKS
     C                   EVAL      PZMsgData = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
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
     C                   IF        ErrLibl = False
     C                   CALL      'UT000031'
     C                   PARM                    ##OBNM
     C                   PARM                    ##LBNM
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
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
      *                                                                                    BUG27989A
     C     *ENTRY        PLIST                                                             BUG27989A
     C                   PARM                    InitLibl                                  BUG27989A
      *
      ** Populate WorkStation ID
      *
     C                   EVAL      Exit       = False
     C                   EVAL      EndPGMFlag = False
     C                   EVAL      D0WID = PSJobName
      *
      ** Populate User
      *
     C                   EVAL      D0USER = PSUser
      *
      ** Initialise Subfile Program Queue and Message File
      *
     C                   EVAL      D1PGMQ = '*'
      *
      ** Message Subfile Indicator
      *
     C**********         EVAL      #1LIBL = '*LIBL'                                        BUG27989A
     C                   EVAL      #1LIBL = InitLibl                                       BUG27989A
     C**********         EVAL      #1HLIBL = #1LIBL                                        BUG27989A
     C                   EVAL      #1HLIBL = InitLibl                                      BUG27989A
     C                   EVAL      *IN32 = *ON
      *
     C                   TIME                    TmStamp
     C                   MOVE      TmStamp       D0MRDT
      *
     C                   ENDSR
      *****************************************************************
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
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
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
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2010
