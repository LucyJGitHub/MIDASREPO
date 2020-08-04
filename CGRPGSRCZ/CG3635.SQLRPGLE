     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD054955
/*STD *  RPGSQLMOD                                                    *                     MD054955
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD054955
/*EXI *  TEXT('Midas CG SQL request editor')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3635 - Edit SQL requests                                   *
      *                                                               *
      *  Function:  This program is used to edit an SQL request       *
      *                                                               *
      *  Called By: *NONE                                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD054955           Date 16Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015  *CREATE    Date 21Nov01               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG015 - Correspondence Manager                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    50         For CGSQLTXT reading                            *
      *    51         Sflclr SF1                                      *
      *    52         Sfldsp SF1                                      *
      *    53         Sflnxtchg SF1                                   *
      *    54         Sfl INZ SF1                                     *
      *    55         Sfldspctl SF1                                   *
      *    56         Readc SF1                                       *
      *    57         I/O Ordinary files                              *
      *    60-62      Screen fields error                             *
      *    64         Enquire mode                                    *
      *    65         Delete mode                                     *
      *    66         Position cursor                                 *
      *    67         Protect header fields                           *
      *    68         Protect list fields                             *
      *    69         I/O Error ordinary files                        *
      *                                                               *
      *****************************************************************
     FCG3635DF  CF   E             WORKSTN
     F                                     SFILE(CG3635S0:LINE)
     F                                     INFSR(*PSSR)
      *
      ** Conversion file
     F*CGRDECL1* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(*PSSR)                                     MD054955
      *
      ** SQL scripts
     FCGSQLTXT  UF A E           K DISK    USROPN
     F                                     RENAME(CGSQLTXT:CGSQTXD0)
      *
      ** UDC User defined SQL request
     FCGSQLRL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
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

      ** Interface definitions for SendMsg, RtvMsgTxt
     D/COPY CGCPYSRC,CG3636D001

      ** Format line to override a file member
     DOvrFilMbr        PR            80
     D FileNm                        10    VALUE
     D FileMb                        10    VALUE

      ** Get SQL statements
     DgetStatements    PR            60    DIM(30)
     D StmtI                               LIKE(SQMBNM) VALUE

      ** Write SQL statements
     DWrtSQLStmt       PR            10
     D StmtLst                       60    DIM(30) VALUE
     D StmtId2                             LIKE(SQMBNM) VALUE

      ** Delete SQL statements
     DDelSQLStmt       PR            10
     D StmtId3                             LIKE(SQMBNM) VALUE

      ** Determines the index of the last statement
     DLastStatement    PR             3  0
     D StmtLst2                      60    DIM(30) VALUE

      ** List of the schemas
     DSchemasList      PR          9999

      ** Get statement identifier
     DgetStmtId        PR            10

      ** Remove member
     DRmvMember        PR            10
     D StmtId4                             LIKE(SQMBNM) VALUE

      ** Add member
     DAddMember        PR            10
     D StmtId5                             LIKE(SQMBNM) VALUE

      ** Syntax check
     DSyntaxCheck      PR          9999
     D StmtLst3                      60    DIM(30) VALUE

      *
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)

      ** Standard Data Stucture when calling another transaction
     DTrnFeedBack      DS
     D ReturnedKey                    2
     D ReturnedErr                    7    DIM(10)
     D ReturnedDta                  256    DIM(10)
     D ErrorTypes                     1    DIM(10)
     D MessageFiles                  10    DIM(10)
     D ReturnedValues               256    DIM(50)
      *
      ** Message Identifier
     DMessageId        S              7
      *
      ** Line
     DLINE             S              5  0
      ** Msg data 2
     DMsgData2         S            256
      *
      ** Query request ?
     DQueryRequest     S              1
      *
      ** Insert mode ?
     DInsertMode       S              1
      *
      ** End Program ?
     DEndProgram       S              1
      *
      ** Update error ?
     DUpdateError      S              1
      *
      ** SQL Statements
     DStatements       S             60    DIM(30)
     DOptions          S              1    DIM(30)
      *
      ** Index for Statements array
     Ds                S              3  0
      *
      ** To hold position of question mark
     DIdxQstnMrk       S              3  0
      *
      ** To hold position of the selection 'I'
      ** in the list
     DPosInsert        S              3  0
      *
      ** Number of valid options entered
     DValidOption      S              3  0
      *
      ** Maximum number of lines that can be written
     DLinesMax         S              3  0
      *
      ** Statement identifier
     DStatementId      S                   LIKE(SQMBNM)
      *
      ** Request activated ?
     DActivated        S              1
      *
      ** Warning generated in case of no statements ?
     DNoStmtWarning    S              1
      *
      ** SQL statement entered ?
     DLineFilled       S              1
      ** Line modified ?
     DLineChanged      S              1
     D CGRDEC        E DS                  EXTNAME(CGRDEJW0)                                MD054955
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *****************************************************************
      *
     C                   EXSR      InitProg
     C                   IF        ReturnCode = *BLANK
     C                   EXSR      Main
     C                   ENDIF
      *
     C                   SETON                                        LR
      *****************************************************************
      * Main                                                          *
      *****************************************************************
     C     Main          BEGSR
      *
     C                   DOU       EndProgram = 'Y'
      ** If the header fields are not protected process transaction
      ** management for the header fields
     C                   IF        *IN67 = '1'
     C                   EXSR      ListMgmt
     C                   ELSE
     C                   EXSR      HeaderMgmt
     C                   ENDIF
      *
     C                   ENDDO
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
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      ************ CALL DBERRCTL IF INTERACTIVE PROGRAM ******************
      *
     C                   CALLB     'DBERRCTL'
      *
      ********************************************************************
     C                   ENDIF
      *
      ************ END PROGRAM IF DBERRCTL NOT CALLED ********************
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *LIKE         DEFINE    SQSHNM        SchemaName
     C     *LIKE         DEFINE    SQRQNM        RequestName

     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode       10
     C                   PARM                    ErrorData       256
      ** Action code (input)
      ** - E: enquire
      ** - A: amend
      ** - D: delete
      ** - I: insert
     C                   PARM                    ActionCode        1
      ** Schema Name (input)
     C                   PARM                    SchemaName
      ** Request Name (input)
     C                   PARM                    RequestName
      ** Key Pressed (output)
     C                   PARM                    KeyPressed        2

     C                   SETON                                        25

      ** Read in Installation Data
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
     C     AGDFF         IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
     C                   EVAL      ##PGM = PSProcName

     C                   ENDSR
      *****************************************************************
      * Header Management                                             *
      *****************************************************************
     C     HeaderMgmt    BEGSR
     C                   EXSR      DisplayHeader
      *
     C                   EXSR      HelpReq
     C                   IF        QueryRequest = 'Y'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        KeyPressed = *BLANK
     C                   EXSR      ValidateHeader
     C                   ENDIF
      *
     C                   IF        MessageId = *BLANK
     C                   EXSR      InzList
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * Display Header                                                *
      *****************************************************************
     C     DisplayHeader BEGSR
      *
     C                   WRITE     CG3635F1
     C                   WRITE     #MSGCTL
     C                   WRITE     CG3635F0
     C                   EXFMT     CG3635C0
      *
      ** Clear Message Q and highligthed fields
     C                   CALL      'ZA0250'
      ** Used as a flag to determine whether validation error occured
     C                   EVAL      MessageId = *BLANK
     C                   EXSR      ResetHdrErrors
      *
      ** Determine which key has been pressed
     C                   SELECT
      ** F3 pressed
     C                   WHEN      *INKC = '1'
     C                   EVAL      EndProgram = 'Y'
     C                   EVAL      KeyPressed = '03'
      ** F12 pressed
     C                   WHEN      *INKL = '1'
     C                   EVAL      EndProgram = 'Y'
     C                   EVAL      KeyPressed = '12'
      ** Enter pressed
     C                   OTHER
     C                   EVAL      KeyPressed = *BLANK
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      * Validate Header                                               *
      *****************************************************************
     C     ValidateHeaderBEGSR
     C     *LIKE         DEFINE    CGNWFD        CnvName
     C     *LIKE         DEFINE    CGTYPE        CnvType
      *
     C     KeyRDECL0     KLIST
     C                   KFLD                    CnvName
     C                   KFLD                    CnvType
      *
      ** Request Name is mandatory
     C                   IF        SRQNM = *BLANK
     C                   EVAL      MessageId = 'SDM0012'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    'SDUSRMSG':*BLANK)
     C                   SETON                                        62
     C                   ENDIF
      *
      ** Request must be unique within the schema
     C                   IF        SRQNM <> *BLANK
     C                   EVAL      SchemaName = SSHNM
     C                   EVAL      RequestName = SRQNM
     C     KeySQLRL0     SETLL     CGSQLRL0
     C                   IF        %EQUAL
     C                   EVAL      MessageId = 'CGD2598'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    *BLANK:*BLANK)
     C                   SETON                                        62
     C                   ENDIF
     C                   ENDIF
      *
      ** Schema name is mandatory
     C                   IF        SSHNM = *BLANK
     C                   EVAL      MessageId = 'SDM0012'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    'SDUSRMSG':*BLANK)
     C                   SETON                                        60
     C                   ENDIF
      *
      ** Schema name must exists
     C                   IF        SSHNM <> *BLANK
     C                   EVAL      CnvName = SSHNM
     C                   EVAL      CnvType = 'REFR'
     C*****KeyRDECL0     SETLL     CGRDECL1                                                 MD054955
     C**********         IF        NOT %EQUAL                                               MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRDEC                                                                        MD054955
     C+ from CGRDEJW0                                                                       MD054955
     C+ where CGNWFD = :CnvName and CGTYPE = :CnvType                                       MD054955
     C/END-EXEC                                                                             MD054955
     C                   IF        SQLCODE = 100                                            MD054955
     C                   EVAL      MessageId = 'CGD2599'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    *BLANK:*BLANK)
     C                   SETON                                        60
     C                   ENDIF
     C                   ENDIF
      *
      ** Description is mandatory
     C                   IF        SRQDS = *BLANK
     C                   EVAL      MessageId = 'SDM0012'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    'SDUSRMSG':*BLANK)
     C                   SETON                                        63
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * Reset errors in the header                                    *
      *****************************************************************
     C     ResetHdrErrorsBEGSR
     C                   SETOFF                                       62
     C                   SETOFF                                       60
     C                   SETOFF                                       63
     C                   ENDSR
      *****************************************************************
      * Inizialise variables for the list                             *
      *****************************************************************
     C     InzList       BEGSR
      ** Protect header fields in order to chain to the statements
      ** list transaction
     C                   SETON                                        67
      ** Fill SQL statements template
     C                   EXSR      FillTemplate
     C                   ENDSR
      *****************************************************************
      * List Management                                               *
      *****************************************************************
     C     ListMgmt      BEGSR
      *
     C                   EXSR      DisplayList
      *
     C                   EXSR      HelpReq
     C                   IF        QueryRequest = 'Y'
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        (KeyPressed = *BLANK OR
     C                             KeyPressed = '10') AND
     C                             (ActionCode = 'A' OR ActionCode = 'I')
     C                             AND LINE <> 0
     C                   EXSR      ValidateList
     C                   ENDIF
      *
     C                   IF        MessageId = *BLANK
     C                   EXSR      OtherProg
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      * Display the list                                              *
      *****************************************************************
     C     DisplayList   BEGSR
     C                   EXSR      ShowSubFile
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
      ** F12 pressed
     C                   WHEN      *INKL = '1'
     C                   IF        ActionCode <> 'I'
     C                   EVAL      EndProgram = 'Y'
     C                   ELSE
      ** In insert mode return to header screen management
      ** (Enable header fields, hide subfile)
     C                   SETOFF                                       67
     C                   SETOFF                                       52
     C                   SETON                                        51
     C                   ENDIF
     C                   EVAL      KeyPressed = '12'
      ** F10 pressed
     C                   WHEN      *INKJ = '1'
     C                   EVAL      KeyPressed = '10'
      ** F13 pressed
     C                   WHEN      *INKM = '1'
     C                   EVAL      KeyPressed = '13'
      ** F14 pressed
     C                   WHEN      *INKN = '1'
     C                   EVAL      KeyPressed = '14'
      ** Enter pressed
     C                   OTHER
     C                   EVAL      KeyPressed = *BLANK
     C                   IF        ActionCode = 'E'
     C                   EVAL      EndProgram = 'Y'
     C                   ENDIF
      *
     C                   ENDSL
      *
      *
     C                   ENDSR
      *****************************************************************
      * Show the sub file                                             *
      *****************************************************************
     C     ShowSubFile   BEGSR
      *
      ** SFLDSP ON
     C                   SETON                                        52
      *
      ** If errors do not reinitialize the sub file
     C                   IF        MessageId <> *BLANK
      ** An error is generated but is not relevant to a particular
      ** line of the subfile => display the first page
     C                   IF        RECNS0 = *LOVAL
     C                   EVAL      RECNS0 = 1
     C                   ENDIF
     C                   WRITE     #MSGCTL
     C                   WRITE     CG3635F0
     C                   EXFMT     CG3635C0
     C                   LEAVESR
     C                   ENDIF
      *
      ** Case insert or empty records
      ** In insert mode a template is loaded
     C                   IF        ActionCode = 'I'
     C                             OR Statements(1) = *LOVAL
      *
      ** If SF1 empty in enquire mode don't display the lines
     C                   IF        Statements(1) = *LOVAL
     C                   IF        ActionCode = 'E'
      ** SFLDSP OFF
     C                   SETOFF                                       52
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** SFLCLR
     C                   SETON                                        51
     C                   WRITE     CG3635C0
     C                   SETOFF                                       51
     C                   EVAL      LINE = 0
     C                   EVAL      s = 1
     C                   EVAL      *IN50 = s > %ELEM(Statements)
     C                                     OR
     C                                     s > LinesMax
     C                   DOW       *IN50 = '0'
      *
     C                   EVAL      LINE = LINE + 1
     C                   EVAL      RECNS0 = LINE
     C                   EXSR      FormatLine
     C                   WRITE     CG3635S0
      *
     C                   EVAL      s = s + 1
     C                   EVAL      *IN50 = s > %ELEM(Statements)
     C                                     OR
     C                                     s > LinesMax
     C                   ENDDO
     C                   EXSR      EmptyLines
      *
     C                   WRITE     CG3635F0
     C                   EXSR      FillSflRcdNbr
     C                   WRITE     #MSGCTL
     C                   EXFMT     CG3635C0
      *
     C                   ENDSR
      *****************************************************************
      * Fill SQL Template                                             *
      *****************************************************************
     C     FillTemplate  BEGSR
     C                   EVAL      Statements(1) = 'INSERT INTO CGUXMRPD'
     C                   EVAL      Statements(2) = 'SELECT ' + '''' +
     C                              %TRIMR(SSHNM) + '''' +
     C                             ' ,DEITEM, DEINCR,'
     C                   EVAL      Statements(3) = '£new element name?], ' +
     C                             '£join file?].£field1?],'
     C                   EVAL      Statements(4) = '£format type?], ' +
     C                             '£format qualifier?]'
     C                   EVAL      Statements(5) = 'FROM CGUXMRPD, ' +
     C                             '£join file?]'
     C                   EVAL      Statements(6) = 'WHERE DESHNM = ' +
     C                             '''' +  %TRIMR(SSHNM) + ''''
     C                   EVAL      Statements(7) = 'AND DENWRD = ' +
     C                             '£element name?]'
     C                   EVAL      Statements(8) = 'AND DERDEV = ' +
     C                             '£join file?].£field2]'
     C                   ENDSR
      *****************************************************************
      * Validate sub file records                                     *
      *****************************************************************
     C     ValidateList  BEGSR
      * Reset all the fields used for validation
     C                   EVAL      ValidOption = 0
     C                   EVAL      LineFilled = 'N'
     C                   EVAL      LineChanged = 'N'
      *
     C                   EVAL      RECNS0 = *LOVAL
     C                   READC     CG3635S0                               56
     C                   DOW       *IN56 = '0'

      ** General checks
     C                   EXSR      GeneralCheck
     C                   IF        MessageId <> *BLANK
      ** To display the right page in case of several errors
     C                   IF        RECNS0 = *LOVAL
     C                   EVAL      RECNS0 = LINE
     C                   ENDIF
     C                   ENDIF
      *
     C                   UPDATE    CG3635S0
     C                   READC     CG3635S0                               56
     C                   ENDDO
      *
      ** Warnings if no errors
     C                   IF        RECNS0 = *LOVAL
     C                   EXSR      Warnings
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * Warning processing                                            *
      *****************************************************************
     C     Warnings      BEGSR
      ** Reset all the warning flag if a line has been changed and no
      ** errors
     C                   IF        Linechanged = 'Y'
     C                   EVAL      NoStmtWarning = 'N'
     C                   ENDIF
      *
      ** Warning: This request has no SQL statements
     C                   IF        LastStatement(Statements) = 0
     C                             AND NoStmtWarning <> 'Y'
     C                             AND LineFilled <> 'Y'
     C                   EVAL      MessageId = 'CGD2607'
     C                   EVAL      NoStmtWarning = 'Y'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    *BLANK:*BLANK)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * Determine SFLRCDNBR                                           *
      *****************************************************************
     C     FillSflRcdNbr BEGSR
      *
      ** Display the page being modified
      ** First time: display the first page
     C                   IF        SCRLS0 = 0
     C                   EVAL      RECNS0 = 1
     C                   ELSE
      ** Lines being amended
     C                   IF        SCRLS0 <= LinesMax
     C                   EVAL      RECNS0 = SCRLS0
     C                   ELSE
      ** Case where all the page lines have been deleted
      ** Display the previous page
     C                   EVAL      RECNS0 = LinesMax
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      * Write empty lines                                             *
      *****************************************************************
     C     EmptyLines    BEGSR
      ** Fill the reminder with blank lines
     C                   DOW       LINE < LinesMax
     C                   EVAL      LINE = LINE + 1
     C                   EVAL      RECNS0 = LINE
     C                   EVAL      SOPTN = *BLANK
     C                   EVAL      SSTMT = *BLANK
     C                   WRITE     CG3635S0
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      * Database Updates                                              *
      *****************************************************************
     C     Updates       BEGSR
      *
     C                   EVAL      UpdateError = 'N'
      *
     C                   IF        ActionCode = 'A'
     C                             OR ActionCode = 'D'
     C                   EVAL      StatementId = SQMBNM
     C                   ELSE
     C                   EVAL      StatementId = getStmtId
     C                   IF        StatementId = *BLANK
     C                   EVAL      UpdateError = 'Y'
     C                   EVAL      MessageId = 'CGD2596'
     C                   CALLP     SendMsg(MessageId:MsgData2:
     C                                    *BLANK:*BLANK)
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *
      ** There is an update for the SQL statements (delete/replace)
      ** There is an update for the Request itself
      *
     C                   IF        ActionCode <> 'I'
     C                   IF        DelSQLStmt(StatementId)
     C                                  = '*ERROR'
     C                   EVAL      UpdateError = 'Y'
     C                   EVAL      MessageId = 'CGD2596'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    *BLANK:*BLANK)
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        ActionCode <> 'D'
     C                   IF        WrtSQLStmt(Statements:StatementId)
     C                                  = '*ERROR'
     C                   EVAL      UpdateError = 'Y'
     C                   EVAL      MessageId = 'CGD2596'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    *BLANK:*BLANK)
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *
     C                   SELECT
     C                   WHEN      ActionCode = 'I'
     C                   EXSR      InsertRequest
     C                   WHEN      ActionCode = 'A'
     C                   EXSR      AmendRequest
     C                   WHEN      ActionCode = 'D'
     C                   EXSR      DeleteRequest
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      * Format sub file header                                        *
      *****************************************************************
     C     FormatHeader  BEGSR
     C                   EVAL      SSHNM = SchemaName
     C                   EVAL      SRQNM = RequestName
     C                   EVAL      SRQDS = SQRQDS
     C                   ENDSR
      *****************************************************************
      * Format sub file line                                          *
      *****************************************************************
     C     FormatLine    BEGSR
     C                   EVAL      SOPTN = *BLANK
     C                   EVAL      SSTMT = Statements(s)
      ** Position cursor to the line that has been inserted/deleted
     C                   IF        Options(s) = 'D' OR
     C                             Options(s) = 'I'
     C                   EVAL      Options(s) = *BLANK
     C                   SETON                                        66
     C                   ELSE
     C                   SETOFF                                       66
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * General checks                                                *
      *****************************************************************
     C     GeneralCheck  BEGSR
     C                   SETOFF                                       61
     C                   SETOFF                                       53
      *
      ** Options allowed are 'I' and 'D'
     C                   IF        SOPTN <> *BLANK
     C                   IF        SOPTN <> 'I' AND SOPTN <> 'D'
     C                   EVAL      MessageId = 'SDM0048'
     C                   EVAL      MsgData2 = 'I' + 'D'
     C                   CALLP     SendMsg(MessageId:MsgData2:
     C                                    'SDUSRMSG':*BLANK)
     C                   SETON                                        61
     C                   ELSE
     C                   EVAL      ValidOption = ValidOption + 1
     C                   ENDIF
      ** Mark the record as changed
     C                   SETON                                        53
     C                   ENDIF
      *
      ** One option can be entered at the time
     C                   IF        ValidOption > 1
     C                   EVAL      MessageId = 'SDC0002'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    'SDUSRMSG':*BLANK)
     C                   SETON                                        61
      ** Mark the record as changed
     C                   SETON                                        53
     C                   ENDIF
      *
      ** Text editor limits reached if number of lines inserted is
      ** greater than the working array
     C                   IF        SOPTN = 'I'
     C                             AND LinesMax + 1 > %ELEM(Statements)
     C                   EVAL      MessageId = 'CGD2597'
     C                   CALLP     SendMsg(MessageId:MsgData2:
     C                                    *BLANK:*BLANK)
     C                   SETON                                        61
      ** Mark the record as changed
     C                   SETON                                        53
     C                   ENDIF
      *
     C                   IF        SSTMT <> Statements(LINE)
      ** Desactivate the request is one of the SQL statements
      ** has changed
     C                   EVAL      Activated = 'N'
     C                   EVAL      LineChanged = 'Y'
      ** Record in a flag if a statement has been entered
     C                   IF        SSTMT <> *BLANK
     C                   EVAL      LineFilled = 'Y'
     C                   ENDIF
      ** Mark the record as changed
     C                   SETON                                        53
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * Insert request                                                *
      *****************************************************************
     C     InsertRequest BEGSR
     C                   EVAL      SQMBNM = StatementId
     C                   EVAL      SQRQNM = SRQNM
     C                   EVAL      SQRQDS = SRQDS
     C                   EVAL      SQSHNM = SSHNM
      *
     C                   IF        Activated = 'Y'
     C                   EVAL      SQACTV = 'Y'
     C                   ELSE
     C                   EVAL      SQACTV = 'N'
     C                   ENDIF
      *
     C                   WRITE(E)  CGSQLRD0
     C                   IF        %ERROR
     C                   EVAL      UpdateError = 'Y'
     C                   EVAL      MessageId = 'CGD2602'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    *BLANK:*BLANK)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * Delete request                                                *
      *****************************************************************
     C     DeleteRequest BEGSR
     C     KeySQLRL0     CHAIN     CGSQLRL0
     C                   IF        NOT %FOUND(CGSQLRL0)
     C                   EVAL      UpdateError = 'Y'
     C                   EVAL      MessageId = 'CGD2601'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    *BLANK:*BLANK)
     C                   LEAVESR
     C                   ENDIF
      *
     C                   DELETE(E) CGSQLRD0
     C                   IF        %ERROR
     C                   EVAL      UpdateError = 'Y'
     C                   EVAL      MessageId = 'CGD2596'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    *BLANK:*BLANK)
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      * Amend request                                                 *
      *****************************************************************
     C     AmendRequest  BEGSR
     C     KeySQLRL0     CHAIN     CGSQLRL0
     C                   IF        NOT %FOUND(CGSQLRL0)
     C                   EVAL      UpdateError = 'Y'
     C                   EVAL      MessageId = 'CGD2601'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    *BLANK:*BLANK)
     C                   LEAVESR
     C                   ENDIF
      *
     C                   IF        Activated = 'Y'
     C                   EVAL      SQACTV = 'Y'
     C                   ELSE
     C                   EVAL      SQACTV = 'N'
     C                   ENDIF
      *
     C                   UPDATE(E) CGSQLRD0
     C                   IF        %ERROR
     C                   EVAL      UpdateError = 'Y'
     C                   EVAL      MessageId = 'CGD2596'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    *BLANK:*BLANK)
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      * Help Requested                                                *
      *****************************************************************
     C     HelpReq       BEGSR
      *
      ** Flag set to Y if '?' entered somewhere on the screen
     C                   EVAL      QueryRequest = 'N'
     C                   EVAL      IdxQstnMrk = %SCAN('?':SSHNM)
     C                   IF        IdxQstnMrk <> 0
     C                   EVAL      QueryRequest = 'Y'
     C                   EVAL      TrnFeedBack = SchemasList
     C                   IF        ReturnedKey = *BLANK AND
     C                             ReturnedValues(1) <> *BLANK
     C                   EVAL      SSHNM = ReturnedValues(1)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * Initialisation                                                *
      *****************************************************************
     C     InitProg      BEGSR

     C                   EVAL      ReturnCode = *BLANK
     C                   EVAL      ErrorData = *BLANK
      ** Empty the array
     C                   EVAL      Statements = *BLANK
      ** Indicates that the array is empty
     C                   EVAL      Statements(1) = *LOVAL
      ** At the beginning the maximum number of SQL statements is 20
      ** This number will evolve with insertions and deletions
     C                   EVAL      LinesMax = 20
     C                   EVAL      EndProgram = 'N'
     C                   EVAL      Activated = 'N'
     C                   EVAL      SRUNA = AGMRDT
     C                   EVAL      SWSID = PsJobName
     C                   EVAL      SUSER = PSUser
      *
      *
     C                   EXSR      EnableFlds
      *
     C                   EXSR      EnableFuncKey

     C                   IF        ActionCode <> 'I'
     C                   EXSR      FillStmtArr
     C                   EXSR      FormatHeader
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * Enable Function Keys                                          *
      *****************************************************************
     C     EnableFuncKey BEGSR
      *
     C                   SELECT
      ** Disable F10, F13, F14
     C                   WHEN      ActionCode = 'E'
     C                   SETON                                        64
      ** Change F10 text
      ** Disable F13, F14
     C                   WHEN      ActionCode = 'D'
     C                   SETON                                        65
     C                   OTHER
     C                   SETOFF                                       65
     C                   SETOFF                                       64
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      * Enable Fields                                                 *
      *****************************************************************
     C     EnableFlds    BEGSR
     C                   SELECT
     C                   WHEN      ActionCode = 'I'
      ** SFLDSP OFF
     C                   SETOFF                                       52
      ** Protect all the  fields
     C                   WHEN      ActionCode = 'E'
     C                             OR ActionCode = 'D'
     C                   SETON                                        67
     C                   SETON                                        68
      ** Protect only the header fields
     C                   WHEN      ActionCode = 'A'
     C                   SETON                                        67
     C                   SETOFF                                       68
     C                   ENDSL
     C                   ENDSR
      *****************************************************************
      * Other programs                                                *
      *****************************************************************
     C     OtherProg     BEGSR
      *
      ** In enquire mode do nothing
     C                   IF        ActionCode = 'E'
     C                   LEAVESR
     C                   ENDIF

     C                   EXSR      AmendTbl

     C                   SELECT
     C                   WHEN      KeyPressed = '10'
     C                   EXSR      Updates
     C                   IF        UpdateError = 'N'
     C                   EVAL      EndProgram = 'Y'
     C                   COMMIT
     C                   ELSE
     C                   ROLBK
     C                   ENDIF
      *
     C                   WHEN      KeyPressed = *BLANK
      *
     C                   WHEN      KeyPressed = '13'
     C                   EXSR      ChkSqlRequest
      *
     C                   WHEN      KeyPressed = '14'
     C                   EXSR      ChkSqlRequest
     C                   IF        MessageId = 'CGD2605'
     C                   EVAL      Activated = 'Y'
     C                   EVAL      MessageId = 'CGD2606'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    *BLANK:*BLANK)
     C                   ELSE
     C                   EVAL      Activated = 'N'
     C                   ENDIF

     C                   ENDSL
     C                   ENDSR
      *****************************************************************
      * Fill statements array                                         *
      *****************************************************************
     C     FillStmtArr   BEGSR
      ** The file that contains the SQL request is opened manually as
      ** an override of one of its member is required.

     C     KeySQLRL0     KLIST
     C                   KFLD                    SchemaName
     C                   KFLD                    RequestName

      ** Retrieve the member name which is associated to the request
     C     KeySQLRL0     CHAIN     CGSQLRL0
     C                   IF        %FOUND(CGSQLRL0)
     C                   UNLOCK    CGSQLRL0
     C                   ELSE
     C                   EVAL      ReturnCode = 'CGD2595'
     C                   LEAVESR
     C                   ENDIF

     C                   EVAL      Statements = getStatements(SQMBNM)
     C                   IF        Statements(1) = *HIVAL
     C                   EVAL      ReturnCode = 'CGD2609'
     C                   EVAL      ErrorData = SQMBNM
     C                   LEAVESR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      * Amend Statements Table                                        *
      *****************************************************************
     C     AmendTbl      BEGSR
      *
     C     *LIKE         DEFINE    LINE          l
      *
     C                   EVAL      PosInsert = 0
     C                   DO        LinesMax      l
     C     l             CHAIN     CG3635S0
     C                   IF        SOPTN = 'D'
     C                   EVAL      Options(l) = SOPTN
     C                   ELSE
     C                   IF        SOPTN = 'I'
     C                   EVAL      Options(l) = SOPTN
     C                   EVAL      PosInsert = l
     C                   ENDIF
     C                   IF        Statements(l) <> SSTMT
     C                   EVAL      Statements(l) = SSTMT
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
      ** A line has been inserted
     C                   IF        PosInsert <> 0
      ** Increase the limit (in case of an 'Insert' in the last line)
     C                   EVAL      LinesMax = LinesMax + 1
     C                   EVAL      s = LastStatement(Statements)
     C                   DOW       s >= PosInsert
     C                   EVAL      Statements(s+1) = Statements(s)
     C                   EVAL      s = s - 1
     C                   ENDDO
     C                   EVAL      Statements(PosInsert) = *BLANK
     C                   ELSE
      ** No insertion
     C                   EVAL      s = 1
     C                   DOW       s <= LinesMax
     C                             AND s <= %ELEM(Statements)
     C                   IF        Options(s) = 'D'
     C                   EVAL      Statements(s) = *BLANK
     C                   DOW       s <= LinesMax - 1
     C                             AND s <= %ELEM(Statements)
     C                   EVAL      Statements(s) = Statements(s+1)
     C                   EVAL      s = s + 1
     C                   ENDDO
      ** Decrease the limit but leave at least one line
     C                   IF        LinesMax > 1
     C                   EVAL      LinesMax = LinesMax - 1
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
     C                   EVAL      s = s + 1
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      * Check SQL Request                                             *
      *****************************************************************
     C     ChkSqlRequest BEGSR
     C                   EVAL      TrnFeedBack = SyntaxCheck(Statements)
     C                   IF        ReturnedErr(1) <> *BLANK
     C                   EVAL      MessageId = ReturnedErr(1)
     C                   EVAL      MsgData2 = ReturnedDta(1)
     C                   CALLP     SendMsg(MessageId:MsgData2:
     C                                    *BLANK:*BLANK)
     C                   ELSE
      ** The syntax of this request is correct
     C                   EVAL      MessageId = 'CGD2605'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                    *BLANK:*BLANK)
     C                   ENDIF
     C                   ENDSR
      ********************************************************************  **
      * Get SQL statements                                               *
      ********************************************************************  **
     PgetStatements    B
     DgetStatements    PI            60    DIM(30)
     DStmtIdent                            LIKE(SQMBNM) VALUE
      *
     DSQLInstr         S             60    DIM(30)
     Di                S              3  0
     DCommandLine      S             80
     DCommandLen       S             15  5
      *
     C                   EVAL      CommandLine
     C                                = OvrFilMbr('CGSQLTXT':StmtIdent)
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    CommandLine
     C                   PARM      80            CommandLen
     C                   IF        NOT %ERROR
      *
     C                   OPEN(E)   CGSQLTXT
     C                   IF        %ERROR
     C                   EVAL      SQLInstr(1) = *HIVAL
     C                   ELSE
      *
     C                   EVAL      i = 1
     C                   READ      CGSQLTXT
     C                   DOW       NOT %EOF
     C                   UNLOCK    CGSQLTXT
     C                   EVAL      SQLInstr(i) = SRCDTA
     C                   EVAL      i = i + 1
     C                   READ      CGSQLTXT
     C                   ENDDO
     C                   CLOSE     CGSQLTXT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   RETURN    SQLInstr
     P                 E
      ********************************************************************  **
      * Format command to override a file member                         *
      ********************************************************************  **
     POvrFilMbr        B
     DOvrFilMbr        PI            80
     DFileName                       10    VALUE
     DMemberName                     10    VALUE
      *
     DFilePar          S             16
     DMemberPar        S             15
     DCommandL         S             80
      *
     C                   EVAL      FilePar = 'FILE(' + %TRIMR(FileName)
     C                               + ')'
     C                   EVAL      MemberPar = 'MBR('
     C                               + %TRIMR(MemberName)
     C                               + ')'
     C                   EVAL      CommandL    = 'OVRDBF' + ' ' +
     C                               FilePar + ' ' +  MemberPar +
     C                               ' ' + 'SHARE(*NO) SECURE(*YES)'
     C                   RETURN    CommandL
     P                 E
      ********************************************************************  **
      * Write SQL statements                                             *
      ********************************************************************  **
     PWrtSQLStmt       B
     DWrtSQLStmt       PI            10
     DStmtList                       60    DIM(30) VALUE
     DStmtIdent                            LIKE(SQMBNM) VALUE
      *
     DRetCodOut        S             10
     DStmtNo           S                   LIKE(SRCSEQ)
     Di                S              3  0
     DLastLine         S              3  0
     DCommandLine      S             80
     DCommandLen       S             15  5
      *
     C                   EVAL      RetCodOut = AddMember(StmtIdent)
     C                   IF        RetCodOut = *BLANK
      *
     C                   EVAL      CommandLine
     C                                = OvrFilMbr('CGSQLTXT':StmtIdent)
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    CommandLine
     C                   PARM      80            CommandLen
     C                   IF        NOT %ERROR

     C                   OPEN(E)   CGSQLTXT
     C                   IF        %ERROR
     C                   EVAL      RetCodOut = '*ERROR'
     C                   ELSE

      ** Determine the last line that has been filled
     C                   EVAL      LastLine = LastStatement(StmtList)

      ** SQL statements are compressed when they are put into the file
      ** (Blank lines are ignored)
     C                   EVAL      i = 0
     C                   EVAL      StmtNo = 0
     C                   DOW       i < LastLine
     C                   EVAL      i = i + 1
     C                   IF        StmtList(i) <> *BLANK
     C                   EVAL      StmtNo = StmtNo + 1
     C                   EVAL      SRCSEQ = StmtNo
     C                   EVAL      SRCDTA = StmtList(i)
     C                   WRITE(E)  CGSQTXD0
     C                   IF        %ERROR
     C                   EVAL      RetCodOut = '*ERROR'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   CLOSE     CGSQLTXT
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      RetCodOut = '*ERROR'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   RETURN    RetCodOut
     P                 E
      ********************************************************************  **
      * Delete SQL statements                                            *
      ********************************************************************  **
     PDelSQLStmt       B
     DDelSQLStmt       PI            10
     DStmtIdent                            LIKE(SQMBNM) VALUE
      *
     DRetCodOut        S             10
     C                   EVAL      RetCodOut = RmvMember(StmtIdent)
     C                   RETURN    RetCodOut
      *
     P                 E
      ********************************************************************  **
      * Determines the index of the last statement                       *
      ********************************************************************  **
     PLastStatement    B
     DLastStatement    PI             3  0
     DStmtList                       60    DIM(30) VALUE
      *
     DStmts            S           6000
     DPosSpace         S              4  0
     DLastLine         S              3  0
      *
     C                   MOVEA     StmtList      Stmts
     C                   EVAL      LastLine = 0
     C     ' '           CHECKR    Stmts         PosSpace
      ** We round the value if necessary
     C                   EVAL      LastLine = PosSpace / 60
     C                   IF        %REM(PosSpace:60) <> 0
     C                   EVAL      LastLine = LastLine + 1
     C                   ENDIF
     C                   RETURN    LastLine
     P                 E
      ********************************************************************  **
      * List of the schemas                                              *
      ********************************************************************  **
     PSchemasList      B
     DSchemasList      PI          9999
      *
     DFeedBack         DS
     D ReturnedKey                    2
     D ReturnedErr                    7    DIM(10)
     D ReturnedDta                  256    DIM(10)
     D ErrorTypes                     1    DIM(10)
     D MessageFiles                  10    DIM(10)
     D ReturnedValues               256    DIM(50)
      *
     DSelectedValue    S                   LIKE(SchemaName)
     DRtnCode          S             10
      *
     C                   CALLB     'CG3636'
     C                   PARM                    RtnCode
     C                   PARM                    SelectedValue
     C                   PARM                    KeyPressed
      *
     C                   EVAL      ReturnedKey = KeyPressed
     C                   EVAL      ReturnedErr(1) = RtnCode
     C                   EVAL      ReturnedValues(1) = SelectedValue
      *
     C                   RETURN    FeedBack
     P                 E
      ********************************************************************  **
      * Get statement identifier                                         *
      ********************************************************************  **
     PgetStmtId        B
     DgetStmtId        PI            10
      *
     DRtnCode          S             10
     DAtribNo          S             35
     DStmId            S                   LIKE(SQMBNM)
      *
     C                   CALLB(E)  'CG3606'
     C                   PARM                    RtnCode
     C                   PARM                    AtribNo
     C                   IF        %ERROR OR RtnCode <> *BLANK
     C                   EVAL      StmId = *BLANK
     C                   ELSE
     C                   EVAL      StmId = AtribNo
     C                   ENDIF
      *
     C                   RETURN    StmId
      *
     P                 E
      ********************************************************************  **
      * Add member                                                       *
      ********************************************************************  **
     PAddMember        B
     DAddMember        PI            10
     DStmtIdent                            LIKE(SQMBNM) VALUE
      *
     DRtnCode          S             10
     DCommandLine      S             80
     DCommandLen       S             15  5
      *
     C                   EVAL      CommandLine = 'ADDPFM FILE(CGSQLTXT) '
     C                             + 'MBR(' + %TRIMR(StmtIdent) + ')'
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    CommandLine
     C                   PARM      80            CommandLen
     C                   IF        %ERROR
     C                   EVAL      RtnCode = '*ERROR'
     C                   ENDIF
     C                   RETURN    RtnCode
     P                 E
      ********************************************************************  **
      * Remove member                                                    *
      ********************************************************************  **
     PRmvMember        B
     DRmvMember        PI            10
     DStmtIdent                            LIKE(SQMBNM) VALUE
      *
     DRtnCode          S             10
     DCommandLine      S             80
     DCommandLen       S             15  5
      *
     C                   EVAL      CommandLine = 'RMVM FILE(CGSQLTXT) '
     C                             + 'MBR(' + %TRIMR(StmtIdent) + ')'
     C                   CALL(E)   'QCMDEXC'
     C                   PARM                    CommandLine
     C                   PARM      80            CommandLen
     C                   IF        %ERROR
     C                   EVAL      RtnCode = '*ERROR'
     C                   ENDIF
     C                   RETURN    RtnCode
     P                 E
      ********************************************************************  **
      * Syntax check                                                     *
      ********************************************************************  **
     PSyntaxCheck      B
     DSyntaxCheck      PI          9999
     DStmtList                       60    DIM(30) VALUE
      *
     DFeedBack         DS
     D ReturnedKey                    2
     D ReturnedErr                    7    DIM(10)
     D ReturnedDta                  256    DIM(10)
     D ErrorTypes                     1    DIM(10)
     D MessageFiles                  10    DIM(10)
     D ReturnedValues               256    DIM(50)
      *
     DRtnCode          S             10
     DRtnMessage       S            256
     DSQLStatement     S            500
     Di                S              3  0

     C                   EVAL      i = 0
     C                   DOW       i < %ELEM(StmtList)
     C                   EVAL      i = i + 1
     C                   IF        SQLStatement = *BLANK
     C                   EVAL      SQLStatement = %TRIMR(StmtList(i))
     C                   ELSE
     C                   EVAL      SQLStatement = %TRIMR(SQLStatement) +
     C                             ' ' +  %TRIMR(StmtList(i))
     C                   ENDIF
     C                   ENDDO

     C                   CALLB(E)  'CG3607'
     C                   PARM                    RtnCode
     C                   PARM                    RtnMessage
     C                   PARM                    SQLStatement

     C                   IF        %ERROR
     C                   EVAL      ReturnedErr(1) = 'CGD2604'
     C                   ELSE
     C                   IF        RtnCode <> *BLANK
     C                   IF        RtnMessage <> *BLANK
     C                   EVAL      ReturnedErr(1) = 'CGD2612'
     C                   EVAL      ReturnedDta(1) = RtnMessage
     C                   ELSE
     C                   EVAL      ReturnedErr(1) = 'CGD2603'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   RETURN    FeedBack

     P                 E

      ** Procedures SendMsg, RtvMsgTxt
     D/COPY CGCPYSRC,CG3636P001
