     H DEBUG
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Request single report by branch')             *
     F*****************************************************************
     F*                                                               *
     F*  Midas - Report Control Facility Module
     F*                                                               *
     F*      FC0200 - REQUEST A SINGLE REPORT BRANCH PROMPT.          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD023136           Date 06Nov13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27056           Date 10Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 141196             Date 16Feb99               *
     F*                 CFT002             Date 16Feb99               *
     F*                     083547           DATE 20FEB95             *
     F*                     079538           DATE 30NOV94             *
     F*                     PM0041           DATE 09SEP94             *
     F*                     S01486           DATE 01JUN94             *
     F*                     S01407           DATE 26JAN93             *
     F*                     E38898           DATE 28APR92             *
     F*                     S01117           DATE 25MAR92             *
     F*                     E36373           DATE 27FEB92             *
     F*                     S01269           DATE 25JUN91             *
     F*                     LN1238           DATE 30APR91             *
     F*                     LN1160           DATE 09APR91             *
     F*                     LN1186           DATE 06MAR91             *
     F*                     LN0981           DATE 16NOV90             *
     F*                     LN0856           DATE 15OCT90             *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  MD023136 - Dealing DLC0727 generates dump                    *
      *  BUG27056 - BSPL prompt error                                 *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits                  *
     F*  CFT002 - STP phase 1                                         *
     F*  141196 - When running Facility history report default of     *
     F*           Entity should be 'ALL'.                             *
     F*  083547 - Correcting Account Officer name on MUSERDD          *
     F*  079538 - Access to AOPORTR0 should only be done when PM      *
     F*           module is switched on.                              *
     F*      PM0041 - Branch should not be displayed when             *
     F*               multibranching is off                           *
     F*      S01486 - Private Banking Upgrade to Rel 10.              *
     F*               Add Account Officer and Department Level (RCF). *
     F*      S01407 - SWITCHABILITY ENHANCEMENTS                      *
     F*      E38898 - IF PROMPT, F12 SHOULD GO BACK TO MENU ITEM      *
     F*      S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD              *
     F*      E36373 - Value selected from select screen is not        *
     F*               reflected on display. Pass DBRN/D6XETY to the   *
     F*               PARM of the calling program ZVOBU/ZVBBU or      *
     F*               ZVCOU respectively for branch or company.       *
     F*      S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO     *
     F*               MUSERDD                                         *
     F*      LN1238 - OUTPUT DIFFERENT ERROR MESSAGES IF USER NOT     *
     F*               AUTHORISED TO BRANCH/COMPANY TO THAT GIVEN      *
     F*               IF BRANCH/COMPANY IS INVALID.                   *
     F*      LN1160 - DON'T CONDITION ACCESS OF FCRREQL1 ON NON       *
     F*               DISPLAY OF BRANCH,COMPANY & SYSTEM.             *
     F*      LN1186 - SEND NEW MESSAGE ID FROM FCUSRMSG TO FCC0240    *
     F*      LN0981 - ALLOW REPORTS TO BE SYSTEM, BRANCH AND          *
     F*               COMPANY                                         *
     F*      LN0856 - (1) CORRECT PROCESSING FOR AUTHORITY            *
     F*                   CHECKS FOR SYSTEM LEVEL REPORT              *
     F*               (2) CORRECT DEFAULTING FOR COMPANY CODE         *
     F*                                                               *
     F*****************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*                                                               *
     F*****************************************************************
      /EJECT
     F*****************************************************************
     F* OPERATION                                                     *
     F* ~~~~~~~~~                                                     *
     F*                                                               *
     F* WHEN A REQUEST FOR A REPORT IS MADE THIS PROGRAM PROVIDES     *
     F* PROMPTS BASED ON BRANCH ACCESS AUTHORITY.  IF THE USER HAS    *
     F* AUTHORITY TO ACCESS MORE THEN ONE BRANCH, THEN THE LEVEL AT   *
     F* WHICH THE REPORT IS REQUIRED AND IF APPROPRIATE WHICH         *
     F* BRANCH/CO., ARE PROMPTED.                                     *
     F*                                                               *
     F*                                                               *
     F*      INDICATORS:                                              *
     F*                    03   IF F3 HAS BEEN TAKEN.                 *
     F*                    12   IF F12 HAS BEEN TAKEN.                *
     F*********************20***RECORD*NOT*FOUND*ON*LF/FCREPTL1.      *   S01407
     F*                    20   RECORD NOT FOUND ON LF/FCREPTJ0.      *   S01407
     F*                    21   RECORD NOT FOUND ON LF/MUSER.         *
     F*                    22   RECORD NOT FOUND ON LF/FCRREQL1.      *
     F*                    31   SCREEN FIELD BRANCH INVALID.          *
     F*                    32   SCREEN FIELD COMPANY INVALID.         *
     F*                    33   SCREEN FIELD SYSTEM INVALID.          *
     F*                    34   SCREEN FIELD ENTITY INVALID.          *
     F*                    35   SCREEN FIELD DISTRIBUTION INVALID.    *
     F*                    36   Screen field Account Officer invalid. *   S01486
     F*                    37   Screen field Department invalid.      *   S01486
     F*                    40   NON-DISPLAY BRANCH.                   *
     F*                    41   NON-DISPLAY COMPANY.                  *
     F*                    42   NON-DISPLAY SYSTEM.                   *
     F*                    43   NON-DISPLAY ENTITY.                   *
     F*                    44   DISPLAY F12.                          *
     F*                    45   NON-DISPLAY DISTRIBUITON              *   LN0856
     F*                    46   Non-Display Account Officer.          *   S01486
     F*                    47   Non-Display Department.               *   S01486
     F*                    50   INVALID SCREEN.                       *
     F*                    51   SCAN FOR '?'                          *   CFT002
     F*                    60   MESSAGE SUBFILE END.                  *
     F*                 U7/U8   DATABASE ERROR.                       *
     F*                                                               *
     F*****************************************************************
     F* SUMMARY  OF  SUBROUTINES                                      *
     F* ~~~~~~~~~~~~~~~~~~~~~~~~                                      *
     F*                                                               *
     F*     SCREEN  -  Screen Processing.                             *
     F*     VALID   -  Validate Screen Data.                          *
     F*     *PSSR   -  Database Error Handling, Terminates Program.   *
     F*****************************************************************
      /EJECT
     F*
     FFC0200DF  CF   E             WORKSTN
     F***********FCREPTL1IF  E           K        DISK                    S01407
     F*FCREPTJ0* IF   E           K DISK                                         S01407     MD055265
     FMUSER     IF   E           K DISK
     FFCRREQL1  IF   E           K DISK
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Used to store screen input for each level                        S01486
      *                                                                   S01486
     D                 DS                                                       S01486
     D  SINP                   1      5                                         S01486
     D                                     DIM(5)                                                S01
     D  SBRCH                  1      1                                         S01486
     D  SCOMP                  2      2                                         S01486
     D  SSYST                  3      3                                         S01486
     D  SACOF                  4      4                                         S01486
     D  SDEPT                  5      5                                         S01486
      *                                                                   S01486
      ** Used to store Screen Entity value for Account Officer            S01486
      *                                                                   S01486
     D                 DS                                                       S01486
     D  SETTY                  1      3                                         S01486
     D  @POS1                  1      1                                         S01486
     D RUNDAT          DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      *  DATA AREA OF BANK DETAILS.
      *
     D PSDS           SDS
     D  WSID                 244    253
     D  JUSR                 254    263
      *  PROGRAM STATUS DATA STRUCTURE.
      *
     D LDA            UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *  DATA STRUCTURE FOR DATABASE ERROR.
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *  200 BYTE ACCESS PROGRAM DATA STRUCTURE.
      *
     D*                                                                   LN1238
     D D@COMP        E DS                  EXTNAME(SDCOMPPD)                    LN1238
      *  LF/SDCOMPL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE.         LN1238
     D*                                                                   LN1238
     D P@BRCH        E DS                  EXTNAME(SDBRCHPD)
      *  LF/SDBRCHL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE.
      *
     D @MMOD         E DS                  EXTNAME(SDMMODPD)                    079538
     D** Dummy record format for access to Modules File                   079538
     D*                                                                   079538
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                    S01486
      *  LF/SDPORTL1 access program record format data structure.         S01486
     D*                                                                   S01486
     D SDACOF        E DS                  EXTNAME(SDACOFPD)                    S01486
      ** Access Object for Account Officer File.                          S01486
      *                                                                   S01486
     D SDDEPT        E DS                  EXTNAME(SDDEPTPD)                    S01486
      ** Access Object for Department Code File                           S01486
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                       CGL029
     D FCREPT        E DS                  EXTNAME(FCREPJW1)                                MD055265
     D NullInds        s              5i 0 dim(19)                                          MD055265
     C                   MOVEA     CPY@          BIS@             80
      /EJECT
     C     *ENTRY        PLIST
     C*
     C*  RECIEVE PARAMETERS FROM CALLING PROGRAM FCC0201/2/3/4.
     C*
     C                   PARM                    LEVEL             1            LEVEL
     C                   PARM                    ENITY             3            ENTITY
     C                   PARM                    DISTR             1            DISTRIBUTION
     C                   PARM                    COMND             1            COMMAND
     C                   PARM                    PGRPG            10            REPORT
     C                   PARM                    RPTSE             5            RPT SEQ NO.
     C                   PARM                    TBRCH             1            BRANCH TYPE
     C                   PARM                    ATION             1            ACTION
     C**
     C*  KEY LIST FOR ACCESSING LF/FCRREQL1.
     C*
     C     KEY1          KLIST
     C                   KFLD                    PGRPG            10
     C                   KFLD                    RPTSE             5
     C**
     C*  SET UP PROGRAM NAME IN LDA
     C*
     C                   MOVEL     'FC0200'      DBPGM
     C**
     C*  CLEAR MESSAGES.
     C*
     C                   MOVEL     '*'           SPGMQ
     C                   CALL      'ZA0250'
     C                   SETON                                        60
     C**
     C*  ACCESS DATA AREA RUNDAT.
     C*
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C**
     C***IF*MULTI-BRANCHING*NOT*IN*THE*SYSTEM*(POS*13*=*N)*THEN****       S01486
     C***SET*PARAMETERS*AND*END*THE*PROGRAM.***********************       S01486
     C*
     C***********MBIN      IFEQ 'N'                                       S01486
     C***********          MOVE 'S'       LEVEL                           S01486
     C***********          MOVE 'N'       DISTR                           S01486
     C***********          GOTO END                                       S01486
     C**
     C*  IF MULTI-BRANCHING IS IN THE SYSTEM (POS 13 = Y) THEN
     C***ACCESS*LF/FCREPTL1.                                              S01407
     C*  ACCESS LF/FCREPTJ0.                                              S01407
     C*
     C***********          ELSE                                           S01486
     C***********PGRPG     CHAINFCREPTL1             20                   S01407
     C*****PGRPG         CHAIN     FCREPTJ0                           20              S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT :NullInds                                                              MD055265
     C+ from FCREPJW1                                                                       MD055265
     C+ where DXRNAM = :PGRPG                                                               MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       20                    MD055265
     C                   If        SQLCODE = 100                                            MD055265
     C                   SETON                                        20                    MD055265
     C                   ENDIF                                                              MD055265
                                                                                            MD055265
     C**
     C*  IF NO RECORD WAS FOUND, DATABASE ERROR
     C**
     C     *IN20         IFEQ      '1'
     C                   MOVE      'T'           ATION
     C***********          MOVEL'FCREPTL1'DBFILE           *************  S01407
     C                   MOVEL     'FCREPTJ0'    DBFILE                         *************  S0140
     C                   MOVEL     PGRPG         DBKEY                          *           *
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   EXSR      *PSSR                                        *           *
     C                   END                                                    *************
      *                                                                   S01486
      ** Exit program if Multi-Branching not in the system and Account    S01486
      ** Officer and Department Levels are not available.                 S01486
      *                                                                   S01486
     C     MBIN          IFEQ      'N'                                                         S0148
     C     DXALVL        ANDNE     'Y'                                                         S0148
     C     DXDLVL        ANDNE     'Y'                                                         S0148
     C                   MOVE      'S'           LEVEL                                         S0148
     C                   GOTO      END                                                         S0148
     C                   END                                                                   S0148
     C**
     C*  ACCESS LF/MUSER                                                  LN0856
     C*                                                                   LN0856
     C     JUSR          CHAIN     MUSER                              21                       LN085
     C**                                                                  LN0856
     C*  IF NO RECORD WAS FOUND SET ACTION TO T AND PERFORM               LN0856
     C*  DATABASE ERROR PROCESSING                                        LN0856
     C*                                                                   LN0856
     C     *IN21         IFEQ      '1'                                                         LN085
     C                   MOVE      'T'           ATION                                         LN085
     C                   MOVEL     'MUSER'       DBFILE                         *************  LN085
     C                   MOVEL     JUSR          DBKEY                          *           *  LN085
     C                   Z-ADD     1             DBASE                          * DBERR 001 *  LN085
     C                   EXSR      *PSSR                                        *           *  LN085
     C                   END                                                    *************  LN085
     C*                                                                   LN0856
     C*  IF REPORT NOT AVAILABLE AT BRANCH-LEVEL NON DISPLAY BRANCH.
     C*
     C     DXBLVL        IFEQ      'N'
     C     MBIN          OREQ      'N'                                                         PM004
     C                   SETON                                        40
     C                   END
     C**
     C*  IF REPORT NOT AVAILABLE AT COMPANY-LEVEL NON DISPLAY COMPANY.
     C*
     C     DXCLVL        IFEQ      'N'
     C     MBIN          OREQ      'N'                                                         PM004
     C                   SETON                                        41
     C                   END
      *                                                                   S01486
      **  Account Officer level not available - do not display.           S01486
      *                                                                   S01486
     C     DXALVL        IFNE      'Y'                                                         S0148
     C                   SETON                                        46                       S0148
     C                   END                                                                   S0148
      * *                                                                 S01486
      ** Department level not available - do not display.                 S01486
      *                                                                   S01486
     C     DXDLVL        IFNE      'Y'                                                         S0148
     C                   SETON                                        47                       S0148
     C                   END                                                                   S0148
     C**
     C*  IF USER IS NOT AUTHORISED TO SYSTEM LEVEL, OR
     C*  REPORT NOT AVAILABLE AT SYSTEM-LEVEL NON DISPLAY SYSTEM.
     C*
     C     DXGLVL        IFEQ      'N'
     C     BANK          OREQ      'N'
     C                   SETON                                        42
     C                   END
     C*
     C*  IF THE USER IS AUTHORISED TO BANK LEVEL REPORTS AND              LN0856
     C*  IF BRANCH LEVEL AND COMPANY LEVEL
     C*  ARE BOTH NO SET PARAMETERS AND END THE PROGRAM.
     C*
     C     DXBLVL        IFEQ      'N'
     C     DXCLVL        ANDEQ     'N'
     C     DXALVL        ANDNE     'Y'                                                         S0148
     C     DXDLVL        ANDNE     'Y'                                                         S0148
     C     BANK          ANDEQ     'Y'                                                         LN085
     C     COMND         IFNE      'F'                                                         E3889
     C                   MOVE      'S'           LEVEL
     C                   MOVE      'N'           DISTR
     C                   ELSE                                                                  E3889
     C                   MOVE      'E'           COMND                                         E3889
     C                   END                                                                   E3889
     C                   GOTO      END
     C                   END
      *                                                                   S01486
      ** If Account Officer Level available set Level and Entity          S01486
      *                                                                   S01486
     C     DXALVL        IFEQ      'Y'                                                         S0148
     C     DXBLVL        ANDEQ     'N'                                                         S0148
     C     DXCLVL        ANDEQ     'N'                                                         S0148
     C     DXGLVL        ANDEQ     'N'                                                         S0148
     C     DXDLVL        ANDNE     'Y'                                                         S0148
      *                                                                   S01486
      ** Exit program if the Account Officer is specified on MUSER        S01486
     C***********ACOF      IFNE *BLANKS                             S01486083547
     C***********ACOF      ANDNE'ALL'                               S01486083547
     C     ACFA          IFNE      *BLANKS                                                     08354
     C     ACFA          ANDNE     'ALL'                                                       08354
     C                   MOVE      'A'           LEVEL                                         S0148
     C                   MOVE      *BLANKS       ENITY                                         S0148
     C***********          MOVELACOF      ENITY                     S01486083547
     C                   MOVEL     ACFA          ENITY                                         08354
     C                   GOTO      END                                                         S0148
     C                   END                                                                   S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      ** If Department Level available set Level and Entity               S01486
      *                                                                   S01486
     C     DXDLVL        IFEQ      'Y'                                                         S0148
     C     DXBLVL        ANDEQ     'N'                                                         S0148
     C     DXCLVL        ANDEQ     'N'                                                         S0148
     C     DXGLVL        ANDEQ     'N'                                                         S0148
     C     DXALVL        ANDNE     'Y'                                                         S0148
      *                                                                   S01486
      ** Exit program if the Account Officer is specified on MUSER        S01486
     C     DPPT          IFNE      *BLANKS                                                     S0148
     C     DPPT          ANDNE     'ALL'                                                       S0148
     C                   MOVE      'D'           LEVEL                                         S0148
     C                   MOVE      DPPT          ENITY                                         S0148
     C                   GOTO      END                                                         S0148
     C                   END                                                                   S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      ** Set Level 'S' when Account Officer, Department, Branch and       S01486
      ** Company Levels are not available.                                S01486
      *                                                                   S01486
     C     DXBLVL        IFEQ      'N'                                                         S0148
     C     DXCLVL        ANDEQ     'N'                                                         S0148
     C     DXALVL        ANDNE     'Y'                                                         S0148
     C     DXDLVL        ANDNE     'Y'                                                         S0148
     C                   MOVE      'S'           LEVEL                                         S0148
     C                   END                                                                   S0148
     C*
     C**  SET UP REPORT DESCRIPTION/NAME ON SCREEN
     C*
     C                   MOVE      DXRDSC        SRDSC
     C                   MOVE      PGRPG         SRNAM
     C**
     C***ACCESS*LF/MUSER                                                  LN0856
     C***********                                                         LN0856
     C***********JUSR      CHAINMUSER                21                   LN0856
     C***********                                                         LN0856
     C***IF*NO*RECORD WAS FOUND SET ACTION TO T AND PERFORM               LN0856
     C***DATABASE ERROR PROCESSING                                        LN0856
     C***********                                                         LN0856
     C************IN21     IFEQ '1'                                       LN0856
     C***********          MOVE 'T'       ATION                           LN0856
     C***********          MOVEL'MUSER'   DBFILE           *************  LN0856
     C***********          MOVELJUSR      DBKEY            *           *  LN0856
     C***********          Z-ADD1         DBASE            * DBERR 001 *  LN0856
     C***********          EXSR *PSSR                      *           *  LN0856
     C***********          END                             *************  LN0856
     C**
     C*  IF USER NOT AUTHORISED TO MULTIPLE BRANCH REPORTS AND
     C*  COMMAND IS NOT F AND ACTION IS I WITH BRANCH-LEVEL AS
     C*  YES SET PARAMETERS.
     C*
     C     MBREP         IFEQ      'N'
     C     COMND         ANDNE     'F'
     C     ATION         ANDEQ     'I'
     C     DXBLVL        ANDEQ     'Y'
     C                   MOVE      'B'           LEVEL
     C                   MOVE      DBRN          ENITY
     C                   MOVE      'N'           DISTR
     C                   GOTO      END
     C                   END
     C**
     C***IF*USER*NOT*AUTHORISED*TO*MULTIPLE*BRANCH*REPORTS*AND            LN0856
     C*  IF USER IS AUTHORISED TO MULTIPLE BRANCH REPORTS AND             LN0981
     C*  BANK LEVEL REPORTS AND REPORT IS AT BANK-LEVEL ONLY AND          LN0981
     C*  COMMAND IS NOT F AND ACTION IS I WITH BANK-LEVEL AS YES
     C*  SET PARAMETERS.
     C*
     C***********MBREP     IFEQ 'N'                                       LN0856
     C     MBREP         IFEQ      'Y'                                                         LN085
     C     BANK          ANDEQ     'Y'                                                         LN085
     C     COMND         ANDNE     'F'
     C     ATION         ANDEQ     'I'
     C     DXGLVL        ANDEQ     'Y'
     C     DXBLVL        ANDEQ     'N'                                                         LN098
     C     DXCLVL        ANDEQ     'N'                                                         LN098
     C     DXALVL        ANDNE     'Y'                                                         S0148
     C     DXDLVL        ANDNE     'Y'                                                         S0148
     C                   MOVE      'S'           LEVEL
     C                   MOVE      *BLANKS       ENITY
     C                   MOVE      'N'           DISTR
     C                   GOTO      END
     C                   END
     C**
     C*  IF USER NOT AUTHORISED TO MULTIPLE BRANCH REPORTS AND
     C*  COMMAND IS NOT F AND ACTION IS I WITH COMPANY-LEVEL AS
     C*  YES SET PARAMETERS.
     C*
     C     MBREP         IFEQ      'N'
     C     COMND         ANDNE     'F'
     C     ATION         ANDEQ     'I'
     C     DXCLVL        ANDEQ     'Y'
     C*                                                                   LN0856
     C** OBTAIN DEFAULT COMPANY CODE FOR DISPLAY ON SCREEN                LN0856
     C*                                                                   LN0856
     C**********           CALL 'AOBRCHR0'                                             LN0856 CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANK        P@APRC            7              B:Return codeLN085
     C                   PARM      '*KEY'        P@APOP            7              I:Option     LN085
     C                   PARM                    DBRN              3              I:User branchLN085
     C********** P@BRCH    PARM P@BRCH    DSFDY              O:Rec format LN0856              CGL029
     C     P@BRCH        PARM      P@BRCH        DSSDY
     C**                                                                  LN0856
     C*  IF PROGRAM ENDS IN ERROR DATABASE ERROR.                         LN0856
     C*                                                                   LN0856
     C     P@APRC        IFNE      *BLANK                                                      LN085
     C                   MOVEL     'SDBRCHL1'    DBFILE                         *************  LN085
     C                   MOVEL     DBRN          DBKEY                          *           *  LN085
     C                   Z-ADD     4             DBASE                          * DBERR 004 *  LN085
     C                   EXSR      *PSSR                                        *           *  LN085
     C                   END                                                    *************  LN085
     C**                                                                  LN0856
     C*  IF NO ERROR IN PROGRAM SET SCREEN FIELD ENTITY TO COMPANY        LN0856
     C*  OF USER'S DEFAULT BRANCH.                                        LN0856
     C*                                                                   LN0856
     C                   MOVE      'C'           LEVEL
     C**********           MOVE 'ALL'     ENITY                           LN0856
     C                   MOVE      A8CMCD        ENITY                                         LN085
     C                   MOVE      'N'           DISTR
     C                   GOTO      END
     C                   END
     C**
     C*  IF USER IS NOT AUTHORISED TO MULTIPLE BRANCH REPORTS AND
     C*  COMMAND IS F TERMINATE PROGRAM.
     C*
     C     MBREP         IFEQ      'N'
     C     COMND         ANDEQ     'F'
      *                                                                   S01486
      ** Exit if Account Officer and Department Level are not available   S01486
     C     DXALVL        IFNE      'Y'                                                         S0148
     C     DXDLVL        ANDNE     'Y'                                                         S0148
     C                   MOVE      'E'           COMND
     C                   GOTO      END
     C                   END
     C                   END                                                                   S0148
     C**                                                                  LN0856
     C*  IF NO LEVEL SELECTIONS ARE AVAILABLE AND THE USER                LN0856
     C*  IS NOT AUTHORISED TO BANK LEVEL REPORTS THEN DISPLAY             LN0856
     C*  THE SCREEN WITH MESSAGE AND ONLY ALLOW F3 TO BE TAKEN            LN0856
     C*                                                                   LN0856
     C     *IN40         IFEQ      '1'                                                         LN085
     C     *IN41         ANDEQ     '1'                                                         LN085
     C     *IN42         ANDEQ     '1'                                                         LN085
     C     *IN46         ANDEQ     '1'                                                         S0148
     C     *IN47         ANDEQ     '1'                                                         S0148
     C**                                                                  LN0856
     C*  SET ON INDICATORS TO NON-DISPLAY                                 LN0856
     C*  ENTITY AND DISTRIBUTION FIELDS                                   LN0856
     C*                                                                   LN0856
     C                   SETON                                        4345                     LN085
     C*                                                                   LN0856
     C                   CALL      'ZA0250'                                                    LN085
     C                   CALL      'FCC0240'                                                   LN085
     C***********          PARM 'RCF0073' MSGID                   LN0856  LN1186
     C                   PARM      'RCF1073'     MSGID                                         LN118
     C                   WRITE     FC0200C1                                                    LN085
     C*                                                                   LN0856
     C*  ONLY F3 CAN BE TAKEN.                                            LN0856
     C*                                                                   LN0856
     C     *IN03         DOWEQ     '0'                                                         LN085
     C                   EXFMT     FC0200F0                                                    LN085
     C**                                                                  LN0856
     C*  IF F3, SET PARAMETERS AND TERMINATE PROGRAM.                     LN0856
     C*                                                                   LN0856
     C     *IN03         IFEQ      '1'                                                         LN085
     C                   MOVE      'E'           COMND                                         LN085
     C                   MOVE      'T'           ATION                                         LN085
     C                   GOTO      END                                                         LN085
     C                   END                                                                   LN085
     C                   END                                                                   LN085
     C                   END                                                                   LN116
     C**
     C*  IF COMMAND IS NOT F AND ACTION IS A ACCESS LF/FCRREQL1.
     C*
     C     COMND         IFNE      'F'
     C     ATION         ANDEQ     'A'
     C     KEY1          CHAIN     FCRREQL1                           22
     C**
     C*  IF NO RECORD WAS FOUND DISPLAY SCREEN WITH MESSAGE.
     C*
     C*
     C     *IN22         IFEQ      '1'
     C                   CALL      'ZA0250'
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0023' MSGID                           LN1186
     C                   PARM      'RCF1023'     MSGID                                         LN118
     C                   WRITE     FC0200C1
     C**
     C*  ONLY F3 AND F12 CAN BE TAKEN.
     C*
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C                   EXFMT     FC0200F0
     C                   END
     C**
     C*  IF F3, SET PARAMETERS AND TERMINATE PROGRAM.
     C*
     C     *IN03         IFEQ      '1'
     C                   MOVE      'E'           COMND
     C                   MOVE      'T'           ATION
     C                   GOTO      END
     C                   END
     C**
     C*  IF F12, SET PARAMETERS AND TERMINATE PROGRAM.
     C*
     C     *IN12         IFEQ      '1'
     C                   MOVE      'E'           COMND
     C                   MOVE      'P'           ATION
     C                   GOTO      END
     C                   END
     C                   END
     C**********           END                                      LN0856LN1160
     C**
     C*  IF USER IS NOT AUTHORISED TO MULTIPLE BRANCH REPORTS
     C*  TERMINATE PROGRAM.
      ** Exit if Account Officer and Department Level are not available   S01486
     C*
     C     MBREP         IFEQ      'N'
     C     DXALVL        ANDNE     'Y'                                                         S0148
     C     DXDLVL        ANDNE     'Y'                                                         S0148
     C                   GOTO      END
     C                   END
     C                   END
      *                                                                   S01486
      ** If command is F (Return to this program from Module prompt)      S01486
      ** and Level is D set screen field Department.                      S01486
      *                                                                   S01486
     C     COMND         IFEQ      'F'                                                         S0148
     C     LEVEL         ANDEQ     'D'                                                         S0148
     C                   MOVE      'Y'           SDEPT                                         S0148
     C                   GOTO      TAG                                                         S0148
     C                   END                                                                   S0148
     C**                                                                  S01486
     C*  If action is I and report is only available at Department Level  S01486
     C*  set screen field Department.                                     S01486
     C*                                                                   S01486
     C     ATION         IFEQ      'I'                                                         S0148
     C     DXDLVL        ANDEQ     'Y'                                                         S0148
     C     DXBLVL        ANDEQ     'N'                                                         S0148
     C     DXCLVL        ANDEQ     'N'                                                         S0148
     C     DXGLVL        ANDEQ     'N'                                                         S0148
     C     DXALVL        ANDNE     'Y'                                                         S0148
     C                   MOVE      'Y'           SDEPT                                         S0148
     C                   GOTO      TAG                                                         S0148
     C                   END                                                                   S0148
     C**                                                                  S01486
     C*  If action is A and level from LF/FCRREQL1 is D set screen        S01486
     C*  field Department.                                                S01486
     C*                                                                   S01486
     C     ATION         IFEQ      'A'                                                         S0148
     C     D5LVL         ANDEQ     'D'                                                         S0148
     C                   MOVE      'Y'           SDEPT                                         S0148
     C                   GOTO      TAG                                                         S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      ** If command is F (Return to this program from Module prompt)      S01486
      ** and Level is A set screen field Account Officer.                 S01486
      *                                                                   S01486
     C     COMND         IFEQ      'F'                                                         S0148
     C     LEVEL         ANDEQ     'A'                                                         S0148
     C                   MOVE      'Y'           SACOF                                         S0148
     C                   GOTO      TAG                                                         S0148
     C                   END                                                                   S0148
     C**                                                                  S01486
     C*  If action is I and report is only available at Account           S01486
     C*  Officer Level set screen field Account Officer.                  S01486
     C*                                                                   S01486
     C     ATION         IFEQ      'I'                                                         S0148
     C     DXALVL        ANDEQ     'Y'                                                         S0148
     C     DXBLVL        ANDEQ     'N'                                                         S0148
     C     DXCLVL        ANDEQ     'N'                                                         S0148
     C     DXGLVL        ANDEQ     'N'                                                         S0148
     C     DXDLVL        ANDNE     'Y'                                                         S0148
     C                   MOVE      'Y'           SACOF                                         S0148
     C                   GOTO      TAG                                                         S0148
     C                   END                                                                   S0148
     C**                                                                  S01486
     C*  If action is A and level from LF/FCRREQL1 is A set screen        S01486
     C*  field Account Officer.                                           S01486
     C*                                                                   S01486
     C     ATION         IFEQ      'A'                                                         S0148
     C     D5LVL         ANDEQ     'A'                                                         S0148
     C                   MOVE      'Y'           SACOF                                         S0148
     C                   GOTO      TAG                                                         S0148
     C                   END                                                                   S0148
     C**
     C*  IF COMMAND IS F (RETURN TO THIS PROGRAM FROM MODULE PROMPT)
     C*  AND LEVEL IS B SET SCREEN FIELD BRANCH.
     C*
     C     COMND         IFEQ      'F'
     C     LEVEL         ANDEQ     'B'
     C                   MOVE      'Y'           SBRCH
     C                   GOTO      TAG
     C                   END
     C**
     C*  IF ACTION IS I AND REPORT IS ONLY AVAILABLE AT BRANCH-LEVEL
     C*  SET SCREEN FIELD BRANCH.
     C*
     C     ATION         IFEQ      'I'
     C     DXBLVL        ANDEQ     'Y'
     C     DXCLVL        ANDNE     'Y'
     C     DXGLVL        ANDNE     'Y'
     C     DXALVL        ANDNE     'Y'                                                         S0148
     C     DXDLVL        ANDNE     'Y'                                                         S0148
     C                   MOVE      'Y'           SBRCH
     C                   GOTO      TAG
     C                   END
     C**
     C*  IF ACTION IS A AND LEVEL FROM LF/FCRREQL1 IS B SET SCREEN
     C*  FIELD BRANCH.
     C*
     C     ATION         IFEQ      'A'
     C     D5LVL         ANDEQ     'B'
     C                   MOVE      'Y'           SBRCH
     C                   GOTO      TAG
     C                   END
     C**
     C*  IF COMMAND IS F AND LEVEL IS C SET SCREEN FIELD COMPANY.
     C*
     C     COMND         IFEQ      'F'
     C     LEVEL         ANDEQ     'C'
     C                   MOVE      'Y'           SCOMP
     C                   GOTO      TAG
     C                   END
     C**
     C*  IF ACTION IS I AND REPORT IS ONLY AVAILABLE AT COMPANY-LEVEL
     C*  SET SCREEN FIELD COMPANY.
     C*
     C     ATION         IFEQ      'I'
     C     DXCLVL        ANDEQ     'Y'
     C     DXBLVL        ANDNE     'Y'
     C     DXGLVL        ANDNE     'Y'
     C     DXALVL        ANDNE     'Y'                                                         S0148
     C     DXDLVL        ANDNE     'Y'                                                         S0148
     C                   MOVE      'Y'           SCOMP
     C                   GOTO      TAG
     C                   END
     C**
     C*  IF ACTION IS A AND LEVEL FROM LF/FCRREQL1 IS C SET SCREEN
     C*  FIELD COMPANY.
     C*
     C     ATION         IFEQ      'A'
     C     D5LVL         ANDEQ     'C'
     C                   MOVE      'Y'           SCOMP
     C                   GOTO      TAG
     C                   END
     C**
     C*  IF COMMAND IS F AND LEVEL IS S SET SCREEN FIELD SYSTEM.
     C*
     C     COMND         IFEQ      'F'
     C     LEVEL         ANDEQ     'S'
     C                   MOVE      'Y'           SSYST
     C                   GOTO      TAG
     C                   END
     C**
     C*  IF ACTION IS A AND LEVEL FROM LF/FCRREQL1 IS S SET SCREEN
     C*  FIELD SYSTEM.
     C*
     C     ATION         IFEQ      'A'
     C     D5LVL         ANDEQ     'S'
     C                   MOVE      'Y'           SSYST
     C                   END
     C*
     C     TAG           TAG
     C*                                                                   141196
     C*  IF FACILITY HISTORY REPORT REQUESTED THEN DEFAULT FOR            141196
     C*  SCREEN FIELD ENTITY SHOULD BE 'ALL'.                             141196
     C*                                                                   141196
     C     PGRPG         IFEQ      'LER610'                                                    14119
     C                   MOVEL     'ALL'         SETTY                                         14119
     C                   GOTO      TAG1                                                        14119
     C                   ENDIF                                                                 14119
     C**
     C*  IF COMMAND IS F SET SCREEN FIELD ENTITY WITH PARAMETER.
     C*
     C     COMND         IFEQ      'F'
     C                   MOVE      ENITY         SETTY
     C                   GOTO      TAG1
     C                   END
     C**
     C*  IF ACTION IS A SET SCREEN FIELD ENTITY WITH ENTITY FROM
     C*  LF/FCRREQL1.
     C*
     C     ATION         IFEQ      'A'
     C                   MOVE      D5ETTY        SETTY
     C                   GOTO      TAG1
     C                   END
     C**
     C*  IF ACTION IS I AND REPORT IS ONLY AVAILABLE AT BRANCH-LEVEL
     C*  SET SCREEN FIELD ENTITY TO USER'S DEFAULT BRANCH.
     C*
     C     ATION         IFEQ      'I'
     C     DXBLVL        IFEQ      'Y'
     C     DXCLVL        ANDEQ     'N'
     C     DXGLVL        ANDEQ     'N'
     C     DXALVL        ANDNE     'Y'                                                         S0148
     C     DXDLVL        ANDNE     'Y'                                                         S0148
     C                   MOVE      DBRN          SETTY
     C                   GOTO      TAG1
     C                   END
     C**
     C*  IF ACTION IS I AND REPORT IS ONLY AVAILABLE AT COMPANY-LEVEL
     C*
     C     DXCLVL        IFEQ      'Y'
     C     DXBLVL        ANDEQ     'N'
     C     DXGLVL        ANDEQ     'N'
     C     DXALVL        ANDNE     'Y'                                                         S0148
     C     DXDLVL        ANDNE     'Y'                                                         S0148
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*KEY'        P@APOP            7              I:Option
     C                   PARM                    DBRN              3              I:User branch
     C********** P@BRCH    PARM P@BRCH    DSFDY              O:Rec format                     CGL029
     C     P@BRCH        PARM      P@BRCH        DSSDY
     C**
     C*  IF PROGRAM ENDS IN ERROR DATABASE ERROR.
     C*
     C     P@APRC        IFNE      *BLANK
     C                   MOVEL     'SDBRCHL1'    DBFILE                         *************
     C                   MOVEL     DBRN          DBKEY                          *           *
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   EXSR      *PSSR                                        *           *
     C                   END                                                    *************
     C**
     C*  IF NO ERROR IN PROGRAM SET SCREEN FIELD ENTITY TO COMPANY
     C*  OF USER'S DEFAULT BRANCH.
     C                   MOVE      A8CMCD        SETTY
     C                   END
     C                   END
     C*                                                                   079538
     C**  Access SDMMODPD for Portfolio Management Indicator.             079538
     C*                                                                   079538
     C                   CALL      'AOMMODR0'                                                  07953
     C                   PARM      '        '    @RTCD             7                           07953
     C                   PARM      '*FIRST  '    @OPTN             7                           07953
     C     @MMOD         PARM      @MMOD         DSFDY                                         07953
     C*                                                                   079538
     C     @RTCD         IFNE      *BLANK                                                      07953
     C     BGTYLC        OREQ      'D'                                                         07953
     C                   Z-ADD     5             DBASE                          ***************07953
     C                   MOVE      'SDMMODPD'    DBFILE                         * DB ERROR 05 *07953
     C                   MOVEL     *BLANKS       DBKEY                          ***************07953
     C                   EXSR      *PSSR                                                       07953
     C                   END                                                                   07953
      *                                                                   S01486
      ** Access PM ICD File.                                              S01486
      *                                                                   S01486
     C     BGPFMG        IFEQ      'Y'                                                         07953
     C*                                                                   079538
     C                   CALL      'AOPORTR0'                                                  S0148
     C                   PARM      '*DBERR '     @RTCD             7              B:Return codeS0148
     C                   PARM      '*FIRST'      @OPTN             7              I:Option     S0148
     C     SDPORT        PARM      SDPORT        DSFDY                            O:Rec format S0148
     C*                                                                   079538
     C                   END                                                                   07953
      *                                                                   S01486
      *
      ** Action is I, the only level is Account Officer; If PM ICD        S01486
      ** High Level Security is 'Y', Entity is equal to MUSER Account     S01486
      ** Officer. If MUSER Account Officer is blank or High Level         S01486
      ** Security is 'N' then Entity is 'ALL'                             S01486
     C     ATION         IFEQ      'I'                                                         S0148
     C     DXALVL        ANDEQ     'Y'                                                         S0148
     C     DXBLVL        ANDEQ     'N'                                                         S0148
     C     DXCLVL        ANDEQ     'N'                                                         S0148
     C     DXGLVL        ANDEQ     'N'                                                         S0148
     C     DXDLVL        ANDNE     'Y'                                                         S0148
      *                                                                   S01486
     C***********P9HLVS    IFEQ 'Y'                                 S01486PM0041
     C     FCHLVS        IFEQ      'Y'                                                         PM004
     C***********ACOF      ANDNE*BLANKS                             S01486083547
     C     ACFA          ANDNE     *BLANKS                                                     08354
     C                   MOVE      *BLANKS       SETTY                                         S0148
     C***********          MOVELACOF      SETTY                     S01486083547
     C                   MOVEL     ACFA          SETTY                                         08354
     C                   ELSE                                                                  S0148
     C                   MOVEL     'ALL'         SETTY                                         S0148
     C                   END                                                                   S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      ** Action is I, the only level is Department; If PM ICD             S01486
      ** High Level Security is 'Y', Entity is equal to MUSER Depart-     S01486
      ** ment.                                                            S01486
      ** If MUSER Department is blank and MUSER Account Officer is        S01486
      ** 'ALL' or if High Level Security is 'N', then Entity is 'ALL'     S01486
      ** If the Account Officer on MUSER is not 'ALL', send an error      S01486
      ** message.                                                         S01486
     C     ATION         IFEQ      'I'                                                         S0148
     C     DXDLVL        ANDEQ     'Y'                                                         S0148
     C     DXBLVL        ANDEQ     'N'                                                         S0148
     C     DXCLVL        ANDEQ     'N'                                                         S0148
     C     DXGLVL        ANDEQ     'N'                                                         S0148
     C     DXALVL        ANDNE     'Y'                                                         S0148
      *                                                                   S01486
     C***********P9HLVS    IFEQ 'Y'                                 S01486PM0041
     C     FCHLVS        IFEQ      'Y'                                                         PM004
     C     DPPT          ANDNE     *BLANKS                                                     S0148
     C                   MOVEL     DPPT          SETTY                                         S0148
     C                   ELSE                                                                  S0148
      *                                                                   S01486
     C***********ACOF      IFEQ 'ALL'                               S01486083547
     C     ACFA          IFEQ      'ALL'                                                       08354
     C                   MOVE      'ALL'         SETTY                                         S0148
     C                   ELSE                                                                  S0148
      ** Send message - Authorisation to this report is not allowed.      S01486
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1089'     MSGID                                         S0148
     C                   WRITE     FC0200C1                                                    S0148
     C                   END                                                                   S0148
     C                   END                                                                   S0148
     C*
     C     TAG1          TAG
     C**
     C*  IF ACTION IS 'F', SET SCREEN FIELD DISTRIBUTION
     C*  WITH PARAMETER.
     C*
     C     COMND         IFEQ      'F'
     C                   MOVE      DISTR         SDRQD
     C                   ELSE
     C                   MOVE      'N'           SDRQD
     C                   END
     C**
     C*  IF ACTION IS 'A' F/12 IS DISPLAYED
     C*
     C     ATION         IFEQ      'A'
     C                   SETON                                        44
     C                   END
     C*
     C                   END
     C**
     C*  PERFORM SCREEN PROCESSING
     C*
     C                   EXSR      SCREEN
     C*
     C     END           TAG
     C                   SETON                                        LR
     C*
     C********************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM SCREEN PROCESSING.                     *
     C*                                                               *
     C* CALLED FROM :  MAIN   - Main processing.                      *
     C* CALLS       :  VALID  - Validate screen data.                 *
     C*                                                               *
     C* FIELDS      :  LEVEL  - Parameter Level.                      *
     C*                SETTY  - Screen Entity.                        *
     C*                SDRQD  - Screen Distribution.                  *
     C*                ENITY  - Parameter Entity.                     *
     C*                DISTR  - Parameter Distribution.               *
     C*                COMND  - Parameter Command.                    *
     C*                ATION  - Parameter Action.                     *
     C*                                                               *
     C*****************************************************************
     C*
     C     SCREEN        BEGSR
     C**
     C*  WRITE SCREEN
     C*
     C                   EXFMT     FC0200F0
     C**
     C*  PERFORM WHILE EXIT IS NOT REQUIRED
     C*
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C**
     C*  VALIDATE INPUT
     C*
     C                   EXSR      VALID
     C**
     C*  IF INPUT IS VALID, SET PARAMETER LEVEL AND TERMINATE PROGRAM.
     C*
     C     *IN50         IFEQ      '0'
     C     SBRCH         IFEQ      'Y'
     C                   MOVE      'B'           LEVEL
     C                   END
     C     SCOMP         IFEQ      'Y'
     C                   MOVE      'C'           LEVEL
     C                   END
     C     SSYST         IFEQ      'Y'
     C                   MOVE      'S'           LEVEL
     C                   END
     C     SACOF         IFEQ      'Y'                                                         S0148
     C                   MOVE      'A'           LEVEL                                         S0148
     C                   END                                                                   S0148
     C     SDEPT         IFEQ      'Y'                                                         S0148
     C                   MOVE      'D'           LEVEL                                         S0148
     C                   END                                                                   S0148
     C                   MOVE      SETTY         ENITY
     C                   MOVE      SDRQD         DISTR
     C                   GOTO      SCREND
     C                   ELSE
     C**
     C*  RE-DISPLAY SCREEN WHEN INVALID.
     C*
     C                   WRITE     FC0200C1
     C                   EXFMT     FC0200F0
     C                   END
     C*
     C                   END
     C**
     C*  IF F/3 IS TAKEN MOVE 'E' INTO COMMAND AND 'T' INTO ACTION.
     C*
     C     *IN03         IFEQ      '1'
     C                   MOVE      'E'           COMND
     C                   MOVE      'T'           ATION
     C                   END
     C**
     C*  IF F/12 IS TAKEN MOVE 'E' INTO COMMAND AND 'P' INTO ACTION.
     C*
     C     *IN12         IFEQ      '1'
     C                   MOVE      'E'           COMND
     C                   MOVE      'P'           ATION
     C                   END
     C*
     C     SCREND        ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM VALIDATION OF SCREEN DATA PROCESSING.  *
     C*                                                               *
     C* CALLED FROM :  SCREEN - Screen Processing.                    *
     C* CALLS       :  NONE   -                                       *
     C*                                                               *
     C* FIELDS      :  SBRCH  - Screen Field Branch.                  *
     C*                SCOMP  - Screen Field Company.                 *
     C*                SSYST  - Screen Filed System.                  *
     C*                SETTY  - Screen entity.                        *
     C*                TBRCH  - Branch type.                          *
     C*                ERO    - Error Return Code.                    *
     C*                SDRQD  - Screen distribution.                  *
     C*                                                               *
     C*****************************************************************
     C*
     C     VALID         BEGSR
     C**
     C*  SET OFF INDICATORS AND CLEAR MESSAGES.
     C*
     C                   SETOFF                                       313233
     C                   SETOFF                                       343550
     C                   SETOFF                                       3637                     S0148
     C                   CALL      'ZA0250'
      *                                                                                     MD023136
      **  Ensure that entered values is a possible ONE - BRANCH LEVEL                       MD023136
      *                                                                                     MD023136
     C     SBRCH         IFNE      'Y'
     C     SBRCH         ANDNE     *BLANKS
     C                   CALL      'FCC0240'
     C                   PARM      'RCF1024'     MSGID             7
     C                   SETON                                        3150
     C                   END
      *                                                                                     MD023136
      ** Ensuer that entered values is a possible ONE - COMPANY LEVEL                       MD023136
      *                                                                                     MD023136
     C     SCOMP         IFNE      'Y'
     C     SCOMP         ANDNE     *BLANKS
     C                   CALL      'FCC0240'
     C                   PARM      'RCF1024'     MSGID             7
     C                   SETON                                        3250
     C                   END
     C*                                                                   CFT002
     C*** WHEN PERFORMING '?' PROCESSING, THE SELECTED ITEM IS            CFT002
     C*** DISPLAYED ON SCREEN AND THE ENTER KEY MUST BE PRESSED           CFT002
     C*** BEFORE VALIDATING                                               CFT002
     C*                                                                   CFT002
     C     '?'           SCAN      SETTY                                  51                   CFT00
     C     *IN51         IFEQ      *ON                                                         CFT00
     C     SBRCH         IFEQ      'Y'
     C*                                                                   CFT002
     C** VALIDATE BRANCH CODE                                             CFT002
     C*                                                                   CFT002
     C**********           CALL 'AOBRCHR0'                                             CFT002 CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANK        P@APRC            7              B:Return codeCFT00
     C                   PARM      '*KEY'        P@APOP            7              I:Option     CFT00
     C                   PARM      SETTY         DBRN              3              I:User branchCFT00
     C********** P@BRCH    PARM P@BRCH    DSFDY              O:Rec format              CFT002 CGL029
     C     P@BRCH        PARM      P@BRCH        DSSDY
     C*                                                                   CFT002
     C                   MOVE      *ON           *IN50                                         CFT00
     C*                                                                   CFT002
     C     P@APRC        IFNE      '*NOSEL'                                                    CFT00
     C                   MOVE      DBRN          SETTY                                         CFT00
     C                   ENDIF                                                                 CFT00
     C                   ELSE                                                                  CFT00
     C**
     C*  EXECUTE BRANCH VALIDATION
     C*
     C     SBRCH         IFNE      'Y'
     C     SBRCH         ANDNE     *BLANKS
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0024' MSGID   7                       LN1186
     C                   PARM      'RCF1024'     MSGID             7                           LN118
     C                   SETON                                        3150
     C                   END
     C                   ENDIF
     C**********           END                                                              BUG27056
      *                                                                                     BUG27056
      ** VALIDATE COMPANY CODE                                                              BUG27056
      *                                                                                     BUG27056
     C     SCOMP         IFEQ      'Y'
     C                   CALL      'AOCOMPR0'
     C                   PARM      *BLANK        P@APRC            7
     C                   PARM      '*KEY'        P@APOP            7
     C                   PARM      SETTY         D6XETY            3
     C     D@COMP        PARM      D@COMP        DSFDY
      *                                                                                     BUG27056
     C                   MOVE      *ON           *IN50
      *                                                                                     BUG27056
     C     P@APRC        IFNE      '*NOSEL'
     C                   MOVE      D6XETY        SETTY
     C                   ENDIF
      *                                                                                     BUG27056
     C                   ELSE
     C**
     C*  EXECUTE COMPANY VALIDATION
     C*
     C     SCOMP         IFNE      'Y'
     C     SCOMP         ANDNE     *BLANKS
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0024' MSGID   7                       LN1186
     C                   PARM      'RCF1024'     MSGID                                         LN118
     C                   SETON                                        3250
     C                   END
     C                   ENDIF
     C                   ENDIF
     C**********           END                                                              BUG27056
     C**
     C*  EXECUTE SYSTEM VALIDATION
     C*
     C     SSYST         IFNE      'Y'
     C     SSYST         ANDNE     *BLANKS
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0024' MSGID   7                       LN1186
     C                   PARM      'RCF1024'     MSGID                                         LN118
     C                   SETON                                        3350
     C                   END
      *                                                                   S01486
      ** Execute Account Officer validation                               S01486
      *                                                                   S01486
     C     SACOF         IFNE      'Y'                                                         S0148
     C     SACOF         ANDNE     *BLANKS                                                     S0148
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1024'     MSGID                                         S0148
     C                   SETON                                        3650                     S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      ** Execute Department validation                                    S01486
      *                                                                   S01486
     C     SDEPT         IFNE      'Y'                                                         S0148
     C     SDEPT         ANDNE     *BLANKS                                                     S0148
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1024'     MSGID                                         S0148
     C                   SETON                                        3750                     S0148
     C                   END                                                                   S0148
     C**
     C*  ONLY ONE OF BRANCH, COMPANY AND SYSTEM MAY BE NON BLANK.
     C*
     C***********SBRCH     IFNE *BLANKS                                   S01486
     C***********SCOMP     ANDNE*BLANKS                                   S01486
     C***********SBRCH     ORNE *BLANKS                                   S01486
     C***********SSYST     ANDNE*BLANKS                                   S01486
     C***********SSYST     ORNE *BLANKS                                   S01486
     C***********SCOMP     ANDNE*BLANKS                                   S01486
      *                                                                   S01486
      ** Perform a LOKUP routine twice to determine the number of 'Y'     S01486
      ** entered. If two are found then output an error.                  S01486
      *                                                                   S01486
     C                   Z-ADD     1             I                 2 0                         S0148
     C     'Y'           LOOKUP    SINP(I)                                48                   S0148
      *                                                                   S01486
      ** A 'Y' has been found.                                            S01486
     C     *IN48         IFEQ      *ON                                                         S0148
     C     I             ANDNE     5                                                           S0148
     C                   ADD       1             I                                             S0148
     C     'Y'           LOOKUP    SINP(I)                                48                   S0148
      *                                                                   S01486
      ** A second 'Y' has been found; hence error.                        S01486
     C     *IN48         IFEQ      *ON                                                         S0148
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0025' MSGID   7
     C                   PARM      'RCF1025'     MSGID
     C                   SETON                                        313233
     C                   SETON                                        3637                     S0148
     C                   SETON                                        50                       S0148
     C                   END                                                                   S0148
     C                   END
      *
      **  ONE LEVEL MUST BE ENTERED
      *
     C     SBRCH         IFEQ      *BLANK
     C     SCOMP         ANDEQ     *BLANK
     C     SSYST         ANDEQ     *BLANK
     C     SACOF         ANDEQ     *BLANK                                                      S0148
     C     SDEPT         ANDEQ     *BLANK                                                      S0148
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0066' MSGID                           LN1186
     C                   PARM      'RCF1066'     MSGID                                         LN118
     C                   SETON                                        313233
     C                   SETON                                        3637                     S0148
     C                   SETON                                        50
     C                   END
     C**
     C*  IF BRANCH IS 'Y' AND ENTITY IS BLANK SCREEN IS INVALID.
     C*
     C     SBRCH         IFEQ      'Y'
     C     SETTY         ANDEQ     *BLANK
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0026' MSGID   7                       LN1186
     C                   PARM      'RCF1026'     MSGID                                         LN118
     C                   SETON                                        3450
     C                   END
     C**
     C*  IF COMPANY IS 'Y' AND ENTITY IS BLANK SCREEN IS INVALID.
     C*
     C     SCOMP         IFEQ      'Y'
     C     SETTY         ANDEQ     *BLANK
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0026' MSGID   7                       LN1186
     C                   PARM      'RCF1026'     MSGID                                         LN118
     C                   SETON                                        3450
     C                   END
     C**
     C*  IF SYSTEM IS 'Y' AND ENTITY IS NOT BLANK SCREEN IS INVALID.
     C*
     C     SSYST         IFEQ      'Y'
     C     SETTY         ANDNE     *BLANK
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0027' MSGID   7                       LN1186
     C                   PARM      'RCF1027'     MSGID                                         LN118
     C                   SETON                                        3450
     C                   END
      *                                                                   S01486
      ** If Account Officer is 'Y' and Entity is blank,                   S01486
      ** screen is invalid.                                               S01486
      *                                                                   S01486
     C     SACOF         IFEQ      'Y'                                                         S0148
     C     SETTY         ANDEQ     *BLANK                                                      S0148
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1026'     MSGID                                         S0148
     C                   SETON                                        3450                     S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      ** If Department is 'Y' and Entity is blank, screen is invalid      S01486
      *                                                                   S01486
     C     SDEPT         IFEQ      'Y'                                                         S0148
     C     SETTY         ANDEQ     *BLANK                                                      S0148
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1026'     MSGID                                         S0148
     C                   SETON                                        3450                     S0148
     C                   END                                                                   S0148
     C**
     C*  VALIDATE BRANCH FOR THE CURRENT USER.
     C*
     C     SBRCH         IFEQ      'Y'
     C     SETTY         ANDNE     *BLANK
     C     SETTY         ANDNE     'ALL'
     C*                                                                   LN1238
     C** VALIDATE BRANCH CODE                                             LN1238
     C*                                                                   LN1238
     C**********           CALL 'AOBRCHR0'                                             LN1238 CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANK        P@APRC            7              B:Return codeLN123
     C                   PARM      '*KEY'        P@APOP            7              I:Option     LN123
     C                   PARM      SETTY         DBRN              3              I:User branchLN123
     C********** P@BRCH    PARM P@BRCH    DSFDY              O:Rec format LN1238              CGL029
     C     P@BRCH        PARM      P@BRCH        DSSDY
     C*                                                                   LN1238
     C** IF RETURN CODE IS NOT BLANK THE BRANCH IS INVALID                LN1238
     C*                                                                   LN1238
     C     P@APRC        IFNE      *BLANK                                                      LN123
     C                   CALL      'FCC0240'                                                   LN123
     C                   PARM      'RCF1028'     MSGID             7                           LN123
     C                   SETON                                        3450                     LN123
     C                   ELSE                                                                  LN123
     C*                                                                   LN1238
     C** BRANCH IS VALID - CHECK USERS AUTHORITY TO IT.                   LN1238
     C*                                                                   LN1238
     C**
     C*  IF BOOKING BRANCH.
     C*
     C     TBRCH         IFEQ      'B'
     C                   CALL      'ZVBBU'
     C***********          PARM           SETTY   3        BRANCH.        E36373
     C                   PARM      DBRN          SETTY             3            BRANCH.        E3637
     C                   PARM                    ERO               1 0          RTRN CODE.
     C**
     C*  IF ORIGINATING BRANCH.
     C*
     C                   ELSE
     C                   CALL      'ZVOBU'
     C***********          PARM           SETTY   3        BRANCH.        E36373
     C                   PARM      DBRN          SETTY             3            BRANCH.        E3637
     C                   PARM                    ERO               1 0          RTRN CODE.
     C                   END
     C**
     C***IF*BRANCH*IS*INVALID*SEND*ERROR*MESSAGE*TO*SCREEN.**********     LN1238
     C** IF USER IS NOT AUTHORISED TO THE BRANCH SEND A MESSAGE           LN1238
     C*
     C     ERO           IFNE      0
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0028' MSGID   7                       LN1186
     C**********           PARM 'RCF1028' MSGID                    LN1186 LN1238
     C                   PARM      'RCF1015'     MSGID                                         LN123
     C                   SETON                                        3450
     C                   END
     C                   END
     C                   END                                                                   LN123
     C**
     C*  VALIDATE COMPANY FOR THE CURRENT USER.
     C*
     C     SCOMP         IFEQ      'Y'
     C     SETTY         ANDNE     *BLANK
     C     SETTY         ANDNE     'ALL'
     C*                                                                   LN1238
     C** VALIDATE COMPANY CODE                                            LN1238
     C*                                                                   LN1238
     C                   CALL      'AOCOMPR0'                                                  LN123
     C                   PARM      *BLANK        P@APRC            7                           LN123
     C                   PARM      '*KEY'        P@APOP            7                           LN123
     C                   PARM      SETTY         D6XETY            3                           LN123
     C     D@COMP        PARM      D@COMP        DSFDY                                         LN123
     C*                                                                   LN1238
     C** IF RETURN CODE IS NOT BLANK THE COMPANY IS INVALID               LN1238
     C*                                                                   LN1238
     C     P@APRC        IFNE      *BLANK                                                      LN123
     C                   CALL      'FCC0240'                                                   LN123
     C                   PARM      'RCF1029'     MSGID             7                           LN123
     C                   SETON                                        3450                     LN123
     C                   ELSE                                                                  LN123
     C*                                                                   LN1238
     C** COMPANY IS VALID - CHECK USERS AUTHORITY TO IT.                  LN1238
     C*                                                                   LN1238
     C                   CALL      'ZVCOU'
     C***********          PARM           SETTY   3        BRANCH.        E36373
     C                   PARM      D6XETY        SETTY             3            COMPANY.       E3637
     C                   PARM                    ERO               1 0          RTRN CODE.
     C**
     C***IF*COMPANY*IS*INVALID*SEND*ERROR*MESSAGE*TO*SCREEN****           LN1238
     C** IF USER IS NOT AUTHORISED TO THE COMPANY SEND A MESSAGE          LN1238
     C*
     C     ERO           IFNE      0
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0029' MSGID   7                       LN1186
     C***********          PARM 'RCF1029' MSGID                    LN1168 LN1238
     C                   PARM      'RCF1077'     MSGID                                         LN123
     C                   SETON                                        3450
     C                   END
     C                   END
     C                   END                                                                   LN123
     C**********           ENDIF                                                   BUG27056 MD023136
     C**********           ENDIF                                                   BUG27056 MD023136
     C*
      ** Validate the Entity if non blank and                             S01486
      ** and the Screen Account Officer is 'Y'                            S01486
      *                                                                   S01486
     C     SACOF         IFEQ      'Y'                                                         S0148
     C     SETTY         ANDNE     *BLANKS                                                     S0148
      *                                                                   S01486
      ** Error if invalid Account Officer code                            S01486
     C     SETTY         IFNE      'ALL'                                                       S0148
      *                                                                   S01486
      ** Determine how the 2A Account Officer field has been entered.     S01486
     C     @POS1         IFNE      ' '                                                         S0148
     C                   MOVEL     SETTY         @ACOF             2                           S0148
     C                   ELSE                                                                  S0148
     C                   MOVE      SETTY         @ACOF                                         S0148
     C                   END                                                                   S0148
      *                                                                   S01486
     C                   CALL      'AOACOFR0'                                                  S0148
     C                   PARM      *BLANK        @RTCD                                         S0148
     C                   PARM      '*KEY    '    @OPTN                                         S0148
     C                   PARM                    @ACOF                                         S0148
     C     SDACOF        PARM      SDACOF        DSFDY                                         S0148
     C*                                                                   S01486
     C     @RTCD         IFNE      *BLANKS                                                     S0148
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1090'     MSGID                                         S0148
     C                   MOVE      *ON           *IN50                                         S0148
     C                   ELSE                                                                  S0148
      *                                                                   S01486
      ** Not authorised when Screen Entity not equal to MUSER ACOF.       S01486
     C***********ACOF      IFNE 'ALL'                               S01486083547
     C***********ACOF      ANDNE*BLANKS                             S01486083547
     C     ACFA          IFNE      'ALL'                                                       08354
     C     ACFA          ANDNE     *BLANKS                                                     08354
     C***********P9HLVS    ANDEQ'Y'                                 S01486PM0041
     C     FCHLVS        ANDEQ     'Y'                                                         PM004
     C***********SETTY     IFNE ACOF                                S01486083547
     C     SETTY         IFNE      ACFA                                                        08354
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1092'     MSGID                                         S0148
     C                   MOVE      *ON           *IN50                                         S0148
     C                   END                                                                   S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      ** MUSER Account Officer is blank; hence error if Screen Entity     S01486
      ** Department code does not equal the MUSER Department code.        S01486
     C***********ACOF      IFEQ *BLANKS                             S01486083547
     C     ACFA          IFEQ      *BLANKS                                                     08354
     C     AZDPCD        IFNE      DPPT                                                        S0148
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1092'     MSGID                                         S0148
     C                   MOVE      *ON           *IN50                                         S0148
     C                   END                                                                   S0148
     C                   END                                                                   S0148
      *                                                                   S01486
     C                   END                                                    Else           S0148
      *                                                                   S01486
      ** Screen Entity is 'ALL'.                                          S01486
     C                   ELSE                                                                  S0148
     C***********ACOF      IFNE *BLANKS                             S01486083547
     C***********ACOF      ANDNE'ALL'                               S01486083547
     C     ACFA          IFNE      *BLANKS                                                     08354
     C     ACFA          ANDNE     'ALL'                                                       08354
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1092'     MSGID                                         S0148
     C                   MOVE      *ON           *IN50                                         S0148
     C                   END                                                                   S0148
     C                   END                                                    'ALL' ??       S0148
     C                   END                                                    Screen         S0148
      *                                                                   S01486
      ** Validate the Entity if non blank and                             S01486
      ** and the Screen Department level is 'Y'.                          S01486
      *                                                                   S01486
     C     SDEPT         IFEQ      'Y'                                                         S0148
     C     SETTY         ANDNE     *BLANKS                                                     S0148
      *                                                                   S01486
      ** Error if invalid Department code                                 S01486
     C     SETTY         IFNE      'ALL'                                                       S0148
      *                                                                   S01486
     C                   CALL      'AODEPTR0'                                                  S0148
     C                   PARM      *BLANK        @RTCD                                         S0148
     C                   PARM      '*KEY    '    @OPTN                                         S0148
     C                   PARM                    SETTY                                         S0148
     C     SDDEPT        PARM      SDDEPT        DSFDY                                         S0148
      *                                                                   S01486
      ** Error                                                            S01486
     C     @RTCD         IFNE      *BLANK                                                      S0148
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1091'     MSGID                                         S0148
     C                   MOVE      *ON           *IN50                                         S0148
     C                   ELSE                                                                  S0148
      *                                                                   S01486
      ** Not authorised when Screen Entity not equal to MUSER DPPT.       S01486
     C     DPPT          IFNE      'ALL'                                                       S0148
     C     DPPT          ANDNE     *BLANKS                                                     S0148
     C***********P9HLVS    ANDEQ'Y'                                 S01486PM0041
     C     FCHLVS        ANDEQ     'Y'                                                         PM004
     C     SETTY         IFNE      DPPT                                                        S0148
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1092'     MSGID                                         S0148
     C                   MOVE      *ON           *IN50                                         S0148
     C                   END                                                                   S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      ** Validate for blank MUSER Department code.                        S01486
     C     DPPT          IFEQ      *BLANKS                                                     S0148
     C***********ACOF      ANDNE'ALL'                               S01486083547
     C     ACFA          ANDNE     'ALL'                                                       08354
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1092'     MSGID                                         S0148
     C                   MOVE      *ON           *IN50                                         S0148
     C                   END                                                                   S0148
      *                                                                   S01486
     C                   END                                                    Valid ACOF ?   S0148
     C                   END                                                    <> 'ALL'       S0148
      *                                                                   S01486
      ** Screen Entity can only be 'ALL' is the MUSER Department code     S01486
      ** is Blank and the Account Officer is 'ALL'.                       S01486
     C     SETTY         IFEQ      'ALL'                                                       S0148
     C***********ACOF      ANDNE'ALL'                               S01486083547
     C     ACFA          ANDNE     'ALL'                                                       08354
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1092'     MSGID                                         S0148
     C                   MOVE      *ON           *IN50                                         S0148
     C                   END                                                                   S0148
      *                                                                   S01486
     C                   END                                                    Entity         S0148
      *                                                                   S01486
     C**  IF ENTITY ID 'ALL', USER MUST BE AUTHORISED TO BANK LEVEL
     C*
     C     SETTY         IFEQ      'ALL'
     C     BANK          ANDEQ     'N'
     C     SACOF         ANDNE     'Y'                                                         S0148
     C     SDEPT         ANDNE     'Y'                                                         S0148
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0065' MSGID                           LN1186
     C                   PARM      'RCF1065'     MSGID                                         LN118
     C                   SETON                                        3450
     C                   END
     C**
     C*  IF ENTITY IS NOT 'ALL' AND DISTRIBUTION IS 'Y' SCREEN
     C*  IS INVALID.
     C*
     C     SETTY         IFNE      'ALL'
     C     SDRQD         ANDEQ     'Y'
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0030' MSGID   7                       LN1186
     C                   PARM      'RCF1030'     MSGID                                         LN118
     C                   SETON                                        3550
     C                   END
     C**
     C*  IF DISTRIBUTION IS NOT 'Y' OR 'N' SCREEN IS INVALID.
     C*
     C     SDRQD         IFNE      'Y'
     C     SDRQD         ANDNE     'N'
     C     SDRQD         ANDNE     *BLANK
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0031' MSGID   7                       LN1186
     C                   PARM      'RCF1031'     MSGID                                         LN118
     C                   SETON                                        3550
     C                   END
     C**
     C*  IF DISTRIBUTION IS BLANK SET TO N.
     C*
     C     SDRQD         IFEQ      *BLANKS
     C                   MOVE      'N'           SDRQD
     C                   END
     C*
     C**********           ENDIF                                                     CFT002 MD023136
     C                   ENDSR
     C*
     C********************************************************************
      /EJECT
     C*****************************************************************
     C* SUBROUTINE  :  PERFORM DATABASE ERROR PROCESSING.             *
     C*                                                               *
     C* CALLED FROM :  MAIN  - Main processing.                       *
     C* CALLS       :  NONE  -                                        *
     C*****************************************************************
     C*
     C     *PSSR         BEGSR
     C**
     C*  PRINT DUMP AND TERMINATE PROGRAM.
     C*
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   END
     C                   RETURN
     C                   ENDSR
     C****************************************************************
** CPY@
(c) Finastra International Limited 2001
