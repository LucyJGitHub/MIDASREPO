     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Periodic requests')
     F********************************************************************
     F*                                                                  *
     F*  Midas - Report Control Facility Module
     F*                                                                  *
     F*      FC0210 - PERIODIC REQUESTS                                  *
     F*                                                                  *
      *  (c) Finastra International Limited 2001                      *
     F*                                                                  *
      *  Last Amend No. MD055681           Date 31Jul20               *
      *  Prev Amend No. MD055265           Date 10Feb20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 187977             Date 18Apr01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 127043             Date 23May00               *
     F*                 134289             Date 05Apr00                  *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CGL008             Date 03Mar99               *
      *                 092597             Date 04Sep95               *
      *                 087380             Date 10May95               *
     F*                     083547           DATE 20FEB95                *
     F*                     S01486           DATE 02JUN94                *
     F*                     048651           DATE 07MAY93                *
     F*                     S01407           DATE 26JAN93                *
     F*                     E38898           DATE 28APR92                *
     F*                     S01117           DATE 25MAR92                *
     F*                     E26621           DATE 23SEP91                *
     F*                     S01269           DATE 25JUN91                *
     F*                     LN1279           DATE 29MAR91                *
     F*                     LN1186           DATE 06MAR91                *
     F*                     LN1133           DATE 15FEB91                *
     F*                     BHF710           DATE 25SEP90                *
     F*                     LN0826           DATE 04OCT90                *
     F*                     LN0714           DATE 07SEP90                *
     F*                     LN0340           DATE 12JUN90                *
     F*                                                                  *
     F********************************************************************
     F*                                                                  *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  187977 - Add validation for the indicated branch. Also,      *
      *           different error messages must be issued by the      *
      *           system if the branch is invalid and if the user     *
      *           is not authorised for the branch.                   *
     F*  127043 - Inputs for FIRST DATE field which consists of a     *
     F*           blank character is being accepted. Applied fix      *
     F*           107739, which validates the said field and does not *
     F*           allow inputs which consists of a blank character    *
     F*           (except blanks for whole field).                    *
     F*  134289 - Don't do irrelevant validation in Delete or            *
     F*           Enquire mode.                                          *
      *  CGL008 - Security on Journal Entry. Recompile.               *
     F*      092597 - Check if Portfolio Management is on before call    *
     F*               to AOPORTR0                                        *
     F*      087380 - Enlarge parameter for AOUSERR0                  *
     F*      083547 - Correct Account Officer name on MUSER              *
     F*      S01486 - Private Banking Upgrade to ABS 10.                 *
     F*               Add Account Officer and Department Level (RCF).    *
     F*      048651 - When a report by branch is requested followed by a *
     F*               report by system, Periodic Reports Maintenance     *
     F*               screen must not display branch code under Entity   *
     F*             - Move blanks to field SETTY before returning to     *
     F*               FC0210D (Periodic Rpts Mnt. program)               *
     F*      S01407 - SWITCHABILITY ENHANCEMENTS                         *
     F*      E38898 - RETAIN THE VALUE OF DAY NO. WHEN RETURNING FROM    *
     F*               OTHER SCREENS
     F*      S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD                 *
     F*      E26621 - IF A PERIODIC REPORT REQUEST WAS AMENDED ON A DAY  *
     F*               IT WAS NOT DUE TO RUN THEN THE FIRST ACTIVE DATE   *
     F*               WAS SET TO ZEROS. THE FIRST ACTIVE DATE FOR WHICH  *
     F*               THE REPORT IS REQUIRED CAN BE ANY DATE FROM TODAY  *
     F*               ONWARDS. THE VALUE DEFAULTS TO TODAYS RUN DATE,    *
     F*               AND MAY BE AMENDED PROVIDED THAT THE DATE ALREADY  *
     F*               THERE IS NOT IN THE PAST.                          *
     F*                                                                  *
     F*      S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO        *
     F*               MUSERDD                                            *
     F*      LN1279 - CHANGE CREATION PARAMETERS.                        *
     F*      LN1186 - SEND NEW MESSAGE ID FROM FCUSRMSG TO FCC0240       *
     F*      LN1133 - PROGRAM REQUIRES RECOMPILING FOR DISPLAY FILE CHG  *
     F*      BHF710 - COMPONENT NAME AND SEQUENCE NUMBER SHOULD NOT      *
     F*             - BE AMENDABLE                                       *
     F*      LN0826 - FIRST DATE FIELD SHOULD ALWAYS DEFAULT TO RUNDATE  *
     F*      LN0714 - ZALIGN NEEDED TO VALIDATE FREQUENCY DAY NUMBER     *
     F*               AND PERIODIC SEQUENCE NUMBER FIELDS                *
     F*      LN0340 - DON'T VALIDATE IF ACTION IS ENQUIRY OR DELETE      *
     F*                                                                  *
     F********************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
/****F*: USRPRF(*USER) CODELIST(*NONE) IGNDECERR(*NO )              : *LN1279
     F*                                                               *
     F****************************************************************
     FFC0210DF  CF   E             WORKSTN
     FFCPREQL1  IF   E           K DISK
     F***********FCRCOML1IF  E           K        DISK                    S01407
     F*FCRCOMJ1* IF   E           K DISK                                         S01407     MD055265
     F*FCREPTJ0* IF   E           K DISK                                         S01407     MD055265
      *                                                                   S01486
     F********************************************************************
     F*           FUNCTION OF INDICATORS
     F*
     F*  03       EXIT
     F*  12       PREVIOUS
     F*  10       DELETE
     F*  31       ERROR ON BRANCH, SECOND SCREEN
     F*  32       ERROR ON COMPANY, SECOND SCREEN
     F*  33       ERROR ON SYSTEM, SECOND SCREEN
     F*  34       ERROR ON ENTITY, SECOND SCREEN
     F*  35       ERROR ON DISTRIBUTION REQUIRED, SECOND SCREEN
     F*  36       NON-DISPLAY COMPANY PROMPT ON SECOND SCREEN
     F*  37       NON-DISPLAY SYSTEM PROMPT ON SECOND SCREEN
     F*  38       NON-DISPLAY BRANCH PROMPT ON SECOND SCREEN
     F*  39       PROTECT USER ID FOR REQUEST
     F*  40       ERROR ON PERIODIC SEQUENCE NUMBER
     F*  41       Non-display Account Officer Propmt on second screen.    S01486
     F*  42       Non-display Department Prompt on seconf screen.         S01486
     F*  43       ERROR ON USER ID FOR REQUEST
     F*  44       ERROR ON REQUEST DESCRIPTION
     F***45*******ERROR*ON*COMPONENT*NAME/SEQ,*SECOND*SCREEN              BHF710
     F*  45       ERROR ON COMPONENT NAME/SEQ, SECOND SCREEN
     F*  46       ERROR ON FREQUENCY
     F*  47       ERROR ON FREQUENCY DAY NUMBER
     F*  48       ERROR ON FIRST DATE
     F*  49       DISPLAY LAST ACTIVE DATE
     F*  50       PROTECT FIRST DATE, AS IT IS BEFORE RUN DATE
     F*  51       ALLOW F10
     F*  52       PROTECT SCREEN FOR ENQUIRE/DELETE
     F*  53       Error on Account Officer, second screen.                S01486
     F*  54       Error on Department, second screen.                     S01486
     F*  55       A seletion has been made (LOKUP).                       S01486
     F*  56       Error on selection for Department Level.                S01486
     F*  60       SFLEND INDICATOR FORM MESSAGE SUBFILE
     F*  63       LOKUP INDICATOR FOR FREQUENCY VALIDATION
     F*  65       END SCREEN PROCESSING
     F*  70       ERROR ON SCREEN
     F*  77       CHAIN FAIL TO FCREPTJ0 - REPORT DESCRIPTIONS            S01407
     F*  78       CHAIN FAIL TO FCPREQL1 - PERIODIC REQUESTS
     F***79*******CHAIN*FAIL*TO*FCRCOML1*-*REPORT*COMPONENTS              S01407
     F*  79       CHAIN FAIL TO FCRCOMJ1 - REPORT COMPONENTS              S01407
     F*
     F*  98       SYSTEM DATE FORMAT IS MMDDYY
     F*
     F****************************************************************
      ** Used to store screen input for each level
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D TABFRQ          S              1    DIM(13) CTDATA PERRCD(13)
      *COPY ZSRSRC,ZDATE2Z1                                                                 MD055265
      /COPY ZSRSRC,ZDATE2Z1LE                                                               MD055265
     D****************************************************************
     D D@BRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      * LF/SDBRCHL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     D D@GELR        E DS                  EXTNAME(SDGELRPD)
      *
      * LF/SDGELRL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     D D@USER        E DS                  EXTNAME(MUSERDD)
      *
      * LF/MUSER ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                    092597
      *                                                                   092597
      * LF/SDMMODL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE           092597
      *                                                                   092597
     D***********D@REPT    E DSFCREPTPD                                   S01407
     D***********                                                         S01407
      **LF/FCREPTL1*ACCESS*PROGRAM*RECORD*FORMAT*DATA*STRUCTURE           S01407
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D*
     D* DATASTRUCTURE FOR USE BY ACCESS PROGRAMS WITH 200 LONG DATA BUFFER
     D*
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01486
     D*                                                                   S01486
     D* DATASTRUCTURE FOR USE BY ACCESS PROGRAMS WITH 800 LONG DATA BUFFERS01486
     D*                                                                   S01486
     D                 DS                                                       S01486
     D  SINP                   1      5                                         S01486
     D                                     DIM(5)
     D  SBRCH                  1      1                                         S01486
     D  SCOMP                  2      2                                         S01486
     D  SSYST                  3      3                                         S01486
     D  SACOF                  4      4                                         S01486
     D  SDEPT                  5      5                                         S01486
     D RUNDAT          DS
     D*
      ** DATA AREA OF BANK DETAILS
     D*
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
     D*                                                                   S01407
     D LDA             DS           256                                         S01407
     D*                                                                   S01407
     D** LOCAL DATA AREA FOR DATABASE ERROR REPORTING                     S01407
     D*                                                                   S01407
     D  DBFILE               134    141                                         S01407
     D  DBKEY                142    170                                         S01407
     D  DBPGM                171    180                                         S01407
     D  DBASE                181    183  0                                      S01407
     D*
     D PSDS           SDS
     D*
     D** PROGRAM STATUS DATA STRUCTURE FOR USER ETC.
     D*
     D  JBNM                 244    253
     D  JUSR                 254    263
     D  JBNB                 264    269
      *
     D                 DS                                                       127043
     D  WPFDT                  1      6                                         127043
     D  WA                     1      1                                         127043
     D  WB                     2      2                                         127043
     D  WC                     3      3                                         127043
     D  WD                     4      4                                         127043
     D  WE                     5      5                                         127043
     D  WF                     6      6                                         127043
     D*                                                                   127043
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                    S01486
      *  LF/SDPORTL1 access program record format data structure.         S01486
     D*                                                                   S01486
     D SDACOF        E DS                  EXTNAME(SDACOFPD)                    S01486
      ** Access Object for Account Officer File.                          S01486
      *                                                                   S01486
     D SDDEPT        E DS                  EXTNAME(SDDEPTPD)                    S01486
      ** Access Object for Department Code File                           S01486
     D FCRCOM        E DS                  EXTNAME(FCRCOJW1)                                MD055265
     D**XSARD***     E                     EXTFLD(SARD)                            MD055265 MD055681
     D  XSARN        E                     EXTFLD(SARN)                                     MD055681
     D  XENABLD      E                     EXTFLD(ENABLD)                                   MD055681
     D*NullInds*       s              5i 0 dim(12)                                 MD055265 MD055681
     D NullInds        s              5i 0 dim(13)                                          MD055681
     D FCREPT        E DS                  EXTNAME(FCREPJW1)                                MD055265
     D*NullInds2       s              5i 0 dim(19)                                 MD055265 MD055681
     D NullInds2       s              5i 0 dim(20)                                          MD055681
     C                   MOVEA     CPY@          BIS@             80
     C*
     C** INPUT PARAMETERS
     C*
      **  Report Name
      **  Periodic Sequence Number
      **  CL Program name
      **  CL Sequence
      **  Periodic Description
      **  User Id for Request
      **  Frequency
      **  Frequency Day No.
      **  First Date
      **  Level
      **  Entity
      **  Distrubution Required
      **  Authorised to bank level reports         }
      **  Authorised to Multiple-branch reports    }  User of current job
      **  Authorised to other user's               }
      **  Default branch                           }
      **  Action
      **  Code
      **  Default Output Id
      **  Midas/Q
      **  Transaction Number of last update
      **
     C     *ENTRY        PLIST
     C                   PARM                    SRNAM
     C                   PARM                    SPSQN
     C                   PARM                    SCOTT
     C                   PARM                    SCSEQ
     C                   PARM                    SPDSC
     C                   PARM                    SUSRR
     C                   PARM                    SFREQ
     C                   PARM                    FDAY              2
     C                   PARM                    PFDT
     C                   PARM                    LVL
     C                   PARM                    SETTY
     C                   PARM                    SDRQD
     C                   PARM                    UBANK
     C                   PARM                    UMBREP
     C                   PARM                    UMUREP
     C                   PARM                    UDBRN
     C                   PARM                    ACTN              1
     C                   PARM                    CODE              1
     C                   PARM                    DFTO
     C                   PARM                    MIDQ
     C                   PARM                    TNLU
     C*                                                                   S01407
     C     *DTAARA       DEFINE                  LDA                                           S0140
     C*
      **  INITIALISE PROGRAM
     C*
     C                   EXSR      INIT
     C*
      **  DETERMINE FIRST SCREEN - KEY SCREEN FOR INSERTION
      **  IF FIRST CALL FOR THIS RECORD
     C*
     C     ACTN          IFEQ      'I'
     C     CODE          ANDNE     'F'
     C                   MOVE      'Y'           KEYF              1
     C                   END
     C*
      **  IF RETURN TO THIS PROGRAM FROM MODULE PROMPT, DETERMINE SCREEN
     C*
     C     CODE          IFEQ      'F'
     C*
      **     Single branch system
      **     or user not authorised to multiple branches
     C*
     C     MBIN          IFEQ      'N'
     C     UMBREP        OREQ      'N'
     C*
      **     or report not available at branch/company level
     C*
     C     DXBLVL        OREQ      'N'
     C     DXCLVL        ANDEQ     'N'
     C     DXALVL        ANDEQ     'N'                                                         S0148
     C     DXDLVL        ANDEQ     'N'                                                         S0148
     C*
      **     display main screen
     C*
     C                   MOVE      'Y'           MAINF             1
     C                   ELSE
     C*
      **     Otherwise display branch prompt screen
     C*
     C                   MOVE      'Y'           BRPMTF
     C                   END
     C*
     C                   END
     C*
      **     If not a return from further screens, and action is not
      **     insert, display main screen
     C*
     C     ACTN          IFNE      'I'
     C     CODE          ANDNE     'F'
     C                   MOVE      'Y'           MAINF             1
     C                   END
     C*
     C**  DISPLAY SCREENS UNTIL EXIT REQUIRED
     C*
     C     *IN03         DOWEQ     '0'
     C*
      **  PROCESS KEY SCREEN IF INSERT
     C*
     C     KEYF          IFEQ      'Y'
     C                   EXSR      KEY
     C                   END
     C*
      **  PROCESS MAIN SCREEN
     C*
     C     MAINF         IFEQ      'Y'
     C                   EXSR      MAIN
     C                   END
     C*
      **  PROCESS BRANCH PROMPT SCREEN IF AVAILABLE:
     C*
     C     BRPMTF        IFEQ      'Y'
     C                   EXSR      BRPMT
     C                   END
     C*
     C                   END
     C*
     C**         Update parameter list from screen defaults
     C*
     C     SBRCH         IFEQ      'Y'
     C                   MOVE      'B'           LVL
     C                   END
     C     SCOMP         IFEQ      'Y'
     C                   MOVE      'C'           LVL
     C                   END
      *                                                                   S01486
      ** Account Officer Level available.                                 S01486
     C     SACOF         IFEQ      'Y'                                                         S0148
     C                   MOVE      'A'           LVL                                           S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      ** Department Level available.                                      S01486
     C     SDEPT         IFEQ      'Y'                                                         S0148
     C                   MOVE      'D'           LVL                                           S0148
     C                   END                                                                   S0148
      *                                                                   S01486
     C     SSYST         IFEQ      'Y'
     C                   MOVE      'S'           LVL
     C                   MOVE      *BLANKS       SETTY                                         04865
     C                   END
     C*
     C*
      **  EXIT PROGRAM AT END OF CYCLE
     C*
     C                   SETON                                        LR
     C*
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R BRPMT - TO PROCESS BRANCH PROMPT SCREEN
     C*  CALLED FROM MAIN PROCESSING
     C*  CALLS
     C*
     C********************************************************************
     C*
     C     BRPMT         BEGSR
     C*
      **  Write main detail screen, and set to invalid on first pass
     C*
     C                   CALL      'ZA0250'
      ** Set up message - Authorisation to this report is not allowed.    S01486
     C     *IN56         IFEQ      *ON                                                         S0148
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1089'     MSGID                                         S0148
     C                   MOVE      *OFF          *IN56                                         S0148
     C                   END                                                                   S0148
     C                   WRITE     FC0210C1
     C                   EXFMT     FC0210F2
     C                   SETON                                        70
     C*
      **  Process Main detail screen until valid, or exit requested
     C*
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C     *IN70         ANDEQ     '1'
     C     *IN52         ANDEQ     '0'                                                         LN034
     C*
     C                   SETOFF                                       70
     C                   SETOFF                                       313233                   S0148
     C                   SETOFF                                       345354                   S0148
     C*
     C                   CALL      'ZA0250'
     C*
      **  EXECUTE BRANCH VALIDATION
     C*
     C     SBRCH         IFNE      'Y'
     C     SBRCH         ANDNE     *BLANKS
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0024' MSGID                           LN1186
     C                   PARM      'RCF1024'     MSGID                                         LN118
     C                   SETON                                        3170
     C                   END
     C*
      **  EXECUTE COMPANY VALIDATION
     C*
     C     SCOMP         IFNE      'Y'
     C     SCOMP         ANDNE     *BLANKS
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0024' MSGID                           LN1186
     C                   PARM      'RCF1024'     MSGID                                         LN118
     C                   SETON                                        3270
     C                   END
     C*
      **  EXECUTE SYSTEM VALIDATION
     C*
     C     SSYST         IFNE      'Y'
     C     SSYST         ANDNE     *BLANKS
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0024' MSGID                           LN1186
     C                   PARM      'RCF1024'     MSGID                                         LN118
     C                   SETON                                        3370
     C                   END
      *                                                                   S01486
      **  Execute Account Officer validation.                             S01486
      *                                                                   S01486
     C     SACOF         IFNE      'Y'                                                         S0148
     C     SACOF         ANDNE     *BLANKS                                                     S0148
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1024'     MSGID                                         S0148
     C                   SETON                                        5370                     S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      **  Execute Department validation.                                  S01486
      *                                                                   S01486
     C     SDEPT         IFNE      'Y'                                                         S0148
     C     SDEPT         ANDNE     *BLANKS                                                     S0148
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1024'     MSGID                                         S0148
     C                   SETON                                        5470                     S0148
     C                   END                                                                   S0148
     C*
      **  ONLY ONE OF BRANCH, COMPANY AND SYSTEM MAY BE NON BLANK.
     C*
     C***********SBRCH     IFNE *BLANKS                                   S01486
     C***********SCOMP     ANDNE*BLANKS                                   S01486
     C***********SBRCH     ORNE *BLANKS                                   S01486
     C***********SSYST     ANDNE*BLANKS                                   S01486
     C***********SSYST     ORNE *BLANKS                                   S01486
     C***********SCOMP     ANDNE*BLANKS                                   S01486
      ** Perform a LOKUP routine twice to determine the number of 'Y'     S01486
      ** entered. If two are found then output an error.                  S01486
      *                                                                   S01486
     C                   Z-ADD     1             I                 2 0                         S0148
     C     'Y'           LOOKUP    SINP(I)                                55                   S0148
      *                                                                   S01486
      ** A 'Y' has been found.                                            S01486
     C     *IN55         IFEQ      *ON                                                         S0148
     C     I             ANDNE     5                                                           S0148
     C                   ADD       1             I                                             S0148
     C     'Y'           LOOKUP    SINP(I)                                55                   S0148
      *                                                                   S01486
      ** A second 'Y' has been found; hence error.                        S01486
     C     *IN55         IFEQ      *ON                                                         S0148
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0025' MSGID                           LN1186
     C                   PARM      'RCF1025'     MSGID                                         LN118
     C                   SETON                                        313233
     C                   SETON                                        5354                     S0148
     C                   SETON                                        70
     C                   END
     C                   END                                                                   S0148
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
     C                   SETON                                        5354                     S0148
     C                   SETON                                        70
     C                   END
     C*
      **  IF BRANCH IS 'Y' AND ENTITY IS BLANK SCREEN IS INVALID.
     C*
     C     SBRCH         IFEQ      'Y'
     C     SETTY         ANDEQ     *BLANK
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0026' MSGID                           LN1186
     C                   PARM      'RCF1026'     MSGID                                         LN118
     C                   SETON                                        3470
     C                   END
     C*
      **  IF COMPANY IS 'Y' AND ENTITY IS BLANK SCREEN IS INVALID.
     C*
     C     SCOMP         IFEQ      'Y'
     C     SETTY         ANDEQ     *BLANK
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0026' MSGID                           LN1186
     C                   PARM      'RCF1026'     MSGID                                         LN118
     C                   SETON                                        3470
     C                   END
     C*
      **  IF SYSTEM IS 'Y' AND ENTITY IS NOT BLANK SCREEN IS INVALID.
     C*
     C     SSYST         IFEQ      'Y'
     C     SETTY         ANDNE     *BLANK
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0027' MSGID                           LN1186
     C                   PARM      'RCF1027'     MSGID                                         LN118
     C                   SETON                                        3470
     C                   END
      *                                                                   S01486
      ** If Account Officer is 'Y' and Entity is blank,                   S01486
      ** screen is invalid.                                               S01486
      *                                                                   S01486
     C     SACOF         IFEQ      'Y'                                                         S0148
     C     SETTY         ANDEQ     *BLANK                                                      S0148
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1026'     MSGID                                         S0148
     C                   SETON                                        3470                     S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      ** If Department is 'Y' and Entity is blank, screen is invalid.     S01486
      *                                                                   S01486
     C     SDEPT         IFEQ      'Y'                                                         S0148
     C     SETTY         ANDEQ     *BLANK                                                      S0148
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1026'     MSGID                                         S0148
     C                   SETON                                        3470                     S0148
     C                   END                                                                   S0148
     C*
      **  VALIDATE BRANCH FOR THE CURRENT USER.
     C*
     C     SBRCH         IFEQ      'Y'
     C     SETTY         ANDNE     *BLANK
     C     SETTY         ANDNE     'ALL'
      *                                                                   187977
      ** Validate the inserted branch                                     187977
      *                                                                   187977
     C**********           CALL 'AOBRCHR0'                                187977              CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANK        P@APRC                                        18797
     C                   PARM      '*KEY'        P@APOP                                        18797
     C                   PARM      SETTY         DBRN                                          18797
     C********** D@BRCH    PARM D@BRCH    DSFDY                           187977              CGL029
     C     D@BRCH        PARM      D@BRCH        DSSDY
      *                                                                   187977
      ** If return code is not blank, branch code is invalid              187977
      *                                                                   187977
     C     P@APRC        IFNE      *BLANK                                                      18797
     C                   CALL      'FCC0240'                                                   18797
     C                   PARM      'RCF1028'     MSGID                                         18797
     C                   MOVE      '1'           *IN34                                         18797
     C                   MOVE      '1'           *IN70                                         18797
     C                   ELSE                                                                  18797
      *                                                                   187977
      ** Valid branch - check user's authority for branch                 187977
      *                                                                   187977
     C*
      **  IF BOOKING BRANCH.
     C*
     C     D3BRTP        IFEQ      'B'
     C                   CALL      'ZVBBU'
     C                   PARM                    SETTY             3            BRANCH.
     C                   PARM                    ERO               1 0          RTRN CODE.
     C*
      **  IF ORIGINATING BRANCH.
     C*
     C                   ELSE
      *                                                                   187977
      ** Originating branch validation must be made if Originating        187977
      ** Branch/User Validation Required field is 'Y' from General        187977
      ** Ledger ICD.                                                      187977
      *                                                                   187977
     C     BKOBUV        IFEQ      'Y'                                                         18797
     C                   CALL      'ZVOBU'
     C                   PARM                    SETTY             3            BRANCH.
     C                   PARM                    ERO               1 0          RTRN CODE.
     C                   ENDIF                                                                 18797
     C                   END
     C*
      **  IF BRANCH IS INVALID SEND ERROR MESSAGE TO SCREEN.
     C*
     C     ERO           IFNE      0
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0028' MSGID                           LN1186
     C**********           PARM 'RCF1028' MSGID                    LN1186 187977
     C                   PARM      'RCF1015'     MSGID                                         18797
     C                   SETON                                        3470
     C                   END
     C                   ENDIF                                                                 18797
     C                   END
     C*
      **  VALIDATE COMPANY FOR THE CURRENT USER.
     C*
     C     SCOMP         IFEQ      'Y'
     C     SETTY         ANDNE     *BLANK
     C     SETTY         ANDNE     'ALL'
     C                   CALL      'ZVCOU'
     C                   PARM                    SETTY             3            BRANCH.
     C                   PARM                    ERO               1 0          RTRN CODE.
     C*
      **  IF COMPANY IS INVALID SEND ERROR MESSAGE TO SCREEN
     C*
     C     ERO           IFNE      0
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0029' MSGID                           LN1186
     C                   PARM      'RCF1029'     MSGID                                         LN118
     C                   SETON                                        3470
     C                   END
     C                   END
      *                                                                   S01486
      ** Validate the Entity if non blank and                             S01486
      ** and the Screen Account Officer is 'Y'                            S01486
      *                                                                   S01486
     C     SACOF         IFEQ      'Y'                                                         S0148
     C     SETTY         ANDNE     *BLANKS                                                     S0148
     C                   MOVEL     SETTY         @ACOF             2                           S0148
      *                                                                   S01486
      ** Error if invalid Account Officer code                            S01486
     C     SETTY         IFNE      'ALL'                                                       S0148
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
     C                   MOVE      *ON           *IN70                                         S0148
     C                   ELSE                                                                  S0148
      *                                                                   S01486
      ** Not authorised when Screen Entity not equal to MUSER ACOF.       S01486
     C***********ACOF      IFNE 'ALL'                               S01486083547
     C***********ACOF      ANDNE*BLANKS                             S01486083547
     C     ACFA          IFNE      'ALL'                                                       08354
     C     ACFA          ANDNE     *BLANKS                                                     08354
     C     FCHLVS        ANDEQ     'Y'                                                         S0148
     C***********SETTY     IFNE ACOF                                S01486083547
     C     SETTY         IFNE      ACFA                                                        08354
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1092'     MSGID                                         S0148
     C                   MOVE      *ON           *IN70                                         S0148
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
     C                   MOVE      *ON           *IN70                                         S0148
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
     C                   MOVE      *ON           *IN70                                         S0148
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
     C                   MOVE      *ON           *IN70                                         S0148
     C                   ELSE                                                                  S0148
      *                                                                   S01486
      ** Not authorised when Screen Entity not equal to MUSER DPPT.       S01486
     C     DPPT          IFNE      'ALL'                                                       S0148
     C     DPPT          ANDNE     *BLANKS                                                     S0148
     C     FCHLVS        ANDEQ     'Y'                                                         S0148
     C     SETTY         IFNE      DPPT                                                        S0148
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1092'     MSGID                                         S0148
     C                   MOVE      *ON           *IN70                                         S0148
     C                   END                                                                   S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      ** Validate for blank MUSER Department code.                        S01486
     C     DPPT          IFEQ      *BLANKS                                                     S0148
     C***********ACOF      ANDNE'ALL'                               S01486083547
     C     ACFA          ANDNE     'ALL'                                                       08354
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1092'     MSGID                                         S0148
     C                   MOVE      *ON           *IN70                                         S0148
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
     C                   MOVE      *ON           *IN70                                         S0148
     C                   END                                                                   S0148
      *                                                                   S01486
     C                   END                                                    Entity         S0148
      *                                                                   S01486
     C*
     C**  IF ENTITY ID 'ALL', USER MUST BE AUTHORISED TO BANK LEVEL
     C*
     C     SETTY         IFEQ      'ALL'
     C     UBANK         ANDEQ     'N'
     C     SACOF         ANDNE     'Y'                                                         S0148
     C     SDEPT         ANDNE     'Y'                                                         S0148
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0065' MSGID                           LN1186
     C                   PARM      'RCF1065'     MSGID                                         LN118
     C                   SETON                                        3470
     C                   END
     C*
      **  IF ENTITY IS NOT 'ALL' AND DISTRIBUTION IS 'Y' SCREEN
      **  IS INVALID.
     C*
     C     SETTY         IFNE      'ALL'
     C     SDRQD         ANDEQ     'Y'
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0030' MSGID                           LN1186
     C                   PARM      'RCF1030'     MSGID                                         LN118
     C                   SETON                                        3570
     C                   END
     C*
      **  IF DISTRIBUTION IS NOT 'Y' OR 'N' SCREEN IS INVALID.
     C*
     C     SDRQD         IFNE      'Y'
     C     SDRQD         ANDNE     'N'
     C     SDRQD         ANDNE     *BLANK
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0031' MSGID                           LN1186
     C                   PARM      'RCF1031'     MSGID                                         LN118
     C                   SETON                                        3570
     C                   END
     C*
      **  IF DISTRIBUTION IS BLANK SET TO N.
     C*
     C     SDRQD         IFEQ      *BLANKS
     C                   MOVE      'N'           SDRQD
     C                   END
     C*
     C   70              WRITE     FC0210C1
     C   70              EXFMT     FC0210F2
     C                   END
     C*
      **  If command 3 taken, exit function
     C*
     C     *IN03         IFEQ      '1'
     C                   MOVE      'E'           CODE
     C                   MOVE      'T'           ACTN
     C                   END
     C*
      **  If delete has been requested, set code to 'D' so no further
      **  screens will be displayed to the user
     C*
     C     *IN10         IFEQ      '1'
     C                   SETON                                        03
     C                   MOVE      'D'           CODE
     C                   END
     C*
      **  If screen is valid, set to exit program
     C*
      **  If previous screen requested, return to main
     C*
     C     *IN12         IFEQ      '1'
     C                   MOVE      'Y'           MAINF
     C                   MOVE      'N'           BRPMTF            1
     C                   END
     C*
      **  If screen valid, return to calling program
     C*
     C     *IN03         IFEQ      '0'
     C     *IN12         ANDEQ     '0'
     C                   SETON                                        03
     C                   MOVE      *BLANK        CODE
     C                   END
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R MAIN - TO PROCESS DETAIL SCREEN
     C*  CALLED FROM MAIN PROCESSING
     C***CALLS*ZDATE1***************                                      LN0826
     C*  CALLS ZDATE1, ZDATE2                                             LN0826
     C*
     C********************************************************************
     C*
     C     MAIN          BEGSR
     C*
      **  Write main detail screen, and set to invalid on first pass
     C*
     C                   CALL      'ZA0250'
     C                   WRITE     FC0210C1
     C                   EXFMT     FC0210F0
     C                   SETON                                        70
     C*
      **  Process Main detail screen until valid, or exit requested
     C*
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C     *IN70         ANDEQ     '1'
     C*
     C                   SETOFF                                       704344
     C***********          SETOF                     454647               BHF710
     C***********          SETOF                     48                   BHF710
     C                   SETOFF                                       464748                   BHF71
     C*
     C                   CALL      'ZA0250'
     C*                                                                   134289
     C     ACTN          IFNE      'D'                                                         13428
     C     ACTN          ANDNE     'E'                                                         13428
     C*
      **  COMPONENT NAME/SEQUENCE NUMBER
     C*
     C     RCOMK         KLIST
     C                   KFLD                    SRNAM
     C                   KFLD                    SCOTT
     C                   KFLD                    SCSEQ
     C*
     C***********                                                         BHF710
     C***********SCOTT     IFEQ *BLANK                                    BHF710
     C***********SCSEQ     OREQ *BLANK                                    BHF710
     C***********          SETON                     4570                 BHF710
     C***********          CALL 'FCC0240'                                 BHF710
     C***********          PARM 'RCF0057' MSGID                           BHF710
     C***********          END                                            BHF710
     C***********                                                         BHF710
      ***Select*Report Components - Report Components  *                  BHF710
     C***********                                                         BHF710
     C***********SCOTT     IFEQ '?'                                       BHF710
     C***********SCSEQ     OREQ '?'                                       BHF710
     C***********                                                         BHF710
     C***********          CALL 'FC0302S'                                 BHF710
     C***********          PARM *BLANK    W0RTN   7                       BHF710
     C***********          PARM SRNAM     WQ0006 10                       BHF710
     C***********SCOTT     PARM *BLANK    WQ0007 10                       BHF710
     C***********SCSEQ     PARM *BLANK    WQ0008  5                       BHF710
     C***********                                                         BHF710
     C***********W0RTN     IFEQ 'PREVSCN'                                 BHF710
     C***********          SETON                     4570                 BHF710
     C***********          CALL 'FCC0240'                                 BHF710
     C***********          PARM 'RCF0059' MSGID                           BHF710
     C***********          END                                            BHF710
     C***********                                                         BHF710
     C***********W0RTN     IFEQ 'Y2U9999'                                 BHF710
     C***********          SETON                     03                   BHF710
     C***********          GOTO EXIT                                      BHF710
     C***********          END                                            BHF710
     C***********                                                         BHF710
     C***********          END                                            BHF710
     C*
     C                   SETOFF                                       79
     C*
     C***********SCOTT     IFNE *BLANK                                    BHF710
     C***********SCSEQ     ANDNE*BLANK                                    BHF710
     C***********SCOTT     ANDNE'?'                                       BHF710
     C***********SCSEQ     ANDNE'?'                                       BHF710
     C***********RCOMK     CHAINFCRCOML1             79             BHF710S01407
     C*****RCOMK         CHAIN     FCRCOMJ1                           79              S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCRCOM :NullInds                                                              MD055265
     C+ from FCRCOJW1                                                                       MD055265
     C+ where D3RNAM = :SRNAM and D3COTT = :SCOTT and D3CSEQ = :SCSEQ                       MD055265
     C/END-EXEC                                                                             MD055265
     C***********          END                                            BHF710
     C*
     C******IN79         IFEQ      '1'                                                      MD055265
     C*****D3MORQ        OREQ      'M'
     C                   IF        SQLCODE = 100                                            MD055265
     C                             or D3MORQ = 'M'                                          MD055265
     C                   SETON                                        4570
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0058' MSGID                           LN1186
     C                   PARM      'RCF1058'     MSGID                                         LN118
     C                   END
     C*
      **  USER NAME FOR REQUEST
     C*
     C     UMUREP        IFEQ      'Y'
     C     SUSRR         ANDNE     JUSR
     C*
     C                   CALL      'AOUSERR0'
     C                   PARM      *BLANK        P@APRC
     C                   PARM      '*VERIFY'     P@APOP
     C                   PARM      SUSRR         P@USER           10
     C***********D@USER    PARM D@USER    DSFDY                           087380
     C     D@USER        PARM      D@USER        DSSDY                                         08738
     C*
     C     P@APRC        IFNE      *BLANK
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0013' MSGID                           LN1186
     C                   PARM      'RCF1013'     MSGID                                         LN118
     C                   SETON                                        4370
     C                   END
     C*
     C                   END
     C*
      **  REQUEST DESCRIPTION
     C*
     C     SPDSC         IFEQ      *BLANK
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0049' MSGID                           LN1186
     C                   PARM      'RCF1049'     MSGID                                         LN118
     C                   SETON                                        4470
     C                   END
     C*
      **  FREQUENCY
     C*
     C     SFREQ         LOOKUP    TABFRQ                                 63
     C     *IN63         IFEQ      '0'
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0051' MSGID                           LN1186
     C                   PARM      'RCF1051'     MSGID                                         LN118
     C                   SETON                                        4670
     C                   END
     C*
     C     SFREQ         IFEQ      'A'
     C     BKAPFQ        ANDEQ     'D'
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0067' MSGID                           LN1186
     C                   PARM      'RCF1067'     MSGID                                         LN118
     C                   SETON                                        4670
     C                   END
     C*
      **  FREQUENCY DAY NUMBER
     C*
     C     SFDAY         IFEQ      *BLANK
     C*
     C     SFREQ         IFEQ      'M'
     C     SFREQ         OREQ      'Q'
     C     SFREQ         OREQ      'Y'
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0052' MSGID                           LN1186
     C                   PARM      'RCF1052'     MSGID                                         LN118
     C                   SETON                                        4770
     C                   END
     C*
     C                   END
      *
     C     SFDAY         IFNE      *BLANK
     C     SFREQ         ANDNE     'M'
     C     SFREQ         ANDNE     'Q'
     C     SFREQ         ANDNE     'Y'
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0053' MSGID                           LN1186
     C                   PARM      'RCF1053'     MSGID                                         LN118
     C                   SETON                                        4770
     C                   END
     C*
     C     SFDAY         IFNE      *BLANK
     C     *IN47         ANDEQ     '0'
     C*********************MOVE '0'       WRK3A   3                       LN0714
     C*********************MOVELSFDAY     WRK3A                           LN0714
     C*********************TESTN          WRK3A      6363                 LN0714
     C                   MOVE      *BLANKS       W0RTN             7                           BHF71
     C                   CALL      'ZALIGN'                                                    LN071
     C     W0RTN         PARM      W0RTN         UPARM1            7                           LN071
     C                   PARM      SFDAY         UPARM2           16                           LN071
     C                   PARM      *ZERO         UPARM3            1 0                         LN071
     C                   PARM      2             UPARM4            2 0                         LN071
     C                   PARM      *BLANK        UPARM5           16                           LN071
     C*
     C************IN63*****IFEQ '0'                                       LN0714
     C***********SFDAY*****ORGT '31'                                      LN0714
     C***********SFDAY*****ORLT ' 1'                                      LN0714
     C     W0RTN         IFEQ      '*ERROR*'                                                   LN071
     C                   SETON                                        4770                     LN071
     C                   CALL      'FCC0240'                                                   LN071
     C***********          PARM 'RCF0054' MSGID                    LN0714 LN1186
     C                   PARM      'RCF1054'     MSGID                                         LN118
     C                   ELSE                                                                  LN071
     C                   MOVE      UPARM5        SFDAN             2 0                         LN071
     C     SFDAN         IFGT      31                                                          LN071
     C     SFDAN         ORLT      1                                                           LN071
     C                   SETON                                        4770
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0054' MSGID                           LN1186
     C                   PARM      'RCF1054'     MSGID                                         LN118
     C                   END                                                                   LN071
     C                   MOVE      UPARM2        SFDAY                                         LN071
     C                   END
     C*
     C                   END
     C*
      **  IF NO ERROR, UPDATE OUTPUT FIELD
     C*
     C     *IN47         IFEQ      '0'
     C     SFDAY         IFNE      *BLANK
     C                   MOVE      SFDAY         FDAY
     C                   ELSE
     C                   MOVE      *ZEROS        FDAY
     C                   END
     C                   END
     C*
      **  FIRST DATE
     C*                                                                   LN0826
     C**  DEFAULT TO RUNDATE IF BLANK                                     LN0826
     C*                                                                   LN0826
     C     SPFDT         IFEQ      *BLANK                                                      LN082
      *                                                                   LN0826
      **  Convert first date to number. Protect if after run date         LN0826
      *                                                                   LN0826
     C                   Z-ADD     RUND          ZDAYNO                                        LN082
     C                   EXSR      ZDATE2                                                      LN082
     C                   MOVE      ZDATE         SPFDT                                         LN082
     C                   MOVE      '1'           *IN70                                         LN082
     C     D9PFDT        COMP      RUND                                 50                     LN082
     C                   END                                                                   LN082
     C*                                                                   127043
     C** Any one of the characters must not be left blank.                127043
     C*                                                                   127043
     C     SPFDT         IFNE      *BLANK                                                      12704
     C                   MOVE      SPFDT         WPFDT                                         12704
     C     WA            IFEQ      ' '                                                         12704
     C     WB            OREQ      ' '                                                         12704
     C     WC            OREQ      ' '                                                         12704
     C     WD            OREQ      ' '                                                         12704
     C     WE            OREQ      ' '                                                         12704
     C     WF            OREQ      ' '                                                         12704
     C                   SETON                                        4870                     12704
     C                   CALL      'FCC0240'                                                   12704
     C                   PARM      'RCF1056'     MSGID                                         12704
     C                   END                                                                   12704
     C                   END                                                                   12704
     C*
      **  Validate only if last date is not displayed - validate via ZDATE1
     C*
     C     *IN49         IFEQ      '0'
     C     *IN52         ANDEQ     '0'                                                         LN034
     C                   MOVE      SPFDT         ZDATE
     C                   EXSR      ZDATE1
     C*
      **  If valid date, check against run date
     C*
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     ZDAYNO        PFDT
     C*
     C     PFDT          IFLT      RUND
     C                   SETON                                        4870
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0055' MSGID   7                       LN1186
     C                   PARM      'RCF1055'     MSGID             7                           LN118
     C                   END
     C*
      **  If date is not valid via ZDATE1, send error message
     C*
     C                   ELSE
     C                   SETON                                        4870
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0056' MSGID                           LN1186
     C                   PARM      'RCF1056'     MSGID                                         LN118
     C                   END
     C*
     C                   END
     C*
     C   70              WRITE     FC0210C1
     C   70              EXFMT     FC0210F0
     C                   END                                                                   13428
     C                   END
     C*
     C     EXIT          TAG                                                    **** EXIT ****
     C*
      **  If command 3 taken, exit function
     C*
     C     *IN03         IFEQ      '1'
     C                   MOVE      'E'           CODE
     C                   MOVE      'T'           ACTN
     C                   END
     C*
      **  If delete has been requested, set code to 'D' so no further
      **  screens will be displayed to the user
     C*
     C     *IN10         IFEQ      '1'
     C                   SETON                                        03
     C                   MOVE      'D'           CODE
     C                   END
     C*
      **  If command 12 taken, and no previous screens exit program
     C*
     C     *IN12         IFEQ      '1'
     C*
     C     ACTN          IFEQ      'I'
     C                   MOVE      'Y'           KEYF
     C                   MOVE      'N'           MAINF
     C                   ELSE
     C                   MOVE      'P'           CODE
     C                   SETON                                        03
     C                   END
     C*
     C                   END
     C*
      **  If exit not requested and no further screens set to exit program:
      **  If branch prompt is not required, exit program
      **     Return not requested
     C*
     C     *IN03         IFEQ      '0'
     C     *IN12         ANDEQ     '0'
     C*
      **     Single branch system
      **     or user not authorised to multiple branches
     C*
     C     MBIN          IFEQ      'N'
     C     UMBREP        OREQ      'N'
     C*
      **     or report not available at branch/company level
     C*
     C     DXBLVL        OREQ      'N'
     C     DXCLVL        ANDEQ     'N'
     C     DXALVL        ANDEQ     'N'                                                         S0148
     C     DXDLVL        ANDEQ     'N'                                                         S0148
     C*
      **     exit program
     C*
     C                   SETON                                        03
     C                   MOVE      *BLANK        CODE
     C                   ELSE
     C                   MOVE      'Y'           BRPMTF
     C                   MOVE      'N'           MAINF
     C                   END
     C*
     C                   END
     C*
     C                   ENDSR
     C*
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R KEY - TO PROCESS KEY SCREEN
     C*  CALLED FROM MAIN PROCESSING
     C*
     C********************************************************************
     C*
     C     KEY           BEGSR
     C*
      **  Set on screen invalid indicator for first pass, write key screen
     C*
     C                   WRITE     FC0210C1
     C                   CALL      'ZA0250'
     C                   SETON                                        70
     C                   SETOFF                                       12
     C                   EXFMT     FC0210F1
     C*
      **  Do while exit is not requested, and screen is invalid
     C*
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C     *IN70         ANDEQ     '1'
     C*
      **  Initialise message subfile and error indicators
     C*
     C                   CALL      'ZA0250'
     C                   SETOFF                                       7040
     C*
      **  Sequence number cannot be left blank
     C*
     C     SPSQN         IFEQ      *BLANK
     C                   SETON                                        4070
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0046' MSGID                           LN1186
     C                   PARM      'RCF1046'     MSGID                                         LN118
     C                   ELSE
     C*
      **  Sequence number must be numeric
     C*
     C*********************MOVE '0'       WRK3A   3                       LN0714
     C*********************MOVELSPSQN     WRK3A                           LN0714
     C*********************TESTN          WRK3A      63                   LN0714
     C                   CALL      'ZALIGN'                                                    LN071
     C     W0RTN         PARM      W0RTN         UPARM1                                        LN071
     C                   PARM      SPSQN         UPARM2                                        LN071
     C                   PARM      *ZERO         UPARM3                                        LN071
     C                   PARM      2             UPARM4                                        LN071
     C                   PARM      *BLANK        UPARM5                                        LN071
     C*                                                                   LN0714
     C************IN63*****IFEQ '0'                                       LN0714
     C     W0RTN         IFNE      *BLANK                                                      LN071
     C     SPSQN         OREQ      *ZEROS
     C                   SETON                                        4070
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0047' MSGID                           LN1186
     C                   PARM      'RCF1047'     MSGID                                         LN118
     C                   ELSE                                                                  LN071
     C                   MOVE      UPARM2        SPSQN                                         LN071
     C                   END
     C*
     C                   END
     C*
      **  If a valid sequence number is entered, must not already
      **  reference a record on periodic requests file
     C*
     C     *IN40         IFEQ      '0'
     C*
     C     PREQK         CHAIN     FCPREQL1                           78
     C*
      **  Send error message if chain is successful
     C*
     C     *IN78         IFEQ      '0'
     C     ACTN          ANDEQ     'I'
     C                   SETON                                        4070
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0048' MSGID                           LN1186
     C                   PARM      'RCF1048'     MSGID                                         LN118
     C                   END
     C*
     C                   END
     C*
     C   70              WRITE     FC0210C1
     C   70              EXFMT     FC0210F1
     C*
     C                   END
     C*
      **  If command 3 taken, exit function
     C*
     C     *IN03         IFEQ      '1'
     C                   MOVE      'E'           CODE
     C                   MOVE      'T'           ACTN
     C                   END
     C*
      **  If command 12 taken, exit program
     C*
     C     *IN12         IFEQ      '1'
     C                   MOVE      'P'           CODE
     C                   SETON                                        03
     C                   END
     C*
      **  If screen valid, display main
     C*
     C     *IN03         IFEQ      '0'
     C                   MOVE      'Y'           MAINF
     C                   MOVE      'N'           KEYF
     C                   END
      *
     C                   ENDSR
     C*
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R INIT- TO INITIALISE PROGRAM
     C*  CALLED FROM MAIN PROCESSING
     C*  CALLS ZDATE2, UPDOWS
     C*
     C********************************************************************
     C*
     C     INIT          BEGSR
     C*
     C     PREQK         KLIST
     C                   KFLD                    SRNAM
     C                   KFLD                    SPSQN
      *
     C     *LIKE         DEFINE    D9RNAM        P@RNAM
     C     *LIKE         DEFINE    D9PFDT        PFDT
     C     *LIKE         DEFINE    DXMIDQ        MIDQ
     C     *LIKE         DEFINE    D9LVL         LVL
     C     *LIKE         DEFINE    DXDFTO        DFTO
     C     *LIKE         DEFINE    D9TNLU        TNLU
     C     *LIKE         DEFINE    BANK          UBANK
     C     *LIKE         DEFINE    MBREP         UMBREP
     C     *LIKE         DEFINE    MUREP         UMUREP
     C     *LIKE         DEFINE    DBRN          UDBRN
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C     DATF          COMP      'M'                                    98
      *
      **  Access General Ledger Details for Accrual Frequency (M/D)
      *
     C**********           CALL 'AOGELRR0'                                                    CGL029
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANK        P@APRC            7
     C                   PARM      '*FIRST'      P@APOP            7
     C********** D@GELR    PARM D@GELR    DSFDY                                               CGL029
     C     D@GELR        PARM      D@GELR        DSSDY
      *
      **  Access Report Description for Periodically requested report
      *
     C***********          CALL 'AOREPTR0'                                S01407
     C***********          PARM '*DBERR'  P@APRC                          S01407
     C***********          PARM '*KEY'    P@APOP                          S01407
     C***********          PARM SRNAM     P@RNAM                          S01407
     C***********D@REPT    PARM D@REPT    DSFDY                           S01407
     C*                                                                   S01407
     C*****SRNAM         CHAIN     FCREPTJ0                           77              S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT :NullInds2                                                             MD055265
     C+ from FCREPJW1                                                                       MD055265
     C+ where DXRNAM = :SRNAM                                                               MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       77                    MD055265
     C                   If        SQLCODE = 100                                            MD055265
     C                   SETON                                        77                    MD055265
     C                   ENDIF                                                              MD055265
                                                                                            MD055265
     C     *IN77         IFEQ      '1'                                                         S0140
     C     *LOCK         IN        LDA                                                         S0140
     C                   MOVEL     'FC0210'      DBPGM                                         S0140
     C                   MOVEL     'FCREPTJ0'    DBFILE                                        S0140
     C                   MOVEL     SRNAM         DBKEY                          *************  S0140
     C                   Z-ADD     1             DBASE                          * DBERR 001 *  S0140
     C                   SETON                                        U7U8LR    *************  S0140
     C                   OUT       LDA                                                         S0140
     C                   EXSR      *PSSR                                                       S0140
     C                   END                                                                   S0140
      *
      **  Set up screen fields
      *
     C                   MOVE      JBNM          WSID
     C                   MOVE      DXRDSC        SRDSC
     C                   MOVE      DXRDSC        SPDSC
     C                   MOVEL     '*'           SPGMQ
     C                   SETON                                        60
     C*
     C**  Protect user Id if not authorised to multiple users
     C*
     C     UMUREP        COMP      'N'                                    39
     C*
     C**  Protect level fields which do not apply
     C*
     C     DXBLVL        COMP      'N'                                    38
     C     DXCLVL        COMP      'N'                                    36
     C     DXGLVL        COMP      'N'                                    37
      *                                                                   S01486
      ** Account Officer Level.                                           S01486
     C     DXALVL        IFEQ      'N'                                                         S0148
     C     MBIN          OREQ      'N'                                                         S0148
     C                   MOVE      *ON           *IN41                                         S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      ** Department Level.                                                S01486
     C     DXDLVL        IFEQ      'N'                                                         S0148
     C     MBIN          OREQ      'N'                                                         S0148
     C                   MOVE      *ON           *IN42                                         S0148
     C                   END                                                                   S0148
     C*
      **  Protect screen for enquire/delete
     C*
     C     ACTN          IFEQ      'D'
     C     ACTN          OREQ      'E'
     C                   SETON                                        52
     C                   END
     C*
      **  Enable delete
     C*
     C     ACTN          IFEQ      'D'
     C                   SETON                                        51
     C                   END
      *
      **  Set up output parameter from report descriptions - Std o/p Id
      *
     C                   MOVE      DXMIDQ        MIDQ
     C                   MOVE      DXDFTO        DFTO
      *
      **  Write sequence number to screen only if non-zero. Will be zero
      **  only if insert chosen and sequence number 99 has been used
      *
     C     SPSQN         IFEQ      *ZEROS
     C                   MOVE      *BLANKS       SPSQN
     C                   END
      *
      **  If action is not insert, and program has not been returned to,
      **  retrieve record from periodic requests
      *
     C     ACTN          IFNE      'I'
     C     CODE          ANDNE     'F'
     C     PREQK         CHAIN     FCPREQL1                           70
      *
      **  Load file- to screen-fields if record found
      *
     C     *IN70         IFEQ      '0'
     C                   MOVE      D9USRR        SUSRR
     C                   MOVE      D9PDSC        SPDSC
     C                   MOVE      D9FREQ        SFREQ
     C                   Z-ADD     D9TNLU        TNLU
     C                   Z-ADD     D9PFDT        PFDT                                          E2662
     C     D9FDAY        IFNE      0
     C                   MOVE      D9FDAY        SFDAY
     C                   END
     C                   MOVE      D9ETTY        SETTY
     C                   MOVE      D9DRQD        SDRQD
      *
      **  Convert first date to number. Protect if after run date
      *
     C                   Z-ADD     D9PFDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         SPFDT
     C     D9PFDT        COMP      RUND                                 50
      *
      **  Convert last date to screen field if present
      *
     C     D9LPDT        IFNE      *ZERO
     C                   Z-ADD     D9LPDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        SLADT
     C                   SETON                                        49
     C                   END
      *
      **  Set level for multibranch system
      *
     C     MBIN          IFEQ      'Y'
      *
      **  Set branch level field to 'Y' if report at branch level
      **  non-display field if branch level not available
      *
     C     D9LVL         IFEQ      'B'
     C                   MOVE      'Y'           SBRCH
     C                   END
      *
      **  Set company level field to 'Y' if report at company level
      **  non-display field if company level not available
      *
     C     D9LVL         IFEQ      'C'
     C                   MOVE      'Y'           SCOMP
     C                   END
      *
      **  Set system level field to 'Y' if report at system level
      **  non-display field if system level not available
      *
     C     D9LVL         IFEQ      'S'
     C                   MOVE      'Y'           SSYST
     C                   END
      *                                                                   S01486
      **  Set Account Officer level field to 'Y' if report at Account     S01486
      **  Officer level non-display field if Account Officer level        S01486
      **  not available                                                   S01486
      *                                                                   S01486
     C     D9LVL         IFEQ      'A'                                                         S0148
     C                   MOVE      'Y'           SACOF                                         S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      **  Set Department level field to 'Y' if report at Department       S01486
      **  level non-display field if Department level not available.      S01486
      *                                                                   S01486
     C     D9LVL         IFEQ      'D'                                                         S0148
     C                   MOVE      'Y'           SDEPT                                         S0148
     C                   END                                                                   S0148
      *
     C                   END
      *
     C                   END
      *
     C                   END
      *
      **  Set defaults if insertion/return via F12
      *
     C     ACTN          IFEQ      'I'
     C     CODE          ANDNE     'F'
     C                   Z-ADD     RUND          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         SPFDT
     C                   MOVE      JUSR          SUSRR
     C                   MOVE      DXRDSC        SPDSC
      *
      **  SET DISTRIBUTION REQUIRED TO 'N'
      *
     C                   MOVE      'N'           SDRQD
      *
      ** SET UP BRANCH PROMPT DEFAULTS: IF REPORT AVAILABLE AT BRANCH
      ** LEVEL SET TO RUN AT BRANCH LEVEL WITH DEFAULT BRANCH CODE
      *
     C     DXBLVL        IFEQ      'Y'
     C                   MOVE      'Y'           SBRCH
     C                   MOVE      UDBRN         SETTY
     C                   ELSE
      *
      ** IF REPORT AVAILABLE AT COMPANY, BUT NOT BRANCH LEVEL, SET TO RUN
      ** AT COMPANY LEVEL WITH ENTITY SET TO COMPANY OF DEFAULT BRANCH
      *
     C     DXCLVL        IFEQ      'Y'
     C                   MOVE      'Y'           SCOMP
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*DBERR'      P@APRC
     C                   PARM      '*KEY'        P@APOP
     C                   PARM                    UDBRN
     C********** D@BRCH    PARM D@BRCH    DSFDY                                               CGL029
     C     D@BRCH        PARM      D@BRCH        DSSDY
     C                   MOVE      A8CMCD        SETTY
     C                   ELSE
      *
      ** IF REPORT ONLY AVAILABLE AT SYSTEM LEVEL, SET LEVEL TO SYSTEM
      *
      ** Check Account Officer and Department Level.                      S01486
      *                                                                   S01486
     C     DXALVL        IFNE      'Y'                                                         S0148
     C     DXDLVL        ANDNE     'Y'                                                         S0148
     C                   MOVE      'Y'           SSYST
     C                   END
     C                   END                                                                   S0148
      *
     C                   END
      *                                                                   092597
     C                   CALL      'AOMMODR0'                                                  09259
     C                   PARM      '*DBERR '     @RTCD             7              B:Return code09259
     C                   PARM      '*FIRST'      @OPTN             7              I:Option     09259
     C     SDMMOD        PARM      SDMMOD        DSFDY                            O:Rec format 09259
      *                                                                   092597
     C     BGPFMG        IFEQ      'Y'                                                         09259
      *                                                                   S01486
     C                   CALL      'AOUSERR0'                                                  S0148
     C                   PARM      *BLANK        P@APRC                                        S0148
     C                   PARM      '*KEY'        P@APOP                                        S0148
     C                   PARM      JUSR          P@USER           10                           S0148
     C     D@USER        PARM      D@USER        DSSDY                                         S0148
     C*                                                                   S01486
     C     P@APRC        IFNE      *BLANK                                                      S0148
     C                   CALL      'FCC0240'                                                   S0148
     C                   PARM      'RCF1013'     MSGID                                         S0148
     C                   SETON                                        4370                     S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      ** Access PM ICD File.                                              S01486
      *                                                                   S01486
     C                   CALL      'AOPORTR0'                                                  S0148
     C                   PARM      '*DBERR '     @RTCD             7              B:Return codeS0148
     C                   PARM      '*FIRST'      @OPTN             7              I:Option     S0148
     C     SDPORT        PARM      SDPORT        DSFDY                            O:Rec format S0148
      *                                                                   S01486
      ** The only level available is Account Officer; If PM ICD           S01486
      ** High Level Security is 'Y', Entity is equal to MUSER Account     S01486
      ** Officer. If MUSER Account Officer is blank or High Level         S01486
      ** Security is 'N' then Entity is 'ALL'                             S01486
     C     DXALVL        IFEQ      'Y'                                                         S0148
     C     DXBLVL        ANDEQ     'N'                                                         S0148
     C     DXCLVL        ANDEQ     'N'                                                         S0148
     C     DXGLVL        ANDEQ     'N'                                                         S0148
     C     DXDLVL        ANDEQ     'N'                                                         S0148
     C                   MOVE      'Y'           SACOF                                         S0148
      *                                                                   S01486
      * CHANGE                                                            S01486
     C     FCHLVS        IFEQ      'Y'                                                         S0148
     C***********ACOF      ANDNE*BLANKS                             S01486083547
     C***********          MOVELACOF      SETTY                     S01486083547
     C     ACFA          ANDNE     *BLANKS                                                     08354
     C                   MOVEL     ACFA          SETTY                                         08354
     C                   ELSE                                                                  S0148
     C                   MOVEL     'ALL'         SETTY                                         S0148
     C                   END                                                                   S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      ** The only level available is Department;                          S01486
      ** If PM ICD High Level Security is 'Y', Entity is equal to         S01486
      ** MUSER Department.                                                S01486
      ** If MUSER Department is blank and MUSER Account Officer is        S01486
      ** 'ALL' or if High Level Security is 'N', then Entity is 'ALL'.    S01486
      ** If the Account Officer on MUSER is not 'ALL', send an error      S01486
      ** message.                                                         S01486
     C     DXDLVL        IFEQ      'Y'                                                         S0148
     C     DXBLVL        ANDEQ     'N'                                                         S0148
     C     DXCLVL        ANDEQ     'N'                                                         S0148
     C     DXGLVL        ANDEQ     'N'                                                         S0148
     C     DXALVL        ANDEQ     'N'                                                         S0148
     C                   MOVE      'Y'           SDEPT                                         S0148
      *                                                                   S01486
      * CHANGE                                                            S01486
     C     FCHLVS        IFEQ      'Y'                                                         S0148
     C     DPPT          ANDNE     *BLANKS                                                     S0148
     C                   MOVEL     DPPT          SETTY                                         S0148
     C                   ELSE                                                                  S0148
      *                                                                   S01486
     C                   MOVE      'ALL'         SETTY                                         S0148
     C***********ACOF      IFNE 'ALL'                               S01486083547
     C     ACFA          IFNE      'ALL'                                                       08354
      ** Set up message - Authorisation to this report is not allowed.    S01486
     C                   MOVE      *ON           *IN56                                         S0148
     C                   END                                                                   S0148
     C                   END                                                                   S0148
     C                   END                                                                   S0148
      *                                                                   S01486
     C                   END                                                                   09259
     C                   END
      *
     C     CODE          IFEQ      'F'
      *
     C     ACTN          IFNE      'I'
     C     PREQK         CHAIN     FCPREQL1                           70
     C                   END
      *
      **  Load input- to screen-fields if record found
      *
     C     *IN70         IFEQ      '0'
     C                   Z-ADD     D9TNLU        TNLU
      *                                                                   E38898
      **  Move day no. from program to screen                             E38898
      *                                                                   E38898
     C     SFREQ         IFEQ      'M'                                                         E3889
     C     SFREQ         OREQ      'Q'                                                         E3889
     C     SFREQ         OREQ      'Y'                                                         E3889
     C                   MOVE      FDAY          SFDAY                                         E3889
     C                   ELSE                                                                  E3889
     C                   MOVE      *BLANKS       SFDAY                                         E3889
     C                   END                                                                   E3889
      *
      **  Convert first date to number. Protect if after run date
      *
     C                   Z-ADD     PFDT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         SPFDT
     C     D9PFDT        COMP      RUND                                 50
      *
      **  Convert last date to screen field if present
      *
     C     D9LPDT        IFNE      *ZERO
     C                   Z-ADD     D9LPDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        SLADT
     C                   SETON                                        49
     C                   END
      *
     C                   END
      *
      **  Set branch level field to 'Y' if report at branch level
      **  non-display field if branch level not available
      *
     C     LVL           IFEQ      'B'
     C                   MOVE      'Y'           SBRCH
     C                   END
      *
      **  Set company level field to 'Y' if report at company level
      **  non-display field if company level not available
      *
     C     LVL           IFEQ      'C'
     C                   MOVE      'Y'           SCOMP
     C                   END
      *
      **  Set system level field to 'Y' if report at system level
      **  non-display field if system level not available
      *
     C     LVL           IFEQ      'S'
     C                   MOVE      'Y'           SSYST
     C                   END
      *                                                                   S01486
      **  Set Account Officer level field to 'Y' if report at Account     S01486
      **  Officer level non-display field if Account Officer level        S01486
      **  not available.                                                  S01486
      *                                                                   S01486
     C     LVL           IFEQ      'A'                                                         S0148
     C                   MOVE      'Y'           SACOF                                         S0148
     C                   END                                                                   S0148
      *                                                                   S01486
      **  Set Department level field to 'Y' if report at Department       S01486
      **  level non-display field if Department level not available.      S01486
      *                                                                   S01486
     C     LVL           IFEQ      'D'                                                         S0148
     C                   MOVE      'Y'           SDEPT                                         S0148
     C                   END                                                                   S0148
     C*
     C                   END
     C*
     C     *IN70         IFEQ      '1'
     C                   EXSR      UPDOWS
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R UPDOWS - TO PERFORM UPDATE BY ANOTHER WORKSTATION PROCESSING
     C*  CALLED FROM  INIT
     C*
     C********************************************************************
     C*
     C     UPDOWS        BEGSR
      *
      *
      **  Send message 'record not found' if chain to periodics fails
      *
     C                   CALL      'ZA0250'
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0023' MSGID                           LN1186
     C                   PARM      'RCF1023'     MSGID                                         LN118
     C                   WRITE     FC0210C1
     C                   SETON                                        52
     C*
      **       If report request has disappeared, alert the user
      **        and allow them to exit/return
     C*
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C                   EXFMT     FC0210F0
     C                   END
     C*
     C     *IN03         IFEQ      '1'
     C                   MOVE      'E'           CODE
     C                   MOVE      'T'           ACTN
     C                   END
     C*
     C     *IN12         IFEQ      '1'
     C                   SETON                                        03
     C                   MOVE      'P'           CODE
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R *PSSR - ERROR ROUTINE
     C*
     C********************************************************************
     C*
     C     *PSSR         BEGSR
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   MOVE      'E'           CODE
     C                   MOVE      'T'           ACTN
     C                   DUMP
     C                   END
     C                   RETURN                                                                S0140
     C                   ENDSR
     C********************************************************************
      /EJECT
      *COPY ZSRSRC,ZDATE1Z2                                                                 MD055265
      /COPY ZSRSRC,ZDATE1Z2LE                                                               MD055265
      /EJECT
      *COPY ZSRSRC,ZDATE2Z2                                                                 MD055265
      /COPY ZSRSRC,ZDATE2Z2LE                                                               MD055265
      /EJECT
** CPY@
(c) Finastra International Limited 2001
**  FREQUENCIES
1234567ABDMQY
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
