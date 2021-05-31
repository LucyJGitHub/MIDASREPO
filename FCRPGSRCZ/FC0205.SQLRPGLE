     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Req a single rpt, output inst.')              *
/*O*RF*:*OVRDBF*(QAOKDL01)*(QAOKL01A)*******************************:**                       CAAA02
     F********************************************************************
     F*                                                                  *
     F*  Midas - Report Control Facility Module
     F*                                                                  *
     F*      FC0205 - REQUEST A SINGLE REPORT, OUTPUT INSTRUCTIONS       *
     F*               SCREEN                                             *
     F*                                                                  *
      *  (c) Finastra International Limited 2001                      *
     F*                                                                  *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24307           Date 16Jun09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 TDA035             Date 02Apr04               *
      *                 CAAA02             Date 01Dec03               *
      *                 CFC002             Date 29Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 096923             Date 05Apr97               *
      *                 108964             Date 04Oct96               *
     F*                     083547           DATE 20FEB95                *
     F*                     S01486           DATE 22SEP94                *
     F*                     043702           DATE 21AUG92                *
     F*                     S01382           DATE 27JUL92                *
     F*                     S01117           DATE 25MAR92                *
     F*                     S01269           DATE 25JUN91                *
     F*                     LN1186           DATE 06MAR91                *
     F*                     LN1170           DATE 19FEB91                *
     F*                     LN0210           DATE 18MAY90                *
     F*                                                                  *
     F********************************************************************
     F*                                                                  *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24307 - Local Tax Office Statement On Request COB            *
      *             returned an error.                                   *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CAAA02 - Webfacing. Rename QAOK* references to the V5R2 names.  *
      *  CFC002 - Multiple Output Queues In Std Output Instructions   *
      *           Recompiled due to change in FCSOUTPD                *
     F*      096923 - In SPF, user's output que was specified.  But      *
     F*               requested I/C reports does not go there.           *
     F*               Applied fix 073628 from CBA-SYD R10.4 to default   *
     F*               the user's output que if nothing was entered from  *
     F*               FC0205 prompt screen.                              *
     F*      108964 - If multibranching not on, then need to save level  *
     F*               and entity if report is available by account       *
     F*               officer or department levels                       *
     F*      083547 - Recompile over MUSERDD                             *
     F*      S01486 - Recompiled due to changed FCREPTPD                 *
     F*      043702 - VALIDATE DISTRIBUTION LIST                         *
     F*      S01382 - OPTICAL DISK DEVELOPMENT.                          *
     F*               - IF THE ARCHIVE ID MEDIUM IS BOTH THEN 'B'        *
     F*                 SHOULD BE OUTPUT ON THE SCREEN AS THE MEDIUM.    *
     F*      S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD                 *
     F*      S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO
     F*               MUSERDD
     F*      LN1186 - SEND NEW MESSAGE ID FROM FCUSRMSG TO FCC0240       *
     F*      LN1170 - (1) RENAME 'ROUT' FIELD AFTER ACCESS AS IT IS      *
     F*                   ACCESSED TWICE FOR DIFFERENT REASONS           *
     F*               (2) ALLOW ALL USERS TO OUTPUT REPORTS TO           *
     F*                   OTHER USERS                                    *
     F*      LN0210 - ARCHIVING OPTIONS TO BE ADDED TO THE REPORT        *
     F*                                                                  *
     F********************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*                                                               *
     F****************************************************************
     FFC0205DF  CF   E             WORKSTN
     F                                     SFILE(FC0205S0:RRN)
     F                                     SFILE(FC0205S2:RRN2)                 LN0210
     FMUSER     IF   E           K DISK
     FFCSOUTL1  IF   E           K DISK
     F*FCRSFXL1* IF   E           K DISK                                                    MD055265
     FMAARCDL2  UF   E           K DISK
     F                                     COMMIT
     FMAARCHL1  IF   E           K DISK
     FMAARCHL2  IF   E           K DISK
     FFCRREQL1  IF   E           K DISK
     FFCRREQL0  UF A E           K DISK
     F                                     COMMIT
     FFCPARDL0  UF A E           K DISK
     F                                     COMMIT
     F*AARCDPDO***E                    DISK                               LN0210
     FMAARCDL0  O    E           K DISK                                         LN0210
     F                                     COMMIT
     FMAARCDL1  UF   E           K DISK                                         LN0210
     F                                     COMMIT                               LN0210
     F*QAOKDL01IF*E*****      K        DISK                                            043702 CAAA02
     FQAOKL01A  IF   E           K DISK
     F                                     IGNORE(WOSFMT01)                     043702
     F/COPY WNCPYSRC,FC0205F001
     F********************************************************************
     F*             FUNCTION OF INDICATORS
     F*
     F*  01         FIRST SUBFILE USE INDICATOR
     F*  03         FUNCTION KEY 3 TAKEN FROM SCREEN
     F*  12         FUNCTION KEY 12 TAKEN FROM SCREEN
     F*  20         SFLNXTCHG INDICATOR
     F*  21         SFLDSP/SFLDSPCTL INDICATOR
     F*  22         SFLINZ INDICATOR
     F*  23         SFLEND INDICATOR
     F*  30         STANDARD OUTPUT INSTRUCTIONS ERROR INDICATOR
     F*  31         DISTRIBUTION LIST ERROR INDICATOR
     F*  32         USER ID FOR OUTPUT ERROR INDICATOR
     F*  33         ARCHIVE ON MICROFICHE ERROR INDICATOR
     F*  34         ARCHIVE ON OPTICAL DISK ERROR INDICATOR
     F*  35         SUBFILE SELECT ERROR INDICATOR
     F*  50         OFFICE PRESENT
     F*  51         PROTECT USER ID, AS DISTRIBUTION IS REQUIRED
     F*  52         MICROFICHE MODULE PRESENT
     F*  53         OPTICAL DISK MODULE PRESENT
     F*  54         ENABLE COMMAND 12 ON INITIAL SCREEN IF AMEND
     F*             AND RECORD NOT FOUND
     F*  60         MESSAGE SUBFILE END
     F*  70         ERROR ON SCREEN
     F*  71         ERRORS ON SUBFILE
     F*  72         WARNINGS EXIST ON SUBFILE
     F*  74         SCREEN VALID
     F*  75         SUBFILE VALID
     F*  80         STANDARD OUTPUT INSTRUCTIONS NOT FOUND
     F*  81         REPORT SUFFIXES NOT FOUND
     F*  82         END OF ARCHIVE ID'S FOR MEDIUM
     F*  83         END OF CHANGED SUBFILE RECORDS
     F*  84         CHAIN FAIL INDICATOR FOR MUSER
     F*  85         MIDAS/Q REPORT
     F*  86         CHAIN FAIL TO FCRREQ ON AMEND
     F*  87         CHAIN FAIL TO MAPARD ON AMEND
     F*  88         END OF RECORDS ON MAARCDL2
     F*  89         CHAIN FAIL TO MAARCD/MAARCH ON AMEND
     F*
     F********************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D RREQDS          DS
     D*
     D** DATASTRUCTURE FOR REPORT REQUEST DATABASE ERRORS
     D*
     D  KRNAM                  1     10
     D  KRQSQ                 11     15
     D*
     D LDA             DS           256
     D*
     D** LOCAL DATA AREA FOR DATABASE ERROR STORE
     D*
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D*
     D RUNDAT          DS
     D*
      ** DATA AREA OF BANK DETAILS
     D*
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
     D*
     D SWARN           DS
     D*
      ** DATA STRUCTURE FOR WARNING ERRORS
     D*
     D  SSOID                  1     10
     D  SDST1                 11     18
     D  SDST2                 19     26
     D  SUSRO                 27     36
     D  SARMF                 37     37
     D  SAROD                 38     38
     D*
     D LWARN           DS
     D*
      ** DATA STRUCTURE FOR WARNING ERRORS: LAST SCREEN OF DATA
     D*
     D  LSOID                  1     10
     D  LDST1                 11     18
     D  LDST2                 19     26
     D  LUSRO                 27     36
     D  LARMF                 37     37
     D  LAROD                 38     38
      *COPY*ZSRSRC,ZTNLU1Z1                                                                 MD055265
      /COPY ZSRSRC,ZTNLU1Z3                                                                 MD055265
     D*
     D PSDS           SDS
     D*
     D** PROGRAM STATUS DATA STRUCTURE FOR USER ETC.
     D*
     D  JBNM                 244    253
     D  JUSR                 254    263
     D  JBNB                 264    269
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * 200 BYTE DATASTRUCTURE FOR ACCESS OBJECTS
      *
     D D@RCF         E DS                  EXTNAME(SDRCFPD)
      * LF/SDRCFL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     D D@MMOD        E DS                  EXTNAME(SDMMODPD)
      * LF/SDMMODL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
      *
     D*P@REPT*** E DSFCREPTPD                                                               MD055265
     D P@REPT        E DS                  EXTNAME(FCREPCTD)                                MD055265
     D FCRSFX        E DS                  EXTNAME(FCRSFJW0)                                MD055265
     I******************* SFX         8  2                                LN0210
     I******************* XNM        10  1                                LN0210
     I*
     I** REPORT SUFFIXES FROM REPORT DESCRIPTION
     I*
     IWOSFMT02                                                                  043702
     I              WOS2LDEN                    S2LDEN                          043702
     I              WOS2LDGN                    S2LDGN                          043702
     I              WOS2DESC                    S2DESC                          043702
     I              WOS2USRP                    S2USRP                          043702
     I              WOS2GCID                    S2GCID                          043702
     I              WOS2IND                     S2IND                           043702
      * LF/FCREPTL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      ** Input Parameters:
      **          Sequence Number
      **          Level
      **          Entity
      **          Distribution Required
      **          Parameters
      **          Action
      **          Report
      **          Cycle
      *
     C     *ENTRY        PLIST
     C                   PARM                    RQSQ
     C                   PARM                    LVL
     C                   PARM                    ETTY
     C                   PARM                    DRQD
     C                   PARM                    PARM
     C                   PARM                    CMD               1
     C                   PARM                    RNAM
     C                   PARM                    COTT
     C                   PARM                    CSEQ
     C                   PARM                    CYCLE             1
     C                   PARM                    ACTN              1
      *
     C                   EXSR      INIT1
      *
      **     IF user is authorised to change output instructions
      **     use the value obtained for the requesting user               LN1170
      *
     C***********ROUT      IFEQ 'Y'                                       LN1170
     C     ROUT1         IFEQ      'Y'                                                         LN117
      *
     C                   MOVE      'Y'           OUTPF                                         LN021
     C                   EXSR      INIT2
      *
     C     *IN03         IFEQ      '1'
     C                   MOVE      'E'           CMD
     C                   MOVE      'T'           ACTN
     C                   EXSR      END
     C                   END
      *
      **          DOWHILE F3 is not taken or screen is invalid
      *
     C********** *IN74     DOWEQ'0'                                       LN0210
     C     OUTPF         DOWEQ     'Y'                                                         LN021
     C     RSFXF         OREQ      'Y'                                                         LN021
     C     ARCHF         OREQ      'Y'                                                         LN021
     C     UPDF          OREQ      'Y'                                                         LN021
      *
     C     OUTPF         IFEQ      'Y'                                                         LN021
     C                   EXSR      VALID
     C                   END                                                                   LN021
      *                                                                   LN0210
      ** PROCESS SUFFIXES IF ARCHIVING REQUESTED                          LN0210
      *                                                                   LN0210
     C     RSFXF         IFEQ      'Y'                                                         LN021
     C                   EXSR      RSFXS                                                       LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      ** PROCESS ARCHIVE DETAILS IF REQUESTED                             LN0210
      *                                                                   LN0210
     C     ARCHF         IFEQ      'Y'                                                         LN021
     C                   EXSR      SETSUB                                                      LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     UPDF          IFEQ      'Y'                                                         LN021
     C                   EXSR      INSAMD                                                      LN021
     C                   MOVE      'N'           UPDF                                          LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *****************                                                   LN0210
      **************** IF*No*errors*exist******************************** LN0210
      **************** AND*archiving*on*Microfiche/optical*disk*is*'Y'*** LN0210
      *****************                                                   LN0210
     C********** *IN70     IFEQ '0'                                       LN0210
     C********** SARMF     ANDEQ'Y'                                       LN0210
     C********** *IN70     OREQ '0'                                       LN0210
     C********** SAROD     ANDEQ'Y'                                       LN0210
     C********** ACTN      OREQ 'A'                                       LN0210
      *********************                                               LN0210
     C******************** EXSR ARCHS                                     LN0210
      *********************                                               LN0210
     C                   END
      *****************                                                   LN0210
      **************** IF*screen*is*valid,*exit*loop********************* LN0210
      *****************                                                   LN0210
     C********** *IN70     IFEQ '0'                                       LN0210
     C******************** SETON                     74                   LN0210
      *****************                                                   LN0210
      **************** Otherwise,*redisplay*screen*********************** LN0210
      *****************                                                   LN0210
     C******************** ELSE                                           LN0210
      *********************                                               LN0210
     C********** *IN03     IFEQ '0'                                       LN0210
     C******************** WRITEFC0205C1                                  LN0210
     C******************** EXFMTFC0205F0                                  LN0210
     C******************** END                                            LN0210
      *********************                                               LN0210
     C******************** END                                            LN0210
      *********************                                               LN0210
      **************** Exit*program**f*F3*taken************************** LN0210
      *****************                                                   LN0210
     C     *IN03         IFEQ      '1'
     C                   MOVE      'E'           CMD
     C                   MOVE      'T'           ACTN
     C                   EXSR      END
     C                   END
      *********************                                               LN0210
     C******************** END                                            LN0210
      *********************                                               LN0210
     C******************** END                                            LN0210
      ******************************************************************* LN0210
      *******Write report requests record******************************** LN0210
      *******IF parameters is not blank********************************** LN0210
      ************Write Parameters daily record************************** LN0210
      *******ENDIF******************************************************* LN0210
      ******************************************************************* LN0210
     C********** KRQSQ*****CHAINFCRREQL0**********   86****************** LN0210
      ******************************************************************* LN0210
     C********** *IN86*****IFEQ '1'************************************** LN0210
     C********** ACTN***** ANDEQ'A'************************************** LN0210
     C******************** MOVE 'RCF0023' MSGID************************** LN0210
     C******************** END******************************************* LN0210
     C******************************************************************* LN0210
     C********** ACTN***** IFEQ 'A'************************************** LN0210
     C********** *IN86*****ANDEQ'0'************************************** LN0210
     C********** OTNLU*****ANDNED5TNLU*********************************** LN0210
     C******************** MOVE 'RCF0060' MSGID************************** LN0210
     C******************** END******************************************* LN0210
     C******************************************************************* LN0210
     C********** ACTN***** IFEQ 'A'************************************** LN0210
     C********** OTNLU*****ANDNED5TNLU*********************************** LN0210
     C********** ACTN***** OREQ 'A'************************************** LN0210
     C********** *IN86*****ANDEQ'0'************************************** LN0210
     C******************** CALL 'ZA0250'********************************* LN0210
     C******************** CALL 'FCC0240'******************************** LN0210
     C******************** PARM********** MSGID************************** LN0210
     C******************** WRITEFC0205C1********************************* LN0210
     C******************** SETON******************** 54****************** LN0210
     C******************************************************************* LN0210
      *******  If report request has changed, alert the user************* LN0210
      *******   and allow them to exit*********************************** LN0210
     C******************************************************************* LN0210
     C********** *IN03*****DOWEQ'0'************************************** LN0210
     C******************** EXFMTFC0205F0********************************* LN0210
     C******************** END******************************************* LN0210
     C******************************************************************* LN0210
     C********** *IN03*****IFEQ '1'************************************** LN0210
     C******************** MOVE 'E'*****  CMD**************************** LN0210
     C******************** MOVE 'T'*****  ACTN*************************** LN0210
     C******************** EXSR END************************************** LN0210
     C******************** END******************************************* LN0210
     C******************************************************************* LN0210
     C******************** END******************************************* LN0210
     C******************************************************************* LN0210
      **  Access MNATN for next transaction number*********************** LN0210
     C******************************************************************* LN0210
     C******************** EXSR ZTNLU1*********************************** LN0210
      ******************************************************************* LN0210
     C******************** MOVE RNAM***** D5RNAM************************* LN0210
     C******************** MOVE RQSQ***** D5RQSQ************************* LN0210
     C******************** MOVE COTT***** D5COTT************************* LN0210
     C******************** MOVE CSEQ***** D5CSEQ************************* LN0210
     C******************** MOVE SSOID*****D5SOID************************* LN0210
     C******************** Z-ADDNATN***** D5TNLU************************* LN0210
     C********** MBIN***** IFEQ 'Y'************************************** LN0210
     C******************** MOVE LVL*****  D5LVL************************** LN0210
     C******************** MOVE ETTY***** D5ETTY************************* LN0210
     C******************** END******************************************* LN0210
     C******************** MOVE 'N'*****  D5PDFL************************* LN0210
     C********** CYCLE*****IFEQ 'I'************************************** LN0210
     C******************** MOVE 'Y'*****  D5IPCY************************* LN0210
     C******************** MOVE 'N'*****  D5COBR************************* LN0210
     C******************** END******************************************* LN0210
     C********** CYCLE*****IFEQ 'C'************************************** LN0210
     C******************** MOVE 'N'*****  D5IPCY************************* LN0210
     C******************** MOVE 'Y'*****  D5COBR************************* LN0210
     C******************** END******************************************* LN0210
     C******************** MOVE SDST1*****D5DLS1************************* LN0210
     C******************** MOVE SDST2*****D5DLS2************************* LN0210
     C******************** MOVE SUSRO*****D5USRO************************* LN0210
     C******************** MOVE SARMF*****D5ARMF************************* LN0210
     C******************** MOVE SAROD*****D5AROD************************* LN0210
     C******************** MOVE DRQD***** D5DRQD************************* LN0210
      ******************************************************************* LN0210
     C********** ACTN***** IFEQ 'I'************************************** LN0210
     C******************** MOVE JUSR***** D5USRR************************* LN0210
     C******************** MOVE JDBRN*****D5DBRN************************* LN0210
     C******************** TIME********** RTIME   60********************* LN0210
     C******************** MOVELRTIME*****D5RQTM************************* LN0210
     C******************** WRITE@D5REI8********************************** LN0210
      ******************************************************************* LN0210
     C********** PARM***** IFNE *BLANK*********************************** LN0210
     C******************** MOVE RNAM***** D7RNAM************************* LN0210
     C******************** MOVE RQSQ***** D7RQSQ************************* LN0210
     C******************** MOVE PARM***** D7PARM************************* LN0210
     C******************** WRITE@D7REJE********************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** ELSE****************************************** LN0210
      ******************************************************************* LN0210
     C********** *IN86*****IFEQ '0'************************************** LN0210
     C******************** UPDAT@D5REI8********************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********** RREQKY    CHAINFCPARDL0**********   87****************** LN0210
     C******************** MOVE RNAM***** D7RNAM************************* LN0210
     C******************** MOVE RQSQ***** D7RQSQ************************* LN0210
     C******************** MOVE PARM***** D7PARM************************* LN0210
      ******************************************************************* LN0210
     C********** PARM***** IFNE *BLANK*********************************** LN0210
      ******************************************************************* LN0210
     C********** *IN87*****IFEQ '0'************************************** LN0210
     C******************** UPDAT@D7REJE********************************** LN0210
     C******************** ELSE****************************************** LN0210
     C******************** WRITE@D7REJE********************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** ELSE****************************************** LN0210
     C**N87*************** DELET@D7REJE********************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** END******************************************* LN0210
      *******                                                             LN0210
      ****** Issue*Commit************************************************ LN0210
      *******                                                             LN0210
      *                                                                   LN0210
      **     IF user is not authorised to change output instructions      LN0210
      **     use the value obtained for the requesting user               LN1170
      *                                                                   LN0210
     C***********ROUT      IFEQ 'N'                                       LN1170
     C     ROUT1         IFEQ      'N'                                                         LN117
     C                   EXSR      INSAMD                                                      LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   SETON                                        LR
     C******************** COMIT                                          LN0210
      *
      ********************************************************************
     C*                INDEX OF SUBROUTINES
     C*  S/R INSAMD - TO PERFORM UPDATES TO FILES                         LN0210
     C*  S/R VALID - TO VALIDATE MAIN SCREEN
     C*  S/R ARCHS - TO PERFORM ARCHIVING SCREEN PROCESSING
     C*  S/R ARCHV - TO VALIDATE CHANGED S/FILE RECORDS FOR A PRINT SUFFIX
     C*  S/R INIT2 - TO INITIALISE MAIN SCREEN
     C*  S/R INIT1 - TO INITIALISE PROGRAM VARIABLES
     C*  S/R ZTNLU1 - ACCESS MNATN FOR NEXT AVAILABLE TRANSACTION NO.
     C*  S/R DBERR - TO PROCESS DATABASE ERRORS AND TERMINATE PROGRAM
     C*  S/R END - TO TERMINATE PROGRAM
     C*  S/R *PSSR - ERROR ROUTINE
      ********************************************************************
      /EJECT                                                              LN0210
     C******************************************************************* LN0210
     C*                                                                   LN0210
     C*  S/R INSAMD - TO PERFORM UPDATES TO FILES                         LN0210
     C*  CALLED FROM MAIN                                                 LN0210
     C*                                                                   LN0210
     C******************************************************************* LN0210
      *                                                                   LN0210
     C     INSAMD        BEGSR                                                                 LN021
      *                                                                   LN0210
      **     Write report requests record                                 LN0210
      **     IF parameters is not blank                                   LN0210
      **          Write Parameters daily record                           LN0210
      **     ENDIF                                                        LN0210
      *                                                                   LN0210
     C     KRQSQ         CHAIN     FCRREQL0                           86                       LN021
      *                                                                   LN0210
     C     *IN86         IFEQ      '1'                                                         LN021
     C     ACTN          ANDEQ     'A'                                                         LN021
     C***********          MOVE 'RCF0023' MSGID                    LN0210 LN1186
     C                   MOVE      'RCF1023'     MSGID                                         LN118
     C                   END                                                                   LN021
     C*                                                                   LN0210
     C     ACTN          IFEQ      'A'                                                         LN021
     C     *IN86         ANDEQ     '0'                                                         LN021
     C     OTNLU         ANDNE     D5TNLU                                                      LN021
     C***********          MOVE 'RCF0060' MSGID                    LN0210 LN1186
     C                   MOVE      'RCF1060'     MSGID                                         LN118
     C                   END                                                                   LN021
     C*                                                                   LN0210
     C     ACTN          IFEQ      'A'                                                         LN021
     C     *IN86         ANDEQ     '0'                                                         LN021
     C     OTNLU         ANDNE     D5TNLU                                                      LN021
     C     ACTN          OREQ      'A'                                                         LN021
     C     *IN86         ANDEQ     '1'                                                         LN021
     C                   CALL      'ZA0250'                                                    LN021
     C                   CALL      'FCC0240'                                                   LN021
     C                   PARM                    MSGID                                         LN021
     C                   WRITE     FC0205C1                                                    LN021
     C                   SETON                                        54                       LN021
     C*                                                                   LN0210
      **       If report request has changed, alert the user              LN0210
      **        and allow them to exit                                    LN0210
     C*                                                                   LN0210
     C     *IN03         DOWEQ     '0'                                                         LN021
     C                   EXFMT     FC0205F0                                                    LN021
     C                   END                                                                   LN021
     C*                                                                   LN0210
     C     *IN03         IFEQ      '1'                                                         LN021
     C                   MOVE      'E'           CMD                                           LN021
     C                   MOVE      'T'           ACTN                                          LN021
     C                   EXSR      END                                                         LN021
     C                   END                                                                   LN021
     C*                                                                   LN0210
     C                   END                                                                   LN021
     C*                                                                   LN0210
      **  Access MNATN for next transaction number                        LN0210
     C*                                                                   LN0210
     C                   EXSR      ZTNLU1                                                      LN021
      *                                                                   LN0210
      **                    Delete all archiving if not required          LN0210
      *                                                                   LN0210
     C     SAROD         IFEQ      'N'                                                         LN021
     C     SARMF         ANDEQ     'N'                                                         LN021
      *                                                                   LN0210
     C     ARCDKP        SETLL     MAARCDL2                                                    LN021
     C     ARCDKP        READE     MAARCDL2                               88                   LN021
      *                                                                   LN0210
     C     *IN88         DOWEQ     '0'                                                         LN021
     C                   DELETE    @ARCDAO                                                     LN021
     C     ARCDKP        READE     MAARCDL2                               88                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    Delete Optical Disk if not required           LN0210
      *                                                                   LN0210
     C     SAROD         IFEQ      'N'                                                         LN021
     C     D5AROD        ANDEQ     'Y'                                                         LN021
      *                                                                   LN0210
     C     ARCDKP        SETLL     MAARCDL2                                                    LN021
     C     ARCDKP        READE     MAARCDL2                               88                   LN021
      *                                                                   LN0210
     C     *IN88         DOWEQ     '0'                                                         LN021
     C     EBARID        CHAIN     MAARCHL1                           89                       LN021
      *                                                                   LN0210
     C     *IN89         IFEQ      '0'                                                         LN021
     C     EAMEDM        ANDEQ     'O'                                                         LN021
     C                   DELETE    @ARCDAO                                                     LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     *IN89         IFEQ      '1'                                                         LN021
     C     *LOCK         IN        LDA                                                         LN021
     C                   MOVEL     'MAARCHL1'    DBFILE                                        LN021
     C                   MOVEL     EBARID        DBKEY                          *************  LN021
     C                   Z-ADD     8             DBASE                          * DBERR 008 *  LN021
     C                   EXSR      DBERR                                        *************  LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     ARCDKP        READE     MAARCDL2                               88                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    Delete Microfiche archiving if not required   LN0210
      *                                                                   LN0210
     C     D5ARMF        IFEQ      'Y'                                                         LN021
     C     SARMF         ANDEQ     'N'                                                         LN021
      *                                                                   LN0210
     C     ARCDKP        SETLL     MAARCDL2                                                    LN021
     C     ARCDKP        READE     MAARCDL2                               88                   LN021
      *                                                                   LN0210
     C     *IN88         DOWEQ     '0'                                                         LN021
     C     EBARID        CHAIN     MAARCHL1                           89                       LN021
      *                                                                   LN0210
     C     *IN89         IFEQ      '0'                                                         LN021
     C     EAMEDM        ANDEQ     'M'                                                         LN021
     C                   DELETE    @ARCDAO                                                     LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     *IN89         IFEQ      '1'                                                         LN021
     C     *LOCK         IN        LDA                                                         LN021
     C                   MOVEL     'MAARCHL1'    DBFILE                                        LN021
     C                   MOVEL     EBARID        DBKEY                          *************  LN021
     C                   Z-ADD     9             DBASE                          * DBERR 009 *  LN021
     C                   EXSR      DBERR                                        *************  LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     ARCDKP        READE     MAARCDL2                               88                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      ** If archiving has been requested                                  LN0210
      *                                                                   LN0210
     C     SARMF         IFEQ      'Y'                                                         LN021
     C     SAROD         OREQ      'Y'                                                         LN021
      *                                                                   LN0210
     C                   MOVE      'N'           SARMF                                         LN021
     C                   MOVE      'N'           SAROD                                         LN021
      *                                                                   LN0210
      ** Read Archive Details Subfile                                     LN0210
      *                                                                   LN0210
     C                   Z-ADD     1             RRN               5 0                         LN021
     C                   READC     FC0205S0                               83                   LN021
      *                                                                   LN0210
      **               DOWHILE changed records                            LN0210
      *                                                                   LN0210
     C     *IN83         DOWEQ     '0'                                                         LN021
      *                                                                   LN0210
      **     If no record previously existed,                             LN0210
      **                    Write Archive Contents                        LN0210
      *                                                                   LN0210
     C     SSEL          IFEQ      '1'                                                         LN021
     C     SEXST         ANDEQ     'N'                                                         LN021
     C                   MOVE      SARID         EBARID                                        LN021
     C                   MOVE      RNAM          EBRNAM                                        LN021
     C                   MOVE      RQSQ          EBRQSQ                                        LN021
     C                   MOVE      SRSFX         EBRSFX                                        LN021
     C                   WRITE     @EBREJQ                                                     LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **      If a record did exist, but no current request made          LN0210
      **                    Delete Archive Contents                       LN0210
      *                                                                   LN0210
     C     SSEL          IFEQ      *BLANK                                                      LN021
     C     SEXST         ANDEQ     'Y'                                                         LN021
     C     ARCDKY        CHAIN     MAARCDL1                           89                       LN021
     C  N89              DELETE    @EBREJR                                                     LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **    If any records selected for this suffix                       LN0210
      *                                                                   LN0210
     C     SSEL          IFEQ      '1'                                                         LN021
      *                                                                   LN0210
      **     Set Archiving flags depending of archive type                LN0210
      *                                                                   LN0210
     C     SMFOD         IFEQ      'MF'                                                        LN021
     C     SMFOD         OREQ      'B '                                                        S0138
     C                   MOVE      'Y'           SARMF                                         LN021
     C                   END                                                                   S0138
      *                                                                   S01382
     C***                  ELSE                                     LN0210S01382
      *                                                                   S01382
     C     SMFOD         IFEQ      'OD'                                                        S0138
     C     SMFOD         OREQ      'B '                                                        S0138
     C                   MOVE      'Y'           SAROD                                         LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    Read changed records                          LN0210
      *                                                                   LN0210
     C                   READC     FC0205S0                               83                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      ** Read Suffix Selection Subfile                                    LN0210
      *                                                                   LN0210
     C                   Z-ADD     1             RRN2                                          LN021
     C                   READC     FC0205S2                               83                   LN021
      *                                                                   LN0210
      **               DOWHILE changed records                            LN0210
      *                                                                   LN0210
     C     *IN83         DOWEQ     '0'                                                         LN021
      *                                                                   LN0210
      **      If a record did exist, but no current request made          LN0210
      **                    Delete Archive Contents                       LN0210
      *                                                                   LN0210
     C     SSELX         IFEQ      *BLANK                                                      LN021
     C     SEXSTX        ANDEQ     'Y'                                                         LN021
     C     ARCDK         SETLL     MAARCDL2                                                    LN021
     C     ARCDK         READE     MAARCDL2                               89                   LN021
      *                                                                   LN0210
     C     *IN89         DOWEQ     '0'                                                         LN021
     C                   DELETE    @ARCDAO                                                     LN021
     C     ARCDK         READE     MAARCDL2                               89                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    Read changed records                          LN0210
      *                                                                   LN0210
     C                   READC     FC0205S2                               83                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   MOVE      RNAM          D5RNAM                                        LN021
     C                   MOVE      RQSQ          D5RQSQ                                        LN021
     C                   MOVE      COTT          D5COTT                                        LN021
     C                   MOVE      CSEQ          D5CSEQ                                        LN021
     C                   MOVE      SSOID         D5SOID                                        LN021
     C                   Z-ADD     NATN          D5TNLU                                        LN021
     C     MBIN          IFEQ      'Y'                                                         LN021
     C     DXALVL        OREQ      'Y'                                                         10896
     C     DXDLVL        OREQ      'Y'                                                         10896
     C                   MOVE      LVL           D5LVL                                         LN021
     C                   MOVE      ETTY          D5ETTY                                        LN021
     C                   END                                                                   LN021
     C                   MOVE      'N'           D5PDFL                                        LN021
     C     CYCLE         IFEQ      'I'                                                         LN021
     C                   MOVE      'Y'           D5IPCY                                        LN021
     C                   MOVE      'N'           D5COBR                                        LN021
     C                   END                                                                   LN021
     C     CYCLE         IFEQ      'C'                                                         LN021
     C                   MOVE      'N'           D5IPCY                                        LN021
     C                   MOVE      'Y'           D5COBR                                        LN021
     C                   END                                                                   LN021
     C                   MOVE      SDST1         D5DLS1                                        LN021
     C                   MOVE      SDST2         D5DLS2                                        LN021
     C                   MOVE      SUSRO         D5USRO                                        LN021
     C/COPY WNCPYSRC,FCH00001
     C*                                                                   096923
     C** If no instructions have been entered, default user for output    096923
     C** from current user, if they have an output queue defined and      096923
     C** if it is during input cycle.                                     096923
     C*                                                                   096923
     C     SUSRO         IFEQ      *BLANK                                                      09692
     C     SDST1         ANDEQ     *BLANK                                                      09692
     C     SDST2         ANDEQ     *BLANK                                                      09692
     C     SSOID         ANDEQ     *BLANK                                                      09692
     C     CYCLE         ANDEQ     'I'                                                         09692
     C     JOUTQ         ANDNE     *BLANKS                                                     09692
     C                   MOVE      JUSR          D5USRO                                        09692
     C                   ENDIF                                                                 09692
     C*                                                                   096923
     C                   MOVE      SARMF         D5ARMF                                        LN021
     C                   MOVE      SAROD         D5AROD                                        LN021
     C                   MOVE      DRQD          D5DRQD                                        LN021
      *                                                                   LN0210
     C     ACTN          IFEQ      'I'                                                         LN021
     C     *IN86         ANDEQ     '1'
     C                   MOVE      JUSR          D5USRR                                        LN021
     C                   MOVE      JDBRN         D5DBRN                                        LN021
     C                   TIME                    RTIME             6 0                         LN021
     C                   MOVEL     RTIME         D5RQTM                                        LN021
     C                   WRITE     @D5REI8                                                     LN021
      *                                                                   LN0210
     C     PARM          IFNE      *BLANK                                                      LN021
     C                   MOVE      RNAM          D7RNAM                                        LN021
     C                   MOVE      RQSQ          D7RQSQ                                        LN021
     C                   MOVE      PARM          D7PARM                                        LN021
     C/COPY WNCPYSRC,FC0205C001
     C                   WRITE     @D7REJE                                                     LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   ELSE                                                                  LN021
      *                                                                   LN0210
     C     *IN86         IFEQ      '0'                                                         LN021
     C                   UPDATE    @D5REI8                                                     LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     RREQKY        CHAIN     FCPARDL0                           87                       LN021
     C/COPY WNCPYSRC,FC0205C002
     C                   MOVE      RNAM          D7RNAM                                        LN021
     C                   MOVE      RQSQ          D7RQSQ                                        LN021
     C                   MOVE      PARM          D7PARM                                        LN021
      *                                                                   LN0210
     C     PARM          IFNE      *BLANK                                                      LN021
     C/COPY WNCPYSRC,FC0205C003
      *                                                                   LN0210
     C     *IN87         IFEQ      '0'                                                         LN021
     C                   UPDATE    @D7REJE                                                     LN021
     C                   ELSE                                                                  LN021
     C                   WRITE     @D7REJE                                                     LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   ELSE                                                                  LN021
     C  N87              DELETE    @D7REJE                                                     LN021
     C/COPY WNCPYSRC,FC0205C004
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      **     Issue Commit                                                 LN0210
      *                                                                   LN0210
     C                   COMMIT                                                                LN021
      *                                                                   LN0210
     C                   ENDSR                                                                 LN021
      *                                                                   LN0210
     C******************************************************************* LN0210
      /EJECT                                                              LN0210
     C********************************************************************
     C*
     C*  S/R VALID - TO VALIDATE MAIN SCREEN
     C*  CALLED FROM MAIN
     C*
     C********************************************************************
      *
     C     VALID         BEGSR
      *
     C******************** CALL 'ZA0250'                                  LN0210
     C******************** SETOF                     703334               LN0210
     C                   SETON                                        70                       LN021
     C                   SETOFF                                       3334                     LN021
     C                   SETOFF                                       303132
     C                   WRITE     FC0205C1                                                    LN021
     C                   EXFMT     FC0205F0                                                    LN021
      *                                                                   LN0210
     C     *IN70         DOWEQ     '1'                                                         LN021
     C     *IN03         ANDEQ     '0'                                                         LN021
      *                                                                   LN0210
     C                   SETOFF                                       7035                     LN021
     C                   CALL      'ZA0250'                                                    LN021
      *
      **               IF standard output instructions is non-blank
      **               AND Distribution list parts 1/2 is non-blank
      *
     C     SSOID         IFNE      *BLANK
     C     SDST1         ANDNE     *BLANK
     C     SSOID         ORNE      *BLANK
     C     SDST2         ANDNE     *BLANK
      *
      **               OR Standard output instructions is non-blank
      **               AND User Id is non-blank
      *
     C     SSOID         ORNE      *BLANK
     C     SUSRO         ANDNE     *BLANK
      *
      **               OR Distribution list parts 1/2 is non-blank
      **               AND User Id is non-blank
      *
     C     SUSRO         ORNE      *BLANK
     C     SDST1         ANDNE     *BLANK
     C     SUSRO         ORNE      *BLANK
     C     SDST2         ANDNE     *BLANK
      *
      **                    Send error message
      *
     C                   SETON                                        70
     C                   SETON                                        303132
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0001' MSGID   7                       LN1186
     C                   PARM      'RCF1001'     MSGID             7                           LN118
     C                   END
      *
      **               IF Standard Output Instructions field is
      **               non-blank
      *
     C     SSOID         IFNE      *BLANK
     C     SWARN         ANDNE     LWARN
      *
      **                    Access Standard Output Instructions
      **                    file for this Id
      *
     C                   MOVEL     SSOID         KSOID
     C     SOIKEY        SETLL     FCSOUTL1                               80
      *
      **                    IF no record is found
      **                         Send warning message to user
      *
     C     *IN80         IFEQ      '0'
     C                   SETON                                        707130
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0002' MSGID   7                       LN1186
     C                   PARM      'RCF1002'     MSGID                                         LN118
     C                   END
      *
     C                   MOVE      SSOID         LSOID
     C                   MOVE      SDST1         LDST1
     C                   MOVE      SDST2         LDST2
     C                   MOVE      SUSRO         LUSRO
     C                   MOVE      SARMF         LARMF
     C                   MOVE      SAROD         LAROD
      *
     C                   END
      *
      **               IF Distribution list field 1 has been
      **               entered
      **               AND Distribution list field 2 is blank
      *
     C     SDST1         IFNE      *BLANK
     C     SDST2         ANDEQ     *BLANK
      *
      **               OR Distribution list 2 field has been
      **               entered
      **               AND Distribution list 1 field is blank
      *
     C     SDST2         ORNE      *BLANK
     C     SDST1         ANDEQ     *BLANK
      *
      **                    Send error message to user
      *
     C                   SETON                                        7031
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0003' MSGID   7                       LN1186
     C                   PARM      'RCF1003'     MSGID                                         LN118
     C                   END
      *                                                                   043702
      **               IF Distribution list fields 1 and 2 are not        043702
      **               blank                                              043702
      *                                                                   043702
     C     SDST1         IFNE      *BLANK                                                      04370
     C     SDST2         ANDNE     *BLANK                                                      04370
      *                                                                   043702
      **                    Access Distribution List Logical file for     043702
      **                    this distribution list                        043702
      *                                                                   043702
     C                   MOVEL     SDST1         KDIST1                                        04370
     C                   MOVEL     SDST2         KDIST2                                        04370
     C*********  KDLIST    CHAINQAOKDL01             80                                043702 CAAA02
     C     KDLIST        CHAIN     QAOKL01A                           80
      *                                                                   043702
      **                    IF no record is found                         043702
      **                         Send warning message to user             043702
      *                                                                   043702
     C     *IN80         IFEQ      '1'                                                         04370
     C                   SETON                                        7031                     04370
     C                   CALL      'FCC0240'                                                   04370
     C                   PARM      'RCF1017'     MSGID                                         04370
     C                   END                                                                   04370
      *                                                                   043702
     C                   END                                                                   04370
      *
      **               IF a user id has been entered
      *
     C     SUSRO         IFNE      *BLANK
      *
      **                    IF this is the user's own Id
      **                    AND the user has no output queue
      **                         Send error message
      *
     C     SUSRO         IFEQ      JUSR
     C     JOUTQ         ANDEQ     *BLANK
     C                   SETON                                        7032
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0004' MSGID   7                       LN1186
     C                   PARM      'RCF1004'     MSGID                                         LN118
     C                   END
      *
      **********************IF*this*is*not*the*user's*own*Id****          LN1170
      **********************AND*user*is*not*authorised*to*others          LN1170
      ***************************Send*error*message*************          LN1170
      **********************************************************          LN1170
     C***********SUSRO     IFNE JUSR                                      LN1170
     C***********JMUREP    ANDEQ'N'                                       LN1170
     C***********          SETON                     7032                 LN1170
     C***********          CALL 'FCC0240'                                 LN1170
     C***********          PARM 'RCF0005' MSGID   7                       LN1170
     C***********          END                                            LN1170
      *******************************************************             LN1170
      **********************IF*user*is*authorised*to*others**             LN1170
      **********************AND*this*is*not*the*user's*own*Id             LN1170
      *******************************************************             LN1170
     C***********JMUREP    IFEQ 'Y'                                       LN1170
     C***********SUSRO     ANDNEJUSR                                      LN1170
      *
      **                      IF this is not the User's own Id            LN1170
      **                         Access MUSER for the user Id
      **                         entered
      *
     C     SUSRO         IFNE      JUSR                                                        LN117
      *                                                                   LN1170
     C     SUSRO         CHAIN     MUSER                              84
      *
      **                         IF no record is found
      **                              Send error message
      *
     C     *IN84         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   SETON                                        7032
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0006' MSGID   7                       LN1186
     C                   PARM      'RCF1006'     MSGID                                         LN118
     C                   ELSE
      *
      **                         Otherwise
      **                                   IF this user has no
      **                                   output queue
      **                                        Send error message
      *
     C*                                                                   LN1170
     C* Define 'Authority to Output Instructions' in a work field to      LN1170
     C* protect from overwriting the value for the requesting user        LN1170
     C*                                                                   LN1170
     C                   MOVE      ROUT          ROUT2             1                           LN117
     C*                                                                   LN1170
     C     OUTQ          IFEQ      *BLANK
     C                   SETON                                        7032
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0007' MSGID   7                       LN1186
     C                   PARM      'RCF1007'     MSGID                                         LN118
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C                   END
      *
      **               IF Archived on Fiche is not Y or N
      **                    Send error message
      *
     C     SARMF         IFNE      'Y'
     C     SARMF         ANDNE     'N'
     C     SARMF         ANDNE     *BLANK
     C                   SETON                                        7033
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0008' MSGID   7                       LN1186
     C                   PARM      'RCF1008'     MSGID                                         LN118
     C                   END
      *
      **               IF Archived on Optical is not Y or N
      **                    Send error message
      *
     C     SAROD         IFNE      'Y'
     C     SAROD         ANDNE     'N'
     C     SAROD         ANDNE     *BLANK
     C                   SETON                                        7034
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0009' MSGID   7                       LN1186
     C                   PARM      'RCF1009'     MSGID                                         LN118
     C                   END
      *
      **         Reset Defaults
      *
     C     SARMF         IFEQ      *BLANK
     C                   MOVE      'N'           SARMF
     C                   END
      *
     C     SAROD         IFEQ      *BLANK
     C                   MOVE      'N'           SAROD
     C                   END
      *
     C   70              WRITE     FC0205C1                                                    LN021
     C   70              EXFMT     FC0205F0                                                    LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      ** SCREEN VALID AND EXIT/PREVIOUS NOT REQUESTED                     LN0210
      *                                                                   LN0210
     C     *IN03         IFEQ      '0'                                                         LN021
      *                                                                   LN0210
      ** SET CURRENT SCREEN OFF, CHECK ARCHIVING REQUIREMENT              LN0210
      **    IF ARCHIVING NOT PRESENT, PERFORM UPDATES                     LN0210
      **    IF ARCHIVING MAY BE REQUIRED, PROCESS ARCHIVING               LN0210
      *                                                                   LN0210
     C                   MOVE      'N'           OUTPF             1                           LN021
      *                                                                   LN0210
     C     SAROD         IFEQ      'Y'                                                         LN021
     C     SARMF         OREQ      'Y'                                                         LN021
     C                   MOVE      'Y'           RSFXF             1                           LN021
     C                   ELSE                                                                  LN021
     C                   MOVE      'Y'           UPDF              1                           LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
     C*                                                                   LN0210
     C** IF EXIT REQUESTED, TERMINATE PROGRAM                             LN0210
     C*                                                                   LN0210
     C     *IN03         IFEQ      '1'                                                         LN021
     C                   MOVE      'E'           CMD                                           LN021
     C                   MOVE      'T'           ACTN                                          LN021
     C                   EXSR      END                                                         LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   ENDSR
     C********************************************************************
      /EJECT                                                              LN0210
     C******************************************************************* LN0210
     C*                                                                   LN0210
     C*  S/R RSFXS - TO DISPLAY SUFFIX SELECTION SCREEN FOR ARCHIVING     LN0210
     C*  CALLED FROM MAIN                                                 LN0210
     C*  CALLS                                                            LN0210
     C*                                                                   LN0210
     C******************************************************************* LN0210
      *                                                                   LN0210
     C     RSFXS         BEGSR                                                                 LN021
      *                                                                   LN0210
      ** Access Report Suffixes (Spool file names) for the report         LN0210
      *                                                                   LN0210
     C*****RNAM*         SETLL     FCRSFXL1                                           LN021 MD055265
     C*****RNAM*         READE     FCRSFXL1                               81          LN021 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ declare ACursor insensitive scroll cursor for                                       MD055265
     C+ select * from FCRSFJW0                                                              MD055265
     C+ where DYRNAM = :RNAM                                                                MD055265
     C+ order by DYRNAM, DYRSFX                                                             MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ close ACursor                                                                       MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ open ACursor                                                                        MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from ACursor into :FCRSFX                                                MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
      *                                                                   LN0210
      ** Ignore Audit Report sections                                     LN0210
      *                                                                   LN0210
     C     DYAURP        IFEQ      'Y'                                                         LN021
     C*****RNAM*         READE     FCRSFXL1                               81          LN021 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from ACursor into :FCRSFX                                                MD055265
     C/END-EXEC                                                                             MD055265
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    IF no records found                           LN0210
      *                                                                   LN0210
     C******IN81         IFEQ      '1'                                                LN021 MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C     *LOCK         IN        LDA                                                         LN021
     C                   MOVEL     'FCRSFXL1'    DBFILE                                        LN021
     C                   MOVEL     RNAM          DBKEY                          ************** LN021
     C                   Z-ADD     7             DBASE                          * DBERR 007 *  LN021
     C                   EXSR      DBERR                                        ************** LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     *IN02         IFEQ      '1'                                                         LN021
      *                                                                   LN0210
      ** Reset Relative Record number for subfile processing              LN0210
      *                                                                   LN0210
     C                   Z-ADD     0             RRN2              5 0                         LN021
     C                   SETON                                        22                       LN021
     C                   SETOFF                                       21                       LN021
     C                   WRITE     FC0205C2                                                    LN021
     C                   SETOFF                                       22                       LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   SETON                                        02                       LN021
      *                                                                   LN0210
      ** Process all report suffixes and load into subfile                LN0210
      *                                                                   LN0210
     C******IN81         DOWEQ     '0'                                                LN021 MD055265
     C                   DOW       SQLCODE = 0                                              MD055265
      *                                                                   LN0210
      ** Set Subfile fileds                                               LN0210
      *                                                                   LN0210
     C                   MOVE      DYRSFX        SRSFX                                         LN021
     C                   MOVE      DYPFTX        SPFTX                                         LN021
      *                                                                   LN0210
      ** Check for existing details for the suffix being processed        LN0210
      *                                                                   LN0210
     C     ARCDK         SETLL     MAARCDL2                               85                   LN021
      *                                                                   LN0210
      ** If details exist, set select field to '1' and record exists      LN0210
      ** flag to Yes. Set on SFLNXTCHG to enable READC operation later    LN0210
      *                                                                   LN0210
     C     *IN85         IFEQ      '1'                                                         LN021
     C                   MOVE      'Y'           SEXSTX                                        LN021
     C                   MOVE      '1'           SSELX                                         LN021
     C                   SETON                                            20                   LN021
     C                   ELSE                                                                  LN021
      *                                                                   LN0210
      ** If no records exist, blank subfile fields and set off SFLNXTCHG  LN0210
      *                                                                   LN0210
     C                   MOVE      'N'           SEXSTX                                        LN021
     C                   MOVE      *BLANK        SSELX                                         LN021
     C                   SETOFF                                           20                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      ** Write subfile record                                             LN0210
      *                                                                   LN0210
     C                   ADD       1             RRN2                                          LN021
     C                   WRITE     FC0205S2                                                    LN021
      *                                                                   LN0210
      ** Access next suffix detail                                        LN0210
      *                                                                   LN0210
     C*****RNAM*         READE     FCRSFXL1                               81          LN021 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from ACursor into :FCRSFX                                                MD055265
     C/END-EXEC                                                                             MD055265
      *                                                                   LN0210
      ** Ignore if audit report section                                   LN0210
      *                                                                   LN0210
     C     DYAURP        IFEQ      'Y'                                                         LN021
     C*****RNAM*         READE     FCRSFXL1                               81          LN021 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from ACursor into :FCRSFX                                                MD055265
     C/END-EXEC                                                                             MD055265
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      ** Validate Suffixes Screen                                         LN0210
      *                                                                   LN0210
     C                   EXSR      VALRSX                                                      LN021
      *                                                                   LN0210
     C                   ENDSR                                                                 LN021
     C******************************************************************* LN0210
      /EJECT                                                              LN0210
     C******************************************************************* LN0210
     C*                                                                   LN0210
     C*  S/R VALRSX - TO VALIDATE SUFFIX SELECTION SCREEN                 LN0210
     C*  CALLED FROM RSFXS                                                LN0210
     C*  CALLS                                                            LN0210
     C*                                                                   LN0210
     C******************************************************************* LN0210
      *                                                                   LN0210
     C     VALRSX        BEGSR                                                                 LN021
      *                                                                   LN0210
      **               Set on SFLNXTCHG                                   LN0210
      *                                                                   LN0210
     C                   SETON                                        202123                   LN021
     C                   SETON                                        71                       LN021
     C                   SETOFF                                       72                       LN021
     C                   MOVE      'N'           SELCT                                         LN021
     C                   WRITE     FC0205F1                                                    LN021
     C                   WRITE     FC0205F2                                                    LN021
     C                   WRITE     FC0205C1                                                    LN021
     C                   EXFMT     FC0205C2                                                    LN021
      *                                                                   LN0210
      **               DOWHILE screen not valid                           LN0210
      *                                                                   LN0210
     C     *IN71         DOWEQ     '1'                                                         LN021
     C     *IN03         ANDEQ     '0'                                                         LN021
     C     *IN12         ANDEQ     '0'                                                         LN021
      *                                                                   LN0210
     C                   SETOFF                                       7135                     LN021
     C                   CALL      'ZA0250'                                                    LN021
      *                                                                   LN0210
      **               Read Changed Subfile Records                       LN0210
      *                                                                   LN0210
     C                   READC     FC0205S2                               83                   LN021
      *                                                                   LN0210
      **               DOWHILE changed subfile records remain             LN0210
      *                                                                   LN0210
     C     *IN83         DOWEQ     '0'                                                         LN021
      *                                                                   LN0210
      **                    IF Subfile select is not '1'/blank            LN0210
      **                         Send error message                       LN0210
      *                                                                   LN0210
     C     SSELX         IFNE      '1'                                                         LN021
     C     SSELX         ANDNE     *BLANK                                                      LN021
     C                   SETON                                        713520                   LN021
     C                   CALL      'FCC0240'                                                   LN021
     C***********          PARM 'RCF0012' MSGID   7                LN0210 LN1186
     C                   PARM      'RCF1012'     MSGID                                         LN118
     C                   UPDATE    FC0205S2                                                    LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **     If selection made, or if record previously existed for       LN0210
      **     archive, set on SFLNXTCHG indicator for updates              LN0210
      *                                                                   LN0210
     C     SSELX         IFEQ      *BLANK                                                      LN021
     C     SEXSTX        ANDEQ     'Y'                                                         LN021
     C     SSELX         OREQ      '1'                                                         LN021
     C                   SETON                                        20                       LN021
     C                   SETOFF                                       35                       LN021
     C                   UPDATE    FC0205S2                                                    LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **     If record changed to have selection blanked out, and no      LN0210
      **     archive record previously existed, set of SFLNXTCHG          LN0210
      *                                                                   LN0210
     C     SSELX         IFEQ      *BLANK                                                      LN021
     C     SEXSTX        ANDNE     'Y'                                                         LN021
     C                   SETOFF                                       3520                     LN021
     C                   UPDATE    FC0205S2                                                    LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **     If an attempt has been made to select an archive, reset      LN0210
      **     warning flags                                                LN0210
      *                                                                   LN0210
     C     SSELX         IFNE      *BLANK                                                      LN021
     C                   MOVE      'Y'           SELCT             1                           LN021
     C                   SETOFF                                       72                       LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    Read changed records                          LN0210
      *                                                                   LN0210
     C                   READC     FC0205S2                               83                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **               IF no selection has been made                      LN0210
      **               AND no warning is currently                        LN0210
      **               displayed                                          LN0210
      **                    Send Warning message                          LN0210
      *                                                                   LN0210
     C     SELCT         IFEQ      'N'                                                         LN021
     C     *IN72         ANDEQ     '0'                                                         LN021
     C                   SETON                                        7172                     LN021
     C                   CALL      'FCC0240'                                                   LN021
     C***********          PARM 'RCF0011' MSGID   7                LN0210 LN1186
     C                   PARM      'RCF1011'     MSGID                                         LN118
     C                   END                                                                   LN021
      *                                                                   LN0210
      ** Display screen if still in error: reset warning flag             LN0210
      *                                                                   LN0210
     C     *IN71         IFEQ      '1'                                                         LN021
     C                   MOVE      'N'           SELCT                                         LN021
     C                   WRITE     FC0205F1                                                    LN021
     C                   WRITE     FC0205F2                                                    LN021
     C                   WRITE     FC0205C1                                                    LN021
     C                   EXFMT     FC0205C2                                                    LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      **    Subfile valid, further processing required                    LN0210
      *                                                                   LN0210
     C     *IN71         IFEQ      '0'                                                         LN021
     C     *IN03         ANDEQ     '0'                                                         LN021
     C     *IN12         ANDEQ     '0'                                                         LN021
     C     SELCT         ANDEQ     'Y'                                                         LN021
     C                   MOVE      'Y'           ARCHF             1                           LN021
     C                   MOVE      'N'           RSFXF                                         LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **    Subfile valid, no selection made                              LN0210
      *                                                                   LN0210
     C     *IN71         IFEQ      '0'                                                         LN021
     C     *IN03         ANDEQ     '0'                                                         LN021
     C     *IN12         ANDEQ     '0'                                                         LN021
     C     SELCT         ANDEQ     'N'                                                         LN021
     C                   MOVE      'N'           SARMF                                         LN021
     C                   MOVE      'N'           SAROD                                         LN021
     C                   MOVE      'Y'           UPDF                                          LN021
     C                   MOVE      'N'           RSFXF                                         LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      ** Exit requested                                                   LN0210
      *                                                                   LN0210
     C     *IN03         IFEQ      '1'                                                         LN021
     C                   MOVE      'E'           CMD
     C                   MOVE      'T'           ACTN
     C                   EXSR      END
     C                   END
      *                                                                   LN0210
      ** Previous screen requested                                        LN0210
      *                                                                   LN0210
     C     *IN12         IFEQ      '1'                                                         LN021
     C                   MOVE      'Y'           OUTPF                                         LN021
     C                   MOVE      'N'           RSFXF                                         LN021
     C                   SETOFF                                       12                       LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   ENDSR                                                                 LN021
      ******************************************************************* LN0210
      /EJECT                                                              LN0210
     C******************************************************************* LN0210
     C*                                                                   LN0210
     C*  S/R SETSUB - TO LOAD SUBFILE OF ARCHIVE IDENTIFIERS              LN0210
     C*  CALLED FROM ARCHS                                                LN0210
     C*                                                                   LN0210
     C******************************************************************* LN0210
     C*                                                                   LN0210
     C     SETSUB        BEGSR                                                                 LN021
      *                                                                   LN0210
      **     Set to beginning of subfile                                  LN0210
      *                                                                   LN0210
     C                   Z-ADD     1             RRN2              5 0                         LN021
     C                   READC     FC0205S2                               83                   LN021
      *                                                                   LN0210
      ** Read next record if not selected                                 LN0210
      *                                                                   LN0210
     C     SSELX         IFNE      '1'                                                         LN021
     C                   SETON                                        20                       LN021
     C                   UPDATE    FC0205S2                                                    LN021
     C                   READC     FC0205S2                               83                   LN021
     C                   SETOFF                                       20                       LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     *IN01         IFEQ      '1'                                                         LN021
     C                   Z-ADD     0             RRN                                           LN021
     C                   SETON                                        22                       LN021
     C                   SETOFF                                       21                       LN021
     C                   WRITE     FC0205C0                                                    LN021
     C                   SETOFF                                       22                       LN021
     C                   END                                                                   LN021
     C                   SETON                                        01                       LN021
     C                   MOVE      'N'           SEXST                                         LN021
     C                   SETOFF                                       20                       LN021
      *                                                                   LN0210
      **               DOWHILE changed records                            LN0210
      *                                                                   LN0210
     C     *IN83         DOWEQ     '0'                                                         LN021
      *                                                                   LN0210
      **                    Access Archive Id's for the required medium   LN0210
      *                                                                   LN0210
     C     *LIKE         DEFINE    EAMEDM        KMEDM                                         LN021
      *                                                                   LN0210
     C                   CALL      'ZA0250'                                                    LN021
      *                                                                   LN0210
     C     SARMF         IFEQ      'Y'                                                         LN021
     C     SAROD         ANDEQ     'N'                                                         LN021
     C                   MOVE      'M'           KMEDM                                         LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     SAROD         IFEQ      'Y'                                                         LN021
     C     SARMF         ANDEQ     'N'                                                         LN021
     C                   MOVE      'O'           KMEDM                                         LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     SAROD         IFEQ      'Y'                                                         LN021
     C     SARMF         ANDEQ     'Y'                                                         LN021
     C                   MOVE      *BLANK        KMEDM                                         LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     KMEDM         SETLL     MAARCHL2                                                    LN021
     C                   READ      MAARCHL2                               82                   LN021
      *                                                                   LN0210
      **                   Send error message if no Archive Id's availableLN0210
      *                                                                   LN0210
     C     *IN82         IFEQ      '1'                                                         LN021
     C     *IN82         OREQ      '0'                                                         LN021
     C     KMEDM         ANDNE     EAMEDM                                                      LN021
     C     KMEDM         ANDNE     *BLANK                                                      LN021
     C                   CALL      'FCC0240'                                                   LN021
     C***********          PARM 'RCF0010' MSGID   7                LN0210 LN1186
     C                   PARM      'RCF1010'     MSGID                                         LN118
      *                                                                   LN0210
     C     SARMF         IFEQ      'Y'                                                         LN021
     C                   SETON                                        33                       LN021
     C                   MOVE      'N'           SARMF                                         LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     SAROD         IFEQ      'Y'                                                         LN021
     C                   MOVE      'N'           SAROD                                         LN021
     C                   SETON                                        34                       LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **  RETURN TO OUTPUT SCREEN                                         LN0210
      *                                                                   LN0210
     C                   MOVE      'N'           ARCHF                                         LN021
     C                   MOVE      'Y'           OUTPF                                         LN021
     C                   MOVE      'Y'           NOARCH            1                           LN021
      *                                                                   LN0210
     C                   GOTO      SUBEND                                                      LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    DOWHILE Archive Id's exist for the media      LN0210
      **                         Write Subfile Record                     LN0210
      **                         Read Archive Id's for the media          LN0210
      **                    ENDDO                                         LN0210
      *                                                                   LN0210
     C     *IN82         DOWEQ     '0'                                                         LN021
     C     KMEDM         ANDEQ     *BLANK                                                      LN021
     C     *IN82         OREQ      '0'                                                         LN021
     C     KMEDM         ANDEQ     EAMEDM                                                      LN021
     C                   ADD       1             RRN                                           LN021
     C                   MOVE      EAARID        SARID                                         LN021
      *                                                                   LN0210
     C     EAMEDM        IFEQ      'O'                                                         LN021
     C                   MOVE      'OD'          SMFOD                                         LN021
     C                   END                                                                   S0138
     C**********           ELSE                                     LN0210S01382
      *                                                                   S01382
     C     EAMEDM        IFEQ      'M'                                                         S0138
     C                   MOVE      'MF'          SMFOD                                         LN021
     C                   END                                                                   LN021
      *                                                                   S01382
     C     EAMEDM        IFEQ      'B'                                                         S0138
     C                   MOVE      'B '          SMFOD                                         S0138
     C                   END                                                                   S0138
      *                                                                   LN0210
     C                   MOVE      EAADSC        SADSC                                         LN021
      *                                                                   LN0210
     C                   SETOFF                                       2035                     LN021
     C                   MOVE      'N'           SEXST                                         LN021
     C                   MOVE      *BLANK        SSEL                                          LN021
      *                                                                   LN0210
      ** Access corresponding archive details record                      LN0210
      *                                                                   LN0210
     C     ARCDKY        CHAIN     MAARCDL1                           89                       LN021
      *                                                                   LN0210
      ** If record exists, set subfile indicators: selected               LN0210
      **                                           record exists          LN0210
      **                                           SFLNXTCHG              LN0210
      *                                                                   LN0210
     C     *IN89         IFEQ      '0'                                                         LN021
     C                   MOVE      '1'           SSEL                                          LN021
     C                   MOVE      'Y'           SEXST                                         LN021
     C                   SETON                                        20                       LN021
     C                   EXCEPT    RELACD                                                      LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   WRITE     FC0205S0                                                    LN021
     C                   READ      MAARCHL2                               82                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    Read changed records                          LN0210
      *                                                                   LN0210
     C                   SETON                                        20                       LN021
     C                   UPDATE    FC0205S2                                                    LN021
     C                   SETOFF                                       20                       LN021
      *                                                                   LN0210
     C                   READC     FC0205S2                               83                   LN021
      *                                                                   LN0210
      ** Read next record if not selected                                 LN0210
      *                                                                   LN0210
     C     SSELX         IFNE      '1'                                                         LN021
     C                   SETON                                        20                       LN021
     C                   UPDATE    FC0205S2                                                    LN021
     C                   READC     FC0205S2                               83                   LN021
     C                   SETOFF                                       20                       LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   SETON                                        2123                     LN021
      *                                                                   LN0210
     C                   EXSR      ARCHV                                                       LN021
      *                                                                   LN0210
     C     SUBEND        ENDSR                                                                 LN021
     C******************************************************************* LN0210
      *EJECT************************************************************* LN0210
     C******************************************************************* LN0210
     C******************************************************************* LN0210
     C*  S/R ARCHS - TO PERFORM ARCHIVING SCREEN PROCESSING************** LN0210
     C*  CALLED FROM MAIN************************************************ LN0210
     C******************************************************************* LN0210
     C******************************************************************* LN0210
      ******************************************************************* LN0210
     C********** ARCHS*****BEGSR***************************************** LN0210
      ******************************************************************* LN0210
      **********************Delete all archiving if not required********* LN0210
      ******************************************************************* LN0210
     C********** SAROD*****IFEQ 'N'************************************** LN0210
     C********** SARMF*****ANDEQ'N'************************************** LN0210
      ******************************************************************* LN0210
     C********** RREQKY    SETLLMAARCDL2********************************* LN0210
     C********** RREQKY    READEMAARCDL2***************  88************** LN0210
      ******************************************************************* LN0210
     C********** *IN88*****DOWEQ'0'************************************** LN0210
     C******************** DELET@ARCDAO********************************** LN0210
     C********** RREQKY    READEMAARCDL2***************  88************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** GOTO ENDAS************************************ LN0210
      ******************************************************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
      **********************Delete Optical Disk if not required********** LN0210
      ******************************************************************* LN0210
     C********** SAROD*****IFEQ 'N'************************************** LN0210
     C********** D5AROD    ANDEQ'Y'************************************** LN0210
      ******************************************************************* LN0210
     C********** RREQKY    SETLLMAARCDL2********************************* LN0210
     C********** RREQKY    READEMAARCDL2***************  88************** LN0210
      ******************************************************************* LN0210
     C********** *IN88*****DOWEQ'0'************************************** LN0210
     C********** EBARID    CHAINMAARCHL1**********   89****************** LN0210
      ******************************************************************* LN0210
      **  Database error if Archive Identifier not found***************** LN0210
      ******************************************************************* LN0210
     C********** *IN89*****IFEQ '0'************************************** LN0210
     C********** EAMEDM    ANDEQ'O'************************************** LN0210
     C******************** DELET@ARCDAO********************************** LN0210
     C******************** END******************************************* LN0210
     C********** *IN89*****IFEQ '1'************************************** LN0210
     C********** *LOCK*****IN   LDA************************************** LN0210
     C******************** MOVEL'MAARCHL1'DBFILE************************* LN0210
     C******************** MOVELEBARID    DBKEY**********  ************** LN0210
     C******************** Z-ADD1*****    DBASE**********  * DBERR 001 *  LN0210
     C******************** EXSR DBERR********************  ************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********** RREQKY    READEMAARCDL2***************  88************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
      **********************Delete Microfiche archiving if not required * LN0210
      ******************************************************************* LN0210
     C********** D5ARMF    IFEQ 'Y'************************************** LN0210
     C********** SARMF*****ANDEQ'N'************************************** LN0210
      ******************************************************************* LN0210
     C********** RREQKY    SETLLMAARCDL2********************************* LN0210
     C********** RREQKY    READEMAARCDL2***************  88************** LN0210
      ******************************************************************* LN0210
     C********** *IN88*****DOWEQ'0'************************************** LN0210
     C********** EBARID    CHAINMAARCHL1**********   89****************** LN0210
      ******************************************************************* LN0210
     C********** *IN89*****IFEQ '0'************************************** LN0210
     C********** EAMEDM    ANDEQ'M'************************************** LN0210
     C******************** DELET@ARCDAO********************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
      **  Database error if Archive Identifier not found***************** LN0210
      ******************************************************************* LN0210
     C********** *IN89*****IFEQ '1'************************************** LN0210
     C********** *LOCK*****IN   LDA************************************** LN0210
     C******************** MOVEL'MAARCHL1'DBFILE************************* LN0210
     C******************** MOVELEBARID    DBKEY**********  ************** LN0210
     C******************** Z-ADD2*****    DBASE**********  * DBERR 002 *  LN0210
     C******************** EXSR DBERR********************  ************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********** RREQKY    READEMAARCDL2***************  88************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
      **********************Access report suffixes for this report******* LN0210
      ******************************************************************* LN0210
     C******************** MOVEA*BLANK    SFX**************************** LN0210
     C******************** Z-ADD1*****    X*****  10********************* LN0210
      ******************************************************************* LN0210
     C********** RNAM***** SETLLFCRSFXL1********************************* LN0210
     C********** RNAM***** READEFCRSFXL1***************  81************** LN0210
      ******************************************************************* LN0210
      **********************ERROR IF no records found******************** LN0210
      ******************************************************************* LN0210
     C********** *IN81*****IFEQ '1'************************************** LN0210
     C********** *LOCK*****IN   LDA************************************** LN0210
     C******************** MOVEL'FCRSFXL1'DBFILE************************* LN0210
     C******************** MOVELRNAM***** DBKEY**********  ************** LN0210
     C******************** Z-ADD3*****    DBASE**********  * DBERR 003 *  LN0210
     C******************** EXSR DBERR********************  ************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
      ***************************Set print suffix to blank for midas/q  * LN0210
      ******************************************************************* LN0210
     C********** *IN85*****IFEQ '1'************************************** LN0210
     C******************** MOVE 'NA'***** SFX,1************************** LN0210
     C******************** Z-ADD2*****    X****************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********** *IN81*****DOWEQ'0'************************************** LN0210
      ******************************************************************* LN0210
     C********** DYRSFX    IFNE 'A'************************************** LN0210
     C******************** MOVE DYRSFX    SFX,X************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** ADD  1*****    X****************************** LN0210
     C********** RNAM***** READEFCRSFXL1***************  81************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
      **********************Access Archive Id's for the required medium * LN0210
      ******************************************************************* LN0210
     C********** SARMF*****IFEQ 'Y'************************************** LN0210
     C********** SAROD*****ANDEQ'N'************************************** LN0210
     C******************** MOVE 'M'*****  KMEDM************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********** SAROD*****IFEQ 'Y'************************************** LN0210
     C********** SARMF*****ANDEQ'N'************************************** LN0210
     C******************** MOVE 'O'*****  KMEDM************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********** SAROD*****IFEQ 'Y'************************************** LN0210
     C********** SARMF*****ANDEQ'Y'************************************** LN0210
     C******************** MOVE *BLANK    KMEDM************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********** KMEDM*****SETLLMAARCHL2********************************* LN0210
     C******************** READ MAARCHL2***************  82************** LN0210
      ******************************************************************* LN0210
      *****************    Send error message if no Archive Id's availableLN0210
      ******************************************************************* LN0210
     C********** *IN82*****IFEQ '1'************************************** LN0210
     C********** *IN82*****OREQ '0'************************************** LN0210
     C********** KMEDM*****ANDNEEAMEDM*********************************** LN0210
     C********** KMEDM*****ANDNE*BLANK*********************************** LN0210
     C******************** SETON******************** 70****************** LN0210
     C******************** CALL 'FCC0240'******************************** LN0210
     C******************** PARM 'RCF0010' MSGID   7********************** LN0210
      ******************************************************************* LN0210
     C********** SARMF*****IFEQ 'Y'************************************** LN0210
     C******************** SETON******************** 33****************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********** SAROD*****IFEQ 'Y'************************************** LN0210
     C******************** SETON******************** 34****************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** GOTO ENDAS************************************ LN0210
      ******************************************************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** Z-ADD1*****    Y*****  10********************* LN0210
      ******************************************************************* LN0210
     C******************** MOVEARNAM***** XNM**************************** LN0210
     C******************** Z-ADD1*****    Z*****  20********************* LN0210
     C********** ' '*****  LOKUPXNM,Z********************88************** LN0210
      ******************************************************************* LN0210
      **********************DOWHILE Records exist on Report Suffixes***** LN0210
      **********************for this report not equal to 'A'/'AU'******** LN0210
      **********************AND F3 is not taken************************** LN0210
      **********************AND F12 is not taken************************* LN0210
      ******************************************************************* LN0210
     C********** Y*****    DOWLTX**************************************** LN0210
      ******************************************************************* LN0210
     C******************** MOVE DXRDSC    SDESC************************** LN0210
      ******************************************************************* LN0210
     C********** *IN01*****IFEQ '1'************************************** LN0210
     C******************** Z-ADD0*****    RRN**************************** LN0210
     C******************** SETON******************** 22****************** LN0210
     C******************** SETOF******************** 21****************** LN0210
     C******************** WRITEFC0205C0********************************* LN0210
     C******************** SETOF******************** 22****************** LN0210
     C******************** END******************************************* LN0210
     C******************** SETON******************** 01****************** LN0210
      ******************************************************************* LN0210
      **********************DOWHILE Archive Id's exist for the media***** LN0210
      ***************************Write Subfile Record******************** LN0210
      ***************************Read Archive Id's for the media********* LN0210
      **********************ENDDO**************************************** LN0210
      ******************************************************************* LN0210
     C********** *IN82*****DOWEQ'0'************************************** LN0210
     C********** KMEDM*****ANDEQ*BLANK*********************************** LN0210
     C********** *IN82*****OREQ '0'************************************** LN0210
     C********** KMEDM*****ANDEQEAMEDM*********************************** LN0210
      ******************************************************************* LN0210
     C********** ACTN***** IFEQ 'A'************************************** LN0210
     C********** SARMF*****ANDEQ'Y'************************************** LN0210
     C********** D5ARMF    ANDEQ'Y'************************************** LN0210
     C********** ACTN***** OREQ 'A'************************************** LN0210
     C********** SAROD*****ANDEQ'Y'************************************** LN0210
     C********** D5AROD    ANDEQ'Y'************************************** LN0210
     C********** ARCDKY    KLIST***************************************** LN0210
     C******************** KFLD********** D5RNAM************************* LN0210
     C******************** KFLD********** D5RQSQ************************* LN0210
     C******************** KFLD********** SUFFIX************************* LN0210
     C******************** MOVE 'N'*****  SEXST************************** LN0210
      ******************************************************************* LN0210
     C********** ARCDKY    CHAINMAARCDL2**********   89****************** LN0210
     C********** *IN89*****IFEQ '0'************************************** LN0210
     C******************** MOVE '1'*****  SSEL*************************** LN0210
     C******************** MOVE 'Y'*****  SEXST************************** LN0210
     C******************** SETON******************** 20****************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** ADD  1*****    RRN**************************** LN0210
     C******************** MOVE EAARID    SARID************************** LN0210
     C********** EAMEDM    IFEQ 'O'************************************** LN0210
     C******************** MOVE 'Optical' SMFOD************************** LN0210
     C******************** ELSE****************************************** LN0210
     C******************** MOVE 'Fiche  ' SMFOD************************** LN0210
     C******************** END******************************************* LN0210
     C******************** MOVE EAADSC    SADSC************************** LN0210
     C******************** WRITEFC0205S0********************************* LN0210
     C******************** SETOF******************** 20****************** LN0210
     C******************** READ MAARCHL2***************  82************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********** SFX,Y*****IFEQ 'NA'************************************* LN0210
     C******************** MOVEAXNM*****  PGMSFX************************* LN0210
     C******************** MOVE *BLANK    SUFFIX 10********************** LN0210
     C******************** ELSE****************************************** LN0210
     C******************** MOVEASFX,Y*****XNM,Z************************** LN0210
     C******************** MOVE SFX,Y*****SUFFIX************************* LN0210
     C******************** MOVEAXNM*****  PGMSFX************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** SETON******************** 2123**************** LN0210
      ******************************************************************* LN0210
     C******************** WRITEFC0205F1********************************* LN0210
     C******************** WRITEFC0205F2********************************* LN0210
     C******************** WRITEFC0205C1********************************* LN0210
     C******************** EXFMTFC0205C0********************************* LN0210
      ******************************************************************* LN0210
      ******************************************************************* LN0210
     C******************** EXSR ARCHV************************************ LN0210
      ******************************************************************* LN0210
      ************IF Command key 12 has been taken*********************** LN0210
      *****************Issue ROLLBACK************************************ LN0210
      *****************Return to main screen***************************** LN0210
      ******************************************************************* LN0210
     C********** *IN12*****IFEQ '1'************************************** LN0210
     C********** *IN03*****OREQ '1'************************************** LN0210
     C******************** SETON******************** 70****************** LN0210
     C******************** ROLBK***************************************** LN0210
     C******************** Z-ADDX*****    Y****************************** LN0210
     C******************** ELSE****************************************** LN0210
      ******************************************************************* LN0210
     C******************** ADD  1*****    Y****************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********** ENDAS*****ENDSR***************************************** LN0210
     C******************************************************************* LN0210
      /EJECT
     C********************************************************************
     C*
     C*  S/R ARCHV - TO VALIDATE CHANGED S/FILE RECORDS FOR A PRINT SUFFIX
     C*  CALLED FROM MAIN
     C*
     C********************************************************************
     C     ARCHV         BEGSR
      *
      **               Set on SFLNXTCHG                                   LN0210
      *                                                                   LN0210
     C                   SETON                                        202171                   LN021
     C                   SETOFF                                       72                       LN021
     C                   WRITE     FC0205F1                                                    LN021
     C                   WRITE     FC0205F2                                                    LN021
     C                   WRITE     FC0205C1                                                    LN021
     C                   EXFMT     FC0205C0                                                    LN021
     C******************** SETOF                     7275
     C                   MOVE      'N'           SELCT
      *
      **               DOWHILE screen not valid
      *
     C********** *IN75     DOWEQ'0'                                       LN0210
     C     *IN71         DOWEQ     '1'                                                         LN021
     C     *IN03         ANDEQ     '0'
     C     *IN12         ANDEQ     '0'
      *
     C                   SETOFF                                       7135
     C                   CALL      'ZA0250'
      *
      **               Read Changed Subfile Records
      *
     C                   READC     FC0205S0                               83
      *
      **               DOWHILE changed subfile records remain
      **                    IF Subfile select is not '1'/blank
      **                         Send error message
      **                         Read changed subfile records
      *
     C     *IN83         DOWEQ     '0'
      *
     C     SSEL          IFNE      '1'
     C     SSEL          ANDNE     *BLANK
      *
      **               Set on ERROR
      *
     C                   SETON                                        713520
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0012' MSGID   7                       LN1186
     C                   PARM      'RCF1012'     MSGID                                         LN118
     C                   UPDATE    FC0205S0
     C                   END
      *                                                                   LN0210
      **     If selection made, or if record previously existed for       LN0210
      **     archive, set on SFLNXTCHG indicator for updates              LN0210
      *                                                                   LN0210
     C     SSEL          IFEQ      *BLANK                                                      LN021
     C     SEXST         ANDEQ     'Y'                                                         LN021
     C     SSEL          OREQ      '1'                                                         LN021
     C                   SETON                                        20                       LN021
     C                   SETOFF                                       35                       LN021
     C                   UPDATE    FC0205S0                                                    LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **     If record changed to have selection blanked out, and no      LN0210
      **     archive record previously existed, set of SFLNXTCHG          LN0210
      *                                                                   LN0210
     C     SSEL          IFEQ      *BLANK                                                      LN021
     C     SEXST         ANDNE     'Y'                                                         LN021
     C                   SETOFF                                       3520                     LN021
     C                   UPDATE    FC0205S0                                                    LN021
     C                   END                                                                   LN021
      ********************************************************************LN0210
      **  If records to be added or deleted, set on SFLNXTCHG to read*****LN0210
      **  in next READC cycle*********************************************LN0210
      ********************************************************************LN0210
     C********   SSEL****  IFEQ '1'***************************************LN0210
     C********   SEXST**** OREQ 'Y'***************************************LN0210
      ********************************************************************LN0210
     C******************** SETOF******************** 35*******************LN0210
      ********************************************************************LN0210
      **************   Set on SFLNXTCHG***********************************LN0210
      ********************************************************************LN0210
     C******************** SETON******************** 20*******************LN0210
      ********************************************************************LN0210
     C******************** UPDATFC0205S0**********************************LN0210
     C******************** END********************************************LN0210
      ********************************************************************LN0210
      **  If Selection has been removed, and a record did not previously**LN0210
      **  exist, set off error indicator and SFLNXTCHG********************LN0210
      ********************************************************************LN0210
     C********   SSEL****  IFEQ *BLANK************************************LN0210
     C********   SEXST**** ANDNE'Y'***************************************LN0210
     C******************** SETOF******************** 3520*****************LN0210
     C******************** UPDATFC0205S0**********************************LN0210
     C******************** END********************************************LN0210
      *
      **  If any entry has been made on the screen, do not send warning
      **  message
      *
     C     SSEL          IFNE      *BLANK
     C                   MOVE      'Y'           SELCT             1
     C                   SETOFF                                       72
     C                   END
      *
     C                   READC     FC0205S0                               83
     C                   END
      *
      **               IF no selection has been made
      **               AND no warning is currently
      **               displayed
      **                    Send Warning message
      **               Otherwise
      *
     C     SELCT         IFEQ      'N'
     C     *IN72         ANDEQ     '0'
     C                   SETON                                        7172
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0011' MSGID   7                       LN1186
     C                   PARM      'RCF1011'     MSGID                                         LN118
     C                   END
      ********************************************************************LN0210
      **************   DOWHILE changed records****************************LN0210
      **********************Write Archive Contents************************LN0210
      **********************Daily Record**********************************LN0210
      **********************Read changed records**************************LN0210
      ********************************************************************LN0210
     C********   *IN71**** IFEQ '0'***************************************LN0210
      ********************************************************************LN0210
     C******************** SETON******************** 75*******************LN0210
     C******************** Z-ADD1******** RRN**** 50**********************LN0210
     C******************** READCFC0205S0**************** 83***************LN0210
      ********************************************************************LN0210
     C********   *IN83**** DOWEQ'0'***************************************LN0210
      ********************************************************************LN0210
      **  If this archive has been selected for the first time, write*****LN0210
      **  details to Daily Archiving file*********************************LN0210
      ********************************************************************LN0210
     C********   SSEL****  IFEQ '1'***************************************LN0210
     C********   SEXST**** ANDEQ'N'***************************************LN0210
     C******************** MOVE SARID**** EBARID**************************LN0210
     C******************** MOVE RNAM****  EBRNAM**************************LN0210
     C******************** MOVE RQSQ****  EBRQSQ**************************LN0210
     C******************** MOVE SUFFIX****EBRSFX**************************LN0210
     C******************** MOVE 'N'****   EBCFLG**************************LN0210
     C******************** MOVE 'N'****   EBACFL**************************LN0210
     C******************** WRITEMAARCDD0**********************************LN0210
     C******************** ELSE*******************************************LN0210
      ********************************************************************LN0210
      **  If a record previously existed, but the archive has not been****LN0210
      **  selected, delete old details************************************LN0210
      ********************************************************************LN0210
     C******************** MOVE SARID**** EAARID**************************LN0210
     C********   ARCDKY****CHAINMAARCDL2************ 89*******************LN0210
     C**N89****************DELET@ARCDAO***********************************LN0210
     C******************** END********************************************LN0210
      ********************************************************************LN0210
     C******************** READCFC0205S0**************** 83***************LN0210
     C******************** END********************************************LN0210
      ********************************************************************LN0210
      **  If screen is still invalid, reset warning indicator and*********LN0210
      **  re-display screen***********************************************LN0210
      ********************************************************************LN0210
     C******************** ELSE*******************************************LN0210
      *                                                                   LN0210
      ** If screen is not valid, redisplay                                LN0210
      *                                                                   LN0210
     C     *IN71         IFEQ      '1'                                                         LN021
     C                   MOVE      'N'           SELCT
     C                   WRITE     FC0205F1
     C                   WRITE     FC0205F2
     C                   WRITE     FC0205C1
     C                   EXFMT     FC0205C0
     C                   END
      *
     C                   END
      *                                                                   LN0210
      **    Subfile valid, but no archive records selected                LN0210
      *                                                                   LN0210
     C     *IN71         IFEQ      '0'                                                         LN021
     C     *IN03         ANDEQ     '0'                                                         LN021
     C     *IN12         ANDEQ     '0'                                                         LN021
     C     SELCT         ANDEQ     'N'                                                         LN021
     C                   MOVE      'N'           SARMF                                         LN021
     C                   MOVE      'N'           SAROD                                         LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **    Subfile valid, proceed to updating                            LN0210
      *                                                                   LN0210
     C     *IN71         IFEQ      '0'                                                         LN021
     C     *IN03         ANDEQ     '0'                                                         LN021
     C     *IN12         ANDEQ     '0'                                                         LN021
     C                   MOVE      'N'           ARCHF                                         LN021
     C                   MOVE      'Y'           UPDF                                          LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      ** Exit requested                                                   LN0210
      *                                                                   LN0210
     C     *IN03         IFEQ      '1'                                                         LN021
     C                   MOVE      'E'           CMD                                           LN021
     C                   MOVE      'T'           ACTN                                          LN021
     C                   EXSR      END                                                         LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      ** Previous screen requested                                        LN0210
      *                                                                   LN0210
     C     *IN12         IFEQ      '1'                                                         LN021
     C                   MOVE      'Y'           RSFXF                                         LN021
     C                   MOVE      'N'           ARCHF                                         LN021
     C                   SETOFF                                       12                       LN021
     C                   END                                                                   LN021
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R INIT2 - TO INITIALISE MAIN SCREEN
     C*  CALLED FROM MAIN
     C*
     C********************************************************************
      *
     C     INIT2         BEGSR
      *
      **          Access Installation Control Data
      *
     C                   CALL      'AORCFR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*FIRST'      P@APOP            7              I:Option
     C     D@RCF         PARM      D@RCF         DSFDY                            O:Rec format
      *
      **          IF no record is found
      **               Database error
      **          ENDIF
      *
     C     P@APRC        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDRCFPD'     DBFILE
     C                   MOVEL     'RCF'         DBKEY                          *************
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   EXSR      DBERR                                        *************
     C                   END
      *
      **          Access Midas Modules Data
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANK        P@APRC                           B:Return code
     C                   PARM      '*FIRST'      P@APOP            7              I:Option
     C     D@MMOD        PARM      D@MMOD        DSFDY                            O:Rec format
      *
      **          IF no record is found
      **               Database error
      **          ENDIF
      *
     C     P@APRC        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     'MMOD'        DBKEY                          *************
     C                   Z-ADD     5             DBASE                          * DBERR 005 *
     C                   EXSR      DBERR                                        *************
     C                   END
      *
      **          Set Screen conditioning indicators:
      **               Do not display archiving on Microfiche if MF
      **               not present
      *
     C     BGMFIC        COMP      'Y'                                    52
      *
      **               Do not display archiving on Optical Disk if OD
      **               not present
      *
     C     BGOPDK        COMP      'Y'                                    53
      *
      **               Do not display Distribution list fields, or
      **               Midas User field if Distribution is required
      *
     C     DRQD          IFEQ      'Y'
     C                   SETON                                        5051
     C                   END
      *
     C                   MOVE      RUNA          SRUNA
     C                   MOVE      JBNM          SWSID
      *
      **               Do not Display Distribution list fields if
      **               Office is not present
      *
     C     D0OFPR        COMP      'Y'                                    50
      *
      **               Write screen
      *
     C******************** WRITEFC0205C1                                  LN0210
     C******************** EXFMTFC0205F0                                  LN0210
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R INIT1 - TO INITIALISE PROGRAM VARIABLES
     C*  CALLED FROM MAIN
     C*
     C********************************************************************
     C     INIT1         BEGSR
     C*
     C     *LIKE         DEFINE    D5RNAM        RNAM
     C     *LIKE         DEFINE    D5RQSQ        RQSQ
     C     *LIKE         DEFINE    D5COTT        COTT
     C     *LIKE         DEFINE    D5CSEQ        CSEQ
     C     *LIKE         DEFINE    D5LVL         LVL
     C     *LIKE         DEFINE    D5ETTY        ETTY
     C     *LIKE         DEFINE    D5LVL         KLVL
     C     *LIKE         DEFINE    D5ETTY        KETTY
     C     *LIKE         DEFINE    D5DRQD        DRQD
     C/COPY WNCPYSRC,FC0205C005
     C     *LIKE         DEFINE    D7PARM        PARM
     C/COPY WNCPYSRC,FC0205C006
     C     *LIKE         DEFINE    SSOID         KSOID
     C     *LIKE         DEFINE    EAARID        KARID
      *
     C     RREQKY        KLIST
     C                   KFLD                    KRNAM
     C                   KFLD                    KRQSQ
      *
     C     SOIKEY        KLIST
     C                   KFLD                    KSOID
      *                                                                   043702
      ** DISTRIBUTION LIST FILE KEY                                       043702
      *                                                                   043702
     C     KDLIST        KLIST                                                                 04370
     C                   KFLD                    KDIST1            8                           04370
     C                   KFLD                    KDIST2            8                           04370
      *                                                                   LN0210
      ** ARCHIVING FILE: PARTIAL KEY                                      LN0210
      *                                                                   LN0210
     C     ARCDKP        KLIST                                                                 LN021
     C                   KFLD                    KRNAM                                         LN021
     C                   KFLD                    KRQSQ                                         LN021
      *                                                                   LN0210
      ** ARCHIVING FILE: KEY FOR CHAINING                                 LN0210
      *                                                                   LN0210
     C     ARCDK         KLIST                                                                 LN021
     C                   KFLD                    KRNAM                                         LN021
     C                   KFLD                    KRQSQ                                         LN021
     C                   KFLD                    SRSFX                                         LN021
      *                                                                   LN0210
      ** ARCHIVING FILE: KEY FOR CHAINING                                 LN0210
      *                                                                   LN0210
     C     ARCDKY        KLIST                                                                 LN021
     C                   KFLD                    SARID                                         LN021
     C                   KFLD                    KRQSQ                                         LN021
     C                   KFLD                    KRNAM                                         LN021
     C                   KFLD                    SRSFX                                         LN021
      ********************************************************************LN0210
     C********   ARCHKY****KLIST******************************************LN0210
     C******************** KFLD********   KMEDM***************************LN0210
     C******************** KFLD********   KARID***************************LN0210
     C/COPY WNCPYSRC,FCH00002
      *
      **          Access Dataarea RUNDAT
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'FC0205'      DBPGM
     C                   OUT       LDA
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
     C                   MOVEL     '*'           SPGMQ
     C                   CALL      'ZA0250'
     C                   SETON                                        60
      *
      **     Access MUSER for current user
      *
     C     JUSR          CHAIN     MUSER                              84
      *
      **     IF no record is found
      **          Database error
      **     ENDIF
      *
     C     *IN84         IFEQ      '1'
     C     RECI          ORNE      'D'
     C     *LOCK         IN        LDA
     C                   MOVEL     'MUSER'       DBFILE
     C                   MOVEL     JUSR          DBKEY                          *************
     C                   Z-ADD     6             DBASE                          * DBERR 006 *
     C                   EXSR      DBERR                                        *************
     C                   END
      *
     C* Define 'Authority to Output Instructions' in a work field to      LN1170
     C* protect from overwriting the value for the requesting user        LN1170
     C*                                                                   LN1170
     C                   MOVE      ROUT          ROUT1             1                           LN117
     C*                                                                   LN1170
     C     *LIKE         DEFINE    DBRN          JDBRN
     C     *LIKE         DEFINE    OUTQ          JOUTQ
     C     *LIKE         DEFINE    MUREP         JMUREP
     C                   MOVE      DBRN          JDBRN
     C                   MOVE      OUTQ          JOUTQ
     C                   MOVE      MUREP         JMUREP
      *
      **     Access report descriptions file for default output Id
      *
     C                   CALL      'AOREPTR0'
     C                   PARM      '*DBERR'      P@APRC                           B:Return code
     C                   PARM      '*KEY'        P@APOP                           I:Option
     C                   PARM      RNAM          P@KEY            10              I:Report Name
     C     P@REPT        PARM      P@REPT        DSFDY                            O:Rec format
      *
     C                   MOVE      DXRDSC        SRDSC
     C                   MOVE      DXRNAM        SRNAM
      *
     C     DXMIDQ        COMP      'Y'                                    85
      *
      **     If action code is insert, set screen defaults
      *
     C     ACTN          IFEQ      'I'
     C/COPY WNCPYSRC,FCH00003
     C                   MOVE      DXDFTO        SSOID
     C/COPY WNCPYSRC,FCH00004
     C                   MOVE      'N'           SAROD
     C                   MOVE      'N'           SARMF
     C                   MOVE      RNAM          KRNAM
     C                   MOVE      RQSQ          KRQSQ
     C                   ELSE
     C*
      **     If action is amend, access current details from
      **      report requests file
     C*
     C                   MOVE      RNAM          KRNAM
     C                   MOVE      RQSQ          KRQSQ
     C     RREQKY        CHAIN     FCRREQL1                           86
     C*
     C     *IN86         IFEQ      '1'
     C                   CALL      'ZA0250'
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0023' MSGID                           LN1186
     C                   PARM      'RCF1023'     MSGID                                         LN118
     C                   WRITE     FC0205C1
     C                   SETON                                        54
     C*
      **       If report request has disappeared, alert the user
      **        and allow them to exit/return
     C*
     C     *IN03         DOWEQ     '0'
     C                   EXFMT     FC0205F0
     C                   END
     C*
     C     *IN03         IFEQ      '1'
     C                   MOVE      'E'           CMD
     C                   MOVE      'T'           ACTN
     C                   EXSR      END
     C                   END
     C*
     C                   END
     C*
     C     *LIKE         DEFINE    D5TNLU        OTNLU
     C                   MOVE      D5TNLU        OTNLU
     C*
      **     Set up screen fields from report request record
     C*
     C                   MOVE      D5AROD        SAROD
     C                   MOVE      D5ARMF        SARMF
     C                   MOVE      D5SOID        SSOID
     C*
      **         Only move distribution list and user Id fields
      **          to screen if distribution to co/br is not required
     C*
     C     DRQD          IFEQ      'N'
     C                   MOVE      D5DLS1        SDST1
     C                   MOVE      D5DLS2        SDST2
     C                   MOVE      D5USRO        SUSRO
     C                   END
     C*
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *COPY*ZSRSRC,ZTNLU1Z2                                                                 MD055265
      /COPY ZSRSRC,ZTNLU1Z4                                                                 MD055265
      /EJECT
     C********************************************************************
     C*
     C*  S/R DBERR - TO PROCESS DATABASE ERRORS AND TERMINATE PROGRAM
     C*  CALLED FROM
     C*
     C********************************************************************
     C*
     C     DBERR         BEGSR
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   RETURN
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R END - TO TERMINATE PROGRAM
     C*  CALLED FROM
     C*
     C********************************************************************
     C*
     C     END           BEGSR
     C/EXEC SQL                                                                             MD055265
     C+ close ACursor                                                                       MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R *PSSR - ERROR ROUTINE
     C*  CALLED FROM DBERR
     C*
     C********************************************************************
     C*
     C     *PSSR         BEGSR
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   MOVE      'E'           CMD
     C                   MOVE      'T'           ACTN
     C                   DUMP
     C                   END
     C                   ENDSR
     C********************************************************************
     O@EBREJR   E            RELACD                                             LN0210
      ********************************************************************
** CPY@
(c) Finastra International Limited 2001
