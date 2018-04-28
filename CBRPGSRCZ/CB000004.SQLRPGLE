     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas CB Close of business monitor')
      *****************************************************************
      *                                                               *
      *  Midas - Close of Business Processing                         *
      *                                                               *
      *  CB000004 - NWDC Close of business monitor                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CCB021  *CREATE    Date 06Aug12               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CCB021 - COB Restructure - Non Working Day COB               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *    01        Display Stream 01 Info                           *
      *    02        Display Stream 02 Info                           *
      *    03        Display Stream 03 Info                           *
      *    04        Display Stream 04 Info                           *
      *    05        Display Stream 05 Info                           *
      *    06        Display Stream 06 Info                           *
      *    07        Display Stream 07 Info                           *
      *    08        Display Stream 08 Info                           *
      *    09        Display Stream 09 Info                           *
      *    20        Error on WRITE to Workstation                    *
      *    21        EOF on DSPF/CBMONDF                              *
      *    50        Display Number of Failed Components              *
      *    70        Re-try lock of Data Area                         *
      *                                                               *
      *    LR        Last Record Indicator                            *
      *                                                               *
      *    U7&U8     Database Error                                   *
      *                                                               *
      *****************************************************************
     FCBMONDF   CF   E             WORKSTN
 
     D ST              S              1    DIM(10)
 
      ** First Data Structure for access object, short data structure
 
     D  DSFDY        E DS                  EXTNAME(DSFDY)
 
      ** External Data Structure for access object format
 
     D SDBANK        E DS                  EXTNAME(SDSBNKTD)
 
      ** Convert Time into 'NICE' Display (HH:MM:SS)
 
     DNICTIM           DS
     D NICHR                   1      2
     D NICHRP                  1      2  0
     D COLON1                  3      3
     D NICMI                   4      5
     D NICMIP                  4      5  0
     D COLON2                  6      6
     D NICSE                   7      8
     D NICSEP                  7      8  0
 
      ** Split Message From DTAQ/CBDTQD Into Seperate Fields
 
     DDQMSG            DS
     D CCOT                    1     10
     D CTXT                   11     70
     D CBSM                   71     78
     D STREAM                 79     86
     D STRNO                  85     86  0
     D STRNOA                 85     86
     D SCINFO                  1     70
 
      ** Data Structure to split current time into hours, minutes
      ** and seconds
 
     DCURFLD           DS
     D CURHR                   1      2  0
     D CURMI                   3      4  0
     D CURSE                   5      6  0
 
      ** Data Structure to split cob start time into hours, minutes
      ** and seconds
 
     DCOBFLD           DS
     D COBHR                   1      2  0
     D COBMI                   3      4  0
     D COBSE                   5      6  0
 
      ** Data Structure to hold components already ran & total to run
 
     DCBRUN            DS             6
     D TOTAL                   1      3P 0
     D RUN                     4      6P 0
 
      ** Read required fields off of DTAARA/CBSTAT
 
     DCBSTAT           DS            50
     D CBFAIL                 14     16  0
     D CBSCHS                 17     17
     D CBCURA                 18     19  0
     D CBSTDT                 33     37  0
     D CBSTTI                 38     43  0
 
      ** Local Data Area
 
     DLDA              DS           256
     D DBFILE                134    141
     D DBKEY                 142    170
     D DBPGM                 171    180
     D DBASE                 181    183  0
 
      ** Data Structure for workstation ID for Screen Output
 
     DPSDS            SDS
     D USRID                 254    263
 
      ** Variable Declaration
 
     D SCWSID          S             10
     D MAXA            S              2
 
     D CNT             S              2  0
     D SCMAXA          S              2  0
 
     D CURRDT          S              5  0
     D PRTCD           S              7
     D POPTN           S              7
 
     D STDT            S              5  0
     D STTI            S              6  0
 
     D DAYS            S              2  0
     D HOURS           S              2  0
     D TOTHRS          S              2  0
     D TOTSEC          S              6  0
     D SECS            S              6  0
     D ENDSEC          S              6  0
     D ESECS           S              6  0
     D DIFSEC          S              6  0
     D MINREM          S              4  0
     D DAYNOA          S              5
     D STIME           S              6
     D DFMT            S              1
 
     C     *ENTRY        PLIST
     C                   PARM                    SCWSID
     C                   PARM                    DQMSG
     C                   PARM                    MAXA
 
      ** Declare dataareas user in Program.
 
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  CBSTAT
     C     *DTAARA       DEFINE                  CBRUN
 
      ** Initialise work fields for screen display
 
     C                   MOVE      ':'           COLON1
     C                   MOVE      ':'           COLON2
 
      ** Write Positions 1-78 of DQMSG to PF/CBMESGPD.
 
     C                   IF        CBSM <> 'REFRESH '
     C/EXEC SQL
     C+ insert into CBMESGPD (CCOT,CTXT,CBSM) values(:CCOT,:CTXT,:CBSM)
     C/END-EXEC
     C                   IF        SQLCODE <> 0
     C                   EXSR      DBERR
     C                   ENDIF
     C                   ENDIF
 
      ** Check the status type of the message.
 
     C                   IF        CBSM = 'STARTED '
     C     *IN70         DOUEQ     '0'
     C     *LOCK         IN        CBSTAT                               70
     C                   ENDDO
 
      ** Task split jobs not shown on the screen. therefore do not
      ** update current no. of active stream jobs screen field
 
     C                   IF        STRNOA <> 'XX'
     C                   ADD       1             CBCURA
     C                   ENDIF
     C                   OUT       CBSTAT
     C                   ENDIF
 
     C                   IF        CBSM = 'COMPLETE'
     C                   MOVE      *BLANKS       CTXT
     C                   MOVE      *BLANKS       CCOT
     C     *IN70         DOUEQ     '0'
     C     *LOCK         IN        CBSTAT                               70
     C                   ENDDO
 
      ** Task split jobs not shown on the screen. therefore do not
      ** update current no. of active stream jobs screen field
 
     C                   IF        STRNOA <> 'XX'
     C                   SUB       1             CBCURA
     C                   ENDIF
     C                   OUT       CBSTAT
     C     *LOCK         IN        CBRUN
     C                   ADD       1             RUN
     C                   OUT       CBRUN
     C                   ENDIF
 
     C                   IF        CBSM = 'FAILED  '
     C                   MOVE      *BLANKS       CTXT
     C                   MOVE      *BLANKS       CCOT
     C     *IN70         DOUEQ     '0'
     C     *LOCK         IN        CBSTAT                               70
     C                   ENDDO
 
      ** Task split jobs not shown on the screen. therefore do not
      ** update current no. of active stream jobs screen field
 
     C                   IF        STRNOA <> 'XX'
     C                   SUB       1             CBCURA
     C                   ENDIF
     C                   ADD       1             CBFAIL
     C                   OUT       CBSTAT
     C                   ENDIF
 
     C                   IF        CBSM = 'END     '
     C     *IN70         DOUEQ     '0'
     C     *LOCK         IN        CBSTAT                               70
     C                   ENDDO
     C                   MOVE      'N'           CBSCHS
     C                   OUT       CBSTAT
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
      ** If halted or restarted access CBSTAT
      ** to obtain release level for later use
 
     C                   IF        CBSM = 'HALTED  ' OR CBSM = 'RESTART '
     C     *IN70         DOUEQ     '0'
     C     *LOCK         IN        CBSTAT                               70
     C                   ENDDO
     C                   OUT       CBSTAT
     C                   ENDIF
 
     C     CBSM          IFEQ      'ERROR   '
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
      ** If status not recognised then database error.
 
     C                   IF        CBSM <> 'STARTED ' AND CBSM <> 'COMPLETE' AND
     C                             CBSM <> 'FAILED  ' AND CBSM <> 'HALTED  ' AND
     C                             CBSM <> 'RESTART ' AND CBSM <> 'END     ' AND
     C                             CBSM <> 'REFRESH '
 
     C     *LOCK         IN        LDA
     C                   MOVEL     'DTQD '       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     CBSM          DBKEY
     C                   Z-ADD     1             DBASE
     C                   EXSR      DBERR
     C                   ENDIF
 
      ** Use maxas field to determine how many streams to show
      ** when displaying the monitor.
 
     C                   Z-ADD     1             CNT
     C                   MOVE      MAXA          SCMAXA
     C                   SUB       1             SCMAXA
     C     CNT           DOWLE     SCMAXA
     C                   MOVE      '1'           ST(CNT)
     C                   ADD       1             CNT
     C                   ENDDO
     C                   ADD       1             SCMAXA
 
      ** Set on the appropraite display file indicators.
 
     C                   MOVEA     ST            *IN(01)
 
      ** Set Current date and time fields
      ** with values from CBTIME
 
     C                   CALL      'CBTIME'
     C                   PARM                    DAYNOA
     C                   PARM                    STIME
     C                   PARM                    DFMT
 
     C                   MOVE      DAYNOA        CURRDT
     C                   MOVE      STIME         CURFLD
 
      ** Retrieve banks run date
 
     C/EXEC SQL
     C+ select * into :SDBANK from SDSBNKTD
     C/END-EXEC
 
      ** If error found by access object exit
      ** program via database error subroutine
 
     C                   IF        SQLCODE <> 0 AND SQLCODE <> 100
     C                   MOVEL     'SQLSDBNK'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   EXSR      DBERR
     C                   ELSE
     C                   EVAL      RUNA = BJMRDT
     C                   ENDIF
 
      ** Move required fields from DTAARA/CBSTAT into work fields.
 
     C     *IN70         DOUEQ     '0'
     C     *LOCK         IN        CBSTAT                               70
     C                   ENDDO
     C                   Z-ADD     CBSTDT        STDT
     C                   Z-ADD     CBSTTI        STTI
     C                   Z-ADD     CBFAIL        SCFAIL
     C                   Z-ADD     CBCURA        SCCURA
     C                   OUT       CBSTAT
 
      ** Improve display of current time.
 
     C                   MOVE      CURHR         NICHR
     C                   MOVE      CURMI         NICMI
     C                   MOVE      CURSE         NICSE
     C                   MOVE      NICTIM        SCCURT
 
      ** Improve display of COB start time.
 
     C                   MOVE      STTI          COBFLD
     C                   MOVE      COBHR         NICHR
     C                   MOVE      COBMI         NICMI
     C                   MOVE      COBSE         NICSE
     C                   MOVE      NICTIM        SCSTTI
 
      ** Evaluate elapsed time between start of COB and current time.
 
     C                   EXSR      TIMCAL
     C                   MOVE      NICTIM        SCELTI
 
      ** If all failed components have been restarted then do
      ** not display the corresponding line on the display file.
 
     C                   IF        SCFAIL <= 0
     C                   SETON                                        50
     C                   ELSE
     C                   SETOFF                                       50
     C                   ENDIF
 
      ** Update the info on the stream line refered to by the message.
      ** do not update if this is a task split job. these jobs
      ** are not shown on the monitor.
 
     C                   IF        STREAM <> *BLANKS AND STRNOA <> 'XX'
 
     C                   IF        STRNO = 0
     C                   MOVE      SCINFO        SCSTR0
     C                   ENDIF
 
     C                   IF        STRNO = 1
     C                   MOVE      SCINFO        SCSTR1
     C                   ENDIF
 
     C                   IF        STRNO = 2
     C                   MOVE      SCINFO        SCSTR2
     C                   ENDIF
 
     C                   IF        STRNO = 3
     C                   MOVE      SCINFO        SCSTR3
     C                   ENDIF
 
     C                   IF        STRNO = 4
     C                   MOVE      SCINFO        SCSTR4
     C                   ENDIF
 
     C                   IF        STRNO = 5
     C                   MOVE      SCINFO        SCSTR5
     C                   ENDIF
 
     C                   IF        STRNO = 6
     C                   MOVE      SCINFO        SCSTR6
     C                   ENDIF
 
     C                   IF        STRNO = 7
     C                   MOVE      SCINFO        SCSTR7
     C                   ENDIF
 
     C                   IF        STRNO = 8
     C                   MOVE      SCINFO        SCSTR8
     C                   ENDIF
 
     C                   IF        STRNO = 9
     C                   MOVE      SCINFO        SCSTR9
     C                   ENDIF
 
      ** If no stream update takes place - Database Error.
 
     C                   IF        STRNO < 0 OR STRNO > SCMAXA
 
     C     *LOCK         IN        LDA
     C                   MOVEL     'DTQD '       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     STRNO         DBKEY
     C                   Z-ADD     3             DBASE
     C                   EXSR      DBERR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IN        CBRUN
 
      ** Adjust totals for COBBEGIN and COBEND, so that correct no. of
      ** components run/to be run is displayed on the screen
 
     C                   SUB       1             RUN
     C                   SUB       2             TOTAL
     C                   MOVE      RUN           SCRANA
     C     RUN           SUB       TOTAL         SCRUNA
 
      ** Display the monitor.
 
     C                   WRITE     CBMONF0                              20
 
      ** If return has been pressed - perform read to stop crash
 
     C                   IF        *IN20 = '1'
     C                   SETOFF                                       20
     C                   READ      CBMONF0                                21
     C                   WRITE     CBMONF0
     C                   ENDIF
 
      ** Return from program without setting on LR.
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * TIMCAL - Calculate the elapsed time of COB so far.            *
      *****************************************************************
 
     C     TIMCAL        BEGSR
 
      ** Subtract COB start date from current date
      ** to give number of days so far taken by COB.
 
     C     CURRDT        SUB       STDT          DAYS
 
      ** Convert days taken into hours taken.
 
     C     DAYS          MULT      24            HOURS
 
      ** Add hours taken to current number of hours
      ** to give total end hours field.
 
     C     HOURS         ADD       CURHR         TOTHRS
 
      ** Move COB number of seconds into total seconds field.
 
     C                   Z-ADD     COBSE         TOTSEC
 
      ** Convert COB start number of minutes into seconds
      ** and add to total seconds field.
 
     C     COBMI         MULT      60            SECS
 
     C                   ADD       SECS          TOTSEC
 
      ** convert COB start number of hours into seconds
      ** and add to total seconds field.
 
     C     COBHR         MULT      3600          SECS
 
     C                   ADD       SECS          TOTSEC
 
      ** Move current number of seconds into total end seconds
      ** work field.
 
     C                   Z-ADD     CURSE         ENDSEC
 
      ** Convert current number of minutes into seconds
      ** and add to total end seconds field.
 
     C     CURMI         MULT      60            ESECS
 
     C                   ADD       ESECS         ENDSEC
 
      ** Convert total number of hours into seconds
      ** and add to total end seconds field.
 
     C     TOTHRS        MULT      3600          ESECS
 
     C                   ADD       ESECS         ENDSEC
 
      ** Subtract total COB start seconds from total
      ** end seconds to obtain run time in seconds.
 
     C     ENDSEC        SUB       TOTSEC        DIFSEC
 
      ** Convert run time into hours, minutes
      ** and seconds fields for report.
 
     C     DIFSEC        DIV       3600          NICHRP
 
     C                   MVR                     MINREM
 
     C     MINREM        DIV       60            NICMIP
 
     C                   MVR                     NICSEP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/EJECT
      *****************************************************************
      * DBERR - To Perform DATABASE ERROR and Exit from Program       *
      *****************************************************************
 
     C     DBERR         BEGSR
 
      ** Seton indicators U7 U8 LR and RETURN to Calling program.
 
     C                   MOVEL     'CBMON '      DBPGM
     C                   SETON                                        U7U8LR
     C                   OUT       LDA
     C                   RETURN
 
     C                   ENDSR
 
