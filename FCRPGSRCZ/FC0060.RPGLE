000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2003')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEBND                                                   *
000500200529/*EXI *  TEXT('Midas FC Review todays reporting')
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Report Control Facility Module                       *
000900200529      *                                                               *
001000200529      *      FC0060 - REVIEW TODAY'S REPORTING                        *
001100200529      *                                                               *
001200200529      *  (c) Finastra International Limited 2001                      *
001300200529      *                                                               *
001400200604      *  Last Amend No. 248899             Date 22May20               *
001500200529      *  Prev Amend No. MD046248           Date 27Oct17               *
001600200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
001700200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
001800200529      *                 CRE026             Date 24May06               *
001900200529      * Midas Plus 1.3 ----------- Base ------------------------------*
002000200529      *                 CSD031             Date 10Apr06               *
002100200529      *                 CSD027             Date 09Dec05               *
002200200529      *                 TDA035             Date 02Apr04               *
002300200529      *                 CGL029             Date 01Sep03               *
002400200529      *                 CAAA02  *CONVERT   Date 02Dec03               *
002500200529      * Midas Release 4 --------------- Base -------------------------*
002600200529      * Midas DBA 3.00 ---------------- Base -------------------------*
002700200529      *                 090344           Date 19Jan98                 *
002800200529      *                 101040           Date 25Feb97                 *
002900200529      *                 087380           Date 10May95                 *
003000200529      *                 083547           Date 20Feb95                 *
003100200529      *                 S01486           Date 07Jun94                 *
003200200529      *                 S01117           Date 25Mar92                 *
003300200529      *                 S01269           Date 25Jun91                 *
003400200529      *                 LN1153           Date 06May91                 *
003500200529      *                 LN0986           Date 03May91                 *
003600200529      *                 S01314           Date 24Apr91                 *
003700200529      *                 LN1208           Date 20Mar91                 *
003800200529      *                 LN1186           Date 06Mar91                 *
003900200529      *                 BHF789           Date 25Jan91                 *
004000200529      *                 LN0843           Date 09Oct90                 *
004100200529      *                 BHF719           Date 01Oct90                 *
004200200529      *                 LN0366           Date 13Jun90                 *
004300200529      *                 LN0344           Date 11Jun90                 *
004400200529      *                                                               *
004500200529      *****************************************************************
004600200529      *                                                               *
004700200529      *  248899 - Reinstated use in MidasPlus.  Applied fix 245733.   *
004800200529      *  MD046248 - Finastra Rebranding                               *
004900200529      *  CRE026 - Consumer Banking (Recompile)                        *
005000200529      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
005100200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
005200200529      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
005300200529      *  CAAA02 - Converted to ILE due to file opening issues with    *
005400200529      *           FCYREQL1 and then Recompiled due to changes in      *
005500200529      *           FC0060DF                                            *
005600200529      *  090344 - When CF11 Pressed to produce Report, pgm set up     *
005700200529      *           System report but FC0600 is only available by       *
005800200529      *           Branch - set up parameters correctly.               *
005900200529      *  101040 - Branch type not taken from FCRCOML1 file            *
006000200529      *  087380 - Enlarge parameter for AOUSERR0                      *
006100200529      *  083547 - Recompile over MUSERDD                              *
006200200529      *  S01486 - Private Banking Upgrade to ABS 10.                  *
006300200529      *           Screen Level and Entity should always be shown.     *
006400200529      *           Recompiled over new display file.                   *
006500200529      *  S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD                  *
006600200529      *  S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO         *
006700200529      *           MUSERDD                                             *
006800200529      *  LN1153 - 1. DISPLAY PERSONAL OUTPUT QUEUE IF CF14 IS TAKEN   *
006900200529      *              INSTEAD OF WORKING WITH IT.                      *
007000200529      *           2. CHANGE SOME ERROR MESSAGES SENT DURING           *
007100200529      *              VALIDATION.ALTER HELP                            *
007200200529      *           3. DO NOT SEND MESSAGE RCF1021 IF ENTER PRESSED ON  *
007300200529      *              DELETE SCREEN.                                   *
007400200529      *           4. ENABLE F5 TO REBUILD THE SUBFILE.                *
007500200529      *           5. IF CF11 IS TAKEN TO PRINT A LIST SEND A MESSAGE  *
007600200529      *              TO INDICATE THAT THE REPORT HAS BEEN SUBMITTED.  *
007700200529      *  LN0986 - IF NO DETAILS EXIST, WRITE A BLANK RECORD TO        *
007800200529      *           SUBFILE IN ORDER TO CLEAR SCREEN                    *
007900200529      *  S01314 - Changes made during PTF incorporation.              *
008000200529      *           Multilanguage subfile message tags changed          *
008100200529      *  LN1208 - ON YESTERDAYS REPORTING ENQUIRY, DISPLAY            *
008200200529      *           DISTRIBUTION LIST FIELDS IN CORRECT ORDER           *
008300200529      *  LN1186 - SEND NEW MESSAGE ID FROM FCUSRMSG TO FCC0240        *
008400200529      *  BHF789 - ALLOW ANYONE TO DELETE HIS OWN REPORT REQUESTS      *
008500200529      *  LN0843 - REPORT POSITIONING FIELD SHOULD RETAIN VALUE        *
008600200529      *           SELECTED AND CARRY FORWARD TO SECOND SCREEN         *
008700200529      *  BHF719 - SELECT FIELD SHOULD RETAIN VALUE SELECTED           *
008800200529      *  LN0366 - DISABLE CF11 IF YESTERDAYS OUTPUT                   *
008900200529      *  LN0344 - CALL TO FC0040X, PARM P1RNAM CHANGED TO FC0060      *
009000200529      *                                                               *
009100200529      *****************************************************************
009200200529      *
009300200529      *              FUNCTION OF INDICATORS
009400200529      *
009500200529      *   01 - NO SUBFILE DETAILS YET DISPLAYED
009600200529      *   03 - EXIT PROG (F3)
009700200529      *   07 - TOGGLE BETWEEN TODAY AND YESTERDAY (F7)
009800200529      *   12 - TAKES USER BACK TO FIRST SCREEN (F12)
009900200529      *   10 - DELETE KEY TAKEN (F10)
010000200529      *   11 - SUBMIT REPORT OF TODAY'S DETAILS (F11)
010100200529      *   14 - DISPLAY OUTPUT QUEUE ON MUSER (F14)
010200200529      *   20 - SFLDSP
010300200529      *   21 - SFLDSPCTL
010400200529      *   22 - SFLNXTCHG
010500200529      *   23 - SFLCLR
010600200529      *   24 - END OF FILE FOR FCRREQ* OR FCYREQ* & SFLEND
010700200529      *   25 - END OF CHANGED SUBFILE RECORDS
010800200529      *   26 - LOKUP INDICATOR
010900200529      *   27 - END OF FILE FCRCOML1
011000200529      *   30 - USER ERROR
011100200529      *   31 - BRANCH ERROR
011200200529      *   32 - REPORT NAME ERROR
011300200529      *   41 - FILE IS SET TO FCRREQL5
011400200529      *   42 - FILE IS SET TO FCRREQL6
011500200529      *   43 - FILE IS SET TO FCRREQL7
011600200529      *   44 - FILE IS SET TO FCRREQL1
011700200529      *   45 - FILE IS SET TO FCYREQL5
011800200529      *   46 - FILE IS SET TO FCYREQL6
011900200529      *   47 - FILE IS SET TO FCYREQL7
012000200529      *   48 - FILE IS SET TO FCYREQL1
012100200529      *   50 - SINGLE BRANCH INDICATOR
012200200529      *   51 - STATUS (ON = TODAY, OFF = YESTERDAY)
012300200529      *   53 - USER AUTHORISED TO CHANGE OUTPUT
012400200529      *   54 - USER HAS OUTPUT QUEUE
012500200529      *   55 - ACCESS TO OTHER REPORTS
012600200529      *   56 - ACCESS TO MULTIBRANCHES
012700200529      *   60 - END OF SUBFILE MESSAGE FORMAT
012800200529      *   70 - SUBFILE RECORDS EXIST
012900200529      *   80 - ERROR ON INITIAL SCREEN
013000200529      *   81 - ERROR ON SUBFILE SELECTION SCREEN
013100200529      *   82 - CHAIN FAIL TO REPORT REQUEST RECORD
013200200529      *   83 - RECORDS ON MAARCDPD FOR REQUEST
013300200529      *   82 - CHAIN FAIL TO PARAMETERS DAILY RECORD
013400200529      *   88 - CHAIN FAIL TO REPORT DESCRIPTION
013500200529      *   89 - END OF FILE FCRREPTL1
013600200529      ********************************************************************
013700200529     FFC0060DF  CF   E             WORKSTN
013800200529     F                                     SFILE(FC0060S1:RRN)
013900200529     FFCRREQL0  UF   E           K DISK
014000200529     F                                     COMMIT
014100200529     FFCPARDL0  UF   E           K DISK
014200200529     F                                     COMMIT
014300200529     FMAARCDL2  UF   E           K DISK
014400200529     F                                     COMMIT
014500200529     FFCRREQL1  IF   E           K DISK
014600200529     FFCRREQL5  IF   E           K DISK
014700200529     FFCRREQL6  IF   E           K DISK
014800200529     FFCRREQL7  IF   E           K DISK
014900200529     FFCYREQL1  IF   E           K DISK
015000200529     FFCYREQL5  IF   E           K DISK
015100200529     FFCYREQL6  IF   E           K DISK
015200200529     FFCYREQL7  IF   E           K DISK
015300200529     FFCREPTL1  IF   E           K DISK
015400200529     FFCPREQL1  IF   E           K DISK
015500200529     FFCRCOML1  IF   E           K DISK
015600200529     F/COPY WNCPYSRC,FC0060F001
015700200529      *
015800200529     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
015900200529     D CMD             S             50    DIM(1) CTDATA PERRCD(1)
016000200529     D TABFRQ          S              1    DIM(13) CTDATA PERRCD(1)
016100200529     D TABNAM          S              8    DIM(13) ALT(TABFRQ)
016200200529      *
016300200529     D DSFDY         E DS                  EXTNAME(DSFDY)
016400200529      *
016500200529      ** 200 BYTE DATASTRUCTURE FOR ACCESS PROGRAMS
016600200529      *
016700200529     D DSSDY         E DS                  EXTNAME(DSSDY)                       087380
016800200529      *                                                                   087380
016900200529      ** 800 BYTE DATASTRUCTURE FOR ACCESS PROGRAMS                       087380
017000200529      *                                                                   087380
017100200529     D P@BRCH        E DS                  EXTNAME(SDBRCHPD)
017200200529      *
017300200529      ** LF/SDBRCHL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
017400200529      *
017500200529     D P@USER        E DS                  EXTNAME(MUSER)
017600200529      *
017700200529      ** LF/MUSER ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
017800200529      *
017900200529     D LDA             DS           256
018000200529      *
018100200529      ** LOCAL DATA AREA FOR DATABASE ERRORS
018200200529      *
018300200529     D  DBFILE               134    141
018400200529     D  DBKEY                142    170
018500200529     D  DBPGM                171    180
018600200529     D  DBASE                181    183  0
018700200529      *
018800200529     D PREQDS          DS
018900200529      *
019000200529      ** DATASTRUCTURE FOR PERIODIC REQUESTS DATABASE ERRORS
019100200529      *
019200200529     D  D5RNAM                 1     10
019300200529     D  D5PSQN                11     12
019400200529      *
019500200529     D RCOMDS          DS
019600200529      *
019700200529      ** DATASTRUCTURE FOR REPORT COMPONENTS DATABASE ERRORS
019800200529      *
019900200529     D  SRNAM                  1     10
020000200529     D  SCOTT                 11     20
020100200529     D  SCSEQ                 21     25
020200200529      *
020300200529     D RUNDAT          DS            13
020400200529      *
020500200529      ** DATA AREA CONTAINING SDBANKPD BASE DETAILS
020600200529      *
020700200529     D  RUNA                   1      7
020800200529     D  RUND                   8     10P 0
020900200529     D  SSF                   11     11
021000200529     D  DATF                  12     12
021100200529     D  @MBIN                 13     13
021200200529     D*
021300200529     D CMDDS           DS            50
021400200529      *
021500200529      ** DATA STRUCTURE FOR INSERTING OUTQ NAME INTO QCMDEXC STRING
021600200529      *
021700200529     D  QUEUE                 14     23
021800200529     D PSDS           SDS
021900200529      *
022000200529      **  Program status data structure.
022100200529      *
022200200529     D  @NOPMS                37     39  0
022300200529     D  WSID                 244    253
022400200529     D  @USER                254    263
022500200529     D  @JOBNO               264    269  0
022600200529     C********************************************************************S01314
022700200529      *                                                                   S01314
022800200529      ** Call SDRTVTXT pgm to access appropriate text                     S01314
022900200529      ** for a field used in a SFL                                        S01314
023000200529      *                                                                   S01314
023100200529     C                   MOVEL     'ZZGBMSGF'    MSGNM                                         S0131
023200200529     C                   MOVEL     'ZZM1175'     MSGDNB                                        S0131
023300200529     C                   CALL      'SDRTVTXT'                                                  S0131
023400200529     C                   PARM                    MSGDNB            7                           S0131
023500200529     C                   PARM                    MSGNM            10                           S0131
023600200529     C                   PARM                    MSGTXT           80                           S0131
023700200529     C                   MOVEL     MSGTXT        ZZM015                                        S0131
023800200529      *                                                                   S01314
023900200529     C                   MOVEL     'ZZM0361'     MSGDNB                                        S0131
024000200529     C                   CALL      'SDRTVTXT'                                                  S0131
024100200529     C                   PARM                    MSGDNB            7                           S0131
024200200529     C                   PARM                    MSGNM            10                           S0131
024300200529     C                   PARM                    MSGTXT           80                           S0131
024400200529     C**********           MOVELMSGTXT    ZZM057                    S01314LN1153
024500200529     C                   MOVEL     MSGTXT        ZZM058                                        LN115
024600200529      *                                                                   S01314
024700200529      ********************************************************************
024800200529      * CONTROL SECTION                                                  *
024900200529      ********************************************************************
025000200529     C                   EXSR      AINIT
025100200529     C                   EXSR      BMAIN
025200200529     C                   EXSR      CTERM
025300200529      ********************************************************************
025400200529      * INDEX OF SUBROUTINES
025500200529      *
025600200529      * AINIT  - INITIALISE
025700200529      * BMAIN  - MAIN SCREEN
025800200529      * VALINT - VALIDATE INITIAL SCREEN
025900200529      * FILE   - SET THE FILENAME ACCORDING TO DATA ENTERED ON SCREEN
026000200529      * SETLOW - SET LOWER LIMITS DEPENDING ON SCREEN INPUT
026100200529      * SETSUB - SETUP AND WRITE SUBFILE TO SCREEN
026200200529      * READIT - READ THE FILE SET BY THE FIRST INPUT SCREEN
026300200529      * VALSFL - VALIDATE SUBFILE
026400200529      * PROSFL - PROCESS SUBFILE REQUEST
026500200529      * DELREQ - DELETE REPORT REQUEST
026600200529      * CF14   - DISPLAY USERS OUTPUT QUEUE
026700200529      * CF11   - SUBMIT REPORT TO PRINT
026800200529      * *PSSR  - DATABASE ERROR HANDLING ROUTINE
026900200529      * CTERM  - PROGRAM TERMINATION
027000200529      *
027100200529      ********************************************************************
027200200529      /EJECT
027300200529      ********************************************************************
027400200529     C*
027500200529     C* AINIT - INITIALISE                                               *
027600200529     C* CALLED FROM MAIN
027700200529     C*
027800200529      ********************************************************************
027900200529     C     AINIT         BEGSR
028000200529     C*
028100200529     C                   MOVEA     CPY@          BIS@             80
028200200529     C/COPY WNCPYSRC,FC0060C001
028300200529     C*
028400200529     C     *DTAARA       DEFINE                  RUNDAT
028500200529     C                   IN        RUNDAT
028600200529     C*
028700200529     C** SET SINGLE BRANCH ENVIRONMENT INDICATOR
028800200529     C*
028900200529     C     @MBIN         IFEQ      'N'
029000200529     C                   SETON                                        50
029100200529     C                   END
029200200529     C*
029300200529     C                   MOVE      @USER         JUSR
029400200529     C*
029500200529     C** CHECK THAT THIS USER EXISTS ON LF/MUSER VIA ACCESS PROGRAM
029600200529     C*
029700200529     C                   CALL      'AOUSERR0'
029800200529     C                   PARM      *BLANK        P@APRC            7              B:Return code
029900200529     C                   PARM      '*KEY'        P@APOP            7              I:Option
030000200529     C                   PARM                    @USER            10              I:User profile
030100200529     C***********P@USER    PARM P@USER    DSFDY              O:Rec format 087380
030200200529     C     P@USER        PARM      P@USER        DSSDY                            O:Rec format 08738
030300200529     C*
030400200529     C** IF ACCESS PROGRAM ENDS IN ERROR DATABASE ERROR.
030500200529     C*
030600200529     C     P@APRC        IFNE      *BLANK
030700200529     C     *DTAARA       DEFINE                  LDA
030800200529     C     *LOCK         IN        LDA
030900200529     C                   MOVEL     'FC0060'      DBPGM
031000200529     C                   MOVEL     'MUSER'       DBFILE
031100200529     C                   MOVEL     @USER         DBKEY                          *************
031200200529     C                   Z-ADD     2             DBASE                          * DBERR 002 *
031300200529     C                   SETON                                        U7U8      *************
031400200529     C                   OUT       LDA
031500200529     C                   EXSR      *PSSR
031600200529     C                   END
031700200529     C*
031800200529     C** SET INDICATOR IF NOT AUTHORISED TO MULTIPLE USERS REPORTS
031900200529     C*
032000200529     C     MUREP         IFEQ      'N'
032100200529     C                   SETON                                        55
032200200529     C                   END
032300200529     C*
032400200529     C** SET INDICATOR IF NOT AUTHORISED TO MULTIPLE BRANCHES
032500200529     C*
032600200529     C     MBREP         IFEQ      'N'
032700200529     C                   SETON                                        56
032800200529     C                   END
032900200529     C*
033000200529     C** SET INDICATOR IF NO OUTQ DEFINED - DISABLE F14 FOR DISPLAY OF OUTQ
033100200529     C*
033200200529     C     OUTQ          IFNE      *BLANKS
033300200529     C                   SETON                                        54
033400200529     C                   MOVEL     OUTQ          XOUTQ            10
033500200529     C                   END
033600200529     C                   MOVEL     @USER         USER
033700200529     C*
033800200529     C** SET INDICATOR IF AUTHORISED TO CHANGE DETAILS
033900200529     C*
034000200529     C     ROUT          IFEQ      'Y'
034100200529     C                   MOVEL     ROUT          XROUT             1
034200200529     C                   SETON                                        53
034300200529     C                   END
034400200529     C*
034500200529     C** SET STATUS TO 'TODAYS ENQUIRY', SET ON SFLMSGRCD END INDICATOR
034600200529     C*
034700200529     C                   SETON                                        5160
034800200529     C                   MOVEL     '*'           SPGMQ
034900200529     C*
035000200529     C** CLEAR PROGRAM MESSAGE QUEUE
035100200529     C*
035200200529     C                   CALL      'ZA0250'
035300200529     C*
035400200529     C     EINIT         ENDSR
035500200529      *****************************************************************
035600200529      /EJECT
035700200529      *****************************************************************
035800200529     C*
035900200529     C* BMAIN - MAIN SCREEN
036000200529     C* CALLED FROM MAIN
036100200529     C* CALLS VALINT, FILE, SETLOW, SETSUB, CF14, CF11, VALSFL, PROSFL
036200200529     C*
036300200529      *****************************************************************
036400200529     C     BMAIN         BEGSR
036500200529     C*
036600200529     C** WRITE INITIAL SCREEN
036700200529     C*
036800200529     C                   WRITE     FC0060C0
036900200529     C                   EXFMT     FC0060F0
037000200529     C*
037100200529     C** CLEAR PROGRAM MESSAGE QUEUE
037200200529     C*
037300200529     C                   CALL      'ZA0250'
037400200529     C*
037500200529     C** PROCESS SCREEN UNTIL F3 FOR EXIT IS TAKEN
037600200529     C*
037700200529     C     *IN03         DOWEQ     '0'
037800200529     C*
037900200529     C** IF F7 IS TAKEN THEN
038000200529     C**     IF STATUS = TODAYS ENQUIRY THEN SET TO YESTERDAYS ENQUIRY.
038100200529     C**     IF STATUS = YESTERDAYS ENQUIRY THEN SET TO TODAYS ENQUIRY.
038200200529     C*
038300200529     C     *IN07         IFEQ      '1'
038400200529     C*
038500200529     C     *IN51         IFEQ      '1'
038600200529     C                   SETOFF                                       51
038700200529     C                   ELSE
038800200529     C                   SETON                                        51
038900200529     C                   END
039000200529     C*
039100200529     C** OTHERWISE VALIDATE THE DATA ENTERED ON THE SCREEN
039200200529     C*
039300200529     C                   ELSE
039400200529     C                   EXSR      VALINT
039500200529     C*
039600200529     C** End statement *in07
039700200529     C*
039800200529     C                   END
039900200529     C*
040000200529     C** IF DATA IS VALID, SET FILENAME AND SET UP SUBFILE FOR
040100200529     C** SECOND SCREEN, OTHERWISE RE-WRITE FIRST SCREEN
040200200529     C*
040300200529     C     *IN80         IFEQ      '0'
040400200529     C     *IN07         ANDEQ     '0'
040500200529     C                   EXSR      FILE
040600200529     C                   EXSR      SETLOW
040700200529     C                   EXSR      SETSUB
040800200529     C     SRPT          IFNE      *BLANK                                                      LN084
040900200529     C                   MOVE      SRPT          SRPTS                                         LN084
041000200529     C                   END                                                                   LN084
041100200529     C                   WRITE     FC0060F1
041200200529     C                   WRITE     FC0060F2
041300200529     C                   WRITE     FC0060C0
041400200529     C                   EXFMT     FC0060C1
041500200529     C                   CALL      'ZA0250'
041600200529     C*
041700200529     C** PROCESS SECOND SCREEN UNTIL EXIT/PREVIOUS TAKEN
041800200529     C*
041900200529     C     *IN03         DOWEQ     '0'
042000200529     C     *IN12         ANDEQ     '0'
042100200529     C     *IN05         OREQ      '1'                                                         LN115
042200200529      *
042300200529      ** DISPLAY OUTQ IF REQUESTED
042400200529      *
042500200529     C     *IN14         IFEQ      '1'
042600200529     C                   EXSR      CF14
042700200529     C                   END
042800200529      *
042900200529      ** PRODUCE LIST IF REQUESTED
043000200529      *
043100200529     C     *IN11         IFEQ      '1'
043200200529     C     *IN51         ANDEQ     '1'                                                         LN036
043300200529     C                   EXSR      CF11
043400200529     C                   END
043500200529      *
043600200529     C** ENTER PRESSED WITH NEW REPORT NAME: REPOSITION SUBFILE
043700200529      *
043800200529     C     SRPTS         IFNE      LRPTS
043900200529     C                   MOVEL     SRPTS         CHKF              1
044000200529      *
044100200529      ** CHECK 'REPORT NAME' ENTERED STARTS WITH LETTER
044200200529      *
044300200529     C     CHKF          IFLT      'A'                                                         LN036
044400200529     C     CHKF          ORGT      'Z'                                                         LN036
044500200529      *
044600200529      ** SEND ERROR MESSAGE IF NOT
044700200529      *
044800200529     C     SRPTS         IFNE      *BLANK
044900200529     C                   CALL      'FCC0240'
045000200529     C***********          PARM 'RCF0070' MSGID   7                       LN1186
045100200529     C                   PARM      'RCF1070'     MSGID             7                           LN118
045200200529     C                   END
045300200529     C                   END
045400200529      *
045500200529      ** RESET SUBFILE POSITION, AND SAVE LAST POSITIONING REPORT NAME
045600200529      *
045700200529     C**********           ELSE
045800200529     C     CHKF          IFGE      'A'                                                         LN036
045900200529     C     CHKF          ANDLE     'Z'                                                         LN036
046000200529     C     CHKF          OREQ      ' '                                                         LN036
046100200529     C                   MOVE      SRPTS         LRPTS            10                           BHF71
046200200529     C                   EXSR      SETLOW
046300200529     C*********************MOVEL*BLANKS   SRPTS                           BHF719
046400200529     C                   EXSR      SETSUB
046500200529     C*********************MOVE SRPTS     LRPTS  10                       BHF719
046600200529     C                   MOVE      LRPTS         SRPTS                                         BHF71
046700200529     C                   END
046800200529     C*                                                                   LN0366
046900200529     C                   WRITE     FC0060F1                                                    LN036
047000200529     C                   WRITE     FC0060F2                                                    LN036
047100200529     C                   WRITE     FC0060C0                                                    LN036
047200200529     C                   EXFMT     FC0060C1                                                    LN036
047300200529     C                   CALL      'ZA0250'                                                    LN036
047400200529     C*                                                                   LN0366
047500200529      *
047600200529      ** IF NEW REPORT NAME NOT ENTERED
047700200529      *
047800200529     C                   ELSE
047900200529      *
048000200529     C** VALIDATE SUBFILE
048100200529      *
048200200529     C     *IN70         IFEQ      '1'
048300200529     C                   EXSR      VALSFL
048400200529     C                   END
048500200529     C*
048600200529     C** IF SUBFILE IS VALID PROCESS REQUEST
048700200529     C*
048800200529     C     *IN81         IFEQ      '0'
048900200529     C     *IN70         ANDEQ     '1'
049000200529     C                   EXSR      PROSFL
049100200529     C                   EXSR      SETLOW
049200200529     C                   EXSR      SETSUB
049300200529     C                   END
049400200529     C*
049500200529     C** REWRITE SUBFILE SCREEN
049600200529     C*
049700200529     C                   MOVE      LRPTS         SRPTS                                         BHF71
049800200529     C                   WRITE     FC0060C0
049900200529     C                   WRITE     FC0060F1
050000200529     C                   WRITE     FC0060F2
050100200529     C                   EXFMT     FC0060C1
050200200529     C                   CALL      'ZA0250'
050300200529     C                   END
050400200529     C*
050500200529     C** End statement *in03/*in12
050600200529     C*
050700200529     C                   END
050800200529     C*
050900200529     C** End statement *in80
051000200529     C*
051100200529     C                   END
051200200529     C*
051300200529     C** IF EXIT HAS NOT BEEN REQUESTED, SET OF PREVIOUS SCREEN
051400200529     C** /SUBFILE PROCESSED INDICATORS
051500200529     C*
051600200529     C     *IN03         IFEQ      '0'
051700200529     C                   SETOFF                                       1224
051800200529     C*********************MOVEL*BLANKS   SRPTS                     LN0366BHF719
051900200529     C                   MOVE      LRPTS         SRPTS                                         BHF71
052000200529     C                   WRITE     FC0060C0
052100200529     C                   EXFMT     FC0060F0
052200200529     C                   CALL      'ZA0250'
052300200529     C                   END
052400200529     C*
052500200529     C* End DO *IN03
052600200529     C*
052700200529     C                   END
052800200529     C*
052900200529     C                   ENDSR
053000200529      *****************************************************************
053100200529      /EJECT
053200200529      *****************************************************************
053300200529     C*
053400200529     C* VALINT - VALIDATE INITIAL SCREEN
053500200529     C* CALLED FROM BMAIN
053600200529     C*
053700200529      *****************************************************************
053800200529     C*
053900200529     C     VALINT        BEGSR
054000200529     C*
054100200529     C** CLEAR PROGRAM MESSAGES AND RESET ERROR INDICATORS
054200200529     C*
054300200529     C                   SETOFF                                       803031
054400200529     C                   SETOFF                                       32
054500200529     C*
054600200529     C** IF USER IS DIFFERENT FROM CURRENT USER CHECK THAT USER EXISTS
054700200529     C** ON LF/MUSER
054800200529     C*
054900200529     C     USER          IFNE      *BLANKS
055000200529     C     USER          ANDNE     @USER
055100200529     C                   CALL      'AOUSERR0'
055200200529     C                   PARM      *BLANK        P@APRC            7              B:Return code
055300200529     C                   PARM      '*KEY'        P@APOP            7              I:Option
055400200529     C                   PARM                    USER             10              I:User profile
055500200529     C***********P@USER    PARM P@USER    DSFDY              O:Rec format 087380
055600200529     C     P@USER        PARM      P@USER        DSSDY                            O:Rec format 08738
055700200529     C     P@APRC        IFNE      *BLANK
055800200529     C                   CALL      'FCC0240'
055900200529     C***********          PARM 'RCF0013' MSGID   7                       LN1186
056000200529     C                   PARM      'RCF1013'     MSGID                                         LN118
056100200529     C                   SETON                                        8030
056200200529     C                   END
056300200529     C                   END
056400200529     C*
056500200529     C** CHECK THAT THE BRANCH CODE EXISTS ON SDBRCHPD
056600200529     C*
056700200529     C     BRANCH        IFNE      *BLANKS
056800200529     C*****              CALL      'AOBRCHR0'                                                 CGL029
056900200529     C                   CALL      'AOBRCHR1'                                                 CGL029
057000200529     C                   PARM      *BLANK        P@APRC            7              B:Return code
057100200529     C                   PARM      '*KEY'        P@APOP            7              I:Option
057200200529     C                   PARM                    BRANCH            3              I:User branch
057300200529     C*****P@BRCH        PARM      P@BRCH        DSFDY                            O:Rec formatCGL029
057400200529     C     P@BRCH        PARM      P@BRCH        DSSDY                            O:Rec formatCGL029
057500200529     C     P@APRC        IFNE      *BLANKS
057600200529     C                   CALL      'FCC0240'
057700200529     C***********          PARM 'RCF0014' MSGID   7                       LN1186
057800200529     C                   PARM      'RCF1014'     MSGID                                         LN118
057900200529     C                   SETON                                        8031
058000200529     C                   END
058100200529     C*
058200200529     C** CHECK USER'S AUTHORITY TO BRANCH, IF BRANCH IS VALID.            LN0366
058300200529     C*                                                                   LN0366
058400200529     C     *IN31         IFNE      '1'                                                         LN036
058500200529     C*                                                                   LN0366
058600200529     C                   CALL      'ZVBBU'
058700200529     C                   PARM      BRANCH        ZBRCDX            3
058800200529     C                   PARM                    ERR               1 0
058900200529     C     ERR           IFNE      0
059000200529     C                   CALL      'FCC0240'
059100200529     C***********          PARM 'RCF0015' MSGID   7                       LN1186
059200200529     C                   PARM      'RCF1015'     MSGID                                         LN118
059300200529     C                   SETON                                        8031
059400200529     C                   END
059500200529     C                   END                                                                   LN036
059600200529     C                   END
059700200529     C*
059800200529     C** CHECK REPORT NAME STARTS WITH A LETTER
059900200529     C*
060000200529     C***********SRPTS     IFNE *BLANKS                                   LN0366
060100200529     C     SRPT          IFNE      *BLANKS                                                     LN036
060200200529     C***********          MOVE SRPTS     LRPTS  10                       LN0366
060300200529     C                   MOVE      SRPT          LRPTS            10                           LN036
060400200529     C                   MOVE      SRPT          SRPTS                                         LN036
060500200529     C***********          MOVELSRPTS     CHKF    1                       LN0366
060600200529     C                   MOVEL     SRPT          CHKF              1                           LN036
060700200529     C*
060800200529     C     CHKF          IFLT      'A'
060900200529     C     CHKF          ORGT      'Z'
061000200529     C                   CALL      'FCC0240'
061100200529     C***********          PARM 'RCF0070' MSGID   7                       LN1186
061200200529     C                   PARM      'RCF1070'     MSGID                                         LN118
061300200529     C                   SETON                                        8032
061400200529     C                   END
061500200529     C*
061600200529     C                   END
061700200529     C*
061800200529     C                   ENDSR
061900200529      *****************************************************************
062000200529      /EJECT
062100200529      *****************************************************************
062200200529     C*
062300200529     C* FILE - SET THE FILENAME ACCORDING TO DATA ENTERED ON SCREEN
062400200529     C* CALLED FROM BMAIN
062500200529     C*
062600200529      *****************************************************************
062700200529     C*
062800200529     C     FILE          BEGSR
062900200529     C*
063000200529     C** RESET INDICATORS FOR NEW SELECTION
063100200529     C*
063200200529     C                   SETOFF                                       414243
063300200529     C                   SETOFF                                       444546
063400200529     C                   SETOFF                                       4748
063500200529     C*
063600200529     C** STATUS = TODAYS ENQUIRY
063700200529     C*
063800200529     C     *IN51         IFEQ      '1'
063900200529     C*
064000200529     C** IF USER IS ENTERED THEN FILE TO BE USED IS FCRREQL5
064100200529     C*
064200200529     C     USER          IFNE      *BLANKS
064300200529     C     BRANCH        ANDEQ     *BLANKS
064400200529     C                   SETON                                        41
064500200529     C                   END
064600200529     C*
064700200529     C** IF BRANCH IS ENTERED THEN FILE TO BE USED IS FCRREQL6
064800200529     C*
064900200529     C     USER          IFEQ      *BLANKS
065000200529     C     BRANCH        ANDNE     *BLANKS
065100200529     C                   SETON                                        42
065200200529     C                   END
065300200529     C*
065400200529     C** IF BOTH USER AND BRANCH ENTERED THEN FILE USED IS FCRREQL7
065500200529     C*
065600200529     C     USER          IFNE      *BLANKS
065700200529     C     BRANCH        ANDNE     *BLANKS
065800200529     C                   SETON                                        43
065900200529     C                   END
066000200529     C*
066100200529     C** IF NEITHER USER OR BRANCH ENTERED FILE USED IS FCRREQL1
066200200529     C*
066300200529     C     USER          IFEQ      *BLANKS
066400200529     C     BRANCH        ANDEQ     *BLANKS
066500200529     C                   SETON                                        44
066600200529     C                   END
066700200529     C*
066800200529     C** END TODAY'S ENQUIRY
066900200529     C*
067000200529     C                   END
067100200529     C*
067200200529     C**
067300200529     C** IF STATUS - YESTERDAYS ENQUIRY
067400200529     C**
067500200529     C*
067600200529     C     *IN51         IFEQ      '0'
067700200529     C*
067800200529     C** IF USER ENTERED THEN FILE TO BE USED IS FCYREQL5
067900200529     C*
068000200529     C     USER          IFNE      *BLANKS
068100200529     C     BRANCH        ANDEQ     *BLANKS
068200200529     C                   SETON                                        45
068300200529     C                   END
068400200529     C*
068500200529     C** IF BRANCH ENTERED THEN FILE TO BE USED IS FCYREQL6
068600200529     C*
068700200529     C     USER          IFEQ      *BLANKS
068800200529     C     BRANCH        ANDNE     *BLANKS
068900200529     C                   SETON                                        46
069000200529     C                   END
069100200529     C*
069200200529     C** IF BOTH USER AND BRANCH ENTERED THEN FILE USED IS FCYREQL7
069300200529     C*
069400200529     C     USER          IFNE      *BLANKS
069500200529     C     BRANCH        ANDNE     *BLANKS
069600200529     C                   SETON                                        47
069700200529     C                   END
069800200529     C*
069900200529     C** IF NEITHER USER OR BRANCH ENTERED THEN FILE USED IS FCYREQL1
070000200529     C*
070100200529     C     USER          IFEQ      *BLANKS
070200200529     C     BRANCH        ANDEQ     *BLANKS
070300200529     C                   SETON                                        48
070400200529     C                   END
070500200529     C*
070600200529     C                   END
070700200529     C*
070800200529     C                   ENDSR
070900200529      *******************************************************************
071000200529      /EJECT
071100200529      *******************************************************************
071200200529     C*
071300200529     C* SETLOW - SET LOWER LIMITS DEPENDING ON SCREEN INPUT
071400200529     C* CALLED FROM MAIN
071500200529     C*
071600200529      *******************************************************************
071700200529     C     SETLOW        BEGSR
071800200529     C*
071900200529     C     *IN41         IFEQ      '1'
072000200529     C*
072100200529     C** KLIST TO READ FCRREQL5
072200200529     C*
072300200529     C     KYTOD5        KLIST
072400200529     C                   KFLD                    KUSRR            10
072500200529     C                   KFLD                    KRNAM            10
072600200529     C                   KFLD                    KRQSQ             5
072700200529     C                   MOVEL     USER          KUSRR
072800200529     C                   MOVEL     SRPTS         KRNAM
072900200529     C                   MOVEL     *BLANKS       KRQSQ
073000200529     C     KYTOD5        SETLL     FCRREQL5
073100200529     C*
073200200529     C                   END
073300200529     C*
073400200529     C     *IN42         IFEQ      '1'
073500200529     C*
073600200529     C** KLIST TO READ FCRREQL6
073700200529     C*
073800200529     C     KYTOD6        KLIST
073900200529     C                   KFLD                    KETTY             3
074000200529     C                   KFLD                    KRNAM            10
074100200529     C                   KFLD                    KRQSQ             5
074200200529     C                   MOVEL     BRANCH        KETTY
074300200529     C                   MOVEL     SRPTS         KRNAM
074400200529     C                   MOVEL     *BLANKS       KRQSQ
074500200529     C     KYTOD6        SETLL     FCRREQL6
074600200529     C*
074700200529     C                   END
074800200529     C*
074900200529     C     *IN43         IFEQ      '1'
075000200529     C*
075100200529     C** KLIST TO READ FCRREQL7
075200200529     C*
075300200529     C     KYTOD7        KLIST
075400200529     C                   KFLD                    KETTY             3
075500200529     C                   KFLD                    KUSRR            10
075600200529     C                   KFLD                    KRNAM            10
075700200529     C                   KFLD                    KRQSQ             5
075800200529     C                   MOVEL     BRANCH        KETTY
075900200529     C                   MOVEL     USER          KUSRR
076000200529     C                   MOVEL     SRPTS         KRNAM
076100200529     C                   MOVEL     *BLANKS       KRQSQ
076200200529     C     KYTOD7        SETLL     FCRREQL7
076300200529     C*
076400200529     C                   END
076500200529     C*
076600200529     C     *IN44         IFEQ      '1'
076700200529     C*
076800200529     C**  KLIST TO READ FCRREQL1
076900200529     C*
077000200529     C     KYTOD1        KLIST
077100200529     C                   KFLD                    KRNAM            10
077200200529     C                   KFLD                    KRQSQ             5
077300200529     C                   MOVEL     SRPTS         KRNAM
077400200529     C                   MOVEL     *BLANKS       KRQSQ
077500200529     C                   SETON                                        44
077600200529     C     KYTOD1        SETLL     FCRREQL1
077700200529     C*
077800200529     C                   END
077900200529     C*
078000200529     C     *IN45         IFEQ      '1'
078100200529     C*
078200200529     C** KLIST TO READ FCYREQL5
078300200529     C*
078400200529     C     KYEST5        KLIST
078500200529     C                   KFLD                    KUSRR            10
078600200529     C                   KFLD                    KRNAM            10
078700200529     C                   KFLD                    KRQSQ             5
078800200529     C                   MOVEL     USER          KUSRR
078900200529     C                   MOVEL     SRPTS         KRNAM
079000200529     C                   MOVEL     *BLANKS       KRQSQ
079100200529     C     KYEST5        SETLL     FCYREQL5
079200200529     C*
079300200529     C                   END
079400200529     C*
079500200529     C     *IN46         IFEQ      '1'
079600200529     C*
079700200529     C** KLIST TO READ FCYREQL6
079800200529     C*
079900200529     C     KYEST6        KLIST
080000200529     C                   KFLD                    KETTY             3
080100200529     C                   KFLD                    KRNAM            10
080200200529     C                   KFLD                    KRQSQ             5
080300200529     C                   MOVEL     BRANCH        KETTY
080400200529     C                   MOVEL     SRPTS         KRNAM
080500200529     C                   MOVEL     *BLANKS       KRQSQ
080600200529     C     KYEST6        SETLL     FCYREQL6
080700200529     C*
080800200529     C                   END
080900200529     C*
081000200529     C     *IN47         IFEQ      '1'
081100200529     C*
081200200529     C** KLIST TO READ FCYREQL7
081300200529     C*
081400200529     C     KYEST7        KLIST
081500200529     C                   KFLD                    KETTY
081600200529     C                   KFLD                    KUSRR
081700200529     C                   KFLD                    KRNAM            10
081800200529     C                   KFLD                    KRQSQ             5
081900200529     C                   MOVEL     BRANCH        KETTY
082000200529     C                   MOVEL     USER          KUSRR
082100200529     C                   MOVEL     SRPTS         KRNAM
082200200529     C                   MOVEL     *BLANKS       KRQSQ
082300200529     C     KYEST7        SETLL     FCYREQL7
082400200529     C*
082500200529     C                   END
082600200529     C*
082700200529     C     *IN48         IFEQ      '1'
082800200529     C*
082900200529     C** KLIST TO READ FCYREQL1
083000200529     C*
083100200529     C     KYEST1        KLIST
083200200529     C                   KFLD                    KRNAM            10
083300200529     C                   KFLD                    KRQSQ             5
083400200529     C                   MOVEL     SRPTS         KRNAM
083500200529     C                   MOVEL     *BLANKS       KRQSQ
083600200529     C     KYEST1        SETLL     FCYREQL1
083700200529     C*
083800200529     C                   END
083900200529     C*
084000200529     C                   ENDSR
084100200529      *******************************************************************
084200200529      /EJECT
084300200529      *******************************************************************
084400200529     C*
084500200529     C* SETSUB - SETUP AND WRITE SUBFILE TO SCREEN
084600200529     C* CALLED FROM MAIN
084700200529     C* CALLS READIT
084800200529     C*
084900200529      *******************************************************************
085000200529     C*
085100200529     C     SETSUB        BEGSR
085200200529     C*
085300200529     C** IF SUBFILE HAS BEEN DISPLAYED, CLEAR CURRENT DETAILS
085400200529     C*
085500200529     C     *IN01         IFEQ      '1'
085600200529     C                   SETOFF                                       01                       LN036
085700200529     C                   SETON                                        23
085800200529     C                   SETOFF                                       202122
085900200529     C                   SETOFF                                       33
086000200529     C                   SETON                                        24                       LN036
086100200529     C                   WRITE     FC0060C1
086200200529     C                   SETOFF                                       24                       LN036
086300200529     C                   END
086400200529     C*
086500200529     C** SET OFF DETAILS EXIST INDICATOR, RESET RECORD NUMBER TO 1
086600200529     C*
086700200529     C                   SETOFF                                       70
086800200529     C                   SETOFF                                       28                       LN098
086900200529     C                   Z-ADD     1             RRN               5 0
087000200529     C                   Z-ADD     1             SDREC
087100200529     C                   MOVEL     *BLANKS       SELECT
087200200529     C*
087300200529     C** SET UP SUBFILE
087400200529     C*
087500200529     C                   EXSR      READIT
087600200529     C*
087700200529     C** FORMAT DETAILS
087800200529     C*
087900200529     C     *IN24         DOWEQ     '0'
088000200529     C*
088100200529     C** SET RECORDS EXIST INDICATOR
088200200529     C*
088300200529     C                   SETON                                        70
088400200529     C*
088500200529     C                   MOVEL     *BLANK        SOTYP
088600200529     C                   MOVEL     *BLANK        SOUTP
088700200529     C                   MOVEL     *BLANK        SFREQ
088800200529     C                   MOVEL     *BLANK        SRPTS                                         LN036
088900200529     C*
089000200529     C** SET UP SUBFILE RECORD
089100200529     C** IF STATUS = TODAY
089200200529     C*
089300200529     C     *IN51         IFEQ      '1'
089400200529     C                   MOVEL     D5RNAM        SRNAM
089500200529     C                   MOVEL     D5RQSQ        SSEQ
089600200529     C                   MOVEL     D5LVL         SLVL
089700200529     C                   MOVEL     D5ETTY        SENTY
089800200529     C                   MOVEL     D5USRR        SUSER
089900200529     C                   MOVEL     EKDBRN        SUBR
090000200529     C                   MOVEL     D5USRO        SUSRO
090100200529     C                   MOVEL     D5DLS1        SDL1
090200200529     C                   MOVEL     D5DLS2        SDL2
090300200529     C                   MOVEL     D5SOID        SSOID
090400200529     C                   MOVEL     D5DRQD        SDRQD
090500200529     C*
090600200529     C** SET READY FLAG ON IF JOB NAME IS PRESENT
090700200529     C*
090800200529     C     D5JBNM        IFNE      *BLANKS
090900200529     C                   MOVEL     'Y'           SRDY
091000200529     C                   ELSE
091100200529     C                   MOVEL     'N'           SRDY
091200200529     C                   END
091300200529     C*
091400200529     C** OUTPUT METHOD IS USER ID IF USER FOR OUTPUT NON-BLANK
091500200529     C*
091600200529     C     D5USRO        IFNE      *BLANKS
091700200529     C                   MOVEL     'USER'        SOTYP
091800200529     C                   MOVEL     D5USRO        SOUTP
091900200529     C                   END
092000200529     C*
092100200529     C** OUTPUT METHOD IS DISTRIBUTION LIST IF DISTRIBUTION LIST FIELDS
092200200529     C** NON BLANK
092300200529     C*
092400200529     C     D5DLS1        IFNE      *BLANKS
092500200529     C     D5DLS2        ANDNE     *BLANKS
092600200529     C                   MOVEL     'DIST'        SOTYP
092700200529     C                   MOVEL     D5DLS1        SOUTP
092800200529     C                   MOVE      D5DLS2        SOUTP
092900200529     C                   END
093000200529     C*
093100200529     C** STANDARD OUTPUT INSTRUCTIONS USED IF SOI NON-BLANK
093200200529     C*
093300200529     C     D5SOID        IFNE      *BLANKS
093400200529     C                   MOVEL     'SOI '        SOTYP
093500200529     C                   MOVEL     D5SOID        SOUTP
093600200529     C                   END
093700200529     C*
093800200529     C** IF NO OUTPUT METHOD, BUT ARCHIVING REQUESTED SET METHOD 'ARCHIVE'
093900200529     C*
094000200529     C     D5USRO        IFEQ      *BLANKS
094100200529     C     D5SOID        ANDEQ     *BLANKS
094200200529     C     D5DLS1        ANDEQ     *BLANKS
094300200529      *
094400200529     C     D5ARMF        IFEQ      'Y'
094500200529     C     D5AROD        OREQ      'Y'
094600200529     C                   MOVEL     *BLANKS       SOTYP
094700200529     C                   MOVEL     'ARCHIVED'    SOUTP
094800200529     C                   END
094900200529      *
095000200529     C                   END
095100200529     C*
095200200529     C** SET COMPONENT NAME ETC. AS HIDDEN FIELDS FOR LATER
095300200529     C*
095400200529     C                   MOVEL     D5COTT        SCOTT
095500200529     C                   MOVEL     D5CSEQ        SCSEQ
095600200529     C*
095700200529     C** SET PRODUCTION METHOD: CLOSE OF BUSINESS/INPUT CYCLE
095800200529     C*
095900200529     C     D5COBR        IFEQ      'Y'
096000200529     C                   MOVEL     '   CoB'      SFREQ
096100200529     C                   END
096200200529     C*
096300200529     C     D5IPCY        IFEQ      'Y'
096400200529     C                   MOVEL     '  Immed'     SFREQ
096500200529     C                   END
096600200529     C*
096700200529     C** IF PERIODIC REQUEST, ACCESS DETAILS FOR FREQUENCE
096800200529     C*
096900200529     C     D5PDFL        IFEQ      'Y'
097000200529     C     KPREQ         KLIST
097100200529     C                   KFLD                    D5RNAM
097200200529     C                   KFLD                    D5PSQR
097300200529     C*
097400200529     C     KPREQ         CHAIN     FCPREQL1                           89
097500200529     C*
097600200529     C** SET FREQUENCE IF RECORD FOUND, ELSE DATABASE ERROR
097700200529     C*
097800200529     C     *IN89         IFEQ      '0'
097900200529     C     D9FREQ        LOOKUP    TABFRQ        TABNAM                   26
098000200529     C                   MOVE      TABNAM        SFREQ
098100200529     C                   ELSE
098200200529     C*
098300200529     C     *LOCK         IN        LDA                                            ************
098400200529     C                   MOVE      PREQDS        DBKEY                            * DBERR 03 *
098500200529     C                   MOVE      'FCPREQL1'    DBFILE                           ************
098600200529     C                   Z-ADD     3             DBASE
098700200529     C                   SETON                                        U7U8
098800200529     C                   OUT       LDA
098900200529     C                   EXSR      *PSSR
099000200529     C                   END
099100200529     C*
099200200529     C                   END
099300200529     C*
099400200529     C                   ELSE
099500200529     C*
099600200529     C** IF STATUS = YESTERDAY
099700200529     C*
099800200529     C                   MOVEL     EKRNAM        SRNAM
099900200529     C                   MOVEL     EKRQSQ        SSEQ
100000200529     C                   MOVEL     EKLVL         SLVL
100100200529     C                   MOVEL     EKETTY        SENTY
100200200529     C                   MOVEL     EKUSRR        SUSER
100300200529     C                   MOVEL     EKDBRN        SUBR
100400200529     C                   MOVEL     EKUSRO        SUSRO
100500200529     C                   MOVEL     EKDLS1        SDL1
100600200529     C                   MOVEL     EKDLS2        SDL2
100700200529     C                   MOVEL     EKSOID        SSOID
100800200529     C                   MOVEL     EKDRQD        SDRQD
100900200529     C*
101000200529     C** SET STATUS TO READY IF JOB NAME PRESENT
101100200529     C*
101200200529     C     EKJBNM        IFNE      *BLANKS
101300200529     C                   MOVEL     'Y'           SRDY
101400200529     C                   ELSE
101500200529     C                   MOVEL     'N'           SRDY
101600200529     C                   END
101700200529     C*
101800200529     C** SET OUTPUT METHOD TO USER IF USER ID FOR OUTPUT NON-BLANK
101900200529     C*
102000200529     C     EKUSRO        IFNE      *BLANKS
102100200529     C                   MOVEL     'USER'        SOTYP
102200200529     C                   MOVEL     EKUSRO        SOUTP
102300200529     C                   END
102400200529     C*
102500200529     C** SET METHOD TO DISTRIBUTION LIST IF NONBLANK
102600200529     C*
102700200529     C     EKDLS1        IFNE      *BLANKS
102800200529     C     EKDLS2        ANDNE     *BLANKS
102900200529     C                   MOVEL     'DIST'        SOTYP
103000200529     C***********          MOVELEKDLS2    SOUTP                           LN1208
103100200529     C***********          MOVE EKDLS1    SOUTP                           LN1208
103200200529     C                   MOVEL     EKDLS1        SOUTP                                         LN120
103300200529     C                   MOVE      EKDLS2        SOUTP                                         LN120
103400200529     C                   END
103500200529     C*
103600200529     C** SET METHOD TO STANDARD OUTPUT ID IF NONBLANK
103700200529     C*
103800200529     C     EKSOID        IFNE      *BLANKS
103900200529     C                   MOVEL     'SOI'         SOTYP
104000200529     C                   MOVEL     EKSOID        SOUTP
104100200529     C                   END
104200200529     C*
104300200529      ** IF ALL BLANK AND ARCHIVING SET ON, SET TO ARCHIVED
104400200529     C*
104500200529     C     EKUSRO        IFEQ      *BLANKS
104600200529     C     EKSOID        ANDEQ     *BLANKS
104700200529     C     EKDLS1        ANDEQ     *BLANKS
104800200529      *
104900200529     C     EKARMF        IFEQ      'Y'
105000200529     C     EKAROD        OREQ      'Y'
105100200529     C                   MOVEL     'ARCHIVED'    SOUTP
105200200529     C                   END
105300200529      *
105400200529     C                   END
105500200529     C*
105600200529     C** HIDDEN FIELDS FOR LATER USE
105700200529     C*
105800200529     C                   MOVEL     EKCOTT        SCOTT
105900200529     C                   MOVEL     EKCSEQ        SCSEQ
106000200529     C*
106100200529     C** SET PRODUCTION FREQUENCY TO CLOSE OF BUSINESS/INPUT CYCLE
106200200529     C*
106300200529     C     EKCOBR        IFEQ      'Y'
106400200529     C                   MOVEL     '   CoB'      SFREQ
106500200529     C                   END
106600200529     C*
106700200529     C     EKIPCY        IFEQ      'Y'
106800200529     C                   MOVEL     '  Immed'     SFREQ
106900200529     C                   END
107000200529     C*
107100200529     C** IF PERIODIC REQUEST, SET FREQUENCE
107200200529     C*
107300200529     C     EKPDFL        IFEQ      'Y'
107400200529     C*
107500200529     C                   MOVE      EKRNAM        D5RNAM
107600200529     C                   MOVE      EKPSQR        D5PSQN
107700200529      *
107800200529     C     KPREQ         CHAIN     FCPREQL1                           89
107900200529      *
108000200529      ** CANNOT GIVE DBERR IF NO RECORD, AS MAY HAVE BEEN DELETED TODAY
108100200529      *
108200200529     C     *IN89         IFEQ      '0'
108300200529     C     D9FREQ        LOOKUP    TABFRQ        TABNAM                   26
108400200529     C                   MOVE      TABNAM        SFREQ
108500200529     C                   END
108600200529      *
108700200529     C                   END
108800200529      *
108900200529     C                   END
109000200529     C*
109100200529     C** ACCESS REPORT DETAILS - DATABASE ERROR IF NOT FOUND
109200200529     C*
109300200529     C     SRNAM         CHAIN     FCREPTL1                           88
109400200529     C*
109500200529     C     *IN88         IFEQ      '1'
109600200529     C     *LOCK         IN        LDA                                           ************
109700200529     C                   MOVE      SRNAM         DBKEY                           * DBERR 01 *
109800200529     C                   MOVE      'FCREPTPD'    DBFILE                          ************
109900200529     C                   Z-ADD     01            DBASE
110000200529     C                   SETON                                        U7U8
110100200529     C                   OUT       LDA
110200200529     C                   EXSR      *PSSR
110300200529     C                   ELSE
110400200529     C                   MOVEL     DXRDSC        SDESC
110500200529     C                   END
110600200529     C*
110700200529     C** WRITE SUBFILE RECORD
110800200529     C*
110900200529     C                   WRITE     FC0060S1
111000200529     C                   ADD       1             RRN
111100200529     C                   EXSR      READIT
111200200529     C                   END
111300200529     C*                                                                   LN0986
111400200529     C** IF NO DETAILS PRESENT WRITE BLANK RECORD TO SUBFILE              LN0986
111500200529     C*                                                                   LN0986
111600200529     C     *IN70         IFEQ      '0'                                                         LN098
111700200529     C                   MOVE      *BLANK        SRNAM                                         LN098
111800200529     C                   MOVE      *BLANK        SSEQ                                          LN098
111900200529     C                   MOVE      *BLANK        SRDY                                          LN098
112000200529     C                   MOVE      *BLANK        SLVL                                          LN098
112100200529     C                   MOVE      *BLANK        SENTY                                         LN098
112200200529     C                   MOVE      *BLANK        SUSER                                         LN098
112300200529     C                   MOVE      *BLANK        SUBR                                          LN098
112400200529     C                   MOVE      *BLANK        SOTYP                                         LN098
112500200529     C                   MOVE      *BLANK        SOUTP                                         LN098
112600200529     C                   MOVE      *BLANK        SDESC                                         LN098
112700200529     C                   MOVE      *BLANK        SFREQ                                         LN098
112800200529     C** SET INDICATOR TO PROTECT SUBFILE FIELDS                          LN0986
112900200529     C                   SETON                                        28                       LN098
113000200529     C                   WRITE     FC0060S1                                                    LN098
113100200529     C                   END                                                                   LN098
113200200529      *
113300200529     C** WRITE SUBFILE/CONTROL
113400200529      *
113500200529     C                   SETOFF                                       23
113600200529     C                   SETON                                        20
113700200529      *
113800200529      ***IF*DETAILS*PRESENT,*SET*SUBFILE*PRESENT*INDICAOTR*************   LN0986
113900200529      ************                                                        LN0986
114000200529     C************IN01     IFEQ '0'                                       LN0986
114100200529     C************IN70     ANDEQ'1'                                       LN0986
114200200529      *                                                                   LN0986
114300200529      ** SET SUBFILE PRESENT INDICATOR AND DISPLAY SUBFILE                LN0986
114400200529      *                                                                   LN0986
114500200529     C                   SETON                                        01
114600200529     C***********          END                                            LN0986
114700200529      ***********                                                         LN0986
114800200529      ***DISPLAY*SUBFILE*IF*DETAILS*PRESENT****************************   LN0986
114900200529      ***********                                                         LN0986
115000200529     C************IN01     IFEQ '1'                                       LN0986
115100200529     C                   SETON                                        21
115200200529     C***********          END                                            LN0986
115300200529     C*
115400200529     C** IF NO DETAILS, SEND MESSAGE TO INFORM USER
115500200529     C*
115600200529     C     *IN70         IFEQ      '0'
115700200529     C                   CALL      'FCC0240'
115800200529     C***********          PARM 'RCF0069' MSGID                           LN1186
115900200529     C                   PARM      'RCF1069'     MSGID                                         LN118
116000200529     C                   END
116100200529      *
116200200529     C                   ENDSR
116300200529      *******************************************************************
116400200529      /EJECT
116500200529      *******************************************************************
116600200529     C*
116700200529     C* READIT - READ THE FILE SET BY THE FIRST INPUT SCREEN
116800200529     C* CALLED FROM SETSUB
116900200529     C*
117000200529      *******************************************************************
117100200529     C*
117200200529     C     READIT        BEGSR
117300200529     C*
117400200529     C     *IN41         IFEQ      '1'
117500200529     C     KYTODA        KLIST
117600200529     C                   KFLD                    AUSR             10
117700200529     C                   MOVEL     USER          AUSR
117800200529     C     KYTODA        READE     FCRREQL5                               24
117900200529     C                   END
118000200529     C*
118100200529     C     *IN42         IFEQ      '1'
118200200529     C     KYTODB        KLIST
118300200529     C                   KFLD                    AETY              3
118400200529     C                   MOVEL     BRANCH        AETY
118500200529     C     KYTODB        READE     FCRREQL6                               24
118600200529     C                   END
118700200529     C*
118800200529     C     *IN43         IFEQ      '1'
118900200529     C     KYTODC        KLIST
119000200529     C                   KFLD                    AETY
119100200529     C                   KFLD                    AUSR
119200200529     C                   MOVEL     BRANCH        AETY
119300200529     C                   MOVEL     USER          AUSR
119400200529     C     KYTODC        READE     FCRREQL7                               24
119500200529     C                   END
119600200529     C*
119700200529     C     *IN44         IFEQ      '1'
119800200529     C     KYTODD        KLIST
119900200529     C                   KFLD                    ANAM             10
120000200529     C                   MOVEL     SRPTS         ANAM
120100200529     C                   READ      FCRREQL1                               24
120200200529     C                   END
120300200529     C*
120400200529     C     *IN45         IFEQ      '1'
120500200529     C     KYESTA        KLIST
120600200529     C                   KFLD                    AUSR
120700200529     C                   MOVEL     USER          AUSR
120800200529     C     KYESTA        READE     FCYREQL5                               24
120900200529     C                   END
121000200529     C*
121100200529     C     *IN46         IFEQ      '1'
121200200529     C     KYESTB        KLIST
121300200529     C                   KFLD                    AETY
121400200529     C                   MOVEL     BRANCH        AETY
121500200529     C     KYESTB        READE     FCYREQL6                               24
121600200529     C                   END
121700200529     C*
121800200529     C     *IN47         IFEQ      '1'
121900200529     C     KYESTC        KLIST
122000200529     C                   KFLD                    AETY
122100200529     C                   KFLD                    AUSR
122200200529     C                   MOVEL     BRANCH        AETY
122300200529     C                   MOVEL     USER          AUSR
122400200529     C     KYESTC        READE     FCYREQL7                               24
122500200529     C                   END
122600200529     C*
122700200529     C     *IN48         IFEQ      '1'
122800200529     C     KYESTD        KLIST
122900200529     C                   KFLD                    ANAM
123000200529     C                   MOVEL     SRPTS         ANAM
123100200529     C                   READ      FCYREQL1                               24
123200200529     C                   END
123300200529     C                   ENDSR
123400200529      *******************************************************************
123500200529      /EJECT
123600200529      *******************************************************************
123700200529     C*
123800200529     C* VALSFL - VALIDATE SUBFILE
123900200529     C* CALLED FROM BMAIN
124000200529     C*
124100200529      *******************************************************************
124200200529     C     VALSFL        BEGSR
124300200529     C*
124400200529     C** RESET ERROR INDICATORS AND CLEAR MESSAGE SUBFILE
124500200529     C*
124600200529     C                   Z-ADD     1             RRN
124700200529     C                   Z-ADD     1             ERRRRN
124800200529     C                   SETOFF                                       81
124900200529     C*
125000200529     C** READ FIRST CHANGED SUBFILE RECORD
125100200529     C*
125200200529     C                   READC     FC0060S1                               25
125300200529     C*
125400200529     C** DO WHILE CHANGED SUBFILE RECORDS EXIST
125500200529     C*
125600200529     C     *IN25         DOWEQ     '0'
125700200529     C*
125800200529     C** SET OFF ERROR INDICATOR
125900200529     C*
126000200529     C                   SETOFF                                       33
126100200529     C*
126200200529     C** IF SELECTION IS NOT BLANK
126300200529     C*
126400200529     C     SELECT        IFNE      *BLANKS
126500200529     C*
126600200529     C** IF USER NOT AUTHORISED TO CHANGE OUTPUT THEN SELECTION MUST BE
126700200529     C***'R'****                                                          BHF789
126800200529     C** 'R' REVIEW REPORTING OR D DELETE REPORT REQUEST                  BHF789
126900200529     C*
127000200529     C     *IN53         IFEQ      '0'
127100200529     C     SELECT        ANDNE     'R'
127200200529     C     SELECT        ANDNE     'D'                                                         BHF78
127300200529     C                   CALL      'FCC0240'
127400200529     C***********          PARM 'RCF0017' MSGID   7                       LN1186
127500200529     C**********           PARM 'RCF1017' MSGID                     LN1186LN1153
127600200529     C                   PARM      'RCF1078'     MSGID                                         LN115
127700200529      *
127800200529      ** SAVE ERROR LINE NUMBER
127900200529      *
128000200529     C     *IN81         IFEQ      '0'
128100200529     C     *LIKE         DEFINE    RRN           ERRRRN
128200200529     C                   Z-ADD     RRN           ERRRRN
128300200529     C                   END
128400200529     C                   SETON                                        8133
128500200529     C                   END
128600200529      *
128700200529     C** IF USER IS AUTHORISED TO CHANGE OUTPUT THEN CHECK SELECTION
128800200529     C** IS 'A', 'D' OR 'R'
128900200529      *
129000200529     C     *IN53         IFEQ      '1'
129100200529     C     SELECT        ANDNE     'A'
129200200529     C     SELECT        ANDNE     'D'
129300200529     C     SELECT        ANDNE     'R'
129400200529     C                   CALL      'FCC0240'
129500200529     C***********          PARM 'RCF0018' MSGID   7                       LN1186
129600200529     C**********           PARM 'RCF1018' MSGID                     LN1186LN1153
129700200529     C                   PARM      'RCF1078'     MSGID                                         LN115
129800200529      *
129900200529     C     *IN81         IFEQ      '0'
130000200529     C                   Z-ADD     RRN           ERRRRN
130100200529     C                   END
130200200529      *
130300200529     C                   SETON                                        8133
130400200529     C                   END
130500200529      *
130600200529     C** IF REPORT IS FOR PRODUCTION IN INPUT CYCLE THEN SELECTION
130700200529     C** CANNOT BE 'A' OR 'D'
130800200529      *
130900200529     C     SFREQ         IFEQ      '  Immed'
131000200529     C     SELECT        ANDEQ     'A'
131100200529     C     SFREQ         OREQ      '  Immed'
131200200529     C     SELECT        ANDEQ     'D'
131300200529      *
131400200529      ** CANNOT AMEND/DELETE YESTERDAY'S
131500200529      *
131600200529     C     *IN51         OREQ      '0'
131700200529     C     SELECT        ANDEQ     'A'
131800200529     C     *IN51         OREQ      '0'
131900200529     C     SELECT        ANDEQ     'D'
132000200529     C                   CALL      'FCC0240'
132100200529     C***********          PARM 'RCF0019' MSGID   7                       LN1186
132200200529     C**********           PARM 'RCF1019' MSGID                     LN1186LN1153
132300200529     C                   PARM      'RCF1078'     MSGID                                         LN115
132400200529      *
132500200529     C     *IN81         IFEQ      '0'
132600200529     C                   Z-ADD     RRN           ERRRRN
132700200529     C                   END
132800200529      *
132900200529     C                   SETON                                        8133
133000200529     C                   END
133100200529      *
133200200529     C** IF REPORT IS NOT READY TO PRINT THEN 'R' CANNOT BE SELECTED
133300200529      *
133400200529     C     SRDY          IFEQ      'N'
133500200529     C     SELECT        ANDEQ     'R'
133600200529     C                   CALL      'FCC0240'
133700200529     C***********          PARM 'RCF0020' MSGID   7                       LN1186
133800200529     C                   PARM      'RCF1020'     MSGID                                         LN118
133900200529      *
134000200529     C     *IN81         IFEQ      '0'
134100200529     C                   Z-ADD     RRN           ERRRRN
134200200529     C                   END
134300200529      *
134400200529     C                   SETON                                        8133
134500200529     C                   END
134600200529      *
134700200529     C                   END
134800200529     C*
134900200529     C** IF SUBFILE SELECT FIELD IS BLANKED OUT PREVENT READ ON NEXT CYCLE
135000200529     C*
135100200529     C     SELECT        IFEQ      *BLANK
135200200529     C                   SETOFF                                       22
135300200529     C                   ELSE
135400200529     C                   SETON                                        22
135500200529     C                   END
135600200529     C*
135700200529     C** UPDATE SUBFILE RECORD
135800200529     C*
135900200529     C                   UPDATE    FC0060S1
136000200529     C*
136100200529     C** READ NEXT CHANGED RECORD
136200200529     C*
136300200529     C                   READC     FC0060S1                               25
136400200529     C                   END
136500200529     C*
136600200529      ** POSITION SUBFILE AT FIRST ERROR
136700200529     C*
136800200529     C***81******          Z-ADDERRRRN    RRN                             LN0366
136900200529     C   81              Z-ADD     ERRRRN        SDREC                                         LN036
137000200529     C*
137100200529     C                   ENDSR
137200200529      *******************************************************************
137300200529      /EJECT
137400200529      *******************************************************************
137500200529     C*
137600200529     C* PROSFL - PROCESS SUBFILE REQUEST
137700200529     C* CALLED FROM BMAIN
137800200529     C* CALLS CTERM, DELREQ
137900200529     C*
138000200529      *******************************************************************
138100200529     C*
138200200529     C     PROSFL        BEGSR
138300200529     C*
138400200529     C** SET TO START OF SUBFILE
138500200529     C*
138600200529     C                   SETOFF                                           22
138700200529     C                   Z-ADD     1             RRN
138800200529     C*
138900200529     C** READ FIRST CHANGED RECORD
139000200529     C*
139100200529     C                   READC     FC0060S1                               25
139200200529     C*
139300200529     C     *IN25         DOWEQ     '0'
139400200529     C*
139500200529     C** IF SELECTION = 'A' THEN READ FCRCOML1
139600200529     C*
139700200529     C     SELECT        IFEQ      'A'
139800200529     C     KCOM1         KLIST
139900200529     C                   KFLD                    SRNAM
140000200529     C                   KFLD                    SCOTT
140100200529     C                   KFLD                    SCSEQ
140200200529      *
140300200529     C     KCOM1         CHAIN     FCRCOML1                           27
140400200529      *
140500200529      ** DATABASE ERROR IF NOT FOUND
140600200529      *
140700200529     C     *IN27         IFEQ      '1'
140800200529     C     *LOCK         IN        LDA
140900200529     C                   MOVEL     'FC0060'      DBPGM
141000200529     C                   MOVEL     'FCRCOML1'    DBFILE
141100200529     C                   MOVEL     RCOMDS        DBKEY                          *************
141200200529     C                   Z-ADD     5             DBASE                          * DBERR 005 *
141300200529     C                   SETON                                        U7U8      *************
141400200529     C                   OUT       LDA
141500200529     C                   EXSR      *PSSR
141600200529     C                   END
141700200529      *                                                                   101040
141800200529      ** Get branch type from FCRCOML1                                    101040
141900200529      *                                                                   101040
142000200529     C                   MOVE      D3BRTP        SBRTP                                         10104
142100200529      *
142200200529     C** IF RECORD FOUND AND PROMPT PROGRAM IS NOT BLANK
142300200529     C** THEN CALL PROG FCC0203
142400200529      *
142500200529     C     D3PRPG        IFNE      *BLANKS
142600200529     C                   CALL      'FCC0203'
142700200529     C                   PARM                    SCOTT
142800200529     C                   PARM                    SCSEQ
142900200529     C                   PARM                    SRNAM
143000200529     C                   PARM                    SSEQ
143100200529     C                   PARM                    D3PRPG
143200200529     C                   PARM                    SBRTP
143300200529     C                   PARM      'A'           PACTN             1
143400200529     C*
143500200529     C                   ELSE
143600200529     C* IF PROMPT PROGRAM IS BLANK
143700200529     C* CALL PROGRAM FCC0204
143800200529     C                   CALL      'FCC0204'
143900200529     C                   PARM                    SCOTT
144000200529     C                   PARM                    SCSEQ
144100200529     C                   PARM                    SRNAM
144200200529     C                   PARM                    SSEQ
144300200529     C                   PARM                    SBRTP
144400200529     C                   PARM      'A'           PACTN             1
144500200529     C                   END
144600200529      *
144700200529     C** IF FCC0203 OR FCC0204 RETURN ACTION AS 'T' THEN TERMINATE THE
144800200529     C** PROGRAM
144900200529      *
145000200529     C     PACTN         IFEQ      'T'
145100200529     C                   EXSR      CTERM
145200200529     C                   END
145300200529      *
145400200529     C                   END
145500200529      *
145600200529     C** IF SELECTION = R FOR REPORTS, SET PROGRAM MODE FOR FC0065
145700200529     C*
145800200529     C     SELECT        IFEQ      'R'
145900200529     C     *IN51         IFEQ      '1'
146000200529     C                   MOVEL     'T'           MODE              1
146100200529     C                   ELSE
146200200529     C                   MOVEL     'Y'           MODE
146300200529     C                   END
146400200529      *                                                                                       248899
146500200529     C     MODE          IFEQ      'T'                                                        248899
146600200529     C     SSEQ          CHAIN     FCRREQL0                           82                      248899
146700200529     C     *IN82         IFEQ      '1'                                                        248899
146800200529     C     *LOCK         IN        LDA                                                        248899
146900200529     C                   MOVEL     'FC0060'      DBPGM                                        248899
147000200529     C                   MOVEL     'FCRREQL0'    DBFILE                                       248899
147100200529     C                   MOVEL     SRNAM         DBKEY                          ************* 248899
147200200529     C                   Z-ADD     87            DBASE                          * DBERR 087 * 248899
147300200529     C                   SETON                                        U7U8      ************* 248899
147400200529     C                   OUT       LDA                                                        248899
147500200529     C                   EXSR      *PSSR                                                      248899
147600200529     C                   END                                                                  248899
147700200529     C                   MOVE      D5JBNM        ABJBNM                                       248899
147800200529     C                   MOVE      D5JUSR        ABJUSR                                       248899
147900200529     C                   MOVE      D5JBNB        ABJBNB                                       248899
148000200529     C                   ELSE                                                                 248899
148100200529     C                   MOVEL     SRNAM         KRNAM                                        248899
148200200529     C                   MOVEL     SSEQ          KRQSQ                                        248899
148300200529     C     KYEST1        CHAIN     FCYREQL1                           82                      248899
148400200529     C     *IN82         IFEQ      '1'                                                        248899
148500200529     C     *LOCK         IN        LDA                                                        248899
148600200529     C                   MOVEL     'FC0060'      DBPGM                                        248899
148700200529     C                   MOVEL     'FCYREQL1'    DBFILE                                       248899
148800200529     C                   MOVEL     SRNAM         DBKEY                          ************* 248899
148900200529     C                   Z-ADD     88            DBASE                          * DBERR 088 * 248899
149000200529     C                   SETON                                        U7U8      ************* 248899
149100200529     C                   OUT       LDA                                                        248899
149200200529     C                   EXSR      *PSSR                                                      248899
149300200529     C                   END                                                                  248899
149400200529     C                   MOVE      EKJBNM        ABJBNM                                       248899
149500200529     C                   MOVE      EKJUSR        ABJUSR                                       248899
149600200529     C                   MOVE      EKJBNB        ABJBNB                                       248899
149700200529     C                   END                                                                  248899
149800200529      *                                                                                       248899
149900200529     C                   CALL      'FCC2001A'                                                 248899
150000200529     C                   PARM                    ABJBNM           10                          248899
150100200529     C                   PARM                    ABJUSR           10                          248899
150200200529     C                   PARM                    ABJBNB            6                          248899
150300200529     C**********                                                                              248899
150400200529     C***CALL*PROGRAM FC0065                                                                  248899
150500200529     C**********                                                                              248899
150600200529     C**********         CALL      'FC0065'                                                   248899
150700200529     C**********         PARM                    USER                                         248899
150800200529     C**********         PARM                    BRANCH                                       248899
150900200529     C**********         PARM                    SRNAM                                        248899
151000200529     C**********         PARM                    SDESC                                        248899
151100200529     C**********         PARM                    SSEQ                                         248899
151200200529     C**********         PARM                    MODE                                         248899
151300200529     C**********         PARM                    TERM              1                          248899
151400200529     C*
151500200529     C** IF FC0065 RETURNS TERM AS 'T' THEN TERMINATE PROGRAM
151600200529     C*
151700200529     C*****TERM*         IFEQ      'T'                                                        248899
151800200529     C     *INKL         IFEQ      '1'                                                        248899
151900200529     C     *INKC         OREQ      '1'                                                        248899
152000200529     C                   EXSR      CTERM
152100200529     C                   END
152200200529     C*
152300200529     C                   END
152400200529     C*
152500200529     C** IF SELECTION - 'D', PROCESS DELETION
152600200529     C*
152700200529     C     SELECT        IFEQ      'D'
152800200529     C                   EXSR      DELREQ
152900200529     C                   END
153000200529     C*
153100200529     C** RESET ERROR MESSAGES ETC.
153200200529     C*
153300200529     C                   MOVE      *BLANK        SELECT
153400200529     C                   UPDATE    FC0060S1
153500200529     C*
153600200529     C** READ NEXT CHANGED RECORD
153700200529     C*
153800200529     C                   READC     FC0060S1                               25
153900200529     C                   END
154000200529     C*
154100200529     C                   ENDSR
154200200529      *******************************************************************
154300200529      /EJECT
154400200529      *******************************************************************
154500200529     C*
154600200529     C* DELREQ -  DELETE REPORT REQUEST
154700200529     C* CALLED FROM PROSFL
154800200529     C* CALLS CTERM
154900200529     C*
155000200529      *******************************************************************
155100200529     C*
155200200529     C     DELREQ        BEGSR
155300200529     C*
155400200529     C                   CALL      'ZA0250'
155500200529     C*
155600200529     C** DISPLAY CONFIRMATION SCREEN
155700200529     C*
155800200529     C                   WRITE     FC0060C0
155900200529     C                   EXFMT     FC0060F3
156000200529     C*
156100200529     C                   CALL      'ZA0250'
156200200529     C*
156300200529     C** DO UNTIL VALID COMMAND KEY TAKEN
156400200529     C*
156500200529     C********** *IN03     DOWEQ'0'                                       LN1153
156600200529     C********** *IN12     ANDEQ'0'                                       LN1153
156700200529     C********** *IN10     ANDEQ'0'                                       LN1153
156800200529     C***********                                                         LN1153
156900200529     C***IF*ENTER PRESSED, TELL USER TO TAKE F10                          LN1153
157000200529     C**********                                                          LN1153
157100200529     C**********           CALL 'FCC0240'                                 LN1153
157200200529     C***********          PARM 'RCF0021' MSGID   7                       LN1186
157300200529     C**********           PARM 'RCF1021' MSGID                     LN1186LN1153
157400200529     C**********           WRITEFC0060C0                                  LN1153
157500200529     C**********           EXFMTFC0060F3                                  LN1153
157600200529     C**********                                                          LN1153
157700200529     C***CLEAR*MESSAGES                                                   LN1153
157800200529     C**********                                                          LN1153
157900200529     C**********           CALL 'ZA0250'                                  LN1153
158000200529     C**********           END                                            LN1153
158100200529     C*
158200200529     C** IF EXIT REQUESTED, TERMINATE PROGRAM
158300200529     C*
158400200529     C     *IN03         IFEQ      '1'
158500200529     C                   EXSR      CTERM
158600200529     C                   END
158700200529     C*
158800200529     C** IF DELETE REQUESTED, DELETE ALL RECORDS FOR THIS REQUEST
158900200529     C*
159000200529     C     *IN10         IFEQ      '1'
159100200529     C     KEYREQ        KLIST
159200200529     C                   KFLD                    SRNAM
159300200529     C                   KFLD                    SSEQ
159400200529     C*
159500200529     C     SSEQ          CHAIN     FCRREQL0                           82
159600200529     C     *IN82         IFEQ      '0'
159700200529     C                   DELETE    @D5REI8
159800200529     C                   END
159900200529     C*
160000200529     C     KEYREQ        CHAIN     FCPARDL0                           84
160100200529     C     *IN84         IFEQ      '0'
160200200529     C                   DELETE    @D7REJE
160300200529     C                   END
160400200529     C/COPY WNCPYSRC,FC0060C002
160500200529      *
160600200529     C     KEYREQ        SETLL     MAARCDL2
160700200529     C     KEYREQ        READE     MAARCDL2                               83
160800200529      *
160900200529     C     *IN83         DOWEQ     '0'
161000200529     C                   DELETE    @ARCDAO
161100200529     C     KEYREQ        READE     MAARCDL2                               83
161200200529     C                   END
161300200529      *
161400200529     C                   COMMIT
161500200529     C                   END
161600200529      *
161700200529     C                   SETOFF                                       12
161800200529      *
161900200529     C                   ENDSR
162000200529      *****************************************************************
162100200529      /EJECT
162200200529      *****************************************************************
162300200529     C*
162400200529     C* CF14 - DISPLAY USERS OUTPUT QUEUE
162500200529     C* CALLED FROM BMAIN
162600200529     C*
162700200529      *****************************************************************
162800200529     C*
162900200529     C     CF14          BEGSR
163000200529     C*
163100200529     C** DISPLAY OUTPUT QUEUE
163200200529     C*
163300200529     C                   MOVEL     CMD(1)        CMDDS
163400200529     C                   MOVEL     XOUTQ         QUEUE
163500200529     C                   CALL      'QCMDEXC'
163600200529     C                   PARM      CMDDS         CMDSTR           50
163700200529     C                   PARM      50            CMDLEN           15 5
163800200529     C*
163900200529     C                   ENDSR
164000200529      *****************************************************************
164100200529      /EJECT
164200200529      *****************************************************************
164300200529     C*
164400200529     C* CF11 - SUBMIT REPORT TO PRINT
164500200529     C* CALLED FROM BMAIN
164600200529     C*
164700200529      *****************************************************************
164800200529     C*
164900200529     C     CF11          BEGSR
165000200529     C*
165100200529     C** SET LEVEL/ENTITY DEPENDING ON INITIAL SCREEN ENTRY
165200200529     C*
165300200529     C     BRANCH        IFNE      *BLANK
165400200529     C                   MOVE      BRANCH        ENTITY            3
165500200529     C                   MOVE      'B'           LEVEL             1
165600200529     C                   ELSE
165700200529     C*********************MOVE 'S'       LEVEL                           090344
165800200529     C*********************MOVE *BLANK    ENTITY                          090344
165900200529     C                   MOVE      'B'           LEVEL                                         09034
166000200529     C                   MOVE      'ALL'         ENTITY                                        09034
166100200529     C                   END
166200200529     C*
166300200529     C                   CALL      'FC0040X'
166400200529     C                   PARM                    P6RTN             7
166500200529     C**********           PARM 'FC0060P' P1RNAM 10                       LN0344
166600200529     C                   PARM      'FC0600'      P1RNAM           10                           LN034
166700200529     C                   PARM      'FCC0301'     P2COTT           10
166800200529     C                   PARM      '00001'       P3CSEQ            5
166900200529     C                   PARM      *BLANKS       P4CLPM          100
167000200529     C                   PARM      @MBIN         P5MBIN            1
167100200529     C                   PARM                    LEVEL
167200200529     C                   PARM                    ENTITY
167300200529     C*
167400200529     C** TERMINATE PROGRAM IF RETURN CODE NON-BLANK
167500200529     C*
167600200529     C     P6RTN         IFNE      *BLANKS
167700200529     C                   EXSR      CTERM
167800200529     C**********           END                                            LN1153
167900200529     C                   ELSE                                                                  LN115
168000200529      *                                                                   LN1153
168100200529      ** Otherwise send message 'Report submitted'                        LN1153
168200200529      *                                                                   LN1153
168300200529     C                   CALL      'FCC0240'                                                   LN115
168400200529     C                   PARM      'RCF0020'     MSGID             7                           LN115
168500200529     C                   END                                                                   LN115
168600200529     C*
168700200529     C                   ENDSR
168800200529      *****************************************************************
168900200529      /EJECT
169000200529      *****************************************************************
169100200529     C*
169200200529     C* *PSSR - DATABASE ERROR HANDLING ROUTINE
169300200529     C* CALLED WHEN DATABASE ERROR OCCURS, OR AUTOMATICALLY BY SYSTEM
169400200529     C*
169500200529      *****************************************************************
169600200529     C     *PSSR         BEGSR
169700200529     C     @RUN          IFEQ      *BLANK
169800200529     C                   MOVE      'Y'           @RUN              1
169900200529     C                   DUMP
170000200529     C                   END
170100200529     C                   EXSR      CTERM
170200200529     C                   ENDSR
170300200529      *****************************************************************
170400200529      /EJECT
170500200529      *****************************************************************
170600200529     C*
170700200529     C* CTERM - PROGRAM TERMINATION
170800200529     C* CALLED FROM MAIN, DELREQ, PROSFL
170900200529     C*
171000200529      *****************************************************************
171100200529     C     CTERM         BEGSR
171200200529     C                   SETON                                        LR
171300200529     C                   RETURN
171400200529     C                   ENDSR
171500200529      *****************************************************************
171600200529** CPY@
171700200529(c) Finastra International Limited 2001
171800200529**  CMD - ARRAY FOR QCMDEXC
171900200529WRKOUTQ OUTQ(          )
172000200529**  FREQUENCIES
1721002005291Each Mon
1722002005292Each Tue
1723002005293Each Wed
1724002005294Each Thu
1725002005295Each Fri
1726002005296Each Sat
1727002005297Each Sun
172800200529DDaily
172900200529MMonthly
173000200529AOn Accrl
173100200529BLast/Mth
173200200529QQ'trly
173300200529YYearly
