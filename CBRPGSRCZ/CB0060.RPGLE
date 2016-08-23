     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CB Close of business enquiry')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Close of Business Processing                         *
     F*                                                               *
     F*  CB0060 - CLOSE OF BUSINESS ENQUIRY                           *
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
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  CPK025 - Revert back fix of CAAA02                           *
      *  CAAA02 - Remove use of INVITE keyword to enable WebFacing    *
      *           to process screens.                                 *
      *           This program must read formats rather than a file.  *
     F*                                                               *
     F*****************************************************************
     FCB0060DF  CF   E             WORKSTN
     F                                     SFILE(CB0060S0:RRN)
     F                                     MAXDEV(*FILE)
     FCBMESGPD  IF   E             DISK
     F*
      /SPACE 2
     F********************************************************************
     F*
     F*     C  L   FUNCTION OF INDICATORS
     F*
     F*    03      COMMAND KEY 3 PRESSED
     F*    25      ROLLUP KEY PRESSED
     F*    30      SFLDSP KEYWORD INDICATOR
     F*    31      SFLDSPCTL KEYWORD INDICATOR
     F*    50      SFLMSGID KEYWORD INDICATOR
     F*    60      NO RECORDS FOUND ON CBMESGPD
     F*    70      READ FAIL ON CB0060DF
     F*
     F*        LR  LAST RECORD INDICATOR
     F*
     F*    U1      SCREEN TIMED OUT
     F*
     F*****************************************************************
     F/EJECT
     D*
     D** COPYRIGHT ARRAY
     D*
     D*****************************************************************
     D/EJECT
     D*
     D RUNDAT          DS            13
     D  AGMRDT                 1      7
     D** DATA STRUCTURE TO GET DATE FROM RUNDAT DATA AREA
     D*
     D PSDS           SDS
     D  WSID                 244    253
     D  USRID                254    263
     D**      DATA STRUCTURE FOR WORKSTATION ID FOR SCREEN OUTPUT
     D*
     D ENQMSG          DS
     D  CCOT                   1     10
     D  CTXT                  11     70
     D  CBSM                  71     78
      **********                                                                       CAAA02 CPK025
      **WaitTime is the time from WRITE to READ                                        CAAA02 CPK025
     d*WaitTime        s              5p 0                                             CAAA02 CPK025
     d*MaxWaitTime     s              5p 0 inz(600)                                    CAAA02 CPK025
      **********                                                                       CAAA02 CPK025
      **Now1Time is the time before the READ and Now2Time the time after               CAAA02 CPK025
     d*Now1Time        s               t                                               CAAA02 CPK025
     d*Now2Time        s               t                                               CAAA02 CPK025
      **********                                                                       CAAA02 CPK025
     I** DATA STRUCTURE TO SET UP DISPLAY FILE MESSAGE
     I*
     I*****************************************************************
     I/EJECT
     C*
     C**  OBTAIN RUN DATE FROM DATA AREA RUNDAT
     C*
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      AGMRDT        RUNA
     C                   UNLOCK    RUNDAT
     C*
     C** READ FILE AND SET RELATIVE RECORD NUMBER TO 1
     C*
     C                   READ      CBMESGP0                               60
     C                   Z-ADD     1             RRN               4 0
     C*
     C** WRITE HEADER AND TRAILER FORMATS TO SCREEN
     C*
     C                   WRITE     CB0060F0
     C                   WRITE     CB0060F1
     C*
     C** DO WHILE COMMAND KEY 3 NOT PRESSED SCREEN NOT,
     C** TIMED OUT, AND NO RECORDS FOUND ON CBMESGPD
     C*
     C     *IN03         DOWNE     '1'
     C     *INU1         ANDNE     '1'
     C     *IN60         ANDEQ     '1'
     C*
     C** SET ON SUBFILE DSPCTL INDICATOR AND
     C** WRITE ERROR MESSAGE TO SCREEN
     C*
     C                   SETON                                        31
     C                   WRITE     CB0060F2
     C*
     C                   WRITE     CB0060C0
     C************       READ      CB0060DF                             U170           CAAA02
     C                   READ      CB0060DF                             U170                  CPK025
      **********/free                                                                         CPK025
      **********   Now1Time = %time();                                               //CAAA02 CPK025
      **********                                                                     //CAAA02 CPK025
      **********   read CB0060C0;                                                    //CAAA02 CPK025
      **********   if %eof;                                                          //CAAA02 CPK025
      **********      *in70='1';                                                     //CAAA02 CPK025
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
     C                   END
     C*
     C** DO WHILE COMMAND KEY 3 NOT PRESSED
     C** AND SCREEN NOT TIMED OUT
     C*
     C     *IN03         DOWNE     '1'
     C     *INU1         ANDNE     '1'
     C*
     C** SET ON SUBFILE DISPLAY & DSPCTL
     C** INDICATORS AND SET COUNT TO 1
     C*
     C                   Z-ADD     1             COUNT             1 0
     C                   SETON                                        3031
     C*
     C** DO UNTIL ROLLUP KEY NOT PRESSED
     C** OR UNTIL SCREEN HAS BEEN TIMED OUT
     C*
     C     *IN25         DOUNE     '1'
     C     *INU1         OREQ      '1'
     C*
     C** FILL SUBFILE WITH RECORDS
     C*
     C                   EXSR      FILSUB
     C*
     C** IF END OF FILE NOT REACHED SET
     C** UP INDICATOR FOR '+' SIGN
     C*
     C     *IN60         IFEQ      '0'
     C                   SETON                                        50
     C                   END
     C*
     C** WRITE SUBFILE PAGE TO SCREEN
     C*
     C                   WRITE     CB0060C0
     C************       READ      CB0060DF                             U170           CAAA02
     C                   READ      CB0060DF                             U170                  CPK025
      **********/free                                                                         CPK025
      **********   Now1Time = %time();                                               //CAAA02 CPK025
      **********                                                                     //CAAA02 CPK025
      **********   read CB0060C0;                                                    //CAAA02 CPK025
      **********   if %eof;                                                          //CAAA02 CPK025
      **********      *in70='1';                                                     //CAAA02 CPK025
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
     C** SET OFF INDICATOR FOR '+' SIGN
     C*
     C     *IN50         IFEQ      '1'
     C                   SETOFF                                       50
     C                   END
     C*
     C** DO WHILE ROLLUP KEY PRESSED
     C*
     C     *IN25         DOWEQ     '1'
     C*
     C** SET COUNT TO 1 AND READ MESSAGES FILE
     C** TO BUILD NEXT PAGE OF SUBFILE
     C*
     C                   Z-ADD     1             COUNT
     C                   READ      CBMESGP0                               60
     C*
     C** FILL SUBFILE WITH RECORDS
     C*
     C                   EXSR      FILSUB
     C*
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C                   SETON                                        LR
     C********************************************************
     C/EJECT
     C********************************************************
     C**
     C** INDEX OF SUBROUTINES
     C**
     C** FILSUB - FILL SUBFILE PROCESSING
     C**
     C********************************************************************
     C/EJECT
     C********************************************************************
     C*
     C** SUBROUTINE TO FILL SUBFILE WITH AVAILABLE RECORDS
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C********************************************************************
     C*
     C     FILSUB        BEGSR
     C*
     C     *IN60         DOWNE     '1'
     C     COUNT         ANDLE     16
     C                   WRITE     CB0060S0
     C*
     C     COUNT         IFLT      16
     C                   ADD       1             COUNT
     C                   ADD       1             RRN
     C                   READ      CBMESGP0                               60
     C                   END
     C*
     C                   END
     C*
     C                   ENDSR
     C*
     C/EJECT
     C********************************************************************
