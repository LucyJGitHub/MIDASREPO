     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CB Request halt before component')               *
     F*****************************************************************
     F*                                                               *
     F*  Midas - Close of Business Processing                         *
     F*                                                               *
     F*  CB0040 - REQUEST HALT BEFORE A COMPONENT IS RUN              *
     F*                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                               *
      *  Last Amend No. CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK025             Date 23Nov06               *
      *                 CAAA02             Date 16Jul03               *
      *  Converted to ILE and code-stripped                           *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 LN0397            DATE  20JUN90               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CPK025 - Revert back fix of CAAA02                           *
      *  CAAA02 - Remove use of INVITE keyword to enable WebFacing    *
      *           to process screens.                                 *
      *           This program must read formats rather than a file.  *
     F*  LN0397 - ADDITION OF HELP TO COB SCREENS                     *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     FCBHALTDF  CF   E             WORKSTN
     F                                     MAXDEV(*FILE)
     FCBCOMSL0  UF   E           K DISK    USROPN
     F*
      /SPACE 2
     F********************************************************************
     F*
     F*     C  L   FUNCTION OF INDICATORS
     F*
     F*    03      COMMAND KEY 3 PRESSED
     F*    06      COMMAND KEY 6 PRESSED
     F*    12      COMMAND KEY 12 PRESSED
     F*    40      DATABASE ERROR ON READ ON DISPLAY FILE
     F*    45      FAIL ON CHAIN TO CBCOMSL0 - FILE BLANK
     F*    46      FAIL ON CHAIN TO CBCOMSL0 - RECORD FOUND ON
     F*              FIRST CHAIN NO LONGER ON FILE
     F*    50      TEST WHETHER SEQUENCE NUMBER ENTERED IS NUMERIC
     F*    55      WRITE SCREEN ERROR MESSAGE ON SEQUENCE NUMBER
     F*            NOT NUMERIC
     F*    60      WRITE SCREEN ERROR MESSAGE ON ALL OTHER ERRORS
     F*    61      DUMMY COMPONENT REQUESTED
     F*    65      ALLOW USE OF COMMAND KEY 6 AND COMMAND KEY 12
     F*            PROTECT SCREEN INPUT FIELDS
     F*    70      SET ON FOR HELP PROCESSING TAG
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
     D TITL            S             29    DIM(1) CTDATA PERRCD(1)
     D** REPORT TITLE ARRAY
     D*
     D ERRMSG          S             78    DIM(9) CTDATA PERRCD(1)
     D** ERROR MESSAGE ARRAY
     D*
     D*****************************************************************
     D/EJECT
     D*
     D SCOBFI          S             10A   INZ('SCOBFINISH')                                  CCB020
     D SYTIM           DS
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
     D CKEYDS          DS
     D  SCCOT                  1     10
     D  SCSEQ                 11     15
     D** DATA STRUCTURE FOR KEY FIELD CKEY TO BE MOVED INTO DBKEY FIELD
     D*
     D RUNDAT          DS            13
     D  AGMRDT                 1      7
     D** DATA STRUCTURE TO GET DATE FROM RUNDAT DATA AREA
     D*
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D**     LOCAL DATA AREA
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
     I**     DATA STRUCTURE FOR WORKSTATION ID FOR SCREEN OUTPUT
     I*
     I*****************************************************************
     I/EJECT
     C*
     C** KEY TO CHAIN TO CBSOMSL0
     C*
     C     CKEY          KLIST
     C                   KFLD                    SCCOT
     C                   KFLD                    CCSEQ
     C*
     C** DEFINE DATA AREA LDA AND LOCK TO SET
     C** UP PROGRAM NAME FOR DATABASE ERRORS
     C*
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'CB0040  '    DBPGM
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
     C** SET UP HEADING FIELDS FOR DISPLAY FILE
     C*
     C                   MOVE      'CB0040'      PROGNO            6
     C                   MOVEL     TITL(1)       TITLE            29
     C*
     C** DO WHILE COMMAND KEY 3 NOT PRESSED
     C** AND SCREEN NOT TIMED OUT
     C*
     C     *IN03         DOWNE     '1'
     C     *INU1         ANDNE     '1'
     C*
     C** DO UNTIL NUMERIC FIELD VALUE ENTERED
     C** ON COMPONENT SEQUENCE NUMBER FIELD OR
     C** UNTIL COMMAND KEY 3 NOT PRESSED
     C** OR SCREEN NOT TIMED OUT
     C*
     C     *IN50         DOUEQ     '1'
     C     *IN03         OREQ      '1'
     C     *INU1         OREQ      '1'
     C*
     C** SET ON INDICATOR TO USE CORRECT HELP TAG IN CBHALTDF
     C*
     C                   SETON                                        70
     C*
     C** SET UP CURRENT TIME FOR DISPLAY ON SCREEN
     C*
     C                   TIME                    TIMDAT           12 0
     C                   MOVEL     TIMDAT        SCTIME
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
     C** WRITE INITIAL SCREEN
     C*
     C                   WRITE     CBHALTF0
     C                   WRITE     CBHALTF1
     C*
     C** READ DISPLAY FILE
     C*
     C************       READ      CBHALTDF                             U140           CAAA02
     C                   READ      CBHALTDF                             U140                  CPK025
      **********/free                                                                         CPK025
      **********   Now1Time = %time();                                               //CAAA02 CPK025
      **********                                                                     //CAAA02 CPK025
      **********   read CBHALTF1;                                                    //CAAA02 CPK025
      **********   if %eof;                                                          //CAAA02 CPK025
      **********      *in40='1';                                                     //CAAA02 CPK025
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
     C     *IN40         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'FMT1'        DBFILE
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** TEST COMPONENT SEQUENCE NUMBER ENTERED ON SCREEN
     C*
     C                   MOVE      0             TSTSQN            6
     C                   MOVEL     SCSEQ         TSTSQN
     C                   TESTN                   TSTSQN               50
     C*
     C** IF NOT NUMERIC SET ON ERROR INDICATOR AND WRITE
     C** ERROR MESSAGE ELSE SET UP FIELD FOR LATER CHAIN
     C*
     C     *IN50         IFEQ      '0'
     C*
     C                   SETON                                        55
     C                   MOVE      ERRMSG(1)     MSG
     C                   MOVE      *BLANKS       DHCTXT
     C*
     C                   ELSE
     C*
     C                   MOVEL     TSTSQN        CCSEQ             5
     C*
     C                   END
     C*
     C                   END
     C*
     C** SET OFF SCREEN ERROR INDICATORS
     C*
     C                   SETOFF                                       556061
     C*
     C** IF COMMAND KEY 3 NOT PRESSED
     C** AND SCREEN NOT TIMED OUT
     C*
     C     *IN03         IFNE      '1'
     C     *INU1         ANDNE     '1'
     C*
     C** OPEN COMPONENTS FILE(CBCOMSL0) AND CHAIN FOR COMPONENT RECORD
     C*
     C                   OPEN      CBCOMSL0
     C     CKEY          CHAIN     @DHREGG                            45
     C                   CLOSE     CBCOMSL0
     C*
     C** IF RECORD NOT FOUND WRITE COMPONENT NOT FOUND ERROR MESSAGE
     C*
     C     *IN45         IFEQ      '1'
     C*
     C                   SETON                                        60
     C                   MOVE      ERRMSG(2)     MSG
     C                   MOVE      *BLANKS       DHCTXT
     C*
     C                   ELSE
     C*
     C***IF*COMPONENT*IS*EITHER*'COBBEGIN'*OR*'COBEND'*WRITE***********                       CCB020
     C***CANNOT*HALT*AFTER*THIS*COMPONENT*ERROR*MESSAGE****************                       CCB020
      ** If component is either 'COBBEGIN' or 'SCOBFINISH' write                              CCB020
      ** cannot halt after this component error message                                       CCB020
     C*
     C     DHCOTT        IFEQ      'COBBEGIN'
     C*****DHCOTT        OREQ      'COBEND'                                                   CCB020
     C     DHCOTT        OREQ      SCOBFI                                                     CCB020
     C*
     C                   SETON                                        6061
     C                   MOVE      ERRMSG(3)     MSG
     C*
     C                   END
     C*
     C** IF HALT BEFORE INDICATOR IS ALREADY 'Y' THEN WRITE HALT
     C** ALREADY REQUESTED AFTER THIS COMPONENT ERROR MESSAGE
     C*
     C     DHCHTB        IFEQ      'Y'
     C*
     C                   SETON                                        60
     C                   MOVE      ERRMSG(4)     MSG
     C*
     C                   END
     C*
     C** IF COMPONENT IS NOT REQUIRED (DHKDST = 'N') THEN WRITE
     C** COMPONENT NOT REQUIRED TODAY ERROR MESSAGE
     C*
     C     DHCRQD        IFEQ      'N'
     C*
     C                   SETON                                        60
     C                   MOVE      ERRMSG(5)     MSG
     C*
     C                   END
     C*
     C** CHECK COMPONENT STATUS USING SUBROUTINE CHKSTS
     C*
     C                   EXSR      CHKSTS
     C*
     C** IF NO ERRORS FOUND ON CHECKING
     C** COMPONENT DETAILS AND STATUS
     C*
     C     *IN60         IFEQ      '0'
     C*
     C** DO WHILE COMMAND KEY 3, COMMAND KEY 6 AND COMMAND
     C** KEY 12 PRESSED AND SCREEN NOT TIMED OUT
     C*
     C     *IN03         DOWNE     '1'
     C     *IN06         ANDNE     '1'
     C     *IN12         ANDNE     '1'
     C     *INU1         ANDNE     '1'
     C*
     C** SET UP MESSAGE AS 'PRESS F6 TO CONFIRM COMPONENT TO
     C** HALT AFTER' AND SET ON INDICATOR TO ALLOW USE OF ADDITIONAL
     C** COMMAND KEYS AND WRITE SCREEN INFORMATION MESSAGE
     C*
     C                   SETON                                        65
     C                   MOVE      ERRMSG(6)     MSG
     C*
     C                   WRITE     CBHALTF1
     C*
     C************       READ      CBHALTDF                             U140           CAAA02
     C                   READ      CBHALTDF                             U140                  CPK025
      **********/free                                                                         CPK025
      **********   Now1Time = %time();                                               //CAAA02 CPK025
      **********                                                                     //CAAA02 CPK025
      **********   read CBHALTF1;                                                    //CAAA02 CPK025
      **********   if %eof;                                                          //CAAA02 CPK025
      **********      *in40='1';                                                     //CAAA02 CPK025
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
     C     *IN40         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'FMT1'        DBFILE
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   Z-ADD     2             DBASE                          * DB ERROR 02 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** IF COMMAND KEY 6 PRESSED AND SCREEN NOT TIMED OUT
     C*
     C     *IN06         IFEQ      '1'
     C     *INU1         ANDNE     '1'
     C*
     C** CHAIN TO COMPONENTS FILE TO CHECK IF
     C** COMPONENT HAS COMPLETED SINCE PREVIOUS CHAIN
     C*
     C                   OPEN      CBCOMSL0
     C     CKEY          CHAIN     @DHREGG                            46
     C*
     C** IF COMPONENT NOT FOUND EXIT PROGRAM
     C** VIA DATABASE ERROR SUBROUTINE
     C*
     C     *IN46         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CMPL0'       DBFILE
     C                   MOVEL     CKEYDS        DBKEY                          ***************
     C                   Z-ADD     3             DBASE                          * DB ERROR 03 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C** CHECK COMPONENT STATUS USING SUBROUTINE CHKSTS
     C*
     C                   EXSR      CHKSTS
     C*
     C** IF COMPONENT HAS NOT RUN - NO ERROR
     C** FOUND IN SUBROUTINE CHKSTS UPDATE HALT
     C** BEFORE FIELD TO 'Y' AND CLOSE FILE
     C*
     C     *IN60         IFEQ      '0'
     C*
     C                   MOVE      'Y'           DHCHTB
     C                   EXCEPT    UCHTB
     C*
     C                   END
     C*
     C                   CLOSE     CBCOMSL0
     C*
     C                   END
     C*
     C** SET OFF PROTECT INDICATOR
     C*
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
     C** IF NO ERRORS OR DUMMY COMPONENT INDICATOR
     C** IS OFF THEN CLEAR SCREEN INPUT FIELDS
     C** AND SET OFF DISPLAY TEXT FIELD INDICATOR
     C*
     C     *IN60         IFEQ      '0'
     C     *IN61         ANDEQ     '0'
     C*
     C                   MOVE      *BLANKS       SCCOT
     C                   MOVE      *BLANKS       SCSEQ
     C                   MOVE      *BLANKS       DHCTXT
     C                   WRITE     CBHALTF2
     C                   SETOFF                                       50
     C*
     C                   END
     C*
     C                   END
     C*
     C                   SETON                                        LR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**
     C** INDEX OF SUBROUTINES
     C**
     C**
     C** CHKSTS - CHECK COMPONENT STATUS
     C**
     C** DBERR  - DATABASE ERROR HANDLING
     C**
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** SUBROUTINE TO CHECK COMPONENT STATUS
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C********************************************************************
     C     CHKSTS        BEGSR
     C*
     C** IF COMPONENT HAS ALREADY STARTED WRITE
     C** COMPONENT ALREADY STARTED MESSAGE
     C*
     C     DHCSTS        IFEQ      'P'
     C*
     C                   SETON                                        60
     C                   MOVE      ERRMSG(8)     MSG
     C*
     C                   END
     C*
     C** IF COMPONENT HAS ALREADY BEEN SCHEDULED TO
     C** START WRITE COMPONENT ALREADY SCHEDULED MESSAGE
     C*
     C     DHCSTS        IFEQ      'S'
     C*
     C                   SETON                                        60
     C                   MOVE      ERRMSG(9)     MSG
     C*
     C                   END
     C*
     C** IF COMPONENT HAS ALREADY COMPLETED WRITE
     C** COMPONENT ALREADY COMPLETED MESSAGE
     C*
     C     DHCSTS        IFEQ      'C'
     C*
     C                   SETON                                        60
     C                   MOVE      ERRMSG(7)     MSG
     C*
     C                   END
     C*
     C                   ENDSR
     C*
      /EJECT
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** DATABASE ERROR SUBROUTINE TO PERFORM DATABASE ERROR
     C** EXIT FROM PROGRAM
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C********************************************************************
     C*
     C     DBERR         BEGSR
     C*
     C** SETON INDICATORS U7 U8 LR AND
     C** RETURN TO CALLING PROGRAM
     C*
     C                   SETON                                        LRU7U8
     C                   OUT       LDA
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C********************************************************************
      /EJECT
     O********************************************************************
     O*
     O**   UPDATE HALT BEFORE FIELD ON COMPONENTS FILE
     O*
     O@DHREGG   E            UCHTB
     O*
     O                       DHCHTB
     O*
     O********************************************************************
      /EJECT
**CTDATA TITL
REQUEST HALT BEFORE COMPONENT
**CTDATA ERRMSG
THE COMPONENT SEQUENCE NUMBER ENTERED IS NOT NUMERIC
THE COMPONENT DETAILS ENTERED ARE INVALID
A HALT CANNOT BE REQUESTED BEFORE THIS COMPONENT
A HALT HAS ALREADY BEEN REQUESTED FOR THIS COMPONENT
THE COMPONENT ENTERED IS NOT TO BE RUN TODAY
PRESS F6 TO CONFIRM A HALT BEFORE THE COMPONENT ENTERED
THE COMPONENT REQUESTED HAS ALREADY BEEN RUN TODAY
THE COMPONENT REQUESTED HAS ALREADY STARTED TO RUN
THE COMPONENT REQUESTED HAS ALREADY BEEN SCHEDULED TO RUN
