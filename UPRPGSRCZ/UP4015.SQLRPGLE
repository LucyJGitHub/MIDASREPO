     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Update Monitor')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP4015 - ADBU Update Monitor                                 *
      *                                                               *
      *  (c) Finastra International 2020                              *
      *                                                               *
      *  Last Amend No. MD061992             Date 23Oct23             *
      *  Prev Amend No. MD061706             Date 01Aug23             *
      *                 MD060271             Date 21Jul22             *
      *                 CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061992 - Allow 3 char prefix for reference libraries       *
      *  MD061706 - Various changes for transition to aDBU            *
      *  MD060271 - Dashed line appeared trimmed                      *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************
      * Indicators                                                    *
      *                                                               *
      *      37 - Time Ended is not blank                             *
      *      38 - Script Complete                                     *
      *      39 - Display Narratives                                  *
      *                                                               *
      *****************************************************************
     FUP4015DF  CF   E             WORKSTN

     D #_DLYJOB        S             70    DIM(1)  CTDATA PERRCD(1)
     D #_FKEY          S             80    DIM(4)  CTDATA PERRCD(1)
     D Err_Ms          S            100    DIM(5)
     D V_TOTF          S              5  0
     D V_EXFMT         S              1
     D SQLOK           C                   Const( 0 )
     D SQLEOF          C                   Const( 100 )
     D Command         S             60
     D CommandLen      S             15  5 INZ(60)
     D RcdCount        S              5  0
     D XTOTN           S              5  0
     D XPROCN          S             10  0
     D #_SCRS          S              1
     D dly             S              1

     D Color           C                   X'21'
     D Normal          C                   X'20'
     D Line            S            100A   Inz
     D i               S              3P 0
     D Ix              S              3P 0
     D Div             S              3P 0

     DRtnCode          S             10
     DObjName          S             10
     DObjLib           S             10
     DObjType          S              8
     DChkMbr           S             10
     D WkTime          S              5S 0
     DTIME0            S               T   INZ(T'00.00.00')
     DN_VAR            S              6  0
     DC_VAR8           S              8
     DEMSG             S            100

     D UPZUPD        E DS                  EXTNAME(UPZUPDTD)
     D UPZUPD_S      E DS                  EXTNAME(UPZUPDTD)
     D                                     PREFIX(S_)

     D C_DOTL          C                   Const('--------------------------                MD060271
     D                                     -----------------------------------              MD060271
     D                                     -----------------------------------              MD060271
     D                                     -----------------------------------              MD060271
     D                                     -----------------------------------')            MD060271
     D/COPY ZACPYSRC,PSDS
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PREFIX            2
     C**********         PARM                    REFSYS            2                        MD061992
     C                   PARM                    REFSYS            3                        MD061992
     C                   PARM                    ERROR            10
     C                   PARM                    OTBU              1                        MD061706

     C                   eval      ERROR = *BLANK
     C                   eval      ##JOB = PSJobName
     C                   eval      ##USR = PSUser
     C                   seton                                        09

      * Retrieve Zone Compare Work File UPZUPDTD
     C/exec SQL
     C+ select * into :UPZUPD
     C+ from UPZUPDTD where UPPRFX = :PREFIX
     C/end-exec
     C                   If        SQLCode <> SQLOK
     C                             and SQLCode <> SQLEOF
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif

      * Initialize display file
     C                   Exsr      SR_LOAD

      * While F3 is not selected
     C                   DOW       *INKC = *OFF
     C                   TIME                    ##TME
     C                   WRITE     CLEARF

      * *****************************************
      * If script is not complete, check progress
     C                   DOW       UPSCRS <> 'C'
     C                             and UPSCRS <> 'A'
     C                             and RcdCount <= XTOTN
     C                             and *INKB = *OFF

     C                   seton                                        10
     C                   TIME                    ##TME
     C                   WRITE     CLEARF
      * Reload script sctatus
     C/exec SQL
     C+ select UPSCRS into :#_SCRS
     C+ from UPZUPDTD where UPPRFX = :PREFIX
     C/end-exec

     C/exec SQL
     C+ select count(*) into :RcdCount from UPZDRVTD
     C+ where DRSCRP = 'Y'
     C/end-exec

     C                   If        RcdCount <= XTOTN
      * Total Number of Files processed so far
     C**                 eval      XPROCN = %Char(RcdCount)
     C                   eval      ##SCTP = RcdCount
     C                   eval(h)   Div = (RcdCount/XTOTN) * 100
     C                   eval      ##SCPC = %Char(Div) + '%'
     C*                  eval      i = (XPROCN/XTOTN) *100
     C                   eval      ##SCSS = Color + %Subst(Line:1:Div) + Normal
     C                   ENDIF

     C                   If        RcdCount = XTOTN
     C                   seton                                        29
     C                   Endif

      * Refresh elapsed time
     C                   TIME                    ##CURT
     C                   EVAL      WkTime = %DIFF(##CURT:##STRT:*SECONDS)
     C                   EVAL      ##LAPS = TIME0 + %SECONDS(WkTime)

     C                   WRITE     RCDKEYF
     C                   WRITE     SCRIPTF
     C                   WRITE     RECFMTF
     C                   EVAL      Command = #_DLYJOB(1)
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen

      * If all files are now processed by script, exit and display message
     C                   If        #_SCRS = 'C'
     C**                 If        RcdCount = XTOTN
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        3839
     C                   setoff                                       10
     C                   eval      ##NARR = '      Script has been generated.' +
     C                             ' Press F2 to continue.'
     C                   eval      ##NAR1 = *blanks
     C                   WRITE     SCRIPTF
     C                   leave
     C                   ENDIF

     C                   ENDDO
      *******************************************

      * Elapsed Time
      * If 'End Time' available
     C                   setoff                                       42
     C                   if        UPTMED <> *BLANKS
     C                   setoff                                       09
     C                   EVAL      ##KEY = #_FKEY(1)
     C                   If        OTBU <> 'Y'                                              MD061706
     C                   EVAL      ##KEYP = #_FKEY(2)
     C                   Endif                                                              MD061706
     C                   EVAL      WkTime = %DIFF(##ENDT:##STRT:*SECONDS)
     C                   EVAL      ##LAPS = TIME0 + %SECONDS(WkTime)
     C                   eval      ##NARR = 'Update is now complete. Press F7/'+
     C                             ' F8 to check reconcile reports'
      * check if Exception
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPADBETD
     C+ where
     C+     ERPRFX = :PREFIX
     C/end-exec
     C                   eval      ##NAR1 = *blanks
     C                   if        RcdCount > 0 and SQLCODE = 0
     C                   eval      ##NAR1 = 'There are ' + %char(RcdCount) +
     C                             ' exceptions. Press F6 to display Excepti' +
     C                             'on Report.'
     C                   seton                                        42
     C                   EVAL      ##KEY = #_FKEY(3)
     C                   EVAL      ##KEYP = #_FKEY(4)
     C                   If        OTBU = 'Y'                                               MD061706
     C                   EVAL      ##KEYP = %subst(##KEYP:1:21)                             MD061706
     C                   Endif                                                              MD061706
     C                   ENDIF

     C                   seton                                        39
     C                   else
      * If 'End Time' not available
     C                   TIME                    ##CURT
     C                   EVAL      WkTime = %DIFF(##CURT:##STRT:*SECONDS)
     C                   EVAL      ##LAPS = TIME0 + %SECONDS(WkTime)
     C                   endif

      * if error
     C                   if        *in99 = '1'

     C                   setoff                                       09
     C                   seton                                        39
      * retrieve error from UTADBETD
     C/exec SQL
     C+ declare CursorErr cursor for
     C+ select ERMSG from UPADBETD
     C+ where ERPRFX = :PREFIX
     C/end-exec

     C/exec SQL
     C+ open CursorErr
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CursorErr
     C+ into :EMSG
     C/end-exec

     C                   eval      Ix = 1
     C                   DOW       SQLCODE = 0
     C                             and Ix < 6
     C                   eval      ERR_Ms(Ix) = EMSG
     C                   eval      Ix = Ix + 1

     C/exec SQL
     C+ fetch next
     C+ from CursorErr
     C+ into :EMSG
     C/end-exec
     C                   ENDDO

     C/exec SQL
     C+ close CursorErr
     C/end-exec

      * set DSPF error message
     C                   eval      ERR0 = 'Process has stopped. T' +
     C                             'here has been an issue in the above ' +
     C                             'highlighted [phase]. More error details' +
     C                             ' here below.'
     C                   eval      ERR1 = Err_Ms(1)
     C                   eval      ERR2 = Err_Ms(2)
     C                   eval      ERR3 = Err_Ms(3)
     C                   eval      ERR4 = Err_Ms(4)
     C                   eval      ERR5 = Err_Ms(5)
     C                   eval      ##UPSS = 'Stopped'

     C                   eval      V_EXFMT = 'Y'
     C                   WRITE     ERRORF

      * else if no error
     C                   else

      * If back up is running, write its format
     C                   if        *in11 = *on
     C                   eval      ##BUTT = UPBUNI
      * count how many are processed already
     C/exec SQL
     C+ select count(*) into :RcdCount from UPZSCRTD
     C+ where SCCDRN = 'Y' and SCTYPE = 'BU'
     C/end-exec

     C                   If        RcdCount <= UPBUNI
     C                             and UPBUNI > 0
      * Total Number of Files processed so far
     C                   eval      ##BUTP = RcdCount
     C                   eval(h)   Div = (RcdCount/UPBUNI) * 100
     C                   eval      ##BUPC = %Char(Div) + '%'
     C                   eval      ##BUSS = Color + %Subst(Line:1:Div) + Normal
     C                   ENDIF
     C                   WRITE     BACKUPF
     C                   ENDIF

      * If PF Update is running, refresh progress and write its format
     C                   if        *in12 = *on
     C                   WRITE     PFUPDF
     C                   ENDIF

      * If LF Update is running, refresh progress and write its format
     C                   if        *in13 = *on
     C                   eval      ##LFTT = UPDVNI
      * count how many are processed already
     C/exec SQL
     C+ select count(*) into :RcdCount from UPZSCRTD
     C+ where SCCDRN = 'Y'
     C+ and ((SCTYPE = '  '  and SCLIB like '%VLIB%') or
     C+  SCTYPE = 'RB')
     C/end-exec

     C                   If        RcdCount <= UPDVNI
      * Total Number of Files processed so far
     C                   eval      ##LFTP = RcdCount
     C                   eval(h)   Div = (RcdCount/UPDVNI) * 100
     C                   eval      ##LFPC = %Char(Div) + '%'
     C                   eval      ##LFSS = Color + %Subst(Line:1:Div) + Normal
     C                   ENDIF
     C                   WRITE     LFUPDF
     C                   ENDIF

      * If reconc is running, write its format
     C                   if        *in14 = *on
     C                   WRITE     RECONCF
     C                   ENDIF

     C                   ENDIF

      * If program is called from OTBU, screen needs to be updated manually by pressing F5  MD061706
     C                   setoff                                       69                    MD061706
     C                   If        OTBU = 'Y'                                               MD061706
     C                   eval      V_EXFMT = 'Y'                                            MD061706
     C                   seton                                        6968                  MD061706
     C                   Endif                                                              MD061706
                                                                                            MD061706
      * D I S P L A Y  S C R E E N
     C                   If        V_EXFMT = 'Y'
     C                   WRITE     RCDKEYF
      * if no error
     C                   if        *in99 = *off
     C                   if        *in39 = *on
     C                             or UPTMED <> *BLANKS
     C                   WRITE     NARRATIVEF
     C                   endif
     C                   endif

     C                   EXFMT     RECFMTF

      * if no error
     C                   If        *IN99 = *OFF
      * If F2 is selected, send message to server and switch back to WRITE mode
     C                   If        *INKB = *ON
     C                   eval      ##NARR = *BLANKS
     C                   eval      ##NAR1 = *BLANKS
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'UPZADBUDTQ'  DtqNam           10
     C                   PARM      '*LIBL'       DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'CONTINUE'    DtqDta           50
     C                   eval      V_EXFMT = 'N'
     C                   Endif

      * If F7 is selected, display Summary spooled file
     C                   If        *INKG = *ON
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'DSPSPLF FILE(UP4017P1' +
     C                             ') JOB(' + %trim(UPSVJN) + '/' +
     C                             %trimr(UPUSER) + '/UPZADBUSVR)'

     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   Endif

      * If F8 is selected, display Detailed spooled file
     C                   If        *INKH = *ON
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'DSPSPLF FILE(UP4016P1' +
     C                             ') JOB(' + %trim(UPSVJN) + '/' +
     C                             %trimr(UPUSER) + '/UPZADBUSVR)'

     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   Endif

      * If F6 is selected, display Detailed spooled file
     C                   If        *INKF = *ON
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'DSPSPLF FILE(UP4018P1' +
     C                             ') JOB(' + %trim(UPSVJN) + '/' +
     C                             %trimr(UPUSER) + '/UPZADBUSVR)'

     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   Endif

      * If F5 is selected, reload screen if different                                       MD061706
     C                   If        *INKE = *ON                                              MD061706
     C/exec SQL                                                                             MD061706
     C+ select * into :UPZUPD                                                               MD061706
     C+ from UPZUPDTD where UPPRFX = :PREFIX                                                MD061706
     C/end-exec                                                                             MD061706
     C                   If        SQLCode <> SQLOK                                         MD061706
     C                             and SQLCode <> SQLEOF                                    MD061706
     C                   eval      ERROR = '*Error'                                         MD061706
     C                   Return                                                             MD061706
     C                   Endif                                                              MD061706
                                                                                            MD061706
     C                   Exsr      SR_LOAD                                                  MD061706
     C                   Endif                                                              MD061706
                                                                                            MD061706
      * If F23 is selected, restore from back up
     C                   If        *INKX = *ON

     C                   CALL      'UP000064'
     C                   PARM                    PREFIX
     C                   PARM                    REFSYS
     C                   PARM                    ERROR
     C                   PARM                    CommandLen
     C                   Endif

     C                   Endif

     C                   Else
     C                   WRITE     RECFMTF
     C                   if        *in39 = *on
     C                   WRITE     NARRATIVEF
     C                   endif

      * IF PF Update is just done, wait for 1 second
     C                   if        dly = 'Y'
     C                   CALL      'QCMDEXC'
     C                   PARM      'DLYJOB 2'    CMD               8
     C                   PARM      8             CMDLEN           15 5
     C                   eval      dly = 'N'
     C                   endif

      * Wait for update before reloading screen
     C                   if        *in12 = *on
     C                             or *in13 = *on
     C                   CALL(E)   'QRCVDTAQ'
     C                   PARM      'UPZADBUDTQ'  DtqNam
     C                   PARM      '*LIBL'       DtqLib
     C                   PARM      50            DtqLen
     C                   PARM                    DtqDta
     C                   PARM      10            DtqWait           5 0
     C                   else
     C                   CALL(E)   'QRCVDTAQ'
     C                   PARM      'UPZADBUDTQ'  DtqNam
     C                   PARM      '*LIBL'       DtqLib
     C                   PARM      50            DtqLen
     C                   PARM                    DtqDta
     C                   PARM      2             DtqWait           5 0
     C                   ENDIF

      * monitor error where DTAQ may already have been deleted by the server
     C                   if        %error
     C                   eval      V_EXFMT = 'Y'
     C                   endif

      * Retrieve Zone Compare Work File UPZUPDTD
     C/exec SQL
     C+ select * into :UPZUPD
     C+ from UPZUPDTD where UPPRFX = :PREFIX
     C/end-exec
     C                   If        SQLCode <> SQLOK
     C                             and SQLCode <> SQLEOF
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif

      * Reload screen if different
     C*                  If        UPZUPD_S <> UPZUPD
     C                   Exsr      SR_LOAD
     C*                  Endif
     C                   ENDIF

     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
     C     SR_LOAD       BEGSR

      * Set off indicators *IN30 to *IN40
     C                   eval      %Subarr(*IN : 30 : 40) = *OFF
     C                   eval      V_TOTF = 0
     C                   eval      ##DOTL = C_DOTL                                          MD060271
      * Set off error indication *in99
     C                   setoff                                       99

      * Zone
     C                   eval      ##PRFX = PREFIX

      * Reference System
     C                   eval      ##RSYS = REFSYS

      * Time Started
     C                   eval      N_VAR = %DEC(UPTMST:6:0)
     C                   eval      ##STRT = %TIME(N_VAR:*HMS)

      * Time Ended
     C                   if        UPTMED <> *BLANKS
     C                   eval      N_VAR = %DEC(UPTMED:6:0)
     C                   eval      ##ENDT = %TIME(N_VAR:*HMS)
     C                   seton                                        37
     C                   setoff                                       69                    MD061706
      * At this point, DTAQ is about to be deleted, so no more WRITE is needed
     C                   eval      V_EXFMT = 'Y'
     C                   endif

      * Script Status
      * If PF Update is not running, do not upload jobs details
     C                   If        UPPFUS <> 'R'
     C                             and UPPFUS <> 'C'
      * reload for a last time so completion for the 3 jobs is displayed
     C                             and S_UPPFUS <> 'R'
     C*                  setoff                                       60
     C                   else
      * Set detail values DM
      * Library
     C                   eval      ##DMLB = PREFIX + 'DMLIB'
      * Job name
     C                   eval      ##DMJB = UPDMJN + '/' + %trimr(UPUSER) +
     C                             '/' + ##DMLB
      * Number of files
     C                   evalr     ##DMTF = %char(UPDMNF)
     C                   eval      V_TOTF = V_TOTF + UPDMNF
      * Number of files processed
     C/exec SQL
     C+ select count(*) into :RcdCount from UPZDRVTD
     C+ where DRLIB = :##DMLB and DRUPDD = 'Y'
     C/end-exec
     C                   evalr     ##DMTR = %char(RcdCount)
      * Time started
     C                   eval      N_VAR = %DEC(UPDMSB:6:0)
     C                   eval      ##DMST = %TIME(N_VAR:*HMS)
      * Time ended
     C                   if        UPDMED <> *BLANKS
     C                   eval      N_VAR = %DEC(UPDMED:6:0)
     C                   eval      ##DMED = %TIME(N_VAR:*HMS)
     C                   ENDIF
      * Run Time
     C                   if        UPDMED <> *BLANKS
     C*                  eval      ##HST = %TIME(##DMST:*HMS)
     C*                  eval      ##HET = %TIME(##DMED:*HMS)
     C                   EVAL      WkTime = %DIFF(##DMED:##DMST:*SECONDS)
     C                   EVAL      ##DMRT = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   If        UPDMSS = 'A'
     C                   eval      ##DMSS = 'Completed Abnormally'
     C                   seton                                        3099
     C                   setoff                                       0912
     C                   Else
     C                   If        UPDMED <> *blanks
     C                   eval      ##DMSS = 'Completed Normally'
     C                   seton                                        31
     C                   Else
     C                   eval      ##DMSS = 'Running...'
     C                   ENDIF
     C                   ENDIF

      * Set detail values DP
      * Library
     C                   eval      ##DPLB = PREFIX + 'DPLIB'
      * Job name
     C                   eval      ##DPJB = UPDPJN + '/' + %trimr(UPUSER) +
     C                             '/' + ##DPLB
      * Number of files
     C                   evalr     ##DPTF = %char(UPDPNF)
     C                   eval      V_TOTF = V_TOTF + UPDPNF
      * Number of files processed
     C/exec SQL
     C+ select count(*) into :RcdCount from UPZDRVTD
     C+ where DRLIB = :##DPLB and DRUPDD = 'Y'
     C/end-exec
     C                   evalr     ##DPTR = %char(RcdCount)
      * Time started
     C                   eval      N_VAR = %DEC(UPDPSB:6:0)
     C                   eval      ##DPST = %TIME(N_VAR:*HMS)
      * Time ended
     C                   if        UPDPED <> *BLANKS
     C                   eval      N_VAR = %DEC(UPDPED:6:0)
     C                   eval      ##DPED = %TIME(N_VAR:*HMS)
     C                   endif
      * Run Time
     C                   if        UPDPED <> *BLANKS
     C*                  eval      ##HST = %TIME(##DPST:*HMS)
     C*                  eval      ##HET = %TIME(##DPED:*HMS)
     C                   EVAL      WkTime = %DIFF(##DPED:##DPST:*SECONDS)
     C                   EVAL      ##DPRT = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   If        UPDPSS = 'A'
     C                   eval      ##DPSS = 'Completed Abnormally'
     C                   seton                                        3299
     C                   setoff                                       0912
     C                   Else
     C                   If        UPDPED <> *blanks
     C                   eval      ##DPSS = 'Completed Normally'
     C                   seton                                        33
     C                   Else
     C                   eval      ##DPSS = 'Running...'
     C                   ENDIF
     C                   ENDIF

      * Set detail values DTA
      * Library
     C                   eval      ##DTLB = PREFIX + 'DTALIB'
      * Job name
     C                   eval      ##DTJB = UPDTJN + '/' + %trimr(UPUSER) +
     C                             '/' + ##DTLB
      * Number of files
     C                   evalr     ##DTTF = %char(UPDTNF)
     C                   eval      V_TOTF = V_TOTF + UPDTNF
      * Number of files processed
     C/exec SQL
     C+ select count(*) into :RcdCount from UPZDRVTD
     C+ where DRLIB = :##DTLB and DRUPDD = 'Y'
     C/end-exec
     C                   evalr     ##DTTR = %char(RcdCount)
      * Time started
     C                   eval      N_VAR = %DEC(UPDTSB:6:0)
     C                   eval      ##DTST = %TIME(N_VAR:*HMS)
      * Time ended
     C                   if        UPDTED <> *BLANKS
     C                   eval      N_VAR = %DEC(UPDTED:6:0)
     C                   eval      ##DTED = %TIME(N_VAR:*HMS)
     C                   ENDIF
      * Run Time
     C                   if        UPDTED <> *BLANKS
     C*                  eval      ##HST = %TIME(##DTST:*HMS)
     C*                  eval      ##HET = %TIME(##DTED:*HMS)
     C                   EVAL      WkTime = %DIFF(##DTED:##DTST:*SECONDS)
     C                   EVAL      ##DTRT = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   If        UPDTSS = 'A'
     C                   eval      ##DTSS = 'Completed Abnormally'
     C                   seton                                        3499
     C                   setoff                                       0912
     C                   Else
     C                   If        UPDTED <> *blanks
     C                   eval      ##DTSS = 'Completed Normally'
     C                   seton                                        35
     C                   Else
     C                   eval      ##DTSS = 'Running...'
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF


      * Set header values
      * Total files to update
     C                   eval      XTOTN = UPDMNF + UPDPNF + UPDTNF + UPDVNF
     C                   eval      ##OTTC = %char(XTOTN)
     C                   eval      ##SCTT = XTOTN
     C                   setoff                                       50

      * Update Status
     C                   If        UPUPSS = 'I'
     C                   eval      ##UPSS = 'Initializing...'
     C                   else
     C                   If        UPUPSS = 'R'
     C                   eval      ##UPSS = 'Running...'
     C                   else
     C                   If        UPUPSS = 'C'
     C                   eval      ##UPSS = 'Completed'
     C                   else
     C                   If        UPUPSS = 'A'
     C                   eval      ##UPSS = 'Ended Abnormally'
     C                   seton                                        99
     C                   eval      V_EXFMT = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * Script Status
     C                   setoff                                       1080
     C                   If        UPSCRS = 'R'
     C                   seton                                        10
     C                   endif
     C                   If        UPSCRS = 'A'
     C                   seton                                        8099
     C                   ENDIF

      * Back Up Status
     C                   setoff                                       1181
     C                   If        UPBKUS = 'R'
     C                   seton                                        11
     C                   Endif
     C                   If        UPBKUS = 'A'
     C                   seton                                        8199
     C                   ENDIF
     C                   If        UPBKUS = 'C'
      * when back up is done, show job details
     C*                  seton                                        60
     C                   endif

      * PF Update Status
     C                   setoff                                       128260
     C                   If        UPPFUS = 'R'
     C                             or UPPFUS = 'S'
     C                   seton                                        12
     C                   If        UPDMSS = 'A'
     C                             or UPDPSS = 'A' or UPDTSS = 'A'
     C                   setoff                                       12
     C                   seton                                        8299
     C                   Endif
     C                   Endif
     C                   If        UPPFUS = 'A'
     C                   seton                                        8299
     C                   ENDIF

      * if submitted, do not display start and end time yet
     C                   setoff                                       40
     C                   If        UPPFUS = 'R'
     C                   seton                                        40
     C                   Endif

      * when PF status is complete, redisplay the screen
     C                   If        UPPFUS = 'C'
     C                             and S_UPPFUS <> 'C'
     C                   eval      dly = 'Y'
     C                   seton                                        40

     C                   endif

      * LF Update Status
     C                   setoff                                       1383
     C                   If        UPLFUS = 'R'
     C                             or UPLFUS = 'S'
     C                   seton                                        13
      * when LF Update is running, don't job details
     C                   setoff                                       60
     C                   Endif
     C                   If        UPLFUS = 'A'
     C                   seton                                        8399
     C                   ENDIF

      * Reconcile Status
     C                   setoff                                       1484
     C                   If        UPRCLS = 'R'
     C                   clear                   LFUPDF
     C                   seton                                        14
     C                   Endif
     C                   If        UPRCLS = 'A'
     C                   seton                                        8499
     C                   ENDIF

     C                   eval      UPZUPD_S = UPZUPD

     C                   ENDSR
      *****************************************************************
     C     *INZSR        BEGSR

     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RtnCode
     C                   PARM      'UPZADBUDTQ'  ObjName
     C                   PARM      '*LIBL'       ObjLib
     C                   PARM      '*DTAQ'       ObjType
     C                   PARM                    ChkMbr

      * If DTAQ does not exist, server is not running, proceed with EXFMT
      * rather WRITE
     C                   eval      V_EXFMT = 'N'
     C                   IF        RtnCode <> 'Exist     '
     C                   eval      V_EXFMT = 'Y'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
** #_DLYJOB
DLYJOB DLY(1)
** #_FKEY
F3=Exit  F7=Display Summary Report  F8=Display Detailed Report
F23=Rollback Changes
F3=Exit  F6=Exception Report  F7=Display Summary Report  F8=Dis
play Detailed Report  F23=Rollback Changes
