     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CB Restart of failed components')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Close of Business Processing                         *
     F*                                                               *
     F*  CB0065 - RESTART FAILED COMPONENTS                           *
     F*                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK025             Date 23Nov06               *
      *  Prev Amend No. CGP002             Date 31Jul03               *
      *                 CAAA02             Date 16Jul03               *
      *  Converted to ILE and code-stripped                           *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209755             Date 24Sep02               *
      *                 208854             Date 07Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 080607             Date 02Mar95               *
      *                 S01517             Date 10Aug94               *
     F*                 063315             DATE 03AUG94               *
     F*                 057217             DATE 26MAY94               *
     F*                 E27295             DATE 18JUL91               *
     F*                 LN1077             DATE 30APR91               *
     F*                 LN0989             DATE 21NOV90               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  CPK025 - Revert fix CAAA02                                   *
      *  CGP002 - Add call to GOC000100 to submit an update to the    *
      *           global dashboard.                                   *
      *  CAAA02 - Remove use of INVITE keyword to enable WebFacing    *
      *           to process screens.                                 *
      *           This program must read formats rather than a file.  *
      *           Repace the call of QCMDEXC to get job details by    *
      *           calling CBC0066 (using API QUSLSPL) to list job     *
      *           spooled files.                                      *
     F*  209755 - 'Number of failed components' is still appearing    *
     F*           after re-starting the component that failed.        *
      *  208854 - Do not allow component to be restarted if status is *
      *           not 'A' to prevent possibility of running the compo-*
      *           nent more than once. Patterned from fix 181716.     *
     F*  080607 - Chain to subfile.                                   *
     F*  S01517 - Allow Component Bypass in COB                       *
     F*  063315 - Another I/O error.                                  *
     F*  057217 - Keyboard error caused by typing ahead               *
     F*  E27295 - ALLOW WRKJOB INSTEAD OF DSPJOB ON ERROR/RESTART     *
     F*           IF QCMD ALLOWED                                     *
     F*  LN1077 - ONLY LOCK CBSTAT WHEN ACCESSING IT FOR READ/UPDATE  *
     F*           THIS WILL PREVENT CB0065 LOCKING CBSTAT INDEFINITELY*
     F*  LN0989 - PROVIDE ADDITIONAL COB ERROR INFORMATION            *
     F*                                                               *
     F*****************************************************************
     FCB0065DF  CF   E             WORKSTN
     F                                     SFILE(CB0065S0:RRN)
     F                                     MAXDEV(*FILE)
     FCBAUDTL1  IF   E           K DISK
     FCBCOMSL8  IF   E           K DISK    USROPN
     FCBCOMSL0  UF   E           K DISK    USROPN
     F*
      /SPACE 2
     F********************************************************************
     F*
     F*     C  L   FUNCTION OF INDICATORS
     F*
     F*    03      COMMAND KEY 3 PRESSED
     F*    05      COMMAND KEY 5 PRESSED
     F*    20      ACTIVATE SFLDSP KEYWORD
     F*    21      ACTIVATE SFLDSPCTL KEYWORD
     F*    24      ACTIVATE SFLNXTCHG KEYWORD
     F*    40      NO RECORDS ON FAILED COMPONENTS FILE - CBCOMSL8
     F*    42      END OF FILE REACHED ON READ OF CBCOMSL8
     F*    43      INDICATOR ON IF RECORDS WRITTEN TO SUBFILE
     F*    45      DISPLAY FILE NOT FOUND ON READ
     F*    50      NO CHANGED RECORDS FOUND ON READ OF SUBFILE
     F*    55      DATABASE ERROR ON FAILED COMPONENTS FILE
     F*    60      INVALID ENTRY IN RESTART FIELD ON DISPLAY FILE
     F*    65      PROTECT RESTART FIELD AND WRITE COMPONENT RESTARTED
     F*            MESSAGE
     F*    70      INDICATOR CONTROLLING EXTRA PAGE + SIGN
     F*    71      SUCCESSFUL LOCK ON CBSTAT ACHIEVED.
     F*    75      ERROR IN CALLED PROGRAM CB0500
     F*    76      LR SWOTCHED ON BY CALLING PROGRAM
     F*    77      ERROR IN DETAILS INPUT TO SCREEN
     F*    78      ERROR IN ACCESS TO JOB DETAILS
     F*    79      USED TO FIND BLANK SPACES IN JOB DETAILS
     F*    81      ERROR IN CALLING CBC0066                                                  CAAA02
     F*
     F*
     F*        LR  LAST RECORD INDICATOR
     F*
     F*    U1      SCREEN TIMED OUT
     F*    U7&U8   DATABASE ERROR
     F*
     F*****************************************************************
     F/EJECT
     D*
     D** COPYRIGHT ARRAY
     D*
     D*ERRMSG*****     S             78    DIM(3) CTDATA PERRCD(1)                           CAAA02
     D*ERRMSG*****     S             78    DIM(4) CTDATA PERRCD(1)                    CAAA02 CPK025
     D ERRMSG          S             78    DIM(3) CTDATA PERRCD(1)                           CPK025
     D** ERROR MESSAGE ARRAY
     D*
     D RSTARR          S             25    DIM(3) CTDATA PERRCD(1)
     D** MESSAGE ARRAY
     D*
     D DJ1             S             12    DIM(2) CTDATA PERRCD(1)
     D*  ARRAY TO SET UP FIRST PART OF DSPJOB COMMAND
     D*
     D JOB             S              1    DIM(30)
     D*  ARRAY TO  ET UP LATER FIELDS OF DSPJOB COMMAND
     D*
     D*****************************************************************
     D/EJECT
     D*
     D LDA            UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D**     LOCAL DATA AREA
     D*
     D CBSTAT          DS            50
     D  CBFAIL                14     16  0
     D**     DATA AREA CBSTAT
     D*
     D RUNDAT          DS            13
     D  AGMRDT                 1      7
     D** DATA STRUCTURE TO GET DATE FROM RUNDAT DATA AREA
     D*
     D PSDS           SDS
     D  WSID                 244    253
     D  USRID                254    263
     D**     DATA STRUCTURE FOR WORKSTATION ID FOR SCREEN OUTPUT
     D*
     D CKEYDS          DS
     D  SCCOTX                 1     10
     D  SCSEQX                11     15
     D** DATA STRUCTURE FOR KEY FIELD CKEY TO BE MOVED INTO DBKEY FIELD
     D*
     D PARMS           DS
     D  PMS                    1     40
     D  JBCMD                  1     12
     D  JBDTL                 13     40
     D** DATA STRUCTURE TO SET UP QCMDEXC PARAMETERS
     D*
     D DTMSG           DS
     D  SCCOT                  1     10
     D  SCSEQ                 11     15
     D  RESTT                 16     16
     D** DATA STRUCTURE TO SET UP MESSAGE FOR QSNDDTAQ
     D*
     D SSCSEQ          DS
     D  RSTMSG                 1     17
     D  SCSEQA                 7     11
     D** DATA STRUCTURE TO SET UP MESSAGE FOR SEQUENCE NO FIELD
     D*
     D SDCOBP        E DS                  EXTNAME(SDCOBPPD)
     D** EXTERNAL DATA STRUCTURE FOR ACCESS OBJECT SDCOBPPD FORMAT
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **********                                                                       CAAA02 CPK025
      **WaitTime is the time from WRITE to READ                                        CAAA02 CPK025
     D*WaitTime*       s              5p 0                                             CAAA02 CPK025
     D*MaxWaitTime     s              5p 0 inz(600)                                    CAAA02 CPK025
      **********                                                                       CAAA02 CPK025
      **Now1Time is the time before the READ and Now2Time the time after               CAAA02 CPK025
     D*Now1Time*       s               t                                               CAAA02 CPK025
     D*Now2Time*       s               t                                               CAAA02 CPK025
      **********                                                                       CAAA02 CPK025
     I***FIRST*DATA STRUCTURE FOR ACCESS OBJECTS, SHORT DATA STRUCTURE                        CPK025
     I**********                                                                              CPK025
     D*Webfacing       s              1                                                CAAA02 CPK025
     I***Webfacing field Y/N definition                                                CAAA02 CPK025
     I*****************************************************************
     I/EJECT
     C*
     C** KEY TO CHAIN TO CBCOMSL8
     C*
     C     CKEY          KLIST
     C                   KFLD                    SCCOT
     C                   KFLD                    SCSEQP            5
     C*
     C** KEY TO READ BACKWARDS THROUGH CBAUDTL1
     C*
     C     AKEY          KLIST
     C                   KFLD                    SCCOT
     C                   KFLD                    CSEQP             5 0
     C*
     C** SET UP PROGRAM NAME FOR DATABASE ERRORS
     C*
     C                   MOVEL     'CB0065  '    DBPGM
     C                   MOVE      *BLANKS       DBKEY
     C*
     C**  OBTAIN RUN DATE FROM DATA AREA RUNDAT
     C*
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C*
     C**   DEFINE CBSTAT
     C*
     C     *DTAARA       DEFINE                  CBSTAT
     C*
     C**   DEFINE LDA
     C*
     C     *DTAARA       DEFINE                  LDA
     C*
     C**   Define work fields
     C*
     C     *LIKE         DEFINE    SCSEQA        WSEQR
     C     *LIKE         DEFINE    SCSEQA        WSEQP
     C*
     C                   MOVE      AGMRDT        RUNA
     C                   UNLOCK    RUNDAT
     C*
     C** OPEN COMPONENTS FILE (CBCOMSL8)
     C*
     C                   OPEN      CBCOMSL8
     C*
     C** SET RELATIVE RECORD NUMBER FOR SUBFILE TO 1
     C** AND SET SCREEN '+' FIELD INDICATOR
     C*
     C                   Z-ADD     1             RRN               3 0
     C                   SETON                                        70
     C*
     C                   WRITE     CB0065C0
     C*
     C** DO WHILE COMMAND KEY 3 NOT PRESSED
     C** AND SCREEN NOT TIMED OUT
     C*
     C     *IN03         DOWNE     '1'
     C     *INU1         ANDNE     '1'
     C*
     C** WRITE DISPLAY FILE HEADER FORMAT
     C*
     C                   WRITE     CB0065F0
     C*
     C** FILL SUBFILE ONLY IF NOT ALREADY FULL
     C*
     C     *IN43         IFEQ      '0'
     C*
     C** READ FAILED COMPONENTS FILE - CBCOMSL8
     C*
     C                   READ      CBCOMSL8                               40
     C*
     C** IF RECORDS ON COMPONENTS FILE THEN
     C** FILL SUBFILE WITH RECORDS
     C*
     C     *IN40         IFEQ      '0'
     C*
     C                   EXSR      FILLSB
     C*
     C                   ELSE
     C*
     C** ELSE WRITE NO FAILED COMPONENTS TO REPORT
     C** MESSAGE FROM MESSAGE FORMAT - CB0065F1
     C*
     C                   SETON                                        42
     C                   WRITE     CB0065F1
     C                   SETON                                        21
     C                   SETOFF                                       43
     C*
     C                   END
     C*
     C** WRITE DISPLAY FILE TRAILER FORMAT
     C*
     C                   WRITE     CB0065F2
     C*
     C** WRITE SUBFILE CONTROL FORMAT IF RECORDS ON COMPONENT FILE
     C*
     C     *IN42         IFEQ      '0'
     C                   WRITE     CB0065C0
     C*
     C                   ELSE
     C*
     C** ELSE SET OFF SFLDSPCTL AND INSTRUCTION FIELD INDICATORS
     C*
     C                   SETOFF                                       2142
     C*
     C                   END
     C*
     C** READ SCREEN FOR DETAILS ENTERED
     C*
     C************       READ      CB0065DF                             U145                  CAAA02
     C                   READ      CB0065DF                             U145                  CPK025
      **********/free                                                                         CPK025
      **********   Now1Time = %time();                                 //              CAAA02 CPK025
      **********                                                       //              CAAA02 CPK025
      **********   read CB0065C0;                                      //              CAAA02 CPK025
      **********   if %eof;                                            //              CAAA02 CPK025
      **********      *in45='1';                                       //              CAAA02 CPK025
      **********   endif;                                              //              CAAA02 CPK025
      **********                                                       //              CAAA02 CPK025
      **********   Now2Time = %time();                                 //              CAAA02 CPK025
      **********                                                       //              CAAA02 CPK025
      **********   WaitTime = %diff(Now2Time:Now1Time:*SECONDS);       //              CAAA02 CPK025
      **********   if WaitTime >= MaxWaitTime;                         //              CAAA02 CPK025
      **********      *inu1 = '1';                                     //              CAAA02 CPK025
      **********   endif;                                              //              CAAA02 CPK025
      **********/end-free                                                                     CPK025
     C*
     C                   END
     C*
     C** IF COMMAND KEY 3 AND COMMAND KEY 5 NOT PRESSED, SCREEN
     C** NOT TIMED OUT AND ALL RECORDS READ ON COMPONENTS FILE
     C*
     C     *IN03         DOWNE     '1'
     C     *IN05         ANDNE     '1'
     C     *IN50         ANDNE     '1'
     C     *INU1         ANDNE     '1'
     C     *IN43         ANDNE     '0'
     C*
     C** DO UNTIL NO ERRORS INPUT TO SCREEN OR
     C** COMMAND KEY 3 AND COMMAND KEY 5 NOT
     C** PRESSED, SCREEN NOT TIMED OUT AND
     C** ALL RECORDS READ ON COMPONENTS FILE
     C*
     C     *IN77         DOUEQ     '0'
     C     *IN03         OREQ      '1'
     C     *IN05         OREQ      '1'
     C     *INU1         OREQ      '1'
     C*
     C** SET OFF SCREEN ERROR INDICATOR AND SET RRN TO 1
     C*
     C                   SETOFF                                       77
     C                   Z-ADD     1             RRN
     C*
     C** CHAIN TO FIRST RECORD ON SUBFILE
     C*
     C     RRN           CHAIN     CB0065S0                           50
     C*
     C** DO WHILE RECORDS FOUND IN SUBFILE
     C*
     C     *IN50         DOWNE     '1'
     C     *INU1         ANDNE     '1'
     C*
     C** SET ON SFLDSP AND SFLDSPCTL INDICATORS
     C*
     C                   SETON                                        2021
     C*
     C** IF COMPONENT HAS NOT BEEN RESTARTED (CHKINP
     C** NOT EQUAL TO 2) CHECK VALUE ENTERED IN RESTART
     C** FIELD USING SUBROUTINE FLDCHK
     C*
     C     CHKINP        IFNE      2
     C*
     C                   EXSR      FLDCHK
     C*
     C                   END
     C*
     C** ADD 1 TO RRN AND CHAIN FOR NEXT RECORD IN SUBFILE
     C*
     C                   ADD       1             RRN
     C     RRN           CHAIN     CB0065S0                           50
     C*
     C                   END
     C*
     C** IF ERROR INDICATOR SET ON BY SUBROUTINE
     C** FLDERR WRITE SCREEN WITH ERROR MESSAGE
     C*
     C     *IN77         IFEQ      '1'
     C                   WRITE     CB0065C0
     C                   WRITE     CB0065F2
     C************       READ      CB0065DF                             U145                  CAAA02
     C                   READ      CB0065DF                             U145                  CPK025
      **********/free                                                                         CPK025
      **********   Now1Time = %time();                                    //           CAAA02 CPK025
      **********                                                          //           CAAA02 CPK025
      **********   read CB0065F2;                                         //           CAAA02 CPK025
      **********   if %eof;                                               //           CAAA02 CPK025
      **********      *in45='1';                                          //           CAAA02 CPK025
      **********   endif;                                                 //           CAAA02 CPK025
      **********                                                          //           CAAA02 CPK025
      **********   Now2Time = %time();                                    //           CAAA02 CPK025
      **********                                                          //           CAAA02 CPK025
      **********   WaitTime = %diff(Now2Time:Now1Time:*SECONDS);          //           CAAA02 CPK025
      **********   if WaitTime >= MaxWaitTime;                            //           CAAA02 CPK025
      **********      *inu1 = '1';                                        //           CAAA02 CPK025
      **********   endif;                                                 //           CAAA02 CPK025
      **********/end-free                                                                     CPK025
     C*
     C                   END
     C*
     C                   END
     C*
     C** IF COMMAND KEYS 3 AND 5 NOT PRESSED
     C** AND SCREEN NOT TIMED OUT
     C*
     C     *IN03         IFEQ      '0'
     C     *IN05         ANDEQ     '0'
     C     *INU1         ANDNE     '1'
     C*
     C** SET OFF SCREEN ERROR INDICATOR AND
     C** WRITE SCREEN FOR FURTHER INPUT
     C*
     C                   SETOFF                                       60
     C                   SETOFF                                       21
     C                   WRITE     CB0065F3
     C                   WRITE     CB0065F2
     C                   SETON                                        21
     C                   WRITE     CB0065C0
     C*
     C** READ SCREEN FOR DETAILS ENTERED
     C*
     C************       READ      CB0065DF                             U145                  CAAA02
     C                   READ      CB0065DF                             U145                  CPK025
      **********/free                                                                         CPK025
      **********   Now1Time = %time();                                 //              CAAA02 CPK025
      **********                                                       //              CAAA02 CPK025
      **********   read CB0065C0;                                      //              CAAA02 CPK025
      **********   if %eof;                                            //              CAAA02 CPK025
      **********      *in45='1';                                       //              CAAA02 CPK025
      **********   endif;                                              //              CAAA02 CPK025
      **********                                                       //              CAAA02 CPK025
      **********   Now2Time = %time();                                 //              CAAA02 CPK025
      **********                                                       //              CAAA02 CPK025
      **********   WaitTime = %diff(Now2Time:Now1Time:*SECONDS);       //              CAAA02 CPK025
      **********   if WaitTime >= MaxWaitTime;                         //              CAAA02 CPK025
      **********      *inu1 = '1';                                     //              CAAA02 CPK025
      **********   endif;                                              //              CAAA02 CPK025
      **********/end-free                                                                     CPK025
     C*
     C                   END
     C*
     C** SET SFLDSP, SFLDSPCTL AND SFLNXTCHG INDICATORS FOR
     C** PROCESSING FURTHER CHANGES TO SUBFILE RECORDS
     C*
     C                   SETON                                        24
     C                   SETOFF                                       2150
     C*
     C                   END
     C*
     C** IF COMMAND KEY 5 TAKEN TO REFRESH
     C** SCREEN AND SCREEN NOT TIMED OUT
     C*
     C     *IN05         IFEQ      '1'
     C     *INU1         ANDNE     '1'
     C*
     C** CLEAR SCREEN INPUT FIELD BEFORE REDISPLAYING SCREEN
     C*
     C                   MOVE      *BLANKS       RESTRT
     C*
     C** CLOSE AND REOPEN COMPONENTS FILE AND SET OFF
     C** INDICATORS TO CLEAR SUBFILE AND ALLOW FURTHER INPUT
     C*
     C                   CLOSE     CBCOMSL8
     C*
     C                   OPEN      CBCOMSL8
     C*
     C                   SETOFF                                       202143
     C                   SETOFF                                       60
     C                   WRITE     CB0065C0
     C                   WRITE     CB0065F3
     C*
     C                   Z-ADD     1             RRN
     C*
     C                   SETOFF                                       05
     C*
     C                   END
     C*
     C                   END
     C*
     C** CLOSE FAILED COMPONENTS FILE - CBCOMSL8
     C*
     C                   CLOSE     CBCOMSL8
     C*
      *                                                                                       CGP002
      * Update global dashboard                                                               CGP002
      *                                                                                       CGP002
     C     GLBUPD        IFEQ      'Y'                                                        CGP002
     C                   MOVEL     'GOC00'       UPDPGM           10                          CGP002
     C                   MOVE      '0101 '       UPDPGM                                       CGP002
     C                   MOVEL     '*PHASE'      PHASE            10                          CGP002
     C                   CALL      UPDPGM                                                     CGP002
     C                   PARM                    PHASE                                        CGP002
     C                   ENDIF                                                                CGP002
      *                                                                                       CGP002
     C                   SETON                                        LR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**
     C** INDEX OF SUBROUTINES
     C**
     C**
     C** FILLSB - FILL SUBFILE PROCESSING
     C** FLDCHK - CHECK VALUE ENTERED ON RESTART SCREEN
     C** FLDVAL - RESTART COMPONENT PROCESSING
     C** FLDERR - ERROR IN FIELD ENTRY PROCESSING
     C** DBERR  - DATABASE ERROR PROCESSING
     C**
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** SUBROUTINE TO FILL SUBFILE WITH
     C** RECORDS FROM COMPONENTS FILE CBCOMSL8
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C********************************************************************
     C*
     C** DO WHILE RECORDS ON FAILED COMPONENTS
     C*
     C     FILLSB        BEGSR
     C*
     C     *IN40         DOWEQ     '0'
     C*
     C** MOVE COMPONENT NAME AND SEQUENCE NUMBER
     C** INTO SUBFILE SCREEN FIELDS
     C*
     C                   MOVE      DHCOTT        SCCOT
     C                   MOVE      DHCSEQ        SCSEQ
     C                   MOVE      *BLANKS       RSTMSG
     C                   MOVE      DHCSEQ        SCSEQA
     C                   Z-ADD     0             CHKINP
     C*
     C** WRITE SUBFILE RECORD FORMAT,
     C** SET ON INDICATOR TO ACTIVATE SUBFILE
     C** AND READ NEXT RECORD ON COMPONENTS FILE
     C*
     C                   WRITE     CB0065S0
     C                   SETON                                        2021
     C*
     C                   READ      @CMPNHP                                40
     C*
     C** IF NOT END OF FILE ADD ONE TO RELATIVE RECORD NUMBER
     C*
     C     *IN40         IFNE      '1'
     C*
     C                   ADD       1             RRN
     C*
     C                   END
     C*
     C                   END
     C*
     C                   SETON                                        43
     C*
     C                   ENDSR
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** SUBROUTINE TO CHECK ENTRY INTO RESTART FIELD AND CALL
     C** SUBROUTINE EITHER TO RESTART COMPONENT OR WRITE ERROR MESSAGE
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS SUBROUTINES - FLDERR
     C*                    - FLDVAL
     C*
     C********************************************************************
     C*
     C     FLDCHK        BEGSR
     C*
     C** IF RESTART FIELD IS NOT 'R', 'E' OR BLANK
     C** CALL SUBROUTINE TO WRITE ERROR MESSAGE
     C*
     C     RESTRT        IFNE      'R'
     C     RESTRT        ANDNE     'E'
     C     RESTRT        ANDNE     'B'
     C     RESTRT        ANDNE     *BLANKS
     C                   EXSR      FLDERR
     C                   SETOFF                                       24
     C                   END
     C*
     C** IF RESTART FIELD IS 'R' THEN CALL
     C** SUBROUTINE TO RESTART COMPONENT
     C*
     C     RESTRT        IFEQ      'R'
     C                   MOVE      SCSEQA        SCSEQ
     C                   MOVE      'Y'           GLBUPD            1                          CGP002
     C                   EXSR      FLDVAL
     C                   SETOFF                                       24
     C                   END
     C*
     C** IF RESTART FIELD IS 'E' THEN DISPLAY
     C** JOB OF THE FAILED COMPONENT
     C*
     C     RESTRT        IFEQ      'E'
     C**********                                                                       CAAA02 CPK025
     C***Check*to see if the job is running in a webfacing environment                 CAAA02 CPK025
     C**********                                                                       CAAA02 CPK025
     C**********         Call      'SCWEBFACCK'                                        CAAA02 CPK025
     C**********         Parm                    Webfacing                             CAAA02 CPK025
     C**********                                                                       CAAA02 CPK025
     C**********         If        Webfacing = 'Y'                                     CAAA02 CPK025
     C**********                                                                       CAAA02 CPK025
     C***Access*CBAUDTL1 to get job, user and job number.                              CAAA02 CPK025
     C**********         MOVE      SCSEQA        CSEQP                                 CAAA02 CPK025
     C*****AKEY*         SETGT     CBAUDTL1                                            CAAA02 CPK025
     C*****AKEY*         READPE    CBAUDTL1                               78           CAAA02 CPK025
     C**********                                                                              CPK025
     C******IN78         IFEQ      '1'                                                        CPK025
     C**********         MOVE      ERRMSG(2)     MSG                                          CPK025
     C**********         SETON                                        246077                  CPK025
     C**********         UPDATE    CB0065S0                                                   CPK025
     C**********         ELSE                                                                 CPK025
     C******ie,*no error in accessing job details. Call program to display spooled     CAAA02 CPK025
     C**********files for the job, user and job number.                                CAAA02 CPK025
     C**********         UNLOCK    LDA                                                 CAAA02 CPK025
     C**********         MOVE      JONBR         P1NBRA            6                   CAAA02 CPK025
     C**********         CALL      'CBC0066'                            81             CAAA02 CPK025
     C**********         PARM      JOJOB         P1JOB            10                   CAAA02 CPK025
     C**********         PARM      JOUSER        P1USER           10                   CAAA02 CPK025
     C**********         PARM                    P1NBRA                                CAAA02 CPK025
     C**********         PARM      *BLANK        P1RTN            10                   CAAA02 CPK025
     C**********                                                                       CAAA02 CPK025
     C******IN81         IFEQ      '1'                                                 CAAA02 CPK025
     C*****P1RTN         ORNE      *BLANKS                                             CAAA02 CPK025
     C**********         MOVE      ERRMSG(4)     MSG                                   CAAA02 CPK025
     C**********         SETON                                        246077           CAAA02 CPK025
     C**********         UPDATE    CB0065S0                                            CAAA02 CPK025
     C**********         ELSE                                                          CAAA02 CPK025
     C***ie,*no*error on displaying spooled files for the job                          CAAA02 CPK025
     C**********         MOVE      *BLANKS       RESTRT                                       CPK025
     C**********         UPDATE    CB0065S0                                                   CPK025
     C**********         ENDIF                                           FI *IN81 = 1  CAAA02 CPK025
      **********                                                    or P1RTN <> Blank  CAAA02 CPK025
     C**********         END                                                                  CPK025
     C**********                                                                              CPK025
     C**********         Else                                                          CAAA02 CPK025
     C**********                                                                       CAAA02 CPK025
     C** ACCESS JOB DETAILS FOR QCMDEXC USING SUBROUTINE JOBDET                               CAAA02
     C*                                                                                       CAAA02
     C                   EXSR      JOBDET                                                     CAAA02
     C**                                                                                      CAAA02
     C                   Z-ADD     40            LENQ                                         CAAA02
     C                   CALL      'QCMDEXC'                            78                    CAAA02
     C                   PARM                    PMS                                          CAAA02
     C                   PARM                    LENQ             15 5                        CAAA02
     C*                                                                                       CAAA02
     C     *IN78         IFEQ      '1'                                                        CAAA02
     C                   MOVE      ERRMSG(2)     MSG                                          CAAA02
     C                   SETON                                        246077                  CAAA02
     C                   UPDATE    CB0065S0                                                   CAAA02
     C                   Else                                                                 CPK025
     C                   MOVE      *BLANKS       RESTRT                                       CPK025
     C                   UPDATE    CB0065S0                                                   CPK025
     C                   Endif                                                                CAAA02
     C**********         Endif                                                         CAAA02 CPK025
     C                   END
     C*
     C** IF RESTART FIELD IS 'B' THEN CHECK THE ALLOW BYPASS FIELD
     C*
     C     RESTRT        IFEQ      'B'
      *
     C** CALL ACCESS OBJECT AOCOBPR0 TO ACCESS COB ICD FILE
     C*
     C                   CALL      'AOCOBPR0'
     C                   PARM      '*MSG   '     P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDCOBP        PARM      SDCOBP        DSFDY
     C*
     C     P@RTCD        IFNE      *BLANKS
     C                   MOVEL     'AOCOB'       DBFILE
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   Z-ADD     3             DBASE                          * DB ERROR 03 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** DISPLAY ERROR MESSAGE IF ALLOW BYPASS IS NO
     C*
     C     DOABIC        IFEQ      'N'
     C                   EXSR      FLDERR
     C                   SETOFF                                       24
     C                   END
     C*
     C** CHECK IF THE COMPONENT CANNOT BE BYPASSED
     C*
     C     DOABIC        IFEQ      'Y'
     C*
     C** DISPLAY ERROR MESSAGE IF COMPONENT CANNOT BE BYPASSED
     C*
     C     DHABIC        IFEQ      'N'
     C                   MOVE      ERRMSG(3)     MSG
     C                   Z-ADD     1             CHKINP
     C                   SETON                                        246077
     C                   UPDATE    CB0065S0
     C*
     C                   ELSE
     C*
     C                   UNLOCK    LDA
     C                   MOVE      'Y'           GLBUPD                                       CGP002
     C                   CALL      'CB0500'                             75
     C                   PARM                    SCCOT
     C     WSEQR         PARM      SCSEQA        WSEQP
     C     *LOCK         IN        LDA
     C*
     C     *IN75         IFEQ      '0'
     C     WSEQR         ANDNE     '99999'
     C*
     C** MOVE BYPASSED MESSAGE TO COMPONENT FIELD
     C*
     C                   MOVEA     RSTARR(2)     RSTMSG
     C*
     C** BLANK AND PROTECT INPUT FIELD, UPDATE HIDDEN
     C** FIELD ON SUBFILE AND CLEAR ERROR MESSAGE FIELD
     C*
     C                   MOVE      *BLANKS       RESTRT
     C                   SETON                                        2465
     C                   SETOFF                                       60
     C                   Z-ADD     2             CHKINP
     C*
     C** UPDATE SUBFILE RECORD
     C*
     C                   UPDATE    CB0065S0
     C                   SETOFF                                       65
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C*
     C** IF RESTART FIELD IS BLANK AND ENTRY HAS
     C** PREVIOUSLY BEEN MADE TO FIELD THEN RESET
     C** FIELD USED HIDDEN FIELD (CHKINP) TO ZERO
     C*
     C     RESTRT        IFEQ      *BLANKS
     C     CHKINP        ANDEQ     1
     C     RRN           CHAIN     CB0065S0                           50
     C                   Z-ADD     0             CHKINP
     C                   SETOFF                                       60
     C                   SETON                                        24
     C                   UPDATE    CB0065S0
     C                   SETOFF                                       24
     C                   END
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** SUBROUTINE TO UPDATE COMPONENTS FILE AND SEND
     C** MESSAGE TO DATA QUEUE IF RESTART VALUE IS 'Y'
     C*
     C** CALLED FROM SUBROUTINE FLDCHK
     C*
     C** CALLS DATABASE ERROR SUBROUTINE
     C*
     C********************************************************************
     C*
     C     FLDVAL        BEGSR
     C*
     C** SET UP PACKED FIELD FOR KEY TO CHAIN
     C** TO COMPONENTS FILE USING SCREEN DETAILS
     C*
     C                   MOVE      SCSEQA        SCSEQP
     C*
     C** OPEN COMPONENTS FILE CBCOMSL0 FOR UPDATE
     C*
     C                   OPEN      CBCOMSL0
     C*
     C     CKEY          CHAIN     @DHREGG                            55
     C*
     C     *IN55         IFEQ      '1'
     C                   MOVE      SCCOT         SCCOTX
     C                   MOVE      SCSEQ         SCSEQX
     C                   MOVEL     'CMPL0'       DBFILE
     C                   MOVEL     CKEYDS        DBKEY                          ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   EXSR      DBERR                                        ***************
     C                   END
      *
     C     DHCSTS        IFEQ      'A'
     C*
     C** UPDATE COMPONENT STATUS TO RESTART AND
     C** SCHEDULING PRIORTY TO 1 ON COMPONENT FILE
     C*
     C                   MOVE      'R'           DHCSTS
     C                   MOVE      1             DHCSHP
     C                   EXCEPT    REST
     C*
     C** SET UP PARAMETERS FOR PROGRAM TO SEND MESSAGE TO DATA QUEUE
     C*
     C                   MOVEL     'CBDTQA'      DTAQ
     C                   MOVEL     '*LIBL'       LIB
     C                   Z-ADD     16            LEN
     C                   MOVE      'R'           RESTT
     C                   MOVE      DTMSG         DTQMSG           16
     C*
     C                   CALL      'QSNDDTAQ'
     C                   PARM                    DTAQ             10
     C                   PARM                    LIB              10
     C                   PARM                    LEN               5 0
     C                   PARM                    DTQMSG
     C*
     C** MOVE RESTARTED MESSAGE TO COMPONENT FIELD
     C*
     C                   MOVEA     RSTARR(1)     RSTMSG
     C*
     C** BLANK AND PROTECT INPUT FIELD, UPDATE HIDDEN
     C** FIELD ON SUBFILE AND CLEAR ERROR MESSAGE FIELD
     C*
     C                   MOVE      *BLANKS       RESTRT
     C                   SETON                                        2465
     C                   SETOFF                                       60
     C                   Z-ADD     2             CHKINP
     C*
     C** UPDATE SUBFILE RECORD
     C*
     C                   UPDATE    CB0065S0
     C                   SETOFF                                       65
     C*
     C** CLOSE UPDATE FILE CBCOMSL0
     C*
     C                   CLOSE     CBCOMSL0
     C*
     C** ATTEMPT TO OBTAIN A LOCK ON CBSTAT.RETRY UNTIL SUCCESSFUL
     C*
     C     *IN71         DOUEQ     '0'
     C     *LOCK         IN        CBSTAT                               71
     C                   END
     C*
     C** SUBTRACT ONE FROM NUMBER OF FAILED
     C** COMPONENTS FIELD ON CBSTAT
     C*
     C                   SUB       1             CBFAIL
     C*
     C** UPDATE CBSTAT
     C*
     C                   OUT       CBSTAT
      *
      ** '*ALREADY STARTED'
     C                   ELSE
     C                   MOVEA     RSTARR(3)     RSTMSG
      *
     C                   ENDIF
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** SUBROUTINE TO WRITE MESSAGE IF RESTART
     C** VALUE IS NOT 'Y'
     C*
     C** CALLED FROM SUBROUTINE FLDCHK
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C********************************************************************
     C*
     C     FLDERR        BEGSR
     C*
     C** DO WHILE RESTART FIELD VALUE VALID OR BLANK
     C** AND COMMAND KEYS 3 AND 5 NOT PRESSED
     C*
     C     *IN03         IFNE      '1'
     C     *IN05         ANDNE     '1'
     C     *IN50         ANDNE     '1'
     C     *INU1         ANDNE     '1'
     C*
     C** SET ON ERROR INDICATORS AND WRITE ERROR
     C** MESSAGE, UPDATE HIDDEN FIELD ON SUBFILE
     C** AND CLEAR ERROR MESSAGE FIELD
     C*
     C                   SETON                                        6077
     C                   MOVE      ERRMSG(1)     MSG
     C                   Z-ADD     1             CHKINP
     C                   SETON                                        24
     C                   UPDATE    CB0065S0
     C*
     C                   END
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*                                                                  *                    LN0989
     C*  SUBROUTINE TO SET UP JOB DETAILS FOR DSPJOB COMMAND             *                    LN0989
     C*                                                                  *                    LN0989
     C*  CALLED FROM SUBROUTINE FLDCHK                                   *                    LN0989
     C*                                                                  *                    LN0989
     C*  CALLS NO OTHER SUBROUTINES                                      *                    LN0989
     C*                                                                  *                    LN0989
     C********************************************************************                    LN0989
     C*                                                                                       LN0989
      **                                                                                      LN0989
     C     JOBDET        BEGSR                                                                LN0989
     C                   MOVE      SCSEQA        CSEQP                                        LN0989
     C     AKEY          SETGT     CBAUDTL1                           87                      LN0989
     C                   READP     CBAUDTL1                               88                  LN0989
      *                                                                                       LN0989
      ** ADJUST JOB NAME TO COMPRESS OUT SPACES                                               LN0989
      *                                                                                       LN0989
     C                   MOVEA     *BLANK        JOB                                          LN0989
      *                                                                                       LN0989
     C                   MOVE      JONBR         JOBA              6                          LN0989
     C                   MOVEA     JOBA          JOB                                          LN0989
     C                   Z-ADD     7             X                 2 0                        LN0989
     C                   MOVE      '/'           JOB(X)                                       LN0989
     C                   ADD       1             X                                            LN0989
     C                   MOVEA     JOUSER        JOB(X)                                       LN0989
     C     ' '           LOOKUP    JOB(X)                                 79                  LN0989
     C                   MOVE      '/'           JOB(X)                                       LN0989
     C                   ADD       1             X                                            LN0989
     C                   MOVEA     JOJOB         JOB(X)                                       LN0989
     C     ' '           LOOKUP    JOB(X)                                 79                  LN0989
     C                   MOVE      ')'           JOB(X)                                       LN0989
      *                                                                                       LN0989
      ** CALL ACCESS OBJECT AOCOBPR0 TO ACCESS COB ICD FILE                                   E27295
      *                                                                                       E27295
     C                   CALL      'AOCOBPR0'                                                 E27295
     C                   PARM      '*MSG   '     P@RTCD            7                          E27295
     C                   PARM      '*FIRST '     P@OPTN            7                          E27295
     C     SDCOBP        PARM      SDCOBP        DSFDY                                        E27295
     C**                                                                                      E27295
     C     P@RTCD        IFNE      *BLANKS                                                    E27295
     C                   MOVEL     'AOCOB'       DBFILE                                       E27295
     C                   MOVE      *BLANKS       DBKEY                          **************E27295
     C                   Z-ADD     2             DBASE                          * DB ERROR 02 E27295
     C                   EXSR      DBERR                                        **************E27295
     C                   END                                                                  E27295
     C**                                                                                      E27295
     C     DOAQCM        IFEQ      'Y'                                                        E27295
     C                   MOVEA     DJ1(2)        JBCMD                                        E27295
     C                   ELSE                                                                 E27295
     C                   MOVEA     DJ1(1)        JBCMD                                        E27295
     C                   END                                                                  E27295
     C**                                                                                      E27295
     C                   MOVEA     JOB           JBDTL                                        E27295
     C**                                                                                      E27295
     C                   ENDSR                                                                E27295
     C********************************************************************                    E27295
     C/EJECT                                                                                  E27295
     C********************************************************************                    E27295
     C*
     C** DATABASE ERROR SUBROUTINE TO PERFORM DATABASE ERROR
     C** EXIT FROM PROGRAM
     C*
     C** CALLED FROM SUBROTINE FLDVAL
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C********************************************************************
     C*
     C     DBERR         BEGSR
     C*
     C** SETON INDICATORS U7 U8 LR AND RETURN TO CALLING PROGRAM
     C*
     C                   SETON                                        U7U8LR
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C********************************************************************
      /EJECT
     O********************************************************************
     O*
     O**   UPDATE STATUS AND SCHEDULING PRIORITY ON COMPONENTS FILE
     O*
     O@DHREGG   E            REST
     O*
     O                       DHCSTS
     O                       DHCSHP
     O*
     O********************************************************************
      /EJECT
**CTDATA ERRMSG
INVALID OPTION ENTERED
UNABLE TO ACCESS JOB INFORMATION
THIS COMPONENT MAY NOT BE BYPASSED
**CTDATA RSTARR
*** RESTARTED ***
*** BYPASSED ***
*ALREADY STARTED*
**CTDATA DJ1
DSPJOB JOB(
WRKJOB JOB(
