     H DEBUG
     H COPYRIGHT('(c) Finastra International 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP OTB upgrade monitor')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP6004 - Midas UP OTU upgrade monitor                        *
      *                                                               *
      *  Function: This program displays the upgrade monitor screen.  *
      *                                                               *
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD061706           Date 01Aug23               *
      *  Prev Amend No. MD060542           Date 20Sep22               *
      *                 MD060514           Date 14Sep22               *
      *                 MD060351           Date 17Aug22               *
      *                 CUP044 *CREATE     Date 22May22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061706 - Various changes for transition to aDBU            *
      *  MD060542 - View should only be displayed when available      *
      *  MD060514 - Failed component can be restarted twice.          *
      *  MD060351 - Compilation error with multilanguage              *
      *  CUP044 - One Touch Bridge Automation Changes - Release/      *
      *           Patch Upgrade                                       *
      *                                                               *
      *****************************************************************
     FUP6004GF  CF   E             WORKSTN

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
     D DBASE           S              2S 0
     D X_PRFX          S              2
     D #_DLYJOB        S             70    DIM(1)  CTDATA PERRCD(1)
     D V_TOTF          S              5  0
     D V_EXFMT         S              1
     D SQLOK           C                   Const( 0 )
     D SQLEOF          C                   Const( 100 )
     D Command         S             80
     D CommandLen      S             15  5 INZ(80)

     D C_DOTL          C                   Const('--------------------------                MD060351
     D                                     -----------------------------------              MD060351
     D                                     -----------------------------------              MD060351
     D                                     -----------------------------------              MD060351
     D                                     -----------------------------------')            MD060351
                                                                                            MD060351
     DRtnCode          S             10
     DObjName          S             10
     DObjLib           S             10
     DObjType          S              8
     DChkMbr           S             10
     D WkTime          S              5S 0
     DTIME0            S               T   INZ(T'00.00.00')
     DN_VAR            S              6  0
     DC_VAR8           S              8
     DADBU             S              1                                                     MD061706

     D UPOTBM        E DS                  EXTNAME(UPOTBMTD)
     D UPOTBM_S      E DS                  EXTNAME(UPOTBMTD)
     D                                     PREFIX(S_)
     D UPOTBL        E DS                  EXTNAME(UPOTBLTD)

     D/COPY ZACPYSRC,PSDS
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    BRIDGELIB        10
     C                   PARM                    ERROR            10

     C                   eval      V_EXFMT = 'N'
     C                   eval      ERROR = *BLANK
     C                   eval      ##JOB = PSJobName
     C                   eval      ##USR = PSUser

      * Retrieve Global Compare Work File UPOTBMTD
     C/exec SQL
     C+ select * into :UPOTBM
     C+ from UPOTBMTD
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif

      * Check if database upgrade is to be done with aDBU                                   MD061706
     C                   eval      ADBU = 'N'                                               MD061706
     C/exec SQL                                                                             MD061706
     C+ select UCADBU into :ADBU                                                            MD061706
     C+ from UPCCSITD                                                                       MD061706
     C/end-exec                                                                             MD061706
                                                                                            MD061706
      * If 'Y', display aDBU                                                                MD061706
     C                   setoff                                       90                    MD061706
     C                   If        ADBU = 'Y'                                               MD061706
     C                   seton                                        90                    MD061706
     C                   Endif                                                              MD061706
                                                                                            MD061706
      * Initialize display file
     C                   Exsr      SR_LOAD

      * While F3 is not selected
     C                   DOW       *INKC = *OFF
     C                   TIME                    ##TME

      * Blank out ##ACTn fields
     C                   eval      ##ACT1 = *blanks
     C                   eval      ##ACT2 = *blanks
     C                   eval      ##ACT3 = *blanks
     C                   eval      ##ACT4 = *blanks
     C                   eval      ##ACT5 = *blanks
     C                   eval      ##ACT6 = *blanks
     C                   eval      ##ACT7 = *blanks

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
                                                                                            MD060542
     C                   If        ##LYRX = ' '                                             MD060542
     C                   setoff                                       22                    MD060542
     C                   Endif                                                              MD060542
                                                                                            MD060542
     C                   EXFMT     RECFMT

      * If Layer is selected
     C                   If        ##LYRX <> ' '
     C                   seton                                        19                    MD060542
     C                   exsr      SR_LoadLayer
     C                   Endif

      * If View is selected
     C                   If        ##ACT1 = 'V'
     C                             or ##ACT2 = 'V' or ##ACT3 = 'V'
     C                             or ##ACT4 = 'V' or ##ACT5 = 'V'
     C                             or ##ACT6 = 'V' or ##ACT7 = 'V'
     C                   exsr      SR_ViewJob
     C                   Endif

      * If Restart is selected
     C                   If        ##ACT1 = 'R'
     C                             or ##ACT2 = 'R' or ##ACT3 = 'R'
     C                             or ##ACT4 = 'R' or ##ACT5 = 'R'
     C                             or ##ACT6 = 'R' or ##ACT7 = 'R'
     C                   exsr      SR_RestartJob
     C                   Endif

      * If Ignore is selected
     C                   If        ##ACT5 = 'I'
     C                   exsr      SR_IgnoreJob
     C                   Endif

     C                   Else
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

      * Retrieve Global Compare Work File UPOTBMTD
     C/exec SQL
     C+ select * into :UPOTBM
     C+ from UPOTBMTD
     C/end-exec
     C                   If        SQLCode <> 0
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif

      * Reload screen if different
     C                   If        UPOTBM_S <> UPOTBM
     C                   Exsr      SR_LOAD
     C                   Endif
     C                   ENDIF

      * If DTAQ does not exist, server is not running, proceed with EXFMT
      * rather WRITE
     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RtnCode
     C                   PARM      'UP_OTB_SVR'  ObjName
     C                   PARM      BRIDGELIB     ObjLib
     C                   PARM      '*DTAQ'       ObjType
     C                   PARM                    ChkMbr

     C***                eval      V_EXFMT = 'N'
     C                   IF        RtnCode <> 'Exist     '
     C                   eval      V_EXFMT = 'Y'
     C                   ENDIF

     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
     C     SR_LOAD       BEGSR

      * Set off indicators *IN30 to *IN40
      * Correct code for built-in function %SUBARR                                          MD061706
     C**********         eval      %Subarr(*IN : 30 : 40) = *OFF                            MD061706
     C                   eval      %Subarr(*IN : 30 : 20) = *OFF                            MD061706
     C**********         eval      %Subarr(*IN : 60) =  *OFF                                MD061706
     C                   eval      %Subarr(*IN : 60 : 10) =  *OFF                           MD061706
     C                   eval      V_TOTF = 0
     C                   eval      UPOTBM_S = UPOTBM
     C                   eval      ##STR1 = *blanks
     C                   eval      ##STR2 = *blanks
     C                   eval      ##STR3 = *blanks
     C                   eval      ##STR4 = *blanks
     C                   eval      ##STR5 = *blanks
     C                   eval      ##STR6 = *blanks
     C                   eval      ##STR7 = *blanks
     C                   eval      ##STS1 = *blanks
     C                   eval      ##STS2 = *blanks
     C                   eval      ##STS3 = *blanks
     C                   eval      ##STS4 = *blanks
     C                   eval      ##STS5 = *blanks
     C                   eval      ##STS6 = *blanks
     C                   eval      ##STS7 = *blanks
     C                   eval      ##DOTL = C_DOTL                                          MD060351

      * GLOBAL
     C                   eval      ##PRFX = DGPRFX

      * Reference System
     C                   eval      ##LYRS = *blanks
     C                   eval      DSLyr  = DLAYRS
     C                   eval      ArrLyr(1) = DSG1
     C                   eval      ArrLyr(2) = DSL1
     C                   eval      ArrLyr(3) = DSL2
     C                   eval      ArrLyr(4) = DSL3
     C                   eval      ArrLyr(5) = DSL4
     C                   eval      ArrLyr(6) = DSL5
     C                   eval      ArrLyr(7) = DSL6
     C                   eval      ArrLyr(8) = DSL7
     C                   eval      ArrLyr(9) = DSL8
     C                   eval      ArrLyr(10) = DSL9
     C                   eval      ArrLyr(11) = DSL0
     C                   DO        11            Ix
     C                   if        ArrLyr(Ix) <> *blanks
     C                   eval      ##LYRS = %trim(##LYRS) + ' ' + ArrLyr(Ix)
     C                   ENDIF
     C                   ENDDO
      * Time Started
     C                   eval      N_VAR = %DEC(DSTRTD:6:0)
     C                   eval      ##STRT = %TIME(N_VAR:*HMS)

      * Time Ended
     C                   if        DENDED <> *BLANKS
     C                   eval      N_VAR = %DEC(DENDED:6:0)
     C                   eval      ##ENDT = %TIME(N_VAR:*HMS)
     C                   seton                                        18
     C                   setoff                                       19                    MD060542
      * At this point, DTAQ is about to be deleted, so no more WRITE is needed
     C                   eval      V_EXFMT = 'Y'
     C                   endif

      * Total number of component
     C                   eval      ##OTTC = %CHAR(DNOCMP)

      * Total number of component completed
     C                   eval      ##CMSS = %CHAR(DNOCMC)

      * Active layer
     C                   eval      ##ACTL = DACTVL
     C                   eval      ##ACNR = DACTNR

      * the components
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
     C                   setoff                                       91                    MD061706
     C                   select
     C                   WHEN      DCMPG4 = 'F'
     C                   eval      ##STS4 = 'Failed'
     C                   eval      V_EXFMT = 'Y'
     C                   seton                                        366437
      ** if aDBU, seton 91 so adbU function key is displayed                                MD061706
     C   90              seton                                        91                    MD061706
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

     C                   ENDSR
      *****************************************************************
     C     *INZSR        BEGSR

     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RtnCode
     C                   PARM      'UP_OTB_SVR'  ObjName
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
     C                   eval      ##JOB2 = *blanks
     C                   eval      ##JOB3 = *blanks
     C                   eval      ##JOB4 = *blanks
     C                   eval      ##JOB5 = *blanks
     C                   eval      ##JOB6 = *blanks
     C                   eval      ##JOB7 = *blanks
     C                   setoff                                       22

     C/exec SQL
     C+ select * into :UPOTBL
     C+ from UPOTBLTD u where D_PRFX = :##LYRX and D_CMPN = 1
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = 71
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
     C+ select * into :UPOTBL
     C+ from UPOTBLTD u where D_PRFX = :##LYRX and D_CMPN = 2
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = 72
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   else
     C                   If        SQLCode = 0
     C                   eval      ##JOB2 = D_JBNB + '/' + %trim(D_JBUS) +
     C                             '/' + %trim(D_JBNM)
     C                   Endif
     C                   Endif
     C/exec SQL
     C+ select * into :UPOTBL
     C+ from UPOTBLTD u where D_PRFX = :##LYRX and D_CMPN = 1
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = 71
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Else
     C                   If        SQLCode = 0
     C                   eval      ##JOB1 = D_JBNB + '/' + %trim(D_JBUS) +
     C                             '/' + %trim(D_JBNM)
     C                   Endif
     C                   Endif

     C/exec SQL
     C+ select * into :UPOTBL
     C+ from UPOTBLTD u where D_PRFX = :##LYRX and D_CMPN = 3
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = 73
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Else
     C                   If        SQLCode = 0
     C                   eval      ##JOB3 = D_JBNB + '/' + %trim(D_JBUS) +
     C                             '/' + %trim(D_JBNM)
     C                   Endif
     C                   Endif

     C/exec SQL
     C+ select * into :UPOTBL
     C+ from UPOTBLTD u where D_PRFX = :##LYRX and D_CMPN = 4
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = 74
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Else
     C                   If        SQLCode = 0
     C                   eval      ##JOB4 = D_JBNB + '/' + %trim(D_JBUS) +
     C                             '/' + %trim(D_JBNM)
     C                   Endif
     C                   Endif

     C/exec SQL
     C+ select * into :UPOTBL
     C+ from UPOTBLTD u where D_PRFX = :##LYRX and D_CMPN = 5
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = 75
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Else
     C                   If        SQLCode = 0
     C                   eval      ##JOB5 = D_JBNB + '/' + %trim(D_JBUS) +
     C                             '/' + %trim(D_JBNM)
     C                   Endif
     C                   Endif

     C/exec SQL
     C+ select * into :UPOTBL
     C+ from UPOTBLTD u where D_PRFX = :##LYRX and D_CMPN = 6
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = 76
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Else
     C                   If        SQLCode = 0
     C                   eval      ##JOB6 = D_JBNB + '/' + %trim(D_JBUS) +
     C                             '/' + %trim(D_JBNM)
     C                   Endif
     C                   Endif

     C/exec SQL
     C+ select * into :UPOTBL
     C+ from UPOTBLTD u where D_PRFX = :##LYRX and D_CMPN = 7
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0 and SQLCODE <> 100
     C                   dump
     C                   eval      DBASE = 77
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Else
     C                   If        SQLCode = 0
     C                   eval      ##JOB7 = D_JBNB + '/' + %trim(D_JBUS) +
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

     C                   eval      X_PRFX = ##ACTL
     C                   if        ##LYRX <> ' '
     C                   eval      X_PRFX = ##LYRX
     C                   endif

     C                   If        ##ACT1 = 'V'
     C/exec SQL
     C+ select * into :UPOTBL
     C+ from UPOTBLTD u where D_PRFX = :X_PRFX and D_CMPN = 1
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = 1
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   If        ##ACT2 = 'V'
     C/exec SQL
     C+ select * into :UPOTBL
     C+ from UPOTBLTD u where D_PRFX = :X_PRFX and D_CMPN = 2
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = 2
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   If        ##ACT3 = 'V'
     C/exec SQL
     C+ select * into :UPOTBL
     C+ from UPOTBLTD u where D_PRFX = :X_PRFX and D_CMPN = 3
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = 3
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   If        ##ACT4 = 'V'
     C/exec SQL
     C+ select * into :UPOTBL
     C+ from UPOTBLTD u where D_PRFX = :X_PRFX and D_CMPN = 4
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = 4
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   If        ##ACT5 = 'V'
     C/exec SQL
     C+ select * into :UPOTBL
     C+ from UPOTBLTD u where D_PRFX = :X_PRFX and D_CMPN = 5
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = 5
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   If        ##ACT6 = 'V'
     C/exec SQL
     C+ select * into :UPOTBL
     C+ from UPOTBLTD u where D_PRFX = :X_PRFX and D_CMPN = 6
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = 6
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   If        ##ACT7 = 'V'
     C/exec SQL
     C+ select * into :UPOTBL
     C+ from UPOTBLTD u where D_PRFX = :X_PRFX and D_CMPN = 7
     C+ order by rrn(u) desc
     C+ fetch first 1 row only
     C/end-exec
     C                   If        SQLCode <> 0
     C                   dump
     C                   eval      DBASE = 7
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif
     C                   Endif

     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'WRKJOB JOB(' + %trim(D_JBNB) +
     C                             '/' + %trim(D_JBUS) + '/' +
     C                             %trimr(D_JBNM) + ')'

     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen

      * monitor error
     C                   if        %error
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

      * If job is restarted, update its status here and reset indicator                     MD060514
     C                   SELECT                                                             MD060514
     C                   WHEN      *IN61 = '1'                                              MD060514
     C/EXEC SQL                                                                             MD060514
     C+ update UPOTBMTD set DCMPG1 = ' '                                                    MD060514
     C/END-EXEC                                                                             MD060514
     C                   SETOFF                                       61                    MD060514
     C                   WHEN      *IN62 = '1'                                              MD060514
     C/EXEC SQL                                                                             MD060514
     C+ update UPOTBMTD set DCMPG2 = ' '                                                    MD060514
     C/END-EXEC                                                                             MD060514
     C                   SETOFF                                       62                    MD060514
     C                   WHEN      *IN63 = '1'                                              MD060514
     C/EXEC SQL                                                                             MD060514
     C+ update UPOTBMTD set DCMPG3 = ' '                                                    MD060514
     C/END-EXEC                                                                             MD060514
     C                   SETOFF                                       63                    MD060514
     C                   WHEN      *IN64 = '1'                                              MD060514
     C/EXEC SQL                                                                             MD060514
     C+ update UPOTBMTD set DCMPG4 = ' '                                                    MD060514
     C/END-EXEC                                                                             MD060514
     C                   SETOFF                                       64                    MD060514
     C                   WHEN      *IN65 = '1'                                              MD060514
     C/EXEC SQL                                                                             MD060514
     C+ update UPOTBMTD set DCMPG5 = ' '                                                    MD060514
     C/END-EXEC                                                                             MD060514
     C                   SETOFF                                       65                    MD060514
     C                   WHEN      *IN66 = '1'                                              MD060514
     C/EXEC SQL                                                                             MD060514
     C+ update UPOTBMTD set DCMPG6 = ' '                                                    MD060514
     C/END-EXEC                                                                             MD060514
     C                   SETOFF                                       66                    MD060514
     C                   WHEN      *IN67 = '1'                                              MD060514
     C/EXEC SQL                                                                             MD060514
     C+ update UPOTBMTD set DCMPG7 = ' '                                                    MD060514
     C/END-EXEC                                                                             MD060514
     C                   SETOFF                                       67                    MD060514
     C                   ENDSL                                                              MD060514
     C                                                                                      MD060514
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'UP_OTB_SVR'  DtqNam           10
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
     C                   PARM      'UP_OTB_SVR'  DtqNam           10
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
