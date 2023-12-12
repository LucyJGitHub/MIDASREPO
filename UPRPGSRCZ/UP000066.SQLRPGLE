     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Upgrade LF')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000066 - ADBU Upgrade LF                                   *
      *                                                               *
      *  (c) Finastra International 2020                              *
      *                                                               *
      *  Last Amend No. MD061992             Date 23Oct23             *
      *  Prev Amend No. CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061992 - Allow 3 char prefix for reference libraries       *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D Command         S            100
     D CommandLen      S             15  5 INZ(100)
     D SQLDynStmt      S          32000A

     D SavFile         S             10A
     D @Fld            S              6A
     D DVLIB           S             10A
     D ERROR           S             10A
     D X_SCCMD         S            100A
     D UPZSCR        E DS                  EXTNAME(UPZSCRTD)
     D UPZLGU        E DS                  EXTNAME(UPZLGUTD)
     D/COPY ZACPYSRC,PSDS
       /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN PROCESSING                                              *
      *                                                               *
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    Prefix            2
     C**********         PARM                    RefSys            2                        MD061992
     C                   PARM                    RefSys            3                        MD061992
     C                   PARM                    Library          10
     C                   PARM                    ERROR

     C                   exsr      SR_UPD

      * Process SCTYPE = '  '
     C/exec SQL
     C+ declare Cursor1 cursor for
     C+ select *
     C+ from UPZSCRTD where SCTYPE = '  '
     C+ and SCLIB like '%VLIB%'
     C+ order by SCSEQ
     C/end-exec

     C/exec SQL
     C+ open Cursor1
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from Cursor1
     C+ into :UPZSCR
     C/end-exec


     C                   DOW       SQLCODE = 0

     C                   eval      ERROR = '          '
     C                   if        SCFILE <> SavFile
     C                             and SavFile <> *BLANKS
     C/exec SQL
     C+ update UPZDRVTD set DRUPDD = 'Y'
     C+ where DRFILE = :SavFile
     C/end-exec
     C                   Endif

     C                   eval      Command = SCCMD
      * log command
      ** Generate TimeStamp

     C                   CALL      'ZAGENTS'
     C                   PARM                    ULTMST
     C                   eval      X_SCCMD = %subst(SCCMD:1:100)
     C/EXEC SQL
     C+ insert into UPZLGUTD
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

      * select if CLP or SQL
     C                   SELECT

     C                   When      SCCMTY = 'CLP'

     C                   CALL(E)   'UPCGENER'
     C                   PARM                    Prefix
     C                   PARM                    Command
     C                   PARM                    ERROR

     C                   eval      SavFile = SCFILE

     C                   if        ERROR <> *BLANKS
     C                   CALL      'UP4040'
     C                   PARM                    Prefix
     C                   PARM                    SCFILE
     C                   PARM      'UP000066'    PSPROCPGM        10
     C                   PARM                    Command
     C                   PARM                    SCCMTY
     C                   PARM                    ERROR
     C                   dump
     C***                goto      End
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

     C                   If        SQLCode <> 0
     C                             and SQLCode <> 100
     C                   eval      ERROR = '*Error'
     C                   CALL      'UP4040'
     C                   PARM                    Prefix
     C                   PARM                    SCFILE
     C                   PARM      'UP000066'    PSPROCPGM        10
     C                   PARM                    Command
     C                   PARM                    SCCMTY
     C                   PARM                    ERROR
     C                   dump
     C***                goto      End
     C                   Endif

     C                   ENDSL

     C                   If        ERROR = '*Error'
     C/EXEC SQL
     C+ insert into UPZLGUTD
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
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = 'E'
     C+ where current of Cursor1
     C/end-exec
     C                   Else

      * update 'Command has run' flag
     C/exec SQL
     C+ update UPZSCRTD set SCCDRN = 'Y'
     C+ where current of Cursor1
     C/end-exec
      * and send DTAQ message to refresh monitor screen
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'UPZADBUDTQ'  DtqNam           10
     C                   PARM      '*LIBL'       DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'REFRESH'     DtqDta2          10
     C                   Endif

     C/exec SQL
     C+ fetch next
     C+ from Cursor1
     C+ into :UPZSCR
     C/end-exec

     C                   ENDDO

     C                   If        SavFile <> *BLANKS
     C/exec SQL
     C+ update UPZDRVTD set DRUPDD = 'Y'
     C+ where DRFILE = :SavFile
     C/end-exec
     C                   Endif

     C/exec SQL
     C+ close Cursor1
     C/end-exec
     C
     C     End           TAG

      * if all went well, send DON message to server (UPC4015)
     C                   If        ERROR = *BLANKS
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'ADBU_ZSVR'   DtqNam           10
     C                   PARM      '*LIBL'       DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'DONE'        DtqDta           50

      * update job status field
     C                   eval      @Fld = 'UP' + %subst(Library:3:2) + 'SS'
     C                   eval      UPDVAL = 'C'

     C                   CALL      'UPZUPDWR'
     C                   PARM      '*UPDATE'     UPDACT           10
     C                   PARM                    Prefix
     C                   PARM      @Fld          UPDFLD           10
     C                   PARM                    UPDVAL          100
     C                   PARM                    ERROR
     C                   PARM                    RETURN           10

     C                   If        RETURN <> *BLANKS
     C                   exsr      *pssr
     C                   endif

     C                   else
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'ADBU_ZSVR'   DtqNam           10
     C                   PARM      '*LIBL'       DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'FAIL'        DtqDta           50

      * update job status field
     C                   eval      @Fld = 'UP' + %subst(Library:3:2) + 'SS'
     C                   eval      UPDVAL = 'A'

     C                   CALL      'UPZUPDWR'
     C                   PARM      '*UPDATE'     UPDACT           10
     C                   PARM                    Prefix
     C                   PARM      @Fld          UPDFLD
     C                   PARM                    UPDVAL
     C                   PARM                    ERROR
     C                   PARM                    RETURN

     C                   If        RETURN <> *BLANKS
     C                   exsr      *pssr
     C                   endif

     C                   endif

      * update job end time field
     C                   eval      @Fld = 'UP' + %subst(Library:3:2) + 'ED'
     C                   TIME                    ##TME             6 0
     C                   eval      UPDVAL = %CHAR(##TME)

     C                   CALL      'UPZUPDWR'
     C                   PARM      '*UPDATE'     UPDACT           10
     C                   PARM                    Prefix
     C                   PARM      @Fld          UPDFLD
     C                   PARM                    UPDVAL
     C                   PARM                    ERROR
     C                   PARM                    RETURN

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
     C                   eval      UPDVAL = %CHAR(PSJobNo)

     C                   CALL      'UPZUPDWR'
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

     C                   CALL      'UPZUPDWR'
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
