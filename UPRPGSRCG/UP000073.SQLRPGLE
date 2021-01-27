     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Upgrade PF global')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000073 - ADBU Upgrade PF global                            *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD050666 *CREATE     Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050666 - Adaptive Database Upgrade                         *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D Command         S            100
     D CommandLen      S             15  5 INZ(100)
     D SQLDynStmt      S          32000A
     D Err_Msg         S            200
     D xposs           S              5  0
     D xpose           S              5  0
     D xposi           S              5  0
     D field           S             10

     D SavFile         S             10A
     D @Fld            S              6A
     D DVLIB           S             10A
     D ERROR           S             10A
     D X_SCCMD         S            100A
     D UPGLGU        E DS                  EXTNAME(UPGLGUTD)
     D UPGSCR        E DS                  EXTNAME(UPGSCRTD)
     D/COPY ZACPYSRC,PSDS
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    Prefix            2
     C                   PARM                    RefSys            2
     C                   PARM                    Library          10
     C                   PARM                    ERROR

     C                   exsr      SR_UPD

      * Process SCTYPE = '  '
     C/exec SQL
     C+ declare Cursor1 cursor for
     C+ select *
     C+ from UPGSCRTD where SCPRFX = :Prefix and SCTYPE = '  '
     C+ and SCLIB = :Library
     C+ order by SCSEQ
     C/end-exec

     C/exec SQL
     C+ open Cursor1
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Cursor1
     C+ into :UPGSCR
     C/end-exec


     C                   DOW       SQLCODE = 0

     C                   if        SCCDRN = ' '
     C                   if        SCFILE <> SavFile
     C                             and SavFile <> *BLANKS
     C/exec SQL
     C+ update UPGDRVTD set DRUPDD = 'Y'
     C+ where DRFILE = :SavFile
     C/end-exec
     C                   Endif

     C                   eval      Command = SCCMD

      * select if CLP or SQL
     C                   SELECT

     C                   When      SCCMTY = 'CLP'

      * log command
      ** Generate TimeStamp

     C                   CALL      'ZAGENTS'
     C                   PARM                    ULTMST
     C                   eval      X_SCCMD = %subst(SCCMD:1:100)
     C/EXEC SQL
     C+ insert into UPGLGUTD
     C+ (
     C+   ULTMST
     C+  ,ULCMDE
     C+ )
     C+ Values
     C+ (
     C+   :ULTMST
     C+  ,:X_SCCMD
     C+ )
     C/END-EXEC

     C                   CALL(E)   'UPCGENER'
     C                   PARM                    Prefix
     C                   PARM                    Command
     C                   PARM                    ERROR

     C                   eval      SavFile = SCFILE

     C                   if        ERROR <> *BLANKS
     C/EXEC SQL
     C+ insert into UPGLGUTD
     C+ (
     C+   ULTMST
     C+  ,ULCMDE
     C+ )
     C+ Values
     C+ (
     C+   :ULTMST
     C+  ,'Previous command failed'
     C+ )
     C/END-EXEC

     C                   CALL      'UP4040'
     C                   PARM                    Prefix
     C                   PARM                    SCFILE
     C                   PARM      'UP000073'    PSPROCPGM        10
     C                   PARM                    Command
     C                   PARM                    SCCMTY
     C                   PARM                    ERROR
     C                   dump
     C*****              goto      End
     C                   Endif

     C                   MONITOR
     C                   ON-ERROR
     C                   ENDMON

     C                   When      SCCMTY = 'SQL'
     C                   eval      SQLDynStmt = *BLANKS
     C                   eval      SQLDynStmt = SCCMD

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   eval      SavFile = SCFILE

      ** in case of conversion error
     C                   Dow       SQLCode  = -406
     C/exec SQL
     C+ SELECT cast(message_text as char(200) ccsid 37)
     C+ into :Err_Msg
     C+ FROM table(qsys2.joblog_info('*')) a
     C+ where a.MESSAGE_ID = 'SQL0406'
     C+ order by a.ORDINAL_POSITION desc
     C/end-exec

     C                   If        SQLCode = 0
     C                             or SQLCode = -811
      * look for field
     C                   eval      xpose = %scan('.':Err_Msg:1)
     C                   eval      xposi = %scan(' ':Err_Msg:xpose-11)
     C                   eval      xposs = %scan(' ':Err_Msg:xposi+1)
     C                   if        xposs > xpose
     C                   eval      xposs = xposi
     C                   ENDIF
     C                   eval      field = %subst(Err_Msg:xposs+1:xpose-xposs-1)
      * search for field in SQL string
     C                   eval      xposs = %scan(%trimr(field):SQLDynStmt:1)
      * search for the next coma
     C                   eval      xpose = %scan(',':SQLDynStmt:xposs)
      * if not found, remove 3 (start position + ' ' + ',')
     C                   if        xpose = 0
     C                   eval      xpose = xposs - 3
     C                   eval      SQLDynStmt = %trimr(%subst(SQLDynStmt: +
     C                             1:xposs-3))
     C                   else
      * re-run SQL without the field
     C                   eval      SQLDynStmt = %trimr(%subst(SQLDynStmt: +
     C                             1:xposs-1)) +
     C                             %trimr(%subst(SQLDynStmt: +
     C                             xpose+1:32000-xpose))
     C                   endif

     C/EXEC SQL
     C+ prepare DynSQLStmnt
     C+ from :SQLDynStmt
     C/END-EXEC

     C/exec SQL
     C+ execute DynSQLStmnt
     C/end-exec

     C                   ENDIF
     C                   ENDDO


     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   CALL      'UP4040'
     C                   PARM                    Prefix
     C                   PARM                    SCFILE
     C                   PARM      'UP000073'    PSPROCPGM        10
     C                   PARM                    Command
     C                   PARM                    SCCMTY
     C                   PARM                    ERROR
     C                   dump
     C*****              goto      End
     C                   Endif

     C                   ENDSL
     C                   If        ERROR = '*Error'
     C/exec SQL
     C+ update UPGSCRTD set SCCDRN = 'E'
     C+ where current of Cursor1
     C/end-exec
     C                   else
     C/exec SQL
     C+ update UPGSCRTD set SCCDRN = 'Y'
     C+ where current of Cursor1
     C/end-exec
     C                   ENDIF
     C                   Endif
     C/exec SQL
     C+ fetch next
     C+ from Cursor1
     C+ into :UPGSCR
     C/end-exec

     C                   eval      ERROR = '       '
     C                   ENDDO

     C                   If        SavFile <> *BLANKS
     C/exec SQL
     C+ update UPGDRVTD set DRUPDD = 'Y'
     C+ where DRFILE = :SavFile
     C/end-exec
     C                   Endif

     C/exec SQL
     C+ close Cursor1
     C/end-exec
     C
     C     End           TAG

      * if all went well, send DONE message to server (UPC4015)
     C                   If        ERROR = *BLANKS
      * update job end time field
     C                   eval      @Fld = 'UP' + %subst(Library:3:2) + 'ED'
     C                   TIME                    ##TME             6 0
     C                   eval      UPDVAL = %CHAR(##TME)

     C                   CALL      'UPGUPDWR'
     C                   PARM      '*UPDATE'     UPDACT           10
     C                   PARM                    Prefix
     C                   PARM      @Fld          UPDFLD
     C                   PARM                    UPDVAL
     C                   PARM                    ERROR
     C                   PARM                    RETURN

      * update job status field
     C                   eval      @Fld = 'UP' + %subst(Library:3:2) + 'SS'
     C                   eval      UPDVAL = 'C'

     C                   CALL      'UPGUPDWR'
     C                   PARM      '*UPDATE'     UPDACT           10
     C                   PARM                    Prefix
     C                   PARM      @Fld          UPDFLD           10
     C                   PARM                    UPDVAL          100
     C                   PARM                    ERROR
     C                   PARM                    RETURN           10

     C                   If        RETURN <> *BLANKS
     C                   exsr      *pssr
     C                   endif

     C                   CALL      'QSNDDTAQ'
     C                   PARM      'ADBU_GSVR'   DtqNam           10
     C                   PARM      '*LIBL'       DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'DONE'        DtqDta           50

     C                   else
      * update job end time field
     C                   eval      @Fld = 'UP' + %subst(Library:3:2) + 'ED'
     C                   TIME                    ##TME             6 0
     C                   eval      UPDVAL = %CHAR(##TME)

     C                   CALL      'UPGUPDWR'
     C                   PARM      '*UPDATE'     UPDACT           10
     C                   PARM                    Prefix
     C                   PARM      @Fld          UPDFLD
     C                   PARM                    UPDVAL
     C                   PARM                    ERROR
     C                   PARM                    RETURN

      * update job status field
     C                   eval      @Fld = 'UP' + %subst(Library:3:2) + 'SS'
     C                   eval      UPDVAL = 'A'

     C                   CALL      'UPGUPDWR'
     C                   PARM      '*UPDATE'     UPDACT           10
     C                   PARM                    Prefix
     C                   PARM      @Fld          UPDFLD
     C                   PARM                    UPDVAL
     C                   PARM                    ERROR
     C                   PARM                    RETURN

     C                   If        RETURN <> *BLANKS
     C                   exsr      *pssr
     C                   endif

     C                   CALL      'QSNDDTAQ'
     C                   PARM      'ADBU_GSVR'   DtqNam           10
     C                   PARM      '*LIBL'       DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'FAIL'        DtqDta           50

     C                   endif

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      ********************************************************************
      /EJECT
      *****************************************************************
      *
     C     SR_UPD        BEGSR

      * update job number field
     C                   eval      @Fld = 'UP' + %subst(Library:3:2) + 'JN'
     C                   eval      UPDVAL = %EDITC(PSJobNo:'X')

     C                   CALL      'UPGUPDWR'
     C                   PARM      '*UPDATE'     UPDACT           10
     C                   PARM                    Prefix
     C                   PARM      @Fld          UPDFLD
     C                   PARM                    UPDVAL
     C                   PARM                    ERROR
     C                   PARM                    RETURN

     C                   If        ERROR <> *BLANKS
     C                   exsr      *pssr
     C                   endif

      * update job status field
     C                   eval      @Fld = 'UP' + %subst(Library:3:2) + 'SS'
     C                   eval      UPDVAL = 'R'

     C                   CALL      'UPGUPDWR'
     C                   PARM      '*UPDATE'     UPDACT           10
     C                   PARM                    Prefix
     C                   PARM      @Fld          UPDFLD
     C                   PARM                    UPDVAL
     C                   PARM                    ERROR
     C                   PARM                    RETURN

     C                   If        ERROR <> *BLANKS
     C                   exsr      *pssr
     C                   endif

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
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
