     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTM main monitor screen')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SM8001 - Midas UP OTM main monitor screen                    *
      *                                                               *
      *  Function: This program displays the monitor screen. Auto-    *
      *            refresh is done while migration process is active. *
      *            If Failed or Warning, component can be restarted.  *
      *            When complete, job logs can be viewed. Attention   *
      *            key can be used anytime to log off.                *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD060979           Date 27Jan23               *
      *  Prev Amend No. CUP046 *CREATE     Date 18Jul22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060979 - Monitor does not refresh                          *
      *  CUP046 - One Touch Bridge - migration                        *
      *                                                               *
      *****************************************************************
     FSM8001GF  CF   E             WORKSTN

     D SQLDynStmt      S            500A
     D X_MIGI          S              4S 0
     D I_MAXI          S              4S 0
     D Ix              S              2S 0
     D TotRow          S             13  0
     D DBASE           S              3A
     D X_PRFX          S              2
     D ##LYRX          S              2
     DIncNo            S              5  0
     D #_DLYJOB        S             70    DIM(1)  CTDATA PERRCD(1)
     D V_TOTF          S              5  0
     D V_EXFMT         S              1
     D SQLOK           C                   Const( 0 )
     D SQLEOF          C                   Const( 100 )
     D Command         S             80
     D CommandLen      S             15  5 INZ(80)
     D C_DOTL          C                   Const('--------------------------
     D                                     -----------------------------------
     D                                     -----------------------------------
     D                                     -----------------------------------
     D                                     -----------------------------------')

     DRtnCode          S             10
     DObjName          S             10
     DObjLib           S             10
     DObjType          S              8
     DChkMbr           S             10
     D WkTime          S              5S 0
     DTIME0            S               T   INZ(T'00.00.00')
     DN_VAR            S              6  0
     DC_VAR8           S              8
     DBYPASS           S              1
     DLOGD             S              6
     DLOGT             S              6
     D TSTMT           S               Z                                                    MD060979
     D TSTMTA          S             30A                                                    MD060979

     D ##TMEDS         DS
     D   TMST                  1      6
     D   TMSD                  7     12
     D   TM12                  1     12                                                     MD060979
     D   ##TMX                 1     12  0

     D SMMIGDS       E DS                  EXTNAME(SMMIGRTD)
     D SMMIGD1       E DS                  EXTNAME(SMMIGRTD)
     D                                     Qualified Dim(11)
     D                                     Prefix(A)
     D SMOTMDS       E DS                  EXTNAME(SMOTMMTD)
     D SMOTMDS_S     E DS                  EXTNAME(SMOTMMTD)
     D                                     PREFIX(S_)
     D SMOTLDS       E DS                  EXTNAME(SMOTMLTD)

     D/COPY ZACPYSRC,PSDS
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    GLOBP             2
     C                   PARM                    ZONEP             2
     C                   PARM                    LAYER             7
     C                   PARM                    BRIDGELIB        10
     C                   PARM                    ERROR            10

     C                   eval      V_EXFMT = 'N'
     C                   eval      ERROR = *BLANK
     C                   eval      ##JOB = PSJobName
     C                   eval      ##USR = PSUser

      * Retrieve monitor information from SMOTMMTD
     C/exec SQL
     C+ select * into :SMOTMDS
     C+ from SMOTMMTD
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '100'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif

      * Initialize display file
     C                   Exsr      SR_LOAD

      * While F3 is not selected
     C                   DOW       *INKC = *OFF
     C                   TIME                    ##TME

      * Blank out ##ACTn fields
     C                   eval      ##ACT1 = *blanks
     C                   eval      ##ACT10 = *blanks
     C                   eval      ##ACT11 = *blanks
     C                   eval      ##ACT2 = *blanks
     C                   eval      ##ACT3 = *blanks
     C                   eval      ##ACT4 = *blanks
     C                   eval      ##ACT5 = *blanks
     C                   eval      ##ACT6 = *blanks
     C                   eval      ##ACT7 = *blanks
     C                   eval      ##ACT8 = *blanks
     C                   eval      ##ACT9 = *blanks

      * Elapsed Time
      * If 'End Time' available
     C                   if        DENDTM <> *BLANKS
     C                   EVAL      WkTime = %DIFF(##ENDT:##STRT:*SECONDS)
     C                   EVAL      ##LAPS = TIME0 + %SECONDS(WkTime)
      * Also, allow selection of one particular layer to display its jobs
     C                   If        *INKW = *ON
     C                   seton                                        20
     C                   Endif
     C                   else
      * If 'End Time' not available
     C                   TIME                    ##CURT
     C                   EVAL      WkTime = %DIFF(##CURT:##STRT:*SECONDS)
     C                   EVAL      ##LAPS = TIME0 + %SECONDS(WkTime)
     C                   endif

     C                   If        V_EXFMT = 'Y'
      ** Do not display 'Attention key'
     C                   setoff                                       25
     C                   EXFMT     RECFMT

      * If View is selected
     C                   If        ##ACT1 = 'V' or ##ACT11 = 'V'
     C                             or ##ACT2 = 'V' or ##ACT3 = 'V'
     C                             or ##ACT4 = 'V' or ##ACT5 = 'V'
     C                             or ##ACT6 = 'V' or ##ACT7 = 'V'
     C                             or ##ACT8 = 'V' or ##ACT9 = 'V'
     C                             or ##ACT10 = 'V' or ##ACT11 = 'V'
     C                   exsr      SR_ViewJob
     C                   Endif

      * If Restart is selected
     C                   If        ##ACT1 = 'R' or ##ACT11 = 'R'
     C                             or ##ACT2 = 'R' or ##ACT3 = 'R'
     C                             or ##ACT4 = 'R' or ##ACT5 = 'R'
     C                             or ##ACT6 = 'R' or ##ACT7 = 'R'
     C                             or ##ACT8 = 'R' or ##ACT9 = 'R'
     C                             or ##ACT10 = 'R' or ##ACT11 = 'R'
     C                   exsr      SR_RestartJob
     C                   Endif

      * If Bypass is selected
      * If Bypass is selected but failed component cannot be bypassed
     C                   setoff                                       89
     C                   If        *IN69  <> '1' and
     C                             (##ACT1 = 'B' or ##ACT11 = 'B'
     C                             or ##ACT2 = 'B' or ##ACT3 = 'B'
     C                             or ##ACT4 = 'B' or ##ACT5 = 'B'
     C                             or ##ACT6 = 'B' or ##ACT7 = 'B'
     C                             or ##ACT8 = 'B' or ##ACT9 = 'B'
     C                             or ##ACT10 = 'B' or ##ACT11 = 'B' )
     C                   seton                                        89
     C                   eval      ##NARR = 'Component cannot be bypassed'
     C                   else


     C                   If        ##ACT1 = 'B' or ##ACT11 = 'B'
     C                             or ##ACT2 = 'B' or ##ACT3 = 'B'
     C                             or ##ACT4 = 'B' or ##ACT5 = 'B'
     C                             or ##ACT6 = 'B' or ##ACT7 = 'B'
     C                             or ##ACT8 = 'B' or ##ACT9 = 'B'
     C                             or ##ACT10 = 'B' or ##ACT11 = 'B'
     C                   exsr      SR_BypassJob
     C                   Endif
     C                   Endif

      * if Restart after halt
     C                   If        *INKB = *ON
     C                   exsr      SR_RestHalt
     C                   Endif

      * if F22 is pressed
     C                   If        *INKW = *ON
     C                   CALL      'SM8012'
     C                   Endif

      * If Ignore is selected
     C*                  If        ##ACT5 = 'I'
     C*                  exsr      SR_IgnoreJob
     C*                  Endif

     C                   Else
      ** Display 'Attention key'
     C                   seton                                        25
     C                   WRITE     RECFMT

      * Wait for update before reloading screen
     C                   EVAL      Command = #_DLYJOB(1)
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen

      * monitor error where DTAQ may already have been deleted by the server
     C                   if        %error
     C                   eval      V_EXFMT = 'Y'
     C                   endif

      * Retrieve Global Compare Work File SMOTMMTD
     C/exec SQL
     C+ select * into :SMOTMDS
     C+ from SMOTMMTD
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '101'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif

      * Reload screen if different
     C                   If        SMOTMDS_S <> SMOTMDS
     C                   Exsr      SR_LOAD
     C                   Endif
     C                   ENDIF

      * If DTAQ does not exist, server is not running, proceed with EXFMT
      * rather WRITE
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RtnCode
     C                   PARM      'SM_OTB_SVR'  ObjName
     C                   PARM      BRIDGELIB     ObjLib
     C                   PARM      '*DTAQ'       ObjType
     C                   PARM                    ChkMbr

     C                   IF        RtnCode <> 'Exist     '
     C*                  eval      V_EXFMT = 'Y'
     C                   ENDIF

     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
     C     SR_LOAD       BEGSR

      * Set off indicators *IN30 to *IN40
     C                   eval      %Subarr(*IN : 30 : 40) = *OFF
     C                   eval      %Subarr(*IN : 60) =  *OFF
     C                   eval      V_TOTF = 0
     C                   eval      SMOTMDS_S = SMOTMDS
     C                   eval      ##STR1 = *blanks
     C                   eval      ##STR10 = *blanks
     C                   eval      ##STR11 = *blanks
     C                   eval      ##STR2 = *blanks
     C                   eval      ##STR3 = *blanks
     C                   eval      ##STR4 = *blanks
     C                   eval      ##STR5 = *blanks
     C                   eval      ##STR6 = *blanks
     C                   eval      ##STR7 = *blanks
     C                   eval      ##STR8 = *blanks
     C                   eval      ##STR9 = *blanks
     C                   eval      ##STS1 = *blanks
     C                   eval      ##STS10 = *blanks
     C                   eval      ##STS11 = *blanks
     C                   eval      ##STS2 = *blanks
     C                   eval      ##STS3 = *blanks
     C                   eval      ##STS4 = *blanks
     C                   eval      ##STS5 = *blanks
     C                   eval      ##STS6 = *blanks
     C                   eval      ##STS7 = *blanks
     C                   eval      ##STS8 = *blanks
     C                   eval      ##STS9 = *blanks
     C                   eval      ##DOTL = C_DOTL

      * Retrieve the running/failed component increment
      * take the number of completed component - 1
     C                   eval      X_MIGI = 0
     C/exec SQL
     C+ select MIGINC into :X_MIGI
     C+ from SMMIGRTD where MIGSTS = 'R' or MIGSTS = 'F'
     C/end-exec
      * if zero, set it to 1
     C                   if        DNOCMC = 0
     C                   eval      X_MIGI = 1
     C                   endif


      * if none switch to EXFMT and display the last 11
     C*                  If        SQLCODE = 100
     C*                  eval      V_EXFMT = 'Y'
     C*                  eval      X_MIGI = 9999
     C*                  ENDIF

      * if none switch to EXFMT
     C*                  If        SQLCODE <> 100 and SQLCODE <> 0
     C*                  eval      DBASE = '001'
     C*                  exsr      *pssr
     C*                  ENDIF

      * if found check value and set X_MIGI for starting postion
     C                   If        X_MIGI <> 0
      * retrieve first the number of component
     C*xec SQL
     C* select max(MIGINC) into :I_MAXI
     C* from SMMIGRTD
     C*end-exec
     C                   eval      I_MAXI = DNOCMP
      * if running is 6 or less, display 1 to 11
      * else compare with max
      *   if running + 5 > max, display [max -10] to max
      *   else dispaly [running - 5] to {running + 5]

     C                   select
     C                   when      X_MIGI <= 6
     C                   eval      X_MIGI = 1
     C                   when      X_MIGI + 5 > I_MAXI
     C                   eval      X_MIGI = I_MAXI - 10
     C                   other
     C                   eval      X_MIGI = X_MIGI - 5
     C                   endsl
     C                   ENDIF

      * if migration complete, then load the 11 last components
     C                   if        DENDTM <> *BLANKS
     C                   eval      X_MIGI = I_MAXI - 10
     C                   ENDIF

     C/exec SQL
     C+ declare MIGCursor insensitive scroll cursor for
     C+ select * from SMMIGRTD
     C+ where MIGINC  >= :X_MIGI
     C+ order by MIGINC
     C/end-exec
      *
     C/exec SQL
     C+ open MIGCursor
     C/end-exec

      ** Get the number of rows of the selected records.
     C/exec SQL
     C+ get diagnostics :TotRow  = db2_number_rows
     C/end-exec

     C/exec SQL
     C+ fetch next from MIGCursor for 11 rows into :SMMIGD1
     C/end-exec

      * Load 11 component
     C                   Do        11            Ix
     C                   eval      SMMIGDS = SMMIGD1(Ix)
     C                   exsr      SR_comp
     C*exec SQL
     C* fetch next from MIGCursor into :SMMIGDS
     C*end-exec
      * if less than 11 components are due to run, just leave
     C                   If        SQLCODE = 100
     C                   leave
     C                   ENDIF
     C                   ENDDO

     C/exec SQL
     C+ close MIGCursor
     C/end-exec
     C*                  If        DLAYRS = '*GLOBAL'
     C*                  eval      ##LYRX = GLOBP
     C*                  eval      ##LYRS = GLOBP + ' *GLOBAL'
     C*                  else
     C*                  eval      ##LYRX = ZONEP
     C*                  eval      ##LYRS = ZONEP + ' ' + DACTNR
     C*                  ENDIF

      * check if there is a failed component that can be bypassed
     C/exec SQL
     C+ select otmbyp into :BYPASS from SMOTCJW0 s
     C+ where exists (select * from SMMIGRTD i
     C+ where s.otmcmp = i.migcmp and s.otmseq = i.migseq
     C+ and i.migsts ='F')
     C/end-exec
      * if found and can be bypassed, set indicator 69, else 70
     C                   setoff                                       6970
     C                   If        SQLCODE = 0
     C                   if        BYPASS = 'Y'
     C                   seton                                        69
     C                   else
     C                   seton                                        70
     C                   ENDIF
     C                   ENDIF
     C
      * Fusion Midas System
     C                   eval      ##GPRF = DNGPFX
     C                   eval      ##ZPRF = DNZPFX
     C                   eval      ##GPRO = DOGPFX
     C                   eval      ##ZPRO = DOZPFX
     C                   if        DACTLY = 'G'
     C                   eval      ##LYRM = DOGPFX + ' *GLOBAL'
     C                   endif
     C                   if        DACTLY = 'Z'
     C                   eval      ##LYRM = DOZPFX + ' *ZONE'
     C                   endif

      * Time Started
     C                   eval      N_VAR = %DEC(DSTRTT:6:0)
     C                   eval      ##STRT = %TIME(N_VAR:*HMS)

      * Time Ended
     C                   if        DENDTM <> *BLANKS
     C                   eval      N_VAR = %DEC(DENDTM:6:0)
     C                   eval      ##ENDT = %TIME(N_VAR:*HMS)
     C                   seton                                        18
      * At this point, DTAQ is about to be deleted, so no more WRITE is needed
     C                   eval      V_EXFMT = 'Y'
     C                   endif

      * Total number of component
     C                   eval      ##OTTC = %CHAR(DNOCMP)

      * Total number of component completed
     C                   eval      ##CMSS = %CHAR(DNOCMC)

      * If process is halted
     C                   setoff                                       26
     C                   if        DMIGHT = 'Y'
     C                   seton                                        26
     C                   eval      V_EXFMT = 'Y'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C     *INZSR        BEGSR

     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RtnCode
     C                   PARM      'SM_OTB_SVR'  ObjName
     C                   PARM      BRIDGELIB     ObjLib
     C                   PARM      '*DTAQ'       ObjType
     C                   PARM                    ChkMbr

      * If DTAQ does not exist, server is not running, proceed with EXFMT
      * rather WRITE
     C                   eval      V_EXFMT = 'N'
     C                   IF        RtnCode <> 'Exist     '
     C*                  eval      V_EXFMT = 'Y'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_ViewJob - Display job                                     *
      *                                                               *
      *****************************************************************
     C     SR_ViewJob    BEGSR

      ** look for the latest failed component
     C/exec SQL
     C+ select MIGINC into :IncNo
     C+ from SMMIGRTD where MIGSTS = 'F'
     C+ order by MIGINC desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = '121'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif

      ** retrieve job info
     C/exec SQL
     C+ select *  into :SMOTLDS
     C+ from SMOTMLTD s where LOGINC = :IncNo
     C+ order by rrn(s) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = '122'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif


     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'WRKJOB JOB(' + %trim(LOGJBN) +
     C                             '/' + %trim(LOGUSR) + '/' +
     C                             %trimr(LOGJNM) + ')'

     C                   CALL      'QCMDEXC'                            99
     C                   PARM                    Command
     C                   PARM                    CommandLen

      * monitor error
     C                   if        *IN99 = *on
     C                             and PSEXCPNO <> '1070'
     C                   exsr      *pssr
     C                   endif

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_RestartJob - Restart the job by sending message to server *
      *                                                               *
      *****************************************************************
     C     SR_RestartJob BEGSR

      * first resest component status to blank as server may update the status to 'R'
      * a bit late, causing the screen to get back to EXFMT instead of WRITE

     C/exec SQL
     C+ update SMMIGRTD set   MIGSTS = ' '
     C+ where MIGSTS = 'F'
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = '200'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif

      * finally update timestamp for monitor refresh
     C                   TIME                    ##TMX
     C                   TIME                    TSTMT                                      MD060979
     C                   eval      TSTMTA = %char(TSTMT:*ISO)                               MD060979
     C                   eval      TM12 = %subst(TSTMTA:12:12)                              MD060979
     C/exec SQL
     C+ update SMOTMMTD
     C**set*DUTMST = :TMST                                                                  MD060979
     C+ set DUTMST = :TM12                                                                  MD060979
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '106'
     C                   exsr      *pssr
     C                   Endif

     C                   CALL      'QSNDDTAQ'
     C                   PARM      'SM_OTB_SVR'  DtqNam           10
     C                   PARM      BRIDGELIB     DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'CONTINUE'    DtqDta           50
     C                   eval      V_EXFMT = 'N'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_BypassJob - Bypass the job by sending message to server   *
      *                                                               *
      *****************************************************************
     C     SR_BypassJob  BEGSR

      * first set component status to BYPASS

     C/exec SQL
     C+ update SMMIGRTD set MIGSTS = 'B'
     C+ where MIGSTS = 'F'
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = '201'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif

      * then set its status in SMOTMLTD to BYPASS as well
     C/exec SQL
     C+ select LOGSTD, LOGSTT into :LOGD, :LOGT
     C+ from SMOTMLTD order by LOGSTD desc, LOGSTT desc
     C+ fetch first row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = '221'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif


     C/exec SQL
     C+ update SMOTMLTD  set LOGSTS = 'B'
     C+ where    LOGSTD = :LOGD and LOGSTT = :LOGT
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = '222'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif

      * then update timestamp for monitor refresh
     C                   TIME                    ##TMX
     C                   TIME                    TSTMT                                      MD060979
     C                   eval      TSTMTA = %char(TSTMT:*ISO)                               MD060979
     C                   eval      TM12 = %subst(TSTMTA:12:12)                              MD060979
     C/exec SQL
     C+ update SMOTMMTD
     C**set*DUTMST = :TMST                                                                  MD060979
     C+ set DUTMST = :TM12                                                                  MD060979
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '116'
     C                   exsr      *pssr
     C                   Endif

     C                   CALL      'QSNDDTAQ'
     C                   PARM      'SM_OTB_SVR'  DtqNam           10
     C                   PARM      BRIDGELIB     DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'BYPASS'      DtqDta           50
     C                   eval      V_EXFMT = 'N'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_IgnoreJob - Ignore if conflict is expected                *
      *                                                               *
      *****************************************************************
     C     SR_IgnoreJob  BEGSR

     C                   CALL      'QSNDDTAQ'
     C                   PARM      'SM_OTB_SVR'  DtqNam           10
     C                   PARM      BRIDGELIB     DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'IGNORE'      DtqDta           50
     C                   eval      V_EXFMT = 'N'

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_Comp - Load components to screen                          *
      *                                                               *
      *****************************************************************
     C     SR_Comp       BEGSR

     C                   Select

     C                   when      Ix = 1
     C                   eval      ##CMP1 = MIGCMP
     C                   eval      ##SEQ1 = %EDITC(MIGSEQ:'X')
     C                   eval      ##DES1 = MIGDES
      * Time started
     C                   if        MIGSTT <> *BLANKS
     C                   eval      ##STR1 = %subst(MIGSTT:1:2) + ':' +
     C                             %subst(MIGSTT:3:2) + ':' +
     C                             %subst(MIGSTT:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END1 = %subst(MIGENT:1:2) + ':' +
     C                             %subst(MIGENT:3:2) + ':' +
     C                             %subst(MIGENT:5:2) + ':'
      * Run Time
     C                   if        MIGENT <> *BLANKS
     C                   eval      ##HST = %TIME(##STR1:*HMS)
     C                   eval      ##HET = %TIME(##END1:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM1 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      MIGSTS = 'F'
     C                   eval      ##STS1 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        306131
     C                   WHEN      MIGSTS = 'C'
     C                   eval      ##STS1 = 'Completed'
     C                   seton                                        31
     C                   WHEN      MIGSTS = 'B'
     C                   eval      ##STS1 = 'Bypassed'
     C                   seton                                        31
     C                   WHEN      MIGSTS = 'R'
     C                   eval      ##STS1 = 'Running...'
     C                   endsl

     C                   when      Ix = 2
     C                   eval      ##CMP2 = MIGCMP
     C                   eval      ##SEQ2 = %EDITC(MIGSEQ:'X')
     C                   eval      ##DES2 = MIGDES
      * Time started
     C                   if        MIGSTT <> *BLANKS
     C                   eval      ##STR2 = %subst(MIGSTT:1:2) + ':' +
     C                             %subst(MIGSTT:3:2) + ':' +
     C                             %subst(MIGSTT:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END2 = %subst(MIGENT:1:2) + ':' +
     C                             %subst(MIGENT:3:2) + ':' +
     C                             %subst(MIGENT:5:2) + ':'
      * Run Time
     C                   if        MIGENT <> *BLANKS
     C                   eval      ##HST = %TIME(##STR2:*HMS)
     C                   eval      ##HET = %TIME(##END2:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM2 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      MIGSTS = 'F'
     C                   eval      ##STS2 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        326133
     C                   WHEN      MIGSTS = 'C'
     C                   eval      ##STS2 = 'Completed'
     C                   seton                                        33
     C                   WHEN      MIGSTS = 'B'
     C                   eval      ##STS2 = 'Bypassed'
     C                   seton                                        33
     C                   WHEN      MIGSTS = 'R'
     C                   eval      ##STS2 = 'Running...'
     C                   endsl

     C                   when      Ix = 3
     C                   eval      ##CMP3 = MIGCMP
     C                   eval      ##SEQ3 = %EDITC(MIGSEQ:'X')
     C                   eval      ##DES3 = MIGDES
      * Time started
     C                   if        MIGSTT <> *BLANKS
     C                   eval      ##STR3 = %subst(MIGSTT:1:2) + ':' +
     C                             %subst(MIGSTT:3:2) + ':' +
     C                             %subst(MIGSTT:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END3 = %subst(MIGENT:1:2) + ':' +
     C                             %subst(MIGENT:3:2) + ':' +
     C                             %subst(MIGENT:5:2) + ':'
      * Run Time
     C                   if        MIGENT <> *BLANKS
     C                   eval      ##HST = %TIME(##STR3:*HMS)
     C                   eval      ##HET = %TIME(##END3:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM3 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      MIGSTS = 'F'
     C                   eval      ##STS3 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        346135
     C                   WHEN      MIGSTS = 'C'
     C                   eval      ##STS3 = 'Completed'
     C                   seton                                        35
     C                   WHEN      MIGSTS = 'B'
     C                   eval      ##STS3 = 'Bypassed'
     C                   seton                                        35
     C                   WHEN      MIGSTS = 'R'
     C                   eval      ##STS3 = 'Running...'
     C                   endsl

     C                   when      Ix = 4
     C                   eval      ##CMP4 = MIGCMP
     C                   eval      ##SEQ4 = %EDITC(MIGSEQ:'X')
     C                   eval      ##DES4 = MIGDES
      * Time started
     C                   if        MIGSTT <> *BLANKS
     C                   eval      ##STR4 = %subst(MIGSTT:1:2) + ':' +
     C                             %subst(MIGSTT:3:2) + ':' +
     C                             %subst(MIGSTT:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END4 = %subst(MIGENT:1:2) + ':' +
     C                             %subst(MIGENT:3:2) + ':' +
     C                             %subst(MIGENT:5:2) + ':'
      * Run Time
     C                   if        MIGENT <> *BLANKS
     C                   eval      ##HST = %TIME(##STR4:*HMS)
     C                   eval      ##HET = %TIME(##END4:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM4 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      MIGSTS = 'F'
     C                   eval      ##STS4 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        366137
     C                   WHEN      MIGSTS = 'C'
     C                   eval      ##STS4 = 'Completed'
     C                   seton                                        37
     C                   WHEN      MIGSTS = 'B'
     C                   eval      ##STS4 = 'Bypassed'
     C                   seton                                        37
     C                   WHEN      MIGSTS = 'R'
     C                   eval      ##STS4 = 'Running...'
     C                   endsl

     C                   when      Ix = 5
     C                   eval      ##CMP5 = MIGCMP
     C                   eval      ##SEQ5 = %EDITC(MIGSEQ:'X')
     C                   eval      ##DES5 = MIGDES
      * Time started
     C                   if        MIGSTT <> *BLANKS
     C                   eval      ##STR5 = %subst(MIGSTT:1:2) + ':' +
     C                             %subst(MIGSTT:3:2) + ':' +
     C                             %subst(MIGSTT:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END5 = %subst(MIGENT:1:2) + ':' +
     C                             %subst(MIGENT:3:2) + ':' +
     C                             %subst(MIGENT:5:2) + ':'
      * Run Time
     C                   if        MIGENT <> *BLANKS
     C                   eval      ##HST = %TIME(##STR5:*HMS)
     C                   eval      ##HET = %TIME(##END5:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM5 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      MIGSTS = 'F'
     C                   eval      ##STS5 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        386139
     C                   WHEN      MIGSTS = 'C'
     C                   eval      ##STS5 = 'Completed'
     C                   seton                                        39
     C                   WHEN      MIGSTS = 'B'
     C                   eval      ##STS5 = 'Bypassed'
     C                   seton                                        39
     C                   WHEN      MIGSTS = 'R'
     C                   eval      ##STS5 = 'Running...'
     C                   endsl

     C                   when      Ix = 6
     C                   eval      ##CMP6 = MIGCMP
     C                   eval      ##SEQ6 = %EDITC(MIGSEQ:'X')
     C                   eval      ##DES6 = MIGDES
      * Time started
     C                   if        MIGSTT <> *BLANKS
     C                   eval      ##STR6 = %subst(MIGSTT:1:2) + ':' +
     C                             %subst(MIGSTT:3:2) + ':' +
     C                             %subst(MIGSTT:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END6 = %subst(MIGENT:1:2) + ':' +
     C                             %subst(MIGENT:3:2) + ':' +
     C                             %subst(MIGENT:5:2) + ':'
      * Run Time
     C                   if        MIGENT <> *BLANKS
     C                   eval      ##HST = %TIME(##STR6:*HMS)
     C                   eval      ##HET = %TIME(##END6:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM6 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      MIGSTS = 'F'
     C                   eval      ##STS6 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        406141
     C                   WHEN      MIGSTS = 'C'
     C                   eval      ##STS6 = 'Completed'
     C                   seton                                        41
     C                   WHEN      MIGSTS = 'B'
     C                   eval      ##STS6 = 'Bypassed'
     C                   seton                                        41
     C                   WHEN      MIGSTS = 'R'
     C                   eval      ##STS6 = 'Running...'
     C                   endsl

     C                   when      Ix = 7
     C                   eval      ##CMP7 = MIGCMP
     C                   eval      ##SEQ7 = %EDITC(MIGSEQ:'X')
     C                   eval      ##DES7 = MIGDES
      * Time started
     C                   if        MIGSTT <> *BLANKS
     C                   eval      ##STR7 = %subst(MIGSTT:1:2) + ':' +
     C                             %subst(MIGSTT:3:2) + ':' +
     C                             %subst(MIGSTT:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END7 = %subst(MIGENT:1:2) + ':' +
     C                             %subst(MIGENT:3:2) + ':' +
     C                             %subst(MIGENT:5:2) + ':'
      * Run Time
     C                   if        MIGENT <> *BLANKS
     C                   eval      ##HST = %TIME(##STR7:*HMS)
     C                   eval      ##HET = %TIME(##END7:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM7 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      MIGSTS = 'F'
     C                   eval      ##STS7 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        426143
     C                   WHEN      MIGSTS = 'C'
     C                   eval      ##STS7 = 'Completed'
     C                   seton                                        43
     C                   WHEN      MIGSTS = 'B'
     C                   eval      ##STS7 = 'Bypassed'
     C                   seton                                        43
     C                   WHEN      MIGSTS = 'R'
     C                   eval      ##STS7 = 'Running...'
     C                   endsl

     C                   when      Ix = 8
     C                   eval      ##CMP8 = MIGCMP
     C                   eval      ##SEQ8 = %EDITC(MIGSEQ:'X')
     C                   eval      ##DES8 = MIGDES
      * Time started
     C                   if        MIGSTT <> *BLANKS
     C                   eval      ##STR8 = %subst(MIGSTT:1:2) + ':' +
     C                             %subst(MIGSTT:3:2) + ':' +
     C                             %subst(MIGSTT:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END8 = %subst(MIGENT:1:2) + ':' +
     C                             %subst(MIGENT:3:2) + ':' +
     C                             %subst(MIGENT:5:2) + ':'
      * Run Time
     C                   if        MIGENT <> *BLANKS
     C                   eval      ##HST = %TIME(##STR8:*HMS)
     C                   eval      ##HET = %TIME(##END8:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM8 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      MIGSTS = 'F'
     C                   eval      ##STS8 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        446145
     C                   WHEN      MIGSTS = 'C'
     C                   eval      ##STS8 = 'Completed'
     C                   seton                                        45
     C                   WHEN      MIGSTS = 'B'
     C                   eval      ##STS8 = 'Bypassed'
     C                   seton                                        45
     C                   WHEN      MIGSTS = 'R'
     C                   eval      ##STS8 = 'Running...'
     C                   endsl

     C                   when      Ix = 9
     C                   eval      ##CMP9 = MIGCMP
     C                   eval      ##SEQ9 = %EDITC(MIGSEQ:'X')
     C                   eval      ##DES9 = MIGDES
      * Time started
     C                   if        MIGSTT <> *BLANKS
     C                   eval      ##STR9 = %subst(MIGSTT:1:2) + ':' +
     C                             %subst(MIGSTT:3:2) + ':' +
     C                             %subst(MIGSTT:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END9 = %subst(MIGENT:1:2) + ':' +
     C                             %subst(MIGENT:3:2) + ':' +
     C                             %subst(MIGENT:5:2) + ':'
      * Run Time
     C                   if        MIGENT <> *BLANKS
     C                   eval      ##HST = %TIME(##STR9:*HMS)
     C                   eval      ##HET = %TIME(##END9:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM9 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      MIGSTS = 'F'
     C                   eval      ##STS9 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        466147
     C                   WHEN      MIGSTS = 'C'
     C                   eval      ##STS9 = 'Completed'
     C                   seton                                        47
     C                   WHEN      MIGSTS = 'B'
     C                   eval      ##STS9 = 'Bypassed'
     C                   seton                                        47
     C                   WHEN      MIGSTS = 'R'
     C                   eval      ##STS9 = 'Running...'
     C                   endsl

     C                   when      Ix = 10
     C                   eval      ##CMP10 = MIGCMP
     C                   eval      ##SEQ10 = %EDITC(MIGSEQ:'X')
     C                   eval      ##DES10 = MIGDES
      * Time started
     C                   if        MIGSTT <> *BLANKS
     C                   eval      ##STR10 = %subst(MIGSTT:1:2) + ':' +
     C                             %subst(MIGSTT:3:2) + ':' +
     C                             %subst(MIGSTT:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END10 = %subst(MIGENT:1:2) + ':' +
     C                             %subst(MIGENT:3:2) + ':' +
     C                             %subst(MIGENT:5:2) + ':'
      * Run Time
     C                   if        MIGENT <> *BLANKS
     C                   eval      ##HST = %TIME(##STR10:*HMS)
     C                   eval      ##HET = %TIME(##END10:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM10 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      MIGSTS = 'F'
     C                   eval      ##STS10 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        486149
     C                   WHEN      MIGSTS = 'C'
     C                   eval      ##STS10 = 'Completed'
     C                   seton                                        49
     C                   WHEN      MIGSTS = 'B'
     C                   eval      ##STS10 = 'Bypassed'
     C                   seton                                        49
     C                   WHEN      MIGSTS = 'R'
     C                   eval      ##STS10 = 'Running...'
     C                   endsl

     C                   when      Ix = 11
     C                   eval      ##CMP11 = MIGCMP
     C                   eval      ##SEQ11 = %EDITC(MIGSEQ:'X')
     C                   eval      ##DES11 = MIGDES
      * Time started
     C                   if        MIGSTT <> *BLANKS
     C                   eval      ##STR11 = %subst(MIGSTT:1:2) + ':' +
     C                             %subst(MIGSTT:3:2) + ':' +
     C                             %subst(MIGSTT:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END11 = %subst(MIGENT:1:2) + ':' +
     C                             %subst(MIGENT:3:2) + ':' +
     C                             %subst(MIGENT:5:2) + ':'
      * Run Time
     C                   if        MIGENT <> *BLANKS
     C                   eval      ##HST = %TIME(##STR11:*HMS)
     C                   eval      ##HET = %TIME(##END11:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM11 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      MIGSTS = 'F'
     C                   eval      ##STS11 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        506151
     C                   WHEN      MIGSTS = 'C'
     C                   eval      ##STS11 = 'Completed'
     C                   seton                                        51
     C                   WHEN      MIGSTS = 'B'
     C                   eval      ##STS11 = 'Bypassed'
     C                   seton                                        51
     C                   WHEN      MIGSTS = 'R'
     C                   eval      ##STS11 = 'Running...'
     C                   endsl

     C                   endsl

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_RestHalt - Restart after halt                             *
      *                                                               *
      *****************************************************************
     C     SR_RestHalt   BEGSR

     C                   CALL      'QSNDDTAQ'
     C                   PARM      'SM_OTB_SVR'  DtqNam           10
     C                   PARM      BRIDGELIB     DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'RESTART'     DtqDta           50
     C                   eval      V_EXFMT = 'N'

      ** reset halt flag
     C/exec SQL
     C+ update SMOTMMTD
     C+ set DMIGHT = ' '
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '127'
     C                   exsr      *pssr
     C                   Endif

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   eval      Error = '*Error'
     C                   RETURN

     C                   ENDSR
      *****************************************************************
** #_DLYJOB
DLYJOB DLY(1)
