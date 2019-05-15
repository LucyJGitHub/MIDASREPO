     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      **********************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Day to date conversion.           *MODULE')
      **********************************************************************
      *                                                                    *
      *  Midas - Common processing                                         *
      *                                                                    *
      *     ZA0140M - DAY NUMBER TO DATE CONVERSION                        *
      *                                                                    *
      *  (c) Finastra International Limited 2001                      *
      *                                                                    *
      * This is an ILE module based on ZA0140                              *
      * This module is a component of service program ZA0001S              *
      *                                                                    *
      * O: Return Code                    1                                *
      * I: Midas Day Number               5 0                              *
      * I: Midas Date Format  D or M      1                                *
      * O: Date DDMMYY or MMDDYY          6 0                              *
      * O: Date DDMMMYY                   7                                *
      * O: Date YYYYMMDD                  8 0                              *
      * O: Date DDMMYYYY or MMDDYYYY      8 0                              *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CLE004             Date 14Mar97               *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE004 - Created for Customer Lending Enhancements                *
      *                                                                    *
      **********************************************************************
     F*
     F**  NO FILES USED IN THIS SUBROUTINE
     F*
     F*
     F**  FUNCTION OF INDICATORS SUMMARY
     F*
     F**      60         ENTRY LESS THAN OR EQUAL TO 'SSRDAY'
     F**                 FOUND IN ARRAY 'SSY'
     F**      61         ENTRY SMALLER THAN 'SSRDAY' IN ARRAY 'SSM'
     F*****************************************************************
     D*****************************************************************
     D*
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D**  ARRAY HOLDING SHORTENED MONTH NAMES
     D*
     D SSY             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND
     D*
     D**  ARRAY HOLDING CUMULATIVE NUMBER OF DAYS IN MONTH BY YEAR
     D*
     D SSM             S              5  0 DIM(12) CTDATA PERRCD(12) ASCEND
     D*
     D**  ARRAY HOLDING SHORTNAMES OF EACH MONTH
     D*
     D SSA             S              3    DIM(12) CTDATA PERRCD(12)
      *
      * Date formatting fields
     D W#EURDATE       S               D   DATFMT(*EUR)
     D W#USADATE       S               D   DATFMT(*USA)
     D*****************************************************************
     D*****************************************************************
     D*
     D*
     D PSDS           SDS
     D  JOBNAM               244    253
     D  JOBUSR               254    263
     I*****************************************************************
     C*****************************************************************
     C**VERSION**
     C**CONVERT DAY NUMBER TO DATE
     C                   MOVE      '01.00.00'    WWVERS            8
     C                   MOVE      'ZA0140M'     WWPGM            10
     C*
     C**  RECEIVING/RETURNING PARAMETERS FROM/TO CALLING PROGRAM
     C*
     C     *ENTRY        PLIST
     C                   PARM                    SSRTN             1
     C                   PARM                    SSDAYN            5 0
     C                   PARM                    SSDFMT            1
     C                   PARM                    SSDATE            6 0
     C                   PARM                    SSDATA            7
     C                   PARM                    SSDAT8            8 0
     C                   PARM                    SSDAT8F           8 0
     C*
     C**  SUBROUTINE PERFORMS INITIAL PROCESSING AND DATE VALIDATION
     C*
     C                   EXSR      SRA
     C*
     C**  SUBROUTINE PERFORMS MAIN PROCESSING
     C*
     C     SSRTN         IFEQ      '0'
     C                   EXSR      SRB
     C                   END
     C*
     C**  PROGRAM TERMINATION
     C*
     C                   SETON                                        LR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C     SRA           BEGSR
     C*****************************************************
     C*                                                   *
     C*   SUBROUTINE TO PERFORM FIRST CYCLE PROCESSING    *
     C*                                                   *
     C*   SUBROUTINE CALLED FROM MAIN PROGRAM             *
     C*   USES NO OTHER PROGRAM DEFINED SUBROUTINES       *
     C*                                                   *
     C*         INITIALISED WORKFIELDS :-                 *
     C*               I      - INDEX TO ARRAY SSY         *
     C*               J      - INDEX TO ARRAY SSM         *
     C*               SSLEAP - FLAG INDICATING LEAP YEAR  *
     C*                                                   *
     C*****************************************************
     C*
     C                   MOVEA     CPY@          BIS@             80
     C*
     C**  INDICATORS USED SET OFF
     C*
     C                   SETOFF                                       6061
     C*
     C**  INITIAISING FIELDS TO BE RETURNED TO CALLING PROGRAM
     C*
     C                   MOVE      *ZEROS        SSDATE            6 0
     C                   MOVE      *BLANKS       SSDATA            7
     C                   MOVE      *ZEROS        SSDAT8
     C                   MOVE      '0'           SSRTN             1
     C*
     C**  INITIALISATION OF WORKFIELDS USED IN PROGRAM
     C*
     C                   Z-ADD     1             I                 2 0
     C                   Z-ADD     1             J                 2 0
     C                   Z-ADD     1             SSLEAP            1 0
     C*
     C**  VALIDATION OF DAY NUMBER - INVALID IF NOT IN RANGE 1 - 99999
     C**  CHECK THAT NOT LESS THAN '1'
     C*
     C     SSDAYN        IFLT      1
     C                   MOVE      '1'           SSRTN
     C                   END
     C*
     C**  CHECK THAT NOT GREATER THAN '99999'
     C*
     C     SSDAYN        IFGT      99999
     C                   MOVE      '1'           SSRTN
     C                   END
     C*
     C**  CHECK THAT DATE FORMAT IS 'M' OR 'D'
     C*
     C     SSDFMT        IFNE      'M'
     C                   MOVE      '1'           SSRTN
     C                   END
     C     SSDFMT        IFEQ      'D'
     C                   MOVE      '0'           SSRTN
     C                   END
     C     SRA9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C     SRB           BEGSR
     C*****************************************************
     C*                                                   *
     C*   SUBROUTINE TO PERFORM MAIN PROCESSING           *
     C*                                                   *
     C*   SUBROUTINE CALLED FROM MAIN PROGRAM             *
     C*   USES NO OTHER PROGRAM DEFINED SUBROUTINES       *
     C*                                                   *
     C*         ARRAY INDICES USED :-                     *
     C*               I      - INDEX TO ARRAY SSY         *
     C*               J      - INDEX TO ARRAY SSM         *
     C*                                                   *
     C*         FIELDS USED IN SETTING UP OUTPUT PARAS.:- *
     C*               SSDTE  - SETTING UP OF 'SSDATE'     *
     C*               SSDTA  - SETTING UP OF 'SSDATA'     *
     C*                                                   *
     C*****************************************************
     C*
     C**  DIVISION TO DETERMINE WHETHER LEAP YEAR
     C*
     C     SSDAYN        DIV       1461          SSYEAR            4 0
     C                   MVR                     SSRDAY            5 0
     C*
     C**  CALCULATING YEAR
     C*
     C     SSYEAR        MULT      4             SSYEAR
     C                   ADD       1972          SSYEAR
     C*
     C**  LOOK UP ARRAY TO DETERMINE HOW MANY YEARS OF 4 YEAR CYCLE
     C**  HAVE PASSED.
     C*
     C     SSRDAY        LOOKUP    SSY(I)                               6060
     C*
     C**  IF YEAR IS LEAP YEAR 'SSLEAP' SET TO '0'
     C*
     C     *IN60         IFEQ      '0'
     C                   Z-ADD     0             SSLEAP
     C                   END
     C*
     C**  ADD INDEX TO YEAR TO GIVE CORRECT YEAR AND ADJUST 'SSRDAY'
     C*
     C     SSLEAP        IFEQ      1
     C     SSRDAY        SUB       SSY(I)        SSRDAY
     C     I             ADD       SSYEAR        SSYEAR
     C                   END
     C*
     C**  PROCESSING FOR LEAP YEAR
     C*
     C     SSLEAP        IFEQ      0
     C*
     C**  IF 'SSRDAY' = 60 DATE MUST BE 29TH FEBRUARY
     C*
     C     SSRDAY        IFEQ      60
     C                   Z-ADD     29            SSDAY             2 0
     C                   Z-ADD     2             SSMNTH            2 0
     C                   MOVE      SSA(2)        SSMNA             3
     C                   GOTO      SRB1
     C                   END
     C*
     C**  IF 'SSRDAY' > 60 DATE AFTER 29TH FEBRUARY. CONVERSION CAN
     C**  PROCEDE AS USUAL AFTER SUBTRACTING THE EXTRA DAY FOR THE LEAP
     C**  YEAR.   NOTE - 'SSRDAY' < 60 CONVERSION PROCEDES AS USUAL
     C*
     C     SSRDAY        IFGT      60
     C     SSRDAY        SUB       1             SSRDAY
     C                   END
     C                   END
     C*
     C**  IF DAY 'SSDAYN' EXACTLY DIVISIBLE BY 1461 (NUMBER OF DAYS IN
     C**  4 YEARS) DATE MUST BE LAST DAY OF PREVIOUS FOUR YEAR GROUP
     C*
     C     SSRDAY        IFEQ      0
     C                   Z-ADD     31            SSDAY
     C                   Z-ADD     12            SSMNTH
     C                   MOVE      SSA(12)       SSMNA             3
     C                   SUB       1             SSYEAR
     C                   GOTO      SRB1
     C                   END
     C*
     C**  LOOK UP ARRAY SSM TO DETERMINE WHICH MONTH 'SSRDAY' OCCURS IN
     C*
     C     SSRDAY        LOOKUP    SSM(J)                               61
     C                   Z-ADD     J             SSMNTH
     C     SSRDAY        SUB       SSM(J)        SSDAY
     C*
     C**  SETTING UP ALPHAMERIC MONTH NAME
     C*
     C                   MOVE      SSA(SSMNTH)   SSMNA
     C*
     C**  SETTING UP VARIABLES TO BE RETURNED TO CALLING PROGRAM
     C*
     C     SRB1          TAG
     C*
     C**  SETTING UP 7 BYTE ALPHAMERIC FIELD 'SSDATA' CONTAINING MONTH
     C**  SHORTNAME
     C*
     C                   MOVEL     SSDAY         SSDTA             5
     C                   MOVE      SSMNA         SSDTA
     C*
     C                   MOVE      SSYEAR        SSDATA
     C                   MOVEL     SSDTA         SSDATA
     C*
     C**  SETTING UP 6 DIGIT DATE 'SSDATE'. MONTH HELD IN NUMERIC FORM.
     C*
     C     SSDFMT        IFEQ      'M'
     C*
     C**  IF 'SSDFMT' = 'M', FIELD 'SSDATE' HAS MMDDYY FORMAT.
     C*
     C                   MOVE      SSDAY         SSDTE             4 0
     C                   MOVEL     SSMNTH        SSDTE
     C                   ELSE
     C*
     C**  IF 'SSDFMT' NOT 'M', FIELD 'SSDATE' HAS FORMAT DDMMYY
     C*
     C                   MOVEL     SSDAY         SSDTE
     C                   MOVE      SSMNTH        SSDTE
     C                   END
     C*
     C**  COMPLETING SET UP OF 'SSDATE'
     C*
     C                   MOVE      SSYEAR        SSDATE
     C                   MOVEL     SSDTE         SSDATE
     C*
     C**  SET UP DATE IN EIGHT DIGIT FORMAT (YYYYMMDD)
     C*
     C                   MOVE      SSDAY         SSDTE
     C                   MOVEL     SSMNTH        SSDTE
     C                   MOVE      SSDTE         SSDAT8
     C                   MOVEL     SSYEAR        SSDAT8
      *
      * Convert YYYYMMDD to DDMMYYYY or MMDDYYYY
     C     SSDFMT        IFEQ      'D'
     C     *ISO          MOVEL     SSDAT8        W#EURDATE
     C                   MOVEL     W#EURDATE     SSDAT8F
     C                   ELSE
     C     *ISO          MOVEL     SSDAT8        W#USADATE
     C                   MOVEL     W#USADATE     SSDAT8F
     C                   ENDIF
     C*
     C     SRB9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C     *PSSR         BEGSR
     C*****************************************************
     C*                                                   *
     C*   EXCEPTION ERROR SUBROUTINE                      *
     C*                                                   *
     C*   SUBROUTINE CALLED WHENEVER PROGRAM ERROR OCCURS *
     C*   CAUSES DUMP TO BE MADE                          *
     C*                                                   *
     C*   ROUTINE USES NO OTHER PROGRAM DEFINED ROUTINES  *
     C*                                                   *
     C*****************************************************
     C                   DUMP
     C                   ENDSR
**  COPYRIGHT STATEMENT
(c) Finastra International Limited 2001
**  CUMULATIVE NUMBER OF YEARS IN FOUR YEAR PERIOD
00366007310109601461
**  CUMULATIVE NUMBER OF DAYS IN YEAR BY MONTH
00000000310005900090001200015100181002120024300273003040033400365
**  MONTH SHORTNAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
