     H DEBUG
     H DFTACTGRP(*NO) ACTGRP(*CALLER)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas CoB Generic Trailer Update Program')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  CB000801 - Midas COB Generic Trailer Update Program          *
      *                                                               *
      *  Last Amend No. MD025467A          Date 17Mar14               *
      *  Prev Amend No. MD025467 *CREATE   Date 28Feb14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD025467A - Few records placed in SDTRDFPD for ACTIONFILE    *
      *            - Recompiled due to changes in SDTRDFL0            *
      *  MD025467 - API locking issues Redesign Approach              *
      *                                                               *
      *****************************************************************
 
     FSDTRDFL0  IF   E           K DISK
      ** Trailer Extension file
     F                                     INFSR(*PSSR)
     F                                     BLOCK(*YES)
     F                                     USROPN
 
      ** Entry Parameters
      ** ================
     D PTrlFile        S             10A
     D PExtFile        S             10A
     D PTrlKey         S             10A
 
      ** Program Parameters
      ** ==================
     D PReturnCode     S              7A
     D POption         S              7A
 
      ** Standard D-specs
      ** ================
 
     D True            C                   CONST(*ON)
     D False           C                   CONST(*OFF)
     D RanBefore       S               N   INZ
 
     D LDA           E DS                  DTAARA
     D DSLDA           DS                  INZ LIKEDS(LDA)
 
      ** Main Procedure/Program variables
      ** ================================
 
     D StrSQLStmt      S            900A   VARYING
     D StrSQLFld       S            250A   VARYING
     D StrSQLFldVal    S            500A   VARYING
     D StrSQLCond      S             40A   VARYING
     D IntField        S             10A   VARYING
     D DecField        S             10A   VARYING
     D MainTrlOnly     S               N   INZ
 
     D SumTotal        S             38S 0 INZ
     D DSBank        E DS                  INZ EXTNAME(SDBANKPD)
     D                                     QUALIFIED
     D DSDummyS      E DS                  INZ EXTNAME(DSFDY)
 
      ** Static variables/constants used by subprocs/functions
      ** Note: limit use in main procedure/program
      ** =====================================================
 
     D WrkStr          S            300A   VARYING
     D IntFldOnly      S               N   INZ
 
     D WrkSum          S             39S 0 INZ
      ** Should always be 1 digit longer than SumTotal
 
     D Idx             S              5I 0 INZ
 
      /EJECT
      *****************************************************************
 
      ** Subprocedures/Functions Prototypes
      ** ==================================
 
     D resendESCMsg    PR                  EXTPGM('QMHRSNEM')
     D   MsgKey                       4A   CONST
     D   ErrCode                     10I 0 CONST
 
     D chkSQLError     PR             3A
     D  ErrMsgDta                          LIKEDS(ErrSQLDta)
     D                                     OPTIONS(*NOPASS)
 
     D sendPgmMsg      PR                  EXTPGM('QMHSNDPM')
     D   MsgID                        7A   CONST
     D   QualMsgF                    20A   CONST
     D   MsgData                   1000A   CONST
     D   MsgDataLen                  10I 0 CONST
     D   MsgType                     10A   CONST
     D   CallStkEnt                  10A   CONST
     D   CallStkCnt                  10I 0 CONST
     D   MsgKey                       4A
     D   ErrCode                           LIKEDS(APIErrCode)
 
     D procCursor      PR
     D   pMode                        7A   VALUE
 
     D truncSum        PR            38A   VARYING
     D   pSum                              VALUE LIKE(SumTotal)
     D   pStartR                           VALUE LIKE(Idx)
     D   pStrLen                           VALUE LIKE(Idx)
     D   pError                        N   OPTIONS(*NOPASS)
 
      ** Templates (reference for declarations)
      ** ======================================
 
     D ErrSQLDta       DS                  TEMPLATE
     D Status                         5A
     D ErrorText                    200A   VARYING
     D ErrorTokenCnt                 10I 0
     D ErrorTokens
     D   Token1                     100A   VARYING OVERLAY(ErrorTokens)
     D   Token2                     100A   VARYING OVERLAY(ErrorTokens:*NEXT)
     D   Token3                     100A   VARYING OVERLAY(ErrorTokens:*NEXT)
     D  ErrorToken                  100A   DIM(3) VARYING OVERLAY(ErrorTokens)
 
     D APIErrCode      DS                  TEMPLATE
     D  BytesProv                    10I 0 INZ
     D  BytesAvail                   10I 0 INZ
 
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------+ *
      **                                                              *
      **   Initial processing is performed automatically: *INZSR is   *
      **   executed at program activation.                            *
      **                                                              *
      ** +------------------------------------------------------------+
 
      ** Main process initialization
 
     C                   OPEN      SDTRDFL0
     C                   EVAL      StrSQLStmt = ''
     C                   EVAL      StrSQLFld = ''
     C                   EVAL      StrSQLFldVal = ''
     C                   EVAL      StrSQLCond = ''
 
     C                   EVAL      MainTrlOnly = False
     C                   IF        PExtFile = ' '
     C                   EVAL      MainTrlOnly = True
     C                   ENDIF
 
     C                   IF        PTrlKey <> ' '
     C                   EVAL      StrSQLCond = ' where AHFLNM = ''' +
     C                                 %TRIMR(PTrlKey) + ''''
     C                   ENDIF
 
      ** Merge/Update main trailer file
 
     C                   MONITOR
     C                   EXSR      UpdMainTrl
     C                   EXSR      ClnTrlRec
     C                   ON-ERROR
     C                   EXSR      *PSSR
     C                   ENDMON
 
      ** Last record/program end processing
 
     C                   CLOSE     SDTRDFL0
 
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** SUBROUTINES
      ** ===========
 
      *****************************************************************
      *                                                               *
      * *INZSR - Initial subroutine called at program startup         *
      *        - One-time initialization process (LR not set to ON)   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PTrlFile
     C                   PARM                    PExtFile
     C                   PARM                    PTrlKey
 
     C/EXEC SQL
     C+                  declare CsrTrailSum cursor for TrailSum
     C/END-EXEC
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    PReturnCode
     C                   PARM      '*FIRST  '    POption
     C     DSBank        PARM      DSBank        DSDummyS
 
     C                   IF        PReturnCode <> ' '
     C                   EVAL      DSLDA.DBASE = 1
     C                   EVAL      DSLDA.DBFILE = 'AOBANKR0'
     C                   EVAL      DSLDA.DBKEY = '*CALL'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdMainTrl - Update main trailer file values                  *
      *                                                               *
      *****************************************************************
     C     UpdMainTrl    BEGSR
 
 
     C     PTrlFile      SETLL     SDTRDFL0
     C                   READ      SDTRDFL0
     C                   DOW       NOT %EOF(SDTRDFL0)
     C                             AND A9TRLNM = PTrlFile
 
     C                   EVAL      IntField = %TRIMR(A9FLDINT)
     C                   EVAL      DecField = %TRIMR(A9FLDDEC)
 
     C                   EVAL      StrSQLFld = StrSQLFld + IntField + ', '
 
     C                   SELECT
 
     C                   WHEN      A9TYPE = 'CHANGEDATE'
     C                   EVAL      StrSQLFldVal = StrSQLFldVal +
     C                                %CHAR(DSBank.BJRDNB) + ', '
 
     C                   WHEN      A9TYPE = 'ACTION'
     C                   EVAL      StrSQLFldVal = StrSQLFldVal + '''A''' + ', '
 
     C                   WHEN      A9TYPE = 'COUNT' OR A9TYPE = 'AMOUNT'
     C                   CALLP     procCursor('PREPARE')
     C                   CALLP     procCursor('OPEN')
     C                   CALLP     procCursor('FETCH')
 
     C                   EVAL      Idx = 1
     C                   IF        A9TYPE = 'AMOUNT'
     C                   EVAL      Idx = A9LENDEC + 1
     C                   ENDIF
 
     C                   EVAL      StrSQLFldVal = StrSQLFldVal +
     C                             truncSum( SumTotal : Idx : A9LENINT )
     C                             + ', '
 
     C                   IF        DecField <> ''
     C                   EVAL      StrSQLFld = StrSQLFld + DecField + ', '
     C                   EVAL      StrSQLFldVal = StrSQLFldVal +
     C                             truncSum( SumTotal : 1 : A9LENDEC ) + ', '
     C                   ENDIF
 
     C                   CALLP     procCursor('CLOSE')
 
     C                   ENDSL
 
     C                   READ      SDTRDFL0
     C                   ENDDO
 
      ** Clean up statements before joining and running them
      ** Check for special conditions
 
     C                   EVAL      %SUBST( StrSQLFld
     C                                   : %LEN(StrSQLFld) - 1 : 2 ) = ''
     C                   EVAL      %SUBST( StrSQLFldVal
     C                                   : %LEN(StrSQLFldVal) - 1 : 2 ) = ''
      *
     C                   EVAL      StrSQLStmt =
     C                               'update ' + %TRIMR(PTrlFile) +
     C                               ' set (' + StrSQLFld + ') '    +
     C                               '   = (' + StrSQLFldVal + ') ' +
     C                                StrSQLCond
     C/EXEC SQL
     C+ execute immediate :StrSQLStmt
     C/END-EXEC
 
      ** Set fields for error, clear if not
 
     C                   EVAL      DSLDA.DBASE = 2
     C                   EVAL      DSLDA.DBFILE = %TRIMR(PTrlFile)
     C                   EVAL      DSLDA.DBKEY = '*UPDATE'
 
     C                   IF        chkSQLError() <> 'ERR'
     C                   CLEAR                   DSLDA
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ClnTrlRec - Cleanup trailer records                           *
      *                                                               *
      *****************************************************************
     C     ClnTrlRec     BEGSR
 
     C                   IF        MainTrlOnly AND StrSQLCond = ''
     C                   EVAL      StrSQLStmt =
     C                               'delete from ' + %TRIMR(PTrlFile) +
     C                               ' where RRN(' + %TRIMR(PTrlFile) +
     C                               ') > 1'
     C                   EVAL      DSLDA.DBFILE = %TRIMR(PTrlFile)
     C                   ELSE
     C                   EVAL      StrSQLStmt =
     C                               'delete from ' + %TRIMR(PExtFile) +
     C                               StrSQLCond
     C                   EVAL      DSLDA.DBFILE = %TRIMR(PExtFile)
     C                   ENDIF
     C/EXEC SQL
     C+                  execute immediate :StrSQLStmt
     C/END-EXEC
 
      ** Set fields for error, clear if not
 
     C                   EVAL      DSLDA.DBASE = 3
     C                   EVAL      DSLDA.DBKEY = '*DELETE'
 
     C                   IF        chkSQLError() <> 'ERR'
     C                   CLEAR                   DSLDA
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Global error handler routine                          *
      *       - called automatically whenever unhandled error occurs  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      DSLDA.DBPGM = 'CB000801'
 
     C                   IF        NOT RanBefore
 
     C                   EVAL      RanBefore = True
     C     *LOCK         IN        LDA
     C                   EVAL      LDA = DSLDA
     C                   OUT       LDA
 
     C                   DUMP
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** SUBPROCEDURES/FUNCTIONS
      ** =======================
 
      *****************************************************************
      *                                                               *
      * chkSQLError - checks the SQLSTATE of recently executed SQL    *
      *               operation if error encountered                  *
      *             - sends a diagnostic message for warnings         *
      *             - sends an escape message if it is an error       *
      *  Parms:                                                       *
      *    ErrMsgDta : data structure to contain SQL message data     *
      *                (optional)                                     *
      *  Returns: 'OK'  - no error encountered                        *
      *           'EOD' - end of data/file                            *
      *           'WRN' - warning encountered                         *
      *           'ERR' - error encountered                           *
      *                                                               *
      *****************************************************************
     P chkSQLError     B
     D                 PI             3A
     D  ErrMsgDta                          LIKEDS(ErrSQLDta)
     D                                     OPTIONS(*NOPASS)
 
     D DSDiag          DS                  LIKEDS(ErrSQLDta)
     D ErrorCode       DS                  INZ LIKEDS(APIErrCode)
 
     D StrMsg          S           1000A   VARYING
     D MsgType         S             10A   INZ
     D MsgKey          S              4A
 
     D RtnStatus       S              3A
 
     C/EXEC SQL
     C+ get diagnostics exception 1
     C+       :DSDiag.Status = RETURNED_SQLSTATE
     C+      ,:DSDiag.ErrorText = MESSAGE_TEXT
     C+      ,:DSDiag.ErrorTokenCnt = DB2_TOKEN_COUNT
     C+      ,:DSDiag.Token1 = DB2_ORDINAL_TOKEN_1
     C+      ,:DSDiag.Token2 = DB2_ORDINAL_TOKEN_2
     C+      ,:DSDiag.Token3 = DB2_ORDINAL_TOKEN_3
     C/END-EXEC
 
     C                   SELECT
     C                   WHEN      %SUBST( DSDiag.Status : 1 : 2 ) = '00'
     C                   EVAL      RtnStatus = 'OK'
 
     C                   WHEN      %SUBST( DSDiag.Status : 1 : 2 ) = '02'
     C                   EVAL      RtnStatus = 'EOD'
 
     C                   WHEN      %SUBST( DSDiag.Status : 1 : 2 ) = '01'
     C                   EVAL      RtnStatus = 'WRN'
     C                   EVAL      MsgType = '*DIAG'
 
     C                   OTHER
     C                   EVAL      RtnStatus = 'ERR'
     C                   EVAL      MsgType = '*ESCAPE'
     C                   ENDSL
 
     C                   IF        %PARMS() = 1
     C                   EVAL      ErrMsgDta = DSDiag
     C                   ELSEIF    MsgType <> *BLANKS
     C                   EVAL      StrMsg = DSDiag.ErrorText
 
     C                   CALLP     sendPgmMsg( 'CPF9897'
     C                                       : 'QCPFMSG   *LIBL'
     C                                       : StrMsg
     C                                       : %LEN( StrMsg )
     C                                       : MsgType
     C                                       : '*'
     C                                       : 1
     C                                       : MsgKey
     C                                       : ErrorCode )
     C                   ENDIF
 
     C                   RETURN    RtnStatus
 
     P chkSQLError     E
      *****************************************************************
      *                                                               *
      * truncSum - Truncates sum with specified length                *
      *            starting from the right                            *
      *  Parms:                                                       *
      *    pSum    : sum to be truncated                              *
      *    pStartR : starting position from the right                 *
      *    pStrLen : length to be retrieved                           *
      *                                                               *
      *****************************************************************
     P truncSum        B
     D                 PI            38A   VARYING
     D  pSum                               VALUE LIKE(SumTotal)
     D  pStartR                       5I 0 VALUE
     D  pStrLen                       5I 0 VALUE
     D  pError                         N   OPTIONS(*NOPASS)
 
     C                   MONITOR
 
     C                   IF        %PARMS() = 4
     C                   EVAL      pError = False
     C                   ENDIF
 
     C                   EVAL      WrkSum = 0
     C                   IF        pSum < 0
     C                   MOVEL     1             WrkSum
     C                   ENDIF
 
     C                   IF        pStartR >= 1
     C                   EVAL      pStartR = pStartR - 1
     C                   ENDIF
 
     C                   EVAL      WrkStr = %EDITC( WrkSum + pSum : 'X' )
     C                   EVAL      Idx = %LEN(WrkStr)
     C                                 - (pStrLen + pStartR) + 1
 
     C                   EVAL      WrkStr = %SUBST( WrkStr
     C                                            : Idx
     C                                            : pStrLen      )
 
     C                   ON-ERROR
 
     C                   IF        %PARMS() = 4
     C                   EVAL      pError = True
     C                   ENDIF
 
     C                   EVAL      DSLDA.DBASE = 4
     C                   EVAL      DSLDA.DBKEY = 'truncSum'
     C                   EVAL      DSLDA.DBFILE = %TRIMR( PTrlFile )
     C                   CALLP     resendESCMsg( *BLANKS : *ZERO )
 
     C                   ENDMON
 
     C                   RETURN    WrkStr
 
     P truncSum        E
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * procCursor - Selects the process to be done to the cursor     *
      *              based on passed mode                             *
      *  Parms:                                                       *
      *    pMode : type of process to be done                         *
      *****************************************************************
     P procCursor      B
     D                 PI
     D  pMode                         7A   VALUE
 
     C                   EVAL      IntFldOnly = False
 
     C                   IF        A9TYPE = 'COUNT'
     C                   EVAL      IntFldOnly = True
     C                   ENDIF
 
     C                   IF        A9TYPE = 'AMOUNT'
     C                   EVAL      IntFldOnly = False
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      pMode = 'PREPARE'
 
     C                   IF        IntFldOnly AND MainTrlOnly
     C                   EVAL      StrSQLStmt =
     C                               'select sum(' + IntField + ') from ' +
     C                                  %TRIMR(PTrlFile) + StrSqlCond
 
     C                   ELSEIF    IntFldOnly AND NOT MainTrlOnly
     C                   EVAL      StrSQLStmt =
     C                               'select sum(FLDX) from ('               +
     C                               ' select ' + IntField + ' as FLDX from '+
     C                                  %TRIMR(PTrlFile) + StrSQLCond        +
     C                               ' union all '                           +
     C                               ' select ' + IntField + ' as FLDX from '+
     C                                  %TRIMR(PExtFile) + StrSQLCond        +
     C                               ') as MERGEDTAB'
 
     C                   ELSEIF    NOT IntFldOnly AND MainTrlOnly
     C                   EVAL      StrSQLStmt =
     C                               'select sum(' + IntField + ' * power(10,' +
     C                               %CHAR(A9LENDEC) + ') + ' + DecField + ') '+
     C                               'from ' + %TRIMR(PTrlFile) + StrSqlCond
 
     C                   ELSE
     C                   EVAL      StrSQLStmt =
     C                             'select sum(FLDX * power(10,'             +
     C                               %CHAR(A9LENDEC) + ') + FLDY) from ('    +
     C                             ' select ' + IntField + ' as FLDX, '      +
     C                                  DecField + ' as FLDY '               +
     C                             '  from ' + %TRIMR(PTrlFile) + StrSQLCond +
     C                             ' union all '                             +
     C                             ' select ' + IntField + ' as FLDX, '      +
     C                                  DecField + ' as FLDY '               +
     C                             '  from ' + %TRIMR(PExtFile) + StrSQLCond +
     C                             ') as MERGEDTAB'
     C                   ENDIF
     C/EXEC SQL
     C+                  prepare TrailSum from :StrSQLStmt
     C/END-EXEC
     C                   WHEN      pMode = 'OPEN'
     C/EXEC SQL
     C+                     open CsrTrailSum
     C/END-EXEC
     C                   WHEN      pMode = 'CLOSE'
     C/EXEC SQL
     C+                     close CsrTrailSum
     C/END-EXEC
     C                   WHEN      pMode = 'FETCH'
     C/EXEC SQL
     C+                     fetch next from CsrTrailSum into :SumTotal
     C/END-EXEC
     C                   ENDSL
 
      ** Set fields for error, clear if not
 
     C                   EVAL      DSLDA.DBASE = 5
     C                   EVAL      DSLDA.DBFILE = %TRIMR( PTrlFile )
     C                   EVAL      DSLDA.DBKEY = 'procCursor ' + pMode
 
     C                   IF        chkSQLError() <> 'ERR'
     C                   CLEAR                   DSLDA
     C                   ENDIF
 
     P procCursor      E
      *****************************************************************
