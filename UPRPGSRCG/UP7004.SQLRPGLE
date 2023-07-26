     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTR main monitor screen')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP7004 - Midas UP OTR main monitor screen                    *
      *                                                               *
      *  Function: This program displays the monitor screen. Auto-    *
      *            refresh is done while refresh process is active.   *
      *            If Failed or Warning, component can be restarted.  *
      *            When complete, job logs can be viewed. Attention   *
      *            key can be used anytime to log off.                *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD061580           Date 17Jul23               *
      *  Prev Amend No. CUP045 *CREATE     Date 01Jun22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061580 - Strange characters appear in OTRM (One Touch      *
      *             Bridge - Refresh Monitor). (Recompile)            *
      *           - Applied for MD061569.                             *
      *  CUP045 - One Touch Bridge - refresh                          *
      *                                                               *
      *****************************************************************
     FUP7004GF  CF   E             WORKSTN

     D ArrLyr          S              2    DIM(11)
     D DSLyr           DS
     D   DSG1                  1      2
     D   DSL1                  3      4
     D   DSL2                  5      6
     D   DSL3                  7      8
     D   DSL4                  9     10
     D   DSL5                 11     12
     D   DSL6                 13     14
     D   DSL7                 15     16
     D   DSL8                 17     18
     D   DSL9                 19     20
     D   DSL0                 21     22
     D SQLDynStmt      S            500A
     D Ix              S              2S 0
     D DBASE           S              3A
     D X_PRFX          S              2
     D ##LYRX          S              2
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

     D UPOTRM        E DS                  EXTNAME(UPOTRMTD)
     D UPOTRM_S      E DS                  EXTNAME(UPOTRMTD)
     D                                     PREFIX(S_)
     D UPOTRL        E DS                  EXTNAME(UPOTRLTD)

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

      * Retrieve Global Compare Work File UPOTRMTD
     C/exec SQL
     C+ select * into :UPOTRM
     C+ from UPOTRMTD
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
     C                   eval      ##ACT11 = *blanks
     C                   eval      ##ACT2 = *blanks
     C                   eval      ##ACT3 = *blanks
     C                   eval      ##ACT4 = *blanks
     C                   eval      ##ACT5 = *blanks
     C                   eval      ##ACT6 = *blanks
     C                   eval      ##ACT7 = *blanks
     C                   eval      ##ACT8 = *blanks

      * Elapsed Time
      * If 'End Time' available
     C                   if        DENDED <> *BLANKS
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

     C                   exsr      SR_LoadLayer

      * If View is selected
     C                   If        ##ACT1 = 'V' or ##ACT11 = 'V'
     C                             or ##ACT2 = 'V' or ##ACT3 = 'V'
     C                             or ##ACT4 = 'V' or ##ACT5 = 'V'
     C                             or ##ACT6 = 'V' or ##ACT7 = 'V'
     C                             or ##ACT8 = 'V'
     C                   exsr      SR_ViewJob
     C                   Endif

      * If Restart is selected
     C                   If        ##ACT1 = 'R' or ##ACT11 = 'R'
     C                             or ##ACT2 = 'R' or ##ACT3 = 'R'
     C                             or ##ACT4 = 'R' or ##ACT5 = 'R'
     C                             or ##ACT6 = 'R' or ##ACT7 = 'R'
     C                             or ##ACT8 = 'R'
     C                   exsr      SR_RestartJob
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

      * Retrieve Global Compare Work File UPOTRMTD
     C/exec SQL
     C+ select * into :UPOTRM
     C+ from UPOTRMTD
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      DBASE = '101'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif

      * Reload screen if different
     C                   If        UPOTRM_S <> UPOTRM
     C                   Exsr      SR_LOAD
     C                   Endif
     C                   ENDIF

      * If DTAQ does not exist, server is not running, proceed with EXFMT
      * rather WRITE
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RtnCode
     C                   PARM      'UP_OTBRSVR'  ObjName
     C                   PARM      BRIDGELIB     ObjLib
     C                   PARM      '*DTAQ'       ObjType
     C                   PARM                    ChkMbr

     C                   IF        RtnCode <> 'Exist     '
     C                   eval      V_EXFMT = 'Y'
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
     C                   eval      UPOTRM_S = UPOTRM
     C                   eval      ##STR1 = *blanks
     C                   eval      ##STR11 = *blanks
     C                   eval      ##STR2 = *blanks
     C                   eval      ##STR3 = *blanks
     C                   eval      ##STR4 = *blanks
     C                   eval      ##STR5 = *blanks
     C                   eval      ##STR6 = *blanks
     C                   eval      ##STR7 = *blanks
     C                   eval      ##STR8 = *blanks
     C                   eval      ##STS1 = *blanks
     C                   eval      ##STS11 = *blanks
     C                   eval      ##STS2 = *blanks
     C                   eval      ##STS3 = *blanks
     C                   eval      ##STS4 = *blanks
     C                   eval      ##STS5 = *blanks
     C                   eval      ##STS6 = *blanks
     C                   eval      ##STS7 = *blanks
     C                   eval      ##STS8 = *blanks
     C                   eval      ##DOTL = C_DOTL

     C                   If        DLAYRS = '*GLOBAL'
     C                   eval      ##LYRX = GLOBP
     C                   eval      ##LYRS = GLOBP + ' *GLOBAL'
     C                   else
     C                   eval      ##LYRX = ZONEP
     C                   eval      ##LYRS = ZONEP + ' ' + DACTNR
     C                   ENDIF

     C                   eval      ##GPRF = GLOBP
     C                   eval      ##ZPRF = ZONEP

      * Time Started
     C                   eval      N_VAR = %DEC(DSTRTD:6:0)
     C                   eval      ##STRT = %TIME(N_VAR:*HMS)

      * Time Ended
     C                   if        DENDED <> *BLANKS
     C                   eval      N_VAR = %DEC(DENDED:6:0)
     C                   eval      ##ENDT = %TIME(N_VAR:*HMS)
     C                   seton                                        18
      * At this point, DTAQ is about to be deleted, so no more WRITE is needed
     C                   eval      V_EXFMT = 'Y'
     C                   endif

      * Total number of component
     C                   eval      ##OTTC = '9'

      * Total number of component completed
     C                   eval      ##CMSS = %CHAR(DNOCMC)

      * Time started
     C                   if        DSTRG1 <> *BLANKS
     C                   eval      ##STR1 = %subst(DSTRG1:1:2) + ':' +
     C                             %subst(DSTRG1:3:2) + ':' +
     C                             %subst(DSTRG1:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END1 = %subst(DENDG1:1:2) + ':' +
     C                             %subst(DENDG1:3:2) + ':' +
     C                             %subst(DENDG1:5:2) + ':'
      * Run Time
     C                   if        DENDG1 <> *BLANKS
     C                   eval      ##HST = %TIME(##STR1:*HMS)
     C                   eval      ##HET = %TIME(##END1:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM1 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      DCMPG1 = 'F'
     C                   eval      ##STS1 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        306131
     C                   WHEN      DCMPG1 = 'C'
     C                   eval      ##STS1 = 'Completed'
     C                   seton                                        31
     C                   WHEN      DCMPG1 = 'R'
     C                   eval      ##STS1 = 'Running...'
     C                   endsl

      * Time started
     C                   if        DSTRG11 <> *BLANKS
     C                   eval      ##STR11 = %subst(DSTRG11:1:2) + ':' +
     C                             %subst(DSTRG11:3:2) + ':' +
     C                             %subst(DSTRG11:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END11 = %subst(DENDG11:1:2) + ':' +
     C                             %subst(DENDG11:3:2) + ':' +
     C                             %subst(DENDG11:5:2) + ':'
      * Run Time
     C                   if        DENDG11 <> *BLANKS
     C                   eval      ##HST = %TIME(##STR11:*HMS)
     C                   eval      ##HET = %TIME(##END11:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM11 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      DCMPG11 = 'F'
     C                   eval      ##STS11 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        809181
     C                   WHEN      DCMPG11 = 'C'
     C                   eval      ##STS11 = 'Completed'
     C                   seton                                        81
     C                   WHEN      DCMPG11 = 'R'
     C                   eval      ##STS11 = 'Running...'
     C                   endsl

      * Time started
     C                   if        DSTRG2 <> *BLANKS
     C                   eval      ##STR2 = %subst(DSTRG2:1:2) + ':' +
     C                             %subst(DSTRG2:3:2) + ':' +
     C                             %subst(DSTRG2:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END2 = %subst(DENDG2:1:2) + ':' +
     C                             %subst(DENDG2:3:2) + ':' +
     C                             %subst(DENDG2:5:2) + ':'
      * Run Time
     C                   if        DENDG2 <> *BLANKS
     C                   eval      ##HST = %TIME(##STR2:*HMS)
     C                   eval      ##HET = %TIME(##END2:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM2 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      DCMPG2 = 'F'
     C                   eval      ##STS2 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        326233
     C                   WHEN      DCMPG2 = 'C'
     C                   eval      ##STS2 = 'Completed'
     C                   seton                                        33
     C                   WHEN      DCMPG2 = 'R'
     C                   eval      ##STS2 = 'Running...'
     C                   endsl

      * Time started
     C                   if        DSTRG3 <> *BLANKS
     C                   eval      ##STR3 = %subst(DSTRG3:1:2) + ':' +
     C                             %subst(DSTRG3:3:2) + ':' +
     C                             %subst(DSTRG3:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END3 = %subst(DENDG3:1:2) + ':' +
     C                             %subst(DENDG3:3:2) + ':' +
     C                             %subst(DENDG3:5:2) + ':'
      * Run Time
     C                   if        DENDG3 <> *BLANKS
     C                   eval      ##HST = %TIME(##STR3:*HMS)
     C                   eval      ##HET = %TIME(##END3:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM3 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      DCMPG3 = 'F'
     C                   eval      ##STS3 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        346335
     C                   WHEN      DCMPG3 = 'C'
     C                   eval      ##STS3 = 'Completed'
     C                   seton                                        35
     C                   WHEN      DCMPG3 = 'R'
     C                   eval      ##STS3 = 'Running...'
     C                   endsl

      * Time started
     C                   if        DSTRG4 <> *BLANKS
     C                   eval      ##STR4 = %subst(DSTRG4:1:2) + ':' +
     C                             %subst(DSTRG4:3:2) + ':' +
     C                             %subst(DSTRG4:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END4 = %subst(DENDG4:1:2) + ':' +
     C                             %subst(DENDG4:3:2) + ':' +
     C                             %subst(DENDG4:5:2) + ':'
      * Run Time
     C                   if        DENDG4 <> *BLANKS
     C                   eval      ##HST = %TIME(##STR4:*HMS)
     C                   eval      ##HET = %TIME(##END4:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM4 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      DCMPG4 = 'F'
     C                   eval      ##STS4 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        366437
     C                   WHEN      DCMPG4 = 'C'
     C                   eval      ##STS4 = 'Completed'
     C                   seton                                        37
     C                   WHEN      DCMPG4 = 'R'
     C                   eval      ##STS4 = 'Running...'
     C                   endsl

      * Time started
     C                   if        DSTRG5 <> *BLANKS
     C                   eval      ##STR5 = %subst(DSTRG5:1:2) + ':' +
     C                             %subst(DSTRG5:3:2) + ':' +
     C                             %subst(DSTRG5:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END5 = %subst(DENDG5:1:2) + ':' +
     C                             %subst(DENDG5:3:2) + ':' +
     C                             %subst(DENDG5:5:2) + ':'
      * Run Time
     C                   if        DENDG5 <> *BLANKS
     C                   eval      ##HST = %TIME(##STR5:*HMS)
     C                   eval      ##HET = %TIME(##END5:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM5 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      DCMPG5 = 'F'
     C                   eval      ##STS5 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        386539
     C                   WHEN      DCMPG5 = 'C'
     C                   eval      ##STS5 = 'Completed'
     C                   seton                                        39
     C                   WHEN      DCMPG5 = 'R'
     C                   eval      ##STS5 = 'Running...'
     C                   WHEN      DCMPG5 = 'W'
     C                   eval      ##STS5 = 'Warning'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        386539
     C                   seton                                        69
     C                   endsl

      * Time started
     C                   if        DSTRG6 <> *BLANKS
     C                   eval      ##STR6 = %subst(DSTRG6:1:2) + ':' +
     C                             %subst(DSTRG6:3:2) + ':' +
     C                             %subst(DSTRG6:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END6 = %subst(DENDG6:1:2) + ':' +
     C                             %subst(DENDG6:3:2) + ':' +
     C                             %subst(DENDG6:5:2) + ':'
      * Run Time
     C                   if        DENDG6 <> *BLANKS
     C                   eval      ##HST = %TIME(##STR6:*HMS)
     C                   eval      ##HET = %TIME(##END6:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM6 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      DCMPG6 = 'F'
     C                   eval      ##STS6 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        406641
     C                   WHEN      DCMPG6 = 'C'
     C                   eval      ##STS6 = 'Completed'
     C                   seton                                        41
     C                   WHEN      DCMPG6 = 'R'
     C                   eval      ##STS6 = 'Running...'
     C                   endsl

      * Time started
     C                   if        DSTRG7 <> *BLANKS
     C                   eval      ##STR7 = %subst(DSTRG7:1:2) + ':' +
     C                             %subst(DSTRG7:3:2) + ':' +
     C                             %subst(DSTRG7:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END7 = %subst(DENDG7:1:2) + ':' +
     C                             %subst(DENDG7:3:2) + ':' +
     C                             %subst(DENDG7:5:2) + ':'
      * Run Time
     C                   if        DENDG7 <> *BLANKS
     C                   eval      ##HST = %TIME(##STR7:*HMS)
     C                   eval      ##HET = %TIME(##END7:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM7 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      DCMPG7 = 'F'
     C                   eval      ##STS7 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        426743
     C                   WHEN      DCMPG7 = 'C'
     C                   eval      ##STS7 = 'Completed'
     C                   seton                                        43
     C                   WHEN      DCMPG7 = 'R'
     C                   eval      ##STS7 = 'Running...'
     C                   endsl

      * Time started
     C                   if        DSTRG8 <> *BLANKS
     C                   eval      ##STR8 = %subst(DSTRG8:1:2) + ':' +
     C                             %subst(DSTRG8:3:2) + ':' +
     C                             %subst(DSTRG8:5:2) + ':'
     C                   endif
      * Time ended
     C                   eval      ##END8 = %subst(DENDG8:1:2) + ':' +
     C                             %subst(DENDG8:3:2) + ':' +
     C                             %subst(DENDG8:5:2) + ':'
      * Run Time
     C                   if        DENDG8 <> *BLANKS
     C                   eval      ##HST = %TIME(##STR8:*HMS)
     C                   eval      ##HET = %TIME(##END8:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##RTM8 = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   select
     C                   WHEN      DCMPG8 = 'F'
     C                   eval      ##STS8 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        446845
     C                   WHEN      DCMPG8 = 'C'
     C                   eval      ##STS8 = 'Completed'
     C                   seton                                        45
     C                   WHEN      DCMPG8 = 'R'
     C                   eval      ##STS8 = 'Running...'
     C                   endsl

     C                   ENDSR
      *****************************************************************
     C     *INZSR        BEGSR

     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RtnCode
     C                   PARM      'UP_OTBRSVR'  ObjName
     C                   PARM      BRIDGELIB     ObjLib
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
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_LoadLayer - Load job details for the selected layer       *
      *                                                               *
      *****************************************************************
     C     SR_LoadLayer  BEGSR

     C                   eval      ##JOB1 = *blanks
     C                   eval      ##JOB11 = *blanks
     C                   eval      ##JOB2 = *blanks
     C                   eval      ##JOB3 = *blanks
     C                   eval      ##JOB4 = *blanks
     C                   eval      ##JOB5 = *blanks
     C                   eval      ##JOB6 = *blanks
     C                   eval      ##JOB7 = *blanks
     C                   eval      ##JOB8 = *blanks
     C                   setoff                                       22

     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :##LYRX and D_CMPN = 1
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = '071'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Else
     C                   If        SQLCode = 0
     C                   eval      ##JOB1 = D_JBNB + '/' + %trim(D_JBUS) +
     C                             '/' + %trim(D_JBNM)
     C                   seton                                        22
     C                   Endif
     C                   Endif

     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :##LYRX and D_CMPN = 11
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = '711'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Else
     C                   If        SQLCode = 0
     C                   eval      ##JOB11 = D_JBNB + '/' + %trim(D_JBUS) +
     C                             '/' + %trim(D_JBNM)
     C                   seton                                        22
     C                   Endif
     C                   Endif

     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :##LYRX and D_CMPN = 2
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = '072'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   else
     C                   If        SQLCode = 0
     C                   eval      ##JOB2 = D_JBNB + '/' + %trim(D_JBUS) +
     C                             '/' + %trim(D_JBNM)
     C                   Endif
     C                   Endif
     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :##LYRX and D_CMPN = 3
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = '073'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Else
     C                   If        SQLCode = 0
     C                   eval      ##JOB3 = D_JBNB + '/' + %trim(D_JBUS) +
     C                             '/' + %trim(D_JBNM)
     C                   Endif
     C                   Endif

     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :##LYRX and D_CMPN = 4
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = '074'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Else
     C                   If        SQLCode = 0
     C                   eval      ##JOB4 = D_JBNB + '/' + %trim(D_JBUS) +
     C                             '/' + %trim(D_JBNM)
     C                   Endif
     C                   Endif

     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :##LYRX and D_CMPN = 5
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = '075'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Else
     C                   If        SQLCode = 0
     C                   eval      ##JOB5 = D_JBNB + '/' + %trim(D_JBUS) +
     C                             '/' + %trim(D_JBNM)
     C                   Endif
     C                   Endif

     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :##LYRX and D_CMPN = 6
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = '076'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Else
     C                   If        SQLCode = 0
     C                   eval      ##JOB6 = D_JBNB + '/' + %trim(D_JBUS) +
     C                             '/' + %trim(D_JBNM)
     C                   Endif
     C                   Endif

     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :##LYRX and D_CMPN = 7
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = '077'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Else
     C                   If        SQLCode = 0
     C                   eval      ##JOB7 = D_JBNB + '/' + %trim(D_JBUS) +
     C                             '/' + %trim(D_JBNM)
     C                   Endif
     C                   Endif

     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :##LYRX and D_CMPN = 8
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = '078'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Else
     C                   If        SQLCode = 0
     C                   eval      ##JOB8 = D_JBNB + '/' + %trim(D_JBUS) +
     C                             '/' + %trim(D_JBNM)
     C                   Endif
     C                   Endif



     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_ViewJob - Display job                                     *
      *                                                               *
      *****************************************************************
     C     SR_ViewJob    BEGSR

     C                   if        ##LYRX <> ' '
     C                   eval      X_PRFX = ##LYRX
     C                   endif

     C                   If        ##ACT1 = 'V'
     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :X_PRFX and D_CMPN = 1
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = '001'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   If        ##ACT11 = 'V'
     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :X_PRFX and D_CMPN = 11
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = '011'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   If        ##ACT2 = 'V'
     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :X_PRFX and D_CMPN = 2
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = '012'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   If        ##ACT3 = 'V'
     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :X_PRFX and D_CMPN = 3
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = '013'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   If        ##ACT4 = 'V'
     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :X_PRFX and D_CMPN = 4
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = '014'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   If        ##ACT5 = 'V'
     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :X_PRFX and D_CMPN = 5
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = '015'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   If        ##ACT6 = 'V'
     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :X_PRFX and D_CMPN = 6
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = '016'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   If        ##ACT7 = 'V'
     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :X_PRFX and D_CMPN = 7
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = '017'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   If        ##ACT8 = 'V'
     C/exec SQL
     C+ select * into :UPOTRL
     C+ from UPOTRLTD u where D_PRFX = :X_PRFX and D_CMPN = 8
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = '018'
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'WRKJOB JOB(' + %trim(D_JBNB) +
     C                             '/' + %trim(D_JBUS) + '/' +
     C                             %trimr(D_JBNM) + ')'

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

     C                   select
     C                   when      ##ACT1 = 'R'
     C                   eval      Field = 'DCMPG1'
     C                   when      ##ACT11 = 'R'
     C                   eval      Field = 'DCMPG11'
     C                   when      ##ACT2 = 'R'
     C                   eval      Field = 'DCMPG2'
     C                   when      ##ACT3 = 'R'
     C                   eval      Field = 'DCMPG3'
     C                   when      ##ACT4 = 'R'
     C                   eval      Field = 'DCMPG4'
     C                   when      ##ACT5 = 'R'
     C                   eval      Field = 'DCMPG5'
     C                   when      ##ACT6 = 'R'
     C                   eval      Field = 'DCMPG6'
     C                   when      ##ACT7 = 'R'
     C                   eval      Field = 'DCMPG7'
     C                   when      ##ACT8 = 'R'
     C                   eval      Field = 'DCMPG8'
     C                   ENDSL

     C                   CALL      'UP7001'
     C                   PARM      '*UPDATE   '  ACT              10
     C                   PARM      ' '           BLK               2
     C                   PARM                    Field            10
     C                   PARM      *blanks       U_VAL           100
     C                   PARM      *blanks       RTN              10

     C                   CALL      'QSNDDTAQ'
     C                   PARM      'UP_OTBRSVR'  DtqNam           10
     C                   PARM      BRIDGELIB     DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'CONTINUE'    DtqDta           50
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
     C                   PARM      'UP_OTBRSVR'  DtqNam           10
     C                   PARM      BRIDGELIB     DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM      'IGNORE'      DtqDta           50
     C                   eval      V_EXFMT = 'N'

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
