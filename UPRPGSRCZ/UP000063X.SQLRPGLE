     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Upgrade PF')                             *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP000063X - ADBU Upgrade PF - submit jos                     *
      *                                                               *
      *  (c) Finastra International 2020                              *
      *                                                               *
      *  Last Amend No. MD060709             Date 08Nov22             *
      *  Prev Amend No. MD050666 *CREATE     Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060709 - Change in LF dynamic selection is omitted         *
      *             File is not deleted when both DTAARA and file     *
      *             have the same name.                               *
      *             Change in PF key is omitted                       *
      *  MD050666 - Adaptive Database Upgrade                         *
      *                                                               *
      *****************************************************************
     D SQLEOF          C                   Const( 100 )
     D SQLOK           C                   Const( 0 )

     D Command         S            200
     D CommandLen      S             15  5 INZ(200)
     D SQLDynStmt      S          32000A
     D Err_Msg         S            200
     D xposs           S              5  0
     D xpose           S              5  0
     D xposi           S              5  0
     D field           S             10
     D Job_Count       S              5  0
     D STOP            S              1
     D RcdCount        S              5  0

     D SavFile         S             10A
     D @Fld            S              6A
     D DVLIB           S             10A
     D ERROR           S             10A
     D UPZSCR        E DS                  EXTNAME(UPZSCRTD)
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

      * Initialize Job_Count
     C                   eval      Job_Count = 0

      * Process SCTYPE = '  '
     C/exec SQL
     C+ declare Cursor1 cursor for
     C+ select *
     C+ from UPZSCRTD where SCPRFX = :Prefix and SCTYPE = '  '
     C+ and SCLIB = :Library
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

     C                   if        SCCDRN = ' '
     C                   if        SCFILE <> SavFile

     C                   EVAL      Command = 'SBMJOB CMD(CALL PGM(UP000063)'+
     C                             ' PARM(' + '''' + Prefix + '''' + ' ' +
     C                             '''' + RefSys + '''' + ' ' + '''' + SCFILE +
     C                             '''' + ' ' + '''' + Library + '''' + ' ' +
     C                             '''' + ' ' + '''' + ')) JOB(' + SCFILE +
     C                             ') JOBD(SETUP) JOBQ(SMJOBQNM) OUTQ(*JOBD)' +
     C                             ' INLLIBL(*CURRENT) INQMSGRPY(*SYSRPYL)'
     C                   CALL      'QCMDEXC'                            20
     C                   PARM                    Command
     C                   PARM                    CommandLen

     C                   eval      Job_Count = Job_Count + 1

     C/exec SQL
     C+ update UPZDRVTD set DRUPDD = 'S'
     C+ where DRFILE = :SavFile and DRLIB = :Library
     C/end-exec
     C                   Endif

     C                   eval      SavFile = SCFILE

     C                   Endif
     C/exec SQL
     C+ fetch next
     C+ from Cursor1
     C+ into :UPZSCR
     C/end-exec

     C                   eval      ERROR = '       '
     C                   ENDDO


     C/exec SQL
     C+ close Cursor1
     C/end-exec
     C
     C     End           TAG
     C                   eval      STOP = ' '

      * wait for driver update
     C                   DOU       STOP = 'Y'
     C                   EVAL      Command = 'DLYJOB DLY(3)'
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen

     C/exec SQL
     C+ select count(*) into :RcdCount from UPZDRVTD
     C+ where DRLIB = :Library and DRUPDD = 'Y'
     C/end-exec
     C                   if        RcdCount =  Job_Count
     C                   eval      STOP = 'Y'
     C                   endif

      ** If RcdCount is greater than Job_Count, then check than none are submitted          MD060709
      ** (case where DTAARA and file are to be deleted - IRCIRSUPD)                         MD060709
     C                   if        RcdCount >  Job_Count                                    MD060709
     C/exec SQL                                                                             MD060709
     C+ select count(*) into :RcdCount from UPZDRVTD                                        MD060709
     C+ where DRLIB = :Library and DRUPDD = 'S'                                             MD060709
     C/end-exec                                                                             MD060709
     C                   if        RcdCount =  0                                            MD060709
     C                   eval      STOP = 'Y'                                               MD060709
     C                   endif                                                              MD060709
     C                   endif                                                              MD060709
                                                                                            MD060709
     C                   ENDDO
     C
      * if all went well, send DONE message to server (UPC4015)
     C                   If        ERROR = *BLANKS
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

     C                   CALL      'QSNDDTAQ'
     C                   PARM      'ADBU_ZSVR'   DtqNam           10
     C                   PARM      '*LIBL'       DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'DONE'        DtqDta           50

     C                   else
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

     C                   CALL      'QSNDDTAQ'
     C                   PARM      'ADBU_ZSVR'   DtqNam           10
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
