     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CB Close of business halt Menu')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Close of Business Processing                         *
     F*                                                               *
     F*  CB0020 - CLOSE OF BUSINESS HALT MENU                         *
     F*                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK025             Date 23Nov06               *
      *  Prev Amend No. CAAA02             Date 16Jul03               *
      *  Converted to ILE and code-stripped                           *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 108076             DATE 16SEP96               *
      *                 LN0545             DATE 20JUL90               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  CPK025 - Revert back fix of CAAA02                           *
      *  CAAA02 - Remove use of INVITE keyword to enable WebFacing    *
      *           to process screens.                                 *
      *           This program must read formats rather than a file.  *
     F*  108076 - ADDTIONAL OPTION FOR HALT FOR MODULE MAINTENANCE    *
     F*  LN0545 - RE-TRY THE LOCK OF CBSTAT TO AVOID POTENTIAL        *
     F*           COB CRASH AS A NUMBER OF PROGRAMS PERFORM THE       *
     F*           *LOCK TO UPDATE THE DATA AREA                       *
     F*****************************************************************
     F*                                                               *
     FCB0020DF  CF   E             WORKSTN
     F                                     MAXDEV(*FILE)
     FCBCOMSL0  IF   E           K DISK    USROPN
     F*
      /SPACE 2
     F********************************************************************
     F*
     F*     C  L   FUNCTION OF INDICATORS
     F*
     F*    03      COMMAND KEY F03
     F*    34      DISPLAY OPTION 4 - REQUEST IMMEDIATE HALT
     F*    35      DISPLAY OPTION 5 - HALT FOR MODULES MAINTENANCE
     F*    50      FAIL ON READ OF DISPLAY FILE - CB0020DF
     F*    60      INVALID ENTRY ON SCREEN
     F*    65      ALLOW USE OF F6/F12 FOR IMMEDIATE HALT
     F*    70      RE-TRY LOCK OF DATA AREA
     F*
     F*    U1      SCREEN TIMED OUT
     F*    U7&U8   DATABASE ERROR
     F*
     F*****************************************************************
     F/EJECT
     D*
     D** COPYRIGHT ARRAY
     D*
     D OPTINV          S             78    DIM(2) CTDATA PERRCD(1)
     D** INVALID OPTION ERROR MESSAGE ARRAY
     D*
     D OPTERR          S             78    DIM(4) CTDATA PERRCD(1)
     D** OPTION ENDED IN ERROR ERROR MESSAGE ARRAY
     D*
     D*****************************************************************
     D/EJECT
     D*
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                179    180
     D  DBASE                181    183  0
     D** LOCAL DATA AREA
     D*
     D CBSTAT          DS            50
     D  JBSTHT                20     20
     D** CBSTAT DATA AREA
     D*
     D ERARR           DS
     D  ERRSTR                 1     78
     D  OPTION                 8      8
     D** SET UP ERROR OPTION NUMBER FOR ARRAY OPTERR
     D*
     D SCTIM           DS
     D  SCTIME                 1      6  0
     D  SCHRS                  1      2  0
     D  SCMIN                  3      4  0
     D  SCSEC                  5      6  0
     D** DATA STRUCTURE TO SPLIT SYSTEM TIME INTO HRS, MINS & SECS
     D*
     D DPTIME          DS
     D  DPHRS                  1      2
     D  DPHRSA                 1      1
     D  COLON1                 3      3
     D  DPMIN                  4      5
     D  COLON2                 6      6
     D  DPSEC                  7      8
     D** DATA STRUCTURE TO CONVERT SYSTEM TIME FOR DISPLAY (HH:MM:SS)
     D*
     D RUNDAT          DS            13
     D  AGMRDT                 1      7
     D** DATA STRUCTURE TO GET DATE FROM RUNDAT DATA AREA
     D*
     D PSDS           SDS
     D  WSID                 244    253
     D  USRID                254    263
      **********                                                                       CAAA02 CPK025
      **WaitTime is the time from WRITE to READ                                        CAAA02 CPK025
     d*WaitTime        s              5p 0                                             CAAA02 CPK025
     d*MaxWaitTime     s              5p 0 inz(600)                                    CAAA02 CPK025
      **********                                                                       CAAA02 CPK025
      **Now1Time is the time before the READ and Now2Time the time after               CAAA02 CPK025
     d*Now1Time        s               t                                               CAAA02 CPK025
     d*Now2Time        s               t                                               CAAA02 CPK025
      **********                                                                       CAAA02 CPK025
     I** DATA STRUCTURE FOR WORKSTATION ID FOR SCREEN OUTPUT
     I*
     I*****************************************************************
     I/EJECT
     C*
     C** DEFINE DATA AREA LDA AND LOCK TO SET
     C** UP PROGRAM NAME FOR DATABASE ERRORS
     C*
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'CB0020  '    DBPGM
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
     C*
     C**  GET RUN DATE FROM DATA AREA RUNDAT
     C*
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      AGMRDT        RUNA
     C                   UNLOCK    RUNDAT
     C*
     C** DO WHILE KEY F3 NOT PRESSED AND SCREEN NOT TIMED OUT
     C*
     C     *IN03         DOWNE     '1'
     C     *INU1         ANDNE     '1'
     C*
     C** DEFINE DATA AREA CBSTAT AND LOCK TO CHECK
     C** IF JOB STREAMS ARE NOT HALTED SET ON INDICATOR
     C** TO DISPLAY 'REQUEST IMMEDIATE HALT' OPTION
     C*
     C     *DTAARA       DEFINE                  CBSTAT
     C*
     C     *IN70         DOUEQ     '0'
     C     *LOCK         IN        CBSTAT                               70
     C                   END
     C*
     C     JBSTHT        IFEQ      'N'
     C                   SETON                                        34
     C                   END
     C*
     C** UNLOCK DATA AREA CBSTAT
     C*
     C                   OUT       CBSTAT
     C*
     C** SET UP CURRENT TIME FOR DISPLAY ON SCREEN
     C*
     C                   TIME                    TIMDAT           12 0
     C                   MOVEL     TIMDAT        SCTIME            6 0
     C                   MOVE      ':'           COLON1
     C                   MOVE      ':'           COLON2
     C                   MOVE      SCHRS         DPHRS
     C                   MOVE      SCMIN         DPMIN
     C                   MOVE      SCSEC         DPSEC
     C     DPHRSA        IFEQ      '0'
     C                   MOVE      *BLANKS       DPHRSA
     C                   END
     C                   MOVE      DPTIME        SCCURT
     C*
     C** WRITE HEADER AND SELECTION FORMATS TO SCREEN
     C** AND READ FOR SELECTION OR TIME OUT
     C*
     C*
     C                   EXSR      DISPLY
     C*
     C                   WRITE     CB0020F0
     C                   WRITE     CB0020F1
     C************       READ      CB0020DF                             U150    CAAA02
     C                   READ      CB0020DF                             U150                  CPK025
      **********/free                                                                         CPK025
      **********   Now1Time = %time();                                               //CAAA02 CPK025
      **********                                                                     //CAAA02 CPK025
      **********   read CB0020F1;                                                    //CAAA02 CPK025
      **********   if %eof;                                                          //CAAA02 CPK025
      **********      *in50='1';                                                     //CAAA02 CPK025
      **********   endif;                                                            //CAAA02 CPK025
      **********                                                                     //CAAA02 CPK025
      **********   Now2Time = %time();                                               //CAAA02 CPK025
      **********                                                                     //CAAA02 CPK025
      **********   WaitTime = %diff(Now2Time:Now1Time:*SECONDS);                     //CAAA02 CPK025
      **********   if WaitTime >= MaxWaitTime;                                       //CAAA02 CPK025
      **********      *inu1 = '1';                                                   //CAAA02 CPK025
      **********   endif;                                                            //CAAA02 CPK025
      **********/end-free                                                                     CPK025
     C*
     C** IF KEY F3 NOT PRESSED AND SCREEN NOT TIMED
     C** OUT THEN CHECK VALIDITY OF ENTRY MADE
     C*
     C     *IN03         IFNE      '1'
     C     *INU1         ANDNE     '1'
     C*
     C** SET OFF SCREEN ERROR INDICATORS
     C*
     C                   SETOFF                                       60
     C*
     C** IF VALUE ENTERED IS NOT 1, 2, 3, 4 OR 5
     C** OR 4 IS ENTERED AND OPTION 4 IS NOT DISPLAYED
     C** OR 5 IS ENTERED AND OPTION 5 IS NOT DISPLAYED
     C** SET ON ERROR INDICATOR AND SET UP ERROR
     C** MESSAGE AS 'ENTRY MUST BE VALID OPTION'
     C*
     C     SELHLT        IFNE      '1'
     C     SELHLT        ANDNE     '2'
     C     SELHLT        ANDNE     '3'
     C     SELHLT        ANDNE     '4'
     C     SELHLT        ANDNE     '5'
     C     SELHLT        OREQ      '4'
     C     *IN34         ANDNE     '1'
     C     SELHLT        OREQ      '5'
     C     *IN35         ANDNE     '1'
     C*
     C                   SETON                                        60
     C                   MOVE      OPTINV(1)     ERRMSG
     C*
     C** ELSE CALL HALT PROGRAM REQUESTED
     C*
     C                   ELSE
     C*
     C** IF VALUE = 1 CALL REQUEST TIMED HALT PROGRAM CB0030
     C*
     C     SELHLT        IFEQ      '1'
     C                   CALL      'CBC0026'
     C                   PARM      'CB0030'      PROG             10
     C                   PARM                    ERROR
     C                   END
     C*
     C** IF VALUE = 2 CALL REQUEST HALT BEFORE COMPONENT PROGRAM CB0040
     C*
     C     SELHLT        IFEQ      '2'
     C                   CALL      'CBC0026'
     C                   PARM      'CB0040'      PROG
     C                   PARM                    ERROR
     C                   END
     C*
     C** IF VALUE = 3 CALL REQUEST HALT AFTER COMPONENT PROGRAM CB0045
     C*
     C     SELHLT        IFEQ      '3'
     C                   CALL      'CBC0026'
     C                   PARM      'CB0045'      PROG
     C                   PARM                    ERROR
     C                   END
     C*
     C** IF VALUE = 4 CALL REQUEST IMMEDIATE HALT PROGRAM CBC0035
     C*
     C     SELHLT        IFEQ      '4'
     C*
     C** SET MESSAGE FIELD AND ALLOW USE OF KEYS F6 AND F12
     C*
     C                   MOVE      OPTINV(2)     ERRMSG
     C                   SETON                                        6065
     C*
     C** WRITE SELECTION FORMAT (CB0020F1) TO SCREEN
     C*
     C                   EXSR      DISPLY
     C*
     C                   WRITE     CB0020F1
     C*
     C** DO WHILE F3, F6 AND F12 NOT PRESSED, SCREEN NOT TIMED OUT
     C*
     C     *IN03         DOWEQ     '0'
     C     *IN06         ANDEQ     '0'
     C     *IN12         ANDEQ     '0'
     C     *INU1         ANDEQ     '0'
     C*
     C************       READ      CB0020DF                             U150    CAAA02
     C                   READ      CB0020DF                             U150                  CPK025
      **********/free                                                                         CPK025
      **********   Now1Time = %time();                                               //CAAA02 CPK025
      **********                                                                     //CAAA02 CPK025
      **********   read CB0020F1;                                                    //CAAA02 CPK025
      **********   if %eof;                                                          //CAAA02 CPK025
      **********      *in50='1';                                                     //CAAA02 CPK025
      **********   endif;                                                            //CAAA02 CPK025
      **********                                                                     //CAAA02 CPK025
      **********   Now2Time = %time();                                               //CAAA02 CPK025
      **********                                                                     //CAAA02 CPK025
      **********   WaitTime = %diff(Now2Time:Now1Time:*SECONDS);                     //CAAA02 CPK025
      **********   if WaitTime >= MaxWaitTime;                                       //CAAA02 CPK025
      **********      *inu1 = '1';                                                   //CAAA02 CPK025
      **********   endif;                                                            //CAAA02 CPK025
      **********/end-free                                                                     CPK025
     C                   SETON                                        65
     C                   WRITE     CB0020F1
     C*
     C                   END
     C                   SETOFF                                       65
     C*
     C** IF KEY F6 PRESSED AND SCREEN NOT TIMED OUT CALL IMMEDIATE
     C** HALT, THEN RESET INDICATORS AND BLANK MESSAGE ON SCREEN.
     C*
     C     *IN06         IFEQ      '1'
     C     *INU1         ANDEQ     '0'
     C                   CALL      'CBC0026'
     C                   PARM      'CBC0035'     PROG
     C                   PARM                    ERROR             1
     C                   END
     C                   SETOFF                                       6065
     C                   WRITE     CB0020F2
     C                   END
     C*
     C*
     C** IF VALUE = 5 CALL HALT FOR MODULE MAINTENANCE CB0047
     C*
     C     SELHLT        IFEQ      '5'
     C*
     C* INITIALISE 'RETURN' FIELD
     C*
     C                   MOVE      *BLANKS       RETURN
     C*
     C/COPY CBCPYSRC,CB0020CHT5
     C*
     C                   CALL      'CB0047'
     C                   PARM                    CNAME            10
     C                   PARM                    NUMBER            5
     C                   PARM                    AFTMDE            1
     C                   PARM                    RETURN            5
     C*
     C* SELECT THE ERROR MESSAGE OTHERWISE EVERYTHING IS OKAY
     C*
     C                   SELECT
     C*
     C     RETURN        WHENEQ    '*NRF'
     C                   Z-ADD     2             X                 1 0
     C                   MOVE      'Y'           ERROR
     C                   MOVE      *OFF          *IN35
     C*
     C     RETURN        WHENEQ    '*COMP'
     C                   Z-ADD     3             X                 1 0
     C                   MOVE      'Y'           ERROR
     C*
     C     RETURN        WHENEQ    '*FAIL'
     C                   Z-ADD     4             X                 1 0
     C                   MOVE      'Y'           ERROR
     C*
     C                   ENDSL
     C*
     C*
     C                   EXSR      DISPLY
     C*
     C                   ENDIF
     C*
     C** IF ERROR PARAMETER PASSED BACK FROM CBC0026
     C** IS 'Y' SET ON ERROR INDICATOR AND SET UP ERROR
     C** MESSAGE AS 'OPTION X ENDED IN ERROR'
     C*
     C     ERROR         IFEQ      'Y'
     C                   SETON                                        60
     C                   MOVE      OPTERR(X)     ERRSTR
     C                   MOVE      SELHLT        OPTION
     C                   MOVEL     ERRSTR        ERRMSG
     C                   WRITE     CB0020F2
     C                   END
     C*
     C** IF ERROR PARAMETER PASSED BACK FROM CBC0026
     C** IS 'T' SET ON SCREEN TIMED OUT INDICATOR
     C*
     C     ERROR         IFEQ      'T'
     C                   SETON                                        U1
     C                   END
     C*
     C** IF VALID OPTION TAKEN CLEAR SCREEN INPUT FIELD
     C*
     C     ERROR         IFNE      'Y'
     C     ERROR         ANDNE     'T'
     C                   MOVE      *BLANKS       SELHLT
     C                   WRITE     CB0020F2
     C                   SETOFF                                       34
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C                   SETON                                        LR
     C*
     C*****************************************************************
     C*                                                               *
     C*  DISPLY - Subroutine to Determine if option 5 should be       *
     C*           optional or non-optional.                           *
     C*                                                               *
     C*  Called By: Main Processing                                   *
     C*  Calls: None.                                                 *
     C*                                                               *
     C*****************************************************************
     C*
     C     DISPLY        BEGSR
     C                   OPEN      CBCOMSL0
     C*
     C* MAKE A KEYLIST FOR SEARCH ARGUMENT
     C*
     C     COMBKY        KLIST
     C                   KFLD                    CNAME
     C                   KFLD                    NUMBER
     C*
     C* READ THE LOGICAL FILE SO TO OBTAIN VALUES FOR DHCHTA & DHCSTS
     C*
     C/COPY CBCPYSRC,CB0020CHT5
     C*
     C     COMBKY        CHAIN     CBCOMSL0                           92
     C*
     C     *IN92         IFEQ      *OFF
     C     DHCHTA        IFEQ      'N'
     C     DHCSTS        ANDEQ     *BLANKS
     C                   MOVE      *ON           *IN35
     C                   ELSE
     C                   MOVE      *OFF          *IN35
     C                   ENDIF
     C                   ENDIF
     C*
     C                   CLOSE     CBCOMSL0
     C                   ENDSR
     C*
     C/EJECT
     C********************************************************************
**CTDATA OPTINV
ENTRY MUST BE A VALID OPTION NUMBER
PRESS F6 TO CONFIRM OR F12 TO CANCEL REQUEST FOR IMMEDIATE HALT
**CTDATA OPTERR
OPTION   ENDED IN ERROR
OPTION   RECORD NOT FOUND IN FILE
OPTION   COMPONENT HAS ALREADY STARTED/COMPLETED PROCESSING
OPTION   HALT REQUEST HAS FAILED
