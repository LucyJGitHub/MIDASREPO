     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG SQL requests validity checking')              *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3607 - Midas CG SQL Requests checking                      *
      *                                                               *
      *  Function:  This module checks SQL requests                   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR659584           Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CCG015  *CREATE    Date 05Nov01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR659584 - Authorisation error when PTF SI29733 is applied.  *
      *             To connect to the database using the current user *
      *             profile, the userid and pwd should not be speci-  *
      *             fied or they must be passed as null.              *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *---------------------------------------------------------------*
      *
      ** Include copy member with CLI prototypes and SQL variables
     D/COPY CGCPYSRC,CLIPROTO
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Retrieve database name
     DRtvDataBase      PR            18A
 
      ** Program variables used by CLI interface
     DSQL_RC           S             10I 0
     Dhenv             S             10I 0
     Dhdbc             S             10I 0
     DDBName           S             18A
     DpDBName          S               *   INZ(%ADDR(DBName))
     DDBUser           S             10A
     D***pDBUser          S               *   INZ(%ADDR(DBUser))                            AR659584
     DpDBUser          S               *   INZ(*NULL)                                       AR659584
     DDBPwd            S             10A
     D***pDBPwd           S               *   INZ(%ADDR(DBPwd))                             AR659584
     DpDBPwd           S               *   INZ(*NULL)                                       AR659584
     DConnOpt          S              5I 0
     DIslLvl           S             10I 0
     DpIslLvl          S               *   INZ(%ADDR(IslLvl))
     DEnvOpt           S              5I 0
     DAttEnv           S             10I 0
     DpAttEnv          S               *   INZ(%ADDR(AttEnv))
     DAttLen           S              5I 0
     Dhstmt            S             10I 0
     DSQLStm           S            500A
     DpSQLStm          S               *   INZ(%ADDR(SQLStm))
     DSQLState         S              6A
     DpSQLState        S               *   INZ(%ADDR(SQLState))
     DSQLCode          S             10I 0
     DSQLMsg           S            256A
     DpSQLMsg          S               *   INZ(%ADDR(SQLMsg))
     DMsgLenMax        S              5I 0
     DMsgLen           S              5I 0
     DZeroBin          S            128A   INZ(*ALLX'00')
     DReturnMsg        S                   LIKE(SQLMsg)
 
      ** Begin of CLI initialization tasks
     C                   EXSR      SQLInit
 
      ** Prepare SQL statement
     C                   EXSR      SQLPrep
 
      ** CLI Termination tasks
     C                   EXSR      SQLTerminate
 
     C                   RETURN
      **********************************************************************
      * SQL Initialisation                                                 *
      **********************************************************************
      *
     C     SQLInit       BEGSR
     C                   EVAL      ReturnCode = *BLANK
     C                   EVAL      ReturnMsg = *BLANK
     C                   EVAL      MsgLenMax = SQL_MAXMSG + 1
      ** Allocate environment handle
     C                   EVAL      SQL_RC = SQLAlcEnv(henv)
     C                   IF        SQL_RC <> SQL_OK
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set environment options
     C                   EVAL      EnvOpt = SQL_AT_SYSNAM
     C                   EVAL      AttEnv = SQL_TRUE
     C                   EVAL      SQL_RC = SQLSetEnvA(henv:EnvOpt:
     C                                                 pAttEnv:AttLen)
     C                   IF        SQL_RC <> SQL_OK
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBASE = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Allocate connection handle
     C                   EVAL      SQL_RC = SQLAlcCon(henv:hdbc)
     C                   IF        SQL_RC <> SQL_OK
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBASE = 3
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set connection options
     C                   EVAL      ConnOpt = SQL_ISOLVL
     C                   EVAL      IslLvl = SQL_NONE
     C                   EVAL      SQL_RC = SQLSetCnOp(hdbc:
     C                                             ConnOpt:pIslLvl)
     C                   IF        SQL_RC <> SQL_OK
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBASE = 4
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve database
     C                   EVAL      DBName = RtvDataBase
     C                   IF        DBName = *LOVAL
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBASE = 12
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Connect to database
     C                   EVAL      DBName = (%TRIM(DBName))+Zerobin
     C                   EVAL      SQL_RC = SQLConnect(hdbc:
     C                                       pDBName:SQL_NTS:
     C                             pDBUser:SQL_NTS:pDBPwd:SQL_NTS)
     C                   IF        SQL_RC <> SQL_OK
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBASE = 5
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      * SQL Prepare                                                        *
      **********************************************************************
      *
     C     SQLPrep       BEGSR
 
     C                   EVAL      SQLStm = SQLStatement
     C                   EVAL      SQLStm = (%TRIM(SQLStm))+Zerobin
     C                   EVAL      SQL_RC = SQLAlcStmt(hdbc:hstmt)
     C                   EVAL      SQL_RC = SQLPrepare(hstmt:pSQLStm:SQL_NTS)
     C                   IF        SQL_RC <> SQL_OK
     C                   EVAL      SQL_RC = SQLError(henv:hdbc:hstmt:pSQLState:
     C                             SQLCode:pSQLMsg:MsgLenMax:MsgLen)
     C                   EVAL      ReturnMsg = %STR(pSQLMsg)
     C                   EVAL      ReturnCode = '*FAIL'
     C                   ENDIF
 
     C                   EVAL      SQL_RC = SQLFreeStm(hstmt:SQL_DROP)
     C                   IF        SQL_RC <> SQL_OK
     C                   EVAL      SQL_RC = SQLError(henv:hdbc:hstmt:pSQLState:
     C                             SQLCode:pSQLMsg:MsgLenMax:MsgLen)
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBASE = 8
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      * SQL Termination                                                    *
      **********************************************************************
      *
     C     SQLTerminate  BEGSR
      ** Disconnect form database
     C                   EVAL      SQL_RC = SQLDisconn(hdbc)
     C                   IF        SQL_RC <> SQL_OK
     C                   EVAL      SQL_RC = SQLError(henv:hdbc:hstmt:pSQLState:
     C                             SQLCode:pSQLMsg:MsgLenMax:MsgLen)
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBASE = 9
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Free connection handle
     C                   EVAL      SQL_RC = SQLFreeCon(hdbc)
     C                   IF        SQL_RC <> SQL_OK
     C                   EVAL      SQL_RC = SQLError(henv:hdbc:hstmt:pSQLState:
     C                             SQLCode:pSQLMsg:MsgLenMax:MsgLen)
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBASE = 10
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Free environment handle
     C                   EVAL      SQL_RC = SQLFreeEnv(henv)
     C                   IF        SQL_RC <> SQL_OK
     C                   EVAL      SQL_RC = SQLError(henv:hdbc:hstmt:pSQLState:
     C                             SQLCode:pSQLMsg:MsgLenMax:MsgLen)
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EVAL      DBASE = 11
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      **********************************************************************
      * Initialisation Subroutine                                          *
      **********************************************************************
      *
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
      ** Return code
      ** Possible values are:
      ** - *ERROR:
     C                   PARM                    ReturnCode       10
     C                   PARM                    ReturnMsg
     C                   PARM                    SQLStatement    500
      *
     C                   ENDSR
     C/COPY ZACPYSRC,PSSR_ILE
      **********************************************************************
      * Retrieve database name                                             *
      **********************************************************************
     PRtvDataBase      B
     DRtvDataBase      PI            18
 
     DRtnCode          S             10
     DDataBase         S             18
     DRemoteLoc        S            256
 
     C                   CALL(E)   'CGC3600'
     C                   PARM      '*LOCAL'      RemoteLoc
     C                   PARM      *BLANK        DataBase
     C                   PARM                    RtnCode
 
     C                   IF        %ERROR OR RtnCode <> *BLANK
     C                   EVAL      DataBase = *LOVAL
     C                   EVAL      DBFILE = 'CGC3600'
     C                   EVAL      DBKEY = '*LOCAL'
     C                   EVAL      DBASE = 1
     C                   DUMP
     C                   ENDIF
 
     C                   RETURN    DataBase
     P                 E
