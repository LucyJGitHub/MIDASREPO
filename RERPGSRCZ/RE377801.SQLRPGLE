     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas RE Accounts transferred to Inactive')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE377801 - Accounts transferred to Inactive                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR1097467B         Date 18Apr13               *
      *  Prev Amend No. AR1071130          Date 07Jan13               *
      *                 CRE083AV *CREATE   Date 06Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1097467B - Expected 15% CoB run optimisation not met       *
      *  AR1071130 - Amend RE377801 to increased MLoopRow from        *
      *              5U to 10S. Verify if there is a need to          *
      *              increase field size of other counter fields.     *
      *  CRE083AV - COB Restructure - Retail CoB Optimisation Phase 1 *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Logical Constants
      *
     D True            C                   Const(*ON)
     D False           C                   Const(*OFF)
     D SQLOK           C                   Const(0)
     D SQLEoF          C                   Const(100)
     D*ACACRows**      C                   Const(500)                                     AR1097467B
     D ACACRows        C                   Const(32000)                                   AR1097467B
     D Error           S              1A
      *
      ** DataStructure of Variables
      *
     D                 DS                  Inz
     D ACACReturned                   5U 0
     D*ACACIdx**                      5U 0                                                AR1097467B
     D ULRows                         5U 0
     D MLoopCtr                       5U 0
     D*MLoopRow*                      5U 0                                                 AR1071130
     D MLoopRow                      10S 0                                                 AR1071130
     D StopMLoop                      1N
     D CutOffDate                          LIKE(ACACL0DS.LACD)
      *
      ** AO Program Parameters
      *
     D WRTCD                          7A
     D WOPTN                          7A
     D SDBANKDS      E DS                  Inz
     D                                     EXTNAME(SDBANKPD)
     D SDRETLDS      E DS                  Inz
     D                                     EXTNAME(SDRETLPD)
      *
      ** Data Structures for SQL Results
      *
     D*ACACL0DS*     E DS                  Occurs(ACACRows) Inz                           AR1097467B
     D ACACL0DS      E DS                  Dim(ACACRows) Inz                              AR1097467B
     D                                     Qualified
     D                                     EXTNAME(REACNTK0)
 
     D INACPDDS      E DS                  Inz
     D                                     Dim(ACACRows)                                  AR1097467B
     D                                     Qualified
     D                                     EXTNAME(REINACPD)
      *
      ** Local Data Area
      *
     D LDA             DS           256    Inz DTAARA(LDA)
     D  DBFILE               134    141A
     D  DBKEY                142    170A
     D  DBPGM                171    180A
     D  DBASE                181    183S 0
      *
      ** Error Subroutine Variables
      *
     D                 DS                  Inz
     D  SRFILE                             LIKE(DBFILE)
     D  SRKEY                              LIKE(DBKEY)
     D  SRPGM                              LIKE(DBPGM)
     D  SRBASE                             LIKE(DBASE)
      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************
      *
      ** Clear REINACPD to make room for new ones
      *
     C/EXEC SQL
     C+ delete from REINACPD
     C/END-EXEC
     C                   IF        SQLCODE <> SQLOK and
     C                             SQLCODE <> SQLEoF
     C                   EVAL      SRBASE = 3
     C                   EVAL      SRFILE = 'REINACPD'
     C                   EVAL      SRKEY = *BLANKS
     C                   EVAL      SRPGM = 'RE377801'
     C                   EXSR      DBERR
     C                   RETURN
     C                   ENDIF
      *
      ** Select all records in Active Accounts File
      ** as Active Accounts Cursor
      *
     C/EXEC SQL
     C+ declare ACACCUR insensitive scroll cursor for
     C+ select *
     C+  from REACNTK0
     C+  where LACD < :CUTOFFDATE
     C+  order by LACD
     C+ for read only                                                                     AR1097467B
     C+ optimize for 32000 rows                                                           AR1097467B
     C/END-EXEC
      *
      ** OPEN cursor to retrieve total number of
      ** rows of REACNTK0 and for FETCH
      *
     C/EXEC SQL
     C+ open ACACCUR
     C/END-EXEC
 
     C/EXEC SQL
     C+ get diagnostics :MLOOPROW = DB2_NUMBER_ROWS
     C/END-EXEC
      *
     C                   IF        MLoopRow = 0
     C                   RETURN
     C                   ENDIF
      *
     C                   IF        MLoopRow > ACACRows
     C                   EVAL      ULRows = ACACRows
      *
     C                   EVAL      MLoopCtr = %DIV(MLoopRow:ACACRows)
      *
     C                   IF        %REM(MLoopRow:ACACRows) <> 0
     C                   EVAL      MLoopCtr += 1
     C                   ENDIF
      *
     C                   ELSE
     C                   EVAL      ULRows = MLoopRow
     C                   EVAL      MLoopCtr = 1
     C                   ENDIF
      *
      ** Start fetch loop
      *
     C                   DOW       MLoopCtr > 0 and
     C                             StopMLoop = False
      *
      ** FETCH by batch of ULROWS into ACACL0DS and determine
      ** number of rows retrieved for this batch
      *
     C/EXEC SQL
     C+ fetch next from ACACCur for
     C+  :ULROWS rows into :ACACL0DS
     C/END-EXEC
      *
     C                   EVAL      ACACReturned = SQLER3
      *
      ** Error in SQL
      *
     C                   IF        SQLCODE <> SQLOK
     C                             or SQLCODE = SQLEoF
     C                             or ACACReturned = 0
     C                   EVAL      SRBASE = 4
     C                   EVAL      SRFILE = 'REACNTK0'
     C                   EVAL      SRKEY = *BLANKS
     C                   EVAL      SRPGM = 'RE377801'
     C                   EXSR      DBERR
     C                   LEAVE
     C                   ENDIF
 
     C**********         EVAL      ACACIdx = 1                                            AR1097467B
      *****************************************************************                   AR1097467B
     C**********         DOW       ACACIdx <= ACACReturned                                AR1097467B
      *****************************************************************                   AR1097467B
     C**********         EVAL      %Occur(ACACL0DS) = ACACIdx                             AR1097467B
      *****************************************************************                   AR1097467B
      *
      ** Place value of corresponding fields from
      ** ACACL0DS to INACPDDS (same field name and type)
      *
     C                   EVAL-CORR INACPDDS = ACACL0DS
      *
      ** Insert inactive accounts to Inactive account file
      ** from INACPDDS data structure
      *
     C                   IF        ACACReturned > 0                                       AR1097467B
     C/EXEC SQL
     C+ insert into REINACPD
     C+ :ACACReturned rows                                                                AR1097467B
     C+  values(:INACPDDS)
     C/END-EXEC
     C                   IF        SQLCODE <> SQLOK
     C                             or SQLCODE = SQLEoF
     C                             or SQLER3 = 0
     C                   EVAL      SRBASE = 5
     C                   EVAL      SRFILE = 'REINACPD'
     C                   EVAL      SRKEY = *BLANKS
     C                   EVAL      SRPGM = 'RE377801'
     C                   EXSR      DBERR
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF                                                            AR1097467B
 
     C**********         EVAL      ACACIdx += 1                                           AR1097467B
      *****************************************************************                   AR1097467B
     C**********         ENDDO                                                            AR1097467B
      *****************************************************************                   AR1097467B
     C                   EVAL      MLoopCtr -= 1
     C                   ENDDO
      *
      ** CLOSE Cursor Fetch
      *
     C/EXEC SQL
     C+ close ACACCur
     C/END-EXEC
      *
      ** End Program
      *
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  Initial Subroutine                                           *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    ERROR
      *
      **  Get details for SDBANKPD.BJRDNB (Current Run Date) and
      **  SDRETLPD.BMNDBI (Number Of Days Before Inactive)
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM                    SDBANKDS
      *
     C                   IF        WRTCD <> *BLANKS
     C                   EVAL      SRBASE = 1
     C                   EVAL      SRFILE = 'SDBANKPD'
     C                   EVAL      SRKEY = *BLANKS
     C                   EVAL      SRPGM = 'RE377801'
     C                   EXSR      DBERR
     C                   RETURN
     C                   ENDIF
      *
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       WRTCD
     C                   PARM      '*VERIFY'     WOPTN
     C                   PARM                    SDRETLDS
      *
     C                   IF        WRTCD <> *BLANKS
     C                   EVAL      SRBASE = 2
     C                   EVAL      SRFILE = 'SDRETLPD'
     C                   EVAL      SRKEY = *BLANKS
     C                   EVAL      SRPGM = 'RE377801'
     C                   EXSR      DBERR
     C                   RETURN
     C                   ENDIF
      *
     C                   IF        Error = 'Y'
     C                   RETURN
     C                   ENDIF
      *
      ** Calculate the cut-off date as current rundate less
      ** number of days before inactive
      *
     C                   EVAL      CutOffDate =  BJRDNB - BMNDBI
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  DBASE Error Subprocedure                                     *
      *                                                               *
      *****************************************************************
     C     DBERR         BEGSR
     C                   EVAL      Error = 'Y'
     C                   EVAL      StopMLoop = True
     C                   EVAL      *INU7 = True
     C                   EVAL      *INU8 = True
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = SRBASE
     C                   EVAL      DBFILE = SRFILE
     C                   EVAL      DBKEY = SRKEY
     C                   EVAL      DBPGM = SRPGM
     C                   OUT       LDA
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
