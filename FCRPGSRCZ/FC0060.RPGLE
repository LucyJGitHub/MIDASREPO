     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas FC Review todays reporting')
      *****************************************************************
      *                                                               *
      *  Midas - Report Control Facility Module                       *
      *                                                               *
      *      FC0060 - REVIEW TODAY'S REPORTING                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAAA02  *CONVERT   Date 02Dec03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 090344           Date 19Jan98                 *
      *                 101040           Date 25Feb97                 *
      *                 087380           Date 10May95                 *
      *                 083547           Date 20Feb95                 *
      *                 S01486           Date 07Jun94                 *
      *                 S01117           Date 25Mar92                 *
      *                 S01269           Date 25Jun91                 *
      *                 LN1153           Date 06May91                 *
      *                 LN0986           Date 03May91                 *
      *                 S01314           Date 24Apr91                 *
      *                 LN1208           Date 20Mar91                 *
      *                 LN1186           Date 06Mar91                 *
      *                 BHF789           Date 25Jan91                 *
      *                 LN0843           Date 09Oct90                 *
      *                 BHF719           Date 01Oct90                 *
      *                 LN0366           Date 13Jun90                 *
      *                 LN0344           Date 11Jun90                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CAAA02 - Converted to ILE due to file opening issues with    *
      *           FCYREQL1 and then Recompiled due to changes in      *
      *           FC0060DF                                            *
      *  090344 - When CF11 Pressed to produce Report, pgm set up     *
      *           System report but FC0600 is only available by       *
      *           Branch - set up parameters correctly.               *
      *  101040 - Branch type not taken from FCRCOML1 file            *
      *  087380 - Enlarge parameter for AOUSERR0                      *
      *  083547 - Recompile over MUSERDD                              *
      *  S01486 - Private Banking Upgrade to ABS 10.                  *
      *           Screen Level and Entity should always be shown.     *
      *           Recompiled over new display file.                   *
      *  S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD                  *
      *  S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO         *
      *           MUSERDD                                             *
      *  LN1153 - 1. DISPLAY PERSONAL OUTPUT QUEUE IF CF14 IS TAKEN   *
      *              INSTEAD OF WORKING WITH IT.                      *
      *           2. CHANGE SOME ERROR MESSAGES SENT DURING           *
      *              VALIDATION.ALTER HELP                            *
      *           3. DO NOT SEND MESSAGE RCF1021 IF ENTER PRESSED ON  *
      *              DELETE SCREEN.                                   *
      *           4. ENABLE F5 TO REBUILD THE SUBFILE.                *
      *           5. IF CF11 IS TAKEN TO PRINT A LIST SEND A MESSAGE  *
      *              TO INDICATE THAT THE REPORT HAS BEEN SUBMITTED.  *
      *  LN0986 - IF NO DETAILS EXIST, WRITE A BLANK RECORD TO        *
      *           SUBFILE IN ORDER TO CLEAR SCREEN                    *
      *  S01314 - Changes made during PTF incorporation.              *
      *           Multilanguage subfile message tags changed          *
      *  LN1208 - ON YESTERDAYS REPORTING ENQUIRY, DISPLAY            *
      *           DISTRIBUTION LIST FIELDS IN CORRECT ORDER           *
      *  LN1186 - SEND NEW MESSAGE ID FROM FCUSRMSG TO FCC0240        *
      *  BHF789 - ALLOW ANYONE TO DELETE HIS OWN REPORT REQUESTS      *
      *  LN0843 - REPORT POSITIONING FIELD SHOULD RETAIN VALUE        *
      *           SELECTED AND CARRY FORWARD TO SECOND SCREEN         *
      *  BHF719 - SELECT FIELD SHOULD RETAIN VALUE SELECTED           *
      *  LN0366 - DISABLE CF11 IF YESTERDAYS OUTPUT                   *
      *  LN0344 - CALL TO FC0040X, PARM P1RNAM CHANGED TO FC0060      *
      *                                                               *
      *****************************************************************
      *
      *              FUNCTION OF INDICATORS
      *
      *   01 - NO SUBFILE DETAILS YET DISPLAYED
      *   03 - EXIT PROG (F3)
      *   07 - TOGGLE BETWEEN TODAY AND YESTERDAY (F7)
      *   12 - TAKES USER BACK TO FIRST SCREEN (F12)
      *   10 - DELETE KEY TAKEN (F10)
      *   11 - SUBMIT REPORT OF TODAY'S DETAILS (F11)
      *   14 - DISPLAY OUTPUT QUEUE ON MUSER (F14)
      *   20 - SFLDSP
      *   21 - SFLDSPCTL
      *   22 - SFLNXTCHG
      *   23 - SFLCLR
      *   24 - END OF FILE FOR FCRREQ* OR FCYREQ* & SFLEND
      *   25 - END OF CHANGED SUBFILE RECORDS
      *   26 - LOKUP INDICATOR
      *   27 - END OF FILE FCRCOML1
      *   30 - USER ERROR
      *   31 - BRANCH ERROR
      *   32 - REPORT NAME ERROR
      *   41 - FILE IS SET TO FCRREQL5
      *   42 - FILE IS SET TO FCRREQL6
      *   43 - FILE IS SET TO FCRREQL7
      *   44 - FILE IS SET TO FCRREQL1
      *   45 - FILE IS SET TO FCYREQL5
      *   46 - FILE IS SET TO FCYREQL6
      *   47 - FILE IS SET TO FCYREQL7
      *   48 - FILE IS SET TO FCYREQL1
      *   50 - SINGLE BRANCH INDICATOR
      *   51 - STATUS (ON = TODAY, OFF = YESTERDAY)
      *   53 - USER AUTHORISED TO CHANGE OUTPUT
      *   54 - USER HAS OUTPUT QUEUE
      *   55 - ACCESS TO OTHER REPORTS
      *   56 - ACCESS TO MULTIBRANCHES
      *   60 - END OF SUBFILE MESSAGE FORMAT
      *   70 - SUBFILE RECORDS EXIST
      *   80 - ERROR ON INITIAL SCREEN
      *   81 - ERROR ON SUBFILE SELECTION SCREEN
      *   82 - CHAIN FAIL TO REPORT REQUEST RECORD
      *   83 - RECORDS ON MAARCDPD FOR REQUEST
      *   82 - CHAIN FAIL TO PARAMETERS DAILY RECORD
      *   88 - CHAIN FAIL TO REPORT DESCRIPTION
      *   89 - END OF FILE FCRREPTL1
      ********************************************************************
     FFC0060DF  CF   E             WORKSTN
     F                                     SFILE(FC0060S1:RRN)
     FFCRREQL0  UF   E           K DISK
     F                                     COMMIT
     FFCPARDL0  UF   E           K DISK
     F                                     COMMIT
     FMAARCDL2  UF   E           K DISK
     F                                     COMMIT
     FFCRREQL1  IF   E           K DISK
     FFCRREQL5  IF   E           K DISK
     FFCRREQL6  IF   E           K DISK
     FFCRREQL7  IF   E           K DISK
     FFCYREQL1  IF   E           K DISK
     FFCYREQL5  IF   E           K DISK
     FFCYREQL6  IF   E           K DISK
     FFCYREQL7  IF   E           K DISK
     FFCREPTL1  IF   E           K DISK
     FFCPREQL1  IF   E           K DISK
     FFCRCOML1  IF   E           K DISK
     F/COPY WNCPYSRC,FC0060F001
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D CMD             S             50    DIM(1) CTDATA PERRCD(1)
     D TABFRQ          S              1    DIM(13) CTDATA PERRCD(1)
     D TABNAM          S              8    DIM(13) ALT(TABFRQ)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** 200 BYTE DATASTRUCTURE FOR ACCESS PROGRAMS
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)                       087380
      *                                                                   087380
      ** 800 BYTE DATASTRUCTURE FOR ACCESS PROGRAMS                       087380
      *                                                                   087380
     D P@BRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** LF/SDBRCHL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     D P@USER        E DS                  EXTNAME(MUSER)
      *
      ** LF/MUSER ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     D LDA             DS           256
      *
      ** LOCAL DATA AREA FOR DATABASE ERRORS
      *
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
     D PREQDS          DS
      *
      ** DATASTRUCTURE FOR PERIODIC REQUESTS DATABASE ERRORS
      *
     D  D5RNAM                 1     10
     D  D5PSQN                11     12
      *
     D RCOMDS          DS
      *
      ** DATASTRUCTURE FOR REPORT COMPONENTS DATABASE ERRORS
      *
     D  SRNAM                  1     10
     D  SCOTT                 11     20
     D  SCSEQ                 21     25
      *
     D RUNDAT          DS            13
      *
      ** DATA AREA CONTAINING SDBANKPD BASE DETAILS
      *
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  @MBIN                 13     13
     D*
     D CMDDS           DS            50
      *
      ** DATA STRUCTURE FOR INSERTING OUTQ NAME INTO QCMDEXC STRING
      *
     D  QUEUE                 14     23
     D PSDS           SDS
      *
      **  Program status data structure.
      *
     D  @NOPMS                37     39  0
     D  WSID                 244    253
     D  @USER                254    263
     D  @JOBNO               264    269  0
     C********************************************************************S01314
      *                                                                   S01314
      ** Call SDRTVTXT pgm to access appropriate text                     S01314
      ** for a field used in a SFL                                        S01314
      *                                                                   S01314
     C                   MOVEL     'ZZGBMSGF'    MSGNM                                         S0131
     C                   MOVEL     'ZZM1175'     MSGDNB                                        S0131
     C                   CALL      'SDRTVTXT'                                                  S0131
     C                   PARM                    MSGDNB            7                           S0131
     C                   PARM                    MSGNM            10                           S0131
     C                   PARM                    MSGTXT           80                           S0131
     C                   MOVEL     MSGTXT        ZZM015                                        S0131
      *                                                                   S01314
     C                   MOVEL     'ZZM0361'     MSGDNB                                        S0131
     C                   CALL      'SDRTVTXT'                                                  S0131
     C                   PARM                    MSGDNB            7                           S0131
     C                   PARM                    MSGNM            10                           S0131
     C                   PARM                    MSGTXT           80                           S0131
     C**********           MOVELMSGTXT    ZZM057                    S01314LN1153
     C                   MOVEL     MSGTXT        ZZM058                                        LN115
      *                                                                   S01314
      ********************************************************************
      * CONTROL SECTION                                                  *
      ********************************************************************
     C                   EXSR      AINIT
     C                   EXSR      BMAIN
     C                   EXSR      CTERM
      ********************************************************************
      * INDEX OF SUBROUTINES
      *
      * AINIT  - INITIALISE
      * BMAIN  - MAIN SCREEN
      * VALINT - VALIDATE INITIAL SCREEN
      * FILE   - SET THE FILENAME ACCORDING TO DATA ENTERED ON SCREEN
      * SETLOW - SET LOWER LIMITS DEPENDING ON SCREEN INPUT
      * SETSUB - SETUP AND WRITE SUBFILE TO SCREEN
      * READIT - READ THE FILE SET BY THE FIRST INPUT SCREEN
      * VALSFL - VALIDATE SUBFILE
      * PROSFL - PROCESS SUBFILE REQUEST
      * DELREQ - DELETE REPORT REQUEST
      * CF14   - DISPLAY USERS OUTPUT QUEUE
      * CF11   - SUBMIT REPORT TO PRINT
      * *PSSR  - DATABASE ERROR HANDLING ROUTINE
      * CTERM  - PROGRAM TERMINATION
      *
      ********************************************************************
      /EJECT
      ********************************************************************
     C*
     C* AINIT - INITIALISE                                               *
     C* CALLED FROM MAIN
     C*
      ********************************************************************
     C     AINIT         BEGSR
     C*
     C                   MOVEA     CPY@          BIS@             80
     C/COPY WNCPYSRC,FC0060C001
     C*
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C*
     C** SET SINGLE BRANCH ENVIRONMENT INDICATOR
     C*
     C     @MBIN         IFEQ      'N'
     C                   SETON                                        50
     C                   END
     C*
     C                   MOVE      @USER         JUSR
     C*
     C** CHECK THAT THIS USER EXISTS ON LF/MUSER VIA ACCESS PROGRAM
     C*
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM                    @USER            10              I:User profile
     C***********P@USER    PARM P@USER    DSFDY              O:Rec format 087380
     C     P@USER        PARM      P@USER        DSSDY                            O:Rec format 08738
     C*
     C** IF ACCESS PROGRAM ENDS IN ERROR DATABASE ERROR.
     C*
     C     P@APRC        IFNE      *BLANK
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'FC0060'      DBPGM
     C                   MOVEL     'MUSER'       DBFILE
     C                   MOVEL     @USER         DBKEY                          *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   SETON                                        U7U8      *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** SET INDICATOR IF NOT AUTHORISED TO MULTIPLE USERS REPORTS
     C*
     C     MUREP         IFEQ      'N'
     C                   SETON                                        55
     C                   END
     C*
     C** SET INDICATOR IF NOT AUTHORISED TO MULTIPLE BRANCHES
     C*
     C     MBREP         IFEQ      'N'
     C                   SETON                                        56
     C                   END
     C*
     C** SET INDICATOR IF NO OUTQ DEFINED - DISABLE F14 FOR DISPLAY OF OUTQ
     C*
     C     OUTQ          IFNE      *BLANKS
     C                   SETON                                        54
     C                   MOVEL     OUTQ          XOUTQ            10
     C                   END
     C                   MOVEL     @USER         USER
     C*
     C** SET INDICATOR IF AUTHORISED TO CHANGE DETAILS
     C*
     C     ROUT          IFEQ      'Y'
     C                   MOVEL     ROUT          XROUT             1
     C                   SETON                                        53
     C                   END
     C*
     C** SET STATUS TO 'TODAYS ENQUIRY', SET ON SFLMSGRCD END INDICATOR
     C*
     C                   SETON                                        5160
     C                   MOVEL     '*'           SPGMQ
     C*
     C** CLEAR PROGRAM MESSAGE QUEUE
     C*
     C                   CALL      'ZA0250'
     C*
     C     EINIT         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C*
     C* BMAIN - MAIN SCREEN
     C* CALLED FROM MAIN
     C* CALLS VALINT, FILE, SETLOW, SETSUB, CF14, CF11, VALSFL, PROSFL
     C*
      *****************************************************************
     C     BMAIN         BEGSR
     C*
     C** WRITE INITIAL SCREEN
     C*
     C                   WRITE     FC0060C0
     C                   EXFMT     FC0060F0
     C*
     C** CLEAR PROGRAM MESSAGE QUEUE
     C*
     C                   CALL      'ZA0250'
     C*
     C** PROCESS SCREEN UNTIL F3 FOR EXIT IS TAKEN
     C*
     C     *IN03         DOWEQ     '0'
     C*
     C** IF F7 IS TAKEN THEN
     C**     IF STATUS = TODAYS ENQUIRY THEN SET TO YESTERDAYS ENQUIRY.
     C**     IF STATUS = YESTERDAYS ENQUIRY THEN SET TO TODAYS ENQUIRY.
     C*
     C     *IN07         IFEQ      '1'
     C*
     C     *IN51         IFEQ      '1'
     C                   SETOFF                                       51
     C                   ELSE
     C                   SETON                                        51
     C                   END
     C*
     C** OTHERWISE VALIDATE THE DATA ENTERED ON THE SCREEN
     C*
     C                   ELSE
     C                   EXSR      VALINT
     C*
     C** End statement *in07
     C*
     C                   END
     C*
     C** IF DATA IS VALID, SET FILENAME AND SET UP SUBFILE FOR
     C** SECOND SCREEN, OTHERWISE RE-WRITE FIRST SCREEN
     C*
     C     *IN80         IFEQ      '0'
     C     *IN07         ANDEQ     '0'
     C                   EXSR      FILE
     C                   EXSR      SETLOW
     C                   EXSR      SETSUB
     C     SRPT          IFNE      *BLANK                                                      LN084
     C                   MOVE      SRPT          SRPTS                                         LN084
     C                   END                                                                   LN084
     C                   WRITE     FC0060F1
     C                   WRITE     FC0060F2
     C                   WRITE     FC0060C0
     C                   EXFMT     FC0060C1
     C                   CALL      'ZA0250'
     C*
     C** PROCESS SECOND SCREEN UNTIL EXIT/PREVIOUS TAKEN
     C*
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C     *IN05         OREQ      '1'                                                         LN115
      *
      ** DISPLAY OUTQ IF REQUESTED
      *
     C     *IN14         IFEQ      '1'
     C                   EXSR      CF14
     C                   END
      *
      ** PRODUCE LIST IF REQUESTED
      *
     C     *IN11         IFEQ      '1'
     C     *IN51         ANDEQ     '1'                                                         LN036
     C                   EXSR      CF11
     C                   END
      *
     C** ENTER PRESSED WITH NEW REPORT NAME: REPOSITION SUBFILE
      *
     C     SRPTS         IFNE      LRPTS
     C                   MOVEL     SRPTS         CHKF              1
      *
      ** CHECK 'REPORT NAME' ENTERED STARTS WITH LETTER
      *
     C     CHKF          IFLT      'A'                                                         LN036
     C     CHKF          ORGT      'Z'                                                         LN036
      *
      ** SEND ERROR MESSAGE IF NOT
      *
     C     SRPTS         IFNE      *BLANK
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0070' MSGID   7                       LN1186
     C                   PARM      'RCF1070'     MSGID             7                           LN118
     C                   END
     C                   END
      *
      ** RESET SUBFILE POSITION, AND SAVE LAST POSITIONING REPORT NAME
      *
     C**********           ELSE
     C     CHKF          IFGE      'A'                                                         LN036
     C     CHKF          ANDLE     'Z'                                                         LN036
     C     CHKF          OREQ      ' '                                                         LN036
     C                   MOVE      SRPTS         LRPTS            10                           BHF71
     C                   EXSR      SETLOW
     C*********************MOVEL*BLANKS   SRPTS                           BHF719
     C                   EXSR      SETSUB
     C*********************MOVE SRPTS     LRPTS  10                       BHF719
     C                   MOVE      LRPTS         SRPTS                                         BHF71
     C                   END
     C*                                                                   LN0366
     C                   WRITE     FC0060F1                                                    LN036
     C                   WRITE     FC0060F2                                                    LN036
     C                   WRITE     FC0060C0                                                    LN036
     C                   EXFMT     FC0060C1                                                    LN036
     C                   CALL      'ZA0250'                                                    LN036
     C*                                                                   LN0366
      *
      ** IF NEW REPORT NAME NOT ENTERED
      *
     C                   ELSE
      *
     C** VALIDATE SUBFILE
      *
     C     *IN70         IFEQ      '1'
     C                   EXSR      VALSFL
     C                   END
     C*
     C** IF SUBFILE IS VALID PROCESS REQUEST
     C*
     C     *IN81         IFEQ      '0'
     C     *IN70         ANDEQ     '1'
     C                   EXSR      PROSFL
     C                   EXSR      SETLOW
     C                   EXSR      SETSUB
     C                   END
     C*
     C** REWRITE SUBFILE SCREEN
     C*
     C                   MOVE      LRPTS         SRPTS                                         BHF71
     C                   WRITE     FC0060C0
     C                   WRITE     FC0060F1
     C                   WRITE     FC0060F2
     C                   EXFMT     FC0060C1
     C                   CALL      'ZA0250'
     C                   END
     C*
     C** End statement *in03/*in12
     C*
     C                   END
     C*
     C** End statement *in80
     C*
     C                   END
     C*
     C** IF EXIT HAS NOT BEEN REQUESTED, SET OF PREVIOUS SCREEN
     C** /SUBFILE PROCESSED INDICATORS
     C*
     C     *IN03         IFEQ      '0'
     C                   SETOFF                                       1224
     C*********************MOVEL*BLANKS   SRPTS                     LN0366BHF719
     C                   MOVE      LRPTS         SRPTS                                         BHF71
     C                   WRITE     FC0060C0
     C                   EXFMT     FC0060F0
     C                   CALL      'ZA0250'
     C                   END
     C*
     C* End DO *IN03
     C*
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C*
     C* VALINT - VALIDATE INITIAL SCREEN
     C* CALLED FROM BMAIN
     C*
      *****************************************************************
     C*
     C     VALINT        BEGSR
     C*
     C** CLEAR PROGRAM MESSAGES AND RESET ERROR INDICATORS
     C*
     C                   SETOFF                                       803031
     C                   SETOFF                                       32
     C*
     C** IF USER IS DIFFERENT FROM CURRENT USER CHECK THAT USER EXISTS
     C** ON LF/MUSER
     C*
     C     USER          IFNE      *BLANKS
     C     USER          ANDNE     @USER
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM                    USER             10              I:User profile
     C***********P@USER    PARM P@USER    DSFDY              O:Rec format 087380
     C     P@USER        PARM      P@USER        DSSDY                            O:Rec format 08738
     C     P@APRC        IFNE      *BLANK
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0013' MSGID   7                       LN1186
     C                   PARM      'RCF1013'     MSGID                                         LN118
     C                   SETON                                        8030
     C                   END
     C                   END
     C*
     C** CHECK THAT THE BRANCH CODE EXISTS ON SDBRCHPD
     C*
     C     BRANCH        IFNE      *BLANKS
     C*****              CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM                    BRANCH            3              I:User branch
     C*****P@BRCH        PARM      P@BRCH        DSFDY                            O:Rec formatCGL029
     C     P@BRCH        PARM      P@BRCH        DSSDY                            O:Rec formatCGL029
     C     P@APRC        IFNE      *BLANKS
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0014' MSGID   7                       LN1186
     C                   PARM      'RCF1014'     MSGID                                         LN118
     C                   SETON                                        8031
     C                   END
     C*
     C** CHECK USER'S AUTHORITY TO BRANCH, IF BRANCH IS VALID.            LN0366
     C*                                                                   LN0366
     C     *IN31         IFNE      '1'                                                         LN036
     C*                                                                   LN0366
     C                   CALL      'ZVBBU'
     C                   PARM      BRANCH        ZBRCDX            3
     C                   PARM                    ERR               1 0
     C     ERR           IFNE      0
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0015' MSGID   7                       LN1186
     C                   PARM      'RCF1015'     MSGID                                         LN118
     C                   SETON                                        8031
     C                   END
     C                   END                                                                   LN036
     C                   END
     C*
     C** CHECK REPORT NAME STARTS WITH A LETTER
     C*
     C***********SRPTS     IFNE *BLANKS                                   LN0366
     C     SRPT          IFNE      *BLANKS                                                     LN036
     C***********          MOVE SRPTS     LRPTS  10                       LN0366
     C                   MOVE      SRPT          LRPTS            10                           LN036
     C                   MOVE      SRPT          SRPTS                                         LN036
     C***********          MOVELSRPTS     CHKF    1                       LN0366
     C                   MOVEL     SRPT          CHKF              1                           LN036
     C*
     C     CHKF          IFLT      'A'
     C     CHKF          ORGT      'Z'
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0070' MSGID   7                       LN1186
     C                   PARM      'RCF1070'     MSGID                                         LN118
     C                   SETON                                        8032
     C                   END
     C*
     C                   END
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C*
     C* FILE - SET THE FILENAME ACCORDING TO DATA ENTERED ON SCREEN
     C* CALLED FROM BMAIN
     C*
      *****************************************************************
     C*
     C     FILE          BEGSR
     C*
     C** RESET INDICATORS FOR NEW SELECTION
     C*
     C                   SETOFF                                       414243
     C                   SETOFF                                       444546
     C                   SETOFF                                       4748
     C*
     C** STATUS = TODAYS ENQUIRY
     C*
     C     *IN51         IFEQ      '1'
     C*
     C** IF USER IS ENTERED THEN FILE TO BE USED IS FCRREQL5
     C*
     C     USER          IFNE      *BLANKS
     C     BRANCH        ANDEQ     *BLANKS
     C                   SETON                                        41
     C                   END
     C*
     C** IF BRANCH IS ENTERED THEN FILE TO BE USED IS FCRREQL6
     C*
     C     USER          IFEQ      *BLANKS
     C     BRANCH        ANDNE     *BLANKS
     C                   SETON                                        42
     C                   END
     C*
     C** IF BOTH USER AND BRANCH ENTERED THEN FILE USED IS FCRREQL7
     C*
     C     USER          IFNE      *BLANKS
     C     BRANCH        ANDNE     *BLANKS
     C                   SETON                                        43
     C                   END
     C*
     C** IF NEITHER USER OR BRANCH ENTERED FILE USED IS FCRREQL1
     C*
     C     USER          IFEQ      *BLANKS
     C     BRANCH        ANDEQ     *BLANKS
     C                   SETON                                        44
     C                   END
     C*
     C** END TODAY'S ENQUIRY
     C*
     C                   END
     C*
     C**
     C** IF STATUS - YESTERDAYS ENQUIRY
     C**
     C*
     C     *IN51         IFEQ      '0'
     C*
     C** IF USER ENTERED THEN FILE TO BE USED IS FCYREQL5
     C*
     C     USER          IFNE      *BLANKS
     C     BRANCH        ANDEQ     *BLANKS
     C                   SETON                                        45
     C                   END
     C*
     C** IF BRANCH ENTERED THEN FILE TO BE USED IS FCYREQL6
     C*
     C     USER          IFEQ      *BLANKS
     C     BRANCH        ANDNE     *BLANKS
     C                   SETON                                        46
     C                   END
     C*
     C** IF BOTH USER AND BRANCH ENTERED THEN FILE USED IS FCYREQL7
     C*
     C     USER          IFNE      *BLANKS
     C     BRANCH        ANDNE     *BLANKS
     C                   SETON                                        47
     C                   END
     C*
     C** IF NEITHER USER OR BRANCH ENTERED THEN FILE USED IS FCYREQL1
     C*
     C     USER          IFEQ      *BLANKS
     C     BRANCH        ANDEQ     *BLANKS
     C                   SETON                                        48
     C                   END
     C*
     C                   END
     C*
     C                   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
     C*
     C* SETLOW - SET LOWER LIMITS DEPENDING ON SCREEN INPUT
     C* CALLED FROM MAIN
     C*
      *******************************************************************
     C     SETLOW        BEGSR
     C*
     C     *IN41         IFEQ      '1'
     C*
     C** KLIST TO READ FCRREQL5
     C*
     C     KYTOD5        KLIST
     C                   KFLD                    KUSRR            10
     C                   KFLD                    KRNAM            10
     C                   KFLD                    KRQSQ             5
     C                   MOVEL     USER          KUSRR
     C                   MOVEL     SRPTS         KRNAM
     C                   MOVEL     *BLANKS       KRQSQ
     C     KYTOD5        SETLL     FCRREQL5
     C*
     C                   END
     C*
     C     *IN42         IFEQ      '1'
     C*
     C** KLIST TO READ FCRREQL6
     C*
     C     KYTOD6        KLIST
     C                   KFLD                    KETTY             3
     C                   KFLD                    KRNAM            10
     C                   KFLD                    KRQSQ             5
     C                   MOVEL     BRANCH        KETTY
     C                   MOVEL     SRPTS         KRNAM
     C                   MOVEL     *BLANKS       KRQSQ
     C     KYTOD6        SETLL     FCRREQL6
     C*
     C                   END
     C*
     C     *IN43         IFEQ      '1'
     C*
     C** KLIST TO READ FCRREQL7
     C*
     C     KYTOD7        KLIST
     C                   KFLD                    KETTY             3
     C                   KFLD                    KUSRR            10
     C                   KFLD                    KRNAM            10
     C                   KFLD                    KRQSQ             5
     C                   MOVEL     BRANCH        KETTY
     C                   MOVEL     USER          KUSRR
     C                   MOVEL     SRPTS         KRNAM
     C                   MOVEL     *BLANKS       KRQSQ
     C     KYTOD7        SETLL     FCRREQL7
     C*
     C                   END
     C*
     C     *IN44         IFEQ      '1'
     C*
     C**  KLIST TO READ FCRREQL1
     C*
     C     KYTOD1        KLIST
     C                   KFLD                    KRNAM            10
     C                   KFLD                    KRQSQ             5
     C                   MOVEL     SRPTS         KRNAM
     C                   MOVEL     *BLANKS       KRQSQ
     C                   SETON                                        44
     C     KYTOD1        SETLL     FCRREQL1
     C*
     C                   END
     C*
     C     *IN45         IFEQ      '1'
     C*
     C** KLIST TO READ FCYREQL5
     C*
     C     KYEST5        KLIST
     C                   KFLD                    KUSRR            10
     C                   KFLD                    KRNAM            10
     C                   KFLD                    KRQSQ             5
     C                   MOVEL     USER          KUSRR
     C                   MOVEL     SRPTS         KRNAM
     C                   MOVEL     *BLANKS       KRQSQ
     C     KYEST5        SETLL     FCYREQL5
     C*
     C                   END
     C*
     C     *IN46         IFEQ      '1'
     C*
     C** KLIST TO READ FCYREQL6
     C*
     C     KYEST6        KLIST
     C                   KFLD                    KETTY             3
     C                   KFLD                    KRNAM            10
     C                   KFLD                    KRQSQ             5
     C                   MOVEL     BRANCH        KETTY
     C                   MOVEL     SRPTS         KRNAM
     C                   MOVEL     *BLANKS       KRQSQ
     C     KYEST6        SETLL     FCYREQL6
     C*
     C                   END
     C*
     C     *IN47         IFEQ      '1'
     C*
     C** KLIST TO READ FCYREQL7
     C*
     C     KYEST7        KLIST
     C                   KFLD                    KETTY
     C                   KFLD                    KUSRR
     C                   KFLD                    KRNAM            10
     C                   KFLD                    KRQSQ             5
     C                   MOVEL     BRANCH        KETTY
     C                   MOVEL     USER          KUSRR
     C                   MOVEL     SRPTS         KRNAM
     C                   MOVEL     *BLANKS       KRQSQ
     C     KYEST7        SETLL     FCYREQL7
     C*
     C                   END
     C*
     C     *IN48         IFEQ      '1'
     C*
     C** KLIST TO READ FCYREQL1
     C*
     C     KYEST1        KLIST
     C                   KFLD                    KRNAM            10
     C                   KFLD                    KRQSQ             5
     C                   MOVEL     SRPTS         KRNAM
     C                   MOVEL     *BLANKS       KRQSQ
     C     KYEST1        SETLL     FCYREQL1
     C*
     C                   END
     C*
     C                   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
     C*
     C* SETSUB - SETUP AND WRITE SUBFILE TO SCREEN
     C* CALLED FROM MAIN
     C* CALLS READIT
     C*
      *******************************************************************
     C*
     C     SETSUB        BEGSR
     C*
     C** IF SUBFILE HAS BEEN DISPLAYED, CLEAR CURRENT DETAILS
     C*
     C     *IN01         IFEQ      '1'
     C                   SETOFF                                       01                       LN036
     C                   SETON                                        23
     C                   SETOFF                                       202122
     C                   SETOFF                                       33
     C                   SETON                                        24                       LN036
     C                   WRITE     FC0060C1
     C                   SETOFF                                       24                       LN036
     C                   END
     C*
     C** SET OFF DETAILS EXIST INDICATOR, RESET RECORD NUMBER TO 1
     C*
     C                   SETOFF                                       70
     C                   SETOFF                                       28                       LN098
     C                   Z-ADD     1             RRN               5 0
     C                   Z-ADD     1             SDREC
     C                   MOVEL     *BLANKS       SELECT
     C*
     C** SET UP SUBFILE
     C*
     C                   EXSR      READIT
     C*
     C** FORMAT DETAILS
     C*
     C     *IN24         DOWEQ     '0'
     C*
     C** SET RECORDS EXIST INDICATOR
     C*
     C                   SETON                                        70
     C*
     C                   MOVEL     *BLANK        SOTYP
     C                   MOVEL     *BLANK        SOUTP
     C                   MOVEL     *BLANK        SFREQ
     C                   MOVEL     *BLANK        SRPTS                                         LN036
     C*
     C** SET UP SUBFILE RECORD
     C** IF STATUS = TODAY
     C*
     C     *IN51         IFEQ      '1'
     C                   MOVEL     D5RNAM        SRNAM
     C                   MOVEL     D5RQSQ        SSEQ
     C                   MOVEL     D5LVL         SLVL
     C                   MOVEL     D5ETTY        SENTY
     C                   MOVEL     D5USRR        SUSER
     C                   MOVEL     EKDBRN        SUBR
     C                   MOVEL     D5USRO        SUSRO
     C                   MOVEL     D5DLS1        SDL1
     C                   MOVEL     D5DLS2        SDL2
     C                   MOVEL     D5SOID        SSOID
     C                   MOVEL     D5DRQD        SDRQD
     C*
     C** SET READY FLAG ON IF JOB NAME IS PRESENT
     C*
     C     D5JBNM        IFNE      *BLANKS
     C                   MOVEL     'Y'           SRDY
     C                   ELSE
     C                   MOVEL     'N'           SRDY
     C                   END
     C*
     C** OUTPUT METHOD IS USER ID IF USER FOR OUTPUT NON-BLANK
     C*
     C     D5USRO        IFNE      *BLANKS
     C                   MOVEL     'USER'        SOTYP
     C                   MOVEL     D5USRO        SOUTP
     C                   END
     C*
     C** OUTPUT METHOD IS DISTRIBUTION LIST IF DISTRIBUTION LIST FIELDS
     C** NON BLANK
     C*
     C     D5DLS1        IFNE      *BLANKS
     C     D5DLS2        ANDNE     *BLANKS
     C                   MOVEL     'DIST'        SOTYP
     C                   MOVEL     D5DLS1        SOUTP
     C                   MOVE      D5DLS2        SOUTP
     C                   END
     C*
     C** STANDARD OUTPUT INSTRUCTIONS USED IF SOI NON-BLANK
     C*
     C     D5SOID        IFNE      *BLANKS
     C                   MOVEL     'SOI '        SOTYP
     C                   MOVEL     D5SOID        SOUTP
     C                   END
     C*
     C** IF NO OUTPUT METHOD, BUT ARCHIVING REQUESTED SET METHOD 'ARCHIVE'
     C*
     C     D5USRO        IFEQ      *BLANKS
     C     D5SOID        ANDEQ     *BLANKS
     C     D5DLS1        ANDEQ     *BLANKS
      *
     C     D5ARMF        IFEQ      'Y'
     C     D5AROD        OREQ      'Y'
     C                   MOVEL     *BLANKS       SOTYP
     C                   MOVEL     'ARCHIVED'    SOUTP
     C                   END
      *
     C                   END
     C*
     C** SET COMPONENT NAME ETC. AS HIDDEN FIELDS FOR LATER
     C*
     C                   MOVEL     D5COTT        SCOTT
     C                   MOVEL     D5CSEQ        SCSEQ
     C*
     C** SET PRODUCTION METHOD: CLOSE OF BUSINESS/INPUT CYCLE
     C*
     C     D5COBR        IFEQ      'Y'
     C                   MOVEL     '   CoB'      SFREQ
     C                   END
     C*
     C     D5IPCY        IFEQ      'Y'
     C                   MOVEL     '  Immed'     SFREQ
     C                   END
     C*
     C** IF PERIODIC REQUEST, ACCESS DETAILS FOR FREQUENCE
     C*
     C     D5PDFL        IFEQ      'Y'
     C     KPREQ         KLIST
     C                   KFLD                    D5RNAM
     C                   KFLD                    D5PSQR
     C*
     C     KPREQ         CHAIN     FCPREQL1                           89
     C*
     C** SET FREQUENCE IF RECORD FOUND, ELSE DATABASE ERROR
     C*
     C     *IN89         IFEQ      '0'
     C     D9FREQ        LOOKUP    TABFRQ        TABNAM                   26
     C                   MOVE      TABNAM        SFREQ
     C                   ELSE
     C*
     C     *LOCK         IN        LDA                                            ************
     C                   MOVE      PREQDS        DBKEY                            * DBERR 03 *
     C                   MOVE      'FCPREQL1'    DBFILE                           ************
     C                   Z-ADD     3             DBASE
     C                   SETON                                        U7U8
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C                   END
     C*
     C                   ELSE
     C*
     C** IF STATUS = YESTERDAY
     C*
     C                   MOVEL     EKRNAM        SRNAM
     C                   MOVEL     EKRQSQ        SSEQ
     C                   MOVEL     EKLVL         SLVL
     C                   MOVEL     EKETTY        SENTY
     C                   MOVEL     EKUSRR        SUSER
     C                   MOVEL     EKDBRN        SUBR
     C                   MOVEL     EKUSRO        SUSRO
     C                   MOVEL     EKDLS1        SDL1
     C                   MOVEL     EKDLS2        SDL2
     C                   MOVEL     EKSOID        SSOID
     C                   MOVEL     EKDRQD        SDRQD
     C*
     C** SET STATUS TO READY IF JOB NAME PRESENT
     C*
     C     EKJBNM        IFNE      *BLANKS
     C                   MOVEL     'Y'           SRDY
     C                   ELSE
     C                   MOVEL     'N'           SRDY
     C                   END
     C*
     C** SET OUTPUT METHOD TO USER IF USER ID FOR OUTPUT NON-BLANK
     C*
     C     EKUSRO        IFNE      *BLANKS
     C                   MOVEL     'USER'        SOTYP
     C                   MOVEL     EKUSRO        SOUTP
     C                   END
     C*
     C** SET METHOD TO DISTRIBUTION LIST IF NONBLANK
     C*
     C     EKDLS1        IFNE      *BLANKS
     C     EKDLS2        ANDNE     *BLANKS
     C                   MOVEL     'DIST'        SOTYP
     C***********          MOVELEKDLS2    SOUTP                           LN1208
     C***********          MOVE EKDLS1    SOUTP                           LN1208
     C                   MOVEL     EKDLS1        SOUTP                                         LN120
     C                   MOVE      EKDLS2        SOUTP                                         LN120
     C                   END
     C*
     C** SET METHOD TO STANDARD OUTPUT ID IF NONBLANK
     C*
     C     EKSOID        IFNE      *BLANKS
     C                   MOVEL     'SOI'         SOTYP
     C                   MOVEL     EKSOID        SOUTP
     C                   END
     C*
      ** IF ALL BLANK AND ARCHIVING SET ON, SET TO ARCHIVED
     C*
     C     EKUSRO        IFEQ      *BLANKS
     C     EKSOID        ANDEQ     *BLANKS
     C     EKDLS1        ANDEQ     *BLANKS
      *
     C     EKARMF        IFEQ      'Y'
     C     EKAROD        OREQ      'Y'
     C                   MOVEL     'ARCHIVED'    SOUTP
     C                   END
      *
     C                   END
     C*
     C** HIDDEN FIELDS FOR LATER USE
     C*
     C                   MOVEL     EKCOTT        SCOTT
     C                   MOVEL     EKCSEQ        SCSEQ
     C*
     C** SET PRODUCTION FREQUENCY TO CLOSE OF BUSINESS/INPUT CYCLE
     C*
     C     EKCOBR        IFEQ      'Y'
     C                   MOVEL     '   CoB'      SFREQ
     C                   END
     C*
     C     EKIPCY        IFEQ      'Y'
     C                   MOVEL     '  Immed'     SFREQ
     C                   END
     C*
     C** IF PERIODIC REQUEST, SET FREQUENCE
     C*
     C     EKPDFL        IFEQ      'Y'
     C*
     C                   MOVE      EKRNAM        D5RNAM
     C                   MOVE      EKPSQR        D5PSQN
      *
     C     KPREQ         CHAIN     FCPREQL1                           89
      *
      ** CANNOT GIVE DBERR IF NO RECORD, AS MAY HAVE BEEN DELETED TODAY
      *
     C     *IN89         IFEQ      '0'
     C     D9FREQ        LOOKUP    TABFRQ        TABNAM                   26
     C                   MOVE      TABNAM        SFREQ
     C                   END
      *
     C                   END
      *
     C                   END
     C*
     C** ACCESS REPORT DETAILS - DATABASE ERROR IF NOT FOUND
     C*
     C     SRNAM         CHAIN     FCREPTL1                           88
     C*
     C     *IN88         IFEQ      '1'
     C     *LOCK         IN        LDA                                           ************
     C                   MOVE      SRNAM         DBKEY                           * DBERR 01 *
     C                   MOVE      'FCREPTPD'    DBFILE                          ************
     C                   Z-ADD     01            DBASE
     C                   SETON                                        U7U8
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     DXRDSC        SDESC
     C                   END
     C*
     C** WRITE SUBFILE RECORD
     C*
     C                   WRITE     FC0060S1
     C                   ADD       1             RRN
     C                   EXSR      READIT
     C                   END
     C*                                                                   LN0986
     C** IF NO DETAILS PRESENT WRITE BLANK RECORD TO SUBFILE              LN0986
     C*                                                                   LN0986
     C     *IN70         IFEQ      '0'                                                         LN098
     C                   MOVE      *BLANK        SRNAM                                         LN098
     C                   MOVE      *BLANK        SSEQ                                          LN098
     C                   MOVE      *BLANK        SRDY                                          LN098
     C                   MOVE      *BLANK        SLVL                                          LN098
     C                   MOVE      *BLANK        SENTY                                         LN098
     C                   MOVE      *BLANK        SUSER                                         LN098
     C                   MOVE      *BLANK        SUBR                                          LN098
     C                   MOVE      *BLANK        SOTYP                                         LN098
     C                   MOVE      *BLANK        SOUTP                                         LN098
     C                   MOVE      *BLANK        SDESC                                         LN098
     C                   MOVE      *BLANK        SFREQ                                         LN098
     C** SET INDICATOR TO PROTECT SUBFILE FIELDS                          LN0986
     C                   SETON                                        28                       LN098
     C                   WRITE     FC0060S1                                                    LN098
     C                   END                                                                   LN098
      *
     C** WRITE SUBFILE/CONTROL
      *
     C                   SETOFF                                       23
     C                   SETON                                        20
      *
      ***IF*DETAILS*PRESENT,*SET*SUBFILE*PRESENT*INDICAOTR*************   LN0986
      ************                                                        LN0986
     C************IN01     IFEQ '0'                                       LN0986
     C************IN70     ANDEQ'1'                                       LN0986
      *                                                                   LN0986
      ** SET SUBFILE PRESENT INDICATOR AND DISPLAY SUBFILE                LN0986
      *                                                                   LN0986
     C                   SETON                                        01
     C***********          END                                            LN0986
      ***********                                                         LN0986
      ***DISPLAY*SUBFILE*IF*DETAILS*PRESENT****************************   LN0986
      ***********                                                         LN0986
     C************IN01     IFEQ '1'                                       LN0986
     C                   SETON                                        21
     C***********          END                                            LN0986
     C*
     C** IF NO DETAILS, SEND MESSAGE TO INFORM USER
     C*
     C     *IN70         IFEQ      '0'
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0069' MSGID                           LN1186
     C                   PARM      'RCF1069'     MSGID                                         LN118
     C                   END
      *
     C                   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
     C*
     C* READIT - READ THE FILE SET BY THE FIRST INPUT SCREEN
     C* CALLED FROM SETSUB
     C*
      *******************************************************************
     C*
     C     READIT        BEGSR
     C*
     C     *IN41         IFEQ      '1'
     C     KYTODA        KLIST
     C                   KFLD                    AUSR             10
     C                   MOVEL     USER          AUSR
     C     KYTODA        READE     FCRREQL5                               24
     C                   END
     C*
     C     *IN42         IFEQ      '1'
     C     KYTODB        KLIST
     C                   KFLD                    AETY              3
     C                   MOVEL     BRANCH        AETY
     C     KYTODB        READE     FCRREQL6                               24
     C                   END
     C*
     C     *IN43         IFEQ      '1'
     C     KYTODC        KLIST
     C                   KFLD                    AETY
     C                   KFLD                    AUSR
     C                   MOVEL     BRANCH        AETY
     C                   MOVEL     USER          AUSR
     C     KYTODC        READE     FCRREQL7                               24
     C                   END
     C*
     C     *IN44         IFEQ      '1'
     C     KYTODD        KLIST
     C                   KFLD                    ANAM             10
     C                   MOVEL     SRPTS         ANAM
     C                   READ      FCRREQL1                               24
     C                   END
     C*
     C     *IN45         IFEQ      '1'
     C     KYESTA        KLIST
     C                   KFLD                    AUSR
     C                   MOVEL     USER          AUSR
     C     KYESTA        READE     FCYREQL5                               24
     C                   END
     C*
     C     *IN46         IFEQ      '1'
     C     KYESTB        KLIST
     C                   KFLD                    AETY
     C                   MOVEL     BRANCH        AETY
     C     KYESTB        READE     FCYREQL6                               24
     C                   END
     C*
     C     *IN47         IFEQ      '1'
     C     KYESTC        KLIST
     C                   KFLD                    AETY
     C                   KFLD                    AUSR
     C                   MOVEL     BRANCH        AETY
     C                   MOVEL     USER          AUSR
     C     KYESTC        READE     FCYREQL7                               24
     C                   END
     C*
     C     *IN48         IFEQ      '1'
     C     KYESTD        KLIST
     C                   KFLD                    ANAM
     C                   MOVEL     SRPTS         ANAM
     C                   READ      FCYREQL1                               24
     C                   END
     C                   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
     C*
     C* VALSFL - VALIDATE SUBFILE
     C* CALLED FROM BMAIN
     C*
      *******************************************************************
     C     VALSFL        BEGSR
     C*
     C** RESET ERROR INDICATORS AND CLEAR MESSAGE SUBFILE
     C*
     C                   Z-ADD     1             RRN
     C                   Z-ADD     1             ERRRRN
     C                   SETOFF                                       81
     C*
     C** READ FIRST CHANGED SUBFILE RECORD
     C*
     C                   READC     FC0060S1                               25
     C*
     C** DO WHILE CHANGED SUBFILE RECORDS EXIST
     C*
     C     *IN25         DOWEQ     '0'
     C*
     C** SET OFF ERROR INDICATOR
     C*
     C                   SETOFF                                       33
     C*
     C** IF SELECTION IS NOT BLANK
     C*
     C     SELECT        IFNE      *BLANKS
     C*
     C** IF USER NOT AUTHORISED TO CHANGE OUTPUT THEN SELECTION MUST BE
     C***'R'****                                                          BHF789
     C** 'R' REVIEW REPORTING OR D DELETE REPORT REQUEST                  BHF789
     C*
     C     *IN53         IFEQ      '0'
     C     SELECT        ANDNE     'R'
     C     SELECT        ANDNE     'D'                                                         BHF78
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0017' MSGID   7                       LN1186
     C**********           PARM 'RCF1017' MSGID                     LN1186LN1153
     C                   PARM      'RCF1078'     MSGID                                         LN115
      *
      ** SAVE ERROR LINE NUMBER
      *
     C     *IN81         IFEQ      '0'
     C     *LIKE         DEFINE    RRN           ERRRRN
     C                   Z-ADD     RRN           ERRRRN
     C                   END
     C                   SETON                                        8133
     C                   END
      *
     C** IF USER IS AUTHORISED TO CHANGE OUTPUT THEN CHECK SELECTION
     C** IS 'A', 'D' OR 'R'
      *
     C     *IN53         IFEQ      '1'
     C     SELECT        ANDNE     'A'
     C     SELECT        ANDNE     'D'
     C     SELECT        ANDNE     'R'
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0018' MSGID   7                       LN1186
     C**********           PARM 'RCF1018' MSGID                     LN1186LN1153
     C                   PARM      'RCF1078'     MSGID                                         LN115
      *
     C     *IN81         IFEQ      '0'
     C                   Z-ADD     RRN           ERRRRN
     C                   END
      *
     C                   SETON                                        8133
     C                   END
      *
     C** IF REPORT IS FOR PRODUCTION IN INPUT CYCLE THEN SELECTION
     C** CANNOT BE 'A' OR 'D'
      *
     C     SFREQ         IFEQ      '  Immed'
     C     SELECT        ANDEQ     'A'
     C     SFREQ         OREQ      '  Immed'
     C     SELECT        ANDEQ     'D'
      *
      ** CANNOT AMEND/DELETE YESTERDAY'S
      *
     C     *IN51         OREQ      '0'
     C     SELECT        ANDEQ     'A'
     C     *IN51         OREQ      '0'
     C     SELECT        ANDEQ     'D'
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0019' MSGID   7                       LN1186
     C**********           PARM 'RCF1019' MSGID                     LN1186LN1153
     C                   PARM      'RCF1078'     MSGID                                         LN115
      *
     C     *IN81         IFEQ      '0'
     C                   Z-ADD     RRN           ERRRRN
     C                   END
      *
     C                   SETON                                        8133
     C                   END
      *
     C** IF REPORT IS NOT READY TO PRINT THEN 'R' CANNOT BE SELECTED
      *
     C     SRDY          IFEQ      'N'
     C     SELECT        ANDEQ     'R'
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0020' MSGID   7                       LN1186
     C                   PARM      'RCF1020'     MSGID                                         LN118
      *
     C     *IN81         IFEQ      '0'
     C                   Z-ADD     RRN           ERRRRN
     C                   END
      *
     C                   SETON                                        8133
     C                   END
      *
     C                   END
     C*
     C** IF SUBFILE SELECT FIELD IS BLANKED OUT PREVENT READ ON NEXT CYCLE
     C*
     C     SELECT        IFEQ      *BLANK
     C                   SETOFF                                       22
     C                   ELSE
     C                   SETON                                        22
     C                   END
     C*
     C** UPDATE SUBFILE RECORD
     C*
     C                   UPDATE    FC0060S1
     C*
     C** READ NEXT CHANGED RECORD
     C*
     C                   READC     FC0060S1                               25
     C                   END
     C*
      ** POSITION SUBFILE AT FIRST ERROR
     C*
     C***81******          Z-ADDERRRRN    RRN                             LN0366
     C   81              Z-ADD     ERRRRN        SDREC                                         LN036
     C*
     C                   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
     C*
     C* PROSFL - PROCESS SUBFILE REQUEST
     C* CALLED FROM BMAIN
     C* CALLS CTERM, DELREQ
     C*
      *******************************************************************
     C*
     C     PROSFL        BEGSR
     C*
     C** SET TO START OF SUBFILE
     C*
     C                   SETOFF                                           22
     C                   Z-ADD     1             RRN
     C*
     C** READ FIRST CHANGED RECORD
     C*
     C                   READC     FC0060S1                               25
     C*
     C     *IN25         DOWEQ     '0'
     C*
     C** IF SELECTION = 'A' THEN READ FCRCOML1
     C*
     C     SELECT        IFEQ      'A'
     C     KCOM1         KLIST
     C                   KFLD                    SRNAM
     C                   KFLD                    SCOTT
     C                   KFLD                    SCSEQ
      *
     C     KCOM1         CHAIN     FCRCOML1                           27
      *
      ** DATABASE ERROR IF NOT FOUND
      *
     C     *IN27         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'FC0060'      DBPGM
     C                   MOVEL     'FCRCOML1'    DBFILE
     C                   MOVEL     RCOMDS        DBKEY                          *************
     C                   Z-ADD     5             DBASE                          * DBERR 005 *
     C                   SETON                                        U7U8      *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *                                                                   101040
      ** Get branch type from FCRCOML1                                    101040
      *                                                                   101040
     C                   MOVE      D3BRTP        SBRTP                                         10104
      *
     C** IF RECORD FOUND AND PROMPT PROGRAM IS NOT BLANK
     C** THEN CALL PROG FCC0203
      *
     C     D3PRPG        IFNE      *BLANKS
     C                   CALL      'FCC0203'
     C                   PARM                    SCOTT
     C                   PARM                    SCSEQ
     C                   PARM                    SRNAM
     C                   PARM                    SSEQ
     C                   PARM                    D3PRPG
     C                   PARM                    SBRTP
     C                   PARM      'A'           PACTN             1
     C*
     C                   ELSE
     C* IF PROMPT PROGRAM IS BLANK
     C* CALL PROGRAM FCC0204
     C                   CALL      'FCC0204'
     C                   PARM                    SCOTT
     C                   PARM                    SCSEQ
     C                   PARM                    SRNAM
     C                   PARM                    SSEQ
     C                   PARM                    SBRTP
     C                   PARM      'A'           PACTN             1
     C                   END
      *
     C** IF FCC0203 OR FCC0204 RETURN ACTION AS 'T' THEN TERMINATE THE
     C** PROGRAM
      *
     C     PACTN         IFEQ      'T'
     C                   EXSR      CTERM
     C                   END
      *
     C                   END
      *
     C** IF SELECTION = R FOR REPORTS, SET PROGRAM MODE FOR FC0065
     C*
     C     SELECT        IFEQ      'R'
     C     *IN51         IFEQ      '1'
     C                   MOVEL     'T'           MODE              1
     C                   ELSE
     C                   MOVEL     'Y'           MODE
     C                   END
     C*
     C** CALL PROGRAM FC0065
     C*
     C                   CALL      'FC0065'
     C                   PARM                    USER
     C                   PARM                    BRANCH
     C                   PARM                    SRNAM
     C                   PARM                    SDESC
     C                   PARM                    SSEQ
     C                   PARM                    MODE
     C                   PARM                    TERM              1
     C*
     C** IF FC0065 RETURNS TERM AS 'T' THEN TERMINATE PROGRAM
     C*
     C     TERM          IFEQ      'T'
     C                   EXSR      CTERM
     C                   END
     C*
     C                   END
     C*
     C** IF SELECTION - 'D', PROCESS DELETION
     C*
     C     SELECT        IFEQ      'D'
     C                   EXSR      DELREQ
     C                   END
     C*
     C** RESET ERROR MESSAGES ETC.
     C*
     C                   MOVE      *BLANK        SELECT
     C                   UPDATE    FC0060S1
     C*
     C** READ NEXT CHANGED RECORD
     C*
     C                   READC     FC0060S1                               25
     C                   END
     C*
     C                   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
     C*
     C* DELREQ -  DELETE REPORT REQUEST
     C* CALLED FROM PROSFL
     C* CALLS CTERM
     C*
      *******************************************************************
     C*
     C     DELREQ        BEGSR
     C*
     C                   CALL      'ZA0250'
     C*
     C** DISPLAY CONFIRMATION SCREEN
     C*
     C                   WRITE     FC0060C0
     C                   EXFMT     FC0060F3
     C*
     C                   CALL      'ZA0250'
     C*
     C** DO UNTIL VALID COMMAND KEY TAKEN
     C*
     C********** *IN03     DOWEQ'0'                                       LN1153
     C********** *IN12     ANDEQ'0'                                       LN1153
     C********** *IN10     ANDEQ'0'                                       LN1153
     C***********                                                         LN1153
     C***IF*ENTER PRESSED, TELL USER TO TAKE F10                          LN1153
     C**********                                                          LN1153
     C**********           CALL 'FCC0240'                                 LN1153
     C***********          PARM 'RCF0021' MSGID   7                       LN1186
     C**********           PARM 'RCF1021' MSGID                     LN1186LN1153
     C**********           WRITEFC0060C0                                  LN1153
     C**********           EXFMTFC0060F3                                  LN1153
     C**********                                                          LN1153
     C***CLEAR*MESSAGES                                                   LN1153
     C**********                                                          LN1153
     C**********           CALL 'ZA0250'                                  LN1153
     C**********           END                                            LN1153
     C*
     C** IF EXIT REQUESTED, TERMINATE PROGRAM
     C*
     C     *IN03         IFEQ      '1'
     C                   EXSR      CTERM
     C                   END
     C*
     C** IF DELETE REQUESTED, DELETE ALL RECORDS FOR THIS REQUEST
     C*
     C     *IN10         IFEQ      '1'
     C     KEYREQ        KLIST
     C                   KFLD                    SRNAM
     C                   KFLD                    SSEQ
     C*
     C     SSEQ          CHAIN     FCRREQL0                           82
     C     *IN82         IFEQ      '0'
     C                   DELETE    @D5REI8
     C                   END
     C*
     C     KEYREQ        CHAIN     FCPARDL0                           84
     C     *IN84         IFEQ      '0'
     C                   DELETE    @D7REJE
     C                   END
     C/COPY WNCPYSRC,FC0060C002
      *
     C     KEYREQ        SETLL     MAARCDL2
     C     KEYREQ        READE     MAARCDL2                               83
      *
     C     *IN83         DOWEQ     '0'
     C                   DELETE    @ARCDAO
     C     KEYREQ        READE     MAARCDL2                               83
     C                   END
      *
     C                   COMMIT
     C                   END
      *
     C                   SETOFF                                       12
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C*
     C* CF14 - DISPLAY USERS OUTPUT QUEUE
     C* CALLED FROM BMAIN
     C*
      *****************************************************************
     C*
     C     CF14          BEGSR
     C*
     C** DISPLAY OUTPUT QUEUE
     C*
     C                   MOVEL     CMD(1)        CMDDS
     C                   MOVEL     XOUTQ         QUEUE
     C                   CALL      'QCMDEXC'
     C                   PARM      CMDDS         CMDSTR           50
     C                   PARM      50            CMDLEN           15 5
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C*
     C* CF11 - SUBMIT REPORT TO PRINT
     C* CALLED FROM BMAIN
     C*
      *****************************************************************
     C*
     C     CF11          BEGSR
     C*
     C** SET LEVEL/ENTITY DEPENDING ON INITIAL SCREEN ENTRY
     C*
     C     BRANCH        IFNE      *BLANK
     C                   MOVE      BRANCH        ENTITY            3
     C                   MOVE      'B'           LEVEL             1
     C                   ELSE
     C*********************MOVE 'S'       LEVEL                           090344
     C*********************MOVE *BLANK    ENTITY                          090344
     C                   MOVE      'B'           LEVEL                                         09034
     C                   MOVE      'ALL'         ENTITY                                        09034
     C                   END
     C*
     C                   CALL      'FC0040X'
     C                   PARM                    P6RTN             7
     C**********           PARM 'FC0060P' P1RNAM 10                       LN0344
     C                   PARM      'FC0600'      P1RNAM           10                           LN034
     C                   PARM      'FCC0301'     P2COTT           10
     C                   PARM      '00001'       P3CSEQ            5
     C                   PARM      *BLANKS       P4CLPM          100
     C                   PARM      @MBIN         P5MBIN            1
     C                   PARM                    LEVEL
     C                   PARM                    ENTITY
     C*
     C** TERMINATE PROGRAM IF RETURN CODE NON-BLANK
     C*
     C     P6RTN         IFNE      *BLANKS
     C                   EXSR      CTERM
     C**********           END                                            LN1153
     C                   ELSE                                                                  LN115
      *                                                                   LN1153
      ** Otherwise send message 'Report submitted'                        LN1153
      *                                                                   LN1153
     C                   CALL      'FCC0240'                                                   LN115
     C                   PARM      'RCF0020'     MSGID             7                           LN115
     C                   END                                                                   LN115
     C*
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C*
     C* *PSSR - DATABASE ERROR HANDLING ROUTINE
     C* CALLED WHEN DATABASE ERROR OCCURS, OR AUTOMATICALLY BY SYSTEM
     C*
      *****************************************************************
     C     *PSSR         BEGSR
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
     C                   EXSR      CTERM
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C*
     C* CTERM - PROGRAM TERMINATION
     C* CALLED FROM MAIN, DELREQ, PROSFL
     C*
      *****************************************************************
     C     CTERM         BEGSR
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2001
**  CMD - ARRAY FOR QCMDEXC
WRKOUTQ OUTQ(          )
**  FREQUENCIES
1Each Mon
2Each Tue
3Each Wed
4Each Thu
5Each Fri
6Each Sat
7Each Sun
DDaily
MMonthly
AOn Accrl
BLast/Mth
QQ'trly
YYearly
