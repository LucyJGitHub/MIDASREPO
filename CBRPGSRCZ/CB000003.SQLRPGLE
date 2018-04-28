     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas CB Close of business monitor menu')
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Processing                         *
      *                                                               *
      *  CB000003 - Close of Business Monitor Menu                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. AR1096378          Date 15Mar12               *
      *  Prev Amend No. CCB021  *CREATE    Date 06Aug12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  AR1096378 - NWDC Issues encountered during link test         *
      *  CCB021 - COB Restructure - Non Working Day COB               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *    01        Display Menu Controlling Indicator               *
      *    06        Command Key 6 for End NWDC processing            *
      *    12        Command Key 12 for End NWDC processing           *
      *    31        Display Menu Option 1                            *
      *    32        Display Menu Option 3                            *
      *    33        Display Menu Option 2                            *
      *    34        Display Menu Option 8                            *
      *    35        Display Menu Option 10                           *
      *    37        Display Menu Option 9                            *
      *    38        Display Menu Option 99                           *
      *    49        Display Menu Option 12 End NWDC processing       *
      *    50        Fail on read of CB0015DF                         *
      *    60        Invalid option entered                           *
      *    65        Allow use of F6/F12 to End NWDC processing       *
      *    70        Protect screen if Confirm/Cancel displayed       *
      *    78        Error on Lock of Dataarea MPHAS                  *
      *    79        Error on Lock of Dataarea CBSTAT                 *
      *                                                               *
      *    LR        Last Record Indicator                            *
      *                                                               *
      *    U1        Screen Timed Out                                 *
      *    U7&U8     Database Error                                   *
      *                                                               *
      *****************************************************************
     FCB0015DF  CF   E             WORKSTN
     F                                     MAXDEV(*FILE)
 
     D SCRMSG          S             78    DIM(3) CTDATA PERRCD(1)
 
      ** Screen Message Array
 
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
 
      ** Local Data Area
 
     D CBSTAT          DS            50
     D  CBFAIL                14     16  0
     D  NOAS                  18     19  0
     D  HALTST                20     20
     D  SCHEDT                21     25  0
     D  SCHETI                26     31  0
     D  REOPFL                32     32
     D  COBSTS                45     45
 
      ** CBSTAT Data Area
 
     D MPHAS           DS             1
     D  PHASE                  1      1
 
      ** MPHAS  Data Area
 
     D ERARR           DS
     D  OPTERR                 1     78
     D                                     DIM(1) CTDATA PERRCD(1)
     D  OPTION                 8      8
 
      ** Set up error option number for array OPTERR
 
     D QCMD            DS
     D  QCMD1                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  QCMD2                 81     93
     D                                     DIM(1) CTDATA PERRCD(1)
 
      ** Data Structure to set up QCMDEXC command
 
     D SCTIM           DS
     D  SCTIME                 1      6  0
     D  SCHRS                  1      2  0
     D  SCMIN                  3      4  0
     D  SCSEC                  5      6  0
 
      ** Data structure to split system time into HRS, MINS & SECS
 
     D DPTIME          DS
     D  DPHRS                  1      2
     D  DPHRSA                 1      1
     D  COLON1                 3      3
     D  DPMIN                  4      5
     D  COLON2                 6      6
     D  DPSEC                  7      8
 
      ** Data structure to convert system time for display (HH:MM:SS)
 
     D PSDS           SDS
     D  PGMSTS           *STATUS
     D  WSID                 244    253
     D  USRID                254    263
 
      ** Data Structure for workstation ID for screen output
 
     D SDCOBP        E DS                  EXTNAME(SDCOBPPD)
 
      ** External Data structure for access object SDCOBPPD format
 
     DDSSDY          E DS                  EXTNAME(DSSDY)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D SDBANK        E DS                  EXTNAME(SDSBNKTD)
 
      ** External data structure for access object format
 
     D UniqueID        S             10
     D ReturnCode      S              7
     D AOOption        S              7
     D FROM            S              1
     D PARTCD          S              1
     D PAOPTN          S              1
     D DAYNOA          S              5
     D STIME           S              6
     D DFMT            S              1
     D DWF             S              5  0
     D TWF             S              6  0
     D SWWF            S              1
     D WSLCT           S              1
     D WSLCT2          S              1
     D PROG            S             10
     D ERROR           S              1
     D PARM            S              1
     D LEN             S             15  5
     D PGMPARM         S              8                                                    AR1096378
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Retrieve banks run date from SDSBNKTD
 
     C/EXEC SQL
     C+ select * into :SDBANK from SDSBNKTD
     C/END-EXEC
 
      ** If error found by access object exit
      ** program via database error subroutine
 
     C                   IF        SQLCODE <> 0
     C                   MOVEL     'SQLSDBNK'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   EXSR      DBERR
     C                   ENDIF
 
     C                   EVAL      RUNA = BJMRDT
 
      ** Call access object AOCOBPR0 to access COB icd file
 
     C                   CALL      'AOCOBPR0'
     C                   PARM      '*MSG   '     PARTCD
     C                   PARM      '*FIRST '     PAOPTN
     C     SDCOBP        PARM      SDCOBP        DSFDY
 
     C                   IF        PARTCD = *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'AOCOB'
     C                   EVAL      DBKEY = *BLANKS
     C                   Z-ADD     1             DBASE
     C                   EXSR      DBERR
     C                   ENDIF
 
      ** Do while indicator 01 is off
      ** and screen not timed out
 
     C                   DOW       *IN01 = *OFF
     C                             AND *INU1 <> *ON
 
      ** Set on indicators to display options 1,8 and 9.
 
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN34 = *ON
     C                   EVAL      *IN37 = *ON
 
      ** Define and lock data area CBSTAT
 
     C     *DTAARA       DEFINE                  CBSTAT
     C     *LOCK         IN        CBSTAT                               79
 
     C                   IF        COBSTS = 'R'
     C                   EVAL      FROM = 'R'
     C**********         ELSE                                                              AR1096378
     C**********         EVAL      FROM = 'A'                                              AR1096378
     C                   END
 
      ** Define and lock data area MPHAS
 
     C     *DTAARA       DEFINE                  MPHAS
     C     *LOCK         IN        MPHAS                                78
 
      ** If error occurs on lock of data area CBSTAT or MPHAS
      ** (i.e. it is being locked by another program)
      ** exit program using program status subroutine'
 
     C                   IF        *IN79 = *ON
     C                             OR *IN78 = *ON
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If MPHAS equals 'N' set on indicator 49 to allow
      ** option 12 (End NWDC processing)
 
     C**********         IF        PHASE = 'N'                                             AR1096378
     C**********         EVAL      *IN49 = *ON                                             AR1096378
     C**********         ENDIF                                                             AR1096378
 
      ** If reopen fail indicator (Pos 32) is on set
      ** off indicators displaying options 1,8 and 9
 
     C**********         IF        REOPFL = 'Y'                                            AR1096378
     C**********         EVAL      *IN31 = *OFF                                            AR1096378
     C**********         EVAL      *IN34 = *OFF                                            AR1096378
     C**********         EVAL      *IN37 = *OFF                                            AR1096378
 
     C**********         ELSE                                                              AR1096378
 
      ** If close of business run has halted (CBSTAT pos
      ** 20 = Y) set indicator to display option 2
 
     C                   IF        HALTST = 'Y'
     C                   EVAL      *IN33 = *ON
     C                   ENDIF
 
     C**********         ENDIF                                                             AR1096378
 
      ** Allow user to signoff                                                             AR1096378
                                                                                           AR1096378
     C                   EVAL      *IN38 = *ON                                             AR1096378
                                                                                           AR1096378
      ** If components have failed (CBSTAT pos 14-16 not zero)
      ** and attempt to reopen input cycle has not failed
      ** set indicator to display option 3
 
     C                   IF        CBFAIL > 0
     C**********                   AND REOPFL <> 'Y'                                       AR1096378
     C                   EVAL      *IN32 = *ON
     C                   ENDIF
 
      ** If command entry flag (from SDCOBPL0) = Y and
      ** error count (CBSTAT pos 14-16) is greater than 0
 
     C                   IF        DOAQCM = 'Y'
     C                             AND CBFAIL > 0
     C                   EVAL      *IN35 = *ON
     C                   ENDIF
 
     C                   CALL      'CBTIME'
     C                   PARM                    DAYNOA
     C                   PARM                    STIME
     C                   PARM                    DFMT
 
      ** Move day no from CBTIME to date work field(DWF)
      ** and time(HHMM) to time work field(TWF)
      ** having subtracted 1 minute
 
     C                   MOVE      DAYNOA        DWF
     C                   MOVE      STIME         SCTIME
     C     SCTIME        SUB       100           TWF
 
      ** If close of business run has halted (pos 20 = Y)
      ** or last scheduled date CBSTAT pos 21-25 is not zero and
      ** is less than the system date and the number of
      ** active STREAMS = 0
      ** or last scheduled date CBSTAT pos 21-25 is not zero and
      ** is equal to the system date and the last scheduled
      ** time CBSTAT pos 26-31 is less than the system time
      ** minus 1 minute and no of active STREAMS = 0
 
     C                   IF        HALTST = 'Y'
     C                             OR SCHEDT < DWF
     C                             AND SCHEDT <> 0
     C                             AND NOAS = 0
     C                             OR SCHEDT = DWF
     C                             AND SCHETI < TWF
     C                             AND SCHEDT <> 0
     C                             AND NOAS = 0
 
      ** Set on indicator to display option 99
 
     C                   EVAL      *IN38 = *ON
 
      ** If MPHAS equals 'N' set on indicator 49 to allow
      ** option 12 (End NWDC processing)
 
     C                   IF        PHASE = 'N'
     C                   EVAL      *IN49 = *ON
     C                   ENDIF
 
      ** Set up switch work field depending on whether close
      ** of business run has halted (CBSTAT pos 20 = Y)
 
     C                   IF        HALTST = 'Y'
     C                   EVAL      SWWF = 'H'
     C                   ELSE
     C                   EVAL      SWWF = 'R'
     C                   ENDIF
 
     C                   END
 
      ** Unlock data area CBSTAT
 
     C                   OUT       CBSTAT
 
      ** If program called from secondary screen
      ** set indicators to display option 11
      ** and non display options 9 & 12
 
     C**********         IF        FROM = 'B'                                              AR1096378
     C**********         EVAL      *IN38 = *ON                                             AR1096378
     C**********         EVAL      *IN37 = *OFF                                            AR1096378
     C**********         EVAL      *IN49 = *OFF                                            AR1096378
     C**********         ENDIF                                                             AR1096378
 
      ** If program called as restart display screen
      ** set indicators to display option 12
      ** and non display option 9 whilst there are
      ** failed components which require restarting
 
     C                   IF        FROM = 'R'
     C                             AND *IN32 = '1'
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN49 = *ON
 
      ** Else if program called as restart display screen
      ** and there are no failed components to restart
      ** set indicators to non display options 12
      ** and display option 9
 
     C                   ELSE
     C                   IF        FROM = 'R'
     C                             AND *IN32 = '0'
     C**********                   AND REOPFL <> 'Y'                                       AR1096378
 
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN49 = *OFF
 
      ** If restart after halt option displayed
      ** ensure return to monitor option(9) is not displayed
 
     C                   IF        *IN33 = *OFF
     C                   EVAL      *IN37 = *ON
     C                   ELSE
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up current time for display on screen
 
     C                   EVAL      COLON1 = ':'
     C                   EVAL      COLON2 = ':'
     C                   MOVE      SCHRS         DPHRS
     C                   MOVE      SCMIN         DPMIN
     C                   MOVE      SCSEC         DPSEC
 
     C                   IF        DPHRSA = '0'
     C                   EVAL      DPHRSA = *BLANKS
     C                   ENDIF
 
     C                   EVAL      SCCURT = DPTIME
 
      ** Write header and selection formats
 
     C                   WRITE     CB0015F0
     C                   WRITE     CB0015F1
     C                   READ      CB0015DF                             U150
 
      ** If screen has not been timed out
 
     C                   IF        *INU1 <> '1'
 
      ** Set off screen error indicator
 
     C                   EVAL      *IN60 = *OFF
 
      ** Left justify the option taken(select field)
 
     C                   MOVEL     SELECT        WSLCT
     C                   MOVE      SELECT        WSLCT2
     C                   IF        WSLCT = ' '
     C                   EVAL      SELECT = *BLANKS
     C                   MOVEL     WSLCT2        SELECT
     C                   MOVE      *BLANKS       WSLCT2
     C                   ENDIF
 
      ** If option taken is invalid then set on
      ** error indicator and write error message
 
     C                   IF        SELECT = '1'
     C                             AND *IN31 = '0'
     C                             OR SELECT = '2'
     C                             AND *IN33 = '0'
     C                             OR SELECT = '3'
     C                             AND *IN32 = '0'
     C                             OR SELECT = '12'
     C                             AND *IN49 = '0'
     C                             OR SELECT = '8'
     C                             AND *IN34 = '0'
     C                             OR SELECT = '9'
     C                             AND *IN37 = '0'
     C                             OR SELECT = '10'
     C                             AND *IN35 = '0'
     C                             OR SELECT = '99'
     C                             AND *IN38 = '0'
     C                             OR SELECT < '1'
     C                             OR SELECT > '12'
 
     C                             AND SELECT < '99'
     C                             AND WSLCT2 <> *BLANKS
     C                             OR WSLCT2 < '0'
     C                             AND WSLCT2 <> *BLANKS
 
     C                   EVAL      *IN60 = *ON
     C                   EVAL      OPTION = SELECT
     C                   MOVE      SCRMSG(1)     ERRMSG
 
      ** Else call program requested from menu
 
     C                   ELSE
 
      ** Release MPHAS
 
     C                   OUT       MPHAS                                99
 
      ** If value = 1 call halt menu program CB0020
 
     C                   IF        SELECT = '1'
     C                   CALL      'CBC0026'
     C                   PARM      'CB0020'      PROG
     C                   PARM                    ERROR
     C                   ENDIF
 
      ** If value = 3 call restart failed components program CB0065
 
     C                   IF        SELECT = '3'
     C                   CALL      'CBC0026'
     C                   PARM      'CB0065'      PROG
     C                   PARM                    ERROR
     C                   ENDIF
 
      ** If value = 2 call restart after halt program CBC0070
 
     C                   IF        SELECT = '2'
     C                   CALL      'CBC0026'
     C                   PARM      'CBC0070'     PROG
     C                   PARM                    ERROR
     C                   ENDIF
 
      ** If value = 8 call close of business enquiry program CBC0060
 
     C                   IF        SELECT = '8'
     C                   CALL      'CBC0026'
     C                   PARM      'CB0060'      PROG
     C                   PARM                    ERROR
     C                   ENDIF
 
      ** If value = 10 display command entry screen
 
     C                   IF        SELECT = '10'
     C                   CALL      'QCMD'
     C                   ENDIF
 
      ** If value = 12 End NWDC processing
 
     C                   IF        SELECT = '12'
 
      ** Set message field and allow
      ** use of keys F6 and F12
 
     C                   MOVE      SCRMSG(2)     ERRMSG
     C                   EVAL      *IN60 = *ON
     C                   EVAL      *IN65 = *ON
     C                   EVAL      *IN70 = *ON
 
      ** Write selection format (CB0015F1) to screen
 
     C                   WRITE     CB0015F1
 
      ** Do while command keys F6 and F12
      ** not pressed, screen not timed out
 
     C                   DOW       *IN06 = '0'
     C                             AND *IN12 = '0'
     C                             AND *INU1 = '0'
 
      ** Re-write selection format (CB0015F1) to screen if neither F6
      ** nor F12 was chosen
 
     C                   WRITE     CB0015F1
 
     C                   READ      CB0015DF                             U150
 
     C                   ENDDO
     C                   EVAL      *IN70 = *OFF
 
      ** If key F6 pressed and screen not timed out
 
     C                   IF        *IN06 = '1'
     C                             AND *INU1 = '0'
 
      ** Call CBC0028 to setup MSGQ/MSPECIAL and to reopen input cycle.
      ** Release the lock on the SFMENU* files so that the database can
      ** be restored.
 
     C                   Eval      AOOption = '*FREE'
 
     C                   CALL      'AOMENUR0'
     C                   PARM                    ReturnCode
     C                   PARM                    AOOption
     C                   PARM                    UniqueID
     C                   PARM                    DSSDY
 
     C**********         CALL      'CBC0028'                                               AR1096378
     C                   EVAL      PGMPARM = 'SCC0700'                                     AR1096378
     C                   CALL      'SCMINIT'                                               AR1096378
     C                   PARM                    PGMPARM                                   AR1096378
 
      ** If SCMINIT fails to reopen input cycle
      ** (i.e. CBSTAT pos 32 is still = 'Y')
      ** deactivate command keys F6 and F12,
      ** and write error message
 
     C                   DOU       *IN79 = '0'
     C     *LOCK         IN        CBSTAT                               79
     C                   ENDDO
 
     C                   IF        REOPFL = 'Y'
     C                   EVAL      *IN65 = *OFF
     C                   MOVE      SELECT        OPTION
     C                   MOVE      OPTERR(1)     ERRMSG
     C                   ENDIF
 
     C                   ELSE
 
      ** Else if command key 12 pressed to cancel request
      ** to reopen input cycle then clear message
 
     C                   IF        *IN12 = '1'
     C                   EVAL      *IN60 = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** If value = 9 return to main close of business monitor
 
     C                   IF        SELECT = '9'
     C                   EVAL      *IN01 = *ON
     C                   ENDIF
 
      ** If value = 99 call program CBC0027 to sign off
 
     C                   IF        SELECT = '99'
 
      ** If program called from secondary screen
      ** sign off with parameter 'B'
 
     C**********         IF        FROM = 'B'                                              AR1096378
     C**********         CALL      'CBC0027'                                               AR1096378
     C**********         PARM      'B'           PARM                                      AR1096378
 
      ** If called from main monitor set parameter
      ** depending on halt status to
      ** cancel scheduler and sign off
 
     C**********         ELSE                                                              AR1096378
 
     C                   IF        SWWF = 'H'
 
     C                   CALL      'CBC0027'
     C                   PARM      'H'           PARM
     C                   ELSE
 
     C                   CALL      'CBC0027'
     C                   PARM      'R'           PARM
     C                   ENDIF
 
     C**********         ENDIF                                                             AR1096378
 
      ** Set on error indicator and write error message since
      ** if program reaches this point CBC0027 has failed
 
     C                   EVAL      *IN60 = *ON
     C                   EVAL      OPTION = SELECT
     C                   MOVE      OPTERR(1)     ERRMSG
     C                   ENDIF
 
      ** If error parameter passed back from CBC0026
      ** is 'Y' set on error indicator and set up error
      ** message as 'Option X ended in error'
 
     C                   IF        ERROR = 'Y'
     C                   EVAL      *IN60 = *ON
     C                   EVAL      OPTION = SELECT
     C                   MOVE      OPTERR(1)     ERRMSG
     C                   ENDIF
 
      ** If error parameter passed back from CBC0026
      ** is 'T' set on screen timed out indicator
 
     C                   IF        ERROR = 'T'
     C                   EVAL      *INU1 = *ON
     C                   ENDIF
 
      ** If valid option taken clear screen input field
 
     C                   IF        ERROR <> 'Y'
     C                             AND ERROR <> 'T'
     C                   EVAL      SELECT = *BLANKS
     C                   WRITE     CB0015F2
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN33 = *OFF
     C                   EVAL      *IN35 = *OFF
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN49 = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C/EJECT
      *****************************************************************
      * *PSSR - Program status subroutine                             *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        PGMSTS = 00432
 
     C                   Z-ADD     93            LEN
     C                   CALL      'QCMDEXC'
     C                   PARM                    QCMD
     C                   PARM                    LEN
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      * DBERR - SR. to perform database error exit from program       *
      *****************************************************************
 
     C     DBERR         BEGSR
 
      ** Seton indicators U7 U8 LR and return to calling program
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   OUT       LDA
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
**CTDATA SCRMSG
ENTRY Must be a valid option number
PRESS F6 to confirm or F12 to cancel request to end NWDC processing
USER Not defined/authorised to the system
**CTDATA OPTERR
OPTION   Ended in error
**CTDATA QCMD1
SNDMSG MSG('Temporarily unable to access C.O.B. Control Menu - Please re-try') T
**CTDATA QCMD2
OMSGQ(MOPERQ)
