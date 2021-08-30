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
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CUT017 *CREATE       Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUT017 - Adaptive Database Upgrade                           *
      *                                                               *
      *****************************************************************
     FUP4004GF  CF   E             WORKSTN

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

     D UPGCMP        E DS                  EXTNAME(UPGCMPTD)
     D UPGCMP_S      E DS                  EXTNAME(UPGCMPTD)
     D                                     PREFIX(S_)

     D/COPY ZACPYSRC,PSDS
      *****************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    PREFIX            2
     C                   PARM                    REFSYS            2
     C                   PARM                    BRIDGELIB        10
     C                   PARM                    ERROR            10

     C                   eval      ERROR = *BLANK
     C                   eval      ##JOB = PSJobName
     C                   eval      ##USR = PSUser

      * Retrieve Global Compare Work File UPGCMPTD
     C/exec SQL
     C+ select * into :UPGCMP
     C+ from UPGCMPTD where UPPRFX = :PREFIX
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

      * Elapsed Time
      * If 'End Time' available
     C                   if        UPTMED <> *BLANKS
     C                   EVAL      WkTime = %DIFF(##ENDT:##STRT:*SECONDS)
     C                   EVAL      ##LAPS = TIME0 + %SECONDS(WkTime)
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
     C                   EVAL      Command = *blanks
     C                   EVAL      Command = 'CALL UP4021'

     C*                  CALL      'QCMDEXC'
     C                   CALL      'UP4021'
     C                   PARM                    PREFIX
     C                   PARM                    REFSYS
     C                   PARM                    BRIDGELIB
     C                   Endif

     C                   Else
     C                   WRITE     RECFMT

      * Wait for update before reloading screen
     C                   CALL(E)   'QRCVDTAQ'
     C                   PARM      'UPGADBCDTQ'  DtqNam           10
     C                   PARM      '*LIBL'       DtqLib           10
     C                   PARM      50            DtqLen            5 0
     C                   PARM                    DtqDta           10
     C                   PARM      2             DtqWait           5 0

      * monitor error where DTAQ may already have been deleted by the server
     C                   if        %error
     C                   eval      V_EXFMT = 'Y'
     C                   endif

      * Retrieve Global Compare Work File UPGCMPTD
     C/exec SQL
     C+ select * into :UPGCMP
     C+ from UPGCMPTD where UPPRFX = :PREFIX
     C/end-exec
     C                   If        SQLCode <> SQLOK
     C                             and SQLCode <> SQLEOF
     C                   eval      ERROR = '*Error'
     C                   Return
     C                   Endif

      * Reload screen if different
     C                   If        UPGCMP_S <> UPGCMP
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
     C                   eval      UPGCMP_S = UPGCMP

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

      * Set detail values GM
      * Library
     C                   eval      ##GMLB = PREFIX + 'GMLIB'
      * Job name
     C                   eval      ##GMJB = UPGMJN + '/' + %trimr(UPUSER) +
     C                             '/' + ##GMLB
      * Number of files
     C                   eval      ##GMTF = %char(UPGMNF)
     C                   eval      V_TOTF = V_TOTF + UPGMNF
      * Number of files in ref system
     C                   eval      ##GMTR = %char(UPGMNR)
      * Time started
     C                   eval      ##GMST = %subst(UPGMSB:1:2) + ':' +
     C                             %subst(UPGMSB:3:2) + ':' +
     C                             %subst(UPGMSB:5:2) + ':'
      * Time ended
     C                   eval      ##GMED = %subst(UPGMED:1:2) + ':' +
     C                             %subst(UPGMED:3:2) + ':' +
     C                             %subst(UPGMED:5:2) + ':'
      * Run Time
     C                   if        UPGMED <> *BLANKS
     C                   eval      ##HST = %TIME(##GMST:*HMS)
     C                   eval      ##HET = %TIME(##GMED:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##GMRT = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   If        UPGMSS = 'A'
     C                   eval      ##GMSS = 'Completed Abnormally'
     C                   seton                                        30
     C                   Else
     C                   If        UPGMED <> *blanks
     C                   eval      ##GMSS = 'Completed Normally'
     C                   seton                                        31
     C                   Else
     C                   eval      ##GMSS = 'Running...'
     C*                  seton                                        31
     C                   ENDIF
     C                   ENDIF

      * Set detail values GP
      * Library
     C                   eval      ##GPLB = PREFIX + 'GPLIB'
      * Job name
     C                   eval      ##GPJB = UPGPJN + '/' + %trimr(UPUSER) +
     C                             '/' + ##GPLB
      * Number of files
     C                   eval      ##GPTF = %char(UPGPNF)
     C                   eval      V_TOTF = V_TOTF + UPGPNF
      * Number of files in ref system
     C                   eval      ##GPTR = %char(UPGPNR)
      * Time started
     C                   eval      ##GPST = %subst(UPGPSB:1:2) + ':' +
     C                             %subst(UPGPSB:3:2) + ':' +
     C                             %subst(UPGPSB:5:2) + ':'
      * Time ended
     C                   eval      ##GPED = %subst(UPGPED:1:2) + ':' +
     C                             %subst(UPGPED:3:2) + ':' +
     C                             %subst(UPGPED:5:2) + ':'
      * Run Time
     C                   if        UPGPED <> *BLANKS
     C                   eval      ##HST = %TIME(##GPST:*HMS)
     C                   eval      ##HET = %TIME(##GPED:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##GPRT = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   If        UPGPSS = 'A'
     C                   eval      ##GPSS = 'Completed Abnormally'
     C                   seton                                        32
     C                   Else
     C                   If        UPGPED <> *blanks
     C                   eval      ##GPSS = 'Completed Normally'
     C                   seton                                        33
     C                   Else
     C                   eval      ##GPSS = 'Running...'
     C*                  seton                                        33
     C                   ENDIF
     C                   ENDIF

      * Set detail values GTA
      * Library
     C                   eval      ##GTLB = PREFIX + 'GTALIB'
      * Job name
     C                   eval      ##GTJB = UPGTJN + '/' + %trimr(UPUSER) +
     C                             '/' + ##GTLB
      * Number of files
     C                   eval      ##GTTF = %char(UPGTNF)
     C                   eval      V_TOTF = V_TOTF + UPGTNF
      * Number of files in ref system
     C                   eval      ##GTTR = %char(UPGTNR)
      * Time started
     C                   eval      ##GTST = %subst(UPGTSB:1:2) + ':' +
     C                             %subst(UPGTSB:3:2) + ':' +
     C                             %subst(UPGTSB:5:2) + ':'
      * Time ended
     C                   eval      ##GTED = %subst(UPGTED:1:2) + ':' +
     C                             %subst(UPGTED:3:2) + ':' +
     C                             %subst(UPGTED:5:2) + ':'
      * Run Time
     C                   if        UPGTED <> *BLANKS
     C                   eval      ##HST = %TIME(##GTST:*HMS)
     C                   eval      ##HET = %TIME(##GTED:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##GTRT = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   If        UPGTSS = 'A'
     C                   eval      ##GTSS = 'Completed Abnormally'
     C                   seton                                        34
     C                   Else
     C                   If        UPGTED <> *blanks
     C                   eval      ##GTSS = 'Completed Normally'
     C                   seton                                        35
     C                   Else
     C                   eval      ##GTSS = 'Running...'
     C*                  seton                                        35
     C                   ENDIF
     C                   ENDIF

      * Set detail values GV
      * Library
     C                   eval      ##GVLB = PREFIX + 'GVLIB'
      * Job name
     C                   eval      ##GVJB = UPGVJN + '/' + %trimr(UPUSER) +
     C                             '/' + ##GVLB
      * Number of files
     C                   eval      ##GVTF = %char(UPGVNF)
     C                   eval      V_TOTF = V_TOTF + UPGVNF
      * Number of files in ref system
     C                   eval      ##GVTR = %char(UPGVNR)
      * Time started
     C                   eval      ##GVST = %subst(UPGVSB:1:2) + ':' +
     C                             %subst(UPGVSB:3:2) + ':' +
     C                             %subst(UPGVSB:5:2) + ':'
      * Time ended
     C                   eval      ##GVED = %subst(UPGVED:1:2) + ':' +
     C                             %subst(UPGVED:3:2) + ':' +
     C                             %subst(UPGVED:5:2) + ':'
      * Run Time
     C                   if        UPGVED <> *BLANKS
     C                   eval      ##HST = %TIME(##GVST:*HMS)
     C                   eval      ##HET = %TIME(##GVED:*HMS)
     C                   EVAL      WkTime = %DIFF(##HET:##HST:*SECONDS)
     C                   EVAL      ##GVRT = TIME0 + %SECONDS(WkTime)
     C                   endif
      * Status
     C                   If        UPGVSS = 'A'
     C                   eval      ##GVSS = 'Completed Abnormally'
     C                   seton                                        36
     C                   Else
     C                   If        UPGVED <> *blanks
     C                   eval      ##GVSS = 'Completed Normally'
     C                   seton                                        37
     C                   Else
     C                   eval      ##GVSS = 'Running...'
     C                   ENDIF
     C                   ENDIF

      * Set header values
      * Total files to compare
     C                   If        UPCMSS = 'C'
     C                   eval      ##OTTC = %CHAR(V_TOTF)
     C                   setoff                                       50
     C                   else
     C                   If        UPGMNF = 0 or UPGPNF = 0  or +
     C                             UPGTNF = 0  or UPGVNF = 0
     C                   eval      ##OTCN = 'Determining...'
     C                   seton                                        50
     C                   else
     C                   eval      ##OTTC = %CHAR(V_TOTF)
     C                   setoff                                       50
     C                   ENDIF
     C                   ENDIF

      * Compare Status
     C                   If        UPCMSS = 'I'
     C                   eval      ##CMSS = 'Initialing...'
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
     C                   eval      ##RPSS = 'Initialing...'
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
     C                   PARM      'UPGADBCDTQ'  ObjName
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
