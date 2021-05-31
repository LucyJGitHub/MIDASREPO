     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD055265
/*STD *  RPGSQLBND                                                    *                     MD055265
/*EXI *  TEXT('Midas FC Output instruction maintenance')
/*O*RF*:*OVRDBF*(QAOKDL01)*(QAOKL01A)*******************************:**                       CAAA02
      *****************************************************************
      *                                                               *
      *  Midas - Report Control Facility Module                       *
      *                                                               *
      *  FC0215 - REQUEST A PERIODIC REPORT, OUTPUT INSTRUCTIONS      *
      *           SCREEN                                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD055265           Date 10Feb20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD031966           Date 27Jul15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14821           Date 07Sep07               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 219969             DATE 06Jun06               *
      *                 BUG8878            Date 14Nov05               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAAA02             Date 01Dec03               *
      *                 CFC002             Date 29Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 173405             Date 13Feb01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 127043             Date 23May00               *
      *                 178819             Date 22May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                     160489           DATE 13OCT99             *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                     112359           DATE 26FEB98             *
      *                     095462           DATE 22JAN98             *
      *                     108038           DATE 19SEP97             *
      *                     096823           DATE 28AUG96             *
      *                     088540           DATE 21JUN95             *
      *                     083547           DATE 20FEB95             *
      *                     S01486           DATE 03JUN94             *
      *                     048716           DATE 09FEB94             *
      *                     043702           DATE 21AUG92             *
      *                     S01382           DATE 17AUG92             *
      *                     S01117           DATE 25MAR92             *
      *                     E26621           DATE 23SEP91             *
      *                     S01269           DATE 25JUN91             *
      *                     LN1156           DATE 09APR91             *
      *                     LN1186           DATE 06MAR91             *
      *                     LN1170           DATE 19FEB91             *
      *                     LN0979           DATE 15NOV90             *
      *                     LN0719           DATE 11SEP90             *
      *                     BHF544           DATE 06SEP90             *
      *                     LN0503           DATE 10JUL90             *
      *                     LN0492           DATE 06JUL90             *
      *                     LN0210           DATE 18MAY90             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD055265 - Deliverable Data Split for Report Control Facility*
      *  MD046248 - Finastra Rebranding                               *
      *  MD031966 - BFM GL3572P1 issue                                *
      *  BUG14821 - Program FC0215 Dumps with duplicate key           *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  219969 - Amending a periodic report frequency from 'D' to 'M'*
      *           causes the system to loop.                          *
      *  BUG8878 - Archive to optical disk allowed only for non-audit *
      *            reports                                            *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAAA02 - Webfacing. Rename QAOK* refs. to the V5R2 names.    *
      *  CFC002 - Multiple Output Queues In Std Output Instructions   *
      *           Recompiled due to change in FCSOUTPD                *
      *  173405 - Amend the periodic report first date from future    *
      *           to rundate, should not delete the record in P/F     *
      *           FCRREQPD.                                           *
      *      127043 - Requested report was not generated during EOM.  *
      *               NEXT ACTIVE DATE was calculated as the last     *
      *               working day of next month. Applied fix 107739,  *
      *               in which certain conditions were removed which  *
      *               increment the month of the NEXT ACTIVE DATE     *
      *               field incorrectly.                              *
      *      178819 - Decimal data error in field at statement 275500 *
      *      160489 - If Periodic Request is inserted and amended     *
      *               'today', reports are deleted from Reports          *
      *               Request file.  Prevent deletion if First Date      *
      *               is equal to Run Date.                              *
      *      112359 - Array Index Error caused by Last Activity Date     *
      *               being 0. Fix is to use First Date in this case.    *
      *      095462 - If 2 users attempt to delete record at same time,  *
      *               both users update the file controls, causing FCOOB.*
      *               If record has been deleted by another user, send   *
      *               message, else delete and update file controls.     *
      *      108038 - Amend of frequency from 'D' to weekly sometimes    *
      *               generates extra reports.                           *
      *      096823 - EOM REQUESTED REPORTS NOT PRODUCED IF FREQ IS 'B'. *
      *               'NEXT ACTIVITY DATE' SET TO NEXT MONTH             *
      *      088540 - Periodical report modifications (excpt Freq. and   *
      *               Freq. Day Number) are not taken into consideration *
      *               the day of the amend but the next activity date    *
      *      083547 - Recompile over MUSERDD                             *
      *      S01486 - Private Banking Upgrade to ABS 10.                 *
      *               Always move Level to Entity to file regardless     *
      *               of whether multibranching is on or not.            *
      *      048716 - EOM REQUESTED REPORTS NOT PRODUCED IF FREQ IS
      *               AMENDED FROM 'M' TO 'B'. THIS ERROR IS CAUSED
      *               BY WRONG VARIABLE BEING PASSED TO THE 'NEXT
      *               ACTIVE DATE' FIELD' WHEN AMENDMENT IS DONE.
      *      043702 - VALIDATE DISTRIBUTION LIST                         *
      *      S01382 - OPTICAL DISK DEVELOPMENT.                          *
      *               - IF THE ARCHIVE ID MEDIUM IS BOTH THEN 'B'        *
      *                 SHOULD BE OUTPUT ON THE SCREEN AS THE MEDIUM.    *
      *      S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD                 *
      *      E26621 - IF A PERIODIC REPORT REQUEST WAS AMENDED ON THE
      *               DAY IT WAS DUE TO RUN THEN THE NEXT ACTIVE DATE    *
      *               TO RUN WAS SET TO ZERO AND THE REPORT REQUEST      *
      *               WAS DELETED FROM FCRREQPD. THE REPORT REQUEST      *
      *               SHOULD ONLY BE DELETED FROM FCRREQPD IF THE FIRST  *
      *               DATE TO RUN IS GREATER THAN RUN DATE OR IF THE     *
      *               NEXT ACTIVE DATE HAS CHANGED & IT IS NOT EQUAL TO  *
      *               THE RUN DATE. NOTE IF A MANUAL REQUEST FOR THE     *
      *               REPORT HAS BEEN MADE THAT DAY IT WILL NOT BE       *
      *               DELETED AS THE PERIODIC SEQUENCE NO IS *BLANK,     *
      *               AND THE DELETED REQUESTS HAVE TO MATCH THE REPORT  *
      *               NAME AND SEQUENCE NO OF THE REPORT BEING AMENDED.  *
      *                                                                  *
      *      S01269 - RECOMPILE FOR TRADE AUTHORISATION CHANGE TO
      *               MUSERDD
      *      LN1156 - DO NOT DISPLAY OUTPUT INSTRUCTIONS IF THE          *
      *               USER IS NOT AUTHORISED TO SEE THEM.                *
      *      LN1186 - SEND NEW MESSAGE ID FROM FCUSRMSG TO FCC0240       *
      *      LN1170 - ALLOW ALL USERS TO OUTPUT REPORTS TO OTHER USERS   *
      *      LN0979 - FIELD 'ROUT' SHOULD BE 'PROUT'
      *      LN0719 - FREQ DAY NO WAS NOT BEING SET UP CORRECTLY         *
      *      BHF544 - FREQUENCY DAY SET-UP AMENDMENT                     *
      *      LN0503 - RUN REPT TODAY IF PNDT *LT NEXT WORKING DAY        *
      *      LN0492 - IF FIRST DATE EQUALS RUNDAT WORK OUT NEXT DATE.    *
      *      LN0210 - ARCHIVING OPTIONS TO BE ADDED TO THE REPORT        *
      ********************************************************************
     FFC0215DF  CF   E             WORKSTN
     F                                     SFILE(FC0215S0:RRN)
     F                                     SFILE(FC0215S2:RRN2)                 LN0210
     FFCSOUTL1  IF   E           K DISK
     F*FCRSFXL1* IF   E           K DISK                                                    MD055265
     FMAARCPL2  UF   E           K DISK
     F                                     COMMIT
     FMAARCDL2  UF   E           K DISK
     F                                     COMMIT
     FMAARCHL1  IF   E           K DISK
     FMAARCHL2  IF   E           K DISK
     FMUSER     IF   E           K DISK
     FFCPREQL1  IF   E           K DISK
     FFCPREQL0  UF A E           K DISK
     F                                     COMMIT
     F                                     INFDS(INFDS)
     FSDFCTLL0  UF   E           K DISK
     F                                     COMMIT
     FFCRREQL9  UF   E           K DISK
     F                                     COMMIT
     FFCRREQL0  UF A E           K DISK
     F                                     COMMIT
     FFCPARPL0  UF A E           K DISK
     F                                     COMMIT
     FFCPARDL0  UF A E           K DISK
     F                                     COMMIT
     F*AARCPPDO***E********************DISK                               LN0210
     FMAARCPL1  UF   E           K DISK                                         LN0210
     F                                     COMMIT
     F*AARCDPDO***E********************DISK                               LN0210
     FMAARCDL1  UF   E           K DISK                                         LN0210
     F                                     COMMIT
     FMAARCPL0  O    E           K DISK                                         LN0210
     F                                     COMMIT                               LN0210
     F                                     INFDS(INFDSA)                        LN0210
     FMAARCDL0  O    E           K DISK                                         LN0210
     F                                     COMMIT                               LN0210
     F                                     INFDS(INFDSB)                        LN0210
     F*QAOKDL01IF*E********   K        DISK                                            043702 CAAA02
     FQAOKL01A  IF   E           K DISK
     F                                     IGNORE(WOSFMT01)                     043702
     FGL0781EX  UF   E           K DISK                                                 MD031966
     F                                     COMMIT                                       MD031966
     F/COPY WNCPYSRC,FC0215F001
     F********************************************************************
     F*             FUNCTION OF INDICATORS
     F*
     F*  01         FIRST SUBFILE USE INDICATOR
     F*  03         FUNCTION KEY 3 TAKEN FROM SCREEN
     F*  10         FUNCTION KEY 10 TAKEN FROM SCREEN
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
     F*  54         PROTECT ALL FIELDS
     F*  55         ENABLE COMMAND 12 ON INITIAL SCREEN IF UPDATE
     F*             BY ANOTHER WORKSTATION
     F*  56         ENABLE COMMAND 10 FOR DELETE
     F*  60         MESSAGE SUBFILE END
     F*  70         ERROR ON SCREEN
     F*  71         ERRORS ON SUBFILE
     F*  72         WARNINGS EXIST ON SUBFILE
     F*  74         ARCHIVING DETAILS VALID
     F*  75         SUBFILE VALID
     F*  76         REPORT REQUESTS RECORD CHAIN
     F*  77         REPORT REQUEST PARAMETERS RECORD CHAIN
     F*  78         REPORT REQUEST ARCHIVING CHAIN
     F*  80         STANDARD OUTPUT INSTRUCTIONS NOT FOUND
     F*  81         REPORT SUFFIXES NOT FOUND
     F*  82         END OF ARCHIVE ID'S FOR MEDIUM
     F*  83         END OF CHANGED SUBFILE RECORDS
     F*  84         CHAIN FAIL INDICATOR FOR MUSER
     F*  86         CHAIN FAIL TO FCPREQ ON AMEND
     F*  87         CHAIN FAIL TO FCPARP ON AMEND
     F*  88         END OF RECORDS ON MAARCPL2
     F*  89         CHAIN FAIL TO MAARCP/MAARCH ON AMEND
     F*
     F********************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D DATES           DS
     D*
     D** DATASTRUCTURE TO DEFINE DATE CONSTITUENT PARTS AS ZONED NUMERIC
     D*
     D  DAYNO                  1      2  0
     D  MTHNO                  3      4  0
     D  YRNO                   5      6  0
     D*
     D PREQDS          DS
     D*
     D** DATASTRUCTURE FOR REPORT REQUEST DATABASE ERRORS
     D*
     D  KRNAM                  1     10
     D  KPSQN                 11     12
     D*
     D INFDS           DS
     D*
     D** DATA STRUCTURE FOR RPG 01021 ERROR HANDLING
     D*
     D*
     D***********************************  *STATUS  STATUS                LN0210
     D  PRSTAT           *STATUS                                                LN0210
     D*                                                                   LN0210
     D INFDSA          DS                                                       LN0210
     D*                                                                   LN0210
     D** DATA STRUCTURE FOR RPG 01021 ERROR HANDLING                      LN0210
     D*                                                                   LN0210
     D  APSTAT           *STATUS                                                LN0210
     D*
     D INFDSB          DS                                                       LN0210
     D*                                                                   LN0210
     D** DATA STRUCTURE FOR RPG 01021 ERROR HANDLING                      LN0210
     D*                                                                   LN0210
     D  ADSTAT           *STATUS                                                LN0210
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
      *COPY*ZSRSRC,ZTNLU1Z1                                                                 MD055265
      /COPY ZSRSRC,ZTNLU1Z3                                                                 MD055265
      *COPY*ZSRSRC,ZAOZ1                                                                    MD055265
      *COPY*ZSRSRC,ZAOZ2                                                                    MD055265
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                MD055265
      *COPY ZSRSRC,ZAOZ3
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   MD055265
      *COPY*ZSRSRC,ZHOLI                                                                    MD055265
     D/COPY ZSRSRC,ZHOLILE                                                                  MD055265
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
     D FCRSFX        E DS                  EXTNAME(FCRSFJW0)                                MD055265
     I******************* SFX         8  2                                LN0210
     I******************* XNM        10  1                                LN0210
     I*COPY*ZSRSRC,ZDATE2Z1                                                                 MD055265
     I/COPY ZSRSRC,ZDATE2Z1LE                                                               MD055265
     I*COPY*ZSRSRC,ZFREQBZ1                                                                 MD055265
     I/COPY ZSRSRC,ZFREQBZ1LE                                                               MD055265
      *COPY*ZSRSRC,ZHOLE                                                                    MD055265
      /COPY ZSRSRC,ZHOLELE                                                                  MD055265
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
      * LF/SDMMODL1 ACCESS PROGRAM RECORD FORMAT DATA STRUCTURE
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      ** Input Parameters:
      **          Report Name
      **          CL Program Name
      **          CL Sequence Number
      **          Request description
      **          Midas/Q
      **          User Id for request
      **          Frequency
      **          Frequency Day no.
      **          First Date
      **          Level
      **          Entity
      **          Distribution Required
      **          Periodic Sequence Number
      **          Action
      **          Transaction Number of last update
      **          Report Description Default Output Id
      **          Parameters
      **          Return Code
      **          User's Authority to Output Instructions
      **          User's Output Queue
      **          User's Authority to other users
      **          User's Default Branch
      *
     C     *ENTRY        PLIST
     C                   PARM                    RNAM
     C                   PARM                    COTT
     C                   PARM                    CSEQ
     C                   PARM                    PDSC
     C                   PARM                    MIDQ              1
     C                   PARM                    USRR
     C                   PARM                    FREQ
     C                   PARM                    FDAY              2
     C                   PARM                    PFDT
     C                   PARM                    LVL
     C                   PARM                    ETTY
     C                   PARM                    DRQD
     C                   PARM                    PSQN
     C                   PARM                    ACTN              1
     C                   PARM                    PTNLU
     C                   PARM                    PDFTO
     C                   PARM                    PARM
     C                   PARM                    CODE              1
     C                   PARM                    PROUT             1
     C                   PARM                    POUTQ            10
     C                   PARM                    PMUREP            1
     C                   PARM                    PDBRN             3
     C                   PARM                    SEQNO             5
      *
     C                   EXSR      INIT1
      *
      **     IF user is authorised to change or view output instructions
      *
     C     PROUT         IFEQ      'Y'
     C     CODE          ANDNE     'D'
      *
     C     ACTN          OREQ      'E'
     C     PROUT         ANDEQ     'Y'                                                         LN115
      *
     C     ACTN          OREQ      'D'
     C     CODE          ANDNE     'D'
      *
     C                   EXSR      INIT2
     C                   MOVE      'Y'           OUTPF                                         LN021
      *
     C     *IN03         IFEQ      '1'
     C                   MOVE      'E'           CODE
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
      ** PERFORM FILE UPDATES                                             LN0210
      *                                                                   LN0210
     C     UPDF          IFEQ      'Y'                                                         LN021
      *                                                                   LN0210
     C*                                                                   LN0492
     C* IF FIRST DATE EQUALS RUNDAT , ON AN INSERT WORK OUT NEXT          LN0492
     C*  ACTIVE DATE BEFORE UPDATE OF PERIODIC REQUESTS FILE              LN0492
     C*                                                                   LN0492
     C     ACTN          IFEQ      'I'                                                         LN049
     C     ACTN          OREQ      'A'                                                         LN049
     C*                                                                   LN0492
     C     PFDT          IFEQ      RUND                                                        LN049
     C*                                                                   LN0492
     C                   Z-ADD     PNDT          PNDTX             5 0                         LN049
     C*                                                                   LN0492
     C                   CALL      'FC0015'                                                    LN049
     C                   PARM      *BLANK        P@RTCD            7                           LN049
     C                   PARM                    FREQ                                          LN049
     C*********************PARM           D9FDAY                   LN0492 LN0719
     C                   PARM                    FDAY                                          LN071
     C                   PARM                    PNDTX                                         LN049
     C*                                                                   LN0492
     C* IF DATABASE ERROR OCCURRED IN FC0015, END PROG.                   LN0492
     C*                                                                   LN0492
     C     P@RTCD        IFNE      *BLANKS                                                     LN049
     C     *LOCK         IN        LDA                                                         LN049
     C                   MOVEL     'FCPREQL2'    DBFILE                                        LN049
     C                   Z-ADD     10            DBASE                          *************  LN049
     C                   EXSR      DBERR                                        * DBERR 010 *  LN049
     C                   END                                                    *************  LN049
     C*                                                                   LN0492
     C                   Z-ADD     PNDTX         PNDT                                          LN049
     C                   END                                                                   LN049
     C                   END                                                                   LN049
     C*                                                                   LN0492
     C     ACTN          IFEQ      'I'                                                         LN021
     C     ACTN          OREQ      'A'                                                         LN021
     C                   EXSR      INSAMD                                                      LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     ACTN          IFEQ      'D'                                                         LN021
     C                   EXSR      DELETE                                                      LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
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
     C******************** WRITEFC0215C1                                  LN0210
     C******************** EXFMTFC0215F0                                  LN0210
     C******************** END                                            LN0210
      *********************                                               LN0210
     C******************** END                                            LN0210
      *********************                                               LN0210
      **************** Exit*program**f*F3*taken************************** LN0210
      *****************                                                   LN0210
     C*********  *IN03***  IFEQ '1'************************************** LN0210
     C*********************MOVE 'E'****** CODE*************************** LN0210
     C*********************EXSR END************************************** LN0210
     C*********************END******************************************* LN0210
      ******************************************************************* LN0210
      *****************Exit program if F12 taken************************* LN0210
      ******************************************************************* LN0210
     C*********  *IN12***  IFEQ '1'************************************** LN0210
     C*********************MOVE 'F'****** CODE*************************** LN0210
     C*********************EXSR END************************************** LN0210
     C*********************END******************************************* LN0210
      ******************************************************************* LN0210
     C*********************END******************************************* LN0210
      ******************************************************************* LN0210
     C*********************END******************************************* LN0210
      ******************************************************************* LN0210
     C********** ROUT      IFEQ 'N'                                 LN0210LN0979
     C     PROUT         IFEQ      'N'                                                         LN097
     C     CODE          OREQ      'D'                                                         LN021
      *                                                                   LN0210
     C     ACTN          IFEQ      'I'
     C     ACTN          OREQ      'A'
     C                   EXSR      INSAMD
     C                   END                                                                   LN021
      ******************************************************************* LN0210
      ** DELETE ANY REPORT REQUEST RECORDS NOT REQUIRED TODAY************ LN0210
      ******************************************************************* LN0210
     C********   PFDT****  IFNE RUND************************************* LN0210
     C********   PNDT****  ANDNERUND************************************* LN0210
     C******************** EXSR DELREQ*********************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** END******************************************* LN0210
      *
     C     ACTN          IFEQ      'D'
     C                   EXSR      DELETE
     C                   END
      *                                                                   LN0210
     C                   END                                                                   LN021
      ******************************************************************* LN0210
      ****** Issue Commit************************************************ LN0210
      ******************************************************************* LN0210
     C********   ACTN****  IFNE 'E'************************************** LN0210
     C******************** TIME********   MTIME************************** LN0210
     C********   CMTTXT****COMIT***************************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C                   SETON                                        LR
      *
     C********************************************************************
      *                INDEX OF SUBROUTINES
     C*  S/R INSAMD - TO PERFORM FILE UPDATES FOR INSERTION/AMENDMENT
     C*  S/R VALID - TO VALIDATE MAIN SCREEN
     C*  S/R RSFXS - TO DISPLAY SUFFIX SELECTION SCREEN FOR ARCHIVING     LN0210
     C*  S/R VALRSX - TO VALIDATE SUFFIX SELECTION SCREEN                 LN0210
     C*  S/R SETSUB - TO LOAD SUBFILE OF ARCHIVE IDENTIFIERS              LN0210
     C*  S/R DELETE - TO PERFORM DELETION PROCESSING
     C*  S/R DELREQ - TO PERFORM DELETION OF REQUEST
     C*  S/R ARCHS - TO PERFORM ARCHIVING SCREEN PROCESSING
     C*  S/R ARCHV - TO VALIDATE CHANGED SUBFILE RECORDS FOR PRINT SUFFIX
     C*  S/R INIT2 - TO INITIALISE MAIN SCREEN
     C*  S/R INIT1 - TO INITIALISE PROGRAM VARIABLES
     C*  S/R UPDOWS - TO DISPLAY SCREEN ERROR IF UPDATE BY ANOTHER W/S
     C*  S/R DBERR - TO PROCESS DATABASE ERRORS AND TERMINATE PROGRAM
     C*  S/R END - TO TERMINATE PROGRAM
     C*  S/R *PSSR - ERROR ROUTINE
     C*  S/R ZTNLU1 - ACCESS NEXT AVAILABLE TRANSACTION NUMBER FROM MNATN
     C*  S/R PFREQB - CALCULATE NEXT PERIODIC DATE
     C*  S/R ZDATE1 - CONVERT DATE TO DAYNO
     C*  S/R ZDATE2 - CONVERT DAYNO TO DATE
     C*  S/R ZACCH - ACCESS HOLIDAYS FILE
     C*  S/R ZBKDT - CHECK IF DATE IS A WORKING DAY AND FIND PREVIOUS DAY
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
     C     PREQKY        CHAIN     FCPREQL0                           86
      *
      **  IF TRANSACTION NUMBER HAS CHANGED, ALERT USER TO UPDATE
      *
     C     ACTN          IFEQ      'A'
     C     D9TNLU        ANDNE     PTNLU
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
     C     D9AROD        ANDEQ     'Y'                                                         LN021
      *                                                                   LN0210
     C     ARCPKP        SETLL     MAARCPL2                                                    LN021
     C     ARCPKP        READE     MAARCPL2                               88                   LN021
      *                                                                   LN0210
     C     *IN88         DOWEQ     '0'                                                         LN021
     C     ECARID        CHAIN     MAARCHL1                           89                       LN021
      *                                                                   LN0210
     C     *IN89         IFEQ      '1'                                                         LN021
     C     *LOCK         IN        LDA                                                         LN021
     C                   MOVEL     'MAARCHL1'    DBFILE                                        LN021
     C                   MOVEL     EBARID        DBKEY                          ************** LN021
     C                   Z-ADD     8             DBASE                          * DBERR 008 ** LN021
     C                   EXSR      DBERR                                        ************** LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     *IN89         IFEQ      '0'                                                         LN021
     C     EAMEDM        ANDEQ     'O'                                                         LN021
     C                   DELETE    @ARCPAP                                                     LN021
     C                   MOVE      ECRSFX        SRSFX                                         LN021
     C     ARCDKY        CHAIN     MAARCDL1                           89                       LN021
     C  N89              DELETE    @ECREJU                                                     LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     ARCPKP        READE     MAARCPL2                               88                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    Delete Microfiche archiving if not required   LN0210
      *                                                                   LN0210
     C     D9ARMF        IFEQ      'Y'                                                         LN021
     C     SARMF         ANDEQ     'N'                                                         LN021
      *                                                                   LN0210
     C     ARCPKP        SETLL     MAARCPL2                                                    LN021
     C     ARCPKP        READE     MAARCPL2                               88                   LN021
      *                                                                   LN0210
     C     *IN88         DOWEQ     '0'                                                         LN021
     C     ECARID        CHAIN     MAARCHL1                           89                       LN021
      *                                                                   LN0210
     C     *IN89         IFEQ      '1'                                                         LN021
     C     *LOCK         IN        LDA                                                         LN021
     C                   MOVEL     'MAARCHL1'    DBFILE                                        LN021
     C                   MOVEL     EBARID        DBKEY                          ************** LN021
     C                   Z-ADD     9             DBASE                          * DBERR 009 ** LN021
     C                   EXSR      DBERR                                        ************** LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     *IN89         IFEQ      '0'                                                         LN021
     C     EAMEDM        ANDEQ     'M'                                                         LN021
     C                   DELETE    @ARCPAP                                                     LN021
     C                   MOVE      ECRSFX        SRSFX                                         LN021
     C     ARCDKY        CHAIN     MAARCDL1                           89                       LN021
     C  N89              DELETE    @ECREJU                                                     LN021
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
     C                   READC     FC0215S0                               83                   LN021
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
      *                                                                   LN0210
     C     WURQSQ        IFNE      *BLANK                                                      LN021
     C                   MOVE      SARID         EBARID                                        LN021
     C                   MOVE      RNAM          EBRNAM                                        LN021
     C                   MOVE      WURQSQ        EBRQSQ                                        LN021
     C                   MOVE      SRSFX         EBRSFX                                        LN021
     C                   WRITE     @EBREJQ                                                     LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      **      If a record did exist on periodic file, check single        LN0210
      **                    request file and add if absent                LN0210
      *                                                                   LN0210
     C     SSEL          IFEQ      '1'                                                         LN021
     C     SEXST         ANDEQ     'Y'                                                         LN021
     C     WURQSQ        ANDNE     *BLANK                                                      LN021
      *                                                                   LN0210
     C     ARCDKY        CHAIN     MAARCDL1                           89                       LN021
      *                                                                   LN0210
     C     *IN89         IFEQ      '1'                                                         LN021
     C                   MOVE      SARID         EBARID                                        LN021
     C                   MOVE      RNAM          EBRNAM                                        LN021
     C                   MOVE      WURQSQ        EBRQSQ                                        LN021
     C                   MOVE      SRSFX         EBRSFX                                        LN021
     C                   WRITE     @EBREJQ                                                     LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      **      If a record did exist, but no current request made          LN0210
      **                    Delete Archive Contents                       LN0210
      *                                                                   LN0210
     C     SSEL          IFEQ      *BLANK                                                      LN021
     C     SEXST         ANDEQ     'Y'                                                         LN021
     C     ARCPKY        CHAIN     MAARCPL1                           89                       LN021
     C  N89              DELETE    @ECREJU                                                     LN021
      *                                                                   LN0210
     C     WURQSQ        IFNE      *BLANK                                                      LN021
     C     ARCDKY        CHAIN     MAARCDL1                           89                       LN021
     C  N89              DELETE    @EBREJR                                                     LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
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
     C                   READC     FC0215S0                               83                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      ** Read Suffix Selection Subfile                                    LN0210
      *                                                                   LN0210
     C                   Z-ADD     1             RRN2                                          LN021
     C                   READC     FC0215S2                               83                   LN021
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
     C                   READC     FC0215S2                               83                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END                                                                   LN021
      *                                                                   LN0210
      *
     C                   MOVE      RNAM          D9RNAM
     C                   MOVE      PSQN          D9PSQN
     C                   MOVE      ACTN          D9CHTP
     C                   MOVE      COTT          D9COTT
     C                   MOVE      CSEQ          D9CSEQ
     C                   MOVE      SSOID         D9SOID
     C                   Z-ADD     NATN          D9TNLU
     C                   MOVE      SDST1         D9DLS1
     C                   MOVE      SDST2         D9DLS2
     C                   MOVE      SUSRO         D9USRO
     C                   MOVE      SARMF         D9ARMF
     C                   MOVE      SAROD         D9AROD
     C                   MOVE      DRQD          D9DRQD
     C                   MOVE      USRR          D9USRR
     C                   MOVE      PDSC          D9PDSC
     C                   MOVE      FREQ          D9FREQ
     C                   MOVE      FDAY          D9FDAY
     C                   Z-ADD     PFDT          D9PFDT
     C                   Z-ADD     PNDT          D9PNDT
     C                   Z-ADD     RUND          D9LCD
      *
     C***********MBIN      IFEQ 'Y'                                       S01486
     C                   MOVE      LVL           D9LVL
     C                   MOVE      ETTY          D9ETTY
     C***********          END                                            S01486
      *
      **  WRITE TO FILES IF INSERTION
      *
     C     ACTN          IFEQ      'I'
     C     *IN86         ANDEQ     '1'
     C                   WRITE     @D9REJI                              20
     C*
     C** TEST FOR UPDATE BY ANOTHER W/S, OR A TERMINAL ERROR
     C*
     C     *IN20         IFEQ      '1'
     C*
     C********** STATUS    IFEQ 01021                                     LN0210
     C     PRSTAT        IFEQ      01021                                                       LN021
     C***********          MOVE 'RCF0064' MSGID                           LN1186
     C                   MOVE      'RCF1064'     MSGID                                         LN118
     C                   EXSR      UPDOWS
     C                   ELSE
     C                   EXSR      *PSSR
     C                   END
      *
     C                   END
      *
     C     PARM          IFNE      *BLANK
     C                   MOVE      RNAM          D8RNAM
     C                   MOVE      PSQN          D8PSQN
     C                   MOVE      PARM          D8PARM
     C/COPY WNCPYSRC,FC0215C001
     C                   WRITE     @D8REJH
     C                   END
      *
     C                   END
      *
      **  IF ACTION CODE IS AMEND, UPDATE RECORD
      *
     C     ACTN          IFEQ      'A'
     C     *IN86         ANDEQ     '0'
      *                                                                   108038
     C     RUND          IFEQ      PNDT                                                        10803
     C                   CALL      'FC0015'                                                    10803
     C                   PARM      *BLANK        P@RTCD            7                           10803
     C                   PARM                    FREQ                                          10803
     C                   PARM                    FDAY                                          10803
     C                   PARM                    PNDTX                                         10803
      *                                                                   108038
      ** If database error occurred in FC0015, end program                108038
      *                                                                   108038
     C     P@RTCD        IFNE      *BLANKS                                                     10803
     C     *LOCK         IN        LDA                                                         10803
     C                   MOVEL     'FCPREQL2'    DBFILE                                        10803
     C                   Z-ADD     10            DBASE                          *************  10803
     C                   EXSR      DBERR                                        * DBERR 010 *  10803
     C                   END                                                    *************  10803
      *                                                                   108038
     C                   Z-ADD     PNDTX         D9PNDT                                        10803
     C                   END                                                                   10803
      *                                                                   108038
     C                   UPDATE    @D9REJI
      *
     C     PREQKY        CHAIN     FCPARPL0                           87
     C/COPY WNCPYSRC,FC0215C002
     C                   MOVE      RNAM          D8RNAM
     C                   MOVE      PSQN          D8PSQN
     C                   MOVE      PARM          D8PARM
      *
     C     PARM          IFNE      *BLANK
     C/COPY WNCPYSRC,FC0215C003
      *
     C     *IN87         IFEQ      '0'
     C                   UPDATE    @D8REJH
     C                   ELSE
     C                   WRITE     @D8REJH
     C                   END
      *
     C                   ELSE
     C  N87              DELETE    @D8REJH
     C/COPY WNCPYSRC,FC0215C004
     C                   END
      *
     C                   END
      *
      **  Update file controls
      *
     C                   MOVEL     'FCPREQPD'    AHFLNM
     C     AHFLNM        CHAIN     SDFCTLL0                           99
      *
      **  Database error if no record found for file
      *
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDFCTLL1'    DBFILE
     C******************** MOVEL'PREQ'    DBKEY            *************  LN0210
     C                   MOVEL     'FCPREQPD'    DBKEY                          *************  LN021
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
     C     WURQSQ        IFNE      *BLANK
      *
      **     Write report requests record
      **     IF parameters is not blank
      **          Write Parameters daily record
      **     ENDIF
      *
     C     WURQSQ        CHAIN     FCRREQL0                           76
      *
     C                   MOVE      RNAM          D5RNAM
     C                   MOVE      WURQSQ        D5RQSQ
     C                   MOVE      COTT          D5COTT
     C                   MOVE      CSEQ          D5CSEQ
     C                   MOVE      SSOID         D5SOID
     C                   TIME                    MTIME
     C                   MOVEL     MTIME         D5RQTM
     C                   Z-ADD     NATN          D5TNLU
      *
     C***********MBIN      IFEQ 'Y'                                       S01486
     C                   MOVE      LVL           D5LVL
     C                   MOVE      ETTY          D5ETTY
     C***********          END                                            S01486
      *
     C                   MOVE      'N'           D5IPCY
     C                   MOVE      'N'           D5COBR
     C                   MOVE      'Y'           D5PDFL
     C                   MOVE      PSQN          D5PSQR
     C                   MOVE      SDST1         D5DLS1
     C                   MOVE      SDST2         D5DLS2
     C                   MOVE      SUSRO         D5USRO
     C                   MOVE      SARMF         D5ARMF
     C                   MOVE      SAROD         D5AROD
     C                   MOVE      DRQD          D5DRQD
      *
     C                   MOVE      USRR          D5USRR
     C                   MOVE      PDBRN         D5DBRN
      *
     C     *IN76         IFEQ      '1'
      *
     C                   WRITE     @D5REI8
      *
     C     PARM          IFNE      *BLANK
     C                   MOVE      RNAM          D7RNAM
     C                   MOVE      WURQSQ        D7RQSQ
     C                   MOVE      PARM          D7PARM
     C/COPY WNCPYSRC,FC0215C005
     C                   WRITE     @D7REJE
     C                   END
      *
     C                   ELSE
      *
     C                   UPDATE    @D5REI8
      *
     C     RREQKY        CHAIN     FCPARDL0                           77
     C/COPY WNCPYSRC,FC0215C006
     C                   MOVE      RNAM          D7RNAM
     C                   MOVE      WURQSQ        D7RQSQ
     C                   MOVE      PARM          D7PARM
      *
     C     PARM          IFNE      *BLANK
     C/COPY WNCPYSRC,FC0215C007
      *
     C     *IN77         IFEQ      '0'
     C                   UPDATE    @D7REJE
     C                   ELSE
     C                   WRITE     @D7REJE
     C                   END
      *
     C                   ELSE
     C  N77              DELETE    @D7REJE
     C/COPY WNCPYSRC,FC0215C008
     C                   END
      *
     C                   END
      *
     C                   END
      *
      ** DELETE ANY REPORT REQUEST RECORDS NOT REQUIRED TODAY             LN0210
      *                                                                   LN0210
     C***********PFDT      IFNE RUND                                LN0210E26621
     C***********PNDT      ANDNERUND                                LN0210E26621
     C     PFDT          IFGT      RUND                                                        E2662
     C     PNDT          ORNE      PNDTOR                                                      E2662
     C     PNDT          ANDNE     RUND                                                        E2662
     C     PFDT          ANDNE     RUND                                                        17340
     C     *IN76         OREQ      '0'                                                         10803
     C     PNDT          ANDGT     RUND                                                        10803
     C     PFDT          ANDNE     RUND                                                        16048
      *                                                                   108038
     C                   EXSR      DELREQ                                                      LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   TIME                    MTIME                                         LN021
     C     CMTTXT        COMMIT                                                                LN021
      *                                                                   LN0210
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
      *
     C******************** CALL 'ZA0250'                                  LN0210
     C******************** SETOF                     703334               LN0210
     C                   SETON                                        70                       LN021
     C                   SETOFF                                       3334                     LN021
     C                   SETOFF                                       303132
      *                                                                   LN0210
     C                   WRITE     FC0215C1                                                    LN021
     C                   EXFMT     FC0215F0                                                    LN021
      *
      **      Validation of input fields for insertion/amendment
      *
     C     ACTN          IFEQ      'I'
     C     ACTN          OREQ      'A'
      *                                                                   LN0210
     C     *IN70         DOWEQ     '1'                                                         LN021
     C     *IN03         ANDEQ     '0'                                                         LN021
     C     *IN12         ANDEQ     '0'                                                         LN021
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
      **********************IF*this*is*not*the*user's*own*Id****          LN1170
      **********************AND*user*is*not*authorised*to*others          LN1170
      ***************************Send*error*message*************          LN1170
      **********************************************************          LN1170
     C***********SUSRO     IFNE JUSR                                      LN1170
     C***********PMUREP    ANDEQ'N'                                       LN1170
     C***********          SETON                     7032                 LN1170
     C***********          CALL 'FCC0240'                                 LN1170
     C***********          PARM 'RCF0005' MSGID   7                       LN1170
     C***********          END                                            LN1170
      *******************************************************             LN1170
      **********************IF*user*is*authorised*to*others**             LN1170
      **********************AND*this*is*not*the*user's*own*Id             LN1170
      *******************************************************             LN1170
     C***********PMUREP    IFEQ 'Y'                                       LN1170
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
      *                                                                                      BUG8878
      **        Archive to optical disk allowed only for non-audit reports                   BUG8878
      *                                                                                      BUG8878
     C     SAROD         IFEQ      'Y'
      *                                                                                      BUG8878
      ** Access Report Suffixes (Spool file names) for the report                            BUG8878
      *                                                                                      BUG8878
     C*****RNAM*         SETLL     FCRSFXL1                                                 MD055265
     C*****RNAM*         READE     FCRSFXL1                               81                MD055265
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
      *                                                                                      BUG8878
      ** Ignore Audit Report sections                                                        BUG8878
      *                                                                                      BUG8878
     C     DYAURP        IFEQ      'Y'
     C*****RNAM*         READE     FCRSFXL1                               81                MD055265
     C/EXEC SQL                                                                             MD055265
     C+ fetch next from ACursor into :FCRSFX                                                MD055265
     C/END-EXEC                                                                             MD055265
     C                   END
      *                                                                                      BUG8878
      **                    IF no records found                                              BUG8878
      *                                                                                      BUG8878
     C******IN81         IFEQ      '1'                                                      MD055265
     C                   IF        SQLCODE = 100                                            MD055265
     C                   SETON                                        7034
     C                   CALL      'FCC0240'
     C                   PARM      'RCF1018'     MSGID
     C                   END
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
     C   70              WRITE     FC0215C1                                                    LN021
     C   70              EXFMT     FC0215F0                                                    LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C                   END
      *
      **       Validation of Deletion Processing
      *
     C     ACTN          IFEQ      'D'
      *                                                                   LN0210
     C     *IN70         DOWEQ     '1'                                                         LN021
     C     *IN03         ANDEQ     '0'                                                         LN021
     C     *IN12         ANDEQ     '0'                                                         LN021
      *                                                                   LN0210
     C                   SETOFF                                       7035                     LN021
     C                   CALL      'ZA0250'                                                    LN021
      *
     C     *IN10         IFEQ      '0'
     C                   SETON                                        70
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0021' MSGID   7                       LN1186
     C                   PARM      'RCF1021'     MSGID                                         LN118
     C                   WRITE     FC0215C1                                                    LN021
     C                   EXFMT     FC0215F0                                                    LN021
     C                   END
      *
     C                   END
      *                                                                   LN0210
     C                   END                                                                   LN021
      *
      *                                                                   LN0210
      ** SCREEN VALID AND EXIT/PREVIOUS NOT REQUESTED                     LN0210
      *                                                                   LN0210
     C     *IN03         IFEQ      '0'                                                         LN021
     C     *IN12         ANDEQ     '0'                                                         LN021
      *                                                                   LN0210
      ** SET CURRENT SCREEN OFF, CHECK ARCHIVING REQUIREMENT              LN0210
      **    IF ARCHIVING NOT PRESENT, PERFORM UPDATES                     LN0210
      **    IF ARCHIVING MAY BE REQUIRED, PROCESS ARCHIVING               LN0210
      *                                                                   LN0210
     C                   MOVE      'N'           OUTPF             1                           LN021
      *                                                                   LN0210
     C     SAROD         IFEQ      'Y'                                                         LN021
     C     ACTN          ANDNE     'D'                                                         LN021
     C     SARMF         OREQ      'Y'                                                         LN021
     C     ACTN          ANDNE     'D'                                                         LN021
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
     C                   MOVE      'E'           CODE                                          LN021
     C                   MOVE      'T'           ACTN                                          LN021
     C                   EXSR      END                                                         LN021
     C                   END                                                                   LN021
     C*                                                                   LN0210
     C     *IN12         IFEQ      '1'                                                         LN021
     C                   MOVE      'F'           CODE                                          LN021
     C                   EXSR      END                                                         LN021
     C                   END                                                                   LN021
     C*                                                                   LN0210
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
     C                   Z-ADD     7             DBASE                          * DBERR 007 ** LN021
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
     C                   WRITE     FC0215C2                                                    LN021
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
     C                   WRITE     FC0215S2                                                    LN021
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
     C                   WRITE     FC0215F1                                                    LN021
     C                   WRITE     FC0215F2                                                    LN021
     C                   WRITE     FC0215C1                                                    LN021
     C                   EXFMT     FC0215C2                                                    LN021
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
     C                   READC     FC0215S2                               83                   LN021
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
     C                   UPDATE    FC0215S2                                                    LN021
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
     C                   UPDATE    FC0215S2                                                    LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **     If record changed to have selection blanked out, and no      LN0210
      **     archive record previously existed, set of SFLNXTCHG          LN0210
      *                                                                   LN0210
     C     SSELX         IFEQ      *BLANK                                                      LN021
     C     SEXSTX        ANDNE     'Y'                                                         LN021
     C                   SETOFF                                       3520                     LN021
     C                   UPDATE    FC0215S2                                                    LN021
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
     C                   READC     FC0215S2                               83                   LN021
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
     C                   WRITE     FC0215F1                                                    LN021
     C                   WRITE     FC0215F2                                                    LN021
     C                   WRITE     FC0215C1                                                    LN021
     C                   EXFMT     FC0215C2                                                    LN021
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
     C                   MOVE      'E'           CODE                                          LN021
     C                   MOVE      'T'           ACTN                                          LN021
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
     C                   READC     FC0215S2                               83                   LN021
      *                                                                   LN0210
      ** Read next record if not selected                                 LN0210
      *                                                                   LN0210
     C     SSELX         IFNE      '1'                                                         LN021
     C                   SETON                                        20                       LN021
     C                   UPDATE    FC0215S2                                                    LN021
     C                   READC     FC0215S2                               83                   LN021
     C                   SETOFF                                       20                       LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
     C     *IN01         IFEQ      '1'                                                         LN021
     C                   Z-ADD     0             RRN                                           LN021
     C                   SETON                                        22                       LN021
     C                   SETOFF                                       21                       LN021
     C                   WRITE     FC0215C0                                                    LN021
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
     C                   MOVE      RNAM          KRNAM
     C                   MOVE      PSQN          KPSQN
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
     C                   WRITE     FC0215S0                                                    LN021
     C                   READ      MAARCHL2                               82                   LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **                    Read changed records                          LN0210
      *                                                                   LN0210
     C                   SETON                                        20                       LN021
     C                   UPDATE    FC0215S2                                                    LN021
     C                   SETOFF                                       20                       LN021
      *                                                                   LN0210
     C                   READC     FC0215S2                               83                   LN021
      *                                                                   LN0210
      ** Read next record if not selected                                 LN0210
      *                                                                   LN0210
     C     SSELX         IFNE      '1'                                                         LN021
     C                   SETON                                        20                       LN021
     C                   UPDATE    FC0215S2                                                    LN021
     C                   READC     FC0215S2                               83                   LN021
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
      /EJECT
     C********************************************************************
     C*
     C*  S/R DELETE - TO PERFORM DELETION PROCESSING
     C*  CALLED FROM MAIN
     C*  CALLS       DELREQ, DBERR
     C*
     C********************************************************************
      *
     C     DELETE        BEGSR
      *
      **  Delete Periodic Request Record
      *
     C     PREQKY        CHAIN     FCPREQL0                           86
     C     *IN86         IFEQ      '1'                                                         09546
     C                   MOVE      'RCF1023'     MSGID                                         09546
     C                   EXSR      UPDOWS                                                      09546
     C                   ELSE                                                                  09546
     C**N86******          DELET@D9REJI                                   095462
     C                   DELETE    @D9REJI                                                     09546
      *
      **  Delete Periodic Request Parameters Record
      *
     C     PREQKY        CHAIN     FCPARPL0                           87
     C  N87              DELETE    @D8REJH
     C/COPY WNCPYSRC,FC0215C009
      *
     C     PREQKY        SETLL     MAARCPL2
      *
      **  Delete Periodic Request Archiving, if present
      *
     C     PREQKY        READE     MAARCPL2                               88
      *
     C     *IN88         DOWEQ     '0'
     C                   DELETE    @ARCPAP
     C     PREQKY        READE     MAARCPL2                               88
     C                   END
      *
      **  Update file controls
      *
     C******************** MOVEL'PREQ'    AHFLNM                          LN0210
     C                   MOVEL     'FCPREQPD'    AHFLNM                                        LN021
     C     AHFLNM        CHAIN     SDFCTLL0                           99
      *
      **  Database error if no record found for file
      *
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDFCTLL1'    DBFILE
     C******************** MOVEL'PREQ'    DBKEY            *************  LN0210
     C                   MOVEL     'FCPREQPD'    DBKEY                          *************  LN021
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
      *
     C                   EXSR      DELREQ
      *                                                                   LN0210
     C                   TIME                    MTIME                                         LN021
     C     CMTTXT        COMMIT                                                                LN021
      *
     C                   END                                                                   09546
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C*  S/R DELREQ - TO PERFORM DELETION OF REQUEST
     C*  CALLED FROM DELETE, MAIN
     C*
     C********************************************************************
      *
     C     DELREQ        BEGSR
      *
      **  Delete Report Request if present
      *
     C     PREQKY        CHAIN     FCRREQL9                           76
      *
     C     *IN76         IFEQ      '0'
     C                   DELETE    @RREQA8
      *
      **  Delete Report Request parameters if present
      *
     C                   MOVE      D5RQSQ        WURQSQ
      *
     C     RREQKY        KLIST
     C                   KFLD                    RNAM
     C                   KFLD                    WURQSQ
      *
     C     RREQKY        CHAIN     FCPARDL0                           77
     C  N77              DELETE    @D7REJE
     C/COPY WNCPYSRC,FC0215C010
      *
     C     RREQKY        SETLL     MAARCDL2
      *
      **  Delete Periodic Request Archiving, if present
      *
     C     RREQKY        READE     MAARCDL2                               78
      *
     C     *IN78         DOWEQ     '0'
     C                   DELETE    @ARCDAO
     C     RREQKY        READE     MAARCDL2                               78
     C                   END
      *
     C                   END
     C                   ENDSR
     C********************************************************************
      /EJECT                                                              LN0210
     C******************************************************************* LN0210
     C******************************************************************* LN0210
     C*  S/R ARCHS - TO PERFORM ARCHIVING SCREEN PROCESSING************** LN0210
     C*  CALLED FROM MAIN************************************************ LN0210
     C*  CALLS ARCHV, DBERR********************************************** LN0210
     C******************************************************************* LN0210
     C******************************************************************* LN0210
      ******************************************************************* LN0210
     C********   ARCHS**** BEGSR***************************************** LN0210
      ******************************************************************* LN0210
      **********************Delete all archiving if not required********* LN0210
      ******************************************************************* LN0210
     C********   SAROD**** IFEQ 'N'************************************** LN0210
     C********   SARMF**** ANDEQ'N'************************************** LN0210
      ******************************************************************* LN0210
     C********   PREQKY****SETLLMAARCPL2********************************* LN0210
     C********   PREQKY****READEMAARCPL2**************** 88************** LN0210
      ******************************************************************* LN0210
     C********   *IN88**** DOWEQ'0'************************************** LN0210
     C******************** DELET@ARCPAP********************************** LN0210
     C********   PREQKY****READEMAARCPL2**************** 88************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
      **  Delete Periodic Request Archiving, if present****************** LN0210
      ******************************************************************* LN0210
     C********   RREQKY****SETLLMAARCDL2********************************* LN0210
     C********   RREQKY****READEMAARCDL2**************** 78************** LN0210
      ******************************************************************* LN0210
     C********   *IN78**** DOWEQ'0'************************************** LN0210
     C******************** DELET@ARCDAO********************************** LN0210
     C********   RREQKY****READEMAARCDL2**************** 78************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** GOTO ENDAS************************************ LN0210
      ******************************************************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
      **********************Delete Optical Disk if not required********** LN0210
      ******************************************************************* LN0210
     C********   SAROD**** IFEQ 'N'************************************** LN0210
     C********   D9AROD****ANDEQ'Y'************************************** LN0210
      ******************************************************************* LN0210
     C********   PREQKY****SETLLMAARCPL2********************************* LN0210
     C********   PREQKY****READEMAARCPL2**************** 88************** LN0210
      ******************************************************************* LN0210
     C********   *IN88**** DOWEQ'0'************************************** LN0210
     C********   ECARID****CHAINMAARCHL1************ 89****************** LN0210
      ******************************************************************* LN0210
     C********   *IN89**** IFEQ '0'************************************** LN0210
     C********   EAMEDM****ANDEQ'O'************************************** LN0210
     C******************** DELET@ARCPAP********************************** LN0210
     C********   ARCDKY****CHAINMAARCDL2************ 78****************** LN0210
     C**N78****************DELET@ARCDAO********************************** LN0210
     C********   ARCDKY****KLIST***************************************** LN0210
     C******************** KFLD********   RNAM*************************** LN0210
     C******************** KFLD********   WURQSQ************************* LN0210
     C******************** KFLD********   ECRSFX************************* LN0210
     C******************** END******************************************* LN0210
     C********   *IN89**** IFEQ '1'************************************** LN0210
     C********   *LOCK**** IN   LDA************************************** LN0210
     C******************** MOVEL'MAARCHL1'DBFILE************************* LN0210
     C******************** MOVELECARID****DBKEY************************** LN0210
     C******************** Z-ADD8******** DBASE************* DBERR 008 ** LN0210
     C******************** EXSR DBERR********************  ************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********   PREQKY****READEMAARCPL2**************** 88************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
      **********************Delete Microfiche archiving if not required   LN0210
      ******************************************************************* LN0210
     C********   D9ARMF****IFEQ 'Y'************************************** LN0210
     C********   SARMF**** ANDEQ'N'************************************** LN0210
      ******************************************************************* LN0210
     C********   PREQKY****SETLLMAARCPL2********************************* LN0210
     C********   PREQKY****READEMAARCPL2**************** 88************** LN0210
      ******************************************************************* LN0210
     C********   *IN88**** DOWEQ'0'************************************** LN0210
     C********   ECARID****CHAINMAARCHL1************ 89****************** LN0210
      ******************************************************************* LN0210
     C********   *IN89**** IFEQ '0'************************************** LN0210
     C********   EAMEDM****ANDEQ'M'************************************** LN0210
     C******************** DELET@ARCPAP********************************** LN0210
     C********   ARCDKY****CHAINMAARCDL2************ 78****************** LN0210
     C**N78****************DELET@ARCDAO********************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********   *IN89**** IFEQ '1'************************************** LN0210
     C********   *LOCK**** IN   LDA************************************** LN0210
     C******************** MOVEL'MAARCHL1'DBFILE************************* LN0210
     C******************** MOVELECARID****DBKEY************************** LN0210
     C******************** Z-ADD9******** DBASE************* DBERR 009 ** LN0210
     C******************** EXSR DBERR********************  ************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********   PREQKY****READEMAARCPL2**************** 88************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
      **********************Access report suffixes for this report, not mqLN0210
      ******************************************************************* LN0210
     C******************** MOVEA*BLANK****SFX**************************** LN0210
     C******************** Z-ADD1******** X****   10********************* LN0210
      ******************************************************************* LN0210
     C********   MIDQ****  IFEQ 'N'************************************** LN0210
     C********   RNAM****  SETLLFCRSFXL1********************************* LN0210
     C********   RNAM****  READEFCRSFXL1**************** 81************** LN0210
      ******************************************************************* LN0210
      **********************IF no records found************************** LN0210
      ******************************************************************* LN0210
     C********   *IN81**** IFEQ '1'************************************** LN0210
     C********   *LOCK**** IN   LDA************************************** LN0210
     C******************** MOVEL'FCRSFXL1'DBFILE************************* LN0210
     C******************** MOVELRNAM****  DBKEY************************** LN0210
     C******************** Z-ADD4******** DBASE************* DBERR 004 ** LN0210
     C******************** EXSR DBERR********************  ************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
      ************************** Set print suffix to blank if midas/q**** LN0210
      ******************************************************************* LN0210
     C********   MIDQ****  IFEQ 'Y'************************************** LN0210
     C******************** MOVE 'NA'****  SFX,1************************** LN0210
     C******************** Z-ADD2******** X****************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********   *IN81**** DOWEQ'0'************************************** LN0210
      ******************************************************************* LN0210
     C********   DYRSFX****IFNE 'A'************************************** LN0210
     C******************** MOVE DYRSFX****SFX,X************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** ADD  1******** X****************************** LN0210
     C********   RNAM****  READEFCRSFXL1**************** 81************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
      **********************Access Archive Id's for the required medium   LN0210
      ******************************************************************* LN0210
     C********   SARMF**** IFEQ 'Y'************************************** LN0210
     C********   SAROD**** ANDEQ'N'************************************** LN0210
     C******************** MOVE 'M'****   KMEDM************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********   SAROD**** IFEQ 'Y'************************************** LN0210
     C********   SARMF**** ANDEQ'N'************************************** LN0210
     C******************** MOVE 'O'****   KMEDM************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********   SAROD**** IFEQ 'Y'************************************** LN0210
     C********   SARMF**** ANDEQ'Y'************************************** LN0210
     C******************** MOVE *BLANK****KMEDM************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********   KMEDM**** SETLLMAARCHL2********************************* LN0210
     C******************** READ MAARCHL2**************** 82************** LN0210
      ******************************************************************* LN0210
      ******************   Send error message if no Archive Id's availableLN0210
      ******************************************************************* LN0210
     C********   *IN82**** IFEQ '1'************************************** LN0210
     C********   *IN82**** OREQ '0'************************************** LN0210
     C********   KMEDM**** ANDNEEAMEDM*********************************** LN0210
     C********   KMEDM**** ANDNE*BLANK*********************************** LN0210
     C******************** SETON******************** 70****************** LN0210
     C******************** CALL 'FCC0240'******************************** LN0210
     C******************** PARM 'RCF0010' MSGID   7********************** LN0210
      ******************************************************************* LN0210
     C********   SARMF**** IFEQ 'Y'************************************** LN0210
     C******************** SETON******************** 33****************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********   SAROD**** IFEQ 'Y'************************************** LN0210
     C******************** SETON******************** 34****************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** GOTO ENDAS************************************ LN0210
      ******************************************************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** Z-ADD1******** Y****   10********************* LN0210
      ******************************************************************* LN0210
     C******************** MOVEARNAM****  XNM**************************** LN0210
     C******************** Z-ADD1******** Z****   20********************* LN0210
     C********   ' '****   LOKUPXNM,Z********************88************** LN0210
      ******************************************************************* LN0210
      **********************DOWHILE Records exist on Report Suffixes***** LN0210
      **********************for this report not equal to 'A'/'AU'******** LN0210
      **********************AND F3 is not taken************************** LN0210
      **********************AND F12 is not taken************************* LN0210
      ******************************************************************* LN0210
     C********   Y******** DOWLTX**************************************** LN0210
      ******************************************************************* LN0210
     C******************** MOVE PDSC****  SDESC************************** LN0210
      ******************************************************************* LN0210
     C********   *IN01**** IFEQ '1'************************************** LN0210
     C******************** Z-ADD0******** RRN**************************** LN0210
     C******************** SETON******************** 22****************** LN0210
     C******************** SETOF******************** 21****************** LN0210
     C******************** WRITEFC0215C0********************************* LN0210
     C******************** SETOF******************** 22****************** LN0210
     C******************** END******************************************* LN0210
     C******************** SETON******************** 01****************** LN0210
      ******************************************************************* LN0210
      **********************DOWHILE Archive Id's exist for the media***** LN0210
      ************************** Write Subfile Record******************** LN0210
      ************************** Read Archive Id's for the media********* LN0210
      **********************ENDDO**************************************** LN0210
      ******************************************************************* LN0210
     C********   *IN82**** DOWEQ'0'************************************** LN0210
     C********   KMEDM**** ANDEQ*BLANK*********************************** LN0210
     C********   *IN82**** OREQ '0'************************************** LN0210
     C********   KMEDM**** ANDEQEAMEDM*********************************** LN0210
      ******************************************************************* LN0210
     C********   ACTN****  IFEQ 'A'************************************** LN0210
     C********   SARMF**** ANDEQ'Y'************************************** LN0210
     C********   D5ARMF****ANDEQ'Y'************************************** LN0210
     C********   ACTN****  OREQ 'A'************************************** LN0210
     C********   SAROD**** ANDEQ'Y'************************************** LN0210
     C********   D5AROD****ANDEQ'Y'************************************** LN0210
     C********   ARCPKY****KLIST***************************************** LN0210
     C******************** KFLD********   D9RNAM************************* LN0210
     C******************** KFLD********   D9PSQN************************* LN0210
     C******************** KFLD********   SUFFIX************************* LN0210
     C******************** MOVE 'N'****   SEXST************************** LN0210
      ******************************************************************* LN0210
     C********   ARCDKY****CHAINMAARCDL2************ 89****************** LN0210
     C********   *IN89**** IFEQ '0'************************************** LN0210
     C******************** MOVE '1'****   SSEL*************************** LN0210
     C******************** MOVE 'Y'****   SEXST************************** LN0210
     C******************** SETON******************** 20****************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** ADD  1******** RRN**************************** LN0210
     C******************** MOVE EAARID****SARID************************** LN0210
     C********   EAMEDM****IFEQ 'O'************************************** LN0210
     C******************** MOVE 'Optical' SMFOD************************** LN0210
     C******************** ELSE****************************************** LN0210
     C******************** MOVE 'Fiche  ' SMFOD************************** LN0210
     C******************** END******************************************* LN0210
     C******************** MOVE EAADSC****SADSC************************** LN0210
     C******************** WRITEFC0215S0********************************* LN0210
     C******************** SETOF******************** 20****************** LN0210
     C******************** READ MAARCHL2**************** 82************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********   SFX,Y**** IFEQ 'NA'************************************* LN0210
     C******************** MOVEAXNM****   PGMSFX************************* LN0210
     C******************** MOVE *BLANK****SUFFIX 10********************** LN0210
     C******************** ELSE****************************************** LN0210
     C******************** MOVEASFX,Y**** XNM,Z************************** LN0210
     C******************** MOVE SFX,Y**** SUFFIX************************* LN0210
     C******************** MOVEAXNM****   PGMSFX************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** SETON******************** 2123**************** LN0210
      ******************************************************************* LN0210
     C******************** WRITEFC0215F1********************************* LN0210
     C******************** WRITEFC0215F2********************************* LN0210
     C******************** WRITEFC0215C1********************************* LN0210
     C******************** EXFMTFC0215C0********************************* LN0210
      ******************************************************************* LN0210
     C********   ACTN****  IFNE 'E'************************************** LN0210
     C******************** EXSR ARCHV************************************ LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
      **********  IF Command key 12 has been taken*********************** LN0210
      **************   Issue ROLLBACK************************************ LN0210
      **************   Return to main screen***************************** LN0210
      ******************************************************************* LN0210
     C********   *IN12**** IFEQ '1'************************************** LN0210
     C********   *IN03**** OREQ '1'************************************** LN0210
     C******************** SETON******************** 70****************** LN0210
     C******************** ROLBK***************************************** LN0210
     C******************** Z-ADDX******** Y****************************** LN0210
     C******************** ELSE****************************************** LN0210
      ******************************************************************* LN0210
     C******************** ADD  1******** Y****************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********   ENDAS**** ENDSR***************************************** LN0210
     C******************************************************************* LN0210
      /EJECT
     C********************************************************************
     C*
     C*  S/R ARCHV - TO VALIDATE CHANGED SUBFILE RECORDS FOR PRINT SUFFIX
     C*  CALLED FROM ARCHS
     C*
     C********************************************************************
     C     ARCHV         BEGSR
      *
      **               Set on SFLNXTCHG
      *
     C******************** SETON                     20                   LN0210
     C                   SETON                                        202171                   LN021
     C                   SETOFF                                       72                       LN021
     C                   WRITE     FC0215F1                                                    LN021
     C                   WRITE     FC0215F2                                                    LN021
     C                   WRITE     FC0215C1                                                    LN021
     C                   EXFMT     FC0215C0                                                    LN021
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
     C                   READC     FC0215S0                               83
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
     C                   SETON                                        713520
     C                   CALL      'FCC0240'
     C***********          PARM 'RCF0012' MSGID   7                       LN1186
     C                   PARM      'RCF1012'     MSGID                                         LN118
     C                   UPDATE    FC0215S0
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
     C                   UPDATE    FC0215S0                                                    LN021
     C                   END                                                                   LN021
      *                                                                   LN0210
      **     If record changed to have selection blanked out, and no      LN0210
      **     archive record previously existed, set of SFLNXTCHG          LN0210
      *                                                                   LN0210
     C     SSEL          IFEQ      *BLANK                                                      LN021
     C     SEXST         ANDNE     'Y'                                                         LN021
     C                   SETOFF                                       3520                     LN021
     C                   UPDATE    FC0215S0                                                    LN021
     C                   END                                                                   LN021
      ******************************************************************* LN0210
     C********   SSEL****  IFEQ *BLANK*********************************** LN0210
     C********   SEXST**** ANDEQ'Y'************************************** LN0210
     C******************** SETON******************** 20****************** LN0210
     C******************** SETOF******************** 35****************** LN0210
     C******************** UPDATFC0215S0********************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C********   SSEL****  IFEQ *BLANK*********************************** LN0210
     C********   SEXST**** ANDNE'Y'************************************** LN0210
     C******************** SETOF******************** 3520**************** LN0210
     C******************** UPDATFC0215S0********************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
      *                                                                   LN0210
      **  If any entry has been made on the screen, do not send warning   LN0210
      **  message                                                         LN0210
      *                                                                   LN0210
     C     SSEL          IFNE      *BLANK
     C                   MOVE      'Y'           SELCT             1
     C                   SETOFF                                       72
     C                   END
      *
     C                   READC     FC0215S0                               83
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
      ******************************************************************* LN0210
      **************   DOWHILE changed records*************************** LN0210
      **********************Write Archive Contents*********************** LN0210
      **********************Daily Record********************************* LN0210
      **********************Read changed records************************* LN0210
      ******************************************************************* LN0210
     C********   *IN71**** IFEQ '0'************************************** LN0210
      ******************************************************************* LN0210
     C******************** SETON******************** 75****************** LN0210
     C******************** Z-ADD1******** RRN**** 50********************* LN0210
     C******************** READCFC0215S0**************** 83************** LN0210
      ******************************************************************* LN0210
     C********   *IN83**** DOWEQ'0'************************************** LN0210
      ******************************************************************* LN0210
     C********   SSEL****  IFEQ '1'************************************** LN0210
     C********   SEXST**** ANDEQ'N'************************************** LN0210
     C******************** MOVE SARID**** ECARID************************* LN0210
     C******************** MOVE RNAM****  ECRNAM************************* LN0210
     C******************** MOVE PSQN****  ECPSQN************************* LN0210
     C******************** MOVE SUFFIX****ECRSFX************************* LN0210
     C******************** WRITEMAARCPD0********************************* LN0210
      ******************************************************************* LN0210
     C********   WURQSQ****IFNE *BLANK*********************************** LN0210
     C******************** MOVE SARID**** EBARID************************* LN0210
     C******************** MOVE RNAM****  EBRNAM************************* LN0210
     C******************** MOVE WURQSQ****EBRQSQ************************* LN0210
     C******************** MOVE SUFFIX****EBRSFX************************* LN0210
     C******************** WRITEMAARCDD0********************************* LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** ELSE****************************************** LN0210
     C******************** MOVE SARID**** EAARID************************* LN0210
     C********   ARCPKY****CHAINMAARCPL2************ 89****************** LN0210
     C**N89****************DELET@ARCPAP********************************** LN0210
     C********   ARCDKY****CHAINMAARCDL2************ 78****************** LN0210
     C**N78****************DELET@ARCDAO********************************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** READCFC0215S0**************** 83************** LN0210
     C******************** END******************************************* LN0210
      ******************************************************************* LN0210
     C******************** ELSE****************************************** LN0210
      *                                                                   LN0210
      ** If screen is not valid, redisplay                                LN0210
      *                                                                   LN0210
     C     *IN71         IFEQ      '1'                                                         LN021
     C                   MOVE      'N'           SELCT
     C                   WRITE     FC0215F1
     C                   WRITE     FC0215F2
     C                   WRITE     FC0215C1
     C                   EXFMT     FC0215C0
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
     C                   MOVE      'E'           CODE                                          LN021
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
     C                   PARM      '*FIRST'      P@APOP                           B:Return code
     C     P@RCF         PARM      P@RCF         DSFDY                            O:Rec format
      *
      **          IF no record is found
      **               Database error
      **          ENDIF
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
      **          ENDIF
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
      **               Do not display Distribution list fields, or
      **               Midas User field if Distribution is required
      *
     C     DRQD          IFEQ      'Y'
     C                   SETON                                        5051
     C                   END
      *
     C                   MOVE      RUNA          SRUNA
     C                   MOVE      JBNM          SWSID
     C                   MOVE      PDSC          SPDSC
     C                   MOVE      RNAM          SRNAM
      *
      **               Do not Display Distribution list fields if
      **               Office is not present
      *
     C     D0OFPR        COMP      'Y'                                    50
      *
      **               Write screen
      *
     C******************** WRITEFC0215C1                                  LN0210
     C******************** EXFMTFC0215F0                                  LN0210
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
     C     *LIKE         DEFINE    D9PDSC        PDSC
     C     *LIKE         DEFINE    D9USRR        USRR
     C     *LIKE         DEFINE    D9FREQ        FREQ
     C     *LIKE         DEFINE    D9PFDT        PFDT
     C     *LIKE         DEFINE    D9PSQN        PSQN
     C     *LIKE         DEFINE    D9TNLU        PTNLU
     C     *LIKE         DEFINE    D9SOID        PDFTO
     C     *LIKE         DEFINE    D9RNAM        RNAM
     C     *LIKE         DEFINE    D9COTT        COTT
     C     *LIKE         DEFINE    D9CSEQ        CSEQ
     C     *LIKE         DEFINE    D9LVL         LVL
     C     *LIKE         DEFINE    D9ETTY        ETTY
     C     *LIKE         DEFINE    D9LVL         KLVL
     C     *LIKE         DEFINE    D9ETTY        KETTY
     C     *LIKE         DEFINE    D9DRQD        DRQD
     C     *LIKE         DEFINE    D9PNDT        PNDT
     C     *LIKE         DEFINE    D9PNDT        PNDTOR                                        E2662
     C/COPY WNCPYSRC,FC0215C011
     C     *LIKE         DEFINE    D8PARM        PARM
     C/COPY WNCPYSRC,FC0215C012
     C     *LIKE         DEFINE    SSOID         KSOID
     C     *LIKE         DEFINE    EAARID        KARID
     C                   MOVE      FDAY          D9FDAY                                        BHF54
      *
     C     PREQKY        KLIST
     C                   KFLD                    KRNAM
     C                   KFLD                    KPSQN
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
     C                   KFLD                    WURQSQ                                        LN021
      *                                                                   LN0210
      ** ARCHIVING FILE: KEY FOR CHAINING                                 LN0210
      *                                                                   LN0210
     C     ARCDK         KLIST                                                                 LN021
     C                   KFLD                    KRNAM                                         LN021
     C                   KFLD                    WURQSQ                                        LN021
     C                   KFLD                    SRSFX                                         LN021
      *                                                                   LN0210
      ** ARCHIVING FILE: KEY FOR CHAINING                                 LN0210
      *                                                                   LN0210
     C     ARCDKY        KLIST                                                                 LN021
     C                   KFLD                    SARID                                         LN021
     C                   KFLD                    WURQSQ                                        LN021
     C                   KFLD                    KRNAM                                         LN021
     C                   KFLD                    SRSFX                                         LN021
      *                                                                   LN0210
      ** ARCHIVING FILE: PARTIAL KEY                                      LN0210
      *                                                                   LN0210
     C     ARCPKP        KLIST                                                                 LN021
     C                   KFLD                    KRNAM                                         LN021
     C                   KFLD                    KPSQN                                         LN021
      *                                                                   LN0210
      ** ARCHIVING FILE: KEY FOR CHAINING                                 LN0210
      *                                                                   LN0210
     C     ARCPK         KLIST                                                                 LN021
     C                   KFLD                    KRNAM                                         LN021
     C                   KFLD                    KPSQN                                         LN021
     C                   KFLD                    SRSFX                                         LN021
      *                                                                   LN0210
      ** ARCHIVING FILE: KEY FOR CHAINING                                 LN0210
      *                                                                   LN0210
     C     ARCPKY        KLIST                                                                 LN021
     C                   KFLD                    SARID                                         LN021
     C                   KFLD                    KRNAM                                         LN021
     C                   KFLD                    KPSQN                                         LN021
     C                   KFLD                    SRSFX                                         LN021
      *
      **          Access Dataarea RUNDAT
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'FC0215'      DBPGM
     C                   OUT       LDA
     C                   MOVEL     'FC0215'      PGMN
     C                   MOVEL     'FC'          MDID
     C                   MOVEL     JBNM          WSIDX
     C                   MOVE      ACTN          ACTCDX
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C     DATF          COMP      'M'                                    98
     C*                                                                   LN0503
      *          Access Sdbankdp for Next Working Date.                   LN0503
      *                                                                   LN0503
     C                   CALL      'AOBANKR0'                                                  LN050
     C                   PARM      *BLANK        P@APRC            7                           LN050
     C                   PARM      '*FIRST'      P@APOP            7                           LN050
     C     D@BANK        PARM      D@BANK        DSFDY                                         LN050
      *                                                                   LN0503
     C                   MOVE      BJDNWD        DNWD              5 0                         LN050
      *                                                                   LN0503
      **  CONVERT RUN DATE TO CONSTITUENT PARTS
     C*
     C                   MOVEL     RUNA          DAYNO
     C                   MOVE      RUNA          YRNO
     C                   MOVE      RUNA          MY                5
     C                   MOVEL     MY            M                 3
     C                   Z-ADD     1             MTHNO
     C     M             LOOKUP    ZMNM(MTHNO)                            99
      *
     C                   MOVEL     '*'           SPGMQ
     C                   CALL      'ZA0250'
     C                   SETON                                        6055
     C*
     C     ACTN          IFEQ      'E'
     C     ACTN          OREQ      'D'
     C                   SETON                                        54
     C                   END
     C*
     C     ACTN          IFEQ      'D'
     C                   SETON                                        56
     C                   END
      *
      **     If action code is insert, set screen defaults
      *
     C     ACTN          IFEQ      'I'
     C                   Z-ADD     PFDT          PNDT
     C                   MOVE      'N'           SAROD
     C                   MOVE      'N'           SARMF
     C                   MOVE      PDFTO         SSOID
     C                   ELSE
      *
      **     If action is amend, access current details from
      **      report requests file
     C*
     C                   MOVE      RNAM          KRNAM
     C                   MOVE      PSQN          KPSQN
     C     PREQKY        CHAIN     FCPREQL1                           86
     C*
     C     *IN86         IFEQ      '1'
     C***********          MOVE 'RCF0023' MSGID                           LN1186
     C                   MOVE      'RCF1023'     MSGID                                         LN118
     C                   EXSR      UPDOWS
     C                   ELSE
     C*
     C**  Alert user if record has changed since request
     C*
     C     D9TNLU        IFNE      PTNLU
     C***********          MOVE 'RCF0060' MSGID                           LN1186
     C                   MOVE      'RCF1060'     MSGID                                         LN118
     C                   EXSR      UPDOWS
     C                   END
     C*
      **     Set up screen fields from report request record
     C*
     C                   MOVE      D9AROD        SAROD
     C                   MOVE      D9ARMF        SARMF
     C                   MOVE      D9SOID        SSOID
     C******************** Z-ADDD9PFDT    PFDT                            L
     C*                                                                   E26621
      **     Set up work fields from report request record                E26621
     C*                                                                   E26621
     C                   MOVE      D9PNDT        PNDT                                          E2662
     C                   MOVE      D9PNDT        PNDTOR                                        E2662
     C*
      **         Only move distribution list and user Id fields
      **          to screen if distribution to co/br is not required
     C*
     C     DRQD          IFEQ      'N'
     C                   MOVE      D9DLS1        SDST1
     C                   MOVE      D9DLS2        SDST2
     C                   MOVE      D9USRO        SUSRO
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
      ** FIND SEQUENCE NUMBER OF REPORT REQUEST ASSOCIATED WITH RECORD
     C*
     C******************** MOVE *BLANK    WURQSQ  5                       LN0210
     C                   MOVE      *BLANK        WURQSQ                                        LN021
     C*
     C     ACTN          IFEQ      'A'
      *
      ***Calculate*next*date.*If first date > run date, next date = first 127043
      *
     C***********PFDT      IFGE RUND                                      127043
     C***********          Z-ADDPFDT      PNDT                            127043
     C***********          END                                            127043
      *
      **  If frequency, or frequency day has changed, next date will have
      **  changed also, and must be re-calculated from last date
      *
     C                   MOVE      D9FDAY        AFDAY             2
      *
      * Force recalculation of PNDT (because next activity date is in the 088540
      * future in file FCPREQPD)                                          088540
     C***********AFDAY     IFNE FDAY                                      088540
     C***********D9LPDT    ANDNE0                                         088540
     C***********D9FREQ    ORNE FREQ                                      088540
     C***********D9LPDT    ANDNE0                                         088540
      *
      **  Access SDBANKPD for the local currency - required for holiday
      **  calculations in ZFREQB.
      *
      * THE CALL TO AOBANKR0 MOVED TO FIRST CYCLE                         LN0503
     C************         CALL 'AOBANKR0'                                LN0503
     C************         PARM *BLANK    P@APRC  7                       LN0503
     C************         PARM '*FIRST'  P@APOP  7                       LN0503
     C***********D@BANK    PARM D@BANK    DSFDY                           LN0503
      ************                                                        LN0503
     C                   MOVE      BJCYCD        ZCCY
     C                   MOVE      *BLANK        ZLOC
      *
      **  If frequency is day-of-week, next date can be calculated from
      **  run date
      *
     C     FREQ          IFGE      '1'
     C     FREQ          ANDLE     '7'
      *
      **  Determine day-of-week of current date
      *
     C     RUND          DIV       7             WORK5N            5 0
     C                   MVR                     WORK1N            1 0
      *
      **  1/1/72 was a Saturday, therefore zero remainder equates to
      **  today being a Friday. Monday is therefore 3, whereas the
      **  frequency code dictates that Monday is 1. To reset to frequency
      **  days, subtract two from real-day and add seven should the result
      **  be negative.
      *
     C     WORK1N        SUB       2             WORK1N                 60
     C   60              ADD       7             WORK1N
      *
      **  To set the next date to the correct day of the week, calculate
      **  how many days there are between the real-day and the next freq-
      **  day. Subtract the real-day from the frequency-day and add seven
      **  if the result is negative.
      *
     C                   MOVE      FREQ          WRK1N             1 0
     C     WRK1N         SUB       WORK1N        WORK1N                 60
     C   60              ADD       7             WORK1N
      *
      **  Add the adjustment calculated to the run date to give actual
      **  next date
      *
     C     RUND          ADD       WORK1N        ZDAYNO
     C                   Z-ADD     0             ZNRDYS
      *
      **  Send result to ZBKDT to work out previous working day if required
      *
     C                   EXSR      ZBKDT
     C                   Z-ADD     ZDAYNO        PNDT
      *
     C                   END
      *
      **  If frequency is daily, set next date to run date
      *
     C     FREQ          IFEQ      'D'
     C                   Z-ADD     RUND          PNDT
     C                   END
      *
      **  For other frequency codes, PFREQB must be called recursively
      **  starting at last date in order to calculate next date.
      *
     C     FREQ          IFEQ      'M'
     C     FREQ          OREQ      'Y'
     C     FREQ          OREQ      'A'
     C     FREQ          OREQ      'Q'
     C     FREQ          OREQ      'B'
      *                                                                   112359
     C     D9LPDT        IFEQ      *ZEROS                                                      11235
     C                   Z-ADD     PFDT          PNDT                                          11235
     C                   ELSE                                                                  11235
      *                                                                   112359
     C                   Z-ADD     D9LPDT        ZDAYNO
     C                   MOVE      FREQ          ZFREQ
     C                   MOVE      FDAY          ZMDAY
      *
     C     ZDAYNO        DOWLT     RUND
     C                   EXSR      PFREQB
     C                   END
      *
     C***********          Z-ADDZDAYNO    PNDT                            048716
     C                   Z-ADD     ZDYNBR        PNDT                                          04871
      *                                                                   112359
     C                   END                                                                   11235
     C*                                                                   127043
     C** Calculate next date. If first date > rundate, then               127043
     C** Next Date = First Date.                                          127043
     C*                                                                   127043
     C     PFDT          IFGE      RUND                                                        12704
     C                   Z-ADD     PFDT          PNDT                                          12704
     C                   END                                                                   12704
      *
     C                   END
      *
     C***********          END                                            088540
      *
     C                   END
      *
      **  If next date is run date, a record should exist on/be written to
      **  Daily report requests file
      **  If Periodic has a Next Working Day Less Than That On SDBANKPD   LN0503
      **  then a Record should also be Written to FCRREQPD.               LN0503
      *
     C                   SETON                                        05
     C     PNDT          IFEQ      RUND
     C     PNDT          ORLT      DNWD                                                        LN050
      *
      **  Access Report Requests file for report sequence number
      *
     C     PREQKY        CHAIN     FCRREQL9                           76
      *
      **  Release record
      *
     C  N76              EXCEPT    RELRRQ
      *
     C     *IN76         IFEQ      '1'
     C*
      **  If no record is found, reserve next sequence number from REQSEQ
      **  Dataarea, and update
     C*
     C     *DTAARA       DEFINE                  REPSEQ
     C     *LOCK         IN        REPSEQ
     C                   MOVE      UUSEQ         WURQSQ            5
     C                   ADD       1             UUSEQ
     C                   OUT       REPSEQ
     C                   ELSE
      *
      **  Store report request sequence number if a record was found
      *
     C                   MOVE      D5RQSQ        WURQSQ
     C                   END
     C*
     C                   END
      *                                                                           MD031966
     C     SEQNO         IFNE      *BLANKS
     C     SEQNO         CHAIN     GL0781E1                           99
     C     *IN99         IFEQ      *OFF
     C     PNDT          IFEQ      RUND
     C     PNDT          ORLT      DNWD
     C                   MOVE      WURQSQ        SEQNO
     C                   ELSE
     C                   MOVE(P)   PSQN          SEQNO
     C                   END
     C                   UPDATE    GL0781E1
     C                   MOVE      *BLANKS       SEQNO
     C                   END
     C                   END
      *                                                                           MD031966
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
     C                   WRITE     FC0215C1
     C                   SETON                                        5455
     C*
      **      Alert the user
      **        and allow them to exit/return
     C*
     C     *IN03         DOWEQ     '0'
     C     *IN12         ANDEQ     '0'
     C                   EXFMT     FC0215F0
     C                   END
     C*
     C     *IN03         IFEQ      '1'
     C                   MOVE      'E'           CODE
     C                   MOVE      'T'           ACTN
     C                   EXSR      END
     C                   END
     C*
     C     *IN12         IFEQ      '1'
     C                   MOVE      'F'           CODE
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
     C                   MOVE      'E'           CODE
     C                   MOVE      'T'           ACTN
     C                   DUMP
     C                   END
     C                   ENDSR
     C********************************************************************
      /EJECT
      *COPY*ZSRSRC,ZTNLU1Z2                                                                 MD055265
      /COPY ZSRSRC,ZTNLU1Z4                                                                 MD055265
      /EJECT
     C********************************************************************
     C**
     C**   PFREQB-SR. TO INCREMENT A DAY NUMBER DATE BY A
     C**             PERIOD VALUE DETERMINED BY A CODE.
     C**             AND FIND PREVIOUS WORKING DAY IF A HOLIDAY
     C**
     C     PFREQB        BEGSR                                                  *** PFREQB ***
     C**
     C**   CALCULATIONS TO DEFINE/CLEAR FIELDS.
     C**
     C                   MOVE      ZFREQ         ZFREQ             1
     C                   Z-ADD     ZDAYNO        ZDAYNO            5 0
     C                   Z-ADD     ZMDAY         ZMDAY             2 0
     C                   MOVE      ZCCY          ZCCY              3
     C                   MOVE      ZLOC          ZLOC              3
     C**
     C**   CONVERT DAY NUMBER TO DATE.
     C**
     C                   EXSR      ZDATE2
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE M-MONTHLY.
     C     ZFREQ         IFEQ      'M'
     C                   Z-ADD     ZMDAY         ZDAY
     C**
     C**   INCREMENT MONTH UNLESS CURRENT WITH RUN DATE AND FREQUENCY DAY
     C**   AFTER TODAY
     C     ZFREQ         IFNE      'B'                                                         12704
     C***********ZMDAY     IFLT DAYNO                                     096823
     C***********ZMTH      ORNE MTHNO                                     096823
     C********** ZMTH      IFNE MTHNO                              096823 219969
     C     ZMDAY         IFLT      DAYNO                                                       21996
     C     ZMTH          ORNE      MTHNO                                                       21996
     C     ZYEAR         ORNE      YRNO
     C     ZMTH          ADD       1             ZMTH
     C                   END
     C                   END                                                                   12704
     C     ZFREQ         IFEQ      'B'                                                         12704
     C     ZMTH          IFNE      MTHNO                                                       12704
     C     ZYEAR         ORNE      YRNO                                                        12704
     C     ZMTH          ADD       1             ZMTH                                          12704
     C                   END                                                                   12704
     C*                                                                   127043
     C                   END                                                                   12704
     C**
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE Q-QUARTERLY.
     C     ZFREQ         IFEQ      'Q'
     C                   Z-ADD     ZMDAY         ZDAY
     C**
     C**   INCREMENT MONTH UNLESS CURRENT WITH RUN DATE AND FREQUENCY DAY
     C**   AFTER TODAY
     C     ZMDAY         IFLT      DAYNO
     C     ZMTH          ORNE      MTHNO
     C     ZYEAR         ORNE      YRNO
     C     ZMTH          ADD       3             ZMTH
     C                   END
     C**
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE Y-YEARLY.
     C     ZFREQ         IFEQ      'Y'
     C                   Z-ADD     ZMDAY         ZDAY
     C**
     C**   INCREMENT YEAR UNLESS CURRENT WITH RUN DATE AND FREQUENCY DAY
     C**   AFTER TODAY
     C***********ZMDAY     IFLT DAYNO                                     048716
     C***********ZMTH      ORNE MTHNO                                     048716
     C     ZMTH          IFNE      MTHNO                                                       04871
     C     ZYEAR         ORNE      YRNO
     C     ZYEAR         ADD       1             ZYEAR
     C                   END
     C**
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE B-LAST WORKING DAY OF MONTH.
     C     ZFREQ         IFEQ      'B'
     C                   Z-ADD     31            ZDAY
     C**
     C**   INCREMENT MONTH UNLESS CURRENT WITH RUN DATE AND FREQUENCY DAY
     C**   AFTER TODAY
     C***********ZMDAY     IFLT DAYNO                                     127043
     C***********ZMTH      ORNE MTHNO                                     127043
     C     ZMTH          IFNE      MTHNO                                                       12704
     C     ZYEAR         ORNE      YRNO
     C     ZMTH          ADD       1             ZMTH
     C                   END
     C**
     C                   END
     C**
     C**   CHECK FOR AND INCREMENT FOR CODE A-MONTHLY ACCRUAL/PROFIT DATE.
     C     ZFREQ         IFEQ      'A'
     C**********           CALL 'AOGELRR0'                   <G/LDG.ICD>                      CGL029
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANK        P@AORC            7              B:Return code
     C                   PARM      '*FIRST'      P@OPTN            7              I:Option
     C********** SDGELR    PARM SDGELR    DSFDY              O:Rec.format                     CGL029
     C     SDGELR        PARM      SDGELR        DSSDY
     C     P@AORC        IFEQ      *BLANK
     C                   Z-ADD     BKAPDT        ZDAYNO
     C                   Z-ADD     BKAPDT        ZDYNBR                                        17881
     C                   END
     C                   GOTO      ZFEND
     C                   END
     C**
     C**   REFORMAT DATE AND ENSURE VALID.
     C**
     C**   VALIDATE MONTH.
     C     ZMTH          IFGT      12
     C     ZMTH          SUB       12            ZMTH
     C     ZYEAR         ADD       1             ZYEAR
     C                   END
     C**
     C**   CHECK FOR LEAP YEAR.
     C     ZYEAR         DIV       4             ZLYR              2 0
     C                   MVR                     ZLY               1 0
     C**
     C**   VALIDATE DAY NUMBER.
     C                   MOVE      ZFMD(ZMTH)    ZWRK2             2 0
     C**
     C     ZMTH          IFEQ      2
     C     ZLY           ANDEQ     0
     C                   Z-ADD     29            ZWRK2
     C                   END
     C**
     C     ZDAY          IFGT      ZWRK2
     C                   Z-ADD     ZWRK2         ZDAY
     C                   END
     C**
     C**   REFORMAT DATE, DDMMYY OR MMDDYY, AND CONVERT TO DAY NUMBER.
     C                   MOVEL     ZDAY          ZWRK4             4 0
     C                   MOVE      ZMTH          ZWRK4
     C   98              MOVEL     ZMTH          ZWRK4
     C   98              MOVE      ZDAY          ZWRK4
     C                   MOVEL     ZWRK4         ZDATE
     C                   MOVE      ZYEAR         ZDATE
     C                   EXSR      ZDATE1
     C**
     C**   RESET TO PREVIOUS WORKING DAY IF HOLIDAY
     C**
     C                   Z-ADD     0             ZNRDYS
     C**
     C                   EXSR      ZBKDT
     C                   Z-ADD     ZDYNBR        ZDAYNO                                        09682
     C**
     C     ZFEND         ENDSR                                                  * ZFEND ENDSR *
     C**
     C********************************************************************
      /EJECT
      *COPY*ZSRSRC,ZDATE1Z2                                                                 MD055265
      /COPY ZSRSRC,ZDATE1Z2LE                                                               MD055265
      /EJECT
      *COPY*ZSRSRC,ZDATE2Z2                                                                 MD055265
      /COPY ZSRSRC,ZDATE2Z2LE                                                               MD055265
      /EJECT
      *COPY*ZSRSRC,ZACCH                                                                    MD055265
      /COPY ZSRSRC,ZACCHLE                                                                  MD055265
      /EJECT
      *COPY*ZSRSRC,ZBKDT                                                                    MD055265
      /COPY ZSRSRC,ZBKDT_ILE                                                                MD055265
      /EJECT
      ********************************************************************
     O@RREQA8   E            RELRRQ
     O@ECREJU   E            RELACP                                             LN0210
** CPY@
(c) Finastra International Limited 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
