     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CB Request timed halt')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Close of Business Processing                         *
     F*                                                               *
     F*  CB0030 - REQUEST TIMED HALT PROGRAM                          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK025             Date 23Nov06               *
      *                 CAAA02             Date 16Jul03               *
      *  Converted to ILE and code-stripped                           *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 LN0545             DATE 20JUL90               *
      *                 LN0278             DATE 13JUL90               *
     F*                 LN0382             DATE 16JUN90               *
     F*                                                               *
     F*****************************************************************
     F*                                                                *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK025 - Revert back fix of CAAA02                           *
      *  CAAA02 - Remove use of INVITE keyword to enable WebFacing    *
      *           to process screens.                                 *
      *           This program must read formats rather than a file.  *
     F*  LN0545 - RE-TRY THE LOCK OF CBSTAT TO AVOID POTENTIAL        *
     F*           COB CRASH AS A NUMBER OF PROGRAMS PERFORM THE       *
     F*           *LOCK TO UPDATE THE DATA AREA                       *
     F*  LN0278 - USE NEW PROGRAM CBTIME TO ACCESS TIME AND           *
     F*           DATE IN CORRECT FORMAT FOR CALCULATIONS             *
     F*           AND REMOVE ZDATE1 SUBROUTINE                        *
     F*  LN0382 - REMOVE CALL TO AOBANKR0 AND USE RUNDAT TO           *
     F*           OBTAIN DATE FORMAT IN ORDER TO AVOID AOBANKR0       *
     F*           BEING CALLED BY ITSELF                              *
     F*****************************************************************
     F*                                                               *
     FCB0030DF  CF   E             WORKSTN
     F                                     MAXDEV(*FILE)
     F*
      /SPACE 2
     F********************************************************************
     F*
     F*     C  L   FUNCTION OF INDICATORS
     F*
     F*    03      COMMAND KEY 3 PRESSED
     F*    06      COMMAND KEY 6 PRESSED
     F*    10      COMMAND KEY 10 PRESSED
     F*    25      INDICATOR SET ON TO WRITE FORMAT CB0030F1
     F*            AND SET OFF TO WRITE FORMAT CB0030F2
     F*    28      FAIL ON READ OF FORMAT CB0030F1
     F*    29      FAIL ON READ OF FORMAT CB0030F2
     F*    40      ERROR ON TIME FIELD INPUT ON SCREEN
     F*    41      ERROR ON CANCEL FIELD INPUT ON SCREEN
     F*    55      CHECK WHETHER FIELD ENTERED ON SCREEN IS NUMERIC
     F*    60      ALLOW USE OF COMMAND KEY 6 AND PROTECT SCREEN
     F*            INPUT FIELDS
     F*    65      ALLOW USE OF COMMAND KEY 10 AND PROTECT SCREEN
     F*            INPUT FIELDS
     F*    70      RE-TRY LOCK OF DATA AREA
 
     F*
     F*        LR  LAST RECORD INDICATOR
     F*
     F*    U1      SCREEN TIME OUT INDICATOR
     F*    U7&U8   DATABASE ERROR
     F*
     F*****************************************************************
     F/EJECT
     D*
     D** COPYRIGHT ARRAY
     D*
     D ERRMSG          S             78    DIM(5) CTDATA PERRCD(1)
     D** ERROR MESSAGE ARRAY
     D*
     D*****************************************************************
     D/EJECT
     D*
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D** DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D*
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D**     LOCAL DATA AREA
     D*
     D SCTIM           DS
     D  HRS                    1      2
     D  MIN                    3      4
     D**     DATA STRUCTURE TO SPLIT TIME INPUT TO SCREEN
     D*
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
     D CBSTAT          DS            50
     D  HALTDE                 5      9
     D  HALTTI                10     13
     D**     CBSTAT DATA AREA
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
     I**      DATA STRUCTURE FOR WORKSTATION ID FOR SCREEN OUTPUT
     I*
     I*****************************************************************
     I/EJECT
     C*
     C** DEFINE DATA AREA LDA AND LOCK TO SET
     C** UP PROGRAM NAME FOR DATABASE ERRORS
     C*
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'CB0030  '    DBPGM
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
     C** DEFINE DATA AREA CBSTAT AND LOCK
     C** TO READ HALT TIME AND DATE VALUES
     C*
     C     *DTAARA       DEFINE                  CBSTAT
     C*
     C     *IN70         DOUEQ     '0'
     C     *LOCK         IN        CBSTAT                               70
     C                   END
     C*
     C** IF HALT DATE (HALTDE FROM CBSTAT POS 5-9) IS BLANK
     C** SET ON INDICATOR TO WRITE INITIAL FORMAT CB0030F1
     C*
     C     HALTDE        IFEQ      ' '
     C                   SETON                                        25
     C*
     C                   ELSE
     C*
     C** ELSE ENSURE INDICATOR IS OFF
     C** TO WRITE SECOND FORMAT CB0030F2
     C*
     C                   SETOFF                                       25
     C*
     C** MOVE HALT TIME (HALTTI FROM CBSTAT POS 10=13)
     C** TO HALT TIME ALREADY INPUT FIELD ON FORMAT CB0030F2
     C*
     C                   MOVE      HALTTI        SCHLIN            4
     C*
     C                   END
     C*
     C** UNLOCK DATA AREA CBSTAT
     C*
     C                   OUT       CBSTAT
     C*
     C** DO WHILE COMMAND KEY 3, COMMAND KEY 6 AND COMMAND
     C** KEY 10 NOT PRESSED AND SCREEN INPUT NOT TIMED OUT
     C*
     C     *IN03         DOWNE     '1'
     C     *IN06         ANDNE     '1'
     C     *IN10         ANDNE     '1'
     C     *INU1         ANDNE     '1'
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
     C** WRITE HEADER FORMAT
     C*
     C                   WRITE     CB0030F0
     C*
     C** WRITE EITHER FORMAT CB0030F1 OR CB0030F2 DEPENDING
     C** ON INDICATOR SET UP ON CHECKING DATA AREA CBSTAT
     C*
     C     *IN25         IFEQ      '1'
     C                   WRITE     CB0030F1
     C************       READ      CB0030DF                             U128           CAAA02
     C                   READ      CB0030DF                             U128                  CPK025
      **********/free                                                                         CPK025
      **********   Now1Time = %time();                                               //CAAA02 CPK025
      **********                                                                     //CAAA02 CPK025
      **********   read CB0030F1;                                                    //CAAA02 CPK025
      **********   if %eof;                                                          //CAAA02 CPK025
      **********      *in28='1';                                                     //CAAA02 CPK025
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
     C     *IN28         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'FMT1'        DBFILE
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C                   ELSE
     C*
     C                   WRITE     CB0030F2
     C************       READ      CB0030DF                             U129           CAAA02
     C                   READ      CB0030DF                             U129                  CPK025
      **********/free                                                                         CPK025
      **********   Now1Time = %time();                                               //CAAA02 CPK025
      **********                                                                     //CAAA02 CPK025
      **********   read CB0030F2;                                                    //CAAA02 CPK025
      **********   if %eof;                                                          //CAAA02 CPK025
      **********      *in29='1';                                                     //CAAA02 CPK025
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
     C     *IN29         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'FMT2'        DBFILE
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   Z-ADD     2             DBASE                          * DB ERROR 02 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C                   END
     C*
     C** SET OFF SCREEN ERROR INDICATORS
     C*
     C                   SETOFF                                       404155
     C*
     C** IF COMMAND KEY 3 NOT PRESSED
     C** AND SCREEN INPUT NOT TIMED OUT
     C*
     C     *IN03         IFNE      '1'
     C     *INU1         ANDNE     '1'
     C*
     C** IF CANCEL HALT FIELD IS NOT BLANK AND
     C** SCREEN INPUT FIELD IS NOT BLANK WRITE ERROR
     C** MESSAGE AS BOTH FIELDS CANNOT BE ENTERED
     C*
     C     SCTIM         IFNE      *BLANKS
     C     RMVHLT        ANDNE     *BLANKS
     C*
     C                   SETON                                        4041
     C*
     C                   MOVE      ERRMSG(5)     MSG
     C*
     C                   ELSE
     C*
     C** TEST TIME ENTERED ON SCREEN AND IF NOT NUMERIC
     C** AND CANCEL HALT TIME FIELD IS BLANK SET ON
     C** ERROR INDICATOR AND WRITE ERROR MESSAGE
     C*
     C                   MOVE      0             TSTTIM            5
     C                   MOVEL     SCTIM         TSTTIM
     C                   TESTN                   TSTTIM               55
     C*
     C     *IN55         IFEQ      '0'
     C     RMVHLT        ANDEQ     *BLANKS
     C*
     C                   SETON                                        40
     C                   MOVE      ERRMSG(1)     MSG
     C*
     C                   ELSE
     C*
     C** IF TIME ENTERED IS NOT VALID (HOURS GREATER
     C** THAN 23 OR MINUTES GREATER THAN 59) SET ON
     C** ERROR INDICATOR AND WRITE ERROR MESSAGE
     C*
     C     HRS           IFGT      '23'
     C     MIN           ORGT      '59'
     C*
     C                   SETON                                        40
     C                   MOVE      ERRMSG(1)     MSG
     C*
     C                   END
     C*
     C                   END
     C*
     C** IF CANCEL HALT FIELD NOT 'Y' OR BLANK WRITE ERROR MESSAGE
     C*
     C     RMVHLT        IFNE      'Y'
     C     RMVHLT        ANDNE     *BLANKS
     C*
     C                   SETON                                        41
     C                   MOVE      ERRMSG(4)     MSG
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C** IF SCREEN FIELD ERROR INDICATORS ARE OFF
     C*
     C     *IN40         IFEQ      '0'
     C     *IN41         ANDEQ     '0'
     C*
     C** DO WHILE COMMAND KEY 3, COMMAND KEY 6 AND COMMAND
     C** KEY 10 NOT PRESSED AND SCREEN INPUT NOT TIMED OUT
     C*
     C     *IN03         DOWNE     '1'
     C     *IN06         ANDNE     '1'
     C     *IN10         ANDNE     '1'
     C     *INU1         ANDNE     '1'
     C*
     C** SET UP MESSAGE AS EITHER 'PRESS F10 TO DELETE HALT TIME
     C** ENTERED' OR 'PRESS F6 TO CONFIRM HALT TIME ENTERED'
     C** AND SET ON INDICATOR TO ALLOW USE OF APPROPRIATE KEY
     C** AND WRITE SCREEN INFORMATION MESSAGE
     C*
     C     RMVHLT        IFEQ      'Y'
     C*
     C                   MOVE      ERRMSG(3)     MSG
     C                   SETON                                        65
     C*
     C                   ELSE
     C*
     C                   MOVE      ERRMSG(2)     MSG
     C                   SETON                                        60
     C*
     C                   END
     C*
     C** WRITE EITHER FORMAT CB0030F1 OR CB0030F2 DEPENDING
     C** ON INDICATOR SET UP ON CHECKING DATA AREA CBSTAT
     C*
     C     *IN25         IFEQ      '1'
     C                   WRITE     CB0030F1
     C************       READ      CB0030DF                             U128           CAAA02
     C                   READ      CB0030DF                             U128                  CPK025
      **********/free                                                                         CPK025
      **********   Now1Time = %time();                                               //CAAA02 CPK025
      **********                                                                     //CAAA02 CPK025
      **********   read CB0030F1;                                                    //CAAA02 CPK025
      **********   if %eof;                                                          //CAAA02 CPK025
      **********      *in28='1';                                                     //CAAA02 CPK025
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
     C     *IN28         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'FMT1'        DBFILE
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   Z-ADD     3             DBASE                          * DB ERROR 03 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C                   ELSE
     C*
     C                   WRITE     CB0030F2
     C************       READ      CB0030DF                             U129           CAAA02
     C                   READ      CB0030DF                             U129                  CPK025
      **********/free                                                                         CPK025
      **********   Now1Time = %time();                                               //CAAA02 CPK025
      **********                                                                     //CAAA02 CPK025
      **********   read CB0030F2;                                                    //CAAA02 CPK025
      **********   if %eof;                                                          //CAAA02 CPK025
      **********      *in29='1';                                                     //CAAA02 CPK025
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
     C     *IN29         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'FMT2'        DBFILE
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   Z-ADD     4             DBASE                          * DB ERROR 04 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C                   END
     C*
     C** IF COMMAND KEY 6 PRESSED AND SCREEN INPUT
     C** NOT TIMED OUT AND CANCEL HALT FIELD IS BLANK
     C*
     C     *IN06         IFEQ      '1'
     C     *INU1         ANDNE     '1'
     C     RMVHLT        ANDEQ     *BLANKS
     C*
     C                   CALL      'CBTIME'
     C                   PARM                    DAYNOA            5
     C                   PARM                    STIME             6
     C                   PARM                    DFMT              1
     C*
     C** MOVE DAY NO FROM CBTIME TO DATE WORK FIELD (DWF)
     C*
     C                   MOVE      DAYNOA        DWF               5 0
     C*
     C** IF TIME ENTERED IS LESS THAN CURRENT SYSTEM TIME ADD
     C** ONE TO DATE WORK FIELD TO SET UP HALT FOR TOMORROW
     C*
     C                   MOVEL     STIME         HRMN              4
     C     SCTIM         IFLT      HRMN
     C*
     C                   ADD       1             DWF
     C*
     C                   END
     C*
     C** LOCK DATA AREA CBSTAT AND SET UP HALT DATE AND TIME
     C** INTO ALPHA FIELDS BEFORE UPDATING DATA AREA CBSTAT
     C*
     C     *IN70         DOUEQ     '0'
     C     *LOCK         IN        CBSTAT                               70
     C                   END
     C                   MOVE      DWF           DWFA              5
     C                   MOVE      SCTIM         SCTIMA            4
     C*
     C                   MOVE      DWFA          HALTDE
     C                   MOVE      SCTIMA        HALTTI
     C*
     C                   OUT       CBSTAT
     C*
     C                   END
     C*
     C** IF COMMAND KEY 10 PRESSED AND SCREEN INPUT
     C** NOT TIMED OUT AND CANCEL HALT FIELD IS NOT BLANK
     C*
     C     *IN10         IFEQ      '1'
     C     *INU1         ANDNE     '1'
     C     RMVHLT        ANDEQ     'Y'
     C*
     C*
     C** LOCK DATA AREA CBSTAT AND CLEAR HALT DATE AND TIME
     C** FIELDS FOR UPDATE OF DATA AREA CBSTAT
     C*
     C     *IN70         DOUEQ     '0'
     C     *LOCK         IN        CBSTAT                               70
     C                   END
     C*
     C                   MOVE      *BLANKS       HALTDE
     C                   MOVE      *BLANKS       HALTTI
     C*
     C                   OUT       CBSTAT
     C*
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
     C** SETON INDICATORS U7 U8 LR AND RETURN TO CALLING PROGRAM
     C*
     C                   SETON                                        U7U8LR
     C*
     C                   OUT       LDA
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C********************************************************************
      /EJECT
**CTDATA ERRMSG
THE HALT TIME ENTERED IS NOT VALID
PRESS F6 TO CONFIRM HALT TIME ENTERED
PRESS F10 TO REMOVE THE CURRENT HALT TIME
ENTER `Y` TO REMOVE THE CURRENT HALT TIME
ENTER ONE FIELD ONLY TO EITHER INSERT OR REMOVE A HALT
