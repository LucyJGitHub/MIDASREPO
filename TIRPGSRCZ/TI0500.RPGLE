     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Interface cob monitor')                       *
      *****************************************************************
      *                                                               *
      *  Midas - TI Module                                            *
      *                                                               *
      *  TI0500 - TI Cob Monitor Program                              *
      *                                                               *
      *  Function:  This program displays the status of the TI COB.   *
      *             It allows user control of the early TI COB phases *
      *             up to and including SUSPEND.                      *
      *                                                               *
      *  Called By: Menu Item                                         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG3481            Date 29Jun04               *
      *                 CSC023             Date 28Jan04               *
      *                 212558             Date 30Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CPK014             Date 14Nov01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CTI003  *CREATE    Date 30Aug00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  BUG3481 - PARMV is too short for contents in QCNDEXC call.   *
      *          - As CMD array elements are 98 long bug references   *
      *            were within the text. Removed bug references.      *
      *  CSC023 - SBMJOB output queue must be *JOBD.                  *
      *  212558 - Recompile over changed TIDTA data area.             *
      *  CPK014 - Submit jobs with user *JOBD                         *
      *  CTI003 - Midas/TI Interface Cob                              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     FTI0500DF  CF   E             WORKSTN INFSR(*PSSR)
      *****************************************************************
      /EJECT
      *                                                               *
      *    F U N C T I O N   O F   I N D I C A T O R S                *
      *                                                               *
      *    03           Exit Function Key F3                          *
      *    05           CF(5) Refresh Function Key                    *
      *    07           CF(7) Re-run Failed Phase                     *
      *    08           CF(8) Bypass Failed Phase                     *
      *    10           CF(10)End background Job                      *
      *    12           CF(12)Cancel Action                           *
      *    15           Failed Cob Phase                              *
      *    18           Conditioning indicator for F12                *
      *    50           Confirmation of Input                         *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Array to contain Phase Status
     D STS             S             11    DIM(6) CTDATA PERRCD(1)
      *
      ** Array to contain Phase Status abbreviations
     D STSA            S              1    DIM(6) CTDATA PERRCD(1)
      *
      ** Array to contain screen messages
     D MSG             S             75    DIM(5) CTDATA PERRCD(1)
      *
      ** Array to parameter for call to QCMDEXC
     D*CMD************ S             98    DIM(5) CTDATA PERRCD(1)                            CPK014
     D CMD             S             98    DIM(6) CTDATA PERRCD(1)                            CPK014
      *
      ** Program Status Data Structure to retrieve job details
     D PSDS           SDS
     D JOB_NAME              244    253
     D JOB_USER              254    263
      *
      ** Data Structure to trap TIDTA data.
     D TIDTA         E DS                  EXTNAME(TIDTA)
      *
      ** Data Structures to hold TIDTA flags.
      *
     DCurrSts          DS           126
     D Curr1                  51     51
     D Curr2                  52     52
     D Curr3                  53     53
     D Curr4                  54     54
     D Curr5                  55     55
     D Curr6                  56     56
     D Curr7                  57     57
     D Curr8                  58     58
     D Curr9                  59     59
     D Curr10                 60     60
     D Curr11                 61     61
     D USER                  101    110
     D NAME                  111    120
     D NUMBER                121    126
      *
      * TI Status Flag data
     D TIFLAGS         S             63
      *
      * Parameters for call to QCMDEXC
     D PARML           S             15  5
     D*PARMV****       S            120                                                      BUG3481
     D PARMV           S            196                                                      BUG3481
      *
      * Define constant for use in call to QCMDEXC
     D SLASH           C                   '/'
     D SPACE           C                   ' '
      *
      * Define work field
     D WORK            S              3  0
      *
      *****************************************************************
      *
      ** Main Program processing
     C                   EXSR      MAIN
      *
      ** Exit the Program
     C                   EXSR      STOP
      *
      *****************************************************************
      *                                                               *
      *  MAIN - Main User Processing                                  *
      *                                                               *
      *  Called by: Program Entry Procedure                           *
      *                                                               *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
      *
      ** Main Processing loop for first screen.
      *
     C     MAIN          BEGSR
      *
     C     *IN03         DOWEQ     *OFF
     C     ANSWER        ANDNE     'N'
      *
      * If TI COB hasn't already started, show initial screen.        ed
     C     Curr1         IFEQ      'P'
      *
     C                   EXFMT     TI0500B
      *
      * Execute subroutine based on user response
     C                   SELECT
      *
      * F12 Pressed then cancel action and reset
     C     *IN12         WHENEQ    '1'
     C                   Clear                   MESSAGE
     C                   EVAL      *IN50 = '0'
      *
     C                   OTHER
      *
     C     ANSWER        IFEQ      'Y'
     C     *IN50         ANDEQ     *ON
      *
      * Submit TI COB Control Job
     C***********        EVAL      PARML = 98                                                 CPK014
     C***********        EVAL      PARMV = CMD(1)                                             CPK014
     C**********         EVAL      PARML = 110                                         CPK014 CSC023
     C                   EVAL      PARML = 196                                                CSC023
     C                   EVAL      PARMV = CMD(1) + CMD(6)                                    CPK014
     C                   CALL      'QCMDEXC'
     C                   PARM                    PARMV
     C                   PARM                    PARML
      *
      * Once the TI COB has started, show status screen
     C                   EXSR      SCREEN2
     C                   ELSE
      *
     C     ANSWER        IFEQ      'Y'
     C                   EVAL      MESSAGE = 'Press Enter to Confirm'
     C                   EVAL      *IN50 = *ON
     C                   ELSE
     C                   EVAL      MESSAGE = 'Enter Y to Start TI Cob'
     C                   EVAL      *IN50 = *OFF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSL
      *
      * Else if TI COB has already started
     C                   ELSE
     C                   EXSR      SCREEN2
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SCREEN2 - Display the TI Control Job Data and control it's   *
      *            actions                                            *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls                                                        *
      *                                                               *
      *****************************************************************
      *
     C     SCREEN2       BEGSR
      *
     C     *IN03         DOWEQ     *OFF
      *
      * Load and show screen details
     C                   EXSR      LOAD
      *
      * Always set off 18 (F12=Cancel) before displaying this
     C                   SETOFF                                       18
      * If not being run during I/C then do not allow Bypass or Re-run
     C*****Phase         IFNE      'A'                                                        CCB020
     C     COBST         IFEQ      '*YES'                                                     CCB020
     C                   SETOFF                                       15
     C                   ENDIF
     C                   EXFMT     TI0500D
      *
      * Process based on the user response
     C                   SELECT
      *
      * F12 Pressed, therefore Cancel any pending actions and invalidate
      *  further presses of F12. (*IN18 = conditioning ind. for CF12)
     C     *IN12         WHENEQ    *ON
     C                   CLEAR                   FAILPHS
     C                   CLEAR                   FAILMSG
     C                   EVAL      *IN12 = *OFF
     C                   EVAL      *IN18 = *OFF
     C
      *
      * F7 Pressed, therefore Request confirmation to Re-run failed
      * Phase
     C     *IN07         WHENEQ    *ON
     C                   EVAL      *IN07 = *OFF
      *
      * If message shown is already 'Re-run?', this acts as
      *  confirmation and we continue with COB
     C     FAILMSG       IFEQ      MSG(3)
     C                   EXSR      RERUN
     C                   CLEAR                   FAILMSG
     C                   CLEAR                   FAILPHS
     C                   ELSE
      *
     C     FAILMSG       IFEQ      *BLANKS
     C                   EVAL      FAILMSG = MSG(3)
     C                   EVAL      *IN18 = *ON
     C                   ENDIF
      *
     C                   ENDIF
      *
      * F8 Pressed, therefore Bypass failed phase
     C     *IN08         WHENEQ    *ON
     C                   EVAL      *IN08 = *OFF
      *
      * If message shown is already 'Bypass?', this acts as
      * confirmation and we continue with COB
     C     FAILMSG       IFEQ      MSG(4)
     C                   EXSR      BYPASS
     C                   CLEAR                   FAILMSG
     C                   CLEAR                   FAILPHS
     C                   ELSE
      *
     C     FAILMSG       IFEQ      *BLANKS
     C                   EVAL      FAILMSG = MSG(4)
     C                   EVAL      *IN18 = *ON
     C                   ENDIF
      *
     C                   ENDIF
      *
      * F10 Pressed, end CoB Control job
     C     *IN10         WHENEQ    *ON
     C                   EVAL      *IN10 = *OFF
      *
      * If message shown is already 'Endjob?', this acts as
      * confirmation and we continue with COB
     C     FAILMSG       IFEQ      MSG(5)
     C                   EXSR      ENDJOB
     C                   CLEAR                   FAILMSG
     C                   CLEAR                   FAILPHS
     C                   ELSE
      *
     C     FAILMSG       IFEQ      *BLANKS
     C                   EVAL      FAILMSG = MSG(5)
     C                   ENDIF
      *
     C                   ENDIF
      *
      * End of possible user inputs to screen
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  LOAD - Load status values of TI phase for screen display     *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls                                                        *
      *                                                               *
      *****************************************************************
      *
     C     LOAD          BEGSR
      *
      * Read in the status flags from TIDTA
     C                   IN        TITEXT
     C                   MOVEL     TITEXT        CurrSts
      *
      ** Output Job data to the screen
      *
     C                   CLEAR                   JOBNAME
     C                   CLEAR                   JOBSTS
      *
     C     NUMBER        IFNE      '      '
     C     '/'           CAT       NUMBER        JOBNAME
     C     NAME          CAT       JOBNAME       JOBNAME
     C     '/'           CAT       JOBNAME       JOBNAME
     C     USER          CAT       JOBNAME       JOBNAME
     C                   EVAL      JOBSTS =  '*ACTIVE'
      *
      * Show the option to 'End the TI COB Control Job'
     C                   EVAL      *IN15 = *OFF
     C                   ELSE
      *
     C                   EVAL      JOBSTS =  '*INACTIVE'
     C                   EVAL      *IN15 = *ON
     C                   ENDIF
      *
      * Output Status flags to the screen for end of background jobs
     C                   CLEAR                   FAILPHS
     C                   Z-ADD     1             X                 1 0
     C     Curr1         LOOKUP    STSA(X)                                50
     C                   MOVEA     STS(X)        STATUS1
      *
     C     Curr1         IFEQ      'T'
     C                   EVAL      FAILPHS = MSG(2)
     C                   ENDIF
     C     Curr1         IFEQ      'F'
     C                   EVAL      FAILPHS = MSG(1)
     C                   ENDIF
      *
      * Output Status flags to the screen for end of backfground jobs confirmed
     C                   Z-ADD     1             X                 1 0
     C     Curr2         LOOKUP    STSA(X)                                50
     C                   MOVEA     STS(X)        STATUS2
      *
     C     Curr2         IFEQ      'T'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(2)
     C                   ENDIF
     C     Curr2         IFEQ      'F'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(1)
     C                   ENDIF
      *
      * Output Status flags to the screen for CLOSING
     C                   Z-ADD     1             X                 1 0
     C     Curr3         LOOKUP    STSA(X)                                50
     C                   MOVEA     STS(X)        STATUS3
      *
     C     Curr3         IFEQ      'T'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(2)
     C                   ENDIF
     C     Curr3         IFEQ      'F'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(1)
     C                   ENDIF
      *
      * Output Status flags to the screen for CLOSINGOK
     C                   Z-ADD     1             X                 1 0
     C     Curr4         LOOKUP    STSA(X)                                50
     C                   MOVEA     STS(X)        STATUS4
      *
     C     Curr4         IFEQ      'T'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(2)
     C                   ENDIF
     C     Curr4         IFEQ      'F'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(1)
     C                   ENDIF
      *
      * Output Status flags to the screen for STREONL
     C                   Z-ADD     1             X                 1 0
     C     Curr5         LOOKUP    STSA(X)                                50
     C                   MOVEA     STS(X)        STATUS5
      *
     C     Curr5         IFEQ      'T'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(2)
     C                   ENDIF
     C     Curr5         IFEQ      'F'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(1)
     C                   ENDIF
      *
      * Output Status flags to the screen for STREONLOK
     C                   Z-ADD     1             X                 1 0
     C     Curr6         LOOKUP    STSA(X)                                50
     C                   MOVEA     STS(X)        STATUS6
      *
     C     Curr6         IFEQ      'T'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(2)
     C                   ENDIF
     C     Curr6         IFEQ      'F'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(1)
     C                   ENDIF
      *
      * Output Status flags to the screen for SUSPEND
     C                   Z-ADD     1             X                 1 0
     C     Curr7         LOOKUP    STSA(X)                                50
     C                   MOVEA     STS(X)        STATUS7
      *
     C     Curr7         IFEQ      'T'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(2)
     C                   ENDIF
     C     Curr7         IFEQ      'F'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(1)
     C                   ENDIF
      *
      * Output Status flags to the screen for SUSPENDOK
     C                   Z-ADD     1             X                 1 0
     C     Curr8         LOOKUP    STSA(X)                                50
     C                   MOVEA     STS(X)        STATUS8
      *
     C     Curr8         IFEQ      'T'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(2)
     C                   ENDIF
     C     Curr8         IFEQ      'F'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(1)
     C                   ENDIF
      *
      * Output Status flags to the screen for End *PROP job
     C                   Z-ADD     1             X                 1 0
     C     Curr9         LOOKUP    STSA(X)                                50
     C                   MOVEA     STS(X)        STATUS9
      *
     C     Curr9         IFEQ      'T'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(2)
     C                   ENDIF
     C     Curr9         IFEQ      'F'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(1)
     C                   ENDIF
      *
      * Output Status flags to the screen for postings processing
     C                   Z-ADD     1             X                 1 0
     C     Curr10        LOOKUP    STSA(X)                                50
     C                   MOVEA     STS(X)        STATUS10
      *
     C     Curr10        IFEQ      'T'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(2)
     C                   ENDIF
     C     Curr10        IFEQ      'F'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(1)
     C                   ENDIF
      *
      * Output Status flags to the screen for STREOD
     C                   Z-ADD     1             X                 1 0
     C     Curr11        LOOKUP    STSA(X)                                50
     C                   MOVEA     STS(X)        STATUS11
      *
     C     Curr11        IFEQ      'T'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(2)
     C                   ENDIF
     C     Curr11        IFEQ      'F'
     C     FAILPHS       ANDEQ     *BLANKS
     C                   EVAL      FAILPHS = MSG(1)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  RERUN - Rerun the failed components                          *
      *                                                               *
      *  Called by: SCREEN2                                           *
      *                                                               *
      *  Calls                                                        *
      *                                                               *
      *****************************************************************
      *
     C     RERUN         BEGSR
      *
      * Submit TI COB Control Job with parameters to Re-run failed
      * sub-component
     C***********        Z-ADD     98            PARML                                        CPK014
     C***********        MOVEL     CMD(1)        PARMV                                        CPK014
     C**********         Z-ADD     110           PARML                                 CPK014 CSC023
     C                   Z-ADD     196           PARML                                        CSC023
     C                   EVAL      PARMV = CMD(1) + CMD(6)                                    CPK014
      *
     C                   CALL      'QCMDEXC'
     C                   PARM                    PARMV
     C                   PARM                    PARML
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  BYPASS - Bypass the failed or timed out component            *
      *                                                               *
      *  Called by: SCREEN2                                           *
      *                                                               *
      *  Calls                                                        *
      *                                                               *
      *****************************************************************
      *
     C     BYPASS        BEGSR
      *
      * Submit TI COB Control Job with paramaters to bypass failed
      * sub-component
     C***********        EVAL      PARML  = 98                                                CPK014
     C***********        EVAL      PARMV = CMD(2)                                             CPK014
     C**********         EVAL      PARML  = 110                                        CPK014 CSC023
     C                   EVAL      PARML  = 196                                               CSC023
     C                   EVAL      PARMV = CMD(2) + CMD(6)                                    CPK014
      *
     C                   CALL      'QCMDEXC'
     C                   PARM                    PARMV
     C                   PARM                    PARML
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  ENDJOB - End the TI COB Control Job                          *
      *                                                               *
      *  Called by: SCREEN2                                           *
      *                                                               *
      *  Calls                                                        *
      *                                                               *
      *****************************************************************
      *
     C     ENDJOB        BEGSR
      *
      * Call QCMDEXC to end the TI CoB Control job
     C                   EVAL      PARMV = %TRIM(CMD(3)) + %TRIM(NUMBER) +
     C                                     SLASH + %TRIM(USER) + SLASH +
     C                                     %TRIM(NAME) + %TRIM(CMD(4))
     C
     C     ' '           CHECKR    PARMV         WORK
     C                   EVAL      PARML = WORK
      *
     C                   CALL      'QCMDEXC'
     C                   PARM                    PARMV
     C                   PARM                    PARML
      *
      * Delay this job long enough for the data area lock to be released
      * by TIC0500
     C                   EVAL      PARMV = CMD(5)
     C                   EVAL      PARML = 14
      *
     C                   CALL      'QCMDEXC'
     C                   PARM                    PARMV
     C                   PARM                    PARML
      *
      * Clear job data from the data area TIDTA.
     C     *LOCK         IN        TITEXT
     C                   EVAL      CurrSts = TITEXT
      *
     C                   CLEAR                   USER
     C                   CLEAR                   NAME
     C                   CLEAR                   NUMBER
      *
      * If the COB job was manually ended, the status field for the last
      * running phase must be updated from here.
     C                   SELECT
     C     Curr1         WHENEQ    'R'
     C                   EVAL      Curr1 = 'F'
     C     Curr2         WHENEQ    'R'
     C                   EVAL      Curr2 = 'F'
     C     Curr3         WHENEQ    'R'
     C                   EVAL      Curr3 = 'F'
     C     Curr4         WHENEQ    'R'
     C                   EVAL      Curr4 = 'F'
     C     Curr5         WHENEQ    'R'
     C                   EVAL      Curr5 = 'F'
     C     Curr6         WHENEQ    'R'
     C                   EVAL      Curr6 = 'F'
     C     Curr7         WHENEQ    'R'
     C                   EVAL      Curr7 = 'F'
     C     Curr8         WHENEQ    'R'
     C                   EVAL      Curr8 = 'F'
     C     Curr9         WHENEQ    'R'
     C                   EVAL      Curr9 = 'F'
     C     Curr10        WHENEQ    'R'
     C                   EVAL      Curr10 = 'F'
     C     Curr11        WHENEQ    'R'
     C                   EVAL      Curr11 = 'F'
     C                   ENDSL
      *
      * Update data area TIDTA
     C                   MOVEL     CurrSts       TITEXT
     C                   OUT       TITEXT
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  INZSR - Automatic Initialisation                             *
      *                                                               *
      *  Called by: None (Automatically run at load of program)       *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      * Read contents of TIDTA Data Area for Job Status and progress
     C     *DTAARA       DEFINE    TIDTA         TITEXT          128
     C                   IN        TITEXT
     C                   MOVEL     TITEXT        CurrSts
      *
      * Check phase of Midas
     C******DTAARA       DEFINE    MPHAS         Phase             1                          CCB020
     C**********         IN        Phase                                                      CCB020
     C                   MOVEL     'CBC00100'    @CLPRM            9                          CCB020
     C                   MOVE      '1'           @CLPRM                                       CCB020
     C                   CALL      @CLPRM                                                     CCB020
     C                   PARM      *BLANKS       COBST             4                          CCB020
      *
      ** Initialise User and Job fields for screen display
     C                   EVAL      JOBNM = JOB_NAME
     C                   EVAL      USERID = JOB_USER
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  STOP - Exit the program in controlled fashion                *
      *                                                               *
      *  Called by:                                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     STOP          BEGSR
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
      *
     C                   END
      *
     C                   ENDSR
      *
      ********************************************************************
**  STS
Pending
Running
Failed
Completed
Bypassed
Timed-out
**  STSA
P
R
F
C
B
T
**  MSG
A COB Phase has failed.  Re-run, Bypass or contact office
A COB Phase has timed out.  Re-run, Bypass or contact office
Press F7 to confirm Re-run of component
Press F8 to confirm Bypass of component
Press F10 to confirm End of TI COB Control Job
**  CMD
SBMJOB CMD(CALL PGM(MLC0000) PARM('TIC0500' ' ' ' ' ' ' ' ' ' ')) JOB(TIC0500) JOBD(TIJOBD)
SBMJOB CMD(CALL PGM(MLC0000) PARM('TIC0500' 'B' ' ' ' ' ' ' ' ')) JOB(TIC0500) JOBD(TIJOBD)
SBMJOB CMD(ENDJOB JOB(
) OPTION(*CNTRLD)) JOB(TICOBEND) JOBD(TIJOBD) USER(*JOBD)
DLYJOB DLY(20)
 USER(*JOBD) OUTQ(*JOBD) INLLIBL(*JOBD)
