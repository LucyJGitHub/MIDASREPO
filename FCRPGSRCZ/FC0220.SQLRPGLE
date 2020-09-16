     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Mand output instructions maint')
/*O*RF*:*OVRDBF*(QAOKDL01)*(QAOKL01A)*******************************:**                       CAAA02
     F********************************************************************
     F*                                                                  *
     F*  Midas - Report Control Facility Module
     F*                                                                  *
     F*      FC0220 - MANDATORY REPORT OUTPUT INSTRUCTIONS               *
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
      *                 CSD027             Date 09Dec05               *
      *                 TDA035             Date 02Apr04               *
      *                 CAAA02             Date 01Dec03               *
      *                 CFC002             Date 29Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01407             Date 26Jan93               *
      *                 043702             Date 21Aug92               *
     F*                     S01382           DATE 19AUG92                *
     F*                     S01117           DATE 25MAR92                *
     F*                     S01269           DATE 25JUN91                *
     F*                     LN1151           DATE 23MAY91                *
     F*                     LN1186           DATE 03MAR91                *
     F*                     LN0210           DATE 18MAY90                *
     F*                                                                  *
     F********************************************************************
      *                                                                  *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CAAA02 - Webfacing. Rename QAOK* references to the V5R2 names.  *
      *  CFC002 - Multiple Output Queues In Std Output Instructions   *
      *           Recompiled due to change in FCSOUTPD                *
     F*      S01407 - SWITCHABILITY ENHANCEMENTS                         *
     F*      043702 - VALIDATE DISTRIBUTION LIST                         *
     F*      S01382 - OPTICAL DISK DEVELOPMENT.                          *
     F*               - IF THE ARCHIVE ID MEDIUM IS BOTH THEN 'B'        *
     F*                 SHOULD BE OUTPUT ON THE SCREEN AS THE MEDIUM.    *
     F*      S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD                 *
     F*      S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO
     F*               MUSERDD
     F*      LN1151 - SEND AN ERROR MESSAGE IF USER ATTEMPTS TO          *
     F*               ASSOCIATE A REPORT WITH A USER TO WHICH HE HAS NO  *
     F*               AUTHORITY.                                         *
     F*      LN1186 - SEND NEW MESSAGE ID FROM FCUSRMSG TO FCC0240       *
     F*      LN0210 - ARCHIVING OPTIONS TO BE ADDED TO THE REPORT        *
     F********************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
     F*                                                               *
     F****************************************************************
     FFC0220DF  CF   E             WORKSTN
     F                                     SFILE(FC0220S0:RRN)                  LN0210
     F                                     SFILE(FC0220S2:RRN2)                 LN0210
     FFCSOUTL1  IF   E           K DISK
     F***********FCREPTL1IF  E           K        DISK                    S01407
     F***********FCRCOML1IF  E           K        DISK                    S01407
     F*FCREPTJ0* IF   E           K DISK                                         S01407     MD055265
     F*FCRCOMJ1* IF   E           K DISK                                         S01407     MD055265
     F*FCRSFXL1* IF   E           K DISK                                         LN0210     MD055265
     FMUSER     IF   E           K DISK
     FFCMOUTL1  IF   E           K DISK
     FFCMOUTL0  UF A E           K DISK
     F                                     COMMIT
     F                                     INFDS(INFDS)
     FMAARCHL1  IF   E           K DISK                                         LN0210
     FMAARCHL2  IF   E           K DISK                                         LN0210
     FMAARCPL2  UF   E           K DISK                                         LN0210
     F                                     COMMIT                               LN0210
     FMAARCPL1  UF   E           K DISK                                         LN0210
     F                                     COMMIT                               LN0210
     FMAARCPL0  O    E           K DISK                                         LN0210
     F                                     COMMIT                               LN0210
     F                                     INFDS(INFDSA)                        LN0210
     FSDFCTLL0  UF   E           K DISK
     F                                     COMMIT
     F*QAOKDL01IF*E*****      K        DISK                                            043702 CAAA02
     FQAOKL01A  IF   E           K DISK
     F                                     IGNORE(WOSFMT01)                     043702
     F********************************************************************
     F*             FUNCTION OF INDICATORS
     F*
     F*  03         FUNCTION KEY 3 TAKEN FROM SCREEN
     F*  10         FUNCTION KEY 10 TAKEN FROM SCREEN
     F*  12         FUNCTION KEY 12 TAKEN FROM SCREEN
     F*  20         SFLNXTCHG INDICATOR
     F*  21         SFLDSP/SFLDSPCTL INDICATOR
     F*  22         SFLDLT INDICATOR
     F*  23         SFLEND INDICATOR
     F*  30         STANDARD OUTPUT INSTRUCTIONS ERROR INDICATOR
     F*  31         DISTRIBUTION LIST ERROR INDICATOR
     F*  32         USER ID FOR OUTPUT ERROR INDICATOR
     F*  33         ARCHIVE ON MICROFICHE ERROR INDICATOR
     F*  34         ARCHIVE ON OPTICAL DISK ERROR INDICATOR
     F*  35         SUBFILE SELECT ERROR INDICATOR
     F*  36         REPORT NAME ERROR
     F*  37         ASSOCIATED USER ERROR
     F*  38         DISTRIBUTION REQUIRED ERROR
     F*  50         OFFICE PRESENT
     F*  51         PROTECT USER ID, DIST LIST, AS DISTRIBUTION IS REQUIRED
     F*  52         MICROFICHE MODULE PRESENT
     F*  53         OPTICAL DISK MODULE PRESENT
     F*  54         PROTECT ALL FIELDS FOR ENQUIRY
     F*  56         ENABLE COMMAND 10 FOR DELETE
     F*  55         CHAIN FAIL TO FCMOUT FILE FOR INSERT CHECK
     F*  57         MULTIBRANCH SYSTEM
     F*  58         'KEY' SCREEN VALID: DISPLAY DETAILS
     F*  59         MAIN SCREEN VALID: DISPLAY OUTPUT INSTRUCTIONS
     F*  60         MESSAGE SUBFILE END
     F*  65         MANDATORY REPORT
     F*  70         ERROR ON SCREEN
     F*  71         ERROR ON ARCHIVING SCREEN                             LN0210
     F*  72         NO ARCHIVE ID'S SELECTED                              LN0210
     F*  75         ARCHIVE UPDATES PERFORMED                             LN0210
     F*  79         REPORT DESCRIPTIONS CHAIN FAIL
     F*  80         STANDARD OUTPUT INSTRUCTIONS NOT FOUND
     F*  84         CHAIN FAIL INDICATOR FOR MUSER
     F*  85         RECORDS FOR CURRENT SUFFIX EXIST                      LN0210
     F*  86         CHAIN FAIL TO FCMOUT ON AMEND
     F*
     F********************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D INFDS           DS
     D*
     D** DATA STRUCTURE FOR RPG 01021 ERROR HANDLING
     D*
     D***********************************  *STATUS  STATUS                LN0210
     D  MOSTAT           *STATUS                                                LN0210
     D*                                                                   LN0210
     D INFDSA          DS                                                       LN0210
     D*                                                                   LN0210
     D** DATA STRUCTURE FOR RPG 01021 ERROR HANDLING                      LN0210
     D*                                                                   LN0210
     D  APSTAT           *STATUS                                                LN0210
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
     D CMTTXT          DS            25
      *
      **  COMIT TEXT
     D  NATN                   1      5  0
     D  MDID                   6      7
     D  PGMN                   8     15
     D  WSIDX                 16     18
     D  MTIME                 19     24  0
     D  ACTCDX                25     25
     D REPSEQ          DS
     D*
     D** REPORT SEQUENCE NUMBER DATA AREA
     D*
     D  UUSEQ                  1      5  0
      *COPY*ZSRSRC ZTNLU1Z1                                                                 MD055265
      /COPY ZSRSRC,ZTNLU1Z3                                                                 MD055265
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D*
     D D@BANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** DATA STRUCTURE FOR BANK FILE ACCESS OBJECT
     D*
     D PSDS           SDS
     D*
     D** PROGRAM STATUS DATA STRUCTURE FOR USER ETC.
     D*
     D  JBNM                 244    253
     D  JUSR                 254    263
     D  JBNB                 264    269
     D P@RCF         E DS                  EXTNAME(SDRCFPD)
      * LF/SDRCFL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     D P@MMOD        E DS                  EXTNAME(SDMMODPD)
     D FCRCOM        E DS                  EXTNAME(FCRCOJW1)                                MD055265
     D**XSARD***     E                     EXTFLD(SARD)                            MD055265 MD055681
     D  XSARN        E                     EXTFLD(SARN)                                     MD055681
     D  XENABLD      E                     EXTFLD(ENABLD)                                   MD055681
     D*NullInds*       s              5i 0 dim(12)                                 MD055265 MD055681
     D NullInds        s              5i 0 dim(13)                                          MD055681
     D FCREPT        E DS                  EXTNAME(FCREPJW1)                                MD055265
     D*NullInds2       s              5i 0 dim(19)                                 MD055265 MD055681
     D NullInds2       s              5i 0 dim(20)                                          MD055681
     D FCRSFX        E DS                  EXTNAME(FCRSFJW0)                                MD055265
     I******************* SFX         8  2                                LN0210
     I******************* XNM        10  1                                LN0210
     IWOSFMT02                                                                  043702
     I              WOS2LDEN                    S2LDEN                          043702
     I              WOS2LDGN                    S2LDGN                          043702
     I              WOS2DESC                    S2DESC                          043702
     I              WOS2USRP                    S2USRP                          043702
     I              WOS2GCID                    S2GCID                          043702
     I              WOS2IND                     S2IND                           043702
      * LF/SDMMODL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      ** Input Parameters:
      **          Report Name
      **          Action Code
      **          Return Code
      *
     C     *ENTRY        PLIST
     C                   PARM                    RNAM
     C                   PARM                    ACTN              1
     C                   PARM                    RTCD              7
      *
     C                   EXSR      INIT1
      *
     C                   EXSR      INIT2
     C*
     C** ENQUIRE/DELETE PROCESSING
     C*
     C     ACTN          IFEQ      'D'                                                         LN021
     C********** ACTN      IFEQ 'E'                                       LN0210
     C********** ACTN      OREQ 'D'                                       LN0210
     C**********           EXSR ENQDEL                                    LN0210
     C                   EXSR      DELETE                                                      LN021
     C                   ELSE
     C*
     C** WRITE KEY SCREEN IF INSERT, OTHERWISE FIRST DETAIL
     C*
     C     ACTN          IFEQ      'I'
     C                   MOVE      'Y'           KEYF              1
     C                   END                                                                   LN021
      *                                                                   LN0210
     C******************** ELSE                                           LN0210
     C     ACTN          IFEQ      'A'                                                         LN021
     C                   MOVE      'Y'           MAINF             1
     C                   END
      *                                                                   LN0210
     C     ACTN          IFEQ      'E'                                                         LN021
     C                   MOVE      'Y'           OUTPF             1                           LN021
     C                   END                                                                   LN021
      *
      **          DOWHILE F3 is not taken or screen is invalid
      *
     C     KEYF          DOWEQ     'Y'
     C     MAINF         OREQ      'Y'
     C     OUTPF         OREQ      'Y'
     C     RSFXF         OREQ      'Y'                                                         LN021
     C     ARCHF         OREQ      'Y'                                                         LN021
     C     UPDF          OREQ      'Y'                                                         LN021
      *
      ** VALIDATE INITIAL SCREEN
      *
     C     KEYF          IFEQ      'Y'
     C                   EXSR      VALRPT
     C                   END
      *
      ** PROCESS MAIN SCREEN IF FIRST IS VALID
      *
     C     MAINF         IFEQ      'Y'
     C                   EXSR      VALINT
     C                   END
      *
      ** PROCESS OUTPUT SCREEN IF FIRST IS VALID
      *
     C     OUTPF         IFEQ      'Y'
     C                   EXSR      VALID
     C                   END
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
      *
     C                   END
      *******                                                             LN0210
      *******Issue*Commit*****************                                LN0210
      *******                                                             LN0210
     C*******    ACTN      IFNE 'E'                                       LN0210
     C*******              TIME           MTIME                           LN0210
     C*******    CMTTXT    COMIT                                          LN0210
     C*******              END                                            LN0210
      *
     C                   SETON                                        LR
      *
      /EJECT                                                              LN0210
     C********************************************************************
      *                INDEX OF SUBROUTINES
     C*  S/R INSAMD - TO PERFORM FILE UPDATES FOR INSERTION/AMENDMENT
     C*  S/R VALRPT - TO VALIDATE KEY SCREEN                              LN0210
     C*  S/R VALINT - TO VALIDATE INITIAL SCREEN                          LN0210
     C*  S/R VALID - TO VALIDATE MAIN SCREEN
     C*  S/R RSFXS - TO DISPLAY SUFFIX SELECTION SCREEN FOR ARCHIVING     LN0210
     C*  S/R VALRSX - TO VALIDATE SUFFIX SELECTION SCREEN                 LN0210
     C*  S/R SETSUB - TO LOAD SUBFILE OF ARCHIVE IDENTIFIERS              LN0210
     C*  S/R ARCHV - TO VALIDATE ARCHIVING SCREEN                         LN0210
     C*  S/R ENQDEL - TO PERFORM ENQUIRE/DELETION PROCESSING
     C*  S/R INIT2 - TO INITIALISE MAIN SCREEN
     C*  S/R INIT1 - TO INITIALISE PROGRAM VARIABLES
     C*  S/R UPDOWS - TO DISPLAY SCREEN ERROR IF UPDATE BY ANOTHER W/S
     C*  S/R DBERR - TO PROCESS DATABASE ERRORS AND TERMINATE PROGRAM
     C*  S/R END - TO TERMINATE PROGRAM
     C*  S/R *PSSR - ERROR ROUTINE
     C*  S/R ZTNLU1 - ACCESS NEXT AVAILABLE TRANSACTION NUMBER FROM MNATN
     C***S/R*ZDATE1*-*CONVERT*DATE*TO*DAYNO*******************************LN0210
     C***S/R*ZDATE2*-*CONVERT*DAYNO*TO*DATE*******************************LN0210
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R INSAMD - TO PERFORM FILE UPDATES FOR INSERTION/AMENDMENT
     C*  CALLED FROM MAIN
     C*  CALLS ZTNLU1, UPDOWS, DBERR
     C*
     C********************************************************************
      *
     C     INSAMD        BEGSR
      *
      **     Write report requests record
      **     IF parameters is not blank
      **          Write Parameters daily record
      **     ENDIF
      *
     C                   EXSR      ZTNLU1
      *
     C     SRNAM         CHAIN     FCMOUTL0                           86
      *
      **  IF TRANSACTION NUMBER HAS CHANGED, ALERT USER TO UPDATE
      *
     C     ACTN          IFEQ      'A'
     C     D2TNLU        ANDNE     PTNLU
     C***********          MOVE 'RCF0060' MSGID                           LN1186
     C                   MOVE      'RCF1060'     MSGID                                         LN118
     C                   EXSR      UPDOWS
     C                   END
      *
      **  IF RECORD HAS BEEN INSERTED, ALERT USER TO UPDATE
      *
     C     ACTN          IFEQ      'I'
     C     *IN86         ANDEQ     '0'
     C***********          MOVE 'RCF0064' MSGID                           LN1186
     C                   MOVE      'RCF1064'     MSGID                                         LN118
     C                   EXSR      UPDOWS
     C                   END
      *                                                                   LN0210
      **                    Delete all archiving if not required          LN0210
      *                                                                   LN0210
     C     SAROD         IFEQ      'N'                                                         LN021
     C     SARMF         ANDEQ     'N'                                                         LN021
      *                                                                   LN0210
     C     ARCPKP        SETLL     MAARCPL2                                                    LN021
     C     ARCPKP        READE     MAARCPL2                               88                   LN021
      *                                                                   LN0210
     C     *IN88         DOWEQ     '0'                                                         LN021
     C                   DELETE    @ARCPAP                                                     LN021
     C     ARCPKP        READE     MAARCPL2                               88                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    Delete Optical Disk if not required           LN0210
      *                                                                   LN0210
     C     SAROD         IFEQ      'N'                                                         LN021
     C     D2AROD        ANDEQ     'Y'                                                         LN021
      *                                                                   LN0210
     C     ARCPKP        SETLL     MAARCPL2                                                    LN021
     C     ARCPKP        READE     MAARCPL2                               88                   LN021
      *                                                                   LN0210
     C     *IN88         DOWEQ     '0'                                                         LN021
     C     ECARID        CHAIN     MAARCHL1                           89                       LN021
      *                                                                   LN0210
     C     *IN89         IFEQ      '0'                                                         LN021
     C     EAMEDM        ANDEQ     'O'                                                         LN021
     C                   DELETE    @ARCPAP                                                     LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     *IN89         IFEQ      '1'                                                         LN021
     C     *LOCK         IN        LDA                                                         LN021
     C                   MOVEL     'MAARCHL1'    DBFILE                                        LN021
     C                   MOVEL     ECARID        DBKEY                          *************  LN021
     C                   Z-ADD     8             DBASE                          * DBERR 008 *  LN021
     C                   EXSR      DBERR                                        *************  LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     ARCPKP        READE     MAARCPL2                               88                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    Delete Microfiche archiving if not required   LN0210
      *                                                                   LN0210
     C     D2ARMF        IFEQ      'Y'                                                         LN021
     C     SARMF         ANDEQ     'N'                                                         LN021
      *                                                                   LN0210
     C     ARCPKP        SETLL     MAARCPL2                                                    LN021
     C     ARCPKP        READE     MAARCPL2                               88                   LN021
      *                                                                   LN0210
     C     *IN88         DOWEQ     '0'                                                         LN021
     C     ECARID        CHAIN     MAARCHL1                           89                       LN021
      *                                                                   LN0210
     C     *IN89         IFEQ      '0'                                                         LN021
     C     EAMEDM        ANDEQ     'M'                                                         LN021
     C                   DELETE    @ARCPAP                                                     LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     *IN89         IFEQ      '1'                                                         LN021
     C     *LOCK         IN        LDA                                                         LN021
     C                   MOVEL     'MAARCHL1'    DBFILE                                        LN021
     C                   MOVEL     ECARID        DBKEY                          *************  LN021
     C                   Z-ADD     9             DBASE                          * DBERR 009 *  LN021
     C                   EXSR      DBERR                                        *************  LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     ARCPKP        READE     MAARCPL2                               88                   LN021
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
     C                   READC     FC0220S0                               83                   LN021
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
     C                   MOVE      SARID         ECARID                                        LN021
     C                   MOVE      RNAM          ECRNAM                                        LN021
     C                   MOVE      PSQN          ECPSQN                                        LN021
     C                   MOVE      SRSFX         ECRSFX                                        LN021
     C                   WRITE     @ECREJT                                                     LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **      If a record did exist, but no current request made          LN0210
      **                    Delete Archive Contents                       LN0210
      *                                                                   LN0210
     C     SSEL          IFEQ      *BLANK                                                      LN021
     C     SEXST         ANDEQ     'Y'                                                         LN021
     C     ARCPKY        CHAIN     MAARCPL1                           89                       LN021
     C  N89              DELETE    @ECREJU                                                     LN021
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
      **                                                                  S01382
     C***                  ELSE                                     LN0210S01382
      **                                                                  S01382
     C     SMFOD         IFEQ      'OD'                                                        S0138
     C     SMFOD         OREQ      'B '                                                        S0138
     C                   MOVE      'Y'           SAROD                                         LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    Read changed records                          LN0210
      *                                                                   LN0210
     C                   READC     FC0220S0                               83                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      ** Read Suffix Selection Subfile                                    LN0210
      *                                                                   LN0210
     C                   Z-ADD     1             RRN2                                          LN021
     C                   READC     FC0220S2                               83                   LN021
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
     C     ARCPK         SETLL     MAARCPL2                                                    LN021
     C     ARCPK         READE     MAARCPL2                               89                   LN021
      *                                                                   LN0210
     C     *IN89         DOWEQ     '0'                                                         LN021
     C                   DELETE    @ARCPAP                                                     LN021
     C     ARCPK         READE     MAARCPL2                               89                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    Read changed records                          LN0210
      *                                                                   LN0210
     C                   READC     FC0220S2                               83                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *
     C                   MOVE      SRNAM         D2RNAM
     C                   MOVE      ACTN          D2CHTP
     C                   MOVE      SSOID         D2DFTO
     C                   Z-ADD     NATN          D2TNLU
     C                   MOVE      SDST1         D2DLS1
     C                   MOVE      SDST2         D2DLS2
     C                   MOVE      SUSRO         D2USRO
     C                   MOVE      SARMF         D2ARMF
     C                   MOVE      SAROD         D2AROD
     C                   MOVE      SDRQD         D2DRQD
     C                   MOVE      SUSRR         D2DFTU
      *
      **  WRITE TO FILES IF INSERTION
      *
     C     ACTN          IFEQ      'I'
     C     *IN86         ANDEQ     '1'
     C                   WRITE     @D2REIZ                              20
     C*
     C** TEST FOR UPDATE BY ANOTHER W/S, OR A TERMINAL ERROR
     C*
     C     *IN20         IFEQ      '1'
     C*
     C********** STATUS    IFEQ 01021                                     LN0210
     C     MOSTAT        IFEQ      01021                                                       LN021
     C***********          MOVE 'RCF0064' MSGID                           LN1186
     C                   MOVE      'RCF1064'     MSGID                                         LN118
     C                   EXSR      UPDOWS
     C                   ELSE
     C                   EXSR      *PSSR
     C                   END
      *
     C                   END
      *
     C                   END
      *
      **  IF ACTION CODE IS AMEND, UPDATE RECORD
      *
     C     ACTN          IFEQ      'A'
     C     *IN86         ANDEQ     '0'
     C                   UPDATE    @D2REIZ
     C                   END
      *
      **  Update file controls
      *
     C                   MOVEL     'FCMOUTPD'    AHFLNM
     C     AHFLNM        CHAIN     SDFCTLL0                           99
      *
      **  Database error if no record found for file
      *
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDFCTLL0'    DBFILE
     C                   MOVEL     'FCMOUTPD'    DBKEY                          *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   EXSR      DBERR                                        *************
     C                   END
      *
      **  Update number of amendments
      *
     C     ACTN          IFEQ      'A'
     C                   ADD       1             AHNOAM
     C                   END
      *
      **  Update number of insertions
      *
     C     ACTN          IFEQ      'I'
     C                   ADD       1             AHNOIN
     C                   ADD       1             AHNORC
     C                   END
      *
      **  Update file control record
      *
     C                   UPDATE    @AHREAU
      *
      **     Issue Commit                                                 LN0210
      *                                                                   LN0210
     C                   TIME                    MTIME                                         LN021
     C     CMTTXT        COMMIT                                                                LN021
     C                   MOVE      *BLANK        RTCD                                          LN021
     C                   SETON                                        75                       LN021
      *                                                                   LN0210
     C                   ENDSR
      *
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R VALRPT - TO VALIDATE KEY SCREEN
     C*  CALLED FROM MAIN
     C*
     C********************************************************************
      *
     C     VALRPT        BEGSR
      *
      *
     C                   CALL      'ZA0250'
     C                   SETON                                        70
     C                   SETOFF                                       585936
     C                   WRITE     FC0220C1
     C                   EXFMT     FC0220F0
      *
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C     *IN70         ANDEQ     '1'
      *
     C                   SETOFF                                       7036
     C                   CALL      'ZA0250'
      *
      ** ALLOW SELECTION
      *
     C     SRNAM         IFEQ      '?'
      *
     C                   CALL      'FC0300S'
     C                   PARM      *BLANK        W0RTN             7
     C     SRNAM         PARM      *BLANK        WQ0006           10
     C*
     C     W0RTN         IFEQ      'PREVSCN'
     C                   SETON                                        70
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0059' MSGID                           LN1186
     C                   PARM      'RCF1059'     MSGID                                         LN118
     C                   END
     C*
     C     W0RTN         IFEQ      'Y2U9999'
     C                   MOVE      W0RTN         RTCD
     C                   EXSR      END
     C                   END
     C*
     C                   END
     C*
      ** A REPORT NAME MUST BE ENTERED
     C*
     C     SRNAM         IFEQ      *BLANK
     C                   SETON                                        7036
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0044' MSGID   7                       LN1186
     C                   PARM      'RCF1044'     MSGID             7                           LN118
     C                   END
     C*
     C     SRNAM         IFNE      *BLANK
     C***********SRNAM     CHAINFCREPTL1             79                   S01407
     C*****SRNAM         CHAIN     FCREPTJ0                           79              S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT :NullInds2                                                             MD055265
     C+ from FCREPJW1                                                                       MD055265
     C+ where DXRNAM = :SRNAM                                                               MD055265
     C/END-EXEC                                                                             MD055265
     C                   If        SQLCODE = 100                                            MD055265
      *
      **                         IF no record is found
      **                              Send error message
      *
     C******IN79         IFEQ      '1'                                                      MD055265
     C                   SETON                                        7036
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0042' MSGID   7                       LN1186
     C                   PARM      'RCF1042'     MSGID                                         LN118
     C                   ELSE
     C*
     C** CHECK REPORT NAME AGAINST ACTION CODE
     C*
     C     SRNAM         CHAIN     FCMOUTL1                           55
     C*
     C     *IN55         IFEQ      '0'
     C     ACTN          ANDEQ     'I'
     C                   SETON                                        7036
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0068' MSGID   7                       LN1186
     C                   PARM      'RCF1068'     MSGID                                         LN118
     C                   END
     C*
     C                   MOVE      DXRNAM        RNAM                                          LN021
     C                   MOVE      DXRDSC        SRDSC
     C                   MOVE      DXDFTO        SSOID
     C*
     C** CHECK MANDATORY VERSION AVAILABLE
     C*
     C                   SETOFF                                       65
     C***********SRNAM     SETLLFCRCOML1                                  S01407
     C***********SRNAM     READEFCRCOML1                 79               S01407
     C*****SRNAM         SETLL     FCRCOMJ1                                           S0140 MD055265
     C*****SRNAM         READE     FCRCOMJ1                               79          S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ declare ACursor insensitive scroll cursor for                                       MD055265
     C+ select * from FCRCOJW1                                                              MD055265
     C+ where D3RNAM = :SRNAM                                                               MD055265
     C+ order by D3RNAM, D3COTT, D3CSEQ                                                     MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ open ACursor                                                                        MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from ACursor into :FCRCOM :NullInds                                      MD055265
     C/END-EXEC                                                                             MD055265
     C                   SETOFF                                       79                    MD055265
     C                   If        SQLCODE = 100                                            MD055265
     C                   SETON                                        79                    MD055265
     C                   Endif                                                              MD055265
     C*
     C     *IN79         DOWEQ     '0'
     C     D3MORQ        COMP      'M'                                    65
     C   65              SETON                                        79
     C**N79******SRNAM     READEFCRCOML1                 79               S01407
     C**N79SRNAM         READE     FCRCOMJ1                               79          S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from ACursor into :FCRCOM :NullInds                                      MD055265
     C/END-EXEC                                                                             MD055265
     C                   If        *IN79 = '0'                                              MD055265
     C                   SETOFF                                       79                    MD055265
     C                   If        SQLCODE = 100                                            MD055265
     C                   SETON                                        79                    MD055265
     C                   Endif                                                              MD055265
     C                   Endif                                                              MD055265
     C                   END
     C*
     C/EXEC SQL                                                                             MD055265
     C+ close ACursor                                                                       MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
      ** IF NO RECORD TYPE 'M' FOUND, SEND ERROR MESSAGE
     C*
     C     *IN65         IFEQ      '0'
     C                   SETON                                        7036
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0043' MSGID   7                       LN1186
     C                   PARM      'RCF1043'     MSGID                                         LN118
     C                   END
      *
     C                   END
      *
     C                   END
      *
     C   70              WRITE     FC0220C1
     C   70              EXFMT     FC0220F0
      *
     C                   END
      *
      ** IF SCREEN IS VALID, SET TO NEXT DISPLAY
      *
     C     *IN03         IFEQ      '0'
     C     *IN12         ANDEQ     '0'
     C                   MOVE      'Y'           MAINF
     C                   MOVE      'N'           KEYF
     C                   END
     C*
     C** IF EXIT REQUESTED, TERMINATE PROGRAM
     C*
     C     *IN03         IFEQ      '1'
     C                   MOVE      'Y2U9999'     RTCD
     C                   EXSR      END
     C                   END
     C*
     C** IF PREVIOUS SCREEN REQUESTED, EXIT PROGRAM
     C*
     C     *IN12         IFEQ      '1'
     C                   SETOFF                                       12
     C                   MOVE      *BLANK        RTCD
     C                   EXSR      END
     C                   END
      *
     C                   ENDSR
      *
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R VALINT - TO VALIDATE INITIAL SCREEN
     C*  CALLED FROM MAIN
     C*
     C********************************************************************
      *
     C     VALINT        BEGSR
      *
     C                   CALL      'ZA0250'
     C                   SETON                                        7058
     C                   SETOFF                                       593738
     C                   WRITE     FC0220C1
     C                   EXFMT     FC0220F0
      *
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C     *IN70         ANDEQ     '1'
      *
     C                   SETOFF                                       703738
     C                   CALL      'ZA0250'
      *
     C     SUSRR         CHAIN     MUSER                              84
      *
      **                         IF no record is found
      **                              Send error message
      *
     C     *IN84         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   SETON                                        7037
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0006' MSGID   7                       LN1186
     C                   PARM      'RCF1006'     MSGID                                         LN118
     C                   END
      *                                                                   LN1151
      ** CHAIN TO MUSER TO PICK UP THE USERS AUTHORITY TO OUTPUT          LN1151
      ** INSTRUCTIONS.IF CHAIN FAILS PERFORM DATABASE ERROR PROCESSING.   LN1151
      *                                                                   LN1151
     C     *IN37         IFEQ      '0'                                                         LN115
     C     JUSR          CHAIN     MUSER                              84                       LN115
     C     *IN84         IFEQ      '1'                                                         LN115
     C     RECI          ORNE      'D'                                                         LN115
     C     *LOCK         IN        LDA                                                         LN115
     C                   MOVEL     'MUSER   '    DBFILE                                        LN115
     C                   MOVEL     JUSR          DBKEY                          *************  LN115
     C                   Z-ADD     10            DBASE                          * DBERR 010 *  LN115
     C                   EXSR      DBERR                                        *************  LN115
     C                   END                                                                   LN115
      *                                                                   LN1151
      ** SEND AN ERROR MESSAGE IF THE USER ATTEMPTS TO                    LN1151
      ** ASSOCIATE A REPORT WITH A USER TO WHICH HE HAS NO                LN1151
      ** AUTHORITY.                                                       LN1151
      *                                                                   LN1151
     C     MUREP         IFNE      'Y'                                                         LN115
     C     SUSRR         ANDNE     *BLANKS                                                     LN115
     C     SUSRR         ANDNE     JUSR                                                        LN115
     C                   SETON                                        7037                     LN115
     C                   CALL      'FCC0240'                                                   LN115
     C                   PARM      'RCF1087'     MSGID                                         LN115
     C                   END                                                                   LN115
     C                   END                                                                   LN115
     C*
     C** DISTRIBUTION REQUIRED MUST BE 'Y' OR 'N'
     C*
     C     SDRQD         IFNE      'Y'
     C     SDRQD         ANDNE     'N'
     C     SDRQD         ANDNE     *BLANK
     C                   SETON                                        7038
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0031' MSGID   7                       LN1186
     C                   PARM      'RCF1031'     MSGID                                         LN118
     C                   END
     C*
      **  IF DISTRIBUTION IS BLANK SET TO N.
     C*
     C     SDRQD         IFEQ      *BLANKS
     C                   MOVE      'N'           SDRQD
     C                   END
      *
     C   70              WRITE     FC0220C1
     C   70              EXFMT     FC0220F0
      *
     C                   END
      *
      ** IF SCREEN IS VALID, SET TO NEXT DISPLAY
      *
     C     *IN03         IFEQ      '0'
     C     *IN12         ANDEQ     '0'
     C                   MOVE      'Y'           OUTPF             1
     C                   MOVE      'N'           MAINF
     C                   END
     C*
     C** IF EXIT REQUESTED, TERMINATE PROGRAM
     C*
     C     *IN03         IFEQ      '1'
     C                   MOVE      'Y2U9999'     RTCD
     C                   EXSR      END
     C                   END
     C*
     C** IF PREVIOUS SCREEN REQUESTED, DETERMINE WHETHER KEY/CALLING PGM
     C*
     C     *IN12         IFEQ      '1'
     C*
     C                   SETOFF                                       12
     C*
     C     ACTN          IFEQ      'I'
     C                   MOVE      'Y'           KEYF
     C                   MOVE      'N'           MAINF
     C                   ELSE
     C                   MOVE      *BLANK        RTCD
     C                   EXSR      END
     C                   END
      *
     C                   END
      *
     C                   ENDSR
      *
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R VALID - TO VALIDATE MAIN SCREEN
     C*  CALLED FROM MAIN
     C*
     C********************************************************************
      *
     C     VALID         BEGSR
      *                                                                   LN0210
     C     ACTN          IFEQ      'E'                                                         LN021
     C                   SETON                                        54                       LN021
     C                   END                                                                   LN021
      *
      **  Reset Error display for archiving only if no archive id's exist LN0210
      *                                                                   LN0210
     C     NOARCH        IFEQ      'N'                                                         LN021
     C                   CALL      'ZA0250'
     C                   SETOFF                                       3334                     LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   MOVE      'N'           NOARCH                                        LN021
      *                                                                   LN0210
     C                   SETON                                        5970
     C******************** SETOF                     583334               LN0210
     C                   SETOFF                                       58                       LN021
     C                   SETOFF                                       303132
      *
      **               Do not display Distribution list fields, or
      **               Midas User field if Distribution is required
      *
     C     SDRQD         IFEQ      'Y'
     C                   SETON                                        51
     C                   ELSE
     C                   SETOFF                                       51
     C                   END
      *
      ** IF DISTRIBUTION IS REQUIRED, ENSURE DIST LIST/USER ARE BLANK
      *
     C     SDRQD         IFEQ      'Y'
     C                   MOVE      *BLANK        SDST1
     C                   MOVE      *BLANK        SDST2
     C                   MOVE      *BLANK        SUSRO
     C                   END
      *
      ** IF DISTRIBUTION NOT REQUIRED, DISPLAY DIST LIST/USER
      *
     C     SDRQD         IFEQ      'N'
     C     ACTN          ANDEQ     'A'
     C                   MOVE      D2DLS1        SDST1
     C                   MOVE      D2DLS2        SDST2
     C                   MOVE      D2USRO        SUSRO
     C                   END
      *
     C                   WRITE     FC0220C1
     C                   EXFMT     FC0220F0
      *
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C     *IN70         ANDEQ     '1'
      *
     C                   CALL      'ZA0250'
      *
     C                   SETOFF                                       703334
     C                   SETOFF                                       303132
      *
      **      Validation of input fields for insertion/amendment
      *
     C     ACTN          IFEQ      'I'
     C     ACTN          OREQ      'A'
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
     C                   PARM      'RCF1001'     MSGID                                         LN118
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
     C                   SETON                                        7030
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
     C********** KDLIST    CHAINQAOKDL01             80                                043702 CAAA02
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
     C     POUTQ         ANDEQ     *BLANK
     C                   SETON                                        7032
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0004' MSGID   7                       LN1186
     C                   PARM      'RCF1004'     MSGID                                         LN118
     C                   END
      *
      **                    IF this is not the user's own Id
      **                    AND user is not authorised to others
      **                         Send error message
      *
     C     SUSRO         IFNE      JUSR
     C     PMUREP        ANDEQ     'N'
     C                   SETON                                        7032
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0005' MSGID   7                       LN1186
     C                   PARM      'RCF1005'     MSGID                                         LN118
     C                   END
      *
      **                    IF user is authorised to others
      **                    AND this is not the user's own Id
      *
     C     PMUREP        IFEQ      'Y'
     C     SUSRO         ANDNE     JUSR
      *
      **                         Access MUSER for the user Id
      **                         entered
      *
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
     C                   END
      *
      *********Validation*of*Deletion*Processing**************************LN0210
      *
     C********** ACTN      IFEQ 'D'                                       LN0210
      *
     C********** *IN10     IFEQ '0'                                       LN0210
     C******************** SETON                     70                   LN0210
     C******************** CALL 'FCC0240'                                 LN0210
     C******************** PARM 'RCF0021' MSGID   7                       LN0210
     C******************** END                                            LN0210
      *
     C******************** END                                            LN0210
      *
     C   70              WRITE     FC0220C1
     C   70              EXFMT     FC0220F0
      *
     C                   END
      *
      ***IF*SCREEN*IS*VALID,*UPDATE*FILES*AND*EXIT************************LN0210
      ** SCREEN VALID AND EXIT/PREVIOUS NOT REQUESTED                     LN0210
      *
     C     *IN03         IFEQ      '0'
     C     *IN12         ANDEQ     '0'
      **********                                                          LN0210
     C********** ACTN      IFEQ 'A'                                       LN0210
     C********** ACTN      OREQ 'I'                                       LN0210
     C**********           EXSR INSAMD                                    LN0210
     C**********           MOVE 'N'       OUTPF                           LN0210
     C**********           END                                            LN0210
      **********                                                          LN0210
     C**********           MOVE *BLANK    RTCD                            LN0210
      *                                                                   LN0210
      ** SET CURRENT SCREEN OFF, CHECK ARCHIVING REQUIREMENT              LN0210
      **    IF ARCHIVING NOT PRESENT, PERFORM UPDATES                     LN0210
      **    IF ARCHIVING MAY BE REQUIRED, PROCESS ARCHIVING               LN0210
      *                                                                   LN0210
     C                   MOVE      'N'           OUTPF                                         LN021
      *                                                                   LN0210
     C     SAROD         IFEQ      'Y'                                                         LN021
     C     SARMF         OREQ      'Y'                                                         LN021
     C                   MOVE      'Y'           RSFXF             1                           LN021
     C                   ELSE                                                                  LN021
     C                   MOVE      'Y'           UPDF              1                           LN021
     C                   END                                                                   LN021
      *
     C                   END
     C*
     C** IF EXIT REQUESTED, TERMINATE PROGRAM
     C*
     C     *IN03         IFEQ      '1'
     C                   MOVE      'Y2U9999'     RTCD
     C                   EXSR      END
     C                   END
     C*
     C** IF PREVIOUS SCREEN REQUESTED, RETURN TO MAIN DETAILS
     C*
     C     *IN12         IFEQ      '1'
     C*                                                                   LN0210
     C     ACTN          IFEQ      'E'                                                         LN021
     C                   MOVE      *BLANK        RTCD                                          LN021
     C                   EXSR      END                                                         LN021
     C                   ELSE                                                                  LN021
     C                   MOVE      'Y'           MAINF
     C                   END                                                                   LN021
     C*                                                                   LN0210
     C                   MOVE      'N'           OUTPF
     C                   SETOFF                                       12
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT                                                              LN0210
     C********************************************************************LN0210
     C*                                                                   LN0210
     C*  S/R RSFXS - TO DISPLAY SUFFIX SELECTION SCREEN FOR ARCHIVING     LN0210
     C*  CALLED FROM MAIN                                                 LN0210
     C*  CALLS                                                            LN0210
     C*                                                                   LN0210
     C********************************************************************LN0210
      *                                                                   LN0210
     C     RSFXS         BEGSR                                                                 LN021
      *                                                                   LN0210
      ** Access Report Suffixes (Spool file names) for the report         LN0210
      *                                                                   LN0210
     C*****RNAM*         SETLL     FCRSFXL1                                           LN021 MD055265
     C*****RNAM*         READE     FCRSFXL1                               81          LN021 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ declare BCursor insensitive scroll cursor for                                       MD055265
     C+ select * from FCRSFJW0                                                              MD055265
     C+ where DYRNAM = :RNAM                                                                MD055265
     C+ order by DYRNAM, DYRSFX                                                             MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ close BCursor                                                                       MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ open BCursor                                                                        MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from BCursor into :FCRSFX                                                MD055265
     C/END-EXEC                                                                             MD055265
                                                                                            MD055265
      *                                                                   LN0210
      ** Ignore Audit Report sections                                     LN0210
      *                                                                   LN0210
     C     DYAURP        IFEQ      'Y'                                                         LN021
     C*****RNAM*         READE     FCRSFXL1                               81          LN021 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from BCursor into :FCRSFX                                                MD055265
     C/END-EXEC                                                                             MD055265
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    IF no records found                           LN0210
      *                                                                   LN0210
     C******IN81         IFEQ      '1'                                                LN021 MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C     *LOCK         IN        LDA                                                         LN021
     C                   MOVEL     'FCRSFXL1'    DBFILE                                        LN021
     C                   MOVEL     RNAM          DBKEY                          *************  LN021
     C                   Z-ADD     7             DBASE                          * DBERR 007 *  LN021
     C                   EXSR      DBERR                                        *************  LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     *IN02         IFEQ      '1'                                                         LN021
      *                                                                   LN0210
      ** Reset Relative Record number for subfile processing              LN0210
      *                                                                   LN0210
     C                   Z-ADD     0             RRN2              5 0                         LN021
     C                   SETON                                        22                       LN021
     C                   SETOFF                                       21                       LN021
     C                   WRITE     FC0220C2                                                    LN021
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
     C     ARCPK         SETLL     MAARCPL2                               85                   LN021
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
     C                   WRITE     FC0220S2                                                    LN021
      *                                                                   LN0210
      ** Access next suffix detail                                        LN0210
      *                                                                   LN0210
     C*****RNAM*         READE     FCRSFXL1                               81          LN021 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from BCursor into :FCRSFX                                                MD055265
     C/END-EXEC                                                                             MD055265
      *                                                                   LN0210
      ** Ignore if audit report section                                   LN0210
      *                                                                   LN0210
     C     DYAURP        IFEQ      'Y'                                                         LN021
     C*****RNAM*         READE     FCRSFXL1                               81          LN021 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from BCursor into :FCRSFX                                                MD055265
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
     C********************************************************************LN0210
      /EJECT                                                              LN0210
     C********************************************************************LN0210
     C*                                                                   LN0210
     C*  S/R VALRSX - TO VALIDATE SUFFIX SELECTION SCREEN                 LN0210
     C*  CALLED FROM RSFXS                                                LN0210
     C*  CALLS                                                            LN0210
     C*                                                                   LN0210
     C********************************************************************LN0210
      *                                                                   LN0210
     C     VALRSX        BEGSR                                                                 LN021
      *                                                                   LN0210
      **               Set on SFLNXTCHG                                   LN0210
      *                                                                   LN0210
     C                   SETON                                        202123                   LN021
     C                   SETON                                        71                       LN021
     C                   SETOFF                                       72                       LN021
     C                   MOVE      'N'           SELCT                                         LN021
     C                   WRITE     FC0220F1                                                    LN021
     C                   WRITE     FC0220F2                                                    LN021
     C                   WRITE     FC0220C1                                                    LN021
     C                   EXFMT     FC0220C2                                                    LN021
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
     C                   READC     FC0220S2                               83                   LN021
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
     C                   UPDATE    FC0220S2                                                    LN021
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
     C                   UPDATE    FC0220S2                                                    LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **     If record changed to have selection blanked out, and no      LN0210
      **     archive record previously existed, set of SFLNXTCHG          LN0210
      *                                                                   LN0210
     C     SSELX         IFEQ      *BLANK                                                      LN021
     C     SEXSTX        ANDNE     'Y'                                                         LN021
     C                   SETOFF                                       3520                     LN021
     C                   UPDATE    FC0220S2                                                    LN021
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
     C                   READC     FC0220S2                               83                   LN021
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
     C                   WRITE     FC0220F1                                                    LN021
     C                   WRITE     FC0220F2                                                    LN021
     C                   WRITE     FC0220C1                                                    LN021
     C                   EXFMT     FC0220C2                                                    LN021
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
     C                   MOVE      'Y2U9999'     RTCD                                          LN021
     C                   EXSR      END                                                         LN021
     C                   END                                                                   LN021
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
      ********************************************************************LN0210
      /EJECT                                                              LN0210
     C********************************************************************LN0210
     C*                                                                   LN0210
     C*  S/R SETSUB - TO LOAD SUBFILE OF ARCHIVE IDENTIFIERS              LN0210
     C*  CALLED FROM ARCHS                                                LN0210
     C*                                                                   LN0210
     C********************************************************************LN0210
     C*                                                                   LN0210
     C     SETSUB        BEGSR                                                                 LN021
      *                                                                   LN0210
      **     Set to beginning of subfile                                  LN0210
      *                                                                   LN0210
     C                   Z-ADD     1             RRN2              5 0                         LN021
     C                   READC     FC0220S2                               83                   LN021
      *                                                                   LN0210
      ** Read next record if not selected                                 LN0210
      *                                                                   LN0210
     C     SSELX         IFNE      '1'                                                         LN021
     C                   SETON                                        20                       LN021
     C                   UPDATE    FC0220S2                                                    LN021
     C                   READC     FC0220S2                               83                   LN021
     C                   SETOFF                                       20                       LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     *IN01         IFEQ      '1'                                                         LN021
     C                   Z-ADD     0             RRN                                           LN021
     C                   SETON                                        22                       LN021
     C                   SETOFF                                       21                       LN021
     C                   WRITE     FC0220C0                                                    LN021
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
      *                                                                   S01382
     C***                  ELSE                                     LN0210S01382
      *                                                                   S01382
     C     EAMEDM        IFEQ      'M'                                                         S0138
     C                   MOVE      'MF'          SMFOD                                         LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     EAMEDM        IFEQ      'B'                                                         S0138
     C                   MOVE      'B '          SMFOD                                         S0138
     C                   END                                                                   S0138
      *                                                                   S01382
     C                   MOVE      EAADSC        SADSC                                         LN021
      *                                                                   LN0210
     C                   SETOFF                                       2035                     LN021
     C                   MOVE      'N'           SEXST                                         LN021
     C                   MOVE      *BLANK        SSEL                                          LN021
      *                                                                   LN0210
      ** Access corresponding archive details record                      LN0210
      *                                                                   LN0210
     C     ARCPKY        CHAIN     MAARCPL1                           89                       LN021
      *                                                                   LN0210
      ** If record exists, set subfile indicators: selected               LN0210
      **                                           record exists          LN0210
      **                                           SFLNXTCHG              LN0210
      *                                                                   LN0210
     C     *IN89         IFEQ      '0'                                                         LN021
     C                   MOVE      '1'           SSEL                                          LN021
     C                   MOVE      'Y'           SEXST                                         LN021
     C                   SETON                                        20                       LN021
     C                   EXCEPT    RELACP                                                      LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   WRITE     FC0220S0                                                    LN021
     C                   READ      MAARCHL2                               82                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    Read changed records                          LN0210
      *                                                                   LN0210
     C                   SETON                                        20                       LN021
     C                   UPDATE    FC0220S2                                                    LN021
     C                   SETOFF                                       20                       LN021
      *                                                                   LN0210
     C                   READC     FC0220S2                               83                   LN021
      *                                                                   LN0210
      ** Read next record if not selected                                 LN0210
      *                                                                   LN0210
     C     SSELX         IFNE      '1'                                                         LN021
     C                   SETON                                        20                       LN021
     C                   UPDATE    FC0220S2                                                    LN021
     C                   READC     FC0220S2                               83                   LN021
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
     C********************************************************************LN0210
      /EJECT                                                              LN0210
     C********************************************************************LN0210
     C*                                                                   LN0210
     C*  S/R ARCHV - TO VALIDATE CHANGED SUBFILE RECORDS FOR PRINT SUFFIX LN0210
     C*  CALLED FROM ARCHS                                                LN0210
     C*                                                                   LN0210
     C********************************************************************LN0210
     C     ARCHV         BEGSR                                                                 LN021
      *                                                                   LN0210
      **               Set on SFLNXTCHG                                   LN0210
      *                                                                   LN0210
     C                   SETON                                        202171                   LN021
     C                   SETOFF                                       72                       LN021
     C                   MOVE      'N'           SELCT                                         LN021
     C                   WRITE     FC0220F1                                                    LN021
     C                   WRITE     FC0220F2                                                    LN021
     C                   WRITE     FC0220C1                                                    LN021
     C                   EXFMT     FC0220C0                                                    LN021
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
     C                   READC     FC0220S0                               83                   LN021
      *                                                                   LN0210
      **               DOWHILE changed subfile records remain             LN0210
      *                                                                   LN0210
     C     *IN83         DOWEQ     '0'                                                         LN021
      *                                                                   LN0210
      **                    IF Subfile select is not '1'/blank            LN0210
      **                         Send error message                       LN0210
      *                                                                   LN0210
     C     SSEL          IFNE      '1'                                                         LN021
     C     SSEL          ANDNE     *BLANK                                                      LN021
     C                   SETON                                        713520                   LN021
     C                   CALL      'FCC0240'                                                   LN021
     C***********          PARM 'RCF0012' MSGID   7                LN0210 LN1186
     C                   PARM      'RCF1012'     MSGID                                         LN118
     C                   UPDATE    FC0220S0                                                    LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **     If selection made, or if record previously existed for       LN0210
      **     archive, set on SFLNXTCHG indicator for updates              LN0210
      *                                                                   LN0210
     C     SSEL          IFEQ      *BLANK                                                      LN021
     C     SEXST         ANDEQ     'Y'                                                         LN021
     C     SSEL          OREQ      '1'                                                         LN021
     C                   SETON                                        20                       LN021
     C                   SETOFF                                       35                       LN021
     C                   UPDATE    FC0220S0                                                    LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **     If record changed to have selection blanked out, and no      LN0210
      **     archive record previously existed, set of SFLNXTCHG          LN0210
      *                                                                   LN0210
     C     SSEL          IFEQ      *BLANK                                                      LN021
     C     SEXST         ANDNE     'Y'                                                         LN021
     C                   SETOFF                                       3520                     LN021
     C                   UPDATE    FC0220S0                                                    LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **     If an attempt has been made to select an archive, reset      LN0210
      **     warning flags                                                LN0210
      *                                                                   LN0210
     C     SSEL          IFNE      *BLANK                                                      LN021
     C                   MOVE      'Y'           SELCT             1                           LN021
     C                   SETOFF                                       72                       LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                         Read changed subfile records             LN0210
      *                                                                   LN0210
     C                   READC     FC0220S0                               83                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **               IF no selection has been made                      LN0210
      **               AND no warning is currently                        LN0210
      **               displayed                                          LN0210
      **                    Send Warning message                          LN0210
      **               Otherwise                                          LN0210
      *                                                                   LN0210
     C     SELCT         IFEQ      'N'                                                         LN021
     C     *IN72         ANDEQ     '0'                                                         LN021
     C                   SETON                                        7172                     LN021
     C                   CALL      'FCC0240'                                                   LN021
     C***********          PARM 'RCF0011' MSGID   7                LN0210 LN1186
     C                   PARM      'RCF1011'     MSGID                                         LN118
     C                   END                                                                   LN021
      *                                                                   LN0210
      ** If screen is not valid, redisplay                                LN0210
      *                                                                   LN0210
     C     *IN71         IFEQ      '1'                                                         LN021
     C                   MOVE      'N'           SELCT                                         LN021
     C                   WRITE     FC0220F1                                                    LN021
     C                   WRITE     FC0220F2                                                    LN021
     C                   WRITE     FC0220C1                                                    LN021
     C                   EXFMT     FC0220C0                                                    LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
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
     C                   MOVE      'Y2U9999'     RTCD                                          LN021
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
      *                                                                   LN0210
     C                   ENDSR                                                                 LN021
      ********************************************************************LN0210
      /EJECT
     C********************************************************************
     C*
     C***S/R*ENQDEL*-*TO*PERFORM*DELETION*PROCESSING**********************LN0210
     C*  S/R DELETE - TO PERFORM DELETION PROCESSING                      LN0210
     C*  CALLED FROM MAIN
     C*  CALLS
     C*
     C********************************************************************
      *
     C********** ENQDEL    BEGSR                                          LN0210
     C     DELETE        BEGSR                                                                 LN021
     C*
     C                   SETON                                        54
     C*
     C     SDRQD         IFEQ      'Y'
     C                   SETON                                        51
     C                   ELSE
     C                   SETOFF                                       51
     C                   END
     C*
     C***********ACTN      IFEQ 'D'                                       LN0210
     C                   SETON                                        56
     C******************** END                                            LN0210
     C*
     C                   CALL      'ZA0250'
     C                   WRITE     FC0220C1
     C                   EXFMT     FC0220F0
     C*
      ** DISPLAY SCREEN UNTIL VALID COMMAND KEY PRESSED
     C*
     C     *IN03         DOWEQ     '0'
     C     *IN10         ANDEQ     '0'
     C     *IN12         ANDEQ     '0'
     C*
     C                   CALL      'ZA0250'
     C*
     C********** ACTN      IFEQ 'D'                                       LN0210
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0021' MSGID                           LN1186
     C                   PARM      'RCF1021'     MSGID                                         LN118
     C                   WRITE     FC0220C1
     C                   EXFMT     FC0220F0
     C******************** ELSE                                           LN0210
     C******************** SETON                     12                   LN0210
     C******************** END                                            LN0210
     C*
     C                   END
      *
      ****Delete*Periodic*Request*Record*****************************     LN0210
      **  Delete Output Instruction Record                                LN0210
      *
     C     *IN10         IFEQ      '1'
     C     SRNAM         CHAIN     FCMOUTL0                           86
     C  N86              DELETE    @D2REIZ
      *                                                                   LN0210
      **  Delete Archiving Option Records if modules present              LN0210
      *                                                                   LN0210
     C     *IN52         IFEQ      '1'                                                         LN021
     C     *IN53         OREQ      '1'                                                         LN021
      *                                                                   LN0210
     C     ARCPKP        SETLL     MAARCPL2                                                    LN021
     C     ARCPKP        READE     MAARCPL2                               88                   LN021
      *                                                                   LN0210
     C     *IN88         DOWEQ     '0'                                                         LN021
     C                   DELETE    @ARCPAP                                                     LN021
     C     ARCPKP        READE     MAARCPL2                               88                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *
      **  Update file controls
      *
     C                   MOVEL     'FCMOUTPD'    AHFLNM
     C     AHFLNM        CHAIN     SDFCTLL0                           99
      *
      **  Database error if no record found for file
      *
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDFCTLL0'    DBFILE
     C                   MOVEL     'FCMOUTPD'    DBKEY                          *************
     C                   Z-ADD     5             DBASE                          * DBERR 005 *
     C                   EXSR      DBERR                                        *************
     C                   END
      *
      **  Update number of deletions
      *
     C                   ADD       1             AHNODL
     C                   SUB       1             AHNORC
      *
      **  Update file control record
      *
     C                   UPDATE    @AHREAU
      *                                                                   LN0210
      **     Issue Commit                                                 LN0210
      *                                                                   LN0210
     C                   TIME                    MTIME                                         LN021
     C     CMTTXT        COMMIT                                                                LN021
      *
     C                   END
     C*
     C** IF EXIT REQUESTED, TERMINATE PROGRAM
     C*
     C     *IN03         IFEQ      '1'
     C                   MOVE      'Y2U9999'     RTCD
     C                   EXSR      END
     C                   END
     C*
     C** IF PREVIOUS SCREEN REQUESTED, EXIT PROGRAM
     C*
     C     *IN12         IFEQ      '1'
     C                   SETOFF                                       12
     C                   MOVE      *BLANK        RTCD
     C                   EXSR      END
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R INIT2 - TO INITIALISE MAIN SCREEN
     C*  CALLED FROM MAIN
     C*  CALLS DBERR
     C*
     C********************************************************************
      *
     C     INIT2         BEGSR
      *
      **          Access Installation Control Data
      *
     C                   CALL      'AORCFR0'
     C                   PARM      *BLANK        P@APRC                           B:Return code
     C                   PARM      '*FIRST'      P@APOP                           B:Proc Optn
     C     P@RCF         PARM      P@RCF         DSFDY                            O:Rec format
      *
      **          IF no record is found
      **               Database error
      *
     C     P@APRC        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDRCFPD'     DBFILE
     C                   MOVEL     'RCF'         DBKEY                          *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   EXSR      DBERR                                        *************
     C                   END
      *
      **          Access Midas Modules Data
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANK        P@APRC            7              B:Return code
     C                   PARM      '*FIRST'      P@APOP            7              I:Option
     C     P@MMOD        PARM      P@MMOD        DSSDY                            O:Rec format
      *
      **          IF no record is found
      **               Database error
      *
     C     P@APRC        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     'MMOD'        DBKEY                          *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
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
     C                   MOVE      RUNA          SRUNA
     C                   MOVE      JBNM          SWSID
      *
      **               Do not Display Distribution list fields if
      **               Office is not present
      *
     C     D0OFPR        COMP      'Y'                                    50
      *
     C     JUSR          CHAIN     MUSER                              84
      *
      **          IF no record is found
      **               Database error
      **          ENDIF
      *
     C     *IN84         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'MUSER'       DBFILE
     C                   MOVEL     JUSR          DBKEY                          *************
     C                   Z-ADD     6             DBASE                          * DBERR 006 *
     C                   EXSR      DBERR                                        *************
     C                   END
      *
     C     *LIKE         DEFINE    MUREP         PMUREP
     C     *LIKE         DEFINE    OUTQ          POUTQ
      *
     C                   MOVE      MUREP         PMUREP
     C                   MOVE      OUTQ          POUTQ
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R INIT1 - TO INITIALISE PROGRAM VARIABLES
     C*  CALLED FROM MAIN
     C*  CALLS UPDOWS, ZBKDT, PFREQB
     C*
     C********************************************************************
     C     INIT1         BEGSR
     C*
     C     *LIKE         DEFINE    D2RNAM        RNAM
     C     *LIKE         DEFINE    D2TNLU        PTNLU
     C     *LIKE         DEFINE    SSOID         KSOID
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
     C     ARCPKP        KLIST                                                                 LN021
     C                   KFLD                    SRNAM                                         LN021
     C                   KFLD                    PSQN                                          LN021
      *                                                                   LN0210
      ** ARCHIVING FILE: KEY FOR CHAINING                                 LN0210
      *                                                                   LN0210
     C     ARCPK         KLIST                                                                 LN021
     C                   KFLD                    SRNAM                                         LN021
     C                   KFLD                    PSQN                                          LN021
     C                   KFLD                    SRSFX                                         LN021
      *                                                                   LN0210
      ** ARCHIVING FILE: KEY FOR CHAINING                                 LN0210
      *                                                                   LN0210
     C     ARCPKY        KLIST                                                                 LN021
     C                   KFLD                    SARID                                         LN021
     C                   KFLD                    SRNAM                                         LN021
     C                   KFLD                    PSQN                                          LN021
     C                   KFLD                    SRSFX                                         LN021
      *                                                                   LN0210
     C     *LIKE         DEFINE    ECPSQN        PSQN                                          LN021
      *                                                                   LN0210
      ** ARCHIVING STORE IS UNDER SEQUENCE NUMBER '00'                    LN0210
      *                                                                   LN0210
     C                   MOVE      '00'          PSQN                                          LN021
      *
      **          Access Dataarea RUNDAT
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'FC0220'      DBPGM
     C                   OUT       LDA
     C                   MOVEL     'FC0220'      PGMN
     C                   MOVEL     'FC'          MDID
     C                   MOVEL     JBNM          WSIDX
     C                   MOVE      ACTN          ACTCDX
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C     DATF          COMP      'M'                                    98
     C     MBIN          COMP      'Y'                                    57
     C     ACTN          COMP      'I'                                5858
      *
     C                   MOVEL     '*'           SPGMQ
     C                   CALL      'ZA0250'
     C                   SETON                                        60
     C*
     C** ACCESS REPORT DESCRIPTION: DATABASE ERROR IF NONE FOUND
     C*
     C     RNAM          IFNE      *BLANK
     C***********RNAM      CHAINFCREPTL1             79                   S01407
     C*****RNAM          CHAIN     FCREPTJ0                           79              S0140 MD055265
     C/EXEC SQL                                                                             MD055265
     C+ SELECT *                                                                            MD055265
     C+ into :FCREPT :NullInds2                                                             MD055265
     C+ from FCREPJW1                                                                       MD055265
     C+ where DXRNAM = :RNAM                                                                MD055265
     C/END-EXEC                                                                             MD055265
     C                   If        SQLCODE = 100                                            MD055265
     C*
     C******IN79         IFEQ      '1'                                                      MD055265
     C     *LOCK         IN        LDA
     C***********          MOVEL'MUSER'   DBFILE                          S01407
     C***********          MOVELJUSR      DBKEY            *************  S01407
     C                   MOVEL     'FCREPTJ0'    DBFILE                                        S0140
     C                   MOVEL     RNAM          DBKEY                          *************  S0140
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   EXSR      DBERR                                        *************
     C                   END
     C*
     C                   END
     C*
     C                   MOVE      DXRDSC        SRDSC
     C*
      ** SET ON PROTECT SCREEN INDICATOR FOR ENQUIRE/DELETE
     C*
     C     ACTN          IFEQ      'E'
     C     ACTN          OREQ      'D'
     C                   SETON                                        54
     C                   END
     C*
      ** SET ON ENABLE COMMAND 10 INDICATOR FOR DELETE
     C*
     C     ACTN          IFEQ      'D'
     C                   SETON                                        56
     C                   END
      *
      **     If action code is insert, set screen defaults
      *
     C     ACTN          IFEQ      'I'
     C                   MOVE      'N'           SAROD
     C                   MOVE      'N'           SARMF
     C                   ELSE
      *
      **     If action is not insert, access current details from
      **      report requests file
     C*
     C     RNAM          CHAIN     FCMOUTL1                           86
     C*
     C     *IN86         IFEQ      '1'
     C***********          MOVE 'RCF0023' MSGID                           LN1186
     C                   MOVE      'RCF1023'     MSGID                                         LN118
     C                   EXSR      UPDOWS
     C                   ELSE
     C*
      **     Set up screen fields from report request record
     C*
     C                   MOVE      RNAM          SRNAM
     C                   MOVE      D2AROD        SAROD
     C                   MOVE      D2DRQD        SDRQD
     C                   MOVE      D2ARMF        SARMF
     C                   MOVE      D2DFTO        SSOID
     C                   MOVE      D2TNLU        PTNLU
     C                   MOVE      D2DLS1        SDST1
     C                   MOVE      D2DLS2        SDST2
     C                   MOVE      D2USRO        SUSRO
     C                   MOVE      D2DFTU        SUSRR
     C                   END
     C*
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R UPDOWS - TO DISPLAY SCREEN WHERE UPDATE BY ANOTHER W/S
     C*  CALLED FROM MAIN PROCESSING, INSAMD, INIT1
     C*  CALLS END
     C*
     C********************************************************************
     C*
     C     UPDOWS        BEGSR
     C*
     C                   CALL      'ZA0250'
     C                   CALL      'FCC0240'
     C                   PARM                    MSGID
      *
     C                   WRITE     FC0220C1
     C                   SETON                                        54
     C*
      **      Alert the user
      **        and allow them to exit/return
     C*
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C                   EXFMT     FC0220F0
     C                   END
     C*
     C     *IN03         IFEQ      '1'
     C                   MOVE      'Y2U9999'     RTCD
     C                   EXSR      END
     C                   END
     C*
     C     *IN12         IFEQ      '1'
     C                   MOVE      *BLANK        RTCD
     C                   EXSR      END
     C                   END
     C*
     C                   ENDSR
      ********************************************************************
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
     C                   MOVE      'Y2U9999'     RTCD
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
     C/EXEC SQL                                                                             MD055265
     C+ close BCursor                                                                       MD055265
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
     C                   MOVE      'Y2U9999'     RTCD
     C                   DUMP
     C                   END
     C                   ENDSR
     C********************************************************************
      /EJECT
      *COPY*ZSRSRC,ZTNLU1Z2                                                                 MD055265
      /COPY ZSRSRC,ZTNLU1Z4                                                                 MD055265
     O@ECREJU   E            RELACP                                             LN0210
** CPY@
(c) Finastra International Limited 2001
