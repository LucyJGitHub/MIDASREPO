     H DEBUG
     H COPYRIGHT('(c) Finastra International 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP ADBU Compare Monitor')                        *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP4004 - ADBU Compare Monitor                                *
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
     FUP4005DF  CF   E             WORKSTN

     D #_DLYJOB        S             70    DIM(1)  CTDATA PERRCD(1)
     D V_TOTF          S              5  0
     D V_EXFMT         S              1
     D SQLOK           C                   Const( 0 )
     D SQLEOF          C                   Const( 100 )
     D Command         S             80
     D CommandLen      S             15  5 INZ(80)

     DRtnCode          S             10
     DObjName          S             10
     DObjLib           S             10
     DObjType          S              8
     DChkMbr           S             10
     D WkTime          S              5S 0
     DTIME0            S               T   INZ(T'00.00.00')
     DN_VAR            S              6  0
     DC_VAR8           S              8

     D UPZCMP        E DS                  EXTNAME(UPZCMPTD)
     D UPZCMP_S      E DS                  EXTNAME(UPZCMPTD)
     D                                     PREFIX(S_)

     D C_DOTL          C                   Const('--------------------------                MD060271
     D                                     -----------------------------------              MD060271
     D                                     -----------------------------------              MD060271
     D                                     -----------------------------------              MD060271
     D                                     -----------------------------------')            MD060271
     D F_A             C                   Const('F3=Exit  F7=Display Summar-               MD061706
     D                                     y Report F8=Display Detailed Report -            MD061706
     D                                     F22=Update Driver File')                         MD061706
     D F_B             C                   Const('F3=Exit  F7=Display Summar-               MD061706
     D                                     y Report F8=Display Detailed Report')            MD061706
     D/COPY ZACPYSRC,PSDS
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PREFIX            2
     C**********         PARM                    REFSYS            2                        MD061992
     C                   PARM                    REFSYS            3                        MD061992
     C                   PARM                    BRIDGELIB        10
     C                   PARM                    ERROR            10
     C                   PARM                    OTBU              1                        MD061706

     C                   eval      ERROR = *BLANK
     C                   eval      ##JOB = PSJobName
     C                   eval      ##USR = PSUser

      * Retrieve Zone Compare Work File UPZCMPTD
     C/exec SQL
     C+ select * into :UPZCMP
     C+ from UPZCMPTD where UPPRFX = :PREFIX
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

      * If program is called from OTBU, screen needs to be updated manually by pressing F5  MD061706
     C                   setoff                                       69                    MD061706
     C                   If        OTBU = 'Y'                                               MD061706
     C                   eval      V_EXFMT = 'Y'                                            MD061706
     C                   seton                                        6968                  MD061706
     C                   Endif                                                              MD061706
                                                                                            MD061706
      * Elapsed Time
      * If 'End Time' available
     C                   if        UPTMED <> *BLANKS
     C                   EVAL      WkTime = %DIFF(##ENDT:##STRT:*SECONDS)
     C                   EVAL      ##LAPS = TIME0 + %SECONDS(WkTime)
     C                   setoff                                       69                    MD061706
     C                   else
      * If 'End Time' not available
     C                   TIME                    ##CURT
     C                   EVAL      WkTime = %DIFF(##CURT:##STRT:*SECONDS)
     C                   EVAL      ##LAPS = TIME0 + %SECONDS(WkTime)
     C                   endif

     C                   If        V_EXFMT = 'Y'
     C                   EXFMT     RECFMT

      * If F7 is selected, display Summary spooled file
     C                   If        *INKG = *ON
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'DSPSPLF FILE(UP4007P1' +
     C                             ') JOB(' + %trim(UPRPJN) + '/' +
     C                             %trimr(UPUSER) + '/UP_ADBURPT)'

     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   Endif

      * If F8 is selected, display Detailed spooled file
     C                   If        *INKH = *ON
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'DSPSPLF FILE(UP4006P1' +
     C                             ') JOB(' + %trim(UPRPJN) + '/' +
     C                             %trimr(UPUSER) + '/UP_ADBURPT)'

     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   Endif

      * If F22 is selected, display Detailed spooled file
     C                   If        *INKW= *ON
     C*                  EVAL      Command = *blanks
     C*                  EVAL      Command = 'CALL UP4020'

     C*                  CALL      'QCMDEXC'
     C                   CALL      'UP4020'
     C                   PARM                    PREFIX
     C                   PARM                    REFSYS
     C                   PARM                    BRIDGELIB
     C                   Endif

      * If F5 is selected, reload screen if different                                       MD061706
     C                   If        *INKE = *ON                                              MD061706
     C/exec SQL                                                                             MD061706
     C+ select * into :UPZCMP                                                               MD061706
     C+ from UPZCMPTD where UPPRFX = :PREFIX                                                MD061706
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
     C                   Else
     C                   WRITE     RECFMT

      * Wait for update before reloading screen
     C                   CALL(E)   'QRCVDTAQ'
     C                   PARM      'UPZADBCDTQ'  DtqNam           10
     C                   PARM      '*LIBL'       DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM                    DtqDta           10
     C                   PARM      2             DtqWait           5 0

      * monitor error where DTAQ may already have been deleted by the server
     C                   if        %error
     C                   eval      V_EXFMT = 'Y'
     C                   endif

      * Retrieve Zone Compare Work File UPZCMPTD
     C/exec SQL
     C+ select * into :UPZCMP
     C+ from UPZCMPTD where UPPRFX = :PREFIX
     C/end-exec
     C                   If        SQLCode <> SQLOK
     C                             and SQLCode <> SQLEOF
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif

      * Reload screen if different
     C                   If        UPZCMP_S <> UPZCMP
     C                   Exsr      SR_LOAD
     C                   Endif
     C                   ENDIF

     C                   ENDDO

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
     C     SR_LOAD       BEGSR

      * Set off indicators *IN30 to *IN40
     C                   eval      %Subarr(*IN : 30 : 40) = *OFF
     C                   eval      V_TOTF = 0
     C                   eval      UPZCMP_S = UPZCMP
     C                   eval      ##DOTL = C_DOTL                                          MD060271
     C                   If        OTBU = 'Y'                                               MD061706
     C                   eval      ##FCT = F_B                                              MD061706
     C                   Else                                                               MD061706
     C                   eval      ##FCT = F_A                                              MD061706
     C                   Endif                                                              MD061706

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
     C                   seton                                        38
      * At this point, DTAQ is about to be deleted, so no more WRITE is needed
     C                   eval      V_EXFMT = 'Y'
     C                   endif

      * Set detail values DM
      * Library
     C                   eval      ##DMLB = PREFIX + 'DMLIB'
      * Job name
     C                   eval      ##DMJB = UPDMJN + '/' + %trimr(UPUSER) +
     C                             '/' + ##DMLB
      * Number of files
     C                   evalr     ##DMTF = %char(UPDMNF)
     C                   eval      V_TOTF = V_TOTF + UPDMNF
      * Number of files in ref system
     C                   evalr     ##DMTR = %char(UPDMNR)
      * Time started
     C                   eval      ##DMST = %subst(UPDMSB:1:2) + ':' +
     C                             %subst(UPDMSB:3:2) + ':' +
     C                             %subst(UPDMSB:5:2) + ':'
      * Time ended
     C                   eval      ##DMED = %subst(UPDMED:1:2) + ':' +
     C                             %subst(UPDMED:3:2) + ':' +
     C                             %subst(UPDMED:5:2) + ':'
      * Run Time
     C                   if        UPDMED <> *BLANKS
     C                   eval      ##HST = %TIME(##DMST:*HMS)
     C                   eval      ##HET = %TIME(##DMED:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##DMRT = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   If        UPDMSS = 'A'
     C                   eval      ##DMSS = 'Completed Abnormally'
     C                   seton                                        30
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
      * Number of files in ref system
     C                   evalr     ##DPTR = %char(UPDPNR)
      * Time started
     C                   eval      ##DPST = %subst(UPDPSB:1:2) + ':' +
     C                             %subst(UPDPSB:3:2) + ':' +
     C                             %subst(UPDPSB:5:2) + ':'
      * Time ended
     C                   eval      ##DPED = %subst(UPDPED:1:2) + ':' +
     C                             %subst(UPDPED:3:2) + ':' +
     C                             %subst(UPDPED:5:2) + ':'
      * Run Time
     C                   if        UPDPED <> *BLANKS
     C                   eval      ##HST = %TIME(##DPST:*HMS)
     C                   eval      ##HET = %TIME(##DPED:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##DPRT = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   If        UPDPSS = 'A'
     C                   eval      ##DPSS = 'Completed Abnormally'
     C                   seton                                        32
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
      * Number of files in ref system
     C                   evalr     ##DTTR = %char(UPDTNR)
      * Time started
     C                   eval      ##DTST = %subst(UPDTSB:1:2) + ':' +
     C                             %subst(UPDTSB:3:2) + ':' +
     C                             %subst(UPDTSB:5:2) + ':'
      * Time ended
     C                   eval      ##DTED = %subst(UPDTED:1:2) + ':' +
     C                             %subst(UPDTED:3:2) + ':' +
     C                             %subst(UPDTED:5:2) + ':'
      * Run Time
     C                   if        UPDTED <> *BLANKS
     C                   eval      ##HST = %TIME(##DTST:*HMS)
     C                   eval      ##HET = %TIME(##DTED:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##DTRT = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   If        UPDTSS = 'A'
     C                   eval      ##DTSS = 'Completed Abnormally'
     C                   seton                                        34
     C                   Else
     C                   If        UPDTED <> *blanks
     C                   eval      ##DTSS = 'Completed Normally'
     C                   seton                                        35
     C                   Else
     C                   eval      ##DTSS = 'Running...'
     C                   ENDIF
     C                   ENDIF

      * Set detail values DV
      * Library
     C                   eval      ##DVLB = PREFIX + 'DVLIB'
      * Job name
     C                   eval      ##DVJB = UPDVJN + '/' + %trimr(UPUSER) +
     C                             '/' + ##DVLB
      * Number of files
     C                   evalr     ##DVTF = %char(UPDVNF)
     C                   eval      V_TOTF = V_TOTF + UPDVNF
      * Number of files in ref system
     C                   evalr     ##DVTR = %char(UPDVNR)
      * Time started
     C                   eval      ##DVST = %subst(UPDVSB:1:2) + ':' +
     C                             %subst(UPDVSB:3:2) + ':' +
     C                             %subst(UPDVSB:5:2) + ':'
      * Time ended
     C                   eval      ##DVED = %subst(UPDVED:1:2) + ':' +
     C                             %subst(UPDVED:3:2) + ':' +
     C                             %subst(UPDVED:5:2) + ':'
      * Run Time
     C                   if        UPDVED <> *BLANKS
     C                   eval      ##HST = %TIME(##DVST:*HMS)
     C                   eval      ##HET = %TIME(##DVED:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##DVRT = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   If        UPDVSS = 'A'
     C                   eval      ##DVSS = 'Completed Abnormally'
     C                   seton                                        36
     C                   Else
     C                   If        UPDVED <> *blanks
     C                   eval      ##DVSS = 'Completed Normally'
     C                   seton                                        37
     C                   Else
     C                   eval      ##DVSS = 'Running...'
     C                   ENDIF
     C                   ENDIF

      * Set header values
      * Total files to compare
     C                   If        UPCMSS = 'C'
     C                   eval      ##OTTC = %CHAR(V_TOTF)
     C                   setoff                                       50
     C                   else
     C                   If        UPDMNF = 0 or UPDPNF = 0  or +
     C                             UPDTNF = 0  or UPDVNF = 0
     C                   eval      ##OTCN = 'Determining...'
     C                   seton                                        50
     C                   else
     C                   eval      ##OTTC = %CHAR(V_TOTF)
     C                   setoff                                       50
     C                   ENDIF
     C                   ENDIF

      * Compare Status
     C                   If        UPCMSS = 'I'
     C                   eval      ##CMSS = 'Initializing...'
     C                   else
     C                   If        UPCMSS = 'R'
     C                   eval      ##CMSS = 'Running...'
     C                   else
     C                   If        UPCMSS = 'C'
     C                   eval      ##CMSS = 'Completed'
     C                   else
     C                   If        UPCMSS = 'A'
     C                   eval      ##CMSS = 'Ended Abnormally'
     C                   eval      V_EXFMT = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * Report Status
     C                   If        UPRPSS = ' '
     C                   eval      ##RPSS = 'Not submitted'
     C                   else
     C                   If        UPRPSS = 'I'
     C                   eval      ##RPSS = 'Initializing...'
     C                   else
     C                   If        UPRPSS = 'R'
     C                   eval      ##RPSS = 'Running...'
     C                   else
     C                   If        UPRPSS = 'C'
     C                   eval      ##RPSS = 'Completed'
     C                   seton                                        39
     C                   eval      ##NARR = UPRPJN + '/' + %trimr(UPUSER) +
     C                             '/' + 'UP_ADBURPT.'
     C                   else
     C                   If        UPRPSS = 'A'
     C                   eval      ##RPSS = 'Ended Abnormally'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C     *INZSR        BEGSR

     C                   CALL      'UTCHKOBJ'
     C                   PARM      *BLANK        RtnCode
     C                   PARM      'UPZADBCDTQ'  ObjName
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
