     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE I/C Zero Balancing/Sweeping Controller')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE101301 - I/C Zero Balancing/Sweeping Controller            *
      *                                                               *
      *  Function:  This program controls input cycle zero balancing  *
      *             and sweeping.                                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSC023             Date 28Jan04               *
      *                 213197             Date 22Jan03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC023 - SBMJOB output queue must be *JOBD.                  *
      *  213197 - Rewrite of sweeping scheduling                      *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FREICSLL0  IF   E           K DISK    INFSR(*PSSR)
     FREICSLPD  O  A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REICSLD0:REICSLD1)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D #_ICSF          S              4    DIM(12)
     D #_STIMS         S              6  0 DIM(12) ASCEND
     D #_ALCOBJ        S             65    DIM(1)  CTDATA PERRCD(1)
     D #_DLCOBJ        S             65    DIM(1)  CTDATA PERRCD(1)
     D #_SBMJOB        S             65    DIM(3)  CTDATA PERRCD(1)
     D #_TXT           S              1    DIM(65)
 
      * 'Now' date
     D                 DS
     D CurDATE                 1      6  0
     D CurMM                   1      2  0
     D CurDD                   3      4  0
     D CurYY                   5      6  0
     D CurMMA                  1      2
     D CurDDA                  3      4
     D CurYYA                  5      6
      * 'Now' time
     D                 DS
     D CurTIME                 1      6  0
     D CurHH                   1      2  0
     D CurMI                   3      4  0
     D CurSS                   5      6  0
     D CurHHA                  1      2
     D CurMIA                  3      4
     D CurSSA                  5      6
 
 
      * Scheduled date
     D                 DS
     D SchDATE                 1      6  0
     D SchMM                   1      2  0
     D SchDD                   3      4  0
     D SchYY                   5      6  0
     D SchDATEA                1      6
     D SchMMA                  1      2
     D SchDDA                  3      4
     D SchYYA                  5      6
      * Scheduled time
     D                 DS
     D SchTIME                 1      6  0
     D SchHH                   1      2  0
     D SchMI                   3      4  0
     D SchSS                   5      6  0
     D SchTIMEA                1      6
     D SchHHA                  1      2
     D SchMIA                  3      4
     D SchSSA                  5      6
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCMAN        E DS                  EXTNAME(SDCMANPD)
      ** External DS for cash management details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs
 
 
      * Infinite loop
      * (Program ends when asked to 'stop')
 
     C     *INLR         DOUEQ     '1'
 
      * Next scheduled time
 
     C                   MOVEL     #_STIMS(1)    SchTIME
 
      * If no next sweep time, set wait time to 'forever'
      * Otherwise, set wait time to 60 seconds
 
     C     SchTIME       IFEQ      999999
     C                   Z-ADD     -1            DtqWait
      * 'Cash management input cycle sweeping - COMPLETED on &1'
     C                   EVAL      #MSGID = 'RE75420 '
     C                   EVAL      #MSGDT = CurDDA + '/' + CurMMA
     C                                      + '/' + CurYYA
     C                   ELSE
     C                   Z-ADD     60            DtqWait
      * 'Cash management input cycle sweeping - Next sweep time is &1'
     C                   EVAL      #MSGID = 'RE75421 '
     C                   EVAL      #MSGDT = SchHHA + ':' + SchMIA
     C                                      + ':' + SchSSA + ' on '
     C                                      + SchDDA + '/' + SchMMA
     C                                      + '/' + SchYYA
     C                   ENDIF
     C                   EXSR      LOGEVENT
 
      * Wait for a time
 
     C                   EXSR      WAIT
 
      * Submit the next scheduled job
 
     C                   EXSR      SBM_JOB
 
     C                   ENDDO
 
      /SPACE 5
      ********************************************************************
      * Wait for a time
      ********************************************************************
     C     WAIT          BEGSR
 
     C     CurTIME       DOUGE     SchTIME
     C     CurDATE       ANDEQ     SchDATE
 
     C                   CALL      'QRCVDTAQ'
     C                   PARM      'RESWPDTQ  '  DtqNam           10
     C                   PARM      '*LIBL     '  DtqLib           10
     C                   PARM      10            DtqLen            5 0
     C                   PARM      *BLANK        DtqDta           10
     C                   PARM                    DtqWait           5 0
 
      * Get current date and time
 
     C                   EXSR      GET_CurDT
 
      * If 'STOP' received, then end
 
     C     DtqDta        IFEQ      'STOP'
      * 'Cash management input cycle sweeping - Stopped by request on &1'
     C                   EVAL      #MSGID = 'RE75422 '
     C                   EVAL      #MSGDT = CurDDA + '/' + CurMMA
     C                                      + '/' + CurYYA
     C                   EXSR      LOGEVENT
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Submit the next scheduled job
      ********************************************************************
     C     SBM_JOB       BEGSR
 
      * ALCOBJ
 
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_ALCOBJ
     C                   PARM      65            LEN              15 5
 
     C     *in99         CABEQ     '1'           ENDSBM
 
      * DLCOBJ
 
     C                   CALL      'QCMDEXC'                            9999    *
     C                   PARM                    #_DLCOBJ
     C                   PARM      65            LEN              15 5
 
      * SBMJOB
 
     C                   MOVEA     #_SBMJOB(2)   #_TXT
     C                   MOVEA     SchTIMEA      #_TXT(44)
     C                   MOVEA     #_TXT         #_SBMJOB(2)
     C                   CALL      'QCMDEXC'
     C                   PARM                    #_SBMJOB
     C                   PARM      180           LEN              15 5
 
      * Write a CONTROL record to the input cycle sweeps log file
 
     C                   Z-ADD     SchDate       ILDATE
     C                   Z-ADD     SchTIME       ILTIME
     C                   MOVE      'C'           ILTYPE
     C                   WRITE     REICSLD1
 
      * 'Cash management input cycle sweeping - Sweep submitted at &1'
     C                   EVAL      #MSGID = 'RE75423 '
     C                   EVAL      #MSGDT = SchHHA + ':' + SchMIA
     C                                      + ':' + SchSSA + ' on '
     C                                      + SchDDA + '/' + SchMMA
     C                                      + '/' + SchYYA
     C                   EXSR      LOGEVENT
 
      * Remove this scheduled time
     c
     C                   Z-ADD     1             I
     C     SchTIME       LOOKUP    #_STIMS(I)                             99
     C                   Z-ADD     999999        #_STIMS(I)
 
      * Sort scheduled times
 
     C                   SORTA     #_STIMS
 
     C     ENDSBM        ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Log an event
      ********************************************************************
     C     LOGEVENT      BEGSR
 
      * Get the message details
 
     C                   CALLB     'ZAMSGRTVMS'
     C                   PARM      *BLANK        ReturnCode       10
     C                   PARM      *BLANK        CompMsg        3000
     C                   PARM                    #MSGID
     C                   PARM                    #MSGDT
     C                   PARM      'GBREUSRMSG'  #MSGF
     C                   PARM      '*LIBL  '     #MSGFL
     C                   PARM      '0'           Level             1
 
      * Write an INFORMATION record to the input cycle sweeps log file
 
     C                   Z-ADD     CurDATE       ILDATE
     C                   Z-ADD     CurTIME       ILTIME
     C                   MOVE      'I'           ILTYPE
     C                   MOVEL     CompMsg       ILNARR
     C                   WRITE     REICSLD1
 
      * Send a message
 
     C                   CALL      'AOCREPT'                            9999    *
     C                   PARM                    #MSGID            7
     C                   PARM      'GBREUSRMSG'  #MSGF            10
     C                   PARM      *BLANKS       #MSGFL           10
     C                   PARM                    #MSGDT          256
     C                   PARM      '*PRV '       #MSGR             5
     C                   PARM      '*'           #PRGM            10
     C                   PARM      'MRUNQ  '     #MSGQ            10
     C                   PARM      '*INFO  '     #MSGT             7
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Get Current Date and Time
      ********************************************************************
     C     GET_CurDT     BEGSR
     C                   TIME                    TimeDate         12 0
     C                   MOVE      TimeDate      DMY               6
     C                   EVAL      CurDDA = %SUBST(DMY:1:2)
     C                   EVAL      CurMMA = %SUBST(DMY:3:2)
     C                   EVAL      CurYYA = %SUBST(DMY:5:2)
     C                   MOVEL     TimeDate      CurTIME
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Determine if Holiday
      ********************************************************************
     C     DET_Holiday   BEGSR
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      *BLANK        ZLOC              3
     C                   PARM      *BLANK        ZIND              1
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert a date to day number
      ********************************************************************
     C     ZDATE1        BEGSR
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM      'M'           ZDFIN             1
     C                   PARM                    ErrorFlag         1
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * Convert a day number to a date
      *****************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      'M'           ZZDFIN            1
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * Calculate scheduled times
      ********************************************************************
     C     CALC_STIMS    BEGSR
 
     C                   Z-ADD     999999        #_STIMS
 
      * Add times from cash management ICD
 
     C                   Z-ADD     1             I                 2 0
     C     I             DOWLE     12
     C     #_ICSF(I)     ANDNE     *BLANK
     C                   MOVEL     #_ICSF(I)     SchHH
     C                   MOVE      #_ICSF(I)     SchMI
     C                   Z-ADD     00            SchSS
     C                   Z-ADD     SchTIME       #_STIMS(I)
      * Remove if time processed
     C     SchTIME       CHAIN     REICSLD0                           99
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     999999        #_STIMS(I)
     C                   ELSE
 
      * 'Cash management input cycle sweeping - Sweeping scheduled for &1'
     C                   EVAL      #MSGID = 'RE75424 '
     C                   EVAL      #MSGDT = SchHHA + ':' + SchMIA
     C                                      + ':' + SchSSA + ' on '
     C                                      + SchDDA + '/' + SchMMA
     C                                      + '/' + SchYYA
     C                   EXSR      LOGEVENT
     C                   ENDIF
     C                   ADD       1             I
     C                   ENDDO
 
      * Sort scheduled times
 
     C                   SORTA     #_STIMS
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Database Error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AOBANKR0 in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      *  Access Cash Management Details
 
     C                   CALLB     'AOCMANR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDCMAN        PARM      SDCMAN        DSSDY
 
      * Database Error
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      X_ERMS = 'Call to AOCMANR0 in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Cut-off time
 
     C                   Z-ADD     170000        CutoffTime        6 0
 
      * Get current date and time
 
     C                   EXSR      GET_CurDT
 
      * Determine if the current date - today - is a holiday
 
     C                   MOVE      CurDATE       ZDATEI
     C                   EXSR      ZDATE1
     C                   EXSR      DET_Holiday
     C     ZIND          IFEQ      'H'
     C                   MOVEL     'Y'           HolidayToday      1
     C                   ELSE
     C                   MOVEL     'N'           HolidayToday
     C                   ENDIF
 
      * Determine next working day after today
 
     C     ZIND          DOUNE     'H'
     C                   ADD       1             ZDAYNO
     C                   EXSR      DET_Holiday
     C                   ENDDO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATEN        NxWkDate          6 0
 
      * If current time is after the cut-off time
      * or if today is a holiday
      *    Sweeping schedule date will be the next working day
      *  Otherwise
      *    Sweeping schedule date will be today
 
     C     CurTIME       IFGT      CutoffTime
     C     HolidayToday  OREQ      'Y'
     C                   Z-ADD     NxWkDate      SchDATE
     C                   ELSE
     C                   Z-ADD     CurDATE       SchDATE
     C                   ENDIF
 
      * 'Cash management input cycle sweeping - STARTED on &1'
     C                   EVAL      #MSGID = 'RE75425 '
     C                   EVAL      #MSGDT = CurDDA + '/' + CurMMA
     C                                      + '/' + CurYYA
     C                   EXSR      LOGEVENT
 
      * Calculate scheduled times
 
     C                   MOVEA     CMICSF        #_ICSF
     C                   EXSR      CALC_STIMS
 
      * Clear the DTAQ
 
     C     DtqDta        DOUEQ     *BLANK
     C                   CALL      'QRCVDTAQ'
     C                   PARM      'RESWPDTQ  '  DtqNam           10
     C                   PARM      '*LIBL     '  DtqLib           10
     C                   PARM      10            DtqLen            5 0
     C                   PARM      *BLANK        DtqDta           10
     C                   PARM      1             DtqWait           5 0
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
** #_ALCOBJ
ALCOBJ OBJ((RESWPEXC *DTAARA *EXCL)) WAIT(0)
** #_DLCOBJ
DLCOBJ OBJ((RESWPEXC *DTAARA *EXCL))
** #_SBMJOB
SBMJOB JOB(CM_SWP_EXC) JOBD(MBATCH) JOBQ(CMZJOBQ) USER(*JOBD)
RTGDTA(*JOBD) RQSDTA('CALL REC101204 PARM(T000000 S_ALL S_ALL)')
 INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                                                      CSC023
