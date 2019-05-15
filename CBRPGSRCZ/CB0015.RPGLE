     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CB Close of business monitor menu')              *
     F*****************************************************************
     F*                                                               *
     F*  Midas - Close of Business Processing
     F*                                                               *
     F*  CB0015 - CLOSE OF BUSINESS MONITOR MENU                      *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1015594          Date 20Nov12               *
      *                 CCB021             Date 06Aug12               *
      *                 CCB020             Date 06Aug12               *
      *                 CSC054             Date 23Feb12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK025             Date 23Nov06               *
      *                 BG12664            Date 11Oct06               *
      *                 CSF002             Date 11Sep03               *
      *                 CAAA02             Date 16Jul03               *
      *  Converted to ILE and code-stripped                           *
      * Midas Release 4.01 -------------------------------------------*
      *                 CPK015             Date 19Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. 102795             Date 16JAN97               *
      *                 101392             Date 23MAY96               *
     F*                 094273             DATE 31OCT95               *
     F*                 S01408             DATE 20OCT95               *
     F*                 092729             DATE 12SEP95               *
     F*                 S01495             DATE 01OCT94               *
     F*                 E40938             DATE 12JUN92               *
     F*                 S01343             DATE 21AUG91               *
     F*                 LN0545             DATE 20JUL90               *
     F*                 LN0278             DATE 13JUL90               *
     F*                 LN0382             DATE 16JUN90               *
     F*                 LN0001             DATE 26APR90               *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1015594 - Disable option 2 in COB menu when PEA option 5   *
      *              is already available                             *
      *  CCB021 - COB Restructure - Non Working Day COB (Recompile)   *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CSC054 - Period End Adjustments                              *
      *  CPK025 - Revert back fix of CAAA02                           *
      *  BG12664 - Call AOMENUR0 to remove lock on the SFMENU*        *
      *            files as the database restore was failing on       *
      *            reopen.                                            *
      *  CSF002 - Global Processing                                   *
      *  CAAA02 - Remove use of INVITE keyword to enable WebFacing    *
      *           to process screens.                                 *
      *           This program must read formats rather than a file.  *
     F*  CPK015 - Remove reference to SCJRNFIN component as this is   *
     F*           redundant at Release 4.                             *
     F*  102795 - Re-write SELECTION FORMAT (CB0015F1) when ENTER key *
     F*           was pressed instead of F6 or F12.                   *
     F*  101392 - MPHAS is locked when restart causing SAVLIB fails   *
     F*  094273 - Add option to rejournal failed journalled files     *
     F*  S01408 - Addition of Core Hooks CB0015FFP1                   *
     F*                                  CB0015FFP2                   *
     F*                                  CB0015CCP1                   *
     F*                                  CB0015CCP2                   *
     F*                                  CB0015CCP3                   *
     F*                                  CB0015CCP4                   *
     F*                                  CB0015CCP5                   *
     F*  092729 - Give access to Reopen when phase is B               *
     F*  S01495 - COB Enhancements.                                   *
     F*  E40938 - RELEASE LOCK ON LDA AFTER UPDATING FOR DB ERROR     *
     F*  S01343 - MINIT RENAMED TO SCMINIT                            *
     F*  LN0545 - RE-TRY THE LOCK OF CBSTAT TO AVOID POTENTIAL        *
     F*           COB CRASH AS A NUMBER OF PROGRAMS PERFORM THE       *
     F*           *LOCK TO UPDATE THE DATA AREA                       *
     F*  LN0278 - USE NEW PROGRAM CBTIME TO ACCESS TIME AND           *
     F*           DATE IN CORRECT FORMAT FOR CALCULATIONS             *
     F*           AND REMOVE ZDATE1 SUBROUTINE                        *
     F*  LN0382 - REMOVE CALL TO AOBANKR0 AND USE RUNDAT TO           *
     F*           OBTAIN DATE FORMAT IN ORDER TO AVOID AOBANKR0       *
     F*           BEING CALLED BY ITSELF                              *
     F*  LN0001 - FIX TO ALLOW SIGNOFF OPTIONS AND REMOVE COBMON OPTION*
     F*           WHEN REOPENING I/C.                                  *
     F*****************************************************************
     F*                                                               *
     FCB0015DF  CF   E             WORKSTN
     F                                     MAXDEV(*FILE)
     FCBCOMSL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
      *
     F/COPY WNCPYSRC,CB0015FFP1
      *
     F*
      /SPACE 2
     F********************************************************************
     F*
     F*     C  L   FUNCTION OF INDICATORS
     F*
     F*    01      DISPLAY MENU CONTROLLING INDICATOR
     F*    06      COMMAND KEY 6 FOR REOPEN INPUT CYCLE OPTION
     F*    12      COMMAND KEY 12 FOR REOPEN INPUT CYCLE OPTION
     F*    31      DISPLAY MENU OPTION 1
     F*    32      DISPLAY MENU OPTION 3
     F*    33      DISPLAY MENU OPTION 2
     F*    34      DISPLAY MENU OPTION 8
     F*    35      DISPLAY MENU OPTION 10
     F*    36      DISPLAY MENU OPTION 4
     F*    37      DISPLAY MENU OPTION 9
     F*    39      DISPLAY MENU OPTION 11
     F*    38      DISPLAY MENU OPTION 99
     F*****46******DISPLAY*MENU*OPTION*5******************************                        CSF002
     F*    46      DISPLAY MENU OPTION 5 PEA Menu                                             CSC054
     F*    47      DISPLAY MENU OPTION 6
     F*    48      DISPLAY MENU OPTION 7
     F*    50      FAIL ON READ OF CB0015DF
     F*    60      INVALID OPTION ENTERED
     F*    65      ALLOW USE OF F6/F12 TO REOPEN INPUT CYCLE
     F*    70      PROTECT SCREEN IF CONFIRM/CANCEL DISPLAYED
     F*    77      FAILED CHAIN ON LF/CBCOMSL0
     F*    78      ERROR ON LOCK OF DATAAREA MPHAS
     F*    79      ERROR ON LOCK OF DATAAREA CBSTAT
      *
     F/COPY WNCPYSRC,CB0015FFP2
      *
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
     D SCRMSG          S             78    DIM(3) CTDATA PERRCD(1)                               S01
     D** SCREEN MESSAGE ARRAY
     D*
     D** OPTION ENDED IN ERROR MESSAGE ARRAY
     D*
     D** QCMDEXC COMMAND
     D*
     D*
     D*****************************************************************
     D/EJECT
     D*
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D** LOCAL DATA AREA
     D*
     D CBSTAT          DS            50
     D  CBFAIL                14     16  0
     D  NOAS                  18     19  0
     D  HALTST                20     20
     D  SCHEDT                21     25  0
     D  SCHETI                26     31  0
     D  REOPFL                32     32
     D  COBSTS                45     45
     D** CBSTAT DATA AREA
     D*
     D MPHAS           DS             1
     D  PHASE                  1      1
     D** MPHAS  DATA AREA
     D*
     D ERARR           DS
     D  OPTERR                 1     78
     D                                     DIM(1) CTDATA PERRCD(1)
     D  OPTION                 8      8
     D** SET UP ERROR OPTION NUMBER FOR ARRAY OPTERR
     D*
     D #SCJRN          DS             9
     D  #SCJR1                 1      5
     D  #SCJR2                 6      9
     D** Dataarea for calling SCJRNFAIL
     D*
     D QCMD            DS
     D  QCMD1                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  QCMD2                 81     93
     D                                     DIM(1) CTDATA PERRCD(1)
     D** DATA STRUCTURE TO SET UP QCMDEXC COMMAND
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
     D*******                                12  12 AGDFF
     D** DATA STRUCTURE TO GET DATE FROM RUNDAT DATA AREA
     D*
     D PSDS           SDS
     D  PGMSTS           *STATUS
     D  WSID                 244    253
     D  USRID                254    263
     D** DATA STRUCTURE FOR WORKSTATION ID FOR SCREEN OUTPUT
     D*
     D PEAIND          C                   CONST('PEAIndicator')                              CSC054
      *                                                                                       CSC054
      ** Constant value for PEA Indicator                                                     CSC054
      *                                                                                       CSC054
     D SDCOBP        E DS                  EXTNAME(SDCOBPPD)
     D** EXTERNAL DATA STRUCTURE FOR ACCESS OBJECT SDCOBPPD FORMAT
     D*
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC054
     D** EXTERNAL DATA STRUCTURE FOR ACCESS OBJECT SDCOBPPD FORMAT                            CSC054
     D*                                                                                       CSC054
     D**SDBANK    E DSSDBANKPD
     D***EXTERNAL*DATA*STRUCTURE*FOR*ACCESS*OBJECT*FORMAT
     D*
     DDSSDY          E DS                  EXTNAME(DSSDY)                                    BG12664
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                       CAAA02 CPK025
      * WaitTime is the time from WRITE to READ                                        CAAA02 CPK025
     d*WaitTime        s              5p 0                                             CAAA02 CPK025
     d*MaxWaitTime     s              5p 0 inz(600)                                    CAAA02 CPK025
                                                                                       CAAA02 CPK025
      * Now1Time is the time before the READ and Now2Time the time after               CAAA02 CPK025
     d*Now1Time        s               t                                               CAAA02 CPK025
     d*Now2Time        s               t                                               CAAA02 CPK025
                                                                                       CAAA02 CPK025
     D UniqueID        S             10                                                      BG12664
     D ReturnCode      S              7                                                      BG12664
     D AOOption        S              7                                                      BG12664
     D CSC054          S              1                                                       CSC054
                                                                                             BG12664
     I** FIRST DATA STRUCTURE FOR ACCESS OBJECTS, SHORT DATA STRUCTURE
     I*
     I/COPY WNCPYSRC,CB0015I001
     I*****************************************************************
     I/EJECT
     C*
     C** PARAMETER LIST TO DETERMINE WHETHER CALLED
     C** FROM MAIN MONITOR OR SECONDARY SCREEN
     C*
     C     *ENTRY        PLIST
     C                   PARM                    FROM              1
     C*
     C     WWKEY         KLIST
     C                   KFLD                    WWCOMP           10
     C                   KFLD                    WWCSEQ            5
     C*
     C** DEFINE DATA AREA LDA AND LOCK TO SET
     C** UP PROGRAM NAME FOR DATABASE ERRORS
     C*
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'CB0015  '    DBPGM
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
     C** CALL ACCESS OBJECT AOCOBPR0 TO ACCESS COB ICD FILE
     C*
     C                   CALL      'AOCOBPR0'
     C                   PARM      '*MSG   '     P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDCOBP        PARM      SDCOBP        DSFDY
     C*
     C     P@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'AOCOB'       DBFILE
     C                   MOVE      *BLANKS       DBKEY                          ***************
     C                   Z-ADD     1             DBASE                          * DB ERROR 01 *
     C                   EXSR      DBERR                                        ***************
     C                   END
      *                                                                                       CSC054
      ** Check if CSC054 Period End Adjustments is Switched On                                CSC054
      *                                                                                       CSC054
     C                   CAll      'AOSARDR0'                                                 CSC054
     C                   PARM      *BLANKS       P@RTCD                                       CSC054
     C                   PARM      '*VERIFY'     P@OPTN                                       CSC054
     C                   PARM      'CSC054'      PSARD             6                          CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC054
      *                                                                                       CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   IF        P@RTCD <> *BLANKS  AND  P@RTCD <> '*NRF   '                CSC054
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC054
     C                   EVAL      DBKEY  = 'CSC054'                                          CSC054
     C                   EVAL      DBASE  = 2                                                 CSC054
     C                   EXSR      DBERR                                                      CSC054
     C                   ELSE                                                                 CSC054
     C                   IF        P@RTCD = *BLANKS                                           CSC054
     C                   EVAL      CSC054 = 'Y'                                               CSC054
      *                                                                                       CSC054
      ** Check PEA Indicator                                                                  CSC054
      *                                                                                       CSC054
     C                   MOVE      ' '           WPEA              1                          CSC054
     C                   CALL      'AOSVALR0'                                                 CSC054
     C                   PARM                    P@RTCD                                       CSC054
     C                   PARM      PEAIND        SVALK1           20                          CSC054
     C                   PARM                    SVAL1           200                          CSC054
     C                   PARM                    SVALK2           20                          CSC054
     C                   PARM                    SVAL2           200                          CSC054
     C                   PARM                    SVALK3           20                          CSC054
     C                   PARM                    SVAL3           200                          CSC054
     C                   PARM                    SVALK4           20                          CSC054
     C                   PARM                    SVAL4           200                          CSC054
     C                   PARM                    SVALK5           20                          CSC054
     C                   PARM                    SVAL5           200                          CSC054
     C                   PARM                    SVALK6           20                          CSC054
     C                   PARM                    SVAL6           200                          CSC054
     C                   PARM                    SVALK7           20                          CSC054
     C                   PARM                    SVAL7           200                          CSC054
     C                   PARM                    SVALK8           20                          CSC054
     C                   PARM                    SVAL8           200                          CSC054
     C                   PARM                    SVALK9           20                          CSC054
     C                   PARM                    SVAL9           200                          CSC054
     C                   PARM                    SVALK0           20                          CSC054
     C                   PARM                    SVAL10          200                          CSC054
      *                                                                                       CSC054
     C                   MOVE      '0'           *IN46                                        CSC054
     C     P@RTCD        IFEQ      *BLANKS                                                    CSC054
     C                   MOVEL     SVAL1         WPEA                                         CSC054
     C     WPEA          IFEQ      'Y'                                                        CSC054
     C                   MOVE      '1'           *IN46                                        CSC054
     C                   ENDIF                                                                CSC054
     C                   ENDIF                                                                CSC054
     C                   ENDIF                                                                CSC054
     C                   ENDIF                                                                CSC054
     C*
     C** DO WHILE INDICATOR 01 IS OFF
     C** AND SCREEN NOT TIMED OUT
     C*
     C     *IN01         DOWEQ     '0'
     C     *INU1         ANDNE     '1'
     C*
     C** SET ON INDICATORS TO DISPLAY OPTIONS 1,7,8 AND 9
     C*
     C                   SETON                                        313437
     C                   SETON                                        48
     C*
     C** DEFINE AND LOCK DATA AREA CBSTAT
     C*
     C     *DTAARA       DEFINE                  CBSTAT
     C     *LOCK         IN        CBSTAT                               79
     C*
     C** DEFINE AND LOCK DATA AREA MPHAS
     C*
     C     *DTAARA       DEFINE                  MPHAS
     C     *LOCK         IN        MPHAS                                78
     C*
     C** IF ERROR OCCURS ON LOCK OF DATA AREA CBSTAT OR MPHAS
     C** (IE IT IS BEING LOCKED BY ANOTHER PROGRAM)
     C** EXIT PROGRAM USING PROGRAM STATUS SUBROUTINE
     C*
     C     *IN79         IFEQ      '1'
     C     *IN78         OREQ      '1'
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF COMPONENT SCC0411 HAS NOT RUN, SET ON INDICATOR 47
     C** TO ALLOW OPTION 6 (ENTRY OF RUNDATE)
     C*
     C                   MOVE      *BLANKS       WWCOMP
     C                   MOVEL     'SCC0411'     WWCOMP
     C                   MOVEL     '00001'       WWCSEQ
     C*
     C** Open file LF/CBCOMSL0
     C*
     C                   OPEN      CBCOMSL0
     C*
     C     WWKEY         CHAIN     CBCOMSL0                           77
     C*
     C     *IN77         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'CBCOMSL0'    DBFILE
     C                   MOVEL     WWCOMP        DBKEY                          ***************
     C                   Z-ADD     2             DBASE                          * DB ERROR 02 *
     C                   EXSR      DBERR                                        ***************
     C                   END
     C*
     C     DHCSTS        IFEQ      *BLANKS
     C                   SETON                                        47
     C                   END
      ** Check if SCC000121 00001 was already called                                          CSC054
     C                   IF        CSC054 = 'Y'                                               CSC054
     C                   EVAL      WWCOMP = *BLANKS                                           CSC054
     C                   EVAL      WWCOMP = 'SCC000121'                                       CSC054
     C                   EVAL      WWCSEQ = '00001'                                           CSC054
     C     WWKEY         CHAIN     CBCOMSL0                           77                      CSC054
     C                   IF        *IN77 = '1'                                                CSC054
     C                   EVAL      *IN46 = '0'                                                CSC054
     C                   ELSE                                                                 CSC054
     C                   IF        DHCODP <> 0                                                CSC054
     C                   EVAL      *IN46 = '0'                                                CSC054
     C                   ENDIF                                                                CSC054
     C                   ENDIF                                                                CSC054
     C                   ENDIF                                                                CSC054
     C****************************************************************                        CSF002
     C***IF*MPHAS*EQUALS*'F'*AND*COMPONENT*SCC0411*HAS*NOT*RUN,*SET***                        CSF002
     C***ON*INDICATOR*46*TO*ALLOW*OPTION*5*(COB*ON*REQUESTS*REPORT****                        CSF002
     C****************************************************************                        CSF002
     C*****PHASE         IFEQ      'F'                                                        CSF002
     C****************************************************************                        CSF002
     C**********         MOVE      *BLANKS       WWCOMP                                       CSF002
     C**********         MOVEL     'SCC0411'     WWCOMP                                       CSF002
     C**********         MOVEL     '00001'       WWCSEQ                                       CSF002
     C****************************************************************                        CSF002
     C*****WWKEY         CHAIN     CBCOMSL0                           77                      CSF002
     C****************************************************************                        CSF002
     C******IN77         IFEQ      '1'                                                        CSF002
     C******LOCK         IN        LDA                                                        CSF002
     C**********         MOVEL     'CBCOMSL0'    DBFILE                                       CSF002
     C**********         MOVEL     WWCOMP        DBKEY                          ***************SF002
     C**********         Z-ADD     3             DBASE                          * DB ERROR 03 *SF002
     C**********         EXSR      DBERR                                        ***************SF002
     C**********         END                                                                  CSF002
     C****************************************************************                        CSF002
     C*****DHCSTS        IFEQ      *BLANKS                                                    CSF002
     C**********         SETON                                        46                      CSF002
     C**********         END                                                                  CSF002
     C**********         END                                                                  CSF002
     C*
     C*
     C** Close file LF/CBCOMSL0
     C*
     C                   CLOSE     CBCOMSL0
     C*
     C** IF REOPEN FAIL INDICATOR (POS 32) IS ON SET
     C** OFF INDICATORS DISPLAYING OPTIONS 1,8 AND 9
     C*
     C     REOPFL        IFEQ      'Y'
     C                   SETOFF                                       313437
     C*
     C                   ELSE
     C*
     C** IF CLOSE OF BUSINESS RUN HAS HALTED (CBSTAT POS
     C** 20 = Y) SET INDICATOR TO DISPLAY OPTION 2
     C*
     C     HALTST        IFEQ      'Y'
     C                   SETON                                        33
     C                   END
     C*
      ** Disable Option 2 when PEA Option 5 is available                                   AR1015594
      *                                                                                    AR1015594
     C     CSC054        IFEQ      'Y'                                                     AR1015594
     C     WPEA          ANDEQ     'Y'                                                     AR1015594
     C     *IN46         ANDEQ     '1'                                                     AR1015594
     C                   SETOFF                                       33                   AR1015594
     C                   ENDIF                                                             AR1015594
      *                                                                                    AR1015594
     C                   END
     C*
     C** IF COMPONENTS HAVE FAILED (CBSTAT POS 14-16 NOT ZERO)
     C** AND ATTEMPT TO REOPEN INPUT CYCLE HAS NOT FAILED
     C** SET INDICATOR TO DISPLAY OPTION 3
     C*
     C     CBFAIL        IFGT      0
     C     REOPFL        ANDNE     'Y'
     C                   SETON                                        32
     C                   END
     C*
     C** IF COMMAND ENTRY FLAG (FROM SDCOBPL0) = Y AND
     C** ERROR COUNT (CBSTAT POS 14-16) IS GREATER THAN 0
     C*
     C     DOAQCM        IFEQ      'Y'
     C     CBFAIL        ANDGT     0
     C                   SETON                                        35
     C                   END
     C*
     C*
     C*
     C                   CALL      'CBTIME'
     C                   PARM                    DAYNOA            5
     C                   PARM                    STIME             6
     C                   PARM                    DFMT              1
     C*
     C** MOVE DAY NO FROM CBTIME TO DATE WORK FIELD (DWF)
     C** AND TIME (HHMM) TO TIME WORK FIELD (TWF)
     C** HAVING SUBTRACTED 1 MINUTE
     C*
     C                   MOVE      DAYNOA        DWF               5 0
     C                   MOVE      STIME         SCTIME            6 0
     C     SCTIME        SUB       100           TWF               6 0
     C*
     C** IF    CLOSE OF BUSINESS RUN HAS HALTED (POS 20 = Y)
     C** OR    LAST SCHEDULED DATE CBSTAT POS 21-25 IS NOT ZERO AND
     C**       IS LESS THAN THE SYSTEM DATE AND THE NUMBER OF
     C**       ACTIVE STREAMS = 0
     C** OR    LAST SCHEDULED DATE CBSTAT POS 21-25 IS NOT ZERO AND
     C**       IS EQUAL TO THE SYSTEM DATE AND THE LAST SCHEDULED
     C**       TIME CBSTAT POS 26-31 IS LESS THAN THE SYSTEM TIME
     C**       MINUS 1 MINUTE AND NO OF ACTIVE STREAMS = 0
     C*
     C     HALTST        IFEQ      'Y'
     C     SCHEDT        ORLT      DWF
     C     SCHEDT        ANDNE     0
     C     NOAS          ANDEQ     0
     C     SCHEDT        OREQ      DWF
     C     SCHETI        ANDLT     TWF
     C     SCHEDT        ANDNE     0
     C     NOAS          ANDEQ     0
     C*
     C** SET ON INDICATOR TO DISPLAY OPTIONS 4 & 11
     C*
     C***********          SETON                     3638
     C                   SETON                                        38
     C*
     C** IF MPHAS EQUALS 'C'  OR 'D', SET ON IDICATOR 36 TO ALLOW
     C** OPTION 4 (REOPEN INPUT CYCLE)
     C*
     C     PHASE         IFEQ      'C'
     C*****PHASE         OREQ      'D'                                                        CCB020
     C*****PHASE         OREQ      'B'                                                        CCB020
     C                   SETON                                        36
     C                   END
     C*
     C** SET UP SWITCH WORK FIELD DEPENDING ON WHETHER CLOSE
     C** OF BUSINESS RUN HAS HALTED (CBSTAT POS 20 = Y)
     C*
     C     HALTST        IFEQ      'Y'
     C*
     C                   MOVE      'H'           SWWF              1
     C                   ELSE
     C*
     C                   MOVE      'R'           SWWF
     C                   END
     C*
     C                   END
     C*
     C** UNLOCK DATA AREA CBSTAT
     C*
     C                   OUT       CBSTAT
     C*
     C** IF PROGRAM CALLED FROM SECONDARY SCREEN
     C** SET INDICATORS TO DISPLAY OPTION 11
     C** AND NON DISPLAY OPTIONS 4 & 9
     C*
     C     FROM          IFEQ      'B'
     C                   SETON                                        38
     C                   SETOFF                                       3637
     C*
     C                   END
     C*
     C** IF PROGRAM CALLED AS RESTART DISPLAY SCREEN
     C** SET INDICATORS TO DISPLAY OPTIONS 4 & 11
     C** AND NON DISPLAY OPTION 9 WHILST THERE ARE
     C** FAILED COMPONENTS WHICH REQUIRE RESTARTING
     C*
     C     FROM          IFEQ      'R'
     C     *IN32         ANDEQ     '1'
     C                   SETON                                        3638
     C                   SETOFF                                       37
     C*
     C** ELSE
     C** IF PROGRAM CALLED AS RESTART DISPLAY SCREEN
     C** AND THERE ARE NO FAILED COMPONENTS TO RESTART
     C** SET INDICATORS TO NON DISPLAY OPTIONS 4 & 11
     C** AND DISPLAY OPTION 9
     C** OPTIONS 4 & 11 NOT DISPLAYED IF REOPEN I/C  FAILED
      *
     C                   ELSE
     C     FROM          IFEQ      'R'
     C     *IN32         ANDEQ     '0'
     C     REOPFL        ANDNE     'Y'
     C*
     C                   SETOFF                                       3638
     C*
     C** IF RESTART AFTER HALT OPTION DISPLAYED
     C** ENSURE RETURN TO MONITOR OPTION (9) IS NOT DISPLAYED
     C*
     C     *IN33         IFEQ      '0'
     C                   SETON                                        37
     C                   ELSE
     C                   SETOFF                                       37
     C                   END
     C                   END
     C*
     C                   END
      *
     C/COPY WNCPYSRC,CB0015CCP1
      *
     C*
     C** SET UP CURRENT TIME FOR DISPLAY ON SCREEN
     C*
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
     C** WRITE HEADER AND SELECTION FORMATS
     C*
     C                   WRITE     CB0015F0
     C                   WRITE     CB0015F1
     C************       READ      CB0015DF                             U150           CAAA02
     C                   READ      CB0015DF                             U150                  CPK025
      **********/free                                                                         CPK025
      **********   Now1Time = %time();                                             //CAAA02   CPK025
      **********                                                                   //CAAA02   CPK025
      **********   read CB0015F1;                                                  //CAAA02   CPK025
      **********   if %eof;                                                        //CAAA02   CPK025
      **********      *in50='1';                                                   //CAAA02   CPK025
      **********   endif;                                                          //CAAA02   CPK025
      **********                                                                   //CAAA02   CPK025
      **********   Now2Time = %time();                                             //CAAA02   CPK025
      **********                                                                   //CAAA02   CPK025
      **********   WaitTime = %diff(Now2Time:Now1Time:*SECONDS);                   //CAAA02   CPK025
      **********   if WaitTime >= MaxWaitTime;                                     //CAAA02   CPK025
      **********      *inu1 = '1';                                                 //CAAA02   CPK025
      **********   endif;                                                          //CAAA02   CPK025
      **********/end-free                                                                     CPK025
     C*
     C** IF SCREEN HAS NOT BEEN TIMED OUT
     C*
     C     *INU1         IFNE      '1'
     C*
     C** SET OFF SCREEN ERROR INDICATOR
     C*
     C                   SETOFF                                       60
     C*
     C** LEFT JUSTIFY THE OPTION TAKEN (SELECT FIELD)
     C*
     C                   MOVEL     SELECT        WSLCT             1
     C                   MOVE      SELECT        WSLCT2            1
     C     WSLCT         IFEQ      ' '
     C                   MOVE      *BLANKS       SELECT
     C                   MOVEL     WSLCT2        SELECT
     C                   MOVE      *BLANKS       WSLCT2
     C                   END
     C*
     C** IF OPTION TAKEN IS INVALID THEN SET ON
     C** ERROR INDICATOR AND WRITE ERROR MESSAGE
     C*
     C     SELECT        IFEQ      '1'
     C     *IN31         ANDEQ     '0'
     C     SELECT        OREQ      '2'
     C     *IN33         ANDEQ     '0'
     C     SELECT        OREQ      '3'
     C     *IN32         ANDEQ     '0'
     C     SELECT        OREQ      '4'
     C     *IN36         ANDEQ     '0'
     C     SELECT        OREQ      '5'
     C     *IN33         ANDEQ     '0'                                                        CSC054
     C     SELECT        OREQ      '5'                                                        CSC054
     C     CSC054        ANDEQ     'Y'                                                        CSC054
     C     WPEA          ANDEQ     'Y'                                                        CSC054
     C     *IN46         ANDEQ     '0'                                                        CSC054
     C     SELECT        OREQ      '5'                                                        CSC054
     C     CSC054        ANDEQ     'N'                                                        CSC054
     C     SELECT        OREQ      '5'                                                        CSC054
     C     WPEA          ANDEQ     'N'                                                        CSC054
     C******IN46         ANDEQ     '0'                                                        CSF002
     C     SELECT        OREQ      '6'
     C     *IN47         ANDEQ     '0'
     C     SELECT        OREQ      '7'
     C     *IN48         ANDEQ     '0'
     C     SELECT        OREQ      '8'
     C     *IN34         ANDEQ     '0'
      *
     C/COPY WNCPYSRC,CB0015CCP2
      *
     C     SELECT        OREQ      '9'
     C     *IN37         ANDEQ     '0'
     C     SELECT        OREQ      '10'
     C     *IN35         ANDEQ     '0'
     C     SELECT        OREQ      '99'
     C     *IN38         ANDEQ     '0'
     C     SELECT        ORLT      '1'
     C     SELECT        ORGT      '11'
      *
     C/COPY WNCPYSRC,CB0015CCP3
      *
     C     SELECT        ANDLT     '99'
     C     WSLCT2        ANDNE     *BLANKS
     C     WSLCT2        ORLT      '0'
     C     WSLCT2        ANDNE     *BLANKS
     C*
     C                   SETON                                        60
     C                   MOVE      SELECT        OPTION
     C                   MOVE      SCRMSG(1)     ERRMSG
     C*
     C** ELSE CALL PROGRAM REQUESTED FROM MENU
     C*
     C                   ELSE
     C* RELEASE MPHAS
     C                   OUT       MPHAS                                99
     C*
     C*
     C** IF VALUE = 1 CALL HALT MENU PROGRAM CB0020
     C*
     C     SELECT        IFEQ      '1'
     C                   CALL      'CBC0026'
     C                   PARM      'CB0020'      PROG             10
     C                   PARM                    ERROR             1
     C                   END
     C*
     C** IF VALUE = 3 CALL RESTART FAILED COMPONENTS PROGRAM CB0065
     C*
     C     SELECT        IFEQ      '3'
     C                   CALL      'CBC0026'
     C                   PARM      'CB0065'      PROG             10
     C                   PARM                    ERROR             1
     C                   END
     C*
     C** IF VALUE = 2 CALL RESTART AFTER HALT PROGRAM CBC0070
     C*
     C     SELECT        IFEQ      '2'
     C                   CALL      'CBC0026'
     C                   PARM      'CBC0070'     PROG             10
     C                   PARM                    ERROR
     C                   END
     C*
     C** IF VALUE = 8 CALL CLOSE OF BUSINESS ENQUIRY PROGRAM CBC0060
     C*
     C     SELECT        IFEQ      '8'
     C                   CALL      'CBC0026'
     C                   PARM      'CB0060'      PROG             10
     C                   PARM                    ERROR
     C                   END
     C*
     C** IF VALUE = 10 DISPLAY COMMAND ENTRY SCREEN
     C*
     C     SELECT        IFEQ      '10'
     C                   CALL      'QCMD'
     C                   END
     C*
     C** IF VALUE = 4 REOPEN INPUT CYCLE
     C*
     C     SELECT        IFEQ      '4'
     C*
     C** SET MESSAGE FIELD AND ALLOW
     C** USE OF KEYS F6 AND F12
     C*
     C                   MOVE      SCRMSG(2)     ERRMSG
     C                   SETON                                        606570
     C*
     C** WRITE SELECTION FORMAT (CB0015F1) TO SCREEN
     C*
     C                   WRITE     CB0015F1
     C*
     C** DO WHILE COMMAND KEYS F6 AND F12
     C** NOT PRESSED, SCREEN NOT TIMED OUT
     C*
     C     *IN06         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C     *INU1         ANDEQ     '0'
     C*
     C** Re-write SELECTION FORMAT (CB0015F1) to screen if neither F6
     C** nor F12 was chosen
     C*
     C                   WRITE     CB0015F1
     C*
     C************       READ      CB0015DF                             U150           CAAA02
     C                   READ      CB0015DF                             U150                  CPK025
      **********/free                                                                         CPK025
      **********   Now1Time = %time();                                               //CAAA02 CPK025
      **********                                                                     //CAAA02 CPK025
      **********   read CB0015F1;                                                    //CAAA02 CPK025
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
     C                   END
     C                   SETOFF                                       70
     C*
     C** IF KEY F6 PRESSED AND SCREEN NOT TIMED OUT
     C*
     C     *IN06         IFEQ      '1'
     C     *INU1         ANDEQ     '0'
     C*
     C** CALL CBC0028 TO SETUP MSGQ/MSPECIAL AND TO REOPEN INPUT CYCLE.
     C*
      * Release the lock on the SFMENU* files so that the database can be restored.          BG12664
      *                                                                                      BG12664
     C                   Eval      AOOption = '*FREE'                                        BG12664
      *                                                                                      BG12664
     C                   CALL      'AOMENUR0'                                                BG12664
     C                   PARM                    ReturnCode                     Return code  BG12664
     C                   PARM                    AOOption                       AOOption     BG12664
     C                   PARM                    UniqueID                       UniqueID     BG12664
     C                   PARM                    DSSDY                          Format       BG12664
      *                                                                                      BG12664
     C                   CALL      'CBC0028'
     C*
     C** IF SCMINIT FAILS TO REOPEN INPUT CYCLE
     C** (IE CBSTAT POS 32 IS STILL = 'Y')
     C** DEACTIVATE COMMAND KEYS F6 AND F12,
     C** AND WRITE ERROR MESSAGE
     C*
     C     *IN79         DOUEQ     '0'
     C     *LOCK         IN        CBSTAT                               79
     C                   END
     C     REOPFL        IFEQ      'Y'
     C*
     C                   SETOFF                                       65
     C                   MOVE      SELECT        OPTION
     C                   MOVE      OPTERR(1)     ERRMSG
     C*
     C                   END
     C*
     C                   ELSE
     C*
     C** ELSE IF COMMAND KEY 12 PRESSED TO CANCEL REQUEST
     C** TO REOPEN INPUT CYCLE THEN CLEAR MESSAGE
     C*
     C     *IN12         IFEQ      '1'
     C                   SETOFF                                       60
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C** IF VALUE = 9 RETURN TO MAIN CLOSE OF BUSINESS MONITOR
     C*
     C     SELECT        IFEQ      '9'
     C                   SETON                                        01
     C                   END
      *                                                                                       CSF002
      ** CBC0301 (CoB on-request reports) is redundant at Midas Plus.                         CSF002
      *                                                                                       CSF002
     C****************************************************************                        CSF002
     C***IF*VALUE*=*5*CALL*PROGRAM*CBC0301*TO*DISPLAY*COB*REPORTS*MENU                        CSF002
     C****************************************************************                        CSF002
     C*****SELECT        IFEQ      '5'                                                        CSF002
     C****************************************************************                        CSF002
     C***CHECK*TO*SEE*IF*USER*IS*AUTHORISED*TO*THE*SYSTEM*************                        CSF002
     C****************************************************************                        CSF002
     C**********         CALL      'SF0410'                                                   CSF002
     C**********         PARM                    @GROUP           50                          CSF002
     C**********         PARM                    @USER            25                          CSF002
     C**********         PARM                    @SLEVL            4 0                        CSF002
     C**********         PARM                    @TIMEO            5 0                        CSF002
     C**********         PARM                    @ERROR            1 0                        CSF002
     C**********         PARM                    @MULT             2                          CSF002
     C****************************************************************                        CSF002
     C***IF*USER*IS*DEFINED*TO*THE*SYSTEM*****************************                        CSF002
     C****************************************************************                        CSF002
     C*****@ERROR        IFNE      1                                                          CSF002
     C**********         CALL      'CBC0301'                                                  CSF002
     C**********         PARM                    @USER                                        CSF002
     C**********         PARM                    @SLEVL                                       CSF002
     C**********         PARM                    @TIMEO                                       CSF002
     C**********         END                                                                  CSF002
     C**********         END                                                                  CSF002
     C*                                                                                       CSC054
     C** IF VALUE = 5 CALL PEA MENU                                                           CSC054
     C*                                                                                       CSC054
     C                   IF        SELECT = '5' AND                                           CSC054
     C                             CSC054 = 'Y'                                               CSC054
     C                             AND WPEA = 'Y'                                             CSC054
     C                             AND *IN46 = '1'                                            CSC054
     C                   CALL      'CBC0026'                                                  CSC054
     C                   PARM      'CB0700'      PROG                                         CSC054
     C                   PARM                    ERROR                                        CSC054
     C                   ENDIF                                                                CSC054
     C*
     C** IF VALUE = 6 CALL PROGRAM SD1020 TO ENTER RUNDATE
     C*
     C     SELECT        IFEQ      '6'
     C/COPY WNCPYSRC,CB0015C001
     C                   CALL      'SD1020'
     C/COPY WNCPYSRC,CB0015C002
     C                   END
     C*
     C** IF VALUE = 7 CALL PROGRAM SDC1740 (SAVE PARAMETERS MAIN-
     C*  TENANCE OPTION)
     C*
     C     SELECT        IFEQ      '7'
     C                   CALL      'SDC1740'
     C                   END
      *
      ** If Option 11 taken Display journal failure screen
      *
     C     SELECT        IFEQ      '11'
     C                   MOVEL     'SCJRN'       #SCJR1
     C                   MOVEL     'FAIL'        #SCJR2
     C                   CALL      #SCJRN
     C                   END
     C*
     C** IF VALUE = 99 CALL PROGRAM CBC0027 TO SIGN OFF
     C*
     C     SELECT        IFEQ      '99'
     C*
     C** IF PROGRAM CALLED FROM SECONDARY SCREEN
     C** SIGN OFF WITH PARAMETER 'B'
     C*
     C     FROM          IFEQ      'B'
     C                   CALL      'CBC0027'
     C                   PARM      'B'           PARM              1
     C*
     C** IF CALLED FROM MAIN MONITOR SET PARAMETER
     C** DEPENDING ON HALT STATUS TO
     C** CANCEL SCHEDULER AND SIGN OFF
     C*
     C                   ELSE
     C*
     C     SWWF          IFEQ      'H'
     C*
     C                   CALL      'CBC0027'
     C                   PARM      'H'           PARM
     C                   ELSE
     C*
     C                   CALL      'CBC0027'
     C                   PARM      'R'           PARM
     C                   END
     C*
     C                   END
     C*
     C** SET ON ERROR INDICATOR AND WRITE ERROR MESSAGE SINCE
     C** IF PROGRAM REACHES THIS POINT CBC0027 HAS FAILED
     C*                                                                D
     C                   SETON                                        60
     C                   MOVE      SELECT        OPTION
     C                   MOVE      OPTERR(1)     ERRMSG
     C                   END
      *
     C/COPY WNCPYSRC,CB0015CCP4
      *
     C*
     C** IF ERROR PARAMETER PASSED BACK FROM CBC0026
     C** IS 'Y' SET ON ERROR INDICATOR AND SET UP ERROR
     C** MESSAGE AS 'OPTION X ENDED IN ERROR'
     C*
     C     ERROR         IFEQ      'Y'
     C                   SETON                                        60
     C                   MOVE      SELECT        OPTION
     C                   MOVE      OPTERR(1)     ERRMSG
     C                   END
     C****************************************************************                        CSF002
     C***IF*ERROR*PARAMETER*PASSED*BACK*FROM*SF0410*******************                        CSF002
     C***IS*'1',*SET*ON*ERROR*INDICATOR*AND*SET*UP*ERROR**************                        CSF002
     C***MESSAGE*AS*'USER*NOT*DEFINED*TO*THE*SYSTEM'******************                        CSF002
     C****************************************************************                        CSF002
     C*****@ERROR        IFEQ      1                                                          CSF002
     C**********         SETON                                        60                      CSF002
     C**********         MOVE      SCRMSG(3)     ERRMSG                                       CSF002
     C**********         END                                                                  CSF002
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
     C*****@ERROR        ANDNE     1                                                          CSF002
     C                   MOVE      *BLANKS       SELECT
     C                   WRITE     CB0015F2
     C                   SETOFF                                       323335
     C                   SETOFF                                       3638
     C                   SETOFF                                       39
      *
     C/COPY WNCPYSRC,CB0015CCP5
      *
     C**********         SETOFF                                       4647                    CSF002
     C                   SETOFF                                       47                      CSF002
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
     C**
     C** INDEX OF SUBROUTINES
     C**
     C**
     C** *PSSR  - PROGRAM STATUS SUBROUTINE
     C** DBERR  - DATABASE ERROR PROCESSING SUBROUTINE
     C**
     C********************************************************************
     C*
     C/EJECT
     C********************************************************************
     C** *PSSR SUBROUTINE
     C*
     C** SUBROUTINE TO SEND MESSAGE ON LOCK OF
     C** DATA AREA CBSTAT AND RETURN TO MONITOR
     C*
     C     *PSSR         BEGSR
     C*
     C     PGMSTS        IFEQ      00432
     C*
     C                   Z-ADD     93            LEN              15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    QCMD
     C                   PARM                    LEN
     C                   SETON                                        LR
     C                   RETURN
     C                   END
     C*
     C                   ENDSR
     C*
      /EJECT
     C*************************************************************
     C*
     C** S/R DBERR TO PERFORM DATABASE ERROR EXIT FROM PROGRAM
     C*
     C** CALLED FROM MAIN CYCLE
     C*
     C** CALLS NO OTHER SUBROUTINES
     C*
     C*************************************************************
     C*
     C     DBERR         BEGSR
     C*
     C** SETON INDICATORS U7 U8 LR
     C** AND RETURN TO CALLING PROGRAM
     C*
     C                   SETON                                        U7U8LR
     C                   OUT       LDA
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C********************************************************************
      /EJECT
**CTDATA SCRMSG
ENTRY MUST BE A VALID OPTION NUMBER
PRESS F6 TO CONFIRM OR F12 TO CANCEL REQUEST TO REOPEN INPUT CYCLE
USER NOT DEFINED/AUTHORISED TO THE SYSTEM
**CTDATA OPTERR
OPTION   ENDED IN ERROR
**CTDATA QCMD1
SNDMSG MSG('TEMPORARILY UNABLE TO ACCESS C.O.B. CONTROL MENU - PLEASE RE-TRY') T
**CTDATA QCMD2
OMSGQ(MOPERQ)
