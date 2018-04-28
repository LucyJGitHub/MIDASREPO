     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Audit User Input Enquiry')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUUIEQ - Audit User Input Enquiry                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. BUG3420            Date 28Jun04               *
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3420 - Audit reporting can't handle system date format MDY*
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPAUUIEQDFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(SUBFLREC:SUBF_RRN)
     FGPAUUIPD  IF   E           K DISK    INFSR(*PSSR)
 
 
     D                 DS
     D  DDMMYY                 1      6
     D  DD                     1      2  0
     D  MM                     3      4  0
     D  YY                     5      6  0
 
 
     D MON             S              3    DIM(12) CTDATA PERRCD(12)
     D #_INF           S             70    DIM(5)  CTDATA PERRCD(1)
 
 
     D NumPerPag       C                   CONST(15)
 
 
      ** Array of records in error
     D RIE             S             14    DIM(NumPerPag)
 
 
     DDateTimeSeqn     DS            14
     D AIDATE                  1      6  0
     D AITIME                  7     12  0
     D AISEQN                 13     14  0
 
 
     DPSDS            SDS
     D PSJobName             244    253
     D PSUser                254    263
     D PSJobNo               264    269S 0
 
 
     D                 DS
     D  DDBUFR                 1   1900
     D  DDBF01                 1    100
     D  DDBF02               101    200
     D  DDBF03               201    300
     D  DDBF04               301    400
     D  DDBF05               401    500
     D  DDBF06               501    600
     D  DDBF07               601    700
     D  DDBF08               701    800
     D  DDBF09               801    900
     D  DDBF10               901   1000
     D  DDBF11              1001   1100
     D  DDBF12              1101   1200
     D  DDBF13              1201   1300
     D  DDBF14              1301   1400
     D  DDBF15              1401   1500
     D  DDBF16              1501   1600
     D  DDBF17              1601   1700
     D  DDBF18              1701   1800
     D  DDBF19              1801   1900
 
 
     D                 DS
     D  EFF_DATE               1      6
     D                 DS
     D  SYS_DATE               1      6
     D  SYS_YY                 1      2
     D  SYS_MM                 3      4
     D  SYS_DD                 5      6
 
 
      * Display subfile screen until F3 taken
 
     C     *INKC         DOWEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END
 
      * End of program
 
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * Display subfile screen
      *****************************************************************
     C     DSPLAY_SCN    BEGSR
 
      * Fill current subfile page
 
     C     *IN05         IFEQ      '1'
     C     *IN06         OREQ      '1'
     C     SUBF_RRN      OREQ      *ZERO
     C     DDDATE        ORNE      DDDATE_P
     C     DDTIME        ORNE      *BLANK
     C     DDJBNO        ORNE      DDJBNO_P
     C     DDRDVL        ORNE      DDRDVL_P
     C     DDZONE        ORNE      DDZONE_P
     C     DDUSER        ORNE      DDUSER_P
     C     DDTTYP        ORNE      DDTTYP_P
     C     DDUPYN        ORNE      DDUPYN_P
     C                   EXSR      FILL_SUBF
     C                   ENDIF
 
     C                   MOVEL     DDDATE        DDDATE_P          6
     C                   MOVEL     *BLANK        DDTIME
     C                   MOVEL     DDJBNO        DDJBNO_P          6
     C                   MOVEL     DDRDVL        DDRDVL_P          1
     C                   MOVEL     DDZONE        DDZONE_P         10
     C                   MOVEL     DDUSER        DDUSER_P         10
     C                   MOVEL     DDTTYP        DDTTYP_P          4
     C                   MOVEL     DDUPYN        DDUPYN_P          1
 
      * Write subfile control and foooter
 
     C                   TIME                    DDMTIM
     C                   WRITE     FOOTER
     C   04              WRITE     NODATA
     C                   WRITE     SUBFLCTL
 
      * Read subfile control
 
     C                   READ      SUBFLCTL                               99    *
     C                   MOVEL     *BLANK        DDMSG
 
      ** If F3 and F12 were not taken
 
     C     *INKC         IFEQ      '0'
     C     *INKL         ANDEQ     '0'
 
      * Rolldown requested
 
     C     *IN05         CASEQ     '1'           ROLLDOWN
 
      * Rollup requested
 
     C     *IN06         CASEQ     '1'           CONTINUE
 
      * Reselection
 
     C     DDTIME        CASNE     *BLANK        CONTINUE
 
      * Check for a record selected from the subfile
 
     C     *IN04         CASEQ     '0'           CHK_SUBF
     C                   END
 
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Continue
      *****************************************************************
     C     CONTINUE      BEGSR
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Check for a record selected from the subfile
      *****************************************************************
     C     CHK_SUBF      BEGSR
 
     C                   READC     SUBFLREC                               99    *RECORD CHANGED
 
      * Read changed record
 
     C     *IN99         IFEQ      '0'
 
      * If an action code is specified
      *   Enquire on the record in the subfile
 
     C     DDACTN        IFNE      *BLANK
     C                   EXSR      ACTN_CHK
 
     C     ActnOK        IFEQ      'Y'
 
     C                   SELECT
     C     DDACTN        WHENEQ    'E'
     C                   EXSR      ENQ_SflREC
     C     DDACTN        WHENEQ    'W'
     C                   MOVEL     *BLANK        WRKJOB           40
     C                   MOVEL     AIJBNO        Wrk06             6
     C     ' '           SCAN      AIJUSR        WX                2 0    99
     C  N99              Z-ADD     11            WX
     C                   SUB       1             WX
     C                   EVAL      WRKJOB = 'WRKJOB JOB(' + Wrk06 + '/' + AIJUSR
     C                   ADD       19            WX
     C                   EVAL      %subst(WRKJOB:WX:12) = '/' + AIJOBN + ')'
     C                   CALL      'QCMDEXC'                            6565    *
     C                   PARM                    WRKJOB
     C                   PARM      40            #MesLen          15 5
     C   65              MOVEL     #_INF(4)      DDMSG
     C                   OTHER
      * ENDDBG
     C                   MOVEL     'ENDDBG'      ENDDBG            6
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ENDDBG
     C                   PARM      6             #MesLen          15 5
      * ENDSRVJOB
     C                   MOVEL     'ENDSRVJOB'   ENDSRVJOB         9
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    ENDSRVJOB
     C                   PARM      9             #MesLen          15 5
      * STRSVRJOB
     C                   MOVEL     *BLANK        STRSRVJOB        43
     C                   MOVEL     AIJBNO        Wrk06
     C     ' '           SCAN      AIJUSR        WX                       99
     C  N99              Z-ADD     11            WX
     C                   SUB       1             WX
     C                   EVAL      STRSRVJOB = 'STRSRVJOB JOB(' + Wrk06 + '/'
     C                                          + AIJUSR
     C                   ADD       22            WX
     C                   EVAL      %subst(STRSRVJOB:WX:12) = '/' + AIJOBN + ')'
     C                   CALL      'QCMDEXC'                            6565    *
     C                   PARM                    STRSRVJOB
     C                   PARM      43            #MesLen          15 5
     C   65              MOVEL     #_INF(4)      DDMSG
     C  N65              MOVEL     #_INF(5)      DDMSG
     C                   ENDSL
 
      * If a problem, log record in error
 
     C     *IN65         IFEQ      '1'
     C                   Z-ADD     1             @RIE              2 0
     C     *BLANK        LOOKUP    RIE(@RIE)                              99
     C                   MOVEL     DateTimeSeqn  RIE(@RIE)
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      * Return to top of subfile page
 
     C                   Z-ADD     ToP_TIME      AITIME
     C                   Z-ADD     ToP_SEQN      AISEQN
     C                   Z-ADD     *ZERO         SUBF_RRN
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Enquire on the record in the subfile
      ********************************************************************
     C     ENQ_SflREC    BEGSR
 
     C* CLEAR SCREEN
 
     C                   WRITE     CLEAR
 
     C     AIRDVL        IFEQ      'V'
     C                   EVAL      DDBUFR =  AIBUFF
     C                   ELSE
     C                   EVAL      DDBUFR =  AITRID
     C                   ENDIF
 
     C** DO WHILE NOT CK/3 OR CK/12
 
     C                   MOVEL     *BLANK        DDMSG
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
 
     C** OUTPUT DETAILS SCREEN
 
     C                   WRITE     DETAILS
     C                   READ      DETAILS
     C                   ENDDO
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Fill subfile
      *****************************************************************
     C     FILL_SUBF     BEGSR
 
     C     DDDATE        IFEQ      *BLANK
     C                   MOVEL     RunDate       DDDATE
     C                   ENDIF
     C                   MOVEL     DDDATE        SYS_DATE
     C                   EVAL      EFF_DATE = SYS_DD + SYS_MM + SYS_YY
     C                   MOVEL     EFF_DATE      AIDATE
 
     C     DDTIME        IFNE      *BLANK
     C                   MOVEL     DDTIME        AITIME
     C                   Z-ADD     *ZERO         AISEQN
     C                   ELSE
     C     DDDATE        IFNE      DDDATE_P
     C     DDJBNO        ORNE      DDJBNO_P
     C     DDRDVL        ORNE      DDRDVL_P
     C     DDZONE        ORNE      DDZONE_P
     C     DDUSER        ORNE      DDUSER_P
     C     DDTTYP        ORNE      DDTTYP_P
     C     DDUPYN        ORNE      DDUPYN_P
     C                   Z-ADD     *ZERO         AITIME
     C                   Z-ADD     *ZERO         AISEQN
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   Z-ADD     *ZERO         SUBF_RRN
 
      * Write subfile control
 
     C                   WRITE     SUBFLCTL                                     *
 
      * Get first record
 
     C     GPAUUIK       SETLL     GPAUUID0
     C     GPAUUIK_P     READE     GPAUUID0                               99    *
     C                   EXSR      READ4SELECT
 
      * If not end of file
 
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     AITIME        ToP_TIME          6 0
     C                   Z-ADD     AISEQN        ToP_SEQN          2 0
     C                   ELSE
     C                   Z-ADD     *ZERO         ToP_TIME
     C                   Z-ADD     *ZERO         ToP_SEQN
     C                   Z-ADD     *ZERO         AITIME
     C                   Z-ADD     *ZERO         AISEQN
 
      * Else, if end of file
      * Issue message
 
     C     DDMSG         IFEQ      *BLANK
     C                   MOVEL     #_INF(1)      DDMSG
     C                   ENDIF
     C                   ENDIF
 
      * Do while not end of file
 
     C     *IN99         DOWEQ     '0'
 
     C                   ADD       1             SUBF_RRN          4 0    04    *
 
      * In error?
 
     C     DateTimeSeqn  LOOKUP    RIE                                    65
 
      * Date
 
     C                   MOVEL     AIDATE        SYS_DATE
     C                   EVAL      EFF_DATE = SYS_DD + SYS_MM + SYS_YY
     C                   MOVEL     EFF_DATE      AIDATEX
 
      * Buffer
 
     C     AIRDVL        IFEQ      'V'
     C                   EVAL      DDBUFF =  AIBUFF
     C                   ELSE
     C                   EVAL      DDBUFF =  AITRID
     C                   ENDIF
 
      * Write a record to the subfile
 
     C                   WRITE     SUBFLREC
     C     SUBF_RRN      IFEQ      NumPerPag
     C     GPAUUIK_P     READE     GPAUUID0                               99    *
     C                   EXSR      READ4SELECT
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         AITIME
     C                   Z-ADD     *ZERO         AISEQN
     C     DDMSG         IFEQ      *BLANK
     C                   MOVEL     #_INF(1)      DDMSG
     C                   ENDIF
     C                   ELSE
     C                   SETON                                            99    *
     C                   END
     C                   ELSE
     C     GPAUUIK_P     READE     GPAUUID0                               99    *
     C                   EXSR      READ4SELECT
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         AITIME
     C                   Z-ADD     *ZERO         AISEQN
     C     DDMSG         IFEQ      *BLANK
     C                   MOVEL     #_INF(1)      DDMSG
     C                   ENDIF
     C                   END
     C                   END
 
     C                   ENDDO
 
      * Set on subfile control indicators
 
     C     *IN(4)        IFEQ      '1'
     C                   MOVEA     '010'         *IN(1)
     C                   ELSE
     C                   MOVEA     '111'         *IN(1)
     C                   END
 
     C                   MOVEL     *BLANK        RIE
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Rolldown
      ********************************************************************
     C     ROLLDOWN      BEGSR
 
     C                   Z-ADD     *ZERO         SUBF_RRN
     C                   Z-ADD     ToP_TIME      AITIME
     C                   Z-ADD     ToP_SEQN      AISEQN
 
     C     GPAUUIK       SETGT     GPAUUID0
     C     GPAUUIK_P     READPE    GPAUUID0                               99    *
     C                   EXSR      READP4SELECT
 
      * Read previous
      * until count matches count of records previous read
 
     C     *IN99         DOWEQ     '0'
     C     SUBF_RRN      ANDLT     NumPerPag
     C     GPAUUIK_P     READPE    GPAUUID0                               99    *
     C                   EXSR      READP4SELECT
     C                   ADD       1             SUBF_RRN
     C                   ENDDO
 
      * Issue start of file message
 
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         AITIME
     C                   Z-ADD     *ZERO         AISEQN
     C     DDMSG         IFEQ      *BLANK
     C                   MOVEL     #_INF(2)      DDMSG
     C                   ENDIF
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Read for selection
      *****************************************************************
     C     READ4SELECT   BEGSR
     C  N99              MOVEL     AIJBNO        JobNumber         6
     C     *IN99         DOWEQ     '0'
     C     DDJBNO        ANDNE     *BLANK
     C     DDJBNO        ANDNE     JobNumber
     C     *IN99         OREQ      '0'
     C     DDRDVL        ANDNE     *BLANK
     C     DDRDVL        ANDNE     AIRDVL
     C     *IN99         OREQ      '0'
     C     DDZONE        ANDNE     *BLANK
     C     DDZONE        ANDNE     AIZONE
     C     *IN99         OREQ      '0'
     C     DDUSER        ANDNE     *BLANK
     C     DDUSER        ANDNE     AIUSER
     C     *IN99         OREQ      '0'
     C     DDTTYP        ANDNE     *BLANK
     C     DDTTYP        ANDNE     AITTYP
     C     *IN99         OREQ      '0'
     C     DDUPYN        ANDNE     *BLANK
     C     DDUPYN        ANDNE     AIUPYN
     C     GPAUUIK_P     READE     GPAUUID0                               99    *
     C  N99              MOVEL     AIJBNO        JobNumber
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Read previous for selection
      *****************************************************************
     C     READP4SELECT  BEGSR
     C  N99              MOVEL     AIJBNO        JobNumber
     C     *IN99         DOWEQ     '0'
     C     DDJBNO        ANDNE     *BLANK
     C     DDJBNO        ANDNE     JobNumber
     C     *IN99         OREQ      '0'
     C     DDRDVL        ANDNE     *BLANK
     C     DDRDVL        ANDNE     AIRDVL
     C     *IN99         OREQ      '0'
     C     DDZONE        ANDNE     *BLANK
     C     DDZONE        ANDNE     AIZONE
     C     *IN99         OREQ      '0'
     C     DDUSER        ANDNE     *BLANK
     C     DDUSER        ANDNE     AIUSER
     C     *IN99         OREQ      '0'
     C     DDTTYP        ANDNE     *BLANK
     C     DDTTYP        ANDNE     AITTYP
     C     *IN99         OREQ      '0'
     C     DDUPYN        ANDNE     *BLANK
     C     DDUPYN        ANDNE     AIUPYN
     C     GPAUUIK_P     READPE    GPAUUID0                               99    *
     C  N99              MOVEL     AIJBNO        JobNumber
     C                   ENDDO
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Action code check
      *****************************************************************
     C     ACTN_CHK      BEGSR
 
     C                   MOVEL     'Y'           ActnOK            1
 
      * Check for valid action code
 
     C     DDACTN        IFNE      'E'
     C     DDACTN        ANDNE     'W'
     C     DDACTN        ANDNE     'S'
     C                   MOVEL     #_INF(3)      DDMSG
     C                   MOVEL     'N'           ActnOK
     C                   ENDIF
 
      * If action code not OK, log record in error
 
     C     ActnOK        IFNE      'Y'
     C                   Z-ADD     1             @RIE              2 0
     C     *BLANK        LOOKUP    RIE(@RIE)                              99
     C                   MOVEL     DateTimeSeqn  RIE(@RIE)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR
 
      * Initialize program name
 
     C                   MOVEL     'GPAUUIEQ '   DDPGM
 
      * Set up standard screen fields.
 
     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR
 
     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50
 
     C**********         TIME                    TimeDate         12 0                       BUG3420
     C**********         MOVE      TimeDate      RunDate           6                         BUG3420
 
      * Create display run date
 
     C                   CALL      'CBTIME'                                                  BUG3420
     C                   PARM                    SystemDayNum      5                         BUG3420
     C                   PARM                    SystemTime        6                         BUG3420
     C                   PARM                    SystemDatFmt      1                         BUG3420
                                                                                             BUG3420
     C                   MOVEL     SystemDayNum  ZDAYNO                                      BUG3420
     C                   CALL      'ZDATE2'                                                  BUG3420
     C                   PARM                    ZDAYNO            5 0                       BUG3420
     C                   PARM      'D'           BJDFIN            1                         BUG3420
     C                   PARM                    ZDATE             6 0                       BUG3420
     C                   PARM                    ZADATE            7                         BUG3420
     C                   MOVEL     ZDATE         RunDate           6                         BUG3420
                                                                                             BUG3420
     C                   MOVEL     RunDate       DDMMYY
     C                   EVAL      DDRDAT = %subst(DDMMYY: 1:2)
     C                                      + MON(MM)
     C                                      + %subst(DDMMYY: 5:2)
 
      * Key lists
 
     C     GPAUUIK       KLIST
     C                   KFLD                    AIDATE
     C                   KFLD                    AITIME
     C                   KFLD                    AISEQN
     C     GPAUUIK_P     KLIST
     C                   KFLD                    AIDATE
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
** MON
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** #_INF
End of File
Start of File
Action code must be 'E'=enquiry or 'W'=WRKJOB or 'S'=STRSVRJOB
Job not found or not active or is already being serviced
STRSVRJOB has been successfully initiated
