     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Custom-defined data extract')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3634 - Custom-defined Data Extract                         *
      *                                                               *
      *  Function:  This program is used to display a list of SQL     *
      *  requests that have been defined in order to enhance          *
      *  existing extractions                                         *
      *                                                               *
      *  Called By: *NONE                                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 21Nov01               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG015 - Correspondence Manager                              *
      *                                                               *
      *****************************************************************
      * INDICATORS                                                    *
      * 30 - Handle screen field error                                *
      * 82 - SFLDSP                                                   *
      * 83 - SFLDSPCTL                                                *
      * 84 - SFLNXTCHG                                                *
      * 86 - SFLEND                                                   *
      * 87 - SFLCLR                                                   *
      * 88 - ROLLUP                                                   *
      * 90 - Work indicator                                           *
      *****************************************************************
     FCG3634DF  CF   E             WORKSTN
     F                                     SFILE(CG3634S0:LINE)
     F                                     INFSR(*PSSR)
      *
      ** User Defined SQL Requests
     FCGSQLRL1  UF   E           K DISK
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
 
      *
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Interface definitions for SendMsg, RtvMsgTxt
     D/COPY CGCPYSRC,CG3636D001
 
      ** Request Details
     DRequestDetails   PR          9999
     D ActionCode                     1    VALUE
     D RequestName                         VALUE LIKE(SQRQNM)
     D SchemaName                          VALUE LIKE(SQSHNM)
 
      ** Activate a request
     DActivateRequest  PR            10
     D RequestNm                           VALUE LIKE(SQRQNM)
     D SchemaNm                            VALUE LIKE(SQSHNM)
      *
 
      ** Standard Data Stucture when calling another transaction
     DTrnFeedBack      DS
     D ReturnedKey                    2
     D ReturnedErr                    7    DIM(10)
     D ReturnedDta                  256    DIM(10)
     D ErrorTypes                     1    DIM(10)
     D MessageFiles                  10    DIM(10)
     D ReturnedValues               256    DIM(50)
 
      ** Message identifier
     DMessageId        S              7
      ** Msg data
     DMsgData          S            244
      ** Msg data 2
     DMsgData2         S            256
      ** Refresh list ?
     DRefreshList      S              1
      ** End Program ?
     DEndProgram       S              1
      ** Query request ?
     DQueryRequest     S              1
      ** Record selected ?
     DRecSelected      S              1
      ** Position of question mark
     DIdxQstnMrk       S              3  0
      ** Number of valid selections like A E D
     DNbActAED         S              3  0
      ** Number of valid selections like X
     DNbActX           S              3  0
      ** Line number written in the sub file
     DLineWritten      S              5  0
      *****************************************************************
      *
     C                   EXSR      InitProg
     C                   IF        ReturnCode = *BLANK
     C                   EXSR      Main
     C                   ENDIF
      *
     C                   SETON                                        LR
      *
      *****************************************************************
      * Initialize program                                            *
      *****************************************************************
     C     InitProg      BEGSR
     C                   EVAL      ReturnCode = *BLANK
     C                   EVAL      EndProgram = 'N'
      ** Screen variables
     C                   EVAL      SRUNA = AGMRDT
     C                   EVAL      SWSID = PsJobName
     C                   EVAL      SUSER = PSUser
      *
     C                   EXSR      EnableFlds
      *
     C                   EXSR      EnableFuncKey
      *
     C                   ENDSR
      *****************************************************************
      * Main                                                          *
      *****************************************************************
     C     Main          BEGSR
      *
     C                   DOU       EndProgram = 'Y'
     C                   EXSR      DisplayList
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      * Display the list                                              *
      *****************************************************************
     C     DisplayList   BEGSR
     C                   EXSR      InitSubFile
     C                   EXSR      PosSubFile
      *
     C                   DOW       *IN86 <> '1'
     C                             AND *IN88 = '1'
      *
     C                   DO        12
     C                   EXSR      FillSubFile
     C                   IF        *IN86 = '1'
     C                   LEAVE
     C                   ENDIF
     C                   EXSR      WriteSubFile
     C                   ENDDO
      *
      ** Stay in the loop until
      ** F3 = Exit
      ** Rollup
      ** Initialisation is requested.
      ** End Transaction
     C                   DOU       *INKC = '1'
     C                             OR *IN88 = '1'
     C                             OR RefreshList = 'Y'
     C                             OR EndProgram = 'Y'
     C                   EXSR      ShowSubFile
     C                   IF        *INKL <> '1'
     C                             AND *INKC <> '1'
     C                             AND *IN88 <> '1'
      ** Determine whether we need to initialize the Sub File
     C                   EXSR      CheckRefresh
      *
     C                   IF        RefreshList = 'Y'
     C                   EXSR      InitSubFile
     C                   EXSR      PosSubFile
     C                   ELSE
      ** Validate list ?
     C                   IF        KeyPressed = *BLANK
     C                             AND LineWritten <> 0
     C                   EXSR      ValidateList
     C                   ENDIF
      ** Go to another transaction ?
     C                   IF        MessageId = *BLANK
     C                   EXSR      OtherProg
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      * Init Sub File Requested ?                                     *
      *****************************************************************
     C     CheckRefresh  BEGSR
     C     *LIKE         DEFINE    SSSHNM        MemSSHNM
     C     *LIKE         DEFINE    SSACTV        MemSACTV
     C     *LIKE         DEFINE    SPRQNM        MemPRQNM
     C                   EVAL      RefreshList = 'N'
      ** Criteria have changed ?
     C                   IF        SSSHNM <> MemSSHNM
     C                   EVAL      MemSSHNM = SSSHNM
     C                   EVAL      RefreshList = 'Y'
     C                   ENDIF
 
     C                   IF        SSACTV <> MemSACTV
     C                   EVAL      MemSACTV = SSACTV
     C                   EVAL      RefreshList = 'Y'
     C                   ENDIF
 
     C                   IF        SPRQNM <> MemPRQNM
     C                   EVAL      MemPRQNM = SPRQNM
     C                   EVAL      RefreshList = 'Y'
     C                   ENDIF
 
      ** F5 Pressed ?
     C                   IF        *INKE = '1'
     C                   EVAL      RefreshList = 'Y'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * Init the sub file                                             *
      *****************************************************************
     C     InitSubFile   BEGSR
      *
     C                   EVAL      LineWritten = 0
      ** Clear Sub File
     C                   SETON                                        87
     C                   SETOFF                                       8283
     C                   WRITE     CG3634C0
     C                   SETOFF                                       87
     C                   SETON                                        8283
      *
      ** Force entry into the main loop in S/R LIST
     C                   SETON                                        88
     C                   SETOFF                                       86
     C                   ENDSR
      *****************************************************************
      * Write sub file line                                           *
      *****************************************************************
     C     WriteSubFile  BEGSR
      *
     C     KeyPTYPL0     KLIST
     C                   KFLD                    PrtItm           10
     C                   KFLD                    PrtSub           10
      *
     C     *LIKE         DEFINE    LineWritten   LINE
     C                   EVAL      LineWritten = LineWritten + 1
      ** Overwrite LINE as it can be changed by a READC
     C                   EVAL      LINE = LineWritten
      ** Page to be displayed
     C                   EVAL      RECNS0 = LineWritten
      ** Reset all error indicators associated with Sub file fields
     C                   SETOFF                                       30
      ** Map information related to sub file field
     C                   EVAL      SOPTN = *BLANK
     C                   EVAL      SRQNM = SQRQNM
     C                   EVAL      SSHNM = SQSHNM
     C                   EVAL      SACTV = SQACTV
     C                   EVAL      SRQDS = SQRQDS
      *
     C                   WRITE     CG3634S0
      *
     C                   ENDSR
      *****************************************************************
      * Setll a record from a file                                    *
      *****************************************************************
     C     PosSubFile    BEGSR
      *
     C     *LIKE         DEFINE    SQRQNM        RequestName
     C     *LIKE         DEFINE    SQSHNM        SchemaName
      *
     C     KeySQLRL0     KLIST
     C                   KFLD                    RequestName
      *
      ** This subroutine is used to position the reading pointer
      ** on a particular record, according to the screen criteria Sxxxx
      ** entered.
      *
     C                   EVAL      RequestName = SPRQNM
     C     KeySQLRL0     SETLL     CGSQLRL1
      *
     C                   ENDSR
      *****************************************************************
      * Read a record from the file                                   *
      *****************************************************************
     C     FillSubFile   BEGSR
     C                   SELECT
      ** Position and no Selection
     C                   WHEN      SPRQNM <> *BLANK AND SSSHNM = *BLANK
     C                             AND SSACTV = *BLANK
     C                   READ      CGSQLRL1                               86
     C                   UNLOCK    CGSQLRL1
      ** Selection
     C                   WHEN      SSSHNM <> *BLANK OR SSACTV <> *BLANK
     C                   EVAL      RecSelected = 'N'
     C                   DOW       RecSelected = 'N' AND *IN86 = '0'
     C                   READ      CGSQLRL1                               86
     C                   UNLOCK    CGSQLRL1
     C                   IF        (SQSHNM = SSSHNM OR SSSHNM = *BLANK)
     C                             AND
     C                             (SQACTV = SSACTV OR SSACTV = *BLANK)
     C                   EVAL      RecSelected = 'Y'
     C                   ENDIF
     C                   ENDDO
     C
      ** Default : No Position and No Selection
     C                   OTHER
     C                   READ      CGSQLRL1                               86
     C                   UNLOCK    CGSQLRL1
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      * Show the sub file                                             *
      *****************************************************************
     C     ShowSubFile   BEGSR
      *
      ** Default screen values
     C                   EXSR      DefaultScr
      *
      ** Display the screen
     C                   IF        LineWritten <> 0
     C                   SETON                                        82
     C                   ELSE
     C                   SETOFF                                       82
     C                   ENDIF
     C                   WRITE     CG3634F1
     C                   WRITE     CG3634F0
     C                   WRITE     #MSGCTL
     C                   EXFMT     CG3634C0
      *
      ** Clear Message Q and highligthed fields
     C                   CALL      'ZA0250'
      ** Used as a flag to determine whether validation error occured
     C                   EVAL      MessageId = *BLANK
      *
      ** Determine which key has been pressed
     C                   SELECT
      ** F3 pressed
     C                   WHEN      *INKC = '1'
     C                   EVAL      EndProgram = 'Y'
     C                   EVAL      KeyPressed = '03'
      ** F5 pressed
     C                   WHEN      *INKE = '1'
     C                   EVAL      KeyPressed = '05'
      ** F9 pressed
     C                   WHEN      *INKI = '1'
     C                   EVAL      KeyPressed = '09'
      ** Enter pressed
     C                   OTHER
     C                   EVAL      KeyPressed = *BLANK
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      * Default screen values                                         *
      *****************************************************************
     C     DefaultScr    BEGSR
      ** No data to display
     C                   IF        LineWritten <> 0
     C                   EVAL      SBOTX = *BLANK
     C                   ELSE
      ** No data to display
     C                   EVAL      SBOTX = RtvMsgTxt('YYG0012':
     C                                MsgData:'Y2USRMSG')
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      * Validate list                                                 *
      *****************************************************************
     C     ValidateList  BEGSR
      ** Last line is used by OtherProg
     C     *LIKE         DEFINE    LINE          LastLine
     C                   EVAL      LastLine = 0
     C                   EVAL      RECNS0 = *LOVAL
      ** Help requested
     C                   EXSR      HelpReq
      *
     C                   EVAL      NbActAED = 0
     C                   EVAL      NbActX = 0
     C                   READC     CG3634S0                               90
     C                   DOW       *IN90 = '0'
     C                   EVAL      LastLine = Line
     C                   SETOFF                                       84
     C                   SETOFF                                       30
      *
      ** Action codes allowed are A, E, D, X
     C                   IF        SOPTN <> *BLANK
     C                   IF        SOPTN <> 'A' AND SOPTN <> 'E'
     C                             AND SOPTN <> 'X' AND SOPTN <> 'D'
     C                   EVAL      MessageId = 'SDM0048'
     C                   EVAL      MsgData2 = 'A' + 'E' + 'X' + 'D'
     C                   CALLP     SendMsg(MessageId:MsgData2:
     C                                    'SDUSRMSG':*BLANK)
     C                   SETON                                        30
     C                   ENDIF
      ** Mark the record as changed
     C                   SETON                                        84
     C                   ENDIF
      *
     C                   IF        SOPTN <> *BLANK
     C                   IF        SOPTN = 'A' OR SOPTN = 'E'
     C                             OR SOPTN = 'D'
     C                   EVAL      NbActAED = NbActAED + 1
     C                   ENDIF
     C                   IF        SOPTN = 'X'
     C                   EVAL      NbActX = NbActX + 1
     C                   ENDIF
     C                   ENDIF
      *
      ** Selections of type 'X' cannot be mixed with other selections
     C                   IF        SOPTN <> *BLANK
     C                   IF        SOPTN = 'X' AND NbActAED > 0
     C                             OR SOPTN = 'A' AND NbActX > 0
     C                   EVAL      MessageId = 'CGD2594'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                      *BLANK:*BLANK)
     C                   SETON                                        30
     C                   ENDIF
      ** Mark the record as changed
     C                   SETON                                        84
     C                   ENDIF
      *
      ** Here test all the PC RI indicators
     C                   IF        *IN30 = '1'
      ** Display the page where the first error occured
     C                   IF        RECNS0 = *LOVAL
     C                   EVAL      RECNS0 = LINE
     C                   ENDIF
     C                   ENDIF
      *
     C                   UPDATE    CG3634S0
     C                   READC     CG3634S0                               90
     C                   ENDDO
      ** No error found, display page 1
     C                   IF        RECNS0 = *LOVAL
     C                   EVAL      RECNS0 = 1
     C                   ENDIF
      *
     C     EXVSCR        ENDSR
      *****************************************************************
      * Other Programs need to be called                              *
      *****************************************************************
     C     OtherProg     BEGSR
     C     *LIKE         DEFINE    LastLine      ValidOpt
     C     *LIKE         DEFINE    LastLine      L
      ** Number of valid options entered
      ** to detect if enter has been pressed without any action
      ** on S/F records
     C                   EVAL      ValidOpt = 0
      *
      ** F9 pressed => Insert a Request
     C                   IF        *INKI = '1'
     C                   EVAL      TrnFeedBack = RequestDetails('I':
     C                              *BLANK:*BLANK)
     C                   IF        ReturnedKey = '03'
     C                   EVAL      KeyPressed = ReturnedKey
     C                   EVAL      EndProgram = 'Y'
     C                   ELSE
      ** Display page 1
     C                   EVAL      RefreshList = 'Y'
     C                   ENDIF
      ** Read list
     C                   ELSE
      *
     C                   IF        LastLine <> 0
     C                   EVAL      RECNS0 = *LOVAL
     C                   DO        LastLine      L
     C                   SETOFF                                       30
     C     L             CHAIN     CG3634S0                           90
      *
     C                   IF        SOPTN <> *BLANK
     C                   EVAL      ValidOpt = ValidOpt + 1
     C                   EVAL      SchemaName = SSHNM
     C                   EVAL      TrnFeedBack = RequestDetails(SOPTN:
     C                                 SRQNM:SSHNM)
      *
     C                   IF        ReturnedKey = '12'
     C                   EVAL      RefreshList = 'N'
     C                   SETON                                        30
     C                   UPDATE    CG3634S0
      ** Display the page where the first F12 has been pressed
     C                   IF        RECNS0 = *LOVAL
     C                   EVAL      RECNS0 = L
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        ReturnedKey = '03'
     C                   EVAL      KeyPressed = ReturnedKey
     C                   EVAL      EndProgram = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        ReturnedKey = '10'
     C                   EVAL      RefreshList = 'Y'
     C                   ENDIF
      *
     C                   IF        ReturnedErr(1) <> *BLANK
     C                   SETON                                        30
     C                   EVAL      MessageId = ReturnedErr(1)
     C                   EVAL      MsgData2 = ReturnedDta(1)
     C                   CALLP     SendMsg(MessageId:MsgData2:
     C                                     *BLANK:*BLANK)
      ** Display the page where the first error has occured
     C                   IF        RECNS0 = *LOVAL
     C                   EVAL      RECNS0 = L
     C                   ENDIF
      ** If request activated, remove the 'X' from the selection field
     C                   IF        MessageId = 'CGD2606'
     C                   EVAL      SACTV = 'Y'
     C                   EVAL      SOPTN = *BLANK
     C                   ENDIF
     C                   UPDATE    CG3634S0
     C                   ITER
     C                   ENDIF
      *
     C                   EVAL      SOPTN = *BLANK
     C                   UPDATE    CG3634S0
     C                   ENDIF
      *
     C                   ENDDO
      ** Display page 1
     C                   IF        RECNS0 = *LOVAL
     C                   EVAL      RECNS0 = 1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      * Enable Function Keys                                          *
      *****************************************************************
     C     EnableFuncKey BEGSR
      ** No function keys need to be enabled
     C                   ENDSR
      *****************************************************************
      * Enable Fields                                                 *
      *****************************************************************
     C     EnableFlds    BEGSR
      ** No fields need to be enabled
     C                   ENDSR
      *****************************************************************
      * Help Requested                                                *
      *****************************************************************
     C     HelpReq       BEGSR
      ** XXXXXX serve as an example
     C                   MOVEL     *BLANK        XXXXXX           10
      ** Flag set to Y if '?' entered somewhere on the screen
     C                   EVAL      QueryRequest = 'N'
     C                   EVAL      IdxQstnMrk = %SCAN('?':XXXXXX)
     C                   IF        IdxQstnMrk <> 0
     C                   EVAL      QueryRequest = 'Y'
     C                   ENDIF
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ***************
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ******************
      *
     C                   CALL      'DBERRCTL'
      *
      ********************************************************************
     C                   END
      *
      ************ END PROGRAM IF DBERRCTL NOT CALLED ********************
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      **********************************************************************
      * INITIALISATION SUBROUTINE
      **********************************************************************
     C     *INZSR        BEGSR
     C     *LIKE         DEFINE    SSHNM         SchemaName
      *
     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode       10
      ** Key Pressed (output)
     C                   PARM                    KeyPressed        2
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   END
 
     C                   EVAL      ##PGM = PSProcName
 
     C                   ENDSR
      ********************************************************************  **
      * Request Details                                                  *
      ********************************************************************  **
     PRequestDetails   B
     DRequestDetails   PI          9999
     DActionCode                      1    VALUE
     DRequestName                          VALUE LIKE(SQRQNM)
     DSchemaName                           VALUE LIKE(SQSHNM)
      *
     DFeedBack         DS
     D ReturnedKey                    2
     D ReturnedErr                    7    DIM(10)
     D ReturnedDta                  256    DIM(10)
     D ErrorTypes                     1    DIM(10)
     D MessageFiles                  10    DIM(10)
     D ReturnedValues               256    DIM(50)
      *
     DReturnCode       S             10
     DErrorData        S            256
     DKeyPressed       S              2
     DSourceFile       S             10
     DRequestMbr       S             10
     DSyntaxCheck      S              1
      *
     C     KeySQLRL1     KLIST
     C                   KFLD                    RequestName
     C                   KFLD                    SchemaName
      *
      ** Not a request activation : display the request editor
     C                   IF        ActionCode <> 'X'
     C                   CALLB     'CG3635'
     C                   PARM                    ReturnCode
     C                   PARM                    ErrorData
     C                   PARM                    ActionCode
     C                   PARM                    SchemaName
     C                   PARM                    RequestName
     C                   PARM                    KeyPressed
     C                   EVAL      ReturnedKey = KeyPressed
     C                   EVAL      ReturnedErr(1) = ReturnCode
     C                   EVAL      ReturnedDta(1) = ErrorData
     C                   ELSE
      ** Request activation
      ** Get the member that contains the SQL statements
     C     KeySQLRL1     CHAIN     CGSQLRL1
     C                   UNLOCK    CGSQLRL1
     C                   IF        NOT %FOUND(CGSQLRL1)
     C                   EVAL      ReturnedErr(1) = 'CGD2601'
     C                   ELSE
     C                   EVAL      RequestMbr = SQMBNM
     C                   CALL      'CGC3601'
     C                   PARM                    ReturnCode
     C                   PARM      'CGSQLTXT'    SourceFile
     C                   PARM                    RequestMbr
     C                   PARM      'N'           SyntaxCheck
 
     C                   SELECT
      ** This request cannot be checked
     C                   WHEN      ReturnCode = '*ERROR'
     C                   EVAL      ReturnedErr(1) = 'CGD2604'
     C                   WHEN      ReturnCode = '*SQLFAIL'
     C                   EVAL      ReturnedErr(1) = 'CGD2608'
     C                   OTHER
     C                   EVAL      ReturnedErr(1) =
     C                              ActivateRequest(RequestName:SchemaName)
     C                   ENDSL
 
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN    FeedBack
     P                 E
      ********************************************************************  **
      * Activate the request                                             *
      ********************************************************************  **
     PActivateRequest  B
     DActivateRequest  PI            10
     DRequestName                          VALUE LIKE(SQRQNM)
     DSchemaName                           VALUE LIKE(SQSHNM)
      *
     DReturnCode       S             10
      *
     C     KeySQLRL1     KLIST
     C                   KFLD                    RequestName
     C                   KFLD                    SchemaName
     C     KeySQLRL1     CHAIN     CGSQLRL1
     C                   IF        NOT %FOUND(CGSQLRL1)
     C                   EVAL      ReturnCode = 'CGD2601'
     C                   ELSE
     C                   EVAL      SQACTV = 'Y'
     C                   UPDATE(E) CGSQLRD0
      ** Request no longer exists or amended by another user
     C                   IF        %ERROR
     C                   EVAL      ReturnCode = 'CGD2596'
     C                   ELSE
      ** Request activated
     C                   EVAL      ReturnCode = 'CGD2606'
     C                   ENDIF
     C                   ENDIF
      *
     C                   RETURN    ReturnCode
      *
     P                 E
 
      ** Procedures SendMsg, RtvMsgTxt
     D/COPY CGCPYSRC,CG3636P001
