     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD054955
/*STD *  RPGSQLMOD                                                    *                     MD054955
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD054955
/*EXI *  TEXT('Midas CG List of schema names')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3636 - List of Schema Names                                *
      *                                                               *
      *  Function:  This program is used to display a list of Schema  *
      *  Names that are available on request.                         *
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
      *                 CCG015  *CREATE    Date 08Nov01               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
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
     FCG3636DF  CF   E             WORKSTN
     F                                     SFILE(CG3636S0:LINE)
     F                                     INFSR(*PSSR)
      *
      ** Conversion file
     F*CGRDECL1* IF   E           K DISK    RENAME(CGRDECD0:CGRDECD1)                       MD054955
     F**********                           INFSR(*PSSR)                                     MD054955
      *
      ** Print Item Type / Sub type
     F*CGPTYPL1* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(*PSSR)                                     MD054955
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

      ** Get Print Item Type                                              *
     DGetPrtItm        PR            10
     Dp1                                   VALUE LIKE(CGARGT)

      ** Get Print Item Sub Type                                          *
     DGetPrtSub        PR            10
     Dp2                                   VALUE LIKE(CGARGT)

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
      ** Reference ?
     DReferFound       S              1
      ** Position of question mark
     DIdxQstnMrk       S              3  0
      ** Number of selections
     DSelCount         S              3  0
      ** Line number written in the sub file
     DLineWritten      S              5  0
     D CGRDEC        E DS                  EXTNAME(CGRDEJW0)                                MD054955
     D CGPTYP        E DS                  EXTNAME(CGPTYJW0)                                MD054955
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
     C                   EVAL      SchemaName = *BLANK
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
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ close RCursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
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
      ** F3 = Exit, F12=Previous
      ** Rollup
      ** Initialisation is requested.
      ** End Transaction
     C                   DOU       *INKL = '1'
     C                             OR *INKC = '1'
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
     C     *LIKE         DEFINE    SPSHNM        MemPSHNM
     C                   EVAL      RefreshList = 'N'
      ** Criteria have changed ?
     C                   IF        SPSHNM <> MemPSHNM
     C                   EVAL      MemPSHNM = SPSHNM
     C                   EVAL      RefreshList = 'Y'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************  Ref
      * Init the sub file                                             *
      *****************************************************************
     C     InitSubFile   BEGSR
      *
     C                   EVAL      LineWritten = 0
      ** Clear Sub File
     C                   SETON                                        87
     C                   SETOFF                                       8283
     C                   WRITE     CG3636C0
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
     C                   EVAL      SSHNM = CGNWFD
      *
     C                   EVAL      PrtItm = GetPrtItm(CGARGT)
     C                   EVAL      PrtSub = GetPrtSub(CGARGT)
     C*****KeyPTYPL0     CHAIN     CGPTYPL1                                                 MD054955
     C***********        IF        %FOUND(CGPTYPL1)                                         MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGPTYP                                                                        MD054955
     C+ from CGPTYJW0                                                                       MD054955
     C+ where ITPTYP = :PrtItm and ITPSTP = :PrtSub and ITRECI = 'D'                        MD054955
     C/END-EXEC                                                                             MD054955
     C                   If        SQLCODE = 0                                              MD054955
     C                   EVAL      SDESC = ITDESC
     C                   ELSE
     C                   EVAL      SDESC = *BLANK
     C                   ENDIF
      *
     C                   WRITE     CG3636S0
      *
     C                   ENDSR
      *****************************************************************
      * Setll a record from a file                                    *
      *****************************************************************
     C     PosSubFile    BEGSR
      *
     C     *LIKE         DEFINE    CGNWFD        CnvName
     C     *LIKE         DEFINE    CGTYPE        CnvType
      *
      ** This subroutine is used to position the reading pointer
      ** on a particular record, according to the screen criteria Sxxxx
      ** entered.
     C     KeyRDECL0     KLIST
     C                   KFLD                    CnvName
     C                   KFLD                    CnvType
      *
     C                   EVAL      CnvType = 'REFR'
     C                   EVAL      CnvName = SPSHNM
     C*****KeyRDECL0     SETLL     CGRDECL1                                                 MD054955
     C/EXEC SQL                                                                             MD054955
     C+ close RCursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare RCursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGRDEJW0                                                              MD054955
     C+ where CGNWFD >= :CnvName and CGTYPE >= :CnvType                                     MD054955
     C+ order by CGNWFD, CGTYPE                                                             MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open RCursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
      *
     C                   ENDSR
      *****************************************************************
      * Read a record from the file                                   *
      *****************************************************************
     C     FillSubFile   BEGSR
      *
     C                   EVAL      ReferFound = 'N'
     C                   DOW       ReferFound = 'N' AND *IN86 = '0'
     C**********         READ      CGRDECL1                               86                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from RCursor into :CGRDEC                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                           86                MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        86                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C                   IF        CGTYPE = 'REFR'
     C                   EVAL      ReferFound = 'Y'
     C                   ENDIF
     C                   ENDDO
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
     C                   WRITE     CG3636F1
     C                   WRITE     CG3636F0
     C                   WRITE     #MSGCTL
     C                   EXFMT     CG3636C0
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
     C                   EVAL      SelCount = 0
     C                   READC     CG3636S0                               90
     C                   DOW       *IN90 = '0'
     C                   EVAL      LastLine = Line
     C                   SETOFF                                       84
     C                   SETOFF                                       30
      *
      ** Action codes allowed are '1'
     C                   IF        SOPTN <> *BLANK
     C                   IF        SOPTN <> '1'
     C                   EVAL      MessageId = 'SDM0048'
     C                   EVAL      MsgData2 = '1'
     C                   CALLP     SendMsg(MessageId:MsgData2:
     C                                    'SDUSRMSG':*BLANK)
     C                   SETON                                        30
     C                   ENDIF
      ** Mark the record as changed
     C                   SETON                                        84
     C                   ENDIF
      *
      ** Only one selection is allowed
     C                   IF        SOPTN <> *BLANK
     C                   IF        SOPTN = '1'
     C                   EVAL      SelCount = SelCount + 1
     C                   IF        SelCount > 1
     C                   EVAL      MessageId = 'SDC0001'
     C                   CALLP     SendMsg(MessageId:*BLANK:
     C                                      'SDUSRMSG':*BLANK)
     C                   SETON                                        30
     C                   ENDIF
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
     C                   UPDATE    CG3636S0
     C                   READC     CG3636S0                               90
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
     C                   IF        LastLine <> 0
     C                   EVAL      RECNS0 = *LOVAL
     C                   DO        LastLine      L
     C                   SETOFF                                       30
     C     L             CHAIN     CG3636S0                           90
      *
     C                   IF        SOPTN <> *BLANK
     C                   EVAL      ValidOpt = ValidOpt + 1
     C                   EVAL      SchemaName = SSHNM
     C                   EVAL      SOPTN = *BLANK
     C                   UPDATE    CG3636S0
     C                   ENDIF
      *
     C                   ENDDO
      ** Display page 1
     C                   IF        RECNS0 = *LOVAL
     C                   EVAL      RECNS0 = 1
     C                   ENDIF
      ** Leave Program if a schema has been selected
     C                   IF        SchemaName <> *BLANK
     C                   EVAL      EndProgram = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
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
      ** Schema Name (output)
     C                   PARM                    SchemaName
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
      * Get Print Item Type                                              *
      ********************************************************************  **
     PGetPrtItm        B
     DGetPrtItm        PI            10
     DReference                            VALUE LIKE(CGARGT)
      *
     Dcol              S              3  0
     DPrtItmTyp        S                   LIKE(ITPTYP)
      *
     C                   EVAL      col = %SCAN(':':Reference)

     C                   EVAL      PrtItmTyp = %SUBST(Reference:1:col - 1)
     C                   RETURN    PrtItmTyp
     P                 E
      ********************************************************************  **
      * Get Print Item Sub Type                                          *
      ********************************************************************  **
     PGetPrtSub        B
     DGetPrtSub        PI            10
     DReference                            VALUE LIKE(CGARGT)
      *
     Dcol              S              3  0
     DPrtItmSub        S                   LIKE(ITPTYP)
      *
     C                   EVAL      col = %SCAN(':':Reference)

     C                   EVAL      PrtItmSub = %SUBST(Reference:col + 1)
     C                   RETURN    PrtItmSub
     P                 E

      ** Procedures SendMsg, RtvMsgTxt
     D/COPY CGCPYSRC,CG3636P001
